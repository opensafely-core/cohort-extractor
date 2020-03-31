*! version 1.6.8  09sep2019
program codebook, rclass
	version 8.1, born(09sep2003) missing

	// codebook stores information in globals T_cb_*
	// necessary to make report of problems
	nobreak {
		macro drop T_cb_*

		capture noisily break {
			Codebook_u `0'
		}
		local rc = _rc
		if `rc' == 0 {
			ReturnGlobals
			return add
		}
		macro drop T_cb_*
	}
	exit `rc'
end


program Codebook_u
	syntax [varlist] [if] [in] [, ///
		All Tabulate(integer 9) Mv Notes ///
		Header Problems	Detail ///
		LANGuages LANGuages2(str) Compact dots ]

	if "`compact'" != "" {
		/* Reset tabulate(9) to undefined */
		if `tabulate' == 9 {
			local tabulate ""
		}

		/* Check that no other options were specified with compact */
		local optmacs "all tabulate mv notes header problems"
		local optmacs "`optmacs' detail languages languages2"
		local optlist "all tabulate() mv notes header problems"
		local optlist "`optlist' detail languages languages()"

		tokenize `optmacs'
		foreach opt of local optlist {
			if "``1''" != "" {
			    di as err "compact and `opt' are mutually exclusive"
			    exit 198
			}
			macro shift
		}
		SummCompact `varlist' `if' `in', `dots'
		exit
	}
	else {
		if "`dots'" != "" {
			di as err "dots allowed only with compact"
			exit 198
		}
	}

	if "`problems'" != "" & "`detail'" == "" {
		local quiet quiet
		local notes
	}

	if "`all'" != "" {
		local header header
		local notes  notes
	}

	ParseLanguage `"`languages'"' `"`languages2'"'
	local lns `s(lns)'
	if "`lns'" != "" {
		local lnopt languages(`lns')
	}

	if "`header'" != "" {
		Header, `lnopt' `notes'
	}

	// program-to-be-run-sortpreserve
	Codebook_vars `varlist' `if' `in' , ///
	   `mv' `quiet' `notes' tabulate(`tabulate') `lnopt'

	if "`problems'" != "" {
		if ("`quiet'" == "") display
		ReportProblems
	}
end


program Codebook_vars, sortpreserve

	syntax [varlist] [if] [in] [, ///
	   Tabulate(integer 9) Mv Notes quiet ///
	   languages(str) ]

	marksample touse, novarlist
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}

	// The DoType commands write reports on a single variable
	// They also set the globals with varlist with potential problems

	if "`languages'" != "" {
		local lnopt languages(`languages')
	}
	foreach v of loc varlist {
		if "`quiet'" == "" {
			VarHeader `v' , `lnopt'
		}

		capture confirm string variable `v'
		if _rc {
			local fmt : format `v'
			local ch = usubstr(`"`fmt'"', 2, 1)
			local DoType = cond(inlist(`"`ch'"',"d","t"), "DoDate", "DoNum")

		}
		else {
			local DoType DoStr
		}
		`quiet' `DoType' `v' `touse' "`tabulate'" "`mv'" "`languages'"

		if "`notes'" != "" {
			note `v'
		}
	}

  	global T_cb_labelnotfound : list uniq global T_cb_labelnotfound
  	global T_cb_notlabeled    : list uniq global T_cb_notlabeled
end


program DoNum
	args v touse tabulate mv languages

	dis _col(19) as txt "type:  numeric (" as res `"`:type `v''"' as txt ")"

	Labeled `v' `touse' "`languages'"
	local vlabeled = `r(vlabeled)'  // 0/1 : value labeled attached
	local vlabdef  = `r(vlabdef)'   // 0/1 : value labeled attached & defined

	dis
	Units `v' `touse'
	#del ;
	dis _col(18) as txt "range:  ["
	             as res r(min)
	             as txt ","
	             as res r(max)
	             as txt "]"
	    _col(55) as txt "units:  "
	             as res r(units) ;
	#del cr

	CntUniq `v' `touse'
	local ntouse   = r(ntouse)     // number of obs
	local miss_sys = r(miss_sys)   // mv code   .
	local miss_ext = r(miss_ext)   // emv code  .a/.z
	local uniq_nmv = r(uniq_nmv)
	local uniq_mv  = r(uniq_mv)
	if `uniq_nmv' < 2 {
		global T_cb_cons $T_cb_cons `v'
	}
	ShowUniq num `uniq_nmv' `uniq_mv' `miss_sys' `miss_ext' `ntouse'
	dis

	if `uniq_nmv' <= `tabulate' {
		if `vlabdef' {
			FullTabValueLabeled `v' `touse' "`languages'"
		}
		else {
			FullTab n `v' `touse' ""
		}
	}
	else {
		if `vlabdef' {
			NumExamples `v' `touse' "`languages'"
		}
		else {
			qui summ `v' if `touse' , detail

			dis as txt _col(19) "mean:"            ///
			    as res _col(26) %8.0g r(mean) _n   ///
			    as txt _col(15) "std. dev:"        ///
			    as res _col(26) %8.0g sqrt(r(Var)) _n

			dis as txt _col(12) "percentiles:" ///
			           _col(32) "10%" ///
			           _col(42) "25%" ///
			           _col(52) "50%" ///
			           _col(62) "75%" ///
			           _col(72) "90%"

			dis as res _col(27) %8.0g r(p10) ///
			           _col(37) %8.0g r(p25) ///
			           _col(47) %8.0g r(p50) ///
			           _col(57) %8.0g r(p75) ///
			           _col(67) %8.0g r(p90)
		}
	}

	if `"`mv'"' != "" {
		CrcMiss `touse' `v' _all
	}
end


