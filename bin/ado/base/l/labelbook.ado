*! version 1.2.15  25feb2015
program define labelbook, rclass
	version 8

	syntax [anything(id=lblnamelist name=names)] [using/] [,     ///
		Alpha Detail LEngth(int 12) LIst(int 32000) Problems ]

	local strlen = c(maxstrvarlen)

	if !inrange(`length',1,`strlen') {
		// max string length
		dis as err "length() should be in range [1,`strlen']"
		exit 198
	}
	loc sh `length'     // length of shortened vallabels

	if `list' < 0 {
		dis as err "list() should be positive"
		exit 198
	}

	if "`problems'" == "" {
		loc detail detail
	}

// parsing is ready

	preserve

	if `"`using'"' != "" {
		use `"`using'"' , clear
	}

	// the option -var- of -uselabel- specifies that
	// varlists that "use" the labels are saved in r(labname)
	//
	// If the data contains labels in more than one language
	// the varlists for the non-active languages are returned
	// in r(labname_ln)

	uselabel `names' , var clear
	if _N==0 {
		exit
	}

	local labnames `r(__labnames__)'
	local cln      `r(__current_language__)'
	local olns     `r(__other_languages__)'
	local nlns   = `:list sizeof olns' + 1

	local vl_notused
	foreach lbn of local labnames {
		local lbused 0
		local xx `"`cln' `"`r(`lbn')'"'"'
		if ("`r(`lbn')'" != "") {
			local lbused 1
		}
		foreach ln of local olns {
			local xx `"`xx' `ln' `"`r(`lbn'_`ln')'"'"'
			if ("`r(`lbn'_`ln')'" != "") {
				local lbused 1
			}
		}

		local v_`lbn' `"`xx'"'
		if !`lbused' {
			local vl_notused `vl_notused' `lbn'
		}
	}
	local vl_notused : list sort vl_notused

	confirm exist lname value label
	confirm string  var lname
	confirm string  var label
	confirm numeric var value
	// value should be integer valued
	capt assert value==round(value)
	if _rc {
		dis as err "labelbook: this should not happen"
		dis as err "value is not integer-valued"
		exit 9999
	}

	// sysmiss cannot be labeled
	capt assert value != .
	if _rc {
		dis as err "labelbook: this should not happen"
		dis as err "sysmiss (.) seems to be value labeled"
		exit 9999
	}

	// labels that can be interpreted as numbers
	gen numlabel = !missing(real(label))
	bys lname (numlabel): gen label_num = numlabel[_N]

	// blank labels (yes, this allowed in Stata!)
	gen null = trim(label) == ""
	bys lname (null) : gen L_null = null[_N]

	// leading/trailing blanks
	gen ltblanks = trim(label) != label
	bys lname (ltblanks) : gen L_ltblanks = ltblanks[_N]

	// truncated labels
	bys lname (trunc) : gen L_trunc = trunc[_N]

	// statistics on length of labels
	gen labellen = length(label)
	bys lname (labellen): gen l_min = labellen[1]
	bys lname (labellen): gen l_max = labellen[_N]

	// non-truncated labels are unique within VL ?
	bys lname label : gen N = _N == 1
	bys lname (N) : gen Unique = (N[1]==1 | L_trunc)
	drop N

	// truncated labels are unique within VL ?
	bys lname label : gen N = _N == 1
	bys lname (N) : gen TrUnique = (N[1]==1 | !L_trunc)
	drop N

	// shortened_labels are unique within VL ?
	qui gen shlabel = usubstr(label,1,`sh')
	bys lname shlabel: gen N = _N == 1
	bys lname (N) : gen shUnique = N[1]==1
	drop N

	// statistics on values
	bys lname : gen nmiss = sum(missing(value))
	qui bys lname : replace nmiss = nmiss[_N]
	bys lname (value) : gen `c(obs_t)' v_n   = _N
	bys lname (value) : gen v_min = value[1]
	bys lname (value) : gen v_max = value[_N-nmiss[_N]]
	bys lname (value) : gen v_gap = (v_max-v_min+1) - (v_n-nmiss)

	// random selection of labels within VLs
	if `list' != 32000 {
		gen rnd = uniform()
		bys lname (rnd) : gen show = _n <= `list'
	}
	else {
		gen byte show = 1
	}

	// details for display info on vlabels
	if "`alpha'" != "" {
		sort lname label value
	}
	else {
		sort lname value label
	}

	loc alablist 		// list of labels in alpha order
	loc n2 = 0
	while `n2' < _N {	// loop over all value labels

		loc n1 = `n2' + 1
		loc vlabel = lname[`n1']
		loc alablist `alablist' `vlabel'
		loc nlab = v_n[`n1']
		loc n2 = `n1' + `nlab' - 1

		if !Unique[`n1'] {
			loc vl_nuniq `vl_nuniq' `vlabel'
		}
		if !TrUnique[`n1'] {
			loc vl_ntruniq `vl_ntruniq' `vlabel'
		}
		if !shUnique[`n1'] {
			loc vl_nuniq_sh `vl_nuniq_sh' `vlabel'
		}
		if L_null[`n1'] {
			loc vl_null `vl_null' `vlabel'
		}
		if L_ltblanks[`n1'] {
			loc vl_ltblanks `vl_ltblanks' `vlabel'
		}
		if v_gap[`n1'] > 0 {
			loc vl_gaps `vl_gaps' `vlabel'
		}
		if label_num[`n1'] > 0 {
			loc vl_numeric `vl_numeric' `vlabel'
		}

		if "`detail'" != "" {
			#del ;
			LabelDetail "`n1'"
				    "`n2'"
				    "`vlabel'"
				    "`sh'"
			            "`list'"
			            "`varlabel'"
			            "`nlns'"
			            `"`v_`vlabel''"' ;
			#del cr
		}
	}
	restore

	if "`problems'" != "" {
		#del ;
		Problems "`alablist'"
			 "`sh'"
			 "`vl_numeric'"
		         "`vl_gaps'"
		         "`vl_ltblanks'"
		         "`vl_null'"
		         "`vl_nuniq'"
		         "`vl_ntruniq'"
		         "`vl_nuniq_sh'"
		         "`vl_notused'" ;
		#del cr
	}

	ret loc names    `alablist'

	ret loc gaps     `vl_gaps'
	ret loc numeric  `vl_numeric'
	ret loc blanks   `vl_ltblanks'
	ret loc null     `vl_null'
	ret loc nuniq    `vl_nuniq'
	ret loc ntruniq  `vl_ntruniq'
	ret loc nuniq_sh `vl_nuniq_sh'
	ret loc notused  `vl_notused'
end


program define LabelDetail
	args n1 n2 vlabel sh list varlabel nlang vlist

	local trunc = L_trunc[`n1']

	dis _n as txt "{hline}" _n "value label " ///
	       as res "`vlabel' "

	if (`trunc') {
		dis as txt "(note: label has values longer than " ///
		"`c(maxstrvarlen)'; values truncated for analysis below)"
	}

	dis as txt "{hline}" _n

	#del ;
	dis _col(7)  as txt "{hi:values}"
	    _col(49)        "{hi:labels}" ;

	dis _col(8)  as txt "range:  [" as res v_min[`n1']
	             as txt "," as res v_max[`n1'] as txt "]"
	    _col(42) as txt "string length:  [" as res l_min[`n1']
	             as txt "," as res l_max[`n1'] as txt "]" ;

	if (`trunc') { ;
		local c2 = 38 - length("`c(maxstrvarlen)'") ;
		dis _col(12)   as txt "N:  " as res v_n[`n1']
		    _col(`c2') as txt "unique at length `c(maxstrvarlen)':  "
		               as res cond(TrUnique[`n1'],"yes","no") ;
	} ;
	else { ;
		dis _col(12) as txt "N:  " as res v_n[`n1']
		    _col(34) as txt "unique at full length:  "
		             as res cond(Unique[`n1'],"yes","no") ;
	} ;

	dis _col(9)  as txt "gaps:  "
	             as res cond(v_gap[`n1'],"yes","no")
	    _col(36) as txt "{ralign 20:unique at length `sh':}  "
	             as res cond(shUnique[`n1'],"yes","no") ;

	dis _col(3)  as txt "missing .*:  "
	             as res nmiss[`n1']
	    _col(44) as txt "null string:  "
	             as res cond(L_null[`n1'],"yes","no") ;

	dis _col(32) as txt "leading/trailing blanks:  "
        	     as res cond(L_ltblanks[`n1'],"yes","no") ;

	dis _col(37) as txt "numeric -> numeric:  "
		     as res cond(label_num[`n1'],"yes","no") ;
	#del cr

	if `list' > 0 {
		dis "  {hi:definition}"
		loc nlab = `n2'-`n1'+1
		if `nlab' > `list' {
			dis as txt _col(8) ///
			  "`list' random examples out of `nlab' labels" _n
		}
		forvalues i = `n1'/`n2' {
			if !show[`i'] {
				continue
			}

			if null[`i'] {
				dis as txt %12.0f value[`i']
				// as res "   {it:empty string/blanks}"
				continue
			}

			local v = value[`i']
			local sp = 12 - length("`v'")
			dis as txt "{p 0 15 2}{space `sp'}`v'{space 2}"

			if udstrlen(trim(label[`i'])) > `sh' {
				// underline chars 1..sh
				loc ul 1
				local vl1 = udsubstr(label[`i'],1,`sh')
				local nextpos = ustrlen(udsubstr(label[`i'],1,`sh')) 				
				dis as res `"   {ul:`macval(vl1)'}"' udsubstr(label[`i'],`nextpos'+1,.)
			}
			else {
				dis as res label[`i']
			}

			dis "{p_end}"
		}
		/*
		if "`ul'" != "" {
			dis as txt "underlining `sh' chars of longer labels"
			dis as txt "red underscores are leading/trailing blanks"
		}
		*/
	}

	// variables to which value label is attached in the different languages

	if `nlang' == 1 {
		gettoken ln vlist : vlist
		dis _n as txt `"{p 3 15}variables:{space 2}"' as res `vlist'
		dis
	}
	else {
		local rest `vlist'
		local used = 0
		forvalues i = 1/`nlang' {
			gettoken ln    rest : rest
			gettoken vlist rest : rest
			if "`vlist'" != "" {
				dis _n as txt "{p 3 23}in {res:`ln'} attached to " ///
				       as res "`vlist'"
				local used 1
			}
		}
		if !`used' {
			dis as txt _n "  not attached to any variable in any language"
		}
		dis
	}
end


program define Problems
	args alablist sh numeric gaps ltblanks null ///
	     nuniq ntruniq nuniq_sh notused

	if `"$S_FN"' == "" {
		loc dataset "[unnamed]"
	}
	else {
		_shortenpath `"$S_FN"' , len(`=c(linesize)-35')
		loc dataset  `"`r(pfilename)'"'
	}

	loc vlen 0
	foreach source in numeric gaps ltblanks null ///
					 nuniq ntruniq nuniq_sh notused {
		loc vlen = max(`vlen', `:length local `source'')
	}
	dis
	if `vlen' == 0 {
		dis `"{txt}no potential problems in dataset {res}`dataset'"'
		exit
	}
	dis `"{txt}   Potential problems in dataset   {res}`dataset'"' _n

	dis as txt _col(16) "potential problem   value labels"
	loc hlen = clip(35+`vlen', 50, `c(linesize)')
	dis as txt "{hline `hlen'}"

	Msg  "`numeric'"   `"numeric -> numeric"'
	Msg  "`gaps'"      `"gaps in mapped values"'
	Msg  "`ltblanks'"  `"leading or trailing blanks"'
	Msg  "`null'"      `"numeric -> null str"'
	Msg  "`nuniq'"     `"duplicate labels"'
	Msg  "`ntruniq'"   `"duplicate lab. at length `c(maxstrvarlen)'"'
	Msg  "`nuniq_sh'"  `"duplicate lab. at length `sh'"'
	Msg  "`notused'"   `"not used by variables"'

	dis as txt "{hline `hlen'}"
end


program define Msg
	args mac txt

	if "`mac'" == "" {
		exit
	}

	loc len = 32-length(`"`txt'"')
	dis as txt "{p 0 35}{space `len'}`txt'{space 3}" as res "`mac'" "{p_end}"
end
exit

HISTORY

  1.2.12 long label (> maxstrvarlen) changes
  1.2.9  language support
  1.2.5  bug fix - order of output could be random
  1.2.4  bug fix - gaps
  1.2.3  Stata/SE
  1.2.2  shortening long paths

