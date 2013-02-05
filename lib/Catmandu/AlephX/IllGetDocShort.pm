package Catmandu::AlephX::IllGetDocShort;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

extends('Catmandu::AlephX::Response');

has z13 => (
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
    $self->data()->{z13} // [];
  }
); 

1;
