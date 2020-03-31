*! version 1.0.4  13feb2015
program _multiplemat_tab
	version 10

	local lsize = c(linesize)
	tempname mtab
	forvalues i = 1/12 {
		tempname t
		local temps `temps' `t'
	}
	mata: JUST__val = "{lalign " \ "{center " \ "{ralign "
	mata: FONT__val = "{sf:" \ "{it:" \ "{bf:"
	mata: REND__val = "{txt:" \ "{res:" \ "{inp:" \ "{err:"

	capture noisily MatTab `mtab' "`temps'" `0'
	local therc = c(rc)

	// drop all Mata objects that might have been used and left behind
	DropThem JUST__val FONT__val REND__val `mtab' `temps'

	set linesize `lsize'

	exit `therc'
end


// ! TODO list
// -- widths(#) sets default format to %#.0g, but with # <= 4 that automatic
//      goes to sci notation?  Consider looking to see if all integers < 10,000
//      (for 4, or 1,000 for 3 ...) and if so have default be %#.0f


program MatTab

	gettoken mtab 0 : 0
	gettoken temps 0 : 0

// Syntax:
//
//     _multiplemat_tab (mat [, opts]) [(mat [, opts]) ...] [, gopts]
//
// (also allowed in place of grouping each matrix and associated options in
// "()" is to divide them using "||"
//
//     _multiplemat_tab mat [, opts] [|| mat [, opts] ...] [||, gopts]

	local gopts ///
		ROWNames(string asis)	/// do row names? (and what formatting)
		COLNames(string asis)	/// do col names? (and what formatting)
		LINes(string asis)	/// where lines should be drawn
		TITle(string asis)	/// overall title
		Key(string asis)	/// table key
		Widths(numlist integer >0 <=244)  /// main table column widths
			/// 244 above is from old limit of %#.0g format.  It
			/// is much larger than what will be requested anyway.
		LEFT(numlist integer max=1 >=0)   /// left indent for table
		RIGHT(numlist integer max=1 >=0)  /// right indent for table
		noBLank			/// suppress blank line before table
		LINESIZE(numlist integer max=1 >=40 <=255) // override linesize

				     // global options may be shared
	_parse expand cmd glob : 0 , common(`gopts')

	if `"`glob_if'`glob_in'"' != "" { // if & in not allowed
		error 198
	}

	if `cmd_n' < 1 {
		error 198
	}

	// Take care of gopts options that might be multiply specified
	_parse combop glob_op : glob_op , option(ROWNames) rightmost opsin
	_parse combop glob_op : glob_op , option(COLNames) rightmost opsin
	_parse combop glob_op : glob_op , option(LINes) rightmost opsin
	_parse combop glob_op : glob_op , option(TITle) rightmost opsin
	_parse combop glob_op : glob_op , option(Key) rightmost opsin
	_parse combop glob_op : glob_op , option(Widths) rightmost opsin
	_parse combop glob_op : glob_op , option(LEFT) rightmost opsin
	_parse combop glob_op : glob_op , option(RIGHT) rightmost opsin
	_parse combop glob_op : glob_op , option(LINESIZE) rightmost opsin

	// Parse global options
	local 0 `", `glob_op'"'
	syntax [, `gopts' ]

	// Set defaults and check for errors
	if (`"`linesize'"' == "")	local linesize = c(linesize)
	else				local linesize `linesize'
	if (`"`left'"' == "")		local left 0
	if (`"`right'"' == "")		local right 0
	if `left' >= `linesize'-5 {
		di as err "left(`left') is too extreme"
		exit 125
	}
	if `right' >= `linesize'-5 {
		di as err "right(`right') is too extreme"
		exit 125
	}
	if `right'+`left' >= `linesize'-5 {
		di as err "left(`left') and right(`right') are too extreme"
		exit 125
	}
	local tabwid = `linesize'-`right'-`left' // This takes care of right()

	// Initialize mata structures
	mata: `mtab' = _mmt_InitTab(`left', `tabwid')

	// grab the matrix names and their options
	forvalues i = 1/`cmd_n' {
		local 0 `"`cmd_`i''"'
		local synx syntax ///
		  anything(name=xmat id="matrix name or matrix expression") ///
			[, ///
			FORmat(string asis)	/// format for elements
			Justification(str asis) /// elements: left|right|center
			FONt(string asis)	/// font for elements
			RENder(string asis)	/// color rendering for elements
			KEYEntry(passthru)	/// Key entry
			BLanks(numlist miss)	/// treat these values as blanks
			OMITLine(numlist miss min=1 max=1) /// omit line from
						/// table if it has only this #
			]
		capture `synx'
		if c(rc) {
			di as err "invalid matrix specification:"
			di as err `"{p 4 8 2}`0'{p_end}"'
			`synx' // redo syntax to get error message displayed
		}

	    // Take care of -xmat-
		// handle matrix name or matrix expression
		capture confirm matrix `xmat'
		if c(rc) { // not an existing matrix; see if matrix expression
			tempname amat
			capture mat `amat' = `xmat'
			if c(rc) {
				di as err `"{p 0 4 2}invalid matrix name "' ///
					`"or expression: `0'{p_end}"'
				exit c(rc)
			}
		}
		else { // xmat is a matrix
			local amat `xmat'
		}

		// check the matrix is same size as others
		if "`nrow'`ncol'" != "" {
			if `nrow' != rowsof(`amat') | ///
			   `ncol' != colsof(`amat') {
				di as err "conformability error"
				di as err "{p}matrix `xmat' is " ///
					rowsof(`amat') " by " ///
					colsof(`amat') "; a " ///
					"`nrow' by `ncol' matrix " ///
					"was expected{p_end}"
				exit 503
			}
		}
		else {	// first matrix
			local nrow = rowsof(`amat')
			local ncol = colsof(`amat')

			// Take care of global -widths()- option
			local haswid 0
			local wcwid : word count `widths'
			if `wcwid' == 0 {
				local widdef "%9.0g"
			}
			else if inlist(`wcwid',1,`ncol') {
				local widdef : ///
					subinstr local widths " " ".0g %", all
				local widdef %`widdef'.0g
				local haswid 1
			}
			else {
				di as err "{p}" ///
					"widths() has `wcwid' elements; " ///
					"1 or `ncol' elements expected{p_end}"
				exit 125
			}
		}

		// first matrix is used for grabbing row/column/equation names
		// (we ignore the name stripes on the remaining matrices)
		if `"`firstmat'"' == "" {
			local firstmat `amat'

			local reqstripe : roweq `amat'
			local hasroweqs 1
			if `"`: list uniq reqstripe'"' == "_" {
				local hasroweqs 0
			}

			local ceqstripe : coleq `amat'
			local hascoleqs 1
			if `"`: list uniq ceqstripe'"' == "_" {
				local hascoleqs 0
			}
		}

	    // Take care of -keyentry()-
		// take keyentry() info and store in akey mata structure
		ParseKeyEntry , `keyentry' ///
			mtstruct(`mtab') default(`xmat') jdefault(left) ///
			fdefault(sf) rdefault(txt) temps(`temps')

		local mfrm : word 1 of `temps'
		local mjst : word 2 of `temps'
		local mfnt : word 3 of `temps'
		local mrnd : word 4 of `temps'

	    // Take care of -format()-
		ParseFormat `"`xmat'"' `nrow' `ncol' `mfrm' "`widdef'" `format'

	    // Take care of -justification()-
		ParseJust `"`xmat'"' `nrow' `ncol' `mjst' "right" ///
							`justification'

	    // Take care of -font()-
		ParseFont `"`xmat'"' `nrow' `ncol' `mfnt' "sf" `font'

	    // Take care of -render()-
		ParseRend `"`xmat'"' `nrow' `ncol' `mrnd' "res" `render'

	    // Place the information in `mtab' Mata structure
		mata: _mmt_AddMat(`mtab', `nrow', `ncol', "`amat'", ///
				"`blanks'", "`omitline'", `mfrm', ///
				`mjst', `mfnt', `mrnd')

		DropThem `mfrm' `mjst' `mfnt' `mrnd'
	}

	// Parse key()
	ParseKey "`mtab'" "`temps'" "`linesize'" `"`key'"'

	// Parse lines()
	if `"`lines'"' == "" {	// if empty, set default lines()
		if `cmd_n' == 1 { // only 1 matrix
			local lines left top eq
		}
		else { // more than 1 matrix
			local lines left top eq rows(gap)
		}
	}
	ParseLines `mtab' , `lines' nr(`nrow') nc(`ncol') ///
		reqnames(`"`reqstripe'"') ceqnames(`"`ceqstripe'"')

	// Parse rownames()
	ParseRNames "`mtab'" "`temps'" ///
		"`firstmat'" "`hasroweqs'" `"`reqstripe'"' `"`rownames'"'

	// Parse colnames()
	ParseCNames "`mtab'" "`temps'" ///
		"`firstmat'" "`hascoleqs'" `"`ceqstripe'"' `"`colnames'"'

	// Parse title()
	ParseTitle "`mtab'" "`temps'" "`linesize'" `"`title'"'

	// Figure/set column widths
	if (`haswid')	mata: _mmt_SetColWids(`mtab', "`widths'")
	else		mata: _mmt_SetColWids(`mtab', "0")

    	// Take care of any loose ends in mtab
	mata: _mmt_FixIt(`mtab')

	// Display the table
	mata: _mmt_DispTable(`mtab', `= "`blank'"==""')
end

program DropThem
	while `"`0'"' != "" {
		gettoken todrop 0 : 0
		capture mata: mata drop `todrop'
	}
end

// parses the equations() suboption of colnames()
program ParseCNeq
	args eqjv eqfv eqrv cnt rest

	mata: _mmt_SetConstants("EQC")
	local eqwhere `EQC_off'	// off until found otherwise

	local who `"colnames(... equations(`rest'))"'
	local 0 `", `rest'"'

	local synx syntax [, ///
		OFF ON			/// show col eq names?
		BIND			/// try to keep eq columns together
		FIRST			/// show eq name above first colname
		EACH			/// show eq name above each colname
		COMbined		/// show eq name spanned over colnames
		Justification(passthru)	/// col eq names justification
		FONt(passthru)		/// col eq names font
		RENder(passthru)	/// col eq names render
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	capture opts_exclusive "`off' `on'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "`off' `on'"
	}

	capture opts_exclusive `"`off' `bind'"'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive `"`off' `bind'"'
	}
	capture opts_exclusive `"`off' `first' `each' `combined'"'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive `"`off' `first' `each' `combined'"'
	}
	if `"`first'`each'`combined'"' == "" & "`off'" == "" {
		local first first
	}

	if ("`first'" != "")		local eqwhere `EQC_first'
	else if ("`each'" != "")	local eqwhere `EQC_each'
	else if (`"`combined'"' != "")	local eqwhere `EQC_span'

	// Set mata vector `eqjv' to justification code(s) for eq names
	ParseJustk , `justification' k(`cnt') default(left) mvec(`eqjv') ///
			from("colnames(... equations") forcek

	// Set mata vector `eqfv' to font code(s) for eq names
	ParseFontk , `font' k(`cnt') default(sf) mvec(`eqfv') ///
			from("colnames(... equations") forcek

	// Set mata vector `eqrv' to render code(s) for eq names
	ParseRendk , `render' k(`cnt') default(txt) mvec(`eqrv') ///
			from("colnames(... equations") forcek

	// set the callers local macros: eqwhere and eqbind
	c_local eqwhere `eqwhere'
	c_local eqbind `= "`bind'" == "bind"'
end

// parses the equations() suboption of rownames()
program ParseRNeq
	args haseqs eqjv eqfv eqrv cnt rest

	mata: _mmt_SetConstants("EQR")
	local eqwhere `EQR_off'	// off until found otherwise
	local eqwid 0		// no width until found otherwise
	local eqsep		// no eq separator until found otherwise

	local who `"rownames(... equations(`rest'))"'
	local 0 `", `rest'"'

	local synx syntax [, ///
		OFF ON			/// show row eq names?
		BEFore			/// show eq on own line before rownames
		BEFOREUnderline		/// -before- with line under it
		FIRST(passthru)		/// show eq on first line of rownames
		EACH(passthru)		/// show eq on each line of rownames
		Justification(passthru)	/// row eq names justification
		FONt(passthru)		/// row eq names font
		RENder(passthru)	/// row eq names render
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	capture opts_exclusive "`off' `on'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "`off' `on'"
	}
	capture opts_exclusive ///
			`"`off' `before' `beforeunderline' `first' `each'"'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive ///
			`"`off' `before' `beforeunderline' `first' `each'"'
	}
	if `"`before'`beforeunderline'`first'`each'"' == "" & ///
						"`off'" == "" & `haseqs' {
		local before before
	}

	if "`before'" != "" {
		local eqwhere `EQR_before'
	}
	else if "`beforeunderline'" != "" {
		local eqwhere `EQR_ulbefore'
	}
	else if `"`first'"' != "" {
		local eqwhere `EQR_first'
		local 0 `", `first'"'
		syntax [, first(string asis) ]
		local 0 `"`first'"'
		local syx syntax anything(name=eqwidth equalok everything) ///
				[, SEP(string) ]
		capture `syx'
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "invalid first()"
			`syx' // redo syntax to get error message displayed
		}
		capture numlist `"`eqwidth'"' , min(1) max(1) range(> 0) int
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "invalid first()"
			numlist `"`eqwidth'"' , min(1) max(1) range(> 0) int
		}
		if `: length local sep' >= `eqwidth' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "invalid first()"
			di as err `"{p}`sep' is too long{p_end}"'
			exit 198
		}
		local eqwid `eqwidth'
		local eqsep `"`sep'"'
	}
	else if `"`each'"' != "" {
		local eqwhere `EQR_each'
		local 0 `", `each'"'
		syntax [, each(string asis) ]
		local 0 `"`each'"'
		local syx syntax anything(name=eqwidth equalok everything) ///
				[, SEP(string) ]
		capture `syx'
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "invalid each()"
			`syx' // redo syntax to get error message displayed
		}
		capture numlist `"`eqwidth'"' , min(1) max(1) range(> 0) int
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "invalid each()"
			numlist `"`eqwidth'"' , min(1) max(1) range(> 0) int
		}
		if `: length local sep' >= `eqwidth' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "invalid each()"
			di as err `"{p}`sep' is too long{p_end}"'
			exit 198
		}
		local eqwid `eqwidth'
		local eqsep `"`sep'"'
	}

	// Set mata vector `eqjv' to justification code(s) for eq names
	ParseJustk , `justification' k(`cnt') default(left) mvec(`eqjv') ///
			from("rownames(... equations") forcek

	// Set mata vector `eqfv' to font code(s) for eq names
	ParseFontk , `font' k(`cnt') default(sf) mvec(`eqfv') ///
			from("rownames(... equations") forcek

	// Set mata vector `eqrv' to render code(s) for eq names
	ParseRendk , `render' k(`cnt') default(txt) mvec(`eqrv') ///
			from("rownames(... equations") forcek

	// set the callers local macros: eqwhere, eqwid, and eqsep
	c_local eqwhere `eqwhere'
	c_local eqwid   `eqwid'
	c_local eqsep   `"`eqsep'"'
