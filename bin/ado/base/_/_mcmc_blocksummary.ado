*! version 1.0.0  02mar2015
program _mcmc_blocksummary
	version 14.0
	if ("`e(block1_names)'"=="") exit //not displayed on dryrun

	syntax [, LINESIZE(real 78)]
	if `linesize' <= 0 {
		local linesize = `c(linesize)'-2
	}
	di
	di as txt "Block summary"
	di as txt "{hline `linesize'}"
	_blocksummary `linesize'
	di as txt "{hline `linesize'}"
end

program _blocksummary
	args linesize

	local i 1
	local gibbscol = `linesize'-7+1
	local block `e(block`i'_names)'
	while ("`block'"!="") {
		_submatnames block : "`block'"
		_getblocknames block : "`block'"
		if ("`e(block`i'_gibbs)'"=="1") {
			local gibbs `"as txt _col(`gibbscol') "(Gibbs)"'
		}
		else {
			local gibbs
		}
		di as txt "{ralign 4:`i'}: " as res "`block'" `gibbs'
		local ++i
		local block `e(block`i'_names)'
	}
end

program _submatnames
	args toblock colon block

	//collapse matrix elements in one matrix
	local matnames `e(matparams)'
	gettoken mname matnames : matnames
	while ("`mname'"!="") {
		gettoken mname : mname, parse("()")
		if (!regexm("`block'","`mname'_[0-9]+_[0-9]+")) {
			gettoken mname matnames : matnames
			continue
		}
		while (regexm("`block'","`mname'_[0-9]+_[0-9]+")) {
			local block=regexr("`block'","`mname'_[0-9]+_[0-9]+","")
		}
		local block "`mname',m `block'"
		gettoken mname matnames : matnames
	}
	c_local `toblock' "`block'"
end

program _getblocknames
	args toblock colon block

	local cureq	
	gettoken token block : block
	while ("`token'"!="") {
		gettoken eq param: token, parse(":")
		if ("`param'"=="") {
			if ("`cureq'"!="") {
				local diblock "`diblock'{c )-}"
			}
			local cureq ""
			local diblock "`diblock' {c -(}`token'{c )-}"
		}
		else {
			gettoken colon param : param, parse(":")
			if ("`cureq'"=="") {
				local diblock "`diblock' {c -(}`eq':`param'"
			}
			else if ("`cureq'"!="`eq'") {
				local diblock ///
					"`diblock'{c )-} {c -(}`eq':`param'"
			}
			else {
				local diblock "`diblock' `param'"
			}
			local cureq "`eq'"
		}
		gettoken token block : block
	}
	if ("`cureq'"!="") {
		local diblock "`diblock'{c )-}"
	}
	c_local `toblock' "`diblock'"
end
