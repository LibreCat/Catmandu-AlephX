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
  sub_library => "HIL",
  bor_id => "00000012",
  verification => "00000012"
);
my $auth = $aleph->bor_auth(%args);
if($auth->is_success){

  print Dumper($auth->z303);
  print Dumper($auth->z304);
  print Dumper($auth->z305);


}else{
  say STDERR $auth->error;
} 
