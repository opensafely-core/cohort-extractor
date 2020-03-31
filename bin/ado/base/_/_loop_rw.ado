*! version 1.6.0  04mar2019
program _loop_rw
	version 9
	set buildfvinfo off			// auto-reset on exit
	set prefix _loop _loop_rw
	// NOTE:  This is a subroutine of jackknife.ado and brr.ado
	syntax namelist(min=3) ,		///
		command(string asis)		///
		express(string asis)		///
		cmd1(string asis)		///
		rwvars(varlist)			///
		owvar(varname)			///
		caller(name)			///
		postid(name)			///
		[				///
			calwvar(varname)	///
			calmethod(string)	///
			calmodel(string)	///
			calopts(string)		///
			POSTS(varname)		///
			POSTW(varname numeric)	///
			pstrwvar(varname)	///
			postextra(varlist)	///
			postconstants(string)	///
			cmd2(string asis)	///
			NODOTS			///
			DOTS(integer 1)		///
			NOIsily			///
			trace			///
			reject(string asis)	///
			stset			///
			checkmat(name max=1)	///
			sdot			///
		]
	gettoken cmdname : command
	local is_st = "`stset'" != ""
	local svyprop = inlist("`cmdname'", "prop", "proportion")
	if `svyprop' {
		local cmd2 `cmd2' svyrw subpop(\`subuse')
	}
	if `"`cmd2'"' != "" {
		local cmd2 `", `macval(cmd2)'"'
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
	}
	gettoken touse namelist : namelist
	gettoken subuse pseudo : namelist
	if `K' != `: word count `pseudo'' {
		local caller = lower("`caller'")
		di as err "internal error in `caller'"
		exit 9		// [sic] this should never happen
	}
	forval j = 1/`K' {
		local tv`j' : word `j' of `pseudo'
		local ppseudo `ppseudo' (`tv`j'')
		local missing `missing' (.)
	}
	local noi = cond("`noisily'"=="","*","noisily")

	local sortvars : sortedby
	tempname nobs
	local nreps : word count `rwvars'
	if "`nodots'" == "" | "`noisily'" != "" {
		di
		_dots 0, title(`caller' replications) reps(`nreps') `nodots' `dots'
	}
	local omit 0
	local rejected 0
	foreach var of local postextra {
		local pextra `macval(pextra)' (`var'[\`j'])
	}
	foreach val of local postconstants {
		local pextra `macval(pextra)' (`val')
	}
	if "`posts'" != "" {
		if "`pstrwvar'" == "" {
			tempname pstrwvar
		}
		if "`postw'" == "" {
			di as err "option posts() requires the postw() option"
			exit 198
		}
		local pstr posts(`posts') postw(`postw')
	}
	else if "`calmethod'" != "" {
		if "`calwvar'" == "" {
			tempname calwvar
		}
		if "`calmodel'" == "" {
			di as err ///
			"option calmethod() requires the calmodel() option"
			exit 198
		}
		if "`calopts'" == "" {
			di as err ///
			"option calmethod() requires the calopts() option"
			exit 198
		}
		local uwvar `calwvar'
	}
	local sdot : length local sdot
	forval j = 1/`nreps' {
		local wvar : word `j' of `rwvars'
		if `sdot' {
			// check against original weight var , e.g:
			//		`wvar' < `owvar'
			quietly count if `wvar' != `owvar' & `subuse'
			if r(N) == 0 {
				// does not affect subpop identified by `subuse'
				`star' `j' -1 , `dots'
				continue
			}
		}
		if "`posts'" != "" {
			capture drop `pstrwvar'
			svygen post double `pstrwvar' [iw=`wvar'] ///
				if `touse' == 1, `pstr'
			local wvar `pstrwvar'
		}
		else if "`calmethod'" != "" {
			capture drop `calwvar'
			quietly ///
			svycal `calmethod' `calmodel' [iw=`wvar'] ///
				if `touse' == 1, generate(`calwvar') `calopts'
			local wvar `calwvar'
		}
		`noi' di as inp `". `command'"'
		if `is_st' {
			quietly streset [iw=`wvar']
		}
		else	local wgt "[iw=`wvar']"
		if `svyprop' {
			`traceon'
			capture `noiqui' `noisily'	///
				`cmd1' `wgt' if `touse' `cmd2'
			`traceoff'
		}
		else {
			`traceon'
			capture `noiqui' `noisily'	///
				`cmd1' `wgt' if `subuse' `cmd2'
			`traceoff'
		}
		if (c(rc) == 1)	error 1
		local bad = c(rc) != 0
		if "`:sortedby'" != "`sortvars'" {
			sort `sortvars', stable
		}
		if c(rc) {
			`noi' di in smcl as error ///
`"{p 0 0 2}an error occurred when `caller' executed `cmdname', "' ///
`"posting missing values{p_end}"'
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
			}
			else if `rejected' {
				local bad 1
				`noi' di as error ///
`"{p 0 0 2}`caller' rejected results from `cmdname', "' ///
`"posting missing values{p_end}"'
			}
			else {
				forval i = 1/`K' {
					capture scalar `tv`i'' = `exp`i''
					if (c(rc) == 1)	error 1
					if c(rc) {
						scalar `tv`i'' = .
					}
					if missing(`tv`i'') {
						local bad 2
						`noi' di as error ///
`"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
					}
				}
			}
		}
		if inlist(`bad', 1, 3) {
			post `postid' `pextra' `missing'
		}
		else {
			post `postid' `pextra' `ppseudo'
		}
		`star' `j' `bad' , `dots'
	}
	`star' `nreps' , `dots'
end
exit
