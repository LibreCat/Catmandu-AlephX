package Catmandu::AlephX::Op::IllGetDoc;
use Catmandu::Sane;
use Data::Util qw(:check);
#use Catmandu::Importer::MARC;
use Catmandu::AlephX::Metadata::MARC;
use Moo;

with('Catmandu::AlephX::Response');

#format: [ { _id => <id>, record => <doc>}, .. ]
#<doc> has extra tag in marc array called 'AVA'
has record => (
  is => 'ro',
  isa => sub { array_ref($_[0]); }
);
sub op { 'ill-get-doc' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  my $op = op();
  my $record;

  my($marc) = $xpath->find("/$op/record")->get_nodelist();

  if($marc){

    #remove controlfield with tag 'FMT' and 'LDR' because Catmandu::Importer::MARC cannot handle these
#    my $fmt_value;
#    my($fmt) = $marc->find("./controlfield[\@tag='FMT']")->get_nodelist();
#    if($fmt){
#      $fmt_value = $fmt->findvalue('.')->value();
#      my $parent = $fmt->getParentNode();
#      $parent->removeChild($fmt);
#    }
#    my $ldr_value;
#    my($ldr) = $marc->find("./controlfield[\@tag='LDR']")->get_nodelist();
#    if($ldr){
#      $ldr_value = $ldr->findvalue('.')->value();
#      my $parent = $ldr->getParentNode();
#      $parent->removeChild($ldr);
#    }
#
#    my $xml = $marc->toString();
#    open my $fh,"<",\$xml or die($!);
#    my $importer = Catmandu::Importer::MARC->new(file => $fh, type => 'XML');
#    my $hit = $importer->first();   
#    close $fh;

    #restore FMT (LDR already stored)
#    unshift @{ $hit->{record} },['FMT','','','_',$fmt_value];

#    $record = $hit->{record};

    $record = Catmandu::AlephX::Metadata::MARC->parse($marc)->data();


  }

  __PACKAGE__->new(
    error => $xpath->findvalue("/$op/error")->value(),
    session_id => $xpath->findvalue("/$op/session-id")->value(),
    record => $record
  ); 
}

1;
