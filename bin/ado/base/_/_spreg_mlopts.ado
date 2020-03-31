*! version 1.1.0  30mar2018
program define _spreg_mlopts
	version 15.0	

	_on_colon_parse `0'
	local MLOPT `s(before)'
	local 0	`s(after)'

	syntax [, DIFficult            			/// Maximization Options 
		TECHnique(string)      			///
		ITERate(real 1500)     			///
		NOLOg LOg                		///
		TRace                			///
		GRADient               			///
		showstep               			///
		HESSian              			///
		SHOWTOLerance        			///
		TOLerance(real 1e-6)   			///
		LTOLerance(real 1e-7)  			///
		NRTOLerance(real 1e-5) 			///
		NONRTOLerance				///
		crittype(string)]
						// check maximize options
	MaximizeOptionsCheck , technique(`technique') iterate(`iterate')  ///
		tolerance(`tolerance') ltolerance(`ltolerance')           ///
		nrtolerance(`nrtolerance') `nonrtolerance'
	
						// difficult	
	if ("`difficult'"=="difficult") {
		local difficult	= "hybrid"
	}
	else {
		local difficult	= "m-marquardt"
	}
						// technique 
	if ("`technique'"!="") {
		local technique	= "`technique'"
	}
	else {
		local technique	= "nr"
	}
						// iterate
	local iterate	= `iterate'
						// log
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"					
	if (`"`log'"'=="nolog") {
		local log = "off"
	}
	else {
		local log	= "on"
	}
						// trace
	if ("`trace'" == "") {
		local trace	= "off"
	}
	else {
		local trace	= "on"
	}
						// gradient
	if ("`gradient'" =="") {
		local gradient	= "off"
	}
	else {
		local gradient	= "on"
	}
						// showstep
	if ("`showstep'" == "") {
		local showstep	= "off"
	}
	else {
		local showstep	= "on"
	}
						// hessian
	if ("`hessian'" == "") {
		local hessian	= "off"
	}
	else {
		local hessian	= "on"
	}
						// showtolerance
	if ("`showtolerance'" == "") {
		local showtolerance 	= "off"
	}
	else {
		local showtolerance	= "on"
	}
						// nonrtolerance
	if ("`nonrtolerance'" == "nonrtolerance") {
		local nonrtolerance	= "on"
	}
	else {
		local nonrtolerance	= "off"
	}
						// tolerance level	
	local tolerance	= `tolerance'
	local ltolerance	= `ltolerance'
	local nrtolerance	= `nrtolerance'


	capture mata : rmexternal("`MLOPT'")
	mata : _st_SPREG__mlopt_parse("`MLOPT'")
end
						//---MaximizeOptionsCheck--//
program MaximizeOptionsCheck
	syntax  [,			///
		TECHnique(string)      	///
		ITERate(real 1500)     	///
		TOLerance(real 1e-6)   	///
		LTOLerance(real 1e-7)  	///
		NRTOLerance(real 1e-5) 	///
		NONRTOLerance        	///
		]

	opts_exclusive "nrtolerance() `nonrtolerance'"
						// iterate	
	if `iterate' < 0 {
		di as error "{bf:iterate()} must be a nonnegative integer"
		exit 125
	}
						// nrtolerance
	if `nrtolerance' < 0 {
		di as error "{bf:nrtolerance()} should be nonnegative"
		exit 198
	}
						// tolerance	
	if `tolerance' < 0 {
		di as error "{bf:tolerance()} should be nonnegative"
		exit 198
	}
						// ltolerance
	if `ltolerance' < 0 {
		di as error "{bf:ltolerance()} should be nonnegative"
		exit 198
	}
							// technique
	ml_technique , technique(`technique')
end
