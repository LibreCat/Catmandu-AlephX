package Catmandu::AlephX::Op::IllBorInfo;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

extends('Catmandu::AlephX::Op::BorAuth');
with('Catmandu::AlephX::Response');

has z308 => (
  is => 'ro',
  lazy => 1,
  isa => sub {
    array_ref($_[0]);
  },
  default => sub {
    [];
  }
);

sub op { 'ill-bor-info' } 

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);
  my $op = op();

  my @keys = qw(z303 z304 z305 z308);
  my %args = ();

  for my $key(@keys){
    my($l) = $xpath->find("/$op/$key")->get_nodelist();
    my $data = $l ? get_children($l,1) : {};
    $args{$key} = $data;
  }

  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();

  __PACKAGE__->new(
    %args,
    session_id => $xpath->findvalue('/ill-bor-info/session-id'),
    errors => \@errors,
    content_ref => $str_ref
  );
  
}

1;
