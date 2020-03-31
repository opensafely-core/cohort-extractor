*! version 1.0.14   08feb2015 
program checkhlpfiles
	version 8

	if `c(SE)' != 1 { 
		di as err "checkhlpfiles:  requires Stata/SE"
		exit 198
	}

	gettoken cmd 0 : 0, parse(" ,")
	syntax [, PATH(string) System]

	if "`system'" != "" {
		if `"`path'"'!="" {
			di as err ///
			"may not combine options -path()- and -system-"
			exit 198
		}
		local path "UPDATES;BASE"
	}
	else if `"`path'"'=="" {
		local path `"`c(adopath)'"'
	}

	preserve

	if "`cmd'"=="help" {
		DoHelp "`path'"
	}
	else if "`cmd'"=="stata" {
		DoStata "`path'"
	}
	else if "`cmd'"=="dialog" {
		DoDialog "`path'"
	}
	else if "`cmd'"=="manual" {
		di "{cmd:checkhlpfiles manual} has been deprecated;"
		di "use {helpb check_help} instead"
	}
	else if "`cmd'"=="doublebang" {
		DoDoublebang "`path'"
	}
	else	error 198
end


program DoDoublebang
	args path

	GetFiles sthlpfiles : *.sthlp `"`path'"'
	GetFiles hlpfiles : *.hlp `"`path'"'
	GetFiles ihlpfiles : *.ihlp `"`path'"'
	GetFiles mfiles : *.maint `"`path'"'

	local n 0
	local h 0
	foreach el of local sthlpfiles {
		DoublebangFile "`el'" "`path'"
		local h = `h' + r(has)
		local ++n
	}

	foreach el of local hlpfiles {
		DoublebangFile "`el'" "`path'"
		local h = `h' + r(has)
		local ++n
	}

	foreach el of local ihlpfiles {
		DoublebangFile "`el'" "`path'"
		local h = `h' + r(has)
		local ++n
	}

	foreach el of local mfiles {
		DoublebangFile "`el'" "`path'"
		local h = `h' + r(has)
		local ++n
	}
	di _n "(`h'/`n' have doublebangs)"
end


program DoublebangFile, rclass
	args hfn path

	GetFFN ffn : `"`path'"' "`hfn'"
	ReadHlpFile `"`path'"' "`hfn'"

	local dbang = "!" + "!" 
	quietly count if strpos(contents, "`dbang'")
	if r(N) {
		di as txt "`ffn'"
		ret scalar has = 1
	}
	else	ret scalar has = 0
end


program DoDialog
	args path
	tempfile dlg dlgs

	quietly {
		drop _all
		set obs 1
		gen str1 ref=""
		gen found = 0
		save "`dlgs'"
	}

	GetFiles sthlpfiles : *.sthlp `"`path'"'
	local myn = r(n)
	GetFiles hlpfiles : *.hlp `"`path'"'
	if `myn'+r(n)==0 {
		exit
	}
	GetFiles ihlpfiles : *.ihlp `"`path'"'

	GetFiles dlgfiles : *.dlg `"`path'"'
	MakeDlgFileDataset `dlgfiles'
	qui save "`dlg'"

	foreach el of local sthlpfiles {
		DialogHlpFile "`el'" "`dlg'" "`path'" "`dlgs'"
		if r(leaf) {
			local leaves `leaves' `el'
		}
	}

	foreach el of local hlpfiles {
		DialogHlpFile "`el'" "`dlg'" "`path'" "`dlgs'"
		if r(leaf) {
			local leaves `leaves' `el'
		}
	}

	foreach el of local ihlpfiles {
		DialogHlpFile "`el'" "`dlg'" "`path'" "`dlgs'"
		if r(leaf) {
			local leaves `leaves' `el'
		}
	}

	qui use `dlgs', clear
	qui count if found==0
	if r(N) {
		di as txt _n "{hline}"
		di as txt "{title:Dialogs referred to but which do not exist}"
		qui keep if found==0
		list ref
	}

	quietly {
		use "`dlgs'", clear
		keep if found
		drop found
		capture drop _merge
		save "`dlgs'", replace
		use "`dlg'", clear
		capture drop _merge
		rename dfn ref
		merge ref using `dlgs', nokeep
		keep if _merge==1
	}
	if _N {
		di as txt _n "{hline}"
		di as txt "{title:Dialogs not referred to}"
		list ref
	}
end

program DialogHlpFile
	args hfn dlgdta path dlgs

	GetFFN ffn : `"`path'"' "`hfn'"

	ReadHlpFile `"`path'"' "`hfn'"
	Extract `"`ffn'"' "dialog"
	if _N==0 { 
		exit
	}
	quietly { 
		replace ref = word(ref, 1) 
		replace ref = bsubstr(ref,1,length(ref)-1) ///
						if bsubstr(ref,-1,.)==","
		sort ref 
		by ref: keep if _n==1

		rename ref dfn
		merge dfn using "`dlgdta'", nokeep
		rename dfn ref
		gen byte found = _merge==3
	}
	qui count if found==0
	if r(N) {
		preserve
		qui keep if found==0
		di as txt _n as res `"`ffn':  "' ///
			as txt "unmatched dialog:"
		list ref
		restore
	}

	quietly {
		append using "`dlgs'"
		sort ref
		by ref: keep if _n==1
		drop if ref==""
		save "`dlgs'", replace
	}
