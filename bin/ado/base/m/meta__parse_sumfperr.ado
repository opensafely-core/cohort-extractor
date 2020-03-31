*! version 1.1.0  03oct2019
program meta__parse_sumfperr
	
	version 16
	syntax [, noSTUDies				///
		nostudy					/// 			
		CFormat(string)				///
		wgtformat(string)			///
		PFormat(string)				///
		SFormat(string)				///
		ordformat(string)			///
		noHEADer				///
		ESREFLINE				///
		SUBGRoup(varlist)			///
		INSIDEMARKER				///
		CUSTOMOVERall				///
		CUMULative(passthru)			///
		SORT(passthru)				///
		* ]			
	opts_exclusive `"`esrefline' `cumulative'"'
	opts_exclusive `"`insidemarker' `cumulative'"'
	if `:list sizeof subgroup' > 1 {
		if `"`insidemarker'"' != "" {
			di as err "{p}"
			di as err "option {bf:insidemarker} not allowed"
			di as err "with multiple {bf:subgroup()} variables"
			di as err "{p_end}"
			exit 198
		}
		if `"`sort'"' != "" {
			di as err "{p}"
			di as err "option {bf:sort()} not allowed"
			di as err "with multiple {bf:subgroup()} variables"
			di as err "{p_end}"
			exit 198
		}
	}
	if `"`customoverall'"' != "" & `"`cumulative'"' != "" {
		opts_exclusive `"customoverall() cumulative()"'
	}
	if `"`sort'"' != "" & `"`cumulative'"' != "" {
		opts_exclusive `"sort() cumulative()"'
	}
	
	if !missing("`studies'") {
		di as err "option {bf:nostudies} not allowed"
		exit 198	
	}
	if !missing("`study'") {
		di as err "option {bf:nostudy} not allowed"
		exit 198	
	}
	if !missing("`header'") {
		di as err "option {bf:noheader} not allowed"
		exit 198	
	}
	if !missing("`cformat'`wgtformat'`pformat'`sformat'`ordformat'") {
		di as err "{p}options {bf:cformat()}, {bf:wgtformat()}, "   ///
		"{bf:pformat()}, {bf:sformat()}, and {bf:ordformat()} are " ///
		"not available with {bf:meta forestplot}{p_end}"
		exit 198
	}
end

