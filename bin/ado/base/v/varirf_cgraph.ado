*! version 2.2.17  23oct2013
program define varirf_cgraph, rclass
	version 8.0
	syntax anything(name=gcmds id="specific graphs") 	/*
		*/ [,						/*
		*/ INdividual					/*
		*/ LSTep(numlist max=1 integer >=0 <=500) 	/* 
		*/ USTep(numlist max=1 integer >0 <=500) 	/* 
		*/ noCI						/*
		*/ Level(passthru)				/*
		*/ set(string)					/*
graph option	*/ SAving(string)				/*
graph option	*/ name(string)					/*
graph option	*/ TItle(string)				/*
graph option	*/ iscale(string)				/*
graph option    */ imargin(string)				/*
		*/ CILines					/*
		*/ CI1opts(string asis)				/*
		*/ CI2opts(string asis)				/*
		*/ ciopts1(string asis)				/*
		*/ ciopts2(string asis)				/*
		*/ PLOT1opts(string asis)			/*
		*/ PLOT2opts(string asis)			/*
		*/ PLOT3opts(string asis)			/*
		*/ PLOT4opts(string asis)			/*
		*/   *  					/*
		*/ ]
	
	if "`individual'" == "" {
		local getcombine getcombine
	}
	else	local getcombine gettwoway
	_get_gropts, graphopts(`options') getallowed(scheme) `getcombine'

	if `"`s(scheme)'"' != "" {
		local scheme `"scheme(`s(scheme)')"'
	}
	local graphopts `"`s(graphopts)'"'
	local twg_opts `"`s(twowayopts)'"'
	local comb_opts `"`s(combineopts)'"'	

	/* comb_options allowed only when individual is not specified */
	if "`individual'" != "" {
		_get_gropts, graphopts(`graphopts') getcombine
		if `"`s(combineopts)'"' != "" {
			di as err "{cmd:graph_combine_opts} cannot " 	/*
				*/ "be specified with {cmd:individual}"
			exit 198
		}
	}
	
	if "`ustep'" != "" & "`lstep'" != "" {
		if `ustep' < `lstep' {
			di as err "{cmd:ustep()} cannot be less that "	/*
				*/ "{cmd:lstep()}."
			exit 198	
		}
	}

	/* check noci and level options and re-map them if specified*/

	if "`ci'" != "" & "`level'" != "" {
		di as err "{cmd:noci} and {cmd:level()} cannot both "	/*
			*/ "be specified"
		exit 198
	}	
	
	local zero `0'
	local 0 ", `level'"
	local backopt `options'
	syntax [, level(cilevel)]
	local 0 `zero'
	local options `backopt'

	if "`ci'" != "" & "`cilines'" != "" {
		di as err "{cmd:noci} and {cmd:cilines} cannot both "	/*
			*/ "be specified"
		exit 198
	}	

	if "`ci'" != "" & `"`ciopts1'`ci1opts'"' != "" {
		di as err "{cmd:noci} and {cmd:ci1opts()} cannot both "	/*
			*/ "be specified"
		exit 198
	}	

	if "`ci'" != "" & `"`ciopts2'`ci2opts'"' != "" {
		di as err "{cmd:noci} and {cmd:ci2opts()} cannot both "	/*
			*/ "be specified"
		exit 198
	}	

	local g_ciopts1 `"`ciopts1' `ci1opts'"'
	local g_ciopts2 `"`ciopts2' `ci2opts'"'

	if "`ci'" != "" {
		local g_ci noci
		local ci 
	}	

	if "`cilines'" != "" {
		local g_cilines cilines
		local cilines 
	}	

	if "`level'" != "" {
		local g_level  `level'
		local level 
	}	
	else {
		local g_level  $S_level
	}
	
	local plist plot1opts plot2opts plot3opts plot4opts
	foreach plopt of local plist {
		if `"``plopt''"' != "" {
			local g_`plopt' `"``plopt''"'
		}	
	}	

	if `"`title'"' != "" {
		local c_tmac `"title(`title')"'
		local c_tmacs `"`title'"'
	}
	
	if "`individual'" != "" & `"`saving'"' != "" {
		di as error "{p 0 4 2}no combined graph requested " ///
			`"{cmd:saving(`saving')} not valid{p_end}"'
		exit 198
	}

	if "`individual'" != "" & `"`name'"' != "" {
		di as error "{p 0 4 2}no combined graph requested " ///
			`"{cmd:saving(`saving')} not valid{p_end}"'
		exit 198
	}

	if "`individual'" != "" & `"`iscale'"' != "" {
		di as error "{p 0 4 2}no combined graph requested "	///
			`"{cmd:iscale(`iscale')} not valid{p_end}"'
		exit 198
	}


	if `"`saving'"' != "" {
		SAVEPARSE `saving'
		local c_file `"`r(fname)'"'
		local c_replace "`r(replace)'"
		if "`c_replace'" != "" {
			local c_replace ", `c_replace'"
		}	
		local c_save `"saving("`c_file'" `c_replace')"'
		local c_saves `"`c_file'`c_replace'"'
	}


	if `"`name'"' != "" {
		NAMEPARSE `name'
		local cn_name `"`r(name)'"'
		local cn_replace "`r(replace)'"
		if "`cn_replace'" != "" {
			local cn_replace ", `cn_replace'"
		}	
		local cn_save `"name(`cn_name'`cn_replace')"'
		local cn_saves `"`cn_name'`cn_replace'"'
	}

	/* set a new irf data file */
	if `"`set'"' != "" {
		irf set `set'
	}

	if `"$S_vrffile"' == "" {
		di as err "no irf file active"
		exit 198
	}
	
	preserve
	_virf_use `"$S_vrffile"'
	sort irfname impulse response step

	qui sum step
	local mstep = r(max)

	if "`ustep'" !=  "" {
		local g_ustep `ustep'	
	}	

	if "`lstep'" !=  "" {
		local g_lstep `lstep'	
	}	

	local j 0
	while `"`gcmds'"' != "" {
		gettoken gline gcmds : gcmds , match(parns)
		local 0 `"`gline'"'
		local 0copy `"`0'"'
		syntax anything(id="graph stats" name=gline)	 	/*
			*/ [,						/*
			*/ noCI						/*
			*/ Level(passthru)				/*
			*/ LSTep(numlist max=1 integer >=0 <=500)	/* 
			*/ USTep(numlist max=1 integer >0 <=500)	/* 
			*/ SAving(string) 				/*
			*/ name(string) 				/*
			*/ SUBtitle(string)				/*
			*/ CILines					/*
			*/ CI1opts(string asis)				/*
			*/ CI2opts(string asis)				/*
			*/ ciopts1(string asis)				/*
			*/ ciopts2(string asis)				/*
			*/ PLOT1opts(string asis)			/*
			*/ PLOT2opts(string asis)			/*
			*/ PLOT3opts(string asis)			/*
			*/ PLOT4opts(string asis)			/*
			*/ *  						/*
			*/ ]

		_get_gropts, graphopts(`options')
		local itw_opts `"`s(graphopts)'"'

		local ++j

		local popts2ck ciopts1 ciopts2 ci1opts ci2opts

		foreach opq of local popts2ck {
			local `opq'm `"`g_`opq'' ``opq''"'
		}	

		local plist plot1opts plot2opts plot3opts plot4opts
		foreach plopt of local plist {
			local `plopt'm `"`g_`plopt'' ``plopt''"'
		}	

		if "`ustep'" == "" {
			if "`g_ustep'" != "" {
				local ustep  `g_ustep'
			}
			else {
				local ustep `mstep'
			}
		}
		
		if "`lstep'" == "" {
			if "`g_lstep'" != "" {
				local lstep  `g_lstep'
			}
			else {
				local lstep 0
			}
		}
		
		if "`lstep'" == "" {
			di as err "minimum step not defined"
			exit 498
		}

		if "`ustep'" == "" {
			di as err "maximum step not defined"
			exit 498
		}

		if `ustep' < `lstep' {
			di as err "{cmd:ustep()} cannot be less "/*
				*/ "that {cmd:lstep()}."
			exit 198	
		}
			
		local ifstep "& step >= `lstep' & step <= `ustep'"	

		if "`ci'" != "" & "`level'" != "" {
			di as err "{cmd:noci} and {cmd:level()} "	/*
				*/ "cannot both be specified"
			exit 198
		}	

		if "`ci'" != "" | "`g_ci'" != "" {
			local cim noci
		}
		else {
			local cim 
		}

		if "`cilines'" != "" | "`g_cilines'" != "" {
			if "`ci'" != "" | "`g_ci'" != "" {
				di as err "{cmd:noci} and {cmd:cilines} " ///
					" cannot both be specified"
				exit 198
			}
		}

		if "`cilines'" != "" | "`g_cilines'" != "" {
			local ciplot rline
		}
		else {
			local ciplot rarea
		}

		if "`level'" != "" & "`g_ci'" != "" {
			di as err "{cmd:level()} and {cmd:noci} cannot " /* 
				*/ "both be specified "	
			exit 198
		}

		if "`level'" == "" {
			local level `g_level'
		}	
		else {
			local zero `0'
			local 0 ", `level'"
			local backopt `options'
			syntax [, level(cilevel)]
			local 0 `zero'
			local options `backopt'
		}


		if `"`saving'"' != "" {
			SAVEPARSE `saving'
			local s_file `"`r(fname)'"'
			local s_replace "`r(replace)'"
			if "`s_replace'" != "" {
				local s_replace ", `s_replace'"
			}	
			local s_save `"saving("`s_file'"`s_replace')"'
			local s_saves `"`s_file'`s_replace'"'
		}

		if `"`name'"' != "" {
			NAMEPARSE `name'
			local sn_name "`r(name)'"
			local sn_replace "`r(replace)'"
			if "`sn_replace'" != "" {
				local sn_replace ", `sn_replace'"
			}	
			local name `"name(`sn_name' `sn_replace')"'
			local name_s `"`sn_name' `sn_replace'"'
		}

		gettoken tmp1 tmp2 : gline , parse("()")
		local base `gline'

		if `"`tmp2'"' != `""' {
			di as err "specific graphs not properly "/*
				*/ `"specified in `0'"' 
			exit 198
		}
		
		gettoken irfname  base  : base 
		local validirfs : char _dta[irfnames]
		local tmp_ck : subinstr local validirfs "`irfname'" 	/*
			*/ "`irfname'", count( local ck_found) word
		if `ck_found' < 1 {
			di as err "`irfname' is not a valid irfname"
			exit 498
		}

		local ckvec : char _dta[`irfname'_model]

		gettoken impulse  base  : base
		_irf_ops `impulse'
		local impulse `s(irfvar)'

		local validimps : char _dta[`irfname'_order]

		gettoken response stats : base
		_irf_ops `response'
		local response `s(irfvar)'

		local tmp_ck : subinstr local validimps "`response'" 	/*
			*/ "`response'", count( local ck_found) word
		if `ck_found' < 1 {
			di as err "`response' is not a valid response"
			exit 498
		}

		local n_stats : word count `stats' 
		if `n_stats' < 1 {
			di as err "no statistics to graph"
			exit 198
		}	

		capture noi confirm variable `stats'
		if _rc > 0 {
			di as err "`stats' not valid"
			exit 198
		}

		local dmult dm cdm
		local dmult : list stats & dmult
		if "`dmult'" != "" {
			local validimps2 : char _dta[`irfname'_exogvars]
			local validimps2 `validimps' `validimps2'
			local tmp_ck : subinstr local validimps2 "`impulse'" /*
				*/ "`impulse'", count( local ck_found) word
			if `ck_found' < 1 {
				di as err "`impulse' is not a valid impulse"
				exit 498
			}
		}
		else {
			local tmp_ck : subinstr local validimps "`impulse'" /*
				*/ "`impulse'", count( local ck_found) word
			if `ck_found' < 1 {
				di as err "`impulse' is not a valid impulse"
				exit 498
			}
		}

		local stats2
		foreach var of local stats {
			HayObs `var', irfname(`irfname') 		///
				impulse(`impulse') response(`response')
			if r(N) > 0 {
				local stats2 `stats2' `var'
			}
			else {
				MissErr `var', irfname(`irfname')
			}	
		}	
		local stats `stats2'

		if `"`subtitle'"' != "" {
			local tmac `"subtitle("`subtitle'")"'
			local tmacs `"`subtitle'"'
		}
		else {
local tmac `"subtitle("`irfname': `impulse' -> `response'""'
local tmac `"`tmac', size(scheme heading) box bexpand blstyle(none))"'
local tmacs "`irfname': `impulse' -> `response'"
		}	
		
		local adj_level = `level'/100 + (100-`level')/200
		
		local legon " legend(on) "

		local uniqs : list uniq stats
		local uniq : list uniqs == stats
		if `uniq' != 1 {
			di as err "duplicate elements found in `stats'"
			exit 198
		}
		
		if "`e(cmd)'"=="arima" | "`e(cmd)'"=="arfima" {
			local tmp irf cirf oirf coirf sirf
			local out : list stats | tmp
			local out : list uniq out
			local out : list out - tmp
			if "`out'"!="" {
				di as err "{cmd:`out'} not available after " /*
					*/ "`e(cmd)'"
				exit 198
			}
		}
		
		local nstats : word count `stats'
		if "`cim'" == "" {
			if `nstats' > 2 {
				di as err "only two statistics may " /*
					*/"be included with CI's in one graph"
				exit 198	
			}	
		}
		else {
			if `nstats' > 4 {
				di as err "only four statistics may " /*
					*/"be included in one graph"
				exit 198	
			}	
		}
		
		if `nstats' > 1 {
			local mys s
		}
		else {
			local mys 
		}	

		local nstatsp1 = `nstats' + 1
		forvalues nsp = `nstatsp1'/4 {
			if `"`plot`nsp'opts'"' != ""  {
