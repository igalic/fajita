
use strict;
package svnupdate;


sub scan(&$$) {
    my ($callback,$message,$who,$svnstatus,$svnlog,$svnmessage) = @_;


	if($message=~/^\@svnupdate$/i) { 
   	    if (&::IsFlag("z")) {


		$svnstatus=`svn update /export/home/fajita/bot`;
           	$svnlog=`svn log /export/home/fajita/bot -r HEAD`;

            $callback->($svnstatus);
            $callback->($svnlog);


	    $callback->($svnlog);
	    return 'NOREPLY';

       }  
       }

 return undef;
}

return "svnupdate";
