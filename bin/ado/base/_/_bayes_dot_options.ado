*! version 1.0.0  13feb2019

program _bayes_dot_options, sclass
	version 16.0
	
	args nodots dots dots1

	if (`"`dots'"'!="" & "`dots1'"!="") {
		di as err "only one of {bf:dots} or {bf:dots()} is allowed"
		exit 198
	}
	if (`"`nodots'"'!="" & "`dots'"!="") {
		di as err "only one of {bf:nodots} or {bf:dots} is allowed"
		exit 198
	}
	if (`"`nodots'"'!="" & "`dots1'"!="") {
		di as err "only one of {bf:nodots} or {bf:dots()} is allowed"
		exit 198
	}
	
	if (`"`dots1'`dots'"'=="" | "`nodots'"!="") {
		local dots 0
		local dotsevery 0
	}
	else if ("`dots'"!="") {
		local dots 100
		local dotsevery 1000
	}
	else {
		_check_dots `dots1'
		local dots `s(dots)'
		local dotsevery `s(dotsevery)'
	}
	sret local dots `dots'
	sret local dotsevery `dotsevery'
end

program _check_dots, sclass
	syntax [anything(name=dots)] [, every(string) * ]
	if (`"`options'"'!="") {
		di as err "suboption {bf:`options'} is not allowed in " ///
			  "option {bf:dots()}"
		exit 198
	}
	if (`"`dots'"'!="") {
		_bayes_check_number `dots' "integer" 0 "." "<" ">" dots()
	}
	else {
		local dots 1
	}
	if (`"`every'"'!="") {
		_bayes_check_number `every' "integer" 0 "." "<" ">" "dots(, every())"
	}
	else {
		local every 0
	}
	sret local dots `dots'
	sret local dotsevery `every'
end
