*! version 1.1.5  17dec2018
program irtgraph
	version 14

	if `"`e(cmd2)'"' != "irt" {
		error 301
	}

	_irtrsm_check
	
	gettoken sub rest : 0
	gettoken sub c : sub, parse(",")
	local rest `c' `rest'

	if `"`sub'"' == "," {
		dis as err "subcommand expected"
		exit 198
	}
	else if `"`sub'"' == "" {
		dis as err "subcommand expected"
		exit 321
	}
	else if !inlist("`sub'","icc","tcc","iif","tif") {
		dis as err `"invalid subcommand `sub'"'
		exit 321
	}

	_parse expand cmd op : rest
	_parse canon 0 : cmd op

	_`sub' `0'
end

program _icc
	syntax [anything] [, *]
	_gr_main `anything', `options' icc(1)
end

program _tcc
	syntax [, *]
	_gr_main, `options' tcc(1)
end

program _iif
	syntax [anything] [, tif *]
	local ti = !missing("`tif'")
	if `ti' & !missing("`anything'") {
		di as err "varlist not allowed with option {bf:tif}"
		exit 198
	}
	if `ti' & "`e(groupvar)'" != "" {
		di as err "option {bf:tif} not allowed with group IRT models"
		exit 198
	}
	_gr_main `anything', `options' iinfo(1) tinfo(`ti')
end

