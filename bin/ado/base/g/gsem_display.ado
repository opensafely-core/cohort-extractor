*! version 1.0.12  14jan2020
program gsem_display
	version 15

	if _by() {
		error 190
	}
	syntax [, BYPARM *]

	if "`e(gclevs)'" == "" | c(noisily) == 0 {
		local byparm byparm
	}

	if "`byparm'" != "" {
		Display, `options'
	}
	else	GDisplay, `options'
end

program Display
	syntax [,	noHeader	///
			noDVHeader	///
			noLegend	///
			notable		///
			disd		///  UNDOCUMENTED
			post		///  UNDOCUMENTED
			verbose		///  UNDOCUMENTED
			eform		///  UNDOCUMENTED
			eqselect(string)	///  UNDOCUMENTED
			*		///
	]
	_get_diopts diopts, `options'
	local coefl coeflegend selegend
	local coefl : list diopts & coefl
	if e(estimates) == 0 {
		if `"`coefl'"' == "" {
			local diopts `diopts' coeflegend
		}
	}
	local diopts `diopts' `eform' eqselect(`eqselect')
	if "`disd'" != "" {
		if "`post'" != "" {
			local verbose verbose
		}
		else {
			if `"`coefl'"' != "" {
				local 0 `", `coefl'"'
				syntax [, NULLOP]
				exit 198	// [sic]
			}
		}
		tempname b V pclass
		mat `b' = e(b_sd)
		mat `V' = e(V_sd)
		if "`e(b_sd_pclass)'" == "matrix" {
			mat `pclass' = e(b_sd_pclass)
		}
		else {
			mat `pclass' = e(b_pclass)
			local dim = colsof(`pclass')
			_b_pclass cov : cov
			_b_pclass corr : corr
			forval i = 1/`dim' {
				if `pclass'[1,`i'] == `cov' {
					matrix `pclass'[1,`i'] = `corr'
				}
			}
		}
		if "`e(Cns)'" == "matrix" {
			tempname Cns
			mat `Cns' = e(Cns)
			local cc ,"`Cns'"
		}
		if "`verbose'" == "" {
			mata: SdSel("`b'","`V'","`pclass'"`cc')
			if `skip' {
				di as err ///
				"no variance components to transform"
				exit 322
			}
		}
		local mats bmat(`b') vmat(`V') pclassmat(`pclass') ///
			cnsmat(`Cns') nocnsreport
	}
	if "`e(groupvar)'`e(lclass)'" != "" {
		local diopts `diopts' byparm
	}
	_prefix_display, `header' `dvheader' `legend' `table' `diopts' `mats'

	if "`disd'" != "" {
		if "`post'" == "" {
			_gsem_ret_sd
		}
		else	_gsem_eret_sd
	}
end

program GDisplay, rclass
	syntax [,	noHeader	///
			noDVHeader	///
			noLegend	///
			NOTABLE		///
			noCNSReport	///
			FULLCNSReport	///
			disd		///  UNDOCUMENTED
			post		///  UNDOCUMENTED
			verbose		///  UNDOCUMENTED
			eform		///  UNDOCUMENTED
			eqselect(string)	///  UNDOCUMENTED
			*		///
	]

	local disdsub 0
	if "`disd'" != "" {
		if "`post'" != "" {
			local verbose verbose
		}
		if "`verbose'" == "" {
			local disdsub 1
		}
	}

	_get_diopts diopts, `options' `cnsreport' `fullcnsreport'
	local diopts : list diopts - fullcnsreport
	local diopts : list diopts - cnsreport
	if e(estimates) == 0 {
		local coefl coeflegend selegend
		local coefl : list diopts & coefl
		if `"`coefl'"' == "" {
			local diopts `diopts' coeflegend
		}
	}
	local diopts `diopts' `eform' eqselect(`eqselect')

	if "`header'" == "" {
		_coef_table_header, nodvheader
		if "`cnsreport'`e(Cns)'" == "matrix" {
			local k_cns : rowna e(Cns)
			local k_cns : list sizeof k_cns
			if "`fullcnsreport'"!="" | `k_cns'>e(k_autoCns) {
				di
				makecns, display nullok `fullcnsreport'
			}
		}
	}
	if "`notable'" != "" {
		if "`disd'" != "" {
			if "`post'" == "" {
				_gsem_ret_sd
			}
			else	_gsem_eret_sd
		}
		exit
	}

	if "`dvheader'" != "" {
		local header noheader
	}

	local g = 0
	local K = rowsof(e(gclevs))
	forval i = 1/`K' {
		local gi = el(e(gclevs),`i',1)
		if `gi' != `g' {
			if "`e(groupvar)'" != "" {
				di
				gsem_depvar_header, gidx(`gi') `header'
			}
			if "`e(lclass)'" != "" & !`disdsub' {
				Table4gidx	`gi'		///
						`"`eqselect'"'	///
						`"`diopts'"'
			}
			local g = `gi'
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
		}

		Table4midx	`i'		///
				`"`eqselect'"'	///
				`"`disd'"'	///
				`"`disdsub'"'	///
				`"`header'"'	///
				`"`diopts'"'
		local puttabs `"`puttabs' `r(put_tables)'"'
		return add
	}
	return hidden local put_tables `: list retok puttabs'

	if c(coeftabresults) == "on" {
		quietly						///
		Display,	`disd'				///
				`post'				///
				`verbose'			///
				`diopts'
		return add
	}
	else if "`disd'" != "" {
		mata: st_rclear()
		if "`post'" == "" {
			_gsem_ret_sd
		}
		else	_gsem_eret_sd
	}
end

program Table4gidx
	args gidx eqselect options

	tempname b V pclass
	if "`e(Cns)'" == "matrix" {
		tempname Cns
	}

	// uses macro:
	// 	eqselect
	// sets macro:
	// 	skip
	// 	cnsmatopt
	mata: st_gsem_sel_midx("`b'", "`V'", "`Cns'", "`pclass'", -`gidx')
	if `skip' {
		exit
	}

	if "`e(groupvar)'" != "" {
		_ms_modify `b', fvignore(1)
	}

	di
	_coef_table,	cmdextras		///
			bmatrix(`b')		///
			vmatrix(`V')		///
			pclassmat(`pclass')	///
			`cnsmatopt'		///
			suffix(_g`gidx')	///
			nocnsreport		///
			`options'
end

program Table4midx
	args midx eqselect disd disdsub header options

	tempname b V pclass
	if "`e(Cns)'" == "matrix" {
		tempname Cns
	}

	// uses macro:
	// 	eqselect
	// sets macro:
	// 	skip
	// 	cnsmatopt
	mata: st_gsem_sel_midx("`b'", "`V'", "`Cns'", "`pclass'", `midx')
	if `skip' {
		exit
	}

	_ms_modify `b', fvignore(`e(b_fvignore)')

	if `disdsub' {
		mata: SdSel("`b'","`V'","`pclass'")
		if `skip' {
			exit
		}
	}

	local dv `"`e(depvar)'"'
	local dv : list uniq dv
	local dv : list sizeof dv
	if "`e(groupvar)'" == "" {
		di
	}
	else if "`e(lclass)'" != "" {
		di
	}
	else if "`header'" == "" & `dv' > 1 {
		di
	}
	gsem_depvar_header, midx(`midx') `header'

	di
	local offset `"`e(m`midx'_offset)'"'
	if `"`offset'"' != "" {
		local offset `"offsetlist(`offset')"'
	}
	_coef_table,	cmdextras			///
			bmatrix(`b')			///
			vmatrix(`V')			///
			pclassmat(`pclass')		///
			`cnsmatopt'			///
			suffix(_m`midx')		///
			nocnsreport			///
			`offset'			///
			`options'
end

mata:

void st_gsem_sel_midx(
	string	scalar	st_b,
	string	scalar	st_V,
	string	scalar	st_Cns,
	string	scalar	st_pclass,
	real	scalar	midx)
{
	real	scalar	doCns
	real	scalar	sd
	real	vector	sel
	real	vector	b
	real	vector	pclass
	real	matrix	V
	real	matrix	Cns
	string	matrix	stripe
	real	matrix	fvinfo
	real	vector	el_sel
	pragma unset el_sel

	doCns	= st_Cns != ""

	sel	= st_matrix("e(b_midx)") :== midx

	if (allof(sel, 0)) {
		st_local("skip", "1")
		return
	}

	sd	= st_local("disd") != ""

	if (sd) {
		b	= st_matrix("e(b_sd)")
		V	= st_matrix("e(V_sd)")
		stripe	= st_matrixcolstripe("e(b_sd)")
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

	_b_eq_select(stripe, tokens(st_local("eqselect")), ., el_sel)
	el_sel = sel :* el_sel
	if (allof(el_sel, 0)) {
		st_local("skip", "1")
		return
	}
	st_local("skip", "0")

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
	st_matrixcolstripe(st_pclass, stripe)
	if (doCns) {
		sel = rowsum(Cns :!= 0) :!= 0
		if (any(sel)) {
			Cns = select(Cns, sel)
			st_matrix(st_Cns, Cns)
			st_local("cnsmatopt", sprintf("cnsmat(%s)", st_Cns))
		}
	}
}

void SdSel(
	string	scalar	bs,
	string	scalar	Vs,
	string	scalar	ps,
	|string	scalar	Cs)
{
	real scalar var, cov, corr, hascns
	real vector b, pclass, sel, Cns
	real matrix V
	string matrix stripe
	class _b_pclass scalar PC
	real matrix fvinfo

	hascns = Cs != ""
	b = st_matrix(st_local("b"))
	V = st_matrix(st_local("V"))
	pclass = st_matrix(st_local("pclass"))
	var = PC.value("var")
	cov = PC.value("cov")
	corr = PC.value("corr")
	sel = (pclass:==var) :| (pclass:==cov) :| (pclass:==corr)
	if (sum(sel)==0) {
		st_local("skip", "1")
		return
	}
	st_local("skip", "0")

	b = select(b,sel)
	V = select(select(V, sel), sel')
	pclass = select(pclass,sel)

	stripe = st_matrixcolstripe(st_local("b"))
	stripe = select(stripe,sel')
	fvinfo = st_matrixcolstripe_fvinfo(st_local("b"))
	// NOTE: first element of fvinfo is an extra global piece of
	// information that needs to be preserved
	fvinfo = select(fvinfo,(1, sel)')

	st_matrix(bs,b)
	st_matrix(Vs,V)
	st_matrix(ps,pclass)
	st_matrixcolstripe(bs,stripe)
	st_matrixrowstripe(Vs,stripe)
	st_matrixcolstripe(Vs,stripe)
	st_matrixcolstripe_fvinfo(bs, fvinfo)

	if (hascns) {
		Cns = st_matrix(st_local("Cns"))
		sel = sel,1
		Cns = select(Cns,sel)
		st_matrix(Cs,Cns)
	}
}

end

exit
