use warnings;
use strict;
use Module::Build;

my $requires = {
  perl => '5.10.0', 
  Carp => 0,
  'XML::LibXML' => 0,
  'XML::LibXML::XPathContext' => 0,
  'Moo' => 0,
  'URI::Escape' => 0,
  'LWP::UserAgent' => 0,
  'Data::Util' => 0,
  Catmandu => 0,
};
my $recommends = {
  'Term::ReadKey' => 0
};
my $build = Module::Build->new(
  module_name => 'Catmandu::AlephX',
  dist_author => [
    'Nicolas Franck <nicolas.franck@ugent.be>',
    'Patrick Hochstenbach <patrick.hochstenbach@ugent.be>',
  ],
  dist_abstract => 'Low level api for Aleph X Services',
  requires => $requires,
  recommends => $recommends,
  build_requires => {
    'Software::License' => 0,
    'Test::Exception' => 0,
    'Test::More' => 0,
  },
  create_license => 1,
  license => 'perl',
  dist_version_from => 'lib/Catmandu/AlephX.pm',
  create_makefile_pl => 'traditional'  
);
$build->create_build_script;
