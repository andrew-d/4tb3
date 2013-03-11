#!/usr/bin/env python
from __future__ import print_function

import os
import sys
import glob
import subprocess


TEST_DIR = os.path.abspath(os.path.join('.', 'tests'))


def run_test(input_file):
    _, fname = os.path.split(input_file)
    name, ext = os.path.splitext(fname)
    expected_file = os.path.join(TEST_DIR, name + '.out')

    # Read the expected file.
    with open(expected_file, 'r') as f:
        expected = f.read()

    # Open input file.
    finput = open(input_file, 'r')

    # De-duplicate.
    try:
        out = subprocess.check_output(['perl', 'dup_remover.pl'], stdin=finput)
    finally:
        finput.close()

    if out != expected:
        print('[FAIL] %s' % (name,), file=sys.stderr)
    else:
        print('[PASS] %s' % (name,), file=sys.stderr)


def main():
    for fname in glob.glob(os.path.join(TEST_DIR, '*.html')):
        run_test(fname)


if __name__ == "__main__":
    main()
