*! version 3.0.1  05feb2020
program define pkshape, rclass
	version 7.0

	syntax varlist(min=4) [, Order(string) OUTcome(string) /*
	*/ TReatment(string) SEQuence(string) PERiod(string) /* 
	*/ CARryover(string) ] 

	local treat_ `"`treatment'"'
	local treatment
	local carry_ `"`carryover'"'
	local carryover
	
	qui count
	if r(N)==0 {
		error 2000
	}

	// Confirm new variable names
	if `"`outcome'"' == "" {
		_err_newvars outcome outcome
                local outcome outcome
        }
        else {
                confirm new var `outcome'
        }
        if `"`period'"' == "" {
		_err_newvars period period
                local period period
        }
        else {
                confirm new var `period'
        }
        if `"`sequence'"' == "" {
		_err_newvars sequence sequence
                local sequence sequence
        }
        else {
                confirm new var `sequence'
        }
        if `"`treat_'"' == "" {
		_err_newvars treatment treat
                local treat_ treat
        }
        else {
                confirm new var `treat_'
        }
	if `"`carry_'"' == "" {
		_err_newvars carryover carry
                local carry_ carry
        }
        else {
                confirm new var `carry_'
        }
	
	// Count the number of periods
	local var_cnt: word count `varlist'
	local nperiod = `var_cnt' - 2
	tokenize `varlist'

	// Determine whether seq is string or numeric
	confirm numeric variable `1' `3' `4'
	capture confirm numeric variable `2'
	if _rc {
		if `"`order'"' != "" {
			di as err /*
*/ "{p}option {bf:order()} may be specified only when input " /*
*/ "sequence variable, {bf:`2'}, is numeric{p_end}"
			exit 198
		}
		confirm string variable `2'
		tempvar seq
		qui encode `2', gen(`seq')
	}
	else {
		local seq = "`2'"
		if `"`order'"' == "" {
			di as err /*
*/ "{p}option {bf:order()} must be specified when input " /*
*/ "sequence variable, {bf:`2'}, is numeric{p_end}"
			exit 198
		}
		capture assert !missing(`2')
		if _rc {
			di as err /*
*/ "{p}missing values in input sequence variable, {bf:`2'}, not allowed{p_end}"
			exit 459
		}
		if `"`: value label `2''"' != "" { 
di as txt "{p 0 6}note: ignoring value labels for numeric sequence variable " /*
*/ "{bf:`2'} and using treatment codes specified in option {bf:order()}{p_end}"
		}
	}

	// Process period variables
	local id = "`1'"
	local period1 = "`3'"
	local period2 = "`4'"
	local i  5
	while `i' < `var_cnt' + 1 {
		local tmp = `i' - 2
		local period`tmp' = "``i''"
		confirm numeric variable `period`tmp''
		local i = `i' + 1
	}

	// Ensure id is not missing and id-seq combos are unique
	preserve
	capture assert !missing(`id')
	if _rc {
di as err "{p}missing values in input id variable, {bf:`id'}, not allowed{p_end}"
		exit 459
	}
	sort `id' 
	capture assert id[_n] != id[_n+1]
	if _rc {
		capture by `id' : assert `seq'[_n] != `seq'[_n+1]
		if _rc {
			di as err "{p}input sequence variable, {bf:`2'}, is not unique"
			di as err "within input id variable, {bf:`id'}{p_end}"
			exit 459
		}
	}

	// count how many distinct sequences
	tempvar oseq iseq
	qui by `seq', sort: gen `iseq' = 1 if _n == 1
	su `iseq' , meanonly
	local nseq = r(sum)
	qui gen `oseq' = sum(`iseq') /* save iseq for later use */

	// store sequences as o1, o2, ..., o`nseq'
	if `"`order'"' != "" {         /* order provided, seq numeric */
		local norder : word count `order'
		if `norder' != `nseq' {
			di as err /*
*/ "{p}the number of sequences in input sequence variable {bf:`2'} " /*
*/ "and in option {bf:order()} does not agree{p_end}"
			exit 198
		}
		local i = 1
		while `i' < `nseq' + 1 {
			local o`i' : word `i' of `order'
			local i = `i' + 1
		}
		local lablist
		local i = 1
		while `i' < `nseq' + 1 {
			if ustrlen(`"`o`i''"') != `nperiod' {
				di as err /*
*/ "{p}the number of periods in the data and in option {bf:order()} " /*
*/ "does not agree{p_end}"
				exit 198
			}
			local lablist = `"`lablist' `i' "`o`i''""'
			local i = `i' + 1
		}
		label define _seqlbl `lablist' , replace
	}
	else { /* this is case where input sequence variable is string */
		sort `iseq' `oseq'
		local i 1
		while `iseq'[`i'] != . {
			local o`i' = `2'[`i']
			local i = `i' + 1
		}
		local i 1
		while `i' < `nseq' + 1 {
			if ustrlen(`"`o`i''"') != `nperiod' {
				di as err /*
*/ "{p}the number of periods in the data and in input sequence variable " /*
*/ "{bf:`2'} does not agree{p_end}"
				exit 459
			}
			local i = `i' + 1
		}
		label copy `seq' _seqlbl , replace
	}


/*
* At this point o1...oN is filled in with the sequence of single-character
* treatment codes. Assign a unique treatment number to each treatment code
*/
	// Create a single string containing all sequences
	local all
	forvalues X = 1/`nseq' {
		// Check for invalid treatment characters
		forvalues Y = 1/`:ustrlen local o`X'' {
			local Z = usubstr(`"`o`X''"', `Y', 1)
			if inlist(`"`Z'"', `"""', "$", "") {
				if `"`order'"' == "" {
					di as err /*
*/ "{p}invalid characters in string sequence variable {bf:`2'}{p_end}"
					exit 459
				}
				else {
					di as err /*
*/ "invalid characters in option {bf:order()}"
					exit 198
				}
			}
		}
		local all `"`all'`o`X''"'
	}
	local alltrt : copy local all

	// Create a matrix to hold a lookup table of treatment numbers
	tempname trtmat
	matrix `trtmat' = J(`nseq', `nperiod', .)

	// Loop over `all' until all treatments have been assigned numbers
	local subval = 1
	while `"`all'"' != "" {
		// Make sure there are no treatment codes with the same 
		// value as `subval'
		if `subval'<10 & ustrregexm(`"`alltrt'"', "`subval'") {
			local subval = `subval' + 1
			continue
		}
		
		// Extract treatm. code for assignment and delete it from `all'
		local char = usubstr(`"`all'"', 1, 1)
		local all = usubinstr(`"`all'"', `"`char'"', "", .)
		
		// Assign number to treatment code: if treatment code is 0-9, 
		// use code as number, o.w. assign treatment number `subval'
		local charnum = cond(ustrregexm(`"`char'"', "^\d$"),         ///
				     `"`char'"', "`subval'")

		// Save number/code pairs for value labels
		local trtlist = `"`trtlist' `charnum' `char'"'
		
		// Fill in lookup table `trtmat' with treatment numbers
		forvalues i = 1/`nseq' {
			forvalues j = 1/`nperiod' {
				mat `trtmat'[`i',`j'] =                      ///
				 cond(usubstr(`"`o`i''"',`j',1)==`"`char'"', ///
				 `charnum', `trtmat'[`i',`j'])
			}
		}
		local subval = `subval' + 1
	}
	
	// Confirm no treatment numbers were lost due to unforeseen invalid
	// codes
	capture assert !matmissing(`trtmat')
	if _rc {
		if `"`order'"' == "" {
			di as err ///
		"invalid treatment codes in input sequence variable {bf:`2'}"
			exit 459
		}
		else {
			di as err ///
		"invalid treatment codes in option {bf:order()}"
			exit 198
		}
	}
	
	label define _trtlbl `trtlist' , replace
	
	// Determine storage type for outcome (double if any period was double)
	local usedbl 0
	forvalues i = 1/`nperiod' {
		if "`: type `period`i'''" == "double" {
			local usedbl 1
		}
	}
	local outtype = cond(`usedbl'==0, "float", "double")
	
	tempvar result treat carry Period
	sort `oseq' `id'
	qui gen `outtype' `result' = `period1'
	qui gen `treat' = .
	qui gen `carry' = 0
	qui gen `Period' = 1

	// Increase # obs as needed, and fill in `result' and `Period'
	local len = _N
	local i 1
	while `i' < `nperiod' {
		local tmp = `i' - 1
		qui expand 2 if _n > (`tmp' * `len')
		
		local tmp = `i' + 1
		qui replace `result' = `period`tmp'' if _n > `i' * `len'
		qui replace `Period' = `tmp' if _n > `i' * `len'
		local i = `i' + 1
	}

	// Fill in `treat' and `carry'
	forvalues i = 1/`nseq' {
		forvalues j = 1/`nperiod' {
			quietly replace `treat' = `trtmat'[`i', `j']         ///
				if `oseq'==`i' & `Period'==`j'
			
			// Carryover = 0 for first period
			local carval = cond(`j'==1, 0, `trtmat'[`i', `j'-1])
			quietly replace `carry' = `carval'                   ///
				if `oseq'==`i' & `Period'==`j'
		}
	}
	
	gettoken drop 0 : 0, parse(",")
	gettoken junk drop : drop
	drop `drop'
	nobreak {
		rename `result' `outcome'
		rename `Period' `period'
		rename `oseq' `sequence'
		rename `treat' `treat_'
		rename `carry' `carry_'
		label values `sequence' _seqlbl
		label values `treat_' _trtlbl
		label values `carry_' _trtlbl
		label variable `outcome' "Outcome"
		label variable `period' "Period of study"
		label variable `sequence' "Sequence of treatments received"
		label variable `treat_' "Treatment received"
		label variable `carry_' "Carryover effect"
		qui compress `period' `sequence' `treat_' `carry_'
		restore, not
	}
end

program _err_newvars
	args vartype varname
	cap noi confirm new var `varname'
	if _rc {
		di as err "{p 4 4 2}By default, {helpb pkshape}"
		di as err "uses the variable name {bf:`varname'} to"
		di as err "create the `vartype' variable. A variable"
		di as err "with the same name already exists in the"
		di as err "dataset. You can specify the new name in"
		di as err "option {bf:`vartype'()}.{p_end}"
	}
	exit _rc
end
exit
