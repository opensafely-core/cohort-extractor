*! version 1.1.0  08feb2015
program _cmdxel, sclass
	version 8, missing
	args	   c_cmd	/*  1. macro name for the command
		*/ c_names	/*  2. macro name for the stat names
		*/ c_exp	/*  3. macro stub name for the stat expressions
		*/ c_val	/*  4. macro stub name for the stat values
		*/ c_K		/*  5. macro name for # of expressions
		*/ c_rest	/*  6. macro name for the [if] [in] [, options]
		*/ COLON	/*  7.
		*/ stub		/*  8. stub for unnamed statistics
		*/ type		/*  9. "new" or "post"
		*/ caller	/* 10. the calling command
		*/ version	/* 11. _caller() from calling command
		*/ cmd		/* 12. the command in double quotes
		*/
	if "`COLON'" != ":" {
		di as error "_cmdxel: syntax error"
		exit 198
	}
	/* check that the command in "cmd" is valid */
	gettoken usercmd : cmd, parse(" ,:")
	cap which `usercmd'
	if _rc {
		cap program list `usercmd'
		if _rc {
			di as error `"`usercmd' command not found"'
			exit 111
		}
	}

        /* the rest of `0' should be: exp_list [if] [in] [, options] */
	mac shift 12

	/* remove quotes from older -bs- syntax */
	local 0 `*'
	gettoken exp_list 0: 0, parse(" ,")
	local 0 `exp_list' `0'
	/* get exp_list */
	local k 0
	/* default stub is _stub_ */
	if `"`stub'"' == "" {
		local stub _stub_
	}
	else	local stub _`stub'_
	_getxel `type'first `stub' `0'
	while `s(found)' {
		local ++k
		local name_`k' `"`s(name)'"'
		local exp_`k' `"`s(exp)'"'
		local eexp_`k' `"`s(eexp)'"'
		local 0 `s(rest)'
		_getxel `type'second `stub' `0'
	}
	if `k' == 0 {
		di as err "list of statistics not found"
		exit 198 
	}
	if `"`version'"' != "" {
		confirm number `version'
		local vv `version'
		local version `"version `version', missing: "'
	}
	capture syntax [if/] [in/] [, nocheck noheader NOIsily TRace nowarn * ]
	if _rc {
		error 198
	}
	/* run resample check for command */
	if `"`check'"' == "" {
		ResampleCheck		/*
			*/ "`caller'"	/*
			*/ "`version'"	/*
			*/ `"`cmd'"'	/*
			*/ `"`if'"'	/*
			*/ "`in'"	/*
			*/ "`noisily'"	/*
			*/ "`trace'"
		local rc `s(rc)'
		local cmd `s(cmd)'
		local cmdif `s(cmdif)'
		local cmdin `s(cmdin)'
		local cmdnoif `s(cmdnoif)'
		local keep `s(keep)'
		local diwarn `s(diwarn)'
		local inable `s(inable)'
		if `rc' {
			if "`caller'" != "" {
				local caller " `caller'"
			}
			di as err _n "command -> `cmd'"
			di as err ///
`"an error occurred when command was executed on original dataset"'
			di as err `"{p 0 0 2}"' ///
