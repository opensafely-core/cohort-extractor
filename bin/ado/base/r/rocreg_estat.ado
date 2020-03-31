*! version 1.0.1  04jul2011
program rocreg_estat, rclass
	version 12
	gettoken subcmd rest : 0 , parse(", ")
	local lsubcmd= length("`subcmd'")
	capture assert `lsubcmd' >= 2
	if (`"`e(probit)'"' == "") {
		if (`"`subcmd'"' == "nproc") {
			Rocreg_estat_np `rest'
			return add
		}
		else {
			di as error ///
"{p 0 4 2}allowed estat subcommand is nproc{p_end}" 
			exit 198
		}
	}
	else {
		di as error ///
"{p 0 4 2}estat not allowed after parametric rocreg{p_end}"
		exit 198
	}
end

program Rocreg_estat_np, rclass
	syntax, [roc(numlist) 		///
		invroc(numlist) 	///
		pauc(numlist) 		///
		auc ]			
	capture assert `"`roc'`invroc'`pauc'`auc'"' != ""
	if (_rc) {
		di as err "must specify at least one option"
		exit 198
	}

	tempname bobo
	qui estimates store `bobo'
	tempvar esample
	gen `esample' = e(sample)
	if (`"`auc'"' != "") {
		local eauc  auc
	}
	else { 
		local eauc `e(auc)'
	}
	if(`"`e(nobootstrap)'"' != "nobootstrap") {
		local nodots nodots 
	}

	local level = string(`e(level)',"%9.0g")
	rocreg `e(refvar)' `e(classvars)' if e(sample), ///
		ctrlcov(`e(ctrlcov)') ctrlmodel(`e(ctrlmodel)') ///
		`e(nobstrata)' breps(`e(breps)') ///
		`e(bootcc)' `e(nobootstrap)' `e(tiecorrected)' ///
		roc(`e(roc)' `roc') invroc(`e(invroc)' `invroc') ///
		pauc(`e(pauc)' `pauc') `eauc' bseed(`e(bseed)') ///
		cluster(`e(clustvar)') `nodots' level(`level')

	tempname bebrop 
	matrix `bebrop' = e(b)
	return matrix b = `bebrop'
	matrix `bebrop' = e(V)
	return matrix V = `bebrop'
	matrix `bebrop' = e(ci_normal)
	return matrix ci_normal = `bebrop'
	matrix `bebrop' = e(ci_percentile)
	return matrix ci_percentile = `bebrop'
	matrix `bebrop' = e(ci_bc)
	return matrix ci_bc = `bebrop'
	qui estimates restore `bobo'
	qui estimates drop `bobo'
end

exit