end

// parses the title() suboption of rownames() or colnames()
program ParseRCNamTitle
	args rorc tjv tfv trv tv rest

	if `"`rest'"' == "" {	// No title suboption
		mata: `tjv' = J(0,1,.)
		mata: `tfv' = J(0,1,.)
		mata: `trv' = J(0,1,.)
		mata: `tv'  = J(0,1,"")

		exit
	}

	// `rorc' is "rownames" or "colnames"
	local who `"`rorc'(... title(`rest'))"'
	local 0 `"`rest'"'

	local synx syntax ///
		anything(name=title id="title" equalok everything) [, ///
		Justification(passthru)	/// row or col names title justific.
		FONt(passthru)		/// row or col names title font
		RENder(passthru)	/// row or col names title render
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	if `"`title'"' == "" & ///
		`"`justification'`font'`render'"' != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		     `"title() options not allowed without specifying a title"'
		exit 198
	}

	local tcnt 0
	while `"`title'"' != "" {
		gettoken atitle title : title , qed(hasq)
		while `"`title'"' != "" & !`hasq' {
			gettoken nxt : title , qed(hasq)
			if !`hasq' {
				gettoken nxt title : title
				local atitle `"`atitle' `nxt'"'
			}
		}
		local ++tcnt
		local t`tcnt' `"`atitle'"'
	}

	// Set mata vector `tjv' to justification code(s) for title(s)
	ParseJustk , `justification' k(`tcnt') default(left) ///
			mvec(`tjv') from("`rorc'(... title") forcek

	// Set mata vector `tfv' to font code(s) for title(s)
	ParseFontk , `font' k(`tcnt') default(sf) mvec(`tfv') ///
			from("`rorc'(... title") forcek

	// Set mata vector `trv' to render code(s) for title(s)
	ParseRendk , `render' k(`tcnt') default(txt) mvec(`trv') ///
			from("`rorc'(... title") forcek

	// put the title line(s) into mata string matrix `tv'
	local dot `"`"`t1'"'"'
	forvalues i = 2/`tcnt' {
		local dot `"`dot' \ `"`t`i''"'"'
	}
	mata: `tv' = `dot'
end

program ParseTitle
	args m temps linesize rest

	local mintitlelen 1

	if `"`rest'"' == "" { // No title option; do nothing
		exit
	}

	local who `"title(`rest')"'
	local 0 `"`rest'"'

	local synx syntax ///
		anything(name=title id="title" equalok everything) [, ///
		Justification(passthru)		 /// key title justification
		FONt(passthru)			 /// key title font
		RENder(passthru)		 /// key title render
		LEFT(numlist integer max=1 >=0)  /// left indent for title
		RIGHT(numlist integer max=1 >=0) /// right indent for title
		WIDth(numlist integer max=1 >=0) /// width for title
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	if `"`title'"' == "" & ///
		`"`justification'`font'`render'`left'`right'"' != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		     `"title() options not allowed without specifying a title"'
		exit 198
	}

	// sets local `mainleft' to overall left for table
	mata: _mmt_GetItLoc(`m',"mainleft","left")

	if `: word count `left' `right' `width'' > 2 {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		   "only two of left(), right(), and width() may be specified"
		exit 198
	}

	if (`"`left'"' == "")	local left `mainleft'

	if `linesize'-`left' < 1 {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err "left(`left') is too extreme"
		exit 125
	}
	// `left' is now set, resolve width() and right() and set `width'

	if "`width'`right'" == "" { // no width() and no right()
		local width = `linesize'-`left'
	}
	else if "`right'" == "" { // width() and no right()
		if `width' > `linesize'-`left' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "width(`width') is too extreme"
			exit 125
		}
	}
	else if "`width'" == "" { // right() and no width()
		if `linesize'-`left'-`right' < `mintitlelen' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "right(`right') is too extreme"
			exit 125
		}
		local width = `linesize'-`left'-`right'
	}
	else { // both width() and right()
		if `linesize'-`left'-`right' < `width' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err ///
			 "width(`width') and right(`right') are too extreme"
			exit 125
		}
	}

	local tcnt 0
	while `"`title'"' != "" {
		gettoken atitle title : title , qed(hasq)
		while `"`title'"' != "" & !`hasq' {
			gettoken nxt : title , qed(hasq)
			if !`hasq' {
				gettoken nxt title : title
				local atitle `"`atitle' `nxt'"'
			}
		}

		local ++tcnt
		local t`tcnt' `"`atitle'"'
	}

	local jv : word 1 of `temps'
	local fv : word 2 of `temps'
	local rv : word 3 of `temps'
	local tv : word 4 of `temps'

	// Set mata vector `jv' to justification code(s) for title(s)
	ParseJustk , `justification' k(`tcnt') default(left) ///
			mvec(`jv') from("title") forcek

	// Set mata vector `fv' to font code(s) for title(s)
	ParseFontk , `font' k(`tcnt') default(sf) mvec(`fv') ///
			from("title") forcek

	// Set mata vector `rv' to render code(s) for title(s)
	ParseRendk , `render' k(`tcnt') default(txt) mvec(`rv') ///
			from("title") forcek

	// put the title line(s) into mata string matrix `tv'
	local dot `"`"`t1'"'"'
	forvalues i = 2/`tcnt' {
		local dot `"`dot' \ `"`t`i''"'"'
	}
	mata: `tv' = `dot'

	mata: _mmt_AddTitle(`m',	  ///
		`left',			  /// left indent for title
		`width',		  /// width for title
		`jv',			  /// justification(s) for title(s)
		`fv',			  /// font(s) for title(s)
		`rv',			  /// render(s) for title(s)
		`tv'			  /// title(s)
		)

	DropThem `jv' `fv' `rv' `tv'
end

program GetKArgs
	gettoken subop 0 : 0
	gettoken mnam  0 : 0
	gettoken nrow  0 : 0
	gettoken ncol  0 : 0

	syntax [anything(id="`subop'()" name=sop)] [, ///
			Row Column Allroworder ALLColorder]

	local cnt : list sizeof sop

	opts_exclusive ///
		"`row' `column' `allroworder' `allcolorder'" `subop'
	if "`row'" != "" {
		local expectk `nrow'
	}
	if "`column'" != "" {
		local expectk `ncol'
	}
	if "`allroworder'" != "" | "`allcolorder'" != "" {
		local expectk = `nrow'*`ncol'
	}
	if "`row'`column'`allroworder'`allcolorder'" != "" {
		if `cnt' != `expectk' {
			di as err `"{p}`cnt' `subop'() arguments found "' ///
				`"for matrix `mnam'; `expectk' arguments "' ///
				`"expected{p_end}"'
			exit 198
		}
	}
	else {
		if `cnt' <= 1 {
			local onlyone onlyone
			local expectk 1
		}
		else if `cnt' == `nrow'*`ncol' {
			local allroworder allroworder
			local expectk = `nrow'*`ncol'
		}
		else if `nrow' == `ncol' & `cnt' == `nrow' {
			di as err `"{p}invalid `subop'() option for "' ///
				`"matrix `mnam'; specify suboption row or "' ///
				`"column to clarify how to apply the "' ///
				`"`cnt' arguments{p_end}"'
			exit 198
		}
		else if `cnt' == `ncol' {
			local column column
			local expectk `ncol'
		}
		else if `cnt' == `nrow' {
			local row row
			local expectk `nrow'
		}
		else {
			NumCommaSort 0 1 `nrow' `ncol' `= `nrow'*`ncol''
			di as err `"{p}option `subop'(`sop') invalid for "' ///
				`"matrix `mnam'; `cnt' arguments found, "' ///
				`"`r(nlist)' arguments expected{p_end}"'
			exit 198
		}
	}

	c_local hask `expectk'
	c_local arglist `"`sop'"'
	c_local mshape `onlyone' `row' `column' `allroworder' `allcolorder'