end


program DoStata
	args path

	tempfile cmds

	quietly { 
		drop _all
		set obs 1 
		gen str1 ref = ""
		gen found = 0 
		save "`cmds'"
	}

	GetFiles sthlpfiles : *.sthlp `"`path'"'
	local myn = r(n)
	GetFiles hlpfiles : *.hlp `"`path'"'
	if `myn'+r(n)==0 { 
		exit
	}
	GetFiles ihlpfiles : *.ihlp `"`path'"'

	foreach el of local sthlpfiles {
		StataHlpfile "`el'" "`path'" "`cmds'"
	}

	foreach el of local hlpfiles {
		StataHlpfile "`el'" "`path'" "`cmds'"
	}

	foreach el of local ihlpfiles {
		StataHlpfile "`el'" "`path'" "`cmds'"
	}

	quietly use "`cmds'", clear
	drop if ref==""
	if _N==0 { 
		exit
	}

	quietly keep if !found
	if _N {
		di as txt _n "{hline}"
		di as txt "{title:Commands used but that do not exist}"
		list ref
	}

	quietly use "`cmds'", clear
	quietly keep if found
	if _N {
		di as txt _n "{hline}"
		di as txt _n "{title:Commands used that exist}"
		list ref
	}
end

program StataHlpfile 
	args hfn path cmds

	GetFFN ffn : `"`path'"' "`hfn'"

	ReadHlpFile `"`path'"' "`hfn'"
	Extract `"`ffn'"' "stata"
	if _N==0 { 
		exit
	}
	quietly { 
		replace ref = word(ref, 1) 
		sort ref 
		by ref: keep if _n==1
		gen byte found = 1 
	}

	forvalues i=1(1)`=_N' {
		local cmd = ref[`i']
		capture which `cmd'
		if _rc {
			qui replace found = 0 in `i'
		}
	}

	capture assert found==1
	if _rc {
		preserve
		qui keep if found==0
		di as txt _n as res `"`ffn':  "' ///
			as txt "unmatched command:"
		list ref
		restore
	}

	quietly {
		append using "`cmds'"
		sort ref
		by ref: keep if _n==1
		drop if ref==""
		save "`cmds'", replace
	}
end

program Read_HlpnotusedMaint_File
	args path f_o f_y

	quietly { 
		drop _all
		set obs 1
		gen str1 hfn = ""
		drop in 1
		save "`f_o'"
		save "`f_y'"
	}

	ReadMaintFile "`path'" hlpnotused.maint
	if _N==0 { 
		exit
	}

	qui gen bad = word(ref,3)!=""
	InvalidLines
	if _N==0 { 
		exit
	}

	quietly {
		gen str word1 = word(ref, 1)
		gen str word2 = word(ref, 2)
		gen bad = !( ///
		word2=="" | word2=="both" | word2=="contents" | word2=="base" ///
		)
	}

	InvalidLines
	if _N==0 { 
		exit
	}

	quietly {
		gen str1 type = "b" if word2=="base"
		replace type = "y" if word2=="contents"
		sort word1
		by word1: gen bad = (type!=type[1])
	}
	InvalidLines
	if _N==0 { 
		exit
	}
	quietly { 
		by word1: keep if _n==1
		keep word1 type
		rename word1 hfn
		sort hfn

		preserve
		keep if type=="b" || type==""
		keep hfn
		save "`f_o'", replace
		restore

		keep if type=="y" || type==""
		keep hfn
		save "`f_y'", replace
	}
