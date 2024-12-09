#!/usr/bin/env perl

# sway-cycle-focus.pl --- emulate "Alt-Tab" behaviour in sway/i3

# Copyright (C) 2024 Daniel Hennigar

# Author: Daniel Hennigar

# This program is free software; you can redistribute it and/or modify
# it under the terms of either:

#   a) the Artistic License 2.0, or
#   b) the GNU General Public License as published by the Free Software
#      Foundation; either version 3, or (at your option) any later version.

# See the LICENSE file for more information.

use 5.032;
use AnyEvent::I3;
use SwayScripts::Utils qw(find_current_ws_and_con find_named_child_cons);

my $tree = i3->get_tree->recv;
my ($current_ws, $current_con) = find_current_ws_and_con($tree, undef);
my $cons_in_workspace = find_named_child_cons($current_ws);

my $index = 0;
$index++ while $cons_in_workspace->[$index] != $current_con->{id};
my $next_id = $cons_in_workspace->[($index + 1) % @$cons_in_workspace];
say "next id: $next_id";
i3->command("[con_id=$next_id] focus");
