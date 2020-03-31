*! version 1.0.0  18apr2019

program meta__model_desc, sclass
	version 16
	syntax , key(string) [meth(string) col(real 2) cont version(real 1) ] 
	
	sreturn clear
	if inlist("`key'", "mhaenszel", "invvariance", "ivariance", ///
		"fixed", "common", "sa") {
		local moddesc = cond("`meth'" == "common", "Common-effect", ///
			cond("`meth'"=="fixed", "Fixed-effects", ///
			"Random-effects"))
		local method  = cond("`key'" == "mhaenszel", ///
			"Mantel-Haenszel", cond("`key'" == "sa", ///
			"Sensitivity-analysis", "Inverse-variance"))
	}
	else {
		local moddesc = "Random-effects"		
		if "`key'" == "dlaird" local method = "DerSimonian-Laird"
		else if "`key'" == "mle" local method = "ML"
		else if "`key'" == "reml" local method = "REML" 
		else if "`key'" == "ebayes" local method = "Empirical Bayes"
		else if "`key'" == "hedges" local method = "Hedges"
		else if "`key'" == "hschmidt" local method = "Hunter-Schmidt"
		else if "`key'" == "sjonkman" local method = "Sidik-Jonkman"
		else if "`key'" == "pmandel" local method = "Paule-Mandel"
		else if "`key'" == "sa" local method = "Sensitivity-analysis"						
	}
	
	if "`version'" == "1" {
		di as txt _col(`col') "Model:  " as txt "`moddesc'" 	
		local --col
		if !missing("`cont'") local endline _c
		di as txt _col(`col') "Method:  " as txt "`method'" `endline'
	}
	else {
		di as txt "`moddesc' model" 	
		di as txt  "Method: " as txt "`method'" `endline'
	}
	
	sreturn local method "`method'"
	sreturn local moddesc "`moddesc'"
end
