*! version 1.0.4  15oct2019
program _pss_graph
	version 13
	tempname results
	_return hold `results'
	_return restore `results' , hold
	capture nobreak noisily {
		powergraph `0'
	}
	local rc = _rc
	_return restore `results'
	if `rc' {
		exit `rc'
	}

end

program powergraph

	local maxticks   8			// max default x ticks
	local plotswrap 15			// unique plot definitions

							// Parse
		// Production notes: dimension options allow plurals but are
		// documented as singular.  Same for option recastcis. option
		// byoptions allowed, but undocumented.

	syntax [, Ydimensions(string asis)				///
		  Xdimensions(string asis)				///
		  PLOTdimensions(string asis)				///
		  BYdimensions(string asis) 				///
		  GRaphdimensions(string asis)				///
		  YVALues						///
		  XVALues						///
		  YREGular						///
		  XREGular						///
		  COLLABels(string asis)				///
		  NOLABels						///
		  SEParator(string)					///
		  EQSEParator(string)					///
		  NOSEParator						///
		  ALLSIMplelabels					///
		  NOSIMplelabels					///
		  FORMAT(string)					///
		  recast(string)					///
		  BYOPts(string asis)					///
		  BYOPTIONs(string asis)				///
		  HORIZontal						///
		  SCHEMEGrid						///
		  NAME(string asis)					///
		  PCYCle(integer -999)					///
		  ADDPLOT(string asis)					///
		  DEFY(namelist)					///
		  DEFX(namelist)					///
		  DEFTITLE(string asis)					///
		  DEFSUBTITLE(string asis)				///
		  DEFNOTE(string asis)					///
		  saving(string asis)					///
		  *							///
		]

	local byoptions `"`macval(byoptions)' `macval(byopts)'"'

	if "`allsimplelabels'" != "" & "`nosimplelabels'" != "" {
	   di as error "options {bf:allsimplelabels} and {bf:nosimplelabels} may not be specified together"
	   exit 198
	}
	local simple = 0 + ("`allsimplelabels'" != "") +		///
		       2 * ("`nosimplelabels'" != "")

	if "`yvalues'" != "" & "`yregular'" != "" {
		di as error "options {bf:yvalues} and {bf:yregular} may not be specified together"
		exit 198
	}
	if "`xvalues'" != "" & "`xregular'" != "" {
		di as error "options {bf:xvalues} and {bf:xregular} may not be specified together"
		exit 198
	}

	if `"`format'"' != `""' {
		confirm format `format'
	}

	tempname labonly
	.`labonly' = .null.new
	RelabelCols `labonly' : `macval(collabels)'

					// 0->any, 1->regular, 2->allvalues
	local ytype = cond("`yvalues'"!="", 2, cond("`yregular'"!="", 1, 0))
	local xtype = cond("`xvalues'"!="", 2, cond("`xregular'"!="", 1, 0))

					// fyi, yregular overrides nosimple


	if "`noseparator'" != "" {			// Overall separator
		local sep ""
	}
	else {
		if `"`separator'"'==`""' {
			local sep ", " 
		}
		else	local sep `"`separator'"'
	}

	local eqsep 
	if `"`eqseparator'"'==`""' {
		local eqsep "="
	}
	else	local eqsep `"`eqseparator'"'

							// Plot style cycling
	if (`pcycle' != -999) {
		if (`pcycle' <= 0)  local pcycle 1
		local plotswrap `pcycle'
	}

							// Default grid
	if "`schemegrid'" == "" {
		local griddef "ylabel(, grid) xlabel(, grid)"
	}

							// Titles and note
	if `"`deftitle'"' != `""' {
		local titleopt `"title(`macval(deftitle)')"'
	}
	if `"`defsubtitle'"' != `""' {
		local subtitleopt `"subtitle(`macval(defsubtitle)')"'
	}
	if `"`defnote'"' != `""' {
		MuliLineNote `"`defnote'"'
		local noteopt `"note(`macval(defnote)')"'
	}


	CheckRecast   `recast'

						// Parse dimension options
	local nolabels = "`nolabels'" != ""

	local defaults							///
		`"`nolabels' `simple' `"`sep'"' `"`eqsep'"' `"`format'"'"'

	ParseDim y  : `defaults' `ydimensions'		// Parse dimension 
	ParseDim x  : `defaults' `xdimensions'		// Parse dimension 
	ParseDim pl : `defaults' `plotdimensions'	// variables and options
	ParseDim by : `defaults' `bydimensions'			
	ParseDim gr : `defaults' `graphdimensions'


						// Set dimensions
	qui des , varlist
	local alllist `r(varlist)'

	local speclist `y' `x' `pl' `by' `gr'
	local speclist : list uniq speclist
	local freelist : list alllist - speclist

						// removed speced from defaults
	foreach dim in y x pl by gr {
		local defy : list defy - `dim'
		local defx : list defx - `dim'
	}

						// set dimensions
	if "`y'" == "" {
		local y `defy'
		local freelist : list freelist - y
	}
	if "`x'" == "" {
		local x `defx'
		local freelist : list freelist - x
	}

	if "`y'" == "" {
		if ("`x'" == "") {
			if `:list posof "N" in freelist' {
				local x "N"
				local freelist : list freelist - x
			}
		}

		SetIfMatch y : power "`freelist'"
		if ("`y'" == "") SetFirstFree y : "`freelist'"
	}

	if "`x'" == "" {
		SetIfMatch x : N "`freelist'"
		if ("`x'" == "") SetFirstFree x : "`freelist'"
	}

	if "`freelist'" != "" {
		if `"`macval(pl)'"' == `""' {
			local pl `freelist'
		}
		else if `"`macval(by)'"' == `""' {
			local by `freelist'
		}
		else	local pl : list pl | freelist

		local freelist
	}

	if "`x'" == "" | "`y'" == "" {
		di as error "must have both x and y dimensions"
		exit 198
	}

							// Make dimensions

	foreach dim in y x pl by gr {
		local ndim : list sizeof `dim'list

		tempvar `dim'var
		tempname `dim'lab
		MakeDim  ``dim'var' ``dim'lab' `dim'allval :	 	///
			 `dim' `"`macval(`dim'sep)'"'			///
			 `"`macval(`dim'eqsep)'"' ``dim'simple'		///
			 ``dim'nolabels' `"``dim'fmt'"'			///
			 `"`macval(`dim'labs)'"'			///
			 `"`macval(`dim'elabs)'"' :			///
			 `maxticks' "``dim'type'" `labonly' :		///
			 ``dim''
	}

							// Build graph command

	if "`horizontal'" == "" {
		local vlist `yvar' `xvar'
		local pltype = cond("`recast'" == "", "connected", "`recast'")
		local yangle "angle(0)"
		local xy "x"
		local yx "y"
	}
	else {
		local vlist `xvar' `yvar'
		local pltype = cond("`recast'" == "", "scatter", "`recast'")
		local angle "angle(0)"
		if `=inlist("`pltype'",					///
		             "area", "bar", "spike", "dropline", "dot")' {
			local vlist `yvar' `xvar'
			local horizopt "horizontal"
		}
		local xy "y"
		local yx "x"
	}

	if "`pl'" != "" {
		local legtitle `"title(`"`:var label `plvar''"', size(*.8))"'
	}

	if `"`addplot'"' != `""' {		// addplot() and order()
		local draw "nodraw"		// skip, Must draw to make top
		_parse expand addplot below : addplot , common(BELOW)

		if "`below_op'" == "below" {
			forvalues i = 1/`addplot_n' {
				local order `"`macval(order)' `i'"'
			}
			local addplot_offset = `addplot_n'
		}
	}
	else	local addplot_offset = 0

	local 0 `", `options'"'
	syntax [, PLOTOPts(string asis) * ]

	local k0 = 0 + 0`addplot_offset'
	local i = 0
	sum `plvar' , meanonly
	local k_pl = r(max)
	local sep ""

	local sep ""
	forvalues i = 1/`k_pl' {			// plots
		local i1 = `i' - 1
		local pstyle = mod(`i1', `plotswrap') + 1
		if `pcycle' == -999 {
			if floor(`i1' / `plotswrap') == 1 {
				local symopt "symbol(triangle)"
			}
			else if floor(`i1' / `plotswrap') == 2 {
				local symopt "symbol(square)"
			}
			else if floor(`i1' / `plotswrap') == 3 {
				local symopt "symbol(diamond)"
			}
			else if floor(`i1' / `plotswrap') == 4 {
				local symopt "symbol(x)"
			}
			else if floor(`i1' / `plotswrap') == 5 {
				local symopt "symbol(plus)"
			}
		}

		local plif "if `plvar' == `i'"

		local 0 `", `options'"'
		syntax [, PLOT`i'opts(string asis) * ]
		local plot `"`sep'`pltype' `vlist' `plif', pstyle(p`pstyle') `symopt' `horizopt' `plotopts' `plot`i'opts'"'
		local sep "|| "

		local order `"`macval(order)' `=`k0'+`i'' `"`:label (`plvar') `i''"'"'

		local mplots `"`mplots' `plot'"'
	}

	local graph `"twoway `mplots'"'

	if `"`addplot'"' != `""' {
		local ka = `k_pl'
		if "`below_op'" != "below" {
			forvalues i = 1/`addplot_n' {
				local order `"`macval(order)' `=`ka'+`i''"'
			}
		}
	}


	if (`k_pl' < 2 & `"`addplot'"' == `""') {
		local legend "legend(off)"
		local bylegend "legend(off)"
	}
	else {
		local legend `"legend(order(`macval(order)') `legtitle')"'
	}



							// Draw graphs
	sort `xvar'
	sum `grvar' , meanonly
	local n_gr = r(max)
	if `n_gr' > 1 {
		if `"`name'"' == `""' {
			local name "name(_mp_\`i', replace)"
		}
		else {
			local 0 `name'
			syntax [anything] [, replace]
			local name `"name(`anything'\`i', `replace')"'
		}

		if `"`saving'"' != `""' {
			local hold `macval(options)'
			local 0 `macval(saving)'
			syntax [anything] [, *]
			local saving `"saving(`anything'\`i', `options')"'
			local options `macval(hold)'
		}
	}
	else {
		local name `"name(`name')"'
		local saving `"saving(`macval(saving)')"'
	}

	if `"`addplot'"' != `""' {
		local saveadd `macval(saving)'
		local saving ""
	}


	tempfile marginsdata

	forvalues i = 1/`n_gr' {

		if `n_gr' > 1 {
			if `i' == 1 {
				local subtitleorig `"`macval(subtitleopt)'"'
			}
			local subtitleopt `"`macval(subtitleorig)' subtitle(`"`: label (`grvar') `i''"', suffix)"'
		}

		if (`"`macval(by)'"' != `""') {
			if `i' == 1 {
				local bytitle    `"`macval(titleopt)'"'
				local bynote     `"`macval(noteopt)'"'
			}
			local by `"by(`byvar' , `macval(bytitle)' `macval(subtitleopt)' `macval(bynote)' `bylegend' `macval(byoptions)')"'
			local titleopt ""
			local subtitleopt ""
			local noteopt ""
		}

		if ("`xfmt'" != "")  local xfmtopt "format(`xfmt')"
		if ("`yfmt'" != "")  local yfmtopt "format(`yfmt')"

		if `xallval' {
			qui levelsof `xvar' if `grvar' == `i'
			local xlabopt					///
			"`xy'label(`r(levels)', `angle' `xfmtopt' valuelabels)"
		}
		else {
			local xlabopt 					///
				"`xy'label(, `angle' `xfmtopt' valuelabels)"
		}

		if `yallval' {
			qui levelsof `yvar' if `grvar' == `i'
			local ylabopt					///
			"`yx'label(`r(levels)', `yangle' `yfmtopt' valuelabels)"
		}
		else {
			local ylabopt 					///
				"`yx'label(, `yangle' `yfmtopt' valuelabels)"
		}

		`graph' || `addplot' || if `grvar' == `i' ,		///
			    `titleopt' `subtitleopt' `noteopt'		///
			   `xlabopt' `xvlab' `ylabopt' `yvlab'		///
			   `macval(legend)' `griddef' 			///
			   /*`draw'*/ `name' `saving' `by' `macval(options)'
	}


end


program RelabelCols
	gettoken labonly  0 : 0
	gettoken colon    0 : 0

	gettoken varnm  0 : 0
	while `"`varnm'"' != `""' {
		capture confirm variable `varnm'
		local rc = _rc
		if ! `rc' {
			local rc : list sizeof `varnm'
		}
		
		if `rc' {
			di as error `"`varnm' not a column in the analysis."'
			exit 198
		}

		.`labonly'.Declare `varnm' = 1
		
		local zero `"`macval(0)'"'
		gettoken varlbl  0 : 0
		if `"`varlbl'"' == `""' & `"`macval(zero)'"' == `""'{
			label var `varnm' `"`varnm'"'
		}
		else	label var `varnm' `"`macval(varlbl)'"'

		gettoken varnm  0 : 0
	}
