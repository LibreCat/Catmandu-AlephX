#!/usr/bin/env perl
use lib qw(/home/njfranck/Catmandu-AlephX/lib);
use Catmandu::AlephX::Sane;
use Catmandu::AlephX;
use Data::Dumper;
use open qw(:std :utf8);

my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be/X");

my($library,$item_barcode)=("usm50","293");
my $readitem = $aleph->read_item(library=>$library,item_barcode=>$item_barcode);
if($readitem->is_success){
  for my $z30(@{ $readitem->z30 }){
    print Dumper($z30);
  }
}else{
  say STDERR $readitem->error;
} 
