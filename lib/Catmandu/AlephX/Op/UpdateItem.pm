package Catmandu::AlephX::Op::UpdateItem;
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
    +{};
  }
);

sub op { 'update-item' }

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
    session_id => $xpath->findvalue('/'.$op.'/session-id'),
    errors => \@errors,    
    content_ref => $str_ref,
    z30 => $z30[0]
  );
} 

1;
