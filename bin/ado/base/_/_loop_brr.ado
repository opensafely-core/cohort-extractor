*! version 1.5.0  04mar2019
program _loop_brr
	version 9
	set buildfvinfo off			// auto-reset on exit
	set prefix _loop _loop_brr
	syntax namelist(min=5) ,		///
		command(string asis)		///
		express(string asis)		///
		cmd1(string asis)		///
		wvar(varname)			///
		Hadamard(name)			///
		FAY(numlist >=0 <= 2 max=1)	///
		postid(name)			///
		[				///
			calwvar(varname)	///
			calmethod(string)	///
			calmodel(string)	///
			calopts(string)		///
			POSTS(varname)		///
			POSTW(varname numeric)	///
			pstrwvar(varname)	///
			cmd2(string asis)	///
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
	gettoken touse  namelist : namelist
	gettoken subuse namelist : namelist
	gettoken strid  namelist : namelist
	gettoken psuid  pseudo   : namelist
	if `K' != `: word count `pseudo'' {
		di as err "internal error in brr"
		exit 9		// [sic] this should never happen
	}
	forval j = 1/`K' {
		local tv`j' : word `j' of `pseudo'
		local ppseudo `ppseudo' (`tv`j'')
		local missing `missing' (.)
	}
	local noi = cond("`noisily'"=="","*","noisily")

	tempname nobs
	tempvar twvar
	quietly gen double `twvar' = .

	if "`posts'" != "" {
		if "`pstrwvar'" == "" {
			tempname pstrwvar
		}
		if "`postw'" == "" {
			di as err "option posts() requires the postw() option"
			exit 198
		}
		local pstr posts(`posts') postw(`postw')
		local uwvar `pstrwvar'
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
	else	local uwvar `twvar'
	if `fay' == 0 {
		local inwgt "2*`wvar'"
		local outwgt "0"
	}
	else if `fay' == 2 {
		local inwgt "0"
		local outwgt "2*`wvar'"
	}
	else {
		local inwgt "(2-`fay')*`wvar'"
		local outwgt "`fay'*`wvar'"
	}

	tempname h
	local ncols = colsof(`hadamard')
	matrix `h' = (J(`ncols',`ncols',3)-`hadamard')/2
	if "`nodots'" == "" | "`noisily'" != "" {
		di
		_dots 0, title(BRR replications) reps(`ncols') `nodots' `dots'
	}
	local omit 0
	local rejected 0
	forval j = 1/`ncols' {
		// adjust weights
		quietly replace `twvar' = ///
		cond(`h'[`j',`strid']==`psuid',`inwgt',`outwgt')
		if "`posts'" != "" {
			capture drop `pstrwvar'
			svygen post double `pstrwvar' [iw=`twvar'] ///
				if `touse' == 1, `pstr'
		}
		else if "`calmethod'" != "" {
			capture drop `calwvar'
			quietly ///
			svycal `calmethod' `calmodel' [iw=`twvar'] ///
				if `touse' == 1, generate(`calwvar') `calopts'
		}
		`noi' di as inp `". `command'"'
		if `is_st' {
			quietly streset [iw=`uwvar']
		}
		else	local wgt "[iw=`uwvar']"
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
		if c(rc) {
			`noi' di in smcl as error ///
`"{p 0 0 2}an error occurred when brr executed `cmdname', "' ///
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
			post `postid' `missing'
		}
		else {
			post `postid' `ppseudo'
		}
		`star' `j' `bad' , `dots'
	}
	`star' `ncols' , `dots'
end
exit
