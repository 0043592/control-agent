MAJOR, MINOR, BUILD, PATCH = 1, 0, 0, 1
__version__ = f'{MAJOR}.{MINOR}.{BUILD}.{PATCH}'


def get_version_full():
    return __version__


def get_version_short():
    return f"{MAJOR}.{MINOR}"


def get_major_version():
    return MAJOR
