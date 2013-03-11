package Catmandu::AlephX::Op::ReadItem;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;
use Catmandu::AlephX::XPath::Helper;

with('Catmandu::AlephX::Response');

has z30 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    array_ref($_[0]);
    for(@{ $_[0] }){
      hash_ref($_);
    }
  },
  default => sub {
    [];
  }
);
sub op { 'read-item' } 

sub parse {
  my($class,$xpath) = @_;

  my @z30;

  for my $z($xpath->find('/read-item/z30')->get_nodelist()){
    push @z30,Catmandu::AlephX::XPath::Helper->get_children($z);
  }    

  __PACKAGE__->new(
    session_id => $xpath->findvalue('/read-item/session-id')->value(),
    error => $xpath->findvalue('/read-item/error')->value(),
    z30 => \@z30
  );
}

1;
