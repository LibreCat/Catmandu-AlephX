package Catmandu::AlephX::ItemData;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

extends('Catmandu::AlephX::Response');

has item => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    my $item = $_[0];
    array_ref($item);
    for(@$item){
      hash_ref($_);
    }
  },
  default => sub {
    my $self = $_[0];
    $self->data()->{item} // [];
  }
); 

1;
