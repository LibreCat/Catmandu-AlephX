use warnings;
use strict;
use Module::Build;

my $requires = {
  perl => '>=5.10.1',
  'XML::XPath' => 0,
  'Moo' => 0,
  'URI::Escape' => 0,
  'LWP::UserAgent' => 0,
  'Data::Util' => 0,
  'Catmandu' => '0.09',
};
my $recommends = {
  'Term::ReadKey' => 0
};
my $build = Module::Build->new(
  module_name => 'Low level api for Aleph X Services',
  dist_version => '0.01',
  dist_author => [
    'Nicolas Franck <nicolas.franck@ugent.be>',
  ],
  dist_abstract => 'Low level api for Aleph X Services',
  requires => $requires,
  recommends => $recommends,
  create_license => 1
);
$build->create_build_script;
