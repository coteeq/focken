#!/usr/bin/env python
from os.path import isfile
import json
import time
import sys
from hashlib import md5
import pexpect
from os import stat

FRACM_LOCAL_FILE = '.fracmfile'

def time_for_file(filename):
    return stat(filename).st_mtime

def checksum_file(filename):
    hash = md5()
    with open(filename, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash.update(chunk)
    return hash.hexdigest()

def get_data_template():
    return {
        'std': 11,
        'cc': 'g++',
        'flags': [
            '-lstdc++',
            '-Wall',
            '-Wextra',
            '-Wshadow',
            '-pedantic'
        ],
        'files': {}
    }

def get_file_template():
    return \
    {
        'last_mod': 0.0, # epoch from time.time()
        'last_hash': '0' * 32, # md5 hexdigest
        'bin_dir': '~/.fracm/'
    }

class FracmFile(object):
    def __init__(self):
        if isfile(FRACM_LOCAL_FILE):
            with open(FRACM_LOCAL_FILE) as fd:
                self.data = json.load(fd) or get_data_template()
        else:
            self.data = get_data_template()

    def get_setting(self, setting):
        if setting not in self.data.keys():
            raise NameError('No such setting')
        return self.data[setting]

    def put_setting(self, setting, value):
        self.data[setting] = value

    def get(self, filename, prop):
        if filename in self.data['files'].keys():
            if prop in self.data['files'][filename]:
                return self.data['files'][filename][prop]
            else:
                raise KeyError('No such prop')
        else:
            self.data['files'][filename] = get_file_template()
            return self.get(filename, prop)

    def put(self, filename, **kwargs):
        if filename not in self.data.keys():
            self.data['files'][filename] = get_file_template()

        for key, value in kwargs.items():
            self.data['files'][filename][key] = value

    def write_data(self):
        with open(FRACM_LOCAL_FILE, 'w') as fd:
            fd.write(json.dumps(self.data))
            fd.truncate()

class Executor(object):
    def __init__(self, binary):
        self.binary = binary

    def run(self, echo=[]):
        '''
        I wanted to use pexpect for this, but it seems to have no support
        for segmentation faults, which is essential for competitive
        programming code, so I used bash instead
        '''
        from os import system
        cmd = f'echo {" ".join(echo)} | ./{self.binary}'
        if len(echo) < 1:
            cmd = f'./{self.binary}'
        real_cmd = f'sh -c "{cmd}"'
        system(real_cmd)

class Compiler(object):
    def __init__(self, cc):
        self.cc = cc

    def build(self, f_in, f_out, flags):
        if flags is None:
            flags = []

        flags += [f_in]
        flags += [f'-o{f_out}']
        child = pexpect.spawn(self.cc, flags)
        ret_text = child.read(-1)
        # ret_code = child.status
        if ret_text != b'' and ret_text is not None:
            return ret_text.decode('utf-8')

        return None


def main():
    if len(sys.argv) < 2:
        help_msg = '''help msg coming soon'''
        print(help_msg)
        sys.exit(-1)

    source = sys.argv[1]
    executable = source + '.run'

    ff = FracmFile()

    t = ff.get(source, 'last_mod')
    if t < time_for_file(source):
        ff.put(source, last_mod=time_for_file(source))
        ff.write_data()

        compiler = Compiler(ff.get_setting('cc'))
        errors = compiler.build(source, executable, ff.get_setting('flags'))

        if errors is not None:
            print(errors)
            sys.exit(-1)

    if isfile(executable):
        executor = Executor(executable)
        print('\x1b[32mREADY\x1b[0m')
        start_time = time.time()
        executor.run(echo=sys.argv[2:])
        print(f'                \x1b[35m{time.time() - start_time:.4}s')
    else:
        print('\x1b[31mNO EXECUTABLE\x1b[0m')

if __name__ == '__main__':
    from os import path
    print(path.abspath(__file__))
    try:
        main()
    except KeyboardInterrupt:
        pass # just exit

