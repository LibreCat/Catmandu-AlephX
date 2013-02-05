package Catmandu::AlephX::Response;
use Moo;
use Data::Util qw(:validate :check);

sub BUILD {
  my $self = $_[0];
  my $error = $self->data()->{error}->[0];
  $self->error($error);
  $self->is_success(!defined($error));
}

has is_success => (is => 'rw');
has 'error' => (is => 'rw');
has data => (
  is => 'ro',
  required => 1,
  isa => sub { hash_ref($_[0]); }
);

1;