program _tif
	syntax [, *]
	_gr_main , `options' tinfo(1)
end

program _gr_main, rclass
	syntax [anything] [, 					///
		addplot(passthru) 				///
		icc(passthru)					///
		tcc(integer 0)					///
		iinfo(passthru) 				///
		tinfo(integer 0)				///
		*]

	// separate out global twoway options and global location options

	__parse_opts, `options' `icc' giverr
	local hasxglloc `s(hasxloc)'
	local glxlocopts `s(xlocopts)'
	local glxlpattern `s(xlpattern)'
	local hasyglloc `s(hasyloc)'
	local glylocopts `s(ylocopts)'
	local glylpattern `s(ylpattern)'
	local glrange `s(range)'
	local glopts `s(opts)'
	local glbcc `s(bcc)'
	local glccc `s(ccc)'

	if missing("`icc'") {
		if `glbcc' {
			di as err "option {bf:bcc} not allowed"
			exit 198
		}
		if `glccc' {
			di as err "option {bf:ccc} not allowed"
			exit 198
		}
	}

	if missing(`"`anything'"') {
		local items `e(item_list)'
		foreach i of local items {
			local anything `anything' (`i')
		}
	}

	local group `e(groupvar)'
	local hasgr = "`group'" != ""
	local gr_levels `e(group_levels)'
	local gr_labels `"`e(group_labels)'"'
	local gr_inv `e(gr_invariant)'

	// for irtgraph icc, separate items into their own equations
	// for binary items, b is converted to 1.b, i.b to 0.b and 1.b
	// for polytomous items, p and i.p are both converted to base.p ... k.p

	_parse expand eqninfo left : anything
	local k_0 = `eqninfo_n'
	local item_list `e(item_list)'
	local item_list_gr `e(item_list_gr)'
	local anything
	local ilist
	local gr_ilist

	tempname fvmat
	local items_fv `e(item_list_fv)'
	local nn : list sizeof items_fv
	mata: st_matrix(st_local("fvmat"),J(1,`nn',0))
	mat colnames `fvmat' = `items_fv'

	forvalues i = 1/`k_0' {
		local gr_eq = strpos(`"`eqninfo_`i''"',":")
		local gr_id
		
		if `gr_eq' {
			if !`hasgr' {
				di as err "group equation not allowed with non-group irt model"
				exit 198
			}
			
			local junk : subinstr local eqninfo_`i' ":" ":", all count(local cc)
			if `cc' > 1 {
				di as err `"invalid {bf:`eqninfo_`i''}"'
				exit 198
			}
			
			local gr_id = usubstr(`"`eqninfo_`i''"',1,`gr_eq'-1)
			local gr_id = trim("`gr_id'")
			if `=`: list sizeof gr_id'' > 1 {
				di as err `"invalid {bf:`eqninfo_`i''}"'
				exit 198
			}
			local gr_ok : list posof "`gr_id'" in gr_levels
			if !`gr_ok' {
				di as err "invalid group level {bf:`gr_id'}"
				exit 198
			}
			
			local eqninfo_`i' = usubstr(`"`eqninfo_`i''"',`gr_eq'+1,.)			
		}
		
		if `hasgr' & "`gr_id'" == "" {
			local gr_id `gr_levels'
		}
		
		gettoken items opts : eqninfo_`i', parse(",")	

		local 0 `opts'
		syntax [, bcc ccc BLOcation1 BLOcation2(passthru) 	///
			PLOcation1 PLOcation2(passthru) *]
		local opts `options'
		local locop `blocation1' `blocation2' `plocation1' `plocation2'

		__cc_check, `bcc' `ccc' `blocation1' `plocation1' ///
				`blocation2' `plocation2'

		local ibcc = !missing("`bcc'`blocation1'`blocation2'")
		local ibcc = `ibcc' | !missing("`plocation1'`plocation2'")
		local ibcc = `ibcc' | `glbcc'
		
		local iccc = !missing("`ccc'")
		local iccc = `iccc' | `glccc'
		
		if `ibcc' {
			if `glbcc' & !missing("`ccc'") {
				local ibcc 0
				local bcc
			}
			else local bcc bcc
		}
		if `iccc' {
			if `glccc' & !missing("`bcc'") {
				local iccc 0
				local ccc
			}
			else local ccc ccc
		}

		_unab `items', mat(`fvmat')
		local items `r(varlist)'

		local items : subinstr local items "b." ".", all

		foreach j of local items {
		
			local gg_id `gr_id'
		
			_ms_parse_parts `j'
			if "`r(type)'"=="variable" {
				// need to capture in case varname
				// is at its maximum allowed length
				capture local `j' : subinstr local j "i." "."
				local pos : list posof "`j'" in item_list
				local m: word `pos' of `e(model_list)'
				if inlist("`m'","1pl","2pl","3pl") & !`iccc' {
					local j 1.`j'
				}
				else {
					_unab i.`j', mat(`fvmat')
					local j `r(varlist)'
					local j : subinstr local j "b." ".", all		
				}
			}
			// for bcc probabilities, drop base categories
			if `ibcc' {
				tempname base
				mat `base' = e(base)
				foreach k of local j {
					_ms_parse_parts `k'
					local min = `base'[1, ///
						colnumb(`base',"`r(name)'")]
					if `r(op)'==`min' local sub `sub' `k'
				}
				local j : list j - sub
			}
			
			// to be group invariant, a given item must be
			// present across all groups....
			
			local ilist `ilist' `j'
			foreach gg of local gr_id {
				foreach k of local j {
					local dot = strpos("`k'",".") +1
					local tt = substr("`k'",`dot',.)
					local ok : list posof "`gg':`tt'" in item_list_gr
					if `ok' {
						local gr_ilist `gr_ilist' `gg':`k'
					}
					else local gg_id : list gg_id - gg
				}
			}
			
			// .... and must be in e(gr_invariant), which already
			// guarantees the item is of same model type
			foreach k of local j {
				if `hasgr' {
					local dot = strpos("`k'",".") +1
					local tt = substr("`k'",`dot',.)
					local ok : list posof "`tt'" in gr_inv
					if `tcc' | `tinfo' local ok 0
					if "`gg_id'" == "`gr_levels'" & `ok' {
gettoken gg : gr_id
local anything `anything' (`gg':`k', `opts' `bcc' `ccc' `locop' grinv)
					}
					else {
						foreach gg of local gr_id {
							local g : list posof "`gg'" in gr_levels
							local glist `e(m`g'_item_list_fv)'
							local hasit : list k & glist
							if "`hasit'" != "" {
local anything `anything' (`gg':`k', `opts' `bcc' `ccc' `locop')
							}
						}
					}
				}
				else {
					local anything `anything' (`k', `opts' `bcc' `ccc' `locop')
				}
			}
		}
	} // end of forvalues

	foreach i of local ilist {
		gettoken junk item : i, parse(".")
		local mylist `mylist' `item'
	}
	local ilist : subinstr local mylist "." "", all
	local ilist : list uniq ilist

	if missing("`ilist'") {
		di as txt "(nothing to draw)"
		exit 0
//		di as err "varlist evaluated to an empty list, nothing to draw"
//		exit 198
	}

	local mylist
	foreach i of local gr_ilist {
		gettoken gg i : i, parse(":")
		gettoken junk item : i, parse(".")
		local mylist `mylist' `gg':`item'
	}
	local gr_ilist : subinstr local mylist "." "", all
	local gr_ilist : list uniq gr_ilist

	local tcc tcc(`tcc')
	local tinfo tinfo(`tinfo')

	// ready to create graphs
	capture noisily _plot_icc `anything', `glopts' 			///
		hasxglloc(`hasxglloc') glxlocopts(`glxlocopts') 	///
		glxlpattern(`glxlpattern') hasyglloc(`hasyglloc') 	///
		glylocopts(`glylocopts') glylpattern(`glylpattern')	///
		glrange(`glrange') hasrange(`glrange') ilist(`ilist')	///
		 `addplot' `icc' `tcc' `iinfo' `tinfo' fvmat(`fvmat')	///
		 gr_ilist(`gr_ilist')
	__drop_mata_tempnames `matanames'

	return add
end

program _plot_icc, rclass

	syntax [anything] [, icc(integer 0) tcc(integer 0) iinfo(integer 0) ///
		tinfo(integer 0) n(numlist max=1 integer >=2) 		  ///
		data(string asis) fvmat(string) hasrange(string) *]

	if missing("`anything'") {
		di as txt "(nothing to draw)"
		exit 0
	}

	preserve

	local group `e(groupvar)'
	local hasgr = "`group'" != ""
	local gr_levels `e(group_levels)'
	local gr_labels `"`e(group_labels)'"'

	if `hasgr' {
		local item_list `e(item_list_gr)'
		local model_list `e(model_list_gr)'
	}
	else {
		local item_list `e(item_list)'
		local model_list `e(model_list)'
	}

	local 0 `anything', tcc(`tcc') iinfo(`iinfo') tinfo(`tinfo') `options'

	local score_ix 0
	local theta_ix 0

	if `tcc' {
		local i 1
		local 0 , `options'
		syntax , [SCorelines(passthru) THetalines(passthru) *]
		while !missing("`scorelines'`thetalines'") {
			if !missing("`scorelines'") {
				local ++score_ix
				local scorelines`i' `scorelines'
			}
			if !missing("`thetalines'") {
				local ++theta_ix
				local thetalines`i' `thetalines'
			}
			local ++i
			local 0 , `options'
			syntax , [SCorelines(passthru) THetalines(passthru) *]
		}
		local 0 `anything' `0' tcc(`tcc')
	}

	syntax [anything] [, SE1 SE2(string) *]
	local se_add = !missing("`se1'`se2'")
	if `icc' | `tcc' | `iinfo' {
		if `se_add' {
di as err "option {bf:se()} allowed only with irtgraph tif"
exit 198
		}
	}
	
	local 0 `anything', `options' score_ix(`score_ix') theta_ix(`theta_ix')
	syntax anything [, 						  ///
		hasxglloc(string) glxlocopts(string) glxlpattern(string)  ///
		hasyglloc(string) glylocopts(string) glylpattern(string)  ///
		glrange(string) ilist(string) addplot(string asis)	  ///
		ICC1(string) IINFO1(string) TINFO1(string) TCC1(string)	  ///
		score_ix(integer 0) theta_ix(integer 0) gr_ilist(string) *]

	// separate out global twoway options
	_get_gropts, graphopts(`options' addplot(`addplot')) gettwoway 	///
		getallowed(LEGend addplot)
	local gltwopts `s(twowayopts)'
	local twopts `s(graphopts)'
	local legend `"`s(legend)'"'

	local addplot `"`s(addplot)'"'
	__get_add_n, addplot(`addplot')
	local add_n `s(add_n)'
	local addplot `addplot' ||

	if !`tcc' {
		if `score_ix' {
			di as err "option {bf:scorelines()} not allowed"
			exit 198
		}
		if `theta_ix' {
			di as err "option {bf:thetalines()} not allowed"
			exit 198
		}
	}
	
	// check global graph options

	_get_gropts, graphopts(`gltwopts') getallowed(XLABel YLABel ///
		XTItle YTItle TItle)
	local xlabel `s(xlabel)'
	local ylabel `s(ylabel)'
	local xtitle `"`s(xtitle)'"'
	local ytitle `"`s(ytitle)'"'
	local title `"`s(title)'"'
	local gltwopts `s(graphopts)'
	
	// get coefficients etc
	tempname coefs bases lasts ncut b_min b_max m
	mat `bases' = e(base)
	mat `lasts' = e(last)

	qui estat report, seqlabel verbose

	mat `coefs' = r(b)
	local a_p `r(alabel)'
	local b_p `r(blabel)'
	local c_p `r(clabel)'

	_parse expand eqninfo opts : anything
	local k_0 = `eqninfo_n'

	// calculate the default range of the x-axis

	__get_range, ilist(`ilist') glrange(`glrange') 	///
		iinfo(`iinfo') tinfo(`tinfo') tcc(`tcc') ///
		gr_ilist(`gr_ilist')
	local min `s(min)'
	local max `s(max)'
	
	local w0 0
	local y_min 0
	local y_max 0
	foreach g of local gr_levels {
		local y_max`g' 0
		local w0_`g' 0
	}

	if `hasgr' local ilist `gr_ilist'

	local nn : list sizeof item_list
	mat `ncut' = J(1,`nn',0)
	mat colnames `ncut' = `item_list'

	foreach i of local ilist {
		local pos : list posof "`i'" in item_list
		if (`pos' == 0) {
			continue
		}
		local model: word `pos' of `model_list'

		if inlist("`model'","pcm","gpcm","rsm") local md 2
		else if inlist("`model'","nrm")	  local md 1
		else local md 0
		
		if `hasgr' {
			gettoken gg i : i, parse(":")
			local gix `gg'
			local grr `gg'
			gettoken junk i : i, parse(":")
		}
		else local gix .
		
		_unab i.`i', mat(`fvmat')
		local iis `r(varlist)'
		local iis : subinstr local iis "b." ".", all
		local cuts : list sizeof iis
		mat `m' = J(`cuts',1,0)
		local j 0
		foreach k of local iis {
			local ++j
			local ii : word `j' of `iis'
			gettoken ii : ii, parse(".")
			mat `m'[`j',1] = `ii'
		}
		local --cuts
		mat `ncut'[1,`pos'] = `cuts'
		local r = rowsof(`m')
		if `gix' == . {

			if `md' local abc `abc' `md' `=`m'[1,1]' 0 0 0 `gix'
			else local w0 = `w0' + `m'[1,1]
		}
		else {
			if `md' local abc `abc' `md' `=`m'[1,1]' 0 0 0 `gix'
			else local w0_`gg' = `w0_`gg'' + `m'[1,1]
		}

		local y_min = `y_min' + `m'[1,1]

		local c = `coefs'[1,colnumb(`coefs',"`i':`c_p'")]
		if missing(`c') local c = 0

		forvalues j = 1/`cuts' {
			if inlist("`model'","1pl","2pl","3pl") {
				if `hasgr' {
					local jj `gg'.`group'#c.
				}
				local aname `i':`jj'`a_p'
				local bname `i':`jj'`b_p'
			}
			else if inlist("`model'","nrm") {
				if `hasgr' {
					local jj `gg'.`group'#
				}
				local aname `i':`jj'`j'.`a_p'
				local bname `i':`jj'`j'.`b_p'
			}
			else {
				if `hasgr' {
					local jja `gg'.`group'#c.
					local jjb `gg'.`group'#
				}
				local aname `i':`jja'`a_p'
				local bname `i':`jjb'`j'.`b_p'
			}

			local a = `coefs'[1,colnumb(`coefs',"`aname'")]
			local b = `coefs'[1,colnumb(`coefs',"`bname'")]

			if `md' local w = `m'[`j'+1,1]
			else local w = `m'[`j'+1,1] - `m'[`j',1]

			local abc `abc' `md' `w' `a' `b' `c' `gix'
		}
		local y_max`grr' = `y_max`grr'' + `m'[`cuts'+1,1]
	}

	if `score_ix' | `theta_ix' {
		forvalues i = 1/`score_ix' {
			local 0 , `scorelines`i''
			syntax , SCORElines(string)
			__tcc_pci_opts `scorelines'
			local e_num`i' `s(num)'
			local e_pci`i' `s(pci)'
			local e1_draw`i' `s(e_draw)'
			local t1_draw`i' `s(t_draw)'
			local gr1_id`i' `s(gr_id)'
		}
		forvalues i = 1/`theta_ix' {
			local 0 , `thetalines`i''
			syntax , THETAlines(string)
			__tcc_pci_opts `thetalines'
			local t_num`i' `s(num)'
			local t_pci`i' `s(pci)'
			local e2_draw`i' `s(e_draw)'
			local t2_draw`i' `s(t_draw)'
			local gr2_id`i' `s(gr_id)'
		}
		mata: __tcc_pci_fast()
		local min = scalar(min)
		local max = scalar(max)
	}

	local glrange range(`min' `max')

	if missing("`n'") local n 300
	local OBS = `n'
	qui count
	if `OBS' > `r(N)' qui set obs `OBS'
	tempvar Theta
	qui gen double `Theta' = `min'+(`max'-`min')*(_n-1)/(`OBS'-1)
	qui replace `Theta' = . if _n>`OBS'
	label var `Theta' "Theta"

	local save_vars `Theta'
	local save_names theta

	// dive into creating graphs

	local LL 1			// label counter
	local DD 1			// counter for omitted labels
	local sty 1			// pstyle counter, cycles 1 to 15

	if `tcc' | `tinfo' {
		if `hasgr' {
			foreach g of local gr_levels {
				tempvar YY`g'
				qui gen double `YY`g'' = 0
				local YY `YY' `YY`g''
				
				local gg `"`e(grlabel`g')'"'
				if `"`gg'"' == "`g'" {
					local gg ", `gg'.`group'"
				}
				else local gg `", `gg'"'
				
				if `tcc' label var `YY`g'' `"Expected score`gg'"'
				else {
					qui replace `YY`g'' = 1
					label var `YY`g'' `"Test information`gg'"'
					if `se_add' {
						tempvar se`g'
						qui gen double `se`g'' = .
						local se `se' `se`g''
						label var `se`g'' `"Standard error`gg'"'
					}
				}
			}
		}
		else {
			tempvar YY
			qui gen double `YY' = 0
			if `tcc' label var `YY' "Expected score"
			else {
				qui replace `YY' = 1
				label var `YY' "Test information"
				if `se_add' {
					tempvar se
					qui gen double `se' = .
					label var `se' "Standard error"
				}
			}
		}
	}

	tempname yxmat
	c_local matanames `yxmat'
	mata: `yxmat' = J(`k_0',2,.)

	local bini 0
	local cati 0
	local bcci 0
	local ccci 0
	local icc_k 0
	local iif_k 0
	local iif_prev
	local grinv_k 0

	tempname m tmpfvmat tmpbases
	local VAR 0

	forvalues i = 1/`k_0' {
		local 0 `eqninfo_`i''
		syntax anything [, bcc ccc			///
			XLOCations1 XLOCations2(string) 	///
			YLOCations1 YLOCations2(string) 	///
			BLOcation1 BLOcation2(string) 		///
			PLOcation1 PLOcation2(string) 		///
			grinv *]

		__parse_opts, icc(`icc') `bcc' `ccc'		 ///
			`xlocations1' xlocations2(`xlocations2') ///
			`ylocations1' ylocations2(`ylocations2') ///
			`blocation1' blocation2(`blocation2') 	 ///
			`plocation1' plocation2(`plocation2')	 ///
			__sub
		local hasxloc `s(hasxloc)'
		local xlocopts `s(xlocopts)'
		local hasyloc `s(hasyloc)'
		local ylocopts `s(ylocopts)'
		
		local item `anything'
		local itemnames `itemnames' `item'

		local bcc = !missing("`bcc'")
		local ccc = !missing("`ccc'")

		if `hasxloc' | `hasxglloc' | `hasyloc' | `hasyglloc' {
			local bcc 1
		}

		_get_gropts, graphopts(`options') gettwoway	///
			getallowed(XLABel YLABel XTItle YTItle TItle LEGend)
		if !missing(`"`s(xlabel)'"') local inxlabel `s(xlabel)'
		if !missing(`"`s(ylabel)'"') local inylabel `s(ylabel)'
		if !missing(`"`s(xtitle)'"')  local inxtitle `"`s(xtitle)'"'
		if !missing(`"`s(ytitle)'"') local inytitle `"`s(ytitle)'"'
		if !missing(`"`s(title)'"') local intitle `"`s(title)'"'
		if !missing(`"`s(legend)'"') local inlegend `"`s(legend)'"'
		local ingltwopts `ingltwopts' `s(twowayopts)'
		local opts `s(graphopts)'

		local xlpat `glxlpattern' `s(xlpattern)'
		if missing("`xlpat'") local xlpat

		local ylpat `glylpattern' `s(ylpattern)'
		if missing("`ylpat'") local ylpat

		if `hasgr' {
			gettoken gg item : item, parse(":")
			gettoken junk item : item, parse(":")
			local w : list posof "`gg'" in gr_levels
			local tmplist `e(m`w'_item_list_fv)'
			mat `tmpfvmat' = e(m`w'_fvmat)
		}
		else {
			local tmplist `e(item_list_fv)'  //`tmplist' `item_list_fv'
			mat `tmpfvmat' = `fvmat'
			mat `tmpbases' = `bases'
		}

		local pos : list posof "`item'" in tmplist
		
		if (`pos' == 0) {
			continue
		}
		
		gettoken junk tmp : item, parse(".")
		local tmp : subinstr local tmp "." ""
		
		if `hasgr' {
			local e_item_list `e(item_list)'
			local jj : list posof "`tmp'" in e_item_list	
			mat `tmpbases' = e(m`w'_`jj'_levels)
			local tmp `gg':`tmp'
		}
		
		local pos : list posof "`tmp'" in item_list
		
		local model : word `pos' of `model_list'
		local cuts = `ncut'[1,`pos']	

		if `iinfo' {
			local pos : list posof "`tmp'" in iif_prev
			if `pos' == 0 {
				local ++iif_k
				local ++VAR
				local iif_prev `iif_prev' `tmp'
				tempvar y`VAR'
				qui gen double `y`VAR'' = 0
				local save_vars `save_vars' `y`VAR''
				local save_names `save_names' iif`VAR'
				local save_vars_iif `save_vars_iif' `y`VAR''
				local iif_ops`VAR' `twopts' `opts'
				local y `y`VAR''
			}
			else local y `y`pos''
		}
		else if `tinfo' | `tcc' {
			local y `YY`gg''
		}
		else { // icc
			local ++icc_k
			local ++VAR
			tempvar y`VAR'
			qui gen double `y`VAR'' = 0
			local save_vars `save_vars' `y`VAR''
			local save_names `save_names' icc`VAR'
			local save_vars_icc `save_vars_icc' `y`VAR''
			local y `y`VAR''
		}
		
		if "`grinv'" == "grinv" local ++grinv_k

		__get_f, model(`model') item(`item') coefs(`coefs') 	///
			bases(`tmpbases') lasts(`lasts')		///
			ix(`VAR') cuts(`cuts') icc(`icc')		///
			tcc(`tcc') iinfo(`iinfo') tinfo(`tinfo')	///
			ap(`a_p') bp(`b_p') cp(`c_p') 			///
			bcc(`bcc') ccc(`ccc') y(`y') x(`Theta')		///
			fvmat(`tmpfvmat') group(`gg') grinv(`grinv')

		local bini = `bini' | `s(bini)'
		local cati = `cati' | `s(cati)'
		local bcci = `bcci' | `s(bcci)'
		local ccci = `ccci' | `s(ccci)'

		local b `s(b)'
		local b_hi `s(b_hi)'
		local ilab `"`s(ilab)'"'
		if `icc' | `iinfo' {
			local vlab`VAR' `"`s(vlab)'"'
			label var `y`VAR'' `"`s(ilab)'"'
		}

		local linelist `linelist' `b'
		local lstyle lstyle(p`sty')

		local flist `macval(flist)' ///
			( line `y`VAR'' `Theta' , `twopts' `opts' `lstyle')

		local order `order' `LL'
		local ++LL
		local ++DD
		if !`tcc' local ++sty
		if `tinfo' & !`iinfo' local --sty
		if `sty' > 15 local sty 1

		if `hasxglloc' | `hasxloc' {
			local g pci `b_hi' `b' 0 `b', ///
				`lstyle' `glxlocopts' `xlpat' `xlocopts'
			local dlist `dlist' ( `g' )
			local xlist `xlist' `b'
			local ++DD
		}

		if `hasyglloc' | `hasyloc' {
			local itm : subinstr local item "." "_"
			local yopts_`itm' `lstyle' `glylocopts' `ylpat' ///
				`ylocopts'

			if "`model'"=="3pl" {
				local ylist_3pl `ylist_3pl' `b_hi'
				local xlist_3pl `xlist_3pl' `b'
				local items_3pl `items_3pl' `item'
			}
			else local ylist `ylist' `b'

			local x `b'
			local y `b_hi'
			mata: `yxmat'[`i',1] = `y'
			mata: `yxmat'[`i',2] = `x'
			local ylist `ylist' `y'
		}
	}

	if `iinfo' {
		local flist
		local order
		local sty 1
		local LL 1
		forvalues i = 1/`VAR' {
			local lstyle lstyle(p`sty')
			local flist `macval(flist)' ///
				( line `y`i'' `Theta' , `iif_ops`i'' `lstyle')
			local ++sty
			if `sty' > 15 local sty 1
			local ++LL
			label var `y`i'' "`vlab`i''"
			if `tinfo' {
				if `hasgr' {
di as err "option {bf:tif} not allowed with group IRT models"
exit 198
				}
				else qui replace `YY' = `YY' + `y`i''

			}
		}
		local DD = `LL'-1
	}

	if !missing("`xlist'") {
		local xlist : list uniq xlist
		local xlist : list sort xlist
		
		local minx : word 1 of `xlist'
		local maxx : word `:list sizeof xlist' of `xlist'
		local one = `: list sizeof xlist' - 1
		
		if `minx' < `min' local min `minx'
		if `maxx' > `max' local max `maxx'
		
		local xvals `xlist'
		if abs( (`min'-`minx')/(`max'-`min') ) > .05 {
			local xvals `min' `xvals'
		}
		if abs( (`max'-`maxx')/(`max'-`min') ) > .05 {
			local xvals `xvals' `max'
		}		
	}

	if `icc' {
		if missing("`ylist'") local yvals 0 .5 1
		else local yvals 0 1
	}

	mata: __get_ypcis(`yxmat')
	local ypci `ypci'
	local yvals `yvals' `ylab'

	if `tcc' {
		local flist
		local save_vars `save_vars' `YY'
		if `hasgr' {
			local ix 0
			foreach v of local YY {
				local ++ix
				local save_names `save_names' tcc`ix'
			}
		}
		else local save_names `save_names' tcc
	}

	if `score_ix' | `theta_ix' {
		forvalues i = 1/`score_ix' {
			local 0 , `scorelines`i''
			syntax , SCORElines(string)
			__tcc_pci_opts `scorelines'
			local e_num`i' `s(num)'
			local e_pci`i' `s(pci)'
			local gr1_id`i' `s(gr_id)'
		}
		forvalues i = 1/`theta_ix' {
			local 0 , `thetalines`i''
			syntax , THETAlines(string)
			__tcc_pci_opts `thetalines'
			local t_num`i' `s(num)'
			local t_pci`i' `s(pci)'
			local gr2_id`i' `s(gr_id)'
		}
		mata: __tcc_pci()
		local th_n = scalar(t_n)
		local sc_n = scalar(e_n)
	}
	else {
		local th_n 0
		local sc_n 0
	}

	__get_axis_lab , lab(`xlabel') xtra(`xvals') alt(`min' `max') ///
		axis(xlabel) hasrange(`hasrange')
	local xlabel xlabel(`s(label)')

	if !missing(`"`inxlabel'"') local inxlabel xlabel(`inxlabel')

	__get_axis_lab , lab(`ylabel') xtra(`yvals') zero axis(ylabel)
	local ylabel ylabel(`s(label)')

	if `tinfo' {
		local ylabel
		if !`iinfo' local flist
	}

	local oneitem = `icc_k'==1 | `iif_k'==1
	if `hasgr' {
		local oneitem = `oneitem' * (`VAR' == 1)
	}
	
	if missing(`"`title'"') & missing(`"`intitle'"') {
		if `tcc' {
			if `hasgr' local title title("Test Characteristic Curves")
			else local title title("Test Characteristic Curve")
		}
		else if `tinfo' {
			if `iinfo' local title 	///
				title("Item and Test Information Functions")
			else local title title("Test Information Function")
		}
		else if `iinfo' {
			if `oneitem' local title ///
				title("Item Information Function for `ilab'")
			else local title title("Item Information Functions")
		}
		else { // icc
			if `bini' local pre Item
			if `cati' local pre Category
			if `bcci' local pre Boundary
			if !`oneitem'*`bini'+!`oneitem'*(`cati'|`bcci') > 1 ///
				local pre
			if `oneitem' local title ///
			    title("`pre' Characteristic Curve for `ilab'")
			else local title title("`pre' Characteristic Curves")
		}
	}
	else {
		if !missing(`"`title'"') local title title(`title')
		if !missing(`"`intitle'"') local intitle title(`intitle')
	}

	if missing(`"`xtitle'"') & missing(`"`inxtitle'"') {
		local xtitle xtitle("Theta")
	}
	else {
		if !missing(`"`xtitle'"') local xtitle xtitle(`xtitle')
		if !missing(`"`inxtitle'"') local inxtitle xtitle(`inxtitle')
	}

	if missing(`"`ytitle'"') & missing(`"`inytitle'"') {
		if `icc' local ytitle ytitle("Probability")
		else if `tcc' local ytitle ytitle("Expected Score")
		else if `iinfo' & `tinfo' ///
			local ytitle ytitle("Item Information")
		else local ytitle ytitle("Information")
	}
	else {
		if !missing(`"`ytitle'"') local ytitle ytitle(`ytitle')
		if !missing(`"`inytitle'"') local inytitle ytitle(`inytitle')
	}

	if `add_n' {
		local EE = `DD'+`add_n'-1
		if `icc' {
			local 0 , myo(`order' `DD'/`EE')
			syntax , myo(numlist)
		}
		if `tcc'{
			local oneitem 0
			local DD = `th_n'+`sc_n'+2
			local EE = `DD'+`add_n'-1
			local 0 , myo(1 `DD'/`EE')
			syntax , myo(numlist)
		}
	}
	else {
		if `icc' local myo `order'
		if `tcc' {
			if `hasgr' {
				local k = `e(N_groups)'
				local 0 , gg(1/`k')
				syntax , gg(numlist)
				local myo `gg'
			}
			else local legend off
			
		}
	}	

	local olegend `legend'
	local oinlegend `inlegend'

	if missing(`"`legend'"') & missing(`"`inlegend'"') {
		if `oneitem' local legend legend(off)
		else local legend legend(`leglab' order(`myo'))
	}
	else {
		local legends `legend' `inlegend'
		__chk_legend, `legends'
		if `s(usemyo)' local myo order(`myo')
		else local myo
		if !missing(`"`legend'"') local legend legend(`myo' `legend')
		if !missing(`"`inlegend'"') local inlegend legend(`myo' `inlegend')
	}

	if `tinfo' & !`iinfo' {
		if !missing(`"`olegend'"') local legend legend(`olegend')
		if !missing(`"`oinlegend'"') local inlegend legend(`oinlegend')
	}

	if `tinfo' {
		if `iinfo' {
			local tplot (line `YY' `Theta' , 		///
				`twopts' `opts' `lstyle' yaxis(2) 	///
				ytitle("Test information", axis(2)) )
		}
		else local tplot (line `YY' `Theta' , `twopts' `opts' `lstyle')

		if `hasgr' {
			local i 0
			foreach y of local YY {
				local ++i
				local save_vars `save_vars' `y'
				local save_names `save_names' tif`i'
			}
			if `se_add' {
				local i 0
				foreach s of local se {
					local ++i
					local y : word `i' of `YY'
					local save_vars `save_vars' `s'
					local save_names `save_names' tif_se`i'
					qui replace `s' = 1/sqrt(`y')
					local tplot `tplot' (	///
						line `s' `Theta' , `twopts' `opts' `se2' ///
						yaxis(2) ytitle("Standard Error", axis(2)) )
				}
			}
			
		}
		else {
			local save_vars `save_vars' `YY'
			local save_names `save_names' tif
			if `se_add' {
				qui replace `se' = 1/sqrt(`YY')
				local save_vars `save_vars' `se'
				local save_names `save_names' tif_se
				local tplot `tplot' (	///
					line `se' `Theta' , `twopts' `opts' `se2' ///
					yaxis(2) ytitle("Standard Error", axis(2)) )
			}	
		}
	}
	
	if `tcc' {
		local tccplot (line `YY' `Theta' , `twopts' `opts' `lstyle')
		local junk `e(model_list)'
		local junk : subinstr local junk "nrm" "", all count(local nomi)
		if `nomi'>1 local s s
		if `nomi' {
di "{p 0 6 2}{txt}"						///
"note: nominal item`s' included in the model; "			///
"you are responsible for interpretation of the TCC{p_end}"
		}
	}

	if `"`flist'`tccplot'`tplot'`dlist'`ypci'"' == "" {
		di as txt "(nothing to draw)"
		exit 0
	}

	twoway `flist' `tccplot' `tplot' `dlist' `ypci' || `addplot'	///
		, `inxlabel' `inylabel' `inytitle' `inxtitle'		///
		`intitle' `inlegend' `ingltwopts' `xlabel' `ylabel' 	///
		`ytitle' `xtitle' `title' `legend' `gltwopts'

	// return list
	return local xvals "`xvals'"
	return local yvals "`yvals'"

	if !missing(`"`data'"') {
		qui keep `save_vars'
		qui keep in 1/`OBS'
		local j 0
		foreach i of local save_vars_icc {
			local ++j
			label var `i' "`vlab`j''"
		}
		local j 0
		foreach i of local save_vars_iif {
			local ++j
			local lab : variable label `i'
			label var `i' "Item information for `lab'"
		}

		if `tinfo' & `se_add' {
			if `hasgr' {
				local i 0
				foreach g of local gr_levels {
					local ++i
					local y : word `i' of `YY'
					local gg : variable label `y'
					gettoken junk gg : gg, parse(",")
					local s : word `i' of `se'
					label var `s' `"Std. err. of test information`gg'"'
				}
			}
			else {
				label var `se' "Std. err. of test information"
			}
		}
		
		rename (`save_vars') (`save_names')
		label data
		qui save `data'
	}

end

program __drop_mata_tempnames
	syntax [anything]
	local rc = c(rc)
	foreach name of local 0 {
		capture mata: mata drop `name'
	}
	if `rc' exit `rc'
