package Catmandu::AlephX::Op::ReadItem;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z30 => (
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
    $self->data()->{z30} // [];
  }
);
sub op { 'read-item' } 

1;