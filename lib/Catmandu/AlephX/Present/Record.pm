package Catmandu::AlephX::Present::Record;
use Catmandu::AlephX::Sane;
use Data::Util qw(:check :validate);
use Moo;

extends 'Catmandu::AlephX::FindDoc::Record';

has record_header => (is => 'ro',required => 1);
has doc_number => (is => 'ro',required => 1);

1;
