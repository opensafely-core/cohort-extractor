*! version 1.0.9  09sep2019
program _mkcross, sortpreserve
	version 9

	#del ;
	syntax  varlist(max=6) [if] [in],
		GENerate(name)
	[
		LABelname(name)
		MISSing
		KEYword
		LENgth(string)		
		sep(string asis)		
		MAXlength(numlist integer max=1 >=1 <=32)		
		STart(numlist integer max=1)
		EDit(string)		
		case(string)
		strok
		CODing(name)
		REPort(string)
		TRUNcate(numlist integer max=1 >=1 <=32)		
		genname(str)      // undocumented name 		
	];
	#del cr

	if "`:list dups varlist'" != "" {
		dis as err "duplicate variables"
		exit 198
	}	
	
	if "`strok'" == "" {
		capture confirm numeric variable `varlist'
		if _rc {
			dis as err "string variables not allowed"
			exit 109
		}	
		local hasstr = 0
	}
	else {
		capture confirm numeric variable `varlist'
		local hasstr = _rc!=0
	}
	if `hasstr' & "`coding'" != "" {
		dis as err "coding matrix cannot be made with string variables"
		exit 198
	}	

	local nvar : list sizeof varlist
	confirm new variable `generate', exact
	
	if "`labelname'" == "" {
		local labelname `generate'
		capture label list `labelname'
		if _rc==0 {
			dis as err "value label `labelname' already exists"
			dis as err "specify option labelname()"
			exit 198
		}
	}
	else {
		capture label list `labelname'
		if _rc==0 {
			dis as err "value label `labelname' already exists"
			exit 198
		}
	}
	
	ParseCase `case' 
	local caseopt `s(case)'

	ParseEdit `edit' 
	local editopt `s(edit)'

	ParseSeparator `"`sep'"' 
	local sep `"`s(sep)'"' 
	
	if "`start'" == "" {
		local start = 1
	}
	if "`maxlength'" == "" {
		local maxlength = 12
	}	
	if "`truncate'" == "" {
		local truncate  = 24
	}	
	if `"`length'"' != "" {
		Length `length'
		local length `s(length)'
	}
	else {
		// spread out available width over variables
		local m = `maxlength' - (`nvar'-1)*length(`"`sep'"')
		local length = floor(`m'/`nvar')
	}		
	
	if "`keyword'" != "" {
		local missing missing
	}	
	
	ParseReport `report'
	local report `s(report)'

	if "`genname'" == "" {
		local genname `generate'
	}	

// --------------------------------------------------------------------- sample

	if "`missing'" != "" {
		local msopt novarlist
	}
	marksample touse , `msopt' strok
	
	quietly count if `touse'
	local nobs = r(N)
	if `nobs' == 0 {
		exit 2000
	}	
	
// ---------------------------------- numeric variables should be integer coded

	foreach v of local varlist {
		if bsubstr("`:type `v''",1,3) != "str" {
			capture assert `v' == floor(`v')  if `touse'
			if _rc {
				dis as err ///
				    "numeric variable `v' is not integer coded"
				exit 198
			}	
		}
	}

// ----------------------------------------------------------- tag and grouping
	
	tempvar code ctag cv g lcode ls s ts unlabmv vtag vtagstr

	// ctag tags the groups = combinations of varlist
	// g identifies the groups with subsequent integers
	
	qui bys `touse' `varlist' : gen `ctag' = _n==1 if `touse'
	qui gen `g' = sum(`ctag') if `touse'
	qui replace `g' = . if !`touse'
	
	qui summ `g' if `touse'
	local ncat = r(max)

