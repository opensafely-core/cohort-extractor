*! version 1.0.0  17apr2013
program _bs_check
	version 13

	local prefix `"`c(prefix)'"'
	if `:list posof "bootstrap" in prefix' {
		// weights not allowed
		syntax [anything(equalok)] [if] [in] [, *]
	}
end
exit
