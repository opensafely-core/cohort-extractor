*! version 1.0.0  01apr2019

program _mcmc_parse_saving, sclass
	version 16.0
	// parse saving()
	local saving `"`0'"'
	local simdatapath
	local replacenote 0

	if `"`saving'"' != "" {
		_savingopt_parse simdatapath replace : saving ".dta" `"`saving'"'
		if ("`replace'"=="") {
			confirm new file `"`simdatapath'"'
		}
		else {
			cap confirm new file `"`simdatapath'"'
			if _rc==0 {
				local replacenote 1
			}
		}
	}
	else {
		local simdatapath `"`c(bayesmhtmpfn)'"'
	}
	local replace = `"`replace'"' == "replace"
	sreturn local replace     = `replace'
	sreturn local replacenote = `replacenote'
	sreturn local simdatapath = `"`simdatapath'"'
end
