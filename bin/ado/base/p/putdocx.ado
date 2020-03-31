*! version 1.6.3  31jan2020
program define putdocx
	version 16.0
	
	if `"`0'"' == `""' {
		di as err "subcommand required"
		exit 198
	}
	
	local cmd `0'
	
	gettoken do 0 : 0, parse(" ,")
	local ldo = length("`do'")
	
	if "`do'" == bsubstr("begin",1,max(5,`ldo')) {
		docx_begin `0'
		exit
	}
	else if "`do'" == bsubstr("paragraph",1,max(9,`ldo')) {
		docx_paragraph `0'
		exit
	}
	else if "`do'" == bsubstr("text",1,max(4,`ldo')) {
		docx_text `0'
		exit
	}
	else if "`do'" == bsubstr("table",1,max(5,`ldo')) {
		docx_table `0'
		exit
	}
	else if "`do'" == bsubstr("image",1,max(5,`ldo')) {
		docx_image `0'
		exit
	}
	else if "`do'" == bsubstr("pagebreak",1,max(9,`ldo')) {
		docx_pagebreak `0'
		exit
	}
	else if "`do'" == bsubstr("describe",1,max(8,`ldo')) {
		docx_describe `0'
		exit
	}
	else if "`do'" == bsubstr("save",1,max(4,`ldo')) {
		local 0 `"using `0'"'
		docx_save `0'
		exit
	}
	else if "`do'" == bsubstr("append",1,max(6,`ldo')) {
		docx_append `0'
		exit
	}
	else if "`do'" == bsubstr("clear",1,max(5,`ldo')) {
		docx_clear `0'
		exit
	}
	else if "`do'" == bsubstr("sectionbreak",1,max(12,`ldo')) {
		docx_sectionbreak `0'
		exit
	}
	else if "`do'" == bsubstr("textblock",1,max(9,`ldo')) {
		docx_textblock `0'
		exit
	}
	else if "`do'" == bsubstr("textfile",1,max(8,`ldo')) {
		docx_textfile `0'
		exit
	}
	else if "`do'" == bsubstr("pagenumber",1,max(10,`ldo')) {
		docx_pagenumber `0'
		exit
	}
	else if "`do'" == bsubstr("tohtml",1,max(6,`ldo')) {
		docx_tohtml `0'
		exit
	}
	else if "`do'" == bsubstr("totext",1,max(6,`ldo')) {
		docx_totext `0'
		exit
	}
	else {
		di as err `"unknown subcommand `do'"'
		exit 198
	}
end

program docx_begin
	syntax [anything] [,font(string asis) LANDscape PAGEsize(string) ///
                header(string) footer(string) pagenum(string asis) *]
		
	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}

	local margins
	local 0 `anything', `options'
	local 0 , `options'
	syntax , [margin(passthru) *]
	while !missing(`"`margin'"') {
		if !missing(`"`margin'"') {
			local margins `margins' `margin'
		}
		local 0 , `options' 
		syntax , [margin(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}

	mata: docx_begin_wrk(`"`font'"', `"`landscape'"', `"`pagesize'"', `"`margins'"')
	mata: docx_hdr_ftr_wrk(`"`header'"', `"`footer'"')
	if(`"`pagenum'"' != "") {
		mata: docx_set_pgnum(`"`pagenum'"')
	}
end

program docx_paragraph
	syntax [anything] [,style(string) font(string) halign(string) 	///
			    valign(string) SHADing(string) toheader(string)       ///
                tofooter(string) *]
	
	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}
	mata: docx_is_valid()

	local indents
	local spacings
	
	local addloc -1
	local hfname ""
	if !missing(`"`toheader'"') {
		local hfname `"`toheader'"'
		local addloc 2
	}
	if !missing(`"`tofooter'"') {
		if `addloc' == -1 {
			local hfname `"`tofooter'"'
			local addloc 3
		}
		else {
			di as err "only one of {bf:toheader()} or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if `addloc' == -1 {
		local addloc 1
	}
    if `addloc' == 2 | `addloc' == 3 {
        mata: docx_validate_header_footer(`addloc', `"`hfname'"')
    }
	
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [indent(passthru) spacing(passthru) *]
	while !missing(`"`indent'`spacing'"') {
		if !missing(`"`indent'"') {
			local indents `indents' `indent'
		}
		if !missing(`"`spacing'"') {
			local spacings `spacings' `spacing'
		}
		local 0 , `options' 
		syntax , [indent(passthru) spacing(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	mata: docx_add_paragraph_wrk(`"`style'"', `"`font'"', 		///
		`"`halign'"', `"`valign'"', `"`shading'"',		///
		`"`indents'"', `"`spacings'"', `addloc',    ///
		`"`hfname'"')
end

program docx_text
	syntax anything(name=paraexplist id=paraexplist equalok) [, 	///
		font(string) script(string) SHADing(string)		///
		bold italic UNDERLine(string) UNDERLine1 STRIKEout 	///
		NFORmat(string) linebreak(string) SMALLCaps ALLCaps 	///
		HYPERLink(string) trim *]
	
	mata: docx_is_valid()
	
	if `"`underline'"' != "" & `"`underline1'"' != "" {
di as err "only one of {bf:underline} or {bf:underline()} is allowed"
		exit 198
	}
	
	if `"`underline1'"' != "" {
		local underline "single"
	}
	
	if `"`smallcaps'"' != "" & `"`allcaps'"' != "" {
di as err "only one of {bf:smallcaps} or {bf:allcaps} is allowed"
		exit 198
	}
	
	local lb `linebreak'
	if `"`lb'"' != "" {
		capture confirm integer number `lb'
		if _rc {
	di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
		
		if real(`"`lb'"') < 1 {
	di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
	}
	
	local linebreaks 0
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [linebreak *]
	while !missing(`"`linebreak'"') {
		if !missing(`"`linebreak'"') {
			local ++linebreaks
		}
		local 0 , `options' 
		syntax , [linebreak *]
	}
	
	if `"`options'"' != "" {
di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	if `linebreaks' > 0 & `"`lb'"' != "" {
di as err "only one of {bf:linebreak} and {bf:linebreak()} is allowed"
		exit 198
	}
	
	if `"`lb'"' != "" {
		local linebreaks = real(`"`lb'"')
	}
	
	mata: docx_paragraph_add_text_wrk(`"`font'"', `"`script'"', 	///
				`"`shading'"', `"`bold'"', 		///
				`"`italic'"', `"`underline'"',		///
				`"`strikeout'"', `linebreaks',	///
				`"`nformat'"', `"`smallcaps'"', 	///
				`"`allcaps'"', `"`trim'"', 	///
				`"`hyperlink'"')
end

program docx_table
	syntax [anything(equalok)] [if] [in] [, *]
	
	mata: docx_is_valid()
	
	local tblinfo `0'
	if strpos(`"`tblinfo'"', "=") == 0 {
		local tblinfo `"`anything'"'
		docx_table_set `tblinfo', `options'
	}
	else {
		local tblinfo `"`anything'"'
		gettoken tblspec : 0, parse("= ")
		if strpos(`"`tblspec'"', "(") == 0 {
			docx_add_table `0'
		}
		else {
			docx_table_set `tblinfo', `options'
		}
	}
end

program docx_add_table
	syntax [anything(equalok)] [if] [in] [, *]
		
	if `"`anything'"' == "" {
		di as err "table specification required"
		exit 198
	}
	
	local tblspec `anything'
	if strpos(`"`tblspec'"', "=") != 0 {
		local 0 `"`tblspec'"'
		gettoken tblnm 0 : 0, parse(" =")
		if "`tblnm'" == "" {
			di as err "syntax error"
			exit 198
		}
		gettoken eqsign 0 : 0, parse(" =")
		local tblexp `0'
		if `"`eqsign'"' != "=" | `"`tblexp'"' == "" {
			di as err "syntax error"
			exit 198
		}
		
		capture confirm names `tblnm'
		if _rc {
			di as err "invalid table name"
			exit 198
		}
	}
	else {
		di as err "invalid table specification"
		exit 198
	}

	if strpos(`"`tblexp'"', "matrix(") != 0 |			///
		strpos(`"`tblexp'"', "matri(") != 0 |			///
		strpos(`"`tblexp'"', "matr(") != 0 |			///
		strpos(`"`tblexp'"', "mat(") != 0 {
		if `"`if'"' != "" {
			di as err "if not allowed"
			exit 101
		}
		if `"`in'"' != "" {
			di as err "in range not allowed"
			exit 101
		}
		local 0 `anything', `options'
		_docx_add_table_matrix `0'
	}
	else if strpos(`"`tblexp'"', "data(") != 0 {
		local 0 `anything' `if' `in', `options'
		_docx_add_table_data `0'
	}
	else if strpos(`"`tblexp'"', "mata(") != 0 {
		if `"`if'"' != "" {
			di as err "if not allowed"
			exit 101
		}
		if `"`in'"' != "" {
			di as err "in range not allowed"
			exit 101
		}
		local 0 `anything', `options'
		_docx_add_table_mata `0'
	}
	else if strpos(`"`tblexp'"', "etable") != 0 | 			///
		strpos(`"`tblexp'"', "etable(") != 0 {
		if `"`if'"' != "" {
			di as err "if not allowed"
			exit 101
		}
		if `"`in'"' != "" {
			di as err "in range not allowed"
			exit 101
		}
		local 0 `anything', `options'
		_docx_add_table_etable `0'		
	}
	else {
		if `"`if'"' != "" {
			di as err "if not allowed"
			exit 101
		}
		if `"`in'"' != "" {
			di as err "in range not allowed"
			exit 101
		}
		local 0 `anything', `options'
		_docx_add_table_other `0'
	}
end

program _docx_add_table_matrix
	syntax [anything(equalok)] [, MEMtable width(string) 		///
		HEADERRow(real 0) halign(string) indent(string) 	///
		CELLSPacing(string) layout(string) NFORmat(string) 	///
		rownames colnames title(string) toheader(string)    ///
		tofooter(string) *]
	
	local cellmargins
	local borders
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	while !missing(`"`border'`cellmargin'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`cellmargin'"') {
			local cellmargins `cellmargins' `cellmargin'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	local tblspec `anything'
	local sp = strpos(`"`tblspec'"', "=")
	local sb = strtrim(substr(`"`tblspec'"', 1, `sp'))
	local ++sp
	local sf = strtrim(substr(`"`tblspec'"', `sp', .))
	
	if bsubstr(strtrim(`"`sf'"'), -1, .)!= ")" {
		di as err "invalid syntax"
		exit 198		
	}
	
	local sp = strpos(`"`sf'"', "(")
	local sp1 = `sp' + 1
	local sm = strtrim(substr(`"`sf'"', `sp1', bstrlen(`"`sf'"')-`sp1'))
	local sf = strtrim(substr(`"`sf'"', 1, `sp'))
	if `"`sm'"' == "" {
		di as err "invalid specification in {bf:matrix()}"
		exit 198
	}

	local tblspec `sb'`sf'`sm' 
	if `"`nformat'"' != "" {
		local tblspec "`tblspec',`nformat'"
	}
	else {
		local tblspec "`tblspec',%12.0g"
	}
	
	if `"`rownames'"' != "" {
		local tblspec "`tblspec',1"
	}
	else {
		local tblspec "`tblspec',0"
	}
	if `"`colnames'"' != "" {
		local tblspec "`tblspec',1"
	}
	else {
		local tblspec "`tblspec',0"
	}
	local tblspec "`tblspec')"
	
	local addloc -1
	local hfname ""
	if !missing(`"`memtable'"') {
		local addloc 0
	}
	if !missing(`"`toheader'"') {
		if `addloc' == -1 {
			local hfname `"`toheader'"'
			local addloc 2
        }
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if !missing(`"`tofooter'"') {
		if `addloc' == -1 {
			local hfname `"`tofooter'"'
			local addloc 3
		}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if `addloc' == -1 {
		local addloc 1
	}
    if `addloc' == 2 | `addloc' == 3 {
        mata: docx_validate_header_footer(`addloc', `"`hfname'"')
    }
	
	mata: docx_add_table_wrk(`"`tblspec'"',	`"`addloc'"',		/// 
			`"`width'"', `headerrow', `"`halign'"',		///
			`"`indent'"', `"`borders'"', `"`cellmargins'"', ///
			`"`cellspacing'"', `"`layout'"', "", "",	///
			`"`title'"', `"`notes'"', `"`hfname'"')
end

program _docx_add_table_data
	syntax [anything(equalok)] [if] [in] [, MEMtable width(string) 	///
		HEADERRow(real 0) halign(string) indent(string) 	///
		CELLSPacing(string) layout(string) varnames obsno 	///
		title(string) toheader(string) tofooter(string) *]

	local cellmargins
	local borders
	local notes
	
	local myif `if'
	local myin `in'
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	while !missing(`"`border'`cellmargin'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`cellmargin'"') {
			local cellmargins `cellmargins' `cellmargin'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	local tblspec `anything'
	local sp = strpos(`"`tblspec'"', "=")
	local sb = strtrim(substr(`"`tblspec'"', 1, `sp'))
	local ++sp
	local sf = strtrim(substr(`"`tblspec'"', `sp', .))
	
	if substr(`"`sf'"', 5, 1) != "(" | substr(`"`sf'"', -1, 1) != ")" {
		di as err "invalid syntax"
		exit 198
	}
	local sm = strtrim(substr(`"`sf'"', 6, bstrlen(`"`sf'"')-6))
	local sf = strtrim(substr(`"`sf'"', 1, 5))
	if `"`sm'"' == "" {
		di as err "invalid specification in {bf:data()}"
		exit 198
	}
	
	tempname tmpvars
	capture matrix define `tmpvars' = `sm'
	local tmpvars `sm' 
	if _rc {
		unab sm : `tmpvars'
	}
	
	local tblspec `sb'`sf'`sm'
	local tblspec "`tblspec',."
	
	if `"`varnames'"' != "" {
		local tblspec "`tblspec',1"
	}
	else {
		local tblspec "`tblspec',0"
	}
	if `"`obsno'"' != "" {
		local tblspec "`tblspec',1"
	}
	else {
		local tblspec "`tblspec',0"
	}
	local tblspec "`tblspec')"
	
	local addloc -1
	local hfname ""
	if !missing(`"`memtable'"') {
		local addloc 0
	}
	if !missing(`"`toheader'"') {
		if `addloc' == -1 {
			local hfname `"`toheader'"'
			local addloc 2
			}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if !missing(`"`tofooter'"') {
		if `addloc' == -1 {
			local hfname `"`tofooter'"'
			local addloc 3
		}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if `addloc' == -1 {
		local addloc 1
	}
    if `addloc' == 2 | `addloc' == 3 {
        mata: docx_validate_header_footer(`addloc', `"`hfname'"')
    }
	
	mata: docx_add_table_wrk(`"`tblspec'"',	`"`addloc'"',		/// 
			`"`width'"', `headerrow', `"`halign'"', 	///
			`"`indent'"', `"`borders'"', `"`cellmargins'"', ///
			`"`cellspacing'"', `"`layout'"', `"`myif'"', 	///
			`"`myin'"', `"`title'"', `"`notes'"', `"`hfname'"')
end

program _docx_add_table_mata
	syntax [anything(equalok)] [, MEMtable width(string) 		///
		HEADERRow(real 0) halign(string) indent(string) 	///
		CELLSPacing(string) layout(string) NFORmat(string) 	///
		title(string) toheader(string) tofooter(string) *]
	
	local cellmargins
	local borders
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	while !missing(`"`border'`cellmargin'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`cellmargin'"') {
			local cellmargins `cellmargins' `cellmargin'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	local tblspec `anything'
	local sp = strpos(`"`tblspec'"', "=")
	local sb = strtrim(substr(`"`tblspec'"', 1, `sp'))
	local ++sp
	local sf = strtrim(substr(`"`tblspec'"', `sp', .))
	
	if substr(`"`sf'"', 5, 1) != "(" | substr(`"`sf'"', -1, 1) != ")" {
		di as err "invalid syntax"
		exit 198
	}
	local sm = strtrim(substr(`"`sf'"', 6, bstrlen(`"`sf'"')-6))
	local sf = strtrim(substr(`"`sf'"', 1, 5))
	if `"`sm'"' == "" {
		di as err "invalid specification in {bf:mata()}"
		exit 198
	}
	
	local tblspec `sb'`sf'`sm' 
	if `"`nformat'"' != "" {
		local tblspec "`tblspec',`nformat'"
	}
	else {
		local tblspec "`tblspec',%12.0g"
	}
	local tblspec "`tblspec')"

	local addloc -1
	local hfname ""
	if !missing(`"`memtable'"') {
		local addloc 0
	}
	if !missing(`"`toheader'"') {
		if `addloc' == -1 {
			local hfname `"`toheader'"'
			local addloc 2
			}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if !missing(`"`tofooter'"') {
		if `addloc' == -1 {
			local hfname `"`tofooter'"'
			local addloc 3
		}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if `addloc' == -1 {
		local addloc 1
	}
    if `addloc' == 2 | `addloc' == 3 {
        mata: docx_validate_header_footer(`addloc', `"`hfname'"')
    }
	
	mata: docx_add_table_wrk(`"`tblspec'"',	`"`addloc'"',		/// 
			`"`width'"', `headerrow', `"`halign'"', 	///
			`"`indent'"', `"`borders'"', `"`cellmargins'"', ///
			`"`cellspacing'"', `"`layout'"', "", "", 	///
			`"`title'"', `"`notes'"', `"`hfname'"')
end

program _docx_add_table_etable
	syntax [anything(equalok)]  [, MEMtable width(string) 		///
		HEADERRow(real 0) halign(string) indent(string) 	///
		CELLSPacing(string) layout(string) title(string)    ///
		toheader(string) tofooter(string) *]
	
	local cellmargins
	local borders
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	while !missing(`"`border'`cellmargin'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`cellmargin'"') {
			local cellmargins `cellmargins' `cellmargin'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	local tblspec `anything'
	local sp = strpos(`"`tblspec'"', "=")
	local sb = strtrim(substr(`"`tblspec'"', 1, `sp'))
	local ++sp
	local sf = strtrim(substr(`"`tblspec'"', `sp', .))
	
	if strpos(`"`sf'"', "(") | strpos(`"`sf'"', ")") {
		if substr(`"`sf'"', 7, 1) != "(" & substr(`"`sf'"', -1, 1) != ")" {
			di as err "invalid specification in {bf:etable()}"
			exit 198
		}
		local sm = strtrim(substr(`"`sf'"', 8, bstrlen(`"`sf'"')-8))
		if `"`sm'"' == "" {
			di as err "invalid specification in {bf:etable()}"
			exit 198
		}
		
		tokenize "`sm'", parse(" ,")
		local tidx
		local i 0
		while "`1'" != "" {
			if "`1'" != "," {
				confirm integer number `1'
				if real(`"`1'"') <= 0 {
					di as err "'`1'' found where positive integer expected"
					exit 7
				}
				if `i'==0 {
					local tidx `1'
				}
				else {
					local tidx "`tidx' `1'"
				}
				local ++i
			}
			mac shift
		}
		
		local sm `tidx'
		local sf = strtrim(substr(`"`sf'"', 1, 7))
		local tblspec `sb'`sf'`sm'
	}
	else {
		if strtrim(`"`sf'"')!="etable" {
			di as err "invalid syntax"
			exit 198
		}
		local sm -1
		local sf = strtrim(substr(`"`sf'"', 1, 6)) + "("
		local tblspec `sb'`sf'`sm' 
	}
	local tblspec "`tblspec')"
	
	local addloc -1
	local hfname ""
	if !missing(`"`memtable'"') {
		local addloc 0
	}
	if !missing(`"`toheader'"') {
		if `addloc' == -1 {
			local hfname `"`toheader'"'
			local addloc 2
			}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if !missing(`"`tofooter'"') {
		if `addloc' == -1 {
			local hfname `"`tofooter'"'
			local addloc 3
		}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if `addloc' == -1 {
		local addloc 1
	}
    if `addloc' == 2 | `addloc' == 3 {
        mata: docx_validate_header_footer(`addloc', `"`hfname'"')
    }
	
	mata: docx_add_table_wrk(`"`tblspec'"',	`"`addloc'"',		/// 
			`"`width'"', `headerrow', `"`halign'"', 	///
			`"`indent'"', `"`borders'"', `"`cellmargins'"', ///
			`"`cellspacing'"', `"`layout'"', "", "",	///
			`"`title'"', `"`notes'"', `"`hfname'"')
end

program _docx_add_table_other
	syntax [anything(equalok)] [, MEMtable width(string) 		///
		HEADERRow(real 0) halign(string) indent(string) 	///
		CELLSPacing(string) layout(string) title(string)    ///
		toheader(string) tofooter(string) *]
	
	local cellmargins
	local borders
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	while !missing(`"`border'`cellmargin'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`cellmargin'"') {
			local cellmargins `cellmargins' `cellmargin'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) CELLMARgin(passthru) note(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	local tblspec `anything'

	local addloc -1
	local hfname ""
	if !missing(`"`memtable'"') {
		local addloc 0
	}
	if !missing(`"`toheader'"') {
		if `addloc' == -1 {
			local hfname `"`toheader'"'
			local addloc 2
			}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if !missing(`"`tofooter'"') {
		if `addloc' == -1 {
			local hfname `"`tofooter'"'
			local addloc 3
		}
		else {
			di as err "only one of {bf:memtable}, {bf:toheader()}, or {bf:tofooter()} is allowed"
			exit 198
		}
	}
	if `addloc' == -1 {
		local addloc 1
	}

	if `addloc' == 2 | `addloc' == 3 {
		mata: docx_validate_header_footer(`addloc', `"`hfname'"')
	}

	mata: docx_add_table_wrk(`"`tblspec'"',	`"`addloc'"',		/// 
			`"`width'"', `headerrow', `"`halign'"', 	///
			`"`indent'"', `"`borders'"', `"`cellmargins'"', ///
			`"`cellspacing'"', `"`layout'"', "", "", 	///
			`"`title'"', `"`notes'"', `"`hfname'"')
end

program docx_table_set
	syntax [anything(equalok)] [, *]

	mata: docx_is_valid()
	
	if `"`anything'"' == "" {
		di as err "table or cell specification required"
		exit 198
	}

	local tblinfo `0'
	if strpos(`"`tblinfo'"', "=") == 0 {
		local tblinfo `"`anything'"'
		
		local 0 `"`tblinfo'"'
		gettoken tblnm 0 : 0
		
		if (strpos(`"`tblnm'"', "(") == 0) {
			di as err "syntax error"
			exit 198
		}
		
		local tblnm = substr(`"`tblinfo'"', 1, 		///
			strpos(`"`tblnm'"', "(")-1)
		if (strlen(`"`tblnm'"')!=strlen(strtrim(`"`tblnm'"'))) {
			di as err "syntax error"
			exit 198				
		}
		if (substr(strtrim(`"`tblinfo'"'), 		///
			strlen(strtrim(`"`tblinfo'"')), 1)!=")") {
			di as err "syntax error"
			exit 198				
		}
		
		mata: docx_table_parse_cell("docx_tname", 	/// 
			"docx_tid", "docx_trow", "docx_tcol", 	///
			"docx_trows", "docx_tcols", `"`tblinfo'"')
		
		if `"`docx_trow'"' == "" {
		di as err "invalid specification; row misspecified"
			exit 198
		}
		if `"`docx_tcol'"' == "" {
		di as err "invalid specification; column misspecified"
			exit 198
		}
		
		if `"`docx_trow'"' != "." & 			///
			`"`docx_tcol'"' != "." {
			local options `options' stocell
			_docx_table_set_cell `tblinfo', `options'
		}
		else if `"`docx_trow'"' != "." & 		///
			`"`docx_tcol'"' == "." {
			local tblinfo "`docx_tid'_`docx_trow'_`docx_tname'"
			_docx_table_set_row `tblinfo', `options'
		}
		else if `"`docx_trow'"' == "." & 		///
			`"`docx_tcol'"' != "." {
			local tblinfo "`docx_tid'_`docx_tcol'_`docx_tname'"
			_docx_table_set_col `tblinfo', `options'
		}
		else {
			local options `options' 		///
				rrange(`"`docx_trows'"')	///
				crange(`"`docx_tcols'"')
			_docx_table_set_cell_range `tblinfo', `options'
		}
	}
	else {
		local tblinfo `"`anything'"'
		_docx_table_set_cell `tblinfo', `options'
	}
end

program _docx_table_set_cell
	syntax anything(name=cellexplist id=cellexplist equalok) [,	///
				font(string) halign(string)		///
				valign(string) SHADing(string)		///
				bold italic UNDERLine(string)  		///
				UNDERLine1 STRIKEout script(string)	///
				rowspan(real 1)	colspan(real 1) 	///
				span(string) append width(string) 	///
				height(string) link stocell 		///
				NFORmat(string) linebreak(string)	///
				SMALLCaps ALLCaps	///
				trim	///
				HYPERLink(string)	///
				totalpages	///
				pagenumber *]
				
	
	if (`"`rowspan'"' != "1" & `"`span'"' != "") {
		opts_exclusive "rowspan() span()"
		exit 198
	}
	if (`"`colspan'"' != "1" & `"`span'"' != "") {
		opts_exclusive "colspan() span()"
		exit 198
	}
	
	if `"`underline'"' != "" & `"`underline1'"' != "" {
di as err "only one of {bf:underline} or {bf:underline()} is allowed"
		exit 198
	}
	
	if `"`underline1'"' != "" {
		local underline "single"
	}
	
	if `"`smallcaps'"' != "" & `"`allcaps'"' != "" {
di as err "only one of {bf:smallcaps} or {bf:allcaps} is allowed"
		exit 198
	}
	
	local lb `linebreak'
	if `"`lb'"' != "" {
		capture confirm integer number `lb'
		if _rc {
di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
		
		if real(`"`lb'"') < 1 {
di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
	}

	local borders
	local linebreaks 0
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) linebreak *]
	while !missing(`"`border'`linebreak'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`linebreak'"') {
			local ++linebreaks
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) linebreak *]
	}

	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	if `linebreaks' > 0 & `"`lb'"' != "" {
di as err "only one of {bf:linebreak} and {bf:linebreak()} is allowed"
		exit 198
	}
	
	if `"`lb'"' != "" {
		local linebreaks = real(`"`lb'"')
	}

	local ckimg = 0
	local cexp `cellexplist' 
	if strpos(`"`cexp'"', "=") == 0 {
		local ckimg = 1
	}
	else {
		local imgpos = strpos(`"`cexp'"', "=") + 1
		local bpos = `imgpos' - 1
		local imgbf = substr(`"`cexp'"', 1, `bpos')
		local imgspec = strtrim(substr(`"`cexp'"', `imgpos', .))
		local imglen = bstrlen(`"`imgspec'"')
		if substr(`"`imgspec'"', `imglen', 1) != ")" {
			di as err "syntax error"
			exit 198
		}
		if substr(`"`imgspec'"', 1, 1) == "(" {
			local ckimg = 1
		}
		else if substr(`"`imgspec'"', 1, 5) == "table" & 	///
			substr(`"`imgspec'"', 6, 1) == "(" {
			local ckimg = 1
		}
		else if substr(`"`imgspec'"', 1, 5) == "image" & 	///
			substr(`"`imgspec'"', 6, 1) == "(" {
			if strpos(`"`imgspec'"', ",") != 0 {
				di as err "syntax error"
				exit 198
			}
			else {
				local imglen = `imglen' - 1
				local imgtmp = substr(`"`imgspec'"', 1, `imglen')
				local imgstr `imgbf'`imgtmp'
				if `"`width'"' != "" {
					local imgstr "`imgstr',`width'"
				}
				else {
					local imgstr "`imgstr',0"
				}
				if `"`height'"' != "" {
					local imgstr "`imgstr',`height'"
				}
				else {
					local imgstr "`imgstr',0"
				}
				if `"`link'"' != "" {
					local imgstr "`imgstr',1"
				}
				else {
					local imgstr "`imgstr',0"
				}
				local imgstr "`imgstr')"
				local cellexplist `imgstr'
			}
		}
		else {
			di as err "syntax error"
			exit 198
		}
	}
	
	if `ckimg' == 1 {
		if `"`width'"' != "" {
			di as err "invalid option " `"{bf:width()}"'"
			exit 198
		}
		if `"`height'"' != "" {
			di as err "invalid option " `"{bf:height()}"'"
			exit 198
		}
		if `"`link'"' != "" {
			di as err "invalid option " `"{bf:link}"'"
			exit 198
		}
	}

	if ("`pagenumber'" != "") & ("`totalpages'" != "") {
di as err "only one of {bf:pagenumber} and {bf:totalpages} is allowed"
		exit 198	
	}
	
	local pagenum = 0
	if "`pagenumber'" != "" {
		local pagenum = 1
	}

	local totalp = 0
	if "`totalpages'" != "" {
		local totalp = 1
	}
	
	mata: docx_table_set_cell_wrk(`"`font'"', `"`halign'"', 	///
				      `"`valign'"', `"`shading'"', 	///
				      `"`borders'"', 			///
				      `"`bold'"', `"`italic'"',		///
				      `"`underline'"', `"`strikeout'"', ///
				      `"`script'"', `rowspan', 	///
				      `colspan', `"`span'"', 		///
				      `"`append'"', `"`stocell'"', 	///
				      `"`nformat'"', `linebreaks', 	///
				      `"`smallcaps'"', `"`allcaps'"', 	///
				      `"`trim'"', `"`hyperlink'"',	/// 
				      `totalp', `pagenum')
end

program _docx_table_set_row
	syntax anything [, NOSPlit addrows(string) drop			///
				font(string) halign(string)		///
				valign(string) SHADing(string) 		///
				bold italic 				///
				UNDERLine(string) UNDERLine1 STRIKEout 	///
				NFORmat(string) SMALLCaps ALLCaps *]
	
	if (`"`nosplit'"' != "" & `"`drop'"' != "") {
		opts_exclusive "nosplit drop"
		exit 198
	}
	
	if (`"`addrows'"' != "" & `"`drop'"' != "") {
		opts_exclusive "addrows() drop"
		exit 198
	}
	
	if `"`underline'"' != "" & `"`underline1'"' != "" {
di as err "only one of {bf:underline} or {bf:underline()} is allowed"
		exit 198
	}
	
	if `"`underline1'"' != "" {
		local underline "single"
	}
	
	if `"`smallcaps'"' != "" & `"`allcaps'"' != "" {
di as err "only one of {bf:smallcaps} or {bf:allcaps} is allowed"
		exit 198
	}
	
	local borders
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) *]
	while !missing(`"`border'"') {
		local borders `borders' `border'
		local 0 , `options' 
		syntax , [BORDer(passthru) *]
	}
	
	if `"`options'"' != "" {
di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	mata: docx_table_set_row_wrk(`"`anything'"', `"`nosplit'"',	///
				      `"`addrows'"', `"`drop'"',	///
					`"`font'"',			///
					`"`halign'"', `"`valign'"', 	///
					`"`shading'"', `"`borders'"',	///
					`"`bold'"', `"`italic'"',	///
					`"`underline'"', `"`strikeout'"', ///
					`"`nformat'"', `"`smallcaps'"', ///
					`"`allcaps'"')
end

program _docx_table_set_col
	syntax anything [, addcols(string) drop 			///
				font(string) halign(string)		///
				valign(string) SHADing(string) 		///
				bold italic 				///
				UNDERLine(string) UNDERLine1 STRIKEout 	///
				NFORmat(string) SMALLCaps ALLCaps *]
	
	if (`"`addcols'"' != "" & `"`drop'"' != "") {
		opts_exclusive "addcols() drop"
		exit 198
	}
	
	if `"`underline'"' != "" & `"`underline1'"' != "" {
di as err "only one of {bf:underline} or {bf:underline()} is allowed"
		exit 198
	}
	
	if `"`underline1'"' != "" {
		local underline "single"
	}
	
	if `"`smallcaps'"' != "" & `"`allcaps'"' != "" {
di as err "only one of {bf:smallcaps} or {bf:allcaps} is allowed"
		exit 198
	}
	
	local borders
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) *]
	while !missing(`"`border'"') {
		local borders `borders' `border'
		local 0 , `options' 
		syntax , [BORDer(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	mata: docx_table_set_column_wrk(`"`anything'"', `"`addcols'"', 	///
					`"`drop'"', `"`font'"',		///
					`"`halign'"', `"`valign'"', 	///
					`"`shading'"', `"`borders'"',	///
					`"`bold'"', `"`italic'"',	///
					`"`underline'"', `"`strikeout'"', ///
					`"`nformat'"', `"`smallcaps'"', ///
					`"`allcaps'"')
end

program _docx_table_set_cell_range
	syntax anything [, font(string) halign(string)			///
				valign(string) SHADing(string) 		///
				bold italic 				///
				UNDERLine(string) UNDERLine1 STRIKEout 	///
				NFORmat(string) rrange(string)		///
				crange(string) SMALLCaps ALLCaps *]
	
	if `"`underline'"' != "" & `"`underline1'"' != "" {
di as err "only one of {bf:underline} or {bf:underline()} is allowed"
		exit 198
	}
	
	if `"`underline1'"' != "" {
		local underline "single"
	}
	
	if `"`smallcaps'"' != "" & `"`allcaps'"' != "" {
di as err "only one of {bf:smallcaps} or {bf:allcaps} is allowed"
		exit 198
	}
	
	local borders
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) *]
	while !missing(`"`border'"') {
		local borders `borders' `border'
		local 0 , `options' 
		syntax , [BORDer(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}

	mata: docx_table_set_cell_range_wrk(`"`anything'"', `"`rrange'"', ///
					`"`crange'"', `"`font'"',	///
					`"`halign'"', `"`valign'"', 	///
					`"`shading'"', `"`borders'"',	///
					`"`bold'"', `"`italic'"',	///
					`"`underline'"', `"`strikeout'"', ///
					`"`nformat'"', `"`smallcaps'"', ///
					`"`allcaps'"')
