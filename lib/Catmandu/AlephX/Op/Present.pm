package Catmandu::AlephX::Op::Present;
use Catmandu::Sane;
use Moo;
use Catmandu::AlephX::Metadata::MARC::Aleph;
use Catmandu::AlephX::Record::Present;

with('Catmandu::AlephX::Response');

has records => (
  is => 'ro',
  lazy => 1,
  default => sub { [] }
);
sub op { 'present' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  my $op = op();

  my @records;
  
  for my $r($xpath->find("/$op/record")->get_nodelist()){
  
    my @metadata;

    my($l) = $r->find('./record_header')->get_nodelist();

    my $record_header = $l ? get_children($l,1) : {};

    push @metadata,Catmandu::AlephX::Metadata::MARC::Aleph->parse(
      $r->find('./metadata/oai_marc')->get_nodelist()
    );
    
    push @records,Catmandu::AlephX::Record::Present->new(
      metadata => \@metadata,
      record_header => $record_header,
      doc_number => $r->findvalue('./doc_number')
    );   

  }

  my @errors = map { $_->to_literal; } $xpath->find("/$op/error")->get_nodelist();  

  __PACKAGE__->new(
    records => \@records,
    session_id => $xpath->findvalue("/$op/session-id"),
    errors => \@errors,
    content_ref => $str_ref
  );
}

1;
