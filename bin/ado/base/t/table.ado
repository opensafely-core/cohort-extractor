*! version 5.4.4  30aug2016
program define table, byable(recall)
	version 7.0, missing

	syntax varlist(max=3) [if] [in] [fw aw pw iw] [, /* 
		*/ BY(varlist) COLumn CW Format(string) Name(string) REPLACE /*
		*/ ROW SColumn markdown Contents(string) CELLwidth(string) *]
	local sctotal "`scolumn'"
	local coltota "`column'"
	local rowtota "`row'"

	if "`replace'"!="" & _by()==1 { 
		di in red "option replace may not be combined with by"
		exit 190
	}

	local stats "`contents'"
	local contents
	if "`by'" != "" {
		local byopt "by(`by')"
	}
        
	if "`cellwidth'" =="" {
		/* set cellw to width implied by format() option if it is
			greater than 9.  Set cellw to 0 otherwise. */
		GetFormatWidth "`format'"
		if `s(formatwidth)' > 9 {
			local cellw `s(formatwidth)'
			local cellwidth `cellw'
		}
		else {
			local cellw 0
		}
	}
	else local cellw  `cellwidth' 
	local msg  1 

	tokenize `varlist'
	local row "`1'"
	local col "`2'"
	local sc  "`3'"

	if "`coltota'"!="" & "`col'"=="" { 
		local coltota 
	}
	if "`sctotal'"!="" & "`sc'"=="" {
		local sctotal 
	}

	tempname one touse

	if "`stats'"=="" {
		local stats "freq"
	}

	if "`replace'"!="" & "`name'"=="" {
		local name "table"
	}
	local i 0
	tokenize `"`stats'"'
	while "`1'" != "" { 
		local i = `i' + 1
		if "`replace'"!="" {
			tempname `name'`i'	
			local res `"``name'`i''"'
		}
		else	tempvar res
		Parse "`weight'" `"`format'"' `res' `one' `*'
		if "`replace'"!="" {
			local s3`i' = $S_3
		}
		local clist "`clist' $S_1"
		local cell  "`cell' `res'"
		local vlist "`vlist' $S_2"
		local flist "`flist' $S_4"
		mac shift $S_3
	}
	if `i'>5 /* limit from tabdisp */ {
		di in red "too many stats()"
		exit 103
	}
				/* take care of cell length */
	if `i' <= 4 {
		local flag 1
	}
	else local flag 0 

	confirm new var `res'			/* in case replace	*/

	quietly { 
		if "`weight'" != "" {
			tempvar wvar
			gen double `wvar' `exp'
			local wgt "[`weight'=`wvar']"
		}
		mark `touse' `wgt' `if' `in'
		count if `touse'
		if r(N)==0 { 
			noisily error 2000
		}
		preserve
		keep if `touse'
		drop `touse'
		DropMis `varlist' `by'
		if _N==0 { 
			noisily error 2000
		}
		gen byte `one' = 1 
/*
		if "`weight'"=="aweight" {
			summarize `wvar', mean
			replace `wvar' = `wvar'/r(mean)
			local wgt "[iweight=`wvar']"
		}
