package Catmandu::AlephX::Op::BorAuth;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z303 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    $_[0]->data()->{z303}->[0];
  }
);
has z304 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    $_[0]->data()->{z304}->[0];
  }
);
has z305 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    $_[0]->data()->{z305}->[0];
  }
);

sub op { 'bor-auth' } 

1;