end

program __parse_opts, sclass

	syntax [, XLOCations1 XLOCations2(string) 	///
		YLOCations1 YLOCations2(string) 	///
		BLOcation1 BLOcation2(string)		///
		PLOcation1 PLOcation2(string)		///
		RAnge(numlist min=2 max=2) 		///
		bcc ccc icc(integer 0) __sub giverr *]

	if !`icc' {
		__ii_check, `bcc' `ccc' `blocation1' `plocation1' ///
			blocation2(`blocation2') plocation2(`plocation2')
	}
	
	if !missing("`giverr'") {
		__cc_check, `bcc' `ccc' `blocation1' `plocation1' ///
			blocation2(`blocation2') plocation2(`plocation2')
	}
	
	if !missing("`__sub'") local sub "within a subgraph"

	if !missing("`blocation1'") & !missing("`blocation2'") {
di as err "only one of {bf:blocation} or {bf:blocation()} is allowed"
exit 198
	}
	if !missing("`plocation1'") & !missing("`plocation2'") {
di as err "only one of {bf:plocation} or {bf:plocation()} is allowed"
exit 198
	}
	
	local xlocations1 `xlocations1' `blocation1'
	local xlocations2 `xlocations2' `blocation2'
	local ylocations1 `ylocations1' `plocation1'
	local ylocations2 `ylocations2' `plocation2'

	// xlocation
	if !missing("`xlocations1'") & !missing(`"`xlocations2'"') {
	      di as err "option {bf:thetalines} can only be specified once `sub'"
	      exit 198
	}

	if missing("`xlocations1'") & missing(`"`xlocations2'"') local hasxloc 0
	else local hasxloc 1

	__check_locations_opts, `xlocations2' __sub
	local xlpattern `s(lpattern)'

	// ylocation

	if !missing("`ylocations1'") & !missing(`"`ylocations2'"') {
	      di as err "option {bf:scorelines} can only be specified once `sub'"
	      exit 198
	}

	if missing("`ylocations1'") & missing(`"`ylocations2'"') local hasyloc 0
	else local hasyloc 1

	__check_locations_opts, `ylocations2' __sub
	local ylpattern `s(lpattern)'
	local bcc = !missing("`bcc'")
	local bcc = `bcc' | `hasxloc' | `hasyloc'
	
	local ccc = !missing("`ccc'")

	// return list

	sreturn local hasxloc `hasxloc'
	sreturn local xlocopts `xlocations2'
	sreturn local xlpattern `xlpattern'

	sreturn local hasyloc `hasyloc'
	sreturn local ylocopts `ylocations2'
	sreturn local ylpattern `ylpattern'

	sreturn local range `range'
	sreturn local opts `options'
	sreturn local bcc `bcc'
	sreturn local ccc `ccc'