end

	

program InvalidLines
	capture assert bad==0
	if _rc==0 { 
		drop bad
		exit 
	}
	di as txt _n
	di as txt "hlpnotused.maint:  contains invalid lines:"
	list ref if bad
	di "hlpnotused.maint:  lines ignored
	qui drop if bad
	drop bad
end
	

	
program ReadMaintFile 
	args path fn 
	qui drop _all
	capture findfile "`fn'", path("`path'")
	if _rc { 
		di as txt "(note:  file `fn' not found)"
		exit
	}
	local input "`r(fn)'"
	quietly {
		infix str ref 1-240 using `"`input'"'
		replace ref = trim(ref)
		drop if ref=="" | bsubstr(ref,1,1)=="*"
		compress
	}
end


program DoHelp
	args path
	tempfile hlpdta refed_o refed_y realhlpfiles
	tempfile noref_o noref_y

	Read_HlpnotusedMaint_File "`path'" "`noref_o'" "`noref_y'"

	GetFiles sthlpfiles : *.sthlp `"`path'"'
	local myn = r(n)
	GetFiles hlpfiles : *.hlp `"`path'"'
	if `myn'+r(n)==0 { 
		exit
	}
	GetFiles ihlpfiles : *.ihlp `"`path'"'

	GetAliases aliases : `"`path'"'

	MakeHlpFileDataset `hlpfiles'
	qui save `"`realhlpfiles'"'

	MakeHlpFileDataset `sthlpfiles'
	qui append using `"`realhlpfiles'"'
	sort hfn
	qui save `"`realhlpfiles'"', replace

	MakeHlpFileDataset `hlpfiles' `aliases'
	rename hfn ref
	qui save `"`hlpdta'"'

	MakeHlpFileDataset `sthlpfiles' `aliases'
	rename hfn ref
	qui append using `"`hlpdta'"'
	sort ref
	qui save `"`hlpdta'"', replace

	quietly {
		drop _all
		set obs 1 
		gen str1 ref = ""
		save "`refed_o'"
		save "`refed_y'"
	}

	di as txt _n "{hline}"
	di as txt "{title:Errors}"
	foreach el of local sthlpfiles {
		CheckHlpFile "`el'" "`hlpdta'" "`path'" "`refed_o'" "`refed_y'"
		if r(leaf) {
			local leaves `leaves' `el'
		}
	}
	foreach el of local hlpfiles {
		CheckHlpFile "`el'" "`hlpdta'" "`path'" "`refed_o'" "`refed_y'"
		if r(leaf) {
			local leaves `leaves' `el'
		}
	}
	foreach el of local ihlpfiles {
		CheckHlpFile "`el'" "`hlpdta'" "`path'" "`refed_o'" "`refed_y'"
		/* don't report .ihlps as leaves */
	}

	di as txt _n "{hline}"
	di as txt "{title:Leaves}"
	ReportLeaves `leaves'
	di as txt _n "{hline}"
	Xref "`refed_o'" "`hlpdta'" "`realhlpfiles'" ///
		"From base help files" 1 "`noref_o'"
	di as txt _n "{hline}"
	Xref "`refed_y'" "`hlpdta'" "`realhlpfiles'" ///
		"From contents help files" 0 "`noref_y'"
end

