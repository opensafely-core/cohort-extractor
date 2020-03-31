*! version 1.1.0  10apr2014

program define tsfilter, sortpreserve
	version 12.0

/* syntax
 *	tsfilter filter [type] newvarname=oldvarname [if] [in] , options
 *	tsfilter filter [type] newvarlist=oldvarlist [if] [in] , options
 *	tsfilter filter [type] stub*=oldvarlist [if] [in] , options
 */

	gettoken filter 0 : 0
	local filter="`filter'"
	local group1 "bk", "cf"
	local group2 "bw", "hp"
	local validFilter "`group1'", "`group2'"
	if inlist("`filter'", "`validFilter'")!=1{
		di as err "{p 0 4 2}filter {bf:`filter'} invalid; " ///
			"valid values are {bf:bk}, " ///
			"{bf:bw}, {bf:cf}, or {bf:hp}{p_end}"
		exit 198
	}

							/* Parse command */
	local equals "="
	local cmdl "`filter'`0'"
	local cmdl : list dups cmdl
	local pe : list posof "`filter'" in cmdl
	if `pe'==0 {
		local cmdline : list 0-filter
	}
	else {
		local cmdline `0'
	}
	local containsEqual = strpos("`cmdline'","=")
	if (`containsEqual' == 0) {
		di as err "invalid syntax, missing = sign"
		exit 198
	}
	gettoken filtered right : cmdline, parse("`equals'")

	local cmdline = subinstr("`right'", "=" ,"", 1)

	cap getNamelist `cmdline'
	if (_rc>0) {
		di as err "{p 0 4 2}{bf:`cmdline'} " ///
		"contains an invalid varlist{p_end}"
		exit _rc
	}
	local vList `s(vList)'
	local weight `s(wtg)'
	if "`weight'" != "" {
		di as err "{p 0 4 2}weights " ///
		"are not allowed with {bf:tsfilter}{p_end}"
		exit 198
	}
	qui cap getVar `vList'
	if (_rc>0) {
		di as err "{p 0 4 2}{bf:`vList'} " ///
		"is an invalid varlist{p_end}"
		exit _rc
	}
	local nvar = s(nvar)

	parseStub "filtered",stubList(`filtered') nvar(`nvar')
	local filterlist `"`s(varlist)'"'
	local filtertype `"`s(typlist)'"'
	local opts = strpos("`cmdline'", ",")
	if (`opts'>0) {
		local cmdline `"`cmdline' filter(`filter')"'
		local cmdline `"`cmdline' fl(`filterlist') ft(`filtertype')"'
	}
	else{
		local cmdline `"`cmdline', filter(`filter')"'
		local cmdline `"`cmdline' fl(`filterlist') ft(`filtertype')"'
	}
	local 0 `cmdline'
	syntax varlist(numeric ts) [if] [in], [ * ]
	marksample touse

	qui count if `touse'
	if (!r(N)) error 2000
	if (r(N)==1) error 2001

	qui tsset
	if "`r(panelvar)'" != "" {
		local pvar "`r(panelvar)'"
		qui summarize `pvar' `if'`in', meanonly
		if r(min) < r(max) {
			local BY " by `pvar' : "
		}
	}
	if inlist("`filter'", "`group1'")==1 {
		`BY' ParseCfBk `cmdline'
	}
	else {
		`BY' ParseBwHp `cmdline'
	}
end

program define ParseBwHp, rclass byable(recall,noheader)
	syntax varlist(numeric ts) [if] [in] , 	///
		filter(string)  		///
		fl(string)      		///
		ft(string)      		///
		[,Trend(string) 		///
		Smooth(string)  		///
		ORder(string)       		/// 
		MAXperiod(string)      		/// 
		Difference(string)       	/// undocumented
		MAorder(string)       		/// undocumented
		Gain(string)]
	
// Note: difference() and maorder() are undocumented options to compute
//       a more general procedure than the Butterworth filter.
//       If either maorder() or difference is specified r(order) is not 
//       put into r() and r(maorder) and r(difference) are put into r().

	qui tsset
	local units "`r(unit)'"
						/* check for excluded	
						panel			*/
	marksample touse, novarlist
	qui count if `touse'
	if (!r(N)) exit

	marksample touse
	_ts timevar panelvar if `touse', sort onepanel
	markout `touse' `timevar'
	tsreport if `touse', report
	if r(N_gaps) {
		di as err "sample may not contain gaps"
		exit 498
	}

	qui count if `touse'
	if (!r(N)) {
						/* must be panel data 
						to get here 		*/
		local panel = _byindex()
		di as txt "{p 0 4 2}note: no observations for panel `panel'" ///
		 "{p_end}"
		exit
	}
	ret clear

	local trendtype ""
	local gaintype ""
	local filterlist `fl'
	local filtertype `ft'
	local smoothn = 1600		
	local ordern  = 2		// default for maorder()
	local dn      = 2		// default for difference()
	local nvar  : word count `varlist'
	local vars : list uniq varlist
	local nvar2 : word count  `vars'
	if `nvar2'!=`nvar' {
		di as err "{p 0 4 2}duplicate names " ///
			"found in {it:varlist}{p_end}"
		exit 198
	}
	local trendlist ""
	if "`trend'"!="" {
		if _byindex()==1 {
						/* check for duplicate names
			   			within trend()              */
			local dtype "double float byte long int ( )"
			local alllist : list trend - dtype
			local alllist : list dups alllist
			local alllist : list alllist - dtype
			if "`alllist'" != "" {
				di as err "{p 0 4 2}duplicate names " ///
					"found in {bf:trend()}{p_end}"
				exit 198
			}
						/* check for duplicate names
						between trend() and varlist */
			cap noi parseStub "trend",stubList(`trend') nvar(`nvar')
			if _rc>0 {
				local rc=_rc
				exit `rc'
			}
			local trendlist `"`s(varlist)'"'
			local trendtype `"`s(typlist)'"'
						/* check for duplicate names
			   			between trend() and namelist */
			local alllist `"`fl' `trendlist'"'
			local kall : word count `alllist'
			local alllist : list uniq alllist
			if `:word count `alllist'' != `kall' {
				di as err "{p 0 4 2}duplicate names exist " ///
				"between {it:namelist} and {bf:trend()}{p_end}"
				exit 198
			}
		}
		else {
			local dtype "double float long int"
			local trendvars : list trend - dtype
			getVar(`trendvars')
			local trendlist `"`s(varlist)'"'
		}
	}
	local gainlist ""
	if "`gain'"!="" {
		if _byindex()==1 {
						/* check for duplicate names
			   			within gain()              */
			local dtype "double float long int"
			local alllist : list dups gain
			local alllist : list alllist - dtype
			if "`alllist'" != "" {
				di as err "{p 0 4 2}duplicate names " ///
					"found in {bf:gain()}{p_end}"
				exit 198
			}
			/* check for valid names       */
			local n =  strpos("`gain'","-")
			local n = `n' + strpos("`gain'","(")
			local n = `n' + strpos("`gain'",")")
			local gainvars : list gain - dtype
			cap confirm new variable `gainvars'
			if _rc != 0 & `n'==0 {
				di as err "{p 0 4 2}invalid new variable " ///
					"name in {bf:gain()}{p_end}"
				exit 198
			}
						/* check for duplicate names
			   			between gain() and varlist */
			parseStub "gain",stubList(`gain') nvar(2)
			local gainlist `"`s(varlist)'"'
			local gaintype `"`s(typlist)'"'
						/* check for duplicate names
						between gain() and namelist */
			local alllist `"`fl' `gainlist'"'
			local kall : word count `alllist'
			local alllist : list uniq alllist
			if `:word count `alllist'' != `kall' {
				di as err "{p 0 4 2}duplicate names exist " ///
				"between {it:namelist} and {bf:gain()}{p_end}"
				exit 198
			}
		}
		else {
			local dtype "double float long int"
			local gainvars : list gain - dtype
			getGainVars(`gainvars')
			local gainlist `"`s(varlist)'"'
		}
	}
	if "`gain'"!="" & "`trend'"!="" & _byindex()==1 {
		local alllist `"`trendlist' `gainlist'"'
		local kall : word count `alllist'
		local alllist : list uniq alllist
		if `:word count `alllist'' != `kall' {
			di as err "{p 0 4 2}duplicate names exist " ///
			"between {bf:trend()} and {bf:gain()}{p_end}"
			exit 198
		}
	}

	if "`smooth'" != "" {
			if ("`filter'"=="bw") {
				di as error "{p 0 4 2}{bf:smooth()} " ///
					"option is invalid with the " ///
					"butterworth filter{p_end}"
				exit 198
			}
			tokenize "`smooth'", parse(" ,")
			if "`2'" != "" {
				di as error "{p 0 4 2}only " ///
					"one argument may be "	///
					"specified in {bf:smooth()}{p_end}"
				exit 198
			}
			cap confirm number `smooth'
			if (_rc != 0) {
				di as error "{p 0 4 2}{bf:smooth()} " ///
					"does not contain a number{p_end}"
				exit 7
			}
			local smoothn = `smooth'
	}
	else {
				/* use the RU rule smoothn=1600*(s^4) */
		if "`units'" == "yearly" {
			local smoothn = 6.25
		}
		else if "`units'" == "monthly" {
			local smoothn = 129600
		}
		else if "`units'" == "weekly" {
			local smoothn = 1600*(12^4)
		}
		else if "`units'" == "daily" {
			local smoothn = 1600*((365.0/4)^4)
		}
		else if "`units'" == "halfyearly" {
			local smoothn = 100
		}
		else {
			local smoothn = 1600
		}
	}

	if "`maxperiod'" != "" {
		if ("`filter'"=="hp") {
			di as error "{p 0 4 2}{bf:maxperiod()} " ///
				"option is invalid with the Hodrick-" ///
				"Prescott filter{p_end}"
			exit 198
		}
		tokenize "`maxperiod'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 	///
				"argument may be specified "	///
				"in {bf:maxperiod()}{p_end}"
			error 200
		}
		cap confirm number `maxperiod'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:maxperiod()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		local phn = `maxperiod'
		if (`phn'<=2) {
			di as error "{p 0 4 2}{bf:maxperiod()} " ///
				"must be greater than 2{p_end}"
			exit 198
		}
	}
	else {
		if "`units'" == "yearly" {
			local phn = 8
		}
		else if "`units'" == "monthly" {
			local phn = 8*12
		}
		else if "`units'" == "weekly" {
			local phn = 8*52
		}
		else if "`units'" == "daily" {
			local phn = 8*365
		}
		else if "`units'" == "halfyearly" {
			local phn = 8*2
		}
		else {
			local phn = 32
		}
	}

	if "`order'" != "" {

		if "`maorder'" != "" {
			di as error "{p 0 4 2}{bf:maorder()} " ///
				"may not be specified with "	///
				"{bf:order()}{p_end}" 
			exit 198
		}

		if "`difference'" != "" {
			di as error "{p 0 4 2}{bf:difference()} " ///
				"may not be specified with "	///
				"{bf:order()}{p_end}" 
			exit 198
		}

		if ("`filter'"=="hp") {
			di as error "{p 0 4 2}{bf:order()} " ///
				"is invalid with the Hodrick-" ///
				"Prescott filter{p_end}"
			exit 198
		}
		tokenize "`order'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 	///
				"argument may be specified "	///
				"in {bf:order()}{p_end}"
			exit 200
		}
		cap confirm number `order'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:order()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		else {
			if int(`order') != `order' {
				di as error "{p 0 4 2}{bf:order()} " ///
					"is not an integer{p_end}"
				exit 198
			}
		}
		if int(`order') < 1 {
			di as error "{p 0 4 2}{bf:order()} " 		///
				"must specify an integer greater "	///
				"than 0{p_end}"
			exit 198
		}	
		local ordern = int(`order')
		local dn     = int(`order')
	}
						// undocumented option
	if "`maorder'" != "" {
		if ("`filter'"=="hp") {
			di as error "{p 0 4 2}{bf:maorder()} " ///
				"is invalid with the Hodrick-" ///
				"Prescott filter{p_end}"
			exit 198
		}
		tokenize "`maorder'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 	///
				"argument may be specified "	///
				"in {bf:maorder()}{p_end}"
			exit 200
		}
		cap confirm number `maorder'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:maorder()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		else {
			if int(`maorder') != `maorder' {
				di as error "{p 0 4 2}{bf:maorder()} " ///
					"is not an integer{p_end}"
				exit 198
			}
		}
		if int(`maorder') < 1 {
			di as error "{p 0 4 2}{bf:maorder()} " 	///
				"must specify an integer greater "	///
				"than 0{p_end}"
			exit 198
		}	
		local ordern = int(`maorder')
		local orderopt maorder
	}
	else {
		local orderopt order
	}

						// undocumented option
	if "`difference'" != "" {
		if ("`filter'"=="hp") {
			di as error "{p 0 4 2}{bf:difference()} option " ///
				"is invalid with the Hodrick-" ///
				"Prescott filter{p_end}"
			exit 198
		}
		tokenize "`difference'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 	///
				"argument may be specified in "	///
				"{bf:difference()}{p_end}"
			exit 200
		}
		cap confirm number `difference'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:difference()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		else {
			if int(`difference') != `difference' {
				di as error "{p 0 4 2}{bf:difference()} " ///
					"is not an integer{p_end}"
				exit 198
			}
		}
		if int(`difference') < 1 {
			di as error "{p 0 4 2}{bf:difference()} " 	///
				"must specify an integer greater than "	///
				"0{p_end}"
			exit 198
		}	
		local dn = int(`difference')
	}

	if ("`filter'" != "bw") {
		local methodn "Hodrick-Prescott"
	}
	else {
		local methodn "Butterworth"
	}
	if ("`filter'"=="hp" & `smoothn'<=0) {
		di as err "{p 0 4 2}{bf:smooth()} must be " ///
			"greater than zero{p_end}"
		exit 198
	}

	if ("`filter'"=="bw" & `ordern'<`dn') {
		di as error "{p 0 4 2}{bf:`orderopt'()} "	///
			"must be  greater than or equal to " 	///
			"{bf:difference()}{p_end}"
		exit 198
	}

	local nflist : word count `filterlist'
	local ntlist : word count `trendlist'
	local nglist : word count `gainlist'
	if (`nflist' != `nvar') {
		di as err "{p 0 4 2}number of variables in ", ///
			"{it:namelist} is not equal to the number in ", ///
			"{it:varlist}{p_end}"
		exit 198
	}
	if (`ntlist' != `nvar' & "`trend'"!="") {
		di as err "{p 0 4 2}number of variables in ", ///
			"{bf:trend()} option is not equal to ", ///
			"the number in {it:varlist}{p_end}"
		exit 198
	}
	if (_byindex() == 1) {
		local i = 0
		foreach v of local filterlist {
			local i =`i'+1
			local typ : word `i' of `filtertype'
			qui gen `typ' `v' = .
		}
		local i = 0
		foreach v of local trendlist {
			local i=`i'+1
			local typ : word `i' of `trendtype'
			qui gen `typ' `v' = .
		}

		local i = 0
		foreach v of local gainlist {
			local i=`i'+1
			local typ : word `i' of `gaintype'
			qui gen `typ' `v'  = .
		}

	}

	local i = 0
	foreach v of local gainlist {
		local i=`i'+1
		if `i'==2 {
			if "`_byvars'" != "" {
				qui by `_byvars': ///
					replace `v' = _n if `touse'
			}
			else{
				qui replace `v' = _n if `touse'
			}
		}
	}

	if ("`gain'"!="") {
		qui count if `touse'
		local curN   = r(N)
		local _gain  : word 1 of `gainlist'
		local _angle : word 2 of `gainlist'
		qui replace `_angle' = _pi*`_angle'/(`curN') if `touse'
	}
	else{
		local _gain  = ""
		local _angle = ""
	}

	if ("`filter'" == "bw") {
		quietly count if `touse'
		local bwN  = r(N)
		if `bwN' - `ordern' < 1 | `bwN' - `dn' < 1 {
			local mes "order of the filter is too large for "
			if _by() {
				local panel = _byindex()
				di as txt "{p 0 4 2}note: `mes' panel " ///
				 "`panel'{p_end}"
				exit
			}
			di as err "{p}`mes' the specified sample{p_end}"
			exit 498
		}

		cap noi {
		mata: _TSFILTER_bwFilter(`phn', `ordern', `dn', ///
			`"`varlist'"', `"`filterlist'"', `"`trendlist'"', ///
			`"`touse'"', `"`_gain'"', `"`_angle'"')
		}
		if (_rc == 3353) {
			return clear
			foreach c of local filterlist {
				drop `c'
			}
			foreach t of local trendlist {
				drop `t'
			}
			foreach g of local gainlist {
				drop `g'
			}
			di as err "{p 0 4 2}large values for " 		///
				"{bf:maxperiod()} or "			///
				"{bf:`orderopt'()} have made the "	///
				"filter ill-conditioned{p_end}"
			exit 498
		}
	}
	else{
		quietly count if `touse'
		local hpN  = r(N)
		if `hpN' <= 2 {
			local mes "insufficient observations for "
			if _by() {
				local panel = _byindex()
				di as txt "{p 0 4 2}note: `mes' panel " ///
				 "`panel'{p_end}"
				exit
			}
			di as err "{p}`mes' the specified sample{p_end}"
			exit 498
		}
		mata: _TSFILTER_hpFilter(`smoothn', ///
			`"`varlist'"', `"`filterlist'"', `"`trendlist'"', ///
			`"`touse'"', `"`_gain'"', `"`_angle'"')
	}
	local nextvar "`varlist'"
	foreach c of local filterlist {
		gettoken v nextvar : nextvar
		label var `c' "`v' cyclical component from `filter' filter"
	}
	local nextvar "`varlist'"
	foreach t of local trendlist {
		gettoken v nextvar : nextvar
		label var `t' "`v' trend component from `filter' filter"
	}
	if "`_gain'" != "" {
		label var `_gain'  "gain from `filter' filter"
		label var `_angle' "angular frequency from `filter' filter"
	}
	return clear
	return local unit "`units'"
	return local method "`methodn'"
	if "`trendlist'" != "" {
		local i = 1
		foreach v of varlist `trendlist' {
			unab tvar : `v', max(1)
			local avar `tvar'
			if `i'==1{
				local vars "`avar'"
				local i = 2
			}
			else {
				local vars "`vars' `avar'"
			}
		}
		return local trendlist `"`vars'"'
	}
	local i = 1
	foreach v of varlist `filterlist' {
		unab tvar : `v', max(1)
		local tvar `v'
		local avar `tvar'
		if `i'==1{
			local vars "`avar'"
			local i = 2
		}
		else {
			local vars "`vars' `avar'"
		}
	}
	return local filterlist `"`vars'"'
	local i = 1
	foreach v of varlist `varlist' {
		cap unab tvar : `v', max(1)
		if _rc != 0 {
			local tvar `v'
			cap
		}
		local avar `tvar'
		if `i'==1{
			local vars "`avar'"
			local i = 2
		}
		else {
			local vars "`vars' `avar'"
		}
	}
	return local varlist `"`vars'"'

	if ("`filter'" == "hp") {
		return scalar smooth = real("`smoothn'")
	}
	else {
		return scalar maxperiod  = real("`phn'")
		if "`maorder'" != "" || "`difference'" != "" {
			return scalar maorder    = real("`ordern'")
			return scalar difference = real("`dn'")
		}
		else {
			return scalar order      = real("`ordern'")
		}
	}
