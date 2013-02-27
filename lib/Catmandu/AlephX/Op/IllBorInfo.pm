package Catmandu::AlephX::Op::IllBorInfo;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

extends('Catmandu::AlephX::Op::BorAuth');
with('Catmandu::AlephX::Response');

has z308 => (
  is => 'ro',
  lazy => 1,
  isa => sub {
    array_ref($_[0]);
  },
  default => sub {
    my $f = $_[0]->data()->{z308};
    is_array_ref($f) ? $f : [];
  }
);

sub op { 'ill-bor-info' } 

1;
