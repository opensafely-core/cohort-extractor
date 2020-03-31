*! version 1.0.3  09sep2019
program define matalabel
	version 9

	global T_matalabel_restore
	capture noisily Matalabel_u `0'
	local rc = _rc
	nobreak {
		if "$T_matalabel_restore" != "" {
			restore
		}
	}
	exit `rc'
end

program define Matalabel_u, rclass
	syntax [anything(name=lablist)] [using/] ///
		[, Var] GENerate(namelist min=3 max=3)

	tokenize `generate'
	local lname `1'
	local value `2'
	local label `3'

	if `"`lablist'"' == "" | `"`lablist'"' == "_all" {
		local lablist  	/* *all* value labels */
	}
	else {
		capture noi confirm name `lablist'
		if _rc {
			exit 198
		}
	}

	if `"`using'"' != "" {
		preserve
		global T_matalabel_restore TRUE
		quietly {
			drop _all
			label drop _all
			use `"`using'"', clear
		}
	}

	if "`lablist'" != "" {
		quietly label list `lablist'	/* verify labels exists	*/
	}
	else {
		quietly label dir
		local lablist `r(names)'
	}

	if "`var'" != "" {
		capt label language
		if _rc==198 {
			local olns
		}
		else {
			local lns `r(languages)'
			local cln `r(language)'
			local olns : list lns - cln
		}

		foreach v of varlist _all {
			capt local vt : value label `v'
			if "`vt'" != "" & `:list vt in lablist' {
				return local `vt' `return(`vt')' `v'
			}

			foreach ln of local olns {
				capt local vt : char `v'[_lang_l_`ln']
				if "`vt'" != "" & `:list vt in lablist' {
					return local `vt'_`ln' `return(`vt'_`ln')' `v'
				}
			}
		}

		// use awkward macro names to prevent name conflict with value labels
		return local __current_language__ `cln'
		return local __other_languages__  `olns'
		return local __labnames__         `lablist'
	}

	quietly {
		tempfile labfile
		label save `lablist' using `"`labfile'"'

		tempname fh

		capture mata: mata drop `lname' `value' `label'
		mata: `lname'=J(0,1,"")
		mata: `value'=J(0,1,.)
		mata: `label'=J(0,1,"")

		file open `fh' using `"`labfile'"', text read
		local i = 0
		file read `fh' line
		while r(eof)==0 {
			local ++i
			gettoken word    line : line // label
			gettoken word    line : line // define
			gettoken labname line : line
			gettoken lval    line : line
			gettoken ltext   line : line, parse(", ") match(paren)
			
			mata: `lname'=`lname'\("`labname'")
			mata: `value'=`value'\(`lval')
			mata: `label'=`label'\(`"`ltext'"')

		      	file read `fh' line
		}
		file close `fh'

		if `i'==0 {
			noi di as txt "(dataset has no value labels)"
			capture mata: mata drop `lname' `value' `label'
			return clear
			exit
		}
		mata: __matalabel_sort(`lname',`value',`label')
	}
	global T_matalabel_restore
end

version 9
mata:
void __matalabel_sort(string colvector lname, real colvector lvalue, string colvector llab)
{
	real colvector	o
	real colvector	newo
	real matrix	tc
	real scalar	i
	real scalar	j

	o = order(lname, 1)
	_collate(lname, o)
	_collate(lvalue, o)
	_collate(llab, o)
	newo=J(1,1,1)
	j=1
	for(i=2; i<=rows(o); i++) {
		if (lname[i,1] != lname[i-1,1]) {
			j++
		}
		newo=newo\j
	}

	tc = newo , lvalue
	tc = order(tc, (1,2))
	_collate(lname, tc)
	_collate(lvalue, tc)
	_collate(llab, tc)
}
end

exit
