package Catmandu::AlephX::Op::ItemData;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;
use Catmandu::AlephX::XPath::Helper qw(:all);

with('Catmandu::AlephX::Response');

has items => (
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
sub op { 'item-data' }

sub parse {
  my($class,$xpath)=@_;
  my @items;

  for my $item($xpath->find('/item-data/item')->get_nodelist()){
    push @items,get_children($item);
  }
  __PACKAGE__->new(
    session_id => $xpath->findvalue('/item-data/session-id')->value(),
    error => $xpath->findvalue('/item-data/error')->value(),
    items => \@items
  );
} 

1;
