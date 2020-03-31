*! version 1.3.0  04mar2019
program _loop_jknife_fw
	version 9
	set buildfvinfo off			// auto-reset on exit
	set prefix _loop _loop_jknife_fw
	syntax namelist(min=3) ,		///
		command(string asis)		///
		express(string asis)		///
		cmd1(string asis)		///
		wvar(varname)			///
		n0(string)			///
		postid(name)			///
		[				///
			cmd2(string asis)	///
			nclust(integer 0)	///
			nfunc(string)		///
			NODOTS			///
			DOTS(integer 1)		///
			NOIsily			///
			trace			///
			reject(string asis)	///
			stset			///
			checkmat(name max=1)	///
		]

	gettoken cmdname : command
	local is_st = "`stset'" != ""
	if `"`cmd2'"' != "" {
		local cmd2 `", `cmd2'"'
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
	gettoken clid  pseudo   : namelist
	confirm var `touse' `clid'
	if `K' != `: word count `pseudo'' {
		di as err "internal error in jackknife"
		exit 9		// [sic] this should never happen
	}
	forval j = 1/`K' {
		local tv : word `j' of `pseudo'
		local ppseudo `ppseudo' (`tv')
		local missing `missing' (.)
	}
	local noi = cond("`noisily'"=="","*","noisily")

	tempname nobs
	if "`nodots'" == "" | "`noisily'" != "" {
		di
		_dots 0, title(Jackknife replications) reps(`nclust') `nodots' `dots'
	}
	local omit 0
	local rejected 0
	forval j = 1/`nclust' {
		`noi' di as inp `". `command'"'
		quietly count if `clid' == `j' & `touse' == 1
		scalar `nobs' = r(N)
		// adjust weights
		quietly replace `wvar' = `wvar' - 1 ///
			if `clid' == `j' & `touse' == 1
		if `is_st' {
			quietly streset [fweight=`wvar']
		}
		else	local wgt "[fweight=`wvar']"
		`traceon'
		capture `noiqui' `noisily'	///
			`cmd1' `wgt' if `touse' == 1 `cmd2'
		`traceoff'
		if (c(rc) == 1)	error 1
		local bad = c(rc) != 0
		if c(rc) {
			`noi' di in smcl as error ///
`"{p 0 0 2}an error occurred when jackknife executed `cmdname', "' ///
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
					local tv : word `i' of `pseudo'
					capture scalar `tv' = `exp`i''
					if (c(rc) == 1)	error 1
					if c(rc) {
						scalar `tv' = .
					}
					if missing(`tv') {
						local bad 2
						`noi' di as error ///
`"{p 0 0 2}captured error in `exp`i'', posting missing value{p_end}"'
					}
				}
				if `"`nfunc'"' != "" {
					local nn = int(`nfunc')
					// keep the value
					if `nn' != `n0'-`nobs' {
						local bad 3
					}
				}
			}
		}
		`star' `j' `bad' , `dots'
		// un-adjust weights
		quietly replace `wvar' =  `wvar' + 1 ///
			if `clid' == `j' & `touse' == 1
		if inlist(`bad', 1, 3) {
			post `postid' (`j') (.) `missing'
		}
		else {
			sum `wvar' if `clid' == `j' & `touse' == 1, mean
			post `postid' (`j') (`r(max)') `ppseudo'
		}
	}
	`star' `nclust' , `dots'
end
exit