*/

		keep `varlist' `by' `vlist' `wvar'
		if "`rowtota'"=="" & "`coltota'"=="" & "`sctotal'"=="" {
			capture collapse `clist' `wgt', ///
				by(`varlist' `by') fast `cw'
			if (_rc == 111) {
			  di as err ///
			    "rowvar variable(s) may not be used in contents()"
			  exit _rc 
			}
			if (_rc == 135) {
			  local sd_in = cond(strpos("`clist'","sd")==0,"0","sd")
			  local se_in = cond(strpos("`clist'","sem")==0,"0","semean")
			  local seb_in = cond(strpos("`clist'","seb")==0 /*
			    */,"0","sebinomial")
			  local sep_in = cond(strpos("`clist'","sep")==0 /*
			    */,"0","sepoisson")
			
			  GetError `weight' `sd_in' `se_in' `seb_in' `sep_in'
	  		  di as err "`s(error)'"
			  exit _rc
			}  	
	 	}
		else {
			tempfile res orig
			save "`orig'"
			capture collapse `clist' `wgt', ///
				by(`varlist' `by') fast `cw'
			if (_rc == 111) {
			  di as err ///
			    "rowvar variable(s) may not be used in contents()"
			  exit _rc 
			}
			if (_rc == 135) {
			  local sd_in = cond(strpos("`clist'","sd")==0,"0","sd")
			  local se_in = cond(strpos("`clist'","sem")==0,"0","semean")
			  local seb_in = cond(strpos("`clist'","seb")==0 /*
			    */,"0","sebinomial")
			  local sep_in = cond(strpos("`clist'","sep")==0 /*
			    */,"0","sepoisson")
			
			  GetError `weight' `sd_in' `se_in' `seb_in' `sep_in'
	  		  di as err "`s(error)'"
			  exit _rc
			}
			save "`res'"
			if "`rowtota'" != "" {
				AddRes "`res'" "`orig'" "`clist'" /*
				*/ "`col' `sc' `by'" "`cw'" "`wgt'"
			}
			if "`coltota'"!= "" {
				AddRes "`res'" "`orig'" "`clist'" /*
				*/ "`row' `sc' `by'" "`cw'" "`wgt'"
				if "`rowtota'" != "" {
					AddRes "`res'" "`orig'" "`clist'" /*
					*/ "`sc' `by'" "`cw'" "`wgt'"
				}
			}
			if "`sctotal'"!="" {
				AddRes "`res'" "`orig'" "`clist'" /*
				*/ "`row' `col' `by'" "`cw'" "`wgt'"
				if "`rowtota'" != "" {
					AddRes "`res'" "`orig'" "`clist'" /*
					*/ "`col' `by'" "`cw'" "`wgt'"
				}
				if "`coltota'" != "" {
					AddRes "`res'" "`orig'" "`clist'" /*
					*/ "`row' `by'" "`cw'" "`wgt'"
				}
				if "`rowtota'" != "" & "`coltota'"!="" {
					AddRes "`res'" "`orig'" "`clist'" /*
					*/ "`by'" "`cw'" "`wgt'"
				}
			}
		}
	}

					/* set display formats		*/
	tokenize `"`flist'"'
	while "`1'" != "" { 
		capture format `1' `2'
		if _rc {
			di as err "invalid format `2'"
			exit 198
		}
		mac shift 2
	}

	if "`c'"=="" | "`replace'"!="" {
		FixLabs "(count) `one'" `cellw' `flag' `msg' `cell'
	}

	if "`replace'"!="" {
		mac drop S_FN S_FNDATE
		restore, not
	}
	if "`cellwidth'" == "" {
		tabdisp `varlist', cell(`cell') `byopt' totals `options' `markdown'
	}
	else {
		local options "cellwidth(`cellwidth') `options'"
		tabdisp `varlist', cell(`cell') `byopt' totals `options' `markdown'
	}
	if "`replace'" != "" {
		tokenize `"`stats'"'
		local i = 0
		while "`1'" != "" {
			local i = `i' + 1
			rename ``name'`i'' `name'`i'
			mac shift `s3`i''
		}
	}

end

program define AddRes /* resfn origfn clist by cw wgt */
	args res orig clist by cw wgt 

	use "`orig'", clear
	local n : word count `by'
	if `n' {
		collapse `clist' `wgt', by(`by') fast `cw'
	}
	else	collapse `clist' `wgt', fast `cw'

	append using "`res'"
	save "`res'", replace
end

program define Parse /* "weighttype" fmt newvar onevar stuff */
	args weight fmt res one 
	mac shift 4
	if "`1'"=="freq" {
		global S_1 "(count) `res'=`one'"
		global S_2 "`one'"
		global S_3 1
		if ("`weight'"=="aweight" | "`weight'"=="iweight" /*
		*/ | "`weight'"=="pweight" | "`weight'"=="fweight") /*
		*/ & `"`fmt'"'!=""  {
			global S_4 "`res' `fmt'"
		}
		else if `"`fmt'"' != "" {

			global S_4 "`res' `fmt'"
		}
		else	global S_4 "`res' %9.0gc"
		exit
	}

	if "`2'"=="" { 
		di in red "`1' invalid or requires argument"
		exit 198 
	}

					/* synonyms	*/
	if lower("`1'")=="n" {
		local 1 "count"
	}
	else if bsubstr("median",1,max(3,length("`1'")))=="`1'" {
		local 1 "median"
	}
	else if bsubstr("mean",1,length("`1'"))=="`1'" {
		local 1 "mean"
	}


	unabbrev `2', max(1)
	local vn "`s(varlist)'"

	confirm numeric variable `vn'

	Valid `1' `vn' `"`fmt'"' `weight'
	global S_4 "`res' $S_1"
	global S_1 "(`1') `res'=`vn'"
	global S_2 "`vn'"
	global S_3 2