end

program ParseFormat
	gettoken mnam 0 : 0
	gettoken nrow 0 : 0
	gettoken ncol 0 : 0
	gettoken mmat 0 : 0
	gettoken def  0 : 0

	// does error checking and sets locals `hask', `arglist', and `mshape'
	GetKArgs "format" `"`mnam'"' `nrow' `ncol' `0'

	if `"`arglist'"' != "" {
		local frmtopt `"format(`arglist')"'
	}

	capture ParseFormatk , k(`hask') mvec(`mmat') default(`def') `frmtopt'
	if c(rc) { // try with  ncol instead of hask
		capture ParseFormatk , k(`ncol') mvec(`mmat') ///
						default(`def') `frmtopt'
		if c(rc) { // rerun with hask without capture to get error out
			ParseFormatk , k(`hask') mvec(`mmat')
						default(`def') `frmtopt'
		}
		else {
			local mshape column
		}
	}

	if "`mshape'" == "column" {
		// mshape==column --> return a row vector with ncol elements
		mata: `mmat' = `mmat''
	}
	else if "`mshape'" == "allroworder" {
		// mshape==allroworder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `ncol')
	}
	else if "`mshape'" == "allcolorder" {
		// mshape==allcolorder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `nrow')'
	}
	// else mshape is "row" or "onlyone" and mmat is already correct shape
end


program ParseJust
	gettoken mnam 0 : 0
	gettoken nrow 0 : 0
	gettoken ncol 0 : 0
	gettoken mmat 0 : 0
	gettoken def  0 : 0

	// does error checking and sets locals `hask', `arglist', and `mshape'
	GetKArgs "justification" `"`mnam'"' `nrow' `ncol' `0'

	if `"`arglist'"' != "" {
		local justopt `"justification(`arglist')"'
	}

	ParseJustk , k(`hask') mvec(`mmat') default(`def') `justopt'

	if "`mshape'" == "column" {
		// mshape==column --> return a row vector with ncol elements
		mata: `mmat' = `mmat''
	}
	else if "`mshape'" == "allroworder" {
		// mshape==allroworder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `ncol')
	}
	else if "`mshape'" == "allcolorder" {
		// mshape==allcolorder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `nrow')'
	}
	// else mshape is "row" or "onlyone" and mmat is already correct shape
end

program ParseFont
	gettoken mnam 0 : 0
	gettoken nrow 0 : 0
	gettoken ncol 0 : 0
	gettoken mmat 0 : 0
	gettoken def  0 : 0

	// does error checking and sets locals `hask', `arglist', and `mshape'
	GetKArgs "font" `"`mnam'"' `nrow' `ncol' `0'

	if `"`arglist'"' != "" {
		local fontopt `"font(`arglist')"'
	}

	ParseFontk , k(`hask') mvec(`mmat') default(`def') `fontopt'

	if "`mshape'" == "column" {
		// mshape==column --> return a row vector with ncol elements
		mata: `mmat' = `mmat''
	}
	else if "`mshape'" == "allroworder" {
		// mshape==allroworder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `ncol')
	}
	else if "`mshape'" == "allcolorder" {
		// mshape==allcolorder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `nrow')'
	}
	// else mshape is "row" or "onlyone" and mmat is already correct shape
end

program ParseRend
	gettoken mnam 0 : 0
	gettoken nrow 0 : 0
	gettoken ncol 0 : 0
	gettoken mmat 0 : 0
	gettoken def  0 : 0

	// does error checking and sets locals `hask', `arglist', and `mshape'
	GetKArgs "render" `"`mnam'"' `nrow' `ncol' `0'

	if `"`arglist'"' != "" {
		local rendopt `"render(`arglist')"'
	}

	ParseRendk , k(`hask') mvec(`mmat') default(`def') `rendopt'

	if "`mshape'" == "column" {
		// mshape==column --> return a row vector with ncol elements
		mata: `mmat' = `mmat''
	}
	else if "`mshape'" == "allroworder" {
		// mshape==allroworder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `ncol')
	}
	else if "`mshape'" == "allcolorder" {
		// mshape==allcolorder --> transform vector into matrix
		mata: `mmat' = colshape(`mmat', `nrow')'
	}
	// else mshape is "row" or "onlyone" and mmat is already correct shape
end

program ParseFormatk
	syntax , k(integer) mvec(string) default(string) [FORmat(string) FORCEK]

	local who `"format(`format')"'

	if ("`forcek'" == "")	local kor1 1
	else			local kor1 `k'

	local 0 `"`format'"'
	syntax [anything(id="format()" name=format)] [, ///
			Row Column Allroworder ALLColorder]
	if "`row'`column'`allroworder'`allcolorder'" != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		 "`: word 1 of `row' `column' `allroworder' `allcolorder''" ///
			" not allowed"
		exit 198
	}
	DropThem `mvec'
	local fcnt : list sizeof format
	if `fcnt' == 0 {
		local defcnt : word count `default'
		if `defcnt' == 1 {
			capture confirm format `default'
			if c(rc) {
				di as err `"{p 0 4}invalid `who'{p_end}"'
				confirm format `default'
			}
			mata: `mvec' = J(`kor1',1,`"`default'"')
		}
		else if `defcnt' == `k' {
			mata: `mvec' = tokens(`"`default'"')'
		}
		else { // shouldn't happen
			di as err ///
		  "Invalid default() and k() in call to ParseFormatk subroutine"
			exit 198
		}
		exit
	}
	else if `fcnt' == 1 {
		capture confirm format `format'
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			confirm format `format'
		}
		mata: `mvec' = J(`kor1',1,`"`format'"')
		exit
	}
	else if `fcnt' == `k' {
		mata: `mvec' = J(`k',1,"")
		forvalues ji = 1/`k' {
			gettoken af format : format
			capture confirm format `af'
			if c(rc) {
				di as err `"{p 0 4}invalid `who'{p_end}"'
				confirm format `af'
			}
			mata: `mvec'[`ji',1] = `"`af'"'
		}
		exit
	}
	else {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		if `k' > 1 {
			di as err ///
				`"has `fcnt' arguments; 0, 1, or `k' expected"'
		}
		else {
			di as err `"has `fcnt' arguments; 0 or 1 expected"'
		}
		exit 198
	}
end

program ParseJustk
	syntax , k(integer) mvec(string) default(string) ///
		[Justification(string) from(string) FORCEK]

	if `"`from'"' != "" {
		local tmp : subinstr local from "(" " " , all count(local pcnt)
		local who `"`from'(..., justification(`justification'))"'
		forvalues i=1/`pcnt' {
			local who `"`who')"'
		}
	}
	else {
		local who `"justification(`justification')"'
	}

	if ("`forcek'" == "")	local kor1 1
	else			local kor1 `k'

	local 0 `"`justification'"'
	syntax [namelist(id="justification()" name=just)] [, ///
			Row Column Allroworder ALLColorder]
	if "`row'`column'`allroworder'`allcolorder'" != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		 "`: word 1 of `row' `column' `allroworder' `allcolorder''" ///
			" not allowed"
		exit 198
	}
	mata: _mmt_SetConstants("J")
	DropThem `mvec'
	local jcnt : list sizeof just
	if `jcnt' == 0 {
		if lower(`"`default'"') == "left" {
			mata: `mvec' = J(`kor1',1,`J_left')
		}
		else if lower(`"`default'"') == "right" {
			mata: `mvec' = J(`kor1',1,`J_right')
		}
		else if lower(`"`default'"') == "center" {
			mata: `mvec' = J(`kor1',1,`J_center')
		}
		else {
			di as err "Programmer error: illegal " ///
					"default() argument to ParseJustk"
			exit 9967
		}
		exit
	}
	else if `jcnt' == 1 {
		local 0 `", `just'"'
		capture syntax [, Left Right Center]
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err `"`just' not allowed"'
			exit 198
		}
		if "`left'" != "" {
			mata: `mvec' = J(`kor1',1,`J_left')
		}
		else if "`right'" != "" {
			mata: `mvec' = J(`kor1',1,`J_right')
		}
		else if "`center'" != "" {
			mata: `mvec' = J(`kor1',1,`J_center')
		}
		exit
	}
	else if `jcnt' == `k' {
		mata: `mvec' = J(`k',1,.)
		forvalues ji = 1/`k' {
			gettoken aj just : just
			local 0 `", `aj'"'
			capture syntax [, Left Right Center]
			if c(rc) {
				di as err `"{p 0 4}invalid `who'{p_end}"'
				di as err `"`aj' not allowed"'
				exit 198
			}
			if "`left'" != "" {
				mata: `mvec'[`ji',1] = `J_left'
			}
			else if "`right'" != "" {
				mata: `mvec'[`ji',1] = `J_right'
			}
			else if "`center'" != "" {
				mata: `mvec'[`ji',1] = `J_center'
			}
		}
		exit
	}
	else {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		if `k' > 1 {
			di as err ///
				`"has `jcnt' arguments; 0, 1, or `k' expected"'
		}
		else {
			di as err `"has `jcnt' arguments; 0 or 1 expected"'
		}
		exit 198
	}
end

program ParseFontk
	syntax , k(integer) mvec(string) default(string) ///
		[font(string) from(string) FORCEK]

	if `"`from'"' != "" {
		local tmp : subinstr local from "(" " " , all count(local pcnt)
		local who `"`from'(..., font(`font'))"'
		forvalues i=1/`pcnt' {
			local who `"`who')"'
		}
	}
	else {
		local who `"font(`font')"'
	}

	if ("`forcek'" == "")	local kor1 1
	else			local kor1 `k'

	local 0 `"`font'"'
	syntax [namelist(id="font()" name=font)] [, ///
		Row Column Allroworder ALLColorder]
	if "`row'`column'`allroworder'`allcolorder'" != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		 "`: word 1 of `row' `column' `allroworder' `allcolorder''" ///
			" not allowed"
		exit 198
	}
	mata: _mmt_SetConstants("F")
	DropThem `mvec'
	local fcnt : list sizeof font
	if `fcnt' == 0 {
		if lower(`"`default'"') == "sf" {
			mata: `mvec' = J(`kor1',1,`F_sf')
		}
		else if lower(`"`default'"') == "it" {
			mata: `mvec' = J(`kor1',1,`F_it')
		}
		else if lower(`"`default'"') == "bf" {
			mata: `mvec' = J(`kor1',1,`F_bf')
		}
		else {
			di as err "Programmer error: illegal default() " ///
					"argument to ParseFontk"
			exit 9967
		}
		exit
	}
	else if `fcnt' == 1 {
		local 0 `", `font'"'
		cap syntax [, Sf Standardfont Italics Bf Boldface]
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err `"`font' not allowed"'
			exit 198
		}
		if "`sf'" != "" | "`standardfont'" != "" {
			mata: `mvec' = J(`kor1',1,`F_sf')
		}
		else if "`italics'" != "" {
			mata: `mvec' = J(`kor1',1,`F_it')
		}
		else if "`bf'" != "" | "`boldface'" != "" {
			mata: `mvec' = J(`kor1',1,`F_bf')
		}
		exit
	}
	else if `fcnt' == `k' {
		mata: `mvec' = J(`k',1,.)
		forvalues fi = 1/`k' {
			gettoken af font : font
			local 0 `", `af'"'
			cap syntax [, Sf Standardfont Italics Bf Boldface]
			if c(rc) {
				di as err `"{p 0 4}invalid `who'{p_end}"'
				di as err `"`af' not allowed"'
				exit 198
			}
			if "`sf'" != "" | "`standardfont'" != "" {
				mata: `mvec'[`fi',1] = `F_sf'
			}
			else if "`italics'" != "" {
				mata: `mvec'[`fi',1] = `F_it'
			}
			else if "`bf'" != "" | "`boldface'" != "" {
				mata: `mvec'[`fi',1] = `F_bf'
			}
		}
		exit
	}
	else {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		if `k' > 1 {
			di as err ///
				`"has `fcnt' arguments; 0, 1, or `k' expected"'
		}
		else {
			di as err `"has `fcnt' arguments; 0 or 1 expected"'
		}
		exit 198
	}
