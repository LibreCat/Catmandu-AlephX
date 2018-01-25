#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::Sane;
use Catmandu::Store::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $bag = Catmandu::Store::AlephX->new(url => "http://borges1.ugent.be/X")->bag();

my $id = shift;

$bag->delete($id);
