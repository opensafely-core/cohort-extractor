*! version 1.0.0  23jan2015
program u_mi_chk_longvnames

	version 14
	args vars cmdname nocheck vtype

	if ("`nocheck'"!="") exit

	local style	`_dta[_mi_style]'
	local M		`_dta[_mi_M]'

	local vlen = `c(namelenchar)'	
	local maxlen = `vlen'-3
	if ("`style'"=="wide") {
		local maxlen = `maxlen'-strlen("`M'")+1
		local err "  In the wide style, variable names are restricted"
		local err `"`err' to {bind:`vlen' - strlen("`M'") - 2 = `maxlen'}"'
		local err `"`err' for M=`M' `=plural(`M',"imputation")'."'
	}

	mata: haslongvars(`maxlen',"`vars'", "haslong", "nvars")
	if (`haslong') {
		di as err "{p}{bf:`cmdname'}: long variable"
		di as err plural(`nvars', "name")
		di as err "detected{p_end}"
		di as err "{p 4 4 2}You specified"
		if (`nvars'>1) {
			di as err "names of `vtype' variables"
		}
		else {
			if ("`vtype'"=="imputation") {
				local article an
			}
			else {
				local article a
			}
			di as err "a name of `article' `vtype' variable"
		}
		di as err " containing more than `maxlen' characters.  This"
		di as err `"is not allowed.`err'"'
		di as err "{p_end}"
		exit 198
	}
end

mata:

void haslongvars(real scalar max, string scalar varlist, haslong, nvars)
{
	real scalar		nlong
	string rowvector	vars

	vars = tokens(varlist)
	nlong = sum(ustrlen(vars):>max)

	st_local(nvars, strofreal(nlong))
	st_local(haslong, strofreal(nlong!=0))
}
end
