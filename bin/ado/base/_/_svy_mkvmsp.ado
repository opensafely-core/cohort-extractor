*! version 1.2.1  29jun2018
program _svy_mkvmsp, eclass
	local vv : display "version " string(_caller()) ":"
	version 9
	if `"`e(prefix)'"' != "svy" | `"`e(command)'"' == "" {
		exit 301
	}
	if inlist(`"`e(cmd2)'"',"stcox","streg") {
		local cmd `e(cmd2)'
	}
	else	local cmd `e(cmd)'
	local svyr svyr
	local props : properties `cmd'
	if ! `:list svyr in props' {
		di as err ///
		"misspecification effects cannot be computed with `cmd'"
		exit 301
	}

nobreak {
capture noisily break {

	tempname esave
	local subpop `"`e(subpop)'"'
	estimates store `esave'

} // capture noisily break

	local rc = c(rc)
	if `rc' == 0 {
		capture `vv' Execute `subpop' : `e(command)'
		local rc = c(rc)
		if `rc' == 0 {
			tempname V
			matrix `V' = e(V)
		}
	}

} // nobreak

	if "`esave'" != "" {
		quietly estimates restore `esave', drop
	}
	if `rc' {
		di as err "misspecification effects could not be computed"
		exit `rc'
	}
	if "`cmd'" == "total" {
		tempname nsub
		matrix `nsub' = e(_N_subp)
		CompTvar `V' `nsub'
		local coleq : coleq e(V), quote
		local colna : colna e(V), quote
		version 11: matrix coleq `V' = `coleq'
		matrix roweq `V' = `coleq'
		version 11: matrix colna `V' = `colna'
		matrix rowna `V' = `colna'
	}
	_svy_mkmeff `V'
end

program Execute
	local vv : display "version " string(_caller()) ":"
	version 9
	set prefix _svy_mkvmsp
	_on_colon_parse `0'
	local command `"`s(after)'"'
	local 0 `"`s(before)'"'
	syntax [varname(default=none)] [if] [in]
	marksample touse
	if "`varlist'" != "" {
		markout `touse' `varlist'
		quietly replace `touse' = 0 if `varlist' == 0
	}
	quietly replace `touse' = 0 if e(sample) != 1
	local 0 `"`command'"'
	syntax [anything(equalok)] [if] [in] [, SCore(passthru) * ]
	if `"`if'`in'"' != "" {
		marksample touse2
		quietly replace `touse' = 0 if `touse2' == 0
	}
	gettoken cmdname anything : anything
	if "`cmdname'" == "total" {
		local cmd mean
	}
	else	local cmd `cmdname'
	if inlist("`cmdname'","stcox","streg") {
		`vv' `cmd' `anything' if `touse', `options'
	}
	else	`vv' `cmd' `anything' [iw=`touse'], `options'
end

program CompTvar
	args V nsub
	// adjustment for -total- estimator
	tempname c
	local cols = colsof(`nsub')
	matrix `c' = J(1,`cols',0)
	forval i = 1/`cols' {
		matrix `c'[1,`i'] = `nsub'[1,`i']^2
	}
	matrix `V' = diag(`c')*`V'
end

exit
