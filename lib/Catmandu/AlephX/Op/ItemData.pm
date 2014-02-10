package Catmandu::AlephX::Op::ItemData;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

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
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);
  my $op = op();

  my @items;

  for my $item($xpath->find("/$op/item")->get_nodelist()){
    push @items,get_children($item,1);
  }

  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();

  __PACKAGE__->new(
    session_id => $xpath->findvalue("/$op/session-id"),
    errors => \@errors,
    items => \@items,
    content_ref => $str_ref
  );
} 

1;
