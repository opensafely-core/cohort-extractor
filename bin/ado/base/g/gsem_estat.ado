*! version 1.1.0  05feb2017
program gsem_estat
	version 13

	gettoken cmd : 0, parse(", ")

	if `"`cmd'"' == "eform" {
		gettoken cmd 0 : 0, parse(", ")
		Eform `0'
		exit
	}
	
	if `"`cmd'"' == "sd" {
		gettoken cmd 0 : 0, parse(", ")
		SD  `0'
		exit
	}

	local lcmd : length local cmd

	if `"`cmd'"' == bsubstr("summarize",1,max(2,`lcmd')) { 
		gettoken cmd 0 : 0, parse(", ")
		gsem_estat_summ `0'
		exit
	}

	if `"`e(lclass)'"' != "" {
		if `"`cmd'"' == "lcgof" {
			if e(fmmcmd) == 1 {
				di as err "{bf:estat lcgof} not valid"
				exit 321
			}
			gettoken cmd 0 : 0, parse(", ")
			gsem_estat_lcgof `0'
			exit
		}
		if `"`cmd'"' == "lcmean" {
			gettoken cmd 0 : 0, parse(", ")
			gsem_estat_lcmargins lcmean `0'
			exit
		}
		if `"`cmd'"' == bsubstr("lcprob",1,max(4,`lcmd')) { 
			gettoken cmd 0 : 0, parse(", ")
			gsem_estat_lcmargins lcprob `0'
			exit
		}
	}

	estat_default `0'
end

program SD
	if e(fmmcmd) == 1 {
		di as err "{bf:estat sd} not valid"
		exit 321
	}
	if "`e(b_sd)'"!="matrix" {
		di as err "current estimation results do not support " ///
			"{bf:estat sd}"
		exit 322
	}
	syntax [, *]
	gsem_display, noheader disd `options'
end

program Eform
	syntax [anything(name=eqlist)] [, byparm *]

	if `"`eqlist'"' == "" {
		local eqlist `"`e(depvar)'"'
		gettoken eqlist : eqlist
	}

	_get_diopts options, `options'
	local ignore nocnsreport fullcnsreport
	local options : list options - ignore
	gsem_display,	noheader		///
			nodvheader		///
			eform			///
			eqselect(`eqlist')	///
			nocnsreport		///
			`byparm'		///
			`options'
end

exit
