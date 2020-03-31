*! version 1.0.0  30apr2019
program meta__di_metainfo
	syntax [, nobs(string) 		///
		  stlbl(string) 	///
		  stsize(string) 	///
		  estype(string) 	///
		  eslbl(string) 	///
		  esvar(string)		///
		  sevar(string)		///
		  cilvar(string) 	///
		  ciuvar(string)	///
		  ciluser(string) 	///
		  ciuuser(string)	///
		  level(string)		///
		  method(string)	///
		  model(string)		///
		  short			///
		  ismetaq		///	
		  ]
	
	local toshow : char _dta[_meta_show]
	local toshow = cond(missing("`toshow'"), "on", "off")
	local cmdline : char _dta[_meta_setcmdline]
	local civarl : char _dta[_meta_civarlevel]
	if !missing("`civarl'") local extra ///
		`"", controlled by " as res "level()""'
	
	
	local cilu = cond("`ciluser'"=="_meta_cil", "", "`ciluser'")
	local ciuu = cond("`ciuuser'"=="_meta_ciu", "", "`ciuuser'")
	
	local ttl `""Meta-analysis setting information""'
	
	local unequal : char _dta[_meta_esopt_unequal]
	local holkinse : char _dta[_meta_esopt_holkinse]
	local zcadj : char _dta[_meta_zcadj]
	local zcval : char _dta[_meta_zcvalue]
	
	if !missing("`zcadj'") {
		if "`zcadj'" == "tacc" local zerocelladj "tacc"
		else if "`zcadj'" == "none" local zerocelladj "None"
		else local zerocelladj "`zcval', `zcadj'"
	}
	
	local seadj `unequal'`holkinse'
	local seadj = cond(missing("`seadj'"), "None", ///
		cond("`seadj'"=="unequal", "Unequal", "Hedges-Olkin"))
	
	if "`stlbl'" == "Generic" local lblfont as txt
	else local lblfont as res
	
	if "`estype'" == "Generic" {
		local esfont as txt
		if !missing("`ismetaq'") local ttl ///
		`""Meta-analysis setting information from " as res "meta set""'
	}
	else {
		local esfont as res
		if !missing("`ismetaq'") local ttl ///
		`""Meta-analysis setting information from " as res "meta esize""'
	}
	
	local col = 2
	
	if !missing("`short'") {
		if !missing("`ismetaq'") di  as txt `"-> `cmdline'"' _n
		di  _col(`=`col'+1') as txt "Effect-size label:  " ///
			as txt "`eslbl'"	
		di  _col(`=`col'+2') as txt "Effect-size type:  " ///
			`esfont' "`estype'"
		di _col(`=`col'+7') as txt "Effect size:  " as res "`esvar'"
		di _col(`=`col'+9') as txt "Std. Err.:  " as res "`sevar'"
		meta__model_desc, key(`method') meth(`model') col(`=`col'+13')
		exit
	}
	
	if missing("`stsize'") local ssfont as txt
	else local ssfont as res
	
	
	if !missing("`ismetaq'") di as txt `"-> `cmdline'"' 
	
	di _n as txt `ttl' _n
	
	di _col(`col') as txt "Study information"
	di _col(`=`col'+3') as txt "No. of studies:  " as res "`nobs'"
	di _col(`=`col'+6') as txt "Study label:  " `lblfont' "`stlbl'"
	
	local stsize = cond(missing("`stsize'"), "N/A", "`stsize'")
	di _col(`=`col'+7') as txt "Study size:  " `ssfont' "`stsize'"
	if "`: char _dta[_meta_datatype]'" != "Generic" {
		di _col(`=`col'+5') as txt "Summary data:  " as res ///
			"`: char _dta[_meta_datavars]'"
	}
	di
	
	di _col(`=`col'+6') as txt "Effect size"
	di _col(`=`col'+13') as txt "Type:  " `esfont' "`estype'"
	di _col(`=`col'+12') as txt "Label:  " as txt "`eslbl'"
	di _col(`=`col'+9') as txt "Variable:  " as res "`esvar'"
	if "`estype'" == "hedgesg" {
		local biascorec : char _dta[_meta_esopt_exact]
		local biascorec = cond(missing("`biascorec'"), ///
			"Approximate", "Exact")
	di _col(`=`col'+2') as txt "Bias correction:  " as txt "`biascorec'"	
	}
	if !missing("`zerocelladj'") {
		di _col(`=`col'+2') as txt "Zero-cells adj.:  " as res ///
			"`zerocelladj'"
	}
	else if inlist("`estype'", "lnoratio", "lnrratio") {
		di _col(`=`col'+2') as txt "Zero-cells adj.:  " as txt ///
			"None; no zero cells"
	}
	
	di
	
	di _col(`=`col'+8') as txt "Precision"
	di _col(`=`col'+8') as txt "Std. Err.:  " as res "`sevar'"
	if inlist("`estype'", "hedgesg", "cohensd", "cohend", "mdiff", "rmd") {
		di _col(`=`col'+3') as txt "Std. Err. adj.:  " as txt "`seadj'"
	}
	di _col(`=`col'+15') as txt "CI:  " as txt "[" as res "`cilvar'" ///
		as txt ", " as res "`ciuvar'" as txt "]"
	di _col(`=`col'+9') as txt "CI level:  " as res "`level'" as txt "%" ///
		as txt `extra'
	if !missing("`cilu'`ciuu'") {
		di _col(`=`col'+10') as txt "User CI:  " as txt "[" as res ///
			"`cilu'" as txt ", " as res "`ciuu'" as txt "]"
		di _col(`=`col'+4') as txt "User CI level:  " as res ///
			"`civarl'" as txt "%, controlled by " as res ///
			"civarlevel()" 
	}
	
	di
	
	di as txt _col(`=`col'+1') "Model and method"
	meta__model_desc, key(`method') meth(`model') col(`=`col'+12')
	/*
	di
	
	di as txt _col(`=`col'+4') "Meta settings"
	di _col(`=`col'+10') as txt "Display:  " as txt "`toshow'"
	*/
end
