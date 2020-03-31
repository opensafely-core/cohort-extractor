*! version 1.2.3  09feb2015

/*
	mi_cmd_genericset "<setcmd>" "<variables>" {na|reg|all}

	A generic set command is one such as -stset-, -xtset-, ..., such that

	    1.  It requires being run on m=0 
	    2.  It may create or drop chars _dta[*] or <varname>[*]
	    3.  It may generate or drop variables specified
	    4.  It may return results in r()

	The call for a generic set command is

		mi_genericset_u `"<command_and_args>"' "<variables>" na|reg|all

	Variables are the list of variable names that the command might
	create or drop.  The command is allowed to do both simultaneously.
	The list may be empty.  Variables specified are added/removed 
	from _dta[_mi_rvars] as necessary.

	na:  does not set individual variable characteristics
	reg: might set regular variable characteristics
	all: might set all     variable characteristics

*/

program mi_cmd_genericset, rclass
	version 11
	args cmd variables mightset

	u_mi_assert_set

	/* ------------------------------------------------------------ */
						/* simple case		*/
	if (`_dta[_mi_M]' == 0) {
		intersect todrop : "`variables'"
		mata: _parse_addoptions("cmd", "mi")
		`cmd'
		nobreak {
			return add
			intersect toadd : "`variables'"
			rm_from_rvars "`todrop'"
			add_to_rvars  "`toadd'"
		}
		exit
	}
	/* ------------------------------------------------------------ */

	local instance
	nobreak {
		mata: u_mi_get_mata_instanced_var("instance", "_mi_xyzset")
		capture noi break genericset_`_dta[_mi_style]'       ///
				`"`cmd'"' "`variables'" "`instance'" ///
				`mightset'
		local rc = _rc
		capture mata: mata drop `instance'
	}
	if !`rc' {
		return add
	}
	exit `rc'
end


program genericset_wide, rclass
	args cmd variables instance mightset

	intersect todrop : "`variables'"

	mata: _parse_addoptions("cmd", "mi")
	nobreak {
		break `cmd'
		return add
		intersect toadd : "`variables'"
		rm_from_rvars "`todrop'"
		add_to_rvars  "`toadd'"
		if ("`mightset'"=="all" | "`mightset'"=="reg") {
			local all "`_dta[_mi_ivars]' `_dta[_mi_pvars]'"
			mata: cpchars_wide("`all'", `_dta[_mi_M]')
		}
	}
end

program genericset_flong, rclass
	genericset_mlong `0'
	return add
end


program genericset_mlong, rclass
	args cmd variables instance mightset

	u_mi_certify_data, acceptable
	tempvar recnum myid
	sethowsorted sortedby `recnum'
	preserve 

	intersect todrop : "`variables'"

	quietly gen `:type _mi_id' `myid' = _mi_id
	local ivars "`_dta[_mi_ivars]'"
	local pvars "`_dta[_mi_pvars]'"
	quietly mi extract 0, clear 
	char _dta[_mi_ivars] "`ivars'"
	char _dta[_mi_pvars] "`pvars'"
	rename `myid' _mi_id
	mata: _parse_addoptions("cmd", "mi")
	`cmd'
	return add
	char _dta[_mi_ivars]
	char _dta[_mi_pvars]

	intersect toadd : "`variables'"
	rm_from_rvars "`todrop'"
	add_to_rvars  "`toadd'"

	mata: u_mi_cpchars_get(`instance')

	if ("`toadd'" != "") {
		tempfile addedvars
		sort _mi_id
		keep _mi_id `toadd'
		qui save "`addedvars'"
		restore, preserve
		mydrop `todrop'
		sort _mi_id
		qui merge m:1 _mi_id using "`addedvars'", ///
					nogen assert(match) sorted
		u_mi_sortback `sortedby' `recnum'
		drop `recnum'
	}
	else {
		restore, preserve
		mydrop `todrop'
	}
	mata: u_mi_cpchars_put(`instance', 2)
	restore, not
end


program genericset_flongsep, rclass
	args cmd variables instance mightset

	u_mi_certify_data, acceptable proper
	local M     `_dta[_mi_M]'
	local name `_dta[_mi_name]'

	preserve

	intersect todrop : "`variables'"
	mata: _parse_addoptions("cmd", "mi")
	`cmd'
	return add
	intersect toadd : "`variables'"

	nobreak {
		rm_from_rvars "`todrop'"
		add_to_rvars  "`toadd'"
		mata: u_mi_cpchars_get(`instance')
		qui save `name', replace
		
		local hastoadd 0
		if ("`toadd'"!="") {
			tempvar recnum
			sethowsorted sortedby `recnum'

			tempfile addedvars
			keep _mi_id `recnum' `toadd'
			sort _mi_id 
			qui save "`addedvars'"
			local hastoadd 1
		}
		forvalues m=1(1)`M' {
			qui use _`m'_`name', clear 
			mydrop `todrop'
			if (`hastoadd') {
				sort _mi_id
				qui merge 1:1 _mi_id using "`addedvars'", ///
						nogen sorted assert(match)
				u_mi_sortback `sortedby' `recnum'
				drop `recnum'
			}
			mata: u_mi_cpchars_put(`instance', 2)
			qui save _`m'_`name', replace
		}
		use "`name'", clear 
	}
	restore, not
end

/* -------------------------------------------------------------------- */
						/* utilities		*/

program add_to_rvars
	args variables

	local regular `_dta[_mi_rvars]'
	local regular : list regular | variables
	char _dta[_mi_rvars] `regular'
end

program rm_from_rvars
	args variables

	local regular `_dta[_mi_rvars]'
	local regular : list regular - variables
	char _dta[_mi_rvars] `regular'
end

program intersect 
	args macname  colon  variables 

	local intersect
	foreach v of local variables {
		capture novarabbrev confirm var `v'
		if (_rc==0) {
			local intersect `intersect' `v'
		}
	}
	c_local `macname' `intersect'
end

program sethowsorted
	args macname recnum
	quietly {
		gen `c(obs_t)' `recnum' = _n
		compress `recnum'
	}
	local sortedby : sortedby
	c_local `macname' `sortedby'
end


program mydrop 
	if ("`0'" != "") {
		drop `0'
	}
end


version 11

local RS	real scalar
local SS	string scalar
local SC	string colvector
local SR	string rowvector

mata:
void cpchars_wide(`SS' uservars, `RS' M)
{
	`RS'	i, j, m
	`SS'	v, charval, charname
	`SR'	vars
	`SC'	charnames

	if (cols(vars = tokens(uservars))==0) return
	if (M==0) return
	for (i=1; i<=cols(vars); i++) {
		v = vars[i]
		for (m=1; m<=M; m++) delchars(sprintf("_%g_%s", m, v))

		charnames = st_dir("char", v, "*", 0)
		for (j=1; j<=rows(charnames); j++) {
			charname = charnames[j]
			charval  = st_global(sprintf("%s[%s]", v, charname))
			for (m=1; m<=M; m++) {
				st_global(sprintf("_%g_%s[%s]", m, v, charname),
								charval)
			}
		}
	}
}
			
void delchars(`SS' v)
{
	`RS'	i
	`SS'	fcharnames

	fcharnames = st_dir("char", v, "*", 1)
	for (i=1; i<=rows(fcharnames); i++) st_global(fcharnames[i], "")
}


void getwidevars(`SS' macname)
{
	`SR'	var
	`SS'	varn
	`SR'	prefix, res
	`RS'	m, M, i, n, k

	M = strtoreal(st_global("_dta[_mi_M]"))
	if (M==0 | M>=.) {
		st_local(macname, "")
		return
	}

	var = tokens(st_global("_dta[_mi_ivars]") + " " + 
		     st_global("_dta[_mi_pvars]"))
	if ((n=length(var))==0) {
		st_local(macname, "")
		return
	}

	prefix = J(1, M, "")
	for (m=1; m<=M; m++)  prefix[m] = sprintf("_%g_", m)


	k   = 0
	res = J(1, n*m, "")
	for (i=1; i<=n; i++) { 
		varn = var[i]
		for (m=1; m<=M; m++) res[++k] = prefix[m] + varn
	}

	st_local(macname, invtokens(res))
}
end
