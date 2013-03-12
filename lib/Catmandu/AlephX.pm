package Catmandu::AlephX;
use Catmandu::AlephX::Sane;
use Moo;
use LWP::UserAgent;
use URI::Escape;
use Data::Util qw(:check :validate);

use Catmandu::AlephX::XPath::Helper qw(:all);

use Catmandu::AlephX::Op::ItemData;
use Catmandu::AlephX::Op::ReadItem;
use Catmandu::AlephX::Op::Find;
use Catmandu::AlephX::Op::FindDoc;
use Catmandu::AlephX::Op::Present;
use Catmandu::AlephX::Op::IllLoanInfo;
use Catmandu::AlephX::Op::IllGetDocShort;
use Catmandu::AlephX::Op::BorAuth;
use Catmandu::AlephX::Op::BorInfo;
use Catmandu::AlephX::Op::IllBorInfo;

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
  warn $self->url."?$query";
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
    for my $item(@{ $item_data->items() }){
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
  Catmandu::AlephX::Op::ItemData->parse(xpath($res->content_ref()));    
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
  Catmandu::AlephX::Op::ReadItem->parse(xpath($res->content_ref()));    
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

=head3 arguments

  request - search request
  adjacent - if 'Y' then the documents should contain all the search words adjacent to each other, otherwise 'N'
=cut
sub find {
  my($self,%args)=@_;
  $args{op} = 'find';
  my $res = $self->_do_web_request(\%args);
  Catmandu::AlephX::Op::Find->parse(xpath($res->content_ref()));    
}

=head2 find_doc

=head3 documentation from AlephX
  
  This service retrieves the OAI XML format of an expanded document as given by the user.

=head3 example

  my $find = $aleph->find_doc(base=>'rug01',doc_num=>'000000444',format=>'marc');
  if($find->is_success){
    for my $record(@{ $find->records }){
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
  Catmandu::AlephX::Op::FindDoc->parse(xpath($res->content_ref()));    
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
  Catmandu::AlephX::Op::Present->parse(xpath($res->content_ref()));    
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
  Catmandu::AlephX::Op::IllGetDocShort->parse(xpath($res->content_ref()));    
}
=head2 bor_auth

=head3 documentation from Aleph X

  This service retrieves the Global record (Z303), Local record (Z305) and the Data record (Z304) for a given Patron if the given ID and verification code match.
  Otherwise, an error message is returned.

=head3 example

  my %args = (
    library => $library,
    bor_id => $bor_id,
    verification => $verification
  );
  my $auth = $aleph->bor_auth(%args);

  if($auth->is_success){

    for my $type(qw(z303 z304 z305)){
      say "$type:";
      my $data = $auth->$type();
      for my $key(keys %$data){
        say "\t$key : $data->{$key}->[0]";
      }
    }

  }else{
    say STDERR "error: ".$auth->error;
    exit 1;
  }

=cut
sub bor_auth {
  my($self,%args)=@_;
  $args{op} = 'bor-auth';
  my $res = $self->_do_web_request(\%args);
  Catmandu::AlephX::Op::BorAuth->parse(xpath($res->content_ref()));
} 
=head2 bor_info

=head3 documentation from Aleph X

  This service retrieves all information related to a given Patron: Global and Local records, Loan records, Loaned items records, Short doc record, Cash record, and so on, if the ID and verification code provided match.

  If not, an error message is returned. Since the bor-info X-Service retrieves a very large amount of data, and not all of it may be relevant, you can choose to receive a part of the data, based on your needs.

=head3 example
    
  my %args = (
    library => $library,
    bor_id => $bor_id,
    verification => $verification,
    loans => 'P'
  );
  my $info = $aleph->bor_info(%args);

  if($info->is_success){

    for my $type(qw(z303 z304 z305)){
      say "$type:";
      my $data = $info->$type();
      for my $key(keys %$data){
        say "\t$key : $data->{$key}->[0]";
      }
    }
    say "fine:";
    for my $fine(@{ $info->fine() }){
      for my $type(qw(z13 z30 z31)){
        say "\t$type:";
        my $data = $fine->{$type}->[0];
        for my $key(keys %$data){
          say "\t\t$key : $data->{$key}->[0]";
        }
      }
    }

  }else{
    say STDERR "error: ".$info->error;
    exit 1;
  }

=cut
sub bor_info {
  my($self,%args)=@_;
  $args{op} = 'bor-info';
  my $res = $self->_do_web_request(\%args);
  Catmandu::AlephX::Op::BorInfo->parse(xpath($res->content_ref()));
}

=head2 ill_bor_info

=head3 documentation from Aleph X

  This service retrieves Z303, Z304, Z305 and Z308 records for a given borrower ID / barcode.

=head3 example

=cut
sub ill_bor_info {
  my($self,%args)=@_;
  $args{op} = 'ill-bor-info';
  my $res = $self->_do_web_request(\%args);
  Catmandu::AlephX::Op::IllBorInfo->parse(xpath($res->content_ref()));
}

sub ill_loan_info {
  my($self,%args)=@_;
  $args{'op'} = "ill-loan-info";
  my $res = $self->_do_web_request(\%args);
  Catmandu::AlephX::Op::IllLoanInfo->parse(xpath($res->content_ref()));
}

=head1 AUTHOR

Nicolas Franck, C<< <nicolas.franck at ugent.be> >>

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 AUTHOR

Patrick Hochstenbach, C<< <patrick dot hochstenbach at ugent dot be> >>

=cut
1;
