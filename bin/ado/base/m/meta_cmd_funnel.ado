*! version 1.0.0  28may2019

/*
	Undocumented <varlist>, useful to construct residual funnel plots
	
	meta regress ...
	predict double resid, resid se(se_resid, marginal) fixedonly
	meta funnel resid_se resid
	
*/

program meta_cmd_funnel, rclass
	version 16
	syntax [varlist(max=2 default=none)] [if] [in]	///
		[,					///
			Metric(string)			///
			random(string) 			///
			RANDOM1				///
			fixed(string)  			///
			FIXED1  			///
			common(string)  		///
			COMMON1  			///
			Level(string)			///
			NOMETASHOW			///
			METASHOW1			///
			CONTOURs(string)		///
			SCHeme(passthru)		///
			N(passthru)			///
			THETA(passthru)			/// NODOC
			*				///
		]
	
	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err	
	}
	
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	if !missing("`level'") & !missing("`contours'") {
		di as err ///
		"only one of {bf:contours()} or {bf:level()} is allowed"
		exit 198
	}
	if missing("`level'") {
		local level  : char _dta[_meta_level]
	}
	else {
		if inlist("`metric'", "n", "invn") {
			di as err ///
			"option {bf:level()} not supported with metric " ///
			"{bf:`metric'}"
			exit 198
		}
		meta__validate_level "`level'"
		local level `s(mylev)'
	}
	
	_get_gropts , graphopts(`options' `scheme')	///
		grbyable total missing			///
		getbyallowed(legend)			///
		getallowed(CIopts ESopts addplot)
	local by	`"`s(varlist)'"'
	local bylegend	`"`s(by_legend)'"'
	local byopts	`"`s(total)' `s(missing)' `s(byopts)'"'
	if `"`by'"' == "" & strtrim(`"`byopts'"') != "" {
		di as error "option by() requires a varlist"
		exit 198
	}
	local options	`"`s(graphopts)'"'
	local ciopts	`"`s(ciopts)'"'
	local esopts	`"`s(esopts)'"'
	local addplot	`"`s(addplot)'"'
	_check4gropts ciopts, opt(`ciopts')
	_check4gropts esopts, opt(`esopts')

	CheckMetric `metric'
	local metric = s(metric)
	local reverse `"`s(reverse)'"'
	local usesN = s(usesN)
	local ytitle `"`s(ytitle)'"'
	
	ParseModelAndMethod, random(`random') `random1' `fixed1' ///
		fixed(`fixed') `common1' common(`common')
	
	CheckMethod `method'
	local method = s(method)
	local estype = s(estype)
	local thlabel "Estimated {&theta}{sub:`estype'}"

	local kC 0
	if `"`contours'"' != "" {
		gr_setscheme, `scheme'
		// Creates following local macros:
		// 	kC	- # of contours
		//	Ctype	- plot type
		//	Carea	- "area" or ""
		//	Cside	- "", "lower", or "upper"
		// 	C#	- significance level for contour #
		// 	C#opts	- graph options for contour #
		ParseContours `contours'
	}

	twoway__meta_funnel_gen `varlist' `if' `in',	///
		metric(`metric') method(`method') `n'
	local ymin = r(ymin)
	local ymax = r(ymax)
	local xmin = r(xmin)
	local xmax = r(xmax)
	local y = r(y)
	local x = r(x)
	local th = r(theta)
	
	if "`Carea'" == "area" {
		if "`Cside'" == "lower" {
			if `xmax' < 0 {
				local Cbase base(0)
			}
			else {
				local Cbase base(`xmax')
			}
		}
		else if "`Cside'" == "upper" {
			if `xmin' > 0 {
				local Cbase base(0)
			}
			else {
				local Cbase base(`xmin')
			}
		}
	}

	local title "title(Funnel plot)"
	if `kC' {
		local title "title(Contour-enhanced funnel plot)"
	}

	local ifin `if' `in'

	if "`by'" != "" {
		local range range(`ymin' `ymax')
		local byopt `"by(`by', `title' `bylegend' `byopts')"'
		local title
		local byifin `if' `in'
	}

	forval i = 1/`kC' {
		local C`i'plot				///
			(`Ctype' `y' `x' `ifin',	///
				metric(`metric')	///
				method(`method')	///
				`range'			///
				`C`i'opts'		///
				`Cbase'			///
				`n'			///
			)
		local Cplots `"`Cplots' `C`i'plot'"'
	}

	if `usesN' == 0 & `kC' == 0 {
		local ciplot				///
			(meta_funnel `y' `x' `ifin',	///
				`theta'			///
				metric(`metric')	///
				method(`method')	///
				horizontal		///
				pstyle(ci)		///
				level(`level')		///
				`range'			///
				`ciopts'		///
				`n'			///
			)
	}
	
	GetEsLabel
	local xtitle `"xtitle(`eslabel')"'
	local scatter				///
		(meta_scatter `y' `x' `ifin',	///
			metric(`metric')	///
			method(`method')	///
			pstyle(p1)		///
			yvarlabel(Studies)	///
			`title'			///
			`ytitle'		///
			`xtitle'		///
			`byopt'			///
			`reverse'		///
			`options'		///
		)
	local esplot				///
		(meta_effect `y' `x' `ifin',	///
			`theta'			///
			metric(`metric')	///
			method(`method')	///
			horizontal		///
			pstyle(p2)		///
			lstyle(xyline)		///
			yvarlabel("`thlabel'")	///
			`range'			///
			`esopts'		///
		)
	
	graph twoway		///
		`ciplot'	///
		`Cplots'	///
		`scatter'	///
		`esplot'	///
		|| `byifin'	///
		|| `addplot'


	local global_metashow : char _dta[_meta_show]
	if missing("`nometashow'`global_metashow'") | !missing("`metashow1'") {
			di
			local col = 2
			meta__esize_desc, col(`=`col'+1') // showstudlbl	
			meta__model_desc, key(`method') meth(`model') ///
			col(`=`col'+13')
	}		
		
	return scalar ymax = `ymax'	
	return scalar ymin = `ymin'
	return scalar xmax = `xmax'
	return scalar xmin = `xmin'	
	return scalar theta = `th'
			
	return local contours "`contours'"
	return local metric "`metric'"
	return local method "`method'"
	return local model "`model'"

end

program GetEsLabel
	local eslbl : char _dta[_meta_eslabel]
	local esizetype : char _dta[_meta_estype]
	
	meta__eslabel,  estype(`esizetype') eslbl(`eslbl')
	c_local eslabel "`s(eslabvarbeg)'"
end

program NeedsN
	di as err "unable to compute study sample sizes"
	di as err "{p 4 4 2}"
	di as err "Perhaps you have used {bf:meta set}"			///
		" to declare your effect size and standard error "	///
		"variables, therefore no information were provided "	///
		"to compute sample sizes.  If you have a variable, "	///
		"{it:ssvar}, in your dataset that stores sample sizes," ///
		" you may use it to construct the funnel plot as "	///
		"{bf:scatter {it:ssvar} _meta_es}, or consider "	///
		"specifying the {bf:studysize()} option in "		///
		"{bf:meta set}.{p_end}" 
	exit 111
end

program CheckMetric, sclass
	args metric

	if "`metric'" == "" {
		local metric se
	}

	if "`metric'" == "se" {
		local ytitle "Standard error"
		local reverse yscale(reverse)
	}
	else if "`metric'" == "invse" {
		local ytitle "Inverse standard error"
	}
	else if "`metric'" == "var" {
		local ytitle "Variance"
		local reverse yscale(reverse)
	}
	else if "`metric'" == "invvar" {
		local ytitle "Inverse variance"
	}
	else if "`metric'" == "n" {
		local ytitle "Sample size"
	}
	else if "`metric'" == "invn" {
		local ytitle "Inverse sample size"
		local reverse yscale(reverse)
	}
	else {
		di as err "option {bf:metric()} invalid;"
		di as err "metric {bf:`metric'} not allowed"
		exit 198
	}

	local usesN = inlist("`metric'", "n", "invn")
	if `usesN' {
		capture confirm var _meta_studysize
		if c(rc) {
			NeedsN
		}
	}

	sreturn local metric	`metric'
	sreturn local usesN	`usesN'
	sreturn local ytitle	"ytitle(`ytitle')"
	sreturn local reverse	"`reverse'"
end

program CheckMethod, sclass
	args method

	if "`method'" == "" {
		sreturn local method ivariance
		sreturn local estype IV
		exit
	}

	meta__validate_method_graph, meth(method) `method'
	local method `s(method)'

	if inlist("`method'", "ivariance", "invvariance") {
		local estype IV
	}	
	else if ("`method'" == "mhaenszel") {
		local dtyp : char _dta[_meta_datatype]
		if "`dtyp'" == "Generic" {
			di as err "option {bf:method} not valid"
			di as err "{p 4 4 2}The {bf:mhaenszel} " ///
			  "is not valid with generic effect sizes " ///
			  "declared by command {bf: meta set}.{p_end}"
			exit 198  
		}
		local estype MH
	}	
	else {
		local l = strlen("`method'")
		if `l' > 4 {
			local estype=ustrupper(bsubstr("`method'",1,2))
		}
		else local estype = ustrupper("`method'")
	}				
	sreturn local method `method'
	sreturn local estype `estype'
end

program ParseContours
	syntax anything(name=nlist id="numlist")	///
		[,					///
			LOWer				///
			UPper				///
			LINEs		 		///
			COLor(string)			/// area options
			FCOLor(string)			///
			FIntensity(passthru)		///
			LCOLor(string)			///
			LWidth(passthru)		///
			LPattern(passthru)		///
			LAlign(passthru)		///
			LSTYle(passthru)		///
			ASTYle(passthru)		///
			PSTYle(passthru)		///
	]

	local common	`fintensity'	///
			`lwidth'	///
			`lpattern'	///
			`lalign'	///
			`lstyle'	///
			`astyle'	///
			`pstyle'

	if "`lower'`upper'" == "" {
		c_local Ctype meta_funnel
	}
	else {
		opts_exclusive "`lower' `upper'"
		c_local Ctype meta_funnel1
	}
	c_local Cside `lower' `upper'

	local cmd numlist `"`nlist'"', min(1) max(8) range(>0 <50) integer sort
	capture `cmd'
	if c(rc) {
		di as err ///
		"{p}option {bf:contours()} must contain no more than" ///
		" 8 integer values between 1 and 50{p_end}"
		exit 198	// [sic]
	}
	local nlist `"`r(numlist)'"'
	local nlist : list uniq nlist

	local kC : list sizeof nlist

	if "`lines'" == "" {
		c_local Carea "area"
	}
	else {
		if "`lower'`upper'" == "" {
			local recast recast(rline)
		}
		else {
			local recast recast(line)
		}
	}

	if `"`color'"' == "" {
		local color scheme funnel_contour
	}
	if `"`fcolor'"' == "" {
		local fcolor : copy local color
	}
	if `"`lcolor'"' == "" {
		local lcolor : copy local color
	}

	tempname fstyle lstyle

	.`fstyle' = .zyx2style.new
	.`fstyle'.editstyle	rule(intensity)		///
				ecolor(`fcolor')	///
				userecolor(yes)		///
				levels(`kC')		///
				editcopy
	.`fstyle'.reset

	.`lstyle' = .zyx2style.new
	.`lstyle'.editstyle	rule(intensity)		///
				ecolor(`lcolor')	///
				userecolor(yes)		///
				levels(`kC')		///
				editcopy
	.`lstyle'.reset

	local p 2
	forval i = 1/`kC' {
		local ++p
		gettoken val nlist : nlist
		if "`lines'" == "" {
			if `i' == `kC' {
				local label "p > `val'%"
			}
			else {
				gettoken val2 : nlist
				local label "`val'% < p < `val2'%"
			}
			if "`lower'`upper'" == "" {
				local label yvarlabel("`label'" "`label'")
			}
			else {
				local label yvarlabel("`label'")
			}
		}
		local fcolor `""`.`fstyle'.cstyles[`i'].color.rgb'""'
		local lcolor `""`.`lstyle'.cstyles[`i'].color.rgb'""'
		c_local C`i' `val'
		c_local C`i'opts			///
			contours(`val')			///
			`lower'				///
			`upper'				///
			horizontal			///
			pstyle(p`p')			///
			`recast'			///
			`label'				///
			fintensity(scheme funnel)	///
			fcolor(`fcolor')		///
			lcolor(`lcolor')		///
			`common'
	}
	c_local kC `kC'
end

program ParseModelAndMethod

	syntax [, random(string) RANDOM1 common(string) COMMON1 ///
		fixed(string) FIXED1 ]
		
	local re = subinstr("`random'", " ", "_", .)
	local fe = subinstr("`fixed'", " ", "_", .)
	local co = subinstr("`common'", " ", "_", .)
	local mod `"`re' `fe' `fixed1' `co' `common1' `random1'"'
	if  (`:word count `mod'' > 1) {
		meta__model_err, mh  
	}
	else if (`:word count `mod'' == 1) {
		// will create local -model- and -method-
		meta__model_method, random(`random') `random1' `fixed1' ///
		fixed(`fixed') `common1' common(`common')
	}
	else {
		local model common
		local method invvariance
	}
	
	c_local model `model'
	c_local method `method'

end

exit