end

program __check_locations_opts, sclass

	syntax [, LPAttern(passthru)		///
		LWidth(passthru)		///
		LColor(passthru)		///
		LSTYle(passthru)		///
		PSTYle(passthru) 		///
		__sub				///
		*]

	if !missing(`"`options'"') {
		di as err "option {bf:locations()}: `options' not allowed"
		exit 198
	}

end

program __cc_check
	syntax [, bcc ccc 	///
		BLOcation1 BLOcation2(string) PLOcation1 PLOcation2(string) ]

	if !missing("`ccc'") {
		if !missing("`bcc'") {
			di as err "only one of {bf:bcc} or {bf:ccc} is allowed"
			exit 198
		}
		if !missing("`blocation1'") {
			di as err "only one of {bf:blocation} or "	///
				"{bf:ccc} is allowed"
			exit 198
		}
		if !missing("`blocation2'") {
			di as err "only one of {bf:blocation()} or "	///
				"{bf:ccc} is allowed"
			exit 198
		}
		if !missing("`plocation1'") {
			di as err "only one of {bf:plocation} or "	///
				"{bf:ccc} is allowed"
			exit 198
		}
		if !missing("`plocation2'") {
			di as err "only one of {bf:plocation()} or "	///
				"{bf:ccc} is allowed"
			exit 198
		}
	}
