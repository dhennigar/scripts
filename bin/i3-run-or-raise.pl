#!/usr/bin/perl

# sway-run-or-raise.pl --- focus a program if it is open; else, launch it.

# Copyright (c) 2024 Daniel Hennigar

# This program is free software; you can redistribute it and/or modify
# it under the terms of either:
#
#   a) the Artistic License 2.0, or
#   b) the GNU General Public License as published by the Free Software
#      Foundation; either version 3, or (at your option) any later version.
#
# See the LICENSE file for more information.

use 5.032;

if (@ARGV < 2) {
    die "Usage: $0 <app_id or class> <command>\n";
}
my ($identifier, $command) = @ARGV;

my $focus_by_app_id = system("swaymsg", "[app_id=$identifier] focus") == 0;
unless ($focus_by_app_id) {
    my $focus_by_class = system("swaymsg", "[class=$identifier] focus") == 0;

    unless ($focus_by_class) {
        system("swaymsg", "exec", $command);
    }
}
