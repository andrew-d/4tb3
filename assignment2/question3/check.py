#!/usr/bin/env python
from __future__ import print_function

import os
import sys
import glob
import subprocess


TEST_DIR = os.path.abspath(os.path.join('.', 'tests'))
COMPILER = os.path.abspath(os.path.join('.', 'risccompiler'))


def run_test(test_file):
    _, fname = os.path.split(test_file)
    name, ext = os.path.splitext(fname)
    input_file    = os.path.join(TEST_DIR, name + '.in')
    expected_file = os.path.join(TEST_DIR, name + '.out')

    # Read the expected file.
    with open(expected_file, 'r') as f:
        expected = f.read().strip()

    # Open input file.
    finput = open(input_file, 'r')

    # De-duplicate.
    try:
        out = subprocess.check_output([COMPILER, test_file], stdin=finput)

        # Remove first 4 lines from output.
        out = ''.join(out.split('\n')[4:]).strip()
    except subprocess.CalledProcessError as e:
        out = "** error code %d **" % (e.returncode,)
    finally:
        finput.close()

    if out != expected:
        print('[FAIL] %s (%r != %r)' % (name, out, expected), file=sys.stderr)
    else:
        print('[PASS] %s' % (name,), file=sys.stderr)


def main():
    for fname in glob.glob(os.path.join(TEST_DIR, '*.pas')):
        run_test(fname)


if __name__ == "__main__":
    main()
