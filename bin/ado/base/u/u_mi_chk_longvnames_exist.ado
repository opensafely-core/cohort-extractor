*! version 1.0.0  23jan2015
program u_mi_chk_longvnames_exist
	version 14
	args cmd style M

	if ("`M'"=="") {
		local M	    `_dta[_mi_M]'
	}
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'

	local vlen = `c(namelenchar)'
	local maxlen = `vlen'-3
	if ("`style'"=="wide") {
		local maxlen = `maxlen'-strlen("`M'")+1
		local err "  In the wide style, variable names are restricted"
		local err `"`err' to {bind:`vlen' - strlen("`M'") - 2 = `maxlen'}"'
		local err `"`err' for M=`M' `=plural(`M',"imputation")'.  "'
	}

	foreach v of local ivars {
		if (ustrlen("`v'") > `maxlen') {
		      _longvnameserr "`cmd'" "`v'" "imputed" "`style'" `"`err'"'
		}
	}
	foreach v of local pvars {
		if (ustrlen("`v'") > `maxlen') {
		      _longvnameserr "`cmd'" "`v'" "passive" "`style'" `"`err'"'
		}
	}
	if ("`style'"=="flongsep") {
		foreach v of local rvars {
			if (ustrlen("_0_`v'") > `vlen') {
			       _longvnameserr "`cmd'" "`v'" "regular" "flongsep"
			}
		}
	}
end

program _longvnameserr
	args cmdname var vtype style err

	if ("`cmdname'"!="") {
		local dicmd "{bf:`cmdname'}: "
	}
	if (`"`err'"'=="") {
		local err "  "
	}
	di as err "`dicmd'long variable names detected"
	di as err "{p 4 4 2} Variable {bf:`var'} is registered as `vtype'"
	di as err "and contains more than 29 characters.  This is not allowed"
	di as err `"in style `style'.`err'Use {helpb mi rename} to rename this"'
	di as err "variable to have a shorter name.{p_end}"
	exit 198
end
