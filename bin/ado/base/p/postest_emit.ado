*! version 1.0.1  28may2015
program postest_emit
	version 14
	syntax anything(id="class arrays") [, validate rsrckey]
	tokenize `anything'
	args cmd ttl repop

	local validate : list sizeof validate
	local rsrckey : list sizeof rsrckey

	if `"``cmd'.isa'"' != "array" {
		di as err "`cmd' is not a class array"
		exit 198
	}

	if `"``ttl'.isa'"' != "array" {
		di as err "`ttl' is not a class array"
		exit 198
	}

	mata: (void) postest_emit(	"`cmd'",	///
					"`ttl'",	///
					"`repop'",	///
					`validate',	///
					`rsrckey')
end
exit
