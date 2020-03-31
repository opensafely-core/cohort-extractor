*! version 2.0.6  16sep2019
program datasignature, rclass
	version 10

	if _caller()<10 {
		_datasignature `0'
		return add
		exit
	}

	gettoken cmd 0 : 0, parse(" ,")
	local l = strlen("`cmd'")

	if ("`cmd'"=="") {
		_datasignature
	}
	else if ("`cmd'"=="clear") { 
		datasig_clear `0'
	}
	else if ("`cmd'"==bsubstr("confirm", 1, max(4,`l'))) { 
		datasig_confirm `0'
	}
	else if ("`cmd'"==bsubstr("report", 1, max(3,`l'))) { 
		datasig_report `0'
	}
	else if ("`cmd'"=="set") {
		datasig_set `0'
	}
	else {
		di as err "invalid datasignature subcommand"
		exit 198
	}
	ret add
end



program datasig_set, rclass
	/* ------------------------------------------------------------ */
							/* parse	*/
	syntax [, SAVING(string asis) RESET FORCEDATE(string)]
	syntax [varlist] [, SAVING(string asis) RESET FORCEDATE(string)]
			// sic, two syntax commands
	parse_saving using replace : `"`saving'"'

	/* ------------------------------------------------------------ */
					/* set whether set or reset	*/
	local set "set"
	if ("`_dta[datasignature_si]'"!="") {
		if ("`reset'"=="") {
			di as err "{p 0 2 2}"
			di as err "data signature already set -- "
			di as err "specify option {bf:reset}"
			di as err "{p_end}"
			exit 110
		}
		local set "reset"
	}
	/* ------------------------------------------------------------ */
					/* store _datasignature		*/
	qui _datasignature 
	char _dta[datasignature_si] "`r(datasignature)'"
	mata: ado_intolchar("_dta", "datasignature_vl", "varlist")
	if ("`forcedate'"=="") {
		local tod : display %21x ///
		    clock("`c(current_date)' `c(current_time)'", "DMYhms")
		char _dta[datasignature_dt] "`tod'"
	}
	else {
		char _dta[datasignature_dt] "`forcedate'"
	}
	/* ------------------------------------------------------------ */
							/* display	*/
	di as res "  `r(datasignature)'       " ///
		  as txt "(data signature `set')"
	ret add
	/* ------------------------------------------------------------ */
						/* save in file		*/
	if (`"`using'"'!="") {
		if (`replace') {
			capture erase `"`using'"'
		}
		local sig     "`_dta[datasignature_si]'"
		local date    "`_dta[datasignature_dt]'"
		mata: wrdatasig(`"`using'"', "date", "sig", "varlist")
		di as txt `"  (file `using' saved)"'
	}
	/* ------------------------------------------------------------ */
end

program datasig_clear
	syntax 
	if ("`_dta[datasignature_si]'" != "") { 
		char _dta[datasignature_dt]
		char _dta[datasignature_si]
		mata: st_lchar("_dta", "datasignature_vl", "")
		di as txt "  (data signature cleared)"
	}
	else {
		mata: st_lchar("_dta", "datasignature_vl", "")
		char _dta[datasignature_dt]
		di as txt "  (no data signature was previously set)"
	}
end

program must_be_signed
	if ("`_dta[datasignature_si]'"=="") {
		di as err "  no data signature was previously set"
		exit 459
	}
end

program data_have_changed_error
	args dt
	di as err "  data have changed since " %tcDDmonCCYY_HH:MM `dt'
	exit 9
end

program datasig_confirm, rclass
	syntax [using/] [, STRICT]

	if (`"`using'"' != "") { 
		mata: rddatasig(`"`using'"', "dt", "sig", "vars")
	}
	else {
		must_be_signed
		local dt   "`_dta[datasignature_dt]'"
		local sig  "`_dta[datasignature_si]'"
		mata: ado_fromlchar("vars", "_dta", "datasignature_vl")
	}

	local k : list sizeof vars
	quietly describe, short
	local added = r(k) - `k'
	ret scalar k_added = `added'

	/* ------------------------------------------------------------ */
					/* following is for speed 	*/
	if (`added'==0) { 
		quietly _datasignature
		if (r(datasignature)=="`sig'") {
			ret add
			unchanged_message `dt'
			exit
		}
	}
	/* ------------------------------------------------------------ */


	capture confirm variable `vars'
	if _rc { 
		data_have_changed_error `dt'
	}

	quietly _datasignature `vars'
	ret add
	if ("`sig'" == "`return(datasignature)'") {
		if (`added'==0) {
			if ("`strict'"!="") {
				ordersame `vars'
				if (r(same)) {
					unchanged_message `dt'
				}
				else {
					unchanged_order_message err `dt'
					exit 9
				}
			}
			else {
				ordersame `vars'
				if (r(same)) {
					unchanged_message `dt'
				}
				else {
					unchanged_order_message txt `dt'
				}
			}
		}
		else {
			if ("`strict'"=="") {
				local rc 0
				local style "as txt"
			}
			else {
				local rc 9
				local style "as err"
			}
			di `style' "{p 2 3 2}"
			di `style' "(data unchanged since " ///
					%tcDDmonCCYY_HH:MM `dt' ///
					", except `added' " _c
			if (`added'==1) {
				di `style' "variable has" _c
			}
			else	di `style' "variables have" _c
			di " been added)"
			di "{p_end}"
			exit `rc'
		}
	}
	else {
		data_have_changed_error `dt'
	}
end


program datasig_report, rclass
	syntax [using/]

	if (`"`using'"' != "") {
		local dup : subinstr local using "/" " ", all
		local dup : subinstr local dup   "\" " ", all
		local n   : word count `dup'
		local last: word `n' of `dup'
		if index("`last'", ".") == 0 {
			local using `"`using'.dtasig"'
		}

		confirm file `"`using'"'
	}
	else {
		must_be_signed
	}

	datasig_report_set `"`using'"'
	ret add

	local note = 1

	local dayname : di %tcDayname return(datetime)
	local dayname = strtrim("`dayname'")

	di as txt "{p 2 3 2}"
	if (`"`using'"'!="") {
		di as txt `"(file `using' created on `dayname'"'
		di as txt %tcDDmonCCYY_HH:MM return(datetime) ")"
	}
	else {
		di as txt `"(data signature set on `dayname'"'
		di as txt %tcDDmonCCYY_HH:MM return(datetime) ")"
	}
	di as txt "{p_end}"


	/* ------------------------------------------------------------ */
	di 
	di as txt "  {title:Data signature summary}"

	local cur  "`return(curdatasignature)'"
	local orig "`return(origdatasignature)'"
	local full "`return(fulldatasignature)'"
	di 
	if (`"`using'"'=="") {
		di as txt _col(4) "1. previous data signature" /// 
		  	_col(35) as res "`orig'"
	}
	else {
		di as txt _col(4) "1. data signature from file" /// 
		  	_col(35) as res "`orig'"
	}

	di as txt _col(4) "2. same data signature today" _col(35) _c
	if ("`cur'"=="") { 
		di as txt "(cannot be calculated)"
	}
	else {
		if "`cur'" == "`return(origdatasignature)'" {
			di as txt "(same as 1)"
		}
		else 	di as res "`return(curdatasignature)'"
	}

	di as txt _col(4) "3. full data signature today" _col(35) _c
	if ("`return(fulldatasignature)'" == "`return(origdatasignature)'") {
		di as txt "(same as 1)"
	}
	else if "`return(fulldatasignature)'" == "`return(curdatasignature)'" {
		di as txt "(same as 2)"
	}
	else 	di as res "`return(fulldatasignature)'"
	/* ------------------------------------------------------------ */

	di 
	if (`"`using'"'=="") {
		di as txt ///
"  {title:Comparison of current data with previously set data signature}"
	}
	else {
		di as txt ///
"  {title:Comparison of current data with data signature from file}"
	}


	di
	di as txt _col(7) "variables" _col(34) "number" _col(42) "notes"
	di as txt _col(7) "{hline 60}"

	/* ------------------------------------------------------ */
	di as txt _col(7) "original # of variables" ///
		  _col(31) as res %9.0gc return(k_original) ///
		  _col(42) _c
	if (return(changed)==0) { 
		di as txt "(values unchanged)" _c
	}
	else if (return(changed)==1) { 
		di as txt "(values have changed)" _c
	}
	else 	di as txt "(values may have changed)" _c

	if (return(reordered)==1) {
		local ornote `note++'
		di as txt "(note `ornote')" _c
	}
	di
	/* ------------------------------------------------------ */

	/* ------------------------------------------------------ */
	di as txt _col(7) "added variables" ///
		  _col(31) as res %9.0gc return(k_added) _c
	if (return(k_added)) {
		local adnote `note++'
		di as txt "  (`adnote')" _c
	}
	di
	/* ------------------------------------------------------ */


	/* ------------------------------------------------------ */
	di as txt _col(7) "dropped variables" ///
		  _col(31) as res %9.0gc return(k_dropped) _c
	if (return(k_dropped)) {
		local drnote `note++'
		di as txt "  (`drnote')" _c
	}
	di
	/* ------------------------------------------------------ */

	di as txt _col(7) "{hline 60}"

	/* ------------------------------------------------------ */
	di as txt _col(7) "resulting # of variables" ///
		  _col(31) as res %9.0gc ///
		          (return(k_original)+return(k_added)-return(k_dropped))

	di
	/* ------------------------------------------------------ */

	if (return(reordered)==1) { 
		di as txt _col(7) "(`ornote')  variables reordered"
		di
	}

	if (return(k_added)) {
		di as txt "{p 6 12 2}"
		di as txt "(`adnote'){bind:  }"
		if (return(k_added)==1) { 
			di as txt ///
			"Added variable is {res:`return(varsadded)'}"
		}
		else {
			di as txt "Added variables are"
			di as res "`return(varsadded)'"
		}
		di
	}

	if (return(k_dropped)) {
		di as txt "{p 6 12 2}"
		di as txt "(`drnote'){bind:  }"

		if (return(k_dropped)==1) { 
			di as txt ///
			"Dropped variable is {res:`return(varsdropped)'}"
		}
		else {
			di as txt "Dropped variables are"
			di as res "`return(varsdropped)'"
		}
		di
	}
end

program datasig_report_set, rclass
	args using

	if (`"`using'"' == "") {
		return local origdatasignature "`_dta[datasignature_si]'"
		return scalar datetime = `_dta[datasignature_dt]'
		mata: ado_fromlchar("vars", "_dta", "datasignature_vl")
	}
	else {
		mata: rddatasig(`"`using'"', "datestr", "sigstr", "vars")
		return local origdatasignature "`sigstr'"
		return scalar datetime = `datestr'
	}

	local original : list sizeof vars
	ret scalar k_original = `original'

	ret scalar reordered = .

	capture confirm variable `vars'
	if _rc { 
		variables_dropped_added `vars'
		ret add
		return scalar changed = .
		quietly _datasignature
		ret local fulldatasignature "`r(datasignature)'"
		exit
	}

	/* ------------------------------------------------------------ */
	return scalar k_dropped = 0
	return local varsdropped ""
	local k : list sizeof vars
	qui describe, short
	ret scalar k_added = r(k) - `k'
	if (return(k_added)==0) {
		return local varsadded ""
	}
	else {
		local 0 _all
		syntax varlist 
		return local varsadded : list varlist - vars
		local varlist
	}
	local k
	/* ------------------------------------------------------------ */

	if (return(k_added)==0) { 
		ordersame `vars'
		ret scalar reordered = !r(same)
	}
	quietly _datasignature `vars'
	ret local curdatasignature "`r(datasignature)'"
	ret scalar changed = ("`r(datasignature)'" !=	///
				"`return(origdatasignature)'")
	if (return(k_added)==0) { 
		ret local fulldatasignature "`return(curdatasignature)'"
	}
	else {
		quietly _datasignature 
		ret local fulldatasignature "`r(datasignature)'"
	}
