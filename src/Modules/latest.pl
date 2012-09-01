# latest 
# arreyder
use strict;
package latest;

BEGIN {
  eval "use LWP::UserAgent";
}

sub scan(&$$) {
  my ($callback,$message,$who) = @_;
  my $results;
  my @RELEASES;
  my $reply;
  my $version;
  
  if($message=~m/^latest/) {
    my $ua = new LWP::UserAgent;
    $ua->timeout(10);
    my $request = new HTTP::Request('GET', "http://httpd.apache.org/");
    my $response = $ua->request($request);
    if (!$response->is_success) {
      	$reply = "Something failed in connecting to the web server. Try again later.";
      	return 1;	
    	}
    my $results = $response->content;
    @RELEASES= $results =~ m/Apache (.*) Released/g;
    foreach $version (@RELEASES) {
    	$reply = $reply."$version => http://www.apache.org/dist/httpd/httpd-$version.tar.bz2   ";
	print $_;
    	}
    $callback->($reply);
    return 1;
}
}
return "latest";

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
