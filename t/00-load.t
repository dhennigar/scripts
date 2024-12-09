#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

# Load your module
use lib '../lib'; # Ensure the test file knows where to find your module
use i3::Utils; # Replace with the actual module name

# Test 1: Check if the module loads correctly
ok(1, 'Basic test file runs'); # Sanity check

# Test 2: Check if the module loads without errors
use_ok('i3::Utils');

# All done!
done_testing();
