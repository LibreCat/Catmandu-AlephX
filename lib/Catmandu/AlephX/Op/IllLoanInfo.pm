package Catmandu::AlephX::Op::IllLoanInfo;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z36 => (
  is => 'ro', 
  lazy => 1,
  isa => sub { hash_ref($_[0]); },  
  default => sub {
    $_[0]->data()->{z36}->[0];
  }
);

sub op { 'ill-loan-info' } 

1;