end

program ParseRendk
	syntax , k(integer) mvec(string) default(string) ///
		[RENder(string) from(string) FORCEK]

	if `"`from'"' != "" {
		local tmp : subinstr local from "(" " " , all count(local pcnt)
		local who `"`from'(..., render(`render'))"'
		forvalues i=1/`pcnt' {
			local who `"`who')"'
		}
	}
	else {
		local who `"render(`render')"'
	}

	if ("`forcek'" == "")	local kor1 1
	else			local kor1 `k'

	local 0 `"`render'"'
	capture syntax [namelist(id="render()" name=render)] [, ///
			Row Column Allroworder ALLColorder]
	if "`row'`column'`allroworder'`allcolorder'" != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		 "`: word 1 of `row' `column' `allroworder' `allcolorder''" ///
				" not allowed"
		exit 198
	}
	mata: _mmt_SetConstants("R")
	DropThem `mvec'
	local rcnt : list sizeof render
	if `rcnt' == 0 {
		if lower(`"`default'"') == "txt" {
			mata: `mvec' = J(`kor1',1,`R_txt')
		}
		else if lower(`"`default'"') == "res" {
			mata: `mvec' = J(`kor1',1,`R_res')
		}
		else if lower(`"`default'"') == "inp" {
			mata: `mvec' = J(`kor1',1,`R_inp')
		}
		else if lower(`"`default'"') == "err" {
			mata: `mvec' = J(`kor1',1,`R_err')
		}
		else {
			di as err "Programmer error: illegal default() " ///
				"argument to ParseRendk"
			exit 9967
		}
		exit
	}
	else if `rcnt' == 1 {
		local 0 `", `render'"'
		cap syntax [, Text Txt Green Result Yellow ///
				Input While Command Cmd Error RED]
		if c(rc) {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err `"`render' not allowed"'
			exit 198
		}
		if "`text'" != "" | "`txt'" != "" | "`green'" != "" {
			mata: `mvec' = J(`kor1',1,`R_txt')
		}
		else if "`result'" != "" | "`yellow'" != "" {
			mata: `mvec' = J(`kor1',1,`R_res')
		}
		else if "`input'" != "" | "`white'" != "" | ///
				"`command'" != "" | "`cmd'" != "" {
			mata: `mvec' = J(`kor1',1,`R_inp')
		}
		else if "`error'" != "" | "`red'" != "" {
			mata: `mvec' = J(`kor1',1,`R_err')
		}
		exit
	}
	else if `rcnt' == `k' {
		mata: `mvec' = J(`k',1,.)
		forvalues ri = 1/`k' {
			gettoken ar render : render
			local 0 `", `ar'"'
			cap syntax [, Text Txt Green Result Yellow ///
					Input While Command Cmd Error RED]
			if c(rc) {
				di as err `"{p 0 4}invalid `who'{p_end}"'
				di as err `"`ar' not allowed"'
				exit 198
			}
			if "`text'" != "" | "`txt'" != "" | ///
						"`green'" != "" {
				mata: `mvec'[`ri',1] = `R_txt'
			}
			else if "`result'" != "" | "`yellow'" != "" {
				mata: `mvec'[`ri',1] = `R_res'
			}
			else if "`input'" != "" | "`white'" != "" | ///
				"`command'" != "" | "`cmd'" != "" {
				mata: `mvec'[`ri',1] = `R_inp'
			}
			else if "`error'" != "" | "`red'" != "" {
				mata: `mvec'[`ri',1] = `R_err'
			}
		}
		exit
	}
	else {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		if `k' > 1 {
			di as err ///
				`"has `rcnt' arguments; 0, 1, or `k' expected"'
		}
		else {
			di as err `"has `rcnt' arguments; 0 or 1 expected"'
		}
		exit 198
	}
end

