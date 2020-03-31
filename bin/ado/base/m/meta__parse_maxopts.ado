*! version 1.0.1  12sep2019
program meta__parse_maxopts
	
	version 16
	syntax [, from(string)				///
		ITERate(string)				/// 
		TOLerance(string)			///
		CIVARTOLerance(string)			///
		NRTOLerance(string)			///
		model(string)				///
		method(string)				///
		i2(string)				///
		tau2(string)				///
		NONRTOLerance				///
		SHOWTRace ]				
	
	if missing("`model'") {
		local model  : char _dta[_meta_model]	
	}
	if missing("`method'") {
		local method : char _dta[_meta_method]
	}
	
	if !missing("`nrtolerance'") & !missing("`nonrtolerance'") {
		di as err ///
	"only one of {bf:nrtolerance()} or {bf:nonrtolerance} is allowed"
		exit 198
	}
	
	
	local msg1 "option {bf:from()} must contain a nonnegative value"
	local msg2 "option {bf:iterate()} must contain a nonnegative " ///
		"integer value"
	local msg3 "option {bf:tolerance()} must contain a positive value"
	local msg4 "option {bf:nrtolerance()} must contain a positive value"
	local msg5 "option {bf:civartolerance()} must contain a positive value"
	
	local opts `"`from'`iterate'`nrtolerance'`nonrtolerance'"'
	local opts `"`opts'`showtrace'`tolerance'"'
	if "`model'"!= "random" & !missing("`opts'") {
		di as err "{p}optimization options {bf:iterate()}, " ///
			"{bf:tolerance()}, {bf:nrtolerance()}, "     ///
			"{bf:nonrtolerance}, {bf:from()}, and "	     ///
			"{bf:showtrace} are allowed only with "      ///
			"random-effects models with iterative methods{p_end}"
		exit 498	
	}
	else if !missing("`i2'`tau2'") & !missing("`opts'") {
		di as err "{p}optimization options {bf:iterate()}, " 	     ///
			"{bf:tolerance()}, {bf:nrtolerance()}, "     	     ///
			"{bf:nonrtolerance}, {bf:from()}, and "	             ///
			"{bf:showtrace} are not allowed with either option"  ///
			" {bf:i2()} or option {bf:tau2()}{p_end}"
		exit 498	
	}
	else if "`model'"=="random" & !missing("`opts'") {
		if !inlist("`method'","reml","mle","ebayes","pmandel") {
			di as err "{p}optimization options {bf:iterate()}, " ///
			"{bf:tolerance()}, {bf:nrtolerance()}, "     	     ///
			"{bf:nonrtolerance}, {bf:from()}, and "	             ///
			"{bf:showtrace} are allowed only with iterative "    ///
			"methods, {bf:reml}, {bf:mle}, and {bf:ebayes}{p_end}"
			exit 498
		}
	}
	
		
	if !missing("`from'") {
		cap assert `from' >= 0
		if _rc {
			di as err "{p}`msg1'{p_end}"
			exit 198
		}
	}
	else local from -1
	if !missing("`iterate'") {
		cap confirm integer number `iterate'
		if _rc {
			di as err "{p}`msg2'{p_end}"
			exit 198
		}
		else {
			cap assert `iterate' >= 0
			if _rc {
				di as err "{p}`msg2'{p_end}"
				exit 198
			}
		}
	}
	else local iterate 100
	if !missing("`tolerance'") {
		cap assert `tolerance' > 0
		if _rc {
			di as err "{p}`msg3'{p_end}"
			exit 198
		}
	}
	else local tolerance 1e-6
	if !missing("`civartolerance'") {
		cap assert `civartolerance' > 0
		if _rc {
			di as err "{p}`msg5'{p_end}"
			exit 198
		}
	}
	else local civartolerance 1e-6
	if !missing("`nrtolerance'") {
		cap assert `nrtolerance' > 0
		if _rc {
			di as err "{p}`msg4'{p_end}"
			exit 198
		}
	}
	else local nrtolerance 1e-5
	
	c_local tolerance `tolerance'
	c_local civartolerance `civartolerance'
	c_local iterate  `iterate'
	c_local nrtolerance `nrtolerance'
	c_local from `from'
	c_local showtrace `showtrace'
	c_local nonrtolerance `nonrtolerance'
end

