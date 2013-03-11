package Catmandu::AlephX::FromXML;
use Catmandu::AlephX::Sane;
use Moo;
use Moo::Role;
use XML::Simple;
use Data::Util qw(:check :validate);

sub _xml_parser {
  state $xml_parser = XML::Simple->new(
    #force every element into an array
    ForceArray => 1,
    #ignores attributes
    #NoAttr => 1,
    #when not set, empty elements result in empty hashes
    SuppressEmpty => 1
  ); 
}

sub _from_xml {
  _xml_parser()->XMLin($_[0]);
}

requires 'parse';

1;
