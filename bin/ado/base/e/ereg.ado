*! version 6.5.4  30jan2017
*  (also see ereg_lf.ado)
program ereg, eclass byable(recall) prop(ml_score)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	version 7.0, missing

	if replay() {
		if `"`e(cmd)'"'!="ereg" { error 301 }
		if _by() { error 190 }
		if `"`e(frm2)'"'=="hazard" {
			local options "HR"
		}
		else	local options "TR"
		syntax [, `options' noCOEF noHEADer Level(cilevel) *]
		_get_diopts diopts, `options'
	}
	else {
		syntax varlist(min=1 fv) [if] [in] [fw aw pw iw/] [,  /*
		*/ CLuster(varname) noCOEF HAzard noHEADer 	/*
		*/ Level(cilevel) noLOg noCONstant /*
		*/ Dead(varname numeric) HR T0(varname numeric) /*
		*/ TR Robust SCore(passthru) STrata(varname fv) /*
		*/ OFFset(varname numeric) FROM(string) /*
		*/ moptobj(passthru) /*
		*/ EXTReat(string)   /* eregress arguments causing error
                */ ENTReat(string)   /*
                */ SELect(string)      /*
                */ TOBITSELect(string) /*
                */ ENDOGenous(string) * ]
		local eregresslist extreat entreat select 
		local eregresslist `eregresslist' tobitselect endogenous
		foreach x of local eregresslist {
			if "``x''" != "" {
				local a "option {bf:`x'()} not allowed;"
				version 15: di as error `"`a'"'
				local a "{p 0 4 2}use {bf:eregress} command"
				local a `"`a' for extended linear regression"' 
				local a `"`a' models{p_end}"'
				version 15: di as error `"`a'"'
				exit 498
			}
		}
		if _by() {
			_byoptnotallowed score() `"`score'"'
		}
		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		gettoken t rhs: varlist
		if "`cluster'" != "" {
			local clopt cluster(`cluster')
		}
		if "`strata'"~="" {
			if _caller() >= 15 {
				local rhs `rhs' i.`strata'
			}
			else {
				qui xi, prefix(_S) i.`strata'
				local rhs `rhs' _S*
			}
                }
		if "`hazard'"!="" {
			if `"`tr'"'!="" {
				di as err "tr invalid with hazard option"
				exit 198
			}
		}
		else if `"`hr'"'!="" {
			local hazard "hazard"
		}

		if `"`weight'"'!="" {
			tempvar wv
			qui gen double `wv' = `exp'
			local w `"[`weight'=`wv']"'
			local wgt `"[`weight'=`exp']"'
		}

		_get_diopts diopts options, `options'
		mlopts mlopts, `options'
		local coll `s(collinear)'
		local cns `s(constraints)'	

		if `"`hazard'"'==`""' & `"`cns'"'!=`""' {
			local ereg_lf ereg2_lf
		}	
		else { local ereg_lf ereg_lf }

		tempvar touse 
		mark `touse' `w' `if' `in'
		markout `touse' `t' `rhs' `dead' `t0' `offset'
		markout `touse' `cluster', strok

		if `"`offset'"'!="" {
			local offopt `"offset(`offset')"'	
			if `"`hazard'"'==`""' { local ereg_lf ereg2_lf }
		}

		if `"`dead'"'!="" {
			* unabbrev `dead', max(1)
			* local dead `s(varlist)'
			local sdead "`dead'"
			capture assert `dead'==0 | `dead'==1 if `touse'
			if _rc {
				tempvar mydead
				qui gen byte `mydead'=`dead'!=0 if `touse'
				local dead `mydead'
			}
		}
		else {
			local sdead "1"
			tempvar dead
			qui gen byte `dead'=1
		}

		if `"`t0'"'==`""' {
			local t0 0
			local realt "`t'"
		}
		else {
			tempvar realt
			qui gen double `realt' = `t'-`t0' if `touse'
			qui compress `realt'
		}
		capture assert `t0'<`t' if `touse'
		if _rc {
			di as err `"`t0' >= `t' in some obs."'
			exit 498
		}

		if `fvops' {
			local rmcoll "version 11: _rmcoll"
		}
		else	local rmcoll _rmcoll
		`rmcoll' `rhs' `w' if `touse', `constant' `coll'
		local rhs `r(varlist)'
		global S_1			/* clear for backwards compat */

		qui count if `touse' 
		local nobs = r(N) 		/* may be reset subsequently */
		if `nobs'<2 {
			if r(N)==0 { error 2000 } 
			error 2001
		}

		if `"`weight'"' != `""' {
			qui replace `wv'=0 if !`touse'
			if `"`weight'"'==`"aweight"' {
				qui summ `wv' if `touse', meanonly
				qui replace `wv' = `wv'/r(mean) if `touse'
			}
		}
		else	local wv `touse'

		local d `dead'

		tempvar num den
		tempname f b0

		quietly {
			gen double `num' = sum(`wv'*`d')
			gen double `den' = sum(`wv'*`realt')
			local cons = ln(`num'[_N]/`den'[_N])
			if `cons'>=. {
				if `num'[_N] <= 0 {
					if `num'[_N]==0 {
						di as err "no failures"
					}
					else	di as err /*
*/ "weighted sum of failures is negative"
					exit 498
				}
				/* `den'[_N]==0 */
				di as err /*
*/ "weighted sum of exit times negative or zero"
				exit 498
			}
			drop `num' `den'
			gen double `num' = sum(`wv'*ln(`d'*`t'))
			global EREGa = `num'[_N]
			drop `num'
			matrix `b0' = ( `cons' )
			matrix colnames `b0' = _cons
			if "`offset'" != "" {
				`vv' ///
				ml model `mm' `ereg_lf' /*
				*/ (`t': `realt' `d'=, `offopt') /*
				*/ `wgt' if `touse', init(_cons=1) missing /*
				*/ collin nopreserve wald(0) `mlopts' /*
				*/ max search(quietly) noout `negh'
				
				local f0 = e(ll)
				local convcnt = e(converged)
				mat `b0' = e(b)
			}
			else {
				tempvar lnf
				gen double `lnf' = `wv' * ///
					(`d'*`cons'-exp(`cons')*`realt') ///
					if `touse'
				sum `lnf', mean
				local f0 = r(sum) + $EREGa
				drop `lnf'
			}
		}

		if "`constant'"=="" {
			local wald lf0(1 `f0')
			if "`from'" != "" {
				local initopt init(`from')
			}
			else if "`offset'"=="" {
				local initopt init(_cons=`cons')
			}
			else {
				if `convcnt' > 0 {
					local initopt continue
				}
				else {
					local initopt init(`b0', skip) 
					local wald wald(1)
				}
			}
			local search search(off)
		}
		else {
			if "`from'" != "" {
				local initopt init(`from')
			}
		 	local wald wald(1)
			local search search(quietly)
		}

		global GLIST : all globals "EREG*"

		`vv' ///
		ml model `mm' `ereg_lf' /*
			*/ (`t': `realt' `d'=`rhs', `constant' `offopt') /*
			*/ `wgt' if `touse', /*
			*/ `initopt'  /*
			*/ missing collin /* for speed */ /* 
			*/ `wald' /*
			*/ maximize `search' `log' noout nopreserve /*
			*/ `mlopts' `crtype' `score' `robust' `clopt' `negh' /*
			*/ `moptobj'
		est local cmd
		global S_E_cmd

		if "`weight'" != "" {
			est local wtype "`weight'"
			est local wexp `"= `exp'"'
		}

		if `"`e(scorevars)'"'!=`""' & `"`hazard'"'==`""' & /*
		*/ `"`offset'"'=="" & `"`cns'"'==`""' {
			local sc `e(scorevars)'
			qui replace `sc' = -`sc'
		}

		if `"`hazard'"'==`""'  {
			local title `"log expected-time form"'
			if `"`cns'"' == `""' & "`offset'" == "" {
				tempname b
				mat `b' = get(_b)
				mat `b' = -1 * `b'
				est repost _b = `b'
			}
		}
		else 	local title `"log relative-hazard form"'

		if _caller() < 15 {
			est local title2 `"`title'"'
		}
		est local t0 `"`t0'"'

		if `"`hazard'"'==`""' {
			est local frm2 `"time"'
		}
		else 	est local frm2 `"hazard"'

		est local dead `sdead'

		if 1 /* _caller()<6 */ { 	/* double save */
			global S_E_t0 `e(t0)'
			global S_E_chi2 = e(chi2)
			global S_E_mdf = e(df_m)
			global S_E_frm2 `e(frm2)'

			global S_E_ll = e(ll)
			global S_E_nobs = e(N)
			global S_E_depv `t'
			global S_E_tdf .

			global S_E_cmd ereg
		}
		cap est hidden scalar converged_cons = `convcnt'
		est local stcurve="stcurve"
		est local predict ereg_p
		est local depvar "`t'"
		est local cmd ereg
		mac drop EREGa
	}
	if "`strata'" != "" {
		est local strata = "`strata'"
	}
	if `"`coef'"'==`""' {
		if `"`hr'"' != `""' {
			local hr `"eform(Haz. Ratio)"'
		}
		else if `"`tr'"' !=`""' {
			local hr `"eform(Time Ratio)"'
		}
		if `"`header'"'==`""' {
			if "`e(frm2)'" == "time" {
				local metric "AFT"
			}
			else local metric "PH"

			di _n as txt /*
		*/ `"Exponential `metric' regression -- entry time `e(t0)'"' _c
		}
		version 9: ///
		ml di, `header' `hr' level(`level') title(`e(title2)') ///
			`diopts'
	}
end

exit

globals used:

	macro EREGa	(#) adjustment to log likelihood function
