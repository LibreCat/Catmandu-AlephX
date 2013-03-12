package Catmandu::AlephX::XPath::Helper;
use Catmandu::Sane;
use XML::XPath;
use Data::Util qw(:check);
use Exporter qw(import);
our @EXPORT_OK=qw(get_children xpath);
our %EXPORT_TAGS = (all=>[@EXPORT_OK]);

sub get_children {
  my $xpath = $_[0];

  my $hash = {};

  if($xpath){
    for my $child($xpath->find('child::*')->get_nodelist()){
      my $name = $child->getName();
      my $value = $child->string_value();
      $hash->{ $name } //= [];
      push @{ $hash->{$name} },$value if is_string($value);
    }
  }

  $hash;
}
sub xpath {
  my $str = $_[0];
  if(is_scalar_ref($str)){
    return XML::XPath->new(xml => $$str);
  }elsif(-f $str){
    return XML::XPath->new(filename => $str);
  }elsif(is_glob_ref($str)){
    return XML::XPath->new(ioref => $str);
  }
}

1;
