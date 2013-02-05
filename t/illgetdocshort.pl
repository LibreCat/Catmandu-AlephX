#!/usr/bin/env perl
use lib qw(/home/njfranck/Catmandu-AlephX/lib);
use Catmandu::AlephX::Sane;
use Catmandu::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be/X");

my $result = $aleph->ill_get_doc_short(doc_number => "000000001",library=>"usm01");
if($result->is_success){
  for my $z30(@{ $result->z13 }){
    print Dumper($z30);
  }
}else{
  say STDERR $result->error;
} 
