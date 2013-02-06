package Catmandu::AlephX::Op::FindDoc;
use Catmandu::AlephX::Sane;
use Moo;
use Catmandu::AlephX::Metadata;
use Catmandu::AlephX::Record;

with('Catmandu::AlephX::Response');

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
      push @record,Catmandu::AlephX::Record->new(metadata => \@metadata);
    }
    \@record;
  }
);
sub op { 'find-doc' }
1;
