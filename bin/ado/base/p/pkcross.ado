*! version 3.7.2  11mar2009
program define pkcross, eclass 
	version 7.0, missing

	syntax varlist(numeric min=1 max=1) [if] [in] /*
		*/ [, Param(integer 3) SEQuence(varname numeric) /*
		*/ TReatment(varname numeric) CARryover(string) /*
		*/ PERiod(varname numeric) ID(varname numeric) /*
		*/ Model(string) SEquential ]

	local treat "`treatment'"
	local treatment
	local carry "`carryover'"
	local carryover

	marksample touse

	local outcome = "`1'"
	gettoken outcome : outcome, parse(,)

	if `param'!=1 & `param'!=2 & `param'!=3 & `param'!=4 {
		di as err "param() should be 1, 2, 3, or 4"
		exit 198
	}
	if "`model'" != "" { /* We are just using ANOVA in this case */
		anova `outcome' `model' if `touse', `sequential'
		if "`carry'" != "" & "`treat'" != "" & "`sequence'" != "" {
			omnibus `treat' `carry' `sequence'
			di
			di as txt _col(5) /*
*/ "Omnibus test of separability of treatment and carryover = " /*
				*/ as res %9.4f r(separate) "%"
		}
		exit
	}

	if "`sequence'" == "" {
		ChkVar sequence
		local sequence sequence
	}
	if "`treat'" == "" {
		ChkVar treat
		local treat treat
	}
	if "`period'" == "" {
		ChkVar period
		local period period
	}
	if "`id'" == "" {
		ChkVar id
		local id id
	}
	if "`carry'" == "" {
		ChkVar carry
		local carry carry
	}

	confirm numeric variable `treat'
	confirm numeric variable `id'
	capture confirm numeric variable `carry'
	if _rc {
		if "`carry'" == "none" {
			local carry ""
		}
		else {
			di `"`carry' not a variable in data"'
			exit 198
		}
	}
		

	tempvar seq Period

	capture confirm numeric variable `sequence'
	qui by `touse' `sequence', sort: gen `seq' = 1 if _n == 1 & `touse'
	qui replace `seq' = sum(`seq') if `touse'

	capture confirm numeric variable `period'
	qui by `touse' `period', sort: gen `Period' = 1 if _n == 1 & `touse'
	qui replace `Period' = sum(`Period') if `touse'
	
	qui su `seq', meanonly
	local nseq = r(max)
	qui su `Period'
	local nperiod = r(max)



	di as txt _col(48) `"  sequence variable = "' as res abbrev("`sequence'",8)
	di as txt _col(48) `"    period variable = "' as res abbrev("`period'", 8)
	di as txt _col(48) `" treatment variable = "' as res abbrev("`treat'", 8)
	di as txt _col(48) `" carryover variable = "' as res abbrev("`carry'", 8)
	di as txt _col(48) `"        id variable = "' as res abbrev("`id'", 8)

	if `nseq' == 2 & `nperiod' == 2 {
		if `param' == 1 {
			_2x2_p1 `id' `seq' `outcome' `period' `treat' `carry' if `touse', `sequential'
		}
		else if `param' == 2 {
			_2x2_p2 `id' `seq' `outcome' `period' `treat' `carry' if `touse', `sequential'
		}
		else if `param' == 3 {
			_2x2_p3 `id' `seq' `outcome' `period' `treat' `carry' if `touse', `sequential'
		}
		else if `param' == 4 {
			_2x2_p4 `id' `seq' `outcome' `period' `treat' `carry' if `touse', `sequential'
		}
		else {
			di as err "param() must be 1, 2, 3 or 4"
			exit 198
		}
	
	}
	else {
		if "`model'" == "" {
			Cx `id' `seq' `outcome' `period' `treat' `carry' /*
				*/ if `touse', `sequential'
		}
	}

	if "`carry'" != "" {
		omnibus `treat' `carry' `seq'	
		di
		di as txt _col(5) /*
	*/ "Omnibus measure of separability of treatment and carryover = " /*
			*/ as res %9.4f r(separate) "%"
	}

	_post_vce_rank
	estimates local predict "_pk_p"
	estimates local varnames
	estimates local cmd
	estimates local model
