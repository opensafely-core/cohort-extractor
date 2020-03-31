*! version 1.0.0  25apr2019
program meta__eslabel, sclass
	version 16
	
	syntax [, EFORM1 EForm(string) estype(string) eslbl(string) ]	
	
	sreturn clear
	
	local which ""
	
	local rmdlbl    	"Mean Diff."
	local mdifflbl    	"Mean Diff."
	local cohendlbl   	"Cohen's d"
	local cohensdlbl  	"Cohen's d"
	local hedgesglbl  	"Hedges's g"
	local glassdelta1lbl 	"Glass's Delta1"
	local glassdelta2lbl 	"Glass's Delta2"
	local glassdeltalbl 	"Glass's Delta2"
	local lnoratiolbl 	"Log Odds-Ratio"
	local lnorpetolbl 	"Log Peto's OR"
	local lnrratiolbl 	"Log Risk-Ratio"
	local rdifflbl 		"Risk Diff."
	
	if `"`eslbl'"' != `"``estype'lbl'"' {
		if "`eslbl'"!="Effect Size" {
			local eslab = cond("`eform1'"=="", "`eslbl'", ///
				"exp(`eslbl')")
			sreturn local eslabvarmid = "`eslab'"
			sreturn local eslabvarbeg = "`eslab'"	
		}
		else {
			local eslab = cond("`eform1'"=="", "Effect Size", ///
				"exp(ES)")
			sreturn local eslabvarmid = "ES" // _meta_weight
			sreturn local eslabvarbeg = "Effect size" // funnel plot	
		}
		sreturn local eslab "`eslab'"
		
		exit
	}
	
	     if "`estype'"=="lnoratio" {
		local eslab=cond("`eform1'"=="", "`lnoratiolbl'", "Odds Ratio")
		local eslabvarmid = ustrlower("`lnoratiolbl'")
		local eslabvarbeg = "Log odds-ratio"
	     }
        else if "`estype'"== "lnrratio" {
		local eslab = cond("`eform1'"=="","`lnrratiolbl'", "Risk Ratio")
		local eslabvarmid =  ustrlower("`lnrratiolbl'")
		local eslabvarbeg = "Log risk-ratio"
	}        
	else if "`estype'"== "rdiff" {
		local eslab = "`rdifflbl'"
		local eslabvarmid = ustrlower("`rdifflbl'")
		local eslabvarbeg = "Risk diff."
	}
        else if "`estype'"== "lnorpeto" {
		local eslab = cond("`eform1'"=="","`lnorpetolbl'", "Peto's OR")
		local eslabvarmid = "log Peto's OR"
		local eslabvarbeg = "`lnorpetolbl'"
	}
        else if inlist("`estype'","cohend","cohensd") {
		local eslab = "`cohensdlbl'"
		local eslabvarmid = "`cohensdlbl'"
		local eslabvarbeg = "`cohensdlbl'"
	}
        else if "`estype'"== "hedgesg" {
		local eslab = "`hedgesglbl'"
		local eslabvarmid = "`hedgesglbl'"
		local eslabvarbeg = "`hedgesglbl'"
	}
	else if "`estype'" == "glassdelta" | "`estype'" == "glassdelta2" {
		local eslab = "Glass's Delta2"
	}
	else if "`estype'" == "glassdelta1" {
		local eslab = "Glass's Delta1"
	}
	else if inlist("`estype'","rmd","mdiff") {
		local eslab = "`mdifflbl'"
		local eslabvarmid = ustrlower("`mdifflbl'")
		local eslabvarbeg = "Mean diff."
	}
	else {
		// should not enter here
		local esl : char _dta[_meta_eslabel]

		if "`esl'"!="Effect Size" {
			local eslab = cond("`eform1'"=="", "`esl'", "exp(`esl')")
		}
		else {
			local eslab = cond("`eform1'"=="", "Effect Size", ///
				"exp(ES)")	
		}
		
	}
		
	sreturn local eslab `eslab'
	sreturn local eslabvarmid = cond(missing("`eslabvarmid'"), ///
		"`eslab'", "`eslabvarmid'")
	sreturn local eslabvarbeg = cond(missing("`eslabvarbeg'"), ///
		"`eslab'", "`eslabvarbeg'")
end	