end


program variables_dropped_added, rclass
	local orig `"`0'"'
	local 0 _all
	syntax varlist
	ret local varsdropped : list orig - varlist
	ret local varsadded   : list varlist - orig
	local dropped : word count `return(varsdropped)'
	local added   : word count `return(varsadded)'
	ret scalar k_dropped  = `dropped'
	ret scalar k_added    = `added'
end

program parse_saving
	args fnmac repmac colon input

	if (`"`input'"'=="") { 
		exit
	}

	gettoken fn input : input, parse(" ,")
	gettoken comma input : input, parse(" ,")
	local replace 0
	if (`"`comma'"'==",") {
		gettoken repl input : input, parse(" ,")
		if (`"`repl'"'=="replace") {
			local replace 1
			gettoken comma input : input, parse(" ,")
		}
		else {
			local comma `"`repl'"'
		}
	}
	if (`"`comma'"'!="") {
		di as err "saving():  syntax error"
		exit 198
	}

	local dup : subinstr local fn "/" " ", all
	local dup : subinstr local dup   "\" " ", all
	local n   : word count `dup'
	local last: word `n' of `dup'
	if index("`last'", ".") == 0 {
		local fn `"`fn'.dtasig"'
	}

	c_local  `fnmac' `"`fn'"'
	c_local `repmac' `replace'

	if (`replace'==0) { 
		confirm new file `"`fn'"'
	}
