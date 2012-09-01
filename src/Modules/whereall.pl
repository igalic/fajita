# context 
#blame arreyder
use strict;
package whereall;

BEGIN {
  eval "use LWP::UserAgent";
  eval "use XML::XPath";
  eval "use XML::XPath::XMLParser";
}

sub scan(&$$) {
  my ($callback,$message,$who) = @_;
  my $searchstring;
  my $reply;
  my @RESULTS;
  my $result;
  my $i;
 
  if($message=~/^(.*)\swhereall$/ && &::IsFlag("d")) {
    #print "We matched!\n";
    $searchstring=lc($1);
    $searchstring=~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
    my $ua = new LWP::UserAgent;
    $ua->timeout(10);
    my $request = new HTTP::Request('GET', "http://arreyder.com:8983/solr/select?q=$searchstring&qt=dismaxwhereall&rows=10");
    my $response = $ua->request($request);
    if (!$response->is_success) {
      #return "Something failed in connecting to the SOLR web server. Try again later.";
    }
    my $content = $response->content;
    my $xpath = XML::XPath->new("$content");
    my $nodeset = $xpath->find("/response/result/doc/arr[\@name='ds-name']/str");
    foreach my $node ( $nodeset->get_nodelist ) {
      push(@RESULTS,XML::XPath::XMLParser::as_string( $node ));
    }
    if (@RESULTS != 0){
      foreach (@RESULTS){
        $_=~m/\<str\>(.*)\<\/str>/;
        $reply=$reply." $1";
	}
	}
    else  {
      $reply="Sorry, no matches for: ".$searchstring.".\n";
      $callback->($reply);
      return 1;
    }
    $reply = "First 100 matches of directives will work in the context of $searchstring: ".$reply."\n";
    $callback->($reply);
    #print "$searchstring may be used in these contexts: $reply |\n";
   return 1;
  }
  
  return undef;
}
 return "whereall";
__END__

=head1 NAME

Filename.pm - Description

=head1 PREREQUISITES

Some::Module

=head1 PARAMETERS

switchname

=over 4

=item value1

Description

=item value2

Description

=back

=head1 PUBLIC INTERFACE

Here you put how you call your sub from the bot user's point of view

=head1 DESCRIPTION

What is it?

=head1 AUTHORS

arreyder