program DoDate
	args v touse tabulate mv languages

	local type : type `v'
	local fmt : format `v'
	local ch1 = bsubstr(`"`fmt'"',2,1)
	local ch2 = bsubstr(`"`fmt'"',3,1)
	if `"`ch1'"' == "d" {
		local ch1 "t"
		local ch2 "d"
	}
	if `"`ch2'"' == "d" {
		local desc "daily"
		local udesc "days"
	}
	else if `"`ch2'"' == "w" {
		local desc "weekly"
		local udesc "weeks"
	}
	else if `"`ch2'"' == "m" {
		local desc "monthly"
		local udesc "months"
	}
	else if `"`ch2'"' == "q" {
		local desc "quarterly"
		local udesc "quarters"
	}
	else if `"`ch2'"' == "h" {
		local desc "halfyearly"
		local udesc "half years"
	}
	else if `"`ch2'"' == "y" {
		local desc "yearly"
		local udesc "years"
	}
	else {
		DoNum `v' `touse' `tabulate' `mv' "`languages'"
		exit
	}
	local bfmt "%t`ch2'"

	dis _col(19) as txt "type:  " ///
	             as txt "numeric `desc' date (" as res `"`type'"' as txt ")"

	if "`languages'" != "" {
		quiet label language
		local inln " in `r(language)'"
	}

	Labeled `v' `touse' "`languages'"
	local vlabeled = `r(vlabeled)'  // 0/1 : value labeled attached
	local vlabdef  = `r(vlabdef)'   // 0/1 : value labeled attached & defined

	dis
	Units `v' `touse'
	#del ;
	dis _col(18) as txt "range:  ["
	             as res r(min)
	             as txt ","
	             as res r(max)
	             as txt "]"
            _col(55) as txt "units:  "
                     as res r(units) ;

	dis _col(8)  as txt "or equivalently:  ["
		     as res trim(string(r(min),"`bfmt'"))
		     as txt ","
		     as res trim(string(r(max),"`bfmt'"))
		     as txt "]"
	    _col(55) as txt "units:  "
	             as res "`udesc'" ;
	#del cr

	CntUniq `v' `touse'
	local ntouse   = r(ntouse)      // n of obs
	local miss_sys = r(miss_sys)    // mv code .
	local miss_ext = r(miss_ext)    // mv code .a/.z
	local uniq_nmv = r(uniq_nmv)    // unique nonmissing values
	local uniq_mv  = r(uniq_mv)     // unique missing values
	if `uniq_nmv' < 2 {
		global T_cb_cons $T_cb_cons `v'
	}
	ShowUniq date `uniq_nmv' `uniq_mv' `miss_sys' `miss_ext' `ntouse'

	dis
	if `uniq_nmv' <= `tabulate' {
		FullTab d `v' `touse' "`bfmt'"
	}
	else if !`vlabeled' {
		qui summ `v' if `touse', detail
		local x = trim(string(r(mean), "`bfmt'"))
		if "`x'" == "." {
			local xnote " (invalid `desc' date)"
		}
		else {
			local diff = r(mean) - int(r(mean))
			if `diff' != 0 {
				if "`ch2'" == "d" {
					loc diff = round(24*`diff',1)
					local xnote "hour"
				}
				else if "`ch2'" == "w" {
					local diff = trim(string( /*
					 */ 7*`diff', "%9.1f"))
					local xnote "day"
				}
				else if "`ch2'" == "m" {
					local diff = round(365.25/12*`diff',1)
					local xnote "day"
				}
				else if "`ch2'" == "q" {
					local diff = trim(string(/*
					 */ 3*`diff',"%9.1f"))
					local xnote "month"
				}
				else if "`ch2'" == "h" {
					local diff = trim(string(/*
					 */ 6*`diff',"%9.1f"))
					local xnote "month"
				}
				else {
					local diff = trim(string(/*
					 */ 6*`diff',"%9.1f"))
					local xnote "month"
				}
				if `diff' == int(`diff') {
					local diff = int(`diff') /* sic */
				}
/*
				if "`diff'" == "1.0" {
					local diff "1"
				}
*/
				if "`diff'" != "1" {
					local xnote "`xnote's"
				}
				local xnote " (+ `diff' `xnote')"
			}
		}

		dis as txt _col(19) "mean:"                         ///
		    as res _col(26) %8.0g r(mean)                   ///
		    as txt " = " as res "`x'" as txt "`xnote'" _n   ///
		    as txt _col(15) "std. dev:"                     ///
		    as res _col(26) %8.0g sqrt(r(Var)) _n

		dis as txt _col(12) "percentiles:" ///
		           _col(32) "10%"          ///
		           _col(42) "25%"          ///
		           _col(52) "50%"          ///
		           _col(62) "75%"          ///
		           _col(72) "90%"

		dis as res _col(27) %8.0g r(p10) ///
		           _col(37) %8.0g r(p25) ///
		           _col(47) %8.0g r(p50) ///
		           _col(57) %8.0g r(p75) ///
		           _col(67) %8.0g r(p90)

		dis as res _col(26) %9s trim(string(r(p10),"`bfmt'")) ///
		           _col(36) %9s trim(string(r(p25),"`bfmt'")) ///
		           _col(46) %9s trim(string(r(p50),"`bfmt'")) ///
		           _col(56) %9s trim(string(r(p75),"`bfmt'")) ///
		           _col(66) %9s trim(string(r(p90),"`bfmt'"))
	}
	else {
		NumExamples `v' `touse' "`languages'"
	}

	if `"`mv'"'!="" {
		CrcMiss `touse' `v' _all
	}

	capt assert `v'==round(`v') if `touse'
	if _rc {
		global T_cb_realdate $T_cb_realdate `v'
	}
end


program DoStr
	args v touse tabulate mv languages
	tempvar cnt

	local type : type `v'
	local tabvar `v'

	dis _col(19) as txt "type:  " ///
	             as txt "string (" as res `"`type'"' as txt ")" _c

	qui gen int `cnt' = length(`v') if `touse'
	qui summ `cnt' if `touse' , meanonly
	if "`type'" != "strL" & r(max) != real(bsubstr("`type'",4,.)) {
		dis as txt ", but longest is str" r(max)
		global T_cb_str_type  $T_cb_str_type `v'
	}
	else {
		dis
	}
	drop `cnt'

	dis
	CntUniq `v' `touse'
	local uniq_nmv `r(uniq_nmv)'
	if `uniq_nmv' < 2 {
		global T_cb_cons $T_cb_cons `v'
	}
	ShowUniq str `uniq_nmv' `r(uniq_mv)' `r(miss_sys)' `r(miss_ext)' `r(ntouse)'

	dis
	if `uniq_nmv' <= `tabulate' {
		FullTab s `v' `touse' ""
	}
	else {
		dis as txt _col(15) "examples:  " _c
		sort `touse' `v'
		qui count if `touse'==0
		local f  = r(N)
		local wd = _N-r(N)
		local i  = 0
		foreach inc in .2 .4 .6 .8 {
			local x = `v'[`f'+`inc'*`wd']
			if `i++' {
				dis _col(26) _c
			}
			Piece res  26 53 `""`x'""'
		}
	}

	if `"`mv'"' != "" {
		CrcMiss `touse' `v' _all
	}

// update problem globals

	qui count if `touse' & bsubstr(`v',1,1)==" "
	if r(N) {
		local haslead 1
		local ttl "leading"
		global T_cb_str_leading  $T_cb_str_leading `v'
	}
	else {
		local haslead 0
	}

	qui count if `touse' & bsubstr(`v',-1,1)==" "
	if r(N) {
		local hastrail 1
		local ttl "trailing"
		global T_cb_str_trailing  $T_cb_str_trailing `v'
	}
	else {
		local hastrail 0
	}

	if `haslead' | `hastrail' {
		tempvar clean
		qui gen `type' `clean' = trim(`v') if `touse'
		capture assert index(`clean'," ")==0 if `touse'
		drop `clean'
	}
	else {
		capture assert index(`v'," ")==0 if `touse'
	}

	if _rc {
		local hasem 1
		local ttl "embedded"
		global T_cb_str_embedded  $T_cb_str_embedded `v'
	}
	else {
		local hasem 0
	}

	local vers = _caller()
	if `vers' < 13 {
		local vers "version 13:"
	}
	else {
		local vers
	}

	`vers' capture assert index(`v',char(0))==0 if `touse'
	if _rc {
		local hasem0 1
		global T_cb_str_embedded0  $T_cb_str_embedded0 `v'
	}
	else {
		local hasem0 0
	}

	if `haslead' + `hastrail' + `hasem' >= 2 {
		if `haslead' & `hastrail' & `hasem' {
			local ttl "leading, embedded, and trailing"
		}
		else if `haslead' & `hastrail' {
			local ttl "leading and trailing"
		}
		else if `haslead' & `hasem' {
			local ttl "leading and embedded"
		}
		else {
			local ttl "embedded and trailing"
		}
	}

	if `haslead' | `hastrail' | `hasem' | `hasem0' {
		display
	}

	if `haslead' | `hastrail' | `hasem' {
		dis as txt _col(16) "warning:  variable has `ttl' blanks"
	}

	if `hasem0' {
		dis as txt _col(16) "warning:  variable has embedded \0"
	}
end


program Labeled, rclass
	args v touse languages

	if "`languages'" != "" {
		// check whether v is valued labeled in any of the languages
		local vlabeled = 0
		local vlabdef  = 0
		foreach ln of local languages {
			if "`ln'" == "`:char _dta[_lang_c]'" {
				local lbl : value label `v'
			}
			else {
				local lbl : char `v'[_lang_l_`ln']
			}
			if ("`lbl'" != "")  local vlabeled = 1
		}

		if (!`vlabeled') {
			return local vlabeled = 0
			return local vlabdef  = 0
			exit
		}

		// if reached, v is value labeled in >=1 languages
		local exist = 0
		foreach ln of local languages {
			LabelLine `v' `touse' `ln'
			local exist = `exist' | `r(exist)'
		}

		return local vlabeled = 1
		return local vlabdef  = `exist'
	}
	else {
		local lbl : value label `v'
		return local vlabeled = "`lbl'" != ""
		LabelLine `v' `touse' ""
		return local vlabdef  = r(exist)
	}
end


program LabelLine, rclass
	args v touse ln

	if ("`ln'" == "") | ("`ln'" == "`:char _dta[_lang_c]'") {
		local lbl : value label `v'
	}
	else {
		local lbl : char `v'[_lang_l_`ln']
	}

	if "`lbl'" == "" {
		if "`ln'" != "" {
			dis as txt "{ralign 22:label in `ln'}:  (unlabeled)"
		}
		return local exist = 0
		exit
	}
	else {
		if ("`ln'" != "")  local inln " in `ln'"
		dis as txt "{ralign 22:label`inln'}:  {res:`lbl'}" _c
	}

	capture label list `lbl'
	if _rc==111 {
		dis as txt ", but label does not exist"
		global T_cb_labelnotfound  $T_cb_labelnotfound `v'
		return local exist = 0
	}
	else {
		tempname codes
		capture qui tab `v' if `touse' & !missing(`v'), matrow(`codes') missing
		if _rc {
			DoTab1 `v' `touse' `lbl'
			if r(exist) == "1" {
				return local exist = 1
			}
		}
		else {
			local n = r(N)
			if `n' == 0 {
				matrix `codes' = (.) 
			}
			local uncoded = 0
			forvalues i = 1 / `=rowsof(`codes')' {
				local c = `codes'[`i',1]
				local s : label `lbl' `c'
				if `"`macval(s)'"' == "." {
					local s = 1
				}
				if (`"`macval(s)'"' == `"`c'"')  local ++uncoded
			}
			
			if `uncoded' > 0 {
				dis as txt ", but {res:`uncoded'} nonmissing value" ///
				cond(`uncoded'==1," is", "s are") " not labeled"
				global T_cb_notlabeled  $T_cb_notlabeled `v'
			}
			else {
				dis
			}
		
			return local exist = 1
		}
	}
