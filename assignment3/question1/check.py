#!/usr/bin/env python
from __future__ import print_function

import os
import sys
import glob
import tempfile
import subprocess


comp_path = os.path.abspath(os.path.join('.', 'risccompiler_test'))
test_dir = os.path.abspath(os.path.join('.', 'tests'))


def run_test(input_file):
    _, fname = os.path.split(input_file)
    name, _ = os.path.splitext(fname)

    proc = subprocess.Popen([comp_path, input_file],
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



def main():
    for fname in glob.glob(os.path.join(test_dir, '*.pas')):
        run_test(fname)


if __name__ == "__main__":
    main()