end

program define Valid /* word fromvar dfltfmt weighttype */
	args w v f weight

	local len : length local w
	if bsubstr("semean", 1, max(3,`len')) == "`w'" {
		local w "sem"
	}
	if bsubstr("sebinomial", 1, max(3,`len')) == "`w'" {
		local w "seb"
	}
	if bsubstr("sepoisson", 1, max(3,`len')) == "`w'" {
		local w "sep"
	}

	if "`w'"=="sd" | "`w'"=="sem" | "`w'"=="sep" | /*
	*/ "`w'"=="seb" | "`w'"=="iqr" | "`w'"=="sum" | "`w'"=="rawsum" {
					/* meaning default format */
		global S_1 = cond(`"`f'"'=="", "%9.0g", `"`f'"')
		exit 
	}

	if "`w'"=="count" {
		if ("`weight'"=="aweight" | "`weight'"=="iweight" /*
		*/ | "`weight'"=="pweight") & `"`f'"'!=""  {
			global S_1 `"`f'"'
		}
		else 	global S_1 "%9.0gc"	/* meaning as-is format */
		exit
	}

			/*
				remaining have default format or 
				variable's date format
			*/
	local fmt : format `v'
	if bsubstr("`fmt'",2,1)=="-" { 
		local fmt = "%" + bsubstr("`fmt'",3,.)
	}

	if bsubstr("`fmt'",1,2)=="%d" | bsubstr("`fmt'",1,2)=="%t" {
		global S_1 "`fmt'"
	}
	else	global S_1 = cond("`f'"=="", "`fmt'", "`f'")


	if "`w'"=="mean" | "`w'"=="median" { 
		exit 
	}
	if "`1'"=="max" | "`1'"=="min" {
		exit 
	}

	if bsubstr("`1'",1,1)=="p" {
		local n = bsubstr("`1'",2,.)
		capture confirm integer number `n'
		if _rc==0 { 
			if `n'>0 & `n'<100 { 
				exit
			}
		}
	}
	di in red "`1' invalid"
	exit 198
end

program define DropMis /* varnames */
	while "`1'" != "" {
		local t : type `1'
		if bsubstr("`t'",1,3)=="str" { 
			drop if `1'=="" 
		}
		else	drop if `1'==.
		mac shift 
	}
end

program define FixLabs /* lab varnames */
	args true cellw flag msg
	mac shift 4
	while "`1'" != "" {
		local lab : variable label `1'
		if "`lab'"=="`true'" {
			label var `1' "Freq."
		}
		else {
			FixLab2 `cellw' `flag' `msg' `1' `lab'
			local msg `s(tmp)'
		}
		mac shift
	}
end

program define FixLab2, sclass /* label */
	args cellw flag msg var wrd
	mac shift 5 
	sreturn clear
	if "`wrd'"=="(count)" {
		if `cellw' == 0 {
			local len = cond(`flag'==1, 8, 9)
		}
		else	local len = `cellw'-3
		FixLab3 `var' N "`*'" `len' `msg'
		/* sreturn local tmp = `s(tmp)' */
		exit
	}
	if "`wrd'" == "(p" {
		local wrd "`1'"
		mac shift 
		if "`wrd'"=="50)" {
			local wrd "med"
			if `cellw' == 0 {
				local len = cond(`flag'==0, 7, 8)
			}
			else	local len = `cellw' - 5
		}
		else {
			local wrd = bsubstr("`wrd'",1,length("`wrd'")-1)
			if `cellw' == 0 {
				local len = cond(`flag'==0,9-length("`wrd'"),8)
			}
			else 	local len = `cellw' - length("`wrd'") - 3
			local wrd p`wrd'
		}
		FixLab3 `var' `wrd' "`*'" `len' `msg'
		/* sreturn local tmp = `s(tmp)' */
		exit
	}
	if "`wrd'"=="(sepoisson)" | "`wrd'"=="(sebinomial)" | "`wrd'"=="(semean)" {
		local wrd = bsubstr("`wrd'",2,3)
                if `cellw' == 0 {
                	local len = cond(`flag'==0, 7, 8)
                }
                else    local len = `cellw' - 5
		FixLab3 `var' `wrd' "`*'" `len' `msg'
                /* sreturn local tmp = `s(tmp)' */
		exit
	}
	
	if bsubstr("`wrd'",1,1)=="(" & bsubstr("`wrd'",-1,1)==")" {
		local wrd = bsubstr("`wrd'",2,length("`wrd'")-2)
		if `cellw' == 0 {
			local len=cond(`flag'==0,10-length("`wrd'"),8)
		}
		else 	local len = `cellw'-length("`wrd'")-2
		FixLab3 `var' `wrd' "`*'" `len' `msg'
		/* sreturn local tmp=`s(tmp)' */
		exit
	}