// ---------------------------------------------- disallow strLs

	_nostrl error : `varlist'

// ---------------------------------------------- construct coding per variable
//                                              add append codes across varlist

	local listopts noobs subvar sep(0) string(48)
	local skipline 1

	local j = 0
	foreach v of local varlist {
		local ++j
	
		// vtag : tags for distinct values of v (subtag of ctag)
		qui bys `touse' `v' (`ctag'): gen `vtag' = _n==_N if `touse'
		qui replace `vtag' = 0 if missing(`vtag')
	
		if bsubstr("`:type `v''",1,3) == "str" {
			local vtype "strvar"
		}
		else if "`:value label `v''" != "" {
			local vtype "valuelabeled"
		}
		else {
			if inlist(bsubstr("`:format `v''",1,1), "d","t") {
				dis as txt ///
				"(date/time variable `v' treated as numeric)"
			}
			local vtype "numeric"
		}
	
		if "`vtype'" == "numeric" { // --------------------------------
			qui gen `cv' = string(`v') if `vtag'
			if "`keyword'" != "" {
				qui replace `cv' = "miss" if `v'==. & `vtag'
				qui replace `cv' = ///
				    "dot" + bsubstr(`cv',2,.) if `v'>. & `vtag'
			}

			qui gen `s' = `cv' if `vtag'
	
			qui gen `ls' = length(`cv') if `vtag'
			qui summ `ls' if `vtag'
			local len_`j' = r(max)
			drop `ls'
		
			qui replace `cv' = ///
			    string(`v',"%0`len_`j''.0f") if `v'<. & `vtag'
			capture assert missing(`v')
			if ("`length'" == "minimal") {
				if _rc != 0 { 
					gen byte `ls' = `vtag' & (`v'<.)
					mata: DropSamePrePost("`cv'","`ls'")
					drop `ls'
					qui gen `ls' = length(`cv') if `vtag'
					qui summ `ls' if `vtag'
					local len_`j' = r(max)
					drop `ls'
				} // else all missings, so leave `cv' alone
			}	
			else {
				capture assert `v'< .
				if _rc != 0 & `length' < 4 {
					local length 4
				}
				if `len_`j''>`length' { // else leave alone
					// fixed length
						qui gen `ts'=bsubstr(`cv',`len_`j''-`length'+1,`len_`j'') if `vtag'
					capture bys `vtag' `ts' : ///
					   assert `v'==`v'[1] if `vtag'
					if _rc {
						dis as err "coding of " ///
						  " `v' not " ///
					          "unique at length `length'"
						exit 198
					}
					local len_`j' = `length'
					qui replace `cv' = `ts' if `vtag'
				}
			}
			
			if inlist("`report'", "variables","all") {
				if `skipline' {
					dis
					local skipline 0
				}	
				dis as txt "Coding of `v'"
				char `cv'[varname] code
				list `cv' `v' if `vtag', `listopts'
				dis
			}	
			capture drop `ts'
		}
		else { // -----------------------------------------------------
	
			if "`vtype'" == "strvar" {
		
				qui gen `s'       = `v'
				qui gen `vtagstr' = `vtag'
				qui gen `unlabmv' =  0
			
			}
			else {
				qui decode `v' if `vtag', gen(`s')

				// decode assigns blanks to unlabeled values
			
				gen `unlabmv' = (`v'>=.) & (`s'=="") & `vtag'
				gen `vtagstr' = (`vtag') & (`s'!="")

				// string-version if no label available
				qui replace `s' = string(`v') ///
				                  if `s'=="" & `vtag'
			}

		// keep only standard chars: letters, digits, _ and blank -----

			qui gen `cv' = trim(`s') if `vtag'
			mata : KeepStandard("`cv'","`vtagstr'")
			CheckNull `v' `cv' `s' `vtagstr' ///
			          "no letter(a-zA-Z)/digit(0-9) found" 
			drop `vtagstr'

		// edit -------------------------------------------------------

			if "`editopt'" == "space" {
				qui replace `cv' = ///
				            subinstr(`cv'," ","",.) if `vtag'
				CheckNull `v' `cv' `s' `vtag' "spaces only"
			}
			else if "`editopt'" == "first" {
				qui replace `cv' = word(`cv',1) if `vtag'
			}
			else if "`editopt'" == "vowel" {
				mata: DropVowels("`cv'","`vtag'")
				CheckNull `v' `cv' `s' `vtag' "vowels only"
			}


		// case -------------------------------------------------------

			if "`caseopt'" == "lower" {
				qui replace `cv' = lower(`cv')  if `vtag'
			}
			else if "`caseopt'" == "upper" {
				qui replace `cv' = upper(`cv')  if `vtag'
			}
			else if "`caseopt'" == "first" {
				qui replace `cv' = proper(`cv') if `vtag'
			}

		// keywords for missing values, AFTER processing case and edit

			if "`keyword'" != "" {
				if "`vtype'" == "strvar" {
					qui replace `cv' = "miss" ///
					                    if `v'=="" & `vtag'
				}
				else {
					qui replace `cv' = "miss" ///
					                    if `v'==. & `vtag'
					qui replace `cv' =                 ///
					          "dot" + bsubstr(`cv',2,1) ///
					         if `v'>. & `unlabmv' & `vtag'
				}
			}

		// code -- exclude unlabeled mv's -----------------------------

			qui compress `cv'
			qui gen `ts' = length(`cv') if `vtag'
			qui summ `ts' if `vtag'
			local min = r(min)
			local max = r(max)
			capture drop `ts'
					
			if "`length'" == "minimal" {
				// determine min length at which codes unique
				local len_`j' = 0
				forvalues k = 1/`max' {
					capture drop `ts'
					qui gen `ts' = bsubstr(`cv', ///
					   1, cond(`unlabmv',.,`k')) if `vtag'
					capture bys `vtag' `ts' : ///
					   assert `v'==`v'[1] if `vtag'
					if _rc==0 {
						local len_`j' = `k'
						continue, break
					}
				}
				if `len_`j''==0 {
					dis as err "coding of `v' not " ///
					           "unique at full length"
					exit 198
				}
			}
			else {
				// fixed length
				local len_`j' = `length'
				qui gen `ts'=bsubstr(`cv',1,`len_`j'') if `vtag'
				capture bys `vtag' `ts' : ///
				   assert `v'==`v'[1] if `vtag'
				if _rc {
					dis as err "coding of `v' not " ///
					           "unique at length `len_`j''"
					exit 198
				}	
			}
		
			qui replace `cv' = `ts'  if `vtag'
			
		// show coding table for the variable -------------------------
	
			if inlist("`report'", "variables","all") {
				if `skipline' {
					dis
					local skipline 0
				}	
				dis as txt "Coding of `v'"
			
				sort `v'
				format %-`maxlength's `cv'
				char `cv'[varname] code
			
				if "`vtype'" == "strvar" {
					char `s'[varname] `v'
					format %-`maxlength's `s'
					list `cv' `s' if `vtag', `listopts'
				}
				else {
					qui gen `ls' = `v'
					char `ls'[varname] value
					list `ls' `cv' `v'  if `vtag', `listopts'
					drop `ls'
				}
				dis
			}
			else if (`len_`j''>`min') {
				dis as txt "(codes of `v' not of same length)"
			}
		
			capture drop `ts' `unlabmv' 
		}
	
		// assign (cv,s), spreading out over ctag ---------------------
	
		if `j'==1 {
			qui bys `ctag' `v' (`vtag') :                       ///
			                       gen `code'  = `cv'[_N] if `ctag'
			   
			qui bys `ctag' `v' (`vtag') :                       ///
			                       gen `lcode' =  bsubstr(`s'[_N],1,`truncate') if `ctag'
		}            
		else {
			qui bys `ctag' `v' (`vtag') : replace `code'  =    ///
			                 `code' + "`sep'" + `cv'[_N] if `ctag'
			                
			qui bys `ctag' `v' (`vtag') :                      ///
			             replace `lcode' = `lcode' + "; " +    ///
			                bsubstr(`s'[_N],1,`truncate') if `ctag'
		}	
	
		drop `cv' `s' `vtag' 
	}		

