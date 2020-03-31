*! version 1.0.2  09sep2019
program diflogistic, rclass sortpreserve
	version 14
	syntax [varlist(numeric default=none)] [if] [in] [fw] , [ ///
		GRoup(varname numeric) 			///
		total(varname numeric)			///
		items(varlist numeric) 			///
		Format(string)				///  NOT DOCUMENTED
		SFormat(string)				///
		PFormat(string)				///
		maxp(string asis)			///
		* ]

	// replay the results
	if missing("`varlist'") {
		cap noi Replay `0'
		local rc = _rc
		return add
		exit `rc'
	}
	
	if !missing(`"`options'"') {
		di as err `"option {bf:`options'} not allowed"'
		exit 198
	}
	if missing("`group'") {
		di "as err option {bf:group()} required"
		exit 198
	}
	
	// check formats
	local glfmt = `"`format'"' != ""
	if `glfmt' {
		confirm numeric format `format'
		mata: __confirm_irtdif_format("`format'","format")
	}
	
	if missing(`"`sformat'"') {
		if `glfmt' local sformat `format'
		else local sformat %9.2f
	}
	confirm numeric format `sformat'
	mata: __confirm_irtdif_format("`sformat'","sformat")
		
	if missing(`"`pformat'"') {
		if `glfmt' local pformat `format'
		else local pformat %9.4f
	}
	confirm numeric format `pformat'	
	mata: __confirm_irtdif_format("`pformat'","pformat")
	
	if !missing("`maxp'") {
		capture confirm number `maxp'
		if _rc {
			di as err "{bf:maxp()} must be a number in (0,1)"
			exit 198
		}
		if `maxp' <= 0 | `maxp' >= 1 {
			di as err "{bf:maxp()} must be in (0,1)"
			exit 198
		}
	}
	
	marksample touse
	
	_dif_check01 `varlist', touse(`touse') name(diflogistic)
	_dif_check01 `items', touse(`touse') name(diflogistic)
	
	if !missing("`items'") {
		local in : list items in varlist
		if !`in' {
di as err "some items in {bf:items()} not present in varlist"
exit 198
		}
	}
	else local items `varlist'
	
	capture _dif_check01 `group', touse(`touse') name(diflogistic)
	if _rc {
		di as err "variable {bf:`group'} must be coded 0, 1, or missing"
		exit 198
	}
	
	local n_items : list sizeof varlist
	local k_items : list sizeof items
	
	tempvar score
	if !missing("`total'") {
		qui gen `score' = `total' if `touse'
	}
	else {
		qui egen `score' = rowtotal(`varlist') if `touse'
		qui replace `touse' = 0 if `score'==0 | `score'==`n_items'
	}
	
	if !missing("`weight'") {
		local wgt [`weight'`exp']
	}
	
	qui sort `score'
	qui levelsof `score' if `touse', local(sc_k)
	local h : list sizeof sc_k
	tempname m r c omt sigma n_level out
	
	mat `out' = J(`k_items',4,.)
	mat `n_level' = J(`k_items',1,0)
	
	local i 0
	
	tempname full nudif udif
	
	foreach v of local items {
		local ++i
		
		// full model
		capture logit `v' c.`score'##i.`group' `wgt'
		if _rc {
			continue
		}
		mat `n_level'[`i',1] 	= `e(N)'
		est store `full'
		// model for nonuniform dif
		qui logit `v' c.`score' i.`group' `wgt'
		est store `nudif'
		// model for uniform dif
		qui logit `v' c.`score' `wgt'
		est store `udif'
		
		qui lrtest `full' `nudif', force	
		mat `out'[`i',1] 	= `r(chi2)'
		mat `out'[`i',2]	= `r(p)'
			
		qui lrtest `nudif' `udif', force		
		mat `out'[`i',3] 	= `r(chi2)'
		mat `out'[`i',4]	= `r(p)'
	}
	
	mata: __di_irtdif_logistic()
	
	mat colnames `out' = Chi2 Prob. Chi2 Prob.
	mat rownames `out' = `items'

	return matrix dif 	= `out'
	return matrix _N	= `n_level'
	
	return local wtype	"`weight'"
	return local wexp	"`exp'"
	return local total	"`total'"
	return local group	"`group'"
	return local items	"`varlist'"
	return local cmdline	"diflogistic `0'"
	return local cmd 	"diflogistic"
	
end

program Replay
	syntax [if] [in] [fw] , [ ///
		GRoup(varname numeric) 			///
		listwise				///
		total(varname numeric)			///
		items(varlist numeric) 			///
		Format(string)				///
		SFormat(string)				///
		PFormat(string)				///
		maxp(string asis)			///
		* ]

	if "`r(cmd)'" != "diflogistic" {
		di as err "last estimates not found"
		exit 301
	}
	
	// check formats
	local glfmt = `"`format'"' != ""
	if `glfmt' {
		confirm numeric format `format'
		mata: __confirm_irtdif_format("`format'","format")
	}
	
	if missing(`"`sformat'"') {
		if `glfmt' local sformat `format'
		else local sformat %9.2f
	}
	confirm numeric format `sformat'
	mata: __confirm_irtdif_format("`sformat'","sformat")
		
	if missing(`"`pformat'"') {
		if `glfmt' local pformat `format'
		else local pformat %9.4f
	}
	confirm numeric format `pformat'	
	mata: __confirm_irtdif_format("`pformat'","pformat")
	
	if !missing("`maxp'") {
		capture confirm number `maxp'
		if _rc {
			di as err "{bf:maxp()} must be a number in (0,1)"
			exit 198
		}
		if `maxp' <= 0 | `maxp' >= 1 {
			di as err "{bf:maxp()} must be in (0,1)"
			exit 198
		}
	}
	
	if !missing(`"`if'"') {
		di as err "if not allowed on replay"
		exit 198
	}
	if !missing(`"`in'"') {
		di as err "in range not allowed on replay"
		exit 198
	}
	if !missing(`"`weight'"') {
		di as err "weight not allowed on replay"
		exit 198
	}
	if !missing(`"`group'"') {
		di as err "option {bf:group()} not allowed on replay"
		exit 198
	}
	if !missing(`"`listwise'"') {
		di as err "option {bf:listwise} not allowed on replay"
		exit 198
	}
	if !missing(`"`items'"') {
		di as err "option {bf:items()} not allowed on replay"
		exit 198
	}
	if !missing(`"`total'"') {
		di as err "option {bf:total()} not allowed on replay"
		exit 198
	}
	if !missing(`"`options'"') {
		di as err `"option {bf:`options'} not allowed"'
		exit 198
	}
	tempname out
	capture mat `out' = r(dif)
	if _rc {
		di as err "matrix {bf:r(dif)} not found"
		exit 198
	}
	local items `r(items)'
	if missing("`items'") {
		di as err "{bf:r(items)} not found"
		exit 198
	}
	mata: __di_irtdif_logistic()
