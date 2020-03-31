*! version 1.0.2  09jan2007
program ca_parse_normalize, sclass
	version 8
	
	local 0 ,`0' 
	
	syntax [, CAnonical STandard SYmmetric ROw COlumn PRincipal * ]
	
	local opt  `canonical' `standard' `symmetric' `row' `column' `principal'
	local nopt : list sizeof opt
	if `nopt' > 1 {
		opts_exclusive "`opt'" normalize 198
	}	
	else if `nopt' == 1 & `"`options'"' != "" { 
		dis as err `"normalize() invalid; unexpected input `options'"' 
		exit 198
	}
	else if `"`options'"' != "" { 
		capture confirm number `options' 
		if _rc {
			dis as err ///
			    `"invalid keyword in option normalize(): `options'"'
			exit 198
		}
		local opt value
		if !inrange(`options',0,1) {
			dis as err "option normalize() invalid: " /// 
			           "value `options' out of range [0,1]" 
			exit 125
		}	
		local value = `options'
		local opt "value=`value'" 
	}
	else if inlist("`opt'", "symmetric", "canonical", "") { 
		local opt symmetric
		local value = 0.5
	}
	else if "`opt'" == "row" {
		local value = 1
	}
	else if "`opt'" == "column" {
		local value = 0
	}
	
	sreturn clear
	sreturn local normalize `opt' 
	
	if "`opt'" == "principal" {
		sreturn local alpha = 1
		sreturn local beta  = 1
	}
	else if "`opt'" == "standard" {
		sreturn local alpha = 0
		sreturn local beta  = 0
	}
	else { 
		sreturn local alpha = `value' 
		sreturn local beta  = 1 - `value' 
	}	
end
exit
