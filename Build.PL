use warnings;
use strict;
use Module::Build;

my $requires = {
    perl => '>=5.10.1',
    'Catmandu' => '0.05',
    'XML::Simple' => 0
};
my $recommends = {};
my $build = Module::Build->new(
    module_name => 'Catmandu Importer Aleph',
    dist_version => '0.01',
    dist_author => [
        'Nicolas Franck <nicolas.franck@ugent.be>',
    ],
    dist_abstract => 'Catmandu Importer Aleph',
    requires => $requires,
    recommends => $recommends,
    create_license => 1
);
$build->create_build_script;