end

version 14
mata:
mata set matastrict on

void __confirm_irtdif_format(string scalar fmt, opt) {

// we need to check format at the beginning, otherwise ado code will
// calculate statistics, which may take some time, and then we will error out 
// on display

	string scalar ok_fmt, my_fmt
	string vector tok
	real scalar ok, x, y, f_w
		
	// Allowed numeric formats at g, f, e.  Max width is 9.

	ok_fmt = "g","f","e"
	
	// width for numerical columns
	if ( substr(fmt,1,1) != "%" ) {
		errprintf("invalid {bf:%s()}\n",opt)
		exit(198)
	}
	if ( substr(fmt,-1,1) == "c" ) {
		my_fmt = substr(fmt,-2,1)
	}
	else my_fmt = substr(fmt,-1,1)
	ok = sum( ok_fmt :== my_fmt )
	if (!ok) {
		errprintf("invalid {bf:%s();}\n",opt)
		errprintf("allowed numerical format is one of e, f, g\n")
		exit(198)
	}

	tok = tokens(fmt,", .")
	f_w = strtoreal(substr(tok[1],2,.))
	
	if (f_w > 9) {
		errprintf("invalid {bf:%s()};\n",opt)
		errprintf("width must be <= 9\n")
		exit(198)
	}
	
	// check format x.y, disallow 9.8
	x = abs(f_w)
	y = strtoreal(substr(tok[3],1,1))
	if (x==9 & y==8) {
		errprintf("invalid {bf:%s()};\n",opt)
		errprintf("widest allowed format is 9.7\n")
		exit(198)
	}
}

