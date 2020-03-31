*! version 1.5.0  23apr2017
program sem_display
	version 12

	if "`e(cmd)'" != "sem" {
		error 301
	}
	if _by() {
		error 190
	}
	syntax [, BYPARM SHOWGinvariant *]

	if "`e(sem_vers)'"=="" | "`e(groupvalue)'"=="" | c(noisily)==0 {
		local byparm byparm
	}

	if "`byparm'`showginvariant'" != "" {
		Display, `options'
	}
	else	GDisplay, `options'
end

program Display
	if "`e(prefix)'" != "" {
		_prefix_display `0'
		exit
	}
	syntax [,	STANDardized		///
		  	SHOWGinvariant		///
			noLABel			///
			NOFVLABel		///
			FVLABel			///
		  	noHEADer		///
		  	noTABLE			///
		  	noFOOTnote		///
			wrap(numlist max=1)	///
			fvwrap(passthru)	///
		  	*			///
	]

	if "`wrap'" != "" {
		opts_exclusive `"wrap(`wrap') `fvwrap'"'
		local fvwrap fvwrap(`wrap')
	}
	if "`label'" != "" {
		opts_exclusive "`label' `fvlabel'"
		local fvlabel nofvlabel
	}
	else {
		local fvlabel `nofvlabel' `fvlabel'
	}

	_get_diopts diopts, `options' `fvwrap' `fvlabel'

	local header = "`header'" == ""
	if `header' {
		_coef_table_header
	}
	local blank `header'

	if ("`table'" == "") {
		if `blank' {
			di
			local blank 0
		}
		if "`standardized'" != "" {
			if "`e(groupvar)'" != "" {
				local showginvariant showginvariant
			}
		}
		if e(estimates) == 0 {
			local coefl coeflegend selegend
			local coefl : list diopts & coefl
			if `"`coefl'"' == "" {
				local diopts `diopts' coeflegend
			}
		}
		_coef_table,			///
			cmdextras		///
			`standardized'		///
			`showginvariant'	///
			`footnote'		///
			`diopts'
	}

	if "`footnote'"=="" { 
		if `blank' {
			di
		}
		Footer
	}

end

program Footer 
	if  "`e(chi2type_note)'" != "" {
		di as txt "{p 0 6 2 79}"
		di as txt "Note: The `e(chi2type_note)' test of model"
		di as txt "vs. saturated is not reported because the"
		if e(df_s) < e(dim_s) {
			di as txt "saturated model is not full rank."
		}
		else {
			di as txt "fitted model is not full rank."
		}
		di as txt "{p_end}"
	}
	else if  "`e(chi2type_ms)'" != "" {
		local df   : display       `e(df_ms)'
		if "`e(chi2type_ms)'" == "Discr." {
			local chi2 : display %8.2f `e(chi2_ms)'
		}
		else {
			local chi2 : display %9.2f `e(chi2_ms)'
		}
		local sk   _skip(`=3-strlen("`df'")')

		dis as txt  "`e(chi2type_ms)' test of model vs. saturated:" ///
			    " chi2({res:`df'}) " `sk' "= {res:`chi2'}, "    ///
			    "Prob > chi2 = " as res %6.4f e(p_ms)
	}
	if e(sbentler) == 1 {
		local chi2sb : display %9.2f `e(chi2sb_ms)'
		dis as txt "Satorra-Bentler scaled test:   " ///
			   " chi2({res:`df'}) " `sk' "= {res:`chi2sb'}, " ///
			   "Prob > chi2 = " as res %6.4f e(psb_ms)
	}
	if e(estimates) == 0 {
		di as txt "{p 0 6 2 79}"
		di as txt "Note: The above coefficient values are starting"
		di as txt "values and not the result of a fully fitted model."
		di as txt "{p_end}"
	}
	ml_footnote
end

program GDisplay, rclass
	syntax [,	STANDardized		///
			noLABel			///
			NOFVLABel		///
			FVLABel			///
		  	noHEADer		///
		  	noTABLE			///
		  	noFOOTnote		///
			wrap(numlist max=1)	///
			fvwrap(passthru)	///
			noCNSReport		///
			FULLCNSReport		///
		  	*			///
	]

	if "`wrap'" != "" {
		opts_exclusive `"wrap(`wrap') `fvwrap'"'
		local fvwrap fvwrap(`wrap')
	}
	if "`label'" != "" {
		opts_exclusive "`label' `fvlabel'"
		local fvlabel nofvlabel
	}
	else {
		local fvlabel `nofvlabel' `fvlabel'
	}

	_get_diopts diopts, `options' `cnsreport' `fullcnsreport'
	local diopts : list diopts - fullcnsreport
	local diopts : list diopts - cnsreport

	local blank 0
	if "`header'" == "" {
		_coef_table_header
		if "`cnsreport'`e(Cns)'" == "matrix" {
			local k_cns : rowna e(Cns)
			local k_cns : list sizeof k_cns
			if "`fullcnsreport'"!="" | `k_cns'>e(k_autoCns) {
				di
				makecns, display nullok `fullcnsreport'
			}
		}
		local blank 1
	}
	if e(estimates) == 0 {
		local coefl coeflegend selegend
		local coefl : list diopts & coefl
		if `"`coefl'"' == "" {
			local diopts `diopts' coeflegend
		}
	}

	if "`table'" == "" {
		tempname b V pclass table ord
		if "`e(Cns)'" == "matrix" {
			tempname Cns
		}
		local mats bmatrix(`b') vmatrix(`V') pclassmat(`pclass')
		local K = colsof(e(groupvalue))
		forval i = 1/`K' {
			// sets macros:
			// 	skip
			// 	cnsmatopt
			mata: st_sem_sel_gidx(	"`b'",		///
						"`V'",		///
						"`Cns'",	///
						"`pclass'",	///
						"`ord'`i'",	///
						`i')
			if `skip' {
				continue
			}
			matrix `ord' = nullmat(`ord'), `ord'`i'
			_ms_modify `b', fvignore(1)

			if `blank' {
				di
				local blank 0
			}
			else if `i' > 1 {
				di
			}
			sem_group_header, gidx(`i') `header'
			_coef_table,			///
				cmdextras		///
				`mats'			///
				`cnsmatopt'		///
				`footnote'		///
				suffix(_g`i')		///
				showginvariant		///
				nocnsreport		///
				`diopts'
			matrix `table' = nullmat(`table'), r(table_g`i')
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
		}
		mata: st_sem_permute_table("`table'", "`ord'")
		return matrix table `table'
		return scalar level = r(level)
	}
	return hidden local put_tables `: list retok puttabs'

	if "`footnote'"=="" { 
		if `blank' {
			di
		}
		Footer
	}

end

mata:

void st_sem_permute_table(
	string	scalar	st_table,
	string	scalar	st_ord)
{
	real	matrix	table
	real	vector	ord

	table	= st_matrix(st_table)
	ord	= st_matrix(st_ord)
	table[,ord] = table
	st_matrix(st_table, table)
	st_matrixcolstripe(st_table, st_matrixcolstripe("e(b)"))
}

void st_sem_sel_gidx(
	string	scalar	st_b,
	string	scalar	st_V,
	string	scalar	st_Cns,
	string	scalar	st_pclass,
	string	scalar	st_ord,
	real	scalar	gidx)
{
	real	scalar	doCns
	real	scalar	std
	real	vector	sel
	real	vector	b
	real	vector	pclass
	real	matrix	V
	real	matrix	Cns
	string	matrix	stripe
	real	matrix	fvinfo

	doCns	= st_Cns != ""

	sel	= st_matrix("e(b_gidx)") :== gidx

	if (allof(sel, 0)) {
		st_local("skip", "1")
		return
	}
	st_local("skip", "0")
	st_matrix(st_ord, selectindex(sel))

	std	= st_local("standardized") != ""

	if (std) {
		b	= st_matrix("e(b_std)")
		V	= st_matrix("e(V_std)")
		stripe	= st_matrixcolstripe("e(b_std)")
	}
	else {
		b	= st_matrix("e(b)")
		V	= st_matrix("e(V)")
		stripe	= st_matrixcolstripe("e(b)")
	}
	fvinfo	= st_matrixcolstripe_fvinfo("e(b)")
	pclass	= st_matrix("e(b_pclass)")
	if (doCns) {
		Cns	= st_matrix("e(Cns)")
	}

	b	= select(b, sel)
	pclass	= select(pclass, sel)
	V	= select(V, sel)
	if (doCns) {
		Cns = select(Cns, (sel,1))
	}
	sel	= colshape(sel,1)
	V	= select(V, sel)
	stripe	= select(stripe, sel)
	// NOTE: first element of fvinfo is an extra global piece of
	// information that needs to be preserved
	fvinfo	= select(fvinfo, (1 \ sel))

	st_matrix(st_b, b)
	st_matrixcolstripe(st_b, stripe)
	st_matrixcolstripe_fvinfo(st_b, fvinfo)
	st_matrix(st_V, V)
	st_matrixcolstripe(st_V, stripe)
	st_matrixrowstripe(st_V, stripe)
	st_matrix(st_pclass, pclass)
	if (doCns) {
		sel = rowsum(Cns :!= 0) :!= 0
		if (any(sel)) {
			Cns = select(Cns, sel)
			st_matrix(st_Cns, Cns)
			st_local("cnsmatopt", sprintf("cnsmat(%s)", st_Cns))
		}
	}
}

end

exit