end

program define omnibus, rclass
	syntax varlist(numeric min=3 max=3)
	tokenize `varlist'	
	local treat = "`1'"
	local carry = "`2'"
	local seq = "`3'"
	
	tempvar x
	qui by `seq' `treat' `carry', sort : gen `x' = 1 if _n==1
	qui tab `treat' `carry' if `x' == 1, ch
	if r(c) <= r(r) {
		local min = r(c)-1
	}
	else local min = r(r)-1 
	tempname separate
	scalar `separate' = 100*(1 - (((r(chi2) / r(N)) / `min')^(1/2))) 
	return scalar separate = `separate'
	
end


program define Line
	args ttl ss df ssovdf F Fprob ptl

	if "`ptl'" == "" & "`ssovdf'" != "ptl" & "`F'" != "ptl" {
		di in smcl as txt _col(5) %21s `"`ttl'"' " {c |}" /*
			*/ as res %9.2f `ss' "  " %5.0f `df' _c
	}
	if "`ptl'" == "ptl" | "`ssovdf'" == "ptl" | "`F'" == "ptl" {
		di in smcl as txt _col(5) %21s `"`ttl'"' " {c |}  " /*
			*/ as res %9.2f `ss' "" %5.0f `df' _c
	}
	if "`ssovdf'" == "ptl" {
		local ssovdf = ""
	}
		
	if "`ssovdf'"=="" {
		di
		exit 
	}
	di as res "   " %9.2f `ssovdf' _c

	if "`F'" == "ptl" {
		local F = ""
	}

	if `"`F'"'=="" {
		di 
		exit
	}
	di as res "   " %7.2f `F' "      " %5.4f `Fprob'
end

program define TopLine
	args ttl ptl
	local skip = int(79-5 - length(`"`ttl'"'))/2 + 5
	di as txt _skip(`skip') `"`ttl'"'
	if "`ptl'" == "" {
		di in smcl as txt _col(5) /*
			*/ " Source of Variation  {c |}     SS       df" /*
			*/ "        MS          F     Prob > F "
	}
	else {
		di in smcl as txt _col(5) /*
			*/ " Source of Variation  {c |} Partial SS   df" /*
			*/ "        MS          F     Prob > F "
	}
		
	di in smcl as txt _col(5) "{hline 22}{c +}{hline 50}"
end

program define DivLine
	di in smcl as txt _col(5) "{hline 22}{c +}{hline 50}"
end


program define HdrLine
	args hdr
	di in smcl as txt _col(6) `"`hdr'"' _col(27) "{c |}"
end

program define _2x2_p1, rclass
	version 6, missing
        syntax varlist(numeric min=5 max=6) [if] [in] [, SEquential]
	marksample touse
	tokenize `varlist'
	local id = "`1'"
	local seq = "`2'"
	local outcome = "`3'"
	local period = "`4'"
	local treat = "`5'"
	local carry = "`6'"

	if "`sequential'" == "" {
		local ptl ptl
	}
	else {
		local ptl = ""
	}
	if "`sequential'" == "" {

		qui anova `outcome' `period' `treat' `carry' if `touse'
		di
		TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study" `ptl'

		qui test `treat'

		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		if "`carry'" != "" {
			qui test `carry'
			Line "Carryover effect" r(ss) r(df) r(ss)/r(df) /*
				*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		}

		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r) `ptl'
	
		DivLine
		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r) `ptl'
		}
	else {
		di
		TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study" `ptl'

		qui anova `outcome' `treat' if `touse'
		qui test `treat'
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		qui anova `outcome' `treat' `period' if `touse'
		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		if "`carry'" != "" {
			qui anova `outcome' `period' `treat' `carry' if `touse'
			qui test `carry'
			Line "Carryover effect" r(ss) r(df) r(ss)/r(df) /*
				*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		}
		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r) `ptl'

		DivLine
	}
	
end


program define _2x2_p2, rclass
        version 6, missing
        syntax varlist(numeric min=6 max=6) [if] [in] [, SEquential]
	marksample touse
	tokenize `varlist'
        local id = "`1'"
        local seq = "`2'"
        local outcome = "`3'"
        local period = "`4'"
        local treat = "`5'"
        local carry = "`6'"

	
	if "`sequential'" == "" {
		local ptl ptl
	}
	else {
		local ptl = ""
	}

/*
 *	In a well designed "balanced" study, partial and sequential 
 *	will be the same because these effects are orthogonal
*/
	
	if "`sequential'" == "" {
		qui anova `outcome' `period' `treat' `period'*`treat' /*
			*/ if `touse'
		di
		TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study"`ptl'

		qui test `treat'
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		qui test `period'*`treat'
		Line "Treatment * Period" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r) `ptl'
		DivLine 

		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r) `ptl'
	}
	else {
		di
                TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study"
		qui anova `outcome' `treat' if `touse'
                qui test `treat'
                Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
                        */ r(F) fprob(r(df),r(df_r),r(F))

		qui anova `outcome' `treat' `period' if `touse'
                qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))

		qui anova `outcome' `treat' `period' `period'*`treat'
                qui test `period'*`treat'
                Line "Treatment * Period" r(ss) r(df) r(ss)/r(df) /*
                        */ r(F) fprob(r(df),r(df_r),r(F))
                Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r)
                DivLine
	}

