package Catmandu::AlephX::UserAgent;
use Catmandu::Sane;
use Moo::Role;

has url => (
  is => 'ro',
  isa => sub { $_[0] =~ /^https?:\/\//o or die("url must be a valid web url\n"); },
  required => 1
);

#usage: request($params,$methods)
requires qw(request);

1;
