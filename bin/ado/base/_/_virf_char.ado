*! version 1.0.8  21feb2019
program define _virf_char
	version 8.0

	syntax [ , unique(string) * ]
	if `"`unique'"' != "" {
		UNIQUE_CHARS `0'
		exit
	}

	syntax [ , Describe * ]
	if `"`describe'"' != "" {
		DESC_CHARS `0'
		RESULTS
		exit
	}

	syntax [ , NEWDescribe * ]
	if `"`newdescribe'"' != "" {
		NEWDESC_CHARS `0'
		RESULTS
		exit
	}

	syntax [ , remove(string) * ]
	if `"`remove'"' != "" {
		REMOVE_CHARS `0'
		RESULTS
		exit
	}

	syntax [ , rename * ]
	if `"`rename'"' != "" {
		RENAME_CHARS `0'
		RESULTS
		exit
	}

	syntax [ , clist(string) * ]
	if "`clist'" != "" {
		CHARLIST charlist
		c_local `clist' "`charlist'" 
		exit
	}

	syntax [ , change(string) * ]
	if "`change'" != "" {
		local 0 `", `change'"'
		syntax , irfname(string) 			/*
			*/ stderr(string)			/*
			*/ reps(string)
		char _dta[`irfname'_stderror] "`stderr'"
		char _dta[`irfname'_reps] "`reps'"
		exit

	}
	
	syntax [ , get(string) locals(string) chars(string) * ]
	if `"`get'"' != "" {
		local irfname "`get'"
		local charlist "`chars'"
		local n1 : word count `locals'
		local n2 : word count `chars'
		if `n1' != `n2' {
			di as error "cannot assign irf characteristics to"/*
				*/ " specified local list"
			exit 198
		}	
		local i 1
		foreach lcl of local charlist {
			local tmp : char _dta[`irfname'_`lcl']
			local local2 : word `i' of `locals'
			c_local `local2' "`tmp'"
			local i = `i' + 1
		}	
		exit
	}

	syntax [ , put(string) * ]
	if `"`put'"' != "" {
		local 0 `", `put'"'
		syntax , irfname(string) 			/*
			*/ vers(string) 			/*
			*/ order(string)			/*
			*/ step(numlist integer >=1 max=1) 	/*
			*/ model(string)			/*
			*/ [					/*
			*/ exog(string)				/*
			*/ constant(string)			/*
			*/ varcns(string)			/*
			*/ stderr(string)			/*
			*/ reps(string)				/*
			*/ tmin(string)				/*
			*/ tmax(string)				/*
			*/ tsfmt(string)			/*
			*/ timevar(string)			/*
			*/ lags(string)				/*
			*/ svarcns(string)			/*
vec			*/ rank(numlist integer >=1 max=1)	/*
vec			*/ trend(string)			/*
vec			*/ veccns(string)			/*
vec			*/ sind(string)				/*
exog			*/ exogvars(string)			/*
exog			*/ exlags(string)			/*
			*/ diff(string)				/*
			*/ ]
		
		local optal rank trend veccns sind exogvars exlags
		foreach type of local optal {
			if "``type''" == "" {
				local `type' "."
			}	
		}
		
		local tnames : char _dta[irfnames]	
		char _dta[irfnames] "`tnames' `irfname' "
		char _dta[`irfname'_version] "`vers'" 
		char _dta[`irfname'_order] `order'
		char _dta[`irfname'_step] `step'
		char _dta[`irfname'_model] "`model'"
		char _dta[`irfname'_exog] "`exog'"
		char _dta[`irfname'_constant] "`constant'"
		char _dta[`irfname'_varcns] "`varcns'"
		char _dta[`irfname'_stderror] "`stderr'"
		char _dta[`irfname'_reps] "`reps'"
		char _dta[`irfname'_tmin] "`tmin'"
		char _dta[`irfname'_tmax] "`tmax'"
		char _dta[`irfname'_tsfmt] "`tsfmt'"
		char _dta[`irfname'_timevar] "`timevar'"
		char _dta[`irfname'_lags] "`lags'"
		char _dta[`irfname'_svarcns] "`svarcns'"
		char _dta[`irfname'_rank] "`rank'"
		char _dta[`irfname'_trend] "`trend'"
		char _dta[`irfname'_veccns] "`veccns'"
		char _dta[`irfname'_sind] "`sind'"
		char _dta[`irfname'_exogvars] "`exogvars'"
		char _dta[`irfname'_exlags] "`exlags'"
		char _dta[`irfname'_d] "`diff'"
		exit
	}
	
	/* should never get here */
	capture syntax [ , Describe ]
	if _rc {
		di as err "internal error in varirf"
		exit 198
	}
	RESULTS
end

program define RESULTS, rclass
	local irfnames : char _dta[irfnames]
	return local irfnames `irfnames'
	CHARLIST
	return add
end

program define CHARLIST, rclass
	local charlist  model order exog constant lags exogvars exlags tmin tmax 
	local charlist `charlist' timevar tsfmt varcns svarcns
	local charlist `charlist' step stderror reps version 
	local charlist `charlist' rank trend veccns
	local charlist `charlist' sind
	return local charlist `charlist'
	if `"`1'"' != "" {
		confirm name `1'
		c_local `1' `return(charlist)'
	}
end

program define UNIQUE_CHARS, rclass
	syntax , unique(string)

	preserve
	_virf_ext `unique'
	local filelist `"`r(filelist)'"'
	
	foreach file of local filelist {
		_virf_use `"`file'"' , one
		local names : char _dta[irfnames]
		local namelist `namelist' `names'
	}
	local junk `namelist'
	foreach name of local namelist {
		local junk :				/*
		*/ subinstr local junk "`name'" "" ,	/*
		*/ all word count(local count)
		if `count' > 1 {
			di as err /*
*/ "`name' is used in more that one of the files to combine"
			exit 198
		}
	}
	return local irfnames `namelist'
	CHARLIST
	return add
end

program define DESC_CHARS
	syntax , Describe [ irf(string) ]
	di
	CHARLIST charlist
	foreach name of local irf {
		di as txt "`name':"
		foreach char of local charlist {
			local charval : char _dta[`name'_`char']
			local len = length("`char'")
			local offset = cond(15-`len' > 0, 15-`len', 0)
			di as txt "{p `offset' 21 0}"	/*
			*/ "`char'"	/*
			*/ ":" _s(1)	/*
			*/ as res "`charval'{p_end}"	/*
			*/
		}
	}
end

program define REMOVE_CHARS
	syntax , remove(string)

	local irfnames : char _dta[irfnames]
	CHARLIST charlist
	foreach name of local remove {
		local irfnames :			/*
		*/ subinstr local irfnames "`name'" ""	/*
		*/ , word
		foreach char of local charlist {
			char _dta[`name'_`char']
		}
	}
	char _dta[irfnames] `irfnames'
end

program define RENAME_CHARS
	syntax , rename irf(string)

	gettoken oldname newname : irf
	local newname `newname'
	local oldname `oldname'
	local irfnames : char _dta[irfnames]
	local irfnames :					/*
	*/ subinstr local irfnames "`oldname'" "`newname'"	/*
	*/ , word count(local count)
	if `count' != 1 { /* should never be true */
		di as err "`oldname' not present in vrf file"
		exit 198
	}

/* must also replace irfname variable */
	replace irfname = "`newname'" if irfname == "`oldname'"

	CHARLIST charlist
	foreach char of local charlist {
		local charval : char _dta[`oldname'_`char']
		char _dta[`newname'_`char'] `charval'
		char _dta[`oldname'_`char']
	}
	char _dta[irfnames] `irfnames'
	di as txt "`oldname' renamed to `newname'"
end


program define NEWDESC_CHARS
	syntax , NEWDescribe [ irf(string) ]

	tempname est_char irf_char

	foreach name of local irf {
		di as txt _n "{title:irf results for `name'}"

		local model : char _dta[`name'_model]

		GET_MODEL_CHAR , model(`model') est(`est_char') irf(`irf_char')	
		
		NICE_DISPLAY , name(`name') est(``est_char'') irf(``irf_char'') 

	}
end

program define NICE_DISPLAY

	syntax , name(string)		/// 	
		est(string)		///
		irf(string)		

	tempname tsfmt_tmp	

	if "`est'" != "" {
		di as txt _n "{col 3}Estimation specification"
		foreach ctype of local est {
			
			if "`ctype'" == "sample" {
				local tsfmt : char _dta[`name'_tsfmt]
				GET_TSFMT , ret_mac(`tsfmt_tmp')	///
					tsfmt(`tsfmt')
				local tsmin : char _dta[`name'_tmin]
				local tsmax : char _dta[`name'_tmax]

				local tsmin : display `tsfmt' `tsmin'
				local tsmax : display `tsfmt' `tsmax'

				local ctype_el "``tsfmt_tmp'' data from `tsmin' to `tsmax'"
			}
			else if "`ctype'" == "endog" {
				local ctype_el : char _dta[`name'_order]
			}
			else {
				local ctype_el : char _dta[`name'_`ctype']
			}	

			
			if "`ctype_el'" == "." 	///
				| "`ctype'" == "" local ctype_el none
			local ind_ctype = cond(12-length("`ctype'")>=0,	///
					12-length("`ctype'"), 0)
			di "{p `ind_ctype' 15}"
			di as txt "`ctype':"
			di as res `"`ctype_el'"'
			di "{p_end}"
	

		}

	}

	if "`irf'" != "" {
		di as txt _n "{col 3}IRF specification"
		foreach ctype of local irf {
			
			if "`ctype'" == "stderr" {
				local ctype_el : char _dta[`name'_stderror]
				local ctype "std error"
			}
			else {
				local ctype_el : char _dta[`name'_`ctype']
			}	

			if "`ctype_el'" == "." 	///
				| "`ctype'" == "" local ctype_el none
			

			local ind_ctype = cond(12-length("`ctype'")>=0,	///
					12-length("`ctype'"), 0)
			di "{p `ind_ctype' 15}"
			di as txt "`ctype':"
			di as res `"`ctype_el'"'
			di "{p_end}"
	

		}

	}



end

//   GET_MODEL_CHAR returns model characteristics for each model.
//  	Model characteristics are defined with the (conceptual) name that they 
//        will display.  NICE_DISPLAY must remap some of these names from 
//        the set of conceptual names -> set of names of _dta[irfname_?]
//	  characteristics.  Also note that a single conceptual name, e.g.,
//	  sample, can correspond to multiple characteristic names.
//        Also note: irf specification stderr has ugly conceptual name because
//	nice name "std error" contains a space (NICE_DISPLAY) remaps from ugly
//	to nice name.

program define GET_MODEL_CHAR
	syntax , model(string) est(name) irf(name)

	local tmp : subinstr local model "svar" "svar", count( local issvar)

	if "`model'" == "vec" {
		local est_char model endog sample lags rank trend veccns sind

		local irf_char step stderr

	}
	else if "`model'" == "var" {
		local est_char model endog sample lags constant exog exogvars exlags varcns

		local irf_char step order stderr reps


	}
	else if `issvar' == 1 {
		local est_char model endog sample lags constant exog varcns
		local est_char `est_char' svarcns

		local irf_char step stderr reps

	}
	else if "`model'" == "dsge" {
		local est_char model endog  sample
		local irf_char step stderr
	}
	else if "`model'" == "dsgenl" {
		local est_char model endog  sample
		local irf_char step stderr
	}
	else if ("`model'" == "arfima") {
		local est_char model endog  sample
		local irf_char step stderr
	}
	else if ("`model'" == "arima") {
		local est_char model endog  sample
		local irf_char step stderr
	}
	else {

// if here model is unknown

		di as err "cannot get characteristics for model `model'"
		exit 498
	}	

	c_local `est' `est_char'
	c_local `irf' `irf_char'

end

program define GET_TSFMT 

	syntax , ret_mac(name)  tsfmt(string)

	if "`tsfmt'" == "%td" {
		c_local `ret_mac' daily
	} 
	else if "`tsfmt'" == "%tw" {
		c_local `ret_mac' weekly
	} 
	else if "`tsfmt'" == "%tm" {
		c_local `ret_mac' monthly
	} 
	else if "`tsfmt'" == "%tq" {
		c_local `ret_mac' quarterly
	} 
	else if "`tsfmt'" == "%th" {
		c_local `ret_mac' halfyearly
	} 
	else if "`tsfmt'" == "%ty" {
		c_local `ret_mac' yearly
	} 
	else  {
		c_local `ret_mac' 
	}	

end

exit

Usage:

  _virf_char , unique(<vrffilelist>)
  _virf_char , Describe [ irf(<irfnamelist>) ]
  _virf_char , remove(<irfnamelist>)
  _virf_char , rename irf(<old_irfname> <new_irfname>)
  _virf_char , irf(<irfname>) order(string) steps(#)
  _virf_char , get(irfname) locals(local_1 local_2 ... ) 
  		chars(char_1 char_2 ... )
  _virf_char , clist(<lmacname>)

unique(<vrffilelist>) verifies that the _dta[irfnames] in <vrffilelist>
are unique.

describe displays the vrf characteristics of each irfname of the vrf file
assumed to be in memory.

remove(<irfnamelist>) removed each irfname and associated characteristics
listed in <irfnamelist> from the vrf file assumed to be in memory.

rename(<new_irfname> = <old_irfname>) renames <old_irfname> to
<new_irfname> along with each associated characteristic in the vrf file
assumed to be in memory.

get puts the characteristics for <irfname> into the locals local_1,
	local_2, local_3.  Upon exit
	local_1 is a local that contains _dta[`irfname'_`char_1']
	local_2 is a local that contains _dta[`irfname'_`char_2']
	...
	
clist(<lmacname>) puts the current list irf characteristics into the local
	specified in <lmacname>
<end>
