package Catmandu::AlephX::Op::UserAuth;
use Catmandu::Sane;
use Data::Util qw(:check :validate);
use Moo;

with('Catmandu::AlephX::Response');

has z66 => (
  is => 'ro',
  isa => sub{
    hash_ref($_[0]);
  }
); 
has reply => (
  is => 'ro'
);
sub op { 'user-auth' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);
  my $op = op();

  my($z66) = $xpath->find('/z66')->get_nodelist();
  $z66 = get_children($z66,1);

  __PACKAGE__->new(
    session_id => $xpath->findvalue('/'.$op.'/session-id'),
    error => $xpath->findvalue('/'.$op.'/error'),    
    reply => $xpath->findvalue('/'.$op.'/reply'),
    z66 => $z66
  );
} 

1;