end


program unchanged_message
	args dt
	di as txt "{p 2 3 2}"
	di as txt "(data unchanged since " %tcDDmonCCYY_HH:MM `dt' ")"
	di as txt "{p_end}"
end

program unchanged_order_message
	args as dt
	di as `as' "{p 2 3 2}"
	di as `as' "(data unchanged since " ///
		%tcDDmonCCYY_HH:MM `dt' ///
		", but order of variables has changed)"
	di as `as' "{p_end}"
end


program ordersame, rclass
	local vars `"`0'"'
	local 0 _all
	syntax varlist 
	mata: ordersame("res", "vars", "varlist")
	return scalar same = `res'
end




version 10

mata:
void ordersame(string scalar res, string scalar vars, string scalar varlist)
{
	real scalar r

	r = (st_local(vars)==st_local(varlist))
	st_local(res, r ? "1" : "0")
}

void wrdatasig(string scalar fn, 
               string scalar datename, 
	       string scalar signame, 
	       string scalar varlistname)
{
	real scalar	fh

	fh = st_fopen(fn, "", "w")
	st_fwritesignature(fh, "datasignature", 1)

	fputmatrix(fh, st_local(datename))
	fputmatrix(fh, st_local(signame))
	fputmatrix(fh, st_local(varlistname))
	fclose(fh)
}

	
void rddatasig(string scalar fn, 
               string scalar datename, 
	       string scalar signame, 
	       string scalar varlistname)
{
	real scalar	fh
	real scalar	f_ver

	fh = st_fopen(fn, ".dtasig", "r")
	pragma unset f_ver
	st_freadsignature(fh, "datasignature", 1, f_ver)

	st_local(datename, fgetmatrix(fh))
	st_local(signame,  fgetmatrix(fh))
	st_local(varlistname, fgetmatrix(fh))
	fclose(fh)
}

end
