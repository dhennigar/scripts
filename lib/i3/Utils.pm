package i3::Utils;

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

our @EXPORT_OK = qw(find_node find_nodes find_focused find_workspace);

# Return the first node which matches criteria
sub find_node {
    my ( $node, $criteria, $parent, $workspace ) = @_;
    
    $workspace = $node if $node->{type} eq 'workspace';

    if ($criteria->($node)) {
	return ( $node, $parent, $workspace );
    }
    
    for my $child ( @{ $node->{nodes} || [] } ) {
	my ( $target_node, $parent_node, $workspace_node ) =
	  find_node( $child, $criteria, $node, $workspace );
	return ( $target_node, $parent_node, $workspace_node ) if $target_node;
    }
}

# Return all child nodes matching criteria
sub find_nodes {
    my ( $node, $criteria, $children ) = @_;
    $children //= [];
    push @$children, $node if $criteria->( $node );
    if ( $node->{nodes} ) {
        foreach my $child ( @{ $node->{nodes} } ) {
            find_nodes( $child, $criteria, $children );
        }
    }
    return $children;
}

1;    # modules must return a true value
