*! version 1.0.7  13feb2015
program caprojection, sortpreserve
	version 9.0

	if "`e(cmd)'" != "ca" {
		error 301
	}
	local md = `e(f)'

	syntax 								///
	[, 								///
		noROW noCOlumn 						///
		DIM(numlist integer >=1 <=`md' sort)			///
		FActors(numlist integer >=1 <=`md' sort) /// undocumented
		MAXlength(numlist integer max=1 >0 <32) 		///
		ALTernate						///
		ROWopts(string)						///
		COLopts(string)						///
		SCHEME(passthru)					///
		* 							///
	]

	if "`dim'" != "" & "`factors'" != "" {
		display as error "options dim() and factors() may not be combined"
		exit 198
	}
	else if "`factors'" != "" {
		local dim `factors'
	}

	if ("`row'" == "norow" & "`column'" == "nocolumn") {
		display as error	///
			"options norow and nocolumn may not be combined"
		exit 198
	}
	if ("`row'"    != "norow") local plots R
	if ("`column'" != "nocolumn") local plots `plots' C
	local nplots : list sizeof plots
	if `nplots' > 1 {
		local getcombine getcombine
	}

	_get_gropts , graphopts(`options') `getcombine'
	local goptions `"`s(graphopts)'"'
	local gcopts   `"`s(combineopts)'"'

	// Parse out row-suppopts and mlabpos
	local 0 , `rowopts'
	syntax , [SUPpopts(string) MLABPosition(string) MLABel(varname) *]
	local rowopts `options'
	local rsupp_opt `suppopts'
	local rmlabel `mlabel'
	if "`mlabposition'" != "" {
		local r_mlabpos `mlabposition'
	}
	else local r_mlabpos 9

	// Parse out column-suppopts and mlabpos
	local 0 , `colopts'
	syntax , [SUPpopts(string) MLABPosition(string) MLABel(varname) *]
	local colopts `options'
	local csupp_opt `suppopts'
	local cmlabel `mlabel'
	if "`mlabposition'" != "" {
		local c_mlabpos `mlabposition'
	}
	else local c_mlabpos 9

	if "`dim'" == "" {
		numlist "1/`md'"
		local dim `r(numlist)'
	}
	local ndim   : list sizeof dim
	local maxdim : word `ndim' of `dim'

	local xlow  : word 1 of `dim'
	local xhigh = `maxdim'
	local Xlow  = `xlow'  - 0.5
	local Xhigh = `xhigh' + 0.5
	if ("`maxlength'"  == "") local maxlength = 12

	foreach i of numlist `dim' {
		local xlab `xlab' `i' "`i'"
	}

	tempname RC SRC
	tempvar  Names SNames id
	
	local rn        `e(Rname)'
	local cn        `e(Cname)'		
	// e(sample) is only available after -ca- and NOT -camat-
	local e_function : e(functions)
	local e_function : subinstr local e_function "sample" "sample" , ///
		word count(local cnt)

	if ("`rmlabel'"!="" | "`cmlabel'"!="") & ("`e(ca_data)'"=="crossed") {
		dis as txt "(with crossed variable(s), option {opt mlabel()} ignored)"
		local rmlabel
		local cmlabel
	}	
		
	if "`rmlabel'" != "" | "`cmlabel'" != "" {
		if `cnt' == 0 {
			display as smcl ///
				"{cmd:e(sample)} not defined; "		///
				"option {opt mlabel()} ignored"
			local rmlabel
			local cmlabel
		}
	}
	
	
	if `cnt' == 0 {
		local donotsort true
	}
	if "`donotsort'" == "" {
		capture confirm variable `rn'
		if _rc local donotsort true
		capture confirm variable `cn'
		if _rc local donotsort true
	}
	if "`donotsort'" == "" {
		tempvar touse obs touse2
		quietly generate byte `touse' = -e(sample)
		quietly generate byte `touse2' = .
		quietly generate `c(obs_t)' `obs' = _n
	}
	if "`donotsort'" == "" {
		// The data used in the plot is basically a twoway tabulation 
		//	and therefore we need to verify that marker labels are
		//	consistent within each group (`rn' and `cn').	
		if "`rmlabel'" != "" {
			_ca_process_mlabel rmlabel : `rn' `rmlabel' `touse' row
			local rowopts `"`rowopts' `rmlabel'"'
		}
		if "`cmlabel'" != "" {
			_ca_process_mlabel cmlabel : `cn' `cmlabel' `touse' column
			local colopts `"`colopts' `cmlabel'"'
		}		
	}

	local vlist
	foreach wh of local plots {
		if "`donotsort'" == "" & "`wh'" == "R" {
			sort `touse' `rn' `obs'
			quietly by `touse' `rn' : 	///
				replace `touse2' = 1 if _n == 1 & `touse'
			sort `touse' `touse2' `rn' `obs'
		}
		if "`donotsort'" == "" & "`wh'" == "C" {
			sort `touse' `cn' `obs'
			quietly replace `touse2' = .
			quietly by `touse' `cn' : 	///
				replace `touse2' = 1 if _n == 1 & `touse'
			sort `touse' `touse2' `cn' `obs'
		}	
		matrix `RC' = e(T`wh')
		local names : rownames `RC'
		local np    = rowsof(`RC')
		if "`e(T`wh'_supp)'" == "matrix" {
			matrix `SRC' = e(T`wh'_supp)
			local np_supp = rowsof(`SRC')
			local Snames : rownames `SRC'
		}
		else {
			local np_supp = 0
		}
		local nps = max(`np', `np_supp')
		if `nps' > c(N) {
			preserve
			local restore restore
			quietly set obs `nps'
		}

		local vlist `Names' `SNames' `id'
		quietly generate  `Names'  = ""
		quietly generate  `SNames' = ""
		quietly generate  `id' = _n
		forvalues i = 1/`np' {
			gettoken name names : names
			quietly replace `Names'  = `"`name'"' in `i'
		}
		forvalues i = 1/`np_supp' {
			gettoken name Snames : Snames
			quietly replace `SNames' = `"`name'"' in `i'
		}
		quietly replace `Names' = usubstr(`Names', 1,`maxlength') in 1/`nps'
		quietly replace `SNames'= usubstr(`SNames',1,`maxlength') in 1/`nps'

		if "`wh'" == "R" {
			if "`column'" == "nocolumn" {
				local ytitle ytitle("Score")
			}
			else {
				local ytitle ytitle("Score", size(large))
			}
			local opt pstyle(p1)  mlab(`Names')  `ytitle' `rowopts'
			local opt_S mlab(`SNames') pstyle(p3) `rsupp_opt'
			local mpos_arg `r_mlabpos'
		}
		else {
			if "`row'" == "norow" {
				local ytitle ytitle("Score")
			}
			else {
				local ytitle ytitle(" ", size(large))
			}					
			local opt pstyle(p2) mlab(`Names')  `ytitle' `colopts'
			local opt_S mlab(`SNames') pstyle(p4) `csupp_opt'
			local mpos_arg `c_mlabpos'
		}

		local sclist
		forvalues d = 1/`ndim' {
			local idim : word `d' of `dim'

			tempvar y`d' x`d' position`d'
			local vlist `vlist' `y`d'' `x`d''

			quietly gen `x`d'' = `idim'
			quietly gen `y`d'' = `RC'[_n,`idim']  in 1/`np'

			if "`alternate'" != "" {
				sort `y`d'' `id'
				quietly generate byte `position`d'' = `mpos_arg'
				quietly replace  `position`d'' = mod(`mpos_arg'+6,12) if mod(_n,2) == 0
				sort `id' // restore sort order
				local pos mlabvpos(`position`d'')
			}
			else {
				local pos mlabpos(`mpos_arg')
			}

			local sclist `sclist' 		///
			   (scatter `y`d'' `x`d'', 	///
			    xtitle(Dimensions)		///	
			    xline(`idim', lcolor(black)) `pos' `opt')

			if `np_supp' > 0 {
				tempvar sy`d'
				local vlist `vlist' `sy`d''
				quietly gen `sy`d'' = `SRC'[_n,`idim'] ///
				   in 1/`np_supp'
				local sclist `sclist'	///
				   (scatter `sy`d'' `x`d'', `opt_S')
			}
		}

		local which `e(`wh'name)'
		local legend label(1 `which')
		local order 1
		if `np_supp' > 0 {
			local legend `legend' label(2 supplementary `which')
			local order  1 2
		}

		if `nplots' == 1 {
			local oneplot_opts 				///
			   title(CA dimension projection plot)		///
			   note(`e(norm)' normalization)
		}
		else {
			tempname `wh'plot
			local plotnames `plotnames' ``wh'plot'
			local oneplot_opts nodraw name(``wh'plot')
		}
		twoway `sclist', 				///
		   legend(`legend' order(`order'))  		///
		   xscale(range(`Xlow' `Xhigh')) 		///
		   xlabel(`xlab', notick labsize(small))	///
		   legend(on) 					///
		   `scheme'					///
		   `oneplot_opts' 				///
		   `goptions'

		if `"`restore'"' != "" {
			`restore'
		}
		else {
			drop `vlist'
		}
	}

// combine plot

	if `nplots' > 1 {
		graph combine `plotnames' , 			///
		   title(CA dimension projection plot)		///
		   note(`e(norm)' normalization) ycommon `scheme' `gcopts'
		graph drop `plotnames'
	}

end
exit
