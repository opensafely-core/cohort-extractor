*! version 1.1.0  27may2009
program mopt_post, eclass
	args b V C wgt touse depvar

	if `:length local touse' {
		tempname esamp
		quietly gen byte `esamp' = `touse'
	}

	ereturn post `b' `V' `C' `wgt',	///
		esample(`esamp')	///
		depname(`depvar')	///
		buildfvinfo
end
