*! version 1.4.2  13nov2018
program gr_set
	version 14
	gettoken cmd 0 : 0, parse(", ")
	if ("`cmd'"=="print") {
		Print `0'
		exit
	}
	if "`cmd'"=="ps" {
		Ps `0'
		exit
	}
	if "`cmd'"=="eps" {
		Eps `0'
		exit
	}
	if "`cmd'"=="svg" {
		Svg `0'
		exit
	}
	if "`cmd'"=="mf" {
		Mf `0'
		exit
	}
	if "`cmd'"=="pict" {
		Pict `0'
		exit
	}
	if "`cmd'"=="window" {
		Window `0'
		exit
	}
	if "`cmd'"=="" {
		di as txt "-> graph set window"
		WindowQuery

		if (c(os) != "Unix") {
			di
			di as txt "-> graph set print"
			PrintQuery
		}
		di
		di as txt "-> graph set ps"
		PsQuery

		di
		di as txt "-> graph set eps"
		EpsQuery

		di
		di as txt "-> graph set svg"
		SvgQuery

		/*
		if (c(os) == "Windows") {
			di
			di as txt "-> graph set mf"
			MfQuery
		}

		if (c(os) == "MacOSX") {
			di
			di as txt "-> graph set pict"
			PictQuery
		}
		*/
		exit
	}
	di as err "`cmd':  invalid graph set subcommand"
	exit 198
end

program Print 
	args setting choice nothing 

	if c(os)=="Unix" {
		Ps `0'
		exit
	}

	if "`setting'"=="" PrintQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		translator set gph2prn `setting' `choice'
	}
end

program Ps
	args setting choice nothing 

	if ("`setting'"=="") PsQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		if ("`setting'" == "fontdir" | "`setting'" == "fontface" | "`setting'" == "fontfacemono" | "`setting'" == "fontfacesans"| "`setting'" == "fontfaceserif" | "`setting'" == "fontfacesymbol") { 
			translator set gph2ps `setting' "`choice'"
		}
		else {
			translator set gph2ps `setting' `choice'
		}
	}
end

program Eps
	args setting choice nothing 

	if ("`setting'"=="") EpsQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		if ("`setting'" == "fontdir" | "`setting'" == "fontface" | "`setting'" == "fontfacesans" | "`setting'" == "fontfaceserif"| "`setting'" == "fontfacemono" | "`setting'" == "fontfacesymbol") { 
			translator set gph2eps `setting' "`choice'"
		}
		else {
			translator set gph2eps `setting' `choice'
		}
	}
end

program Svg
	args setting choice nothing 

	if ("`setting'"=="") SvgQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		if ("`setting'" == "fontface" | "`setting'" == "fontfacesans" | "`setting'" == "fontfaceserif"| "`setting'" == "fontfacemono" | "`setting'" == "fontfacesymbol") { 
			translator set gph2svg `setting' "`choice'"
		}
		else {
			translator set gph2svg `setting' `choice'
		}
	}
end

program Window
	args setting choice nothing 

	if ("`setting'"=="") WindowQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		if ("`setting'" == "fontface" | "`setting'" == "fontfacesans" | "`setting'" == "fontfaceserif" | "`setting'" == "fontfacemono" | "`setting'" == "fontfacesymbol") { 
			gprefs set window `setting' "`choice'"
		}
		else {
			gprefs set window `setting' `choice'
		}
	}
end

program Mf
	args setting choice nothing 

	if c(os)!="Windows" {
		di as err "mf settings not available under `c(os)'"
		exit 198
	}
	if ("`setting'"=="") MfQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		if ("`setting'" == "fontface") {
			translator set gph2wmf `setting' "`choice'"
		}
		else {
			translator set gph2wmf `setting' `choice'
		}
	}
end

program Pict
	args setting choice nothing 

	if c(os)!="MacOSX" {
		di as err "pict settings not available under `c(os)'"
		exit 198
	}
	if ("`setting'"=="") PictQuery
	else {
		if ("`choice'"=="" | "`nothing'"!="") error 198
		if ("`setting'" == "fontface") {
			translator set gph2pict `setting' "`choice'"
		}
		else {
			translator set gph2pict `setting' `choice'
		}
	}
end

		

program PrintQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui translator query gph2prn
	ret local logo    "`r(logo)'"
	ret local tmargin "`r(tmargin)'"
	ret local lmargin "`r(lmargin)'"
	if c(os) == "MacOSX" {
		ret local fittopage "`r(fittopage)'"
	}

	di 
	di as txt _col(4) "print" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	Di "logo" "`return(logo)'" "{res:on} or {res:off}"
	Di "tmargin" "`return(tmargin)'" "#, 0 <= # <= 20"
	Di "lmargin" "`return(lmargin)'" "#, 0 <= # <= 20"
	if c(os) == "MacOSX" {
		Di "fittopage" "`return(fittopage)'" "{res:on} or {res:off}"
	}
	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set print " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program PsQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui translator query gph2ps
	ret local logo    "`r(logo)'"
	ret local cmyk    "`r(cmyk)'"
	ret local tmargin "`r(tmargin)'"
	ret local lmargin "`r(lmargin)'"
	ret local mag     "`r(mag)'"
	ret local fontface    "`r(fontface)'"
	ret local fontfacesans "`r(fontfacesans)'"
	ret local fontfaceserif "`r(fontfaceserif)'"
	ret local fontfacemono "`r(fontfacemono)'"
	ret local fontfacesymbol "`r(fontfacesymbol)'"
	if (c(os) == "Unix") {
		ret local fontdir    "`r(fontdir)'"
	}
	ret local orientation "`r(orientation)'"
	ret local pagesize    "`r(pagesize)'"
	ret local pageheight  "`r(pageheight)'"
	ret local pagewidth   "`r(pagewidth)'"

	
	local chdr = cond(c(os)=="Unix", "ps/print", "ps")

	di as txt
	di as txt _col(4) "`chdr'" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	Di "tmargin" "`return(tmargin)'" "#, 0 <= # <= 20"
	Di "lmargin" "`return(lmargin)'" "#, 0 <= # <= 20"
	Di "logo" "`return(logo)'" "{res:on} or {res:off}"
	Di "cmyk" "`return(cmyk)'" "{res:on} or {res:off}"
	Di "mag"  "`return(mag)'" "#, 1 <= # <= 10000"

	Di "fontface" "`return(fontface)'" "font name"
	Di "fontfacesans" "`return(fontfacesans)'" "font name"
	Di "fontfaceserif" "`return(fontfaceserif)'" "font name"
	Di "fontfacemono" "`return(fontfacemono)'" "font name"
	Di "fontfacesymbol" "`return(fontfacesymbol)'" "font name"
	if (c(os) == "Unix") {
		Di "fontdir" "`return(fontdir)'" "font directory"
	}
	Di "orientation" "`return(orientation)'" ///
		   "{res:portrait} or {res:landscape}"
	Di "pagesize" "`return(pagesize)'" ///
		   "{res:letter}, {res:legal}, {res:executive}, {res:A4}, {res:custom}"

	if "`return(pagesize)'"=="custom" {
		Di "pageheight" "`return(pageheight)'" ///
	   	"#, 0 <= # <= 20"
		Di "pagewidth" "`return(pagewidth)'" ///
	   	"#, 0 <= # <= 20"
	}
	else {
		Di "pageheight" "{txt:--}" ///
		"relevant only if {res:pagesize} is {res:custom}"
		Di "pagewidth" "{txt:--}" ///
		"relevant only if {res:pagesize} is {res:custom}"
	}

	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set ps " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program EpsQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui translator query gph2eps
	ret local logo    "`r(logo)'"
	ret local cmyk    "`r(cmyk)'"
	ret local mag     "`r(mag)'"
	ret local fontface    "`r(fontface)'"
	ret local fontfacesans "`r(fontfacesans)'"
	ret local fontfaceserif "`r(fontfaceserif)'"
	ret local fontfacemono "`r(fontfacemono)'"
	ret local fontfacesymbol "`r(fontfacesymbol)'"
	if (c(os) == "Unix") {
		ret local fontdir    "`r(fontdir)'"
	}
	ret local orientation "`r(orientation)'"
	ret local preview "`r(preview)'"

	
	di as txt
	di as txt _col(4) "eps" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	Di "logo" "`return(logo)'" "{res:on} or {res:off}"
	Di "cmyk" "`return(cmyk)'" "{res:on} or {res:off}"
	Di "mag"  "`return(mag)'" "#, 1 <= # <= 10000"
	Di "preview" "`return(preview)'" "{res:on} or {res:off}"
	Di "fontface" "`return(fontface)'" "font name"
	Di "fontfacesans" "`return(fontfacesans)'" "font name"
	Di "fontfaceserif" "`return(fontfaceserif)'" "font name"
	Di "fontfacemono" "`return(fontfacemono)'" "font name"
	Di "fontfacesymbol" "`return(fontfacesymbol)'" "font name"
	if (c(os) == "Unix") {
		Di "fontdir" "`return(fontdir)'" "font directory"
	}
	Di "orientation" "`return(orientation)'" ///
		   "{res:portrait} or {res:landscape}"

	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set eps " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program SvgQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui translator query gph2svg
	ret local baselineshift    "`r(baselineshift)'"
	ret local ignorefont       "`r(ignorefont)'"
	ret local nbsp             "`r(nbsp)'"
	ret local clipstroke       "`r(clipstroke)'"
	ret local scalestrokewidth "`r(scalestrokewidth)'"
	ret local fontface    "`r(fontface)'"
	ret local fontfacesans "`r(fontfacesans)'"
	ret local fontfaceserif "`r(fontfaceserif)'"
	ret local fontfacemono "`r(fontfacemono)'"
	ret local fontfacesymbol "`r(fontfacesymbol)'"

	
	di as txt
	di as txt _col(4) "svg" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	Di "baselineshift" "`return(baselineshift)'" "{res:on} or {res:off}"
	Di "ignorefont" "`return(ignorefont)'" "{res:on} or {res:off}"
	Di "nbsp" "`return(nbsp)'" "{res:on} or {res:off}"
	Di "clipstroke" "`return(clipstroke)'" "{res:on} or {res:off}"
	Di "scalestrokewidth" "`return(scalestrokewidth)'" "{res:on} or {res:off}"
	Di "fontface" "`return(fontface)'" "font name"
	Di "fontfacesans" "`return(fontfacesans)'" "font name"
	Di "fontfaceserif" "`return(fontfaceserif)'" "font name"
	Di "fontfacemono" "`return(fontfacemono)'" "font name"
	Di "fontfacesymbol" "`return(fontfacesymbol)'" "font name"

	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set svg " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program WindowQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui gprefs query window
	ret local fontface    "`r(fontface)'"
	ret local fontfacesans "`r(fontfacesans)'"
	ret local fontfaceserif "`r(fontfaceserif)'"
	ret local fontfacemono "`r(fontfacemono)'"
	ret local fontfacesymbol "`r(fontfacesymbol)'"
	
	local chdr = "window"

	di as txt
	di as txt _col(4) "`chdr'" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	Di "fontface" "`return(fontface)'" "font name"
	Di "fontfacesans" "`return(fontfacesans)'" "font name"
	Di "fontfaceserif" "`return(fontfaceserif)'" "font name"
	Di "fontfacemono" "`return(fontfacemono)'" "font name"
	Di "fontfacesymbol" "`return(fontfacesymbol)'" "font name"

	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set window " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program PictQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui translator query gph2pict
	ret local mag     "`r(mag)'"
	ret local fontface    ""
	
	di as txt
	di as txt _col(4) "pict" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	Di "mag"  "`return(mag)'" "#, 1 <= # <= 10000"

	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set pict " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program MfQuery, rclass
	if (trim(`"`0'"')!= "") error 198
	qui translator query gph2wmf
	ret local fontface    ""
	
	di as txt
	di as txt _col(4) "`mf'" _col(21) "current"
	di as txt _col(4) "setting" _col(21) "default" _col(38) "choices"
	di as txt _col(4) "{hline 72}"

	di as txt _col(4) "{hline 72}"
	di as txt _col(4) `"To change setting, type ""' _c 
	di as res "graph set mf " as txt ///
		"{it:setting} {it:choice}" as txt `"""'
end

program Di
	args setting default choices

	di as txt _col(4)  "`setting'" ///
	   as res _col(21) "`default'" ///
	   as txt _col(39) "`choices'"
end
