package Catmandu::AlephX::Record;
use Catmandu::Sane;
use Data::Util qw(:validate);
use Moo;
use Catmandu::AlephX::Metadata;

has metadata => (
  is => 'ro',
  required => 1,
  isa => sub {
    instance($_[0],"Catmandu::AlephX::Metadata");
  }
);

1;