end


program FullTab
	args vtype v touse bfmt

	tempname
	tempvar cnt first
	sort `touse' `v'
	qui by `touse' `v' : gen `c(obs_t)' `cnt' = _N  if `touse'
	qui by `touse' `v' : gen byte `first' = 1 if _n==1 & `touse'

//	if "`sort'" != "" {
//		tempvar mcnt
//		qui gen `mcnt' = - `cnt'
//	}
	sort `touse' `first' `mcnt' `v'

	qui count if `touse'==0
	local j = r(N)+1

	dis as txt _col(13) "tabulation:  Freq.  Value"
	while `first'[`j'] == 1 {
		if "`vtype'" == "n" {
			// numeric unlabeled
			dis _col(21) as res %10.0fc `cnt'[`j']  ///
			    _col(33) as res (`v'[`j'])
		}
		else if "`vtype'" == "d" {
			// date
			dis _col(21) as res %10.0fc `cnt'[`j']  ///
			    _col(33) as res (`v'[`j']) ///
			    _col(40) as txt `bfmt' (`v'[`j'])
		}
		else {
			// string
			dis _col(21) as res %10.0fc `cnt'[`j']  ///
			    _col(33) as txt _c
			local s = `v'[`j']
			Piece ye 33 40 `""`macval(s)'""'
		}
		local ++j
	}
