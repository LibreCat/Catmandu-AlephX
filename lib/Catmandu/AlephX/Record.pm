package Catmandu::AlephX::Record;
use Catmandu::Sane;
use Data::Util qw(:validate :check);
use Moo;
use Catmandu::AlephX::Metadata;

has metadata => (
  is => 'ro',
  lazy => 1,
  #required => 1,
  isa => sub {
    instance($_[0],"Catmandu::AlephX::Metadata");
  },
  coerce => sub {
    if(is_code_ref($_[0])){
      return $_[0]->();
    }
    $_[0];
  }
);

1;
