*! version 1.0.3  16feb2015
program define webseek
	version 6
	local rel "r=1"
	local DfltLoc "http://www.stata.com"
	local DfltScr "websee.cgi"
	local DfltCon "http://www.stata.com"
	local Output wseekres

	local keyword
	gettoken word : 0, parse(" ,")
	while `"`word'"' != "" & `"`word'"' != "," {
		if index(`"`word'"',"&") | index(`"`word'"',"+") {
			di in red "keywords may not contain characters" /*
			*/ " + or &"
			exit 198
		}
		if `"`keyword'"'=="" {
			local keyword `"`word'"'
		}
		else	local keyword `"`keyword'+`word'"'
		gettoken word 0 : 0, parse(" ,")
		gettoken word   : 0, parse(" ,")
	}
	if `"`keyword'"'=="" {
		di in red "keywords required"
		exit 198
	}

	/* Here are the options in logical order:
		debug
		debugo
		or
		help result type
		tocpkg toc pkg
		everywhere filenames
		description titleonly filenames
		nostb
		engine(string)
	    The options are in alpha order below
	*/

	syntax [, /*
		*/ DEBUG		/*
		*/ DEBUGO		/*
		*/ DRYRUN		/* 
		*/ ENGine(string)	/*
		*/ ERRNONE		/*
		*/ Everywhere		/*
		*/ Filenames		/*
		*/ Help			/*
		*/ OR			/*
		*/ PKG			/*
		*/ noSTB		/*
		*/ Results		/*
		*/ TOCPKG 		/*
		*/ TOC 			/*
		*/ TYpe			/*
		*/ ]

	if ("`help'"!="") + ("`results'"!="") + ("`type'"!="") > 1 {
		di in red "options help, results, and type are" /*
		*/ " mutually exclusive"
		exit 198
	}
	if ("`tocpkg'"!="")+("`toc'"!="")+("`pkg'"!="")>1 {
		di in red "options tocpkg, toc, and pkg are mutually exclusive"
		exit 198
	}
	if ("`everywhere'"!="") + ("`filenames'"!="") > 1 { 
		di in red "options everywhere and filenames" /*
		*/ " are mutually exclusive"
		exit 198
	}
	if "`filenames'"!="" & ("`tocpkg'"!="" | "`toc'"!="") { 
		di in red "option filenames may not be combined with" /*
		*/ " tocpkg or toc"
		exit 198
	}

	if "`dryrun'"!="" { 
		local debug "debug"
	}


	/* 
		Set s=<search_type>,
			<search_type> := {btpf}{dtf}{yn}
	*/

	if "`filenames'" != "" {
		local search1 "f"
	}
	else if "`tocpkg'" != "" {
		local search1 "b"
	}
	else if "`toc'"!="" {
		local search1 "t"
	}
	else if "`pkg'"!="" {
		local search1 "p"
	}
	else	local search1 "b"

	if "`everywhere'"!="" {
		local search2 "d"
	}
	else if "`filenames'"!="" {
		local search2 "f"
	}
	else	local search2 "d"

	local search3 = cond("`stb'"!="", "n", "s")

	local search "s=`search1'`search2'`search3'"


	/* 
		Set o=<output_type>,
			<output_type> := {wlt}
		and internal mode flag
	*/
	Output1 "`help'`results'`type'"
	local output1 `s(output1)'
	if "`output1'"=="" {
		Output1 $webseek
		local output1 `s(output1)'
		if "`output1'"=="" {
			local output1 = cond("$S_OS"=="Unix","l","w")
		}
	}
	local output "o=`output1'"
	local mode "`output1'"

	/* 
		Set j=<join_bypte>,
			<join_type> := {oa}
	*/
	local join1=cond("`or'"!="", "o", "a")
	local join "j=`join1'"

	/* 
		Set k=<keywords>
	*/
	local key `"k=`keyword'"'


	/*
		set engine 
	*/
	if `"`engine'"' != "" {
		local loc `"`engine'/`DfltScr'"'
		local con `"`engine'"'
	}
	else {
		local loc `"`DfltLoc'/`DfltScr'"'
		local con `"`DfltCon'"'
	}



	capture erase `Output'.sthlp
	capture noi quietly {
		set checksum off
		if "`debug'" != "" {
			noi di /*
*/ `"copy `"`loc'?`rel'&`search'&`output'&`join'&`key'"' `"`Output'.sthlp"', text"'
		}
		if "`dryrun'" != "" { 
			exit
		}
		noi di in gr `"(contacting `con')"'
		copy `"`loc'?`rel'&`search'&`output'&`join'&`key'"' /*
			*/ `"`Output'.sthlp"', text
	}
	local rc = _rc
	set checksum on
	if "`debugo'"!="" { 
		di "BEGIN OUTPUT"
		capture noi type `"`Output'.sthlp"'
		di "END OUTPUT"
	}
	if `rc' {
		capture erase `"`Output'.sthlp"'
		exit `rc'
	}
	capture noi Part2 `mode' `"`Output'"' "`errnone'"
	local rc = _rc
	if "`mode'"!="w" | `rc' {
		capture erase `"`Output'.sthlp"'
	}
	exit `rc'
end


program define Output1, sclass
	args word
	sret clear
	if "`word'"=="results" {
		sret local output1 "l"
	}
	else if "`word'" == "help" {
		sret local output1 "w"
	}
	else if "`word'" == "type" {
		sret local output1 "t"
	}
end

program define Part2
	args mode Output errnone
	preserve
	local maxline 10
	quietly {
		drop _all
		infix str line 1-80 in 1/`maxline' using `"`Output'.sthlp"'
	}
	if _N==0 { 
		di in gr "no matches"
		exit cond("`errnone'"=="", 0, 111)
	}

	if bsubstr(trim(line[1]),1,2)!="++" { 
		if "`mode'"=="l" {
			help `Output'
		}
		else if "`mode'"=="w" {
			whelp `Output'
		}
		else {
			di 
			type `"`Output'.sthlp"'
		}
		exit
	}
	local rc = real(line[_N])
	local rc = cond(`rc'==0 | `rc'==., 198, `rc')
	local i 2 
	while `i' <= _N-1 {
		di in red line[`i']
		local i = `i' + 1
	}
	exit `rc'
end
exit
