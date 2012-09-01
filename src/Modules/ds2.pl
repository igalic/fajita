#
# ds.pl: ds headline retrival
#      Author: Chris Tessone <tessone@imsa.edu>
#    Modified: dms
#   Licensing: Artistic License (as perl itself)
#     Version: v0.4 (19991125)
#

###
# fixed up to use XML'd /. backdoor 7/31 by richardh@rahga.com
# My only request if this gets included in infobot is that the
# other header gets trimmed to 2 lines, dump the fluff ;) -rah
#
# added a status message so people know to install LWP - oznoid
# also simplified the return code because it wasn't working.
###

package ds;

use strict;

sub dsParse {
    my @list;

    foreach (@_) {
        next unless (/<br(.*?)<\/br>/);
        my $title = $1;
        $title =~ s/&amp\;/&/g;
        push( @list, $title );
    }

    return @list;
}

sub ds {
    $searchstring = shift;
    my @results =
&::getURL("http://arreyder.com:9080/docsearch/select?q=$searchstring&qt=dismax2&rows=100&wt=xslt&tr=result.xslt");
    my $retval  = "i could not get the headlines.";

    if ( scalar @results ) {
        my $prefix = 'ds results ';
        my @list   = &dsParse(@results);
        $retval = &::formListReply( 0, $prefix, @list );
    }

    &::performStrictReply($retval);
}

sub dsAnnounce {
    my $file = "$::param{tempDir}/ds.xml";

    my @Cxml = &::getURL("http://ds.org/ds.xml");
    if ( !scalar @Cxml ) {
        &::DEBUG("sdA: failure (Cxml == NULL).");
        return;
    }

    if ( !-e $file ) {    # first time run.
        open( OUT, ">$file" );
        foreach (@Cxml) {
            print OUT "$_\n";
        }
        close OUT;

        return;
    }

    my @Oxml;
    open( IN, $file );
    while (<IN>) {
        chop;
        push( @Oxml, $_ );
    }
    close IN;

    my @Chl = &dsParse(@Cxml);
    my @Ohl = &dsParse(@Oxml);

    my @new;
    foreach (@Chl) {
        last if ( $_ eq $Ohl[0] );
        push( @new, $_ );
    }

    if ( scalar @new == 0 ) {
        &::status("ds: no results.");
        return;
    }

    if ( scalar @new == scalar @Chl ) {
        &::DEBUG("sdA: scalar(new) == scalar(Chl). bad?");
    }

    open( OUT, ">$file" );
    foreach (@Cxml) {
        print OUT "$_\n";
    }
    close OUT;

    return "ds: foo"
      . join( " \002::\002 ", @new );
}

1;

# vim:ts=4:sw=4:expandtab:tw=80
