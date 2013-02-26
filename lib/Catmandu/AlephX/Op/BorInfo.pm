package Catmandu::AlephX::Op::BorInfo;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

extends('Catmandu::AlephX::Op::BorAuth');
with('Catmandu::AlephX::Response');

has item_l => (
  is => 'ro', 
  lazy => 1,
  isa => sub { array_ref($_[0]); },
  default => sub {
    my $l = $_[0]->data()->{item_l};
    is_array_ref($l) ? $l : [];
  }
);
has item_h => (
  is => 'ro', 
  lazy => 1,
  isa => sub { array_ref($_[0]); },  
  default => sub {
    my $h = $_[0]->data()->{item_h};
    is_array_ref($h) ? $h : [];
  }
);

has balance => ( 
  is => 'ro',
  lazy => 1,
  default => sub {
    my $b = $_[0]->data()->{balance};
    is_array_ref($b) ? $b->[0] : undef;
  }
);
has sign => ( 
  is => 'ro',
  lazy => 1,
  default => sub {
    my $s = $_[0]->data()->{balance};
    is_array_ref($s) ? $s->[0] : undef;
  }
);
has fine => (
  is => 'ro',
  lazy => 1,
  isa => sub {
    array_ref($_[0]);
  },
  default => sub {
    my $f = $_[0]->data()->{fine};
    is_array_ref($f) ? $f : [];
  }
);
has due_date => ( 
  is => 'ro',
  lazy => 1,
  default => sub {
    my $due_date = $_[0]->data()->{due_date};
    is_array_ref($due_date) ? $due_date->[0] : undef;
  }
);
has due_hour => ( 
  is => 'ro',
  lazy => 1,
  default => sub {
    my $due_hour = $_[0]->data()->{due_hour};
    is_array_ref($due_hour) ? $due_hour->[0] : undef;
  }
);

sub op { 'bor-info' } 

1;