program ReportLeaves
	if `"`0'"'=="" {
		exit
	}
	MakeHlpFileDataset `0'
	sort hfn
	list
end


program Xref
	args refed hlpdta realhlpfiles title isbase noref

	quietly { 
		use "`refed'", clear 
		drop if ref==""
		if _N==0 { 
			exit
		}
		sort ref
		merge ref using "`hlpdta'"
		drop if _merge==3
		if _N==0 { 
			exit
		}
		sort ref 
	}
		
	preserve
	qui count if _merge==1
	if r(N) {
		qui keep if _merge==1
		di as txt "{title:`title':  referenced but do not exist}"
		list ref
		di
		restore, preserve
	}
	if `isbase' {
		// contents.sthlp and contents_*.sthlp are not part of "base"
		qui drop if bsubstr(ref,1,9)=="contents_"
		qui drop if ref=="contents.sthlp"
		qui drop if ref=="contents.hlp"
	}
	qui count if _merge==2
	if r(N) {
		quietly {
			keep if _merge==2
			drop _merge
			rename ref hfn
			sort hfn

			merge hfn using `"`realhlpfiles'"'
			keep if _merge==3
			drop _merge 
			sort hfn

			merge hfn using "`noref'", nokeep
			drop if _merge==3
			drop _merge

			rename hfn ref
		}
		di as txt "{title:`title':  exist but not referenced}"
		di as txt "    (hlpnotused.maint references removed)"
		list ref 
	}

	restore, preserve
	qui count if _merge==1
	if r(N) {
		quietly {
			keep if _merge==1
			drop _merge
			rename ref hfn
			sort hfn
			merge hfn using "`noref'", nokeep
			keep if _merge==3
			drop _merge
			rename hfn ref
		}
		if _N {
			di as txt
			di as txt ///
			"{title:`title':  referenced but should not be}"
			list ref
		}
	}
end

	

program CheckHlpFile, rclass
	args hfn hlpdta path refed_o refed_y

	ret scalar leaf = 0 

	GetFFN ffn : `"`path'"' "`hfn'"

	ReadHlpFile `"`path'"' "`hfn'"
	/* Extract `"`ffn'"' "help" "helpb"     <-- replaced with next line */
	ExtractHlp `"`ffn'"'
	CleanHlpArg 

	UpdateRef "`hfn'" "`refed_o'" "`refed_y'"

	if _N==0 {
		ret scalar leaf = 1
		exit
	}

	quietly {
		sort ref 
		by ref: keep if _n==1
		merge ref using "`hlpdta'", nokeep
		drop if _merge==3
	}
	if _N==0 { 
		exit
	}

	sort ref
	di as txt _n as res `"`ffn':  "' ///
		as txt "unmatched help references:"
	list ref
end

program UpdateRef 
	args	hfn ref_o ref_y

	if _N==0 {
		exit
	}
	preserve 
	quietly {
		if bsubstr("`hfn'",1,9)=="contents_"  ///
			| "`hfn'"=="contents.hlp" | "`hfn'"=="contents.sthlp" {
			local fn "`ref_y'"
		}
		else	local fn "`ref_o'"

		append using "`fn'"
		sort ref 
		by ref: keep if _n==1
		save "`fn'", replace
	}
end

