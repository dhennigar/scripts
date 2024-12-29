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
    my ( $node, $criteria ) = @_;
    
    if ($criteria->($node)) {
	return $node;
    }
    
    for my $child ( @{ $node->{nodes} || [] } ) {
	my $target_node =_find( $child, $criteria );
	return $target_node if $target_node;
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

1;

=pod

=head1 NAME

i3::Utils - Utility functions for traversing and querying the i3 window manager tree.

=head1 DESCRIPTION

This module provides utility functions for finding and querying nodes in the i3/sway tree structure using the AnyEvent::I3 module.

=head1 FUNCTIONS

=head2 find_node

  my ($node, $parent, $workspace) = find_node($tree, sub { $_[0]->{name} eq 'example' });

Recursively searches the i3 tree for the first node that matches a given criteria. The criteria should be a code reference that evaluates to true for the desired node. Returns the target node, its parent node, and (if applicable) its parent workspace node.

=head2 find_nodes

  my @nodes = find_nodes($tree, sub { $_[0]->{type} eq 'workspace' });

Like find_node(), but returns a list of all nodes that match the criteria.

=head1 DEPENDENCIES

=over 4

=item * L<AnyEvent::I3|https://metacpan.org/pod/AnyEvent::I3>

=back

=head1 AUTHOR

Daniel Hennigar

=head1 LICENSE

This module is licensed under the Artistic License 2.0 and the GNU General Public License.

=cut