end

program define FixLab3, sclass
	args vn fcn name len msg
	local len = `len'
	if `len' < 0 {
		local nam = ""
		local fcn = ""
		di _n in gr /* 
		*/ "note: cellwidth too small, cannot display column heading;"
		di in gr /*
                */ "to increase cellwidth, specify cellwidth(#)"
		local msg 0
		label var `vn' " "
	}
	else if `len' == 0 {
		di _n in gr /* 
                */ "note: cellwidth too small, cannot display variable name;"
                di in gr /*
                */ "to increase cellwidth, specify cellwidth(#)"
                local msg 0
		label var `vn' "`fcn'()"
	}
	else if `len' < 5 {
		local nam = udsubstr("`name'", 1, `len')
		if `msg' & "`nam'"!="" & "`nam'"!="`name'" {
			di _n in gr /* 
			*/ "note: cellwidth too small, variable name truncated;"
			di in gr /*
			*/ "      to increase cellwidth, specify cellwidth(#)"
			local msg 0
		}
		label var `vn' "`fcn'(`nam')"	
	}
	else {
		local nam = abbrev("`name'", `len')
		label var `vn' "`fcn'(`nam')"
	}
	sret local tmp `msg'
end

program define GetFormatWidth, sclass
	args fmt

	if "`fmt'" == "" | bsubstr("`fmt'",1,1)!="%" {
		/* no (or a bad) format() option specified
						default to 0 (== unknown) */
		sret local formatwidth 0
	}
	else {
		local fmt = bsubstr("`fmt'",2,.)  /* remove the % */
		if bsubstr("`fmt'",1,1)=="-" {
			local fmt = bsubstr("`fmt'",2,.)  /* remove the - */
		}
		if bsubstr("`fmt'",1,1)=="d" | bsubstr("`fmt'",1,1)=="t" {
			/* date or time format -- default to 0 (unknown) */
			sret local formatwidth 0
		}
		else if index("`fmt'","s") { /* string format */
			sret local formatwidth = /*
				*/ bsubstr("`fmt'",1,length("`fmt'")-1)
		}
		else if index("`fmt'",".") { /* numeric format */
			sret local formatwidth = /*
				*/ bsubstr("`fmt'",1,index("`fmt'",".")-1)
		}
		else if index("`fmt'",",") { /* european numeric format */
			sret local formatwidth = /*
				*/ bsubstr("`fmt'",1,index("`fmt'",",")-1)
		}
		else { /* bad format -- default to 0 (unknown) */
			sret local formatwidth 0
		}
	}
end

program define GetError, sclass
	args wgt sd_in se_in seb_in sep_in
	local s_list "`sd_in' `se_in' `seb_in' `sep_in'"

	if "`wgt'"=="iweight" {
		local s_list = subinstr("`s_list'","sd","",1)
	}
	if "`wgt'"=="aweight" {
		local s_list = subinstr("`s_list'","sd","",1)
		local s_list = subinstr("`s_list'","semean","",1)
	}
	
	local s_list = subinstr("`s_list'","0","",.)
	local count: word count `s_list'
	local error ""
	local i=0
	
	foreach opt of local s_list {
		local ++i
		if `i' < `count'-1{
			local error "`error'`opt', "
		}
		else if `i'==`count'-1 {
			local error "`error'`opt' and "
		}
		else if `i'==`count' {
			local error "`error'`opt' not allowed with `wgt's"
		}
	}
	sret local error "`error'"
end
	