end

program NumExamples
	args v touse languages

	if "`languages'" != "" {
		quiet label dir
		local labdef `r(names)'
		foreach ln of local languages {
			if "`ln'" == "`:char _dta[_lang_c]'" {
				local lbl : value label `v'
			}
			else {
				local lbl : char `v'[_lang_l_`ln']
			}
			if ("`lbl'" != "") & (`:list lbl in labdef') {
				local inln " in `ln'"
				continue, break
			}
		}
	}
	else {
		local lbl : value label `v'
	}

	sort `touse' `v'
	qui count if `touse'==0
	local f  = r(N)
	local wd = _N-r(N)
	local text "examples`inln':"
	foreach inc in .2 .4 .6 .8 {
		local vv = `v'[`f'+`inc'*`wd']
		local s  : label `lbl' `vv'
		if (`"`macval(s)'"' == `"`vv'"')  local s
		dis as txt "{ralign 23: `text'}" ///
		  _col(26) as res (`vv') _col(32) as txt `"`s"'
		local text
	}
end


program FullTabValueLabeled
	args v touse languages

	local nln : list sizeof languages
	if `nln' > 0 {
		foreach ln of local languages {
			if "`ln'" == "`: char _dta[_lang_c]'" {
				local lbl : value label `v'
			}
			else {
				local lbl : char `v'[_lang_l_`ln']
			}
			local lbllist `lbllist' `lbl'
		}
		local lbllist : list uniq lbllist

		// keep only those that are actually defined
		qui label dir
		local labdef `r(names)'
		local lbllist : list lbllist & labdef

		local nlbl    : list sizeof lbllist
		if `nlbl' > 3 {
			tokenize `lbllist'
			local lbllist `1' `2' `3'
			local nlbl = 3
			mac shift 3
			local notshown `*'
		}
	}
	else {
		local lbllist : value label `v'
		assert "`lbllist'" != ""
		local nlbl = 1
	}

	tokenize `lbllist'
	local cw = 0
	forvalues i = 1 / `nlbl' {
		local cw = max(`cw',`:label ``i'' maxlength',length("``i''"))
	}
	local cwidth = min(`cw', int((`c(linesize)'-43)/`nlbl')-3)

	if `nlbl' > 1 {
		dis as txt _col(13) "tabulation:  Freq. Numeric" _c
		forvalues i = 1 / `nlbl' {
			dis `"   {lalign `cwidth':`=abbrev("``i''",`cwidth')'}"' _c
		}
		dis
	}
	else {
		if (`nln'==1) local incln " in `languages'"
		dis as txt _col(13) "tabulation:  Freq.   Numeric  Label`incln'"
	}

	tempname cnt codes
	capture qui tab `v' if `touse' , matcell(`cnt') matrow(`codes') missing
	if _rc {
		DoTab2 `v' `touse' `nlbl' `cwidth' `notshown'	
	}
	else {
		forvalues i = 1 / `=rowsof(`cnt')' {
			local c = `codes'[`i',1]
			if `nlbl' == 1 {
				dis _col(21) as res %10.0fc `cnt'[`i',1]   ///
				    _col(33) as res %8.0g `c'            ///
				    _col(43) as txt _c
				local s : label `1' `c'
				if `"`macval(s)'"' != `"`c'"' {
					Piece txt  43 32 `"`macval(s)'"'
				}
				else	display
			}
			else {
				dis _col(21) as res %10.0fc `cnt'[`i',1]   ///
				    _col(31) as res %8.0g `c'            ///
				    _col(42) as txt _c
				forvalues j = 1 / `nlbl' {
					local s : label ``j'' `c' `cwidth'
					if (`"`macval(s)'"' == `"`c'"') local s ""
					dis as res `"{lalign `cwidth':`macval(s)'}"' _c
					if (`j'<`nlbl')  dis _skip(3) _c
	
				}
				dis
			}
		}
		if "`notshown'" != "" {
			dis as txt _n "(value labels `notshown' are not listed)"
		}
	}
end


