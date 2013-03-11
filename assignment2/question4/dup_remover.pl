#!/usr/bin/env perl -w

# This makes Perl complain more.  Apparently it's good practice.
use strict;

# Emit the first 6 lines.
for(my $i = 0; $i < 6; $i++) {
    my $line = <STDIN>;
    print $line;
}

while(<STDIN>) {
    # Interestingly enough, this defaults to $_ if no argument is given.  Which
    # is kind of cool.
    if( m/ HREF="http/ ) {
        check_and_emit($_);
    } else {
        # Same as above, actually.
        print;
    }
}

# This hash trackes what we've already seen.
my %seen;

sub check_and_emit {
    # Extract the url.
    my $line = $_[0];
    $line =~ / HREF="([^"\s]+)"/;
    my $url = $1;

    # Check if we've already seen this line.
    return if $seen{$url};

    # Why is "true" not allowed?!
    $seen{$url} = 1;

    # Otherwise, print it.
    print $line;
}