di as txt "only `nstats' plot`mys' specified, plot`nsp'opts() option ignored"
			}
		}

		local i 1
		local slist


		local lopt "xlabel(#4) ylabel(#4 , grid angle(horizontal))"

		local nstatsp1 = `nstats' + 1

		if "`cim'" == "" {

			if `nstats' == 1 {
if "`ciopts2'`ci2opts'" != "" {
	di as txt "only one statistics specified, ci2opts() ignored"
}	

			
local var : word 1 of `stats'

tempvar `var'l `var'u
capture noi confirm variable std`var'

HayObs std`var', irfname(`irfname') impulse(`impulse') response(`response')

if r(N) > 0 {
	tempvar `var'l `var'u
	qui gen double ``var'l' = `var' - std`var'*invnorm(`adj_level')
	qui gen double ``var'u' = `var' + std`var'*invnorm(`adj_level')


	local cilab `"`=strsubdp("`level'")'% CI for `var'"'
	local ylab `"yvarlabel("`cilab'" "`cilab'")"'
	local plt1 `"( `ciplot' ``var'l' ``var'u' step, sort(step) "'
	local plt1 `"`plt1' pstyle(ci) `ylab' `lopt' `ciopts1m' `ci1optsm')"'

	local ylab `"yvarlabel("`var'")"'
	local plt2 `"(line `var' step, sort(step) pstyle(p1) `ylab' "'
	local plt2 `"`plt2' `lopt' `itw_opts' `plot1optsm' )"'

	local allplots `" `plt1' `plt2' "'
}
else {

	StdMissErr `var', irfname(`irfname') model(`ckvec')

		local ylab `"yvarlabel("`var'")"'
		local plt1 `"(line `var' step, sort(step) pstyle(p1) `ylab' "'
		local plt1 `"`plt1' `legon' `lopt' `itw_opts' `plot1optsm' )"'

		local allplots `" `plt1' "'
}
			}

			if `nstats' == 2 {
local var1 : word 1 of `stats'
local var2 : word 2 of `stats'

tempvar `var1'l `var1'u
capture noi confirm variable std`var1'

HayObs std`var1', irfname(`irfname') impulse(`impulse') response(`response')
if r(N) > 0 {
	
	tempvar `var1'l `var1'u
	qui gen double ``var1'l' = `var1' - std`var1'*invnorm(`adj_level')
	qui gen double ``var1'u' = `var1' + std`var1'*invnorm(`adj_level')

	local cilab `"`=strsubdp("`level'")'% CI for `var1'"'
	local ylab `"yvarlabel("`cilab'" "`cilab'")"'
	local plt1 `"( `ciplot' ``var1'l' ``var1'u' step, sort(step) "'
	local plt1 `"`plt1' pstyle(ci) `ylab' `lopt' `ciopts1m' `ci1optsm')"'

}
else {
	StdMissErr `var1', irfname(`irfname') model(`ckvec')
	local plt1 
}
	