program CntUniq, rclass
	args v touse

	quietly {
		count if `touse'
		ret scalar ntouse = r(N)

		tempvar tag
		bys `touse' `v': gen byte `tag'= 1 if _n==1 & `touse'

		count if `tag'==1 & !missing(`v') & `touse'
		ret scalar uniq_nmv = r(N)

		if bsubstr("`:type `v''",1,3) == "str" {
			count if missing(`v') & `touse'
			ret scalar miss_sys = r(N)
			ret scalar miss_ext = 0
			ret scalar uniq_mv  = return(miss_sys) > 0
		}
		else {
			count if `tag'==1 & missing(`v') & `touse'
			ret scalar uniq_mv = r(N)
			count if `v'==. & `touse'     // sic -- "`v'==."
			ret scalar miss_sys = r(N)          // sysmiss  (.)
			count if missing(`v') & `touse'
			ret scalar miss_ext = r(N) - return(miss_sys)
						     // extended mv (.a/.z)
		}
	}
end


program ShowUniq
	args  vtype  uniq_nmv  uniq_mv  miss_sys  miss_ext  ntouse1

	local uniq_nmv	: display %10.0fc `uniq_nmv'
	local uniq_nmv	: list retok uniq_nmv
	local uniq_mv	: display %10.0fc `uniq_mv'
	local uniq_mv	: list retok uniq_mv
	local miss_sys	: display %10.0fc `miss_sys'
	local miss_sys	: list retok miss_sys
	local miss_extc	: display %10.0fc `miss_ext'
	local miss_extc	: list retok miss_extc
	local ntouse1	: display %10.0fc `ntouse1'
	local ntouse1	: list retok ntouse1
	if "`vtype'" == "str" {

		dis _col(10) as txt "unique values:  " as res "`uniq_nmv'" ///
	 	    _col(51) as txt  `"missing "":  "' as res "`miss_sys'" ///
	 	             as txt "/" as res "`ntouse1'"

	}
	else {	// numeric var, both miss_sys and miss_ext

		dis _col(10) as txt "unique values:  " as res "`uniq_nmv'" ///
	 	    _col(51) as txt     "missing .:  " as res "`miss_sys'" ///
	 	             as txt "/" as res "`ntouse1'"

		if `miss_ext' > 0 {
			dis _col(8)  as txt "unique mv codes:  "  ///
			             as res "`uniq_mv'"           ///
			    _col(50) as txt      "missing .*:  "  ///
	 		             as res "`miss_extc'" as txt "/" ///
	 		             as res "`ntouse1'"
		}
	}
end


/* CrcMiss touse varlist

   reports the logical relations between missingness of the first var and
   missingness of the other vars in varlist
*/
program CrcMiss
	syntax varlist(min=3)

	gettoken touse varlist : varlist
	gettoken v     varlist : varlist

	capt confirm string var `v'
	local vs = (_rc == 0)
	// v ever missing ?
	capt assert !missing(`v') if `touse'
	if _rc == 0 {
		exit
	}

	tempvar ismiss newmiss
	local frst 1
	local abv = abbrev("`v'",12)
	qui gen byte `ismiss'  = missing(`v') if `touse'
	qui gen byte `newmiss' = .

	foreach tv of local varlist {
		if "`tv'" == "`v'" {
			continue
		}

		capt confirm string var `tv'
		local tvs = (_rc == 0)

		// tv ever missing ?
		qui replace `newmiss' = missing(`tv') if `touse'
		capt assert `newmiss' == 0 if `touse'
		if !_rc {
			continue
		}

		// v . ==> tv . ?
		capt assert `ismiss' if `newmiss' & `touse'
		if _rc {
			continue
		}

		if `frst' {
			local frst 0
			dis as txt _n _col(9) "missing values:" _c
		}
		else {
			dis _col(24) _c
		}

		local abtv = abbrev("`tv'",12)
		dis as txt "{ralign 14:`abtv'}==" cond(`tvs',`""" "',"mv ") _c

		// v>=. ==> tv>=.?
		capt assert `newmiss' if `ismiss' & `touse'
		dis as txt cond(_rc==0,"<-> ", "--> ") _c
		dis as txt "`abv'==" cond(`vs',`""""',"mv")
	}
end


