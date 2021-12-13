# Pull base image
FROM python:3.9 as build-system
# Set environment varibles
# If this is set to a non-empty string,
# Python won’t try to write .pyc files on the import of source modules.
# This is equivalent to specifying the -B option.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_NO_CACHE_DIR 0

# -- Install Pipenv:
RUN set -ex &&  pip3 install --no-cache-dir --upgrade pip pipenv && mkdir -p /app
# -- Adding Pipfiles
ONBUILD COPY Pipfile Pipfile
ONBUILD COPY Pipfile.lock Pipfile.lock
ONBUILD RUN set -ex && pipenv install --deploy --system
### create the runtime image ###
FROM build-system as runtime

# Copy the entrypoint that will generate Nginx additional configs
COPY  entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create a group and user to run our app

COPY ./src /app
WORKDIR /app
RUN chmod +x /app/control-agent.py

CMD ["/entrypoint.sh"]