program ParseKeyEntry
	syntax , mtstruct(str) DEFault(str) JDEFault(str) FDEFault(str) ///
		RDEFault(str) TEMPS(str) [KEYEntry(str asis)]

	// append keyentry() info into the mata structure `mtstruct'

	local who `"keyentry(`keyentry')"'

	local 0 `"`keyentry'"'
	local synx syntax [anything(name=keyent id="keyentry" ///
						equalok everything)] ///
		[, ///
		OMIT					///
		Justification(passthru)			///
		FONt(passthru)				///
		RENder(passthru)			///
		]
	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	if "`omit'" == "omit" {
		// We leave the mata structure `mtstruct' unchanged
		exit
	}

	local kcnt 0
	while `"`keyent'"' != "" {
		gettoken onekey keyent : keyent , qed(hasq)
		while `"`keyent'"' != "" & !`hasq' {
			gettoken nxt : keyent , qed(hasq)
			if !`hasq' {
				gettoken nxt keyent : keyent
				local onekey `"`onekey' `nxt'"'
			}
		}

		local ++kcnt
		local ent_`kcnt' `"`onekey'"'
	}

	if `kcnt' == 0 {
		local ent_1 `"`default'"'
		local ++kcnt
	}

	local jv   : word 1 of `temps'
	local fv   : word 2 of `temps'
	local rv   : word 3 of `temps'
	local evec : word 4 of `temps'

	// sets local jst_count and jst_1, jst_2, ...
	ParseJustk , `justification' k(`kcnt') default(`jdefault') ///
			mvec(`jv') from("keyentry") forcek

	// sets local fnt_count and fnt_1, fnt_2, ...
	ParseFontk , `font' k(`kcnt') default(`fdefault') mvec(`fv') ///
			from("keyentry") forcek

	// sets local rnd_count and rnd_1, rnd_2, ...
	ParseRendk , `render' k(`kcnt') default(`rdefault') mvec(`rv') ///
			from("keyentry") forcek

	local doe `"`"`ent_1'"'"'
	forvalues i = 2/`kcnt' {
		local doe `"`doe' \ `"`ent_`i''"'"'
	}
	mata: `evec' = `doe'

	mata: _mmt_AddKeyEntry(`mtstruct',`jv',`fv',`rv',`evec')

	DropThem `jv' `fv' `rv' `evec'
end

// parses the colnames() option
program ParseCNames
	args mtstruct temps firstmat haseqs eqstripe rest

	local who `"colnames(`rest')"'
	local 0 `"`rest'"'
	local synx syntax [, ///
		OFF ON			/// Display col names? (0=off, 1=on)
		UNDERscore		/// change underscores to spaces
		Justification(passthru)	/// col name justifications
		FONt(passthru)		/// col name fonts
		RENder(passthru)	/// col name renders
		TITle(string asis)	/// title above col names
		EQuations(string asis)	/// equation names
		LINes(string asis)	/// line specification
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	capture opts_exclusive "`off' `on'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "`off' `on'"
	}
	if ("`off'`on'" == "") local on on

	// sets local `cnt' to the number of columns
	mata: _mmt_GetItLoc(`mtstruct',"cnt","c")

    // Set mata vector `jv' to justification codes for col names
	local jv : word 1 of `temps'
	ParseJustk , `justification' k(`cnt') default(right) ///
			mvec(`jv') from("colnames") forcek

    // Set mata vector `fv' to font code(s) for col names
	local fv : word 2 of `temps'
	ParseFontk , `font' k(`cnt') default(sf) mvec(`fv') ///
			from("colnames") forcek

    // Set mata vector `rv' to render code(s) for col names
	local rv : word 3 of `temps'
	ParseRendk , `render' k(`cnt') default(txt) mvec(`rv') ///
			from("colnames") forcek

    // handle title() suboption
	local tjv : word 4 of `temps'
	local tfv : word 5 of `temps'
	local trv : word 6 of `temps'
	local tv  : word 7 of `temps'
	ParseRCNamTitle "colnames" "`tjv'" "`tfv'" "`trv'" "`tv'" `"`title'"'

    // handle equations() suboption
	local eqjv : word 8 of `temps'
	local eqfv : word 9 of `temps'
	local eqrv : word 10 of `temps'
	if `"`equations'"' == "" & !`haseqs' {
		// There are col equation names but no equations() option
		// Set default behavior
		local equations on combined
	}
	ParseCNeq `eqjv' `eqfv' `eqrv' `cnt' `"`equations'"'
	// ParseCNeq sets local macros: eqwhere and eqbind

    // handle lines() suboption
	local lcv : word 11 of `temps'
	local lrv : word 12 of `temps'
	if (`"`lines'"' == "") local lines inherit
	ParseCNLines `lcv' `lrv' `mtstruct' `eqwhere' `"`eqstripe'"' `"`lines'"'

    // Add the col name info to mata structure
	mata: _mmt_AddCNames(`mtstruct', ///
		`= "`on'" == "on"',	/// show column names?
		"`firstmat'",		/// first Stata matrix
		`= "`underscore'" == "underscore"', /// underscores ==> spaces
		`jv',			/// justification(s) for colnames
		`fv',			/// font(s) for colnames
		`rv',			/// render(s) for colnames
		`eqbind',		/// bind columns for eq together?
		`eqwhere',		/// where to place eq names
		`eqjv',			/// equation name justification
		`eqfv',			/// equation name font
		`eqrv',			/// equation name render
		`tv',			/// title over column names
		`tjv',			/// justification for title over colnams
		`tfv',			/// font for title over colnames
		`trv',			/// render for title over colnames
		`lcv',			/// column lines (indicator vector)
		`lrv'			/// row lines (indicator vector)
		)

	DropThem `jv' `fv' `rv' `tjv' `tfv' `trv' `tv' ///
		 `eqjv' `eqfv' `eqrv' `lcv' `lrv'
end

// Parses the rownames() option
program ParseRNames
	args mtstruct temps firstmat haseqs eqstripe rest

	local minrownamewid 1
	local defaultnamewid 12

	local who `"rownames(`rest')"'
	local 0 `"`rest'"'
	local synx syntax [, ///
		OFF ON			/// Display row names? (0=off, 1=on)
		WIDth(numlist integer max=1 >=0) /// width of the column
		UNDERscore		/// change underscores to spaces
		Justification(passthru)	/// row name justifications
		FONt(passthru)		/// row name fonts
		RENder(passthru)	/// row name renders
		TITle(string asis)	/// title above row names
		EQuations(string asis)	/// equation names
		LINes(string asis)	/// line specification
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	capture opts_exclusive "`off' `on'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "`off' `on'"
	}
	if ("`off'`on'" == "") local on on

	// sets local `cnt' to the number of rows
	mata: _mmt_GetItLoc(`mtstruct',"cnt","r")

    // handle width() option
	// sets local `mainwid' to overall width for table
	mata: _mmt_GetItLoc(`mtstruct',"mainwid","width")

	if "`width'" == "" { // no width given, set default
		local width `defaultnamewid'
	}
	else if ("`on'" == "on") & (`mainwid' > 0) ///
				& (`mainwid'-`width' < `minrownamewid') {
		di as err `"{p 0 4}invalid width() suboption of `who'{p_end}"'
		di as err ///
		    "width(`width') too extreme compared to overall table width"
		exit 125
	}

    // Set mata vector `jv' to justification codes for row names
	local jv : word 1 of `temps'
	ParseJustk , `justification' k(`cnt') default(right) ///
			mvec(`jv') from("rownames") forcek

    // Set mata vector `fv' to font code(s) for row names
	local fv : word 2 of `temps'
	ParseFontk , `font' k(`cnt') default(sf) mvec(`fv') ///
			from("rownames") forcek

    // Set mata vector `rv' to render code(s) for row names
	local rv : word 3 of `temps'
	ParseRendk , `render' k(`cnt') default(txt) mvec(`rv') ///
			from("rownames") forcek

    // handle title() suboption
	local tjv : word 4 of `temps'
	local tfv : word 5 of `temps'
	local trv : word 6 of `temps'
	local tv  : word 7 of `temps'
	ParseRCNamTitle "rownames" "`tjv'" "`tfv'" "`trv'" "`tv'" `"`title'"'

    // handle equations() suboption
	local eqjv : word 8 of `temps'
	local eqfv : word 9 of `temps'
	local eqrv : word 10 of `temps'
	if `"`equations'"' == "" & `haseqs' {
		// There are row equation names but no equations() option
		// Set default behavior
		local equations on before
	}
	ParseRNeq `haseqs' `eqjv' `eqfv' `eqrv' `cnt' `"`equations'"'
		// ParseRNeq sets local macros: eqwhere, eqwid, and eqsep
	if `width' - `eqwid' < `minrownamewid' {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err `"{p}width(`width') insufficient for specified "' ///
				`"equations() suboption{p_end}"'
		exit 198
	}

    // handle lines() suboption
	local lcv : word 11 of `temps'
	local lrv : word 12 of `temps'
	if (`"`lines'"' == "")	local lines inherit
	ParseRNLines `lcv' `lrv' `mtstruct' `eqwhere' `"`eqstripe'"' `"`lines'"'

    // Add the row name info to mata structure
	mata: _mmt_AddRNames(`mtstruct', ///
		`= "`on'" == "on"',	/// show column with rownames?
		"`firstmat'",		/// first Stata matrix
		`= "`underscore'" == "underscore"', /// underscores ==> spaces
		`width',		/// width of column for rownames
		`jv',			/// justification(s) for rownames
		`fv',			/// font(s) for rownames
		`rv',			/// render(s) for rownames
		`eqwhere',		/// where to place eq names
		`eqwid',		/// width for equation names
		`"`eqsep'"',		/// equation separator string
		`eqjv',			/// equation name justification
		`eqfv',			/// equation name font
		`eqrv',			/// equation name render
		`tv',			/// title over rowname column
		`tjv',			/// justification for rowname col title
		`tfv',			/// font for rowname column title
		`trv',			/// render for rowname column title
		`lcv',			/// column lines (indicator vector)
		`lrv'			/// row lines (indicator vector)
		)

	DropThem `jv' `fv' `rv' `tjv' `tfv' `trv' `tv' ///
		 `eqjv' `eqfv' `eqrv' `lcv' `lrv'
end

// Parses the key() option, setting the appropriate values in the mata
// key structure.
program ParseKey
	args mtstruct temps linesize rest

	local minkeylen 5

	local who `"key(`rest')"'
	local 0 `"`rest'"'
	local synx syntax [anything(name=keytitle equalok everything)] [, ///
		OFF ON			/// present the key or not
		noTItle			/// suppress the key title
		TOP BOTtom		/// place key above or below table
		LEFTx RIGHTx CENter	/// place key left right or centered
		LEFT(numlist integer max=1 >=0)  /// left indent for key
		RIGHT(numlist integer max=1 >=0) /// right indent for key
		WIDth(numlist integer max=1 >=0) /// total width for key
		Justification(passthru)	/// key title justification
		FONt(passthru)		/// key title font
		RENder(passthru)	/// key title render
		LINes(string asis)	/// key border and interior lines
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	capture opts_exclusive "`off' `on'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "`off' `on'"
	}

	capture opts_exclusive "`top' `bottom'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "`top' `bottom'"
	}

	capture opts_exclusive "`leftx' `rightx' `center'"
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		// chop off the "x" at the end
		opts_exclusive ///
		"`= usubstr("`leftx'",1,4)' `= usubstr("`rightx'",1,5)' `center'"
	}
	mata: _mmt_SetConstants("J")
	if ("`center'" != "")		local keywhere `J_center'
	else if ("`rightx'" != "")	local keywhere `J_right'
	else /* default is leftx */	local keywhere `J_left'

	// check/set left() right() and width()
	// the resolved `left' and `width' are what are used later

	if `: word count `left' `right' `width'' > 2 {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err ///
		   "only two of left(), right(), and width() may be specified"
		exit 198
	}

	if "`left'" == "" {
		// sets local `left' to overall left for table
		mata: _mmt_GetItLoc(`mtstruct',"left","left")
	}
	else if `linesize'-`left' < `minkeylen' {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err "left(`left') is too extreme"
		exit 125
	}
	// `left' is now set, resolve width() and right() and set `width'

	if "`width'`right'" == "" { // no width() and no right()
		local width = `linesize'-`left'
	}
	else if "`right'" == "" { // width() and no right()
		if `width' > `linesize'-`left' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "width(`width') is too extreme"
			exit 125
		}
	}
	else if "`width'" == "" { // right() and no width()
		if `linesize'-`left'-`right' < `minkeylen' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err "right(`right') is too extreme"
			exit 125
		}
		local width = `linesize'-`left'-`right'
	}
	else { // both width() and right()
		if `linesize'-`left'-`right' < `width' {
			di as err `"{p 0 4}invalid `who'{p_end}"'
			di as err ///
			 "width(`width') and right(`right') are too extreme"
			exit 125
		}
	}

	local ktcnt 0
	while `"`keytitle'"' != "" {
		gettoken onekeyt keytitle : keytitle , qed(hasq)
		while `"`keytitle'"' != "" & !`hasq' {
			gettoken nxt : keytitle , qed(hasq)
			if !`hasq' {
				gettoken nxt keytitle : keytitle
				local onekeyt `"`onekeyt' `nxt'"'
			}
		}

		local ++ktcnt
		local kt_`ktcnt' `"`onekeyt'"'
	}

	if `ktcnt' == 0 {
		local kt_1 "Key"
		local ++ktcnt
	}

	// ParseKeyLines sets locals: lineright, lineleft, linetop,
	//     linebottom, linetitle, and linerow
	if (`"`lines'"' == "") local lines standard	// default: standard
	ParseKeyLines , `lines'

	local jv  : word 1 of `temps'
	local fv  : word 2 of `temps'
	local rv  : word 3 of `temps'
	local ktv : word 4 of `temps'

	// Set mata vector `jv' to justification code(s) for key title(s)
	ParseJustk , `justification' k(`ktcnt') default(left) ///
			mvec(`jv') from("key") forcek

	// Set mata vector `fv' to font code(s) for key title(s)
	ParseFontk , `font' k(`ktcnt') default(sf) mvec(`fv') ///
			from("key") forcek

	// Set mata vector `rv' to render code(s) for key title(s)
	ParseRendk , `render' k(`ktcnt') default(txt) mvec(`rv') ///
			from("key") forcek

	// put the key title line(s) into mata string matrix `ktv'
	local dokt `"`"`kt_1'"'"'
	forvalues i = 2/`ktcnt' {
		local dokt `"`dokt' \ `"`kt_`i''"'"'
	}
	mata: `ktv' = `dokt'

	mata: _mmt_AddKeyMain(`mtstruct', ///
		`= "`off'"==""',	  /// show key table?
		`= "`bottom'"==""',	  /// key table above main table?
		`keywhere',		  /// ... left, center, or right?
		`= "`title'"!="notitle"', /// show the key title?
		`left',			  /// left indent for key table
		`width',		  /// width for key table
		`lineright',		  /// right border line?
		`lineleft',		  /// left border line?
		`linetop',		  /// top border line?
		`linebottom',		  /// bottom border line?
		`linetitle',		  /// line under title?
		`linerow',		  /// line between each row?
		`jv',			  /// justification(s) for key title(s)
		`fv',			  /// font(s) for key title(s)
		`rv',			  /// render(s) for key title(s)
		`ktv'			  /// key title(s)
		)

	DropThem `jv' `fv' `rv' `ktv'
end

program ParseKeyLines
	syntax [, Left Right Top Bottom BOX TITle STandard ROws ALL]

	if "`all'" != "" {
		local box box
		local title title
		local rows rows
	}

	if "`standard'" != "" {
		local box box
		local title title
	}

	if "`box'" != "" {
		local left left
		local right right
		local top top
		local bottom bottom
	}

	// set caller's local macros
	c_local lineleft `= "`left'"=="left"'
	c_local lineright `= "`right'"=="right"'
	c_local linetop `= "`top'"=="top"'
	c_local linebottom `= "`bottom'"=="bottom"'
	c_local linetitle `= "`title'"=="title"'
	c_local linerow `= "`rows'"=="rows"'
end

