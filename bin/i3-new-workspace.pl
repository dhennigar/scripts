#!/usr/bin/perl

# sway-new-workspace.pl --- open the next available empty workspace

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
use Getopt::Std;
use AnyEvent::I3;

my %opts;
getopts('t', \%opts); # -t "take"

my $workspaces = i3->get_workspaces->recv;
my %workspace_numbers;
foreach my $workspace (@$workspaces) {
    $workspace_numbers{$workspace->{num}} = 1;
}

my $lowest_empty_workspace;
my $max_workspace_number = scalar @$workspaces + 1;
for my $i (1..$max_workspace_number) {
    unless (exists $workspace_numbers{$i}) {
        $lowest_empty_workspace = $i;
        last;
    }
}

if (defined $lowest_empty_workspace) {
    if ($opts{t}) {
	i3->command("move to workspace " . $lowest_empty_workspace);
    }
    i3->command("workspace " . $lowest_empty_workspace);
}
