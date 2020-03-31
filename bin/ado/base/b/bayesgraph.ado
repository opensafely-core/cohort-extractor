*! version 1.2.0  07nov2019
program bayesgraph
	version 14
	local vv : di "version " string(_caller()) ", missing :"

	mata: getfree_mata_object_name("mcmcobject", "g_mcmc_model")
	local mobj mcmcobject(`mcmcobject')
	
	// load parameters sorted by eqnames in global macros 
	// to be used by _mcmc_fv_decode in _mcmc_expand_paramlist
	_bayesmh_eqlablist import
	
	// trim white space
	local 0 `0'
	syntax [anything] [using] [, CHAINs(string) SEPCHAINs *]
	
	GetChains, user(`chains') `options'
	local chains `r(chains)'
	local chainnote `r(chainnote)'

	local nchains 1
	if `"`e(nchains)'"' != "" {
		local nchains `e(nchains)'
	}

	local first : word 1 of `anything'
	if `"`first'"' == "matrix" {
		local k : list sizeof chains
		if `nchains' > 1 & "`sepchains'" == "" & `k' > 1 {
			di as txt "(note: bayesgraph matrix implies "	///
				"option sepchains)"
		}
		local sepchains sepchains
		local chainlist chainlist(`chains')
	}
	
	if "`sepchains'" != "" {
		local off 0
		foreach c of local chains {
			if `nchains' > 1 {
				local chainnote chainnote(`"Chain `c'"')
			}
			capture noi `vv' _bayesgraph `anything' `using',  ///
				`mobj'	`options' chains(`c') `chainnote' ///
				off(`off') sepchains(1) `chainlist'
				
			local rc = _rc
			if `rc' {
				_bayesmh_eqlablist clear
				capture mata: mata drop `mcmcobject'
				exit `rc'
			}
			local off = `r(off)'
		}
	}
	else {
		if `nchains' > 1 {
			local chainnote chainnote(`"`chainnote'"')
		}
		capture noi `vv' _bayesgraph `anything' `using', `mobj' `options' ///
			chains(`chains') `chainnote' off(0)
		local rc = _rc
		_bayesmh_eqlablist clear
		capture mata: mata drop `mcmcobject'
		exit `rc'
	}
end

program _bayesgraph, rclass
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	
	// common multiopts
	syntax [anything] [using], 	///
		MCMCOBJECT(string) 	///
		[SKIP(passthru)		///
		noLEGend		///
		noLABEL			///
		COMBINEf		///
		combine(string)		///
		BYPARMf			///
		byparm(string asis)	///
		sleep(string)		///
	 	wait			///
		name(string)		///
		saving(string)		///
		NOCLOSEe		///
	      	CLOSE			///
		nobinrescale		///
		CHAINs(string)		///
		CHAINSLEGend		///
		sepchains(integer 0)	/// internal
		chainlist(string)	/// internal
		chainnote(string asis)	/// internal
		NOCHAINNOTE		/// internal
		BYCHAINf		/// internal
		bychain(string asis)	/// internal
		freq			/// undocumented
	 	genecusum		/// undocumented
	 	off(string)		/// undocumented
		graphopts(string) 	///
		chainopts(string asis)	///
		SHOWREffects SHOWREffects1(string) ///
		PREDictiondata * ]

	_bayesmhpost_options `"`skip'"'
	local every = `s(skip)' + 1
	local origopts `options'
	// get graph type
	local 0 `anything'
	gettoken graphtype 0 : 0, parse(",\ ")
	ParseGraphType, `graphtype'
	local graphtype `r(graphtype)'

	// Set sleeptime
	if "`sleep'" != "" {
		capture confirm number `sleep'
		local rc = _rc
		if !`rc' {
			capture assert `sleep' >= 0
			local rc = _rc | `rc'
		}
		if `rc' {
			di as err ///
	"{p}option {bf:sleep()} must contain a nonnegative integer{p_end}"
			exit 198
		}
		local sleep = `sleep'*1000
	}

	if "`closee'" != "" & "`close'" != "" {
		opt_exclusive "noclose close"
		exit 198
	}
	if "`binrescale'" == "nobinrescale" {
		local binrescale
	}
	else {
		local binrescale binrescale
	}

	// check -showreffects- and -showreffects1-
	if ("`e(cmd)'" == "bayesmh" | "`e(latparams)'" == "" ) & ///
		("`showreffects'" != "" | "`showreffects1'" != "") {
		di as err "{p}options {bf:showreffects} and " ///
			"{bf:showreffects()} are supported only after " ///
			"multilevel models fit using the {helpb bayes} " ///
			"prefix{p_end}"
		exit 198
	}

	local nchains 1
	if `"`e(nchains)'"' != "" {
		local nchains `e(nchains)'
	}
	if `nchains'==1 {
		local bychainf
		local bychain
		local chainslegend
	}

	if "`chainslegend'" != "" {
		local chainnote
	}

	// check argument combinations that don't depend
	// on the number of parameters
	if ("`combine'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:combine()} for graph type "	///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
		else if `"`byparmf'"' != "" {
			opts_exclusive "combine() byparm"
		}
		else if `"`byparm'"' != "" {
			opts_exclusive "combine() byparm()"
		}
		else if `"`bychainf'"' != "" {
			opts_exclusive "combine() bychain"
		}
		else if `"`bychain'"' != "" {
			opts_exclusive "combine() bychain()"
		}
	}
	if ("`combinef'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:combine} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
		else if `"`byparmf'"' != "" {
			opts_exclusive "combine byparm"
		}
		else if `"`byparm'"' != "" {
			opts_exclusive "combine byparm()"
		}
		else if `"`bychainf'"' != "" {
			opts_exclusive "combine bychain"
		}
		else if `"`bychain'"' != "" {
			opts_exclusive "combine bychain()"
		}
	}
	if ("`byparmf'" != "") {
		if `"`bychainf'"' != "" {
			opts_exclusive "byparm bychain"
		}
		else if `"`bychain'"' != "" {
			opts_exclusive "byparm bychain()"
		}
	}
	if ("`byparm'" != "") {
		if `"`bychainf'"' != "" {
			opts_exclusive "byparm() bychain"
		}
		else if `"`bychain'"' != "" {
			opts_exclusive "byparm() bychain()"
		}
	}
	if (`"`byparm'"' != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:byparm()} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
	}
	if (`"`byparmf'"' != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:byparm} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
	}
	if ("`bychainf'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:bychain} for graph type "	///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
	}
	if ("`bychain'" != "") {
		if "`diagnostics'`matrix'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:bychain()} for graph type "		///
				"{bf:`diagnostics'`matrix'}{p_end}"
			exit 198
		}
	}
	if "`matrix'" != "" {
		if "`wait'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:wait} for graph type "		///
				"{bf:matrix}{p_end}"
			exit 198
		}
		if "`sleep'" != "" {
			di as err "{p 0 4 2}cannot specify option "	///
				"{bf:sleep()} for graph type "		///
				"{bf:matrix}{p_end}"
			exit 198
		}
	}

	if `sepchains' {
		if ("`bychainf'" != "") {
			opts_exclusive "sepchains bychain"
		}
		if ("`bychain'" != "") {
			opts_exclusive "sepchains bychain()"
		}
	}
	
	
	if `"`byparmf'"' != "" & "`sleep'" != "" {
		opts_exclusive "byparm sleep()"
	}
	if `"`byparm'"' != "" & "`sleep'" != "" {
		opts_exclusive "byparm() sleep()"
	}
	if "`combinef'" != "" & "`sleep'" != "" {
		opts_exclusive "combine sleep()"
	}
	if "`combine'" != "" & "`sleep'" != "" {
		opts_exclusive "combine() sleep()"
	}
	if `"`byparmf'"' != "" & "`wait'" != "" {
		opts_exclusive "byparm wait"
	}
	if `"`byparm'"' != "" & "`wait'" != "" {
		opts_exclusive "byparm() wait"
	}
	if "`combinef'" != "" & "`wait'" != "" {
		opts_exclusive "combine wait"
	}
	if "`combine'" != "" & "`wait'" != "" {
		opts_exclusive "combine() wait"
	}

	local thetaok 0
	gettoken thetas 0 : 0, parse(",") bind
	if `"`thetas'"' == "_all" {
		local thetas
		local thetaok 1
	}
	
	local usefile
	if `"`using'"' != "" {
		gettoken tok using : using
		_bayespredict estrestore `"`using'"'
		local usefile `s(predfile)'
		_bayespredict_parse `"`thetas'"'
		if `"`s(expr)'"' != "" {
			local predictiondata predictiondata
		}
	}
	
	if `"`thetas'"' != "" & `"`thetas'"' != "," {
		if `"`predictiondata'"' == "" {
		// label:i.factorvar must be called as {label:i.factorvar} 
		// in order to expand properly
			_mcmc_expand_paramlist `"`thetas'"' `"`e(parnames)'"'
			local thetas `s(thetas)'
		}
		local thetaok 1
	}
	else if `thetaok' {
		local 0 `thetas'`0'
		//local thetas `e(parnames)'
		// use this routine to handle REs, not shown by default
		_bayesmhpost_paramlist thetas : "" ///
			`"`showreffects'"' `"`showreffects1'"'
	}

	if !`thetaok' {
		di as err "you must specify at least one parameter"
		exit 111
	}

	local 0 `name'

	syntax [anything] [, REPLACE *]
	local namelist `anything'
	local nameopts `options' replace

	local 0 `saving'
	syntax [anything] [, REPLACE *]
	if `"`anything'"' != "" {
		local filelist `anything'
		local saveopts `options' `replace'
	}
	local savefile

	// save current settings and data
	preserve
	local omore `c(more)'
	if "`wait'" != "" {
		set more on
	}
	
	local nn = `=`: list sizeof chains''
	
