*! version 1.0.1  12feb2018

program _mswitch_print, eclass
	version 14.0
	syntax [anything] [if] [in] 				///
		[, 						///
			Level(cilevel) 				///
			NOCNSReport				///
			vsquish					///
			NOEMPTYcells				///
			BASElevels				///
			ALLBASElevels				///
			NOOMITted				///
			nofvlabel				///
			fvwrap(string)				///
			fvwrapon(string)			///
			cformat(string)				///
			pformat(string)				///
			sformat(string)				///
			nolstretch				///
			coeflegend				///
			*					///
		]

	local chkdiopts noci nopvalues
        local chkdiopts : list chkdiopts & 0
	if ("`chkdiopts'"=="noci" | wordcount("`chkdiopts'")==2) {
		di as err "{p}option {bf:noci} not allowed{p_end}"
		exit 198
	}
        else if ("`chkdiopts'"=="nopvalues") {
		di as err "{p}option {bf:nopvalues} not allowed{p_end}"
		exit 198
	}



	ereturn hidden scalar level = `level'	//hidden, used for replay

/*Print header*/
	di as txt _n "`e(title)'"

	local disample "{txt:Sample}:{res: `e(tmins)' - `e(tmaxs)'} " 
	if (length(`"`e(tmins)' - `e(tmaxs)'"')>=39) di _n "`disample'" _n /*
		*/"{col 49}Number of obs {col 67}= " as res %10.0fc e(N)
	else di _n "`disample'" "{col 49}Number of obs {col 67}= " as res 	/*
		*/ %10.0fc e(N)
	
	di as txt "Number of states{col 18}= " as res %4.0g `e(states)' /*
		*/ as txt "{col 49}AIC{col 67}= " as res 	/*
		*/ %10.04f `e(aic)' 
	if (`e(states)'!=1) {
		di as txt "Unconditional probabilities:" as res 	/*
			*/ "{col 30}`e(p0)'" as txt 			/*
			*/ "{col 49}HQIC{col 67}= " as res %10.04f 	/*
			*/ `e(hqic)'
	}
	else di as txt "{col 49}HQIC{col 67}= " as res %10.04f `e(hqic)'
	di as txt "{col 49}SBIC{col 67}= " as res %10.04f `e(sbic)'
	di as txt "Log likelihood = " as res `e(ll)' _newline
	

/*Print estimation output*/
	local neq = `e(neq)'+`e(states)'*`e(num_reg)' + `e(nsig)'

	if (`"`coeflegend'"'!="") {
		_coef_table, neq(`neq') level(`level') `vsquish' 	    ///
		`noemptycells' `baselevels' `allbaselevels' `nofvlabel'	    ///
		fvwrap(`fvwrap') fvwrapon(`fvwrapon') 			    ///
		cformat(`cformat') pformat(`pformat') 			    ///
		sformat(`pformat') `nolstretch' `coeflegend' `nocnsreport'  ///
		`noomitted'
		exit
	}
	else _coef_table, neq(`e(neq)') level(`level') `vsquish' 	    ///
		`noemptycells' `baselevels' `allbaselevels' `nofvlabel'	    ///
		fvwrap(`fvwrap') fvwrapon(`fvwrapon') 			    ///
		cformat(`cformat') pformat(`pformat') 			    ///
		sformat(`pformat') `nolstretch' `coeflegend' `nocnsreport'  ///
		`noomitted'
		
end