end

program ParseDim
	gettoken pfx      0 : 0
	gettoken colon    0 : 0
	gettoken nolabdef 0 : 0
	gettoken simpdef  0 : 0
	gettoken sepdef   0 : 0
	gettoken eqsepdef 0 : 0
	gettoken fmtdef   0 : 0

	syntax [anything] [, 						///
		  SEParator(string)					///
		  EQSEParator(string)					///
		  NOSEParator						///
		  LABels(string asis)					///
		  ELABels(string asis)					///
		  ALLSIMplelabels					///
		  NOSIMplelabels					///
		  NOLABels						///
		  FORMAT(string)					///
		]

	if `"`format'"' != `""' {
		confirm format `format'
	}

	if "`allsimplelabels'" != "" & "`nosimplelabels'" != "" {
	  di as error "options {bf:allsimplelabels} and {bf:nosimplelabels} may not be specified together"
	  exit 198
	}
	local simple = 0 + ("`allsimplelabels'" != "") +		///
		       2 * ("`nosimplelabels'" != "")

						// Make and check varlist
	foreach tok of local anything {
		IsDim `tok'
	}

	c_local `pfx' `:list clean anything'

							// Save options
	if "`noseparator'" != "" {
		local sep ""
	}
	else {
		if `"`separator'"'==`""' {
			local sep `"`sepdef'"'
		}
		else	local sep `"`separator'"'
	}

	if `"`eqseparator'"'==`""' {
		local eqsep `"`eqsepdef'"'
	}
	else	local eqsep `"`eqseparator'"'

	if `"`format'"'==`""' {
		local format `"`fmtdef'"'
	}

	c_local `pfx'sep   `"`macval(sep)'"'
	c_local `pfx'eqsep `"`macval(eqsep)'"'
	c_local `pfx'labs  `"`macval(labels)'"'
	c_local `pfx'elabs `"`macval(elabels)'"'
	c_local `pfx'simple = cond(`simple', `simple', `simpdef')
	c_local `pfx'nolabels = cond("`nolabels'" != "", 1, `nolabdef')
	c_local `pfx'fmt  `"`macval(format)'"'
