#!/usr/bin/env python

import os
import glob
import json
import subprocess


curr_dir = os.path.abspath(os.path.dirname(__file__))
prog = os.path.join(curr_dir, 'calculator')

class stats(object):
    pass

stats.tests = 0
stats.asserts = 0
stats.successes = 0
stats.failures = 0


def run_test(file_path):
    p = subprocess.Popen([prog, file_path],
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE
                         )

    (stdout, stderr) = p.communicate()
    return (p.returncode, stdout, stderr)


def assert_equal(one, two):
    if isinstance(one, unicode):
        one = one.encode('latin-1')
    if isinstance(two, unicode):
        two = two.encode('latin-1')

    print "  ASSERT: %r == %r" % (one, two)
    stats.asserts += 1

    if one == two:
        stats.successes += 1
    else:
        print "    FAIL"
        stats.failures += 1


def main():
    for test_file in glob.iglob(os.path.join(curr_dir, 'tests', '*.test')):
        stats.tests += 1

        base_path = os.path.splitext(test_file)[0]
        base_name = os.path.split(base_path)[1]
        data_file = base_path + '.output'
        print "-" * 50
        print "TEST: %s" % (base_name,)

        with open(data_file, 'rb') as f:
            output_data = json.load(f)

        # Run the program with the test file.
        code, stdout, stderr = run_test(test_file)

        # Ensure data matches.
        assert_equal(code, output_data['return_code'])
        assert_equal(stdout, output_data['stdout'])
        assert_equal(stderr, output_data['stderr'])

    print "-" * 50
    print "Tests     : %d" % (stats.tests,)
    print "Asserts   : %d" % (stats.asserts,)
    print "Successes : %d" % (stats.successes,)
    print "Failures  : %d" % (stats.failures,)
    print ""


if __name__ == "__main__":
    main()
