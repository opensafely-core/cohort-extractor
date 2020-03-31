*! version 4.2.0  01oct2018
program bsqreg, byable(onecall) prop(mi) eclass
	local vv : di "version " string(_caller()) ":"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if "`e(cmd)'" != "bsqreg" {
			error 301
		}
		if _by() {
			error 190
		}
		Replay `0'
		exit
	}
	`vv' `BY' Estimate `0'
end

program Estimate, eclass byable(recall) sort
	local cmdline : copy local 0
	version 13, missing

	syntax varlist(numeric fv) [if] [in] [,	Level(cilevel)	///
					Quantile(real .5)	///
					WLSiter(integer 1)	///
					Reps(integer 20)	///
					noDOts			///
					* ]
	_get_diopts diopts, `options'
	local quant = `quantile'
	if (`quantile'>=1) {
		local quantile = `quantile'/100
	}
	if (`quantile'<=0 | `quantile'>=1) {
		di in red "{bf:quantile(`quant')} is out of range"
		exit 198
	}
	if `reps' < 2 {
		di in red "{bf:reps(`reps')} must be greater than 1"
		error 198
	}

	if "`log'"!="" | "`dots'"!="" {
		local log "*"
	}

	marksample touse

	ereturn clear

	tempname coefs VCE omitmat
	tempvar e
	tempfile BOOTMST BOOTRES

	local opts "quantile(`quantile') wls(`wlsiter') `cons'"
	gettoken depv vl : varlist
	_fv_check_depvar `depv'
	_rmcoll `vl' [`weight'`exp'] if `touse', expand
	local vl `r(varlist)'
	`log' di in gr "(fitting base model)"
	/* vc <= 12 for old std.err. (discarded)	*/
	version 12: qui qreg `depv' `vl' if `touse', `opts'
	_check_omit `omitmat', get
	local colna : colna e(b)
	local nobs `e(N)'
	local tdf `e(df_r)'
	local q `e(q_v)'
	local rsd  `e(sum_rdev)'
	local rq `e(q)'		/* about */
	local msd `e(sum_adev)'
	local frc `e(convcode)'
	mat `coefs' = get(_b)

	local seed = c(seed)
	preserve

	quietly {
		keep if `touse'
		fvrevar `vl', list
		keep `depv' `r(varlist)'
		save "`BOOTMST'"
		drop _all
		set obs 1
		gen byte `e'=.
		save "`BOOTRES'"
	}
	if "`log'" == "" {
		di
		_dots 0, title(Bootstrap replications) reps(`reps') `dots'
		if ("`dots'"!="") local dots *
		else local dots _dots
	}
	else local dots *

	local nx : list sizeof colna
	local j 1
	while `j'<=`reps' {
		quietly use "`BOOTMST'", clear 
		* bootsamp _N
		bsample
		cap noisily quietly _crcbsqr `depv' `vl', `opts' /*see note 1*/
		local rc = _rc
		if `rc' == 0 {
			_check_omit `omitmat', check result(omit)
			if `omit' {
				local rc = 2
			}
		}
		drop _all
		if (`rc'==0) {
			quietly set obs 1
			local COLNA : copy local colna
			forval i = 1/`nx' {
				gettoken bi COLNA : COLNA
				gen double b`i' = _b[`bi']
			}
			quietly {
				append using "`BOOTRES'"
				save "`BOOTRES'", replace
			}
			`dots' `j' 0
			local j=`j'+1
		}
		else {
			if `rc' == 1 {
				error 1
			}
			`dots' `j' 1
		}
	}
	`dots' `reps'

	quietly mat accum `VCE' = b*, dev nocons
	mat rownames `VCE' = `colna'
	mat colnames `VCE' = `colna'
	mat `VCE'=`VCE'/(`reps'-1)
	restore
	ereturn post `coefs' `VCE',	obs(`nobs')		///
					dof(`tdf')		///
					depn(`depv')		///
					esample(`touse')	///
					buildfvinfo
	capture erase "`BOOTMST'"
	capture erase "`BOOTRES'"

	/* double save in S_E_ and e() */
	ereturn hidden local seed `seed'
	ereturn local depvar "`depv'"
	ereturn scalar reps = `reps'   /* undocumented */
	ereturn local vle "`vle'"      /* undocumented */
	ereturn scalar N = `nobs'
	ereturn scalar df_r = `tdf'
	ereturn scalar q_v = `q'
	ereturn scalar sum_rdev = `rsd'
	ereturn scalar q = `rq'
	ereturn scalar sum_adev = `msd'

	global S_E_depv "`depv'"
	global S_E_reps `reps'
	global S_E_vl "`vl'"
	global S_E_vle "`vle'"
	global S_E_nobs `nobs'
	global S_E_tdf `tdf'
	global S_E_q `q'
	global S_E_rsd `rsd'
	global S_E_rq `rq'
	global S_E_msd `msd'

	global S_E_cmd "bsqreg"
	global S_E_frc 0

	ereturn local marginsnotok stdp stddp Residuals
	ereturn local predict "qreg_p"
	ereturn local cmdline `"bsqreg `cmdline'"'
	ereturn local cmd "bsqreg"
	ereturn scalar convcode = 0
	_post_vce_rank

	Replay, level(`level') `diopts'
end

program Replay
	syntax [, Level(cilevel) *]
	_get_diopts diopts, `options'
	di
	if (e(q)==0.5) {
		di in gr "Median regression, bootstrap("  /*
		*/ in ye "`e(reps)'" in gr ") SEs" /*
		*/ _col(53) _c
	}
	else {
		di in gr e(q) " Quantile regression, bootstrap(" /*
		*/ in ye "`e(reps)'" in gr ") SEs" /*
		*/ _col(53) _c 
	}
	di in gr "Number of obs = " in ye %10.0gc e(N)
	di in gr "  Raw sum of deviations" in ye %9.0g e(sum_rdev) /*
		*/ in gr " (about " in ye e(q_v) in gr ")"
	di in gr "  Min sum of deviations" in ye %9.0g e(sum_adev) _col(53) /*
		*/ in gr "Pseudo R2     = " /*
		*/ in ye %10.4f 1 - (e(sum_adev)/e(sum_rdev))
	di
	_coef_table, level(`level') `diopts'
	error e(convcode)
end

program _crcbsqr
	syntax varlist(numeric fv) [, Quantile(real 0.5) WLSiter(integer 1) ]
	local quant "`quantile'"
	if `wlsiter'<1 {
		error 198
	}
	tempvar r s2 hat
	gen `c(obs_t)' `s2' = _n

	_qregwls `varlist', quant(`quant') iterate(`wlsiter') r(`r')

	sort `r' `s2'
	drop `r' 

	cap _qreg `varlist', quant(`quant')
	if (r(convcode)!=1 | _rc~=0) {
		if (_rc==1) {
			exit 1
		}
		exit -2000
	}

	_predict double `hat'
	tokenize `varlist'
	mac shift
	reg `hat' `*'
end
exit

Notes
-----

Note 1.
You can substitute qreg for _crcbsqr, the result being only to slow the
program down.  _crcbsqr is an alternative that
	1)	does not allow if exp or in range
	2)	does not allow weights
	3)	produces no output
	4)	produces no estimates of the standard errors