program CleanHlpArg
	if _N==0 { 
		exit
	}

	// if first and last chars are double quotes, drop them
	quietly replace ref = bsubstr(ref,2,length(ref)-2) ///
		if bsubstr(ref,1,1) == `"""' & bsubstr(ref,-1,1) == `"""'

	// this allows things like "help r(2)" or "help r(663)"
	// and strips the "r(663)" to just "663"
	tempvar x
	quietly { 
		replace ref=lower(ref)
		gen `x' = bsubstr(ref,1,2)=="r(" & bsubstr(ref,-1,1)==")"
		replace ref = bsubstr(ref,3,.) if `x'
		replace ref = bsubstr(ref, 1, length(ref)-1) if `x'

		replace ref = bsubstr(ref,2,.) if bsubstr(ref,1,1)=="#"

		compress ref
		sort ref
		by ref: keep if _n==1
	}

	// drop any "|" and whatever follows it
	quietly {
		replace `x' = strpos(ref,"|")
		replace ref = bsubstr(ref,1,`x'-1) if `x'
	}

	// drop any "##" and whatever follows it
	// (maybe someday make this more sophisticated so it verifies markers
	// instead of ignoring the markers)
	quietly {
		replace `x' = strpos(ref,"##")
		replace ref = bsubstr(ref,1,`x'-1) if `x'
	}

	// Change "mata whatever()" to "mf_whatever"
	quietly {
		replace `x' = bsubstr(ref,1,5)=="mata " & bsubstr(ref,-2,2)=="()"
		replace ref = "mf_" + bsubstr(ref,6,length(ref)-7) if `x'
	}

	// Change "whatever()" to "f_whatever"
	quietly {
		replace `x' = bsubstr(ref,-2,2)=="()"
		replace ref = "f_" + bsubstr(ref,1,length(ref)-2) if `x'
	}

	// replace colon and 1 or 2 spaces combo with single underscore
	qui replace ref=subinstr(ref,":  ","_",.)
	qui replace ref=subinstr(ref,": ","_",.)

	// replace colon with underscore
	qui replace ref=subinstr(ref,":","_",.)

	// replace space with underscore
	qui replace ref=subinstr(ref," ","_",.)

	// replace dash with underscore
	qui replace ref=subinstr(ref,"-","_",.)

	// replace % with nothing if in first position (think of %fmt)
	qui replace ref=bsubstr(ref,2,.) if bsubstr(ref,1,1)=="%"
end

program ExtractHlp
	args ffn

	quietly {
		gen lino = _n
		gen str1 ref = ""
		gen byte used = 0
		while (1) {
			gen int pos1 = strpos(contents,"{help ") if used==0
			gen int pos2 = strpos(contents,"{helpb ") if used==0
			gen int pos3 = strpos(contents,"{manhelp ") if used==0
			gen int pos4 = strpos(contents,"{manhelpi ") if used==0
			gen int pos5 = strpos(contents,"{opth ") if used==0

			replace pos1 = 32700 if pos1==0 & used==0
			replace pos2 = 32700 if pos2==0 & used==0
			replace pos3 = 32700 if pos3==0 & used==0
			replace pos4 = 32700 if pos4==0 & used==0
			replace pos5 = 32700 if pos5==0 & used==0

			gen int pos = min(pos1,pos2,pos3,pos4,pos5) if used==0
			replace pos = 0 if pos==32700 & used==0

			keep if used | pos
			if _N==0 { 
				drop _all
				exit
			}
			capture assert used==1
			if _rc==0 { 
				keep ref
				compress
				exit
			}

			gen int len=0 if used==0
			gen byte kind=0 if used==0
			replace kind=1 if strpos(contents,"{help ")==pos ///
					& pos & used==0
			replace len=6 if strpos(contents,"{help ")==pos ///
					& pos & used==0
			replace kind=1 if strpos(contents,"{helpb ")==pos ///
					& pos & used==0
			replace len=7 if strpos(contents,"{helpb ")==pos ///
					& pos & used==0
			replace kind=2 if strpos(contents,"{manhelp ")==pos ///
					& pos & used==0
			replace len=9 if strpos(contents,"{manhelp ")==pos ///
					& pos & used==0
			replace kind=2 if strpos(contents,"{manhelpi ")==pos ///
					& pos & used==0
			replace len=10 if strpos(contents,"{manhelpi ")==pos ///
					& pos & used==0
			replace kind=3 if strpos(contents,"{opth ")==pos ///
					& pos & used==0
			replace len=6 if strpos(contents,"{opth ")==pos ///
					& pos & used==0

			replace contents=trim(bsubstr(contents,pos+len,.)) ///
				if used==0
			replace pos = strpos(contents, "}") if used==0
			gen byte bad = pos==0 & used==0
			ReportError `"`ffn'"' bad lino "no close brace"
			drop if bad 
			drop bad

			// for now ref gets everything up to closing brace
			replace ref=trim(bsubstr(contents,1,pos-1)) if used==0 

			// and contents gets whatever is left after it
			replace contents = trim(bsubstr(contents,pos+1,.)) ///
				if used==0

			// ---------------------------------------------------
			// deal with kind==1  (help and helpb)

			// now we trim any excess from ref
			// For instance       whatever:clickme
			// should have the colon and clickme trimmed off
			// However, with something like
			//        "svy: regress":click me
			// we should skip over the quoted part and trim the
			// second colon and what follows it.
			gen int col2 = 1 if used==0 & kind==1
			replace col2 = strpos(bsubstr(ref,2,.),`"""') ///
				if bsubstr(ref,1,1)==`"""' & used==0 & kind==1
			gen byte bad = col2==0 & used==0 & kind==1
			ReportError ///
			   `"`ffn'"' bad lino "open quote without close quote"
			drop if bad 
			drop bad
			replace col2 = col2+2 ///
				if bsubstr(ref,1,1)==`"""' & used==0 & kind==1
			gen str tmp = bsubstr(ref,col2,.) if used==0 & kind==1
			replace ref = bsubstr(ref,1,col2-1) if used==0 & kind==1
			replace col2 = strpos(tmp, ":") if used==0 & kind==1
			replace col2 = strlen(tmp)+1 ///
					if col2==0 & used==0 & kind==1
			replace ref = ref + bsubstr(tmp,1,col2-1) ///
					if used==0 & kind==1
			drop col2 tmp

			// ---------------------------------------------------
			// deal with kind==2  (manhelp and manhelpi)

			gen int col2 = 1 if used==0 & kind==2
			replace col2 = strpos(bsubstr(ref,2,.),`"""') ///
				if bsubstr(ref,1,1)==`"""' & used==0 & kind==2
			gen byte bad = col2==0 & used==0 & kind==2
			ReportError ///
			   `"`ffn'"' bad lino "open quote without close quote"
			drop if bad 
			drop bad
			replace col2 = col2+2 ///
				if bsubstr(ref,1,1)==`"""' & used==0 & kind==2
			replace col2 = strpos(ref," ") ///
				if col2==1 & used==0 & kind==2
			replace ref = bsubstr(ref,1,col2-1) if used==0 & kind==2

			drop col2

			// ---------------------------------------------------
			// deal with kind==3  (opth)

			gen int col1 = strpos(ref,"(") if used==0 & kind==3
			gen int col2 = strpos(ref,")") if used==0 & kind==3
			gen byte bad = col1==0 & used==0 & kind==3
			ReportError ///
			    `"`ffn'"' bad lino "missing opening paren in opth"
			drop if bad 
			drop bad
			gen byte bad = col2==0 & used==0 & kind==3
			ReportError ///
			    `"`ffn'"' bad lino "missing closing paren in opth"
			drop if bad 
			drop bad
			gen byte bad = col2<col1 & used==0 & kind==3
			ReportError `"`ffn'"' bad lino ///
				"closing paren before opening in opth"
			drop if bad 
			drop bad
			replace ref = trim(bsubstr(ref,col1+1,col2-col1-1)) ///
				if used==0 & kind==3

			// with kind==3 we now have the insides of the parens
			// kill off colon and after if not quoted at first
			gen int colpos = strpos(ref,":") ///
				if bsubstr(ref,1,1)!=`"""' & used==0 & kind==3
			replace ref = bsubstr(ref,1,colpos-1) ///
				if bsubstr(ref,1,1)!=`"""' ///
				& used==0 & kind==3 & colpos!=0
			// keep inside part of quoted part if quoted at first
			replace ref = bsubstr(ref,2, ///
					strpos(bsubstr(ref,2,.),`"""')-1) ///
				if bsubstr(ref,1,1)==`"""' & used==0 & kind==3

			drop col1 col2 colpos

			//----------------------------------------------------
			local n = _N
			expand 2 if used==0
			replace contents="" if used==0 in 1/`n'
			replace used = 1 if used==0 in 1/`n'
			if `n' < _N { 
				replace ref="" in `++n'/l
			}

			drop pos1 pos2 pos3 pos4 pos5 pos len kind
		}
	}
	/*NOTREACHED*/
end

program Extract
	args ffn smcla smclb

	local lena = length("`smcla'")
	if "`smclb'" != "" {
		local lenb = length("`smclb'")
	}

	quietly {
		gen lino = _n
		gen str1 ref = ""
		gen byte used = 0
		while (1) {
			gen int cola = strpos(contents,"{`smcla' ") if used==0
			if "`smclb'" != "" {
				gen int colb = strpos(contents,"{`smclb' ") ///
					if used==0
			}
			gen int len = 0 if used==0
			gen int col = cola if used==0
			replace len = `lena' if cola & used==0
			if "`smclb'" != "" {
				replace col = colb ///
				    if colb & (!cola | colb<cola) & used==0
				replace len = `lenb' ///
				    if colb & (!cola | colb<cola) & used==0
			}
			keep if used | col
			if _N==0 { 
				drop _all
				exit
			}
			capture assert used==1
			if _rc==0 { 
				keep ref
				compress
				exit
			}
			replace contents= ///
				trim(bsubstr(contents, col+len+2, .)) ///
				if used==0
			replace col = strpos(contents, "}") if used==0
			gen byte bad = col==0 & used==0
			ReportError `"`ffn'"' bad lino "no close brace"
			drop if bad 
			drop bad

			// for now ref gets everything up to closing brace
			replace ref = trim(bsubstr(contents,1,col-1)) ///
				 if used==0 

			// and contents gets whatever is left after it
			replace contents = trim(bsubstr(contents,col+1,.)) ///
				if used==0

			// now we trim any excess from ref
			// For instance       whatever:clickme
			// should have the colon and clickme trimmed off
			// However, with something like
			//        "svy: regress":click me
			// we should skip over the quoted part and trim the
			// second colon and what follows it.
			gen col2 = 1 if used == 0
			replace col2 = strpos(bsubstr(ref,2,.),`"""') ///
				if bsubstr(ref,1,1)==`"""' & used==0
			gen byte bad = col2==0 & used==0
			ReportError ///
			   `"`ffn'"' bad lino "open quote without close quote"
			drop if bad 
			drop bad
			replace col2 = col2+2 ///
				if bsubstr(ref,1,1)==`"""' & used==0
			gen str tmp = bsubstr(ref,col2,.) if used==0
			replace ref = bsubstr(ref,1,col2-1) if used==0
			replace col2 = strpos(tmp, ":") if used==0
			replace col2 = strlen(tmp)+1 if col2==0 & used==0
			replace ref = ref + bsubstr(tmp,1,col2-1) if used==0

			local n = _N
			expand 2 if used==0
			replace contents="" if used==0 in 1/`n'
			replace used = 1 if used==0 in 1/`n'
			if `n' < _N { 
				replace ref="" in `++n'/l
			}
			drop col col2 tmp cola len
			capture drop colb
		}
	}
	/*NOTREACHED*/
