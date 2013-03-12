package Catmandu::AlephX::Op::IllGetDocShort;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;
use Catmandu::AlephX::XPath::Helper qw(:all);

with('Catmandu::AlephX::Response');

has z13 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub { {}; }
); 
sub op { 'ill-get-doc-short' }

sub parse {
  my($class,$xpath)=@_;

  my $z13 = {};

  my($z) = $xpath->find('/ill-get-doc-short/z13')->get_nodelist();

  $z13 = get_children($z) if $z;

  __PACKAGE__->new(
    session_id => $xpath->findvalue('/ill-get-doc-short/session-id')->value(),
    error => $xpath->findvalue('/ill-get-doc-short/error')->value(),
    z13 => $z13
  );
}

1;
