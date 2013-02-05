package Catmandu::AlephX::Present::Record;
use Catmandu::Util qw(:is :check);
use Moo;

extends 'Catmandu::AlephX::FindDoc::Record';

has record_header => (is => 'ro',required => 1);
has doc_number => (is => 'ro',required => 1);

1;
