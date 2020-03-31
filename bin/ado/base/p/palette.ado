*! version 1.2.1  24mar2017
program palette
	gettoken cmd 0 : 0, parse(" ,")

	local l = length("`cmd'")

	if "`cmd'"==bsubstr("symbolpalette",1,max(3,`l')) {
		symbolpalette `0'
	}
	else if "`cmd'"==bsubstr("smclsymbolpalette",1,max(3,`l')) {
		smclsymbolpalette `0'
	}
	else if "`cmd'"==bsubstr("linepalette",1, max(3,`l')) {
		linepalette `0'
	}
	else if "`cmd'"=="color" {
		color `0'
	}
	else {
		di as err "invalid subcommand; understood are"
		di as err "{col 8} palette linepalette"
		di as err "{col 8} palette symbolpalette"
		di as err "{col 8} palette smclsymbolpalette"
		di as err "{col 8} palette color {it:color} [{it:color}]
		exit 198
	}
end

program symbolpalette
	syntax [, SCHeme(passthru)]
	gr_setscheme , `scheme' refscheme		// handle scheme
	preserve
	set more off
	qui drop _all
//	local list `" "1 1 O"  "1 2 Oh" "1 3 o" "1 4 oh"  "2 1 D" "2 2 Dh" "2 3 d" "2 4 dh" "3 1 T" "3 2 Th"  "3 3 t"  "3 4 th" "4 1 S" "4 2 Sh" "4 3 s" "4 4 sh"  "5 1 +" "5 3 smplus" "6 1 X" "6 3 x" "7 1 A" "7 3 a" "8 1 V" "8 3 v" "9 1 |" "9 3 p"  "'
	local list `" "1 1 O"  "1 2 Oh" "1 3 o" "1 4 oh"  "2 1 D" "2 2 Dh" "2 3 d" "2 4 dh" "3 1 T" "3 2 Th"  "3 3 t"  "3 4 th" "4 1 S" "4 2 Sh" "4 3 s" "4 4 sh"  "5 1 +" "5 2 smplus" "5 3 X" "5 4 x" "6 1 A" "6 2 a" "6 3 V" "6 4 v" "7 1 |" "7 2 p"  "'

	local cmd
	qui set obs 0
	qui gen x = .
	qui gen y = .
	qui gen id = .
	qui gen str1 t = ""
	foreach el of local list {
		local y :word 1 of `el'
		local x :word 2 of `el'
		local s :word 3 of `el'
		qui set obs `=_N+1'
		qui replace x= `x' in l 
		qui replace y= `y' in l
		qui replace id = _n in l 
		qui replace t = "`s'" in l
		local c "sc y x if id==`=_N', ms(`s') mlabel(t) pstyle(p1) msize(3) mlabgap(3) mlabsize(4)"
		local cmd `cmd' (`c')
	}
	* di "`cmd'"
	capture twoway `cmd', xsca(r(-.05 5)) xlab(none) ysca(reverse) ///
		ysca(r(0 8)) ylab(none) xtitle("") ytitle("") ///
		title("Symbol palette") graphregion(lstyle(none)) ///
		note("(symbols shown at larger than default size)") `scheme' ///
		legend(nodraw)
end


program smclsymbolpalette
	syntax [, SCHeme(passthru)]
	gr_setscheme , `scheme' refscheme		// handle scheme
	preserve
	set more off
	qui drop _all
	local list `" "Alpha" "Beta" "Chi" "Delta" "Epsilon" "Eta" "Gamma" "Iota" "Kappa" "Lambda" "Mu" "Nu" "Omega" "Omicron" "Phi" "Pi" "Prime" "Psi" "Rho" "Sigma" "Tau" "Theta" "Upsilon" "Xi" "Zeta" "alefsym" "alpha" "amp" "and" "ang" "asymp" "beta" "bull" "cap" "chi" "clubs" "cong" "copy" "crarr" "cup" "dArr" "darr" "degree" "delta" "diams" "empty" "epsilon" "equiv" "eta" "euro" "exist" "fnof" "forall" "frasl" "gamma" "ge" "gt" "hArr" "harr" "hearts" "hellip" "image" "infin" "int" "iota" "isin" "kappa" "lArr" "lambda" "larr" "le" "lowast" "loz" "lt" "minus" "mu" "nabla" "ne" "notin" "nsub" "nu" "omega" "omicron" "oplus" "or" "otimes" "part" "perp" "phi" "pi" "piv" "plusmn" "prime" "prod" "prop" "psi" "rArr" "radic" "rarr" "real" "reg" "rho" "sdot" "sigma" "sigmaf" "sim" "spades" "sub" "sube" "sum" "sup" "supe" "tau" "there4" "theta" "thetasym" "trade" "uArr" "uarr" "upsih" "upsilon" "weierp" "xi" "zeta" "'

	local cmd
	qui set obs 0
	qui gen x = .
	qui gen y = .
	qui gen id = .
	qui gen str1 t = ""
	qui gen str1 tt = ""
	local i = 0
	local y = 1
	local maxcols = 5
	local l : word count `list'
	local maxrows = ceil(`l'/`maxcols')
	foreach s of local list {
		local x = int(`i'/`maxrows')
		qui set obs `=_N+1'
		qui replace x= `x' in l 
		qui replace y= `y' in l
		qui replace id = _n in l 
		qui replace t = "`s'" in l
		qui replace tt = "{&`s'}" in l
		local c "sc y x if id==`=_N', ms(none) mlabel(tt) pstyle(p1) mlabsize(3)"
		local cmd `cmd' (`c')
		local c "sc y x if id==`=_N', ms(none) mlabel(t) pstyle(p1) mlabgap(5) mlabsize(2)"
		local cmd `cmd' (`c')
		local i = `i' + 1
		local y = `y' + 1
		if `y' > `maxrows' {
			local y = 1
		}
	}
	local maxrows = `maxrows' + 1
	* di "`cmd'"
	capture twoway `cmd', xsca(r(0 `maxcols')) xlab(none) ysca(reverse) ///
		ysca(r(0 `maxrows')) ylab(none) xtitle("") ytitle("") ///
		title("SMCL symbol palette") graphregion(lstyle(none)) ///
		legend(nodraw)
end


program linepalette
	syntax [, SCHeme(passthru)]
	gr_setscheme , `scheme' refscheme		// handle scheme
	preserve
	qui drop _all
	local list `" "1 solid" "2 dash" "3 longdash_dot" "4 dot" "5 longdash" "6 dash_dot" "7 shortdash" "8 shortdash_dot" "9 blank" "'

	local cmd
	qui set obs 0
	qui gen x = .
	qui gen x2 = .
	qui gen y = .
	qui gen str1 s = ""
	foreach el of local list {
		local y : word 1 of `el'
		local s : word 2 of `el'
		local n1 = _N+1
		local n2 = _N+2 
		qui set obs `n2' 
		qui replace y = `y' in `n1'/`n2'
		qui replace x = 0 in `n1'
		qui replace x = 1 in `n2'
		qui replace s = "`s'" in `n1' 
		qui replace x2= 1.2  in `n1'
		local c1 "sc y x in `n1'/`n2', pstyle(p1) ms(i) c(l) clpattern(`s')"
		local c2 "sc y x2 in `n1', pstyle(p1) ms(i) mlabel(s) mlabsize(4)"
		local cmd "`cmd' (`c1') (`c2')"
	}
	* di "`cmd'"
	capture twoway `cmd', ysca(r(0 10)) xsca(r(0 1.5)) ///
		xlab(none) ylab(none) ysca(reverse) ///
		xtitle("") ytitle("") title("Line pattern palette") ///
		legend(nodraw) `scheme'
end


program define getcolor 
	args mcolor mrest colon from

	gettoken color : from, parse(" ,")
	if "`color'"=="," { 
		c_local `mcolor' ""
		c_local `mrest' `"`from'"'
		exit
	}

	gettoken color from : from, parse(" ,")
	capture confirm integer number `color'
	if _rc {
		c_local `mcolor' "`color'"
		c_local `mrest' `"`from'"'
		exit
	}
	gettoken green from : from, parse(" ,")
	gettoken blueag  from : from, parse(" ,")
	gettoken blue bluerest : blueag, parse(" *")

	capture confirm integer number `green'
	local bad = _rc 
	capture confirm integer number `blue'
	local bad = `bad' + _rc
	if `color'<0 | `color'>255 { 
		local bad 1
	}
	if `green'<0 | `green'>255 {
		local bad 1
	}
	if `blue'<0 | `blue'>255 {
		local bad 1 
	}
	if `bad' {
		di as err `""`color' `green' `blue'" invalid RGB value"'
		exit 198
	}
	if "`bluerest'"=="" {
		c_local `mcolor' "`color' `green' `blue'"
		c_local `mrest' `"`from'"'
		exit
	}
	gettoken s rest : bluerest, parse(" *")
	gettoken num rest : rest, parse(" *")
	if "`s'" !="*" || trim(`"`rest'"') != "" {
		local bad 1
	}
	capture confirm number `num'
	if _rc | `bad' { 
		di as err `""`s'`num'`rest'" invalid intensity modifier"'
		exit 198
	}
	c_local `mcolor' "`color' `green' `blueag'"
	c_local `mrest' `"`from'"'
