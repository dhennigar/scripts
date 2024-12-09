package SwayScripts::Utils;

# Utils.pm --- a set of helper functions for SwayScripts::Utils

# Copyright (C) 2024 Daniel Hennigar

# Author: Daniel Hennigar

# This program is dual-licensed under the GNU General Public License,
# version 3, or the Artistic License, version 2.0. You may choose to
# use, modify, and redistribute it under either of these licenses.

# Commentary:
# SwayScripts aims to extend the functionality your Linux window manager.
# It is compatible with sway/i3, and communicates with them through their
# IPC interfaces via the AnyEvent::I3 module.

use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(find_current_ws_and_con find_named_child_cons);

sub find_current_ws_and_con {
    my ($node, $current_workspace) = @_;
    $current_workspace = $node if $node->{type} eq 'workspace';

    return ($current_workspace, $node) if $node->{focused};

    for my $child (@{$node->{nodes} || []}) {
        my ($ws, $con) = find_current_ws_and_con($child, $current_workspace);
        return ($ws, $con) if $con;
    }
}


sub find_named_child_cons {
    my ($node, $windows) = @_;
    $windows //= [];
    push @$windows, $node->{id} if $node->{name} && $node->{type} eq 'con';
    if ($node->{nodes}) { # && ref $node->{nodes} eq 'ARRAY') {
        foreach my $child (@{$node->{nodes}}) {
            find_named_child_cons($child, $windows);
        }
    }
    return $windows;
}

1; # modules must return a true value
