#!/usr/bin/env python
from __future__ import print_function

import os
import sys
import glob
import subprocess


TEST_DIR = os.path.abspath(os.path.join('.', 'tests'))
BIN = os.path.join('.', 'tablefmt')


def run_test(input_file):
    _, fname = os.path.split(input_file)
    name, ext = os.path.splitext(fname)
    expected_file = os.path.join(TEST_DIR, name + '.out')

    # Read the expected file.
    try:
        with open(expected_file, 'r') as f:
            expected = f.read()
    except IOError:
        print('[ERR!] expected file %s.out does not exist!' % (name,), file=sys.stderr)
        return

    # Open input file.
    finput = open(input_file, 'r')

    # De-duplicate.
    try:
        out = subprocess.check_output([BIN], stdin=finput)
    finally:
        finput.close()

    if out.strip('\r\n') != expected.strip('\r\n'):
        print('[FAIL] %s' % (name,), file=sys.stderr)

        print("   Got:", file=sys.stderr)
        for l in out.splitlines():
            print("     > " + l, file=sys.stderr)

        print("  Need:", file=sys.stderr)
        for l in expected.splitlines():
            print("     > " + l, file=sys.stderr)
    else:
        print('[PASS] %s' % (name,), file=sys.stderr)


def main():
    for fname in glob.glob(os.path.join(TEST_DIR, '*.test')):
        run_test(fname)


if __name__ == "__main__":
    main()
