package Catmandu::AlephX::Op::ItemData;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

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
sub op { 'item-data' }

1;
