#!/usr/bin/env perl
use 5.040;
use Test::More;

our $VERSION = '0.01';

# Get the bin directory from the environment
my $bin_dir =
  $ENV{PERL_LOCAL_LIB_ROOT}
  ? "$ENV{PERL_LOCAL_LIB_ROOT}/bin"
  : "$ENV{HOME}/perl5/bin";

# Ensure the bin directory exists
ok( -d $bin_dir, "The bin directory exists: $bin_dir" );

# Get the list of scripts in the bin directory
my @scripts = glob "$bin_dir/*";

# Check that scripts exist
ok( @scripts > 0, 'Scripts are found in the bin directory' );

# Verify each script is executable
foreach my $script (@scripts) {
    ok( -f $script, "$script is a file" );
    ok( -x $script, "$script is executable" );
}

done_testing();
