#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::AlephX::Sane;
use Catmandu::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be/X");

my %args = (
  library => "usm50",
  bor_id => "00000012",
  verification => "00000012"
);
my $info = $aleph->bor_info(%args);
if($info->is_success){

  #print Dumper($info->z303);
  #print Dumper($info->z304);
  #print Dumper($info->z305);

  print Dumper($info->fine);
  print $info->due_date;
}else{
  say STDERR $info->error;
} 