program Units, rclass /* varname touse */
	args v touse

	// v always missing
	capture assert missing(`v') if `touse'
	if _rc == 0 {
		return scalar units = .
		return scalar min   = .
		return scalar max   = .
		return scalar mean  = .
		return scalar Var   = .
		exit
	}

	tempname max mean min p Var
	qui summ `v' if `touse'
	scalar `min'  = r(min)
	scalar `max'  = r(max)
	scalar `mean' = r(mean)
	scalar `Var'  = r(Var)

	// v constant
	capture assert missing(`v') | (`Var' == 0)  if `touse'
	if _rc == 0 {
		return scalar units = 1      // current behavior
		return scalar min   = `min'
		return scalar max   = `max'
		return scalar mean  = `mean'
		return scalar Var   = `Var'
		exit
	}

	// determine unit
	scalar `p' = 1
	capture assert float(`v') == float(round(`v',1)) if `touse'
	if _rc == 0 {
		while _rc == 0 {
			scalar `p' = `p'*10
			capture assert float(`v') == float(round(`v',`p')) if `touse'
		}
		scalar `p' = `p'/10
	}
	else {
		while _rc {
			scalar `p' = `p'/10
			capture assert float(`v') == float(round(`v',`p')) if `touse'
		}
	}
	return scalar units = `p'
	return scalar min   = round(`min',`p')
	return scalar max   = round(`max',`p')
	return scalar mean  = `mean'
	return scalar Var   = `Var'
end


program Piece
	args color col len str

	local piece : piece 1 `len' of `"`macval(str)'"'
	dis as `color' `"`macval(piece)'"'

	local i 2
	local piece : piece 2 `len' of `"`macval(str)'"'
	while `"`macval(piece)'"' != "" {
		dis as `color' _col(`col') `"`macval(piece)'"'
		local ++i
		local piece : piece `i' `len' of `"`macval(str)'"'
	}
end


program Header
	syntax [, LANGuages(str) Notes]
	dis _n as txt _col(16) "Dataset:  " _c
	if `"$S_FN"' == "" {
		dis as txt "[unnamed]"
	}
	else {
		_shortenpath `"$S_FN"' , len(`=c(linesize)-28')
		dis as res `"`r(pfilename)'"'
	}

	dis as txt _col(13) "Last saved:  " _c
	if `"$S_FN"' == "" {
		dis as txt "never"
	}
	else if `"$S_FNDATE"' == "" {
		dis as txt "unknown"
	}
	else {
		dis as res `"$S_FNDATE"'
	}

	if `"$S_FN"' != "" {
		qui des, short
		if r(changed) {
			dis as txt _col(26) "DATA HAVE CHANGED SINCE LAST SAVED"
		}
	}
	dis

	quiet label language
	local cln `r(language)'
	local lns `r(languages)'
	local nln : list sizeof languages

	if "`lns'" != "default" {
		dis "{p 3 26 2}{txt:Available languages:}{space 2}{res:`lns'}{p_end}"
		if `nln' > 0 {
			dis "{p 4 26 2}{txt:Codebook languages:}{space 2}{res:`languages'}{p_end}"
		}
		else if `nln' == 0 {
			dis "{col 6}{txt:Codebook language:}  {res:`cln'}"
		}
		dis
	}

	if "`languages'" == "" {
		local x : data label
		if `"`x'"' == "" {
			local x "[none]"
		}
		dis as txt _col(18) "Label:" as res `"  `x'"'
	}
	else {
		foreach ln of local languages {
			if "`ln'" == "`cln'" {
				local x : data label
			}
			else {
				local x : char _dta[_lang_v_`ln']
			}
			if `"`x'"' == "" {
				local x "[none]"
			}
			dis as txt "{ralign 22:Label in `ln'}:" as res `"  `x'"'
		}
		dis
	}

	quietly desc, short
	dis _col(4)  as txt "Number of variables:  "       ///
	             as res trim(string(r(k),"%16.0gc"))
	dis _col(1)  as txt "Number of observations:  "    ///
	             as res trim(string(r(N),"%16.0gc"))
	dis _col(19) as txt "Size:  "                      ///
	             as res trim(string((r(width))*r(N),"%16.0gc")) ///
	             as txt " bytes ignoring labels, etc."

	if "`notes'" != "" {
		notes _dta
	}
end


/* VarHeader v
   displays the header for the report on variable v
*/
program VarHeader
	syntax varname [, LANGuages(str)]

	local v `varlist'
	local vname `v'
	if "`languages'" != "" {
		dis _n "{txt}{hline}"
		foreach ln of local languages {
			if "`ln'" == "`:char _dta[_lang_c]'" {
				local lbl : variable label `v'
			}
			else {
				local lbl : char `v'[_lang_v_`ln']
			}
			if `"`lbl'"' == "" {
				local lbl "(unlabeled)"
			}

			local len = udstrlen("`vname'`ln'")
			if `len' < 22 {
				local sp `"{space `=19-`len''}"'
				dis `"{p 0 25}{res}`vname'`sp'{txt:in `ln':}{space 2}{res:`lbl'}{p_end}"'
			}
			else {
				local splen = 22-udstrlen("in `ln'") 
				if `splen' <= 0 {
					local splen = 2
				}
				local sp `"{space `splen'}"'
				dis "{res:`vname'}" _n ///
				    `"{p 0 25}`sp'{txt:in `ln':}{space 2}{res:`lbl'}{p_end}"'
			}
			local vname
		}
		dis "{txt}{hline}" _n
	}
	else {
		local lbl : variable label `v'
		local lbl : subinstr local lbl "`" "{c 'g}", all

		if `"`lbl'"' == "" {
			local lbl "(unlabeled)"
		}
		dis _n "{txt}{hline}"
		if  udstrlen(`"`lbl'"') + udstrlen("`vname'") < `c(linesize)'-2 {
			dis `"{res}`vname'{right:`lbl'}"'
		}
		else {
			local splen = 39-udstrlen("`v'") 
			if `splen' <= 0 {
				local splen = 2 
			}
			local sp = "{space `splen'}"
			dis `"{p 0 39}{res}`vname'`sp'`lbl'{p_end}"'
		}
		dis "{txt}{hline}" _n
	}
end


/* ReportProblems
   creates a report on potential problems in the data
*/
program ReportProblems

	if `"$S_FN"' == "" {
		local dataset "[unnamed]"
	}
	else {
		_shortenpath `"$S_FN"' , len(`=c(linesize)-36')
		local dataset `"`r(pfilename)'"'

		qui des, short
		if r(changed) {
			global T_cb_datachanged 1
		}
	}

	// len := max of varlists to be displayed
	local len 0
	foreach source in cons labelnotfound notlabeled str_type ///
	                  str_leading str_trailing str_embedded  ///
			  str_embedded0 realdate {
		local len = max(`len',`: length global T_cb_`source'')
	}
	if  `len' == 0 {
		dis _n ///
		`"{txt}no potential problems in dataset {res}`dataset'"'
		exit
	}

	dis _n `"{txt}   Potential problems in dataset   {res}`dataset'"' _n

	// if "$T_cb_datachanged" != "" {
	//	dis as txt "    data changed since last saved" _n
	// }

	local hlen = clip(35+`len', 50, c(linesize))

	dis as txt _col(16) "potential problem   variables"
	dis as txt "{hline `hlen'}"

	Msg  cons           "constant (or all missing) vars"
	Msg  labelnotfound  "vars with nonexisting label"
	Msg  notlabeled     "incompletely labeled vars"
	Msg  str_type       "str# vars that may be compressed"
	Msg  str_leading    "string vars with leading blanks"
	Msg  str_trailing   "string vars with trailing blanks"
	Msg  str_embedded   "string vars with embedded blanks"
	Msg  str_embedded0  "string vars with embedded \0"
	Msg  realdate       "noninteger-valued date vars"

	dis as txt "{hline `hlen'}"
end


/* Msg mac txt
   display utility for Problems
*/
program Msg
	args mac txt

	if `"${T_cb_`mac'}"' == "" {
		exit
	}

	local len = 32 - udstrlen(`"`txt'"')
	if `len' <= 0 {
		local len = 2
	}
	dis as txt `"{p 0 35}{space `len'}`txt'{space 3}"' ///
	    as res "${T_cb_`mac'}" "{p_end}"
end


program ReturnGlobals, rclass
	local macros  datachanged   cons          labelnotfound ///
		      notlabeled    str_type      str_leading   ///
		      str_trailing  str_embedded  str_embedded0 realdate

	foreach r of local macros {
		return local `r' `"${T_cb_`r'}"'
	}
end


program ParseLanguage, sclass
	args languages languages2

	if "`languages'" != "" & `"`languages2'"' != "" {
		dis as err "options languages and languages() may not be combined"
		exit 198
	}

	quiet label language
	local cln  `r(language)'
	local dlns `r(languages)'

	if ("`languages'" != "") | (`"`languages2'"' == "_all") {
		local lns `dlns'
	}
	else if `"`languages2'"' != "" {
		local notfound : list languages2 - dlns
		if "`notfound'" != "" {
			dis as err "languages() invalid; `notfound' not defined"
			exit 100
		}
		local lns : list uniq languages2
	}

//	if "`lns'" == "default" {
//		local lns
//	}

	sreturn clear
	sreturn local lns `lns'
end

program define DoTab1, rclass
	args v touse lbl
	preserve
	qui sum `v'
	if r(N) > 0 {
		contract `v' if `touse' & !missing(`v')
		local n = _N
		local uncoded = 0
		forvalues i = 1/`n' {
			local c = `v'[`i']
			local s : label `lbl' `c'
			if ("`s'" == "`c'")  local ++uncoded
		}
	
		if `uncoded' > 0 {
			dis as txt ", but {res:`uncoded'} nonmissing value" ///
			cond(`uncoded'==1," is", "s are") " not labeled"
			global T_cb_notlabeled  $T_cb_notlabeled `v'
		}
		else {
			dis
		}
		return local exist = 1
	}
	else {
		return local exist = 0
	}
	
	restore

end

program define DoTab2, rclass
	args v touse nlbl cwidth notshown
	preserve
	contract `v' if `touse' 
	qui sum `v'	
	local n = _N
	forvalues i = 1 / `n' {
		local c = `v'[`i']
		if `nlbl' == 1 {
			dis _col(24) as res %7.0g _freq[`i']   ///
			    _col(33) as res %8.0g `c'            ///
			    _col(43) as txt _c
			local s : label `1' `c'
			if `"`macval(s)'"' != "`c'" {
				Piece txt  43 32 `"`macval(s)'"'
			}
			else display
		}
		else {
			dis _col(24) as res %7.0g _freq[`i']   ///
			    _col(31) as res %8.0g `c'            ///
			    _col(42) as txt _c
			forvalues j = 1 / `nlbl' {
				local s : label ``j'' `c' `cwidth'
				if (`"`macval(s)'"' == "`c'") local s ""
				dis as res `"{lalign `cwidth':`macval(s)'}"' _c
				if (`j'<`nlbl')  dis _skip(3) _c
			}
			dis
		}
	}
	if "`notshown'" != "" {
			dis as txt _n "(value labels `notshown' are not listed)"
	}
		
	restore