// -------------------------------------------------------- check coding length

	qui compress `code'
	local len_sum = bsubstr("`:type `code''",4,.)
	if `len_sum'  > `maxlength' {
		dis as err "Value labels of combined variables " ///
		           "not unique at length `maxlength'"
		local j 1	          
		foreach v of local varlist {
			dis as err ///
			    "  `v' needs `len_`j'' chars in crossed value label"
			local ++j
		}
		exit 198
	}

// -------------------------------------------- encode and create coding matrix

	local mkcoding = !`hasstr' & "`coding'" != ""
	if `mkcoding'  {
		matrix `coding' = J(`ncat',`nvar',.)
		matrix colnames `coding' = `varlist'
		numlist `"`start' / `=`start'+`ncat'-1'"'
		matrix rownames `coding' = `r(numlist)'
	}	

	sort `touse' `ctag' `g' 
	forvalues i = 1/`ncat' {
		local ii = c(N) - `ncat' + `i'
		local c = `code' in `ii'
		label define `labelname' `=`i'+`start'-1' `"`c'"' , modify
		
		if `mkcoding' {
			local j = 0
			foreach v of local varlist {
				local ++j	
				matrix `coding'[`i',`j'] = `v'[`ii']
			}	
		}
	}

	if `start' != 1 {
		quietly replace `g' = `g' - 1 + `start'
	}
	quietly compress `g'
	rename `g' `generate'
	label  value    `generate' `labelname'
	label  variable `generate' "group(`varlist')"
	