end

program define ParseCfBk, rclass byable(recall, noheader)
	syntax varlist(numeric ts) [if] [in] , ///
			filter(string) ///
			fl(string)     ///
			ft(string)     ///
			[Trend(string) ///
			MINperiod(string)     ///
			MAXperiod(string)     ///
			SMAorder(string)      ///
			STATionary     ///
			Drift          ///
			Gain(string)]
	qui tsset
	local units "`r(unit)'"
	marksample touse
	_ts timevar panelvar if `touse', sort onepanel
	markout `touse' `timevar'
	tsreport if `touse', report
	if r(N_gaps) {
		di as err "sample may not contain gaps"
		exit 498
	}

	if (_byindex()==1) {
		ret clear
	}

	qui count if `touse'
	local N = r(N)
	if (!`N') {
						/* must be panel data 
						to get here 		*/
		local panel = _byindex()
		di as txt "{p 0 4 2}note: no observations for panel `panel'" ///
		 "{p_end}"
		exit
	}
	local trendtype ""
	local gaintype ""
	local filterlist `fl'
	local filtertype `ft'
	local driftn "no"
	local symmetricn "no"
	if "`filter'" == "bk" {
		if "`units'" == "yearly" {
			local qn = 3
		}
		else if "`units'" == "monthly" {
			local qn = 3*12
		}
		else if "`units'" == "weekly" {
			local qn = 3*52
		}
		else if "`units'" == "daily" {
			local qn = 3*365
		}
		else if "`units'" == "halfyearly" {
			local qn = 3*2
		}
		else {
			local qn = 12
		}
		local symmetricn "yes"
	}
	else {
		local qn = .
	}
	local rootn = 1
	local pln   = 6
	local phn   = 32
	if "`drift'" != "" & "`filter'" == "cf" {
		local driftn "yes"
	}
	if "`drift'" != "" & "`filter'" == "bk" {
		di as error "{p 0 4 2}{bf:drift} option " ///
			"is invalid with the Baxter-" ///
			"King filter{p_end}"
		exit 198
	}
	if "`minperiod'" != "" {
		tokenize "`minperiod'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 		///
				"argument may be specified in "		///
				"{bf:minperiod()}{p_end}"
			exit 198
		}
		cap confirm number `minperiod'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:minperiod()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		local pln = `minperiod'
	}
	else {
		if "`units'" == "yearly" {
			local pln = 2
		}
		else if "`units'" == "monthly" {
			local pln = 1.5*12
		}
		else if "`units'" == "weekly" {
			local pln = 1.5*52
		}
		else if "`units'" == "daily" {
			local pln = 548
		}
		else if "`units'" == "halfyearly" {
			local pln = 1.5*2
		}
		else {
			local pln = 1.5*4
		}
	}
	if "`maxperiod'" != "" {
		tokenize "`maxperiod'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 		///
				"argument may be specified in "		///
				"{bf:maxperiod()}{p_end}"
			exit 200
		}
		cap confirm number `maxperiod'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:maxperiod()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		local phn = `maxperiod'
	}
	else {
		if "`units'" == "yearly" {
			local phn = 8
		}
		else if "`units'" == "monthly" {
			local phn = 8*12
		}
		else if "`units'" == "weekly" {
			local phn = 8*52
		}
		else if "`units'" == "daily" {
			local phn = 8*365
		}
		else if "`units'" == "halfyearly" {
			local phn = 8*2
		}
		else {
			local phn = 8*4
		}
	}
	local nvar : word count `varlist'
	local vars : list uniq varlist
	local nvar2 : word count `vars'
	if `nvar2'!=`nvar' {
		di as err "{p 0 4 2}duplicate names " ///
			"found in {it:varlist}{p_end}"
		exit 198
	}
	local trendlist ""
	if "`trend'"!="" {
		if _byindex()==1 {
						/* check for duplicate names
						   within trend()          */
			local dtype "double float byte long int ( )"
			local alllist : list trend - dtype
			local alllist : list dups alllist
			local alllist : list alllist - dtype
			if "`alllist'" != "" {
				di as err "{p 0 4 2}duplicate names " ///
					"found in {bf:trend()}{p_end}"
				exit 198
			}
						/* check for duplicate names
						between trend() and varlist */
			cap noi parseStub "trend",stubList(`trend') nvar(`nvar')
			if _rc>0 {
				local rc=_rc
				exit `rc'
			}
			local trendlist `"`s(varlist)'"'
			local trendtype `"`s(typlist)'"'
						/* check for duplicate names
						between trend() and namelist */
			local alllist `"`fl' `trendlist'"'
			local kall : word count `alllist'
			local alllist : list uniq alllist
			if `:word count `alllist'' != `kall' {
				di as err "{p 0 4 2}duplicate names exist " ///
				"between {it:namelist} and {bf:trend()}{p_end}"
				exit 198
			}
		}
		else {
			local dtype "double float long int"
			local trendvars : list trend - dtype
			getVar(`trendvars')
			local trendlist `"`s(varlist)'"'
		}
	}
	local gainlist ""
	if "`gain'"!="" {
		if _byindex()==1 {
						/* check for duplicate names
						   within gain()           */
			local dtype "double float long int"
			local alllist : list dups gain
			local alllist : list alllist - dtype
			if "`alllist'" != "" {
				di as err "{p 0 4 2}duplicate names " ///
					"found in {bf:gain()}{p_end}"
				exit 198
			}
						/* check for valid names    */
			local n = strpos("`gain'","-")
			local n = `n' + strpos("`gain'","(")
			local n = `n' + strpos("`gain'",")")
			local gainvars : list gain - dtype
			cap confirm new variable `gainvars'
			if _rc != 0 & `n'==0 {
				di as err "{p 0 4 2}invalid new variable " ///
					"name in {bf:gain()}{p_end}"
				exit 198
			}
						/* check for duplicate names
						 between gain() and varlist */
			parseStub "gain",stubList(`gain') nvar(2)
			local gainlist `"`s(varlist)'"'
			local gaintype `"`s(typlist)'"'
						/* check for duplicate names
						 between gain() and namelist */
			local alllist `"`fl' `gainlist'"'
			local kall : word count `alllist'
			local alllist : list uniq alllist
			if `:word count `alllist'' != `kall' {
				di as err "{p 0 4 2}duplicate names exist " ///
				"between {it:namelist} and {bf:gain()}{p_end}"
				exit 198
			}
		}
		else {
			local dtype "double float long int"
			local gainvars : list gain - dtype
			getGainVars(`gainvars')
			local gainlist `"`s(varlist)'"'
		}
	}
	if "`gain'"!="" & "`trend'"!="" & _byindex()==1 {
		local alllist `"`trendlist' `gainlist'"'
		local kall : word count `alllist'
		local alllist : list uniq alllist
		if `:word count `alllist'' != `kall' {
			di as err "{p 0 4 2}duplicate names exist " ///
			"between {bf:trend()} and {bf:gain()}{p_end}"
			exit 198
		}
	}
	if "`smaorder'" != "" {
		tokenize "`smaorder'", parse(" ,")
		if "`2'" != "" {
			di as error "{p 0 4 2}only one " 		///
				"argument may be specified in " 	///
				"{bf:smaorder()}{p_end}"
			exit 198
		}
		cap confirm number `smaorder'
		if (_rc!=0) {
			di as error "{p 0 4 2}{bf:smaorder()} does not " ///
				"contain a number{p_end}"
			exit 7
		}
		else {
			if int(`smaorder') != `smaorder' {
				di as error "{p 0 4 2}{bf:smaorder()} " ///
					"is not an integer{p_end}"
				exit 198
			}
		}
		if `smaorder' < 1 {
			di as error "{p 0 4 2}{bf:smaorder()} must be " ///
				"greater than 0{p_end}"
			exit 198
		}
		local qn = int(`smaorder')
		if "`filter'"=="cf" {
			local symmetricn "yes"
		}
	}
	local rootn "yes"
	local stationaryn "no"
	if "`stationary'" != "" {
		local rootn "no"
		local stationaryn "yes"
	}

	if ("`filter'" != "bk") {
		local methodn "Christiano-Fitzgerald"
	}
	else {
		local methodn "Baxter-King"
	}
	if (`N'<(`qn'+`qn'+1) & "`symmetricn'"=="yes") {
						/* not enough data 	*/
		
		local mes1 "insufficient number of observations" 
		local mes2 "for symmetric, fixed-length filter with"
		local mes2 "`mes2' {bf:smaorder(`qn')}"
		if _by() {
			local panel = _byindex()
			di as txt "{p 0 6 2}note: `mes1' in panel `panel' " ///
			 "`mes2'{p_end}"
			exit
		}
		di as err "{p}`mes1' `mes2'{p_end}"
		exit 198
	}
	else if (`N' < 2) {
		local mes1 "insufficient number of observations" 
		if _by() {
			local panel = _byindex()
			di as txt "{p 0 6 2}note: `mes1' in panel `panel' " ///
			 "`mes2'{p_end}"
			exit
		}
		di as err "{p}`mes1'{p_end}"
		exit 198
	}
	if (`pln'<2) {
		di as err "{p 0 4 2}{bf:minperiod()} must be " ///
			"greater than or equal to 2{p_end}"
		exit 198
	}
	if (`pln'>=`phn') {
							/* error pl>=ph */
		di as err "{p 0 4 2}{bf: minperiod()} must be less " ///
				"than {bf: maxperiod()}{p_end}"
		exit 198
	}

						/* calculate filter weights */
	local i = 0
	local nflist : word count `filterlist'
	local ntlist : word count `trendlist'
	local nglist : word count `gainlist'
	if (`nflist' != `nvar') {
		di as err "{p 0 4 2}number of variable names in ", ///
			"{it:namelist} is not equal to the number in ", ///
			"{it:varlist}{p_end}"
		exit 198
	}
	if (`ntlist' != `nvar' & "`trend'"!="") {
		di as err "{p 0 4 2}number of variable names in ", ///
			"trend list is not equal to the number in ", ///
			"{it:varlist}{p_end}"
		exit 198
	}

	if (_byindex() == 1) {
		local i = 0
		foreach v of local filterlist {
			local i=`i'+1
			local typ     : word `i' of `filtertype'
			qui gen `typ' `v' = .
		}
		local i = 0
		foreach v of local trendlist {
			local i=`i'+1
			local typ     : word `i' of `trendtype'
			qui gen `typ' `v' = .
		}
		local i = 0
		foreach v of local gainlist {
			local i=`i'+1
			local typ : word `i' of `gaintype'
			qui gen `typ' `v'  = .
		}
	}
	local i = 0
	foreach v of local gainlist {
		local i=`i'+1
		if `i'==2 {
			if "`_byvars'" != "" {
				qui by `_byvars': ///
					replace `v' = _n if `touse'
			}
			else{
				qui replace `v' = _n if `touse'
			}
		}
	}


	if ("`gain'"!="") {
		qui count if `touse'
		local curN   = r(N)
		local _gain  : word 1 of `gainlist'
		local _angle : word 2 of `gainlist'
		qui replace `_angle' = _pi*`_angle'/(`curN') if `touse'
	}
	else{
		local _gain  = ""
		local _angle = ""
	}
	qui count if `touse'
	local N = r(N)
	if ("`filter'" == "bk") {
		mata: _TSFILTER_bkFilter(`pln', `phn', `qn', ///
			`"`driftn'"', `"`stationaryn'"',       ///
			`"`varlist'"', `"`filterlist'"', `"`trendlist'"', ///
			`"`touse'"', `"`_gain'"', `"`_angle'"')
	}
	else {
		mata: _TSFILTER_cfFilter(`pln', `phn', `qn',`"`driftn'"', ///
			`"`stationaryn'"',`"`symmetricn'"',    ///
			`"`varlist'"', `"`filterlist'"', `"`trendlist'"', ///
			`"`touse'"', `"`_gain'"', `"`_angle'"')
	}

	if ("`filter'"=="bk" | "`symmetricn'"=="yes") {
		tempname __f
		matrix `__f' = r(filter)
		local __z    = matmissing(`__f')
		if ("`__z'"!="1"){
			matrix colnames `__f' = Weight
			local b "b0"
			forvalues i=1/`qn' {
				local b "`b' b`i'"
			}
			matrix rownames `__f' = `b'
		}
		else {
			di as err "unable to return coefficients"
			exit 3000
		}
		return matrix filter = `__f'
	}
	local nextvar "`varlist'"
	foreach c of local filterlist {
		gettoken v nextvar : nextvar
		label var `c' "`v' cyclical component from `filter' filter"
	}
	local nextvar "`varlist'"
	foreach t of local trendlist {
		gettoken v nextvar : nextvar
		label var `t' "`v' trend component from `filter' filter"
	}
	if "`_gain'" != "" {
		label var `_gain'  "gain from `filter' filter"
		label var `_angle' "angular frequency from `filter' filter"
	}
	return scalar maxperiod = `phn'
	return scalar minperiod = `pln'
	if `qn'<. return scalar smaorder  = `qn'
	return local stationary "`stationaryn'"
	if "`filter'"== "cf" {
		return local symmetric "`symmetricn'"
		return local drift      "`driftn'"
	}
	return local unit "`units'"
	return local method "`methodn'"
	if "`trendlist'" != "" {
		local i = 1
		foreach v of varlist `trendlist' {
			unab tvar : `v', max(1)
			local avar  `tvar'
			if `i'==1{
				local vars "`avar'"
				local i = 2
			}
			else {
				local vars "`vars' `avar'"
			}
		}
		return local trendlist `"`vars'"'
	}
	local i = 1
	foreach v of varlist `filterlist' {
		unab tvar : `v', max(1)
		local avar `tvar'
		if `i'==1{
			local vars "`avar'"
			local i = 2
		}
		else {
			local vars "`vars' `avar'"
		}
	}

	return local filterlist `"`vars'"'
	local i = 1
	foreach v of varlist `varlist' {
		cap unab tvar : `v', max(1)
		if _rc!=0 {
			local tvar `v'
			cap
		}
		local avar `tvar'
		if `i'==1{
			local vars "`avar'"
			local i = 2
		}
		else {
			local vars "`vars' `avar'"
		}
	}
	return local varlist `"`vars'"'

