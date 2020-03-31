*! version 1.0.0  14nov2018
program _lasso_parse_laout, sclass
	version 16.0

	syntax [anything(name=laout_name id="laout output")] [, replace]


	if (`"`replace'"' == "replace") {
		local laout_isreplace = 1
		local laout_replace replace
	}
	else {
		local laout_isreplace = 0
		local laout_replace
	}

	if (`"`laout_name'"' == "") {
		esrf default_filename
		local laout_name `s(stxer_default)'
		local laout_isreplace = 1
		local laout_replace replace
	}

	sret local laout_name `laout_name'
	sret local laout_isreplace `laout_isreplace'
	sret local laout_replace `laout_replace'
end
