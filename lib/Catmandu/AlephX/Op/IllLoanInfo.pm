package Catmandu::AlephX::Op::IllLoanInfo;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z36 => (
  is => 'ro', 
  lazy => 1,
  isa => sub { hash_ref($_[0]); },  
  default => sub {
    {}
  }
);

sub op { 'ill-loan-info' } 

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);
  my $op = op();

  my $z36 = {};

  my($z) = $xpath->find("/ill-LOAN-INFO/z36")->get_nodelist();

  $z36 = get_children($z) if $z;

  my @errors = map { $_->to_literal; } $xpath->find("/ill-LOAN-INFO/error")->get_nodelist();

  __PACKAGE__->new(
    session_id => $xpath->findvalue('/ill-LOAN-INFO/session-id'),
    errors => \@errors,
    z36 => $z36,
    content_ref => $str_ref
  );
}

1;
