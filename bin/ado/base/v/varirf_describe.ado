*! version 1.0.8  05nov2015
program define varirf_describe, rclass
	version 8
	syntax	[anything(id="irf name list" name=irflist)]	/*
	*/ 	[,		/*
	*/	set(string)	/*
	*/	using(string)	/*
	*/  	Detail		/*
	*/	Variables	/*
	*/	IRFWORDING	/*
	*/	noDATE		/*  undocumented
	*/	*		/*
	*/	]		/*
	*/

/* clear quotes and spaces */

	local irflist `irflist'

	if `"`set'"' != "" & `"`using'"' != ""  {
		di as err "set() and using() cannot both be specified"
		exit 198
	}

	if `"`set'"' != "" {
		irf set `set'
	}	
	local irffile `"$S_vrffile"'

	if `"`using'"' != "" {
		_virf_fck `"`using'"'
		local irffile `"`r(fname)'"'
	}
	
	if `"`irffile'"' == "" {
		di as error "no irf file active"
		exit 111
	}

	local linesize = c(linesize)

	preserve
	use `"`irffile'"' , clear

	if "`variables'" != "" {
		local qui
	}
	else {
		local qui qui
	}
/* irflist specified implies detail */

	if `"`irflist'"' == "" {
		local irflist : char _dta[irfnames]
	}
	else {
		
		local baselist : char _dta[irfnames]
		local irflist2 : list baselist & irflist
		if "`irflist2'"  == "" {
			di as err "{p 0 4 0}`irflist' not found "	/*
				*/ "in $S_vrffile{p_end}"
			exit 498
		}	
		local detail detail
	}


	local nirf : word count `irflist'
	if `nirf' == 0 {
		di as txt "no irfnames in  $S_vrffile"
		exit
	}

	if "`irfwording'" != "" & "`detail'" != "" {
		di as err "{cmd:irfwording} cannot be specified with "	/*
			*/ "{cmd:detail}"
		exit 198
	}	
	
	if "`date'" == "" {
		local datemod = c(filedate)
		local len_dm  = length("`datemod'")
		local col_dm  = cond(`linesize' - `len_dm' >= 31, ///
			`linesize' - `len_dm' , 31)
		local dated " (dated `datemod')"
	}
	
	if "`detail'" == "" {
		if "`irfwording'" != "" {
			di "{p 0 5 0}{txt}IRF result sets: "	///
				"{res}`irflist'{p_end}" 
			di 
			di as txt "{col 12}irf {c |} {col 18}model"	///
				"{col 27}impulse or response variables"
		}
		else {
			di as txt "Contains irf results from `irffile'`dated'"
			di 
			di as txt "{col 8}irfname {c |} {col 18}model"	///
				"{col 27}endogenous variables and order (*)"
		}	


		local len_aftert = `linesize' - 16
		di as txt "{hline 15}{c +}{hline `len_aftert'}"
		foreach irfnb of local irflist {
local order : char _dta[`irfnb'_order]
local model : char _dta[`irfnb'_model]
if "`model'" == "short-run svar" {
	local model sr svar
}
if "`model'" == "long-run svar" {
	local model lr svar
}
local irfnb = abbrev("`irfnb'",14)
local len = length("`irfnb'")
local len3 = 16 - `len'
local len4 = 14 - `len'

local model = abbrev("`model'",7)
local len2 = length("`model'")
local len2 = 9 - `len2'
di "{res}{p 0 27 0}{space `len4'}`irfnb' " as txt "{c |}"	///
	as res" `model'{space `len2'}`order'{p_end}" 
		}
		di as txt "{hline 15}{c BT}{hline `len_aftert'}"
		di as txt "{col 3}(*) order is relevant only when "	///
			"model is var"
	}
	else {
		/* display the -irf- characteristics */
		_virf_char , newdescribe irf(`irflist')
	}

	local irfnames : char _dta[irfnames]
	local _version : char _dta[_version]

	/* describe the -irf- dataset */
	`qui' describe, `options' `date'
	ret add
	
	_virf_char, clist(charlist)
	foreach name of local irfnames {
		foreach char of local charlist {
			local tmp : char _dta[`name'_`char']
			ret local `name'_`char' "`tmp'"
		}
	}
	restore
	ret local irfnames "`irfnames'"
	ret local _version "`_version'"
end

exit

