*! version 2.2.5  13feb2015
program aorder
	version 6, missing
	syntax [varlist]
	local n : word count `varlist'
	if `n' <= 1 { exit }
	preserve 
	quietly { 
		tempvar name
		drop _all 
		set obs `n'
		gen str32 `name' = ""
		tokenize `varlist'
		local i 1 
		while "``i''" != "" {
			replace `name' = "``i''" in `i'
			local i = `i'+1
		}

		SortAord `name'

		local i 1 
		while "``i''" != "" { 
			local x = `name'[`i']
			local newlist "`newlist' `x'"
			local i = `i'+1
		}
		restore
		order `newlist'
	}
end


program SortAord
	syntax varname [in]

	if "`in'" ~= "" {
		tokenize "`in'", parse(" /")
		local first "`2'"
		local last  "`4'"
	}
	else {
		local first 1
		local last = _N
	}

	quietly {
		tempvar name l stub digits nonumb group
		gen str32 `name' = `varlist' `in'
		gen int `l' = index(`name',"0") `in'
		replace `l' = . if `l'==0 `in'
		local i 1
		while `i' <= 33 {
			replace `l' = index(`name',"`i'") if /*
					*/ index(`name',"`i'")<`l' & /*
					*/ index(`name',"`i'")!=0 `in'
			local i = `i' + 1 
		}
		replace `l' = 33 if `l'>=. `in'
		gen str32 `stub' = bsubstr(`name',1,`l'-1) `in'
		local i 1
		gen long `digits' = real(bsubstr(`name',`l',`i')) `in'
		while `i' < 31 {
			local i = `i' + 1
			replace `digits' = real(bsubstr(`name',`l',`i')) `in' /*
					*/ if `digits'<.  /*
					*/ & real(bsubstr(`name',`l',`i'))<. /*
					*/ & index(bsubstr(`name',`l',`i'),"d")==0 /*
					*/ & index(bsubstr(`name',`l',`i'),"e")==0
		}
		gen byte `nonumb' = -1 if `digits'>=. `in'
		sort `stub' `nonumb' `digits' `in'
		drop `nonumb'
		replace `stub' = `stub' + string(`digits') `in'
		drop `digits'
		local i 1
		local flag 0
		while `i' <= _N & `flag'==0 {
			if `name'[`i'] != `stub'[`i'] {
				local flag 1
			}
			local i = `i' + 1
		}
		if `flag' == 1 {
			encode `stub' `in', gen(`group')
			if `group'[`last'] != (`last'-`first'+ 1) {
				replace `l' = length(`stub') `in'
				replace `name' = bsubstr(`name',`l'+1,.) `in'
				local i `first'
				while `i' < `last' {
					if `group'[`i']==`group'[`i'+1] {
						local start `i'
						while `group'[`i']== /*
							*/ `group'[`i'+1] {
							local i = `i' + 1
						}
						local finish `i'
						SortAord `name' /*
							*/ in `start'/`finish'
					}
					else {
						local i = `i' + 1
					}
				}
			}
		}
	}
end
