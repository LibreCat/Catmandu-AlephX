package Catmandu::AlephX;
use Catmandu::AlephX::Sane;
use Moo;
use LWP::UserAgent;
use XML::Simple;
use URI::Escape;
use Data::Util qw(:check :validate);

use Catmandu::AlephX::Op::ItemData;
use Catmandu::AlephX::Op::ReadItem;
use Catmandu::AlephX::Op::Find;
use Catmandu::AlephX::Op::FindDoc;
use Catmandu::AlephX::Op::Present;
use Catmandu::AlephX::Op::IllGetDocShort;

has url => (
  is => 'ro',
  isa => sub { $_[0] =~ /^https?:\/\//o or die("url must be a valid web url\n"); },
  required => 1
);
has _web => (
  is => 'ro',
  lazy => 1,
  default => sub {
    LWP::UserAgent->new(
      cookie_jar => {}
    );
  }
);
has _xml_parser => (
  is => 'ro',
  lazy => 1,
  default => sub { XML::Simple->new(); }
);
sub _from_xml {
  my($self,$data)=@_;
  $self->_xml_parser->XMLin($data,ForceArray => 1);
}
sub _validate_web_response {
  my($res) = @_;
  $res->is_error && confess($res->content);
}
sub _do_web_request {
  my($self,$params,$method)=@_;
  $method ||= "GET";
  my $res;
  if(uc($method) eq "GET"){
    $res = $self->_get($params);
  }elsif(uc($method) eq "POST"){
    $res = $self->_post($params);
  }else{
    confess "method $method not supported";
  }
  _validate_web_response($res);
  $res;
}
sub _post {
  my($self,$data)=@_;
  $self->_web->post($self->url,_construct_params_as_array($data));
}
sub _construct_query {
  my $data = shift;
  my @parts = ();
  for my $key(keys %$data){
    if(is_array_ref($data->{$key})){
      for my $val(@{ $data->{$key} }){
          push @parts,URI::Escape::uri_escape($key)."=".URI::Escape::uri_escape($val // "");
      }
    }else{
      push @parts,URI::Escape::uri_escape($key)."=".URI::Escape::uri_escape($data->{$key} // "");
    }
  }
  join("&",@parts);
}
sub _construct_params_as_array {
    my $params = shift;
    my @array = ();
    for my $key(keys %$params){
        if(is_array_ref($params->{$key})){
            #PHP only recognizes 'arrays' when their keys are appended by '[]' (yuk!)
            for my $val(@{ $params->{$key} }){
                push @array,$key."[]" => $val;
            }
        }else{
            push @array,$key => $params->{$key};
        }
    }
    return \@array;
}
sub _get {
  my($self,$data)=@_;
  my $query = _construct_query($data) || "";
  $self->_web->get($self->url."?$query");
}
=head1 NAME

  Catmandu::AlephX - Low level client for Aleph X-Services

=head1 SYNOPSIS

  my $aleph = Catmandu::AlephX->new(url => "http://aleph.ugent.be");
  my $item_data = $aleph->item_data(base => "rug01",doc_number => "001484477");


  #all public methods return a Catmandu::AlephX::Response
  # 'is_success' means that the xml-response did not contain the element 'error'
  # other errors are thrown (xml parse error, no connection ..)

  if($item_data->is_success){

    say "valid response from aleph x server";

  }else{

    say "aleph x server returned error-response: ".$item_data->error;

  }

=head1 METHODS

=head2 item-data
 
=head3 documentation from AlephX
 
The service retrieves the document number from the user.
For each of the document's items it retrieves:
  Item information (From Z30).
  Loan information (from Z36).
  An indication whether the request is on-hold

=head3 example

  my $item_data = $aleph->item_data(base => "rug01",doc_number => "001484477");
  if($item_data->is_success){
    for my $item(@{ $item_data->item() }){
      print Dumper($item);
    };
  }else{
    print STDERR $item_data->error."\n";
  }

=head3 remarks
  
  This method is equivalent to 'op' = 'item-data'

=cut
sub item_data {
  my($self,%args)=@_;
  $args{'op'} = "item-data";
  my $res = $self->_do_web_request(\%args);
  my $data = $self->_from_xml($res->content);
  Catmandu::AlephX::Op::ItemData->new(data => $data);    
}

=head2 read_item

=head3 documentation from AlephX

  The service retrieves a requested item's record from a given ADM library in case such an item does exist in that ADM library.

=head3 example

  my $readitem = $aleph->read_item(library=>"usm50",item_barcode=>293);
  if($readitem->is_success){
    for my $z30(@{ $readitem->z30 }){
      print Dumper($z30);
    }
  }else{
    say STDERR $readitem->error;
  }

=head3 remarks

  This method is equivalent to 'op' = 'read-item'

=cut

sub read_item {
  my($self,%args)=@_;
  $args{'op'} = "read-item";
  my $res = $self->_do_web_request(\%args);
  my $data = $self->_from_xml($res->content);
  Catmandu::AlephX::Op::ReadItem->new(data => $data);    
}

=head2 find

=head3 documentation from Aleph X
  
  This service retrieves a set number and the number of records answering a search request inserted by the user.

=head3 example
  
  my $find = $aleph->find(request => 'wrd=(art)',base=>'rug01');
  if($find->is_success){
    say "set_number: ".$find->set_number;
    say "no_records: ".$find->no_records;
    say "no_entries: ".$find->no_entries;
  }else{
    say STDERR $find->error;
  }

=head3 remarks

  This method is equivalent to 'op' = 'find'

=cut
sub find {
  my($self,%args)=@_;
  $args{op} = 'find';
  my $res = $self->_do_web_request(\%args);
  my $data = $self->_from_xml($res->content);
  Catmandu::AlephX::Op::Find->new(data => $data);    
}

=head2 find_doc

=head3 documentation from AlephX
  
  This service retrieves the OAI XML format of an expanded document as given by the user.

=head3 example

  my $find = $aleph->find_doc(base=>'rug01',doc_num=>'000000444',format=>'marc');
  if($find->is_success){
    for my $record(@{ $find->record }){
      say Dumper($record);
    }
  }else{
    say STDERR $find->error;
  }

=head3 remarks

  This method is equivalent to 'op' = 'find-doc'

=cut
sub find_doc {
  my($self,%args)=@_;
  $args{op} = 'find-doc';
  my $res = $self->_do_web_request(\%args);
  my $data = $self->_from_xml($res->content);
  Catmandu::AlephX::Op::FindDoc->new(data => $data);    
}

=head2 present

=head3 documentation from Aleph X

  This service retrieves OAI XML format of expanded documents.
  You can view documents according to the locations within a specific set number.

=head3 example

  my $set_number = $aleph->find(request => "wrd=(BIB.AFF)",base => "rug01")->set_number;
  my $present = $aleph->present(
    set_number => $set_number,
    set_entry => "000000001-000000003"
  );
  if($present->is_success){
    say "doc_number: ".$record->{doc_number};
    for my $metadata(@{ $record->metadata }){
      say "\tmetadata: ".$metadata->type;
    }
  }else{
    say STDERR $present->error;
  }

=head3 remarks

  This method is equivalent to 'op' = 'present'

=cut
sub present {
  my($self,%args)=@_;
  $args{op} = 'present';
  my $res = $self->_do_web_request(\%args);
  my $data = $self->_from_xml($res->content);
  Catmandu::AlephX::Op::Present->new(data => $data);    
}

=head2 ill_get_doc_short

=head3 documentation from Aleph X

  The service retrieves the doc number and the XML of the short document (Z13).

=head3 example

  my $result = $aleph->ill_get_doc_short(doc_number => "000000001",library=>"usm01");
  if($result->is_success){
    for my $z30(@{ $result->z13 }){
      print Dumper($z30);
    }
  }else{
    say STDERR $result->error;
  }

=head3 remarks

  This method is equivalent to 'op' = 'ill-get-doc-short'

=cut
sub ill_get_doc_short {
  my($self,%args)=@_;
  $args{op} = 'ill-get-doc-short';
  my $res = $self->_do_web_request(\%args);
  my $data = $self->_from_xml($res->content);
  Catmandu::AlephX::Op::IllGetDocShort->new(data => $data);    
}
=head1 AUTHOR

Nicolas Franck, C<< <nicolas.franck at ugent.be> >>

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
1;
