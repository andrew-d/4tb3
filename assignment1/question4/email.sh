#!/bin/bash

# Email regex:
#   [A-Za-z+\._-]+                       - The initial bit
#   @                                   - @ symbol
#   ([A-Za-z0-9-]+\.)+                  - One or more subdomains, followed by a dot
#   [A-Za-z]{2,6}                       - The TLD
#
# The seperators that are valid are anything that doesn't exist in an email - i.e.:
#   [^A-Za-z0-9@+\._-]

cd tests && grep -orhE '([^A-Za-z0-9@+\._-]|^)[A-Za-z+\._-]+@([A-Za-z0-9-]+\.)+[A-Za-z0-9-]+([^A-Za-z0-9@+\._-]|$)' .