end

program ReportError
	args hfn bad tolist msg
	capture assert `bad'==0
	if _rc==0 { 
		exit
	}
	preserve
	di as txt _n `"`msg'"'
	keep if `bad'
	list `tolist'
end

program GetFFN
	args ffn colon path fn
	if "`colon'" != ":" { 
		exit 198
	}
	qui findfile "`fn'", path("`path'")
	c_local `ffn' `"`r(fn)'"'
end


program ReadHlpFile 
	args path hfn

	GetFFN ffn : `"`path'"' "`hfn'"

	quietly {
		drop _all
		infix str contents 1-240 using `"`ffn'"'
		compress
	}
end


program MakeHlpFileDataset 
	local n : word count `0'
	quietly { 
		drop _all
		set obs `n'
		gen str1 hfn = ""
		local i 1
		foreach el of local 0 {
			replace hfn = `"`el'"' in `i++'
		}
		gen i = strpos(hfn, ".hlp")
		replace i = strpos(hfn, ".sthlp") if i==0
		replace hfn = bsubstr(hfn, 1, i-1) if i
		drop i
		sort hfn
	}
end

program MakeDlgFileDataset 
	local n : word count `0'
	quietly { 
		drop _all
		set obs `n'
		gen str1 dfn = ""
		local i 1
		foreach el of local 0 {
			replace dfn = `"`el'"' in `i++'
		}
		gen i = strpos(dfn, ".dlg")
		replace dfn = bsubstr(dfn, 1, i-1) if i
		drop i
		sort dfn 
	}
