*! version 1.0.0  27apr2019
program meta__model_err

	syntax [, mh] 
	
	if missing("`mh'") {
		di as err "only one of options {bf:random()}, {bf:random}, " ///
		"{bf:common}, or {bf:fixed} may be specified"
		exit 184	
	}
	else {
		di as err "{p}only one of options {bf:random()}, " ///
			"{bf:random}, {bf:common()}, {bf:common}, " ///
			"{bf:fixed()}, or {bf:fixed} may be " ///
			"specified{p_end}"
		exit 184
	}
	
end	
