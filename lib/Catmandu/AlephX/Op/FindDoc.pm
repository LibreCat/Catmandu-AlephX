package Catmandu::AlephX::Op::FindDoc;
use Catmandu::Sane;
use Moo;
use Catmandu::AlephX::Metadata::MARC::Aleph;
use Catmandu::AlephX::Record;

with('Catmandu::AlephX::Response');

has record => ( 
  is => 'ro'
);
sub op { 'find-doc' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);
  my $op = op();

  my @metadata = ();

  #metadata
  my($oai_marc) = $xpath->find("/$op/record[1]/metadata/oai_marc")->get_nodelist();

  push @metadata,Catmandu::AlephX::Metadata::MARC::Aleph->parse($oai_marc) if $oai_marc;

  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();

  __PACKAGE__->new(
    record => Catmandu::AlephX::Record->new(metadata => \@metadata),
    session_id => $xpath->findvalue("/$op/session-id"),
    errors => \@errors,
    content_ref => $str_ref
  );
  
}

1;
