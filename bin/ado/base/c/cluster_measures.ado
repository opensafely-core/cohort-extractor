*! version 1.0.3  21sep2010
program define cluster_measures, rclass
	version 7, missing

	syntax varlist(numeric) [if] [in] , COMPare(numlist >=1 int) /*
			*/ GENerate(string) [ PROPVars PROPCompares * ]

	marksample touse

	local ncomp : word count `compare'
	local ngen  : word count `generate'
	if `ngen' != `ncomp' {
		di as err "{p}need the same number of compare() arguments as"
		di as err "generate() arguments{p_end}"
		exit 198
	}

	confirm new variable `generate'

	foreach x of local compare {
		if `x' > _N {
			di as err "{p}compare() arguments must be between 1"
			di as err "and the number of observations{p_end}"
			exit 125
		}
	}

	if trim(`"`options'"') == "" {
		local options L2
	}
	cluster parsedistance `options'
	local dist `s(dist)'`s(darg)'
	local dtype `s(dtype)'
	local dbinary `s(binary)'

	if `"`dist'"' == "Gower" {
		if "`propvars'" != "" {
			di as err "propvars not allowed with Gower"
			exit 198
		}
		if "`propcompares'" != "" {
			di as err "propcompares not allowed with Gower"
			exit 198
		}
	}

	forvalues i = 1/`ngen' {
		local vardone 0
		local gvar : word `i' of `generate'
		local cnum : word `i' of `compare'

		/* check if comparison obs #cnum has any missings.  If so
		   then generate missings as answer */
		foreach var of local varlist {
			if missing(`var'[`cnum']) {
				gen byte `gvar' = .
				local vardone 1
				continue, break
			}
		}

		if `vardone' == 0 {
			_cluster `varlist' if `touse', computemeasures /*
				*/ generate(`gvar') compare(`cnum') /*
				*/ `propvars' `propcompares' `dist'
			qui compress `gvar'
		}

	}

	ret local distance `dist'
	ret local dtype `dtype'
	ret local binary `binary'
	ret local compare `compare'
	ret local generate `generate'

end
