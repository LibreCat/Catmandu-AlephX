package Catmandu::Store::AlephX;
use namespace::clean;
use Catmandu::Sane;
use Catmandu::AlephX;
use Moo;
use Data::Dumper;

our $VERSION = "0.01";

with 'Catmandu::Store';

has url => (is => 'ro', required => 1);

has alephx => (
  is       => 'ro',
  init_arg => undef,
  lazy     => 1,
  builder  => '_build_alephx',
);
around default_bag => sub {
  'usm01';
};

sub _build_alephx {
  Catmandu::AlephX->new(url => $_[0]->url);
}

package Catmandu::Store::AlephX::Bag;
use Catmandu::Sane;
use Moo;
use Catmandu::Util qw(:check :is);
use Catmandu::Hits;
use Clone qw(clone);
use Data::Dumper;

with 'Catmandu::Bag';
with 'Catmandu::Searchable';

sub check_catmandu_marc {
  my $r = $_[0];
  check_hash_ref($r);
  check_string($r->{_id});
  check_array_ref($r->{record});
  check_array_ref($_) for @{ $r->{record} };
}

sub get {
  my($self,$id)=@_;
  my $alephx = $self->store->alephx;

  my $find_doc = $alephx->find_doc(
    format => 'marc',
    doc_num => $id,
    base => $self->name
  );
  
  return unless($find_doc->is_success);
  $find_doc->record->metadata->data;
}
sub add {
  my($self,$data)=@_;
  
  $data = clone($data);
  my $alephx = $self->store->alephx;

  #try to update (even when it does not exists)
  my $update_doc = $alephx->update_doc(
    doc_action => 'UPDATE',
    doc_number => $data->{_id},
    marc => $data
  );
  say ${ $update_doc->content_ref() };
  #document does not exist (yet)
  if(!($update_doc->is_success) && $update_doc->errors()->[-1] =~ /Doc number given does not exist/i){

    say "not found, trying to insert record";
    #'If you want to insert a new document, then the doc_number you supply should be all zeroes'
    my $new_doc_num = sprintf("%-9.9d",0);
    #last error should be 'Document: 000050105 was updated successfully.'
    $update_doc = $alephx->update_doc(
      doc_action => 'UPDATE',
      doc_number => $data->{_id},
      marc => $data
    );
    if($update_doc->errors()->[-1] =~ /Document: (\d{9}) was updated successfully/i){
      my $_id = $1;
      say "new record inserted with doc_num $_id";
      $data->{_id} = $_id;      
    }
  }else{
    say "found and updated";
  }

  
  $data;
}

sub delete {
  my($self,$id)= @_;
  die("not implemented");

}
sub generator {
  my($self)=@_;
  die("not implemented");

  sub {
  };
}
#warning: no_entries is the maximum number of entries to be retrieved (always lower or equal to no_records)
#         specifying a set_entry higher than this, has no use, and leads to the error 'There is no entry number: <set_entry> in set number given'
sub search {
  my($self,%args)=@_;

  my $query = delete $args{query};
  my $start = delete $args{start};
  $start = is_natural($start) ? $start : 0;
  my $limit = delete $args{limit};
  $limit = is_natural($limit) ? $limit : 20;

  my $alephx = $self->store->alephx;
  my $find = $alephx->find(
    request => $query,    
    base => $self->name
  );
  
  return unless $find->is_success;

  my $no_records = int($find->no_records);
  my $no_entries = int($find->no_entries);
    
  my $s = sprintf("%-9.9d",$start + 1);
  my $l = $start + $limit;
  my $e = sprintf("%-9.9d",($l > $no_entries ? $no_entries : $l));
  my $set_entry = "$s-$e";

  my $present = $alephx->present(set_number => $find->set_number,set_entry => $set_entry,format => 'marc');

  return unless $present->is_success;

  my @results;

  @results = map { $_->metadata->data; } @{ $present->records() };

  my $hits = Catmandu::Hits->new({
    limit => $limit,
    start => $start,
    total => $find->no_records,
    hits  => \@results,
  }); 
}
sub searcher {

}

#not supported
sub delete_all {
  my($self)=@_;
  die("not supported");
}
sub delete_by_query {

}
sub translate_sru_sortkeys {
  die("not supported");
}
sub translate_cql_query {
  die("not supported");
}
1;