end


program CheckRecast

	if `:word count `0'' > 1 {
		di as error `"recast(`0') not allowed"'
		exit 198
	}

	local a `"`0'"'
	local 0 `", `0'"'
	capture syntax [, scatter line connected area bar spike dropline dot ]
	if _rc {
		di as error `"recast(`a') not allowed"'
		exit 198
	}
end

program IsDim
	args nm

	qui des , varlist
	local vlist `r(varlist)'

	if ! `:list nm in vlist' {
		di as error "`nm' not a dimension in power results"
		exit 322
	}
end

program SetIfMatch
	gettoken dimnm 0 : 0
	gettoken colon 0 : 0
	gettoken try   0 : 0
	gettoken free  0 : 0

	local t "`try'"
	if `:list posof "`t'" in free' {
		local free : list free - t
		c_local freelist `free'
		c_local `dimnm' `t'
	}
	else	c_local `dimnm' 

end


program SetFirstFree
	gettoken dimnm 0 : 0
	gettoken colon 0 : 0
	gettoken free  0 : 0

/*
	if ! `:sizeof free' {
		di as error "No free variable for `dimnm' dimension"
		exit 198
	}
*/

	gettoken t free : free

	local free : list free - t
	c_local freelist `free'
	c_local `dimnm' `t'
