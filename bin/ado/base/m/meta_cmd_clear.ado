*! version 1.0.0  14may2019
program meta_cmd_clear
	version 16
	
	syntax
	
	if missing("`: char _dta[_meta_marker]'") {
		di as txt "{p}(data not {bf:meta} set;"
		di as txt "use {helpb meta set} or {helpb meta esize}"
		di as txt "to declare as {bf:meta} data){p_end}"
		exit
	}
	
	cap drop _meta_*
	
	meta__clear_char
	
end
