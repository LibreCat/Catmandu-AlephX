package Catmandu::AlephX::Op::UpdateDoc;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

sub op { 'update-doc' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);
  my $op = op();

  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();

  __PACKAGE__->new(
    session_id => $xpath->findvalue('/'.$op.'/session-id'),
    errors => \@errors,    
    content_ref => $str_ref
  );
} 

1;