end

program __ii_check
	syntax [, bcc ccc	///
		BLOcation1 BLOcation2(string) PLOcation1 PLOcation2(string) ]

	if !missing("`bcc'") {
		di as err "option {bf:bcc} not allowed"
		exit 198
	}
	if !missing("`ccc'") {
		di as err "option {bf:ccc} not allowed"
		exit 198
	}
	if !missing("`blocation1'") {
		di as err "option {bf:blocation} not allowed"
		exit 198
	}
	if !missing("`blocation2'") {
		di as err "option {bf:blocation()} not allowed"
		exit 198
	}
	if !missing("`plocation1'") {
		di as err "option {bf:plocation} not allowed"
		exit 198
	}
	if !missing("`plocation2'") {
		di as err "option {bf:plocation()} not allowed"
		exit 198
	}
end

program __tcc_pci_opts, sclass
	syntax [anything] [ , 			///
		LPAttern(passthru)		///
		LWidth(passthru)		///
		LColor(passthru)		///
		LSTYle(passthru)		///
		PSTYle(passthru) 		///
		noXLINEs noYLINEs		///
		]

	if missing("`anything'") {
		sreturn local num
		sreturn local pci
		exit 0
	}

	local gr_eq = strpos(`"`anything'"',":")
	if `gr_eq' & "`e(groupvar)'" == "" {
		di as err "group equation not allowed with non-group irt model"
		exit 198
	}
	
	if `gr_eq' {
		local gr_id = usubstr(`"`anything'"',1,`gr_eq'-1)
		local gr_id = trim("`gr_id'")
		if `=`: list sizeof gr_id'' > 1 {
			di as err `"invalid {bf:`anything'}"'
			exit 198
		}
		if `gr_eq' {
			local anything = usubstr(`"`anything'"',`gr_eq'+1,.)
		}
		local gr_levels `e(group_levels)'
		local gr_ok : list posof "`gr_id'" in gr_levels
		if !`gr_ok' {
			di as err "invalid group level {bf:`gr_id'}"
			exit 198
		}
	}
	else if "`e(groupvar)'" != "" {
		local gr_id `e(group_levels)'
	}
	else local gr_id
	
	local 0 , num(`anything')
	syntax , num(numlist sort)

	if missing(`"`lcolor'"') local lcolor lcolor(black)
	local pci `lpattern' `lwidth' `lcolor' `lstyle' `pstyle'

	local t_draw = !("`xlines'"=="noxlines")
	local e_draw = !("`ylines'"=="noylines")

	sreturn local num `num'
	sreturn local pci `pci'
	sreturn local t_draw `t_draw'
	sreturn local e_draw `e_draw'
	sreturn local gr_id `gr_id'
end

program __get_axis_lab, sclass
	syntax [, lab(string asis) xtra(numlist) alt(numlist) zero ///
		axis(string) hasrange(string) ]
	local 0 `lab'
	syntax [anything] [, format(passthru) angle(passthru) *]
	if missing(`"`format'"') local format format(%8.3g)
	if missing("`angle'") & !missing("`zero'") local angle angle(0)
	local opts `format' `angle' `options'
	
	if !missing(`"`anything'"') {
		sreturn local label `anything', `opts'
		exit
	}

	local 0 , num(`xtra')
	
	capture syntax [, num(numlist sort)]
	if _rc {
di as err `"option {bf:`axis'(`anything')} invalid;"'
di as err `"{p 6 6 2}{bf:`anything'} is not allowed with {bf:irtgraph}{p_end}"'
exit 198
	}
	
	if !missing("`hasrange'") {
		gettoken rmin rmax : hasrange
	}
	
	if missing("`num'") & !missing("`alt'") {
		gettoken min2 max2 : alt

		_natscale `min2' `max2' 7

		local min = `r(min)' + `r(delta)'
		local max = `r(max)' - `r(delta)'

		if !missing("`hasrange'") {
			if `r(min)'!=`rmin' {
				if `r(min)'>`rmin' local min2 `r(min)'
				else local min2
			}
			if `r(max)'!=`rmax' {
				if `r(max)'<`rmax' local max2 `r(max)'
				else local max2
			}
		}
		else {
			if `min2'!=`min' {
				if `r(min)'<`min2' local min2 
				else local min2 `r(min)'
			}
			if `max2'!=`max' {
				if `r(max)'>`max2' local max2
				else local max2 `r(max)'
			}
		}

		local num "`min2' `min'(`r(delta)')`max' `max2'"

		local 0 , num(`num')
		syntax , num(numlist)
	}
	local num : list uniq num
	local label `num', `opts'

	sreturn local label `label'
end

program __parse_addplot, sclass

	_parse expand plots below : 0, common(BELOW)

	forvalues i = 1/`plots_n' {
		local addplot `addplot' (`plots_`i'')
	}
	if !missing("`below_op'") local num 1
	else local num 2
	
	sreturn local addplot`num' `addplot'
	sreturn local addplot `addplot'
	sreturn local add_n `plots_n'
end

program __get_f, sclass
	syntax, model(string) item(string) coefs(string) 		///
		bases(string) lasts(string) fvmat(string)		///
		ix(string) cuts(string) icc(string)			///
		tcc(string) iinfo(string) tinfo(string) bp(string)	///
		[ ap(string) cp(string) bcc(string) ccc(string) 	///
		y(varname) x(varname) group(string) grinv(string)]

	gettoken junk it : item, parse(".")
	local it : subinstr local it "." ""

	_ms_parse_parts `item'
	local op `r(level)'
	assert "`r(type)'"=="factor"

	local hasgr = "`group'" != ""

	if inlist("`model'","1pl","2pl","3pl") {
		local ibase 0
		local ilast 1
	}
	else {
		local ibase = `bases'[1,colnumb(`bases',"`it'")]
		local ilast = `lasts'[1,colnumb(`lasts',"`it'")]
	}

	if `hasgr' {
		local ibase = `bases'[1,1]
		local ilast = `bases'[rowsof(`bases'),1]
		local cuts = rowsof(`bases') -1
	}

	local base = `op'==`ibase'
	if `base' local sub 1-

	local last = `op'==`ilast'

	if `tcc' local w `op'
	else local w 1

	tempvar tmp P DEN DDEN NUM DNUM

	if inlist("`model'","1pl","2pl") {

		if `hasgr' local gg "`group'.`e(groupvar)'#c."
		
		local bcc 0

		local a = `coefs'[1,colnumb(`coefs',"`it':`gg'`ap'")]
		local b = `coefs'[1,colnumb(`coefs',"`it':`gg'`bp'")]
		local c = 0

		local p invlogit(`a'*(\`x' -`b'))
		if `iinfo' | `tinfo' {
			local f (`a')^2 * (`p' * (1-`p'))
			local b_hi = 0.25 * (`a')^2
		}
		else {
			local f (`sub'`p')
			local b_hi = .5
		}
		qui replace `y' = `y' + `w'*`f'	
	}

	if inlist("`model'","3pl") {
		
		if `hasgr' local gg "`group'.`e(groupvar)'#c."
		
		local bcc 0

		local a = `coefs'[1,colnumb(`coefs',"`it':`gg'`ap'")]
		local b = `coefs'[1,colnumb(`coefs',"`it':`gg'`bp'")]
		local c = `coefs'[1,colnumb(`coefs',"`it':`gg'`cp'")]
		if missing(`c') local c = 0

		local p (`c' + (1-`c')*invlogit(`a'*(\`x' -`b')))

		if `iinfo' | `tinfo' {
			local a2 = (`a')^2
			local c2 = (`c')^2
			local q (1-`p')
			local p_star (`p'-`c')/(1-`c')
			local f `a2'*`p'*`q'*(`p_star'/`p')^2
			local b = `b' + log( .5 + sqrt(1+8*`c')/2 ) / `a'
			local b_hi = `a2'/(8*(1-`c')^2) * ///
				(1-20*`c'-8*`c2'+(1+8*`c')^(1.5))
		}
		else {
			local f (`sub'`p')
			local b_hi = `sub'(1+`c')/2
		}
		qui replace `y' = `y' + `w'*`f'	
	}

	if inlist("`model'","grm") {
		__check_op, item(`it') op(`op') fvmat(`fvmat')
		local k0 `s(k0)'
		local k1 = `k0'+1
		
		if `hasgr' {
			local gga "`group'.`e(groupvar)'#c."
			local ggb "`group'.`e(groupvar)'#"
		}
		
		// get p0
		if `k0'==0 local p0 1
		else {
			local a0 = `coefs'[1,colnumb(`coefs',"`it':`gga'`ap'")]
			local b0 = `coefs'[1,colnumb(`coefs',"`it':`ggb'`k0'.`bp'")]
			local p0 invlogit(`a0'*(\`x' -`b0'))
		}

		// get p1
		if `k0'==`cuts' local p1 0
		else {
			local a1 = `coefs'[1,colnumb(`coefs',"`it':`gga'`ap'")]
			local b1 = `coefs'[1,colnumb(`coefs',"`it':`ggb'`k1'.`bp'")]
			local p1 invlogit(`a1'*(\`x' -`b1'))
		}
		
		if `iinfo' | `tinfo' {
			local f (`p0'-`p1')
			if `k0'==0 local f ( `a1'*`p1'*(1-`p1') )^2 / `f'
			else if `k0'==`cuts' local f ///
				( `a0'*`p0'*(1-`p0') )^2 / `f'
			else local f ( `a0'*`p0'*(1-`p0') - ///
				`a0'*`p1'*(1-`p1') )^2 / `f'
		}
		else {
			local f (`p0'-`p1')
			if `bcc' {
				local f `p0'
				local b `b0'
				local b_hi = .5
			}
		}
		qui replace `y' = `y' + `w'*`f'	
	}

	if inlist("`model'","pcm","gpcm","rsm") {
		__check_op, item(`it') op(`op') fvmat(`fvmat')
		local k0 `s(k0)'
		local k1 = `k0'+1
		
		if `hasgr' {
			local gga "`group'.`e(groupvar)'#c."
			local ggb "`group'.`e(groupvar)'#"
		}
		
		local num0 0
		qui generate double `DEN' = exp(`num0')
		
		forvalues i = 1/`cuts' {
			local j = `i'-1
			local a`i' = `coefs'[1,colnumb(`coefs',"`it':`gga'`ap'")]
			local b`i' = `coefs'[1,colnumb(`coefs',"`it':`ggb'`i'.`bp'")]
			local z`i' `a`i''*(\`x' -`b`i'')
			local num`i' `num`j'' + `z`i''
		}
		
		forvalues i = 1/`cuts' {
			qui replace `DEN' = `DEN' + exp(`num`i'')
		}

		if `base' qui gen double `P' = exp(`num0')/`DEN'
		else 	  qui gen double `P' = exp(`num`k0'')/`DEN'

		if `iinfo' | `tinfo' {
			
			qui gen double `tmp' = 0
			qui gen double `DDEN' = 0
		
			local dden 0
			local dz 0
			local dnum0 0
			
			forvalues i = 1/`cuts' {
				local dz = `dz' + `a`i''
				local dnum`i' `dz'*exp(`num`i'')
				qui replace `DDEN' = `DDEN' + `dz'*exp(`num`i'')
			}

			qui gen double `DNUM' = `dnum`k0''
			qui gen double `NUM' = exp(`num`k0'')

			qui replace `tmp' = `tmp' + `DNUM'/`DEN'
			qui replace `tmp' = `tmp' - `NUM'*`DDEN' / `DEN'^2
			qui replace `tmp' = `tmp'*`tmp' / `P'

			qui replace `y' = `y' + `tmp'
		}
		else {
			local f `P'
			if `bcc' {
				local f invlogit(`a`k0''*(\`x'-`b`k0''))
				local b `b`k0''
				local b_hi = .5
			}
			qui replace `y' = `y' + `w'*`f'
		}
	}

	if inlist("`model'","nrm") {
		__check_op, item(`it') op(`op') fvmat(`fvmat') nrm
		local k0 `s(k0)'
		local levels `s(levels)'

		if `hasgr' local gg "`group'.`e(groupvar)'#"
		
		local a0 0
		local b0 0
		local z0 0
		local e0 1
		qui gen double `DEN' = 1

		local j 0
		foreach i of local levels {
			local ++j
			local a`i' = `coefs'[1,colnumb(`coefs',"`it':`gg'`j'.`ap'")]
			local b`i' = `coefs'[1,colnumb(`coefs',"`it':`gg'`j'.`bp'")]
			local z`i' `a`i''*(\`x'-`b`i'')
			local e`i' exp(`z`i'')
			qui replace `DEN' = `DEN' + `e`i''
		}

		if `base' qui gen double `P' = `e0'/`DEN'
		else	  qui gen double `P' = `e`k0''/`DEN'

		if `iinfo' | `tinfo' {

			local allevels 0 `levels'

			qui gen double `DDEN' = 0
			
			foreach i of local allevels {
				local p`i' (`e`i'' / `DEN')
				qui replace `DDEN' = `DDEN' + `a`i''*`e`i''
			}

			// 1st derivative
			foreach i of local allevels {
				local dp`i' ( (`a`i''*`e`i''*`DEN' - 	///
					`e`i''*`DDEN') / `DEN'^2 )
			}

			// 2nd derivative
			foreach i of local allevels {
				local aa`i' 0
				local a2a2`i' 0
				foreach j of local allevels {
					local aa`i' `aa`i'' + 	///
						`e`j''*(`a`i''-`a`j'')
					local a2a2`i' `a2a2`i'' + `e`j''* ///
						(`a`i''-`a`j'')*(`a`i''+`a`j'')
				}
				local ddp`i' (`e`i''*((`a2a2`i'')*`DEN' -  ///
					2*(`aa`i'')*`DDEN' )) / `DEN'^3
			}

			foreach i of local allevels {
				local info`i' `dp`i''^2 / `p`i'' - `ddp`i''
			}

			if `base' qui replace `y' = `y' + `info0'
			else	  qui replace `y' = `y' + `info`k0''
		}
		else {
			local f `P'
			if `bcc' {
				local f invlogit(`a`k0''*(\`x'-`b`k0''))
				local b `b`k0''
				local b_hi = .5
			}
			qui replace `y' = `y' + `w'*`f'
		}
	}

	if inlist("`model'","1pl","2pl","3pl") {
		sreturn local bini 1
		sreturn local cati 0
	}
	else {
		sreturn local bini 0
		sreturn local cati 1
	}
	sreturn local bcci `bcc'
	sreturn local ccci `ccc'
	
	sreturn local b `b'
	sreturn local b_hi `b_hi'
	
	local gg
	
	if `icc' | `iinfo' {
		if `hasgr' & "`grinv'" == "" {
			local name `e(groupvar)'
			local g `"`e(grlabel`group')'"'
			if `"`g'"' == "`group'" {
				local gg ", `g'.`name'"
			}
			else {
				local len = udstrlen(`"`g'"')
				if `len' > 16 {
					local g1 = udsubstr(`"`g'"',1,14)
					local g2 = udsubstr(`"`g'"',-1,.)
					local g `"`g1'~`g2'"'
				}
				local gg `", `g'"'
			}
		}
	}

	if `icc' {
		if `bcc' & !`last' local sign "{&ge}"
		else local sign "="

		if "`sign'" == "=" local vlab `"ICC for Pr(`it'=`op')`gg'"'
		else 		   local vlab `"ICC for Pr(`it'>=`op')`gg'"'
		
		local lab `"Pr(`it'`sign'`op')`gg'"'

		sreturn local leglab `"label(`ix' `lab')"'
		sreturn local ilab `"`lab'"'
		sreturn local vlab `"`vlab'"'
		sreturn local op `op'
	}
	if `iinfo' {
		sreturn local ilab `"`it'`gg'"'
		sreturn local vlab `"`it'`gg'"'
	}