end


program define _2x2_p3, rclass
        version 6, missing
        syntax varlist(numeric min=5 max=6) [if] [in] [, SEquential]
	marksample touse
	tokenize `varlist'
        local id = "`1'"
        local seq = "`2'"
        local outcome = "`3'"
        local period = "`4'"
        local treat = "`5'"
        local carry = "`6'"



	if "`sequential'" == "" {
		local ptl ptl
	}
	else {
		local ptl = ""
	}

	if "`sequential'" == "" {
		qui anova `outcome' `seq'/`id'|`seq' `treat' `period' /*
			*/ if `touse', `sequential' 
		di
		TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study" `ptl'
		HdrLine "Intersubjects"
		qui test `seq'/`id'|`seq'
		Line "Sequence effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		qui test `id'|`seq'
		Line "Residuals" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		DivLine 
		HdrLine "Intrasubjects"
		qui test `treat'
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r) `ptl'
		DivLine
		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r) `ptl'
/*		qui anova `outcome' `seq'/`id'|`seq' `treat' `period' /*
			*/ if `touse', `sequential' 
*/	}
	else {

		di
		TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study"
		HdrLine "Intersubjects"
		qui anova `outcome' `seq'/`id'|`seq' /*
			*/ if `touse', `sequential' 
		qui test `seq'/`id'|`seq'
		Line "Sequence effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))
		qui test `id'|`seq'
		Line "Residuals" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))
		DivLine 
		HdrLine "Intrasubjects"
		qui anova `outcome' `seq'/`id'|`seq' `treat'  /*
			*/ if `touse', `sequential' 
		qui test `treat'
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))
		qui anova `outcome' `seq'/`id'|`seq' `treat' `period' /*
			*/ if `touse', `sequential' 
		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))
		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r)
		DivLine
		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r)
	}

end
 

