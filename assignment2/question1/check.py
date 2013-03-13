#!/usr/bin/env python
from __future__ import print_function

import os
import sys
import glob
import tempfile
import subprocess


bin_path = os.path.abspath(os.path.join('.', 'prettyprint'))
comp_path = os.path.abspath(os.path.join('.', 'risccompiler'))


def try_compile(name, file):
    # Try compiling this file.  This uses a modified version of the RISC
    # compiler that will halt if the return code is non-zero.
    proc = subprocess.Popen([comp_path, file],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)

    stdout, stderr = proc.communicate()

    if proc.returncode != 0:
        print('[FAIL] %s' % (name,), file=sys.stderr)

        if len(stderr) > 0:
            for line in stderr.splitlines():
                print("       %s" % (line,))

            print("")

        for line in stdout.splitlines():
            print("       %s" % (line,))
    else:
        print('[PASS] %s' % (name,), file=sys.stderr)


def run_test(input_file):
    # Get output dir.
    _, name = os.path.split(input_file)
    new_file = tempfile.NamedTemporaryFile()

    ifile = open(input_file)

    # Prettyprint the file.
    try:
        subprocess.check_call([bin_path],
                              stdin=ifile,
                              stdout=new_file,
                              stderr=subprocess.PIPE)

        try_compile(name, new_file.name)
    finally:
        new_file.close()
        ifile.close()



def main():
    for fname in glob.glob(os.path.join('tests', '*.pas')):
        run_test(fname)


if __name__ == "__main__":
    main()