end

program docx_image
	syntax anything(name=filenm id=file)				///
		[,LINK Width(string) Height(string) linebreak(string) *]

	mata: docx_is_valid()
	
	local lb `linebreak'
	if `"`lb'"' != "" {
		capture confirm integer number `lb'
		if _rc {
	di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
		
		if real(`"`lb'"') < 1 {
	di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
	}
	
	local linebreaks 0
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [linebreak *]
	while !missing(`"`linebreak'"') {
		if !missing(`"`linebreak'"') {
			local ++linebreaks
		}
		local 0 , `options' 
		syntax , [linebreak *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	if `linebreaks' > 0 & `"`lb'"' != "" {
di as err "only one of {bf:linebreak} and {bf:linebreak()} is allowed"
		exit 198
	}
	
	if `"`lb'"' != "" {
		local linebreaks = real(`"`lb'"')
	}
	
	if "`link'" != "" {
		mata: docx_paragraph_add_image_wrk(`"`filenm'"', 	///
					`"`width'"', `"`height'"', 1,	///
					`linebreaks')
	}
	else {
		mata: docx_paragraph_add_image_wrk(`"`filenm'"', 	///
					`"`width'"', `"`height'"', 0,	///
					`linebreaks')
	}
end

program docx_pagebreak
	syntax [anything]
	
	mata: docx_is_valid()
	
	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}

	mata: docx_add_pagebreak_wrk()
end

program docx_sectionbreak
	syntax [anything] [,LANDscape PAGEsize(string) header(string) ///
        footer (string) pagenum(string) *]
		
	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}
	
	mata: docx_is_valid()
	
	local margins
	local 0 `anything', `options'
	local 0 , `options'
	syntax , [margin(passthru) *]
	while !missing(`"`margin'"') {
		if !missing(`"`margin'"') {
			local margins `margins' `margin'
		}
		local 0 , `options' 
		syntax , [margin(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}

	mata: docx_add_sectionbreak_wrk(`"`landscape'"', `"`pagesize'"', `"`margins'"')
	mata: docx_hdr_ftr_wrk(`"`header'"', `"`footer'"')
	if(`"`pagenum'"' != "") {
		mata: docx_set_pgnum(`"`pagenum'"')
	}
end

program docx_pagenumber
    syntax [anything] [,font(string) script(string) SHADing(string)	///
		bold italic UNDERLine(string) UNDERLine1 STRIKEout 	///
		linebreak(string) ALLCaps totalpages *]

	mata: docx_is_valid()
	
	if `"`underline'"' != "" & `"`underline1'"' != "" {
di as err "only one of {bf:underline} or {bf:underline()} is allowed"
		exit 198
	}
	
	if `"`underline1'"' != "" {
		local underline "single"
	}
	
	local lb `linebreak'
	if `"`lb'"' != "" {
		capture confirm integer number `lb'
		if _rc {
di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
		
		if real(`"`lb'"') < 1 {
di as err "option {bf:linebreak()} requires a positive integer"
			exit 198
		}
	}
	
	local linebreaks 0
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [linebreak *]
	while !missing(`"`linebreak'"') {
		if !missing(`"`linebreak'"') {
			local ++linebreaks
		}
		local 0 , `options' 
		syntax , [linebreak *]
	}
	
	if `"`options'"' != "" {
di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	if `linebreaks' > 0 & `"`lb'"' != "" {
di as err "only one of {bf:linebreak} and {bf:linebreak()} is allowed"
		exit 198
	}
	
	if `"`lb'"' != "" {
		local linebreaks = real(`"`lb'"')
	}
	
	mata: docx_pagenumber_wrk(`"`font'"', `"`script'"', 	///
				`"`shading'"', `"`bold'"', 		///
				`"`italic'"', `"`underline'"',		///
				`"`strikeout'"', `linebreaks',	///
				`"`allcaps'"', `"`totalpages'"')
end

program docx_describe, rclass
	syntax [anything]
	
	if `"`anything'"' != "" {
		gettoken tblnm 0 : 0, parse(" ,")
		if `"`0'"' != "" {
			di as err "invalid " `"`0'"'
			exit 198
		}
		
		mata: docx_describe_wrk(`"`tblnm'"', 1)
	}
	else {
		mata: docx_describe_wrk("", 0)
	}
end

program docx_clear
	syntax [anything]

	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}

	mata: docx_clear_wrk()
end