end


program GetAliases, rclass
	args result colon path

	tempfile afile

	ReadHlpFile `"`path'"' _help_alias.maint
	qui save `"`afile'"'
	foreach ltr in a b c d e f g h i j k l m n o p q r s t u v w x y z {
		ReadHlpFile `"`path'"' `ltr'help_alias.maint
		qui append using `"`afile'"'
		qui save `"`afile'"', replace
	}

	quietly { 
		gen str alias = trim(word(contents,1))
		keep alias
	}
	local n = _N
	forvalues i=1(1)`n' {
		local el = alias[`i']
		local list `list' `el'
	}
	qui drop _all
	c_local `result' `list'
	local na : word count `list'
	ret scalar n = `na'
	di as txt "(`na' aliases)"
end


program GetFiles, rclass
	args result colon suffix path
	local subdirs "_ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"

	gettoken d path : path, parse(" ;")
	while `"`d'"' != "" {
		if `"`d'"' != ";" {
			local d : sysdir `"`d'"'

			capture local x : dir "`d'" files "*`suffix'"
			if _rc==0 {
				local list : list list | x
			}

			foreach l of local subdirs {
				capture local x : dir "`d'`l'" files "*`suffix'"
				if _rc==0 {
					local list : list list | x
				}
			}
		}
		gettoken d path : path, parse(" ;")
	}




	local list : list clean list
	c_local `result' : list sort list
	local n : word count `list'
	ret scalar n = `n' 
	di as txt "(`n' `suffix' files)"
end