void __di_irtdif_logistic() {

	string scalar text, text0, itm_fmt, ttl_fmt, pfmt, sfmt, pp
	string vector items
	real scalar i, i_w
	real scalar pr, use_pr
	real vector values, todisplay
	real matrix res
	class _tab scalar Tab
	
	pfmt = st_local("pformat")
	sfmt = st_local("sformat")
	use_pr = st_local("maxp") != ""
	items = tokens(st_local("items"))
	res = st_matrix(st_local("out"))

// The output table has a fixed format with the exception of the Item column
// whose width can be between 6 and 13 characters.
// The remaining columns have a width of 9 characters with 4 spaces between
// the numbers if displayed as %9.7f.

	// width of Item column
	i_w = max( (udstrlen(items),5) )
	i_w = min((i_w,12))
	
	todisplay = J(rows(res),1,1)
	if (use_pr) {
		pp = st_local("maxp")
		pr = strtoreal(pp)
		for (i=1; i<=rows(res); i++) {
			if (res[i,2] > pr) {
				res[i,1] = .
				res[i,2] = .
			}
			if (res[i,4] > pr | res[i,2] !=.) {
				res[i,3] = .
				res[i,4] = .
			}
			if (res[i,2]==. & res[i,4]==.) todisplay[i] = 0
		}
	}

	if (sum(todisplay)==0) {
printf("\n{txt}No items to show; all p-values greater than %s\n",pp)
exit(0)
	}
	
	// print table
	
	printf("\n{txt}Logistic Regression DIF Analysis\n\n")

	Tab.init(5)
	Tab.set_lmargin(0)
	Tab.set_vbar((0,1,0,1,0,0))
	Tab.set_width((i_w+1,10,13,10,12))
	Tab.set_diwidth((.,9,9,9,9))
	
	text	= J(1,5,"")
	
	itm_fmt = sprintf("%%%gs",i_w)
	
	__getfmt(sfmt)
	__getfmt(pfmt)
		
	Tab.set_format_string((itm_fmt,"","","",""))
	Tab.set_format_number(("",sfmt,pfmt,sfmt,pfmt))
	
	text0 = J(1,5,"")
	text0[1] = ""
	text0[2] = "      Nonuniform"
	text0[3] = ""
	text0[4] = "      Uniform"
	text0[5] = ""
	
	ttl_fmt = J(1,5,"")
	ttl_fmt[2] = "%10s"
	ttl_fmt[3] = "%12s"
	ttl_fmt[4] = "%10s"
	ttl_fmt[5] = "%12s"
	Tab.set_format_title(ttl_fmt)
	
	Tab.titles(text0)
	
	text = J(1,5,"")
	text[1] = "Item"
	text[2] = "Chi2"
	text[3] = "Prob."
	text[4] = "Chi2"
	text[5] = "Prob."
	
	ttl_fmt = J(1,5,"")
	ttl_fmt[2] = "%10s"
	ttl_fmt[3] = "%12s"
	ttl_fmt[4] = "%10s"
	ttl_fmt[5] = "%12s"
	Tab.set_format_title(ttl_fmt)
	
	Tab.titles(text)
	
	Tab.sep()
	
	for (i=1; i<=rows(res); i++) {
		if (todisplay[i]) {
			values = 0,res[i,.]
			text = J(1,5,"")
			text[1] = abbrev(items[i],12)
			Tab.row(values,text)
		}
	}

	Tab.sep("bottom")
}

end

exit

format() is global;
sformat() and pformat() take priority over format()

