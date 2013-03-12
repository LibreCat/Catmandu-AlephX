package Catmandu::AlephX::Op::Find;
use Catmandu::Sane;
use Moo;

with('Catmandu::AlephX::Response');

#'set_number' == id waaronder zoekactie wordt opgeslagen door Aleph (kan je later hergebruiken)
has set_number => (
  is => 'ro'
);
has no_records => (
  is => 'ro'
);
has no_entries => (
  is => 'ro',
);
sub op { 'find' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  __PACKAGE__->new(
    error => $xpath->findvalue('/find/error')->value(),
    session_id => $xpath->findvalue('/find/session-id')->value(),
    set_number => $xpath->findvalue('/find/set_number')->value(),
    no_records => $xpath->findvalue('/find/no_records')->value(),
    no_entries => $xpath->findvalue('/find/no_entries')->value()
  ); 
}

1;
