*! version 1.0.8  13feb2015
program define print
	version 7.0
	
	gettoken filename 0 : 0, parse(", ")
	gettoken start rest : filename, parse(".")
	while ("`rest'" != "") {
		gettoken next rest : rest, parse(".")
		if ("`rest'" != "") {
			local ext "`rest'"
		}
	}
	
	syntax [, like(string) name(passthru) printer(string) * ]
			
	if bsubstr("`filename'", 1, 1) == "@" {
		if "`like'" != "" {
			dis in error "like() invalid"
			exit 198
		}
		local first = bsubstr("`filename'", 2, .)
		local translator "`first'2prn"
	}
	else if "`like'" != "" {
		local translator "`like'2prn"
	}
	else {
		qui transmap q `ext'
		local ext "`r(suffix)'"
		local translator "`ext'2prn"
	}

	if ("`ext'" == "gph") {
		capture gs_fileinfo `"`filename'"'
		if _rc {
			di as err "file not a Stata .gph file"
			exit 610
		}
		if !("`r(ft)'" == "old" | "`r(ft)'" == "asis") {
			di as err "cannot print live graph directly from file;"
			di as err "try -graph use {it:filename}- then -print @Graph-"
			exit 610
		}
	}

	if "$S_OS" == "Unix" {
		if "`printer'" != ""  {
			if bsubstr("`filename'", 1, 1) == "@" {
				local translator "`first'2`printer'"
			}
			else if "`like'" != ""  {
				local translator "`like'2`printer'"
			}
			else 	local translator "`ext'2`printer'"
		}
	}
	else {
		if "`printer'" != "" {
			dis in err "printer() invalid" 
			exit 198
		}
	}
	qui translate "`filename'" __PRINT, /*
			*/ translator(`translator') `name' `options'
end
		
