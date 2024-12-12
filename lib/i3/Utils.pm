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

use 5.040;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(find_node find_nodes);

sub _find {
    my ( $node, $criteria, $parent, $workspace ) = @_;
    
    $workspace = $node if $node->{type} eq 'workspace';

    if ($criteria->($node)) {
	return ( $node, $parent, $workspace );
    }
    
    for my $child ( @{ $node->{nodes} || [] } ) {
	my ( $target_node, $parent_node, $workspace_node ) =
	  _find( $child, $criteria, $node, $workspace );
	return ( $target_node, $parent_node, $workspace_node ) if $target_node;
    }
}

sub _finds {
    my ( $node, $criteria, $is_root, $children ) = @_;

    push @$children, $node if !$is_root && $criteria->( $node );
    
    foreach my $child ( @{ $node->{nodes} || [] }, @{ $node->{floating_nodes} || [] } ) {
        _finds( $child, $criteria, 0, $children );
    }
    return $children;
}

sub find_node {
    my ( $node, $criteria ) = @_;

    die "First argument must be a node hashref" unless ref $node eq 'HASH';
    die "Second argument must be a code reference" unless ref $criteria eq 'CODE';

    return _find( $node, $criteria, undef, undef);
}
sub find_nodes {
    my ( $node, $criteria ) = @_;

    die "First argument must be a node hashref" unless ref $node eq 'HASH';
    die "Second argument must be a code reference" unless ref $criteria eq 'CODE';

    return @{ _finds( $node, $criteria, 1, [] ) };
}

1;    # modules must return a true value