end
	

program define color
	version 8

	getcolor color 0 : `"`0'"'
	getcolor color2 0 : `"`0'"'

	capture syntax [, CMYK SCHeme(passthru) ]
	gr_setscheme , `scheme' refscheme		// handle scheme
	if _rc | "`color'"=="" {
		di as err ("invalid syntax")
		di as err "{p 4 4 2}
		di as err "Syntax is -palette color {it:colorname} [{it:colorname}] [, scheme({it:schemename})]-{break}"
		di as err "You may specify one color or you may specify two"
		di as err "colors if you want them compared."
		di as err "Type -graph query colorstyle-"
		di as err "for a list of colornames."
		di as err "{p_end}"
		exit 198
	}
	if ("`cmyk'" == "")  local type "RGB"
	else		     local type "CMYK"
	color_load `color'
	local rgb "`s(rgb)'"
	if ("`cmyk'" != "") rgb2cmyk rgb : `rgb'
	local color `"`s(color)'"'

	if `"`color2'"'!="" {
		color_load `color2'
		local rgb2 "`s(rgb)'"
		if ("`cmyk'" != "") rgb2cmyk rgb2 : `rgb2'
		local color2 `"`s(color)'"'
		di as txt `"(`color' = "`rgb'", `color2' = "`rgb2'")"'
	}
	else 	di as txt `"(`color' = "`rgb'")"'
	sret clear

	preserve
	qui {
		drop _all
		gen y = . 
		gen x = . 
		gen str1 s = ""
	}

	color_add 1 1 `"Color `color' is `type' "`rgb'""'
	local cmd1 ///
		sc y x in 1, ///
		ms(S) mcolor(`color') msize(10) ///
		mlabel(s) mlabcolor(`color') mlabgap(2) mlabsize(4)

	color_add 2 1 ""
	color_add 2 1.2 ""
	color_add 2 2 ""
	color_add 2 2.2 ""
	local cmd2 sc y x in 2, ms(O) mcolor(`color')
	local cmd3 line y x in 3/4, clc(`color')
	local cmd4 sc y x in 5, ms(Oh) mcolor(`color')
	local cmdA (`cmd1') (`cmd2') (`cmd3') (`cmd4')

	if `"`color2'"' != "" {
		color_add 3 1 `"Color `color2' is `type' "`rgb2'""'
		local cmd1 ///
			sc y x in 6, ///
			ms(S) mcolor(`color2') msize(10) ///
			mlabel(s) mlabcolor(`color2') mlabgap(2) mlabsize(4)

		color_add 4 1 ""
		color_add 4 1.2 ""
		color_add 4 2 ""
		color_add 4 2.2 ""
		local cmd2 sc y x in 7, ms(O) mcolor(`color2')
		local cmd3 line y x in 8/9, clc(`color2')
		local cmd4 sc y x in 10, ms(Oh) mcolor(`color2')
		local cmdB (`cmd1') (`cmd2') (`cmd3') (`cmd4')
		local title "Color comparison"
	}
	else	local title "Color sample"

	capture twoway `cmdA' `cmdB', ///
		ysca(reverse) ysca(r(.5 4.5)) xsca(r(0.7 3.7)) ///
		ylab(none) xlab(none) ytitle("") xtitle("")    ///
		title("`title'") `scheme' legend(nodraw)

end

program color_add 
	args y x s 
	quietly {
		set obs `=_N+1'
		replace y = `y' in l 
		replace x = `x' in l 
		replace s = `"`s'"' in l
	}
end


program color_load , sclass
	tempname mycolor
	.`mycolor' = .color.new , style(`0')
	sret local rgb "`.`mycolor'.setting'"
	sret local color `""`0'""'
end

program rgb2cmyk
	args target colon r g b

	local c = 255 - `r'
	local m = 255 - `g'
	local y = 255 - `b'

	local k = min(`c', `m', `y')
	c_local `target' "`=`c'-`k'' `=`m'-`k'' `=`y'-`k'' `k'"

/*
	local r = cond(`c'+`k' < 255, 255 - (`c'+`k'), 0)
	local g = cond(`m'+`k' < 255, 255 - (`m'+`k'), 0)
	local b = cond(`y'+`k' < 255, 255 - (`y'+`k'), 0)
*/
end

/*
program color_load, sclass
	args color g b nothing

	sret clear

	if "`nothing'"!="" {
		di as err `"`0':  invalid {it:colorstyle}"'
		exit 198
	}

	if "`b'" != "" {
		capture assert `color'>=0 & `color'<=255
		local rc1 = _rc 
		capture assert `g'>=0 & `g'<=255
		local rc2 = _rc 
		capture assert `b'>=0 & `b'<=255
		if _rc | `rc1' | `rc2' {
			di as err `"`0':  invalid RGB value"'
			exit 198
		}
		sret local rgb "`color' `g' `b'"
		sret local color `""`color' `g' `b'""'
		exit
	}
	if "`g'" != "" {
		di as err `"`0':  invalid RGB value"'
		exit 198
	}

	gettoken basecolor basemod : color, parse(" *")

	capture findfile color-`basecolor'.style
	if _rc { 
		di as err "{p 0 4 4}"
		di as err "color `basecolor' not found{break}"
		di as err "Type -graph query colorstyle-"
		di as err "for a list of colornames."
		di as err "{p_end}"
		exit 111
	}
	local fn `"`r(fn)'"'

	tempname hdl
	file open `hdl' using `"`fn'"', read text
	file read `hdl' line
	while r(eof)==0 {
		tokenize `"`line'"'
		if "`1'"=="set" & "`2'"=="rgb" {
			sret local rgb "`3'`basemod'"
			sret local color "`color'"
			file close `hdl'
			exit
		}
		file read `hdl' line
	}
	file close `hdl'
	di as err "{p}"
	di as err `"file "`fn'" does not contain "set rgb""'
	di as err "{p_end}"
	exit 610
end
*/
