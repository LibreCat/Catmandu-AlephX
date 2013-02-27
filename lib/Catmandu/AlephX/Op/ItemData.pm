package Catmandu::AlephX::Op::ItemData;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has item => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    array_ref($_[0]);
    for(@{ $_[0] }){
      hash_ref($_);
    }
  },
  default => sub {
    $_[0]->data()->{item} // [];
  }
); 
sub op { 'item-data' }

1;
