*! version 1.0.5  05jun2015 
program xtdpd_estat, rclass
        version 10
        
        if "`e(cmd)'" != "xtdpd"      &	///
	   "`e(cmd)'" != "xtabond"    &	///
	   "`e(cmd)'" != "xtdpdsys"   & ///
	   "`e(engine)'" != "xtdpd"   {
	   	di "{p}{err}xtdpd_estat only valid after {cmd:xtdpd}, "	///
			"{cmd:xtabond}, or {cmd:xtdpdsys}{p_end}"
                exit 301
        }
        
        gettoken sub rest: 0, parse(" ,")

        local lsub = length("`sub'")
        if "`sub'" == bsubstr("abond",1,max(2,`lsub')) {		// ABond
                ABond `rest'
        }
        else if "`sub'" == bsubstr("sargan",1,max(3,`lsub')) { 	// SARgan
                SARgan `rest'
        }
        else estat_default `0'
	return add
end

program define SARgan

	di "{txt}Sargan test of overidentifying restrictions"
	di "{txt}{col 9}H0: overidentifying restrictions are valid"

	mata: st_local("bparms", strofreal(cols(st_matrix("e(b)"))))
	mata: st_local("dropped", strofreal(diag0cnt(st_matrix("e(V)"))) )
	
	if `dropped' {
		di "{p 8}{txt}cannot calculate Sargan test with "	///
			"dropped variables{p_end}"
	}		

	if "`e(vce)'" == "robust" {
		di "{p 8}{txt}cannot calculate Sargan test with "	///
			"{cmd:vce(robust)}{p_end}"
	}
	local bparms = `bparms' - `dropped'

	local df = e(zrank) - `bparms'
	
	di
	di "{txt}{col 9}chi2({res}`df'{txt}){col 22}={res} " %9.8g e(sargan)
	local pval = chiprob(`df' ,e(sargan))
	di "{txt}{col 9}Prob > chi2  = {res}   " %6.4f `pval' 

end

program define ABond, rclass

	syntax , 					///
		[					///
		ARTests(numlist >=1 integer max=1)	///
		]

	if "`artests'" == "" {
		local artests `e(artests)'
	}

	if "`e(system)'" == "system" & "`e(twostep)'" == "" & "`e(vce)'" != "robust" {
		di "{p}{txt}artests not computed for "	///
			"one-step system estimator "	///
			"with {cmd:vce(gmm)}{p_end}"
		exit 198
	}


	mata: st_local("dropped", strofreal(diag0cnt(st_matrix("e(V)"))) )
	

	local artests_calc = e(artests)

	if `artests'>`artests_calc' {
		qui _datasignature
		local datasig `r(datasignature)'
		if "`datasig'" != "`e(datasignature)'" {
			di "{p}{txt}the data have changed; cannot "	///
				"compute additional AR tests{p_end}"
			di "{p}displaying AR tests computed during "	///
				"estimation{p_end}"
			local artests = `artests_calc'		
		}	
	}		
			
			
	if `artests' >0 {		
		tempname armv
		mat `armv' = J(`artests',1,.)
	}

	if `dropped' {
		di "{p 8}{txt}cannot calculate AR tests with "	///
			"dropped variables{p_end}"
	}		

	if `artests'<=`artests_calc' | `dropped' {
		forvalues i=1/`artests'  {
			 matrix `armv'[`i',1] = e(arm`i')
		}
	}
	else {

		REDOests , artests(`artests') armv(`armv')
	}

	di
        di as txt "{p}Arellano-Bond test for zero autocorrelation " 	///
        	"in first-differenced errors{p_end}"

	if `dropped' {
		di "{p 2}{txt}cannot calculate test with "	///
			"dropped variables{p_end}"
	}		
	

	tempname table pvalues 
	.`table' = ._tab.new, col(3)
	.`table'.width |6|8 8|
	.`table'.strcolor green . . 
	.`table'.numcolor green yellow yellow 
        .`table'.numfmt %4.0f %7.6g %6.4f
	.`table'.pad 0 0 1
	.`table'.sep, top
	.`table'.titles "Order"  	/// 1
                        "z    "  	/// 2
                        "Prob > z"	// 3

	.`table'.sep, mid

	matrix `pvalues' =  J(1, 1, 0)
	
	forvalues i=1/`artests' {

		local pval =  	2*(normprob(-1*abs(`armv'[`i',1]) ))		
		.`table'.row	`i'					///
				`armv'[`i',1]				///
				`pval'
		matrix `pvalues' = (`pvalues')\(`pval')
		
        }       
	
	.`table'.sep, bot
        di "{txt}{col 4}H0: no autocorrelation " 

	return clear

	if `artests' > 0 {
		tempname order
		mata: st_matrix("`order'", 1::`artests')
		matrix `pvalues' = ///
			`pvalues'[2..rowsof(`pvalues'), 1]
		matrix `armv' = `order', `armv', `pvalues'
		matrix colnames `armv' = order arstat p-values
		return matrix arm  = `armv'
			
	}
end


program define REDOests
	syntax , artests(integer) armv(name)

	tempname oest b0 v0 b1 v1
	tempvar  osamp samp

	qui gen byte `samp' = e(sample)

	_estimates hold `oest', copy restore varname(`osamp')

	mat `b0' = e(b)
	mat `v0' = e(V)

	local depvar = e(depvar)
	local indeps : colfullnames e(b) 
	local indeps : subinstr local indeps	///
		"_cons" "" , word count(local cnt)
	
	if `cnt' == 0 {
		local constant noconstant
	}

	local hascons `e(hascons)'
	local transform `e(transform)'

	local twostep `e(twostep)'
	local vce     vce(`e(vce)')

	GetDGmmiv 
	local dgmmiv `r(dgmmiv)'

	GetLGmmiv
	local lgmmiv `r(lgmmiv)'

	if "`e(div_odvars)'" != "" {
		local div_only_dvars div(`e(div_odvars)')
	}
	
	if "`e(div_olvars)'" != "" {
		local div_only_lvars div(`e(div_olvars)', nodiff)
	}	


	if "`e(liv_olvars)'" != "" {
		local liv_only_lvars `e(liv_olvars)'
		local liv_only_lvars : subinstr local liv_only_lvars	///
			"_cons" "" , word 
		local liv_only_lvars liv(`liv_only_lvars') 	
	}	

	if "`e(div_dvars)'" != "" {
		local iv_vars_list `e(div_dvars)'
		local iv_dvars       iv(`e(div_dvars)')
	}	

	if "`e(div_lvars)'" != "" {
		local iv_vars_list `iv_vars_list' `e(div_lvars)'
		local iv_lvars      iv(`e(div_lvars)' , nodiff)
	}

	local liv_lvars_list `e(liv_lvars)'

	local same : list iv_vars_list === liv_lvars_list
	if !`same' {
		di "{err}error reconstructing {cmd:iv()}"
		di "{err}unable to compute additional AR tests"
		exit 9999
	}
	
	if "`e(diffvars)'" != "" {
		local diffvars `e(diffvars)'
		local indeps : list indeps - diffvars
		local diffvars diffvars(`diffvars')
	}	

	xtdpd `depvar' `indeps' if `samp' ,			///
		`dgmmiv'					///
		`lgmmiv'					///
		`div_only_dvars'				///
		`div_only_lvars'				///
		`liv_only_lvars'				///
		`iv_dvars'					///
		`iv_lvars'					///
		`constant'					///
		`diffvars'					///
		`twostep'					///
		`vce'						///
		`transform'					///
		`hascons'					///
		artest(`artests')

	mat `b1' = e(b)
	mat `v1' = e(V)

	if (mreldif(`b0',`b1')>1e-15 | mreldif(`v0',`v1')>1e-15 ) {
		di "{err}error refitting model"
		di "{err}unable to compute additional AR tests"
		exit 9999

	}

	forvalues i=1/`artests'  {
		 matrix `armv'[`i',1] = e(arm`i')
	}
	
	_estimates unhold `oest'

end

program define GetLGmmiv, rclass

	local lgmmiv_vars `e(lgmmiv_vars)'
	local lgmmiv_lag  `e(lgmmiv_lag)'
	
	local i 1
	foreach v of local lgmmiv_vars {
		local f : word `i' of `lgmmiv_lag'
		local lgmmiv "`lgmmiv' lgmmiv(`v', lag(`f')) "
		local ++i
	}
	
	return local lgmmiv `lgmmiv'

end

program define GetDGmmiv, rclass

	local dgmmiv_vars `e(dgmmiv_vars)'
	local dgmmiv_flag `e(dgmmiv_flag)'
	local dgmmiv_llag `e(dgmmiv_llag)'

	local i 1
	foreach v of local dgmmiv_vars {
		local f : word `i' of `dgmmiv_flag'
		local l : word `i' of `dgmmiv_llag'
		local dgmmiv "`dgmmiv' dgmmiv(`v' , lag(`f' `l')) "
		local ++i
	}

	return local dgmmiv `dgmmiv'
end