tempvar `var2'l `var2'u
capture noi confirm variable std`var2'

HayObs std`var2', irfname(`irfname') impulse(`impulse') response(`response')
if r(N) > 0 {
	tempvar `var2'l `var2'u
	qui gen double ``var2'l' = `var2' - std`var2'*invnorm(`adj_level')
	qui gen double ``var2'u' = `var2' + std`var2'*invnorm(`adj_level')

	local cilab `"`=strsubdp("`level'")'% CI for `var2'"'
	local ylab `"yvarlabel("`cilab'" "`cilab'")"'
	local plt2 `"( `ciplot' ``var2'l' ``var2'u' step, sort(step) "'
	local plt2 `"`plt2' pstyle(ci2) `ylab' `lopt' `ciopts2m' `ci2optsm')"'

}
else {
	StdMissErr `var2', irfname(`irfname') model(`ckvec')
	local plt2 

}
	
	local ylab `"yvarlabel("`var1'")"'
	local plt3 `"(line `var1' step, sort(step) pstyle(p1line) `ylab' "'
	local plt3 `"`plt3' `lopt' `itw_opts' `plot1optsm' )"'

	local ylab `"yvarlabel("`var2'")"'
	local plt4 `"(line `var2' step, sort(step) pstyle(p2line) `ylab' "'
	local plt4 `"`plt4' `lopt' `itw_opts' `plot2optsm' )"'

	local allplots `" `plt1' `plt2' `plt3' `plt4' "'

			}

			if `nstats' > 2 {
				di as err "only two statistics may " /*
					*/"be included with CI's in one graph"
				exit 198	
			}

			if `nstats' < 1 {
				di as txt "all variables contain all "	///
					"missing values for irf "	///
					"results  `irfname'"
				di as txt `"{p 0 4 4}cannot make a "'	///
					`"graph for {cmd:(`0copy')}{p_end}"'
				local allplots 

			}
		}
		else {

			if `nstats' == 1 {
				local legon " legend(on) "
			}
			else {
				local legon 
			}

			local labvar 
			local allplots
			local nsp 0
			foreach var of local stats {
local ++nsp
local plt`nsp' `"(line `var' step ,  yvarlab("`var'") `lopt' "'
local plt`nsp' `"`plt`nsp'' `legon' `itw_opts' `plot`nsp'optsm')"'

local allplots `" `allplots' `plt`nsp'' "'
			}

			if `nsp' < 1 {
di as txt "all variables contain all missing values "	///
	"for irf results `irfname'"
