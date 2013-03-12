#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::Sane;
use Catmandu::AlephX;
use Data::Dumper;
use open qw(:std :utf8);
use Catmandu::Exporter::MARC;

my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be/X");

my $exporter = Catmandu::Exporter::MARC->new(type => 'XML');

my $publish = $aleph->publish_avail(doc_num => '000196220,001313162,001484478,001484538,001317121,000000000',library=>'rug01');
if($publish->is_success){

  for my $item(@{ $publish->list }){
    #say $item->[0]." : ".($item->[1] ? "available":"not available");

    say "id: $item->[0]";
    if($item->[1]){
      say "xml:";
      $exporter->add({ record => $item->[1] });
      $exporter->commit;
    }
    else{
      say "nothing for $item->[0]";
    }

    say "\n---";
  }
}else{
  say STDERR $publish->error;
} 