`" please rerun`caller' and specify the {cmd:trace} option to see a "' ///
`"trace of the commands`caller' executed{p_end}"'
			exit `rc'
		}
	}
	if `"`warn'"' == "nowarn" | `"`caller'"' == "" {
		local diwarn
	}

	/* expand eexp's in exp_list */
	local K 0
	forvalues i = 1/`k' {
		if `"`eexp_`i''"' != `""' {
			if `"`check'"' != "" {
				di as err "nocheck option cannot be used" /*
				*/ `" with `eexp_`i''"'
				exit 198
			}
			_getxel2 `eexp_`i''
			tokenize `eexp_`i''
			local type `1'
			local eq `2'
			tempname B
			mat `B' = e(b)
			if "`eq'" != "" {
				if bsubstr("`eq'",1,1) == "#" {
					// equation number specified
					local eqn = bsubstr("`eq'",2,.)
					local eqnames : coleq `B'
					local ueqnames : list uniq eqnames
					local neq : word count `ueqnames'
					// check that `eq' is valid
					if `neq' < `eqn' {
						di as err ///
						"equation `eq' not found"
						exit 111
					}
					local eq : word `eqn' of `ueqnames'
				}
				mat `B' = `B'[1,"`eq':"]
			}
			local cnames : colnames `B'
			local c1 : word 1 of `cnames'
			local n `s(n)'
			local ++K
			if "`c1'" == "_cons" {
				local c1 = bsubstr("`c1'",2,.)
			}
			if "`type'" == "_b" {
				local name`K' = usubstr("b_`c1'",1,32) 
			}
			else local name`K' = usubstr("se_`c1'",1,32)
			capture confirm name `name`K''
			if _rc {
				local name`K' `stub'`K'
			}
			local exp`K' `"`s(e1)'"'
			local temp `c1'
			forvalues j = 2/`n' {
				local cj : word `j' of `cnames'	
				if "`cj'" == "_cons" {
					local cj = bsubstr("`cj'",2,.)
				}
				local junk : subinstr local temp "`cj'" /*
				*/ "`cj'", all count(local m)
				local temp `temp' `cj'
				local ++K
				if `m' == 0  {
					if "`type'" == "_b" {
					local name`K' = usubstr("b_`cj'", 1,32)
					}
					else {
					local name`K' = usubstr("se_`cj'", 1,32)
					}
				}
				else {
					if "`type'" == "_b" {
					local name`K' = usubstr("b_`m'`cj'",1,32)
					}
					else {
					local name`K' = usubstr("se_`m'`cj'",1,32)
					}
				}
				local exp`K' `"`s(e`j')'"'
				capture confirm name `name`K''
				if _rc {
					local name`K' `stub'`K'
				}
			}
		}
		else {
			local ++K
			if "`name_`i''" == "`stub'`i'" {
				local name`K' `stub'`i'
			}
			else local name`K' `name_`i''
			local exp`K' `exp_`i''
		}
	}
	/* check names */
	local names
	forvalues i = 1/`K' {
		local names `names' `name`i''
	}
	confirm names `names'
	/* check list of statistics and save observed values */
	local stats
	tempname x
	forvalues i = 1/`K' {
		capture noi scalar `x' = `exp`i''
		local rc = _rc
		if `rc' {
			sret clear
			di as error `"error in statistic: `exp`i''"'
			exit `rc'
		}
		local val`i' = `x'
	}

	/* save callers new locals */
	c_local `c_K' `K'
	c_local `c_names' `names'
	forvalues k = 1/`K' {
		c_local `c_exp'`k' `exp`k''
		c_local `c_val'`k' = `val`k''
	}
	c_local `c_cmd' `cmd'
	c_local `c_rest' `0'

	/* display command, list of statistics and number of observations */
	if `"`noisily'"' != "" {
		if `"`caller'"' != "" {
			local dicaller "{cmd:`caller'} "
		}
		di in smcl as txt _n "`dicaller'header:"
	}
	if `"`header'"' == "" {
		di as txt _n "command:" _col(15) `"`cmd'"'
		if "`K'" == "1" {
			di as txt "statistic:" _c
		}
		else {
			di as txt "statistics:" _c
		}
		forvalues k = 1/`K' {
			di as txt _col(15) abbrev(`"`name`k''"',10) /*
				*/ _col(25) `" = `exp`k''"'
		}
	}

	/* save return results */
	sret clear
	sret loc cmdif `cmdif'
	sret loc cmdin `cmdin'
	sret loc cmdnoif `cmdnoif'
	sret loc keep `keep'
	sret loc warn `diwarn'
	sret loc inable `inable'
	/* remove global left behind from -_getxel- */
	global S_getxel
end

program ResampleCheck, sclass
	args caller version cmd callerif callerin noisily trace
	if "`trace'" != "" {
		local noisily noisily
		local traceon set trace on
		local traceoff set trace off
	}
	tempname estresample
	capture _est hold `estresample'
	local 0 `cmd'
	syntax [anything(equalok)] [if/] [in/] [, *]
	if `"`if'"' != "" & `"`callerif'"' != "" {
		local if if `if'
		local if `if' & `callerif'
	}
	else if `"`if'`callerif'"' != "" {
		local if if `if'`callerif'
	}
	if `"`in'"' != "" & `"`callerin'"' != "" {
		gettoken command : cmd
		di as err /*
		*/ "{cmd:in} option may be allowed in {cmd:`command'}" /*
		*/ " or {cmd:`caller'}, but not both"
		exit 198
	}
	else if `"`in'`callerin'"' != "" {
		local in in `in'`callerin'
	}
	if `"`if'"' != "" & `"`in'"' != "" {
		local ifin `if' `in'
	}
	else if `"`if'`in'"' != "" {
		local ifin `if'`in'
	}
	if `"`options'"' != "" {
		local options `", `options'"'
		local optionsnoif `"`options' ,"'
	}
	/* rebuild cmd */
	local cmd `"`anything' `ifin' `options'"'
	local cmd : list retok cmd
	local cmdnoif `"`anything' `in' `optionsnoif'"'
	local cmdnoif : list retok cmdnoif
	if "`noisily'" != "" {
		di
		if `"`caller'"' != "" {
			di `"{cmd:`caller'}: "' _c
		}
		di	as txt "First call to ("	///
			as inp `"`cmd'"'		///
			as txt ") with data as is:" _n
		di as inp `". `cmd'"'
	}
	local inable inable
	local rc 0
	if `"`in'"' == "" {
		local cmdin `"`anything' `if' in 1/l `options'"'
		capture `noisily' `version'`cmdin'
		if _rc {
			local inable
			`traceon'
			capture noi qui `noisily' `version'`cmd'
			`traceoff'
		}
		local rc = _rc
	}
	else {
		`traceon'
		capture noi qui `noisily' `version'`cmd'
		`traceoff'
		local rc = _rc
	}
	if ! `rc' {
		/* check for unused observations */
		capture assert e(sample) == 1
		if _rc {
			capture assert e(sample) == 0
			if _rc {
				sret loc keep keep if e(sample)
			}
			else {
				sret loc diwarn /*
				*/ _resample_warn `caller' `"`cmd'"'
			}
		}
			capture _est drop `estresample'
	}
	capture est unhold `estresample'
	/* let the caller handle any errors */
	sret loc rc `rc'
	sret loc cmd `cmd'
	sret loc cmdif `if'
	sret loc cmdin `in'
	sret loc cmdnoif `cmdnoif'
	sret loc inable `inable'
end
exit