end


program MakeDim
	gettoken dimvar   0 : 0
	gettoken dimlab   0 : 0
	gettoken allval   0 : 0
	gettoken colon    0 : 0
	gettoken dim      0 : 0
	gettoken sep      0 : 0
	gettoken eqsep    0 : 0
	gettoken simple   0 : 0
	gettoken nolab    0 : 0
	gettoken fmtspec  0 : 0
	gettoken labels   0 : 0
	gettoken elabels  0 : 0
	gettoken colon    0 : 0
	gettoken maxticks 0 : 0
	gettoken typesig  0 : 0
	gettoken labonly  0 : 0
	gettoken colon    0 : 0

	local 0 `0'
	local k : list sizeof 0

	if `k' == 0 {					// No variables
		qui gen byte `dimvar' = 1
		label var `dimvar' "No `dim' dimension"

		exit						// Exit
	}

	tempvar tag revtag
	qui by `0', sort: gen byte `tag' = _n==1
	qui gen byte `revtag' = !`tag'


							// Continuous & allvals

						// x or y and k < 1
	capture confirm numeric variable `0'
	if inlist("`dim'", "x", "y") & `k' == 1 & _rc == 0 {
		qui clonevar `dimvar' = `0'

								// var label
		if ! 0`.`labonly'.`0'' {
			local eqlab : char `0'[symlabel]
		}
		local lab : var label `0'
		if `"`macval(eqlab)'"' != `""' & `"`macval(lab)'"' != `""' {
			label var `dimvar' `"`macval(lab)' (`macval(eqlab)')"'
		}
		else if `"`macval(eqlab)'"' == `""' {
			if `"`macval(lab)'"' == `""' {
				label var `dimvar' "`0'"
			}
			else	label var `dimvar' `"`macval(lab)'"'
		}
		else	label var `dimvar' `"`macval(eqlab)'"'

		if `typesig' == 0 {				// default
			if "`dim'" == "y" {
				local typesig 1			// regular grid
			}
			else {
				qui count if `tag'
				if `r(N)' <= `maxticks' {
					local typesig 2		// all values
				}
				else	local typesig 1
			}
		}

		c_local `allval' = (`typesig' == 2)

		if `nolab' {
			label values `dimvar' 
			exit					// Exit
		}
		else {
			if "`:value label `dimvar''" != "" {
				label copy `:value label `dimvar'' `dimlab'
			}
			label values `dimvar' `dimlab'
		}

		if `"`labels'"' != `""' {
			qui levelsof `dimvar' if `tag'
			local levs `r(levels)'

			capture numlist "`levs'", integer
			if _rc {
				"may not use labels() with non integer data"
				exit 198
			}

			foreach val of local levs {
				gettoken lab : labels labels
				label define `dimlab' `val' `"`lab'"' , add
			}
		}

		if `"`elabels'"' != `""' {
			label define `dimlab' `macval(elabels)' , modify
		}


		exit						// Exit
	}

						// pl, by, gr, or k > 1

	sort `revtag' `0'				// Dim variable
	qui gen `c(obs_t)' `dimvar' = _n if `tag'
	c_local `allval' = 1
		
	if `k' == 1 {					// variable label
		if ! 0`.`labonly'.`0'' {
			local eqlab : char `0'[symlabel]
		}
		local lab : var label `0'
		if `"`macval(eqlab)'"' != `""' & `"`macval(lab)'"' != `""' {
			label var `dimvar' `"`macval(lab)' (`macval(eqlab)')"'
		}
		else if `"`macval(eqlab)'"' == `""' {
			if `"`macval(lab)'"' == `""' {
				label var `dimvar' "`0'"
			}
			else	label var `dimvar' `"`macval(lab)'"'
		}
		else	label var `dimvar' `"`macval(eqlab)'"'
	}
	else {
		forvalues i=1/`k' {
			local var : word `i' of `0'
			local msep 
			if `i'==1 {
				local msep ""
			}
			else	local msep `"`sep'"'

			if ! 0`.`labonly'.`var'' {
				local eqlab : char `var'[symlabel]
			}
			if `"`macval(eqlab)'"' == `""' {
				local vlab : var label `var'
				if `"`macval(vlab)'"' == `""' {
					local lab `"`lab'`msep'`var'"'
				}
				else	local lab `"`lab'`msep'`macval(vlab)'"'
			}
			else	local lab `"`lab'`msep'`macval(eqlab)'"'
		}
		label variable `dimvar' `"`macval(lab)'"'
	}

							// value labels
	qui count if `tag'				
	forvalues i = 1/`=r(N)' {
		local lab ""
		local j 0
		foreach var of local 0 {
			if `++j' > 1 {
				local lab `"`lab'`sep'"'
			}

			local vlab : var label `var'
			if ! 0`.`labonly'.`var'' {
				local eqlab : char `var'[symlabel]
			}
			if `"`macval(eqlab)'"' == `""' {
				local eqlab `"`macval(vlab)'"'
			}
			if `"`macval(vlab)'"' == `""' {
				local vlab "`var'"
			}

			if "`fmtspec'" == "" {
				local fmt :format `var'
			}
			else	local fmt "`fmtspec'"

			local islabeled =				///
			      ("`:value label `var''" != "") &		///
			      !`nolab'
			local olab = `islabeled'
			if `simple' == 2 | 				///
			   (`simple' == 0 & 				///
			    (!`olab' & 					///
			     !inlist("`dim'", "x", "y", "pl"))) {
				local lab `"`lab'`macval(eqlab)'`eqsep'"'
			}

			if `nolab' {
				local value = 				///
				      strofreal(`var'[`i'], "`fmt'")
			}
			else {
				if `islabeled' {
				      local value : label (`var') `=`var'[`i']'
				}
				else {
				      local value = 			///
					strofreal(`var'[`i'], "`fmt'")
				}
			}
			local lab `"`lab'`value'"'
		}
		label define `dimlab' `i' `"`lab'"' , add
	}

	if `"`labels'"' != `""' {
		label drop `dimlab'
		local i 0
		foreach lab of local labels {
			label define `dimlab' `++i' `"`macval(lab)'"' , add
		}
	}

	if `"`elabels'"' != `""' {
		label define `dimlab' `macval(elabels)' , modify
	}


	label values `dimvar' `dimlab'

	qui by `0' (`tag'), sort:  replace `dimvar' = `dimvar'[_N]


end

program MuliLineNote
	args orinote
	/* break a long note into several lines*/
	// substitute non-delimiter "," by " _" first
	// then break the lines at the previous delimiter , when a line holds
	// more than 107 characters at the current delimiter
	// a line can hold at most 106 characters if the 106th char is ,
	local tempnote `"`orinote'"'
	while (regexm(`"`tempnote'"', ".*([0-9],[0-9]).*")) {
             local match = regexs(1)
             local match_2 = subinstr( `"`match'"', ",", "_", .)
	     local tempnote = subinstr(`"`tempnote'"', ///
			"`match'", "`match_2'", .)

	}
	
	local disbreak 107
	local predisl_br 0
	local predisl 0
	local prepos 1
	local count 1
	local prel -2
	local i 1
	local tempnote `"`tempnote', "'
	while (strpos(`"`tempnote'"', ",")) {
                local l = strpos(`"`tempnote'"', ",")
                local tempnote = subinstr(`"`tempnote'"', ",", " ", 1)
                local tempstr = bsubstr(`"`tempnote'"', 1, `l'+1)
                local disl : graphsmcllength local tempstr 
		// assume two consecutive comma <`disbreak'
		if (`disl'-`predisl' > `disbreak') exit
                else if ( `disl'-`predisl_br' > `disbreak' & ///
			!(`l'==strlen(`"`tempnote'"')-1 & ///
			 `disl'-`predisl_br' == `disbreak'+1)){
				local predisl_br = `predisl'
				local line`count' = substr(`"`orinote'"', ///
					`prepos', `prel'+2-`prepos')
				local prepos = `prel' + 3
				local ++count
		}	
                local predisl = `disl'
                local prel = `l'
	}

	local line`count' = substr(`"`orinote'"', `prepos', .)
	local allnote `"`line1'"'

	forvalues i=2/`count' {
		local allnote `"`allnote'"' `"`line`i''"'
	}

	c_local defnote `"`allnote'"'

end

exit


