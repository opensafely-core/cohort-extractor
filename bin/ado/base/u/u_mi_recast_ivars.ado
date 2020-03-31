*! version 1.0.0  10mar2009

/*
	u_mi_recast_ivars [float|double]

	Recast integer _dta[_mi_ivars] to be of the designated type.
	If not specified, then recast to float if c(type) != double, 
	otherwise to float or, if long, to double.

	Original types of variables determined by m=0.

	This routine recasts m=0 and well as m>0.
*/

program u_mi_recast_ivars
	args totype

	if ("`_dta[_mi_ivars]'"=="") {
		exit
	}

	if ("`totype'"=="") {
		local totype = ("`c(type)'"=="double", "double", "float")
	}

	recast_`_dta[_mi_style]' `totype'

end

program recast_wide
	args totype

	mata: set_desired_types("`totype'")	/* defines t1, t2, ... */

	local ivars `_dta[_mi_ivars]'
	local M     `_dta[_mi_M]'

	quietly { 
		local i 0
		foreach v of local ivars {
			_recast `t`++i'' `v'
		}
		forvalues m=1(1)`M' {
			local i 0
			foreach v of local ivars {
				_recast `t`++i'' _`m'_`v'
			}
		}
	}
end

program recast_mlong
	args totype
	recast_flong `totype'

end

program recast_flong
	args totype

	mata: set_desired_types("`totype'")	/* defines t1, t2, ... */

	local ivars `_dta[_mi_ivars]'

	quietly {
		local i 0
		foreach v of local ivars {
			_recast `t`++i'' `v'
		}
	}
end

program recast_flongsep
	args totype

	mata: set_desired_types("`totype'")	/* defines t1, t2, ... */

	local ivars `_dta[_mi_ivars]'
	local M     `_dta[_mi_M]'
	local name  `_dta[_mi_name]'

	nobreak quietly { 
		local i 0
		foreach v of local ivars {
			_recast `t`++i'' `v'
		}
		save `name', replace
		forvalues m=1(1)`M' {
			use _`m'_`name', clear 
			local i 0
			foreach v of local ivars {
				_recast `t`++i'' `v'
			}
			save _`m'_`name', replace
		}
		use `name', clear 
	}
end

version 11
mata:
void set_desired_types(string scalar totype)
{
	real scalar		i, n
	string rowvector	ivars
	string scalar		t

	ivars = tokens(st_global("_dta[_mi_ivars]"))
	if ((n=length(ivars))==0) return

	if (totype=="double") {
		for (i=1; i<=n; i++) {
			st_local(sprintf("t%g", i), "double")
		}
	}
	else {
		for (i=1; i<=n; i++) {
			t = st_vartype(ivars[i])
			st_local(sprintf("t%g", i), 
				(t=="long" | t=="double" ? "double" : "float"))
		}
	}
}
end
