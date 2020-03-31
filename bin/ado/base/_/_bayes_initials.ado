*! version 1.0.4  13jun2019

program _bayes_initials
	gettoken cmd 0 : 0
	_bayes_initials_`cmd' `0'
end

program _err_msg
	args opt nchains
	local s
	local schains one
	if `nchains' != 1 {
		local schains `nchains'
	}
	if `nchains' > 1 {
		local s s
	}
	if `"`opt'"' == "init0()" {
		di as err `"option {bf:`opt'} not allowed"'
		return
	}
	di as err `"option {bf:`opt'} not allowed with `schains' chain`s'"'
	if `nchains' < 2 {
		di as err `"{p 4 4 2}You have only one chain. "' ///
		`"Use option {bf:nchains()} to specify multiple chains.{p_end}"'
	}
	else {
	di as err `"{p 4 4 2}You have only `nchains' chains. "' ///
		`"Use option {bf:nchains()} to increase the number of chains.{p_end}"'
	}
end

program _bayes_initials_parse, rclass
	args initial options gtouse nchains

	if `"`initial'"' != "" {
		_mcmc_fv_decode	`"`initial'"' `gtouse'
		local initial `"`s(outstr)'"'
	}
	local initspec `initial'
	local initial
	if `"`initspec'"' != "" {
		local initial initial(`initspec')
	}
	if `nchains' > 1 & `"`initspec'"' != "" {
		di as txt "note: {bf:initial()} is a synonym to {bf:init1()} " ///
			"and applied to the first chain only"
	}
	if `nchains' >= 1 {
		local intitsyn 
		forvalues i = 1/`nchains' {
			local intitsyn `intitsyn' init`i'(string)
		}
		local 0 `", `options'"'
		syntax , [initall(string) `intitsyn' *]
		if `nchains' < 2 & `"`initall'"' != "" {
			_err_msg `"initall()"' `nchains'
			exit 198
		}
		if regexm(`"`options'"', "init[0-9]+") {
			_err_msg `"`=regexs(0)'()"' `nchains'
			exit 198
		}
		if `"`initall'"' != "" {
			_mcmc_fv_decode	`"`initall'"' `gtouse'
			local initall `s(outstr)'
			local initial `initial' initall(`initall')
		}
		if `"`initspec'"' != "" & `"`init1'"' != "" {
			//di as err "options {bf:`initial'} and " ///
			//	`"{bf:init1(`init1')} cannot be combined"'
			di as err "options {bf:initial()} and " ///
				`"{bf:init1()} cannot be combined"'
			exit 198
		}		
		return local init1 `initspec'
		forvalues i = 1/`nchains' {
			if `"`init`i''"' != "" {
				_mcmc_fv_decode	`"`init`i''"' `gtouse'
				local initial `initial' init`i'(`s(outstr)')
				return local init`i' `s(outstr)'
			}
		}
	}
	return local initial = `"`initial'"'
	return local options = `"`options'"'
end

program _bayes_initials_push
	args mcmcobject initial nchains

	if `"`initial'"' == "" {
		exit
	}
	local intitsyn INITial(string)
	forvalues i = 1/`nchains' {
		local intitsyn `intitsyn' init`i'(string)
	}
	local 0 `", `initial'"'
	syntax , [`intitsyn' initall(string) *]
	if `"`initial'"' != "" {
		_bayesmh_init_params `mcmcobject' `"`initial'"' 0
	}
	if `"`initall'"' != "" {
		forvalues i = 1/`nchains' {
			_bayesmh_init_params `mcmcobject' `"`initall'"' 0 `i' 1
		}
	}
	forvalues i = 1/`nchains' {
		if `"`init`i''"' != "" {
			_bayesmh_init_params `mcmcobject' `"`init`i''"' 0 `i'
		}
	}
end
