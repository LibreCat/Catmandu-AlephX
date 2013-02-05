package Catmandu::AlephX::FindDoc;
use Catmandu::Sane;
use Moo;
use Catmandu::AlephX::Metadata;
use Catmandu::AlephX::FindDoc::Record;

extends('Catmandu::AlephX::Response');

has record => (
  is => 'ro',
  lazy => 1,
  default => sub { 
    my $self = $_[0];
    my $rs = $self->data->{record};
    my @record = ();
    for my $r(@$rs){
      my @metadata = ();
      for my $type(keys %{ $r->{metadata}->[0] }){
        push @metadata,Catmandu::AlephX::Metadata->new(
          type => $type,data => $r->{metadata}->[0]->{$type}->[0]
        );
      }
      push @record,Catmandu::AlephX::FindDoc::Record->new(metadata => \@metadata);
    }
    \@record;
  }
);

1;
