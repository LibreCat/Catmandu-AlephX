#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::Sane;
use Catmandu::Store::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $bag = Catmandu::Store::AlephX->new(url => "http://aleph.ugent.be/X")->bag();

#print Dumper($bag->get('000000444'));
#
#my $hits = $bag->search(query => "WRD=(art)");
#print Dumper($hits);

my $record = $bag->get('000000444');
$record->{_id} = "010000000";

$bag->add($record);