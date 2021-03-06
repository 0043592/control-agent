# Pull base image
FROM python:3.10.4 AS build-system
# Set environment varibles
# If this is set to a non-empty string,
# Python won’t try to write .pyc files on the import of source modules.
# This is equivalent to specifying the -B option.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_NO_CACHE_DIR 0

# -- Install Pipenv:
RUN set -ex &&  pip3 install --no-cache-dir --upgrade pip pipenv certbot && mkdir -p /app
# -- Adding Pipfiles
ONBUILD COPY Pipfile Pipfile
ONBUILD COPY Pipfile.lock Pipfile.lock
ONBUILD RUN set -ex && pipenv install --deploy --system
### create the runtime image ###
FROM build-system AS runtime

COPY  entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./src /app
WORKDIR /app
RUN chmod +x /app/control-agent.py

CMD ["/entrypoint.sh"]