end

program define SummCompact, sortpreserve
	syntax [varlist] [if] [in] [, dots ]

	marksample touse, strok novarlist
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}

	mata: CrMatrices("`varlist'", "`touse'", "`dots'")

end

mata:
void CrMatrices(string scalar varlist, string scalar touse, string scalar dots)
{
	transmorphic matrix	Varlist, Vars, Obs, Means, Uniques
	transmorphic matrix	Mins, Maxs, Varlbls, Lengths, curmat
	pointer			MatNames
	real scalar		varct, i, j, obs, unique, totalwidth
	real scalar		lengthhold, length
	string scalar		val
	real scalar		linesize, lbllength
	string scalar		mean, min, max
	string scalar		var, varlbl, lbl2print
	string scalar		varwidth, obswidth, meanwidth, uniquewidth
	string scalar		minwidth, maxwidth

	Varlist = tokens(varlist)
	varct = cols(Varlist)

	for(i=1;i<=varct;i++) {
		if (dots != "") {
			stata("_dots " + strofreal(i) + " 0")
		}
		var = Varlist[1,i]
		if (udstrlen(var) > 12) {
			stata(`"local abbrevvar = abbrev(""' +
				var + `"", 12)"')
			var = st_local("abbrevvar")
		}

		stata("CntUniq " + Varlist[1,i] + " " + touse)
		unique = st_numscalar("r(uniq_nmv)")
		varlbl = st_varlabel(Varlist[1,i])

		if (st_isnumvar(Varlist[1,i])) {
			stata("summarize " + Varlist[1,i] + " if " + 
				touse + ",  meanonly")
			obs  = st_numscalar("r(N)")
			if (obs > 0) {
			    mean = sprintf("%9.0g", st_numscalar("r(mean)"))
			    min  = sprintf("%9.0g", st_numscalar("r(min)"))
			    max  = sprintf("%9.0g", st_numscalar("r(max)"))
			}
			else {
				mean = "."
				min  = "."
				max  = "."
			}
		}
		else {
			stata("qui count if " + touse + "& !missing(" + Varlist[1,i] +")")
			obs  = st_numscalar("r(N)")
			mean = "."
			min  = "."
			max  = "."
		}

		if (i==1) {
			Vars    = J(varct,1,strtrim(var))
			Obs     = J(varct,1,obs)
			Means   = J(varct,1,strtrim(mean))
			Uniques = J(varct,1,unique)
			Mins    = J(varct,1,strtrim(min))
			Maxs    = J(varct,1,strtrim(max))
			Varlbls = J(varct,1,strtrim(varlbl))
		}
		else {
			Vars[i,1]    = strtrim(var)
			Obs[i,1]     = obs
			Means[i,1]   = strtrim(mean)
			Uniques[i,1] = unique
			Mins[i,1]    = strtrim(min)
			Maxs[i,1]    = strtrim(max)
			Varlbls[i,1] = varlbl
		}
	}

	if (dots != "") {
		printf("\n")
	}

	// We need to find the max width for each column of our table
	MatNames = (&Vars \ &Obs \ &Means \ &Uniques \ &Mins \ &Maxs \ &Varlbls)
	Lengths = J(7,1,.)
	for(i=1;i<=7;i++) {
		lengthhold = 0
		for(j=1;j<=varct;j++) {
			curmat = *MatNames[i,1]
			if (isstring(curmat)) {
				length = udstrlen(curmat[j,1])
			}
			else {
				val = sprintf("%f", curmat[j,1])
				length = strlen(val)
			}
			if (length > lengthhold) {
				lengthhold = length
			}
		}
		Lengths[i,1] = lengthhold
	}

	varwidth = (Lengths[1,1] < 9) ? "9" : strofreal(Lengths[1,1])
	totalwidth = (Lengths[1,1] < 9) ? 9 : Lengths[1,1]

	obswidth = (Lengths[2,1] <= 3) ? "5" : strofreal(Lengths[2,1] + 2)
	totalwidth = (Lengths[2,1] <= 3) ? totalwidth + 5 : totalwidth +
		Lengths[2,1] + 2

	meanwidth = (Lengths[3,1] <= 4) ? "6" : strofreal(Lengths[3,1] + 2)
	totalwidth = (Lengths[3,1] <= 4) ? totalwidth + 6 : totalwidth +
		Lengths[3,1] + 2

	uniquewidth = (Lengths[4,1] <= 6) ? "7" : strofreal(Lengths[4,1] + 1)
	totalwidth = (Lengths[4,1] <= 6) ? totalwidth + 7 : totalwidth +
		Lengths[4,1] + 1

	minwidth = (Lengths[5,1] <= 3) ? "5" : strofreal(Lengths[5,1] + 2)
	totalwidth = (Lengths[5,1] <= 3) ? totalwidth + 5 : totalwidth +
		Lengths[5,1] + 2

	maxwidth = (Lengths[6,1] <= 3) ? "5" : strofreal(Lengths[6,1] + 2)
	totalwidth = (Lengths[6,1] <= 3) ? totalwidth + 5 : totalwidth +
		Lengths[6,1] + 2
	totalwidth = totalwidth + 2

	printf("\n")
	printf("{txt}")
	printf("%-" + varwidth + "uds", "Variable")
	printf("%" + obswidth + "s", "Obs")
	printf("%" + uniquewidth + "s", "Unique")
	printf("%" + meanwidth + "s", "Mean")
	printf("%" + minwidth + "s", "Min")
	printf("%" + maxwidth + "s", "Max")


	printf("  Label\n")

	linesize = c("linesize")
	printf("{txt}{hline " + strofreal(linesize) + "}\n")
	for(i=1;i<=varct;i++) {
	    printf("{txt}")
	    printf("%-" + varwidth + "uds", Vars[i,1])

	    printf("{res}")
	    printf("%" + obswidth + "s", strofreal(Obs[i,1]))
	    printf("%" + uniquewidth + "s", strofreal(Uniques[i,1]))
	    printf("%" + meanwidth + "s", Means[i,1])
	    printf("%" + minwidth + "s", Mins[i,1])
	    printf("%" + maxwidth + "s", Maxs[i,1])
	    printf("  ")

	    if (totalwidth + strlen(strtrim(Varlbls[i,1])) > linesize) {
		lbllength = linesize - totalwidth
		lbl2print = udsubstr(Varlbls[i,1], 1, lbllength - 3)
		lbl2print = lbl2print + "..."

	    }
	    else {
		lbllength = strlen(strtrim(Varlbls[i,1]))
		lbl2print = strtrim(Varlbls[i,1])
	    }
	    printf("{txt}%-" + strofreal(lbllength) + "uds\n", strtrim(lbl2print))
	}
	printf("{txt}{hline " + strofreal(linesize) + "}\n")
}
end

exit


GLOBALS USED FOR VARLISTS WITH POTENTIAL PROBLEMS

  T_cb_datachanged          flags data have changed since last saved

  T_cb_cons                 constant (or all missing) vars
  T_cb_labelnotfound        vars with nonexisting label
  T_cb_notlabeled           incompletely labeled vars
  T_cb_str_type             str# vars that may be compressed
  T_cb_str_leading          string vars with leading blanks
  T_cb_str_trailing         string vars with trailing blanks
  T_cb_str_embedded         string vars with embedded blanks
  T_cb_str_embedded0        string vars with embedded \0
  T_cb_realdate             noninteger-valued date vars


DISPLAY FORMATS

longlong ------------------------------------------ average january temperature
	          type:  numeric (int)
	         label:  gould, but 2 values are not labeled
	         range:  [xxx,xxx]
	         units:  1
	 unique values:  5
	 coded missing:  72
            Tabulation:  Freq.   Numeric  label
		       xxxxxxx  xxxxxxxx  (none)
		       1234567  12345678
 Or:
            Tabulation:  Freq.  value
		        xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

         1         2         3
12345678901234567890123456789012345678901234
               Warning:  variable has leading, trailing, embedded blanks