program define _2x2_p4, rclass
        version 6, missing
        syntax varlist(numeric min=5 max=6) [if] [in] [, SEquential]
	marksample touse
	tokenize `varlist'
        local id = "`1'"
        local seq = "`2'"
        local outcome = "`3'"
        local period = "`4'"
        local treat = "`5'"
        local carry = "`6'"

	if "`sequential'" == "" {
		local ptl ptl
	}
	else {
		local ptl = ""
	}

	if "`sequential'" == "" {
		qui anova `outcome' `seq'/`id'|`seq' `treat' `treat'*`seq' /*
			*/ if `touse', `sequential'
		di
		TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study" `ptl'
		qui test `treat'                        
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		qui test `seq'/`id'|`seq'               
		Line "Sequence effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		qui test `id'|`seq'
		Line "Id|Sequence" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		qui test `treat'*`seq'                  
		Line "Treatment * Sequence" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r)  `ptl'
		DivLine
		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r) `ptl'
	}
	else {
                di
                TopLine "Analysis of variance (ANOVA) for a 2x2 crossover study"
                qui anova `outcome' `treat' /*
                        */ if `touse', `sequential'
                qui test `treat'
                Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
                        */ r(F) fprob(r(df),r(df_r),r(F))
                qui anova `outcome' `treat' `seq'/`id'|`seq' /*
                        */ if `touse', `sequential'
                qui test `seq'/`id'|`seq'       
                Line "Sequence effect" r(ss) r(df) r(ss)/r(df) /*
                        */ r(F) fprob(r(df),r(df_r),r(F))
		qui test `id'|`seq'
		Line "Id|Sequence" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))
                qui anova `outcome' `treat' `seq'/`id'|`seq' `treat'*`seq' /*
                        */ if `touse', `sequential'
                qui test `treat'*`seq'
                Line "Treatment * Sequence" r(ss) r(df) r(ss)/r(df) /*
                        */ r(F) fprob(r(df),r(df_r),r(F))
                Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r)
                DivLine
                Line "Total" e(rss)+e(mss) e(df_m)+e(df_r)
	}
end


program define Cx, rclass
        version 6, missing
        syntax varlist(numeric min=5 max=6) [if] [in] [, SEquential]
	marksample touse 

	tokenize `varlist'
        local id = "`1'"
        local seq = "`2'"
        local outcome = "`3'"
        local period = "`4'"
        local treat = "`5'"
        local carry = "`6'"


	if "`sequential'" == "" {
		local ptl ptl
	}
	else {
		local ptl = ""
	}
	if "`sequential'" == "" {
	       	qui anova `outcome' `seq'/`id'|`seq' `period' `treat' /*
			*/ `carry' if `touse'
		
		TopLine "Analysis of variance (ANOVA) for a crossover study" `ptl'

		HdrLine Intersubjects
	
		qui test `seq'/`id'|`seq'
		Line "Sequence effect " r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		qui test `id'|`seq'
		Line "Residuals" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		DivLine
		HdrLine Intrasubjects

		qui test `treat'
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		if "`carry'" != "" {
			qui test `carry'
			Line "Carryover effect" r(ss) r(df) r(ss)/r(df) /*
				*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'
		}

		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F)) `ptl'

		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r) `ptl'

		DivLine
		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r) `ptl'
	
	}
	else {
		di
		TopLine "Analysis of variance (ANOVA) for a crossover study"

		HdrLine "Intersubjects"

		qui anova `outcome' `seq'/`id'|`seq' if `touse'
		qui test `seq'/`id'|`seq'
		Line "Sequence effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))


		qui anova `outcome' `seq' `id'|`seq' if `touse'
		qui test `id'|`seq'
		Line "Residuals" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))

		DivLine
		HdrLine "Intrasubjects"

		qui anova `outcome' `seq'/`id'|`seq' `period' if `touse'
		qui test `period'
		Line "Period effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))

		qui anova `outcome' `seq'/`id'|`seq' `period' `treat' /*
			*/ if `touse'
		qui test `treat'
		Line "Treatment effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))

		if "`carry'" != "" {
			qui anova `outcome' `seq'/`id'|`seq' `period' /*
				*/ `treat' `carry' if `touse'
			qui test `carry'
		}
		Line "Carryover effect" r(ss) r(df) r(ss)/r(df) /*
			*/ r(F) fprob(r(df),r(df_r),r(F))

		Line "Residuals" r(rss) r(df_r) r(rss)/r(df_r)

		DivLine

		Line "Total" e(rss)+e(mss) e(df_m)+e(df_r)
	}
		
end

program define ChkVar
	args var
	unab vname : `var'
	if `"`vname'"' != `"`var'"' {
		di as err "no variable named " as res `"`var'"' /*
			*/ as err " in the data"
		exit 198
	}
end

exit