capture noi break {

	_mcmc_read_simdata, mcmcobject(`mcmcobject') 		///
		 thetas(`thetas')				///
		 using(`"`usefile'"') every(`every') norestore	///
		 nobaselevels `predictiondata'

	capture confirm variable _chain
	if _rc {
		qui gen int _chain = 1
	}
	
	if `nn' == 1 {
		qui keep if _chain == `chains'
	}

	qui gen double _fw = _frequency

	local numpars `s(numpars)'
	// parnames may contain ""
	local parnames `"`s(parnames)'"'
	local varnames `s(varnames)'
	local addvar `s(tempnames)'

	local 0 , `origopts'
	// Finish parsing
	local syni
	local syn
	forvalues i = 1/`numpars' {
		if "`matrix'" == "" {
			local syni graph`i'opts(string)
		}
		if "`diagnostics'" != "" {
			local syni `syni'		///	
				trace`i'opts(string)	///	
				hist`i'opts(string)	///	
				kdens`i'opts(string)	///
				ac`i'opts(string)
		}
		syntax [, `syni' *]
		local 0 , `options'
	}

	foreach i of local chains {
		local chai `chai' chain`i'opts(string)
		syntax [, `chai' *]
		local 0 , `options'
		local chainkopts `chainkopts' chain`i'opts(`chainopts' `chain`i'opts')
	}
	local chainmopts `chainkopts'
	local chainkopts chainopts(`chainkopts')

	if "`diagnostics'" != "" {
		local syn 			///	
			traceopts(string)	///	
			acopts(string)		///
			histopts(string)	///
			kdensopts(string)
	}
	
	syntax, [`syn' *]
	local ooptions `options'

	// graph graphi trace tracei
	
	if `"`graph1opts'"' != "" & "`diagnostics'" != "" {
		local 0, `graph1opts'
		foreach word in trace ac hist kdens {
			local o`word'1opts ``word'1opts'
			local o`word'opts ``word'opts'
			syntax [, `word'1opts(string) ///
				`word'opts(string) *]
			local graph1opts `options'
			local 0, `graph1opts'
			local `word'1opts	///
				``word'opts'	/// 
				``word'1opts' `o`word'1opts'
			local `word'opts `o`word'opts'
		}			 
	}
	forvalues i = 2/`numpars' {
		if `"`graph`i'opts'"' != "" & "`diagnostics'" != "" {
			local 0, `graph`i'opts'
			foreach word in trace ac hist kdens {
				local o`word'1opts ``word'1opts'
				local o`word'opts ``word'opts'
				syntax [, `word'1opts(string) ///
					`word'opts(string) *]
				local graph`i'opts `options'
				local 0, `graph`i'opts'
				local `word'`i'opts	///
					``word'opts'	///
					``word'1opts'	/// 
					``word'`i'opts'
				local `word'1opts `o`word'1opts'
				local `word'opts `o`word'opts'
			}			 
		}
	}

	if `"`graphopts'"' != "" & "`diagnostics'" != "" {
		local 0, `graphopts'
		local otraceopts `traceopts'
		local ohistopts `histopts'
		local okdensopts `kdensopts'
		local oacopts `acopts'
		syntax [, traceopts(string) histopts(string) ///
				kdensopts(string) acopts(string) *]
		local graphopts `options'
		local 0, `graphopts'
		local traceopts `traceopts' `otraceopts'
		local histopts `histopts' `ohistopts'
		local kdensopts `kdensopts' `okdensopts'
		local acopts `acopts' `oacopts'

		forvalues i = 1/`numpars'	{
			foreach word in trace ac hist kdens {
				local o`word'`i'opts ``word'`i'opts'
				syntax [, `word'`i'opts(string)  *]
				local graphopts `options'
				local 0, `graphopts'
				local `word'`i'opts	///
					``word'`i'opts'	///
					`o`word'`i'opts'
			}
		}
	}
	forvalues i = 1/`numpars' {
		if `"`byparmf'"' != "" & ///
			`"`graph`i'opts'"' != "" {
			opts_exclusive "byparm graph`i'opts()"
		}
		if `"`byparm'"' != "" & ///
			`"`graph`i'opts'"' != "" {
			opts_exclusive "byparm() graph`i'opts()"
		}
	}
	local options `ooptions'

	// parsing is done

	local twowayopts `options'
	local alloptions `options' `graphopts'

	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err  "MCMC object not found"
		exit _rc
	}
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 1 {
		di "no MCMC samples available"
		exit 2000
	}

	if "`matrix'" == "" & `"`combinef'`combine'`byparmf'`byparm'"'=="" {
		local nfiles: word count `filelist'
		if `nfiles'  >= 1 & `nfiles' < `numpars' {
			local n 1
			local flist `filelist'
			local filelist
			while `n' < `nfiles' {
				local stub: word `n' of `flist'
				local filelist `filelist' `stub'
				local n = `n' + 1
			}
			local stub: word `nfiles' of `flist'
			local n 1
			while `nfiles' <= `numpars' {
				local filelist `filelist' `stub'`n'
				local n      = `n' + 1
				local nfiles = `nfiles' + 1
			}
		}
	}
	if "`matrix'" == "" & `"`combinef'`combine'`byparmf'`byparm'"'=="" {
		local nnames: word count `namelist'
		if `nnames'  >= 1 & `nnames' < `numpars' {
			local n 1
			local nlist `namelist'
			local namelist
			while `n' < `nnames' {
				local stub: word `n' of `nlist'
				local namelist `namelist' `stub'
				local n = `n' + 1
			}
			local stub: word `nnames' of `nlist'
			local n 1
			while `nnames' <= `numpars' {
				local namelist `namelist' `stub'`n'
				local n      = `n' + 1
				local nnames = `nnames' + 1
			}
		}
	}
	local w: word count `namelist'
	if `"`byparm'`byparmf'`combine'`combinef'"' != "" & `w' > 1 {
		di as err "{p 0 4 2}invalid number of names specified in " ///
			"option {bf:name()}{p_end}"
		exit 198
	}
	local w: word count `filelist'
	if `"`byparm'`byparmf'`combine'`combinef'"' != "" & `w' > 1 {
		di as err "{p 0 4 2}invalid number of files specified in " ///
			"option {bf:saving()}{p_end}"
		exit 198
	}
	local cols 0
	local rows 0
	if `"`combinef'`combine'"' != "" {
		local combinef combinef
		local 0 , `combine'
		syntax [anything], [Cols(integer 0) Rows(integer 0) *]
		local combine `options'
		if `numpars' > 1 {
			if `cols' < 1 & `rows' < 1 {
				local cols = floor(sqrt(`numpars'))
			}
			if `cols' > `numpars' {
				local cols `numpars'
			}
			if `cols' <= 0 {
				if `rows' > `numpars' {
					local rows `numpars'
				}
				if `rows' < 1 {
					local rows 1
				}
				local cols = ceil(`numpars'/`rows')
			}
			else {
				local rows = ceil(`numpars'/`cols')
			}
		}
	}
	if `"`bychainf'`bychain'"' != "" {
		local bychainf bychainf
		local 0 , `bychain'
		syntax [anything], [Cols(integer 0) Rows(integer 0) *]
		local bychain `options'
		if `cols' < 1 & `rows' < 1 {
			local cols = floor(sqrt(`nchains'))
		}
		if `cols' > `nchains' {
			local cols `nchains'
		}
		if `cols' <= 0 {
			if `rows' > `nchains' {
				local rows `nchains'
			}
			if `rows' < 1 {
				local rows 1
			}
			local cols = ceil(`nchains'/`rows')
		}
		else {
			local rows = ceil(`nchains'/`cols')
		}
	}

	local ovarnames
	gettoken vartok varnames: varnames
	local i = 1
	while "`vartok'" != "" {
		capture confirm variable `vartok', exact
		local passin `vartok'
		if _rc {
			local passin `i'
			local i = `i' + 1
		}
		local ovarnames `ovarnames' `passin'
		gettoken vartok varnames: varnames	
	}	
	local varnames: copy local ovarnames
	local ovarnames
	local oparnames: copy local parnames
	local othetas: copy local thetas
	gettoken vartok varnames: varnames
	gettoken partok parnames: parnames
	gettoken thetatok thetas: thetas, bind
	while "`vartok'" != "" {
		capture confirm variable `vartok', exact
		local there = 1
		if _rc {
			tempvar vartok
			local addvar `addvar' `vartok'
			quietly mata: st_addvar("double", "`vartok'")
			quietly mata: st_store(., st_varindex(	///
				"`vartok'"),			///
				`mcmcobject'.find_param_data(	///
				`"`partok'"'))
			local there = 0
			label variable `vartok' `partok'
		}
		local ovarnames `ovarnames' `vartok'
		if ((substr(`"`thetatok'"',1,1) == "{" &	/// 
			substr(`"`thetatok'"',			///		
			length(`"`thetatok'"'),1) == "}") |	///
			(substr(`"`thetatok'"',1,1) == "(" &	/// 
			substr(`"`thetatok'"',			///		
			length(`"`thetatok'"'),1) == ")")) & 	///
			(subinstr(`"`thetatok'"',":","",1) != 	///
			`"`thetatok'"')  {	
			local s = substr("`thetatok'",2,length("`thetatok'")-2)
		}
		else {
			local s `thetatok'
		}
		if !`there' {
			local os = ltrim(rtrim(`"`s'"'))
			gettoken os1 os: os, parse(":")
			capture confirm name `os1'
			if _rc {
				local os `s'
			}
			else {
				gettoken colon os: os, parse(":")		
				local os = subinstr(`"`os'"'," ","",.)
			}
			if length(`"`os'"') < 15 {
				label variable `vartok' `"`os'"'
				char `vartok'[two] "No Note"
			}
			else {
				char `vartok'[two] "Note"
			}
			if subinstr(`"`s'"',"`partok'","",1) == `"`s'"' {
				local s `partok':`s'
			}
			char `vartok'[one] `"`s'"'
		}
		else {
			label variable `vartok' `"`s'"'
		}
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken thetatok thetas: thetas, bind
	}
	local varnames: copy local ovarnames
	local parnames: copy local oparnames
	local thetas: copy local othetas

	local everynote
        if `every' != 1 {
                label variable _index "Sample identifier"
		local everynote "Using thinning interval of `every'"
		if `"`byparm'`byparmf'"' != "" {
			local everynote "Graphs by parameter; `everynote'"
		}
        }
        else {
		if `"`byparm'`byparmf'"' != "" {
			local everynote "Graphs by parameter"
		}
                label variable _index "Iteration number"
        }
	
	if `"`matrix'`byparmf'`byparm'`combine'`combinef'"' != "" {
		local ovarnames: copy local varnames
		gettoken vartok varnames: varnames
		local note
		while "`vartok'" != "" {
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			local h: char `vartok'[two]
			if `"`g'"' != ""  & `"`h'"' == "Note" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			gettoken vartok varnames: varnames
		}
		if "`everynote'" != "" {
			local everynote note("`everynote'" `note' `chainnote')
		}
		else if `"`note'"' != "" {
			local everynote note(`note' `chainnote')
		}
		else if `"`chainnote'"' != "" {
			local everynote note(`chainnote')
		}
		local varnames: copy local ovarnames
	}

	if `"`freq'"' == ""  & "`matrix'" == "" {
		tempvar order
		gen double `order' = _n
		qui expand _fw
		qui replace _fw = 1
		qui sort _chain `order', stable
		qui by _chain: replace _index = _n
		sort _chain _index
		qui xtset _chain _index
	}
	if `"`freq'"' != "" & `"`matrix'`histogram'"' == "" {
		di as err "option {bf:freq} not allowed with graph type " ///
			`"`kdensity'`diagnostics'`trace'`ac'`cusum'"'
	}
	if `"`freq'"' != "" {
		local fw [fw=_fw]
	}

	qui xtset _chain _index
		
	if "`matrix'" != "" {
		if `numpars' < 2 {
			di as err "graph type {bf:`matrix'} " ///
				"requires at least two parameters"
			exit 198
		}
		if "`chainslegend'" != "" {
			di as err "option {bf:chainslegend} not allowed " ///
				"with {bf:bayesgraph matrix}"
			exit 198
		}
		local ++off
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local filename Graph__`off'
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local grname Graph__`off'
		}
		local 0 , `alloptions'
		syntax [anything], [msize(string) *]
		
		if `"`msize'"' == "" local msize tiny
		if "`freq'" == "" {
			tempvar order
			gen double `order' = _n
			qui expand _fw
			qui replace _fw = 1
			sort `order', stable
			qui replace _index = _n
			qui xtset _chain _index
		}

		foreach i of local chainlist {
			local 0 , `options'
			syntax [, chain`i'opts(string) *]
			if `i'==`chains' {
				local chainopts chainkopts(chain`i'opts(`chain`i'opts'))
			}
		}

		local lastopts msize(`msize') `everynote' `options' ///
			name(`grname',`nameopts') `savefile'
		GetGraph matrix `varnames', chains(`chains') ///
			`chainkopts' fw(`fw') lastopts(`lastopts')
		quietly `r(graph)'
				
	}
	else if "`diagnostics'" != "" {
		if "`chainslegend'" != "" {
			di as err "option {bf:chainslegend} not allowed " ///
				"with {bf:bayesgraph diagnostics}"
			exit 198
		}
		local combineopts `alloptions'
		local nth 0
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note' `chainnote')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note' `chainnote')
			}
			else if `"`chainnote'"' != "" {
				local everynote`nth' note(`chainnote')
			}
			local 0 , `traceopts' `trace`nth'opts'
			syntax [anything], [ title(passthru) 		///
				xtitle(passthru) ytitle(passthru) 	///
				by(passthru) *]
			local trace`nth'opts `options'
			if "`by'" != "" {
				di as err				/// 
				"{p 0 4 2}suboption {bf:by()} not "	///
				"allowed in {bf:trace`nth'opts()}{p_end}"
				exit 191
			}
			if `"`title'"' == "" local title title(Trace)
			if `"`xtitle'"' == "" {
				local xtitle: variable label _index
				local xtitle xtitle(`xtitle')
			}
			if `"`ytitle'"' == "" {
				local ytitle ytitle("")
			}
				
			GetGraph trace `vartok', chains(`chains') ///
				`chainkopts' traceopts(`trace`nth'opts')
			local gr_`nth'_tr ///
				`r(graph)', `title' `xtitle' `ytitle'  ///
				xlabel(,labsize(vsmall)) ylabel(,angle(0)) ///
				`r(gopts)' name(_`nth'_tr, replace) nodraw

			local 0 , `histopts' `hist`nth'opts'
			syntax [anything], [ by(passthru) title(passthru) ///
				xtitle(passthru) ytitle(passthru) *]
			local hist`nth'opts `options'
			if `"`title'"' == "" local title title(Histogram)
			if `"`xtitle'"' == "" local xtitle xtitle("")
			if `"`ytitle'"' == "" local ytitle ytitle("")
			if `"`by'"' != "" {
				di as err				/// 
				"{p 0 4 2}suboption {bf:by()} not "	///
				"allowed in {bf:hist`nth'opts()}{p_end}"
				exit 191
			}

			GetGraph histogram `vartok', chains(`chains') ///
				`chainkopts' fw(`fw') histopts(`hist`nth'opts')
			quietly `r(graph)' , ///
				`title'	`xtitle' `ytitle'  ///
			     	`r(gopts)' name(_`nth'_hist, replace) nodraw

			local 0 , `acopts' `ac`nth'opts'
			syntax [, GENerate(passthru) ci CIOPts(string)  ///
				by(passthru) title(passthru)		///
				xtitle(passthru)			///
				ytitle(passthru) *]
			local ac`nth'opts `options'
			local 0, `ac`nth'opts'
			syntax, [level(string) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not " ///
				"allowed in option {bf:ac`nth'opts()}{p_end}"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err	///
				"{p 0 4 2}suboption {bf:generate()} not " ///
				"allowed in option {bf:ac`nth'opts()}{p_end}"
				exit 198
			}
			if `"`title'"' == "" local title title(Autocorrelation)
			if `"`xtitle'"' == "" local xtitle xtitle("Lag")
			if `"`ytitle'"' == "" local ytitle ytitle("")
	
			if `"`ci'`ciopts'"' != "" {
				local ciopts ciopts(`ciopts')
			}
			else 	local ciopts ciopts(astyle(none))

			GetGraph ac `vartok', chains(`chains') ///
				`chainkopts' ix(`nth') `ciopts' msize(vsmall) ///
				acopts(`ac`nth'opts') ac(1)
			quietly `r(graph)', 			///
				`title'	`xtitle' `ytitle' ylabel(,angle(0)) ///
			     	note("") `r(ciopts)' `r(gopts)'	///
			     	name(_`nth'_ac, replace) nodraw

			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)'  local legpos 1

			local 0 , `kdensopts' `kdens`nth'opts'
			syntax [anything], [SHOW(string) 		///
				LEGend(string asis)			///
				title(passthru) xtitle(passthru) 	///
				ytitle(passthru)			///
				KDENSFirst(string) KDENSSecond(string) 	///
				GENerate(passthru) *] 
			local legendoff = 0
			if `"`legend'"' == "off" {
				local legendoff = 1
			}
			if `"`generate'"' != "" {
				di as err 				  ///
				"{p 0 4 2}suboption {bf:generate()} not " ///
				"allowed in option "			  ///
				"{bf:kdens`nth'opts()}{p_end}"
				exit 198
			}
			local kdens`nth'opts `options'

			local 0, `kdens`nth'opts'
			syntax ,[ by(passthru) NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not " ///
			"allowed in option {bf:kdens`nth'opts()}{p_end}"
				exit 191
			}
			local kdens`nth'normal = `"`normal'`normopts'"' != ""
			local norm`nth'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err 				 ///
				"{p 0 4 2}suboption {bf:student()} not " ///
			"allowed in option {bf:kdens`nth'opts()}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err 				///
				"{p 0 4 2}suboption {bf:stopts()} not " ///
				"allowed in {bf:kdens`nth'opts()}{p_end}"
				exit 198
			}
			local kdens`nth'opts `options'
			local 0, `kdensfirst'
			syntax ,[ by(passthru) GENerate(passthru)	///
				NORmal NORMOPts(string) 		///
				STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:generate()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 191
			}
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2} suboption {bf:student} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:stopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:normopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdensfirst()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			local 0, `kdenssecond'
			syntax ,[ by(passthru) 	GENerate(passthru)	///	
				NORmal NORMOPts(string) 		///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:generate()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 191
			}
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`student'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:student()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:stopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err ///
				"{p 0 4 2} suboption {bf:normopts()} not"
				di as err " allowed in option "
				di as err "{bf:kdenssecond()} specified within"
				di as err " option {bf:kdens`nth'opts()}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}

			// add plot
			local 0, `kdens`nth'opts'
			syntax, [addplot(string) *]
			local kdens`nth'opts `options'	
			
			if `"`title'"' == "" local title title(Density)
			if `"`xtitle'"' == "" local xtitle xtitle("")
			if `"`ytitle'"' == "" local ytitle ytitle("")

			local t1 = floor(_N/2)
			local t2 = _N
			local nn = floor(_N/`nchains'/2)
			tempvar n1 n2
			gen byte `n1' = _index <= `nn'
			gen byte `n2' = _index >= `nn'
					
			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`nth'normal'  {
					local legend`nth'		///
					legend(pos(`legpos')		///
					ring(0) col(1) order(1 2 3)	///
					label(1 "all")			///
					label(2 "1-half")		///
					label(3 "2-half") 		///
					symxsize(7) `legend')
				}
				else {
					local legend`nth'		///
					legend(pos(`legpos')		///
					ring(0) col(1) order(1 2 3 4)	///
					label(1 "all")			///
					label(2 "Normal density")	///
					label(3 "1-half")		///
					label(4 "2-half") 		///
					symxsize(7) `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			else if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth' 		///
					legend(pos(`legpos')		/// 
					ring(0) col(1) order(1 2)	///
					label(1 "all")			///
					label(2 "1-half") `legend')
				}
				else {
					local legend`nth' 		///
					legend(pos(`legpos')		/// 
					ring(0) col(1) order(1 2 3)	///
					label(1 "all")			///
					label(2 "Normal density")	///
					label(3 "1-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			else if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth' 		///
					legend(pos(`legpos')		///
					ring(0) col(1) order(1 2)	///
					label(1 "all")			///
					label(2 "2-half") `legend')
				}
				else {
					local legend`nth' 		///
					legend(pos(`legpos')		///
					ring(0) col(1) order(1 2 3)	///
					label(1 "all")			///
					label(2 "Normal density")	///
					label(3 "2-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			else if `"`show'"' == "none" {
				local Ngraph
				if `kdens`nth'normal' {
					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'

					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "Normal density") `legend')
				}
				else local legend`nth' legend(off)
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			
			if inlist("`show'","none","first") local first second(0)
			if inlist("`show'","none","second") local second first(0)
			
			local lastopts ///
				`title'					///
				`xtitle'				///
				`ytitle'				///
				`legend`nth''				///
				name(_`nth'_kdens, replace) nodraw

			GetGraph kdensity `vartok', chains(`chains') ///
				`chainkopts' ///
				ngraph(`Ngraph') /*graphnthopts(`graph`nth'opts')*/ ///
				nfirst(`nfirst') kdensfirst(`kdensfirst') ///
				nsecond(`nsecond') kdenssecond(`kdenssecond') ///
				lastopts(`lastopts') n1(`n1') n2(`n2') ///
				`first' `second' kdensopts(`kdens`nth'opts')
			quietly `r(graph)' || `addplot'
			
			local partok`nth' `partok'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local more`nth' 0
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				local more`nth' 1
			}

			local close`nth' 0
			if "`close'" != ""  & "`vartok'" != "" {
				local close`nth' 1
			}
		}
		local totd = `nth'
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		local nnth = `off'
		forvalues nth = 1/`totd' {
			local ++nnth
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nnth'
				}
				local savefile ///
					saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nnth'
			}
			`gr_`nth'_tr'
			`gr_`nth'_ac'
			local 0 , `combineopts'
			syntax [anything], [Cols(integer 2)	///
				imargin(string) title(passthru) *]
			if `"`imargin'"' == "" local imargin small
			if `"`title'"' == "" local title title({bf:`partok`nth''})
			local combineoptsi `options'

			quietly graph combine _`nth'_tr _`nth'_hist	///
				_`nth'_ac _`nth'_kdens,			/// 
				cols(`cols') imargin(`imargin')		///
				`title' `combineoptsi'			///
				`everynote`nth''			///
				`graph`nth'opts'			///
				name(`grname',`nameopts') `savefile'
			local ogname `grname'
			quietly graph drop _`nth'_tr
			quietly graph drop _`nth'_hist
			quietly graph drop _`nth'_ac
			quietly graph drop _`nth'_kdens
			if "`sleep'" != "" {
				sleep `sleep'
			}
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
			if `more`nth'' {
				more
			}
			if `close`nth'' {
				graph close `ogname'
			}
		}
		local off = `nnth'
	}
	else if `"`trace'"' != "" & `"`byparmf'`byparm'"' != "" {
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		if `sepchains' {
			local ++off
			local grname Graph__`off'
		}
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param_`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		tempvar order
		qui gen `order' = _n
		qui reshape long _param_, i(`order') j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale noxrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `byparm'
		syntax, [noROWCOLDEFAULT Cols(passthru) Rows(passthru) *]
		local argcols cols(1)
		if "`cols'`rows'`rowcoldefault'" != "" {
			local argcols
		}
		local byparm `cols' `rows' `options'
		local xtitle: variable label _index
		local 0, `alloptions'
		syntax, [by(passthru) *]
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}
		GetGraph trace _param, chains(`chains') `chainkopts'
		quietly `r(graph)', xtitle("`xtitle'") ytitle("") ///
			ylabel(,angle(0)) `alloptions' by(_pname, ///
			title("Trace plots") `argyrescale' `argxrescale' ///
			`argcols' `everynote' `byparm' `r(gopts)') ///
			name(`grname',`nameopts') `savefile'
	}
	else if `"`trace'"' != "" & `"`combinef'`combine'"' != "" {
		local xtitle: variable label _index
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local ++off
			local grname Graph__`off'
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local 0, `alloptions' `graph`nth'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			if `numpars' > 1 {
				GetGraph trace `vartok', chains(`chains') ///
					`chainkopts'
				quietly `r(graph)' ,			///
					title(`"{bf:`partok'}"')	///
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					`alloptions' `r(gopts)'		///
					`graph`nth'opts'		///
					name(_`nth'_tr, replace) nodraw
				local grcombine `grcombine' _`nth'_tr
			}
			else {
				GetGraph trace `vartok', chains(`chains') ///
					`chainkopts'
				quietly `r(graph)', 			///
					title(`"Trace of {bf:`partok'}"') ///
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					`everynote' `r(gopts)'		///
					`alloptions' `graph`nth'opts'	///
					name(`grname',`nameopts')	///
					`savefile'
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		if `numpars' > 1 {
			graph combine `grcombine',		///
				cols(`cols') imargin(small)	///
				title(`"Trace plots"')		///
				`everynote'			///
				`combine'			///
				name(`grname',`nameopts')	///
				`savefile' 
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}		
	}
	else if `"`trace'"' != "" & `"`bychainf'`bychain'"' != "" {
		local xtitle: variable label _index
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local pth 0
		while "`vartok'" != "" {
			local ++pth
			local nth 0
foreach ch of local chains {
			local ++nth
			local 0, `alloptions' `graph`ch'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			local 0 , `chainkopts'
			syntax [, chainopts(string asis)]
			local 0 , `chainopts'
			syntax [, chain`ch'opts(string asis) *]
			local chopt traceopts(`traceopts' `chain`ch'opts')
			GetGraph trace `vartok', chains(`ch') `chopt'
			quietly `r(graph)' ,			///
				subtitle(`"Chain `ch'"')	///
				xtitle("`xtitle'") ytitle("")	///
				ylabel(,angle(0))		///
				`alloptions' `r(gopts)'		///
				`graph`ch'opts'			///
				name(_`nth'_tr, replace) nodraw
			local grcombine `grcombine' _`nth'_tr
}
			graph combine `grcombine',		///
				cols(`cols') imargin(small)	///
				title(`"Trace plot for {bf:`partok'}"')	///
				`everynote'			///
				`combine' ycommon		///
				name(Graph__`pth',`nameopts')	///
				`savefile' 
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
	}
	else if "`trace'" != "" {
		local xtitle: variable label _index
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist

		GetChainsLegend `chainslegend', chains(`chains')
		local chainlegend `r(chainslegend)'
		
		local nth  = `off'
		while "`vartok'" != "" {
			local ++nth
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile	///
				saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note' `chainnote')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note' `chainnote')
			}
			else if `"`chainnote'"' != "" {
				local everynote`nth' note(`chainnote')
			}
			local 0, `alloptions' `graph`nth'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			GetGraph trace `vartok', chains(`chains') `chainkopts'
//di as err "note is: `note'"
//di as err `"everynote`nth' is: `everynote`nth''"'
			quietly `r(graph)', xtitle("`xtitle'")		///
				ytitle("") title(`"Trace of {bf:`partok'}"') ///
				`everynote`nth'' `r(gopts)'		///
				`alloptions' `graph`nth'opts'		///
				`chainlegend' ///
				name(`grname',`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
				
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
		local off = `nth'
	}
	else if `"`cusum'"' != "" & `"`byparmf'`byparm'"' != "" {
		local xtitle: variable label _index
		gettoken grname namelist: namelist
		local oparnames `"`parnames'"'
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		if `sepchains' {
			local ++off
			local grname Graph__`off'
		}
		while "`vartok'" != "" {
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')		
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		local varnames: copy local ovarnames
		local parnames: copy local oparnames
		gettoken vartok ovarnames: ovarnames
		gettoken partok parnames: parnames
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param_`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok ovarnames: ovarnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}

		qui reshape long _param_, i(_chain _index) j(_pname)
				
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale noxrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `byparm'
		syntax, [noROWCOLDEFAULT Cols(passthru) Rows(passthru) *]
		local argcols cols(1)
		if "`cols'`rows'`rowcoldefault'" != "" {
			local argcols 
		}
		local byparm `cols' `rows' `options'
		local 0, `alloptions'
		syntax, [yline(string) by(passthru) *]
		local argyline yline(0)
		if `"`yline'"' != "" {
			local argyline 
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}
		
		GetGraph cusum _param_, chains(`chains') `chainkopts' ///
			cusumopts(`cusumopts')
		quietly `r(graph)', ///
			xtitle("`xtitle'") ytitle("") ylabel(,angle(0))	///
			`argyline' `alloptions' by(_pname, /// 
			title(`"Cusum plots"') `argyrescale' `argxrescale' ///
			`argcols' `everynote' `byparm' `r(gopts)') ///
			name(`grname',`nameopts') `savefile'
	}
	else if `"`cusum'"' != "" & "`combine'`combinef'" != "" {
		local xtitle: variable label _index
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local ++off
			local grname Graph__`off'
		}
		
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')
			local 0, `alloptions' `graph`nth'opts'
			syntax, [yline(string) by(passthru) *]
			local argyline yline(0)
			if `"`yline'"' != "" {
				local argyline 
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			if `numpars' > 1 {
				GetGraph cusum `vartok', chains(`chains') ///
					`chainkopts' cusumopts(`cusumopts')
				quietly `r(graph)',			///
					title(`"{bf:`partok'}"')	///   
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0)) `argyline'	///
					`alloptions' `r(gopts)'		///
					`graph`nth'opts'		///     
					name(_`nth'_cusum, replace) nodraw 
				local grcombine `grcombine' _`nth'_cusum
			}
			else {
				GetGraph cusum `vartok', chains(`chains') ///
					`chainkopts' cusumopts(`cusumopts')
				quietly `r(graph)',			///
					title(`"Cusum of {bf:`partok'}"') ///
					xtitle("`xtitle'")		///
					ytitle("") ylabel(,angle(0))	///
					`argyline' `r(gopts)'		///
					`everynote'			///
					`alloptions' `graph`nth'opts'	///
					name(`grname',`nameopts')	///
					`savefile'
			}

			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		if `numpars' > 1 {
			graph combine `grcombine',		///
				col(`cols') imargin(small)	///
				title(`"Cusum plots"')		///
				`everynote'			///
				`combine'			///
				name(`grname',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}
	}
	else if `"`cusum'"' != "" & `"`bychainf'`bychain'"' != "" {
		local xtitle: variable label _index
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local pth 0
		while "`vartok'" != "" {
			local ++pth
			local nth 0
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')
foreach ch of local chains {
			local nth = `nth' + 1
			local 0, `alloptions' `graph`ch'opts'
			syntax, [yline(string) by(passthru) *]
			local argyline yline(0)
			if `"`yline'"' != "" {
				local argyline 
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			local 0 , `chainkopts'
			syntax [, chainopts(string asis)]
			local 0 , `chainopts'
			syntax [, chain`ch'opts(string asis) *]
			local chopt cusumopts(`cusumopts' `chain`ch'opts')
			GetGraph cusum `vartok', chains(`ch') `chopt'
			quietly `r(graph)',			///
				subtitle(`"Chain `ch'"')	///
				xtitle("`xtitle'") ytitle("")	///
				ylabel(,angle(0)) `argyline'	///
				`alloptions' `r(gopts)'		///
				`graph`ch'opts'			///     
				name(_`nth'_cusum, replace) nodraw 
			local grcombine `grcombine' _`nth'_cusum
}
			graph combine `grcombine',		///
				col(`cols') imargin(small)	///
				title(`"Cusum plot for {bf:`partok'}"')	///
				`everynote'			///
				`combine' ycommon		///
				name(Graph__`pth',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
		
	}
	else if "`cusum'" != "" {
		local xtitle: variable label _index
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		
		GetChainsLegend `chainslegend', chains(`chains')
		local chainlegend `r(chainslegend)'
		
		local nth  = `off'
		while "`vartok'" != "" {
			local ++nth
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
				
			quietly summarize `vartok'
			quietly replace `vartok' = `vartok' - `r(mean)'
			quietly replace `vartok' = sum(`vartok')
			local 0, `alloptions' `graph`nth'opts'
			syntax, [yline(string) *]
			local argyline yline(0)
			if `"`yline'"' != "" {
				local argyline 
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note' `chainnote')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note' `chainnote')
			}
			else if `"`chainnote'"' != "" {
				local everynote`nth' note(`chainnote')
			}
			local 0, `alloptions' `graph`nth'opts'
			syntax , [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			GetGraph cusum `vartok', chains(`chains') `chainkopts' ///
				cusumopts(`cusumopts')
			quietly `r(graph)', 				///
				xtitle("`xtitle'") ytitle("")		///
				title(`"Cusum of {bf:`partok'}"')	///
				`everynote`nth'' `r(gopts)'		///
				`argyline' `alloptions' `graph`nth'opts' ///
				`chainlegend'				///
				name(`grname',`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
				
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
		local off = `nth'
	}
	else if `"`histogram'"' != "" & `"`byparmf'`byparm'"' != "" {
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		if `sepchains' {
			local ++off
			local grname Graph__`off'
		}
		local i = 1
		local lab
		while "`vartok'" != "" {
			rename `vartok' _param_`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		tempvar order
		gen `order' = _n
		qui reshape long _param_, i(`order' _fw) j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		local 0 , `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale xrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `alloptions'
		syntax, [by(passthru) LEGend(string asis) NORMal ///
			NORMOPts(passthru) KDENsity KDENOPts(passthru) *]

		local legendoff 0
		if `"`legend'"' == "off" | `"`legend'"' == "" {
			local legendoff 1
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}
		local legendpass label(1 "Density")
		if `"`normal'`normopts'"' != "" {
			local legendpass `legendpass' label(2 "Normal density")	
			if `"`kdensity'`kdenopts'"' != "" {
				local legendpass `legendpass'	///
					label(3 "Kernel density")
			}
		}
		else if `"`kdensity'`kdenopts'"' != "" {
			local legendpass `legendpass' label(2 "Kernel density")
		}
		local legend legend(`legendpass' `legend')
		if `legendoff' {
			local legendoff legend(off)			
		}
		else {
			local legendoff 
		}

		GetGraph histogram _param_, chains(`chains') 	///
			`chainkopts' fw(`fw') binrescale(`binrescale')
		quietly `r(graph)' , ///
			xtitle("") ytitle("") `alloptions' by(_pname, ///
			title(`"Histograms"') `argyrescale' `argxrescale' ///	
			`everynote' `byparm' `legendoff' /*`r(gopts)'*/) ///
			`r(binrescale)' `r(gopts)' `legend' ///
			name(`grname',`nameopts') ///
			`savefile' `r(chainiopts)'
	}
	else if "`histogram'" != "" & "`combinef'`combine'" != "" {
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local ++off
			local grname Graph__`off'
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local 0, `alloptions' `graph`nth'opts'
			syntax, [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}	
			if `numpars' > 1 {
				GetGraph histogram `vartok', chains(`chains') ///
					`chainkopts' fw(`fw')
				quietly `r(graph)' ,			///
					title(`"{bf:`partok'}"')	/// 
					xtitle("") ytitle("")		///
					ylabel(,angle(0)) `alloptions'	///
					`graph`nth'opts' `r(gopts)'	///
					name(_`nth'_hist, replace) 	///
					`r(chainiopts)' nodraw   
				
				local grcombine `grcombine' _`nth'_hist
			}
			else {
				GetGraph histogram `vartok', chains(`chains') ///
					`chainkopts' fw(`fw')
				quietly `r(graph)' ,			///
					title(				///
					`"Histogram of {bf:`partok'}"')	///
					xtitle("") ytitle("")		///
					ylabel(,angle(0))		///
					`everynote' `r(gopts)'		/// 
					`alloptions' `graph`nth'opts'	/// 
					name(`grname',`nameopts')	///
					`savefile' `r(chainiopts)'
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}

		if `numpars' > 1 {
			graph combine `grcombine',		///
				col(`cols') imargin(small)	///
				title(`"Histogram plots"')	///
				`everynote'			///
				`combine'			///
				name(`grname',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}
	}
	else if "`histogram'" != "" & `"`bychainf'`bychain'"' != "" {
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local pth 0
		while "`vartok'" != "" {
			local ++pth
			local nth 0
foreach ch of local chains {
			local ++nth
			local 0, `alloptions' `graph`ch'opts'
			syntax, [by(passthru) *]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			local 0 , `chainkopts'
			syntax [, chainopts(string asis)]
			local 0 , `chainopts'
			syntax [, chain`ch'opts(string asis) *]
			local chopt histopts(`histopts' `chain`ch'opts')
			GetGraph histogram `vartok', chains(`ch') ///
				`chopt' fw(`fw')
			quietly `r(graph)' ,			///
				subtitle(`"Chain `ch'"')	///
				xtitle("") ytitle("")		///
				ylabel(,angle(0))		///
				`everynote' `r(gopts)'		/// 
				`alloptions' `graph`ch'opts'	/// 
				name(_`nth'_hist, replace) 	///
				`r(chainiopts)' nodraw
			local grcombine `grcombine' _`nth'_hist
}
			graph combine `grcombine',		///
				col(`cols') imargin(small)	///
				title(`"Histogram plot for {bf:`partok'}"') ///
				`everynote'			///
				`combine' ycommon		///
				name(Graph__`pth',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
	}
	else if "`histogram'" != "" {
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist

		GetChainsLegend `chainslegend', chains(`chains')
		local chainlegend `r(chainslegend)'
		
		local nth = `off'
		while "`vartok'" != "" {
			local ++nth
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note' `chainnote')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note' `chainnote')
			}
			else if `"`chainnote'"' != "" {
				local everynote`nth' note(`chainnote')
			}

			local 0, `alloptions'
			syntax , [by(passthru) ///
				addplot(string) /* undocumented */ * ]
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			if `"`addplot'"' != "" {
				local addplot addplot(`addplot')
			}

			GetGraph histogram `vartok', chains(`chains')	///
				`chainkopts' fw(`fw') `addplot'
			quietly `r(graph)' , 				///
				xtitle("") ytitle("")			///
				title(`"Histogram of {bf:`partok'}"')	///
				`everynote`nth'' `r(gopts)'		///
				`alloptions' `graph`nth'opts'		///
				`chainlegend'				///
				name(`grname',`nameopts') 		///
				`savefile' `r(chainiopts)'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
			
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
		local off = `nth'
	}
	else if `"`ac'"' != "" & `"`byparmf'`byparm'"' != "" {
		local xtitle Lag
		local 0 , `alloptions'
		syntax [, generate(passthru) ci ciopts(passthru) ///
			by(passthru) level(string) *]
		if `"`generate'"' != "" {
			di as err "option {bf:generate()} not allowed"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}		
		if "`ci'" != "" & `"`byparmf'"' != "" {
			opts_exclusive "ci byparm"
		}
		if `"`ciopts'"' != "" & `"`byparmf'"' != "" {
			opts_exclusive "ciopts() byparm"
		}
		if "`ci'" != "" & `"`byparm'"' != "" {
			opts_exclusive "ci byparm()"
		}
		if `"`ciopts'"' != "" & `"`byparm'"' != "" {
			opts_exclusive "ciopts() byparm()"
		}
		if `"`level'"' != "" & `"`byparmf'"' != "" {
			opts_exclusive "level() byparm"
		}
		if `"`level'"' != "" & `"`byparm'"' != "" {
			opts_exclusive "level() byparm()"
		}
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		if `"`grname'"' == "" {
			local ++off
			local grname Graph__`off'
		}
		local i = 1
		local lab

if `nn' == 1 {
		while "`vartok'" != "" {
			rename `vartok' _param`i'
			qui ac _param`i', generate(_ac`i') ///
				`alloptions' nograph
			qui gen _lag`i' = _n if _ac`i' != .
			local parms _pname
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		qui reshape long _param _ac _lag, i(_index) j(_pname)
		local msize msize(small)
}
else {			
		while "`vartok'" != "" {
			rename `vartok' _param`i'
			foreach j of local chains {
				qui ac _param`i' if _chain==`j', ///
					generate(_ac`i'_`j') `alloptions' nograph
				qui gen _lag`i'_`j' = _n if _ac`i'_`j' != .
				qui gen _ix`i'_`j' = `j' if _ac`i'_`j' != .
			}
			local parms `parms' `i'
			local reshape `reshape' _ac`i'_ _lag`i'_ _ix`i'_
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}

		qui reshape long _param, i(_chain _index) j(_pname)

		qui reshape long `reshape', i(_chain _index _pname)
}

		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		
		local 0 , `alloptions'
		syntax [, GENerate(string) LAGs(passthru) ///
			level(string) fft *]
		local alloptions `options'
		local 0, `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale xrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'

		GetGraph ac `vartok', chains(`chains') `chainkopts' ///
			byparm(`parms') msize(small) ///
			acopts(`graph`nth'opts' `lags')
		qui `r(graph)'	 				///
			, xtitle("`xtitle'") ytitle("")		///
			ylabel(, angle(0)) note("") `msize'    	///
			`alloptions' `r(acopts)'		///
			by(_pname, title("Autocorrelations")	///	
			`argyrescale' `argxrescale'		///
			`everynote' `byparm' `r(gopts)')	///
			name(`grname',`nameopts') `savefile'
		
	}
	else if "`ac'" != "" & "`combinef'`combine'" != "" {
		local xtitle Lag
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local ++off
			local grname Graph__`off'
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			local 0 , `alloptions' `graph`nth'opts'
			syntax [, GENerate(passthru) LAGs(passthru)	///
				ci CIOPts(string) by(passthru) *]
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax ,[ level(passthru) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`ci'`ciopts'"' != "" {
				local ciopts ciopts(`ciopts')
			}
			else {
				local ciopts ciopts(astyle(none))
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			if `numpars' > 1 {
				GetGraph ac `vartok', chains(`chains') 	///
					/*`chainkopts'*/ ix(`nth') emptyok ///
					`ciopts' msize(small) ac(1) ///
					acopts(`graph`nth'opts' `lags')
				quietly `r(graph)'			///
					, title(`"{bf:`partok'}"')	///
					xtitle("`xtitle'") ytitle("")	///
					ylabel(,angle(0))		///
					note("") `r(gopts)'		///
					`r(ciopts)' /*`graph`nth'opts'*/ ///
					name(_`nth'_ac, replace) nodraw 
				local grcombine `grcombine' _`nth'_ac
			}
			else {
				GetGraph ac `vartok', chains(`chains') 	///
					/*`chainkopts'*/ ix(`nth') emptyok ///
					`ciopts' msize(small) ac(1) ///
					acopts(`graph`nth'opts' `lags')
				quietly `r(graph)',			///
					title(				///
				`"Autocorrelation of {bf:`partok'}"')	///
					xtitle("`xtitle'") 		///
					ytitle("")			///
					ylabel(,angle(0))		///
					note("") `r(gopts)'		///
					`everynote'			///
					`r(ciopts)' /*`graph`nth'opts'*/ ///    
					name(`grname',`nameopts')	///
					`savefile'
			}
				
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}

		if `numpars' > 1 {
			graph combine `grcombine',			///
				col(`cols') imargin(small)		///
				title(`"Autocorrelation plots"')	///
				name(`grname',`nameopts')		///
				`everynote'				///
				`combine' `savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}	
	}
	else if "`ac'" != "" & `"`bychainf'`bychain'"' != "" {
		local xtitle Lag
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local pth 0
		while "`vartok'" != "" {
			local ++pth
			local nth 0
foreach ch of local chains {
			local ++nth
			local 0 , `alloptions' `graph`ch'opts'
			syntax [, GENerate(passthru) LAGs(passthru)	///
				ci CIOPts(string) by(passthru) *]
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			local graph`ch'opts `options'
			local 0, `graph`ch'opts'
			syntax ,[ level(passthru) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`ci'`ciopts'"' != "" {
				local ciopts ciopts(`ciopts')
			}
			else {
				local ciopts ciopts(astyle(none))
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			local 0 , `chainkopts'
			syntax [, chainopts(string asis)]
			local 0 , `chainopts'
			syntax [, chain`ch'opts(string asis) *]
//			local chopt acopts(`graph`nth'opts' `lags')
			local chopt acopts(`acopts' `lags' `chain`ch'opts')
			GetGraph ac `vartok', chains(`ch') 	///
				`chopt' ix(`nth') emptyok 	///
				`ciopts' msize(small) ac(1)
			quietly `r(graph)' ,			///
				subtitle(`"Chain `ch'"')	///
				xtitle("`xtitle'") ytitle("")	///
				ylabel(,angle(0))		///
				note("") `r(gopts)'		///
				`r(ciopts)' /*`graph`ch'opts'*/ ///
				name(_`nth'_ac, replace) nodraw 
			local grcombine `grcombine' _`nth'_ac
}
			graph combine `grcombine',			///
				col(`cols') imargin(small)		///
				title(`"Autocorrelation plot for {bf:`partok'}"') ///
				name(`grname',`nameopts')		///
				`everynote' ycommon			///
				`combine' `savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		}
	}
	else if "`ac'" != "" {
		local xtitle Lag
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		
		GetChainsLegend `chainslegend', chains(`chains')
		local chainlegend `r(chainslegend)'
		
		local nth = `off'
		while "`vartok'" != "" {
			local ++nth
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note' `chainnote')
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note' `chainnote')
			}
			else if `"`chainnote'"' != "" {
				local everynote`nth' note(`chainnote')
			}
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			local 0 , `alloptions' `graph`nth'opts'
			syntax [, GENerate(passthru) LAGs(passthru)	///
				ci CIOPts(string) by(passthru) *]
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax ,[ level(passthru) *]
			if `"`level'"' != "" {
				local ci ci
			}
			if `"`ci'`ciopts'"' != "" {
				local ciopts ciopts(`ciopts')
			}
			else {
				local ciopts ciopts(astyle(none))
			}
			
			GetGraph ac `vartok', chains(`chains') `chainkopts' ///
				ix(`nth') `ciopts' ac(1) ///
				acopts(`graph`nth'opts' `lags')
			quietly `r(graph)', ytitle("")			///
				xtitle("`xtitle'") ylabel(, angle(0))	///
				`r(ciopts)' note("") title(		///
				`"Autocorrelation of {bf:`partok'}"')	///
				`everynote`nth'' `r(gopts)'		///
				`chainlegend'				///
				/*`graph`nth'opts'*/ name(`grname',	///
				`nameopts') `savefile'
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != ""  & "`vartok'" != "" {
				graph close `ogname'
			}
		}
		local off = `nth'
	}
	else if `"`kdensity'"' != "" & `"`byparmf'`byparm'"' != "" {
		gettoken grname namelist: namelist
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		if `sepchains' {
			local ++off
			local grname Graph__`off'
		}
		local 0 , `alloptions'
		syntax [anything], [SHOW(string) LEGend(string asis)	///
			GENerate(passthru) 				///
			KDENSFirst(string) KDENSSecond(string) by(passthru) *]
		local legendoff 0
		if `"`legend'"' == "off" {
			local legendoff 1
		} 
		if `"`generate'"' != "" {
			di as err "option {bf:generate()} not allowed"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "option {bf:by()} not allowed"
			exit 191
		}
		local alloptions `options'
		
		local i = 1
		local lab
		local list _param

		if !(	`"`show'"'=="first" | `"`show'"'=="second" |	///
			`"`show'"'=="none" | `"`show'"' =="" |		///
			`"`show'"' == "both") {
			di as err "{p 0 4 2}"		/// 
				"option {bf:show()} "	///
				"must be {bf:first}, "	///
				"{bf:second}, "		///
				"{bf:both}, or {bf:none}{p_end}"
			exit 198
		}
 
		local 0, `alloptions'
		syntax ,[ NORmal NORMOPts(string) ///
			  STUdent(string) STOPts(string) *]
		local kdensnormal = "`normal'`normopts'" != ""
		local normkopts `normopts'
		if "`student'" != "" {
			di as err "{p 0 4 2} option {bf:student()} not " ///
				"allowed{p_end}"
			exit 198
		}
		if "`stopts'" != "" {
			di as err "{p 0 4 2}option {bf:stopts()} not " ///
				"allowed{p_end}"
			exit 198
		}
		local alloptions `options'

		local 0, `kdensfirst'
		syntax ,[ NORmal NORMOPts(string) GENerate(passthru) ///
			  STUdent(string) STOPts(string) by(passthru) *]
		if `"`generate'"' != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:generate()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "{p 0 4 2}suboption {bf:by()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 191
		}		
		if "`normal'" != "" {
			di as err "{p 0 4 2}suboption {bf:normal} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if "`student'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:student()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if "`stopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:stopts()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		if "`normopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:normopts()} not allowed "
			di as err "in option {bf:kdensfirst()}{p_end}"
			exit 198
		}
		local kdensfirst `options'
		local nfirst n(300)
		if "`n'" != "" {
			local nfirst `n'
		}

		local 0, `kdenssecond'
		syntax ,[ NORmal NORMOPts(string)	/// 
			by(passthru) GENerate(passthru)	///
			  STUdent(string) STOPts(string) n(passthru) *]
		if `"`generate'"' != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:generate()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if `"`by'"' != "" {
			di as err "{p 0 4 2}suboption {bf:by()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 191
		}		
		if "`normal'" != "" {
			di as err "{p 0 4 2}suboption {bf:normal} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if "`student'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:student()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if "`stopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:stopts()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		if "`normopts'" != "" {
			di as err ///
			"{p 0 4 2}suboption {bf:normopts()} not allowed "
			di as err "in option {bf:kdenssecond()}{p_end}"
			exit 198
		}
		local kdenssecond `options'
		local nsecond n(300)
		if "`n'" != "" {
			local nsecond `n'
		}
		while "`vartok'" != "" {
			rename `vartok' _param`i'
			local lab = `"`lab'"' +  `" `i' "' + ///
				char(34) + `"`partok'"' + char(34)
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			local i = `i' + 1
		}
		tempvar order
		gen `order' = _n

		local t1 = floor(_N/2)
		local t2 = _N	
		local nn = floor(_N/`nchains'/2)
		tempvar n1 n2
		gen byte `n1' = _index <= `nn'
		gen byte `n2' = _index >= `nn'
		
		qui reshape long `list', i(`order' `first' `second' _fw) ///
			j(_pname)
		tempname labname
		label define `labname' `lab'
		label values _pname `labname'
		label variable _pname "parameter"
		sort _pname, stable
		local 0, `alloptions'
		syntax [, XTItle(passthru) YTItle(passthru) ///
			TItle(passthru) YLABel(passthru) *]
		local alloptions `options'
		local 0, `byparm'
		syntax [, noRescale noYRescale noXRescale ///
			Rescalee YRescalee XRescalee *]
		local argyrescale yrescale
		if "`rescale'`rescalee'" != "" {
			local argyrescale 
		}
		if "`yrescale'`yrescalee'" != "" {
			local argyrescale 
		}
		local argxrescale xrescale
		if "`rescale'`rescalee'" != "" {
			local argxrescale 
		}
		if "`xrescale'`xrescalee'" != "" {
			local argxrescale 
		}
		local byparm `options'
		local 0, `alloptions'
		syntax [, addplot(string) *]
		local alloptions `options'

		if "`show'" == "" {
			if _caller() < 16 local show both
			else local show none
		}	

		if "`show'" == "none" {
			if `kdensnormal' {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2)				///
				label(1 "overall")			/// 
				label(2 "Normal density"))
			}
			else local legendoff 1
		}

		if `kdensnormal' {
			local Ngraph				///
				yvarlab("normal _param")	///
				lstyle(refline)			///
				range(_param)			///
				`normkopts'	
		}
		
		if inlist("`show'","both","") {
			if !`kdensnormal' {
				local legend 				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2 3)				///
				label(1 "overall") 			///
				label(2 "1st-half")			///
				label(3 "2nd-half") `legend')		
			}
			else {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2 3 4)				///
				label(1 "overall")			/// 
				label(2 "Normal density")		///
				label(3 "1st-half")			///
				label(4 "2nd-half") `legend')		
			}
		}
		else if "`show'" == "first" {
			if !`kdensnormal' {
				local legend 				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2)				///
				label(1 "overall") 			///
				label(2 "1st-half")			///
				`legend')		
			}
			else {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2 3)				///
				label(1 "overall")			/// 
				label(2 "Normal density")		///
				label(3 "1st-half")			///
				`legend')		
			}
		}
		else if "`show'" == "second" {
			if !`kdensnormal' {
				local legend 				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2)				///
				label(1 "overall") 			///
				label(2 "2nd-half") `legend')		
			}
			else {
				local legend				///
				legend(pos(`legpos') ring(0) col(1)	///
				order(1 2 3)				///
				label(1 "overall")			/// 
				label(2 "Normal density")		///
				label(3 "2nd-half") `legend')		
			}
		}
		
		if inlist("`show'","none","first") local first second(0)
		if inlist("`show'","none","second") local second first(0)
		
		if `legendoff' {
			local legend legend(off)
		}
		if `legendoff' {
			local legendoff legend(off)
		}
		else {
			local legendoff 
		}
		
		local lastopts					///
			`alloptions'				///
			`nsecond' `kdenssecond'			///
			xtitle("") ytitle("")			/// 
			ylabel(,angle(0))			///
			by(_pname, title(`"Densities"') 	///
			`argyrescale' `argxrescale'		///
			`everynote' `byparm' `legendoff')	///
			name(`grname',`nameopts')		///
			`savefile'				///
			`legend'				///
			`xtitle' `ytitle' `ylabel' `title'
		
		`vv' ///
		GetGraph kdensity _param, chains(`chains') `chainkopts' ///
			ngraph(`Ngraph') graphnthopts(`graph`nth'opts') ///
			nfirst(`nfirst') kdensfirst(`kdensfirst') ///
			nsecond(`nsecond') kdenssecond(`kdenssecond') ///
			lastopts(`lastopts') n1(`n1') n2(`n2') ///
			`first' `second'
		`r(graph)' || `addplot'
	}
	else if "`kdensity'" != "" & "`combinef'`combine'" != "" {
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		gettoken grname namelist: namelist
		if `"`grname'"' == "" {
			local ++off
			local grname Graph__`off'
		}
		
		local t1 = floor(_N/2)
		local t2 = _N	
		local nn = floor(_N/`nchains'/2)
		tempvar n1 n2
		gen byte `n1' = _index <= `nn'
		gen byte `n2' = _index >= `nn'
		
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local nth 0
		while "`vartok'" != "" {
			local nth = `nth' + 1
			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)' {
				local legpos 1
			}

			local 0 , `alloptions' `graph`nth'opts'
			syntax [anything], [SHOW(string) by(passthru)	///
				GENerate(passthru) LEGend(string asis)	///
				KDENSFirst(string) KDENSSecond(string) *] 
			local legendoff 0
			if `"`legend'"' == "off" {
				local legendoff 1
			} 
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			local 0, `options'
			syntax [, 	XTItle(passthru) YTItle(passthru) ///
					TItle(passthru) YLABel(passthru) *]
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax ,[ NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			local kdens`nth'normal = "`normal'`normopts'" != ""
			local norm`nth'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err	/// 	
				"{p 0 4 2}option {bf:student()} not " ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err	/// 	
				"{p 0 4 2}option {bf:stopts()} not "   ///
					"allowed with overlaid graphs; "  ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `kdensfirst'
			syntax ,[ NORmal NORMOPts(string)	///
				  STUdent(string) by(passthru)	/// 	
				  GENerate(passthru)		///
				  STOPts(string) n(passthru) *]
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err "{p 0 4 2}suboption {bf:generate()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}	
			if "`normal'" != "" {
				di as err "{p 0 4 2}suboption {bf:normal} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2}suboption {bf:student()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:stopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:normopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			local kdensfirst `options'

			local 0, `kdenssecond'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2}suboption {bf:generate()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2}suboption {bf:by()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2}suboption {bf:normal} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2}suboption {bf:student()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:stopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:normopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}
			local 0,  `graph`nth'opts'
			syntax, [addplot(string) *]
			local graph`nth'opts `options'

			if "`show'" == "" {
				if _caller() < 16 local show both
				else local show none
			}
			
			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "1st-half")		///
					label(3 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3 4)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					label(4 "2nd-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "1st-half")		///
					`legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					`legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "2nd-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			if `"`show'"' == "none" {				
				local Ngraph
				if `kdens`nth'normal' {
					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'

					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "Normal density") `legend')
				}
				else local legend`nth' legend(off)
				
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			
			if inlist("`show'","none","first") local first second(0)
			if inlist("`show'","none","second") local second first(0)
		
			if `numpars' > 1 {
			//`graph`nth'opts'
			local lastopts	///
				`graph`nth'opts'		///
				/* `nfirst' `kdensfirst'	///
				`nsecond' `kdenssecond'*/	///
				`legend`nth''			///
				xtitle("") ytitle("")		///
				ylabel(,angle(0))		///
				title(`"{bf:`partok'}"')	///
				`xtitle' `ytitle' `ylabel'	///
				`title'				///
				name(_`nth'_kdens, replace)	///
				nodraw
			}
			else {
				local lastopts ///
				/*`nfirst' `kdensfirst'		///
				`nsecond' `kdenssecond'*/	///
				`legend`nth''			///
				xtitle("") ytitle("")		///
				ylabel(,angle(0))		///
				`everynote'			///
				title(				///
				`"Density of {bf:`partok'}"')	///
				name(`grname',`nameopts')	///
				`savefile' `xtitle' `ytitle'	///
				`title' `ylabel'
			}
			
			if `numpars' > 1 {
				`vv' ///
				GetGraph kdensity `vartok', chains(`chains') ///
				`chainkopts' ///
				ngraph(`Ngraph') graphnthopts(`graph`nth'opts') ///
				nfirst(`nfirst') kdensfirst(`kdensfirst') ///
				nsecond(`nsecond') kdenssecond(`kdenssecond') ///
				lastopts(`lastopts') n1(`n1') n2(`n2') ///
				`first' `second'
				quietly `r(graph)' || `addplot'
			
				local grcombine `grcombine' _`nth'_kdens
			}
			else {
				`vv' ///
				GetGraph kdensity `vartok', chains(`chains') ///
				`chainkopts' ///
				ngraph(`Ngraph') graphnthopts(`graph`nth'opts') ///
				nfirst(`nfirst') kdensfirst(`kdensfirst') ///
				nsecond(`nsecond') kdenssecond(`kdenssecond') ///
				lastopts(`lastopts') n1(`n1') n2(`n2') ///
				`first' `second'
				quietly `r(graph)' || `addplot'
			}
			
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		} // end of while

		if `numpars' > 1 {
			graph combine `grcombine',		///
				col(`cols') imargin(small)	/// 
				title(`"Density plots"')	///
				`everynote'			///
				`combine'			///         
				name(`grname',`nameopts')	///
				`savefile' 
				
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
		}
	}
	else if "`kdensity'" != "" & `"`bychainf'`bychain'"' != "" {
		// use the first filename
		if `"`saving'"' != "" {
			gettoken filename filelist: filelist
			if `"`filename'"' == "" {
				local nn = `off' +1
				local filename Graph__`nn'
			}
			local savefile saving(`filename',`saveopts')
		}
		local t1 = floor(_N/2)
		local t2 = _N	
		local nn = floor(_N/`nchains'/2)
		tempvar n1 n2
		gen byte `n1' = _index <= `nn'
		gen byte `n2' = _index >= `nn'
		
		local grcombine ""
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		local pth 0
		while "`vartok'" != "" {
			local ++pth
			local nth 0
foreach ch of local chains {
			local ++nth
			
			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)' {
				local legpos 1
			}

			local 0 , `alloptions' `graph`ch'opts'
			syntax [anything], [SHOW(string) by(passthru)	///
				GENerate(passthru) LEGend(string asis)	///
				KDENSFirst(string) KDENSSecond(string) *] 
			local legendoff 0
			if `"`legend'"' == "off" {
				local legendoff 1
			} 
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}		
			local 0, `options'
			syntax [, 	XTItle(passthru) YTItle(passthru) ///
					TItle(passthru) YLABel(passthru) *]
			local graph`ch'opts `options'
			local 0, `graph`ch'opts'
			syntax ,[ NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			local kdens`ch'normal = "`normal'`normopts'" != ""
			local norm`ch'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err	/// 	
				"{p 0 4 2}option {bf:student()} not " ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err	/// 	
				"{p 0 4 2}option {bf:stopts()} not "   ///
					"allowed with overlaid graphs; "  ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			local graph`ch'opts `options'
			local 0, `kdensfirst'
			syntax ,[ NORmal NORMOPts(string)	///
				  STUdent(string) by(passthru)	/// 	
				  GENerate(passthru)		///
				  STOPts(string) n(passthru) *]
			
			local 0 , `chainkopts'
			syntax [, chainopts(string asis)]
			local 0 , `chainopts'
			syntax [, chain`ch'opts(string asis) *]
			local chopt kdensopts(`chain`ch'opts')	
			
			if `"`by'"' != "" {
				di as err ///
				"{p 0 4 2}suboption {bf:by()} not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err "{p 0 4 2}suboption {bf:generate()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}	
			if "`normal'" != "" {
				di as err "{p 0 4 2}suboption {bf:normal} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2}suboption {bf:student()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:stopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:normopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdensfirst()}{p_end}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			local kdensfirst `options'

			local 0, `kdenssecond'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2}suboption {bf:generate()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2}suboption {bf:by()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2}suboption {bf:normal} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2}suboption {bf:student()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:stopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2}suboption {bf:normopts()} "
				di as err "not allowed"
				di as err " in option {bf:kdenssecond()}{p_end}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}
			local 0,  `graph`ch'opts'
			syntax, [addplot(string) *]
			local graph`ch'opts `options'

			if "`show'" == "" {
				if _caller() < 16 local show both
				else local show none
			}
			
			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`ch'normal' {
					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "1st-half")		///
					label(3 "2nd-half") `legend')
				}
				else {
					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3 4)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					label(4 "2nd-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`ch'opts'
				}
				if `legendoff' {
					local legend`ch' legend(off)
				}
			}
			if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`ch'normal' {
					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "1st-half")		///
					`legend')
				}
				else {
					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					`legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`ch'opts'
				}
				if `legendoff' {
					local legend`ch' legend(off)
				}
			}
			if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`ch'normal' {
					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "2nd-half") `legend')
				}
				else {
					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "2nd-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`ch'opts'
				}
				if `legendoff' {
					local legend`ch' legend(off)
				}
			}
			if `"`show'"' == "none" {				
				local Ngraph
				if `kdens`ch'normal' {
					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`ch'opts'

					local legend`ch'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "Normal density") `legend')
				}
				else local legend`ch' legend(off)
				
				if `legendoff' {
					local legend`ch' legend(off)
				}
			}
			
			if inlist("`show'","none","first") local first second(0)
			if inlist("`show'","none","second") local second first(0)
			
			local lastopts	///
				`graph`ch'opts'		///
				/* `nfirst' `kdensfirst'	///
				`nsecond' `kdenssecond'*/	///
				`legend`ch''			///
				xtitle("") ytitle("")		///
				ylabel(,angle(0))		///
				subtitle(`"Chain `ch'"')	///
				`xtitle' `ytitle' `ylabel'	///
				`title'				///
				name(_`nth'_kdens, replace)	///
				nodraw
			
			`vv' ///
			GetGraph kdensity `vartok', chains(`ch') ///
				/*`chainkopts'*/ ///
				`chopt' ///
				ngraph(`Ngraph') ///
				/*graphnthopts(`graph`ch'opts')*/ ///
				nfirst(`nfirst') kdensfirst(`kdensfirst') ///
				nsecond(`nsecond') kdenssecond(`kdenssecond') ///
				lastopts(`lastopts') n1(`n1') n2(`n2') ///
				`first' `second'
				quietly `r(graph)' || `addplot'
			
				local grcombine `grcombine' _`nth'_kdens
} // end of foreach
			graph combine `grcombine',		///
				col(`cols') imargin(small)	/// 
				title(`"Density plot for {bf:`partok'}"') ///
				`everynote'			///
				`combine' ycommon		///         
				name(Graph__`pth',`nameopts')	///
				`savefile'
			gettoken next grcombine: grcombine
			while "`next'" != "" {
				quietly graph drop `next'
				gettoken next grcombine: grcombine
			}
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
		} // end of while
	}
	else if "`kdensity'" != "" {
		gettoken vartok varnames: varnames
		gettoken partok parnames: parnames
		gettoken filename filelist: filelist
		gettoken grname namelist: namelist
		
		local t1 = floor(_N/2)
		local t2 = _N	
		local nn = floor(_N/`nchains'/2)
		tempvar n1 n2
		gen byte `n1' = _index <= `nn'
		gen byte `n2' = _index >= `nn'
		
		local nth  = `off'
		while "`vartok'" != "" {
			local ++nth
			if `"`saving'"' != "" {
				if `"`filename'"' == "" {
					local filename Graph__`nth'
				}
				local savefile saving(`filename',`saveopts')
			}
			if `"`grname'"' == "" {
				local grname Graph__`nth'
			}
			quietly summarize `vartok'
			local legpos 11
			if `r(max)' + `r(min)' > 2*`r(mean)' {
				local legpos 1
			}
			local note 
			local g: char `vartok'[one]
			local g = subinstr("`g'",":", ":  ",1)
			local g = subinstr(`"`g'"',"{","[",.)
			local g = subinstr(`"`g'"',"}","]",.)	
			local g = subinstr(`"`g'"',"[","{c -(}",.)
			local g = subinstr(`"`g'"',"]","{c )-}",.)
			if `"`g'"' != "" {
				local note = `"`note' "' + ///
					char(34) + `"`g'"' + char(34)
			}
			if "`everynote'" != "" {
				local everynote`nth' note("`everynote'" `note' `chainnote') 
			}
			else if `"`note'"' != "" {
				local everynote`nth' note(`note' `chainnote')
			}
			else if `"`chainnote'"' != "" {
				local everynote`nth' note(`chainnote')
			}
			local 0 , `alloptions' `graph`nth'opts'
			syntax [anything], [SHOW(string) by(passthru) 	///
				GENerate(passthru) LEGend(string asis)	///
				KDENSFirst(string) KDENSSecond(string) *] 
			local legendoff 0
			if `"`legend'"' == "off" {
				local legendoff 1
			}
			if `"`by'"' != "" {
				di as err "option {bf:by()} not allowed"
				exit 191
			}
			if `"`generate'"' != "" {
				di as err "option {bf:generate()} not allowed"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `graph`nth'opts'
			syntax [, 	XTItle(passthru) YTItle(passthru) ///
					TItle(passthru) YLABel(passthru) *]
			local graph`nth'opts `options'
			syntax ,[ NORmal NORMOPts(string) ///
				  STUdent(string) STOPts(string) *]
			local kdens`nth'normal = "`normal'`normopts'" != ""
			local norm`nth'opts `normopts'
			if `"`show'"' != "none" & "`student'" != "" {
				di as err				 /// 
				"{p 0 4 2}option {bf:student()} not " 	 ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			if `"`show'"' != "none" & "`stopts'" != "" {
				di as err			 	 /// 
				"{p 0 4 2}option {bf:stopts()} not "  	 ///
					"allowed with overlaid graphs; " ///
					"specify {bf:show(none)}{p_end}"
				exit 198
			}
			local graph`nth'opts `options'
			local 0, `kdensfirst'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2} suboption {bf:generate()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2} suboption {bf:student()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:stopts()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:normopts()} "
				di as err ///
				"not allowed in option {bf:kdensfirst()}"
				di as err "{p_end}"
				exit 198
			}
			local nfirst `n'
			if "`n'" == "" {
				local nfirst n(300)
			}
			
			local kdensfirst `options'
			local 0, `kdenssecond'
			syntax ,[ NORmal NORMOPts(string) by(passthru)  ///
				  GENerate(passthru)			///
				  STUdent(string) STOPts(string) n(passthru) *]
			if `"`generate'"' != "" {
				di as err "{p 0 4 2} suboption {bf:generate()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if `"`by'"' != "" {
				di as err "{p 0 4 2} suboption {bf:by()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 191
			}		
			if "`normal'" != "" {
				di as err "{p 0 4 2} suboption {bf:normal} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if "`student'" != "" {
				di as err "{p 0 4 2} suboption {bf:student()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if "`stopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:stopts()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			if "`normopts'" != "" {
				di as err "{p 0 4 2} suboption {bf:normopts()} "
				di as err ///
				"not allowed in option {bf:kdenssecond()}"
				di as err "{p_end}"
				exit 198
			}
			local nsecond `n'
			if "`n'" == "" {
				local nsecond n(300)
			}
			local kdenssecond `options'
			local 0, `graph`nth'opts'
			syntax [, addplot(string) *]
			local graph`nth'opts `options'

			if "`show'" == "" {
				if _caller() < 16 local show both
				else local show none
			}
			
			
			
			
			if "`show'" == "first" local _1st 1
			else local _1st 0
			if "`show'" == "second" local _2nd 1
			else local _2nd 0
			if "`show'" == "both" {
				local _1st 1
				local _2nd 1
			}
			if "`show'" == "none" {
				local _1st 0
				local _2nd 0
			}
			
			local mult = `_1st' + `_2nd' + `kdens`nth'normal' + 1
//di as err `"first is `_1st', second is `_2nd', normal is `kdens`nth'normal'"'
			GetChainsLegend `chainslegend', chains(`chains') ///
				mult(`mult') xtra(pos(`legpos') ring(0)	col(1))
			local chainlegend `r(chainslegend)'
//di as err `"chain_legends is: `chainlegend'"'


			
			if `"`show'"' == "" | `"`show'"' == "both" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "1st-half")		///
					label(3 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3 4)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					label(4 "2nd-half") `legend')
				
					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			else if `"`show'"' == "first" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "1st-half")		///
					`legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "1st-half")		///
					`legend')
					
					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
					
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			else if `"`show'"' == "second" {
				local Ngraph
				if !`kdens`nth'normal' {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "2nd-half") `legend')
				}
				else {
					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2 3)		///
					label(1 "overall")		///
					label(2 "Normal density")	///
					label(3 "2nd-half") `legend')

					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'
				}
				if `legendoff' {
					local legend`nth' legend(off)
				}
			}
			else if `"`show'"' == "none" {
				local Ngraph
				if `kdens`nth'normal' {
					local Ngraph			///
					yvarlab("normal `vartok'")	///
					lstyle(refline)			///
					range(`vartok')			///
					`norm`nth'opts'

					local legend`nth'		///
				     	legend(pos(`legpos') ring(0)	///
					col(1) order(1 2)		///
					label(1 "overall")		///
					label(2 "Normal density") `legend')
				}
				else {
					local legend`nth' legend(off)
				}
			}
			
			if "`chainslegend'" != "" local legend`nth' `chainlegend'
			
			if inlist("`show'","none","first") local first second(0)
			if inlist("`show'","none","second") local second first(0)
						
			local lastopts ///
				`legend`nth'' xtitle("") ytitle("") ///
				ylabel(,angle(0)) `everynote`nth''  ///
				title(`"Density of {bf:`partok'}"') ///
				name(`grname',`nameopts') `savefile' ///
				 `xtitle' `ytitle' `ylabel' `title'

			`vv' ///
			GetGraph kdensity `vartok', chains(`chains') `chainkopts' ///
				ngraph(`Ngraph') graphnthopts(`graph`nth'opts') ///
				nfirst(`nfirst') kdensfirst(`kdensfirst') ///
				nsecond(`nsecond') kdenssecond(`kdenssecond') ///
				lastopts(`lastopts') n1(`n1') n2(`n2') ///
				`first' `second'
			`r(graph)' || `addplot'
						
			if "`sleep'" != "" {
				sleep `sleep'
			}
			local ogname `grname'
			gettoken vartok varnames: varnames
			gettoken partok parnames: parnames
			gettoken filename filelist: filelist
			gettoken grname namelist: namelist
				
			if "`vartok'" != "" & `"`wait'"' == "wait" {
				more
			}
			if "`close'" != "" & "`vartok'" != "" {
				graph close `ogname'
			}

		} // end of while
		local off = `nth'
	}
	
}  // end of noi capture break

	set more `omore'
	if _rc {
		restore
		exit _rc
	}
	if "`genecusum'" == "" {
		restore
	}
	else {
		restore, not
	}
	
	return local off `off'
end

program ParseGraphType, rclass
	local syntargs DIAGnostics trace ac HISTogram KDENSity cusum matrix
	syntax, [`syntargs' *]
	if "`options'" != "" {
		gettoken opt : options
		if `"`opt'"' == "{" | `"`opt'"' == "}" {
			di as err "`opt' invalid graph type"		
		}
		else 	di as err "{bf:`opt'} invalid graph type"
		exit 198
	}
	local ret `diagnostics'`trace'`ac'`histogram'`kdensity'`cusum'`matrix'
	foreach word of local syntargs {
		local uword = lower("`word'")
		c_local `uword' ``uword''
	}
	if "`ret'" == "" {
		di as err "graph type not specified"
		exit 198
	}
	return local graphtype `ret'  
end

program GetChains, rclass
	syntax [, user(string) noCHAINNOTE CHAINNOTEPOSition(string) *]
	
	local opts `options'
	
	local nchains 1
	if `"`e(nchains)'"' != "" {
		local nchains `e(nchains)'
	}
	local default 10 		// default number of chains to plot
	
	if `"`user'"' == "" {
		if `nchains' > `default' {
			local clist 1/`default'
			di as txt "(only the first `default' chains shown)"
			
		}
		else local clist 1/`nchains'
	}
	else if `"`user'"' == "_all" {
		local clist 1/`nchains'
	}
	else {
		local 0 , chains(`user')
		syntax , chains(numlist >=1 <=`nchains')
		local clist : list uniq chains
	}
	local 0, chains(`clist')
	syntax , chains(numlist)
	
	local clist 1/`nchains'
	local 0, clist(`clist')
	syntax , clist(numlist)
	local disallow : list clist - chains
	foreach i of local disallow {
		local 0 , `opts'
		syntax [, chain`i'opts(string) *]
		if `"`chain`i'opts'"' != "" {
			di as err "option {bf:chain`i'opts()} not allowed"
			exit 198
		}
	}

	if "`chainnote'" == "" & `nchains' > 1 {
		local chainnote `chains'
		mata: __invnumlist("chainnote")
		if `=`: list sizeof chains'' == 1 {
			return local chainnote `""Chain `chainnote'""'
		}
		else	return local chainnote `""Chains: `chainnote'""'
	}

	return local chains `chains'
end

program GetChainsLegend, rclass
	syntax [anything], chains(numlist) [mult(integer 1) xtra(string)]
	if "`anything'" == "" {
		exit
	}
	local k : list sizeof chains
	forvalues i=1/`k' {
		local ch : word `i' of `chains'
		if `mult' == 1 local pp `i'
		else local pp = (`i'-1)*`mult' + 1
		local label `label' label(`pp' "Chain `ch'")
		local order `order' `pp'
	}
	return local chainslegend legend(order(`order') `label' `xtra') legend(on)
end

program GetGraph, rclass
	version 16
	local vv = _caller()
	
	syntax [anything], chains(numlist) [chainopts(string) byparm(string) ///
		ix(integer 0) fw(string) emptyok ///
		ngraph(string asis) graphnthopts(string asis) nfirst(string) ///
		kdensfirst(string) nsecond(string) kdenssecond(string) ///
		lastopts(string asis) n1(string) n2(string) ///
		first(integer 1) second(integer 1) binrescale(string) ///
		msize(passthru) ciopts(passthru) ac(integer 0) ///
		traceopts(string) acopts(string) histopts(string) ///
		kdensopts(string) cusumopts(string) addplot(string)]
	
	local twoway twoway
	
	gettoken grtype anything : anything
	local anything_o `anything'
	gettoken vartok anything : anything
	gettoken xvar : anything

	local nn = `=`: list sizeof chains''

	// transparency
	local tt = floor(100/`nn')
	if `tt' < 30 local tt 30
	local tt "%`tt'"
	
	foreach i of local chains {
		local chai `chai' chain`i'opts(string)
	}

	if "`emptyok'" == "" {
		local 0 , `chainopts'
		syntax [, `chai']
	}

	// this part parses chain1opts( traceopts(...) ) and the like
	local otraceopts `traceopts'
	local oacopts `acopts'
	local ohistopts `histopts'
	local okdensopts `kdensopts'
	foreach i of local chains {
		local 0 , `chain`i'opts'
		syntax [, traceopts(string)	///	
			acopts(string)		///
			histopts(string)	///
			kdensopts(string) 	///
			*]
		local chain`i'opts `options'
		local trace`i'opts `traceopts'
		local ac`i'opts `acopts'
		local hist`i'opts `histopts'
		local kdens`i'opts `kdensopts'
	}
	local traceopts `otraceopts'
	local acopts `oacopts'
	local histopts `ohistopts'
	local kdensopts `okdensopts'

	if "`grtype'"== "cusum" {
		if `nn' == 1 {
			local twoway
			local gopts `cusumopts'
			local graph `graph' tsline `vartok' if _chain==`chains'
		}
		else {
			foreach i of local chains {
				local graph `graph' ///
(tsline `vartok' if _chain==`i', color(`tt') `chain`i'opts' `cusumopts')
			}
		}
	}
	
	if "`grtype'"== "trace" {
		if `nn' == 1 {
			local twoway
			local gopts `traceopts'
			local graph `graph' tsline `vartok' `fw' if _chain==`chains'
		}
		else {
			foreach i of local chains {
				local graph `graph' ///
(tsline `vartok' if _chain==`i', color(`tt') `chain`i'opts' `traceopts' `trace`i'opts')
			}
		}
	}
	
	
	if "`grtype'"== "histogram" {
if `nn' == 1 {
	local twoway
	local gopts `histopts'
	local graph `graph' histogram `vartok' `fw' if _chain==`chains'
}
else {
	local k 0
	foreach i of local chains {
		local p = mod(`k',15) +1
		local graph `graph' ///
(histogram `vartok' `fw' if _chain==`i', pstyle(p`p') color(`tt') `chain`i'opts' `histopts' `hist`i'opts')
		local ++k
	}
}
	}
	
	if "`grtype'"== "kdensity" {

		local k 0
		foreach i of local chains {
local p = mod(`k',15) +1
local ++k

if `k' == `nn' local OPTS `lastopts'

if `vv' < 16 {

local graph `graph' (kdensity `vartok' if _chain==`i' & (`n1' | `n2'), ///
	boundary color(`tt') clp(solid) lcol(dknavy) note("") `graphnthopts' `chain`i'opts' `OPTS' `kdensopts')

if `"`ngraph'"' != "" {
local graph `graph' (fn_normden `vartok' if _chain==`i' & (`n1' | `n2'), color(`tt') `ngraph')
}

if `first' {
local graph `graph' (kdensity `vartok' if _chain==`i' & `n1', ///
	boundary color(`tt') clp(dash) lcol(dkgreen) `nfirst' `kdensfirst' `chain`i'opts')
}

if `second' {
local graph `graph' (kdensity `vartok' if _chain==`i' & `n2', ///
	boundary color(`tt') clp(dot) lcol(purple) `nsecond' `kdenssecond' `chain`i'opts')
}

}
else {

if `nn'==1 {
	local opt0 lcol(dknavy)
	local opt1 lcol(dkgreen)
	local opt2 lcol(purple)
	local opt3
}
else {
	local opt0 pstyle(p`p') lwidth(medthick)
	local opt1 pstyle(p`p') lwidth(medthick)
	local opt2 pstyle(p`p') lwidth(medthick)
	local opt3 pstyle(p`p') lwidth(medthick)
}

local graph `graph' (kdensity `vartok' if _chain==`i' & (`n1' | `n2'), ///
	`opt0' boundary color(`tt') clp(solid) note("") `graphnthopts' ///
	`chain`i'opts' `OPTS' `kdensopts' `kdens`i'opts')

if `"`ngraph'"' != "" {
local graph `graph' (fn_normden `vartok' if _chain==`i' & (`n1' | `n2'), ///
	`opt3' color(`tt') `ngraph')
}

if `first' {
local graph `graph' (kdensity `vartok' if _chain==`i' & `n1', ///
	`opt1' boundary color(`tt') clp(dash) `nfirst' `kdensfirst' `chain`i'opts')
}

if `second' {
local graph `graph' (kdensity `vartok' if _chain==`i' & `n2', ///
	`opt2' boundary color(`tt') clp(dot) `nsecond' `kdenssecond' `chain`i'opts')
}

}
		}
	}
	
	if "`grtype'"=="ac" {
		local 0 , `acopts'
		syntax [, LAGs(string) Level(passthru) *]
		local acopts `options'
		if `"`lags'"' == "" {
//			local lags = min(floor(_N/`nchains'/2) -2, 40)
			local lags = min(floor(_N/`nn'/2) -2, 40)
		}
		if `"`byparm'"' != "" {
			foreach i in `byparm' {
				if `nn' == 1 {
					local j `chains'
					local pstyle pstyle(p1)
					local graph ///
					dropline _ac _lag if _lag != .
				}
				else {
					local k 0
					foreach j in `chains' {
						local p = mod(`k',15) +1
						local graph `graph' ///
(dropline _ac`i'_ _lag`i'_ if _ix`i' ==`j' & _pname == `i', /*base(0)*/ color(`tt') pstyle(p`p') msize(small))
						local ++k
					}
				}
			}
		}
		else {
			if `nn' == 1 & `ac' {
				local gopts `acopts' lags(`lags') `level'
				local graph ac `vartok' if _chain==`chains'
			}
			else {
				local k 0
				foreach i in `chains' {
					ac `vartok' if _chain==`i', lags(`lags') gen(ac`i'_`ix') nodraw
					qui gen lag`i'_`ix' = _n
					local p = mod(`k',15) +1
					local graph `graph' ///
(dropline ac`i'_`ix' lag`i'_`ix' in 1/`lags', /*base(0)*/ color(`tt') pstyle(p`p') msize(small) `chain`i'opts')
					local ++k
				}
			}
		}
	}
	
	if "`grtype'"=="matrix" {
		local twoway
		local graph graph matrix `anything_o' `fw' if _chain==`chains', ///
			`lastopts' `chain`chains'opts'
	}

	local gopts `gopts' legend(off)

	if `nn' == 1 {
		return local binrescale `binrescale'
		return local chainiopts `chain`chains'opts'	
		if "`grtype'"=="ac" {
			if `"`byparm'"' != "" {
				return local acopts `acopts'
			}
			else {
				local gopts `gopts' `msize'
			}
		}
		if `ac' {
			return local ciopts `ciopts'
			local twoway
		}	
	}
	return local gopts `gopts'
	return local graph `twoway' `graph'
	
end

mata:

void __invnumlist(string scalar s)
{
	string vector out
	transmorphic vector x
	string vector y
	real vector ix
	real scalar m, r, i
	
	// s is a local containing an expanded numlist
	// This functions replaces s with a 'contracted' numlist
	// which can be used to label variables, graphs, etc
	// For example, '1 3 2 7 6 5 9 10' will become '1-3, 5-7, 9, 10'
	
	x = strtoreal(tokens(st_local(s))')
	_sort(x,1)
	x = uniqrows(x)
	
	if (rows(x)==1) return
	
	m = max(x)
		
	y = J(m,1,0)
	y[x] = x
	
	ix = J(m,1,0)
	
	// construct a 'reverse running sum' for each group of numbers
	r = 0
	for (i=m; i>=1; i--) {
		if (y[i]) ix[i] = ++r
		else r = 0
	}
	
	out = ""
	for (i=1; i<=m; i++) {
		// do nothing for 0'
		// for the running sum =1 or =2, just add the numbers to the list
		if (ix[i]==1 | ix[i]==2) {
			out = out + " " + strofreal(y[i])
		}
		// for the running sum =3 or more, take the first and last
		// number and separate them by '-', advance the counter to the
		// end of the current running sum
		if (ix[i]>2) {
			out = out + " " + strofreal(y[i]) + "/" + strofreal(y[i+ix[i]-1])
			i = i + ix[i] - 1
		}	
	}
	
	out = tokens(out)
	out = invtokens(out,", ")
	
	st_local(s,out)
}

end

exit

