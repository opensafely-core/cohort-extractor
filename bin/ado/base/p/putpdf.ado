*! version 1.2.9  10oct2019
program define putpdf
	local vv : di "version " string(_caller()) ":"
	version 15.0
	
	if `"`0'"' == `""' {
		di as err "subcommand required"
		exit 198
	}
	
	gettoken do 0 : 0, parse(" ,")
	local ldo = length("`do'")
	
	if "`do'" == bsubstr("begin",1,max(5,`ldo')) {
		pdf_begin `0'
		exit
	}
	else if "`do'" == bsubstr("paragraph",1,max(9,`ldo')) {
		`vv' pdf_paragraph `0'
		exit
	}	
	else if "`do'" == bsubstr("text",1,max(4,`ldo')) {
		pdf_text `0'
		exit
	}
	else if "`do'" == bsubstr("table",1,max(5,`ldo')) {
		`vv' pdf_table `0'
		exit
	}
	else if "`do'" == bsubstr("image",1,max(5,`ldo')) {
		pdf_image `0'
		exit
	}
	else if "`do'" == bsubstr("pagebreak",1,max(9,`ldo')) {
		`vv' pdf_pagebreak `0'
		exit
	}
	else if "`do'" == bsubstr("describe",1,max(8,`ldo')) {
		pdf_describe `0'
		exit
	}
	else if "`do'" == bsubstr("save",1,max(4,`ldo')) {
		local 0 `"using `0'"'
		`vv' pdf_save `0'
		exit
	}
	else if "`do'" == bsubstr("clear",1,max(5,`ldo')) {
		pdf_clear `0'
		exit
	}
	else if "`do'" == bsubstr("sectionbreak",1,max(12,`ldo')) {
		`vv' pdf_sectionbreak `0'
		exit
	}
	else {
		di as err `"unknown subcommand `do'"'
		exit 198
	}
end

program pdf_begin
	syntax [anything] [,font(string) PAGEsize(string)		///
			  LANDscape halign(string) bgcolor(string) *]
		
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
	
	mata: pdf_begin_wrk(`"`font'"', `"`pagesize'"', `"`landscape'"', ///
			    `"`margins'"', `"`halign'"', `"`bgcolor'"')
end

program pdf_paragraph
	syntax [anything] [,font(string) halign(string) valign(string) 	///
			   bgcolor(string) *]
	
	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}
	mata: pdf_is_valid()

	local indents
	local spacings
	
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
	
	mata: pdf_add_paragraph_wrk(`"`font'"', `"`halign'"', 		///
				    `"`valign'"', `"`indents'"',	/// 
				    `"`spacings'"', `"`bgcolor'"')
end

program pdf_text
	syntax anything(name=paraexplist id=paraexplist equalok) [, 	///
			font(string) bold italic script(string) 	///
			UNDERLine STRIKEout bgcolor(string) 		///
			NFORmat(string) linebreak(string) ALLCaps *]
	
	mata: pdf_is_valid()
	
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
	
	mata: pdf_paragraph_add_text_wrk(`"`font'"', 			///
					 `"`bold'"', `"`italic'"', 	///
					 `"`script'"', `"`underline'"', ///
					 `"`strikeout'"', `"`bgcolor'"', ///
					 `linebreaks', `"`nformat'"', 	///
					 `"`allcaps'"')
end

program pdf_image
	syntax anything(name=filenm id=file)				///
		[,Width(string) Height(string) linebreak(string) *]

	mata: pdf_is_valid()

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

	mata: pdf_paragraph_add_image_wrk(`"`filenm'"', `"`width'"', 	///
		`"`height'"', `linebreaks')
end

program pdf_table
	syntax [anything(equalok)] [if] [in] [, *]
	
	mata: pdf_is_valid()
	
	local tblinfo `0'
	if strpos(`"`tblinfo'"', "=") == 0 {
		local tblinfo `"`anything'"'				
		pdf_table_set `tblinfo', `options'
	}
	else {
		local tblinfo `"`anything'"'
		gettoken tblspec : 0, parse("= ")
		if strpos(`"`tblspec'"', "(") == 0 {
			pdf_add_table `0'
		}
		else {
			pdf_table_set `tblinfo', `options'
		}
	}
end

program pdf_table_set_cell
	syntax anything(name=cellexplist id=cellexplist equalok) [,	///
				font(string) bold italic halign(string) ///
				valign(string) UNDERLine STRIKEout 	///
				bgcolor(string) script(string) 		///
				rowspan(real 1) colspan(real 1)  	///
				span(string) append NFORmat(string) 	///
				linebreak(string) ALLCaps *]
				
	if (`"`rowspan'"' != "1" & `"`span'"' != "") {
		opts_exclusive "rowspan() span()"
		exit 198
	}
	if (`"`colspan'"' != "1" & `"`span'"' != "") {
		opts_exclusive "colspan() span()"
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
	local borders
	local margins
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) margin(passthru) linebreak *]
	while !missing(`"`border'`margin'`linebreak'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		
		if !missing(`"`margin'"') {
			local margins `margins' `margin'
		}
		
		if !missing(`"`linebreak'"') {
			local ++linebreaks
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) margin(passthru) linebreak *]
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

	mata: pdf_table_set_cell_wrk(`"`font'"', `"`bold'"', 		///
				     `"`italic'"', `"`script'"',	///
				     `"`underline'"', `"`strikeout'"',	///
				     `"`halign'"', `"`valign'"',	///
				     `"`bgcolor'"', `"`borders'"', 	///
				     `"`margins'"', `rowspan',		///
				     `colspan', `"`span'"',		///
				     `"`append'"', `"`nformat'"', 	///
				     `linebreaks', `"`allcaps'"')
end

program pdf_table_set_row
	syntax anything [, NOSPlit addrows(string) drop			///
				font(string) bold italic		///
				halign(string) valign(string) 		///
				bgcolor(string)				///
				UNDERLine STRIKEout 			///
				NFORmat(string) ALLCaps *]
	
	if (`"`nosplit'"' != "" & `"`drop'"' != "") {
		opts_exclusive "nosplit drop"
		exit 198
	}
	if (`"`addrows'"' != "" & `"`drop'"' != "") {
		opts_exclusive "addrows() drop"
		exit 198
	}
	
	local borders
	local margins
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) margin(passthru) *]
	while !missing(`"`border'`margin'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		
		if !missing(`"`margin'"') {
			local margins `margins' `margin'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) margin(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	mata: pdf_table_set_row_wrk(`"`anything'"', `"`nosplit'"',	///
				    `"`addrows'"', `"`drop'"',		///
				    `"`font'"',	`"`bold'"', 		///
				    `"`italic'"',		 	///
				    `"`underline'"', `"`strikeout'"',	///
				    `"`halign'"', `"`valign'"',		///
				    `"`bgcolor'"', `"`borders'"',	///
				    `"`margins'"', `"`nformat'"', 	///
				    `"`allcaps'"')
end

program pdf_table_set_col
	syntax anything [, addcols(string) drop				///
				font(string) bold italic		///
				halign(string) valign(string) 		///
				bgcolor(string)				///
				UNDERLine STRIKEout 			///
				NFORmat(string) ALLCaps *]
	
	if (`"`addcols'"' != "" & `"`drop'"' != "") {
		opts_exclusive "addcols() drop"
		exit 198
	}
	
	local borders
	local margins
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) margin(passthru) *]
	while !missing(`"`border'`margin'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		
		if !missing(`"`margin'"') {
			local margins `margins' `margin'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) margin(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	mata: pdf_table_set_column_wrk(`"`anything'"', `"`addcols'"',	///
				       `"`drop'"',			///
				       `"`font'"',	`"`bold'"', 	///
				       `"`italic'"',			///
				       `"`underline'"', `"`strikeout'"', ///
				       `"`halign'"', `"`valign'"',	///
				       `"`bgcolor'"', `"`borders'"',	///
				       `"`margins'"', `"`nformat'"', 	///
				       `"`allcaps'"')
end

program pdf_table_set_cell_range
	syntax anything [, font(string) bold italic			///
			   halign(string) valign(string) 		///
			   bgcolor(string)				///
			   UNDERLine STRIKEout 				///
			   NFORmat(string) rrange(string)		///
			   crange(string) ALLCaps *]
	
	local borders
	local margins
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) margin(passthru) *]
	while !missing(`"`border'`margin'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		
		if !missing(`"`margin'"') {
			local margins `margins' `margin'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) margin(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	mata: pdf_table_set_cell_range_wrk(`"`anything'"', `"`rrange'"', ///
					`"`crange'"',  `"`font'"',	///
					`"`bold'"', `"`italic'"',	///
					`"`underline'"', `"`strikeout'"', ///
					`"`halign'"', `"`valign'"',	///
					`"`bgcolor'"', `"`borders'"',	///
					`"`margins'"', `"`nformat'"', 	///
					`"`allcaps'"')
end

program pdf_table_set
	syntax [anything(equalok)] [, *]

	mata: pdf_is_valid()
	
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
		
		mata: pdf_table_parse_cell("pdf_tname", 	/// 
			"pdf_trow", "pdf_tcol", 		///
			"pdf_trows", "pdf_tcols", `"`tblinfo'"')
		
		if `"`pdf_trow'"' == "" {
		di as err "invalid specification; row misspecified"
			exit 198
		}
		if `"`pdf_tcol'"' == "" {
		di as err "invalid specification; column misspecified"
			exit 198
		}
		
		if `"`pdf_trow'"' != "." & `"`pdf_tcol'"' != "." {
			pdf_table_set_cell `tblinfo', `options'
		}
		else if `"`pdf_trow'"' != "." & `"`pdf_tcol'"' == "." {
			local tblinfo "`pdf_trow'_`pdf_tname'"
			pdf_table_set_row `tblinfo', `options'
		}
		else if `"`pdf_trow'"' == "." & `"`pdf_tcol'"' != "." {
			local tblinfo "`pdf_tcol'_`pdf_tname'"
			pdf_table_set_col `tblinfo', `options'
		}
		else {
			local options `options' 		///
				rrange(`"`pdf_trows'"')	///
				crange(`"`pdf_tcols'"')
			pdf_table_set_cell_range `tblinfo', `options'
		}
	}
	else {
		local tblinfo `"`anything'"'				
		pdf_table_set_cell `tblinfo', `options'
	}
end

program pdf_add_table_matrix
	syntax [anything(equalok)] [,MEMtable 				///
				    halign(string) indent(string) 	///
				    NFORmat(string) rownames colnames 	///
				    title(string) *]
	
	local spacings
	local borders
	local widths
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) spacing(passthru) width(passthru) 	///
		note(passthru) *]
	while !missing(`"`border'`spacing'`width'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`spacing'"') {
			local spacings `spacings' `spacing'
		}
		if !missing(`"`width'"') {
			local widths `widths' `width'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) spacing(passthru) width(passthru) ///
			note(passthru) *]
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
	
	mata: pdf_add_table_wrk(`"`tblspec'"', `"`memtable'"', 		/// 
				`"`widths'"', `"`halign'"', `"`indent'"', ///
				`"`spacings'"', `"`borders'"', "", "", 	///
				`"`title'"', `"`notes'"')
end

program pdf_add_table_data
	syntax [anything(equalok)] [if] [in] [,MEMtable 		///
					      halign(string) indent(string) ///
					      varnames obsno 		///
					      title(string) *]

	local spacings
	local borders
	local widths
	local notes
	
	local myif `if'
	local myin `in'
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) spacing(passthru) width(passthru) 	///
		note(passthru) *]
	while !missing(`"`border'`spacing'`width'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`spacing'"') {
			local spacings `spacings' `spacing'
		}
		if !missing(`"`width'"') {
			local widths `widths' `width'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) spacing(passthru) width(passthru) ///
			note(passthru) *]
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
		di as err "syntax error"
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
	
	mata: pdf_add_table_wrk(`"`tblspec'"', `"`memtable'"', 		/// 
				`"`widths'"', `"`halign'"', `"`indent'"', ///
				`"`spacings'"', `"`borders'"', 		///
				`"`myif'"', `"`myin'"',			///
				`"`title'"', `"`notes'"')
end

program pdf_add_table_mata
	syntax [anything(equalok)] [,MEMtable 				///
				    halign(string) indent(string) 	///
				    NFORmat(string) 			///
				    title(string) *]
	
	local spacings
	local borders
	local widths
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) spacing(passthru) width(passthru) 	///
		note(passthru) *]
	while !missing(`"`border'`spacing'`width'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`spacing'"') {
			local spacings `spacings' `spacing'
		}
		if !missing(`"`width'"') {
			local widths `widths' `width'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) spacing(passthru) width(passthru) ///
			note(passthru) *]
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
	
	mata: pdf_add_table_wrk(`"`tblspec'"', `"`memtable'"', 		/// 
				`"`widths'"', `"`halign'"', `"`indent'"', ///
				`"`spacings'"', `"`borders'"', "", "",	///
				`"`title'"', `"`notes'"')
end

program pdf_add_table_etable
	syntax [anything(equalok)] [,MEMtable 			///
				    halign(string) indent(string) 	///
				    title(string) *]
	
	local spacings
	local borders
	local widths
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) spacing(passthru) width(passthru) 	///
		note(passthru) *]
	while !missing(`"`border'`spacing'`width'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`spacing'"') {
			local spacings `spacings' `spacing'
		}
		if !missing(`"`width'"') {
			local widths `widths' `width'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) spacing(passthru) width(passthru) ///
			note(passthru) *]
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
	
	mata: pdf_add_table_wrk(`"`tblspec'"', `"`memtable'"', 		/// 
				`"`widths'"', `"`halign'"', `"`indent'"', ///
				`"`spacings'"', `"`borders'"', "", "", 	///
				`"`title'"', `"`notes'"')
end