end

program define parseStub, sclass
	syntax anything(id="stub" name=stub), stubList(string) Nvar(int)
	local n = strpos("`stubList'","*")
	if `n' == 0 | `stub'=="gain" {
		getNvar `stubList'
		local nvar2 = s(nvar)
	}
	else {
		local nvar2 = `nvar'
	}
	if `nvar' != `nvar2' {
		if `stub'=="trend" & `n' ==0{
			di as err "{p 0 4 2}number of variables " ///
				"in {bf:trend()} must " ///
				"match the number in {it:varlist}{p_end}"
			exit 198
		}
		if `stub'== "filtered" & `n' == 0{
			di as err "{p 0 4 2}number of variables "  ///
				"in {it:namelist} must match "  ///
				"the number in {it:varlist}{p_end}"
			exit 198
		}
		if `stub' == "gain" & `n'==0{
			local n : word count `stubList'
			di as err "{p 0 4 2}{bf:gain()} " ///
				"must specify the names of two new " ///
				"variables{p_end}"
			exit 198
		}
	}
	cap noi _stubstar2names `stubList', nvars(`nvar') outcome
	local rc = _rc
	if `rc'==102 | `rc'==103 {
		local nr : word count `stubList'
		local opt = `stub'
		di as err "{p 0 4 2}use {bf:`opt'()} "  ///
			"with `nvar' variable "  ///
			plural(`nvar',"name","names") ///
			", or use the {it:stub*} syntax{p_end}"
		exit 198
	}
	else {
		if (`rc') exit `rc'
	}
end

program define getNamelist, sclass
	syntax anything(name=vList) [if] [in] [fw pw iw aw] [, *]
	sreturn local vList `vList'
	sreturn local wtg `weight'
end

program define getVar, sclass
	syntax varlist(numeric ts) [if] [in] [, *]
	local n : word count `varlist'
	sreturn local nvar = `n'
	sreturn local varlist `varlist'
end

program define getGainVars, sclass
	syntax varlist(min=2 max=2 numeric) [if] [in] [, *]
	local n : word count `varlist'
	sreturn local nvar = `n'
	sreturn local varlist `varlist'
end

program define getNvar, sclass
	syntax newvarlist [, *]
	local n : word count `varlist'
	sreturn local nvar = `n'
end

exit
