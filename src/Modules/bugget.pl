# bugget 
# blame arreyder
use strict;
package bugget;

BEGIN {
 
  eval "use LWP::UserAgent";
  eval "use XML::XPath";
  eval "use XML::XPath::XMLParser";

}

sub scan(&$$) {
  my ($callback,$message,$who) = @_;
  my $searchstring;
  my @RESULTS;
  my $result;
  my $bugnum;
  my $title;
  my $reply;
  
  if($message=~m/(PR|pr)\#([0-9]+)/) {
    $bugnum=$2;
    my $ua = new LWP::UserAgent;
    $ua->timeout(10);
    my $request = new HTTP::Request('GET', "http://issues.apache.org/bugzilla/show_bug.cgi?id=$bugnum");
    my $response = $ua->request($request);
    if (!$response->is_success) {
      my $reply = "Something failed in connecting to the Bug List web server. Try again later.";
      return 1;	
    }
    my @RESULTS = $response->content;
    foreach (@RESULTS) {
    if ($_ =~ m/\<title\>(.*)\<\/title>/) {
    	if (!($1 =~ m/Invalid Bug ID/)){
    	my $reply = "$1 => http://issues.apache.org/bugzilla/show_bug.cgi?id=$bugnum";
    	&::performStrictReply($reply);
    	return 1;
    	}
    else {
    	my $reply = "Invalid Bug ID => $bugnum";
    	&::performStrictReply($reply);
	return 1;
    	}
    }
    my $reply = "Kernel Panic! IIIIIIIIIIIIIEEEEEEEEEEEEEEEEEEEE!!!!!!!";
    &::performStrictReply($reply);
    return 1;
  }
  
  return undef;
}
}
return "bugget";

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
