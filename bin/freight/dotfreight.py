from .utils import *
from . import FREIGHT_LOCAL_FILE
import yaml

class FreightFile(object):
    def __init__(self):
        if isfile(FREIGHT_LOCAL_FILE):
            with open(FREIGHT_LOCAL_FILE) as fd:
                self.data = yaml.load(fd) or get_data_template()
        else:
            self.data = get_data_template()

    def get(self, filename, prop):
        if filename in self.data:
            if prop in self.data['files']:
                return self.data[filename][prop]
            else:
                raise KeyError('No such prop')
        else:
            raise NameError('Filename not present in cache')

    def put(self, filename, **kwargs):
        if filename not in self.data:
            self.data[filename] = get_file_template()

        for key, value in kwargs.items():
            self.data[filename][key] = value

    def close_data(self):
        from json import dumps
        with open(FREIGHT_LOCAL_FILE, 'w') as fd:
            fd.write(dumps(self.data))
            fd.truncate()
