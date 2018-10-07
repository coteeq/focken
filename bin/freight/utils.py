from os import stat

def time_for_file(filename):
    return stat(filename).st_mtime

_DATA_DEFAULT = {
            'files': [],
            'std': 14,
            'bin_path': '~/.binruncc/',
            'flags': [
                    '-lstdc++',
                    '-Wall',
                    '-Wextra'
                ],
            'colors': {
                    'time': 35
                }
        }


_FILE_DEFAULT = {
    'filename': '',
    'last_mod': 0,
    'hash': '0' * 32, # md5 hexdigest size
    'has_custom_bin_name': False,
    'has_custom_bin_path': False,
    'custom_bin_name': '',
    'custom_bin_path': ''
}

def get_data_template():
    return _DATA_DEFAULT

def get_file_template():
    return _FILE_DEFAULT;
