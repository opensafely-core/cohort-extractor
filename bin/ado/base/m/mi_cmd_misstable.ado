*! version 1.0.3  15apr2019 

/*
	mi misstable summarize [varlist] [if] [in], [m(#) nopreserve *]

	mi misstable patterns  [varlist] [if] [in], [m(#) nopreserve exmiss *]

	mi misstable tree      [varlist] [if] [in], [m(#) nopreserve exmiss *]

	mi misstable nested    [varlist] [if] [in], [m(#) nopreserve exmiss *]

	(option -exmiss- is tolerated in -mi misstable summarize-)
*/

program mi_cmd_misstable
	version 11
	/* ------------------------------------------------------------ */
							/* parse	*/
	u_mi_assert_set

	gettoken cmd 0 : 0, parse(" ,")
	mi_misstable_chkcmd cmd : `cmd'
	local xtraops "EXOK EXMISS GENerate(string)"
	if ("`cmd'"=="patterns") {
		local xtraops `xtraops' REPLACE CLEAR
	}

	syntax [varlist(default=none)] [if] [in] ///
			[, m(integer 0) `xtraops' noPRESERVE DEBUG *]
	u_mi_no_sys_vars "`varlist'" "{it:varlist}"
	u_mi_no_wide_vars "`varlist'" "{it:varlist}"

	if ("`replace'"!="" & c(changed) & "`clear'"=="") {
		error 4
	}

	if (`m'<0 | `m'>`_dta[_mi_M]') {
		di as smcl as err "{p 0 4 2}"
		di as smcl as err ///
			"option {bf:m(}{it:#}{bf:)} out of range{break}"
		di as smcl as err "{it:M} = `_dta[_mi_M]'; 
		di as smcl as err "0 <= {it:#} <= {it:M} required"
		di as smcl as err "{p_end}"
		exit 198
	}

	if (`"`generate'"'!="") {
		di as err ///
		   "option {bf:generate()} not allowed with {bf:mi misstable}"
		exit 198
	}

	if ("`exok'"!="") {
		if ("`exmiss'"!="") { 
			mi_misstable_error_ex
			/*NOTREACHED*/
		}
		if ("`cmd'"=="summarize") {
			di as smcl as txt ///
			"(option {bf:exok} irrelevant with {bf:mi misstable})"
		}
		else {
			di as smcl as txt ///
		"(option {bf:exok} assumed when using {bf:mi misstable})"
		}
	}
	local exok 
	if ("`cmd'"=="summarize") {
		if ("`exmiss'"!="") {
			di as smcl as txt ///
		"(option {bf:exmiss} irrelevant with {bf:mi misstable})"
		}
	}
	else {
		if ("`exmiss'"=="") {
			local exok exok
		}
	}
		
							/* parse	*/
	/* ------------------------------------------------------------ */

	if ("`preserve'"=="") { 
		preserve
	}
	quietly mi extract `m', clear 
	if ("`debug'" != "") {
		di as txt `"misstable ..., `exok' `replace' `clear' `options'"'
	}
	misstable `cmd' `varlist' `if' `in', ///
				nopreserve `exok' `replace' `clear' `options'
	if ("`replace'" !="" & "`preserve'"=="") {
		restore, not
	}
end

program mi_misstable_error_ex
	local di "di as smcl as err"
	`di' "{p 0 4 2}"
	`di' "options {bf:exmiss} and {bf:exok} may not be combined{break}"
	`di' "{bf:mi misstable} assumes {bf:exok}.  Specify {bf:exmiss}"
	`di' "to treat .a, .b, ..., .z as missing, or omit the option"
	`di' "to treat .a, .b, ..., .z as nonmissing."
	`di' "{p_end}"
	exit 198
end

program mi_misstable_chkcmd
	args macname  colon  cmd

	local l  = strlen("`cmd'")
	if ("`cmd'"== bsubstr("nested", 1, max(4,`l'))) {
		c_local `macname' nested
		exit
	}
	if ("`cmd'"==bsubstr("patterns", 1, max(3,`l'))) {
		c_local `macname' patterns
		exit
	}
	if ("`cmd'"==bsubstr("summarize", 1, max(3,`l'))) {
		c_local `macname' summarize
		exit
	}
	if ("`cmd'"=="tree") {
		c_local `macname' tree
		exit
	}
	misstable
	/*NOTREACHED*/
end
