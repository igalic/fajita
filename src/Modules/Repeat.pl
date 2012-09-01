#!/usr/bin/perl

# Exchange.pl - currency exchange 'module'
#
# Last update: 990818 08:30:10, bobby@bofh.dk
# 20021111 Tim Riker <Tim@Rikers.org>
#

package Exchange;
use strict;

my ($chan) = "#apache"

use Schedule::Cron;

  # Subroutines to be called
  sub dispatcher { 
    print "ID:   ",shift,"\n"; 
    print "Args: ","@_","\n";
  }




sub announce {
    my ($message) = "This is #apache - This channel is not intended to support the Apache Web Server";
    &msg( $chan, $message );
    return;
}




# Create new object with default dispatcher
my $cron = new Schedule::Cron(\&dispatcher);

# Load a crontab file
$cron->load_crontab("/var/spool/cron/perl");

# Add dynamically  crontab entries
$cron->add_entry("*/1 * * * *",\&announce);

# Run scheduler 
$cron->run(detach=>1);
                   




