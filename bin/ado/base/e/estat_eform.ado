*! version 1.1.0  03feb2017
program estat_eform
	version 13

	syntax [anything(name=eqlist)] [, *]

	_get_diopts diopts efopts, `options'
	_check_eformopt `e(cmd)', eformopts(`efopts')
	local eform `"`s(eform)'"'
	if `"`eform'"' == "" {
		local eform eform
	}

	if "`eqlist'" == "" {
		if inlist("`e(cmd)'", "mlogit", "mprobit") {
			_ms_eq_info
			local neq = r(k_eq)
			forval i = 1/`neq' {
				if `i' != e(ibaseout) {
					local eqlist `eqlist' #`i'
				}
			}
		}
		else {
			local eqlist "#1"
		}
	}

	tempname eb eV b V Vi ehold
	matrix `eb' = e(b)
	matrix `eV' = e(V)

	foreach eq of local eqlist {
		matrix `b' = nullmat(`b'), `eb'[1,`"`eq':"']
	}
	local dim = colsof(`b')
	matrix `V' = J(`dim', `dim', 0)
	local pos 1
	foreach eq of local eqlist {
		matrix `Vi' = `eV'[`"`eq':"',`"`eq':"']
		matrix `V'[`pos',`pos'] = `Vi'
		local pos = `pos' + colsof(`Vi')
	}
	if inlist("gsem", "`e(cmd)'", "`e(cmd2)'") {
		local eqna : coleq `b'
		local eqna : subinstr local eqna "b." ".", all
		matrix coleq `b' = `eqna'
	}

	_est hold `ehold' , restore
	matrix colna `V' = `:colfu `b''
	matrix rowna `V' = `:colfu `b''
	PostIt `b' `V'

	_coef_table, `eform' `diopts'
end

program PostIt, eclass
	ereturn post `1' `2'
	_ms_eq_info
	if r(k_eq) == 1 {
		local depvar : coleq e(b)
		local depvar : list uniq depvar
		ereturn local depvar `depvar'
	}
	ereturn scalar k_eform = r(k_eq)
end

exit
