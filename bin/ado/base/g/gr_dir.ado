*! version 1.1.3  06nov2015
program gr_dir, rclass
	version 8
	gettoken pattern : 0, parse(" ,")
	if `"`pattern'"' != "" & `"`pattern'"' != "," {
		gettoken pattern 0 : 0, parse(" ,")
	}
	else	local pattern

	syntax [, Memory Gph Detail]
	local domem 0
	local dogph 0
	if "`memory'"!="" | "`gph'"!="" {
		if ("`memory'"!="") local domem 1
		if ("`gph'"!="")    local dogph 1
	}
	else {
		local domem 1
		local dogph 1
	}

	if `domem' {
		_gs_clean_graphlist
		local mlist `"`._Gr_Global.graphlist'"'
		local mlist : list clean mlist
		if `"`pattern'"' != "" {
			Filter mlist : `"`pattern'"' `"`mlist'"'
		}
		local mlist : list sort mlist
	}
	if `dogph' {
		local glist : dir . files "*.gph", respectcase
		local glist : list clean glist
		if `"`pattern'"' != "" {
			Filter glist : `"`pattern'"' `"`glist'"'
		}
		local glist : list sort glist
	}

	ret local list `"`mlist' `glist'"'

	if "`detail'"=="" DisplayInCols res 4 0 0 `mlist' `glist'
	else		  Detail "`mlist'" `"`glist'"'
end

program Filter 
	args lhs colon pattern list


	foreach el of local list {
		if match(`"`el'"', `"`pattern'"') {
			local newlist `newlist' `el'
		}
	}
	c_local `lhs' `newlist'
end
		

program Detail
	args mlist glist 

	local hasmlist 0
	local hasglist 0
	if "`mlist'"!="" {
		local hasmlist 1
	}
	if "`mlist'"!="" {
		local hasglist 1
	}

	local len 0
	foreach el in `mlist' `glist' {
		if (length(`"`el'"') > `len') local len = length(`"`el'"')
	}
	local len = cond(`len'<8, 8, cond(`len'>32, 32, `len'))

	Header `len'
	local line 0
	foreach el of local mlist {
		Line `++line' 0 `len' `"`el'"'
	}
	if (`hasmlist' & `hasglist') Divider `len'
	local line 0
	foreach el of local glist {
		Line `++line' 1 `len' `"`el'"'
	}
	Trailer `len'
end

program Line 
	args lino isfile len el

	if (`lino' == 5*int(`lino'/5)) di as txt

	local cmdlen = min(max(c(linesize)-`len'-9, 20), 78)
	
	if (`isfile')	capture gs_fileinfo `"`el'"'
	else		capture gs_graphinfo `el'
	if _rc==0 {
		if ("`r(ft)'" == "live")    local cmd `"`r(command)'"'
		else if ("`r(ft)'")=="asis" local cmd "(asis-format file)"
		else if ("`r(ft)'")=="old"  local cmd "(old-format file)"
		else                        local cmd "(unknown filetype)"
	}
	else	local cmd "(not a Stata file)"
		
	if (udstrlen(`"`el'"') > `len') di as res `"  `el'"'
	else			      di as res `"  `el'{...}"'

	di "{col `=`len'+5'}{...}"
	if udstrlen(`"`cmd'"') > `cmdlen' {
		local cmd = udsubstr(`"`cmd'"', 1, `cmdlen')
		di as txt _asis `"`cmd'..."'
	}
	else	di as txt _asis `"`cmd'"'
end

program Header
	args len
	di as txt
	di as txt "  name{col `=`len'+5'}command"
	di as txt "  {hline `=`c(linesize)'-4'}"
end

program Divider 
	args len
	di as txt "  {hline `=`c(linesize)'-4'}"
end

program Trailer
	args len
	di as txt "  {hline `=`c(linesize)'-4'}"
end
		




program DisplayInCols /* sty #indent #pad #wid <list>*/
	gettoken sty    0 : 0
	gettoken indent 0 : 0
	gettoken pad    0 : 0
	gettoken wid	0 : 0

	local indent = cond(`indent'==. | `indent'<0, 0, `indent')
	local pad    = cond(`pad'==. | `pad'<1, 2, `pad')
	local wid    = cond(`wid'==. | `wid'<0, 0, `wid')
	
	local n : list sizeof 0
	if `n'==0 { 
		exit
	}

	foreach x of local 0 {
		local wid = max(`wid', length(`"`x'"'))
	}

	local wid = `wid' + `pad'
	local cols = int((`c(linesize)'+1-`indent')/`wid')

	if `cols' < 2 { 
		if `indent' {
			local col "_column(`=`indent'+1')"
		}
		foreach x of local 0 {
			di as `sty' `col' `"`x'"'
		}
		exit
	}
	local lines = `n'/`cols'
	local lines = int(cond(`lines'>int(`lines'), `lines'+1, `lines'))

	/* 
	     1        lines+1      2*lines+1     ...  cols*lines+1
             2        lines+2      2*lines+2     ...  cols*lines+2
             3        lines+3      2*lines+3     ...  cols*lines+3
             ...      ...          ...           ...               ...
             lines    lines+lines  2*lines+lines ...  cols*lines+lines

             1        wid
	*/


	* di "n=`n' cols=`cols' lines=`lines'"
	forvalues i=1(1)`lines' {
		local top = min((`cols')*`lines'+`i', `n')
		local col = `indent' + 1 
		* di "`i'(`lines')`top'"
		forvalues j=`i'(`lines')`top' {
			local x : word `j' of `0'
			di as `sty' _column(`col') `"`x'"' _c
			local col = `col' + `wid'
		}
		di as `sty'
	}
end
