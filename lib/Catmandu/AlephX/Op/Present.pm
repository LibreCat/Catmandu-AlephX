package Catmandu::AlephX::Op::Present;
use Catmandu::AlephX::Sane;
use Moo;
use Catmandu::AlephX::Metadata;
use Catmandu::AlephX::Record::Present;

with('Catmandu::AlephX::Response');

has record => (
  is => 'ro',
  lazy => 1,
  default => sub {
    my $self = shift;
    my $rs = $self->data->{record};
    my @record = ();
    for my $r(@$rs){
      my @metadata = ();
      for my $type(keys %{ $r->{metadata}->[0] }){
        push @metadata,Catmandu::AlephX::Metadata->new(
          type => $type,data => $r->{metadata}->[0]->{$type}->[0]
        );
      }
      push @record,Catmandu::AlephX::Record::Present->new(
        metadata => \@metadata,
        record_header => $r->{record_header}->[0],
        doc_number => $r->{doc_number}->[0]
      );
    }
    \@record;
  }
);
sub op { 'present' }

1;
