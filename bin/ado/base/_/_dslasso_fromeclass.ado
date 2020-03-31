*! version 1.0.0  25mar2019
program _dslasso_fromeclass
	syntax [, laout_name(string)]

	if (!fileexists(`"`laout_name'"')) {
		esrf create `laout_name'	
	}
	esrf fromeclass `laout_name' , pattern(*)  replace
end
