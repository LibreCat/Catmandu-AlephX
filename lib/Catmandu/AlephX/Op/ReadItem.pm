package Catmandu::AlephX::Op::ReadItem;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z30 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    array_ref($_[0]);
    for(@{ $_[0] }){
      hash_ref($_);
    }
  },
  default => sub {
    $_[0]->data()->{z30} // [];
  }
);
sub op { 'read-item' } 

1;
