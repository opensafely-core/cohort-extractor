*! version 1.2.0  04mar2019
program _loop_bs
	version 10
	set buildfvinfo off			// auto-reset on exit
	set prefix _loop _loop_bs
	local version : di "version " string(_caller()) ", missing:"
	syntax ,				///
		cmdname(name)			///
		command(string asis)		///
		express(string asis)		///
		postid(name)			///
		reps(integer)			///
		[				///
			size(string)		///
			strata(varlist)		///
			cluster(varlist)	///
			NODOTS			///
			DOTS(integer 1)		///
			NOIsily			///
			trace			///
			reject(string asis)	///
			group(varname)		///
			idcluster(varname)	///
			panelvar(varname)	///
			timevar(varname)	///
			checkmat(name max=1)	///
		]

	if `"`strata'"' != "" {
		local bsamopts strata(`strata')
	}
	if `"`cluster'"' != "" {
		local bsamopts `bsamopts' ///
			cluster(`cluster') idcluster(`idcluster')
	}

	if "`trace'" != "" {
		local noisily	noisily
		local traceon	set trace on
		local traceoff	set trace off
	}
	
	if `dots'==0 {
		local nodots nodots
		local dots
	}
	else local dots dots(`dots')
	
	if "`noisily'" != "" {
		local nodots nodots
	}
	if "`nodots'"=="nodots" {
		local star "*"
		local noiqui noisily quietly
	}
	else	local star _dots
	local K 0
	while `"`express'"' != "" {
		gettoken exp`++K' express : express,	///
			parse("()") bind match(par)
		tempname x`K'
		local xstats `xstats' (`x`K'')
		local mis `mis' (.)
	}
	local noi = cond("`noisily'"=="","*","noisily")
	if `"`panelvar'`timevar'"' != "" {
		local tsop 1
	}
	else	local tsop 0

	if "`nodots'" == "" | "`noisily'" != "" {
		di
		_dots 0, title(Bootstrap replications) reps(`reps') `nodots'
	}
	local omit 0
	local rejected 0
	preserve
	forvalues i = 1/`reps' {
		`version' bsample `size' , `bsamopts'
		if "`group'" != "" {
			tempvar newgroup
			sort `strata' `idcluster' `group', stable
			quietly by `strata' `idcluster' `group': ///
				gen `newgroup' = _n==1
			quietly replace `newgroup' = sum(`newgroup')
			drop `group'
			rename `newgroup' `group'
		}
		if `tsop' {
			// -tsset- will result in an error if the user
			// misspecified one or more of the -cluster()-,
			// -idcluster()-, and -group()- options

			capture noisily quietly ///
				tsset `panelvar' `timevar', noquery
			if c(rc) {
				di as err "{p 0 0 2}" ///
"the most likely cause for this error is misspecifying the cluster(), " ///
"idcluster(), or group() option{p_end}"
				exit c(rc)
			}
		}
		// run command and post results
		`noi' di as inp `". `command'"'
		`traceon'
		capture `noiqui' `noisily' `version' `command'
		`traceoff'
		if (c(rc) == 1)	error 1
		local bad = c(rc) != 0
		if c(rc) {
			`noi' di as error ///
`"{p 0 0 2}an error occurred when bootstrap executed `cmdname', "' ///
`"posting missing values{p_end}"'
			post `postid' `mis'
		}
		else {
			if "`checkmat'" != "" {
				_check_omit `checkmat', check result(omit)
			}
			if `"`reject'"' != "" {
				capture local rejected = `reject'
				if c(rc) {
					local rejected 1
				}
			}
			if `omit' {
				local bad 1
				`noi' di as error ///
`"{p 0 0 2}collinearity in replicate sample is "' ///
`"not the same as the full sample, posting missing values{p_end}"'
				post `postid' `mis'
			}
			else if `rejected' {
				local bad 1
				`noi' di as error ///
`"{p 0 0 2}rejected results from `cmdname', "' ///
`"posting missing values{p_end}"'
				post `postid' `mis'
			}
			else {
				forvalues j = 1/`K' {
					capture scalar `x`j'' = `exp`j''
					if (c(rc) == 1)	error 1
					if c(rc) {
						local bad 1
						`noi' di as error ///
`"{p 0 0 2}captured error in `exp`j'', posting missing value{p_end}"'
						scalar `x`j'' = .
					}
					else if missing(`x`j'') {
						local bad 1
					}
				}
				post `postid' `xstats'
			}
		}
		`star' `i' `bad' , `dots'

		restore, preserve
	}
	`star' `reps' , `dots'
end
exit
