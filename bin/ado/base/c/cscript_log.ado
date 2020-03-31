*! version 1.1.0  09jun2015
program define cscript_log
	version 7
	args subcmd subdir nothing 
	if `"`nothing'"' != "" { 
		error 198
	}
	if `"`subdir'"' != "" {
		qui cd `"`subdir'"'
	}

	if `"`subcmd'"' == "begin" {
		clear
		discard
		if "$S_CONSOLE" == "" {
			local prefix "x"
		}
		else	local prefix "c"
		if "$S_StataSE"=="SE" { 
			local suffix "-se"
		}
		if "$S_StataMP"=="MP" { 
			local suffix "-mp"
		}
		capture erase `"`prefix'test`suffix'.smcl"'
		capture erase `"`prefix'test`suffix'.log"'
		capture erase `"`prefix'cf`suffix'.log"'
		qui log using `"`prefix'test`suffix'.smcl"'
		di as txt `"(log `r(filename)' started)"'
		exit
	}
	if `"`subcmd'"'=="end" | `"`subcmd'"'=="close" {
		qui log close 
		di as txt "(log normal close)"
		exit
	}
	error 198 
end
