package Catmandu::AlephX::Sane;
use strict;
use warnings;
use 5.010;
use feature ();
use Carp ();
use utf8;

sub import {
    my $pkg = caller;

    strict->import;
    warnings->import;
    feature->import(':5.10');
    Carp->export_to_level(1, $pkg, qw(confess));
    utf8->import;
}

1;

=head1 NAME

Catmandu::AlephX::Sane - Sensible package boilerplate, copy of Catmandu::Sane

=head1 SYNOPSIS

    use Catmandu::AlephX::Sane;

=head1 DESCRIPTION

Sensible package boilerplate equivalent to:

    use strict;
    use warnings;
    use 5.012;
    use Carp qw(confess);
    use utf8;

This package is a copy of Catmandu::Sane from the cpan module Catmandu

=cut
