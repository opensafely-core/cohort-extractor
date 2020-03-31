*! version 1.0.2  05nov2002
program define varirf_dir
	version 8.0
	syntax [anything(id="directory" name=basedir)]
/* anything passes strings asis, 
 * local assignment clears quotes
 */	
 	local basedir `basedir'

	if `"`basedir'"' != "" {
/* second local clears leading and trailing spaces	
 */
	 	local basedir `basedir'
		ls `"`basedir'/*.vrf"'
		exit
	}
	else {
		ls *.vrf
	}	
end

exit