// ------------------------------------------------------ report overall coding

	if inlist("`report'", "crossed","all") {
		if (`skipline') dis
		dis as txt "Coding of (`genname': " ///
		    subinstr("`varlist'"," ","; ",.) ")"
		
		qui gen `ts' = `generate'
		char `ts'[varname] value

		format `code' %-`maxlength's				
		char  `code'[varname] code 
		
		format `lcode' %-`truncate's
		char `lcode'[varname] description
	
		sort `generate'	
		list `ts' `code' `lcode' if `ctag'==1, `listopts'
	}
	
end /* end _mkcross */

// ========================================================== Stata subroutines

program ParseReport, sclass
	local 0 ,`0' 
	syntax [, Variables Crossed All ]
	
	local s `variables' `crossed' `all'
	local ns : list sizeof s
	if `ns' > 1 {
		opts_exclusive "`s'" "report"
	}	
	
	sreturn clear
	sreturn local report `s'
end	


program ParseCase, sclass
	local 0 ,`0' 
	syntax [, UNchanged First Upper Lower ]
	
	local s `unchanged' `first' `upper' `lower'
	local ns : list sizeof s
	if `ns' > 1 {
		opts_exclusive "`s'" "case"
	}	
	else if `ns' == 0 {
		local s unchanged
	}
	
	sreturn clear
	sreturn local case `s'
end	


program ParseEdit, sclass
	local 0 ,`0' 
	syntax [, Space First Vowel ]
	
	local s `first' `space' `vowel'
	local ns : list sizeof s
	if `ns' > 1 {
		opts_exclusive "`s'" "edit"
	}	
	else if `ns' == 0 {
		local s space
	}	
	
	sreturn clear
	sreturn local edit `s'
end	


program ParseSeparator, sclass
	args sep
	if `"`sep'"' == "" {
		local s _
	}
	else if `"`sep'"' == `""""' {
		local s
	}
	else {
		gettoken s : sep
		gettoken s : s
	}
	sreturn clear
	sreturn local sep `"`s'"' 
end


program Length, sclass
	args x
		
	if `"`x'"' == bsubstr("minimal",1,length(`"`x'"')) {
		local x minimal
	}
	else {
		capture numlist `"`x'"', min(1) max(1) range(>=1 <=32)
		if _rc == 125 {
			noi di as err "length not in range 1-32"
			exit 198
		}
		local x `r(numlist)'
	}	
	sreturn clear
	sreturn local length `x'
end



program CheckNull
	args v cv s touse text
	
	capture assert `cv' != "" if `touse' & `s' != ""
	if _rc {
		dis _n as err "null code(s) found for `v'"
		dis    as err `"`text'"'
		exit 198
	}	
end

// ============================================================= mata functions

mata:

void function DropVowels( string scalar _v, string scalar _touse )
{
	string colvector  svar
	real scalar       i, j
	string scalar     s, t
	string scalar	  evowels

	pragma unset svar
	st_sview(svar, ., _v, _touse)
	
	// extended vowels (not yY)
	evowels = "aeiouAEIOU "
	
	for (i=1; i<=rows(svar); i++) {
		s = svar[i,1]
		t = ""
		while (j = indexnot(s,evowels)) {
			t = t + bsubstr(s,j,1)
			s = bsubstr(s,j+1,.)
		}
		svar[i,1] = t		
	}
}

// keeps only a..z, A..Z, 0..9, underscore, space
void function KeepStandard( string scalar _v, string scalar _touse )
{
	string colvector  svar
	real scalar       i, j
	string scalar     ch, s, t
	
	pragma unset svar
	st_sview(svar, ., _v, _touse)
	
	for (i=1; i<=rows(svar); i++) {
		s = svar[i,1]
		t = ""
		for (j=1; j<=strlen(s); j++) {
			ch = bsubstr(s,j,1)
			if ( ((ch>="a") & (ch<="z")) |
			     ((ch>="A") & (ch<="Z")) |
			     ((ch>="0") & (ch<="9")) |
			     (ch==" ") |
			     !indexnot(ch,"+-#_")
			   ) t = t + ch
		}	
		svar[i,1] = t		
	}
}


void function DropSamePrePost( string scalar _v, string scalar _touse )
{
	real scalar       i, j2, j
	real colvector    n, cons
	string colvector  s, subs
	
	s = strtrim(st_sdata( ., _v, _touse ))
	n = strlen(s)
	if (min(n = strlen(s)) < max(n)) {
	    _error( "_mkcross::DropSameSubStr:: strings not of same length" )
	}

	cons = 1
	n = n[1]
	for (j2=1; cons & j2<=n; j2++) {	
		subs = bsubstr(s,j2,.)
		for (i=1; cons & i<=rows(s); i++) {
			for(j=i+1; cons & j<=rows(s); j++){
				if (subs[i] == subs[j]) {
					j2--
					cons = 0
				}
			}
		}
	}
	j2--
	st_sstore( .,_v, _touse, bsubstr(s,j2,n))
}

end
exit

coding of missing values

    standard      .    .a    .b  ---    .z
     keyword   miss  dota  dotb  ---  dotz
       short     mv    da    db  ---    dz
  underscore     __    _a    _b  ---    _z


