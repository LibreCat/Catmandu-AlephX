package Catmandu::AlephX::Metadata::MARC;
use Catmandu::AlephX::Sane;
use Moo;
extends qw(Catmandu::AlephX::Metadata);

sub parse {
  my($class,$xpath)=@_;
 
  my @marc = ();

  my($fix_fields) = $xpath->find('./fixfield');
  for my $fix_field(@$fix_fields){
    my $tag = $fix_field->findvalue('@id')->value();
    my $value = $fix_field->findvalue('.')->value();
    push @marc,[$tag,'','','_',$value];
  }

  my($var_fields) = $xpath->find('./varfield');
  for my $var_field(@$var_fields){

    my $tag = $var_field->findvalue('@id')->value();
    my $ind1 = $var_field->findvalue('@i1')->value();
    my $ind2 = $var_field->findvalue('@i2')->value();

    my @subf = ();

    my($sub_fields) = $var_field->find('.//subfield')->get_nodelist();
    foreach my $sub_field($sub_fields) {
      my $code  = $sub_field->findvalue('@label')->value();
      my $value = $sub_field->findvalue('.')->value();
      push @subf,$code,$value;
    }

    push @marc,[$tag,$ind1,$ind2,@subf];

  }

  __PACKAGE__->new(type => 'oai_marc',data => \@marc); 
}

1;
