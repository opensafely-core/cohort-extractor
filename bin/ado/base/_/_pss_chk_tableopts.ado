*! version 1.1.0  18feb2019
/*
	<anything> = [<label>:<column> [<label>:<column> [...]]]
*/
program _pss_chk_tableopts, sclass
	version 13
	args byrowmac colon 0
	syntax [anything(name=columns)] [,				/// 	
						ADD 			///
						LABels(string asis) 	///
						WIDths(string) 		///
						Formats(string asis) 	///
						NOFORMAT 		///
						SEParator(string) 	///
						DIVider 		///
						BYROW			///
						NOHEADer 		///
						CONTinue 		///
						pssobj(string) 		///
						NOTABle 		///
						Table 			///
						NOLABel /// //undoc.
						* ]
	c_local `byrowmac' "`byrow'"
	local collabels `"`labels'"'
	local colwidths `"`widths'"'
	if (`"`options'"'!="") {
		gettoken opt : options, bind
		di as err `"{bf:table()}: option {bf:`opt'} not allowed"'
		exit 198
	}
	if (`"`separator'"'=="") {
		local separator 0
	}
	else {
		cap confirm integer number `separator'
		local rc 0
		if (_rc) {
			local rc = _rc
		}
		else if (`separator'<0) {
			local rc = 198
		}
		if (`rc') {
			di as err "{bf:separator()} must contain " ///
				  "nonnegative integers"
			exit 198
		}
	}
	if ("`pssobj'"!="") {
		mata: st_local("allcolnames", `pssobj'.allcolnames); ///
		      st_local("defcolnames", `pssobj'.defcolnames); ///
		      st_local("allcolnamesshow", `pssobj'.allcolnamesshow)
		mata: `pssobj'.defcollabels("defcollabels")
	}
	local nwords: list sizeof columns
	local all "_all"
	local is_all : list all in columns
	if (`is_all') {
		if (`nwords'>1) {
			di as err "{bf:table()}: you may not specify "  ///
				  "{bf:_all} and columns together"
			exit 198
		}
		local colnames "`allcolnamesshow'"
	}
	else {
	    while (`"`columns'"'!="") {
		local lab
		gettoken col columns : columns, parse(": ")
		gettoken colon : columns, parse(": ") quotes qed(quotes)
		if (`"`colon'"'==":") {
			gettoken colon columns : columns, parse(": ")
			gettoken lab columns : columns, quotes
		}
		else if (`quotes') {
			gettoken lab columns: columns, quotes
		}
		local colnames `colnames' `col'
		if (`"`lab'"'!="") {
			local collabs `"`collabs' `lab'"'
		}
		else {
			local collabs `"`collabs' """'
		}
	    }
	}
	if (`"`collabels'`colwidths'`formats'"'!="") {
		if ("`colnames'"=="") {
			local tabcols "`defcolnames'"
		}
		else if ("`add'"!="") {
			local tabcols "`defcolnames' `colnames'"
		}
		else {
			local tabcols "`colnames'"
		}
	}
	if (`"`collabels'"'!="") {
		_pss_optcolspec labels() label "`tabcols'" `"`collabels'"' qq
		local collabels `"`s(vals)'"'
		local collabelspos "`s(posind)'"
	}
	if (`"`colwidths'"'!="") {
		cap numlist `"`colwidths'"', missingok range(>1) integer
		if (_rc==125 | _rc==126) {
			di as err "{bf:widths()}: invalid {it:numlist} " ///
				  "specification;"
			di as err "{p 4 4 2}{bf:widths(}{it:numlist}{bf:)} "
			di as err "may contain only integers greater than 1 "
			di as err "and missing values{p_end}"
			exit 198 
		}
		else if (_rc) { // alternative specification
			_pss_optcolspec widths() # ///
					"`tabcols'" `"`colwidths'"'
			local subcolwidths `"`s(vals)'"'
			local colwidthspos "`s(posind)'"
			local colwidths
		}
	}
	if (`"`formats'"'!="") {
		if ("`noformat'"!="") {
			di as err "only one of {bf:formats()} or "	///
				  "{bf:noformat} is allowed"
			exit 198
		}
		gettoken fmt : formats, quotes qed(qq)
		if (!`qq') { // alternative specification
			cap noi _pss_optcolspec formats() 	///
				"{it:{help format:fmt}}" 	///
				"`tabcols'" `"`formats'"' qq
			if (_rc) {
				di as err "{p 4 4 2} or a list of formats "
				di as err `"in quotes:{p_end}"'
				di as err `"{p 8 8 2}"{it:{help format:fmt}}" "'
				di as err `"["{it:{help format:fmt}}" [...] ]"'
				di as err "{p_end}"
				exit _rc
			}
			local subformats `"`s(vals)'"'
			local formatspos "`s(posind)'"
			local formats
		}
	}
	if ("`allcolnames'"!="") {
		local notallowed : list colnames - allcolnames
		if (`"`notallowed'"'!="") {
			di as err `"{p}{bf:table()}: invalid "'
			di as err plural(`: list sizeof notallowed',"column")
			di as err `" {bf:`notallowed'}{p_end}"'
			exit 198
		}
	}
	if ("`colnames'"=="") {
		local ncols : list sizeof defcolnames
	}
	else {
		local ncols : list sizeof colnames
	}
	local ncolw : list sizeof colwidths
	if (`ncolw'==0) {
		local colwidths
	}
	else if (`ncolw'<`ncols') {
		local lastw : word `ncolw' of `colwidths'
		local colwidths `colwidths' ///
				`: di _dup(`=`ncols'-`ncolw'') " `lastw'"'
	}
	else if (`ncolw'>`ncols') {
		di as err "{bf:widths()}: too many values specified"
		exit 198
	}
	local nform : list sizeof formats
	if (`nform'==0) {
		local formats
		if ("`noformat'"!="" & "`pssobj'"!="") {
			mata: `pssobj'.formats = J(1,0,.)
		}
	}
	else if (`nform'<`ncols') {
		local lastf : word `nform' of `formats'
		local formats ///
		    `"`formats' `: di _dup(`=`ncols'-`nform'') `" "`lastf'""''"'
	}
	else if (`nform'>`ncols') {
		di as err "{bf:formats()}: too many values specified"
		exit 198
	}
	if ("`nolabel'"!="") {
		local collabs `colnames'
	}
	if ("`pssobj'"!="") {
		if ("`add'"!="") {
			local colnames `defcolnames' `colnames'
			if (`"`collabs'"'!="") {
				local collabs `"`defcollabels' `collabs'"'
			}
			else local collabs
			local ndefcols : list sizeof defcolnames
			if (`ncolw') {
				local colwidths 	///
				      `: di _dup(`ndefcols') " ."' `colwidths'
			}
			if (`nform') {
				local formats `"`: di _dup(`ndefcols') `" """'' `formats'"'
			}
		}
		mata: `pssobj'.inittabopts("`table'`notable'",	///
					   "`colnames'",	///
					   "`colwidths'",	///
					   `"`formats'"',	///
					   `"`collabs'"',	///
					   ("`divider'"!=""),	///
					   `separator', 	///
					   `"`collabels'"',	///
					   "`collabelspos'",	///
					   `"`subcolwidths'"',	///
					   "`colwidthspos'",	///
					   `"`subformats'"',	///
					   "`formatspos'",	///
					   ("`noheader'"!=""), 	///
					   ("`continue'"!=""),	///
					   ("`byrow'"!=""))
	}
	sret clear /* clean up */
end

program _pss_optcolspec, sclass
	args optname sname tabcols colspec qq

	if (`"`colspec'"'=="") exit	

	while (`"`colspec'"'!="") {
		gettoken col colspec : colspec, qed(quotes)
		if (`quotes') {
			di as err "{bf:`optname'}: invalid specification;"
			di as err "{p 4 4 2}Column names may not be enclosed "
			di as err "in quotes.{p_end}"
			exit 198
		}
		gettoken val colspec : colspec, quotes qed(quotes)
		if (`"`val'"'=="") {
			_pss_colspec_err1 198 "`optname'" "`sname'" `"`qq'"'
		}
		if (`"`qq'"'!="" & !`quotes') {
			_pss_colspec_err1 198 "`optname'" "`sname'" `"`qq'"'
		}
		else if (`"`qq'"'=="") {
			cap confirm integer number `val'
			local rc 0
			if (_rc) {
				local rc = 198
			}
			else {
				if (`val'<2) {
					local rc = 198
				}
			}
			_pss_colspec_err2 `rc' "`optname'" "`sname'"
		}
		local pos : list posof "`col'" in tabcols
		if (!`pos') {
			di as err "{bf:`optname'}: invalid specification;"
			di as err "{p 4 4 2}Column {bf:`col'} is not one "
			di as err "of the table columns.  Current table "
			di as err "columns include: {bf:`tabcols'}.{p_end}"
			exit 198
		}
		local posind `posind' `pos'
		local vals `"`vals' `val'"'
	}
	sret local vals `"`vals'"'
	sret local posind "`posind'"
	
end

program _pss_tabopts_err1

	di as err "{bf:columns()}: invalid specification"
	di as err "{p 4 4 2}An optional column label {it:clab} may be"
	di as err "specified before the column name {it:cname} separated by"
	di as err "the colon with no spaces--[{it:<clab>}{bf::}]{it:cname};"
	di as err `"e.g., {bf:columns("Sample size":N)}."'
	di as err "{p_end}"
	exit(198)
end

program _pss_colspec_err1
	args rc optname sname qq

	if (`rc'==0) exit

	if (`"`qq'"'!="") {
		local inquotes " in quotes"
		local qq `"""'
	}

	di as err "{bf:`optname'}: invalid specification;"
	di as err "{p 4 4 2}You must specify the column "
	di as err "name followed by `sname'`inquotes':{p_end}"
	di as err "{p 8 8 2}{it:column} "
	di as err `"{bf:`qq'}{it:`sname'}{bf:`qq'} "'
	di as err "[{it:column} "
	di as err `"{bf:`qq'}{it:`sname'}{bf:`qq'} [...] ]{p_end}"'

	exit `rc'
end

program _pss_colspec_err2
	args rc optname sname

	if (`rc'==0) exit

	di as err "{bf:`optname'}: invalid column width"
	di as err "{p 4 4 2}Column widths must be integer numbers"
	di as err "greater than 2.{p_end}"

	exit `rc'
end

exit
