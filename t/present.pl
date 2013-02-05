#!/usr/bin/env perl
use lib qw(/home/njfranck/Catmandu-AlephX/lib);
use Catmandu::Sane;
use Catmandu::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be/X");

my $set_number = $aleph->find(request => "wrd=(BIB.AFF)",base => "rug01")->set_number;
my $present = $aleph->present(
  set_number => $set_number,
  set_entry => "000000001-000000003"
);
if($present->is_success){
  for my $record(@{ $present->record }){
    say "doc_number: ".$record->{doc_number};
    for my $metadata(@{ $record->metadata }){
      say "\tmetadata: ".$metadata->type;
    }
  }
}else{
  say STDERR $present->error;
} 
