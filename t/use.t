#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

my @packages = qw(
  Catmandu::AlephX
  Catmandu::AlephX::Response
  Catmandu::AlephX::Metadata
  Catmandu::AlephX::Sane
  Catmandu::AlephX::Record
  Catmandu::AlephX::Record::Present
  Catmandu::AlephX::Op::Find
  Catmandu::AlephX::Op::FindDoc
  Catmandu::AlephX::Op::ItemData
  Catmandu::AlephX::Op::ReadItem
  Catmandu::AlephX::Op::Present
  Catmandu::AlephX::Op::IllGetDocShort
);
plan tests => scalar(@packages);
for my $package(@packages){
  use_ok($package);
}

done_testing(scalar @packages);
