*! version 1.0.8  20jan2015
program stpower
	version 10
	gettoken cmd 0 : 0, parse(" ,")
	local len = length(`"`cmd'"')
	if `"`cmd'"' == "," | `"`cmd'"' == "" {
		di as err "one of cox, logrank, or exponential subcommands " ///
			  "must be specified"
		exit 198
	}
	else if `"`cmd'"' == bsubstr("logrank",1,`len') & `len'>=3 {
		local cmd log
		local argnames survival probabilities
		local argname survival probability
	}
	else if `"`cmd'"' == bsubstr("exponential",1,`len') & `len'>=3 {
		local cmd exp
		syntax [anything] [, T(string) *]
		if `"`t'"' != "" {
			local argnames survival probabilities
			local argname survival probability
		}
		else {
			local argnames hazard rates
			local argname hazard rate
		}
	}
	else if `"`cmd'"' == "cox" {
		local cmd cox
		local argnames coefficients
	}
	else {
		di as err "unknown stpower subcommand `cmd'"
		exit 198
	}
	gettoken arg1 0 : 0, match(parent) parse(" ,")
	if `"`arg1'"' == "" | `"`arg1'"' == "," {
		local 0 , `0'
		local arg1
	}
	else {
		gettoken arg2 0: 0, match(parent) parse(" ,")
		if `"`arg2'"' == "" | `"`arg2'"' == "," {
			local 0 , `0'
			local arg2
		}
		else if `"`cmd'"' == "cox" {
			di as err `"{p}too many `argnames' or you omitted "' ///
				  "the parentheses from a numlist{p_end}"
			exit 198
		}
	}
	gettoken comma: 0, match(parent) parse(" ,")
	if `"`comma'"' == "," {
		local 0 `0' arg1(`arg1') arg2(`arg2')
	}
	else if `"`comma'"' == "" {
		local 0 , `0' arg1(`arg1') arg2(`arg2')
	}
	else {
		di as err `"{p}too many `argnames' or you omitted "' ///
			  "the parentheses from a numlist{p_end}"
		exit 198
	}
	syntax [, arg1(string) arg2(string) HRATio(string) Alpha(string) ///
		  Power(string) Beta(string) N(string) p1(string) 	 ///
		  NRATio(string) DETAIL PARallel NOTABLE TABle		 ///
		  COLumns(string) COLWidth(string) 			 ///
		  noHEADer CONTinue noTItle noLEGend T(string) 		 ///
		  SEParator(string) SAVing(string) noOUTPUT * ]
	if `"`t'"' != "" {
		if `"`cmd'"' != "exp" {
			di as err "t() not allowed"
			exit 198
		}
		local options `options' t(`t')
	}
	if "`detail'" != "" {
		if `"`cmd'"' != "exp" {
			di as err "detail not allowed"
			exit 198
		}
		if `"`table'`columns'"' != "" {
			di as err "detail may not be combined with " ///
				  "table or columns()"
			exit 198
		}
		local options `options' detail
	}
	/* handle numlists */
	if `"`arg1'"' != "" {
		cap numlist `"`arg1'"'
		if _rc == 121 {
			di as err `"`argnames' must be numeric"'
			exit 198
		}
		if `"`cmd'"' == "log" | (`"`cmd'"' == "exp" & `"`t'"' != "") {
			cap numlist `"`arg1'"', range(>0 <1)
			if _rc == 125 {
				di as err "survival probabilities must be " ///
					  "numbers between 0 and 1"
				exit 198
			}
		}
		else if `"`cmd'"' == "exp" {
			cap numlist `"`arg1'"', range(>0)
			if _rc == 125 {
				di as err "hazard rates must be positive " ///
					  "numbers"
				exit 198
			}
		}
		local arg1 `r(numlist)'
	}
	if `"`arg2'"' != "" {
		cap numlist `"`arg2'"'
		if _rc == 121 {
			di as err `"`argnames' must be numeric"'
			exit 198
		}
		if `"`cmd'"' == "log" | (`"`cmd'"' == "exp" & `"`t'"' != "") {
			cap numlist `"`arg2'"', range(>0 <1)
			if _rc == 125 {
				di as err "survival probabilities must be " ///
					  "numbers between 0 and 1"
				exit 198
			}
		}
		else if `"`cmd'"' == "exp" {
			cap numlist `"`arg2'"', range(>0)
			if _rc == 125 {
				di as err "hazard rates must be positive " ///
					  "numbers"
				exit 198
			}
		}
		local arg2 `r(numlist)'
	}
	if `"`hratio'"' != "" {
		if `"`arg2'"' != "" {
			di as err `"{p}`argname' in the experimental group"' ///
				  " may not be combined with hratio(){p_end}"
			exit 198
		}
		else if `"`cmd'"' == "cox" & `"`arg1'"' != "" {
			di as err "coefficient value may not be combined " ///
				  "with hratio()" 
			exit 198
		}
		cap numlist `"`hratio'"', range(>0)
		if _rc {
			di as err "hratio() values must be positive "	/// 
				  "numbers different from 1"
			exit 198
		}
		local hratio  `r(numlist)'
	}
	if `"`power'"' != "" {
		if `"`beta'"' != "" {
			di as err "power() and beta() may not be combined"
			exit 198
		}
		cap numlist `"`power'"', range(>0 <1)
		if _rc {
			di as err "power() values must be numbers "	/// 
				  "between 0 and 1"
			exit 198
		}
		local power `r(numlist)'
		local powbet power
	}
	if `"`beta'"' != "" {
		cap numlist `"`beta'"', range(>0 <1)
		if _rc {
			di as err "beta() values must be numbers "	/// 
				  "between 0 and 1"
			exit 198
		}
		local beta `r(numlist)'
		local powbet beta
	}
	if `"`alpha'"' != "" {
		cap numlist `"`alpha'"', range(>0 <1)
		if _rc {
			di as err "alpha() values must be numbers "	/// 
				  "between 0 and 1"
			exit 198
		}
		local alpha `r(numlist)'
	}
	if `"`n'"' != "" {
		if `"`powbet'"' != "" {
			if "`cmd'" == "exp" {
        	        	di as err 	///
				    `"n() and `powbet'() may not be combined"'
				exit 198
			}
			else if `"`hratio'"' != "" {
di as err `"hratio() may not be combined with n() and `powbet'()"'
exit 198
			}
			if ("`cmd'" == "cox" & `"`arg1'"' != "") {
di as err `"coefficient value may not be combined with n() and `powbet'()"'
exit 198
			}
			else if ("`cmd'" == "log" & `"`arg2'"' != "") {
di as err "{p}survival probability in the experimental group "	///
	  `"may not be combined with n() and `powbet'(){p_end}"'
exit 198
			}
		}
		cap numlist `"`n'"', range(>1) integer
		if _rc {
			di as err "n() values must be integers "	/// 
				  "greater than 1"
			exit 198
		}
		local n `r(numlist)'
	}
	if `"`p1'"' != "" {
		if `"`cmd'"' == "cox" {
			di as err "p1() not allowed"
			exit 198
                }
		cap numlist `"`p1'"', range(>0 <1)
		if _rc {
			di as err "p1() values must be numbers "	/// 
				  "between 0 and 1"
			exit 198
		}
		local p1 `r(numlist)'
	}
	if `"`nratio'"' != "" {
		if `"`cmd'"' == "cox" {
			di as err "nratio() not allowed"
			exit 198
                }
		cap numlist `"`nratio'"', range(>0)
		if _rc {
			di as err "nratio() values must be positive numbers " 
			exit 198
		}
		local nratio `r(numlist)'
	}

	local nopts: word count `table' `notable'
	if `nopts' > 1 {
		di as err "table and notable may not be combined"
		exit 198
	}
	local ditable
	if `"`columns'"' != "" {
		if `"`notable'"' != "" {
			di as err ///
			   "notable and columns() may not be combined"
			exit 198
		}
		local ditable tablecol(`columns')
	}
	else if "`table'" != "" { /* default columns */
		local ditable table
	}
	else if "`notable'" != "" {
		local ditable
	}
	if `"`n'"' == "" {
		local compute n
	}
	else if `"`power'"' == "" & `"`beta'"' == "" {
		local compute power
	}
	else {
		local compute hratio
	}
	// number of elements
	local narg1:	word count `arg1'
	local narg2:	word count `arg2'
	local nhratio:	word count `hratio'
	local nalpha:	word count `alpha'
	local nn:	word count `n'
	if `"`beta'"' != "" {
		local npower = 0
		local powbet beta
	}
	else {
		local nbeta = 0
		local powbet power
	}
	local n`powbet': word count ``powbet''
	if `"`nratio'"' != "" {
		if `"`p1'"' != "" {
			di as err ///
			   "p1() and nratio() may not be combined"
			exit 198
		}
		local alloc nratio
		local np1 = 0
	}
	else {
		local alloc p1
		local nnratio = 0
	}
	local n`alloc': word count ``alloc''
	local nvals `narg1' `narg2' `nhratio' `n`powbet'' `nalpha'
	local nvals `nvals' `n`alloc'' `nn'
	local nopts = 7
	tokenize `nvals'
	local total = 1
	forvalues i = 1/7 {
		if ``i'' != 0 {
			local total = `total'*``i''
		}
	}
	if `total' > 1 { /* display table */
		if `"`notable'"' == "" & `"`columns'"' == "" {
			local ditable table
		}
	}
	if `"`saving'"' != "" {
		if `"`ditable'"' != "" {
			tempname tabpost
			local postname postname(`tabpost')
			_prefix_saving `saving'
			local saving    `"`s(filename)'"'
			local replace   `"`s(replace)'"'
			cap confirm new file `"`saving'"'
			if _rc {
				tempfile holdfile
				copy `"`saving'"' `"`holdfile'"'
			}
		}
		else {
			if `total' == 1 {
				di as err "{p}saving() requires tabular " ///
				    "output; specify table or columns(){p_end}"
				exit 198
			}
			else if `"`notable'"' != "" {
				di as err "saving() may not be combined " ///
				 	  "with notable"
				exit 198
			}
		}
	}
	if `"`ditable'"' == "" {
		if `"`separator'`header'`continue'`colwidth'"' != "" | /// 
		    `"`title'`legend'"' != "" {
			if `"`notable'"' != "" {
				local errmsg may not be combined with notable
			}
			else {
				local errmsg require table or columns()
			}
			di as err "{p 0 0 30}noheader, notitle, "	///
				  "continue, nolegend, separator(), "	///
				  "and colwidth() `errmsg'{p_end}"	 
			exit 198
		}
	}
	if `"`separator'"' == "" {
		local separator = 0
	}
	else {
		cap confirm integer number `separator'
		if _rc {
			di as err "separator() must be a nonnegative integer"
			exit 198
		}
		cap assert `separator' >=0
		if _rc {
			di as err "separator() must be a nonnegative integer"
			exit 198
		}
	}
	if `"`colwidth'"' != "" {
		cap numlist `"`colwidth'"', range(>=4) integer miss
		if _rc {
			di as err "colwidth() values must be integers " ///
				  "between 4 and 20 or must be missing"
			exit 198
		}
		local colwidth: subinstr local colwidth "." "9", all word
		cap numlist `"`colwidth'"', range(>=4 <=20) integer
		if _rc {
			di as err "colwidth() values must be integers " ///
				  "between 4 and 20 or must be missing"
			exit 198
		}
		local colwidth `r(numlist)'
		local ditable `ditable' colwidth(`colwidth')
	}
	local tabopts `title' `legend' saving(`"`saving'"') `replace' `postname'
	local tabopts `tabopts' `output'
	
	if `"`parallel'"' != "" {
		numlist `"`nvals'"', sort
		local nvals `r(numlist)'
		local max: word `nopts' of `nvals'
		local max = max(1, `max')
	}
	local numopts alpha `alloc' arg1 arg2 hratio `powbet' n
	foreach opt of local numopts {
		if `n`opt'' != 0 {
			/*check number of elements in numlists for parallel*/
			if `"`parallel'"' != "" {
				if (`n`opt''>1 & `n`opt''<`max') {
di as err "{p 0 0 32}options with multiple values must have equal numbers " ///
	  "of elements if parallel is specified{p_end}"
exit 198
				}
			}
			local numoptnames `numoptnames' `opt'
			local numoptvals `numoptvals' (``opt'')
		}
	}
	local otheropts `options' `tabopts'
	if `"`ditable'"' != "" {
		local cnt `continue'
		local head `header'
	}
	local firstpart firstpart
	while `"$STPOW_cols"' != "" | "`firstpart'" != "" {
		if `"`parallel'"' != "" { /* parallel */
			cap noi DoParallel `cmd', 			    ///
					opt(`"`numoptnames'"')		    ///
					optval(`"`numoptvals'"')	    ///
					other(`"`otheropts'"') 		    ///
					ditab(`ditable') 		    ///
					max(`max') sep(`separator')	    ///
					`firstpart' `cnt' `head' `notable'
			local cmderr = _rc
		} /* end parallel */
		else { /* nested output */
			global STPOW_index = 1
			cap noi DoNested `cmd', 			    ///
					opt(`"`numoptnames'"')		    ///
					optval(`"`numoptvals'"')	    ///
					other(`"`otheropts'"')		    ///
					ditab(`ditable') 		    ///
					total(`total') sep(`separator')	    ///
					`firstpart' `cnt' `head' `notable'
			local cmderr = _rc
			cap macro drop STPOW_index
		} /* end nested */
		if `cmderr' {
			if `"`saving'"' != "" {
				cap postclose `tabpost'
				if `"`replace'"' == "" {
					cap erase `"`saving'"'
				}
				else if `"`holdfile'"' != "" {
					cap confirm new file `"`holdfile'"'
					if  _rc {
						copy `"`holdfile'"' ///
						     `"`saving'"', replace
					}
				}
			}
			cap macro drop STPOW_colw STPOW_cols STPOW_holdtab
			cap sreturn clear
			exit `cmderr'
		}
		local ditable tablecol($STPOW_cols) colw($STPOW_colw)
		local firstpart
	} /* end while */
	if `"`saving'"' != "" {
		cap postclose `tabpost'
	}
	cap macro drop STPOW_colw STPOW_cols STPOW_holdtab
	cap sreturn clear
end

program DoParallel
	version 10.0
	syntax [anything] [, opt(string) optval(string) max(real 1)	   ///
			     other(string) ditab(string) CONTINUE noHEADER ///
			     SEParator(real 0) FIRSTPART NOTABLE ]
	forvalues i = 1/`max' {
		if `i' == 1 & `"`firstpart'"' != "" {
			local firstcall firstcall
		}
		if `i' == `max' {
			local lastcall lastcall
		}
		if `"`ditab'"' != "" {
			if `"`continue'"' != "" {
				local cnt `continue'
			}	
			else if `i' == `max' {
				local cnt
			}
			else {
				local cnt continue
			}
			if `"`header'"' != "" {
				local head `header'
			}
			else if `i' != 1 {
				local head noheader
			}
			if mod(`i',`separator') == 0 {
				local sep separator
			}
			else {
				local sep
			}
		}
		local args
		local nextopt
		local holdoptval `optval'
		foreach optname of local opt {
			gettoken vals holdoptval: holdoptval, match(parent)
			tokenize `vals'
			if `"`2'"' == "" {
				local index = 1
			}
			else {
				local index = `i'
			}
			if `"`optname'"' == "arg1" | `"`optname'"' == "arg2" {
				local args `args' ``index''
			}
			else {
				local nextopt `nextopt' `optname'(``index'')
			}
		}
		_stpower `anything' `args', `nextopt' `other' `ditab'	///
					    `cnt' `head' `sep'		///
					    `firstcall' `lastcall' `firstpart' 
		if `"`notable'"' != "" {
			display _n
		}
		local firstcall
	} /* end forvalues */
end

/* recursively calls _stpower if number lists are specified in options */
/*
	opt()	  - list of option names with multiple values
	optval()  - list of option values enclosed in parentheses
	newopt()  - list of options passed to _stpower at each recursion step
	args()	  - list of arguments passed to _stpower at each rec. step
	other()   - the rest of -stpower- options
	total()	  - the total number of executions of _stpower
	firstpart - the first part of the table is being produced (long tables)
	anything  - cmd name (cox, log, or exp)
*/
program DoNested
	version 10.0
	syntax [anything] [, 	opt(string) optval(string) newopt(string) ///
				args(string) other(string) total(real 0)  ///
				noHEADer CONTinue SEParator(real 0) 	  ///
				DITAB(string) FIRSTPART NOTABLE ]
	if `"`opt'"' == "" {
		if $STPOW_index == `total' {
			local continue `continue'
			local lastcall lastcall
		}
		else if `"`ditab'"' != "" {
			local continue continue
		}
		if $STPOW_index == 1 & `"`firstpart'"' != "" {
			local firstcall firstcall
		}
		else if $STPOW_index > 1 {
			if `"`ditab'"' != "" {
				local header noheader
			}
			local firstcall
		}
		if mod($STPOW_index,`separator') == 0 {
			local sep separator
		}
		else {
			local sep
		}
		_stpower `anything' `args', `newopt' `other' `sep'	///
					    `header' `continue' `ditab'	///
					    `firstcall' `firstpart' `lastcall'
		if `"`notable'"' != "" {
			display _n
		}
		global STPOW_index = $STPOW_index+1
	}
	else {
		gettoken nextopt opt: opt
		gettoken nextoptvals optval: optval, match(parent)
		foreach val of local nextoptvals {
			if `"`nextopt'"'=="arg1" {
				local arg1 `val'
				local newoptval
			}
			else if `"`nextopt'"'=="arg2" {
				local arg2 `val'
				local newoptval
			}
			else {
				local newoptval `nextopt'(`val')
			}
			DoNested `anything', 				///
					args(`arg1' `args' `arg2') 	///
					opt(`opt') optval(`optval') 	///
					newopt(`newopt' `newoptval')	///
					other(`"`other'"') `header'	///
					`continue' sep(`separator')	///
					total(`total') ditab(`ditab')	///
					`firstpart' 
		} /* end foreach */
	}
end

exit
