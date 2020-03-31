*! version 1.1.3  13feb2015
program define _virf_fck, rclass
	version 8.0
	syntax anything(name=filename id="irf file name") /*
	*/ [, exact vrf ] 
/* exact is undocumented */	

/* anything passes in string asis so quoted filenames with space will pass
 * this test
 */
 	local words : word count `filename'
	if `words' > 1 {
		di as error `"`filename' is not a valid filename"'
		exit 198
	}	
/* anything passes in string asis so use local assignment to rip
 * off any quotes
 */
	local filename `filename'

	cap noi local tmp = rtrim(`"`filename'"')
	if _rc > 0 {
		di as err `"specified irf filename is not a valid filename"'
		exit 198
	}	
/* now only filename is left so put on .vrf extension if necessary
 */

	local filename = rtrim(`"`filename'"')
	
	if "`exact'" == "" {

		if "`vrf'" != "" {
			local rfilename  = reverse(`"`filename'"')
			local ext = bsubstr(`"`rfilename'"',1,4)
			if `"`ext'"' != `"frv."' & `"`ext'"' != "fri." {
				local filename `"`filename'.vrf"'
			}
		}
		else {
			local rfilename  = reverse(`"`filename'"')
			local ext = bsubstr(`"`rfilename'"',1,4)
			if `"`ext'"' != `"fri."' & `"`ext'"' != "frv." {
				local filename `"`filename'.irf"'
			}
		}
	}
	ret local fname `"`filename'"'
end
exit

usage _virf_fck <filename>
	_virf_fck 
		i)   checks that <filename> is a legal filename
		ii)  adds ".irf" extension if this extension is not already
		     the last extension unless -vrf- is specified in which 
		     case it adds ".vrf" extension
		iii) returns the adjusted <filename> in the r(fname).  Note:
		     any outside quotes on <filename> have been stripped off
		     and r(fname) is not quoted.
		     