program pdf_add_table_other
	syntax [anything(equalok)] [,MEMtable 			///
				    halign(string) indent(string) 	///
				    title(string) *]
	
	local spacings
	local borders
	local widths
	local notes
	
	local 0 `anything', `options' 
	local 0 , `options' 
	syntax , [BORDer(passthru) spacing(passthru) width(passthru) 	///
		note(passthru) *]
	while !missing(`"`border'`spacing'`width'`note'"') {
		if !missing(`"`border'"') {
			local borders `borders' `border'
		}
		if !missing(`"`spacing'"') {
			local spacings `spacings' `spacing'
		}
		if !missing(`"`width'"') {
			local widths `widths' `width'
		}
		if !missing(`"`note'"') {
			local notes `notes' `note'
		}
		local 0 , `options' 
		syntax , [BORDer(passthru) spacing(passthru) width(passthru) ///
			note(passthru) *]
	}
	
	if `"`options'"' != "" {
		di as err "option " `"{bf:`options'}"' " not allowed"
		exit 198
	}
	
	local tblspec `anything'
	mata: pdf_add_table_wrk(`"`tblspec'"', `"`memtable'"', 		/// 
				`"`widths'"', `"`halign'"', `"`indent'"', ///
				`"`spacings'"', `"`borders'"', "", "",	///
				`"`title'"', `"`notes'"')
end

program pdf_add_table
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
		pdf_add_table_matrix `0'
	}
	else if strpos(`"`tblexp'"', "data(") != 0 {
		local 0 `anything' `if' `in', `options'
		pdf_add_table_data `0'
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
		pdf_add_table_mata `0'
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
		pdf_add_table_etable `0'		
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
		pdf_add_table_other `0'
	}
end

program pdf_pagebreak
	syntax [anything]
	
	mata: pdf_is_valid()
	
	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}

	mata: pdf_add_pagebreak_wrk()
end

program pdf_sectionbreak
	syntax [anything] [,font(string) PAGEsize(string)		///
			  LANDscape halign(string) bgcolor(string) *]
		
	mata: pdf_is_valid()
	
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
	
	mata: pdf_add_sectionbreak_wrk(`"`font'"', `"`pagesize'"', 	///
		`"`landscape'"', `"`margins'"', `"`halign'"', `"`bgcolor'"')
end

program pdf_describe, rclass
	syntax [anything]
	
	if `"`anything'"' != "" {
		gettoken tblnm 0 : 0, parse(" ,")
		if `"`0'"' != "" {
			di as err "invalid " `"`0'"'
			exit 198
		}
		
		mata: pdf_describe_wrk(`"`tblnm'"', 1)
	}
	else {
		mata: pdf_describe_wrk("", 0)
	}
end

program pdf_clear
	syntax [anything]

	if `"`anything'"' != "" {
		di as err "syntax error"
		exit 198
	}
	
	mata: pdf_clear_wrk()
end

program pdf_save
	syntax using / [,replace nomsg] 

	mata: pdf_save_wrk(`"`using'"', `"`replace'"')
	if "`msg'" == "" {
		local destfile ""
		capture mata:(void)pdf_file_get_abspath("`using'", "destfile")
		if _rc == 0 {
			if "`destfile'" != "" {
di in smcl `"successfully created {browse "`destfile'":"`destfile'"}"' 						
			}
		}
	}	
end

version 15.0

local CI	struct color_info scalar
local FTI 	struct font_info scalar
local IMI 	struct image_info scalar
local II 	struct indent_info scalar
local SPI 	struct spacing_info scalar
local MI 	struct margin_info scalar
local TWI	struct tbl_width_info scalar
local TBI 	struct tbl_border_info scalar
local TCCI 	struct tbl_cell_content_info scalar
local ETI	struct _etable_info scalar

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

local CPTS	class PdfText scalar
local CPPS	class PdfParagraph scalar
local CPTBLS 	class PdfTable scalar
local PdfGlobal	class PdfDocument scalar
local CPTBLSRC	class PdfTable colvector

