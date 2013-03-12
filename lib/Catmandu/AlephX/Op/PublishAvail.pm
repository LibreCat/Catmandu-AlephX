package Catmandu::AlephX::Op::PublishAvail;
use Catmandu::Sane;
use Data::Util qw(:check);
use Catmandu::Importer::MARC;
use Moo;

with('Catmandu::AlephX::Response');

#format: [ [<id>,<doc>] ]
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
    my($record) = $record->find("./metadata/record")->get_nodelist();
    if(!$record){
      $identifier =~ s/aleph-publish://o;
      push @list,[$identifier,undef];
    }else{
      #remove controlfield with tag 'FMT' and 'LDR'
      my($fmt) = $record->find("./controlfield[\@tag='FMT']")->get_nodelist();
      if($fmt){
        my $parent = $fmt->getParentNode();
        $parent->removeChild($fmt);
      }
      my($ldr) = $record->find("./controlfield[\@tag='LDR']")->get_nodelist();
      if($ldr){
        my $parent = $ldr->getParentNode();
        $parent->removeChild($ldr);
      }

      my $xml = $record->toString();
      open my $fh,"<",\$xml or die($!);
      my $importer = Catmandu::Importer::MARC->new(file => $fh, type => 'XML');
      my $hit = $importer->first();
      push @list,[$hit->{_id},$hit->{record}];
      close $fh;
    }
  }

  __PACKAGE__->new(
    error => $xpath->findvalue("/$op/error")->value(),
    session_id => $xpath->findvalue("/$op/session-id")->value(),
    list => \@list
  ); 
}

1;
