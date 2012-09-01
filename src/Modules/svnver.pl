
use strict;
package svnver;


sub scan(&$$) {
    my ($callback,$message,$who,$svnver,$svnlog) = @_;


	if($message=~/^\svnver$/i) { 
   	    if (&::IsFlag("m")) {

            $svnlog=`svn log /home/fajita/infobot -r BASE`;

	    $callback->($svnlog);
	    return 'NOREPLY';

       }  
       }

 return undef;
}

return "svnver";
