*! version 1.0.0  24mar2015
program define unicode, rclass
	version 14
	local version : di "version " string(_caller()) ":"

	gettoken subcmd new0 : 0, parse(", ")

	local len = strlen(`"`subcmd'"') 
	
	if (`len' >= 3) & `"`subcmd'"' == bsubstr("locale", 1, `len') {
		`version' z_unicode `0'
		exit
	}
	else if (`len' >= 2) & `"`subcmd'"' == bsubstr("uipackage", 1, `len') {
		`version' z_unicode `0'
		exit
	}
	else if (`len' >= 3) & `"`subcmd'"' == bsubstr("encoding", 1, `len') {
		gettoken subsubcmd new0 : new0, parse(", ")
		if ("`subsubcmd'" == "list" | "`subsubcmd'" == "alias") {
			`version' z_unicode `0'
			exit
		}
	}
	else if (`len' >= 4) & `"`subcmd'"' == bsubstr("collator", 1, `len') {
		`version' z_unicode `0'
		exit
	}
	else if (`len' >= 4) & `"`subcmd'"' == bsubstr("convertfile", 1, `len') {
		`version' z_unicode `0'		
		exit
	}
	else if (`len' >= 4) & `"`subcmd'"' == bsubstr("fixvariable", 1, `len') {
		`version' z_unicode `0'
		exit
	}
	`version' z_unicodetrans `0'
	return add
end

