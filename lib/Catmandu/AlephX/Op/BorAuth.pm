package Catmandu::AlephX::Op::BorAuth;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;
use Catmandu::AlephX::XPath::Helper;

with('Catmandu::AlephX::Response');

has z303 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    {};
  }
);
has z304 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    {};
  }
);
has z305 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    {};
  }
);

sub op { 'bor-auth' } 

sub parse {
  my($class,$xpath) = @_;

  my @keys = qw(z303 z304 z305);
  my %args = ();

  for my $key(@keys){
    my $data = Catmandu::AlephX::XPath::Helper->get_children(
      $xpath->find("/bor-auth/$key")->get_nodelist()
    );
    $args{$key} = $data;
    
  }  

  __PACKAGE__->new(
    %args,
    session_id => $xpath->findvalue('/bor-auth/session-id')->value(),
    error => $xpath->findvalue('/bor-auth/error')->value()
  ); 

}

1;
