*! version 1.0.2  02feb2015
program u_mi_impute_difvheader
	version 12
	args varlist

	if ("`varlist'"=="") exit

	gettoken fvvar varlist : varlist
	while ("`fvvar'"!="") {
		local vname = abbrev("`fvvar'", 12)
		local pos = 12 - udstrlen("`vname'")
		local vchar : char `fvvar'[fvrevar]
		if ("`vchar'"=="") { //terms omitted with o.
			local vchar : char `fvvar'[tsrevar]
		}
		di as txt "{p `pos' 15 2}`vname': " ///
		   as res `"`vchar'{p_end}"'
		gettoken fvvar varlist : varlist
	}
end
