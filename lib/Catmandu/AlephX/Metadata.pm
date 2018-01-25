package Catmandu::AlephX::Metadata;
use Catmandu::Sane;
use Moo;

our $VERSION = "1.07";

has type => (is => 'ro',required => 1);
has data => (is => 'ro',required => 1);

1;
