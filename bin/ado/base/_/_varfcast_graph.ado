*! version 1.0.11  12feb2010
program define _varfcast_graph, rclass
	version 8.0
	
	syntax anything(id="varlist of endogenous variables" name=list)/*
		*/ [if] [in] 				/*
		*/ [, 					/*
		*/ noCI					/*
		*/ Observed				/*
		*/ INdividual				/*
		*/ ISAving(string)			/*
		*/ INAME(string) 			/*
		*/ CILines				/*
		*/ CIOPts(string)			/*
graph option	*/ iscale(string)			/*
graph option    */ imargin(string)			/*
graph_opts	*/ * ]					
	

	if "`individual'" == "" {
		local getcombine getcombine
	}
	else	local getcombine gettwoway
	_get_gropts, graphopts(`options') getallowed(SCHeme) `getcombine'

	if `"`s(scheme)'"' != "" {
		local scheme `"scheme(`s(scheme)')"'
	}
	local graphopts `"`s(graphopts)'"'
	local twg_opts `"`s(twowayopts)'"'
	local comb_opts `"`s(combineopts)'"'	

	if "`individual'" != "" {
		_get_gropts, graphopts(`graphopts') getcombine
		if `"`s(combineopts)'"' != "" {
			di as err "{cmd:graph_combine_opts} cannot " 	/*
				*/ "be specified with {cmd:individual}"
			exit 198
		}
	}

	if "`ci'" != "" & "`cilines'" != "" {
		di as err "{cmd:noci} and {cmd:cilines} cannot "	/*
			*/ "both be specified"
		exit 198
	}

	if "`individual'" != "" & `"`iscale'"' != "" {
		di as error "no combined graph requested"
		di as error `"{cmd:iscale(`iscale')} not valid"'
		exit 198
	}

	if "`individual'" != "" & `"`imargin'"' != "" {
		di as error "no combined graph requested"
		di as error `"{cmd:margin(`margin')} not valid"'
		exit 198
	}

	if "`isaving'" != "" & "`individual'" == "" {
		di as err "{cmd:isaving()} cannot be specified "	/*
			*/ "without {cmd:individual}"
		exit 198
	}

	if "`iname'" != "" & "`individual'" == "" {
		di as err "{cmd:iname()} cannot be specified "	/*
			*/ "without {cmd:individual}"
		exit 198
	}

	if "`isaving'" != "" {
		ISAVEparse `isaving'
		
		local fnstub `r(fnstub)'
		if "`r(replace)'" != "" {
			local ireplace ",`r(replace)'"
		}	
	}

	if "`iname'" != "" {
		INAMEparse `iname'
		
		local namestub `r(namestub)'
		if "`r(replace)'" != "" {
			local inreplace ",`r(replace)'"
		}	
	}

	tsunab varlist : `list', name("varlist of endogenous variables")

	local vlist3 `varlist'
	local varlist : subinstr local varlist "." "_", all
	foreach var of local varlist {
		local var "`var'_f"
		local vlist2  `vlist2' `var'
	}	

/* assign default iscale and imargin if individual */

	local nstats : word count `varlist'

	if "`individual'" == "" {
		local rows = ceil(sqrt(`nstats'))
		if `"`iscale'"' == "" {
			if `rows' == 1 {
				local iscale "*1"
			}
			if `rows' == 2 {
				local iscale "*.75"
			}
			if `rows' >2 {
				local iscale "*.6"
			}
		}
			
		if `"`imargin'"' == "" {
			if `rows' == 1 {
				local imargin small
			}
			if `rows' == 2 {
				local imargin vsmall
			}
			if `rows' >2 {
				local imargin tiny
			}
		}
	}



	if "`if'`in'" != "" {
		marksample touse_all, novarlist
	}

	qui tsset, noquery
	local tvar `r(timevar)'
	local tsfmt `r(tsfmt)'
	
	tempvar touse
	qui gen byte `touse' = 1

/* default xlabel() and ylabel() settings */

	local lopt `"xlabel(#4) ylabel(#4 , angle(horizontal)) ytitle("") "'
	
	// lets find out how many vars we have because we want to avoid a 
	// more condition on the last graph when individual is specified
	local num_of_vars : word count `vlist2'
	local i 0
	foreach var of local vlist2 {
		local ++i

		local vars `var'
		local fcast `var'

		local vname : word `i' of `vlist3'

		if "`individual'" == "" {
			tempname tgraph`i'
			local glist `" `glist' `tgraph`i'' "'
			local namemac `"name(`tgraph`i'')"'
		}
		else {
			if "`namestub'" != "" {
				local vname2 : word `i' of `varlist'
				local ngraph`i' "`namestub'`vname2'"
				local namemac `"name(`ngraph`i'' `inreplace')"'
			}	

			if "`fnstub'" != "" {
				local vname2 : word `i' of `varlist'
				local fgraph`i' "`fnstub'`vname2'"
				local savemac `"saving(`fgraph`i'' `ireplace')"'
			}	
		}
		
		local var : subinstr local var "." "_", all

		confirm numeric variable `var'	 

		if "`touse_all'" == "" {
			tempvar tousei
			qui gen byte `tousei' = 1
			markout `tousei' `var'	
			qui replace `touse' = `tousei'
		}
		else {
			qui replace `touse' = `touse_all' 
		}	

		qui sum `tvar' if `touse'
		local rmin = r(min)
		local rmax = r(max)
		local min : di `tsfmt' `rmin'
		local max : di `tsfmt' `rmax'

