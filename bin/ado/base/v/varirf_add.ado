*! version 1.1.0  08jul2004
program define varirf_add
	version 8.0

	gettoken tleft tright:0, parse(",")
	if "`tleft'" == "" | "`tleft'" == "," {
		di as err "no addlist specified"
		exit 198
	}	

	gettoken addlist 0:0 ,parse(",")
	syntax , using(string) [ exact ]	

/* exact is undocumented
 * it implies that the using(filename) is not checked for a .irf 
 * extension
 */	

	if "$S_vrffile" == "" {
		di as err "{p 3 3 3}no irf file active{p_end}"
		exit 198
	}	
	local tofile `"$S_vrffile"'
	
	_virf_fck `"`using'"' , `exact'
	local fromfile `"`r(fname)'"'

	capture confirm file `"`fromfile'"'
	local rc = _rc
	if `rc' == 601 & "`exact'" == "" {
		_virf_fck `"`using'"'  , vrf
		local fromfilevrf `"`r(fname)'"'
	
		capture confirm file `"`fromfilevrf'"'
		local rc2 = _rc
		if `rc2' == 601 {
			di as err `"file `fromfile' not found"'
			exit 601
		}
		else if `rc2' > 0 {
// should never get here but exit cleanly
			di as err `"file `fromfilevrf' not available"'
			exit `rc2'
		}
		local fromfile `"`fromfilevrf'"'
	}
	else if `rc' == 601 & "`exact'" != "" {
		di as err `"file `fromfile' not found"'
		exit 601
	}
	else if `rc' > 0 {
// should never get here but exit cleanly
		di as err `"file `fromfile' not available"'
		exit `rc'
	}

	local flist `"`addlist'"'

	local flist : subinstr local flist "_all" "" /*
		*/ , all word count(local allf)

	local err1 : subinstr local flist "==" "==", /*
			*/ count(local ecnt1) all
	if `ecnt1' > 0 {
		di as err "{p 3 3 3}`addlist' not valid{p_end}"
		exit 198
	}

	if `allf' > 1 {
		di as err "{p 3 3 3}_all may only appear once in "	/* 
			*/ "the add list{p_end}"
		exit 198
	}
	if `allf' == 1 {
		qui preserve
		_virf_use `"`fromfile'"' , one
		local all_list `r(irfnames)' 
		restore
	}	
	
	local hassomething = 0 
	while 1 {
		gettoken name flist : flist, parse(" =!@#$%^&*()-") 
		if `"`name'"'== "" {
			if `hassomething'==0 & "`all_list'" == "" { 
				di in red "{p 3 3 3}add list cannot "	/*
					*/ "be empty{p_end}"
				exit 198
			}
			if "`all_list'" == "" {
				_virf_add , fromfile(`"`fromfile'"' ,`exact') /*
					*/ newfile(`"`tofile'"') /*
					*/ oldirf(`oldnlist') /*
					*/ newirf(`newnlist') 
				exit
			}
			else {
				local flist `all_list'
				local all_list ""
				foreach irfn of local oldnlist {
					local flist : subinstr local flist /*
						*/ "`irfn'" "", word 
				}		
				local flist `flist'
			}	
		}
		local hassomething = 1 
		if "`name'" != "" {
			confirm name `name'
			_virf_nlen `name'
						/* name is oldname or 
						 * newname
						 */

			gettoken eq : flist, parse(" =!@#$%^&*()-") 
			if "`eq'" == "=" {
/* newname = oldname logic
 * name is now newname
 * and oldname is parsed below
 */
 
				gettoken eq flist : flist, /*
					*/ parse(" =!@#$%^&*()-") 
				gettoken oname flist : flist, /*
					*/ parse(" =!@#$%^&*()-") 
			
				confirm name `oname'
				_virf_nlen `oname'
/* need to check that
 * oname is not already
 * in oldnlist
 */

				local noput : subinstr local oldnlist /*
					*/ "`oname'" "`oname'" , word /*
					*/ count(local already_in)
				if `already_in' > 0 {
					di as err "{p 3 3 3}old name `oname' "/*
						*/ "is specified more than "/*
						*/ "once in `addlist'{p_end}"
					exit 198
				}	


				local oldnlist `oldnlist' `oname'
				local newnlist `newnlist' `name'
			}
			else {			

/* if here then name is 
 * oldname so check that name
 * is not already in 
 * oldnlist
 */
				local noput : subinstr local oldnlist /*
					*/ "`name'" "`name'" , word /*
					*/ count(local already_in)
				if `already_in' > 0 {
					di as err "{p 3 3 3}old name `name' "/*
						*/ "is specified more than "/*
						*/ "once in `addlist'{p_end}"
					exit 198
				}	

						/* oldname = oldname logic
						 * name parsed above is 
						 * oldname
						 */
				local oldnlist `oldnlist' `name'
				local newnlist `newnlist' `name'
			}
	
		}
	}	
end
exit

usage:
	syntax
	
	varirf_add <addlist> , using(irf filename) [ exact ]

	where

	<addel> := {
		_all | oldirfname[=newirfname] 
	}
	<addlist> := <addel> [<addlist>]

	varirf_add adds the specified irf's from the file specified in using 
        to the $S_vrffile specified by varirf_set.  
	
	The irfname (optionally) be changed.

	Specifying exact implies that the using option exactly specifies
        the file to be used.  In particular, a ".irf" extension should not
        be added to the using file if it is not already present.

