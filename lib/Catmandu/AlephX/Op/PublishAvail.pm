package Catmandu::AlephX::Op::PublishAvail;
use Catmandu::Sane;
use Data::Util qw(:check);
#use Catmandu::Importer::MARC;
use Catmandu::AlephX::Metadata::MARC;
use Moo;

with('Catmandu::AlephX::Response');

#format: [ { _id => <id>, record => <doc>}, .. ]
#<doc> has extra tag in marc array called 'AVA'
has list => (
  is => 'ro',
  isa => sub { array_ref($_[0]); }
);
sub op { 'publish-avail' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  my $op = op();
  my @list;

  for my $record($xpath->find("/$op/OAI-PMH/ListRecords/record")->get_nodelist()){
    my $identifier = $record->findvalue("./header/identifier")->value();
    $identifier =~ s/aleph-publish://o;

    my($record) = $record->find("./metadata/record")->get_nodelist();
    if(!$record){
      push @list,{ _id => $identifier, record => undef };
    }else{
      #remove controlfield with tag 'FMT' and 'LDR' because Catmandu::Importer::MARC cannot handle these
#      my $fmt_value;
#      my($fmt) = $record->find("./controlfield[\@tag='FMT']")->get_nodelist();
#      if($fmt){
#        $fmt_value = $fmt->findvalue('.')->value();
#        my $parent = $fmt->getParentNode();
#        $parent->removeChild($fmt);
#      }
#      my $ldr_value;
#      my($ldr) = $record->find("./controlfield[\@tag='LDR']")->get_nodelist();
#      if($ldr){
#        $ldr_value = $ldr->findvalue('.')->value();
#        my $parent = $ldr->getParentNode();
#        $parent->removeChild($ldr);
#      }
#
#      my $xml = $record->toString();
#    
#      open my $fh,"<",\$xml or die($!);
#      my $importer = Catmandu::Importer::MARC->new(file => $fh, type => 'XML');
#      my $hit = $importer->first();
#  
      #restore FMT (LDR already stored)
#      unshift @{ $hit->{record} },['FMT','','','_',$fmt_value];

#      push @list,{ _id => $hit->{_id}, record => $hit->{record} };
#      close $fh;

      my $r = Catmandu::AlephX::Metadata::MARC->parse($record);
      push @list,{ _id => $identifier, record => $r->data };
    }
  }

  __PACKAGE__->new(
    error => $xpath->findvalue("/$op/error")->value(),
    session_id => $xpath->findvalue("/$op/session-id")->value(),
    list => \@list
  ); 
}

1;
