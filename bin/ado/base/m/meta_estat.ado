*! version 1.0.0  02may2019
program meta_estat
	version 16
	
	gettoken cmd : 0, parse(" ,")
	local lcmd = length(`"`cmd'"')

	if `"`cmd'"'==bsubstr("bubbleplot",1,max(6,`lcmd')) {
		gettoken cmd 0 : 0, parse(", ")
		meta_estat_bubble `0'
		exit
	}
	
	// for handling other estats e.g. -estat vce- and -estat summarize-
	estat_default `0'
end

exit
