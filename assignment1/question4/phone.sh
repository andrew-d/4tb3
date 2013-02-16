#!/bin/bash

# Phone number regex:
#   \(905\)([ -])[0-9]{3}(\1)?[0-9]{4}        # Matches (905) 515 5463 OR (905)-515-5463 OR (905) 5155463 OR (905)-5155463
#   [0-9]{3}([ -])[0-9]{3}(\1)?[0-9]{3}       # Matches 905-515-5463 OR 905 515 5463 OR 905 5155463 OR 905-5155463
#
# The seperators that are valid are anything that doesn't exist in a number - i.e.:
#   [^0-9 -]
# Note that we use a lookahead at the end so we don't match the phone number.

cd tests && grep -orhE '(^|[^0-9()-])(\([0-9]{3}\)([ -])[0-9]{3}(\3)?[0-9]{4})|([0-9]{3}([ -])[0-9]{3}(\6)?[0-9]{4})(?=[^0-9()-]|$)' .