local pDocument pointer(`PdfGlobal')
local pParagraph pointer(`CPPS')
local pTable	pointer(`CPTBLS')

mata:
mata set matastrict on

struct color_info {
	`RS'			r
	`RS'			g
	`RS' 			b
}

struct font_info {
	`SS' 			name
	`RS'			size
	pointer(`CI') scalar 	color
}

struct image_info {
	`SS' 			filepath
	`RS'			cx
	`RS'			cy
}

struct indent_info {
	`SS'			type
	`RS'			value
}

struct spacing_info {
	`SS'			type
	`RS'			value
}

struct margin_info {
	`SS'			type
	`RS'			value
}

struct tbl_width_info {
	`RS'			type
	`RR'			widths
}

struct tbl_border_info {
	`SS'			border
	`RS'			width
	pointer(`CI') scalar 	color
}

struct tbl_cell_content_info {
	`RS'			row
	`RS'			col
	`RS'			type
	`SS'			exp
	`SS'			table
	`SS'			image
}

`SS' pdf_remove_quote(`SS' value)
{
	if (strpos(value, `"""') > 0) {
		value = subinstr(value, `"""', "")
	}
	
	return(value)
}

`SS' pdf_remove_double_quote(`SS' value)
{
	`SS'			tmpstr, s1, s2
	`RS'			slen
	
	tmpstr = pdf_remove_paren(value)
	tmpstr = pdf_process_options(tmpstr)
	s1 = bsubstr(tmpstr,1,1)
	slen = strlen(tmpstr)
	s2 = bsubstr(tmpstr,slen,1)
	
	if (s1==`"""' & s2==`"""') {
		tmpstr = bsubstr(tmpstr,2,slen-2)
	}
	return(tmpstr)
}

`SS' pdf_remove_paren(`SS' value)
{
	`SS'			rev

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

`RS' pdf_check_paren(`SS' expression)
{
	if (bsubstr(expression, 1, 1) != "(") {
		return(1)
	}
	if (bsubstr(expression, strlen(expression), 1) != ")") {
		return(1)
	}
	
	return(0)
}

`SS' pdf_process_options(`SS' s)
{
	`SR'			opts
	`RS'			i, nopts
	`SS'			sret
	
	opts = tokens(s, ",")
	nopts = cols(opts)
	
	sret = ""
	for(i=1; i<=nopts; i++) {
		if (i==1 & strtrim(opts[i]) == ",") {
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

void pdf_is_valid()
{
	`SS' 			sid
	`RS'			pid

	sid = st_global("ST__PDF_ID")
	if (bstrlen(sid) == 0) {
		errprintf("document not created\n")
		exit(198)
	}
	
	pid = strtoreal(sid)
	if (pid < 0) {
		errprintf("document not opened\n")
		exit(198)
	}
}

`RR' pdf_get_table_info(`SS' tblname)
{
	`SS'			sret
	`RR'			tinfo
	`SR'			stinfo
	`RS'			tlen
	`pTable' 		tbl
	`pDocument' scalar	pDoc
	
	tinfo = J(1,3,.)
	
	pDoc = findexternal("pdf__global")
	tbl = pDoc->gettbl(tblname)
	if (tbl == NULL) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)
	}
	
	sret = tbl->getInfo()
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

`RS' pdf_check_table_name(`SS' tblname)
{
	`RS'			boverr
	`pTable' 		tbl
	`pDocument' scalar	pDoc
	
	boverr = 0
	pDoc = findexternal("pdf__global")
	tbl = pDoc->gettbl(tblname)
	if (tbl != NULL) {
		boverr = 1
	}
	
	return(boverr)
}

void pdf_update(`RS' type)
{
	`RS'			ntables, nparas
	`SS'			tmpstr
	
	(void) pdf_is_valid()
	
	if (type == 1) {
		nparas = strtoreal(st_global("ST__PDF_NO_PARAGRAPHS"))
		nparas = nparas + 1
		tmpstr = sprintf("%g", nparas)
		st_global("ST__PDF_NO_PARAGRAPHS", tmpstr)
	}
	else {
		ntables = strtoreal(st_global("ST__PDF_NO_TABLES"))
		ntables = ntables + 1
		tmpstr = sprintf("%g", ntables)
		st_global("ST__PDF_NO_TABLES", tmpstr)
	}
}

`RS' pdf_parse_color(`SS' s, `CI' ci) 
{
	`RR'			rcolor
	
	rcolor = put_get_rgb_color(s)
	if (hasmissing(rcolor)) {
		return(0)
	}
	ci.r = rcolor[1]
	ci.g = rcolor[2]
	ci.b = rcolor[3]
	
	return(1)
}

void pdf_parse_font(`SS' s, `FTI' fti, `pDocument' pDoc)
{
	`TR'			t
	`SS'			tmpstr, token, sname, ssize, scolor
	`RS'			args, size
	`CI'			color

	tmpstr = pdf_remove_paren(s)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	sname = ""
	ssize = ""
	scolor = ""
	size = 0

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			sname = pdf_remove_quote(token)
		}
		else if (args == 2) {
			ssize = pdf_remove_quote(token)
		}
		else if (args == 3) {
			scolor = pdf_remove_quote(token)
		}
		else if (args > 3) {
	errprintf("too many arguments specified in option {bf:font()}\n")
			if (pDoc) {
				(void) pdf_close_wrk(pDoc)
			}
			exit(198)
		}
		args++
	}
	
	sname = strtrim(sname)
	ssize = strtrim(ssize)
	if (bstrlen(ssize) > 0) {
		size = strtoreal(ssize)
		if (missing(size) | size <= 0) {
	errprintf("invalid font size specified in option {bf:font()}\n")
			if (pDoc) {
				(void) pdf_close_wrk(pDoc)
			}
			exit(198)
		}
	}

	fti.color = J(1,1,NULL)
	scolor = strtrim(scolor)
	if (bstrlen(scolor) > 0) {
		if (pdf_parse_color(scolor, color)==0) {
	errprintf("invalid font color specified in option {bf:font()}\n")
			if (pDoc) {
				(void) pdf_close_wrk(pDoc)
			}
			exit(198)
		}
		fti.color = &color
	}

	fti.name = sname
	fti.size = size
}

void pdf_parse_indent(`SS' s, `II' ii)
{
	`TR'			t
	`SS'			tmpstr, token, stype, svalue
	`RS'			args, value

	tmpstr = pdf_remove_paren(s)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	stype = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t) 
		if (args == 1) {
			stype = pdf_remove_quote(token)
		}
		else if (args == 2) {
			svalue = pdf_remove_quote(token)
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
		tmpstr != "firstline") {
	errprintf("invalid indent type specified in option {bf:indent()}\n")
		exit(198)
	}

	
	value = put_get_points(strtrim(svalue))
	if (value < 0) {
	errprintf("invalid indent value specified in option {bf:indent()}\n")
		exit(198)
	}

	ii.type = tmpstr 
	ii.value = value
}

void pdf_parse_spacing(`SS' s, `SPI' spi, `RS' user)
{
	`TR'			t
	`SS'			tmpstr, token, stype, svalue
	`RS'			args, value

	tmpstr = pdf_remove_paren(s)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	stype = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			stype = pdf_remove_quote(token)
		}
		else if (args == 2) {
			svalue = pdf_remove_quote(token)
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

	if (user==1) {
		tmpstr = strtrim(stype)
		if (tmpstr != "line" & tmpstr != "before" & tmpstr != "after") {
	errprintf("invalid spacing type specified in option {bf:spacing()}\n")
			exit(198)
		}
	}
	else {
		tmpstr = strtrim(stype)
		if (tmpstr != "before" & tmpstr != "after") {
	errprintf("invalid spacing type specified in option {bf:spacing()}\n")
			exit(198)
		}		
	}

	value = put_get_points(strtrim(svalue))
	if (value < 0) {
	errprintf("invalid spacing value specified in option {bf:spacing()}\n")
		exit(198)
	}

	spi.type = tmpstr 
	spi.value = value
}

void pdf_parse_margin(`SS' s, `MI' mi, `PdfDocument' pDoc)
{
	`TR'			t
	`SS'			tmpstr, token, stype, svalue
	`RS'			args, value

	tmpstr = pdf_remove_paren(s)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	stype = ""
	svalue = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			stype = pdf_remove_quote(token)
		}
		else if (args == 2) {
			svalue = pdf_remove_quote(token)
		}
		else if (args > 2) {
	errprintf("too many arguments specified in option {bf:margin()}\n")
			if (pDoc) {
				(void) pdf_close_wrk(pDoc)
			}
			exit(198)
		}
		args++
	}
	
	if (args < 3) {
	errprintf("too few arguments specified in option {bf:margin()}\n")
		if (pDoc) {
			(void) pdf_close_wrk(pDoc)
		}
		exit(198)		
	}
	
	stype = strtrim(stype)
	if (stype != "top" & stype != "bottom" & stype != "left" & 
		stype != "right" & stype != "all") {
	errprintf("invalid margin type specified in option {bf:margin()}\n")
		if (pDoc) {
			(void) pdf_close_wrk(pDoc)
		}
		exit(198)
	}

	value = put_get_points(strtrim(svalue))
	if (value < 0) {
	errprintf("invalid margin value specified in option {bf:margin()}\n")
		if (pDoc) {
			(void) pdf_close_wrk(pDoc)
		}
		exit(198)
	}

	mi.type = stype
	mi.value = value
}

void pdf_parse_table_width(`SS' s, `TWI' twi)
{
	`RS'			tw, rc, i
	`RR'			colw
	`RM'			colm
	`SS'			tmpname, tmpstr

	s = strtrim(s)
	tw = put_get_points(s, 1)
	
	if (tw < 0) {
		tmpname = st_tempname() 
		rc = _stata(sprintf("matrix define %s = %s", tmpname, s), 1)
		if (rc) {
		errprintf("option {bf:width()} specified incorrectly\n")
			exit(198)
		}
		else {
			tmpstr = "confirm matrix " + tmpname
			rc = _stata(tmpstr)
			if (rc) {
				exit(rc)
			}
			
			colm = st_matrix(tmpname)
			if (rows(colm) != 1) {
		errprintf("option {bf:width()} specified incorrectly\n")
				exit(198)
			}
			
			for(i=1; i<=cols(colm); i++) {
				if (colm[i] <= 0) {
		errprintf("option {bf:width()} specified incorrectly\n")
					exit(198)					
				}
			}
			
			if (sum(colm) != 100) {
errprintf("sum of the column width must be equal to 100 in option {bf:width()}\n")
				exit(198)
			}
			
			colw = colm/100
			twi.type = 2 
			twi.widths = colw
		}
	}
	else {
		if (tw == 0) {
		errprintf("option {bf:width()} specified incorrectly\n")
			exit(198)
		}
		if (strpos(s, "%") > 0) {
			if (tw < 0 | tw > 100) {
		errprintf("option {bf:width()} specified incorrectly\n")
				exit(198)
			}
			
			colw = J(1,1,.)
			colw[1,1] = tw
			twi.type = 3
			twi.widths = colw
		}
		else {
			colw = J(1,1,.)
			colw[1,1] = tw
			twi.type = 1 
			twi.widths = colw
		}
	}
}

void pdf_parse_border(`SS' s, `TBI' tbi, `RS' type)
{
	`TR'			t
	`SS'			tmpstr, token, bname, bpattern, scolor
	`SS'			lbname
	`RS'			args, width
	`CI'			color

	tmpstr = pdf_remove_paren(s)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	bname = ""
	bpattern = ""
	scolor = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t) 
		if (args == 1) {
			bname = pdf_remove_quote(token)
		}
		else if (args == 2) {
			bpattern = pdf_remove_quote(token)
		}
		else if (args == 3) {
			scolor = pdf_remove_quote(token)
		}
		else if (args > 3) {
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
	if (lbname == "start") {
		lbname = "left"
	}
	if (lbname == "end") {
		lbname = "right"
	}
	
	bpattern = strtrim(bpattern)
	if (bstrlen(bpattern) != 0) {
		if (bpattern != "nil" & bpattern != "single") {
	errprintf("invalid border pattern specified in option {bf:border()}\n")
			exit(198)
		}
		if (bpattern == "nil") {
			width = 0
		}
		else {
			width = 1
		}
	}
	else {
		width = 1
	}
	
	tbi.color = J(1,1,NULL)
	scolor = strtrim(scolor)
	if (bstrlen(scolor) != 0) {
		if (pdf_parse_color(scolor, color)==0) {
	errprintf("invalid color specified in option {bf:border()}\n")
			exit(198)
		}
		tbi.color = &color
	}	

	tbi.border = lbname
	tbi.width = width
}

void pdf_parse_image(`SS' s)
{
	`SS'			filepath, quote, ext
	`RS'			rc

	filepath = pdf_remove_paren(s)
	filepath = pdf_process_options(filepath)

	filepath = strtrim(filepath)
	if (bstrlen(filepath) == 0) {
		errprintf("image file required\n")
		exit(100)
	}
	
	filepath = pdf_remove_quote(filepath)
	ext = pathsuffix(filepath)
	if (ext == "") {
		errprintf("image type not supported\n")
		exit(198)
	}
	else {
		ext = strlower(ext)
		if (ext != ".png" & ext != ".jpg" & ext != ".jpeg") {
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
}

`SS' pdf_check_filename(`SS' filename, `RS' check_exist)
{
	`SS'			using_file
	`SS'			basename, HoldPWD
	`SS'			file, path, ext 
	`RS'			rc 
	
	using_file = filename
	basename = pathbasename(using_file)
	
	if (basename == "") {
		errprintf("%s is not a pdf file\n", using_file)
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
		using_file = using_file + ".pdf"
	}
	else {
		ext = strlower(ext)
		if (ext != ".pdf") {
			errprintf("%s is not a pdf file\n", using_file)
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

void pdf_set_margin_wrk(`pDocument' pDoc, `SS' marginstr)
{
	`TR'			t
	`SS'			token, mstr, mtype
	`MI' 			mi
	
	t = tokeninit(" ", "margin", `"()"')
	tokenset(t, marginstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "margin") {
			mstr = tokenpeek(t)
			if (pdf_check_paren(mstr)) {
				errprintf("%s must be enclosed in ()\n", mstr)
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) pdf_parse_margin(token, mi, pDoc)
				
				mtype = strlower(mi.type)
				if (mtype=="left") {
					pDoc->setMargins2(mi.value, ., ., .)
				}
				else if (mtype=="right") {
					pDoc->setMargins2(., ., mi.value, .)
				}
				else if (mtype=="top") {
					pDoc->setMargins2(., mi.value, ., .)
				}
				else if (mtype=="bottom") {
					pDoc->setMargins2(., ., ., mi.value)
				}
				else {
					pDoc->setMargins2(mi.value, mi.value, 
						mi.value, mi.value)
				}
				if (pDoc->getLastError()) {
					errprintf("failed to set margin\n")
					(void) pdf_close_wrk(pDoc)
					exit(198)
				}
			}
		}
		else {
			errprintf("%s: invalid options\n", token)
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
}

void pdf_set_wrk(`pDocument' pDoc, `SS' font, `SS' pagesize, 
		 `SS' landscape, `SS' margins, `SS' halign, 
		 `SS' bgcolor)
{
	`FTI'			fti
	`CI' 			color
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, pDoc)
		if (fti.name != "") {
			pDoc->setFont(fti.name, "regular")
			if (pDoc->getLastError()) {
				errprintf("failed to set font\n")
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
		}
		if (fti.size) {
			pDoc->setFontSize(fti.size)
			if (pDoc->getLastError()) {
				errprintf("failed to set font size\n")
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
		}
		if (fti.color != J(1,1,NULL)) {
			pDoc->setColor(fti.color->r, fti.color->g, 
				fti.color->b)
			if (pDoc->getLastError()) {
				errprintf("failed to set font color\n")
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
		}		
	}
	else {
		pDoc->setFontSize(11)
		if (pDoc->getLastError()) {
			errprintf("failed to set font size\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	
	if (pagesize != "") {
		pagesize = strtrim(pagesize)
		if (pagesize!="letter" & pagesize!="legal" & 
			pagesize!="A3" & pagesize!="A4" & 
			pagesize!="A5" & pagesize!="B4" & pagesize!="B5") {
		errprintf("option {bf:pagesize()} specified incorrectly\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}	
	}
	else {
		pagesize = "letter"
	}
	pDoc->setPageSize(pagesize)
	if (pDoc->getLastError()) {
		errprintf("failed to set page size\n")
		(void) pdf_close_wrk(pDoc)
		exit(198)
	}
	
	if (landscape != "") {
		pDoc->setLandscape(1)
		if (pDoc->getLastError()) {
			errprintf("failed to set orientation\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	
	if (margins != "") {
		(void) pdf_set_margin_wrk(pDoc, margins)
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		if (halign!="left" & halign!="right" & halign!="center") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)	
		}
		pDoc->setHAlignment(halign)		
	}
	
	if (bgcolor != "") {
		if (strpos(bgcolor, ",")!=0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		if (pdf_parse_color(bgcolor, color)==0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		pDoc->setBgColor(color.r, color.g, color.b)
		if (pDoc->getLastError()) {
			errprintf("failed to set background color\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
}

void pdf_begin_wrk(`SS' font, `SS' pagesize, `SS' landscape, 
		   `SS' margins, `SS' halign, `SS' bgcolor)
{
	`pDocument' scalar	pDoc
	
	if ((pDoc = findexternal("pdf__global")) != NULL) {
		errprintf("document already open in memory\n")
		exit(110)
	}
	
	pDoc = crexternal("pdf__global")
	if (pDoc==NULL) {
		errprintf("failed to create document\n")
		exit(198)
	}
	(*pDoc) = PdfDocument(1)
	pDoc->setErrorMode("off")
	
	st_global("ST__PDF_ID", "0")
	st_global("ST__PDF_CUR_PARAGRAPH", "-1")
	st_global("ST__PDF_CUR_TABLE", "-1")
	st_global("ST__PDF_NO_TABLES", "0")
	st_global("ST__PDF_NO_PARAGRAPHS", "0")
	
	(void) pdf_set_wrk(pDoc, font, pagesize, landscape, margins, 
			   halign, bgcolor)
}

void pdf_save_wrk(`SS' filename, `SS' replace)
{
	`SS' 			using_file
	`pDocument' scalar	pDoc
	
	(void) pdf_is_valid()
	(void) pdf_paragraph_add_wrk()
	(void) pdf_table_add_wrk()
	
	pDoc = findexternal("pdf__global")
	if (pDoc) {
		using_file = pdf_check_filename(filename, 0)
		if (fileexists(using_file)) {
			if (replace == "") {
				errprintf("%s already exists\n", using_file)
				errprintf("you must specify the {bf:replace} option\n")
				exit(198)
			}
		}
		
		pDoc->save(using_file)
		if (pDoc->getLastError()) {
			errprintf("failed to save document\n")
			if (pDoc->getLastError()==17112) {
				exit(603)
			}
			else {
				exit(198)
			}
		}
	}
	
	(void) pdf_close_wrk(pDoc)
}

void pdf_clear_wrk()
{
	`pDocument' scalar	pDoc
	
	pDoc = findexternal("pdf__global")
	(void) pdf_close_wrk(pDoc)
}

void pdf_close_wrk(`pDocument' pDoc)
{
	if (pDoc) {
		pDoc->close()
		if (pDoc->getLastError()) {
			errprintf("failed to close document\n")
			exit(198)
		}
		rmexternal("pdf__global")		
	}
	st_global("ST__PDF_ID", "-1")
	st_global("ST__PDF_CUR_PARAGRAPH", "-1")
	st_global("ST__PDF_CUR_TABLE", "-1")
	st_global("ST__PDF_NO_TABLES", "0")
	st_global("ST__PDF_NO_PARAGRAPHS", "0")
}

void pdf_describe_wrk(`SS' s, `RS' type)
{
	`RS'			maxlen, tid
	`RS'			ntables, nparas
	`RR'			tinfo
	
	(void) pdf_is_valid()
	if (type == 0) {
		ntables = strtoreal(st_global("ST__PDF_NO_TABLES"))
		nparas = strtoreal(st_global("ST__PDF_NO_PARAGRAPHS"))
		
		printf("\n")
		maxlen = 20
		printf("  {hline %g}{c +}{hline %g}\n", 20, maxlen+3)
		printf("  {cmd:No. of tables}       {c |}  %g\n", ntables)
		printf("  {cmd:No. of paragraphs}   {c |}  %g\n", nparas)
		(void) _stata("return add", 1)
	}
	else {
		tinfo = pdf_get_table_info(s)
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

void pdf_text_set_script(`CPTS' pt, `SS' script) 
{	
	script = strtrim(script)
	if (script == "sub") {
		(void) pt.setSubscript()
	}
	else if (script == "super") {
		(void) pt.setSuperscript()
	}
	else {
		errprintf("option {bf:script()} specified incorrectly\n")
		exit(198)
	}
}

void pdf_paragraph_set_indent_wrk(`pParagraph' curp, `SS' indentstr)
{
	`TR'			t
	`SS'			token, indstr
	`II' 			ii
	
	t = tokeninit(" ", "indent", `"()"')
	tokenset(t, indentstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "indent") {
			indstr = tokenpeek(t)
			if (pdf_check_paren(indstr)) {
				errprintf("%s must be enclosed in ()\n", indstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				token = pdf_remove_paren(token)
				(void) pdf_parse_indent(token, ii)
				
				if (curp) {
				if (ii.type=="firstline") {
					curp->setFirstIndent(ii.value)
				}
				else if (ii.type=="left") {
					curp->setLeftIndent(ii.value)		
				}
				else {
					curp->setRightIndent(ii.value)				
				}
				if (curp->getLastError()) {
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

void pdf_paragraph_set_spacing_wrk(`pParagraph' curp, `SS' spacingstr)
{
	`TR'			t
	`SS'			token, spstr
	`SPI' 			spi
	
	t = tokeninit(" ", "spacing", `"()"')
	tokenset(t, spacingstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "spacing") {
			spstr = tokenpeek(t)
			if (pdf_check_paren(spstr)) {
				errprintf("%s must be enclosed in ()\n", spstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				token = pdf_remove_paren(token)
				(void) pdf_parse_spacing(token, spi, 1)
				
				if (curp) {
				if (spi.type=="before") {
					curp->setTopSpacing(spi.value)
				}
				else if (spi.type=="after") {
					curp->setBottomSpacing(spi.value)					
				}
				else {
					curp->setLineSpace(spi.value)				
				}
				if (curp->getLastError()) {
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

void pdf_paragraph_set_wrk(`pDocument' pDoc, `SS' font, `SS' halign, 
			   `SS' valign, `SS' indents, `SS' spacings, 
			   `SS' bgcolor)
{
	`FTI'			fti
	`pParagraph'		curp
	`CI'			color
	
	curp = pDoc->getp()
	if (curp == NULL) {
		errprintf("no active paragraph\n")
		exit(198)
	}
	curp->setErrorMode("off")
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, NULL)
		if (fti.name != "") {
			curp->setFont(fti.name, "regular")
			if (curp->getLastError()) {
				errprintf("failed to set paragraph font\n")
				exit(198)
			}
		}
		if (fti.size) {
			curp->setFontSize(fti.size)
			if (curp->getLastError()) {
			errprintf("failed to set paragraph font size\n")
				exit(198)
			}
		}
		if (fti.color != J(1,1,NULL)) {
			curp->setColor(fti.color->r, fti.color->g, fti.color->b)
			if (curp->getLastError()) {
			errprintf("failed to set paragraph font color\n")
				exit(198)
			}
		}
	}

	if (halign != "") {
		halign = strtrim(halign)
		if (halign=="distribute") {
			halign = "stretch"
		}
		curp->setHAlignment(halign)
		if (curp->getLastError()) {
			errprintf("failed to set paragraph alignment\n")
			exit(198)
		}
	}

	if (valign != "") {
		valign = strtrim(valign)
		curp->setVAlignment(valign)
		if (curp->getLastError()) {
			errprintf("failed to set paragraph alignment\n")
			exit(198)
		}
	}

	if (indents != "") {
		(void) pdf_paragraph_set_indent_wrk(curp, indents)
	}

	if (spacings != "") {
		(void) pdf_paragraph_set_spacing_wrk(curp, spacings)
	}
	else {
		(void) pdf_paragraph_set_spacing_wrk(curp, "spacing(after,8pt)")
	}
	
	if (bgcolor != "") {
		if (pdf_parse_color(bgcolor, color)==0) {
			errprintf("invalid color specified in bgcolor()\n")
			exit(198)
		}
		curp->setBgColor(color.r, color.g, color.b)
		if (curp->getLastError()) {
	errprintf("failed to set paragraph background color\n")
			exit(198)
		}
	}
}

void pdf_paragraph_check_prop(`SS' font, `SS' halign, `SS' valign,
			      `SS' indents, `SS' spacings, `SS' bgcolor)
{
	`FTI'			fti
	`CI'			color
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, NULL)
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		if (halign != "left" & halign != "right" & 
			halign != "center" & halign != "justified" & 
			halign != "distribute") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			exit(198)
		}
	}

	if (valign != "") {
		valign = strtrim(valign)
		if (valign != "top" & valign != "baseline" & 
			valign != "bottom" & valign != "center") {
		errprintf("option {bf:valign()} specified incorrectly\n")
			exit(198)
		}
	}

	if (indents != "") {
		(void) pdf_paragraph_set_indent_wrk(NULL, indents)
	}
	
	if (spacings != "") {
		(void) pdf_paragraph_set_spacing_wrk(NULL, spacings)
	}
	
	if (bgcolor != "") {
		if (strpos(bgcolor, ",")!=0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		if (pdf_parse_color(bgcolor, color)==0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
	}
}

void pdf_add_paragraph_wrk(`SS' font, `SS' halign, `SS' valign,
			   `SS' indents, `SS' spacings, `SS' bgcolor)
{
	`pDocument' scalar	pDoc
	
	(void) pdf_paragraph_check_prop(font, halign, valign, indents, 
		spacings, bgcolor)
	
	(void) pdf_paragraph_add_wrk()
	(void) pdf_table_add_wrk()
	
	pDoc = findexternal("pdf__global")
	pDoc->setp(&PdfParagraph(1))
	
	(void) pdf_update(1)
	
	(void) pdf_paragraph_set_wrk(pDoc, font, halign, valign, indents, 
		spacings, bgcolor)
}

void pdf_paragraph_set_text_wrk(`CPTS' pt, `SS' font, `SS' bold, `SS' italic, 
				`SS' script, `SS' underline, `SS' strikeout, 
				`SS' bgcolor)
{
	`FTI'			fti
	`CI'			color
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, NULL)
		if (fti.name != "") {
			(void) pt.setFont(fti.name, "regular")
		}
		if (fti.size) {
			(void) pt.setFontSize(fti.size)
		}
		if (fti.color != J(1,1,NULL)) {
			(void) pt.setColor(fti.color->r, fti.color->g, fti.color->b)
		}
	}
	
	if (bold != "") {
		(void) pt.setFontStyle("Bold")
	}
	
	if (italic != "") {
		(void) pt.setFontStyle("Italic")
	}

	if (script != "") {
		(void) pdf_text_set_script(pt, script)
	}

	if (bgcolor != "") {
		if (strpos(bgcolor, ",")!=0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		if (pdf_parse_color(bgcolor, color)==0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		(void) pt.setBgColor(color.r, color.g, color.b)
	}

	if (underline != "") {
		(void) pt.setUnderline()
	}

	if (strikeout != "") {
		(void) pt.setStrikethru()
	}
}

void pdf_paragraph_add_text_wrk(`SS' font, `SS' bold, `SS' italic, `SS' script, 
				`SS' underline, `SS' strikeout, `SS' bgcolor, 
				`RS' linebreaks, `SS' nformat, `SS' allcaps)
{
	`SS'			expression, tmpname, tmpstr
	`RS'			rc, i, rtmpstr	
	`CPTS'			pt
	`pDocument' scalar	pDoc
	`pParagraph'		curp

	pDoc = findexternal("pdf__global")
	curp = pDoc->getp()
	if (curp == NULL) {
		errprintf("no active paragraph\n")
		exit(198)
	}

	expression = st_local("paraexplist")

	if (pdf_check_paren(expression)) {
		errprintf("expression must be enclosed in ()\n")
		exit(198)
	}

	expression = pdf_remove_paren(expression)

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
		rtmpstr = strtoreal(tmpstr)
		if (!missing(rtmpstr)) {
			tmpstr = sprintf(nformat, rtmpstr)
		}
	}
	
	pt = PdfText()
	if (allcaps != "") {
		tmpstr = ustrupper(tmpstr)
	}
	pt.addString(tmpstr)
	
	if (strlen(tmpstr)!=0) {
		(void) pdf_paragraph_set_text_wrk(pt, font, bold, italic, 
			script, underline, strikeout, bgcolor)
		
		curp->addText2(pt)
		if (curp->getLastError()) {
			errprintf("failed to set text font\n")
			exit(198)
		}		
	}
	
	if (linebreaks != 0) {
		for(i=1; i<=linebreaks; i++) {
			curp->addLineBreak()
			if (curp->getLastError()) {
				errprintf("failed to add linebreak\n")
				exit(198)
			}
		}
	}
}

void pdf_paragraph_add_image_wrk(`SS' filename, `SS' width, `SS' height,
	`RS' linebreaks)
{
	`SS'			ext 
	`pDocument' scalar	pDoc
	`pParagraph'		curp
	`RS'			rwidth, rheight, i
	
	pDoc = findexternal("pdf__global")
	curp = pDoc->getp()
	if (curp == NULL) {
		errprintf("no active paragraph\n")
		exit(198)
	}
	
	filename = pdf_remove_double_quote(filename)
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
		if (ext != ".png" & ext != ".jpg" & ext != ".jpeg") {
			errprintf("image type not supported\n")
			exit(198)
		}
	}
	
	if (!fileexists(filename)) {
		errprintf("file {bf:%s} not found\n", filename)
		exit(601)
	}

	rwidth = .
	if (bstrlen(width) > 0) {
		rwidth = put_get_points(strtrim(width))
		if (rwidth <= 0) {
		errprintf("option {bf:width()} specified incorrectly\n")
			exit(198)
		}
	}
	
	rheight = .
	if (bstrlen(height) != 0) {
		rheight = put_get_points(strtrim(height))
		if (rheight <= 0) {
		errprintf("option {bf:height()} specified incorrectly\n")
			exit(198)
		}
	}
	
	curp->addImage(filename, rwidth, rheight)
	if (curp->getLastError()) {
		errprintf("failed to add image\n")
		exit(198)
	}
	
	if (linebreaks != 0) {
		for(i=1; i<=linebreaks; i++) {
			curp->addLineBreak()
			if (curp->getLastError()) {
				errprintf("failed to add linebreak\n")
				exit(198)
			}
		}
	}
}

void pdf_paragraph_add_wrk() 
{
	`pDocument' scalar	pDoc
	`pParagraph'		curp

	pDoc = findexternal("pdf__global")
	curp = pDoc->getp()
	if (curp == NULL) {
		return
	}
	
	pDoc->addParagraph(*curp)
	if (pDoc->getLastError()) {
		errprintf("failed to add paragraph\n")
		exit(198)
	}
	curp->close()
	pDoc->setp(NULL)
	
	st_global("ST__PDF_CUR_PARAGRAPH", "-1")
}

void pdf_table_parse_cell(`SS' ltname, `SS' lrow, `SS' lcol, 
			  `SS' lrows, `SS' lcols, `SS' cellexplist)
{
	`TR'			t
	`SS'			token, cell, cellexp, tblname, srow, scol
	`RS'			tid, row, col, bnumlist
	`RR'			tinfo
	
	(void) pdf_is_valid()
	
	cellexp = cellexplist
	tblname = bsubstr(cellexp, 1, strpos(cellexp, "(")-1)
	cellexp = bsubstr(cellexp, strpos(cellexp, "("), .)
	
	tinfo = pdf_get_table_info(tblname)
	tid = tinfo[1]
	if (tid < 0) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)
	}
	st_local(ltname, tblname)
	
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
			cell = pdf_remove_paren(strtrim(cell))
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
			cell = pdf_remove_paren(strtrim(token))
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

`CPTBLS' pdf_add_matrix_wrk(`SS' tmatrix)
{
	`TR'			t
	`SS'			tmpstr, token, matname, tmpname
	`SS'			sfmt, srownames, scolnames, fmt
	`RS'			args, rownames, colnames, rc
	`CPTBLS' 		tbl

	tmpstr = pdf_remove_paren(tmatrix)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	matname = ""
	sfmt = ""
	srownames = ""
	scolnames = ""

	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			matname = pdf_remove_quote(token)
		}
		else if (args == 2) {
			sfmt = pdf_remove_quote(token)
		}
		else if (args == 3) {
			srownames = pdf_remove_quote(token)
		}
		else if (args == 4) {
			scolnames = pdf_remove_quote(token)
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
	rc = _stata(sprintf("matrix define %s = %s", tmpname, matname))
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

	tbl.setErrorMode("off")
	tbl.fillStataMatrix(tmpname, colnames, rownames, fmt)
	
	return(tbl)
}

`CPTBLS' pdf_add_mata_wrk(`SS' tmata)
{
	`TR'			t
	`SS'			tmpstr, token, smata, sfmt, fmt
	transmorphic matrix	m
	`RS'			args
	`CPTBLS' 		tbl
	
	tmpstr = pdf_remove_paren(tmata)
	tmpstr = pdf_process_options(tmpstr)

	t = tokeninit(" ", `","', `""""', 0, 0)
	tokenset(t, tmpstr)

	args = 1
	smata = ""
	sfmt = ""
	
	for(token=tokenget(t); token != ""; token = tokenget(t)) {
		(void) tokenget(t)
		if (args == 1) {
			smata = pdf_remove_quote(token)
		}
		else if (args == 2) {
			sfmt = pdf_remove_quote(token)
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
	
	tbl.setErrorMode("off")
	tbl.fillMataMatrix(m, 1, 1, fmt)
	
	return(tbl)
}

void pdf_check_varindex(`SS' varnames) 
{
	`SR' 			vars
	`RS'			ivar
	
	vars = tokens(varnames)
	
	for(ivar=1; ivar<=cols(vars); ivar++) {
		if (hasmissing(_st_varindex(vars[ivar]))) {
			errprintf("variable %s not found\n", vars[ivar])
			exit(111)
		}
	}
}

`CPTBLS' pdf_add_data_wrk(`SS' tdata, `SS' myif, `SS' myin)
{
	`TR'			t
	`SS'			tmpstr, token, svarnames, sobsno, 
				si, sj, tmpname
	`RM'			i
	`RR'			j
	`RS'			args, varnames, obsno, rc, tmppos
	`RS' 			myifin, oobsno
	`CPTBLS' 		tbl

	tmpstr = strtrim(tdata)
	
	if (strpos(tmpstr, "(") | strpos(tmpstr, ")")) {
		if (strpos(tmpstr, "(") & strpos(tmpstr, ")") == 0) {
			errprintf("parenthesis not balanced\n")
			exit(198)
		}
		if (strpos(tmpstr, "(") == 0 & strpos(tmpstr, ")")) {
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
			if (strpos(tmpstr, "(") & strpos(tmpstr, ")") == 0) {
				errprintf("parenthesis not balanced\n")
				exit(198)
			}
			if (strpos(tmpstr, "(") == 0 & strpos(tmpstr, ")")) {
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
			tmpstr = pdf_process_options(tmpstr)
			svarnames = ""
			sobsno = ""

			t = tokeninit(" ", `","', `""""', 0, 0)
			tokenset(t, tmpstr)
			
			args = 1
			for(token=tokenget(t); token != ""; token = tokenget(t)) {
				(void) tokenget(t)
				if (args == 1) {
					svarnames = pdf_remove_quote(token)
				}
				else if (args == 2) {
					sobsno = pdf_remove_quote(token)
				}
				else if (args > 2) {
			errprintf("invalid specification in {bf:data()}\n")
					exit(198)
				}
				args++
			}			
		}
		else {
			tmpstr = pdf_process_options(tmpstr)
			svarnames = ""
			sobsno = ""
			si = ""

			t = tokeninit(" ", `","', `""""', 0, 0)
			tokenset(t, tmpstr)
			
			args = 1
			for(token=tokenget(t); token != ""; token = tokenget(t)) {
				(void) tokenget(t)
				if (args == 1) {
					si = pdf_remove_quote(token)
				}
				else if (args == 2) {
					svarnames = pdf_remove_quote(token)
				}
				else if (args == 3) {
					sobsno = pdf_remove_quote(token)
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
		tmpstr = pdf_process_options(tmpstr)
		args = 1
		svarnames = ""
		sobsno = ""
		si = ""
		sj = ""
		
		t = tokeninit(" ", `","', `""""', 0, 0)
		tokenset(t, tmpstr)

		for(token=tokenget(t); token != ""; token = tokenget(t)) {
			(void) tokenget(t)
			if (args == 1) {
				sj = pdf_remove_quote(token)
			}
			else if (args == 2) {
				si = pdf_remove_quote(token)
			}
			else if (args == 3) {
				svarnames = pdf_remove_quote(token)
			}
			else if (args == 4) {
				sobsno = pdf_remove_quote(token)
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
	
	sj = pdf_remove_quote(sj)
	tmpname = st_tempname()
	rc = _stata(sprintf("matrix define %s = %s", tmpname, sj), 1)
	if (rc) {
		(void) pdf_check_varindex(sj)
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

	si = pdf_remove_quote(si)
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
	
	tbl.setErrorMode("off")
	tbl.fillData(i, j, varnames, obsno)
	
	if (myifin == 1) {
		if (oobsno == 1) {
			tbl.setCellContentString(1, 1, "")
		}
		
		rc = _stata("restore", 1)
		if (rc) {
			errprintf("failed to add table\n")
			exit(198)
		}
	}
	
	return(tbl)
}

`RS' pdf_table_is_resultset(string scalar token)
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

`CPTBLS' pdf_table_resultset(`RS' nrows, `RS' ncols, `SM' contents)
{
	`CPTBLS'		tbl
	`RS'			i, j, err
	
	tbl.setErrorMode("off")
	tbl.init(nrows, ncols)
	err = tbl.getLastError()
	if (err > 0) {
		if (err==17121) {
			errprintf("maximum number of rows exceeded; limit 65535\n")
			exit(198)				
		}
		else if (err==17128) {
			errprintf("maximum number of columns exceeded; limit 50\n")
			exit(198)
		}
		else {
			errprintf("failed to add table\n")
			exit(198)
		}
	}
	tbl.setType(2)

	for(i=1; i<=nrows; i++) {
		for(j=1; j<=ncols; j++) {
			tbl.setCellContentString(i, j, contents[i,j])
		}
	}
	
	return(tbl)
}

`RR' pdf_check_resultset(`RS' restype)
{
	`SC'			return_names
	`RS'			nrows
	`RR'			nret
	
	nret = J(1,3,0)
	if (restype == 1) {
		return_names = st_dir("e()", "numscalar", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		nret[1] = 1
	}
	else if (restype == 2) {
		return_names = st_dir("r()", "numscalar", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no return results in memory\n")
			exit(198)
		}
		nret[1] = 1
	}
	else if (restype == 3) {
		return_names = st_dir("e()", "macro", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		nret[2] = 1
	}
	else if (restype == 4) {
		return_names = st_dir("r()", "macro", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no return results in memory\n")
			exit(198)
		}
		nret[2] = 1
	}
	else if (restype == 5) {
		return_names = st_dir("e()", "matrix", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		nret[3] = 1
	}
	else if (restype == 6) {
		return_names = st_dir("r()", "matrix", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no return results in memory\n")
			exit(198)
		}
		nret[3] = 1		
	}
	else if (restype == 7) {
		return_names = st_dir("e()", "numscalar", "*")
		nrows = rows(return_names)
		if (nrows != 0) {
			nret[1] = 1
		}
		
		return_names = st_dir("e()", "macro", "*")
		nrows = rows(return_names)
		if (nrows != 0) {
			nret[2] = 1
		}

		return_names = st_dir("e()", "matrix", "*")
		nrows = rows(return_names)
		if (nrows != 0) {
			nret[3] = 1
		}

		if (nret==J(1,3,0)) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
	}
	else {
		return_names = st_dir("r()", "numscalar", "*")
		nrows = rows(return_names)
		if (nrows != 0) {
			nret[1] = 1
		}
		
		return_names = st_dir("r()", "macro", "*")
		nrows = rows(return_names)
		if (nrows != 0) {
			nret[2] = 1
		}

		return_names = st_dir("r()", "matrix", "*")
		nrows = rows(return_names)
		if (nrows != 0) {
			nret[3] = 1
		}

		if (nret==J(1,3,0)) {
			errprintf("no return results in memory\n")
			exit(198)
		}
	}
	
	return(nret)
}

`CPTBLS' pdf_add_scalars_table(`RS' cls_type, `RS' scalar_type)
{
	`SC'			return_names, return_values
	`RS'			i, nrows, ncols
	`CPTBLS'		tbl
	`SM'			contents
	
	if (cls_type == 1 & scalar_type == 1) {
		return_names = st_dir("r()", "numscalar", "*")
		nrows = rows(return_names)
		if (nrows == 0) {
			errprintf("no return results in memory\n")
			exit(198)
		}
		
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
		if (nrows == 0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		
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
		if (nrows == 0) {
			errprintf("no return results in memory\n")
			exit(198)
		}		

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
		if (nrows == 0) {
			errprintf("no e-return results in memory\n")
			exit(198)
		}
		
		return_values = J(nrows, 1, "")
		for(i=1; i<=nrows; i++) {
			return_values[i] = "e(" + return_names[i] + ")"
			return_values[i] = 
				sprintf("%s", st_global(return_values[i]))
		}
	}
	
	ncols = 2
	contents = J(nrows, ncols, "")
	contents[.,1] = return_names
	contents[.,2] = return_values
	
	tbl = pdf_table_resultset(nrows, ncols, contents)
	
	return(tbl)
}

`CPTBLSRC' pdf_add_matrices_table(`RS' cls_type)
{
	`SC'			return_names
	`SS'			cls_name, tmpname
	`RS'			i, ntables, rc, nrows, ncols
	`RM'			return_matrix
	`SM'			contents
	`CPTBLSRC'		tbls
	
	if (cls_type == 1) {
		return_names = st_dir("r()", "matrix", "*")
	}
	else {
		return_names = st_dir("e()", "matrix", "*")
	}
	
	ntables = rows(return_names)
	if (ntables == 0) {
		if (cls_type == 1) {
			errprintf("no return results in memory\n")
		}
		else {
			errprintf("no e-return results in memory\n")
		}
		exit(198)
	}
	
	tbls = PdfTable(ntables, 1)
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
			
		tbls[i] = pdf_table_resultset(nrows, ncols, contents)
	}
	
	return(tbls)
}

`CPTBLS' pdf_add_resultset_wrk(`RS' restype) 
{
	`CPTBLS'		tbl
	`RS'			i, ntables, count
	`CPTBLSRC'		tbls
	`RR'			nret
	
	if (restype == 1) {
		(void) pdf_check_resultset(1)
		tbl = pdf_add_scalars_table(2, 1)
	}
	else if (restype == 2) {
		(void) pdf_check_resultset(2)
		tbl = pdf_add_scalars_table(1, 1)
	}
	else if (restype == 3) {
		(void) pdf_check_resultset(3)
		tbl = pdf_add_scalars_table(2, 2)
	}
	else if (restype == 4) {
		(void) pdf_check_resultset(4)
		tbl = pdf_add_scalars_table(1, 2)
	}
	else if (restype == 5){
		(void) pdf_check_resultset(5)
		tbls = pdf_add_matrices_table(2)
		ntables = rows(tbls)
		
		tbl.init(ntables+1, 1)
		tbl.setErrorMode("off")
		
		tbl.setCellContentString(1, 1, "e-class matrices")
		tbl.setCellHAlignment(1, 1, "center")

		for(i=1; i<=ntables; i++) {
			tbl.setCellContentTable(i+1, 1, tbls[i])
		}
	}
	else if (restype == 6) {
		(void) pdf_check_resultset(6)
		tbls = pdf_add_matrices_table(1)
		ntables = rows(tbls)
		
		tbl.init(ntables+1, 1)
		tbl.setErrorMode("off")
		
		tbl.setCellContentString(1, 1, "r-class matrices")
		tbl.setCellHAlignment(1, 1, "center")
		
		for(i=1; i<=ntables; i++) {
			tbl.setCellContentTable(i+1, 1, tbls[i])
		}
	}
	else if (restype == 7) {
		nret = pdf_check_resultset(7)
		
		tbl.init(1, 1)
		tbl.setErrorMode("off")
		count = 0
		if (nret[1] == 1) {
			tbl.setCellContentString(1, 1, "e-class scalars")
			tbl.setCellHAlignment(1, 1, "center")
			count = count + 1
			
			tbl.addRow(1)
			tbl.setCellContentTable(2, 1, 
				pdf_add_scalars_table(2, 1))
			count = count + 1
		}
		
		if (nret[2] == 1) {
			tbl.addRow(count)
			tbl.setCellContentString(count+1, 1, "e-class macros")
			tbl.setCellHAlignment(count+1, 1, "center")
			count = count + 1
			
			tbl.addRow(count)
			tbl.setCellContentTable(count+1, 1, 
				pdf_add_scalars_table(2, 2))
			count = count + 1
		}
		
		if (nret[3] == 1) {
			tbl.addRow(count)
			tbl.setCellContentString(count+1, 1, "e-class matrices")
			tbl.setCellHAlignment(count+1, 1, "center")
			count = count + 1
			
			tbls = pdf_add_matrices_table(2)
			ntables = rows(tbls)
			
			for(i=1; i<=ntables; i++) {
				tbl.addRow(i+count-1)
				tbl.setCellContentTable(i+count, 1, tbls[i])
			}
		}	
	}
	else {
		nret = pdf_check_resultset(8)
		
		tbl.init(1, 1)
		tbl.setErrorMode("off")
		count = 0
		if (nret[1] == 1) {
			tbl.setCellContentString(1, 1, "r-class scalars")
			tbl.setCellHAlignment(1, 1, "center")
			count = count + 1
			
			tbl.addRow(1)
			tbl.setCellContentTable(2, 1, 
				pdf_add_scalars_table(1, 1))
			count = count + 1
		}
		
		if (nret[2] == 1) {
			tbl.addRow(count)
			tbl.setCellContentString(count+1, 1, "r-class macros")
			tbl.setCellHAlignment(count+1, 1, "center")
			count = count + 1
			
			tbl.addRow(count)
			tbl.setCellContentTable(count+1, 1, 
				pdf_add_scalars_table(1, 2))
			count = count + 1
		}
		
		if (nret[3] == 1) {
			tbl.addRow(count)
			tbl.setCellContentString(count+1, 1, "r-class matrices")
			tbl.setCellHAlignment(count+1, 1, "center")
			count = count + 1
			
			tbls = pdf_add_matrices_table(1)
			ntables = rows(tbls)
			
			for(i=1; i<=ntables; i++) {
				tbl.addRow(i+count-1)
				tbl.setCellContentTable(i+count, 1, tbls[i])
			}
		}
	}
	
	return(tbl)
}

void pdf_table_set_width_wrk(`pTable' tbl, `SS' widthstr)
{
	`TR'			t
	`SS'			token, spstr
	`TWI' 			twi
	
	t = tokeninit(" ", "width", `"()"')
	tokenset(t, widthstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "width") {
			spstr = tokenpeek(t)
			if (pdf_check_paren(spstr)) {
				errprintf("%s must be enclosed in ()\n", spstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				token = pdf_remove_paren(token)
				(void) pdf_parse_table_width(token, twi)
				
				if (tbl) {
				if (twi.type == 1) {
					tbl->setTotalWidth(twi.widths[1])
				}
				else if (twi.type == 2) {
					tbl->setColumnWidths(twi.widths)
				}
				else {
					tbl->setWidthPercent(twi.widths[1]/100)
				}
				if (tbl->getLastError()) {
					errprintf("failed to set table width\n")
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

void pdf_table_set_spacing_wrk(`pTable' tbl, `SS' spacingstr)
{
	`TR'			t
	`SS'			token, spstr
	`SPI' 			spi
	
	t = tokeninit(" ", "spacing", `"()"')
	tokenset(t, spacingstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "spacing") {
			spstr = tokenpeek(t)
			if (pdf_check_paren(spstr)) {
				errprintf("%s must be enclosed in ()\n", spstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				token = pdf_remove_paren(token)
				(void) pdf_parse_spacing(token, spi, 2)
				
				if (tbl) {
				if (spi.type=="top") {
					tbl->setTopSpacing(spi.value)
				}
				else {
					tbl->setBottomSpacing(spi.value)				
				}
				if (tbl->getLastError()) {
				errprintf("failed to set table spacing\n")
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

void pdf_table_set_border_wrk(`pTable' tbl, `SS' borderstr)
{
	`TR'			t
	`SS'			token, cellbstr
	`TBI' 			tbi
	
	t = tokeninit(" ", "border", `"()"')
	tokenset(t, borderstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "border") {
			cellbstr = tokenpeek(t)
			if (pdf_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) pdf_parse_border(token, tbi, 1)
				
				if (tbl) {
					if (tbi.color != J(1,1,NULL)) {
						tbl->setBorderColor(tbi.color->r, 
							tbi.color->g, 
							tbi.color->b, 
							tbi.border)
					
						if (tbl->getLastError()) {
							errprintf("failed to set table border\n")
							exit(198)
						}
					}
				}
				
				if (tbl) {
					tbl->setBorderWidth(tbi.width, tbi.border)
					if (tbl->getLastError()) {
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

void pdf_table_check_prop(`SS' widths, `SS' halign, `SS' indent, 
			  `SS' spacings, `SS' borders)
{
	`RS'			rindent
	
	if (widths != "") {
		(void) pdf_table_set_width_wrk(NULL, widths)
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		if (halign != "left" & halign != "right" & halign != "center") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			exit(198)
		}
	}

	if (indent != "") {
		rindent = put_get_points(strtrim(indent))
		if (rindent < 0) {
		errprintf("option {bf:indent()} specified incorrectly\n")
			exit(198)
		}
	}

	if (spacings != 0) {
		(void) pdf_table_set_spacing_wrk(NULL, spacings)
	}
	
	if (borders != "") {
		(void) pdf_table_set_border_wrk(NULL, borders)
	}
}

void pdf_table_set_attr(`pTable' tbl, `SS' tblname, `SS' widths, 
			`SS' halign, `SS' indent, `SS' spacings, 
			`SS' borders, `SS' title, `SS' notes) 
{
	`RS'			rindent

	if (widths != "") {
		(void) pdf_table_set_width_wrk(tbl, widths)
	}

	if (halign != "") {
		halign = strtrim(halign)
		tbl->setHAlignment(halign)
		if (tbl->getLastError()) {
			errprintf("failed to set table alignment\n")
			exit(198)
		}
	}

	if (indent != "") {
		rindent = put_get_points(strtrim(indent))
		tbl->setIndentation(rindent)
		if (tbl->getLastError()) {
			errprintf("failed to set table indentation\n")
			exit(198)
		}
	}
	
	if (spacings != 0) {
		(void) pdf_table_set_spacing_wrk(tbl, spacings)
	}

	if (borders != "") {
		(void) pdf_table_set_border_wrk(tbl, borders)
	}
	
	if ((title != "") | (notes != "")) {
		(void) pdf_table_set_title_note(tbl, tblname, title, notes)
	}
}

void pdf_table_set_note_wrk(`pTable' tbl, `SS' notestr, `RS' nrows, `RS' ncols)
{
	`TR'			t
	`SS'			token, cellbstr, cellstr
	`RS'			j, ncount
	
	tbl->addRow(nrows)
	if (tbl->getLastError()) {
		errprintf("failed to add table note\n")
		exit(198)
	}
	for(j=1; j<=ncols; j++) {
		tbl->setCellBorderWidth(nrows+1, j, 0, "bottom")
	}
	tbl->setCellColSpan(nrows+1, 1, ncols)
	tbl->setCellBorderWidth(nrows+1, 1, 0, "left")
	tbl->setCellBorderWidth(nrows+1, 1, 0, "right")
	if (tbl->getLastError()) {
		errprintf("failed to add table note\n")
		exit(198)
	}
	
	t = tokeninit(" ", "note", `"()"')
	tokenset(t, notestr)
	
	ncount = 1
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "note") {
			cellbstr = tokenpeek(t)
			if (pdf_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				if (token!="") {
					token = pdf_remove_paren(token)
					token = pdf_remove_double_quote(token)
					cellstr = pdf_table_parse_cell_string(token, "", "", 
						"", "", "", "", "")
					
					if (ncount > 1) {
						tbl->addCellLineBreak(nrows+1, 1)
						if (tbl->getLastError()) {
							errprintf("failed to add linebreak\n")
							exit(198)
						}
					}
					tbl->setCellContentString2(nrows+1, 1, cellstr, 1, 0)
					if (tbl->getLastError()) {
						errprintf("failed to add table note\n")
						exit(198)
					}
					ncount = ncount + 1
				}
			}
		}
		else {
			errprintf("%s: invalid options\n", token)
			exit(198)
		}
	}
}

void pdf_table_set_title_note(`pTable' tbl, `SS' tblname, `SS' title, 
			      `SS' notes)
{
	`RR'			tblinfo
	`RS'			nrows, ncols, j, hastitle
	
	if ((title != "") | (notes != "")) {
		tblinfo = pdf_get_table_info(tblname)
		nrows = tblinfo[2]
		ncols = tblinfo[3]
		hastitle = 0
		if (title != "") {
			tbl->addRow(0)
			if (tbl->getLastError()) {
				errprintf("failed to add table title\n")
				exit(198)
			}
			for(j=1; j<=ncols; j++) {
				tbl->setCellBorderWidth(1, j, 0, "top")
			}
			tbl->setCellColSpan(1, 1, ncols)
			tbl->setCellBorderWidth(1, 1, 0, "left")
			tbl->setCellBorderWidth(1, 1, 0, "right")
			tbl->setCellContentString(1, 1, title)
			if (tbl->getLastError()) {
				errprintf("failed to add table title\n")
				exit(198)
			}
			hastitle = 1
		}
		if (notes != "") {
			if (hastitle == 1) {
				nrows = nrows + 1
			}
			(void) pdf_table_set_note_wrk(tbl, notes, nrows, ncols)
		}
	}
}

void pdf_add_table_wrk(`SS' tblspec, `SS' memtable, `SS' widths, 
		       `SS' halign, `SS' indent, `SS' spacings, 
		       `SS' borders, `SS' myif, `SS' myin,
		       `SS' title, `SS' notes)
{
	`RS'			rows, cols, rettype, rtype, err, boverr
	`TR'			t
	`SS'			token, cell, tblname, srows, scols
	`SS'			tmatrix, tdata, tmata, tetable
	`CPTBLS'		tbl
	`pDocument' scalar	pDoc
	
	(void) pdf_is_valid()
	(void) pdf_paragraph_add_wrk()
	
	if (memtable == "") {
		(void) pdf_table_add_wrk()
	}
	
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
				if (pdf_check_paren(token)) {
					errprintf("matrix specification must be enclosed in ()\n")
					exit(198)
				}
				tmatrix = pdf_remove_paren(strtrim(token))
			}
			else if (rettype = pdf_table_is_resultset(token)) {
				rtype = rettype
			}
			else if (token == "mata") {
				token = tokenget(t)
				if (pdf_check_paren(token)) {
					errprintf("mata specification must be enclosed in ()\n")
					exit(198)
				}
				tmata = pdf_remove_paren(strtrim(token))
			}
			else if (token == "data") {
				token = tokenget(t)
				if (pdf_check_paren(token)) {
					errprintf("data specification must be enclosed in ()\n")
					exit(198)
				}
				tdata = pdf_remove_paren(strtrim(token))
			}
			else if (token == "etable") {
				token = tokenget(t)
				if (pdf_check_paren(token)) {
					errprintf("etable specification must be enclosed in ()\n")
					exit(198)
				}
				tetable = pdf_remove_paren(strtrim(token))
			}
			else {
				if (pdf_check_paren(token)) {
					errprintf("%s: invalid table specification\n", token)
					exit(198)
				}
				cell = pdf_remove_paren(strtrim(token))
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
	
	pDoc = findexternal("pdf__global")	
	(void) pdf_table_check_prop(widths, halign, indent, spacings, borders)

	if (tetable == "") {
		boverr = pdf_check_table_name(tblname)
		if (rows > 0) {
			tbl.setErrorMode("off")
			tbl.init(rows, cols)
			err = tbl.getLastError()
			if (err > 0) {
				if (err==17121) {
					errprintf("maximum number of rows exceeded; limit 65535\n")
					exit(198)				
				}
				else if (err==17128) {
					errprintf("maximum number of columns exceeded; limit 50\n")
					exit(198)
				}
				else {
					errprintf("failed to add table\n")
					exit(198)
				}
			}
			tbl.setName(tblname)
			tbl.setType(2)
			if (memtable == "") {
				pDoc->addtbl(&tbl, 0)
			}
			else {
				pDoc->addtbl(&tbl, 1)
			}
		}
		
		if (tmatrix != "") {
			tbl = pdf_add_matrix_wrk(tmatrix)
			err = tbl.getLastError()
			if (err > 0) {
				if (err==17121) {
					errprintf("maximum number of rows exceeded; limit 65535\n")
					exit(198)				
				}
				else if (err==17128) {
					errprintf("maximum number of columns exceeded; limit 50\n")
					exit(198)
				}
				else {
					errprintf("failed to add table\n")
					exit(198)
				}
			}
			tbl.setName(tblname)
			tbl.setType(2)
			if (memtable == "") {
				pDoc->addtbl(&tbl, 0)
			}
			else {
				pDoc->addtbl(&tbl, 1)
			}
		}
		
		if (tmata != "") {
			tbl = pdf_add_mata_wrk(tmata)
			err = tbl.getLastError()
			if (err > 0) {
				if (err==17121) {
					errprintf("maximum number of rows exceeded; limit 65535\n")
					exit(198)				
				}
				else if (err==17128) {
					errprintf("maximum number of columns exceeded; limit 50\n")
					exit(198)
				}
				else {
					errprintf("failed to add table\n")
					exit(198)
				}
			}
			tbl.setName(tblname)
			tbl.setType(2)
			if (memtable == "") {
				pDoc->addtbl(&tbl, 0)
			}
			else {
				pDoc->addtbl(&tbl, 1)
			}
		}

		if (tdata != "") {
			tbl = pdf_add_data_wrk(tdata, myif, myin)
			err = tbl.getLastError()
			if (err > 0) {
				if (err==17121) {
					errprintf("maximum number of rows exceeded; limit 65535\n")
					exit(198)				
				}
				else if (err==17128) {
					errprintf("maximum number of columns exceeded; limit 50\n")
					exit(198)
				}
				else {
					errprintf("failed to add table\n")
					exit(198)
				}
			}
			tbl.setName(tblname)
			tbl.setType(2)
			if (memtable == "") {
				pDoc->addtbl(&tbl, 0)
			}
			else {
				pDoc->addtbl(&tbl, 1)
			}
		}
		
		if (rtype != 0) {
			tbl = pdf_add_resultset_wrk(rtype)
			tbl.setName(tblname)
			if (memtable == "") {
				pDoc->addtbl(&tbl, 0)
			}
			else {
				pDoc->addtbl(&tbl, 1)
			}
		}
		
		(void) pdf_update(2)
		
		if (memtable == "") {
			st_global("ST__PDF_CUR_TABLE", "0")
		}
		
		(void) pdf_table_set_attr(&tbl, tblname, widths, halign, indent, 
			spacings, borders, title, notes)
			
		if (boverr > 0) {
printf("{txt}(note: table " + "{cmd:" + ustrtrim(tblname) + "} has been redefined)\n")
		}
	}
	else {
		(void) pdf_add_etable_wrk(tblname, tetable, memtable, widths, 
			halign, indent, spacings, borders, title, notes)
	}
}

void pdf_table_add_wrk()
{
	`RS' 			tid
	`CPTBLS'		tbl
	`pDocument' scalar	pDoc
	
	tid = strtoreal(st_global("ST__PDF_CUR_TABLE"))
	if (tid < 0) {
		return
	}
	
	pDoc = findexternal("pdf__global")
	tbl = *(pDoc->gettoptbl())
	pDoc->addTable(tbl)
	if (pDoc->getLastError()) {
		errprintf("failed to add table\n")
		exit(198)
	}
	
	st_global("ST__PDF_CUR_TABLE", "-1")
}

void pdf_cell_set_border_wrk(`pTable' tbl, `RS' row, `RS' col, `SS' borderstr)
{
	`TR'			t
	`SS'			token, cellbstr
	`TBI' 			tbi
	
	t = tokeninit(" ", "border", `"()"')
	tokenset(t, borderstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "border") {
			cellbstr = tokenpeek(t)
			if (pdf_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) pdf_parse_border(token, tbi, 2)
				
				if (tbl) {
					tbl->setCellBorderWidth(row, col, tbi.width, 
						tbi.border)
					if (tbl->getLastError()) {
						errprintf("failed to set cell border\n")
						exit(198)
					}
				
					if (tbi.color != J(1,1,NULL)) {
						tbl->setCellBorderColor(row, col, tbi.color->r, 
							tbi.color->g, tbi.color->b, tbi.border)
						if (tbl->getLastError()) {
							errprintf("failed to set cell border\n")
							exit(198)
						}
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

void pdf_cell_set_margin_wrk(`pTable' tbl, `RS' row, `RS' col, `SS' marginstr)
{
	`TR'			t
	`SS'			token, cellbstr, mtype
	`MI' 			mi
	
	t = tokeninit(" ", "border", `"()"')
	tokenset(t, marginstr)
	
	for (token=tokenget(t); token!=""; token=tokenget(t)) {
		if (token == "margin") {
			cellbstr = tokenpeek(t)
			if (pdf_check_paren(cellbstr)) {
				errprintf("%s must be enclosed in ()\n", cellbstr)
				exit(198)
			}
			else {
				token = tokenget(t)
				(void) pdf_parse_margin(token, mi, NULL)
				
				if (tbl) {
				mtype = strlower(mi.type)
				tbl->setCellMargin(row, col, mi.value, mtype)
				if (tbl->getLastError()) {
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

void pdf_table_set_cell_attr(`pTable' tbl, `RS' row, `RS' col, 
			     `SS' font, `SS' bold, `SS' italic,
			     `SS' halign, `SS' valign, `SS' bgcolor, 
			     `SS' borders, `SS' margins, `RS' rowspan, 
			     `RS' colspan, `SS' span, `SS' nformat, 
			     `RS' linebreaks, `SS' allcaps)
{
	`CI' 			color
	`RS'			span1, span2, i
	`SS'			srowspan, scolspan
	`FTI'			fti

	if (font != "") {
		(void) pdf_parse_font(font, fti, NULL)
		if (fti.name != "") {
			if (bold!="" && italic !="") {
				tbl->setCellFont(row, col, fti.name, "bold italic")
			}
			else if (bold!="") {
				tbl->setCellFont(row, col, fti.name, "bold")
			}
			else if (italic!="") {
				tbl->setCellFont(row, col, fti.name, "italic")
			}
			else {
				tbl->setCellFont(row, col, fti.name, "regular")
			}
			if (tbl->getLastError()) {
				errprintf("failed to set cell font\n")
				exit(198)
			}
		}
		if (fti.size != 0) {
			tbl->setCellFontSize(row, col, fti.size)
			if (tbl->getLastError()) {
			errprintf("failed to set cell font size\n")
				exit(198)
			}
		}
		if (fti.color != J(1,1,NULL)) {
			tbl->setCellColor(row, col, fti.color->r, 
				fti.color->g, fti.color->b)
			if (tbl->getLastError()) {
			errprintf("failed to set cell font color\n")
				exit(198)
			}
		}
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		tbl->setCellHAlignment(row, col, halign)
		if (tbl->getLastError()) {
			errprintf("failed to set cell alignment\n")
			exit(198)
		}
	}

	if (valign != "") {
		valign = strtrim(valign)
		if (valign=="center") {
			valign = "middle"
		}
		tbl->setCellVAlignment(row, col, valign)
		if (tbl->getLastError()) {
			errprintf("failed to set cell alignment\n")
			exit(198)
		}
	}

	if (bgcolor != "") {
		if (pdf_parse_color(bgcolor, color)==0) {
			errprintf("invalid color specified in bgcolor()\n")
			exit(198)
		}
		tbl->setCellBgColor(row, col, color.r, color.g, color.b)
		if (tbl->getLastError()) {
			sprintf("%g, %g, %g, %g, %g, %g", row, col, color.r, color.g, color.b, tbl->getLastError())
			errprintf("failed to set cell background color\n")
			exit(198)
		}
	}
	
	if (borders != "") {
		(void) pdf_cell_set_border_wrk(tbl, row, col, borders)
	}
	
	if (margins != "") {
		(void) pdf_cell_set_margin_wrk(tbl, row, col, margins)
	}

	if (rowspan != 1) {
		tbl->setCellRowSpan(row, col, rowspan)
		if (tbl->getLastError()) {
			errprintf("failed to span row\n")
			exit(198)
		}
	}

	if (colspan != 1) {
		tbl->setCellColSpan(row, col, colspan)
		if (tbl->getLastError()) {
			errprintf("failed to span column\n")
			exit(198)
		}
	}
	
	if (span != "") {
		span = strtrim(span)
		if (strpos(span, ",")>0) {
			srowspan = bsubstr(span, 1, strpos(span, ",")-1)
			span1 = strtoreal(srowspan)

			scolspan = bsubstr(span, strpos(span, ",")+1, .)
			span2 = strtoreal(scolspan)
		
			tbl->setCellSpan(row, col, span1, span2)
			if (tbl->getLastError()) {
				errprintf("failed to span cell\n")
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
		tbl->setCellNFormat(row, col, nformat)
		if (tbl->getLastError()) {
			errprintf("failed to format cell value\n")
			exit(198)
		}
	}
	
	if (linebreaks != 0) {
		for(i=1; i<=linebreaks; i++) {
			tbl->addCellLineBreak(row, col)
			if (tbl->getLastError()) {
				errprintf("failed to add linebreak\n")
				exit(198)
			}
		}
	}
	
	if (allcaps != "") {
		tbl->setCellTextCaps(row, col)
		if (tbl->getLastError()) {
			errprintf("failed to set cell text with all caps\n")
			exit(198)
		}
	}
}

void pdf_parse_cellexplist(`TCCI' tcci, `SS' cell, `SS' expression, 
			   `RS' type, `RS' noexp)
{
	`SS'			srow, scol
	`SS'			tmpname, tblname, imagename
	`RS'			row, col, rc

	tcci.type = type
	tcci.row = -1
	tcci.col = -1

	cell = pdf_remove_paren(strtrim(cell))
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
		if (pdf_check_paren(expression)) {
			errprintf("expression must be enclosed in ()\n")
			exit(198)
		}

		expression = pdf_remove_paren(expression)
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
				errprintf("image file required\n")
				exit(100)
			}	
	imagename = pdf_remove_double_quote(expression)
			if (imagename=="") {
				errprintf("image file required\n")
				exit(100)
			}
			(void) pdf_parse_image(imagename)
			tcci.image = imagename
		}
		else if (type == 3) {
			if (expression=="") {
				errprintf("table name required\n")
				exit(100)
			}
			tblname = pdf_remove_quote(expression)
			tcci.table = tblname
		}
		else {
			errprintf("syntax error\n")
			exit(198)
		}
	}
}

`SS' pdf_table_parse_cell_string(`SS' str, `SS' font, `SS' bold,  
				 `SS' italic, `SS' script, `SS' bgcolor, 
				 `SS' underline, `SS' strikeout)
{
	`FTI'			fti
	`CI'			color
	`SS'			cstr
	`CPTS'			pt
	
	if (strlen(str) == 0) {
		return(str)
	}
	
	pt = PdfText()
	pt.addString(str)
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, NULL)
		if (fti.name != "") {
			pt.setFont(fti.name, "regular")
		}
		if (fti.size != 0) {
			pt.setFontSize(fti.size)
		}
		if (fti.color != J(1,1,NULL)) {
			pt.setColor(fti.color->r, fti.color->g, fti.color->b)
		}
	}
	if (bold != "") {
		(void) pt.setFontStyle("Bold")
	}
	if (italic != "") {
		(void) pt.setFontStyle("Italic")
	}
	
	if (script != "") {
		(void) pdf_text_set_script(pt, script)
	}
	
	if (bgcolor != "") {
		(void) pdf_parse_color(bgcolor, color)
		pt.setBgColor(color.r, color.g, color.b)
	}
	
	if (underline != "") {
		pt.setUnderline()
	}
	if (strikeout != "") {
		pt.setStrikethru()
	}
	
	cstr = pt.getContent()
	
	return(cstr)
}

void pdf_table_check_cell_prop(`SS' font, `SS' script, `SS' halign, 
			       `SS' valign, `SS' bgcolor, `SS' borders, 
			       `SS' margins, `RS' rowspan, `RS' colspan, 
			       `SS' span, `SS' nformat)
{
	`FTI'			fti
	`CI' 			color
	`RS'			span1, span2
	`SS'			srowspan, scolspan
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, NULL)
	}
	
	if (script != "") {
		script = strtrim(script)
		if (script!="sub" & script!="super") {
		errprintf("option {bf:script()} specified incorrectly\n")
			exit(198)			
		}
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
		if (valign=="center") {
			valign = "middle"
		}
		if (valign != "top" & valign != "bottom" & 
			valign != "middle" & valign != "center") {
		errprintf("option {bf:valign()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (bgcolor != "") {
		if (strpos(bgcolor, ",")!=0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		if (pdf_parse_color(bgcolor, color)==0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
	}
	
	if (borders != "") {
		(void) pdf_cell_set_border_wrk(NULL, -1, -1, borders)
	}
	
	if (margins != "") {
		(void) pdf_cell_set_margin_wrk(NULL, -1, -1, margins)
	}
	
	if (rowspan != 1) {
		if (rowspan < 1) {
		errprintf("invalid {bf:rowspan()}; rows out of range\n")
			exit(198)
		}
	}
	
	if (colspan != 1) {
		if (colspan < 1) {
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
			
			if (span1 < 1) {
		errprintf("invalid {bf:span()}; rows out of range\n")
				exit(198)
			}
			if (span2 < 1) {
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

void pdf_table_set_cell_wrk(`SS' font, `SS' bold, `SS' italic, `SS' script,
			    `SS' underline, `SS' strikeout, 
			    `SS' halign, `SS' valign, `SS' bgcolor, 
			    `SS' borders, `SS' margins, `RS' rowspan, 
			    `RS' colspan, `SS' span, `SS' append, 
			    `SS' nformat, `RS' linebreaks, `SS' allcaps)
{
	`TR'			t
	`SS'			token, cell, cellexp, tblname, cellstr
	`TCCI' 			tcci
	`RS'			row, col
	`RS'			tappend
	`pTable'		tbl, src_tbl
	`RR'			tblinfo
	`pDocument' scalar	pDoc
	
	cellexp = st_local("cellexplist")
	tblname = bsubstr(cellexp, 1, strpos(cellexp, "(")-1)
	cellexp = bsubstr(cellexp, strpos(cellexp, "("), .)
	
	pDoc = findexternal("pdf__global")
	tbl = pDoc->gettbl(tblname)
	if (tbl == NULL) {
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
				if (pdf_check_paren(token)) {
					errprintf("%s: table name must be enclosed in ()\n", token)
					exit(198)
				}
				(void) pdf_parse_cellexplist(tcci, cell, 
					token, 3, 0)
			}
			else if (token == "image") {
				token = tokenget(t)
				if (pdf_check_paren(token)) {
					errprintf("%s: image must be enclosed in ()\n", token)
					exit(198)
				}
				(void) pdf_parse_cellexplist(tcci, cell, 
					token, 2, 0)
			}
			else {
				token = strtrim(bsubstr(cellexp, strpos(cellexp, "=")+1, .))
				if (bsubstr(token, 1, 1)=="(") {
					(void) pdf_parse_cellexplist(tcci, cell, 
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
			(void) pdf_parse_cellexplist(tcci, token, "()", 0, 1)
		}
	}
	
	row = tcci.row 
	col = tcci.col 
	tblinfo = pdf_get_table_info(tblname)
	if (row <= 0 | row > tblinfo[2]) {
		errprintf("invalid cell specification; row out of range\n")
		exit(198)
	}
	if (col <= 0 | col > tblinfo[3]) {
		errprintf("invalid cell specification; column out of range\n")
		exit(198)
	}
	
	(void) pdf_table_check_cell_prop(font, script, halign, valign, 
					 bgcolor, borders, margins, 
					 rowspan, colspan, span, nformat)

	tappend = 0
	if (append != "") {
		tappend = 1
	}
	
	if (tappend==1) {
		if (tcci.type==2) {
errprintf("option {bf:append} and {bf:image()} can not be specified together\n") 
			exit(198)
		}
		if (tcci.type==3) {
errprintf("option {bf:append} and {bf:table()} can not be specified together\n")
			exit(198)
		}
	}
	
	if (tcci.type == 1) {
		if (nformat != "") {
			nformat = strtrim(nformat)
			tcci.exp = put_format_value(tcci.exp, nformat)
		}
		if (allcaps != "") {
			tcci.exp = ustrupper(tcci.exp)
		}
		
		if (strlen(tcci.exp)!=0) {
			cellstr = pdf_table_parse_cell_string(tcci.exp, font, bold, 
				italic, script, bgcolor, underline, strikeout)
			
			tbl->setCellContentString2(row, col, cellstr, tappend, 0)
			if (tbl->getLastError()) {
				errprintf("failed to set cell font\n")
				exit(198)
			}
		}
		else {
			tbl->setCellContentString2(row, col, "", tappend, 2)
			if (tbl->getLastError()) {
				errprintf("failed to set cell font\n")
				exit(198)
			}			
		}
		
		font = ""
		bold = ""
		italic = ""
		nformat = ""
		bgcolor = ""
		allcaps = ""
	}
	else if (tcci.type == 2) {
		tbl->setCellContentImage(row, col, tcci.image)
	}
	else if (tcci.type == 3) {
		src_tbl = pDoc->gettbl(tcci.table)
		if (src_tbl == NULL) {
			errprintf("table %s does not exist\n", tcci.table)
			exit(198)
		}
		
		tbl->setCellContentTable(row, col, *src_tbl)		
	}
	else {
		cellstr = pdf_table_parse_cell_string(" ", "", bold, 
			italic, script, "", underline, strikeout)

		tbl->setCellContentString2(row, col, cellstr, 0, 1)
		if (tbl->getLastError()) {
			errprintf("failed to set cell font\n")
			exit(198)
		}	
	}

	(void) pdf_table_set_cell_attr(tbl, row, col, 
				font, bold, italic,
				halign, valign, bgcolor, 
				borders, margins,  
				rowspan, colspan, span, 
				nformat, linebreaks, allcaps)
}

void pdf_table_set_row_wrk(`SS' tinfo, `SS' split, `SS' addrows, `SS' drop,
			   `SS' font, `SS' bold, `SS' italic,
			   `SS' underline, `SS' strikeout, 
			   `SS' halign, `SS' valign, `SS' bgcolor, 
			   `SS' borders, `SS' margins, `SS' nformat, 
			   `SS' allcaps)
{
	`RS'			row, i
	`SS'			srow, sname, snadds, safter, cellstr
	`RR'			tblinfo
	`RS'			nadds, bafter, colcount
	`pTable'		tbl
	`pDocument' scalar	pDoc
	
	(void) pdf_is_valid()
	
	srow = bsubstr(tinfo, 1, strpos(tinfo, "_")-1)
	row = strtoreal(srow)
	
	sname = bsubstr(tinfo, strpos(tinfo, "_")+1, .)
	tblinfo = pdf_get_table_info(sname)
	
	if (row <= 0 | row > tblinfo[2]) {
	errprintf("invalid specification; row out of range\n")
		exit(198)
	}
	
	pDoc = findexternal("pdf__global")
	tbl = pDoc->gettbl(sname)
	if (tbl == NULL) {
		errprintf("table %s does not exist\n", sname)
		exit(198)
	}
	
	if (split != "") {
		tbl->setRowSplit(row, 1)
		if (tbl->getLastError()) {
			errprintf("failed to set row split property\n")
			exit(198)
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
				tbl->addRow(row+i-1)
			}
			else {
				tbl->addRow(row+i)
			}
			if (tbl->getLastError()) {
				errprintf("failed to add rows to table\n")
				exit(198)
			}
		}
	}
	
	if (drop != "") {
		tbl->delRow(row)
		if (tbl->getLastError()) {
			errprintf("failed to delete row from table\n")
			exit(198)
		}
	}
	
	(void) pdf_table_check_cell_prop(font, "", halign, valign, 
					 bgcolor, borders, margins, 
					 1, 1, "", nformat)
	
	colcount = tblinfo[3]
	if (colcount <= 0) {
		exit(198)
	}
	
	for(i=1; i<=colcount; i++) {
		if ((bold!="") | (italic!="") | (underline!="") | (strikeout!="")) {
			cellstr = pdf_table_parse_cell_string(" ", "", bold, 
				italic, "", "", underline, strikeout)

			tbl->setCellContentString2(row, i, cellstr, 0, 1)
			if (tbl->getLastError()) {
				errprintf("failed to set cell font\n")
				exit(198)
			}
		}
		
		(void) pdf_table_set_cell_attr(tbl, row, i, font, bold, italic,
				halign, valign, bgcolor, borders, margins,  
				1, 1, "", nformat, 0, allcaps)
	}
}

void pdf_table_set_column_wrk(`SS' tinfo, `SS' addcols, `SS' drop,
			      `SS' font, `SS' bold, `SS' italic,
			      `SS' underline, `SS' strikeout, 
			      `SS' halign, `SS' valign, `SS' bgcolor, 
			      `SS' borders, `SS' margins, `SS' nformat, 
			      `SS' allcaps)
{
	`RS'			col, i
	`SS'			scol, sname, snadds, sbefore, cellstr
	`RR'			tblinfo
	`RS'			nadds, bleft, rowcount
	`pTable'		tbl
	`pDocument' scalar	pDoc
	
	(void) pdf_is_valid()
	
	scol = bsubstr(tinfo, 1, strpos(tinfo, "_")-1)
	col = strtoreal(scol)
	
	sname = bsubstr(tinfo, strpos(tinfo, "_")+1, .)
	tblinfo = pdf_get_table_info(sname)
	
	if (col <= 0 | col > tblinfo[3]) {
		errprintf("invalid specification; column out of range\n")
		exit(198)
	}
	
	pDoc = findexternal("pdf__global")
	tbl = pDoc->gettbl(sname)
	if (tbl == NULL) {
		errprintf("table %s does not exist\n", sname)
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
			if (bleft == 1) {
				tbl->addColumn(col+i-1)
			}
			else {
				tbl->addColumn(col+i)
			}
			if (tbl->getLastError()) {
				errprintf("failed to add columns to table\n")
				exit(198)
			}
		}
	}
	
	if (drop != "") {
		tbl->delColumn(col)
		if (tbl->getLastError()) {
			errprintf("failed to delete column from table\n")
			exit(198)
		}
	}
	
	(void) pdf_table_check_cell_prop(font, "", halign, valign, 
					 bgcolor, borders, margins, 
					 1, 1, "", nformat)
	
	rowcount = tblinfo[2]
	if (rowcount <= 0) {
		exit(198)
	}
	
	for(i=1; i<=rowcount; i++) {
		if ((bold!="") | (italic!="") | (underline!="") | (strikeout!="")) {
			cellstr = pdf_table_parse_cell_string(" ", "", bold, 
				italic, "", "", underline, strikeout)

			tbl->setCellContentString2(i, col, cellstr, 0, 1)
			if (tbl->getLastError()) {
				errprintf("failed to set cell font\n")
				exit(198)
			}
		}
		
		(void) pdf_table_set_cell_attr(tbl, i, col, font, bold, italic,
				halign, valign, bgcolor, borders, margins,  
				1, 1, "", nformat, 0, allcaps)
	}	
}

void pdf_table_set_cell_range_wrk(`SS' tinfo, `SS' rrange, `SS' crange, 
				  `SS' font, `SS' bold, `SS' italic,
				  `SS' underline, `SS' strikeout, 
				  `SS' halign, `SS' valign, `SS' bgcolor, 
				  `SS' borders, `SS' margins, `SS' nformat, 
				  `SS' allcaps)
{
	`RS'			nrows, ncols, i, j, rowcount, colcount, rc
	`SS'			quote, tblname, numcmd, cellstr
	`RR'			tblinfo, rownum, colnum
	`RC'			crownum, ccolnum
	`pTable'		tbl
	`pDocument' scalar	pDoc
	
	(void) pdf_is_valid()
	
	tblname = bsubstr(tinfo, 1, strpos(tinfo, "(")-1)
	tblinfo = pdf_get_table_info(tblname)
	rowcount = tblinfo[2]
	colcount = tblinfo[3]
	
	pDoc = findexternal("pdf__global")
	tbl = pDoc->gettbl(tblname)
	if (tbl == NULL) {
		errprintf("table %s does not exist\n", tblname)
		exit(198)
	}
	
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
	
	(void) pdf_table_check_cell_prop(font, "", halign, valign, 
					 bgcolor, borders, margins, 
					 1, 1, "", nformat)
	
	nrows = cols(rownum)
	ncols = cols(colnum)
	for(i=1; i<=nrows; i++) {
		for(j=1;j<=ncols;j++) {
			if ((bold!="") | (italic!="") | (underline!="") | (strikeout!="")) {
				cellstr = pdf_table_parse_cell_string(" ", "", bold, 
					italic, "", "", underline, strikeout)

				tbl->setCellContentString2(rownum[i], colnum[j], cellstr, 0, 1)
				if (tbl->getLastError()) {
					errprintf("failed to set cell font\n")
					exit(198)
				}
			}
			
			(void) pdf_table_set_cell_attr(tbl, rownum[i], colnum[j], font, bold, 
					italic, halign, valign, bgcolor, borders, margins,  
					1, 1, "", nformat, 0, allcaps)
		}
	}
}

void pdf_add_pagebreak_wrk()
{
	`pDocument' scalar	pDoc
		
	(void) pdf_paragraph_add_wrk()
	(void) pdf_table_add_wrk()
	
	pDoc = findexternal("pdf__global")
	pDoc->addNewPage()
	if (pDoc->getLastError()) {
		errprintf("failed to add pagebreak\n")
		exit(198)
	}
}

void pdf_set_section_wrk(`pDocument' pDoc, `SS' font, `SS' pagesize, 
			`SS' landscape, `SS' margins, `SS' halign, 
			`SS' bgcolor)
{
	`FTI'			fti
	`CI' 			color
	
	if (font != "") {
		(void) pdf_parse_font(font, fti, pDoc)
		if (fti.name != "") {
			pDoc->setFont(fti.name, "regular")
			if (pDoc->getLastError()) {
				errprintf("failed to set font\n")
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
		}
		if (fti.size) {
			pDoc->setFontSize(fti.size)
			if (pDoc->getLastError()) {
				errprintf("failed to set font size\n")
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
		}
		if (fti.color != J(1,1,NULL)) {
			pDoc->setColor(fti.color->r, fti.color->g, 
				fti.color->b)
			if (pDoc->getLastError()) {
				errprintf("failed to set font color\n")
				(void) pdf_close_wrk(pDoc)
				exit(198)
			}
		}		
	}
	else {
		pDoc->setFont("Helvetica", "regular")
		if (pDoc->getLastError()) {
			errprintf("failed to set font\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
		pDoc->setFontSize(11)
		if (pDoc->getLastError()) {
			errprintf("failed to set font size\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
		pDoc->setColor(0, 0, 0)
		if (pDoc->getLastError()) {
			errprintf("failed to set font color\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	
	if (pagesize != "") {
		pagesize = strtrim(pagesize)
		if (pagesize!="letter" & pagesize!="legal" & 
			pagesize!="A3" & pagesize!="A4" & 
			pagesize!="A5" & pagesize!="B4" & pagesize!="B5") {
		errprintf("option {bf:pagesize()} specified incorrectly\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}	
	}
	else {
		pagesize = "letter"
	}
	pDoc->setPageSize(pagesize)
	if (pDoc->getLastError()) {
		errprintf("failed to set page size\n")
		(void) pdf_close_wrk(pDoc)
		exit(198)
	}
	
	if (landscape != "") {
		pDoc->setLandscape(1)
		if (pDoc->getLastError()) {
			errprintf("failed to set orientation\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	else {
		pDoc->setLandscape(0)
		if (pDoc->getLastError()) {
			errprintf("failed to set orientation\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	
	if (margins != "") {
		(void) pdf_set_margin_wrk(pDoc, margins)
	}
	else {
		pDoc->setMargins2(36, 36, 36, 36)
		if (pDoc->getLastError()) {
			errprintf("failed to set margin\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	
	if (halign != "") {
		halign = strtrim(halign)
		if (halign!="left" & halign!="right" & halign!="center") {
		errprintf("option {bf:halign()} specified incorrectly\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)	
		}
		pDoc->setHAlignment(halign)	
	}
	else {
		pDoc->setHAlignment("left")
	}
	
	if (bgcolor != "") {
		if (strpos(bgcolor, ",")!=0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		if (pdf_parse_color(bgcolor, color)==0) {
		errprintf("option {bf:bgcolor()} specified incorrectly\n")
			exit(198)
		}
		pDoc->setBgColor(color.r, color.g, color.b)
		if (pDoc->getLastError()) {
			errprintf("failed to set background color\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}
	}
	else {
		pDoc->setBgColor(255, 255, 255)
		if (pDoc->getLastError()) {
			errprintf("failed to set background color\n")
			(void) pdf_close_wrk(pDoc)
			exit(198)
		}	
	}
}

void pdf_add_sectionbreak_wrk(`SS' font, `SS' pagesize, `SS' landscape, 
			      `SS' margins, `SS' halign, `SS' bgcolor)
{
	`pDocument' scalar	pDoc
	
	(void) pdf_add_pagebreak_wrk()
	pDoc = findexternal("pdf__global")
	
	(void) pdf_set_section_wrk(pDoc, font, pagesize, landscape, margins, 
			   halign, bgcolor)
}

void pdf_add_etable_wrk(`SS' tename, `SS' tetable, `SS' memtable, 
			`SS' widths, `SS' halign, `SS' indent, 
			`SS' spacings, `SS' borders, `SS' title, 
			`SS' notes)
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
		(void) pdf_is_valid()
		(void) pdf_paragraph_add_wrk()
	
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
		
		(void) pdf_is_valid()
		(void) pdf_paragraph_add_wrk()
		
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

	(void) pdf_table_add_etable_wrk(etir, memtable, widths, halign, indent, 
				spacings, borders, title, notes)
}

void pdf_table_add_etable_wrk(`ETIR' etir, `SS' memtable, `SS' widths, 
			      `SS' halign, `SS' indent, `SS' spacings, 
			      `SS' borders, `SS' title, `SS' notes)
{
	`RS'			i, etcount, boverr, overcount
	`SS'			tnames, soverr
	
	(void) pdf_is_valid()
	(void) pdf_paragraph_add_wrk()
	
	etcount = cols(etir)
	tnames = ""
	soverr = ""
	overcount = 0
	for(i=1; i<=etcount; i++) {
		boverr = pdf_check_table_name(etir[i].tname)
		(void) pdf_add_etable(etir[i], memtable, widths, 
			halign, indent, spacings, borders, title, notes)
		tnames = tnames + " " + etir[i].tname
		if (boverr > 0) {
			soverr = soverr + " " + etir[i].tname
			overcount = overcount + 1
		}
	}
	
	if (etcount > 1) {
		printf("{txt}(note: table " + "{cmd:" + ustrtrim(tnames) + "} are added)\n")
	}
	if (bstrlen(soverr) != 0) {
		if (overcount > 1) {
printf("{txt}(note: tables " + "{cmd:" + ustrtrim(soverr) + "} have been redefined)\n")
		}
		else {
printf("{txt}(note: table " + "{cmd:" + ustrtrim(soverr) + "} has been redefined)\n")		
		}
	}
}

void pdf_add_etable(`ETI' eti, `SS' memtable, `SS' widths, `SS' halign, 
		    `SS' indent, `SS' spacings, `SS' borders, `SS' title, 
		    `SS' notes)
{
	`pDocument' scalar	pDoc
	`CPTBLS'		tbl
	`RS'			err, nspan, halignv
	`RS'			i, j, nrow, ncol, ktitle
	
	if (memtable == "") {
		(void) pdf_table_add_wrk()
	}
	
	pDoc = findexternal("pdf__global")
	
	nrow = eti.nrow 
	ncol = eti.ncol 
	ktitle = eti.ktitle
	
	tbl.setErrorMode("off")
	tbl.init(nrow, ncol)
	err = tbl.getLastError()
	if (err > 0) {
		if (err==17121) {
			errprintf("maximum number of rows exceeded; limit 65535\n")
			exit(198)				
		}
		else if (err==17128) {
			errprintf("maximum number of columns exceeded; limit 50\n")
			exit(198)
		}
		else {
			errprintf("failed to add table\n")
			exit(198)
		}
	}
	tbl.setName(eti.tname)
	tbl.setType(2)
	if (memtable == "") {
		pDoc->addtbl(&tbl, 0)
	}
	else {
		pDoc->addtbl(&tbl, 1)
	}
	
	(void) pdf_update(2)
	
	if (memtable == "") {
		st_global("ST__PDF_CUR_TABLE", "0")
	}
		
	tbl.setBorderWidth(0, "all")
	tbl.setBorderWidth(1, "top")
	tbl.setBorderWidth(1, "bottom")
	
	(void) pdf_table_set_attr(&tbl, eti.tname, widths, halign, indent, 
		spacings, borders, "", "")
	
	for(i=1; i<=nrow; i++) {
		for(j=1; j<=ncol; j++) {
			tbl.setCellContentString(i, j, eti.val[i, j])
			tbl.setCellMargin(i, j, 5, "left")
			tbl.setCellMargin(i, j, 5, "right")
			halignv = eti.halign[i, j]
			if (missing(halignv)) {
				tbl.setCellHAlignment(i, j, "right")
			}
			nspan = eti.hspan[i, j]
			if (!missing(nspan)) {
				tbl.setCellColSpan(i, j, nspan)
			}
			if (i<=ktitle) {
				if (i==ktitle) {
					tbl.setCellBorderWidth(i, j, 1, "bottom")
				}
			}
			else {
				if (eti.vsep[1, i-ktitle]==1) {
					tbl.setCellBorderWidth(i, j, 1, "top")
				}
			}
			
			if (j==1) {
				tbl.setCellBorderWidth(i, j, 1, "end")
			}
		}
	}
	
	(void) put_etable_star2(eti, &tbl)
	(void) pdf_table_set_title_note(&tbl, eti.tname, title, notes)
}

void pdf_file_get_abspath(`SS' filename, `SS' loc)
{
	`SS' using_file
	
	using_file = pdf_check_filename(filename, 0)
	if (fileexists(using_file)) {
		(void)pathresolve(pwd(), using_file, loc)
	}
}

end