di as txt `"{p 0 4 4}cannot make a graph for "'		///
	`"{cmd:(`0copy')}{p_end}"'
local allplots 
			}
		}


		if "`individual'" == "" {
			local nodraw nodraw	
		}	

		if `"`allplots'"' != "" {


			if "`individual'" == "" {
				if `"`name'"' == "" {
					tempname tname`j'
					local snames `"`snames' `tname`j'' "'
					local dropnames "`dropnames' `tname`j'' "
					local name "name(`tname`j'')"
				}	
				else {
					local snames `"`snames' `sn_name' "'
				}	
			}

		
			graph twoway `allplots' 		///
				if irfname == "`irfname'" 	///
				& impulse  == "`impulse'"  	///
				& response == "`response'"	///
				`ifstep' ,			///
				`nodraw'			///
				ytitle("")			///
				`name'				///
				`tmac' `s_save'			///
				`twg_opts' `scheme' `graphopts'
			 

			ret local stats`j' `stats'
			ret local irfname`j' `irfname'
			ret local impulse`j' `impulse'
			ret local response`j' `response'
			ret local title`j' `"`tmacs'"'
			ret local save`j' `"`s_saves'"'
			ret local name`j' `"`name_s'"'

			if "`cim'" == "" {
				ret local ci`j' `level'
			}
			else {
				ret local ci`j' `cim'
			}	

	
			if "`individual'" != "" & `"`gcmds'"' != "" {	
				more	
			}	

		}		
		
	}


	if "`individual'" == "" {
		local rows = ceil(sqrt(`j'))
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

		local tgraphs : word count `snames'
		
		if `tgraphs' > 0 {
			graph combine `snames', `c_save' `cn_save'	///
				`c_tmac' iscale(`iscale') 		///
				imargin(`imargin') `scheme' `comb_opts'
			ret local title `"`c_tmacs'"'
			ret local save `"`c_saves'"'
			ret local name `"`cn_saves'"'
		}	
	}
	else {
		ret local individual individual
	}	

	ret scalar k = `j'

	if "`dropnames'" != "" {
		capture graph drop `dropnames'
		if _rc > 0 {
			di as err "could not drop temporary "	/*
				*/ "graphs `dropnames'"
		}
	}

	restore

end


program define	SAVEPARSE, rclass
	syntax anything(id="filename" name=fname) [, replace]
	local fname `fname'
	ret local fname    `"`fname'"'
	ret local replace  `replace'
end

program define	NAMEPARSE, rclass
	syntax name(id="filename" name=name) [, replace]
	local name `name'
	ret local name    `"`name'"'
	ret local replace  `replace'
end

program define MissErr
	syntax varname, irfname(string)
	di as txt "{p 0 4}`varlist' contains all missing values "	///
		"for irf results `irfname'{p_end}"
	di as txt "statistic dropped from specification"
	di
end


program define StdMissErr
	syntax varname, irfname(string) model(string)

	if "`model'" != "vec" {
		di as txt "{p 0 4}standard errors not computed for "	///
			"`varlist' in irf results `irfname'{p_end}"
		di as txt "cannot compute confidence interval"
	}	
end	

program define HayObs, rclass
	syntax varname, irfname(string) impulse(string) response(string)
	
	qui count if `varlist' < . & irfname == "`irfname'"  	///
		& impulse  == "`impulse'"  	/// 
		& response == "`response'"


	ret scalar N = r(N)
end	
exit