program ParseCNLines
	args lcv lrv mt eqwhere eqstripe rest

	mata: _mmt_SetConstants("EQC")
	mata: _mmt_SetConstants("L")

	local who `"colnames(... lines(`rest'))"'
	local 0 `", `rest'"'

	local synx syntax [, ///
		Left Right Top Bottom BOX COLumns COLumns2(string)	///
		LAst EQuations HOREQuations TITle ALL INHerit		///
		ATRows(string) ATCols(string)				///
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	local opta `"`left'`right'`top'`bottom'`box'`columns'`columns2'`last'"'
	local opta `"`opta'`equations'`horequations'`title'`all'`inherit'"'
	if `"`opta'"' != "" & (`"`atrows'"' != "" | `"`atcols'"' != "") {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err "{p}suboptions atrows() and atcols() not " ///
			"allowed with other lines() suboptions{p_end}"
		exit 198
	}

	mata: _mmt_GetItLoc(`mt',"nc","c") // sets local `nc' to number of cols
	local numcol = `nc' + 1
	local numrow = 4  // for: top, title, eqnames, bottom (under colnames)
			  // if title or eqnames not used, its row ignored

	if `"`atrows'"' != "" | `"`atcols'"' != "" {
		mata: `lrv' = J(0,0,.)
		mata: `lcv' = J(0,0,.)
		mata: _mmt_SetAtLines("colnames(... lines())",`numrow', ///
			`numcol',`"`atrows'"',`"`atcols'"',`lrv',`lcv')
		exit
	}

	if `"`columns2'"' != "" & "`columns'" != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "columns columns()"
	}

	tempname xrn xcn

	mat `xcn' = J(1,`numcol',`L_off')
	mat `xrn' = J(`numrow',1,`L_off')

	if "`inherit'" != "" {
		// Stata matrix `xcn' overwritten with main .lc matrix from
		// `mt' mata structure
		mata : _mmt_GetItMat(`mt',"`xcn'","lc")
	}

	if "`all'" != "" {
		mat `xrn' = J(`numrow',1,`L_on')
		forvalues i = 1/`numcol' {
			if `xcn'[1,`i'] == `L_off' {
				mat `xcn'[1,`i'] = `L_on'
			}
		}
	}

	if `"`columns2'"' != "" {
		local 0 `", `columns2'"'
		capture syntax [, Short Long]
		if c(rc) {
			di as err ///
			  `"{p 0 4}invalid suboption columns() of `who'{p_end}"'
			syntax [, Short Long]
		}
		if "`short'" != "" & "`long'" != "" {
			di as err ///
			  `"{p 0 4}invalid suboption columns() of `who'{p_end}"'
			di as err "only one of short or long are allowed"
			exit 198
		}
		if "`short'" != "" {
			mat `xcn' = J(1,`numcol',`L_short')
		}
		if "`long'" != "" {
			mat `xcn' = J(1,`numcol',`L_long')
		}
	}
	else if "`columns'" != "" {
		forvalues i = 1/`numcol' {
			if `xcn'[1,`i'] == `L_off' {
				mat `xcn'[1,`i'] = `L_on'
			}
		}
	}

	if "`box'" != "" {
		local left left
		local right right
		local top top
		local bottom bottom
	}

	if "`left'" != "" {
		if `xcn'[1,1] == `L_off' {
			mat `xcn'[1,1] = `L_on'
		}
	}
	if "`right'" != "" {
		if `xcn'[1,`numcol'] == `L_off' {
			mat `xcn'[1,`numcol'] = `L_on'
		}
	}
	if "`top'" != "" {
		if `xrn'[1,1] == `L_off' {
			mat `xrn'[1,1] = `L_on'
		}
	}
	if "`bottom'" != "" {
		if `xrn'[`numrow',1] == `L_off' {
			mat `xrn'[`numrow',1] = `L_on'
		}
	}

	if "`title'" != "" {
		if `xrn'[2,1] == `L_off' {
			mat `xrn'[2,1] = `L_on'
		}
	}
	if "`last'" != "" {
		if `xcn'[1, `= `numcol'-1'] == `L_off' {
			mat `xcn'[1,`= `numcol'-1'] = `L_on'
		}
	}

	if `eqwhere' != `EQC_off' {
		if "`horequations'" != "" {
			// horizontal line between equation names and col names
			mat `xrn'[3,1] = `L_on'
		}
		if "`equations'" != "" {
			// place vertical lines between equations
			local uniqc : list uniq eqstripe
			local nceq : list sizeof uniqc
			if `nceq' > 1 {
				forvalues i=2/`nceq' {
					local anc : word `i' of `uniqc'
					local atc : list posof ///
							`"`anc'"' in eqstripe
					if `xcn'[1,`atc'] == `L_off' {
						mat `xcn'[1,`atc'] = `L_on'
					}
				}
			}
		}
	}

	mata: `lrv' = st_matrix("`xrn'")
	mata: `lcv' = st_matrix("`xcn'")
end

program ParseRNLines
	args lcv lrv mt eqwhere eqstripe rest

	mata: _mmt_SetConstants("EQR")
	mata: _mmt_SetConstants("L")

	local who `"rownames(... lines(`rest'))"'
	local 0 `", `rest'"'

	local synx syntax [, ///
		Left Right Top Bottom BOX ROws ROws2(string)	///
		LAst EQuations VERTEQuations TITle ALL INHerit	///
		ATRows(string) ATCols(string)			///
		]

	capture `synx'
	if c(rc) {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		`synx' // redo syntax to get error message displayed
	}

	local opta `"`left'`right'`top'`bottom'`box'`rows'`rows2'`last'"'
	local opta `"`opta'`equations'`vertequations'`title'`all'`inherit'"'
	if `"`opta'"' != "" & (`"`atrows'"' != "" | `"`atcols'"' != "") {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		di as err "{p}suboptions atrows() and atcols() not " ///
			"allowed with other lines() suboptions{p_end}"
		exit 198
	}

	mata: _mmt_GetItLoc(`mt',"nr","r") // sets local `nr' to number of rows

	local numcol = 3 // (left, mid, right) mid ignored if no equations
	local numrow = `nr' + 2 // not + 1 (because of rowname column title)

	if `"`atrows'"' != "" | `"`atcols'"' != "" {
		mata: `lrv' = J(0,0,.)
		mata: `lcv' = J(0,0,.)
		mata: _mmt_SetAtLines("rownames(... lines())",`numrow', ///
			`numcol',`"`atrows'"',`"`atcols'"',`lrv',`lcv')
		exit
	}

	if `"`rows2'"' != "" & "`rows'" != "" {
		di as err `"{p 0 4}invalid `who'{p_end}"'
		opts_exclusive "rows rows()"
	}

	tempname xrn xcn

	mat `xcn' = J(1,`numcol',`L_off')
	mat `xrn' = J(`numrow',1,`L_off')

	if "`inherit'" != "" {
		// Stata matrix `xrn' overwritten with main .lr matrix from
		// `mt' mata structure
		mata : _mmt_GetItMat(`mt',"`xrn'","lr")
		// need to add one element at front
		mat `xrn' = J(1,1,`L_off') \ `xrn'
	}

	if "`all'" != "" {
		if `eqwhere' == `EQR_before' | `eqwhere' == `EQR_ulbefore' {
			mat `xcn' = `L_on' , `L_off' , `L_on'
		}
		else {
			mat `xcn' = J(1,`numcol',`L_on')
		}
		forvalues i = 1/`numrow' {
			if `xrn'[`i',1] == `L_off' {
				mat `xrn'[`i',1] = `L_on'
			}
		}
	}

	if `"`rows2'"' != "" {
		local 0 `", `rows2'"'
		capture syntax [, Short Long Gap]
		if c(rc) {
			di as err ///
			    `"{p 0 4}invalid suboption rows() of `who'{p_end}"'
			syntax [, Short Long Gap]
		}
		capture opts_exclusive "`short' `long' `gap'"
		if c(rc) {
			di as err ///
			    `"{p 0 4}invalid suboption rows() of `who'{p_end}"'
			opts_exclusive "`short' `long' `gap'"
		}
		if ("`short'" != "")	mat `xrn' = J(`numrow',1,`L_short')
		if ("`long'" != "")	mat `xrn' = J(`numrow',1,`L_long')
		if ("`gap'" != "")	mat `xrn' = J(`numrow',1,`L_gap')
	}
	else if "`rows'" != "" {
		forvalues i = 1/`numrow' {
			if `xrn'[`i',1] == `L_off' {
				mat `xrn'[`i',1] = `L_on'
			}
		}
	}

	if "`box'" != "" {
		local left left
		local right right
		local top top
		local bottom bottom
	}

	if "`left'" != "" {
		if `xcn'[1,1] <= `L_off' {
			mat `xcn'[1,1] = `L_on'
		}
	}
	if "`right'" != "" {
		if `xcn'[1,`numcol'] <= `L_off' {
			mat `xcn'[1,`numcol'] = `L_on'
		}
	}
	if "`top'" != "" {
		if `xrn'[1,1] <= `L_off' {
			mat `xrn'[1,1] = `L_on'
		}
	}
	if "`bottom'" != "" {
		if `xrn'[`numrow',1] <= `L_off' {
			mat `xrn'[`numrow',1] = `L_on'
		}
	}

	if "`title'" != "" {
		if `xrn'[2,1] <= `L_off' {
			mat `xrn'[2,1] = `L_on'
		}
	}
	if "`last'" != "" {
		if `xrn'[`= `numrow'-1',1] <= `L_off' {
			mat `xrn'[`= `numrow'-1',1] = `L_on'
		}
	}

	if `eqwhere' != `EQR_off' {
		if "`vertequations'" != "" {
			if `eqwhere' == `EQR_before' | ///
					 `eqwhere' == `EQR_ulbefore' {
				di as err `"{p 0 4}invalid `who'{p_end}"'
				di as err "{p}suboption vertequations only " ///
					"allowed with equations(first()) " ///
					"or equations(each()){p_end}"
				exit 198
			}

			// vertical lines between equation names and row names
			mat `xcn'[1,2] = `L_on'
		}
		if "`equations'" != "" {
			// place horizontal lines between equations
			local uniqr : list uniq eqstripe
			local nreq : list sizeof uniqr
			if `nreq' > 1 {
				forvalues i=2/`nreq' {
					local anr : word `i' of `uniqr'
					local atr : list posof ///
							`"`anr'"' in eqstripe
					local ++atr // because title at top
					if `xrn'[`atr',1] <= `L_off' {
						mat `xrn'[`atr',1] = `L_on'
					}
				}
			}
		}
	}

	mata: `lrv' = st_matrix("`xrn'")
	mata: `lcv' = st_matrix("`xcn'")
end

