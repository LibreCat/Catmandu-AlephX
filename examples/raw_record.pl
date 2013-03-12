#!/usr/bin/env perl 
use Catmandu::Sane;
use XML::XPath;
use Data::Dumper;

local $/ = undef;
my $data = <STDIN>;

my $xpath = XML::XPath->new(xml => $data);

my($r) = $xpath->find('/publish-avail/OAI-PMH[1]/ListRecords/record/metadata')->get_nodelist;
print Dumper($r->toString);
