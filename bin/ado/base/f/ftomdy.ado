*! version 2.1.0  02/27/93
program define ftomdy
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	parse "`generat'", parse(" ")
	if ("`3'"=="" | "`4'"~="") { exit 198 }
	conf new var `*'
	tempvar touse good mo da yr
	quietly {
		gen byte `touse' = 1 `if' `in'
		gen int `yr' = `varlist'/10000 + 1900 `if' `in'
		gen byte `mo' = `varlist'/100-(`yr'-1900)*100 `if' `in'
		gen byte `da' = `varlist'-(`yr'-1900)*10000-`mo'*100 `if' `in'
	}
	gen byte `good' = 1 if !(`touse'==. | `yr'<1901 /*
			*/ | `yr'>1999 /*
			*/ | `mo'<1 | `mo'>12 | `da'<1 | `da'>31)
	quietly {
		replace `yr' = . if `good'!=1
		replace `mo' = . if `good'!=1
		replace `da' = . if `good'!=1
	}
	rename `yr' `3'
	rename `da' `2'
	rename `mo' `1'
end
