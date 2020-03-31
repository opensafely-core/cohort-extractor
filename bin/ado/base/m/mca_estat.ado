*! version 1.0.5  20jan2015
program mca_estat
	version 10

	if "`e(cmd)'" != "mca" {
		error 301
	}

	gettoken key args : 0, parse(" ,")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("coordinates",1,max(2,`lkey')) {
		Coordinates `args'
	}
	else if `"`key'"' == bsubstr("subinertia",1,max(3,`lkey')) {
		// override default handler
		Subinertia `args'
	}
	else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		// override default handler
		Summarize `args'
	}
	else {
		estat_default `0'
	}
end

// ---------------------------------------------------------------- Coordinates

program Coordinates, rclass
	//                                                       * undocumented
	syntax  [anything] [, NORMalize(str) STats FORmat(passthru) *]
	local matlist_opts `options'
	
	if "`anything'" != "" {
		foreach name of local anything {
			local 0 `name'
			capture syntax varlist(numeric)
			if _rc == 0 {
				local mynamelist `mynamelist' `varlist'
			}
			else {
				local mynamelist `mynamelist' `name'
			}
		}
		foreach name of local mynamelist {
			mca_lookup "`name'" "`e(names)'"
			local enamelist `enamelist' `s(name)'
		}
		local namelist: list uniq enamelist
	}	
	
	if "`normalize'" != "" {
		mca_parse_normalize `"`normalize'"'
		local norm `s(norm)'
	}
	else 	local norm `e(norm)'

	tempname C X
	if "`norm'" == "principal" {
		matrix `C' = e(F)
	}
	else	matrix `C' = e(A)
	
	if "`stats'" != "" {
		local and "statistics and "
		matrix `C' = (e(cMass),e(cDist),e(cInertia),`C')
	}	

	if "`namelist'" != "" { 	
		tempname Ci CS
		foreach name of local namelist {
			matrix `Ci' = `C'["`name':",.]
			matrix `CS' = nullmat(`CS') \ `Ci'
		}
	}
	else {
		local namelist `e(names)'
		local CS `C'
	}	

	// displays missings as blanks, using the nodotz option of matlist
	matrix `X' = `CS'
	mata: st_replacematrix("`X'",editmissing(st_matrix("`X'"),.z))

	dis _n as txt "Column `and'`norm' coordinates"
	matlist `X', border left(4) rowtitle(Categories) ///
	   `format' `matlist_opts' nodotz

	if "`e(supp)'" != "" {
		local supp `e(supp)'
		local supp : list namelist & supp
		local nsupp : word count `supp'
		if `nsupp' > 0 {
			local vars = plural(`nsupp',"variable")
			dis as txt "{p 5 7 2}supplementary `vars': `supp'{p_end}"
		}	
	}
	dis

	if "`stats'" == "" { 	
		return matrix Coord = `CS'
	}
	else { 	
		matrix `X' = `CS'[.,1..3]
		return matrix Stats = `X'
	
		matrix `X' = `CS'[.,4...]
		return matrix Coord = `X'
	}	
	return local  norm    "`norm'"
end

// ----------------------------------------------------------------- Subinertia

program Subinertia, rclass
	// options undocumented
	syntax [, * ]
	local matlist_opts `options'
	
	if "`e(inertia_sub)'" != "matrix" {
		dis as txt ///
      "(subinertias only available if method(joint) was specified to {cmd:mca})"
		exit
	}
	tempname subin
	mat `subin' = e(inertia_sub)
	dis _n as txt ///
	    "Subinertias: decomposition of total inertia"
	matlist `subin', ///
	    border left(4) rowtitle(Variable) `matlist_opts'
	return matrix inertia_sub = `subin'
end

// ------------------------------------------------------------------ Summarize

program Summarize
	// undocumented: varlist(), Analysis is a synonym for Crossed
	syntax [, VARlist(str) Crossed Analysis * ]
	local summ_opts `options'

	if `"`analysis'"' != "" {
		local crossed crossed
	}

	if `"`varlist'"' != "" {
		dis as err "option varlist() not valid"
		exit 198
	}
	
	if "`crossed'" == "" {
		// raw/crossing variables
		if `e(crossed)' == 0 {
			local defs `e(defs)'
			local summspec : subinstr local defs "/" "", all
		}
		else {
			local defs  `e(defs)'
			local names `e(names)'
			
			gettoken def defs: defs, parse("/")
			local i = 1
			foreach name of local names {
				if trim("`def'") == "`name'" {
					local sp (mcavar`i' :`name')
				}
				else	local sp (`name' : `def')
				local summspec `summspec' `sp'
				
				gettoken tok defs: defs, parse("/")
				// assert "`tok'" == "/"
				gettoken def defs: defs, parse("/")
				local ++i
			}
		}
		estat_summ `summspec', `summ_opts' misswarning	
	}
	else {
		// crossed variables
		local names `e(names)'
		local k : word count `names'
		
		// we use non temporary variables
		// be sure that names are not used, and vars are removed
		forvalues i = 1/`k' {
			capture confirm new var mcavar`i'
			if _rc {
				dis as err "variable mcavar`i' already exists"
				exit 198
			}	
			local mcalist `mcalist' mcavar`i'
		}	
		capture noisily {
			SummCrossed `"`summ_opts'"'
		}	
		forvalues i = 1/`k' {
			capture drop mcavar`i'
		}	
	}
end

program SummCrossed
	args summ_opts

	tempname C
	local defs  `e(defs)'
	local names `e(names)'
	local k : word count `names'
	
	gettoken def defs: defs, parse("/")
	local i = 1
	foreach name of local names {
		matrix `C' = e(Coding`i')
		qui _applycoding mcavar`i' if e(sample), coding(`C') `e(missing)'
		if r(unusedcodes) > 0 {
		   dis as txt "(unused codes for `name' in current data)"
		}			
		if r(uncodedobs) > 0 {
		   dis as txt "(uncodable values for `name' in current data)"
		}	
		local mcalist `mcalist' mcavar`i'
		
		gettoken tok defs: defs, parse("/")
		gettoken def defs: defs, parse("/")
		local ++i
	}
	
	estat_summ `mcalist', `summ_opts'
	dis as txt "  MCA analysis variables are coded 1,2,3,..."
end

exit
