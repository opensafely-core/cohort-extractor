*! version 1.1.3  08mar2018
program define _xtab_parser, rclass

	version 10


	syntax varlist(ts numeric default=none) [if] [in] ,	///
		[						///
		LAgs(integer 1) 				///
		Robust 						/// undocumented
		TWOstep 					///
		noCONStant 					///
		ARtests(integer 2)				/// 
                MAXLDep(numlist integer max=1 >=1)		///
		DIFFvars(varlist ts numeric)			///
		INST(string) 					///
                MAXLAGs(numlist integer max=1 >=1) 		///
		SMall						/// undocumented
                Level(cilevel) 					///
		VCE(passthru) 					///
		vsquish						///
		COEFLegend					///
		selegend					///
		NOLSTRETCH					///
		xtabond						/// undocumented
		xtdpdsys					/// undocumented
		* 						///
		]

	_get_diopts diopts, `vsquish' `coeflegend' `selegend' `nolstretch'

/// pre() is repeatable option parsed below		

	if "`xtabond'" != "" & "`xtdpdsys'" != "" {
		di "{err}specify {cmd:xtabond} or {cmd:xtdpdsys}, "	///
			"not both"
		exit 198	
	}
	local xtcmd "`xtabond'`xtdpdsys'"

	if "`small'" != "" {
		di "{txt}small is a deprecated option"
	}

	gettoken depvar indeps: varlist	

	if `lags' < 1 {
		di "{err}lags of dependent variable must >=1"
		exit 198
	}	

	if "`maxldep'" == "" {
		local maxldep .
	}	
	
	_vce_parse, opt(GMM Robust) old :, `vce' `robust'
        local robust `r(robust)'
        local vce = cond("`r(vce)'" != "", "`r(vce)'", "gmm")

	if "`maxlags'" == "" {
		local maxlags .
	}	
	
	_parse_pre_main , `options' globalmaxlags(`maxlags')

	local prevars `prevars' `r(prevars)'
	local laglist `laglist' `r(laglist)'
	local mllist  `mllist' `r(mllist)'
	local flist   `flist' `r(flist)'
	
	local options `"`r(options)'"'

	_parse_endog_main , `options' globalmaxlags(`maxlags')

	local prevars `prevars' `r(prevars)'
	local laglist `laglist' `r(laglist)'
	local mllist  `mllist' `r(mllist)'
	local flist   `flist' `r(flist)'
	
	local options `"`r(options)'"'


	if `"`options'"' != "" {
		local a: word 1 of `options'
		display as error ///
			"option {bf:`a'} not allowed with {bf:`xtcmd'}"
		exit 198
	}



				// maxldep in xtabond means maximum number
				// of lags of dependent variable that can 
				// be used.  In contrast, up (upper lag
				// limit) in dgmmmiv(y, lag(low up) is last
				// lag of depvar that can be used.  Because
				// first lag is always 2 for xtabond, 
				// conversion is up = maxldep + 1 
				// (maxldep=1 mean lag(2 2), maxldep(2) means
				// lag(2 3), etc)

	local maxldep = `maxldep' + 1


	local i 1
	foreach v of local prevars {
local lag   : word `i' of `laglist'
local maxl  : word `i' of `mllist'
local first : word `i' of `flist'

local pre_indeps `pre_indeps' L(0/`lag').`v'
local pre_inst   "`pre_inst' dgmmiv(L`lag'.`v', lag(`first' `maxl'))"
local ++i
	}

	
	if "`xtabond'" != "" {
		local diffsmp diffsmp	
	}

	if "`xtdpdsys'" != "" {
		local lgmmivmac " lgmmiv(`depvar') "

		local i 1
		foreach v of local prevars {
local lag   : word `i' of `laglist'
local first : word `i' of `flist'
local first = `first' - 1

local pre_levinst   "`pre_levinst' lgmmiv(L`lag'.`v', lag(`first'))"
local ++i
		}
	}
	
	if "`inst'" != "" {
		local instmac "div(`inst', nodifference) "
	}

	if "`indeps'" != "" {
		local indepsmac "div(`indeps') "
	}

	if "`diffvars'" != "" {
		local diffvarmac  "diffvars(`diffvars') "
		local diffvarmaci "div(`diffvars', nodifference) "
	}

	local cmd "L(0/`lags').`depvar' `pre_indeps' `indeps' "
	local cmd "`cmd' `if' `in' , "
	local cmd "`cmd' dgmmiv(`depvar', lagrange(2 `maxldep')) "
	local cmd "`cmd' `pre_inst' `indepsmac' level(`level') "
	local cmd "`cmd' vce(`vce') `twostep' `constant' `xtcmd' "
	local cmd "`cmd' `instmac' `diffsmp' hascons "
	local cmd "`cmd' `diffvarmac' `diffvarmaci' "
	local cmd "`cmd' `lgmmivmac' `pre_levinst' artests(`artests')"
	local cmd "`cmd' `diopts'"

	return local cmd "`cmd'"
