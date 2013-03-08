from __future__ import print_function

import os
import sys
import glob
import tempfile
import subprocess


bin_path = os.path.abspath(os.path.join('.', 'prettyprint'))
comp_path = os.path.abspath(os.path.join('.', 'risccompiler'))


def run_test(input_file):
    # Get output dir.
    _, name = os.path.split(input_file)
    new_file = tempfile.NamedTemporaryFile()

    # Prettyprint the file.
    try:
        subprocess.check_call([bin_path, input_file],
                              stdout=new_file,
                              stderr=subprocess.PIPE)
    finally:
        new_file.close()

    # Try compiling this file.  This uses a modified version of the RISC
    # compiler that will halt if the return code is non-zero.
    ret = subprocess.call([comp_path, new_file.name],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
    if ret != 0:
        print('[FAIL] %s' % (name,), file=sys.stderr)
    else:
        print('[PASS] %s' % (name,), file=sys.stderr)


def main():
    for fname in glob.glob(os.path.join('tests', '*.pas')):
        run_test(fname)


if __name__ == "__main__":
    main()
