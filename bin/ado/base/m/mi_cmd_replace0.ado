*! version 1.0.3  17sep2019

/*
	mi replace0 using <filename>, id(<varlist>)

		It does not matter whether the mi file or the 
		new original is in memory
*/

program mi_cmd_replace0
	version 11.0

	syntax using/, ID(varlist)
	mata: confirmfile(`"`using'"', ".dta")

	u_mi_how_set style
	if ("`style'"=="") {
		local repl_in_mem 1
	}
	else {
		local repl_in_mem 0
		u_mi_assert_set
	}
	novarabbrev mi_replace0_u "`id'" `repl_in_mem' "`using'"
end

program mi_replace0_u
	args idvars repl_in_mem usingfile

	preserve 
	tempvar newid
	tempfile replfile selfile

	if (`repl_in_mem') { 
		sort `idvars'
		quietly gen `c(obs_t)' `newid' = _n
		quietly compress `newid'
		quietly save "`replfile'"
		keep `idvars' `newid'
		quietly save "`selfile'" /* sorted by `newid' */

		qui use "`usingfile'", clear 
		u_mi_assert_set
		capture confirm var `idvars'
		if (_rc) { 
			local n : word count `idvars'
			local variables = cond(_n==1, "variable", "variables")
			di as smcl as err "{p}"
			di as smcl as err "`variables' `idvars' not found in"
			di as smcl as err `"original mi data `usingfile'.dta"'
			di as smcl as err "{p_end}"
			exit 111
		}
	}
	else {
		qui use "`usingfile'", clear /* which is replacement data */
		capture confirm var `idvars'
		if (_rc) { 
			local n : word count `idvars'
			local variables = cond(_n==1, "variable", "variables")
			di as smcl as err "{p}"
			di as smcl as err "`variables' `idvars' not found in"
			di as smcl as err `"replacement data `usingfile'.dta"'
			di as smcl as err "{p_end}"
			exit 111
		}
		sort `idvars'
		quietly gen `c(obs_t)' `newid' = _n
		quietly compress `newid'
		quietly save "`replfile'"
		keep `idvars' `newid'
		quietly save "`selfile'"
		restore, preserve
	}

	u_mi_xeq_on_tmp_flongsep, nopreserve: ///
		mi_sub_replace0_flongsep "`idvars'" `newid' ///
					 "`replfile'" "`selfile'"
	u_mi_fixchars, proper
	restore, not
end

		
mata:
void confirmfile(string scalar uffn, string scalar suffix)
{
	string scalar	ffn

	ffn = (pathsuffix(uffn)=="" ? uffn+suffix : uffn)
	if (fileexists(ffn)==0) {
		errprintf("file %s not found\n", ffn)
		exit(601)
	}
}
end