program ParseLines
	gettoken m 0 : 0

	local synx syntax [, ///
		Left Right Top Bottom BOX ROws ROws2(string)	///
		COLumns COLumns2(string) LAst LAst2(string)	///
		EQuations EQuations2(string) ALL ATRows(string) ///
		ATCols(string) ///
		NR(int 0) NC(int 0) REQNAMES(string) CEQNAMES(string) ///
		]

	capture `synx'
	if c(rc) {
		di as err "lines() invalid"
		`synx'
	}

	local opta `"`left'`right'`top'`bottom'`box'`rows'`rows2'`columns'"'
	local opta `"`opta'`columns2'`last'`last2'`equations'`equations2'`all'"'
	if `"`opta'"' != "" & (`"`atrows'"' != "" | `"`atcols'"' != "") {
		di as err "{p}lines() invalid; suboptions atrows() " ///
			"and atcols() not allowed with other lines() " ///
			"suboptions{p_end}"
		exit 198
	}

	local nr1 = `nr'+1
	local nc1 = `nc'+1

	if `"`atrows'"' != "" | `"`atcols'"' != "" {
		mata: _mmt_SetMainAtLines(`m',`nr1',`nc1', ///
						`"`atrows'"',`"`atcols'"')
		exit
	}

	if `"`rows2'"' != "" & "`rows'" != "" {
		opts_exclusive "rows rows()" lines
	}
	if `"`columns2'"' != "" & "`columns'" != "" {
		opts_exclusive "columns columns()" lines
	}
	if `"`last2'"' != "" & "`last'" != "" {
		opts_exclusive "last last()" lines
	}
	if `"`equations2'"' != "" & "`equations'" != "" {
		opts_exclusive "equations equations()" lines
	}

	mata: _mmt_SetConstants("L")

	tempname xrn xcn

	if "`all'" != "" {
		mat `xrn' = J(`nr1',1,`L_on')
		mat `xcn' = J(1,`nc1',`L_on')
	}
	else {
		mat `xrn' = J(`nr1',1,`L_off')
		mat `xcn' = J(1,`nc1',`L_off')
	}

	if `"`rows2'"' != "" {
		local 0 `", `rows2'"'
		capture syntax [, Short Long Gap]
		if c(rc) {
			di as err "invalid suboption rows() of option lines();"
			syntax [, Short Long Gap]
		}
		capture opts_exclusive "`short' `long' `gap'"
		if c(rc) {
			di as err "{p}invalid suboption rows() of option " ///
				"lines(){p_end}"
			opts_exclusive "`short' `long' `gap'"
		}
		if ("`short'" != "")	mat `xrn' = J(`nr1',1,`L_short')
		if ("`long'" != "")	mat `xrn' = J(`nr1',1,`L_long')
		if ("`gap'" != "")	mat `xrn' = J(`nr1',1,`L_gap')
	}
	else if ("`rows'" != "")	mat `xrn' = J(`nr1',1,`L_on')

	if `"`columns2'"' != "" {
		local 0 `", `columns2'"'
		capture syntax [, Short Long]
		if c(rc) {
			di as err ///
				"invalid suboption columns() of option lines();"
			syntax [, Short Long]
		}
		if "`short'" != "" & "`long'" != "" {
			di as err "{p}invalid suboption columns() of " ///
				"option lines(); only one of short or " ///
				"long are allowed{p_end}"
			exit 198
		}
		if ("`short'" != "")	mat `xcn' = J(1,`nc1',`L_short')
		if ("`long'" != "")	mat `xcn' = J(1,`nc1',`L_long')
	}
	else if ("`columns'" != "")	mat `xcn' = J(1,`nc1',`L_on')

	if "`box'" != "" {
		local left left
		local right right
		local top top
		local bottom bottom
	}

	if "`left'" != "" {
		if `xcn'[1,1] <= `L_off' {
			mat `xcn'[1,1] = `L_on'
		}
	}
	if "`right'" != "" {
		if `xcn'[1,`nc1'] <= `L_off' {
			mat `xcn'[1,`nc1'] = `L_on'
		}
	}
	if "`top'" != "" {
		if `xrn'[1,1] <= `L_off' {
			mat `xrn'[1,1] = `L_on'
		}
	}
	if "`bottom'" != "" {
		if `xrn'[`nr1',1] <= `L_off' {
			mat `xrn'[`nr1',1] = `L_on'
		}
	}

	if `"`last2'"' != "" {
		local 0 `", `last2'"'
		capture syntax [, Row Column]
		if c(rc) {
			di as err ///
				"invalid suboption last() of option lines();"
			syntax [, Row Column]
		}
		if "`row'" != "" {
			if `xrn'[`nr',1] <= `L_off' {
				mat `xrn'[`nr',1] = `L_on'
			}
		}
		if "`column'" != "" {
			if `xcn'[1,`nc'] <= `L_off' {
				mat `xcn'[1,`nc'] = `L_on'
			}
		}
	}
	else if "`last'" != "" {
		if `xrn'[`nr',1] <= `L_off' {
			mat `xrn'[`nr',1] = `L_on'
		}
		if `xcn'[1,`nc'] <= `L_off' {
			mat `xcn'[1,`nc'] = `L_on'
		}
	}

	local doreq 0
	local doceq 0
	if `"`equations2'"' != "" {
		local 0 `", `equations2'"'
		capture syntax [, Rows Columns]
		if c(rc) {
			di as err ///
			    "invalid suboption equations() of option lines();"
			syntax [, Rows Columns]
		}
		if ("`rows'" != "")	local doreq 1
		if ("`columns'" != "")	local doceq 1
	}
	else if "`equations'" != "" {
		local doreq 1
		local doceq 1
	}

	local uniqr : list uniq reqnames
	local nreq : list sizeof uniqr
	local uniqc : list uniq ceqnames
	local nceq : list sizeof uniqc
	if (`nreq' < 2) local doreq 0 	// less than 2 row equations
	if (`nceq' < 2) local doceq 0	// less than 2 col equations

	if `doreq' {
		forvalues i=2/`nreq' {
			local anr : word `i' of `uniqr'
			local atr : list posof `"`anr'"' in reqnames
			if `xrn'[`atr',1] <= `L_off' {
				mat `xrn'[`atr',1] = `L_on'
			}
		}
	}

	if `doceq' {
		forvalues i=2/`nceq' {
			local anc : word `i' of `uniqc'
			local atc : list posof `"`anc'"' in ceqnames
			if `xcn'[1,`atc'] <= `L_off' {
				mat `xcn'[1,`atc'] = `L_on'
			}
		}
	}

	// set the `m'.lc and `m'.lr Mata vectors
	mata: _mmt_Setlclr(`m',"`xrn'","`xcn'")
end

program NumCommaSort, rclass
	local 0 : list uniq 0
	local 0 , nlist(`0')
	syntax [, nlist(numlist sort)]

	local cnt : word count `nlist'
	if `cnt' <= 1 {
		return local nlist `nlist'
		exit
	}
	if `cnt' == 2 {
		local nlist: subinstr local nlist " " " or "
		return local nlist `nlist'
		exit
	}

	gettoken newlist nlist : nlist
	forvalues i=2/`= `cnt'-1' {
		gettoken item nlist : nlist
		local newlist `newlist', `item'
	}
	local newlist `newlist', or `nlist'
	return local nlist `newlist'
end

exit

//============================================================================
// Syntax / Explanation
//============================================================================

Syntax
------

	_multiplemat_tab (mat [, opts]) [(mat [, opts]) ...] [, gopts]

    also allowed in place of grouping each matrix and associated options in
    "()" is to divide them using "||"

	_multiplemat_tab mat [, opts] [|| mat [, opts] ...] [||, gopts]


In the discussion below, the matrices are r by c

Notes:

(1) The option or suboption allows 1, r, c, or r*c arguments.  If only one
    argument is provided, it is applied to all elements of the matrix.  If r
    arguments are provided, they are applied to the corresponding rows.  If c
    arguments are provided, they are applied to the corresponding columns.  If
    r*c arguments are provided, they apply individually to the cells.  The
    suboptions [Row|Column|Allroworder|ALLColorder] clarify your intention --
    apply to rows, columns, or all cells.  -allroworder- indicates that the
    r*c arguments are in row order (the first c arguments are to be applied to
    the first row, the second c arguments are to be applied to the second row,
    ...).  -allcolorder- indicates that the r*c arguments are in column order
    (the first r arguments are to be applied to the first column, the second r
    arguments are to be applied to the second column, ...).

(2) The option or suboption allows 1 or k arguments.  If only one argument is
    provided it applies to all k items (what items are depends on the option).


matname specific options -opts-
-------------------------------

FORmat(%fmt [%fmt ...] [, Row Column Allroworder ALLColorder])

    indicates the format for cells of the table.  See Note 1.

Justification(jst [jst ...] [, Row Column Allroworder ALLColorder])

        where jst is:  Left|Right|Center

    indicates the cell justification.  See Note 1.

FONt(fnt [fnt ...] [, Row Column Allroworder ALLColorder])

        where fnt is:  Sf          |It     |Bf
        with aliases:  Standardface|Italics|Boldface

    indicates the cell font.  See Note 1.

RENder(rdr [rdr ...] [, Row Column Allroworder ALLColorder])

        where rdr is:  Text |Result|Input  |Error
        with aliases:  Green|Yellow|White  |RED
                       Txt  |      |Command|
                            |      |Cmd    |

    indicates how to render the text of the cells.  See Note 1.

KEYEntry(entry [entry ...] [,
	OMIT
	Justification(jst [jst ...])
	FONt(fnt [fnt ...])
	RENder(rdr [rdr ...])
        ]
        )

    provides the key entry for this matrix.  Multiple entries in one
    keyentry() option indicate multiple lines for the key entry.  The default
    entry is the matrix name or expression.

    suboptions justification(), font(), and render() allow 1 or k arguments
    that apply to the k entries defined in this keyentry() option; see Note 2.

    The omit suboption indicates that no key entry at all should be produced
    for this matrix.

BLanks(numlist)

    indicates values to be shown as blanks.  For example -blanks(.z)- displays
    a blank instead of .z for cells containing a .z.  -blanks(0)- displays a
    blank instead of 0 for cells containing a 0.  -blanks(0 .z)- displays a
    blank instead of 0 or .z for cells containing either 0 or .z.

OMITLine(number)

    indicates that if all (main body) table values are equal to the number
    argument (typically one of the missing values), then that line should be
    omitted from the display.  (If this happens for the first matrix, then the
    rowname portion will also be lost.  Probably you only want to use this for
    later matrices in the call.


Global options -gopts-
----------------------

LINESIZE(#)

    override the currently active c(linesize).

LEFT(#)

    specifies how far to indent from the left for the table.

RIGHT(#)

    specifies how far to indent from the right for the table.

Widths(# [# ...])

    main table column widths (the row name column width is controlled through
    the rownames(, width(#)) option).  If the widths() option is not given,
    the column widths default to the largest format length within that column.
    The number (or numbers) given in this -widths()- option state the minimum
    width.  Longer widths will be used if any of the matrix format widths
    require it.  If one number is given, it is used for all of the columns.
    Otherwise, c numbers are expected, one for each column.

noBLank

    suppress blank line before the table.

TITle(title [title ...] [,
	Justification(jst [jst ...])
	FONt(fnt [fnt ...])
	RENder(rdr [rdr ...])
	LEFT(#) RIGHT(#) WIDth(#)
	]
     )

    provides an overall title.  By default, no title is presented.  Specifying
    multiple titles indicates a multiline overall title.  Suboptions
    justification(), font(), and render() allow 1 or k arguments that apply to
    the k titles; see Note 2.  Suboptions left(), right(), and width()
    indicate how far to indent from the left, how far to indent from the
    right, and the width for the title.  At most 2 of the 3 options may be
    specified.  If not specified, they default to the values set for the whole
    table.  (Notice there is no format() suboption because it would not be
    that useful with textual titles and we already have a justification()
    suboption.)

Key(title [title ...] [,
	OFF|ON
	noTItle
	TOP BOTtom LEFT RIGHT CENter
	LEFT(#) RIGHT(#) WIDth(#)
	Justification(jst [jst ...])
	FONt(fnt [fnt ...])
	RENder(rdr [rdr ...])
        LINes(	Left Right Top Bottom
		BOX			<-- = left right top bottom
		TITle
		STandard		<-- = box title
		ROws
		ALL			<-- = box title rows
             )
	]
   )

    specifies if a table key will be shown and where.  The entries are
    specified through the separate keyentry() options associated with each
    matrix.

    One or more titles may be given; they provide the title for the key.
    Multiple titles will be shown on multiple lines.

    Suboptions off and on indicate if the key should be shown or not.

    Suboption notitle indicates that no title is to be provided for the key.

    The top and bottom suboptions cause the complete key table to be presented
    either above or below the main table.  The left, right, and center
    suboptions further specify that the complete key should be placed to the
    left, right or center relative to the overall table.  left() and right()
    allow the key table to use different left and right margins compared to the
    overall table.  The width() suboption indicates the width of the key
    table.  At most 2 of left(), right(), and width() may be specified.

    The default is to produce a key table at the top left before the main
    table.  The default Key table is boxed with a dividing line between the
    title (which defaults to "Key") and the entries for each matrix.  The
    default key entries are the matrix names (or expressions).

    The lines() suboption indicates where lines should be drawn for the key.
    Subsuboptions left, right, top and bottom indicate which outer bounding
    lines should be drawn.  subsuboption box indicates to do all four.
    subsuboption title indicates a line should be drawn separating the Key's
    title from the rest of the key.  subsuboption standard is the same as
    specifying both box and title. The rows subsuboption indicates that
    separating lines should be drawn between each key entry.  subsuboption all
    is the same as specifying box, title, and rows.

LINes(  Left Right Top Bottom
	BOX				<-- = left right top bottom
	ROws[(Short Long Gap)]
        COLumns[(Short Long)]
	LAst[(Row Column)]		<-- no arg equals both args
	EQuations[(Rows Columns)]	<-- no arg equals both args
	ALL				<-- = box rows columns
	ATRows(str)
	ATCols(str)
     )

    indicates where lines are to be drawn for the main body of the table.

        Suboptions left, right, top, and bottom indicate which outer bounding
        lines are to be drawn. suboption box indicates to do all four.

        Suboption rows indicates that lines are to be drawn between each
        conceptual row (with multiple matrices, a conceptual row will have
        multiple actual rows).  Suboption columns indicates that lines are to
        be drawn between each column.  For rows and columns, subsuboptions
        short and long do not actually change the main table, but (depending
        on other options) take effect if there are equations displayed with
        the row or column names.

        Suboption last() indicates that a line is to be drawn before the last
        row and/or column.  last without arguments is equivalent to last(row
        column).

        Suboption equation() indicates that a line is to be drawn between
        equations.  The rows and columns subsuboptions indicates the lines are
        to be shown with rows and/or columns. equation with no arguments is
        the same as equation(rows columns).

	Suboption all is equivalent to specifying box, rows, and columns.

        suboption atrows() and atcols() provide complete control over which
        lines are to be drawn.  A string is provided as the argument to these
        suboptions.  Within the string a "." indicates no line should be
        drawn, while "|" and synonyms "-", "l", and "s" indicate that a line
        should be drawn.  The "l" and "s" provide information similar to the
        long and short subsuboptions of rows() and columns().  For atrows(),
        within the string a "g" indicates a gap line (blank line) should be
        provided.


ROWNames(
	OFF|ON
	Justification(jst [jst ...])
	FONt(fnt [fnt ...])
	RENder(rdr [rdr ...])
	WIDth(#)
	TITle(title [title ...] [,
		Justification(jst [jst ...])
		FONt(fnt [fnt ...])
		RENder(rdr [rdr ...])
		]
	     )
	UNDERscore
	EQuations(OFF|ON
		  BEFore|BEFOREUnderline|FIRST(#, sep(sep))|EACH(#, sep(sep))
		  Justification(jst [jst ...])
		  FONt(fnt [fnt ...])
		  RENder(rdr [rdr ...])
		 )
	LINes(  Left Right Top Bottom
		BOX		<-- = left right top bottom
		ROws[(Short Long Gap)]
		LAst
		EQuations
		VERTEQuations
		TITle
		ALL		<-- = box rows title
		INHerit
		ATRows(str)
		ATCols(str)
	     )
        )

    specifies if a column giving the matrix row names is to be presented, and
    if so, how.

    suboptions off and on specify if the column with matrix row names is to be
    presented.

    The justification(), font(), and render() suboptions allow 1 or r
    arguments and alter the presentation of the row names; see Note 2.

    The width() suboption specifies the width of the column.

    The title() suboption provides a title over the column of row names.  Each
    specified title argument is presented on a separate line.  The
    subsuboptions alter how these titles are presented.  The subsuboptions
    allow either 1 or k arguments; see Note 2.

    The underscore() suboption indicates that underscores in the row names are
    to be presented as spaces.

    The equations() suboption indicates if matrix equation names are to be
    presented along with the row names, and if so, how.

        The before, beforeunderline, first(), and each() subsuboptions
        indicate if the equation name is to appear on its own line before the
        first row, on its own line before the first row with a line under it
        dividing it from it's rownames, on the same line as the first row, or
        on the same line with each row for the rownames associated with that
        equation.  first() and each() need to specify the width they will use.
        Any remaining width is used for the matrix names.  sep() as an option
        to first() or each() provides a string appended to the end of the
        equation names.  For instance sep(:) would display a colon after the
        equation name.

        format(), justification(), font(), and render() apply to the equation
        labels.  One or q arguments are allowed (where q are the number of
        equations); see Note 2.

    The lines() suboption indicates where lines are to be drawn for the
    row-names column.

        left, right, top, and bottom place lines at the stated places around
        the outer edges of the row-names column.  box is the same as
        indicating all four of these suboptions.

        rows indicates that lines are to be drawn between each logical row.
        The optional short and long subsuboptions of rows() indicate if long
        or short lines are to be used for the lines that are not the breaks
        between equations.  rows(gap) indicates a blank line gap be used
        between rows.

        last indicates a line is to be drawn before the last row.  title
        indicates that a line is to be drawn after the title for the column of
        row names.

	all is the same as specifying box, rows, and title.

        equations indicates that horizontal lines be drawn between different
        equations.  vertequations indicates that a vertical line be drawn
        between the equation names and the row names.

        inherit indicates that the row lines are to be the same as those for
        the main table.  inherit is the default.  It is possible to specify
        inherit and the suboptions listed above, in which case the additional
        options add lines to those indicated by inherit.

        atrows() and atcols() provide complete control over which lines are to
        be drawn.  A string is provided as the argument to these suboptions.
        Within the string a "." indicates no line should be drawn, while "|"
        and synonyms "-", "l", and "s" indicate that a line should be drawn.
        The "l" and "s" indicate whether short or long lines are to be drawn,
        and only make a difference if there are equation names being presented
        with the row names.  atrows() also allows "g" to mean gap line (blank
        line).


COLNames(
	OFF|ON
	Justification(jst [jst ...])
	FONt(fnt [fnt ...])
	RENder(rdr [rdr ...])
	TITle(title [title ...] [,
		Justification(jst [jst ...])
		FONt(fnt [fnt ...])
		RENder(rdr [rdr ...])
		]
	     )
	UNDERscore
	EQuations(OFF|ON
		  BIND
		  FIRST|EACH|COMbined
		  Justification(jst [jst ...])
		  FONt(fnt [fnt ...])
		  RENder(rdr [rdr ...])
		 )
	LINes(  Left Right Top Bottom
		BOX		<-- = left right top bottom
		COLumns[(Short Long)]
		LAst
		EQuations
		HOREQuations
		TITle
		ALL		<-- = box columns title
		INHerit
		ATRows(str)
		ATCols(str)
	     )
        )

    specifies if a row (or rows) giving the matrix column names is to be
    presented, and if so, how.

    suboptions off and on specify if a row (or rows) with matrix column names
    is to be presented.

    The justification(), font(), and render() suboptions allow 1 or c
    arguments and alter the presentation of the column names; see Note 2.

    The title() suboption provides a title over the columns showing the column
    names.  Each specified title argument is presented on a separate line.
    The subsuboptions alter how these titles are presented.  The subsuboptions
    allow either 1 or k arguments; see Note 2.

    The underscore() suboption indicates that underscores in the column names
    are to be presented as spaces.

    The equations() suboption indicates if matrix equation names are to be
    presented above the columns, and if so, how.

        The bind subsuboption indicates that columns of the same equation are
        to remain together if possible when wrapping long tables.

        The first, each, and combined subsuboptions indicate if the equation
        name is to appear over just the first column for that equation, over
        each column for that equation, or once over the set of columns for
        that equation.

        format(), justification(), font(), and render() apply to the equation
        labels.  One or q arguments are allowed (where q are the number of
        equations); see Note 2.

    The lines() suboption indicates where lines are to be drawn for the column
    names header.

        left, right, top, and bottom place lines at the stated places around
        the outer edges of the column-names header.  box is the same as
        indicating all four of these suboptions.

        columns indicates that lines are to be drawn between each column.  The
        optional short and long subsuboptions of columns() indicate if long or
        short lines are to be used for the lines that are not the breaks
        between equations.

        last indicates a line is to be drawn before the last column.

        title indicates that a horizontal line is to be drawn after the title
        for the column-names header.

	all is the same as specifying box, columns, and title.

        equations indicates that vertical lines be drawn between different
        equations.  horequations indicates that a horizontal line be drawn
        between the equation names and the row names in the column-names
        header.

        inherit indicates that the column lines are to be the same as those
        for the main table.  inherit is the default.  It is possible to
        specify inherit and the suboptions listed above, in which case the
        additional options add lines to those indicated by inherit.

        atrows() and atcols() provide complete control over which lines are to
        be drawn.  A string is provided as the argument to these suboptions.
        Within the string a "." indicates no line should be drawn, while "|"
        and synonyms "-", "l", and "s" indicate that a line should be drawn.
        The "l" and "s" indicate whether short or long lines are to be drawn,
        and only make a difference if there are equation names being presented
        with the column names.  atrows() also allows "g" to indicate a gap
        line (blank line).


Notes about Lines/Borders

    +-----------------------+
    |                       |
    |  The Key              |
    |                       |
    +-----------------------+
    +-----------+-----------------------------------------------+
    |           |                                               |
    |  Row-     |     Column-Name Header                        |
    |  Name     |                                               |
    |  Info     +-----------------------------------------------+
    |           |                                               |
    |           |   Body of table                               |
    |           |                                               |
    |           |                                               |
    |           |                                               |
    |           |                                               |
    |           |                                               |
    +-----------+-----------------------------------------------+


Here is a closer look at "Column-Name Header"

      +----------------------------------------------------------+
      |   Column-Name Title                                      |
      +--------.-------.--------+--------.-------.-------.-------+
      | Eq1    .       .        | Eq2    .       .       .       |
      |~~~~~~~~.~~~~~~~.~~~~~~~~|~~~~~~~~.~~~~~~~.~~~~~~~.~~~~~~~|
      |  name1 | name2 | name3  |  name4 | name5 | name6 | name7 |
      |        |       |        |        |       |       |       |
      +--------+-------+--------+--------+-------+-------+-------+

Here is a closer look at "Row-Name Info"

      +--------------------------+  \
      |                          |   \
      | Row Name Title           |    >-- as tall as "Column-Name Header"
      |                          |   /
      +--------------------------+  /
      | Eq1        i             |
      |............i.............|
      |            1     row1    |
      |,,,,,,,,,,,,1~~~~~~~~~~~~~|
      |            1     row2    |
      +------------1-------------+
      | Eq2        i             |
      |............i.............|
      |            1     row3    |
      |,,,,,,,,,,,,1~~~~~~~~~~~~~|
      |            1     row4    |
      |,,,,,,,,,,,,1~~~~~~~~~~~~~|
      |            1     row5    |
      +--------------------------+

different symbols are used to indicate different lines that might be used in
the row or column stripes.

<end>
