*! version 1.0.0  13feb2019

program _bayes_check_number
	version 16.0

	args number integer min max leq geq optname

	cap confirm `integer' number `number'
	if ("`integer'"!="") {
		local numborint integer
		local dinumber an integer
	}
	else {
		local numborint number
		local dinumber a number
	}
	if ("`max'"=="." & `min'==0) {
		if ("`leq'"=="<") {
			local dinumber a nonnegative `numborint'
		}
		else {
			local dinumber a positive `numborint'
		}
	}
	else if ("`max'"=="." & `min'!=0) {
		if ("`leq'"=="<") {
			local dinumber `dinumber' greater than or equal to `min'
		}
		else {
			local dinumber `dinumber' greater than `min'
		}
	}
	else if ("`max'"=="`min'") {
		local dinumber `dinumber' equal to `min'
	}
	else {
		if ("`leq'"=="<" & "`geq'"==">") {
			local dinumber `dinumber' between `min' and `max'
			local dinumber `dinumber', inclusive
		}
		else if ("`leq'"=="<" & "`geq'"==">=") {
			local dinumber `dinumber' between `min' (inclusive) 
			local dinumber `dinumber' and `max'
		}
		else if ("`leq'"=="<=" & "`geq'"==">") {
			local dinumber `dinumber' between `min'
			local dinumber `dinumber' and `max' (inclusive)
		}
		else {
			local dinumber `dinumber' between `min' and `max'
		}
		
	}
	local rc = _rc
	if (!`rc') {
		if (`number'`leq'`min' | `number'`geq'`max') {
			local rc 198
		}
	}
	if `rc' {
		di as err "{p}option {bf:`optname'} must contain"
		di as err "`dinumber'{p_end}"
		exit `rc'
	}
end
