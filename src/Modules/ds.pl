#
# ds.pl: ds headline retrival
#    Modified: dms
#   Licensing: Artistic License (as perl itself)

package ds;

use strict;

sub ds::dsParse {
    my @list;

    foreach (@_) {
        next unless (/<br(.*?)<\/br>/);
        my $title = $1;
        $title =~ s/&amp\;/&/g;
        push( @list, $title );
    }

    return @list;
}

sub ds::ds {
    my $searchstring = shift;
    my @results = &::getURL("http://arreyder.com:9080/docsearch/select?q=$searchstring&qt=dismax2&rows=100&wt=xslt&tr=result.xslt");
    my $retval  = "i could not get the results.";

    if ( scalar @results ) {
        my $prefix = 'ds results ';
        my @list   = &dsParse(@results);
        $retval = &::formListReply( 0, $prefix, @list );
    }

    &::performStrictReply($retval);
}

sub ds::dsAnnounce {
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