end

program __check_op, sclass
// ==========================================================================
//
// For ordinal models, we have cutpoints Diff1, Diff2, ..., irrespective of
//   how item levels are coded, so we return k0=1 or 2 or 3 ...
// For nominal models, we have #.item and each #.item corresponds to the
//   actual item level so for an item coded 1 4 10 we return k0=1 or 4 or 10
//   because each level has #.item:Diff and #.item:Discrim
//
// ==========================================================================
	syntax , item(string) op(string) fvmat(string) [nrm]

	_unab i.`item', mat(`fvmat')
	local levels `r(varlist)'
	
	local levels : subinstr local levels "b." "."
	local levels : subinstr local levels ".`item'" "", all
	local pos : list posof "`op'" in levels
	if !`pos' {
		di as err "invalid {bf:`op'.`item'}"
		exit 198
	}
	if missing("`nrm'") local k0 = `pos'-1
	else {
		local k0 : word `pos' of `levels'
		gettoken junk levels : levels
	}
	sreturn local k0 `k0'
	sreturn local levels `levels'
end

program __get_range, sclass
	syntax [, glrange(numlist min=2 max=2 sort) ilist(string) ///
		iinfo(integer 0) tinfo(integer 0) tcc(integer 0) ///
		gr_ilist(string)]
	
	if !missing(`"`glrange'"') {
		local min : word 1 of `glrange'
		local max : word 2 of `glrange'
	}
	else if `iinfo' | `tinfo' | `tcc' {
		local min = -4
		local max = 4
	}
	else {
		tempname b bb
		qui estat rep `ilist', sort(b) byparm
		mat `b' = r(b)
		mata: __get_range_bb("`b'","`bb'")
		local nn = colsof(`bb')

		local bb_min = `bb'[1,1]
		local bb_max = `bb'[1,`nn']

		if `bb_max' < 4 local max 4
		else local max = `bb_max'

		if `bb_min' > -4 local min -4
		else local min = `bb_min'
	}

	sreturn local min `min'
	sreturn local max `max'
end

program __chk_legend, sclass
	syntax [, order(string) *]
	if missing(`"`order'"') sreturn local usemyo 1
	else sreturn local usemyo 0
end

program __get_add_n, sclass
	syntax [, addplot(string)]
	_parse expand plots junk : addplot
	local n `plots_n'
	local k 0
	local type lfitci qfitci fpfitci lpolyci
	forvalues i = 1/`plots_n' {
		local tmp `plots_`i''
		local s : word 1 of `tmp'
		foreach t in `type' {
			if "`s'"=="`t'" {
				local ++k
				break
			}
		}
	}
	local n = `n'+(`k'>0)
	sreturn local add_n `n'
end

exit