program _docx_check_append, sclass
	syntax [,			///
		headsrc(string)	///
		pagebreak		///
		pgnumrestart	///
	]
	
	if `"`pgnumrestart'"' != "" {
		if `"`pagebreak'"' == "" {
			di as err "option {bf:pgnumrestart} must be specified with option {bf:pagebreak}"
			exit 198
		}
	}
	
	local appendopts headsrc(`headsrc') `pagebreak' `pgnumrestart'
	sret local append `"`appendopts'"'
end

program docx_save
	syntax using / [,replace APPEND(string) APPEND1 nomsg]

	if `"`replace'"' != "" & `"`append'"' != "" {
		opts_exclusive "replace append()"
		exit 198
	}
	
	if `"`replace'"' != "" & `"`append1'"' != "" {
		opts_exclusive "replace append"
		exit 198
	}
	
	if `"`append'"' != "" & `"`append1'"' != "" {
		opts_exclusive "append append()"
		exit 198
	}
	
	if `"`append'"' != "" {
		_docx_check_append, `append'
				
		if strpos(`"`append'"', "pagebreak")!=0 {
			local pagebreak "pagebreak"
		}
		if strpos(`"`append'"', "headsrc")!=0 {
			local hf1 = strpos(`"`append'"', "headsrc")
			local hf2 = strpos(`"`append'"', ")")
			local hfsrc = substr(`"`append'"', `hf1'+8, `hf2'-`hf1'-8)
		}
		if strpos(`"`append'"', "pgnumrestart")!=0 {
			local pgnumrestart "pgnumrestart"
		}		
	}

	local save_mode = ""
	mata: docx_save_wrk(`"`using'"', `"`replace'"', `"`append1'"', `"`pagebreak'"', `"`hfsrc'"', `"`pgnumrestart'"', "save_mode")

	if "`msg'" == "" {
		capture mata:(void)docx_file_get_abspath("`using'", "destfile")
		if _rc == 0 {
			if "`save_mode'" == "" {
				local save_mode = "created"
			}
di in smcl `"successfully `save_mode' {browse "`destfile'":"`destfile'"}"'
		}
	}
end

program docx_append
	syntax anything [,SAVing(string) pagebreak headsrc(string) 	///
		pgnumrestart nomsg]
	
	local filelist `"`anything'"'
	local nfiles: word count `filelist'
	if `nfiles' < 2 {
		di as err "at least two files must be specified"
		exit 198
	}
	
	if `"`pgnumrestart'"' != "" {
		if `"`pagebreak'"' == "" {
			di as err "option {bf:pgnumrestart} must be specified with option {bf:pagebreak}"
			exit 198
		}
	}

	local n 1
	local flist `"`filelist'"'
	local filelist
	while `n' <= `nfiles' {
		local stub: word `n' of `flist'
		if `n' != 1 {
			local filelist `filelist',`stub'
		}
		else {
			local filelist `filelist' `stub'
		}
		local n = `n' + 1
	}
	
	local savefile
	local saveopt
	
	if `"`saving'"' != "" {
		local 0 `saving'
		syntax anything [, REPLACE]
		local savefile `anything'
		local saveopt `replace'
	}

	local dest = ""
	local save_mode = ""
	mata: docx_append_wrk(`"`filelist'"', `"`savefile'"', `"`saveopt'"', `"`pagebreak'"', `"`headsrc'"', `"`pgnumrestart'"', "dest", "save_mode")
	if "`msg'" == "" {
		capture mata:(void)docx_file_get_abspath("`dest'", "destfile")
		if _rc == 0 {
			if "`save_mode'" == "" {
				local save_mode = "appended to"
			}
di in smcl `"successfully `save_mode' {browse "`destfile'":"`destfile'"}"' 
		}
	}

end

program docx_textblock
	syntax [anything] [, NOPARAmode PARAmode NOHARDbreak HARDbreak *]

	mata: docx_is_valid()
	
	local subcmd = strtrim("`anything'")
	local opts = ""

	if "`noparamode'" != "" & "`paramode'" != "" {
di as err "options paramode and noparamode may not be combined"
		exit 198				
	}

	if "`nohardbreak'" != "" & "`hardbreak'" != "" {
di as err "options hardbreak and nohardbreak may not be combined"
		exit 198				
	}
	
	if "`noparamode'" == "noparamode" {
		local opts = "`opts' nonewparafornewlines"
	}
	else if "`paramode'" != "" {
		local opts = "`opts' newparafornewlines"
	} 

	if "`nohardbreak'" == "nohardbreak" {
		local opts = "`opts' nohardbreak"
	}
	else if "`hardbreak'" != "" {
		local opts = "`opts' hardbreak"	
	}
	
	if "`opts'"  != "" {
		local opts = ", `opts'"
	}
	
	if "`subcmd'" == "begin" {
		if "`options'" != "" {
			docx_paragraph, `options'
		}
		else {
			docx_paragraph		
		}
		mata:docx_current_paragraph_valid()
		_putdocx_textblock_add $ST__DOCX_ID `opts'
	}
	else if "`subcmd'" == "append" {
		if "`options'" != "" {
di as err "paragraph options not allowed for subcommand {bf:append}"
			exit 198				
		}
		mata:docx_current_paragraph_valid()
		_putdocx_textblock_add $ST__DOCX_ID `opts'
	}
	else if "`subcmd'" == "end" {
		// do nothing
	}
	else {
		di as err `"unknown subcommand `subcmd'"'
		exit 198		
	}
end

program docx_textfile
	syntax anything [, stopat(string asis) append unsmcl defaultstyle]

	mata: docx_is_valid()
	
        gettoken file opargs : anything
        local srcfile = strtrim("`file'")
        confirm file "`srcfile'"

	if (`"`stopat'"' != "") {
		parse_stopat_opt `stopat'
		local stopat `s(stopat)'
		local stopatops `s(stopatops)'
	}

	if ("`append'" != "" ) {
		mata:docx_current_paragraph_valid()
		mata: (void)_docx_add_textfile(strtoreal(st_global("ST__DOCX_ID")), `"`srcfile'"', 0, `"`stopat'"')
		exit
	}
	
	if ("`defaultstyle'" == "") {	
		putdocx paragraph, font("courier new", 9)
		mata: (void)_docx_add_textfile(strtoreal(st_global("ST__DOCX_ID")), `"`srcfile'"', 0, `"`stopat'"')
	}
	else {
		mata: (void)_docx_add_textfile(strtoreal(st_global("ST__DOCX_ID")), `"`srcfile'"', 1, `"`stopat'"')	
	}
end

program parse_stopat_opt, sclass

    syntax anything(everything)  	///
    [ , 		///
	begin		///
	end		///
	contain		///
	match		///
    ]
    
    gettoken stopstr : anything
    
    local num = 0	
    
    if ("`begin'" != "") {
	local stopstr = `"`stopstr'(.*)"'
	local num = `num'+1
    }

    if ("`end'" != "") {
	local stopstr = `"(.*)`stopstr'"'
	local num = `num'+1
    }

    if ("`match'" != "") {
	local num = `num'+1
    }
    
    if ("`contain'" != "") {
	local stopstr = `"(.*)`stopstr'(.*)"'    
	local num = `num'+1
    }

    if "`num'" == "0" {
	local stopstr = `"(.*)`stopstr'(.*)"'    
    }
    
    if `num' > 1 {
	di as err "only one options of begin, end, or contain can be specified"
	exit 198		    
    }
    sreturn local stopat `"`stopstr'"'
end

program docx_fromhtml
	syntax anything, saving(string) [basedir(string)] 
	
	gettoken file opargs : anything
	
	local savefile
	local saveopt
	
	if `"`saving'"' != "" {
		local 0 `saving'
		syntax anything [, REPLACE]
		local savefile `anything'
		local saveopt `replace'
	}

	mata: docx_fromhtml_wrk(`"`file'"', `"`savefile'"', `"`basedir'"', `"`saveopt'"')
end

program docx_tohtml
	syntax anything, saving(string)
	
	gettoken file opargs : anything
	
	local savefile
	local saveopt
	
	if `"`saving'"' != "" {
		local 0 `saving'
		syntax anything [, REPLACE]
		local savefile `anything'
		local saveopt `replace'
	}

	mata: (void)pathresolve(pwd(), `"`file'"', "srcfile") 	
	confirm file "`srcfile'"
	mata: (void)pathresolve(pwd(), `"`savefile'"', "destfile") 		
	mata: docx_tohtml_wrk(`"`srcfile'"', `"`destfile'"', `"`saveopt'"')
end

program docx_topdf
	syntax anything, saving(string)
	
	gettoken file opargs : anything
	
	local savefile
	local saveopt
	
	if `"`saving'"' != "" {
		local 0 `saving'
		syntax anything [, REPLACE]
		local savefile `anything'
		local saveopt `replace'
	}

	mata: docx_topdf_wrk(`"`file'"', `"`savefile'"', `"`saveopt'"')
end

program docx_totext
	syntax anything, saving(string)
	
	gettoken file opargs : anything
	
	local savefile
	local saveopt
	
	if `"`saving'"' != "" {
		local 0 `saving'
		syntax anything [, REPLACE]
		local savefile `anything'
		local saveopt `replace'
	}

	mata: (void)pathresolve(pwd(), `"`file'"', "srcfile") 	
	confirm file "`srcfile'"
	mata: (void)pathresolve(pwd(), `"`savefile'"', "destfile") 			
	mata: docx_totext_wrk(`"`srcfile'"', `"`destfile'"', `"`saveopt'"')
end

version 16.0

local FTI 	struct font_info scalar
local SHI 	struct shading_info scalar
local IMI 	struct image_info scalar
local II 	struct indent_info scalar
local SPI 	struct spacing_info scalar
local MI 	struct margin_info scalar
local TBI 	struct tbl_border_info scalar
local TCMI 	struct tbl_cellmargin_info scalar
local TCCI 	struct tbl_cell_content_info scalar
local ETI	struct _etable_info scalar
local PGNI  struct page_num_info scalar

local RS	real scalar
local SS	string scalar
local SR	string rowvector
local SC	string colvector
local RR	real rowvector
local RC	real colvector
local TR	transmorphic
local RM	real matrix
local SM	string matrix
local ETIR	struct _etable_info vector

mata:
mata set matastrict on

struct font_info {
	`SS' 		name
	`RS'		size
	`SS'		color
}

struct shading_info {
	`SS'		bgcolor
	`SS'		fgcolor
	`SS'		pattern
}

struct image_info {
	`SS' 		filepath
	`RS'		cx
	`RS'		cy
	`RS' 		link
}

struct indent_info {
	`SS'		type
	`RS'		value
}

struct spacing_info {
	`SS'		type
	`RS'		value
}

struct margin_info {
	`SS'			type
	`RS'			value
}

struct tbl_border_info {
	`SS'		border
	`SS'		style
	`SS'		color
	`RS'		sz
}

struct tbl_cellmargin_info {
	`SS'		name
	`SS'		type
	`RS'		value
}

struct tbl_cell_content_info {
	`RS'		row
	`RS'		col
	`RS'		type
	`SS'		exp
	`SS'		table
	pointer(`IMI')	imi
}

struct page_num_info {
    `SS'        type
    `RS'        start
    `RS'        chapStyle
    `SS'        chapSep
}

`SS' docx_remove_quote(`SS' value)
{
	if (strpos(value, `"""') > 0) {
		value = subinstr(value, `"""', "")
	}
	return(value)
}

`SS' docx_remove_double_quote(`SS' value)
{
	`SS'			tmpstr, s1, s2
	`RS'			slen
	
	tmpstr = docx_remove_paren(value)
	tmpstr = docx_process_options(tmpstr)
	s1 = bsubstr(tmpstr,1,1)
	slen = strlen(tmpstr)
	s2 = bsubstr(tmpstr,slen,1)
	
	if (s1==`"""' & s2==`"""') {
		tmpstr = bsubstr(tmpstr,2,slen-2)
	}
	return(tmpstr)
}

`SS' docx_remove_paren(`SS' value)
{
	`SS'		rev

	value = strtrim(value)
	
	if (bsubstr(value, 1, 1) == "(" & 
		bsubstr(value, bstrlen(value), 1) == ")") {	
		if (bsubstr(value, 1, 1) == "(") {
			value = subinstr(value, "(", "", 1)
		}

		rev = strreverse(value)
		if (bsubstr(rev, 1, 1) == ")") {
			value = strreverse(subinstr(rev, ")", "", 1))
		}
	}
	return(value)
}

`RS' docx_check_paren(`SS' expression)
{
	if (bsubstr(expression, 1, 1) != "(") {
		return(1)
	}
	if (bsubstr(expression, strlen(expression), 1) != ")") {
		return(1)
	}
	return(0)
}

`SS' docx_process_options(`SS' s)
{
	`SR'		opts
	`RS'		i, nopts
	`SS'		sret
	
	opts = tokens(s, ",")
	nopts = cols(opts)
	
	sret = ""
	for(i=1; i<=nopts; i++) {
		if (i==1 && strtrim(opts[i]) == ",") {
			sret = sret + `"""' + `"""' + ", "
		}
		if (i != 1) {
			if (strtrim(opts[i-1]) == "," & strtrim(opts[i]) == ",") {
				sret = sret + `"""' + `"""' + ", "
			}
		}
		if (opts[i] != ",") {
			sret = sret + `"""' + opts[i] + `"""' + ", "
		}
	}
	sret = strtrim(sret)
	sret = bsubstr(sret, 1, bstrlen(sret)-1)
	
	return(sret)
}

void docx_is_valid()
{
	`SS' 		tmpstr
	`RS'		doc_id

	tmpstr = st_global("ST__DOCX_ID")
	if (bstrlen(tmpstr) == 0) {
		errprintf("document not created\n")
		exit(198)
	}
	doc_id = strtoreal(tmpstr)
	if (doc_id < 0) {
		errprintf("document not opened\n")
		exit(198)
	}
}

void docx_update(`RS' type)
{
	`RS'		ntables, nparas
	`SS'		tmpstr
	
	(void) docx_is_valid()
	
	if (type == 1) {
		nparas = strtoreal(st_global("ST__DOCX_NO_PARAGRAPHS"))
		nparas = nparas + 1
		tmpstr = sprintf("%g", nparas)
		st_global("ST__DOCX_NO_PARAGRAPHS", tmpstr)
	}
	else {
		ntables = strtoreal(st_global("ST__DOCX_NO_TABLES"))
		ntables = ntables + 1
		tmpstr = sprintf("%g", ntables)
		st_global("ST__DOCX_NO_TABLES", tmpstr)
	}
}

`RR' docx_get_table_info(`RS' doc_id, `SS' tblname)
{
	`SS'		sret
	`RR'		tinfo
	`SR'		stinfo
	`RS'		tlen
	
	tinfo = J(1,3,.)
	
	sret = _docx_table_get_info(doc_id, tblname)
	if (bstrlen(sret) == 0) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)
	}
	
	stinfo = tokens(sret, "|")
	tlen = cols(stinfo)
	if (tlen != 5) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)
	}
	tinfo[1] = strtoreal(stinfo[1])
	if (missing(tinfo[1])) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)		
	}
	tinfo[2] = strtoreal(stinfo[3])
	if (missing(tinfo[2])) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)		
	}
	tinfo[3] = strtoreal(stinfo[5])
	if (missing(tinfo[3])) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)		
	}
	
	return(tinfo)
}

void docx_parse_font(`SS' s, `FTI' fti, `RS' type)
{
	`TR'		t
	`SS'		tmpstr, token, font, ssize, color
	`RS'		args, size

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	font = ""
	ssize = ""
	color = ""
	size = 0

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			font = docx_remove_quote(token)
		}
		else if (args == 2) {
			ssize = docx_remove_quote(token)
		}
		else if (args == 3) {
			color = docx_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in option {bf:font()}\n")
			if (type==1) {
				(void) docx_close_wrk()
			}
			exit(198)
		}
		args++
	}
	
	font = strtrim(font)
	ssize = strtrim(ssize)
	if (bstrlen(ssize) > 0) {
		size = strtoreal(ssize)
		if (missing(size) | size <= 0) {
	errprintf("invalid font size specified in option {bf:font()}\n")
			if (type==1) {
				(void) docx_close_wrk()
			}
			exit(198)
		}
	}

	color = strtrim(color)
	if (bstrlen(color) > 0) {
		color = put_get_hex_color(color)
		if (color=="") {
	errprintf("invalid font color specified in option {bf:font()}\n")
			if (type==1) {
				(void) docx_close_wrk()
			}
			exit(198)
		}
	}

	fti.name = font
	fti.size = 2*size
	fti.color = color
}

`RS' docx_is_shading_style(`SS' sstyle) 
{
	`RS'		vstyle 

	vstyle = 0
	if (sstyle=="nil" | sstyle=="clear" | sstyle=="solid" |
		sstyle=="horzStripe" | sstyle=="vertStripe" | 
		sstyle=="reverseDiagStripe" | sstyle=="diagStripe" |
		sstyle=="horzCross" | sstyle=="diagCross" | 
		sstyle=="thinHorzStripe" | sstyle=="thinVertStripe" | 
		sstyle=="thinReverseDiagStripe" | sstyle=="thinDiagStripe" | 
		sstyle=="thinHorzCross" | sstyle=="thinDiagCross" |
		sstyle=="pct5" | sstyle=="pct10" | sstyle=="pct12" |
		sstyle=="pct15" | sstyle=="pct20" | sstyle=="pct25" |
		sstyle=="pct30" | sstyle=="pct35" | sstyle=="pct37" |
		sstyle=="pct40" | sstyle=="pct45" | sstyle=="pct50" |
		sstyle=="pct55" | sstyle=="pct60" | sstyle=="pct62" |
		sstyle=="pct65" | sstyle=="pct70" | sstyle=="pct75" |
		sstyle=="pct80" | sstyle=="pct85" | sstyle=="pct87" |
		sstyle=="pct90" | sstyle=="pct95") {
		vstyle = 1
	}
	
	return(vstyle)
}

void docx_parse_shading(`SS' s, `SHI' shi)
{
	`TR'		t
	`SS'		tmpstr, token, bgcolor, fgcolor, pattern
	`RS'		args

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	bgcolor = ""
	fgcolor = ""
	pattern = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			bgcolor = docx_remove_quote(token)
		}
		else if (args == 2) {
			fgcolor = docx_remove_quote(token)
		}
		else if (args == 3) {
			pattern = docx_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in option {bf:shading()}\n")
			exit(198)
		}
		args++
	}

	if (args < 2) {
	errprintf("too few arguments specified in option {bf:shading()}\n")
		exit(198)		
	}

	bgcolor = strtrim(bgcolor)
	if (bstrlen(bgcolor) != 0) {
		bgcolor = put_get_hex_color(bgcolor)
		if (bgcolor=="") {
	errprintf("invalid background color specified in option {bf:shading()}\n")
			exit(198)
		}
	}

	fgcolor = strtrim(fgcolor)
	if (bstrlen(fgcolor) != 0) {
		fgcolor = put_get_hex_color(fgcolor)
		if (fgcolor=="") {
	errprintf("invalid foreground color specified in option {bf:shading()}\n")
			exit(198)
		}
	}
	else {
		fgcolor = "000000"
	}
	
	pattern = strtrim(pattern)
	if (bstrlen(pattern) != 0) {
		if (!docx_is_shading_style(pattern)) {
	errprintf("invalid shading pattern specified in option {bf:shading()}\n")
			exit(198)
		}
	}
	else {
		pattern = "clear"
	}
	
	shi.bgcolor = bgcolor
	shi.fgcolor = fgcolor
	shi.pattern = pattern
}

void docx_parse_indent(`SS' s, `II' ii)
{
	`TR'		t
	`SS'		tmpstr, token, stype, svalue
	`RS'		args, value

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	stype = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t) 
		if (args == 1) {
			stype = docx_remove_quote(token)
		}
		else if (args == 2) {
			svalue = docx_remove_quote(token)
		}
		else if (args > 2) {
	errprintf("too many arguments specified in option {bf:indent()}\n")
			exit(198)
		}
		args++
	}

	if (args < 3) {
	errprintf("too few arguments specified in option {bf:indent()}\n")
		exit(198)
	}

	tmpstr = strtrim(stype)
	if (tmpstr=="para") {
		tmpstr = "firstline"
	}
	if (tmpstr != "left" & tmpstr != "right" & 
		tmpstr != "hanging" & tmpstr != "firstline") {
	errprintf("invalid indent type specified in option {bf:indent()}\n")
		exit(198)
	}

	value = put_get_twips(strtrim(svalue))
	if (value < 0) {
	errprintf("invalid indent value specified in option {bf:indent()}\n")
		exit(198)
	}

	ii.type = tmpstr 
	ii.value = value
}

void docx_parse_spacing(`SS' s, `SPI' spi)
{
	`TR'		t
	`SS'		tmpstr, token, stype, svalue
	`RS'		args, value

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	stype = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			stype = docx_remove_quote(token)
		}
		else if (args == 2) {
			svalue = docx_remove_quote(token)
		}
		else if (args > 2) {
	errprintf("too many arguments specified in option {bf:spacing()}\n")
			exit(198)
		}
		args++
	}

	if (args < 3) {
	errprintf("too few arguments specified in option {bf:spacing()}\n")
		exit(198)
	}

	tmpstr = strtrim(stype)
	if (tmpstr != "line" & tmpstr != "before" &
	    tmpstr != "after") {
	errprintf("invalid spacing type specified in option {bf:spacing()}\n")
		exit(198)
	}
	
	value = put_get_twips(strtrim(svalue))
	if (value < 0) {
	errprintf("invalid spacing value specified in option {bf:spacing()}\n")
		exit(198)
	}

	spi.type = tmpstr 
	spi.value = value
}

void docx_parse_image(`SS' s, `IMI' imi)
{
	`TR'		t
	`SS'		tmpstr, token, filepath, scx, scy, slink, quote, ext
	`RS'		args, cx, cy, link, rc

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	filepath = ""
	slink = ""
	scx = ""
	scy = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			filepath = docx_remove_quote(token)
		}
		else if (args == 2) {
			scx = docx_remove_quote(token)
		}
		else if (args == 3) {
			scy = docx_remove_quote(token)
		}
		else if (args == 4) {
			slink = docx_remove_quote(token)
		}
		else if (args > 4) {
	errprintf("too many arguments specified in option {bf:image()}\n")
			exit(198)
		}
		args++
	}

	filepath = strtrim(filepath)
	if (bstrlen(filepath) == 0) {
		errprintf("image file required\n")
		exit(100)
	}
	
	filepath = docx_remove_quote(filepath)
	ext = pathsuffix(filepath)
	if (ext == "") {
		errprintf("image type not supported\n")
		exit(198)
	}
	else {
		ext = strlower(ext)
		if (ext != ".png" & ext != ".emf" & 
			ext != ".tif" & ext != ".tiff" &
			ext != ".jpg" & ext != ".jpeg") {
			errprintf("image type not supported\n")
			exit(198)
		}
	}
	
	quote = `"""'
	rc = _stata(sprintf("qui confirm file %s%s%s", quote, 
		filepath, quote), 1)
	if (rc) {
		errprintf("file {bf:%s} not found\n", filepath)
		exit(rc)
	}
	
	if (bstrlen(scx) != 0) {
		cx = put_get_twips(strtrim(scx))
		if (cx < 0) {
	errprintf("option {bf:width()} specified incorrectly\n")
			exit(198)
		}
	}
	else {
		cx = 0
	}	

	if (bstrlen(scy) != 0) {
		cy = put_get_twips(strtrim(scy))
		if (cy < 0) {
	errprintf("option {bf:height()} specified incorrectly\n")
			exit(198)
		}
	}
	else {
		cy = 0
	}
	
	if (bstrlen(slink) != 0) {
		link = strtoreal(strtrim(slink))
	}
	else {
		link = 0
	}

	imi.filepath = filepath
	imi.link = link
	imi.cx = cx
	imi.cy = cy
}

`RS' docx_is_border_style(`SS' bstyle) 
{
	`RS'		vstyle 

	vstyle = 0
	if (bstyle=="nil" | bstyle=="single" | 
		bstyle=="thick" | bstyle=="double" | 
		bstyle=="dotted" | bstyle=="dashed" | 
		bstyle=="dotDash" | bstyle=="dotDotDash" | 
		bstyle=="triple" | bstyle=="thinThickSmallGap" | 
		bstyle=="thickThinSmallGap" | bstyle=="thinThickThinSmallGap" | 
		bstyle=="thinThickMediumGap" | bstyle=="thickThinMediumGap" | 
		bstyle=="thinThickThinMediumGap" | bstyle=="thinThickLargeGap" |
		bstyle=="thickThinLargeGap" | bstyle=="thinThickThinLargeGap" | 
		bstyle=="wave" | bstyle=="doubleWave" | 
		bstyle=="dashSmallGap" | bstyle=="dashDotStroked" | 
		bstyle=="threeDEmboss" | bstyle=="threeDEngrave" | 
		bstyle=="inset" | bstyle=="outset") {
		vstyle = 1
	}
	
	return(vstyle)
}

void docx_parse_border(`SS' s, `TBI' tbi, `RS' type)
{
	`TR'		t
	`SS'		tmpstr, token, bname, bstyle, bcolor, bsz
	`SS'		lbname
	`RS'		args, sz
	
	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	bname = ""
	bstyle = ""
	bcolor = ""
	sz = -1

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t) 
		if (args == 1) {
			bname = docx_remove_quote(token)
		}
		else if (args == 2) {
			bstyle = docx_remove_quote(token)
		}
		else if (args == 3) {
			bcolor = docx_remove_quote(token)
		}
		else if (args == 4) {
			bsz = docx_remove_quote(token)
		}
		else if (args > 4) {
	errprintf("too many arguments specified in option {bf:border()}\n")
			exit(198)
		}
		args++
	}

	if (args < 2) {
	errprintf("too few arguments specified in option {bf:border()}\n")
		exit(198)
	}

	lbname = strtrim(bname)
	if (type == 1) {
		if (lbname != "top" & lbname != "bottom" &
		    lbname != "start" & lbname != "end" &
		    lbname != "left" & lbname != "right" &
		    lbname != "insideH" & lbname != "insideV" &
		    lbname != "all") {
	errprintf("invalid border name specified in option {bf:border()}\n")
			exit(198)
		}
	}
	else {
		if (lbname != "top" & lbname != "bottom" &
		    lbname != "start" & lbname != "end" &
		    lbname != "left" & lbname != "right" & 
		    lbname != "all") {
	errprintf("invalid border name specified in option {bf:border()}\n")
			exit(198)
		}
	}
	if (lbname == "left") {
		lbname = "start"
	}
	if (lbname == "right") {
		lbname = "end"
	}
	
	bstyle = strtrim(bstyle)
	if (bstyle == "") {
		bstyle = "single"
	} 
	else {
		if (!docx_is_border_style(bstyle)) {
	errprintf("invalid border pattern specified in option {bf:border()}\n")
			exit(198)
		}
	}

	bcolor = strtrim(bcolor)
	if (bstrlen(bcolor) != 0) {
		bcolor = put_get_hex_color(bcolor)
		if (bcolor=="") {
		errprintf("invalid color specified in option {bf:border()}\n")
			exit(198)
		}
	}
	else {
		bcolor = "000000"
	}
	
	if (bstrlen(bsz) != 0) {
		sz = put_get_twips(strtrim(bsz))
		if (sz <= 0) {
	errprintf("invalid width specified in option {bf:border()}\n")
			exit(198)
		}
	}

	tbi.border = lbname
	tbi.style = bstyle
	tbi.color = bcolor
	tbi.sz = sz/2.5
}

void docx_parse_table_cellmargin(`SS' s, `TCMI' tcmi)
{
	`TR'		t
	`SS'		tmpstr, token, sname, svalue
	`RS'		args, value

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	sname = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			sname = docx_remove_quote(token)
		}
		else if (args == 2) {
			svalue = docx_remove_quote(token)
		}
		else if (args > 2) {
	errprintf("too many arguments specified in option {bf:cellmargin()}\n")
			exit(198)
		}
		args++
	}
	
	if (args < 3) {
	errprintf("too few arguments specified in option {bf:cellmargin()}\n")
		exit(198)
	}
	
	sname = strtrim(sname)
	if (sname != "top" & sname != "bottom" & sname != "left" & 
		sname != "right" & sname != "all") {
errprintf("invalid cell margin name specified in option {bf:cellmargin()}\n")
		exit(198)
	}

	tcmi.type = "dxa"
	value = put_get_twips(strtrim(svalue))
	if (value < 0) {
errprintf("invalid cell margin value specified in option {bf:cellmargin()}\n")
		exit(198)
	}
	if (value == 0) {
		tcmi.type = "nil"
	}

	tcmi.name = sname
	tcmi.value = value
}

string scalar docx_check_filename(`SS' filename, `RS' check_exist)
{
	`SS'		using_file
	`SS'		basename, HoldPWD
	`SS'		file, path, ext
	`RS'		rc
	
	using_file = filename
	basename = pathbasename(using_file)
	
	if (basename == "") {
		errprintf("%s is not a docx file\n", using_file)
		exit(198)
	}
	
	if (bsubstr(using_file, 1, 1) == "~") {
		if (st_global("c(os)") != "Windows") {
			path = ""
			file = ""
			(void) pathsplit(using_file, path, file)
			HoldPWD = pwd()
			rc = _chdir(path)
			if (rc == 0) {
				path = pwd()
			}
			else {
				errprintf("invalid path :%s\n", path)
				exit(170)
			}
			chdir(HoldPWD)
			using_file = path + file
		}
	}
	
	ext = pathsuffix(using_file)
	if (ext == "") {
		using_file = using_file + ".docx"
	}
	else {
		ext = strlower(ext)
		if (ext != ".docx") {
			errprintf("%s is not a docx file\n", using_file)
			exit(198)
		}
	}
	
	if (check_exist) {
		if (!fileexists(using_file)) {
			errprintf("file %s not found\n", using_file)
			exit(601)
		}
	}
	
	return (using_file)
}

void docx_parse_margin(`SS' s, `MI' mi)
{
	`TR'			t
	`SS'			tmpstr, token, stype, svalue
	`RS'			args, value

	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	stype = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			stype = docx_remove_quote(token)
		}
		else if (args == 2) {
			svalue = docx_remove_quote(token)
		}
		else if (args > 2) {
	errprintf("too many arguments specified in option {bf:margin()}\n")
			(void) docx_close_wrk()
			exit(198)
		}
		args++
	}
	
	if (args < 3) {
	errprintf("too few arguments specified in option {bf:margin()}\n")
		(void) docx_close_wrk()
		exit(198)		
	}
	
	stype = strtrim(stype)
	if (stype != "top" & stype != "bottom" & stype != "left" & 
		stype != "right" & stype != "all") {
	errprintf("invalid margin type specified in option {bf:margin()}\n")
		(void) docx_close_wrk()
		exit(198)
	}

	value = put_get_twips(strtrim(svalue))
	if (value < 0) {
	errprintf("invalid margin value specified in option {bf:margin()}\n")
		(void) docx_close_wrk()
		exit(198)
	}

	mi.type = stype
	mi.value = value
}

void docx_set_margin_wrk(`RS' doc_id, `SS' marginstr)
{
	`TR'			t
	`SS'			token, mstr, mtype
	`MI' 			mi
	`RS'			ret
	
	t = tokeninit(" ", "margin", `"()"')
	tokenset(t, marginstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "margin") {
			mstr = tokenpeek(t)
			if (docx_check_paren(mstr)) {
				errprintf("%s must be enclosed in ()\n", mstr)
				(void) docx_close_wrk()
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) docx_parse_margin(token, mi)
				
				mtype = strlower(mi.type)
				ret = _docx_set_margin(doc_id, mtype, mi.value)
				if (ret < 0) {
	                if (ret==-16528) {
        errprintf("invalid margin specification; margin value too big\n")
					}
					else {
						errprintf("failed to set margin\n")
					}
					(void) docx_close_wrk()
					exit(198)
				}
			}
		}
		else {
			errprintf("%s: invalid options\n", token)
			(void) docx_close_wrk()
			exit(198)
		}
	}
}

void docx_set_wrk(`RS' doc_id, `SS' font, `SS' landscape, `SS' pagesize,
				`SS' margins)
{
	`FTI'		fti
	`RS'		ret
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 1)
		if (fti.name != "") {
			ret = _docx_set_font(doc_id, fti.name)
			if (ret < 0) {
				errprintf("failed to set font\n")
				(void) docx_close_wrk()
				exit(198)
			}
		}
		if (fti.size) {
			ret = _docx_set_size(doc_id, fti.size)
			if (ret < 0) {
				errprintf("failed to set font size\n")
				(void) docx_close_wrk()
				exit(198)
			}
		}
		if (fti.color != "") {
			ret = _docx_set_color(doc_id, fti.color)
			if (ret < 0) {
			errprintf("failed to set font color\n")
				(void) docx_close_wrk()
				exit(198)
			}
		}
	}

	if (landscape != "") {
		ret = _docx_set_landscape(doc_id, 1)
		if (ret < 0) {
			errprintf("failed to set orientation\n")
			(void) docx_close_wrk()
			exit(198)
		}
	}
	
	if (pagesize != "") {
		pagesize = strtrim(pagesize)
		if (pagesize != "letter" & pagesize != "legal" &
			pagesize != "A3" & pagesize != "A4" &
			pagesize != "B4JIS") {
errprintf("option {bf:pagesize()} specified incorrectly\n")
			(void) docx_close_wrk()
			exit(198)
		}
		ret = _docx_set_papersize(doc_id, pagesize)
		if (ret < 0) {
			errprintf("failed to set page size\n")
			(void) docx_close_wrk()
			exit(198)
		}
	}
	
	if (margins != "") {
		(void) docx_set_margin_wrk(doc_id, margins)
	}
}

void docx_begin_wrk(`SS' font, `SS' landscape, `SS' pagesize, `SS' margins)
{
	`SS' 		tmpstr
	`RS'		dh

	dh = -1

	tmpstr = st_global("ST__DOCX_ID")
	if (bstrlen(tmpstr) != 0 & strtoreal(tmpstr) != -1) {
		errprintf("document already open in memory\n")
		exit(110)
	}

	dh = _docx_new()
	if (dh < 0) {
		errprintf("failed to create document\n")
		exit(198)
	}
	
	tmpstr = sprintf("%g", dh)
	st_global("ST__DOCX_ID", tmpstr)
	st_global("ST__DOCX_CUR_PARAGRAPH", "0")
	st_global("ST__DOCX_NO_TABLES", "0")
	st_global("ST__DOCX_NO_PARAGRAPHS", "0")
	
	(void) docx_set_wrk(dh, font, landscape, pagesize, margins)
}

void docx_add_pagebreak_wrk()
{
	`RS'		doc_id, ret

	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	ret = _docx_add_pagebreak(doc_id)
	if (ret < 0) {
		errprintf("failed to add pagebreak\n")
		exit(198)
	}
	st_global("ST__DOCX_CUR_PARAGRAPH", "0")
}

void docx_set_section_wrk(`RS' doc_id, `SS' landscape, `SS' pagesize, 
						`SS' margins)
{
	`RS'		ret

	if (landscape != "") {
		ret = _docx_set_landscape(doc_id, 1)
		if (ret < 0) {
			errprintf("failed to set orientation\n")
			(void) docx_close_wrk()
			exit(198)
		}
	}
	else {
		ret = _docx_set_landscape(doc_id, 0)
		if (ret < 0) {
			errprintf("failed to set orientation\n")
			(void) docx_close_wrk()
			exit(198)
		}
	}
	
	if (pagesize != "") {
		pagesize = strtrim(pagesize)
		if (pagesize != "letter" & pagesize != "legal" &
			pagesize != "A3" & pagesize != "A4" &
			pagesize != "B4JIS") {
errprintf("option {bf:pagesize()} specified incorrectly\n")
			(void) docx_close_wrk()
			exit(198)
		}
		ret = _docx_set_papersize(doc_id, pagesize)
		if (ret < 0) {
			errprintf("failed to set page size\n")
			(void) docx_close_wrk()
			exit(198)
		}
	}
	else {
		ret = _docx_set_papersize(doc_id, "letter")
		if (ret < 0) {
			errprintf("failed to set page size\n")
			(void) docx_close_wrk()
			exit(198)
		}
	}

	if (margins != "") {
		(void) docx_set_margin_wrk(doc_id, margins)
	}
}

void docx_add_sectionbreak_wrk(`SS' landscape, `SS' pagesize, `SS' margins)
{
	`RS'		doc_id, ret

	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	ret = _docx_add_sectionbreak(doc_id)
	if (ret < 0) {
		errprintf("failed to add section break\n")
		exit(198)
	}	
	
	(void) docx_set_section_wrk(doc_id, landscape, pagesize, margins)
	st_global("ST__DOCX_CUR_PARAGRAPH", "0")
}

void docx_paragraph_add_image_wrk(`SS' filename, `SS' width, `SS' height, 
			`RS' link, `RS' linebreaks)
{
	`SS'		ext
	`RS'		doc_id, ret, rwidth, rheight, cur_para, i
	
	cur_para = st_global("ST__DOCX_CUR_PARAGRAPH")

	if (strtoreal(cur_para) == 0) {
		errprintf("no active paragraph\n")
		exit(198)
	}
	
	filename = docx_remove_double_quote(filename)
	if (filename=="") {
		errprintf("image file required\n")
		exit(100)		
	}
	
	ext = pathsuffix(filename)
	if (ext == "") {
		errprintf("image type not supported\n")
		exit(198)
	}
	else {
		ext = strlower(ext)
		if (ext != ".png" & ext != ".emf" & 
			ext != ".tif" & ext != ".tiff" &
			ext != ".jpg" & ext != ".jpeg") {
			errprintf("image type not supported\n")
			exit(198)
		}
	}
	
	if (!fileexists(filename)) {
		errprintf("file {bf:%s} not found\n", filename)
		exit(601)
	}

	rwidth = 0
	if (bstrlen(width) != 0) {
		rwidth = put_get_twips(strtrim(width))
		if (rwidth < 0) {
		errprintf("option {bf:width()} specified incorrectly\n")
			exit(198)
		}
	}
	
	rheight = 0
	if (bstrlen(height) != 0) {
		rheight = put_get_twips(strtrim(height))
		if (rheight < 0) {
		errprintf("option {bf:height()} specified incorrectly\n")
			exit(198)
		}
	}
	
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	ret = _docx_image_add(doc_id, filename, link, rwidth, rheight, 0)
	if (ret < 0) {
		errprintf("failed to add image\n")
		exit(198)
	}
	
	if (linebreaks != 0) {
		for(i=1; i<=linebreaks; i++) {
			ret = _docx_paragraph_add_linebreak(doc_id)
			if (ret < 0) {
			errprintf("failed to add linebreak\n")
				exit(198)
			}
		}
	}
}

void docx_paragraph_set_indent_wrk(`RS' doc_id, `SS' indentstr)
{
	`TR'		t
	`SS'		token, indstr
	`II' 		ii
	`RS'		ret
	
	t = tokeninit(" ", "indent", `"()"')
	tokenset(t, indentstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "indent") {
			indstr = tokenpeek(t)
			if (docx_check_paren(indstr)) {
				errprintf("%s must be enclosed in ()\n", indstr)
			}
			else {
				token = tokenget(t)
				token = docx_remove_paren(token)
				(void) docx_parse_indent(token, ii)
				
				if (doc_id >= 0) {
				ret = _docx_paragraph_set_ind(doc_id, 
					ii.type, ii.value)
				if (ret < 0) {
			errprintf("failed to set paragraph indentation\n")
					exit(198)
				}
				}
			}
		}
		else {
			errprintf("%s: invalid options", token)
			exit(198)
		}
	}
}

void docx_paragraph_set_spacing_wrk(`RS' doc_id, `SS' spacingstr)
{
	`TR'		t
	`SS'		token, spstr
	`SPI' 		spi
	`RS'		ret
	
	t = tokeninit(" ", "spacing", `"()"')
	tokenset(t, spacingstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "spacing") {
			spstr = tokenpeek(t)
			if (docx_check_paren(spstr)) {
				errprintf("%s must be enclosed in ()\n", spstr)
			}
			else {
				token = tokenget(t)
				token = docx_remove_paren(token)
				(void) docx_parse_spacing(token, spi)
				
				if (doc_id >= 0) {
				ret = _docx_paragraph_set_spacing(doc_id, 
					spi.type, spi.value)
				if (ret < 0) {
			errprintf("failed to set paragraph spacing\n")
					exit(198)
				}
				}
			}
		}
		else {
			errprintf("%s: invalid options", token)
			exit(198)
		}
	}
}

void docx_paragraph_check_prop(`SS' style, `SS' font, `SS' halign, `SS' valign,
			       `SS' shading, `SS' indents, `SS' spacings)
{
	`FTI'		fti
	`SHI' 		shi
	`SS'		sstyle
	
	if (style != "") {
		sstyle = strtrim(style)
		if (sstyle != "Title" & sstyle != "Subtitle" &
			sstyle != "Heading1" & sstyle != "Heading2" &
			sstyle != "Heading3" & sstyle != "Heading4" &
			sstyle != "Heading5" & sstyle != "Heading6" &
			sstyle != "Heading7" & sstyle != "Heading8" &
			sstyle != "Heading9") {
		errprintf("option {bf:style()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 2)
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		if (halign=="justify" | halign=="justified") {
			halign = "both"
		}
		if (halign != "left" & halign != "right" & 
			halign != "center" & halign != "both" & 
			halign != "distribute") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			exit(198)
		}
	}

	if (valign != "") {
		valign = strtrim(valign)
		if (valign != "auto" & valign != "baseline" & 
			valign != "bottom" & valign != "center" 
			& valign != "top") {
		errprintf("option {bf:valign()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (shading != "") {
		(void) docx_parse_shading(shading, shi)
	}
	
	if (indents != "") {
		(void) docx_paragraph_set_indent_wrk(-1, indents)
	}
	
	if (spacings != "") {
		(void) docx_paragraph_set_spacing_wrk(-1, spacings)
	}
}

void docx_add_paragraph_wrk(`SS' style, `SS' font, `SS' halign, `SS' valign, 
			    `SS' shading, `SS' indents, `SS' spacings, `RS' addloc,
				`SS' hfname)
{
	`RS' 		doc_id, ret
	`SS'		sstyle
	
	(void) docx_paragraph_check_prop(style, font, halign, valign, 
					 shading, indents, spacings)

	doc_id = strtoreal(st_global("ST__DOCX_ID"))

	if (style != "") {
		sstyle = strtrim(style)
		ret = _docx_paragraph_new_styledtext(doc_id, "", sstyle, addloc, hfname)
		if (ret < 0) {
			errprintf("failed to add paragraph\n")
			exit(198)
		}
		ret = _docx_paragraph_add_text(doc_id, "")
		if (ret < 0) {
			errprintf("failed to add paragraph\n")
			exit(198)
		}
	}
	else {
		ret = _docx_paragraph_new(doc_id, "", addloc, hfname)
		if (ret < 0) {
			errprintf("failed to add paragraph\n")
			exit(198)
		}
	}
	st_global("ST__DOCX_CUR_PARAGRAPH", "1")
	(void) docx_update(1)
	
	(void) docx_paragraph_set_wrk(font, halign, valign, shading, 
		indents, spacings)
}

void docx_paragraph_set_wrk(`SS' font, `SS' halign, `SS' valign, 
			    `SS' shading, `SS' indents, `SS' spacings)
{
	`RS' 		doc_id, ret
	`FTI'		fti
	`SHI' 		shi
	`SS'		cur_para

	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	cur_para = st_global("ST__DOCX_CUR_PARAGRAPH")
	if (strtoreal(cur_para) != 1) {
		errprintf("no active paragraph\n")
		exit(198)
	}
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 2)
		if (fti.name != "") {
			ret = _docx_paragraph_set_font(doc_id, fti.name)
			if (ret < 0) {
				errprintf("failed to set paragraph font\n")
				exit(198)
			}
		}
		if (fti.size) {
			ret = _docx_paragraph_set_textsize(doc_id, fti.size)
			if (ret < 0) {
			errprintf("failed to set paragraph font size\n")
				exit(198)
			}
		}
		if (fti.color != "") {
			ret = _docx_paragraph_set_color(doc_id, fti.color)
			if (ret < 0) {
			errprintf("failed to set paragraph font color\n")
				exit(198)
			}
		}
	}

	if (halign != "") {
		halign = strtrim(halign)
		if (halign=="justify" || halign=="justified") {
			halign = "both"
		}
		ret = _docx_paragraph_set_halign(doc_id, halign) 
		if (ret < 0) {
			errprintf("failed to set paragraph alignment\n")
			exit(198)
		}
	}

	if (valign != "") {
		valign = strtrim(valign)
		ret = _docx_paragraph_set_valign(doc_id, valign) 
		if (ret < 0) {
			errprintf("failed to set paragraph alignment\n")
			exit(198)
		}
	}

	if (shading != "") {
		(void) docx_parse_shading(shading, shi)
		ret = _docx_paragraph_set_shading(doc_id, shi.bgcolor,
			shi.fgcolor, shi.pattern)
		if (ret < 0) {
			errprintf("failed to set paragraph shading\n")
			exit(198)
		}
	}

	if (indents != "") {
		(void) docx_paragraph_set_indent_wrk(doc_id, indents)
	}

	if (spacings != "") {
		(void) docx_paragraph_set_spacing_wrk(doc_id, spacings)
	}
}

`RS' docx_is_underline_style(`SS' ustyle) 
{
	`RS'		vstyle 

	vstyle = 0
	if (ustyle=="none" | ustyle=="single" | ustyle=="words" |
		ustyle=="double" | ustyle=="thick" | 
		ustyle=="dotted" | ustyle=="dottedHeavy" |
		ustyle=="dash" | ustyle=="dashedHeavy" | 
		ustyle=="dashLong" | ustyle=="dashLongHeavy" | 
		ustyle=="dotDash" | ustyle=="dashDotHeavy" | 
		ustyle=="dotDotDash" | ustyle=="dashDotDotHeavy" |
		ustyle=="wave" | ustyle=="wavyHeavy" |
		ustyle=="wavyDouble") {
		vstyle = 1
	}
	
	return(vstyle)
}

void docx_paragraph_check_run_prop(`SS' font, `SS' script, `SS' shading,
				   `SS' underline) 
{
	`FTI'		fti
	`SHI'		shi
	`SS'		valign
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 2)
	}

	if (script != "") {
		valign = strtrim(script)
		if (valign!="sub" & valign!="super") {
		errprintf("option {bf:script()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (shading != "") {
		(void) docx_parse_shading(shading, shi)
	}
	
	if (underline != "") {
		underline = strtrim(underline)
		if (!docx_is_underline_style(underline)) {
		errprintf("option {bf:underline()} specified incorrectly\n")
			exit(198)
		}
	}
}

void docx_paragraph_set_run_wrk(`SS' font, `SS' script, `SS' shading, 
				`SS' bold, `SS' italic, `SS' underline,
				`SS' strikeout, `RS' linebreaks, 
				`SS' smallcaps, `SS' allcaps)
{
	`FTI'		fti
	`SHI'		shi
	`SS'		cur_para, valign
	`RS'		doc_id, ret, i
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	cur_para = st_global("ST__DOCX_CUR_PARAGRAPH")

	if (strtoreal(cur_para) == 0) {
		errprintf("no active paragraph\n")
		exit(198)
	}
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 2)
		if (fti.name != "") {
			ret = _docx_text_set_font(doc_id, fti.name)
			if (ret < 0) {
				errprintf("failed to set text font\n")
				exit(198)
			}
		}
		if (fti.size) {
			ret = _docx_text_set_size(doc_id, fti.size)
			if (ret < 0) {
				errprintf("failed to set text font size\n")
				exit(198)
			}
		}
		if (fti.color != "") {
			ret = _docx_text_set_color(doc_id, fti.color)
			if (ret < 0) {
				errprintf("failed to set text font color\n")
				exit(198)
			}
		}
	}

	if (script != "") {
		valign = strtrim(script)
		if (valign == "sub") {
			valign = "subscript"
		}
		else {
			valign = "superscript"
		}
		ret = _docx_text_set_valign(doc_id, valign)
		if (ret < 0) {
			errprintf("failed to set text alignment\n")
			exit(198)
		}
	}

	if (shading != "") {
		(void) docx_parse_shading(shading, shi)
		ret = _docx_text_set_shading(doc_id, shi.bgcolor, 
				shi.fgcolor, shi.pattern)
		if (ret < 0) {
			errprintf("failed to set text shading\n")
			exit(198)
		}
	}

	if (bold != "") {
		ret = _docx_text_set_bold(doc_id, 1)
		if (ret < 0) {
			errprintf("failed to set text to be bold\n")
			exit(198)
		}
	}

	if (italic != "") {
		ret = _docx_text_set_italic(doc_id, 1)
		if (ret < 0) {
			errprintf("failed to set text to be italic\n")
			exit(198)
		}
	}

	if (underline != "") {
		underline = strtrim(underline)
		ret = _docx_text_set_underline(doc_id, underline)
		if (ret < 0) {
			errprintf("failed to underline text\n")
			exit(198)
		}
	}

	if (strikeout != "") {
		ret = _docx_text_set_strikeout(doc_id, 1)
		if (ret < 0) {
			errprintf("failed to strikeout text\n")
			exit(198)
		}
	}
	
	if (linebreaks != 0) {
		for(i=1; i<=linebreaks; i++) {
			ret = _docx_paragraph_add_linebreak(doc_id)
			if (ret < 0) {
				errprintf("failed to add linebreak\n")
				exit(198)
			}
		}
	}
	
	if (smallcaps != "") {
		ret = _docx_text_set_caps(doc_id, "small")
		if (ret < 0) {
			errprintf("failed to set text with small caps\n")
			exit(198)
		}
	}
	
	if (allcaps != "") {
		ret = _docx_text_set_caps(doc_id, "all")
		if (ret < 0) {
			errprintf("failed to set text with all caps\n")
			exit(198)
		}
	}
}

void docx_current_paragraph_valid()
{
	`SS'	cur_para
	cur_para = st_global("ST__DOCX_CUR_PARAGRAPH")

	if (strtoreal(cur_para) == 0) {
		errprintf("no active paragraph\n")
		exit(198)
	}
}

void docx_paragraph_add_text_wrk(`SS' font, `SS' script, `SS' shading, 
				 `SS' bold, `SS' italic, `SS' underline,
				 `SS' strikeout, `RS' linebreaks,
				 `SS' nformat, `SS' smallcaps, 
				 `SS' allcaps, `SS' trim, 
				 `SS' hyperlink)
{
	`SS'		expression, tmpname, tmpstr, cur_para
	`RS'		doc_id, ret, rc	

	expression = st_local("paraexplist")
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	cur_para = st_global("ST__DOCX_CUR_PARAGRAPH")

	if (strtoreal(cur_para) == 0) {
errprintf("no active paragraph\n")
		exit(198)
	}

	if (docx_check_paren(expression)) {
errprintf("expression must be enclosed in ()\n")
		exit(198)
	}

	expression = docx_remove_paren(expression)

	tmpname = st_tempname()
	rc = _stata(sprintf("scalar %s = %s", tmpname, expression))
	if (rc) {
		exit(rc)
	}

	if (st_numscalar(tmpname)==J(0,0,.)) {
		tmpstr = st_strscalar(tmpname)
	}
	else {
		tmpstr = sprintf("%g", st_numscalar(tmpname))
	}
	
	if (nformat != "") {
		nformat = strtrim(nformat)
		if (!st_isnumfmt(nformat)) {
errprintf("option {bf:nformat()} specified incorrectly\n")
			exit(198)
		}
		tmpstr = put_format_value(tmpstr, nformat)
	}
	
	(void) docx_paragraph_check_run_prop(font, script, shading, underline)
	
	if(strlen(trim) != 0) {
		tmpstr = strtrim(tmpstr)
	}
	
	if(strlen(hyperlink)==0) {
		ret = _docx_paragraph_add_text(doc_id, tmpstr)
	}
	else {
		ret = _docx_paragraph_add_hyperlink(doc_id, tmpstr, hyperlink)
	}
	if (ret < 0) {
errprintf("failed to add text to paragraph\n")
		exit(198)
	}
	
	(void) docx_paragraph_set_run_wrk(font, script, shading,
					  bold, italic, underline,
					  strikeout, linebreaks, 
					  smallcaps, allcaps)
}

void docx_pagenumber_wrk(`SS' font, `SS' script, `SS' shading, 
			`SS' bold, `SS' italic, `SS' underline,
			`SS' strikeout, `RS' linebreaks,
			`SS' allcaps, `SS' totalpages)
{
	`SS'	cur_para
	`RS'	doc_id, ret, totpages 

	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	cur_para = st_global("ST__DOCX_CUR_PARAGRAPH")

	if (strtoreal(cur_para) == 0) {
		errprintf("no active paragraph\n")
		exit(198)
	}
	
	if(totalpages != "") {
		totpages = 1
	}
	else {
		totpages = 0
	}
	
	(void) docx_paragraph_check_run_prop(font, script, shading, underline)
	
	ret = _docx_add_pagenumber(doc_id, totpages)
	if (ret < 0) {
errprintf("failed to add page number to paragraph\n")
		exit(198)
	}
	
	(void) docx_paragraph_set_run_wrk(font, script, shading,
		bold, italic, underline,
		strikeout, linebreaks, 
		"", allcaps)
}

void docx_table_set_border_wrk(`RS' doc_id, `RS' tid, `SS' borderstr)
{
	`TR'		t
	`SS'		token, cellbstr
	`TBI' 		tbi
	`RS'		ret
	
	t = tokeninit(" ", "border", `"()"')
	tokenset(t, borderstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "border") {
			cellbstr = tokenpeek(t)
			if (docx_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) docx_parse_border(token, tbi, 1)
				if (doc_id >= 0) {
			ret = _docx_table_set_border(doc_id, tid, tbi.border,
					tbi.style, tbi.color, 0, -1, tbi.sz)
				if (ret < 0) {
					errprintf("failed to set table border\n")
					exit(198)
				}
				}
			}
		}
		else {
			errprintf("%s: invalid options\n", token)
			exit(198)
		}
	}
}

void docx_cell_set_border_wrk(`RS' doc_id, `RS' tid, `RS' row, 
			      `RS' col, `SS' borderstr)
{
	`TR'		t
	`SS'		token, cellbstr
	`TBI' 		tbi
	`RS'		ret
	
	t = tokeninit(" ", "border", `"()"')
	tokenset(t, borderstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "border") {
			cellbstr = tokenpeek(t)
			if (docx_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) docx_parse_border(token, tbi, 2)
				
				if (doc_id >= 0) {
			ret = _docx_cell_set_border(doc_id, tid, row, col, 
					tbi.border, tbi.style, tbi.color, tbi.sz)
				if (ret < 0) {
					errprintf("failed to set cell border\n")
					exit(198)
				}
				}
			}
		}
		else {
			errprintf("%s: invalid options\n", token)
			exit(198)
		}
	}
}

void docx_table_set_cellmargin_wrk(`RS' doc_id, `RS' tid, `SS' cellmarginstr)
{
	`TR'		t
	`SS'		token, cellmstr
	`TCMI' 		tcmi
	`RS'		ret
	
	t = tokeninit(" ", "cellmargin", `"()"')
	tokenset(t, cellmarginstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "cellmargin") {
			cellmstr = tokenpeek(t)
			if (docx_check_paren(cellmstr)) {
				errprintf("%s must be enclosed in ()\n", cellmstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) docx_parse_table_cellmargin(token, tcmi)
				if (doc_id >= 0) {
				ret = _docx_table_set_cellmargin(doc_id, tid, 
					tcmi.name, tcmi.type, tcmi.value)
				if (ret < 0) {
					errprintf("failed to set cell margin\n")
					exit(198)
				}
				}
			}
		}
		else {
			errprintf("%s: invalid options\n", token)
			exit(198)
		}
	}
}

void docx_table_set_attr(`RS' doc_id, `RS' tid, `SS' tblname, 
			 `SS' width, `RS' headerrow,
			 `SS' halign, `SS' indent, `SS' borders, 
			 `SS' cellmargins, `SS' cellspacing, 
			 `SS' layout, `SS' title, `SS' notes) 
{
	`RS'		ret, rwidth, rindent, rcellspacing

	if (width != "") {
		rwidth = put_get_twips(strtrim(width), 1)
		if (strpos(width, "%") > 0) {
	ret = _docx_table_set_width(doc_id, tid, "pct", rwidth)
		}
		else {
	ret = _docx_table_set_width(doc_id, tid, "dxa", rwidth)
		}
		if (ret < 0) {
			errprintf("failed to set table width\n")
			exit(198)
		}
	}

	if (halign != "") {
		halign = strtrim(halign)
		ret = _docx_table_set_alignment(doc_id, tid, halign)
		if (ret < 0) {
			errprintf("failed to set table alignment\n")
			exit(198)
		}
	}

	if (indent != "") {
		rindent = put_get_twips(strtrim(indent))
		ret = _docx_table_set_ind(doc_id, tid, "dxa", rindent)
		if (ret < 0) {
			errprintf("failed to set table indentation\n")
			exit(198)
		}
	}

	if (borders != "") {
		(void) docx_table_set_border_wrk(doc_id, tid, borders)
	}

	if (cellmargins != "") {
		(void) docx_table_set_cellmargin_wrk(doc_id, tid, cellmargins)
	}

	if (cellspacing != "") {
		rcellspacing = put_get_twips(strtrim(cellspacing))
		ret = _docx_table_set_cellspacing(doc_id, tid, "dxa", 
				rcellspacing)
		if (ret < 0) {
			errprintf("failed to set table cell spacing\n")
			exit(198)
		}
	}

	if (layout != "") {
		layout = strtrim(layout)
		if (strpos(layout,"fixed")>0) {
			ret = _docx_table_set_layout(doc_id, tid, "fixed")
			if (ret < 0) {
				errprintf("failed to set table layout\n")
				exit(198)
			}
		}
		else if (strpos(layout,"autofitw")>0) {
			ret = _docx_table_set_layout(doc_id, tid, "autofit")
			if (ret < 0) {
				errprintf("failed to set table layout\n")
				exit(198)
			}
		}
		else if (strpos(layout,"autofitc")>0) {
			ret = _docx_table_set_width(doc_id, tid, "auto", 0)
			if (ret < 0) {
				errprintf("failed to set table layout\n")
				exit(198)
			}			
		}
		else {
		errprintf("option {bf:layout()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if ((title != "") | (notes != "")) {
		(void) docx_table_set_title_note(doc_id, tid, tblname, 
			title, notes)
	}
	
	if (headerrow != 0) {
		(void) docx_table_set_headerrow(doc_id, tid, headerrow)
	}
}

void docx_table_set_note_wrk(`RS' doc_id, `RS' tid, `SS' notestr, 
                             `RS' nrows, `RS' ncols)
{
	`TR'		t
	`SS'		token, cellbstr
	`RS'		j, ret, ncount
	
	ret = 0
	ret = ret + _docx_table_add_row(doc_id, tid, nrows, ncols)
	ret = ret + _docx_cell_set_border(doc_id, tid, nrows+1, 
		1, "start", "nil", "000000")
	ret = ret + _docx_cell_set_border(doc_id, tid, nrows+1, 
		1, "end", "nil", "000000")
	for(j=1; j<=ncols; j++) {
		ret = ret + _docx_cell_set_border(doc_id, tid, 
			nrows+1, j, "bottom", "nil", "000000")
	}
	if (ncols != 1) {
		ret = ret + _docx_cell_set_colspan(doc_id, tid, 
			nrows+1, 1, ncols, 2)
		if (ret < 0) {
			errprintf("failed to add table note\n")
			exit(198)
		}
	}

	t = tokeninit(" ", "note", `"()"')
	tokenset(t, notestr)
			
	ncount = 1
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "note") {
			cellbstr = tokenpeek(t)
			if (docx_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
			}
			else {
				token = tokenget(t)
				token = docx_remove_paren(token)
				token = docx_remove_double_quote(token)
				
				ret = 0
				if (ncount > 1) {
					ret = ret + _docx_cell_add_linebreak(doc_id, tid, nrows+1, 1)
					ret = ret + _docx_table_mod_cell(doc_id, tid, 
						nrows+1, 1, token, 1, 0)
					if (ret < 0) {
						errprintf("failed to add table note\n")
						exit(198)
					}
				}
				else {
					ret = ret + _docx_table_mod_cell(doc_id, tid, 
						nrows+1, 1, token)
					if (ret < 0) {
						errprintf("failed to add table note\n")
						exit(198)
					}
				}
				ncount = ncount + 1
			}
		}
		else {
			errprintf("%s: invalid options", token)
			exit(198)
		}
	}
}

void docx_table_set_title_note(`RS' doc_id, `RS' tid, `SS' tblname, 
			       `SS' title, `SS' notes)
{
	`RR'			tblinfo
	`RS'			nrows, ncols, j, ret, hastitle
	
	if ((title != "") | (notes != "")) {
		tblinfo = docx_get_table_info(doc_id, tblname)
		nrows = tblinfo[2]
		ncols = tblinfo[3]
		hastitle = 0
		if (title != "") {
			ret = 0
			ret = ret + _docx_table_add_row(doc_id, tid, 0, ncols)
			if (ncols != 1) {
				ret = ret + _docx_cell_set_colspan(doc_id, tid, 1, 1, 
					ncols, 2)
			}
			ret = ret + _docx_cell_set_border(doc_id, tid, 1, 1, 
				"start", "nil", "000000")
			ret = ret + _docx_cell_set_border(doc_id, tid, 1, 1, 
				"end", "nil", "000000")
			for(j=1; j<=ncols; j++) {
				ret = ret + _docx_cell_set_border(doc_id, tid, 1, 
					j, "top", "nil", "000000")
			}
			ret = ret + _docx_table_mod_cell(doc_id, tid, 1, 1, title)
			if (ret < 0) {
				errprintf("failed to add table title\n")
				exit(198)
			}
			hastitle = 1
		}
		
		if (notes != "") {
			if (hastitle == 1) {
				nrows = nrows + 1
			}
			(void) docx_table_set_note_wrk(doc_id, tid, notes, nrows, ncols)
		}
	}
}

void docx_table_set_headerrow(`RS' doc_id, `RS' tid, `RS' headerrow)
{
	`RS'			nrows, i, ret
	
	if (headerrow != 0) {
		ret = 0
		nrows = _docx_query_table(doc_id, tid)
		if (headerrow > nrows) {
	errprintf("invalid {bf:headerrow()}; rows out of range\n")
			exit(198)
		}
		
		for(i=1; i<=headerrow; i++) {
			ret = ret + _docx_row_set_header(doc_id, tid, i, 1)
		}
		if (ret < 0) {
			errprintf("failed to set row header\n")
			exit(198)
		}
	}
}

void docx_table_set_cell_attr(`RS' doc_id, `RS' tid, `RS' row, `RS' col,
			      `SS' font, `SS' halign, `SS' valign, 
			      `SS' shading, `SS' borders, `SS' bold, 
			      `SS' italic, `SS' underline, `SS' strikeout, 
			      `SS' script, `RS' rowspan, `RS' colspan, 
			      `SS' span, `RS' tocell, `SS' nformat, 
			      `RS' linebreaks, `SS' smallcaps, `SS' allcaps)
{
	`FTI'		fti
	`SHI' 		shi
	`RS'		ret, span1, span2, i
	`SS'		srowspan, scolspan
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 2)
		if (fti.name != "") {	
			ret = _docx_cell_set_textfont(doc_id, tid, 
					row, col, fti.name, tocell)
			if (ret < 0) {
				if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
					exit(198)
				}
				else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
					exit(198)
				}
				else {
					errprintf("failed to set cell font\n")
					exit(198)
				}
			}
		}
		if (fti.size) {
			ret = _docx_cell_set_textsize(doc_id, tid,
					row, col, fti.size, tocell)
			if (ret < 0) {
				if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
					exit(198)
				}
				else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
					exit(198)
				}
				else {
					errprintf("failed to set cell font size\n")
					exit(198)
				}
			}
		}
		if (fti.color != "") {
			ret = _docx_cell_set_textcolor(doc_id, tid,
					row, col, fti.color, tocell)
			if (ret < 0) {
				if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
					exit(198)
				}
				else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
					exit(198)
				}
				else {
					errprintf("failed to set cell font color\n")
					exit(198)
				}
			}
		}
	}

	if (halign != "") {
		halign = strtrim(halign)
		ret = _docx_cell_set_halign(doc_id, tid,
				row, col, halign)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell alignment\n")
				exit(198)
			}
		}
	}

	if (valign != "") {
		valign = strtrim(valign)
		ret = _docx_cell_set_valign(doc_id, tid, row, 
			col, valign)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell alignment\n")
				exit(198)
			}
		}
	}

	if (shading != "") {
		(void) docx_parse_shading(shading, shi) 
		ret = _docx_cell_set_shading(doc_id, tid, row, col,
				shi.bgcolor, shi.fgcolor, shi.pattern, tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell shading\n")
				exit(198)
			}
		}
	}

	if (borders != "") {
		(void) docx_cell_set_border_wrk(doc_id, tid, row, col, borders)
	}

	if (bold != "") {
		ret = _docx_cell_set_textbold(doc_id, tid, row, col, 1, tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell text to be bold\n")
				exit(198)
			}
		}
	}

	if (italic != "") {
		ret = _docx_cell_set_textitalic(doc_id, tid, row, col, 1, tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell text to be italic\n")
				exit(198)
			}
		}
	}

	if (underline != "") {
		underline = strtrim(underline)
		ret = _docx_cell_set_textunderline(doc_id, tid,
				row, col, underline, tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to underline cell text\n")
				exit(198)
			}
		}
	}

	if (strikeout != "") {
		ret = _docx_cell_set_textstrikeout(doc_id, tid, row, col, 1, tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to strikeout cell text\n")
				exit(198)
			}
		}
	}
	
	if (script != "") {
		script = strtrim(script)
		if (script == "sub") {
			script = "subscript"
		}
		else {
			script = "superscript"
		}
		ret = _docx_cell_set_textvalign(doc_id, tid, row, col, script, tocell)
		if (ret < 0) {
			errprintf("failed to set script style of the text\n")
			exit(198)
		}
	}

	if (rowspan != 1) {
		ret = _docx_cell_set_rowspan(doc_id, tid, row, col, rowspan)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to span row\n")
				exit(198)
			}
		}
	}

	if (colspan != 1) {
		ret =  _docx_cell_set_colspan(doc_id, tid, row, col, colspan, 2)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to span column\n")
				exit(198)
			}
		}
	}
	
	if (span != "") {
		span = strtrim(span)
		srowspan = bsubstr(span, 1, strpos(span, ",")-1)
		span1 = strtoreal(srowspan)

		scolspan = bsubstr(span, strpos(span, ",")+1, .)
		span2 = strtoreal(scolspan)
		
		ret = _docx_cell_set_span(doc_id, tid, row, col, span1, span2)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to span cell\n")
				exit(198)
			}
		}
	}
	
	if (nformat != "") {
		nformat = strtrim(nformat)
		if (tocell) {
			ret = _docx_cell_set_nformat(doc_id, tid, row, col, nformat)
			if (ret < 0) {
				if (ret == -16517) {
			errprintf("invalid cell specification; row out of range\n")
					exit(198)
				}
				else if (ret == -16518) {
			errprintf("invalid cell specification; column out of range\n")
					exit(198)
				}
				else {
					errprintf("failed to format cell value\n")
					exit(198)
				}
			}			
		}
	}
	
	if (linebreaks != 0) {
		for(i=1; i<=linebreaks; i++) {
			ret = _docx_cell_add_linebreak(doc_id, tid, row, col)
			if (ret < 0) {
			errprintf("failed to add linebreak\n")
				exit(198)
			}
		}
	}
	
	if (smallcaps != "") {
		ret = _docx_cell_set_textcaps(doc_id, tid, row, col, "small", tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell text with small caps\n")
				exit(198)
			}
		}
	}
	
	if (allcaps != "") {
		ret = _docx_cell_set_textcaps(doc_id, tid, row, col, "all", tocell)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
		errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set cell text with all caps\n")
				exit(198)
			}
		}
	}
}

`RS' docx_table_is_resultset(string scalar token)
{
	`RS'			type

	type = 0

	if (token == "escal" | token == "escala" | token == "escalar" |
		token == "escalars") {
		type = 1
	} 
	else if (token == "rscal" | token == "rscala" | token == "rscalar" | 
		token == "rscalars") {
		type = 2
	} 
	else if (token == "emac" | token == "emacr" | token == "emacro" | 
		token == "emacros") {
		type = 3
	} 
	else if (token == "rmac" | token == "rmacr" | token == "rmacro" |
		token == "rmacros") {
		type = 4
	}
	else if (token == "emat" | token == "ematr" | 
		token == "ematri" | token == "ematric" | 
		token == "ematrice" | token == "ematrices") {
		type = 5
	}
	else if (token == "rmat" | token == "rmatr" |
		token == "rmatri" | token == "rmatric" | 
		token == "rmatrice" | token == "rmatrices") {
		type = 6
	}
	else if (token == "e*") {
		type = 7
	} 
	else if (token == "r*") {
		type = 8
	}
	
	return(type)
}

`SS' docx_table_get_layout(`SS' layout)
{
	layout = strtrim(layout)
	if (layout=="fixed") {
		return("fixed")
	}
	else if (layout=="autofitw" | layout=="autofitwi" | 
		layout=="autofitwin" | layout=="autofitwind" | 
		layout=="autofitwindo" | layout=="autofitwindow") {
		return("autofitw")
	}
	else if (layout=="autofitc" | layout=="autofitco" | 
		layout=="autofitcon" | layout=="autofitcont" | 
		layout=="autofitconte" | layout=="autofitconten" |
		layout=="autofitcontent" | layout=="autofitcontents") {
		return("autofitc")
	}
	else {
		return("")
	}	
}

void docx_table_check_prop(`SS' width, `RS' headerrow, `SS' halign, 
			   `SS' indent, `SS' borders, `SS' cellmargins, 
			   `SS' cellspacing, `SS' layout)
{
	`RS'		rwidth, rindent, rcellspacing
	
	if (width != "") {
		rwidth = put_get_twips(strtrim(width), 1)
		if (rwidth < 0) {
	errprintf("option {bf:width()} specified incorrectly\n")
			exit(198)
		}
	}

	if (headerrow != 0) {
		if (headerrow < 0) {
		errprintf("invalid {bf:headerrow()}; rows out of range\n")
			exit(198)
		}
	}

	if (halign != "") {
		halign = strtrim(halign)
		if (halign != "left" & halign != "right" & halign != "center") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			exit(198)
		}
	}

	if (indent != "") {
		rindent = put_get_twips(strtrim(indent))
		if (rindent < 0) {
		errprintf("option {bf:indent()} specified incorrectly\n")
			exit(198)			
		}
	}

	if (borders != "") {
		(void) docx_table_set_border_wrk(-1, -1, borders)
	}

	if (cellmargins != "") {
		(void) docx_table_set_cellmargin_wrk(-1, -1, cellmargins)
	}
	
	if (cellspacing != "") {
		rcellspacing = put_get_twips(strtrim(cellspacing))
		if (rcellspacing < 0) {
		errprintf("option {bf:cellspacing()} specified incorrectly\n")
			exit(198)			
		}
	}

	if (layout != "") {
		if (docx_table_get_layout(layout)=="") {
		errprintf("option {bf:layout()} specified incorrectly\n")
			exit(198)
		}
	}	
}

void docx_add_table_wrk(`SS' tblspec, `SS' saddloc, `SS' width, `RS' headerrow, 
			`SS' halign, `SS' indent, `SS' borders, 
			`SS' cellmargins, `SS' cellspacing, `SS' layout, 
			`SS' myif, `SS' myin, `SS' title, `SS' notes,
			`SS' hfname)
{
	`RS'		addloc, doc_id, tid, ret, rows, cols, rettype, rtype
	`TR'		t
	`SS'		token, cell, tblname, srows, scols, soverr
	`SS'		tmatrix, tdata, tmata, tetable

	tid = -1
	doc_id = strtoreal(st_global("ST__DOCX_ID"))

	addloc = strtoreal(saddloc)
	
	rows = 0
	cols = 0
	rtype = 0
	
	t = tokeninit(" ", `"="', `"()"')
	tokenset(t, tblspec)

	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (tokenpeek(t)=="=") {
			(void) tokenget(t)
			tblname = token
			token = tokenget(t)
			if (token=="") {
	errprintf("nothing found where expression expected\n")
				exit(198)
			}
			else if (token == "matrix" | token == "matri" | 
				token == "matr" | token == "mat") {
				token = tokenget(t)
				if (docx_check_paren(token)) {
	errprintf("matrix specification must be enclosed in ()\n")
					exit(198)
				}
				tmatrix = docx_remove_paren(strtrim(token))
			}
			else if (rettype = docx_table_is_resultset(token)) {
				rtype = rettype
			}
			else if (token == "mata") {
				token = tokenget(t)
				if (docx_check_paren(token)) {
	errprintf("mata specification must be enclosed in ()\n")
					exit(198)
				}
				tmata = docx_remove_paren(strtrim(token))
			}
			else if (token == "data") {
				token = tokenget(t)
				if (docx_check_paren(token)) {
	errprintf("data specification must be enclosed in ()\n")
					exit(198)
				}
				tdata = docx_remove_paren(strtrim(token))
			}
			else if (token == "etable") {
				token = tokenget(t)
				if (docx_check_paren(token)) {
	errprintf("etable specification must be enclosed in ()\n")
					exit(198)
				}
				tetable = docx_remove_paren(strtrim(token))
			}
			else {
				if (docx_check_paren(token)) {
			errprintf("%s: invalid table specification\n", token)
					exit(198)
				}
				cell = docx_remove_paren(strtrim(token))
				if (strpos(cell, ",")>0) {
					srows = bsubstr(cell, 1, 
						strpos(cell, ",")-1)
					rows = strtoreal(srows)
					if (missing(rows)) {
errprintf("invalid table specification; number of rows misspecified\n")
						exit(198)
					}

					scols = bsubstr(cell, 
						strpos(cell, ",")+1, .)
					cols = strtoreal(scols)
					if (missing(cols)) {
errprintf("invalid table specification; number of columns misspecified\n")
						exit(198)
					}
					
					if (rows < 0) {
errprintf("invalid table specification; number of rows out of range\n")
						exit(198)
					}
					if (cols < 0) {
errprintf("invalid table specification; number of columns out of range\n")
						exit(198)
					}
				}
				else {
			errprintf("invalid table specification\n")
					exit(198)
				}
			}
		}
		else {
			errprintf("%s: invalid table specification\n", token)
			exit(198)
		}
	}
	
	(void) docx_table_check_prop(width, headerrow, halign, indent, borders, 
				     cellmargins, cellspacing, layout)
	
	if (tetable == "") {
		if (rows > 0) {
			tid =  _docx_new_table(doc_id, rows, cols, addloc, hfname)
		}
		
		if (tmatrix != "") {
			tid = docx_add_matrix_wrk(doc_id, tmatrix, addloc, hfname)
		}
		
		if (tmata != "") {
			tid = docx_add_mata_wrk(doc_id, tmata, addloc, hfname)
		}

		if (tdata != "") {
			tid = docx_add_data_wrk(doc_id, tdata, addloc, myif, myin, hfname)
		}
		
		if (rtype != 0) {
			tid = docx_add_resultset_wrk(rtype, addloc, hfname)
		}

		if (tid < 0) {
			if (tid == -16515) {
			errprintf("maximum number of tables exceeded; limit 500\n")
				exit(198)
			}
			else if (tid == -16526) {
				errprintf("maximum number of columns exceeded; limit 63\n")
				exit(198)
			}
			else {
				errprintf("failed to add table\n")
				exit(198)
			}
		}
		
		soverr = _docx_table_get_info(doc_id, tblname)
		
		ret = _docx_table_set_name(doc_id, tid, tblname)
		if (ret < 0) {
			errprintf("failed to add table\n")
			exit(198)
		}
		(void) docx_update(2)
		
		st_global("ST__DOCX_CUR_PARAGRAPH", "0")
		
		(void) docx_table_set_attr(doc_id, tid, tblname, width, headerrow, halign, 
					indent, borders, cellmargins, cellspacing, 
					layout, title, notes)
					
		if (bstrlen(soverr) != 0) {
printf("{txt}(note: table " + "{cmd:" + ustrtrim(tblname) + "} has been redefined)\n")
		}
	}
	else {
		(void) docx_add_etable_wrk(doc_id, tblname, tetable, addloc, 
			width, headerrow, halign, indent, borders, cellmargins, 
			cellspacing, layout, title, notes, hfname)
	}
}

void docx_parse_cellexplist(`TCCI' tcci, `SS' cell, `SS' expression, 
			    `RS' type, `RS' noexp)
{
	`SS'		srow, scol
	`SS'		tmpname, tblname
	`IMI'		imi
	`RS'		row, col, rc

	tcci.type = type
	tcci.row = -1
	tcci.col = -1
	tcci.imi = &(image_info())

	cell = docx_remove_paren(strtrim(cell))
	if (strpos(cell, ",")>0) {
		srow = bsubstr(cell, 1, strpos(cell, ",")-1)
		row = strtoreal(srow)
		if (missing(row)) {
		errprintf("invalid cell specification; row misspecified\n")
			exit(198)
		}

		scol = bsubstr(cell, strpos(cell, ",")+1, .)
		col = strtoreal(scol)
		if (missing(col)) {
		errprintf("invalid cell specification; column misspecified\n")
			exit(198)
		}

		tcci.row = row
		tcci.col = col
	}
	else {
		errprintf("syntax error\n")
		exit(198)
	}

	if (noexp==0) {
		if (docx_check_paren(expression)) {
			errprintf("expression must be enclosed in ()\n")
			exit(198)
		}

		expression = docx_remove_paren(expression)
		if (type == 1) {
			tmpname = st_tempname()
			rc = _stata(sprintf("scalar %s = %s", 
				tmpname, expression))
			if (rc) {
				exit(rc)
			}

			if (st_numscalar(tmpname)==J(0,0,.)) {
				tcci.exp = st_strscalar(tmpname)
			}
			else {
				tcci.exp = sprintf("%g", st_numscalar(tmpname))
			}
		}
		else if (type == 2) {
			if (expression=="") {
			errprintf("{bf:image()} specified incorrectly\n")
				exit(198)
			}
			(void) docx_parse_image(expression, imi)
			tcci.imi = &imi
		}
		else if (type == 3) {
			if (expression=="") {
			errprintf("{bf:table()} specified incorrectly\n")
				exit(198)
			}
			tblname = docx_remove_quote(expression)
			tcci.table = tblname
		}
		else {
			errprintf("syntax error\n")
			exit(198)
		}
	}
}

void docx_table_parse_cell(`SS' ltname, `SS' ltid, `SS' lrow, `SS' lcol, 
			   `SS' lrows, `SS' lcols, `SS' cellexplist)
{
	`TR'		t
	`SS'		token, cell, cellexp, tblname, srow, scol
	`RS'		doc_id, tid, row, col, bnumlist
	`RR'		tinfo
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	
	cellexp = cellexplist
	tblname = bsubstr(cellexp, 1, strpos(cellexp, "(")-1)
	cellexp = bsubstr(cellexp, strpos(cellexp, "("), .)
	
	tinfo = docx_get_table_info(doc_id, tblname)
	tid = tinfo[1]
	if (tid < 0) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)
	}
	st_local(ltname, tblname)
	tblname = sprintf("%g", tid)
	st_local(ltid, tblname)
	
	t = tokeninit(" ", `"="', `"()"')
	tokenset(t, cellexp)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (tokenpeek(t)=="=") {
			(void) tokenget(t)
			cell = token
			token = tokenget(t)
			if (token=="") {
		errprintf("nothing found where expression expected\n")
				exit(198)
			}
			cell = docx_remove_paren(strtrim(cell))
			if (strpos(cell, ",")>0) {
				srow = bsubstr(cell, 1, strpos(cell, ",")-1)
				if (srow != ".") {
					row = strtoreal(srow)
					if (missing(row) & srow!=".") {
		errprintf("invalid specification; row misspecified\n")
						exit(198)
					}
				}

				scol = bsubstr(cell, strpos(cell, ",")+1, .)
				if (scol != ".") {
					col = strtoreal(scol)
					if (missing(col) & scol!=".") {
		errprintf("invalid specification; column misspecified\n")
						exit(198)
					}
				}
				
				if (missing(row) & missing(col)) {
		errprintf("invalid specification; row and column misspecified\n")
					exit(198)
				}
				st_local(lrow, srow)
				st_local(lcol, scol)
			}
			else {
				errprintf("syntax error\n")
				exit(198)
			}
		}
		else {
			cell = docx_remove_paren(strtrim(token))
			if (strpos(cell, ",")>0) {
				srow = bsubstr(cell, 1, strpos(cell, ",")-1)
				if (strlen(srow)==0) {
		errprintf("invalid specification; row misspecified\n")
					exit(198)
				}
				
				bnumlist = 0
				if (srow != ".") {
					row = strtoreal(srow)
					if (missing(row)) {
						st_local(lrows, srow)
						st_local(lrow, ".")
						st_local(lcol, ".")
						bnumlist = 1
					}
					else {
						st_local(lrows, srow)
						st_local(lrow, srow)
					}
				}
				else {
					st_local(lrow, srow)
					st_local(lrows, srow)
				}

				scol = bsubstr(cell, strpos(cell, ",")+1, .)
				scol = strtrim(scol)
				if (strlen(scol)==0) {
		errprintf("invalid specification; column misspecified\n")
					exit(198)
				}
				if (strpos(scol, ",")) {
		errprintf("invalid specification; column misspecified\n")
					exit(198)
				}
				
				if (scol != ".") {
					col = strtoreal(scol)
					if (missing(col)) {
						st_local(lcols, scol)
						st_local(lrow, ".")
						st_local(lcol, ".")
						bnumlist = 1
					}
					else {
						if (bnumlist==0) {
							st_local(lcol, scol)
						}
						else {
							st_local(lcol, ".")
						}
						st_local(lcols, scol)
					}
				}
				else {
					st_local(lcols, scol)
					st_local(lcol, scol)
				}
			}
			else {
				errprintf("syntax error\n")
				exit(198)
			}
		}
	}
}

void docx_table_check_cell_prop(`SS' font, `SS' halign, `SS' valign,
				`SS' shading, `SS' borders, `SS' underline,
				`SS' script, `RS' rowspan, `RS' colspan, 
				`SS' span, `SS' nformat)
{
	`FTI'		fti
	`SHI' 		shi
	`RS'		span1, span2
	`SS'		srowspan, scolspan
	
	if (font != "") {
		(void) docx_parse_font(font, fti, 2)
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		if (halign != "left" & halign != "right" & 
			halign != "center") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (valign != "") {
		valign = strtrim(valign)
		if (valign != "top" & valign != "bottom" & 
			valign != "center") {
		errprintf("option {bf:valign()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (shading != "") {
		(void) docx_parse_shading(shading, shi)
	}

	if (borders != "") {
		(void) docx_cell_set_border_wrk(-1, -1, -1, -1, borders)
	}

	if (underline != "") {
		underline = strtrim(underline)
		if (!docx_is_underline_style(underline)) {
		errprintf("option {bf:underline()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (script != "") {
		valign = strtrim(script)
		if (valign!="sub" & valign!="super") {
		errprintf("option {bf:script()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (rowspan != 1) {
		if (rowspan <= 0) {
		errprintf("invalid {bf:rowspan()}; rows out of range\n")
			exit(198)
		}
	}
	
	if (colspan != 1) {
		if(colspan <= 0) {
		errprintf("invalid {bf:colspan()}; columns out of range\n")
			exit(198)
		}
	}
	
	if (span != "") {
		span = strtrim(span)
		if (strpos(span, ",")>0) {
			srowspan = bsubstr(span, 1, strpos(span, ",")-1)
			span1 = strtoreal(srowspan)
			if (missing(span1)) {
		errprintf("invalid {bf:span()}; rows misspecified\n")
				exit(198)
			}

			scolspan = bsubstr(span, strpos(span, ",")+1, .)
			span2 = strtoreal(scolspan)
			if (missing(span2)) {
		errprintf("invalid {bf:span()}; columns misspecified\n")
				exit(198)
			}

			if (span1 <= 0) {
		errprintf("invalid {bf:span()}; rows out of range\n")
				exit(198)				
			}
			if (span2 <= 0) {
		errprintf("invalid {bf:span()}; columns out of range\n")
			exit(198)
			}
		}
		else {
			errprintf("syntax error\n")
			exit(198)
		}
	}
	
	if (nformat != "") {
		nformat = strtrim(nformat)
		if (!st_isnumfmt(nformat)) {
		errprintf("option {bf:nformat()} specified incorrectly\n")
			exit(198)
		}
	}
}

void docx_table_set_cell_wrk(`SS' font, 
			`SS' halign, 
			`SS' valign, 
			`SS' shading, 
			`SS' borders, 
			`SS' bold, 
			`SS' italic, 
			`SS' underline, 
			`SS' strikeout, 
			`SS' script, 
			`RS' rowspan, 
			`RS' colspan, 
			`SS' span, 
			`SS' append, 
			`SS' stocell, 
			`SS' nformat, 
			`RS' linebreaks, 
			`SS' smallcaps, 
			`SS' allcaps,
			`SS' trim,
			`SS' hyperlink,
			`RS' totalpage, 
			`RS' pagenum)
{
	`TR'		t
	`SS'		token, cell, cellexp, tblname, sval
	`TCCI' 		tcci
	`RS'		doc_id, tid, row, col
	`RS'		tappend, src_tid, ret, tocell
	`RR'		tinfo, src_tinfo

	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))

	cellexp = st_local("cellexplist")
	tblname = bsubstr(cellexp, 1, strpos(cellexp, "(")-1)
	cellexp = bsubstr(cellexp, strpos(cellexp, "("), .)

	tinfo = docx_get_table_info(doc_id, tblname)
	tid = tinfo[1]
	if (tid < 0) {
errprintf("table %s does not exist\n", tblname)
		exit(198)
	}

	t = tokeninit(" ", `"="', `"()"')
	tokenset(t, cellexp)

	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (tokenpeek(t)=="=") {
			(void) tokenget(t)
			cell = token
			token = tokenget(t)
			if (token=="") {
errprintf("nothing found where expression expected\n")
				exit(198)
			}
			else if (token == "table") {
				token = tokenget(t)
				if (docx_check_paren(token)) {
errprintf("%s: table name must be enclosed in ()\n", token)
					exit(198)
				}
				(void) docx_parse_cellexplist(tcci, cell, 
					token, 3, 0)
			}
			else if (token == "image") {
				token = tokenget(t)
				if (docx_check_paren(token)) {
errprintf("%s: image must be enclosed in ()\n", token)
					exit(198)
				}
				(void) docx_parse_cellexplist(tcci, cell, 
					token, 2, 0)
			}
			else {
				token = strtrim(bsubstr(cellexp, strpos(cellexp, "=")+1, .))
				if (bsubstr(token, 1, 1)=="(") {
					(void) docx_parse_cellexplist(tcci, cell, 
						token, 1, 0)
					break
				}
				else {
errprintf("syntax error\n")
					exit(198)
				}
			}
		}
		else {
			(void) docx_parse_cellexplist(tcci, token, "()", 0, 1)
		}
	}

	row = tcci.row 
	col = tcci.col 
	if (row < 0) {
errprintf("invalid cell specification; row out of range\n")
		exit(198)
	}
	if (col < 0) {
errprintf("invalid cell specification; column out of range\n")
		exit(198)
	}
	
	(void) docx_table_check_cell_prop(font, halign, valign, shading, 
				borders, underline, script, rowspan, colspan, 
				span, nformat)

	tappend = 0
	if (append != "") {
		tappend = 1
	}
	tocell = 0
	if (stocell != "") {
		tocell = 1
	}

	if (tcci.type == 1) {
		if (nformat != "") {
			nformat = strtrim(nformat)
			sval = put_format_value(tcci.exp, nformat)
		}
		else {
			sval = tcci.exp
		}
		
		if(strlen(trim) != 0) {
			sval = strtrim(sval);
		}
		
		if(strlen(hyperlink) != 0) {
			ret = _docx_table_mod_cell_hyperlink(doc_id, tid, 
				row, col, sval, hyperlink, tappend, 0)		
		}
		else {
			ret = _docx_table_mod_cell(doc_id, tid, 
				row, col, sval, tappend, 0)
		}
		
		if(ret == 0) {
			if(pagenum != 0) {
				ret = _docx_table_mod_cell_pagenum(doc_id, tid, 
					row, col, 1, 0)
			}
			else {
				if(totalpage != 0) {
					ret = _docx_table_mod_cell_totalpages(doc_id, tid, 
						row, col, 1, 0)
				}
			}
		}
	}
	else if (tcci.type == 2) {
		if((totalpage != 0) || (pagenum != 0)) {
errprintf("Option {bf:totalpages} and option {bf:pagenumber} can not be used for input type {bf:image()}\n")
			exit(198)
		}
		ret =  _docx_table_mod_cell_image(doc_id, tid, row, col,
				tcci.imi->filepath, tcci.imi->link, 
				tappend, tcci.imi->cx, tcci.imi->cy, 0)
	}
	else if (tcci.type == 3) {
		src_tinfo = docx_get_table_info(doc_id, tcci.table)
		src_tid = src_tinfo[1]
		if (src_tid < 0) {
errprintf("table %s does not exist\n", tcci.table)
			exit(198)
		}
		if((totalpage != 0) || (pagenum != 0)) {
errprintf("Option {bf:totalpages} and option {bf:pagenumber} can not be used for input type {bf:table}\n")
			exit(198)
		}
		ret = _docx_table_mod_cell_table(doc_id, tid, row, col,
				tappend, src_tid)
	}
	else {
		if((totalpage != 0) || (pagenum != 0)) {
errprintf("Option {bf:totalpages} and option {bf:pagenumber} can only be used when adding an expression to a cell\n")
			exit(198)
		}		
	}

	if (tcci.type != 0) {
		if (ret < 0) {
			if (ret == -16517) {
errprintf("invalid cell specification; row out of range\n")
				exit(198)
			}
			else if (ret == -16518) {
errprintf("invalid cell specification; column out of range\n")
				exit(198)
			}
			else {
errprintf("failed to modify cell content\n")
				exit(198)
			}
		}
	}

	(void) docx_table_set_cell_attr(doc_id, tid, row, col, font, 
				halign, valign, shading, borders, bold, italic,
				underline, strikeout, script, rowspan, colspan, 
				span, tocell, nformat, linebreaks, smallcaps, 
				allcaps)
}

void docx_table_set_row_wrk(`SS' tinfo, `SS' nosplit, `SS' addrows, `SS' drop, 
			    `SS' font, `SS' halign, `SS' valign, 
			    `SS' shading, `SS' borders,
			    `SS' bold, `SS' italic, 
			    `SS' underline, `SS' strikeout, 
			    `SS' nformat, `SS' smallcaps, `SS' allcaps)
{
	`RS'		doc_id, tid, row, ret, i, colcount, rowcount
	`SS'		stid, srow, srest, snadds, safter
	`RR'		tblinfo
	`RS'		nadds, bafter
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	
	stid = bsubstr(tinfo, 1, strpos(tinfo, "_")-1)
	tid = strtoreal(stid)
	
	srest = bsubstr(tinfo, strpos(tinfo, "_")+1, .)
	srow = bsubstr(srest, 1, strpos(srest, "_")-1)
	row = strtoreal(srow)
	
	srest = bsubstr(srest, strpos(srest, "_")+1, .)
	tblinfo = docx_get_table_info(doc_id, srest)
	rowcount = tblinfo[2]
	colcount = tblinfo[3]
	
	if (row <= 0 | row > rowcount) {
		errprintf("invalid specification; row out of range\n")
		exit(198)
	}
	
	if (nosplit != "") {
		ret = _docx_row_set_cantsplit(doc_id, tid, row, 1)
		if (ret < 0) {
			if (ret == -16517) {
		errprintf("invalid specification; row out of range\n")
				exit(198)
			}
			else {
				errprintf("failed to set row split property\n")
				exit(198)
			}
		}
	}
	
	if (addrows != "") {
		bafter = 1
		addrows = strtrim(addrows)
		if (strpos(addrows, ",") == 0) {
			nadds = strtoreal(addrows)
			if (missing(nadds)) {
		errprintf("option {bf:addrows()} specified incorrectly\n")
				exit(198)
			}
		}
		else {
			snadds = bsubstr(addrows, 1, strpos(addrows, ",")-1)
			safter = bsubstr(addrows, strpos(addrows, ",")+1, .)
			nadds = strtoreal(snadds)
			if (missing(nadds)) {
		errprintf("option {bf:addrows()} specified incorrectly\n")
				exit(198)
			}
			safter = strtrim(safter)
			if (safter != "before" & safter != "after") {
		errprintf("option {bf:addrows()} specified incorrectly\n")
				exit(198)
			}
			if (safter == "before") {
				bafter = 0
			}
		}
		
		if (nadds <= 0) {
		errprintf("option {bf:addrows()} specified incorrectly\n")
			exit(198)
		}
		
		for(i=0; i<nadds; i++) {
			if (bafter == 0) {
			ret = _docx_table_add_row(doc_id, tid, row+i-1, colcount)
			}
			else {
			ret = _docx_table_add_row(doc_id, tid, row+i, colcount)
			}
			if (ret < 0) {
				errprintf("failed to add rows to table\n")
				exit(198)
			}
		}
	}
	
	if (drop != "") {
		ret = _docx_table_del_row(doc_id, tid, row)
		if (ret < 0) {
			errprintf("failed to delete row from table\n")
			exit(198)
		}
	}
	
	(void) docx_table_check_cell_prop(font, halign, valign, shading, 
				borders, underline, "", 1, 1, "", nformat)
	
	colcount = _docx_table_query_row(doc_id, tid, row)
	if (colcount > 0) {
		for(i=1; i<=colcount; i++) {
			(void) docx_table_set_cell_attr(doc_id, tid, row, i, font, 
						halign, valign, shading, borders, 
						bold, italic, underline, strikeout, 
						"", 1, 1, "", 1, nformat, 0, 
						smallcaps, allcaps)
		}
	}
}

void docx_table_set_column_wrk(`SS' tinfo, `SS' addcols, `SS' drop, 
			       `SS' font, `SS' halign, `SS' valign, 
			       `SS' shading, `SS' borders,
			       `SS' bold, `SS' italic, 
			       `SS' underline, `SS' strikeout, 
			       `SS' nformat, `SS' smallcaps, `SS' allcaps)
{
	`RS'		doc_id, tid, col, ret, i, rowcount, colcount
	`SS'		stid, scol, srest, snadds, sbefore
	`RR'		tblinfo
	`RS'		nadds, bleft
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	
	stid = bsubstr(tinfo, 1, strpos(tinfo, "_")-1)
	tid = strtoreal(stid)
	
	srest = bsubstr(tinfo, strpos(tinfo, "_")+1, .)
	scol = bsubstr(srest, 1, strpos(srest, "_")-1)
	col = strtoreal(scol)
	
	srest = bsubstr(srest, strpos(srest, "_")+1, .)
	tblinfo = docx_get_table_info(doc_id, srest)
	rowcount = tblinfo[2]
	colcount = tblinfo[3]
	
	if (col <= 0 | col > colcount) {
		errprintf("invalid specification; column out of range\n")
		exit(198)
	}
	
	if (addcols != "") {
		bleft = 0
		addcols = strtrim(addcols)
		if (strpos(addcols, ",") == 0) {
			nadds = strtoreal(addcols)
			if (missing(nadds)) {
		errprintf("option {bf:addcols()} specified incorrectly\n")
				exit(198)
			}
		}
		else {
			snadds = bsubstr(addcols, 1, strpos(addcols, ",")-1)
			sbefore = bsubstr(addcols, strpos(addcols, ",")+1, .)
			nadds = strtoreal(snadds)
			if (missing(nadds)) {
		errprintf("option {bf:addcols()} specified incorrectly\n")
				exit(198)
			}
			sbefore = strtrim(sbefore)
			if (sbefore != "before" & sbefore != "after") {
		errprintf("option {bf:addcols()} specified incorrectly\n")
				exit(198)
			}
			if (sbefore == "before") {
				bleft = 1
			}
		}
		
		if (nadds <= 0) {
		errprintf("option {bf:addcols()} specified incorrectly\n")
			exit(198)
		}
		
		for(i=0; i<nadds; i++) {
			ret = 0
			if (bleft == 1) {
				ret = ret + _docx_table_add_column(doc_id, tid, i+col-1)
			}
			else {
				ret = ret + _docx_table_add_column(doc_id, tid, col)
			}
			if (ret < 0) {
				errprintf("failed to add columns to table\n")
				exit(198)
			}
		}
	}
	
	if (drop != "") {
		ret = _docx_table_del_column(doc_id, tid, col)
		if (ret < 0) {
			errprintf("failed to delete column from table\n")
			exit(198)
		}
	}
	
	(void) docx_table_check_cell_prop(font, halign, valign, shading, borders, 
				underline, "", 1, 1, "", nformat)
	
	for(i=1; i<=rowcount; i++) {
		(void) docx_table_set_cell_attr(doc_id, tid, i, col, font, 
					halign, valign, shading, borders, 
					bold, italic, underline, strikeout, 
					"", 1, 1, "", 1, nformat, 0, 
					smallcaps, allcaps)
	}
}

void docx_table_set_cell_range_wrk(`SS' tinfo, `SS' rrange, `SS' crange, 
				   `SS' font, `SS' halign, `SS' valign, 
				   `SS' shading, `SS' borders,
				   `SS' bold, `SS' italic, 
				   `SS' underline, `SS' strikeout, 
				   `SS' nformat, `SS' smallcaps, `SS' allcaps)
{
	`RS'		doc_id, tid, nrows, ncols, i, j, rowcount, colcount, rc
	`SS'		quote, tblname, numcmd
	`RR'		tblinfo, rownum, colnum
	`RC'		crownum, ccolnum
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	
	tblname = bsubstr(tinfo, 1, strpos(tinfo, "(")-1)
	tblinfo = docx_get_table_info(doc_id, tblname)
	tid = tblinfo[1]
	rowcount = tblinfo[2]
	colcount = tblinfo[3]
	
	if (rrange==".") {
		crownum = range(1,rowcount,1)
		rownum = crownum'
	}
	else {
		quote = `"""'
		numcmd = sprintf("qui numlist %s%s%s, integer sort range(>0 <=%g)", 
			quote, rrange, quote, rowcount)
		rc = _stata(numcmd, 1)
		if (rc) {
	errprintf("invalid numlist specification; row misspecified\n")
			exit(rc)
		}
		rownum = strtoreal(tokens(st_global("r(numlist)")))
	}
	
	if (crange==".") {
		ccolnum = range(1,colcount,1)
		colnum = ccolnum'
	}
	else {
		quote = `"""'
		numcmd = sprintf("qui numlist %s%s%s, integer sort range(>0 <=%g)", 
			quote, crange, quote, colcount)
		rc = _stata(numcmd, 1)
		if (rc) {
	errprintf("invalid numlist specification; column misspecified\n")
			exit(rc)
		}
		colnum = strtoreal(tokens(st_global("r(numlist)")))
	}
	
	(void) docx_table_check_cell_prop(font, halign, valign, shading, borders, 
				underline, "", 1, 1, "", nformat)
	
	nrows = cols(rownum)
	ncols = cols(colnum)
	for(i=1; i<=nrows; i++) {
		for(j=1;j<=ncols;j++) {
			(void) docx_table_set_cell_attr(doc_id, tid, rownum[i], colnum[j], 
						font, halign, valign, shading, borders, 
						bold, italic, underline, strikeout, 
						"", 1, 1, "", 1, nformat, 0, 
						smallcaps, allcaps)
		}
	}
}

`RS' docx_add_matrix_wrk(`RS' doc_id, `SS' tmatrix, `RS' addloc, `SS' hfname)
{
	`TR'		t
	`SS'		tmpstr, token, matname, tmpname
	`SS'		sfmt, srownames, scolnames, fmt
	`RS'		args, tid, rownames, colnames, rc

	tmpstr = docx_remove_paren(tmatrix)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	tid = -1
	args = 1
	matname = ""
	sfmt = ""
	srownames = ""
	scolnames = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			matname = docx_remove_quote(token)
		}
		else if (args == 2) {
			sfmt = docx_remove_quote(token)
		}
		else if (args == 3) {
			srownames = docx_remove_quote(token)
		}
		else if (args == 4) {
			scolnames = docx_remove_quote(token)
		}
		else if (args > 4) {
		errprintf("invalid specification in {bf:matrix()}\n")
			exit(198)
		}
		args++
	}

	matname = strtrim(matname)
	if (matname == "") {
		errprintf("matrix name must be specified\n")
		exit(198)
	}
	
	tmpname = st_tempname()
	rc = _stata(sprintf("matrix define %s = %s", 
		tmpname, matname))
	if (rc) {
		exit(rc)
	}
	
	tmpstr = "confirm matrix " + tmpname
	rc = _stata(tmpstr)
	if (rc) {
		exit(rc)
	}

	fmt = "%12.0g"
	if (sfmt != "") {
		fmt = strtrim(sfmt)
		if (!st_isnumfmt(fmt)) {
		errprintf("option {bf:nformat()} specified incorrectly\n")
			exit(198)
		}
	}

	rownames = 0
	if (srownames != "") {
		rownames = strtoreal(strtrim(srownames))
	}
	
	colnames = 0
	if (scolnames != "") {
		colnames = strtoreal(strtrim(scolnames))
	}

	tid =  _docx_add_matrix(doc_id, tmpname, fmt, 
		colnames, rownames, addloc, hfname)
	
	if (tid == -111) {
		errprintf("%s not found\n", matname)
		exit(198)
	}
	
	return(tid)
}

`RS' docx_add_mata_wrk(`RS' doc_id, `SS' tmata, `RS' addloc, `SS' hfname)
{
	`TR'		t
	`SS'		tmpstr, token, smata, sfmt, fmt
	transmorphic matrix	m
	`RS'		args, tid
	
	tmpstr = docx_remove_paren(tmata)
	tmpstr = docx_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	tid = -1
	args = 1
	smata = ""
	sfmt = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			smata = docx_remove_quote(token)
		}
		else if (args == 2) {
			sfmt = docx_remove_quote(token)
		}
		else if (args > 2) {
		errprintf("invalid specification in {bf:mata()}\n")
			exit(198)
		}
		args++
	}

	if (args < 1) {
		errprintf("invalid specification in {bf:mata()}\n")
		exit(198)
	}

	smata = strtrim(smata)
	if (smata == "") {
		errprintf("matrix must be specified\n")
		exit(198)
	}
	if (findexternal(smata) == NULL) {
		errprintf("mata matrix %s undefined\n", smata)
		exit(198)
	}
	else {
		m = valofexternal(smata)
	}

	fmt = "%12.0g"
	if (sfmt != "") {
		fmt = strtrim(sfmt)
		if (!st_isnumfmt(fmt)) {
		errprintf("option {bf:nformat()} specified incorrectly\n")
			exit(198)
		}
	}

	tid =  _docx_add_mata(doc_id, m, fmt, addloc, hfname)
	return(tid)
}

void docx_check_varindex(`SS' varnames) 
{
	`SR' 		vars
	`RS'		ivar
	
	vars = tokens(varnames)
	
	for(ivar=1; ivar<=cols(vars); ivar++) {
		if (hasmissing(_st_varindex(vars[ivar]))) {
			errprintf("variable %s not found\n", vars[ivar])
			exit(111)
		}
	}
}

`RS' docx_add_data_wrk(`RS' doc_id, `SS' tdata, `RS' addloc, 
		       `SS' myif, `SS' myin, `SS' hfname)
{
	`TR'		t
	`SS'		tmpstr, token, svarnames, sobsno, si, sj, tmpname
	`RM'		i
	`RR'		j
	`RS'		args, tid, varnames, obsno, rc, tmppos
	`RS' 		myifin, oobsno

	tmpstr = strtrim(tdata)
	
	if (strpos(tmpstr, "(") | strpos(tmpstr, ")")) {
		if (strpos(tmpstr, "(") && strpos(tmpstr, ")") == 0) {
			errprintf("parenthesis not balanced\n")
			exit(198)
		}
		if (strpos(tmpstr, "(") == 0 && strpos(tmpstr, ")")) {
			errprintf("parenthesis not balanced\n")
			exit(198)
		}
		if (strpos(tmpstr, "(") == 1) {
			tmppos = strpos(tmpstr, ")")
			sj = bsubstr(tmpstr, 1, tmppos)
			tmpstr = strtrim(bsubstr(tmpstr, tmppos+1, .))
			if (bstrlen(tmpstr) == 0) {
			errprintf("invalid specification in {bf:data()}\n")
				exit(198)
			}
			if (strpos(tmpstr, ",") != 1) {
				errprintf("syntax error\n")
				exit(198)
			}
			tmpstr = strtrim(bsubstr(tmpstr, 2, .))
			if (bstrlen(tmpstr) == 0) {
			errprintf("invalid specification in {bf:data()}\n")
				exit(198)
			}
		}
		else {
			tmppos = strpos(tmpstr, "(")
			sj = strtrim(bsubstr(tmpstr, 1, tmppos-1))
			if (strpos(sj, ",") != bstrlen(sj)) {
			errprintf("invalid specification in {bf:data()}\n")
				exit(198)
			}
			sj = bsubstr(sj, 1, bstrlen(sj)-1)
			tmpstr = strtrim(bsubstr(tmpstr, tmppos, .))
			if (bstrlen(tmpstr) == 0) {
			errprintf("invalid specification in {bf:data()}\n")
				exit(198)
			}
		}
		
		if (strpos(tmpstr, "(") | strpos(tmpstr, ")")) {
			if (strpos(tmpstr, "(") && strpos(tmpstr, ")") == 0) {
				errprintf("parenthesis not balanced\n")
				exit(198)
			}
			if (strpos(tmpstr, "(") == 0 && strpos(tmpstr, ")")) {
				errprintf("parenthesis not balanced\n")
				exit(198)
			}
			if (strpos(tmpstr, "(") != 1) {
			errprintf("invalid specification in {bf:data()}\n")
				exit(198)
			}
			tmppos = strpos(tmpstr, ")")
			si = bsubstr(tmpstr, 1, tmppos)
			
			tmpstr = strtrim(bsubstr(tmpstr, tmppos+1, .))
			if (bstrlen(tmpstr) != 0) {
				if (strpos(tmpstr, ",") != 1) {
					errprintf("syntax error\n")
					exit(198)
				}
				tmpstr = strtrim(bsubstr(tmpstr, 2, .))
			}
			tmpstr = docx_process_options(tmpstr)
			svarnames = ""
			sobsno = ""

			t = tokeninit(" ", `","', `""""', 0, 0)
			tokenset(t, tmpstr)
			
			args = 1
			for(token=tokenget(t); token != ""; token = tokenget(t)) {
				(void) tokenget(t)
				if (args == 1) {
					svarnames = docx_remove_quote(token)
				}
				else if (args == 2) {
					sobsno = docx_remove_quote(token)
				}
				else if (args > 2) {
			errprintf("invalid specification in {bf:data()}\n")
					exit(198)
				}
				args++
			}
		}
		else {
			tmpstr = docx_process_options(tmpstr)
			svarnames = ""
			sobsno = ""
			si = ""

			t = tokeninit(" ", `","', `""""', 0, 0)
			tokenset(t, tmpstr)
			
			args = 1
			for(token=tokenget(t); token != ""; token = tokenget(t)) {
				(void) tokenget(t)
				if (args == 1) {
					si = docx_remove_quote(token)
				}
				else if (args == 2) {
					svarnames = docx_remove_quote(token)
				}
				else if (args == 3) {
					sobsno = docx_remove_quote(token)
				}
				else if (args > 3) {
			errprintf("invalid specification in {bf:data()}\n")
					exit(198)
				}
				args++
			}
		}
	}
	else {
		tmpstr = docx_process_options(tmpstr)
		args = 1
		svarnames = ""
		sobsno = ""
		si = ""
		sj = ""
		
		t = tokeninit(" ", `","', `""""', 0, 0)
		tokenset(t, tmpstr)

		tid = -1

		for(token=tokenget(t); token != ""; token = tokenget(t)) {
			(void) tokenget(t)
			if (args == 1) {
				sj = docx_remove_quote(token)
			}
			else if (args == 2) {
				si = docx_remove_quote(token)
			}
			else if (args == 3) {
				svarnames = docx_remove_quote(token)
			}
			else if (args == 4) {
				sobsno = docx_remove_quote(token)
			}
			else if (args > 4) {
			errprintf("invalid specification in {bf:data()}\n")
				exit(198)
			}
			args++
		}
		
		if (args < 2) {
			errprintf("invalid specification in {bf:data()}\n")
			exit(198)
		}
	}

	if (bstrlen(svarnames) == 0) {
		varnames = 0
	}
	else {
		varnames = strtoreal(svarnames)
	}

	if (bstrlen(sobsno) == 0) {
		obsno = 0
	}
	else {
		obsno = strtoreal(sobsno)
	}
	
	myifin = 0
	if (strlen(myif) != 0 | strlen(myin) != 0) {
		myifin = 1 
	}
	
	if (myifin == 1) {
		rc = _stata("preserve", 1) 
		if (rc) {
			errprintf("failed to add table\n")
			exit(198)
		}
		rc = _stata(sprintf("count %s %s", myif, myin), 1)
		tmpname = st_tempname()
		rc = rc + _stata(sprintf("local %s = r(N)", tmpname), 1)
		if (rc) {
			errprintf("failed to add table\n")
			_stata("restore", 1)
			exit(198)
		}
		if (st_local(tmpname) == "0") {
errprintf("no qualified observation found in specified ifin condition\n")
			_stata("restore", 1)
			exit(2000)
		}
		if (obsno == 1) {
			rc = _stata("gen obsno = _n", 1)
			if (rc) {
				errprintf("failed to add table\n")
				_stata("restore", 1)
				exit(198)
			}
		}
		
		rc = _stata(sprintf("keep %s %s", myif, myin), 1)
		if (rc) {
			errprintf("failed to add table\n")
			_stata("restore", 1)
			exit(198)
		}
	}
	
	sj = docx_remove_quote(sj)
	tmpname = st_tempname()
	rc = _stata(sprintf("matrix define %s = %s", tmpname, sj), 1)
	if (rc) {
		(void) docx_check_varindex(sj)
		if (myifin == 1) {
			if (obsno == 1) {
				sj = "obsno " + sj
			}
		}
		j = _st_varindex(tokens(sj))
	}
	else {
		j = st_matrix(tmpname)
		if (rows(j) != 1) {
			errprintf("invalid specification in {bf:data()}\n")
			exit(198)
		}
		if (myifin == 1) {
			if (obsno == 1) {
				j = j'
				j = 1 \ j
				j = j'
			}
		}
	}

	si = docx_remove_quote(si)
	if (strpos(si, "(")) {
		tmpname = st_tempname()
		rc = _stata(sprintf("matrix define %s = %s", tmpname, si))
		if (rc) {
			errprintf("invalid specification in {bf:data()}\n")
			exit(rc)
		}
		i = st_matrix(tmpname)
	}
	else {
		if (si == ".") {
			i = J(1,1,.)
		}
		else {
			i = st_matrix(si)
		}
	}
	
	oobsno = obsno
	if (myifin == 1) {
		if (obsno == 1) {
			obsno = 0
		}
	}
	tid =  _docx_add_data(doc_id, varnames, obsno, i, j, addloc, "", hfname)
	if (myifin == 1) {
		if (tid >= 0) {
			if (oobsno == 1) {
				(void)_docx_table_mod_cell(doc_id, tid, 1, 1, "", 0)
			}
		}
		rc = _stata("restore", 1)
		if (rc) {
			errprintf("failed to add table\n")
			exit(198)
		}
	}

	return(tid)
}

void docx_save_wrk(`SS' filename, `SS' replace, `SS' append, 
				`SS' pagebreak, `SS' hfsrc, 
				`SS' pgnumrestart, `SS' loc)
{
	`SS' 		using_file
	`RS'		doc_id, ret, pgbreak, hffrom, pgrestart, appendopts
	`SS'		mode
	
	(void) docx_is_valid()
	
	pgbreak = 0
	hffrom = 1
	pgrestart = 0
	if (pagebreak != "") {
		pgbreak = 1
	}

	if (pgnumrestart != "") {
		pgrestart = 1
	}

	mode = "created"
	if (hfsrc != "") {
		hfsrc = docx_remove_quote(hfsrc)
		if (hfsrc == "file") {
			hffrom = 1
		}
		else if (hfsrc == "own") {
			hffrom = 0
		}
		else if (hfsrc == "active") {
			hffrom = 2
		}
		else {
			errprintf("option {bf:append()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (hffrom==2 & pgnumrestart != "") {
		errprintf("options {bf:headsrc(active)} and {bf:pgnumrestart} cannot be specified together\n")
		exit(198)
	}
	
	appendopts = 0
	if (pagebreak != "" | pgnumrestart != "" | hfsrc != "") {
		appendopts = 1
	}
	
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	if (doc_id >= 0) {
		using_file = docx_check_filename(filename, 0)
		if (fileexists(using_file)) {
			if (replace == "" & append == "" & appendopts == 0) {
				errprintf("file %s already exists\n", using_file)
				errprintf("you must specify one of the {bf:replace} ")
				errprintf(", {bf:append}, and {bf:append()} options\n")
				exit(198)
			}
			ret = 0
			if (replace != "") {
				mode = "replaced"
				ret = _docx_save(doc_id, using_file, 1)
			}
			if (append != "" | appendopts != 0) {
				mode = "appended to"
				ret = _docx_append(doc_id, using_file, pgbreak, hffrom, pgrestart)
			}
			if (ret < 0) {
				errprintf("failed to save document\n")
				if (ret==-3621) {
					exit(603)
				}
				else {
					exit(198)
				}
			}
		}
		else {
			if (append != "" | appendopts != 0) {
				errprintf("file %s not found\n", using_file)
				exit(601)
			}
			if (_docx_save(doc_id, using_file, 1) < 0) {
				errprintf("failed to save document\n")
				exit(198)
			}
		}
	}

	(void) docx_close_wrk()
	st_local(loc, mode)
}

void docx_clear_wrk()
{
	`RS'		doc_id
	
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	if (doc_id!=.) {
		if (doc_id >= 0) {
			if (_docx_close(doc_id) < 0) {
				errprintf("failed to close document\n")
				exit(198)
			}		
		}
	}
	
	st_global("ST__DOCX_ID", "-1")
	st_global("ST__DOCX_CUR_PARAGRAPH", "0")
	st_global("ST__DOCX_NO_TABLES", "0")
	st_global("ST__DOCX_NO_PARAGRAPHS", "0")	
}

void docx_close_wrk()
{
	`RS'		doc_id
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	if (doc_id >= 0) {
		if (_docx_close(doc_id) < 0) {
			errprintf("failed to close document\n")
			exit(198)
		}		
	}
	
	st_global("ST__DOCX_ID", "-1")
	st_global("ST__DOCX_CUR_PARAGRAPH", "0")
	st_global("ST__DOCX_NO_TABLES", "0")
	st_global("ST__DOCX_NO_PARAGRAPHS", "0")
}

void docx_describe_wrk(`SS' s, `RS' type)
{
	`RS'		doc_id, maxlen, tid
	`RS'		ntables, nparas
	`RR'		tinfo
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	if (type == 0) {
		ntables = strtoreal(st_global("ST__DOCX_NO_TABLES"))
		nparas = strtoreal(st_global("ST__DOCX_NO_PARAGRAPHS"))
		if (doc_id >= 0) {
			printf("\n")
			maxlen = 20
			printf("  {hline %g}{c +}{hline %g}\n", 20, maxlen+3)
			printf("  {cmd:No. of tables}       {c |}  %g\n", ntables)
			printf("  {cmd:No. of paragraphs}   {c |}  %g\n", nparas)
			(void) _stata("return add", 1)
		}
	}
	else {
		tinfo = docx_get_table_info(doc_id, s)
		tid = tinfo[1]
		if (tid < 0) {
			errprintf("table %s does not exist\n", s)
			exit(198)
		}
		else {
			printf("\n")
			maxlen = 20
			maxlen = bstrlen(s)
			if (maxlen < 20) maxlen = 20
			if (maxlen > 60) maxlen = 60
			printf("  {hline %g}{c +}{hline %g}\n", 20, maxlen+3)
			printf("  {cmd:Table name}          {c |}  %s\n", s)
			printf("  {cmd:No. of rows}         {c |}  %g\n", tinfo[2])
			printf("  {cmd:No. of cols}   	    {c |}  %g\n", tinfo[3])
			
			st_rclear()
			st_numscalar("r(ncols)", tinfo[3])
			st_numscalar("r(nrows)", tinfo[2])
			(void) _stata("return add", 1)
		}
	}
}

void docx_append_wrk(`SS' filelist, `SS' savefile, `SS' replace, 
			`SS' pagebreak, `SS' hfsrc, `SS' pgnumrestart, 
			`SS' loc, `SS' save_mode)
{
	`SS'		dest, file1, file2
	`RS'		rep, ret, i, count, pgbreak, pgrestart, hffrom
	`SR'		flist
	`SS'		mode
	
	flist = tokens(filelist, ",")
	dest = ""
	count = 0
	mode = "appended to"
	
	for(i=1; i<=cols(flist); i++) {
		file2 = flist[i]
		if (file2 != ",") {
			file2 = docx_check_filename(file2, 1)
			if (count == 0) {
				file1 = file2
			}
			else {
				file1 = file1 + "," + file2
			}
			count = count + 1
		}
	}
	
	rep = 0
	if (savefile != "") {
		dest = docx_check_filename(savefile, 0)
		rep = 0
		if (replace != "") {
			rep = 1
		}
		if (fileexists(dest) !=0) {
			if(rep == 0) {
				errprintf("file %s already exists\n", dest)
				errprintf("you must specify the {bf:replace} option\n")
				exit(198)
			}
			else {
				mode = "replaced"
			}
		}
		else {
			mode = "created"
		}
	}

	pgbreak = 0
	pgrestart = 0
	hffrom = 1
	if (pagebreak != "") {
		pgbreak = 1
	}
	
	if (pgnumrestart != "") {
		pgrestart = 1
	}
	
	if (hfsrc != "") {
		if (hfsrc == "first") {
			hffrom = 1
		}
		else if (hfsrc == "own") {
			hffrom = 0
		}
		else if (hfsrc == "last") {
			hffrom = 2
		}
		else {
			errprintf("option {bf:headsrc()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (hffrom==2 & pgnumrestart != "") {
		errprintf("options {bf:headsrc(last)} and {bf:pgnumrestart} cannot be specified together\n")
		exit(198)
	}
	
	ret = _docx_merge(file1, dest, rep, pgbreak, hffrom, pgrestart)
	if (ret < 0) {
		errprintf("failed to append files\n")
		if (ret==-3621) {
			exit(603)
		}
		else {
			exit(198)
		}
	}
	
	if(dest=="") {
		flist = tokens(filelist, ",")
		st_local(loc, flist[1])	
	}
	else {
		st_local(loc, dest)
	}
	
	st_local(save_mode, mode)
}

`RS' docx_table_resultset(`RS' doc_id, `RS' nrows, `RS' ncols, 
			  `SM' contents, `RS' addloc, `SS' hfname)
{
	`RS'		tid
	`RS'		i, j, ret
	
	tid = _docx_new_table(doc_id, nrows, ncols, addloc, hfname)
	if (tid < 0) {
		if (tid == -16515) {
		errprintf("maximum number of tables exceeded; limit 500\n")
			exit(198)
		}
		else if (tid == -16526) {
			errprintf("maximum number of columns exceeded; limit 63\n")
			exit(198)
		}
		else {
			errprintf("failed to add table\n")
			exit(198)
		}
	}
	
	for(i=1; i<=nrows; i++) {
		for(j=1; j<=ncols; j++) {
			ret = _docx_table_mod_cell(doc_id, tid, 
				i, j, contents[i,j], 0)
			if (ret < 0) {
				errprintf("failed to modify cell content\n")
				exit(198)
			}
		}
	}
	
	return(tid)
}

`RS' docx_add_scalars_table(`RS' doc_id, `RS' cls_type, `RS' scalar_type, 
			    `RS' addloc, `SS' hfname)
{
	`SC'		return_names, return_values
	`RS'		i, nrows, ncols, tid
	`SM'		contents
	
	if (cls_type == 1 & scalar_type == 1) {
		return_names = st_dir("r()", "numscalar", "*")
		nrows = rows(return_names)
		return_values = J(nrows, 1, "")
		for(i=1; i<=nrows; i++) {
			return_values[i] = "r(" + return_names[i] + ")"
			return_values[i] = 
				sprintf("%g", st_numscalar(return_values[i]))
		}
	}
	else if (cls_type == 2 & scalar_type == 1) {
		return_names = st_dir("e()", "numscalar", "*")
		nrows = rows(return_names)

		return_values = J(nrows, 1, "")
		for(i=1; i<=nrows; i++) {
			return_values[i] = "e(" + return_names[i] + ")"
			return_values[i] = 
				sprintf("%g", st_numscalar(return_values[i]))
		}
	}
	else if (cls_type == 1 & scalar_type == 2) {
		return_names = st_dir("r()", "macro", "*")
		nrows = rows(return_names)

		return_values = J(nrows, 1, "")
		for(i=1; i<=nrows; i++) {
			return_values[i] = "r(" + return_names[i] + ")"
			return_values[i] = 
				sprintf("%s", st_global(return_values[i]))
		}
	}
	else {
		return_names = st_dir("e()", "macro", "*")
		nrows = rows(return_names)

		return_values = J(nrows, 1, "")
		for(i=1; i<=nrows; i++) {
			return_values[i] = "e(" + return_names[i] + ")"
			return_values[i] = 
				sprintf("%s", st_global(return_values[i]))
		}
	}
	
	if (nrows == 0) {
		return(-2)
	}
	
	ncols = 2
	contents = J(nrows, ncols, "")
	contents[.,1] = return_names
	contents[.,2] = return_values
	
	tid = docx_table_resultset(doc_id, nrows, ncols, contents, addloc, hfname)
	
	return(tid)
}

`RC' docx_add_matrices_table(`RS' doc_id, `RS' cls_type, `RS' addloc, `SS' hfname)
{
	`SC'		return_names
	`SS'		cls_name, tmpname
	`RS'		i, ntables, rc, tid, nrows, ncols
	`RM'		return_matrix
	`SM'		contents
	`RC'		tids
	
	if (cls_type == 1) {
		return_names = st_dir("r()", "matrix", "*")
	}
	else {
		return_names = st_dir("e()", "matrix", "*")
	}
	
	ntables = rows(return_names)
	tids = J(ntables, 1, -1)
	for(i=1; i<=ntables; i++) {
		if (cls_type == 1) {
			cls_name = "r(" + return_names[i] + ")"
		}
		else {
			cls_name = "e(" + return_names[i] + ")"
		}
		tmpname = st_tempname()
		
		rc = _stata(sprintf("matrix define %s = %s", 
			tmpname, cls_name))
		if (rc) {
			exit(rc)
		}
		
		return_matrix = st_matrix(tmpname)
		nrows = rows(return_matrix)
		ncols = cols(return_matrix)
		ncols = ncols + 1
		contents = J(nrows, ncols, "")
		contents[1,1] = return_names[i]
		contents[(1::nrows), (2..ncols)] = 
			strofreal(return_matrix)

		tid = docx_table_resultset(doc_id, nrows, ncols, contents, addloc, hfname)
		tids[i] = tid
	}
	
	return(tids)
}

`RS' docx_resultset_ptable(`RS' doc_id, `RS' addloc, `SS' hfname) 
{
	`RS'		tid, ret 
	
	tid = _docx_new_table(doc_id, 1, 1, addloc, hfname) 
	if (tid < 0) {
		if (tid == -16515) {
		errprintf("maximum number of tables exceeded; limit 500\n")
			exit(198)
		}
		else {
			errprintf("failed to add table\n")
			exit(198)
		}
	}
	ret = _docx_table_set_cellmargin(doc_id, tid, "all", "nil", 1)
	if (ret < 0) {
		errprintf("failed to set cell margin\n")
		exit(198)
	}
	
	return(tid)
}

`RS' docx_add_resultset_wrk(`RS' restype, `RS' addloc, `SS' hfname)
{
	`RS'		doc_id, tid, tmptid1, tmptid2
	`RS'		ntables, ret, i, count
	`RC'		tids
	
	(void) docx_is_valid()
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
		
	tid = -1
	if (restype == 1) {
		tid = docx_add_scalars_table(doc_id, 2, 1, addloc, hfname)
		if (tid == -2) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
	}
	else if (restype == 2) {
		tid = docx_add_scalars_table(doc_id, 1, 1, addloc, hfname)
		if (tid == -2) {
			errprintf("no return results in memory\n")
			exit(198)
		}
	}
	else if (restype == 3) {
		tid = docx_add_scalars_table(doc_id, 2, 2, addloc, hfname)
		if (tid == -2) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
	}
	else if (restype == 4) {
		tid = docx_add_scalars_table(doc_id, 1, 2, addloc, hfname)
		if (tid == -2) {
			errprintf("no return results in memory\n")
			exit(198)
		}
	}
	else if (restype == 5) {
		tids = docx_add_matrices_table(doc_id, 2, addloc, hfname)
		ntables = rows(tids)
		if (ntables == 0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		
		tid = docx_resultset_ptable(doc_id, addloc, hfname)
		ret = _docx_table_mod_cell(doc_id, tid, 1, 1,
			"e-class matrices")
		ret = ret + _docx_cell_set_halign(doc_id, tid, 1, 1,
			"center")
		if (ret < 0) {
			errprintf("failed to modify cell content\n")
			exit(198)
		}
		
		for(i=1; i<=ntables; i++) {
			ret = _docx_table_add_row(doc_id, tid, i, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell_table(doc_id, tid,
				i+1, 1, 0, tids[i])
			ret = ret + _docx_cell_set_halign(doc_id, tid, i+1, 1,
				"center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
		}
	}
	else if (restype == 6) {
		tids = docx_add_matrices_table(doc_id, 1, addloc, hfname)
		ntables = rows(tids)
		if (ntables == 0) {
			errprintf("no return results in memory\n")
			exit(198)
		}
		
		tid = docx_resultset_ptable(doc_id, addloc, hfname)
		ret = _docx_table_mod_cell(doc_id, tid, 1, 1, 
			"r-class matrices")
		ret = ret + _docx_cell_set_halign(doc_id, tid, 1, 1,
			"center")
		if (ret < 0) {
		errprintf("failed to modify cell content\n")
			exit(198)
		}
		
		for(i=1; i<=ntables; i++) {
			ret = _docx_table_add_row(doc_id, tid, i, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell_table(doc_id, tid,
				i+1, 1, 0, tids[i])
			ret = ret + _docx_cell_set_halign(doc_id, tid, i+1, 1,
				"center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
		}
	}
	else if (restype == 7) {
		tmptid1 = docx_add_scalars_table(doc_id, 2, 1, addloc, hfname)
		tmptid2 = docx_add_scalars_table(doc_id, 2, 2, addloc, hfname)
		tids = docx_add_matrices_table(doc_id, 2, addloc, hfname)
		ntables = rows(tids)
		
		if (tmptid1==-2 & tmptid2==-2 & ntables==0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		
		tid = docx_resultset_ptable(doc_id, addloc, hfname)
		count = 0
		if (tmptid1 >= 0) {
			ret = _docx_table_mod_cell(doc_id, tid, 1, 1,
				"e-class scalars")
			ret = ret + _docx_cell_set_halign(doc_id, tid, 1, 1,
				"center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			count = count + 1
			
			ret = _docx_table_add_row(doc_id, tid, count, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell_table(doc_id, tid,
				count+1, 1, 0, tmptid1)
			ret = ret + _docx_cell_set_halign(doc_id, tid, 
				count+1, 1, "center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			count = count + 1
		}
		
		if (tmptid2 >= 0) {
			if (count == 0) {
				ret = _docx_table_mod_cell(doc_id, tid, 1, 1,
					"e-class macros")
				ret = ret + _docx_cell_set_halign(doc_id, tid, 
					1, 1, "center")
				if (ret < 0) {
			errprintf("failed to modify cell content\n")
					exit(198)
				}
				count = count + 1
			}
			else {
				ret = _docx_table_add_row(doc_id, tid, count, 1)
				if (ret < 0) {
				errprintf("failed to modify cell content\n")
					exit(198)
				}
				ret = _docx_table_mod_cell(doc_id, tid,
					count+1, 1, "e-class macros")
				ret = ret + _docx_cell_set_halign(doc_id, tid, 
					count+1, 1, "center")
				if (ret < 0) {
				errprintf("failed to modify cell content\n")
					exit(198)
				}
				count = count + 1
			}
			
			ret = _docx_table_add_row(doc_id, tid, count, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell_table(doc_id, tid,
				count+1, 1, 0, tmptid2)
			ret = ret + _docx_cell_set_halign(doc_id, tid, 
				count+1, 1, "center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			count = count + 1
		}
		
		if (ntables > 0) {
			ret = _docx_table_add_row(doc_id, tid, count, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell(doc_id, tid,
				count+1, 1, "e-class matrices")
			ret = ret + _docx_cell_set_halign(doc_id, tid, 
				count+1, 1, "center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			
			for(i=1; i<=ntables; i++) {
				ret = _docx_table_add_row(doc_id, tid, i+count, 1)
				if (ret < 0) {
			errprintf("failed to modify cell content\n")
					exit(198)
				}
				ret = _docx_table_mod_cell_table(doc_id, tid,
					i+count+1, 1, 0, tids[i])
				if (ret < 0) {
			errprintf("failed to modify cell content\n")
					exit(198)
				}
			}
		}
	}
	else if (restype == 8) {
		tmptid1 = docx_add_scalars_table(doc_id, 1, 1, addloc, hfname)
		tmptid2 = docx_add_scalars_table(doc_id, 1, 2, addloc, hfname)
		tids = docx_add_matrices_table(doc_id, 1, addloc, hfname)
		ntables = rows(tids)
		
		if (tmptid1==-2 & tmptid2==-2 & ntables==0) {
			errprintf("no return results in memory\n")
			exit(198)
		}		
		
		tid = docx_resultset_ptable(doc_id, addloc, hfname)
		count = 0
		if (tmptid1 >= 0) {
			ret = _docx_table_mod_cell(doc_id, tid, 1, 1,
				"r-class scalars")
			ret = ret + _docx_cell_set_halign(doc_id, tid, 
				1, 1, "center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			count = count + 1
			
			ret = _docx_table_add_row(doc_id, tid, count, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell_table(doc_id, tid,
				count+1, 1, 0, tmptid1)
			ret = ret + _docx_cell_set_halign(doc_id, tid, 
				count+1, 1, "center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			count = count + 1
		}
		
		if (tmptid2 >= 0) {
			if (count == 0) {
				ret = _docx_table_mod_cell(doc_id, tid, 1, 1,
					"r-class macros")
			ret = ret + _docx_cell_set_halign(doc_id, tid, 1, 1,
					"center")
				if (ret < 0) {
			errprintf("failed to modify cell content\n")
					exit(198)
				}
				count = count + 1
			}
			else {
				ret = _docx_table_add_row(doc_id, tid, count, 1)
				if (ret < 0) {
				errprintf("failed to modify cell content\n")
					exit(198)
				}
				ret = _docx_table_mod_cell(doc_id, tid,
					count+1, 1, "r-class macros")
				ret = ret + _docx_cell_set_halign(doc_id, tid, 
					count+1, 1, "center")
				if (ret < 0) {
				errprintf("failed to modify cell content\n")
					exit(198)
				}
				count = count + 1
			}
			
			ret = _docx_table_add_row(doc_id, tid, count, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell_table(doc_id, tid,
				count+1, 1, 0, tmptid2)
			ret = ret + _docx_cell_set_halign(doc_id, tid, count+1, 1,
				"center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			count = count + 1
		}
		
		if (ntables > 0) {
			ret = _docx_table_add_row(doc_id, tid, count, 1)
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			ret = _docx_table_mod_cell(doc_id, tid,
				count+1, 1, "r-class matrices")
			ret = ret + _docx_cell_set_halign(doc_id, tid, count+1, 1,
				"center")
			if (ret < 0) {
			errprintf("failed to modify cell content\n")
				exit(198)
			}
			
			for(i=1; i<=ntables; i++) {
				ret = _docx_table_add_row(doc_id, tid, i+count, 1)
				if (ret < 0) {
			errprintf("failed to modify cell content\n")
					exit(198)
				}
				ret = _docx_table_mod_cell_table(doc_id, tid,
					i+count+1, 1, 0, tids[i])
				ret = ret + _docx_cell_set_halign(doc_id, tid, 
					i+count+1, 1, "center")
				if (ret < 0) {
			errprintf("failed to modify cell content\n")
					exit(198)
				}
			}
		}
	}
	else {
		errprintf("invalid return type\n")
		exit(198)
	}
	
	return(tid)
}

void docx_add_etable_wrk(`RS' doc_id, `SS' tename, `SS' tetable, 
			`RS' addloc, `SS' width, `RS' headerrow,
			`SS' halign, `SS' indent, `SS' borders, 
			`SS' cellmargins, `SS' cellspacing, 
			`SS' layout, `SS' title, `SS' notes, `SS' hfname) 
{
	`RS'		i, etcount
	`ETIR'		etir
	`SR'		tetables	

	etcount = put_get_etable_count()
	if (etcount == 0) {
		if (st_global("e(cmd)") == "") {
			errprintf("last estimates not found\n")
			exit(301)
		}
		else {
			if (put_check_etable() != 0) {
errprintf("{bf:etable} is not supported for last estimation command\n")
				exit(198)
			}
			else {
errprintf("information for the estimation table not found;\n")
errprintf("{p 4 4 2}Please {helpb estcom##remarks19:replay} estimation results and try again{p_end}")
				exit(111)
			}
		}
	}
	
	if (tetable=="-1") {	
		etir = _etable_info(etcount)
		for(i=1; i<=etcount; i++) {
			if (etcount==1) {
				(void) put_get_etable_data(etir[i], i, tename)
			}
			else {
				(void) put_get_etable_data(etir[i], i, tename+strofreal(i))
			}
		}
	}
	else {
		tetables = tokens(tetable)
		for(i=1; i<=cols(tetables); i++) {
			if (strtoreal(tetables[i]) > etcount) {
errprintf("table index out of range;\n")
errprintf("{p 4 4 2}%g found where index value from 1 to %g were expected{p_end}", strtoreal(tetables[i]), etcount)
				exit(125)
			}
		}
		
		etcount = cols(tetables)
		etir = _etable_info(etcount)
		for(i=1; i<=etcount; i++) {
			if (etcount==1) {
				(void) put_get_etable_data(etir[i], strtoreal(tetables[i]), tename)
			}
			else {
(void) put_get_etable_data(etir[i], strtoreal(tetables[i]), tename+tetables[i])
			}
		}
	}

	(void) docx_add_etables(doc_id, etir, addloc, width, headerrow, halign, 
		indent, borders, cellmargins, cellspacing, layout, title, notes, hfname)
}

void docx_add_etables(`RS' doc_id, `ETIR' etir, `RS' addloc, `SS' width, 
		     `RS' headerrow, `SS' halign, `SS' indent, `SS' borders, 
		     `SS' cellmargins, `SS' cellspacing, `SS' layout, 
		     `SS' title, `SS' notes, `SS' hfname)
{
	`RS'			i, etcount, overcount
	`SS'			tnames, soverr, soverr2
	
	etcount = cols(etir)
	tnames = ""
	soverr2 = ""
	overcount = 0
	for(i=1; i<=etcount; i++) {
		soverr = _docx_table_get_info(doc_id, etir[i].tname)
		(void) docx_add_etable(doc_id, etir[i], addloc, width, 
			headerrow, halign, indent, borders, cellmargins, 
			cellspacing, layout, title, notes, hfname)
		tnames = tnames + " " + etir[i].tname
		if (bstrlen(soverr) != 0) {
			soverr2 = soverr2 + " " + etir[i].tname
			overcount = overcount + 1
		}
	}
	
	if (etcount > 1) {
		printf("{txt}(note: tables " + "{cmd:" + ustrtrim(tnames) + "} are added)\n")
	}
	if (bstrlen(soverr2) != 0) {
		if (overcount > 1) {
printf("{txt}(note: tables " + "{cmd:" + ustrtrim(soverr2) + "} have been redefined)\n")
		}
		else {
printf("{txt}(note: table " + "{cmd:" + ustrtrim(soverr2) + "} has been redefined)\n")		
		}
	}
}

void docx_add_etable(`RS' doc_id, `ETI' eti, `RS' addloc, `SS' width, 
		     `RS' headerrow, `SS' halign, `SS' indent, 
		     `SS' borders, `SS' cellmargins, `SS' cellspacing, 
		     `SS' layout, `SS' title, `SS' notes, `SS' hfname)
{
	`RS'		tid, nspan, halignv
	`RS'		i, j, nrow, ncol, ktitle
	
	(void) docx_is_valid()
	
	nrow = eti.nrow 
	ncol = eti.ncol 
	ktitle = eti.ktitle
	
	tid = _docx_new_table(doc_id, nrow, ncol, addloc, hfname)
	if (tid < 0) {
		if (tid == -16515) {
		errprintf("maximum number of tables exceeded; limit 500\n")
			exit(198)
		}
		else if (tid == -16526) {
			errprintf("maximum number of columns exceeded; limit 63\n")
			exit(198)
		}
		else {
			errprintf("failed to add table\n")
			exit(198)
		}
	}
	
	(void) _docx_table_set_name(doc_id, tid, eti.tname)			
	(void) _docx_table_set_border(doc_id, tid, "all", "nil", "000000")
	
	(void) docx_update(2)
	
	st_global("ST__DOCX_CUR_PARAGRAPH", "0")
	
	(void) docx_table_set_attr(doc_id, tid, eti.tname, width, 0, halign, 
				indent, borders, cellmargins, cellspacing, 
				layout, "", "")
	
	for(i=1; i<=nrow; i++) {
		for(j=1; j<=ncol; j++) {
			(void) _docx_table_mod_cell(doc_id, tid, i, j, eti.val[i, j])
			halignv = eti.halign[i, j]
			if (missing(halignv)) {
				(void) _docx_cell_set_halign(doc_id, tid, i, j, "right")
			}
			nspan = eti.hspan[i, j]
			if (!missing(nspan)) {
				(void) _docx_cell_set_colspan(doc_id, tid, i, j, nspan, 2)
			}
			if (i<=ktitle) {
				if (i==ktitle) {
					(void) _docx_cell_set_border(doc_id, tid, i, j, "bottom", "single", "000000")
				}
			}
			else {
				if (eti.vsep[1, i-ktitle]==1) {
					(void) _docx_cell_set_border(doc_id, tid, i, j, "top", "single", "000000")
				}
			}
			
			if (j==1) {
				(void) _docx_cell_set_border(doc_id, tid, i, j, "end", "single", "000000")
			}
			if (i==1) {
				(void) _docx_cell_set_border(doc_id, tid, i, j, "top", "single", "000000")
			}
			if (i==nrow) {
				(void) _docx_cell_set_border(doc_id, tid, i, j, "bottom", "single", "000000")
			}
		}
	}
	
	(void) put_etable_star1(eti, doc_id, tid)
	(void) docx_table_set_title_note(doc_id, tid, eti.tname, title, notes)
	(void) docx_table_set_headerrow(doc_id, tid, headerrow)
}

void docx_validate_header_footer(`RS' addloc, `SS' hfname)
{
    `RS'		doc_id, ret
    doc_id = strtoreal(st_global("ST__DOCX_ID"))
    ret = _docx_validate_header_footer(doc_id, addloc, hfname)
    if (ret < 0) {
    errprintf("invalid header or footer name\n")
        exit(198)
    }
}


void docx_set_pgnum(`SS' pgnumfmt)
{
	`RS'		doc_id, ret
	`PGNI' pgni
	
	doc_id = strtoreal(st_global("ST__DOCX_ID"))
	
	(void) docx_parse_pgnumfmt(pgnumfmt, pgni)
	ret = _docx_set_pgnum_format(doc_id, pgni.type, pgni.start, pgni.chapStyle, pgni.chapSep) 
	if (ret < 0) { 
errprintf("failed to set page number format\n")
		(void) docx_close_wrk()
		exit(198)
	}
} 

void docx_hdr_ftr_wrk(`SS' header, `SS' footer)
{
	`RS'		doc_id, ret

	doc_id = strtoreal(st_global("ST__DOCX_ID"))
    
	if(header != ""){
		ret = _docx_set_section_header(doc_id, header)
        if (ret < 0) {
        errprintf("failed to add header to document\n")
			(void) docx_close_wrk()
            exit(198)
        }
	}
	if(footer != ""){
		ret = _docx_set_section_footer(doc_id, footer)
        if (ret < 0) {
        errprintf("failed to add footer to document\n")
			(void) docx_close_wrk()
            exit(198)
        }
	}
}

void docx_parse_pgnumfmt(`SS' s, `PGNI' pgni)
{
	`TR' t
	`SS' tmpstr, token, fmttype, sstart, schapStyle, chapSep
	`RS' args, start, chapStyle
	
	tmpstr = docx_remove_paren(s)
	tmpstr = docx_process_options(tmpstr)
	
	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			fmttype = docx_remove_quote(token)
		}
		else if (args == 2) {
			sstart = docx_remove_quote(token)
		}
		else if (args == 3) {
			schapStyle = docx_remove_quote(token)
		}
		else if (args == 4) {
			chapSep = docx_remove_quote(token)
		}
		else if (args > 4) {
errprintf("too many arguments specified in option {bf:pagenum()}\n")
			(void) docx_close_wrk()
			exit(198)
		}
		args++
	}
	
	if (args < 2) {
	errprintf("too few arguments specified in option {bf:pagenum()}\n")
		(void) docx_close_wrk()
		exit(198)
	}
	
	fmttype = strtrim(fmttype)
	if(bstrlen(fmttype) > 0){
		if (fmttype != "cardinal_text" & fmttype != "decimal" & 
			fmttype != "decimal_enclosed_circle" & fmttype != "decimal_enclosed_fullstop" & 
			fmttype != "decimal_enclosed_paren" & fmttype != "decimal_zero" & 
			fmttype != "lower_letter" & fmttype != "lower_roman" & 
			fmttype != "none" & fmttype != "ordinal_text" & 
			fmttype != "upper_letter" & fmttype != "upper_roman"){
errprintf("invalid page number format specified in option {bf:pagenum()}\n")
			(void) docx_close_wrk()
			exit(198)
		}
		fmttype = strupper(fmttype)
	} 
	else { 
		fmttype = "" 
	}
	
	sstart = strtrim(sstart) 
	if(bstrlen(sstart) > 0){ 
		start = strtoreal(sstart) 
		if (missing(start) | start < 0){
errprintf("invalid starting page number specified in option {bf:pagenum()}\n")
			(void) docx_close_wrk()
			exit(198) 
		}
	}
	else {
		start = -1
	}
	
	schapStyle = strtrim(schapStyle)
	if(bstrlen(schapStyle) > 0){
		if (schapStyle != "Heading1" & schapStyle != "Heading2" &
			schapStyle != "Heading3" & schapStyle != "Heading4" &
			schapStyle != "Heading5" & schapStyle != "Heading6" &
			schapStyle != "Heading7" & schapStyle != "Heading8" &
			schapStyle != "Heading9") {
errprintf("invalid page number chapter style specified in option {bf:pagenum()}\n")
			(void) docx_close_wrk()
			exit(198)
		}
		chapStyle = strtoreal(bsubstr(schapStyle, 8, .))
	} 
	else {
		if(args == 4){
			chapStyle = 1
		}
		else {
			chapStyle = -1
		}
	}
	
	chapSep = strtrim(chapSep)
	if(bstrlen(chapSep) > 0){
		if(chapSep != "colon" & chapSep != "hyphen" &
			chapSep != "em_dash" & chapSep != "en_dash" &
			chapSep != "period") {
errprintf("invalid page number chapter separator specified in option {bf:pagenum()}\n")
			(void) docx_close_wrk()
			exit(198)
		}
		chapSep = strupper(chapSep)
	}
	else {
		if(args == 3 || args == 4){
			chapSep = "HYPHEN"
		}
		else {
			chapSep = ""
		}
	}
	
	pgni.type = fmttype
	pgni.start = start
	pgni.chapStyle = chapStyle
	pgni.chapSep = chapSep
}

void docx_fromhtml_wrk(`SS' file, `SS' savefile, `SS' basedir, `SS' replace)
{
	`SS'		dest
	`RS'		rep, ret
		
	rep = 0
	if (savefile != "") {
		dest = savefile
		rep = 0
		if (replace != "") {
			rep = 1
		}
		if (fileexists(dest) != 0 & rep == 0) {
			errprintf("file %s already exists\n", dest)
			errprintf("you must specify the {bf:replace} option\n")
			exit(198)
		}
	}
	
	ret = _docx_from_html(file, dest, basedir)
	if (ret < 0) {
		errprintf("failed to convert from HTML to docx\n")
		exit(198)
	}
}

void docx_tohtml_wrk(`SS' file, `SS' savefile, `SS' replace)
{
	`SS'		dest
	`RS'		rep, ret
		
	rep = 0
	if (savefile != "") {
		// dest = docx_check_filename(savefile, 0)
		dest = savefile
		rep = 0
		if (replace != "") {
			rep = 1
		}
		if (fileexists(dest) != 0 & rep == 0) {
			errprintf("file %s already exists\n", dest)
			errprintf("you must specify the {bf:replace} option\n")
			exit(198)
		}
	}
	
	ret = _docx_to_html(file, dest)
	if (ret < 0) {
		errprintf("failed to convert document to HTML\n")
		exit(198)
	}
}

void docx_topdf_wrk(`SS' file, `SS' savefile, `SS' replace)
{
	`SS'		dest
	`RS'		rep, ret
		
	rep = 0
	if (savefile != "") {
		// dest = docx_check_filename(savefile, 0)
		dest = savefile
		rep = 0
		if (replace != "") {
			rep = 1
		}
		if (fileexists(dest) != 0 & rep == 0) {
			errprintf("file %s already exists\n", dest)
			errprintf("you must specify the {bf:replace} option\n")
			exit(198)
		}
	}
	
	ret = _docx_to_pdf(file, dest)
	if (ret < 0) {
		errprintf("failed to convert document to PDF\n")
		exit(198)
	}
}

void docx_totext_wrk(`SS' file, `SS' savefile, `SS' replace)
{
	`SS'		dest
	`RS'		rep, ret
		
	rep = 0
	if (savefile != "") {
		// dest = docx_check_filename(savefile, 0)
		dest = savefile
		rep = 0
		if (replace != "") {
			rep = 1
		}
		if (fileexists(dest) != 0 & rep == 0) {
			errprintf("file %s already exists\n", dest)
			errprintf("you must specify the {bf:replace} option\n")
			exit(198)
		}
	}
	
	ret = _docx_to_text(file, dest)
	if (ret < 0) {
		errprintf("failed to convert document to text\n")
		exit(198)
	}
}

void docx_file_get_abspath(`SS' filename, `SS' loc)
{
	`SS' using_file
	
	using_file = docx_check_filename(filename, 0)
	(void)pathresolve(pwd(), using_file, loc) 
}
end
