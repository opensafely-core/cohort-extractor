*! version 1.5.4  15oct2019
program define fracgen, rclass
	version 8

	gettoken v 0 : 0, parse(" ,")
	unab v : `v', max(1)

	local done 0
	gettoken nxt : 0, parse(" ,")
	while ("`nxt'" != "" & "`nxt'" != ",") & !`done' {
		cap confirm number `nxt'
		if !_rc {
			local powers "`powers' `nxt'"
			gettoken nxt 0 : 0, parse(" ,")
			gettoken nxt   : 0, parse(" ,")
		}
		else 	local done 1
	}
	if "`powers'"=="" {
		di in red "powers required"
		exit 198
	}

	syntax [if] [in] [, noSCAling REPLACE /*
		*/ restrict(string) CATzero noDouble NAme(string) Index(integer 1) /*
		*/ EXPx(string) ORIgin(string) Zero noGEN /*
		*/ Adjust(str) CENTer(str) STUBlen(int 6) SAYESAMP * ]

	local double = cond("`double'"!="", "", "double") 

	if `"`options'"' != "" { 
		di as txt `"[`options' ignored]"'
	}

	* catzero implies zero
	if "`catzero'"!="" local zero zero

	if ("`adjust'"=="") {
	        local adjust "`center'"
	}
	else if ("`adjust'"!="" & "`center'"!="") {
		di as err "options {bf:adjust()} and {bf:center()} may not be specified together"
		exit 198
	}
	if "`adjust'"=="no" local adjust
	if "`adjust'"!="" & "`adjust'"!="mean" {
		cap confirm num `adjust'
		if _rc {
			di in red "invalid option {bf:center()}, must be # or mean"
			exit 198
		}
	}
	tempname small
	scalar `small'=1e-6

	tempvar x lnx
	frac_pq "`powers'" 1 0
	local np `r(np)'
	local i 1
	while `i'<=`np' {
		local p`i' `r(p`i')'
		local i=`i'+1
	}

* `lin' signifies only power 1 is used; but x could still be transformed.
	local lin = (`np'==1 & `p1'==1)

* identity transformation: do nothing except record name of original xvar.
	if `lin' & `"`zero'`origin'`expx'`name'`adjust'"'=="" {
		ret local names `v'
		local l : var lab `v'
		char `v'[fp] `l'
		ret scalar shift = 0 
		ret scalar scale = 1
		global S_1 `v'				/* double save */
		global S_2 0				/* double save */
		global S_3 1				/* double save */
		global S_4
		exit
	}
	local names
	local name = usubstr(cond("`name'"=="", "`v'", "`name'"), 1, `stublen')

	quietly {
		tempvar touse
		mark `touse' `if' `in'
		if "`restrict'"!="" {
/*
	-restrict()- becomes part of touse for calculation purposes;
	only for restricting the transformation is the original touse used.
*/
			tempvar touse_user
			gen byte `touse_user' = `touse'
			frac_restrict `touse' `restrict'
		}
		else	local touse_user `touse'
		if "`sayesamp'"=="" local say `"`if' `in'"'
		else local say "if e(sample)"
		gen `double' `x' = `v'
		gen `double' `lnx' = .
		frac_xo `x' `lnx' `lin' "`expx'" "`origin'" /*
		*/ "`zero'" "`scaling'" `v' `touse' "`adjust'"
		local shift = cond(r(shifted)==0, 0, r(zeta))
		local expxest `r(expxest)'
		local scale `r(scale)'
		local adjust `r(adjust)'
		local r `v'
		if "`expx'"!="" {
			local e=bsubstr(`"`r(expxest)'"',1,8)
			local r `"exp(`e'*`r')"'
			if "`adjust'"!="" {
				local adjust=exp(`r(expxest)'*`adjust')
			}
		}
		if "`adjust'"!="" {
			local adjust=(`adjust'+`shift')/`scale'
		}
		if `shift'!=0 local r "(`r'+`shift')"
		if "`scaling'"!="noscaling" {
			if `scale'<1 {
				local scale=1/`scale'
				local r "`r'*`scale'"
			}
			else {
				if `scale'>1 local r "`r'/`scale'"
			}
		}
		if "`r'"!="`v'" {
			local vn X
			local where ": X = `r'"
		}
		else 	local vn `v'
/*
		`x' & `lnx' emerge from frac_xo unrestricted to
		the desired sample. Now restrict them.
*/
		replace `x'=. if `touse_user'==0
		replace `lnx'=. if `touse_user'==0
		if "`gen'"=="nogen" {
			ret scalar shift = `shift'
			ret scalar scale = `scale'
			ret local expxest `expxest'
			global S_2 `shift'		/* double save */
			global S_3 `scale'		/* double save */
			global S_4 `expxest'		/* double save */
			exit
		}
		local h0 1
		local plast 0
		local hlast "h0"
		local k 0
		local j 1
		while `j'<=`np' {
			if "`adjust'"!="" {
				tempname adj`j'
			}
			local hj h`j'
			local nj n`j' /*transformation for labeling purposes*/
			tempvar `hj'
			local pj `p`j''
			if abs(`pj'-`plast')>`small' { /*not a repeated power*/
				if abs(`pj')<`small' {
					gen `double' ``hj'' = `lnx'
					local `nj' ln(`vn')
					local k 1
					local nlast
					if "`adjust'"!="" {
						scalar `adj`j''=log(`adjust')
					}
				}
				else {
					if abs(`pj'-1)<`small' {
						gen `double' ``hj'' = `x'
						local `nj' `vn'
					}
					else {
						gen `double' ``hj'' = /*
						*/ cond(`x'==0,0,`x'^`pj')
						if int(2*abs(`pj'))!= /*
						*/ (2*abs(`pj')) {
							frac_ddp `pj' 4
							local `nj' `vn'^`r(ddp)'
						}
						else 	local `nj' `vn'^`pj'
					}
					if "`adjust'"!="" {
						scalar `adj`j''=`adjust'^`pj'
					}
					local k 0
					local nlast ``nj''*
				}
			}
			else {
				local k=`k'+1
				if `j'==1 {
					gen `double' ``hj'' = `lnx'
					if "`adjust'"!="" {
						scalar `adj`j''=log(`adjust')
					}
				}
				else {
					gen `double' ``hj'' = `lnx'*``hlast''
					if "`adjust'"!="" {
						scalar `adj`j''=/*
						*/ ln(`adjust')*`alast'
					}
				}
				if `k'==1 {
					local `nj' `nlast'ln(`vn')
				}
				else 	local `nj' `nlast'ln(`vn')^`k'
			}
			local hlast `hj'
			local plast `pj'
			if "`adjust'"!="" {
				local alast `adj`j''
			}
			local j = `j'+1
		}
	}
	local j 0
	if `index'+`np'>99 local index = 99-`np'
	while `j'<`np' {
		local k = `j'+`index'
		local j = `j'+1
		local hj h`j'
		local nj n`j'
		if `k'<10 local k _`k'
		local xj `name'`k'
		if "`replace'"!="" capture drop `xj'
		if "`adjust'"!="" {
			local adjj `adj`j''
			qui gen `double' `xj'=``hj''-`adjj'
			if `adjj'<0 {
				local s +
				local adjj=-`adjj'
			}
			else 	local s -
			local adjd: display %12.0g `adjj'
			local adjd=trim("`adjd'")
			di in gr /*
			*/ `"-> gen `double' `xj' = ``nj''`s'`adjd' `say'"'
			local l ``nj''`s'`adjd'`where'
		}
		else {
			qui gen `double' `xj'=``hj''
			di in gr `"-> gen `double' `xj' = ``nj'' `say'"'
			local l ``nj''`where'
		}
		lab var `xj' "`l'"
		char `xj'[fp] `l'
		drop ``hj''
		local names `names' `xj'
	}
	if "`v'"!="`r'" { 
		di in gr "   (where`where')"
	}
	if "`catzero'"!="" {
		local xj `name'_0
		if "`replace'"!="" capture drop `xj'
		qui gen byte `xj' = `v'<=0 if `touse_user'
		di in gr `"-> gen byte `xj' = `v'<=0 `say'"'
		local l "`v'<=0"
		lab var `xj' "`l'"
		local names `xj' `names'
		char `xj'[fp] `l'
	}
	ret local names `names'
	ret scalar shift = `shift'
	ret scalar scale = `scale'
	ret local  expxest `expxest'
	global S_1 `names'				/* double save */
	global S_2 `shift'				/* double save */
	global S_3 `scale'				/* double save */
	global S_4 `expxest'				/* double save */
	if "`adjust'"!="" {
* Save adjustments
		local j 1
		while `j'<=`np' {
			return scalar adj`j'=`adj`j''
			local j=`j'+1
		}
	}
end
