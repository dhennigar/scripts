package i3::Utils;

# Utils.pm --- a set of helper functions for SwayScripts::Utils

# Copyright (C) 2024 Daniel Hennigar

# Author: Daniel Hennigar

# This program is free software; you can redistribute it and/or modify
# it under the terms of either:

#   a) the Artistic License 2.0, or
#   b) the GNU General Public License as published by the Free Software
#      Foundation; either version 3, or (at your option) any later version.

# See the LICENSE file for more information.

use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(find_node find_nodes);

# Expects $node (an i3 node object) and $criteria, itself a subroutine
# which takes an i3 node and returns a boolean value. Returns the
# first node matching $criteria, its parent node, and a workspace if
# one exists as an ancestor.
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

# Similar to find_node(), but returns all child nodes matching criteria
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