/* build ci plots */

		if "`ci'" == "" {
if "`cilines'" != ""  {
	local ciptype rline
}
else {
	local ciptype rarea
}

		
confirm numeric variable `var'_L
confirm numeric variable `var'_U
local vars `vars' `var'_L `var'_U

local tmplab : var label `var'_L
gettoken level : tmplab, parse("%")
capture confirm integer number `level'
if _rc == 0 {
	local ylab `"yvarlab("`level'% CI" "`level'% CI")"'
}
else {
	local ylab `"yvarlab("CI" "CI")"'
}
local ciplot `"(`ciptype' `var'_L `var'_U `tvar', pstyle(ci) `ylab' `ciopts')"'

		}

		if "`observed'" != "" {
/* plot observed and forecasted */
			CKNAME `vname'
			qui count if `vname' < . & `touse' & `tvar'>`rmin'
			if r(N) == 0 {
di as txt "no observations on `vname' in prediction sample"
di as txt "`vname' has been dropped from the graph"
					
local lab `" yvarlabel("forecast") "'
local ps  `" pstyle(p1) "'
local fplot (line `fcast' `tvar' ,`lopt' `lab' `ps' `graphopts' )

			}
			else {
local vars `vars' `vname'
local ylab `"yvarlab("forecast" "observed")"'			
local ps  `" pstyle(p1 p2) "'
local fplot `"(line `fcast' `vname' `tvar',`lopt' `ylab' `ps' `graphopts' ) "'
				}
		}	
		else {
/* only plot forecasted */

local lab `" yvarlabel("forecast") "'
local ps  `" pstyle(p1) "'
local fplot (line `fcast' `tvar' ,`lopt' `lab' `ps' `graphopts' )
		}					
		

		if "`individual'" == "" {
			local nodraw nodraw	
		}	

		graph twoway `ciplot' `fplot' 			/*
			*/ if `touse',				/*
			*/ subtitle("Forecast for `vname'",	/*
			*/ size(scheme heading)	box bexpand blstyle(none)) /*
			*/ `savemac' `namemac' `nodraw'	`twg_opts' `scheme'

		if "`individual'" != "" & `i' < `num_of_vars' {
			more
		}

		ret local twowaycon `"`graphopts'"'

		if "`fnstub'" != "" {
			ret local fname`i' "`fgraph`i''" 
		}	
		if "`namestub'" != "" {
			ret local name`i' "`ngraph`i''" 
		}	
		ret local tmax`i' "`max'"
		ret local tmin`i' "`min'"
		ret local variables`i' "`vars'"
		ret local graph`i' "`var'"

	}

	ret local ciopts `"`ciopts'"'
	ret local comb_opts `"`comb_opts'"'

	ret local timevar "`tvar'"
	ret local tsfmt "`tsfmt'"

	if "`individual'" == "" {
		graph combine `glist' , iscale(`iscale') 	/*
			*/ imargin(`imargin') `scheme' `comb_opts' 
		graph drop `glist'
	}	
	else {
		ret local individual individual
	}	
	

end

program define CKNAME
	capture syntax varlist(numeric ts max=1 min=1)
	
	if _rc > 0 {
		di as err "either `0' does not exist or it is not a "	/*
			*/ " numeric variable"
		exit 198
	}	

end

program define ISAVEparse, rclass
	syntax name(id="filename stub" name=stub) [, replace]

	ret local fnstub `stub'
	ret local replace `replace'
end

program define INAMEparse, rclass
	syntax name(id="name stub" name=stub) [, replace]

	ret local namestub `stub'
	ret local replace `replace'
end

