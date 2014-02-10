package Catmandu::AlephX::Op::GetHolding;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has cdl_holdings => (
  is => 'ro',
  lazy => 1,
  isa => sub{
    array_ref($_[0]);
  },
  default => sub {
    [];
  }
);
sub op { 'get-holding' } 

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  my $op = op();

  my @cdl_holdings;

  for my $ch($xpath->find("/$op/cdl-holdings")->get_nodelist()){
    push @cdl_holdings,get_children($ch,1);
  }    
  
  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();

  __PACKAGE__->new(
    cdl_holdings => \@cdl_holdings,
    session_id => $xpath->findvalue("/$op/session-id"),
    errors => \@errors,
    content_ref => $str_ref
  );
}

1;
