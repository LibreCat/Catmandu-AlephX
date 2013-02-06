package Catmandu::AlephX::Op::Find;
use Catmandu::AlephX::Sane;
use Moo;

with('Catmandu::AlephX::Response');

#'set_number' == id waaronder zoekactie wordt opgeslagen door Aleph (kan je later hergebruiken)
has set_number => (
  is => 'ro',
  lazy => 1,
  default => sub { $_[0]->data->{set_number}->[0]; }
);
has no_records => (
  is => 'ro',
  lazy => 1,
  default => sub { $_[0]->data->{no_records}->[0]; }
);
has no_entries => (
  is => 'ro',
  lazy => 1,
  default => sub { $_[0]->data->{no_entries}->[0]; }
);
sub op { 'find' }

1;
