#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::AlephX::Sane;
use Catmandu::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be/X");

my $find = $aleph->find_doc(base=>'rug01',doc_num=>'000000444');
if($find->is_success){
  for my $record(@{ $find->record }){
    say Dumper($record);
  }
}else{
  say STDERR $find->error;
} 
