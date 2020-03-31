*! version 2.1.6  08oct2018
program define _ggroup
	version 7, missing
	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist [if] [in] [, Missing BY(string) Label LName(name) /*
		*/ QLABEL Truncate(numlist max=1 int >= 1)]
	
	

	if `"`by'"' != "" {
		_egennoby group() `"`by'"'
		/* NOTREACHED */
	}

	if "`truncate'" != "" & "`label'" == "" {
		di as err "truncate() option requires the label option"
		exit 198
	}

	if "`lname'" != "" {
		local label "label"
	}
	
	tempvar touse
	quietly {
		mark `touse' `if' `in'
		if "`missing'"=="" { 
			markout `touse' `varlist', strok
		}

		sort `touse' `varlist'
		quietly by `touse' `varlist': /*
			*/ gen `type' `g'=1 if _n==1 & `touse'
		replace `g'=sum(`g')
		replace `g'=. if `touse'!=1
		if "`label'"!="" {
			if "`truncate'" == "" {
				local truncate `c(namelenchar)'				
			}
			if "`lname'" == "" {
				local lname $EGEN_Varname
				unab lab_name_list : _all
				foreach var of local lab_name_list {
					local lab : value label `var'
					local lab_list `lab_list' `lab'
				}
				local dup_check : list lname in lab_list
				if `dup_check' {
					di as err "you must specify the lname() option"
					exit 198
				}
			}
			

			local dfltfmt : set dp 
			local dfltfmt = /*
				*/ cond("`dfltfmt'"=="period","%9.0g","%9,0g")

			count if !`touse'
			local j = 1 + r(N)
			sum `g', meanonly
			local max `r(max)'
			local i 1
			while `i' <= 0`max' {
				tokenize `varlist'
				local vtmp ""
				local x 0
				while "`1'"!="" {
					local vallab : value label `1'
					local val = `1'[`j']
					if "`vallab'" != "" {
local vtmp2 : label `vallab' `val' `truncate'
					}
					else {
						cap confirm numeric var `1' 
						if _rc==0 {
local vtmp2 = string(`1'[`j'],"`dfltfmt'") 
						}
						else {
							if "`truncate'"=="" {
local vtmp2 : display trim(`1'[`j'])
							}
							else {
local vtmp2 : display trim(usubstr(trim(`1'[`j']),1,`truncate'))
							}
						}
					}
if ("`qlabel'" != "") {
	if (`"`vtmp'"' == "") {
		local x = length(`"`vtmp2'"') + 4
		local vtmp `"`"`vtmp2'"'"'
	}
	else {
		local x = `x' + length(`"`vtmp2'"') + 5
		local vtmp `"`vtmp' `"`vtmp2'"'"'
	}
}
else {
	if (`"`vtmp'"' == "") {
		local x = length(`"`vtmp2'"')
		local vtmp `"`vtmp2'"'
	}
	else {
		local x = `x' + length(`"`vtmp2'"') + 1
		local vtmp `"`vtmp' `vtmp2'"'
	}
}
					mac shift
				}

				local val `"`vtmp'"'
				label def `lname' `i' `"`val'"', modify
				count if `g' == `i'
				local j = `j' + r(N)
				local i = `i' + 1
			}
				label val `g' `lname'
			
		}
	}


	if length("group(`varlist')") > 80 {
		note `g' : group(`varlist')
		label var `g' "see notes"
	}
	else 	label var `g' "group(`varlist')"
end
