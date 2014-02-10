package Catmandu::AlephX::Op::ReadItem;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z30 => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    hash_ref($_[0]);
  },
  default => sub {
    {};
  }
);
sub op { 'read-item' } 

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  my $op = op();

  my @z30;

  for my $z($xpath->find("/$op/z30")->get_nodelist()){
    push @z30,get_children($z,1);
  }    

  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();

  __PACKAGE__->new(
    session_id => $xpath->findvalue("/$op/session-id"),
    errors => \@errors,
    z30 => $z30[0],
    content_ref => $str_ref
  );
}

1;