end

program define _parse_endog_main, rclass

	syntax , [ ENDogenous(string) * ]		///
		globalmaxlags(numlist max=1 missingokay integer >=1 )
	local 0 `", `options'"'

	while "`endogenous'" != "" {

		local tmp : subinstr local endogenous "," ",", 	///
			count(local ncommas)

		if `ncommas'==0 {
			local endopt ", endopt"
		} 
		else {	
			local endopt " endopt"
		}

		_parse_pre `endogenous'  `endopt'
		local prevars `prevars' `r(prevars)'
		local laglist `laglist' `r(laglist)'
		local flist   `flist'   `r(flist)'
		
		local mli  `r(mllist)'
		if  `globalmaxlags' < . {
			local cnt : word count `mli'
			mata: st_local("put","`globalmaxlags' "*`cnt')
			local mllist  `mllist' `put'
		}
		else {
			local mllist  `mllist' `mli'
		}

		syntax , [ ENDogenous(string) * ]
		local 0 `", `options'"'
	}
	

	
	return local prevars `prevars'
	return local laglist `laglist'
	return local mllist  `mllist'
	return local flist   `flist'

	return local options `"`options'"'

end

program define _parse_pre_main, rclass

	syntax , [ pre(string) * ]		///
		globalmaxlags(numlist max=1 missingokay integer >=1 )
	local 0 `", `options'"'

	while "`pre'" != "" {

		_parse_pre `pre'
		local prevars `prevars' `r(prevars)'
		local laglist `laglist' `r(laglist)'
		local flist   `flist'   `r(flist)'
		
		local mli  `r(mllist)'
		if  `globalmaxlags' < . {
			local cnt : word count `mli'
			mata: st_local("put","`globalmaxlags' "*`cnt')
			local mllist  `mllist' `put'
		}
		else {
			local mllist  `mllist' `mli'
		}

		syntax , [ pre(string) * ]
		local 0 `", `options'"'
	}
	

	
	return local prevars `prevars'
	return local laglist `laglist'
	return local mllist  `mllist'
	return local flist   `flist'

	return local options `"`options'"'

end

program define _parse_pre, rclass

	syntax varlist, 			///
		[				///
		LAGstruct(string) 		///
		ENDogenous			///
		endopt				///
		]
	
	 if "`lagstruct'" != "" {
	 	local lagstruct0 `lagstruct'
                local lagstruct : subinstr local lagstruct " " "", all
                gettoken lags lagstruct : lagstruct, parse(",")
                capture confirm integer number `lags'
		if _rc {
			di "{err}{cmd:lagstruct(`lagstruct0')} invalid"
               		error 198
	     	}

		if `lags'<0 {
			di "{err}{cmd:lagstruct(`lagstruct0')} invalid"
               		error 198
		}

                gettoken comma lagstruct : lagstruct, parse(",")
                if "`comma'"!="," {
			di "{err}{cmd:lagstruct(`lagstruct0')} invalid"
                        error 198
                }               

                gettoken maxlags lagstruct : lagstruct, parse(",")
                if "`maxlags'" != "." {
                       capture confirm integer number `maxlags'
		       if _rc {
				di "{err}{cmd:lagstruct(`lagstruct0')} invalid"
                       		error 198
		       }
                }       

		if `maxlags'<1 {
			di "{err}{cmd:lagstruct(`lagstruct0')} invalid"
               		error 198
		}

                if "`lagstruct'"!="" {
			di "{err}{cmd:lagstruct0(`lagstruct') invalid"
                        error 198
                }               
        
        }
        else {
                local lags  0
                local maxlags "."
        }

	if "`endogenous'" != "" & "`endopt'" != "" {
		di "{err}{cmd:endogenous} not allowed"
		exit 198
	}

	if "`endogenous'" != "" | "`endopt'" != "" {
		local first 2
		local maxlags = `maxlags' + 1
	}
	else {
		local first 1
	}

	foreach v of local varlist {
		local prevars `prevars' `v'
		local laglist `laglist' `lags'
		local mllist  `mllist'  `maxlags'
		local flist   `flist'   `first'
	}

	return local prevars `prevars'
	return local laglist `laglist'
	return local mllist  `mllist'
	return local flist   `flist'
end

