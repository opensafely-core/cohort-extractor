*! version 1.4.0  13nov2018
program gr_export
	version 9
	local 0 `"using `0'"'
	syntax using/ [, AS(string) NAME(passthru) REPLACE *]

	if "`replace'"=="" {
		confirm new file `"`using'"'
	}

	if "`as'"=="" {
		Suffix as : `"`using'"'
		capture VerifySuffix `as'
		if _rc { 
			di as err "{p 0 4 2}"
			di as err ///
			`"output-file suffix "`as'" not recognized{break}"'
			di as err ///
			"specify correct suffix or specify as() option"
			di as err "{p_end}"
			exit 198
		}
	}
	else {
		capture VerifySuffix `as'
		if _rc {
			di as err `"option as(`as') invalid"'
			exit 198
		}
	}
	OpSysCheck `as'
	GenericClass genas : `as'
	GetOpts_`genas' options : `"`options'"'

	translate @Graph `"`using'"', translator(Graph2`as') ///
		`name' `replace' `options'
end

program GetOpts_ps
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		TMargin(passthru)
		LMargin(passthru)
		LOGO(passthru)
		MAG(passthru)
		FONTface(passthru)
		FONTFACESANS(passthru)
		FONTFACESERIF(passthru)
		FONTFACEMONO(passthru)
		FONTFACESYMBOL(passthru)
		FONTDIR(passthru)
		ORientation(passthru)
		PAGESize(passthru)
		PAGEHeight(passthru)
		PAGEWidth(passthru)
		CMYK(passthru)
	       ] ;
	c_local `lhs'
		`tmargin'
		`lmargin'
		`logo'
		`mag'
		`fontface'
		`fontfacesans'
		`fontfaceserif'
		`fontfacemono'
		`fontfacesymbol'
		`fontdir'
		`orientation'
		`pagesize'
		`pageheight'
		`pagewidth'
		`cmyk'
		;
	#delimit cr
end

program GetOpts_eps
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		LOGO(passthru)
		MAG(passthru)
		FONTface(passthru)
		FONTFACESANS(passthru)
		FONTFACESERIF(passthru)
		FONTFACEMONO(passthru)
		FONTFACESYMBOL(passthru)
		FONTDIR(passthru)
		ORientation(passthru)
		PREview(passthru)
		CMYK(passthru)
	       ] ;
	c_local `lhs'
		`logo'
		`mag'
		`fontface'
		`fontfacesans'
		`fontfaceserif'
		`fontfacemono'
		`fontfacesymbol'
		`fontdir'
		`orientation'
		`preview'
		`cmyk'
		;
	#delimit cr
end

program GetOpts_svg
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		MAG(passthru)
		FONTface(passthru)
		FONTFACESANS(passthru)
		FONTFACESERIF(passthru)
		FONTFACEMONO(passthru)
		FONTFACESYMBOL(passthru)
		IGNOREFont(passthru)
		BGFill(passthru)
		SCALESTRokewidth(passthru)
		BASElineshift(passthru)
		NBSP(passthru)
		CLIPSTRoke(passthru)
		VERBose
		WIDth(passthru)
		HEIght(passthru)
		PATHPrefix(passthru)
	       ] ;
	c_local `lhs'
		`mag'
		`fontface'
		`fontfacesans'
		`fontfaceserif'
		`fontfacemono'
		`fontfacesymbol'
		`ignorefont'
		`bgfill'
		`scalestrokewidth'
		`baselineshift'
		`nbsp'
		`clipstroke'
		`verbose'
		`width'
		`height'
		`pathprefix'
		;
	#delimit cr
end

program GetOpts_mf
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		FONTface(passthru)
	       ] ;
	c_local `lhs'
		`fontface'
		;
	#delimit cr
end

