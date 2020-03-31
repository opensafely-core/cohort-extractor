*! version 1.0.1  30jan2020
program define meta__parse_transform
	version 16
	
	args fn invfcn fnlbl colon transform
				
	local pos = ustrpos(`"`transform'"', ":")
	local l = ustrlen(`"`transform'"')
	
	local msg "option {bf:transform()} invalid;"
	
	if `pos' > 0 {
		local fcn  = usubstr(`"`transform'"', `=`pos'+1', `l')
		local label =  ustrrtrim(usubstr(`"`transform'"',1,`=`pos'-1'))
		if missing("`fcn'") {
			di as err "{p}you must specify a transformation " ///
				"in option {bf:transform()}{p_end}"
			exit 198
		}
	}
	else local fcn `"`transform'"'
	
	_parse comma lhs rhs : fcn
	if "`rhs'" == "" | "`rhs'" == "," {
		c_local `invfcn' ""	
	}
	else {
		local 0 `rhs'
		syntax [, invfn(string) *] 
		
		if "`options'" != "" {
			if `:length local options' {
			gettoken tok : options, bind
				di as err "`msg'"
				di as err "option {bf:`tok'} not allowed"
				exit 198
			}
		}
		
		if !missing("`invfn'") {
			local pos = ustrpos("`invfn'", "@")
			if !`pos' {
				di as err "`msg'"
				di as err "expression in {bf:invfn()} " ///
					"must be in the form of f(@)"
				exit 198	
			}
			
			local fcn = subinstr("`invfn'", "@","_meta_es",.)
	
			tempvar check
			cap gen `check' = `fcn'
			if _rc {
				di as err "`msg'"
				gen `check' = `fcn'
			}
		}
	}
	
	local fn_of_at `lhs'
	local pos = ustrpos(`"`fn_of_at'"', "@")
	if !`pos' {
		local 0, `lhs'
		local syntax syntax [, tanh exp invlogit efficacy corr *]
		
		capture `syntax'
		if _rc {
			di as err "`msg'"
			`syntax'
			error 198	
		}
			
		opts_exclusive ///
			"`tanh' `exp' `invlogit' `efficacy' `corr'" transform
		if `:length local options' {
			gettoken tok : options, bind
			di as err "`msg'"
			di as err "transformation {bf:`tok'} not allowed"
			exit 198
		}
		
		if !missing("`tanh'`corr'") {
			local fn_of_at "tanh(@)"
			local invfn "atanh(@)"
		}
		else if !missing("`exp'") {
			local fn_of_at "exp(@)"
			local invfn "log(@)"
		}
		else if !missing("`invlogit'") {
			local fn_of_at "invlogit(@)"
			local invfn "logit(@)"
		}
		else if !missing("`efficacy'") {
			local fn_of_at "-expm1(@)"
			local invfn "log1m(@)"
		}
	}
	else {
		local fcn = subinstr("`fn_of_at'", "@", "_meta_es", .)
	
		tempvar check
		cap gen `check' = `fcn'
		if _rc {
			di as err "`msg'"
			gen `check' = `fcn'
		}
	}
	
	c_local `invfcn' `invfn'
	c_local `fn' `fn_of_at'
	c_local `fnlbl' `"`label'"'
	// c_local legend = cond(missing("`legend'"), 1, 0)
	c_local tr_fn `"`tanh'`exp'`invlogit'`efficacy'`corr'"'
end