program GetOpts_png
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		WIDth(string)
		HEIght(string)
	       ] ;
	#delimit cr
	if "`width'" != "" {
		capture confirm integer number `width'
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		}
		capture assert inrange(`width', 8, 16000)
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		} 
		else {
			local width "width(`width')"
		}
	}
	if "`height'" != "" {
		capture confirm integer number `height'
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
	
		capture assert inrange(`height', 8, 16000)
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
		else {
			local height "height(`height')"
		}
	}
	#delimit ;
	c_local `lhs'
		`width'
		`height'
		;
	#delimit cr
end

program GetOpts_tif
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		WIDth(string)
		HEIght(string)
	       ] ;
	#delimit cr
	if "`width'" != "" {
		capture confirm integer number `width'
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		}
		capture assert inrange(`width', 8, 16000)
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		} 
		else {
			local width "width(`width')"
		}
	}
	if "`height'" != "" {
		capture confirm integer number `height'
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
	
		capture assert inrange(`height', 8, 16000)
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
		else {
			local height "height(`height')"
		}
	}
	#delimit ;
	c_local `lhs'
		`width'
		`height'
		;
	#delimit cr
end

program GetOpts_gif
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		WIDth(string)
		HEIght(string)
	       ] ;
	#delimit cr
	if "`width'" != "" {
		capture confirm integer number `width'
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		}
		capture assert inrange(`width', 8, 16000)
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		} 
		else {
			local width "width(`width')"
		}
	}
	if "`height'" != "" {
		capture confirm integer number `height'
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
	
		capture assert inrange(`height', 8, 16000)
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
		else {
			local height "height(`height')"
		}
	}
	#delimit ;
	c_local `lhs'
		`width'
		`height'
		;
	#delimit cr
end

program GetOpts_jpg
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		WIDth(string)
		HEIght(string)
		Quality(string)
	       ] ;
	#delimit cr
	if "`width'" != "" {
		capture confirm integer number `width'
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		}
		capture assert inrange(`width', 8, 16000)
		if _rc {
			display as err "width() must be an integer between 8 and 16,000"
			exit 198
		} 
		else {
			local width "width(`width')"
		}
	}
	if "`height'" != "" {
		capture confirm integer number `height'
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
	
		capture assert inrange(`height', 8, 16000)
		if _rc {
			display as err "height() must be an integer between 8 and 16,000"
			exit 198
		}
		else {
			local height "height(`height')"
		}
	}
	if "`quality'" != "" {
		capture confirm integer number `quality'
		if _rc {
			display as err "quality() must be an integer between 1 and 100"
			exit 198
		}
	
		capture assert inrange(`quality', 1, 100)
		if _rc {
			display as err "quality() must be an integer between 1 and 100"
			exit 198
		}
		else {
			local quality "quality(`quality')"
		}
	}
	#delimit ;
	c_local `lhs'
		`width'
		`height'
		`quality'
		;
	#delimit cr
end

program GetOpts_pdf
	args lhs colon rhs
	local 0 `", `rhs'"'
	#delimit ;
	syntax [, 
		LOGO(passthru)
		MAG(passthru)
		FONTface(passthru)
		FONTFACESANS(passthru)
		FONTFACESERIF(passthru)
		FONTFACEMONO(passthru)
		FONTFACESYMBOL(passthru)
		FONTDIR(passthru)
		ORientation(passthru)
		CMYK(passthru)
		XSIZE(passthru)
		YSIZE(passthru)		
	       ] ;
	c_local `lhs'
		`logo'
		`mag'
		`fontface'
		`fontfacesans'
		`fontfaceserif'
		`fontfacemono'
		`fontfacesymbol'
		`fontdir'
		`orientation'
		`cmyk'
		`xsize'
		`ysize'		
		;
	#delimit cr
end


program GenericClass
	args lhs colon as
	if ("`as'"=="wmf" | "`as'"=="emf") c_local `lhs' "mf"
	else if ("`as'"=="jpeg") c_local `lhs' "jpg"
	else c_local `lhs' `as'
end



program OpSysCheck
	args as
	if ("`as'"=="ps" | "`as'"=="eps" | "`as'"=="png" | "`as'"=="tif" ///
		| "`as'"=="pdf" | "`as'"=="svg") exit
	if (c(os)=="Windows" & ("`as'"=="wmf" | "`as'"=="emf")) exit
	if (c(os)=="MacOSX" & ("`as'"=="jpeg" | "`as'"=="jpg" ///
		| "`as'"=="gif")) exit
	di as err "Stata for `c(os)' cannot create `as' files"
	exit 198
end
	

program VerifySuffix 
	args as
	if ("`as'"=="png") exit
	if ("`as'"=="tif") exit
	if ("`as'"=="pdf") exit
	if ("`as'"=="svg") exit
	if ("`as'"=="ps" | "`as'"=="eps") exit
	if ("`as'"=="wmf" | "`as'"=="emf") exit
	if ("`as'"=="jpeg" | "`as'"=="jpg") exit
	if ("`as'"=="gif") exit
	exit 9
end


program Suffix 
	args lhs colon fname
	local fname : subinstr local fname "/" " ", all
	local fname : subinstr local fname "\" " ", all
	local n     : word count `fname'
	local last : word `n' of `fname'
	local l = index("`last'", ".")
	if `l'==0 c_local `lhs' ""
	else 	  c_local `lhs' = bsubstr("`last'",`l'+1,.)
end
