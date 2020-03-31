*! version 2.0.4  13feb2015
program define cluster_tree_8, sortpreserve
	version 7, missing

	local orig0 `"`0'"'
	gettoken clname 0 : 0, parse(" ,")
	if "`clname'" == "," | "`clname'" == "if" | "`clname'" == "in" {
		local clname
		local 0 `"`orig0'"'
	}

	cluster query
	local clnames `r(names)'
	if `"`clname'"' == "" { /* if no name -- take latest cluster anal. */
		local clname : word 1 of `clnames'
	}

	cluster query `clname'
	local clname `r(name)'

	/* if a treeprogram is specified within -clname- call that routine */
	local i 1
	while `"`r(o`i'_tag)'"' != "" {
		if `"`r(o`i'_tag)'"' == "treeprogram" {
			`r(o`i'_val)' `orig0'
			exit
		}
		local i = `i' + 1
	}

	/* otherwise we use the default tree routine */
	if "`r(type)'" != "hierarchical" {
		di as err "{p}dendrograms allowed only after hierarchical"
		di as err "clustering{p_end}"
		exit 198
	}

	local maxleaflimit 100	/* max number of leaves that will be allowed */

	local idvar `r(idvar)'
	local ordvar `r(ordervar)'
	local hgtvar `r(heightvar)'

	if "`hgtvar'" == "" {
		di as err "currently can't handle dendrogram reversals"
		exit 198
	}

	local i 1
	while "`r(o`i'_tag)'" != "" {
		if "`r(o`i'_tag)'" == "range" {
			local range `r(o`i'_val)'
			continue, break
		}
		local i = `i' + 1
	}
	if "`range'" == "" {
		local simval 0
	}
	else {
		local simval : word 1 of `range'
	}
	local rsim `r(similarity)'
	local rdis `r(dissimilarity)'

	syntax [if] [in] [, LAbels(varname) YLAbel1(numlist) YLAbel /*
		*/ YTick(numlist) RLAbel1(numlist) RLAbel RTick(numlist) /*
		*/ VERTLabels noAXis LABCutn CUTValue(numlist max=1) /*
		*/ CUTNumber(numlist max=1 >1 <=`maxleaflimit' int) * ]

	if "`cutvalue'" != "" & "`cutnumber'" != "" {
		di as err "{p}only one of cutvalue() and cutnumber() may be"
		di as err "specified{p_end}"
		exit 198
	}

	if "`labcutn'" != "" & "`cutvalue'`cutnumber'" == "" {
		di as err /*
		 */ "{p}cutvalue() or cutnumber() required with labcutn{p_end}"
		exit 198
	}

	if "`ylabel1'" != "" & "`ylabel'" != "" {
		di as err /*
		 */ "{p}ylabel and ylabel() cannot both be specified{p_end}"
		exit 198
	}

	if "`rlabel1'" != "" & "`rlabel'" != "" {
		di as err /*
		 */ "{p}rlabel and rlabel() cannot both be specified{p_end}"
		exit 198
	}

	if "`ylabel1'`ylabel'`ytick'`rlabel1'`rlabel'`rtick'" != "" & /*
						*/ "`axis'" == "noaxis" {
		di as err "{p}label and tick options not allowed with noaxis"
		di as err "option{p_end}"
		exit 198
	}

	tempvar newid
	if "`cutvalue'`cutnumber'" != "" {
		/* We are to trim the lower part of the tree before display */
		if "`if'`in'" != "" {
			di as err "{p}cutvalue() and cutnumber() not allowed"
			di as err "with if or in{p_end}"
			exit 198
		}

		tempvar notuse
		qui gen byte `notuse' = 1

		if "`cutnumber'" != "" {
			qui replace `notuse' = 0 if `idvar' <  . & `hgtvar' >= .
			local cutnm1 = `cutnumber' - 1
			tempvar tmpsort
			qui gen byte `tmpsort' = `idvar' >= .
			if "`rsim'" != "" {
				sort `tmpsort' `hgtvar'
				qui drop `tmpsort'
			}
			else {
				tempvar tmpsort2
				qui gen double `tmpsort2' = -`hgtvar'
				sort `tmpsort' `tmpsort2'
				qui drop `tmpsort2' `tmpsort'
			}
			if `hgtvar'[`cutnm1'] == `hgtvar'[`cutnumber'] {
				di as err "{p}cannot cut exactly `cutnumber'"
				di as err "groups due to ties in the"
				di as err "dendrogram{p_end}"
				exit 198
			}
			qui replace `notuse' = 0 in 1/`cutnm1'
		}
		else { /* cutvalue */
			if "`rsim'" != "" {
				qui replace `notuse' = 0 if `idvar' < . & /*
					*/ (`hgtvar'<=`cutvalue' | `hgtvar'>=.)
			}
			else {
				qui replace `notuse' = 0 if `idvar' < . & /*
					*/ `hgtvar'>=`cutvalue'
			}
			qui count if `notuse' == 0
			if r(N) <= 1 {
				di as err "{p}nothing to display; all tree" /*
					*/ " divisions fall below " /*
					*/ "cutvalue(`cutvalue'){p_end}"
				exit 198
			}
		}

		sort `notuse' `idvar'
		qui gen `c(obs_t)' `newid' = _n if `notuse'==0

		if "`labcutn'" != "" {
			tempvar tmpcnt2 xlabvar2
			quietly {
				gen long `tmpcnt2' = .
				replace `tmpcnt2' = `idvar' - `idvar'[_n-1] /*
						*/ in 2/l if `newid' < .
				replace `tmpcnt2' = `idvar' in 1
				gen str1 `xlabvar2' = ""
				if "`vertlabels'" != "" {
					replace `xlabvar2' = "N" + /*
						*/ string(`tmpcnt2') /*
						*/ if `newid' < .
				}
				else {
					replace `xlabvar2' = "N=" + /*
						*/ string(`tmpcnt2') /*
						*/ if `newid' < .
				}
				drop `tmpcnt2'
			}
			local xlab2opt "xlabel2(`xlabvar2')"
		}

		local oldid `idvar'
		local idvar `newid'
		qui drop `notuse'

		tempvar xlabvar
		if "`labels'" != "" {
			local xvtype : type `labels'

 			sort `oldid'
			qui gen `xvtype' `xlabvar' = `labels'[`ordvar'] /*
							*/ if ~missing(`idvar')
 			sort `idvar'
		}
		else {
			qui gen str1 `xlabvar' = ""
			qui replace `xlabvar' = "G"+string(`idvar') /*
							*/ if `idvar' < .
		}
	}
	else { /* no cut options */
		marksample touse
		/* As well as -if- & -in- we restrict to obs. from cl. anal. */
		markout `touse' `idvar'
		qui count if `touse'
		if `r(N)' < 1 {
			di as err "{p}no observations that meet your selection"
			di as err "criteria and are part of `clname'{p_end}"
			exit 2000
		}
		sort `idvar'
		/* The [`ordvar'] on `touse' in the line below is crucial */
		qui gen long `newid' = `idvar' if `touse'[`ordvar']
		qui compress `newid'
		local idvar `newid'

		if "`labels'" != "" {
			tempvar xlabvar
			local xvtype : type `labels'
			qui gen `xvtype' `xlabvar' = `labels'[`ordvar']
		}
		else {
			local xlabvar `ordvar'
		}
	}

	/* impose a limit on the number of leaves allowed */
	qui count if `idvar' < .
	if `r(N)' > `maxleaflimit' {
		if "`cutvalue'`cutnumber'" != "" {
			di as err "{p}too many leaves; use a more restrictive"
			di as err "value for cutvalue() or use the cutnumber()"
			di as err "option{p_end}"
		}
		else {
			di as err "{p}too many leaves; consider using the"
			di as err "cutvalue() or cutnumber() options{p_end}"
		}
		exit 198
	}

	tempvar heightv
	local hvtype : type `hgtvar'
	if "`rsim'" != "" {
		/* swap the sense of the hgtvar to be like a dissimilarity */
		qui gen `hvtype' `heightv' = `simval'-`hgtvar'
		local meastitle `rsim' similarity measure
		local sign "-"  /* realh = simval - myh */
	}
	else if "`rdis'" != "" {
		qui gen `hvtype' `heightv' = `hgtvar' - `simval'
		local meastitle `rdis' dissimilarity measure
		local sign "+"  /* realh = simval + myh */
	}
	else {
		di as err "{p}`clname' does not have similarity or"
		di as err "dissimilarity measure set{p_end}"
		exit 198
	}
	local l2def "defaultl2(`meastitle')"
	local r2def "defaultr2(`meastitle')"

	/* Take care of ylabels and yticks */
	if "`ylabel'" != "" {
		/* make 5 yaxis labels and ticks that look reasonable */
		qui summ `heightv' if `idvar' < . , meanonly
		local maxy = r(max)
		local realmaxy = `simval' `sign' `maxy'
		local inc = abs(`simval' - `realmaxy')/4
		GetSigDigits `inc' 3
		local inc = `r(answer)'
		local ticks "0 `inc'"
		local aticklab = `simval' `sign' `inc'
		local ticklabs "`simval' `aticklab'"
		local atick = 2*`inc'
		local aticklab = `simval' `sign' 2*`inc'
		local ticks "`ticks' `atick'"
		local ticklabs "`ticklabs' `aticklab'"
		local atick = 3*`inc'
		local aticklab = `simval' `sign' 3*`inc'
		local ticks "`ticks' `atick'"
		local ticklabs "`ticklabs' `aticklab'"
		local atick = 4*`inc'
		local aticklab = `simval' `sign' 4*`inc'
		local ticks "ticks(`ticks' `atick')"
		local ticklabs "ticklabs(`ticklabs' `aticklab')"
	}
	else if "`ylabel1'" != "" {
		/* user has specified yaxis labels to use */
		foreach tck of local ylabel1 {
			if "`rsim'" != "" {
				local mytick = `simval' - `tck'
			}
			else {
				local mytick = `tck' - `simval'
			}
			local ticks `ticks' `mytick'
		}
		local ticks "ticks(`ticks')"
		local ticklabs "ticklabs(`ylabel1')"
	}
	else if ("`rlabel1'" == "" & "`rlabel'" == "" & "`rtick'" == "") | /*
							*/ "`ytick'" != "" {
		/* setup default tick marks  -- 5 ticks, end ticks numbered */
		qui summ `heightv' if `idvar' < . , meanonly
		local maxy = r(max)
		local ticks "ticks(0 `maxy')"
		local ticklabs = `simval' `sign' `maxy'
		local ticklabs "ticklabs(`simval' `ticklabs')"
		local extraticks = `maxy'/4
		local atick = `maxy'/2
		local extraticks "`extraticks' `atick'"
		local atick = `maxy'*3/4
		local extraticks "`extraticks' `atick'"
	}
	else {
		local l2def
	}

	if "`ytick'" != "" {
		/* user has specified extra yticks to use */
		foreach tck of local ytick {
			if "`rsim'" != "" {
				local mytick = `simval' - `tck'
			}
			else {
				local mytick = `tck' - `simval'
			}
			local extraticks `extraticks' `mytick'
		}
	}

	if "`extraticks'" != "" {
		local extraticks "extraticks(`extraticks')"
	}

	/* Take care of rlabels and rticks */
	if "`rlabel'" != "" {
		/* make 5 raxis labels and ticks that look reasonable */
		qui summ `heightv' if `idvar' < . , meanonly
		local maxy = r(max)
		local realmaxy = `simval' `sign' `maxy'
		local inc = abs(`simval' - `realmaxy')/4
		GetSigDigits `inc' 3
		local inc = `r(answer)'
		local rticks "0 `inc'"
		local aticklab = `simval' `sign' `inc'
		local rticklabs "`simval' `aticklab'"
		local atick = 2*`inc'
		local aticklab = `simval' `sign' 2*`inc'
		local rticks "`rticks' `atick'"
		local rticklabs "`rticklabs' `aticklab'"
		local atick = 3*`inc'
		local aticklab = `simval' `sign' 3*`inc'
		local rticks "`rticks' `atick'"
		local rticklabs "`rticklabs' `aticklab'"
		local atick = 4*`inc'
		local aticklab = `simval' `sign' 4*`inc'
		local rticks "rticks(`rticks' `atick')"
		local rticklabs "rticklabs(`rticklabs' `aticklab')"
	}
	else if "`rlabel1'" != "" {
		/* user has specified raxis labels to use */
		foreach tck of local rlabel1 {
			if "`rsim'" != "" {
				local mytick = `simval' - `tck'
			}
			else {
				local mytick = `tck' - `simval'
			}
			local rticks `rticks' `mytick'
		}
		local rticks "rticks(`rticks')"
		local rticklabs "rticklabs(`rlabel1')"
	}

	if "`rtick'" != "" {
		/* user has specified extra rticks to use */
		foreach tck of local rtick {
			if "`rsim'" != "" {
				local mytick = `simval' - `tck'
			}
			else {
				local mytick = `tck' - `simval'
			}
			local rextraticks `rextraticks' `mytick'
		}
	}
	if "`rextraticks'" != "" {
		local rextraticks "rextraticks(`rextraticks')"
	}

	if "`rlabel'`rlabel1'`rtick'" == "" {
		local r2def
	}

	capture noisily DoTree, id(`idvar') xlabel(`xlabvar') `xlab2opt' /*
		*/ hgt(`heightv') hgtlab(`hgtvar') `options' name(`clname') /*
		*/ `l2def' `r2def' `axis' `ticks' `ticklabs' `extraticks' /*
		*/ `rticks' `rticklabs' `rextraticks' `vertlabels'

	if _rc {
		exit _rc
	}
end


* DoTree --- draw a tree
*
program define DoTree
	syntax [, id(varname) xlabel(varname) xlabel2(varname) VERTLabels /*
		*/ hgt(varname) hgtlab(varname) SAving(string asis) TItle(str) /*
		*/ T1title(str) T2title(str) B1title(str) B2title(str) /*
		*/ L1title(str) L2title(str) R1title(str) R2title(str) /*
		*/ noAXis Gap(int 8) name(str) defaultl2(str) defaultr2(str) /*
		*/ ticks(numlist >= 0) ticklabs(numlist) /*
		*/ extraticks(numlist >= 0) rticks(numlist >= 0) /*
		*/ rticklabs(numlist) rextraticks(numlist >= 0) /*
		*/ scale(real 1.0) /*
		*/ bgcolor(numlist min=3 max=3 int >=0 <=255) /*
		*/ treecolor(numlist min=3 max=3 int >=0 <=255) /*
		*/ textcolor(numlist min=3 max=3 int >=0 <=255)  quick ]


*	local lbuf 20
	local lbuf 350
	local rbuf 20
*	local tbuf 20
	local tbuf 350
	local bbuf 20
	local mygaph 300
	local mygapv 300
	local adjusthgt = 265  /* adjusts base line title */
	local adjusttext = 610 /* adjusts right side title */
	local titletext = 150 /* adjust title2 text */
	local tickadj = 0
	local radj = 275

	if `gap' < 0 {
		di as err "{p}gap() must be positive integer{p_end}"
		exit 198
	}

	/* set the font size */
	local fontsize = `scale'*10

	/* set the background color */
	if "`bgcolor'" == "" {
		local bgcolor = "225 230 240"
	}
	local bgred   : word 1 of `bgcolor'
	local bggreen : word 2 of `bgcolor'
	local bgblue  : word 3 of `bgcolor'


	/* set the tree color */
	if "`treecolor'" == "" {
		local treecolor = "39 63 111"
	}
	local treered   : word 1 of `treecolor'
	local treegreen : word 2 of `treecolor'
	local treeblue  : word 3 of `treecolor'


	/* set the text color */
	if "`textcolor'" == "" {
		local textcolor "0 0 0"
	}
	local textred   : word 1 of `textcolor'
	local textgreen : word 2 of `textcolor'
	local textblue  : word 3 of `textcolor'

	/* default font size */
	local fonthigh 570
	local fontwide 290

	local tickwidth = int(`fontwide'*4/5)

	/* set the title font height and width */
	local font1high = round(`fonthigh'*1.25,1)
	local font1wide = round(`fontwide'*1.25,1)

	local font2high = round(`fonthigh'*1.125,1)
	local font2wide = round(`fontwide'*1.125,1)

	sort `id'
	local y `hgt'

	capture confirm numeric var `y'
	if _rc ~= 0 {
		di as err `"{p}`y' must be a numeric variable{p_end}"'
		exit _rc
	}

	tempvar atx
	qui gen double `atx' = _n - .5 if `id' < .

	qui count if `id' < .
	local maxx = r(N)
	tempname tmpmaxy
	qui summ `y' if `id' < . , meanonly
	scalar `tmpmaxy' = r(max)
	local maxy = r(max)

	if `maxx' > 1 {
		capture assert `id' == `id'[_n-1]+1 in 2/`maxx'
		if ((`y'[`maxx']<.) & (float(`y'[`maxx'])<float(`tmpmaxy'))) /*
								*/ | _rc {
			di as err "{p}selected observations do not create a"
			di as err "valid sub dendrogram{p_end}"
			exit 198
		}
	}

	/* extend range if any ticks above max */
	foreach tck of local ticks {
		if `maxy' < `tck' {
			local maxy = `tck'
		}
	}
	foreach tck of local rticks {
		if `maxy' < `tck' {
			local maxy = `tck'
		}
	}
	foreach tck of local extraticks {
		if `maxy' < `tck' {
			local maxy = `tck'
		}
	}
	foreach tck of local rextraticks {
		if `maxy' < `tck' {
			local maxy = `tck'
		}
	}

	if `"`title'"' != "" & `"`b1title'"' != "" {
		exit 198
	}
	local btitle "Dendrogram for `name' cluster analysis"


	/* gdi init */
	gdi init 6 4 `bgred' `bggreen' `bgblue'

	local midcol = int(`gdi(xmetric)' / 2)
	local midrow = int(`gdi(ymetric)' / 2)

    capture noisily {
	gdi yalpha= `gdi(ymetric)'
	gdi ybeta=-1
	gdi pen=1
	gdi penchange

	/* take care of titles */
	gdi textrgb = `textred' `textgreen' `textblue'
	gdi textsize=`fontsize'+(`fontsize'*(12/100))
	gdi textchange

	local they = `gdi(ymetric)'-`bbuf' - `adjusthgt'
	gdi textvalign= baseline
	gdi textangle=0
	gdi texthalign=center
	gdi textchange
	if `"`b1title'"' != "" {
		gdi text `midcol' `they' `b1title'
	}
	else if `"`title'"' != "" {
		gdi text `midcol' `they' `title'
	}
	else if `"`title'"' == "" && `"`b1title'"' == "" {
		gdi text `midcol' `they' `btitle'
	}
	local bbuf = `bbuf' + `font1high' + `mygapv'

	if `"`t1title'"' != "" {
		local they = `tbuf'+`font1high'
		gdi textvalign=baseline
		gdi textangle=0
		gdi texthalign=center
		gdi textchange
		gdi text `midcol' `they'  `t1title'
		local tbuf = `they' + `mygapv'
	}

	if `"`b2title'"' != "" {
		local they = `gdi(ymetric)'-`bbuf'
		gdi textvalign=baseline
		gdi textangle=0
		gdi texthalign=center
		gdi textchange
		gdi text `midcol' `they'  `b2title'
		local bbuf = `bbuf' + `font2high' + `mygapv'
	}
	if `"`t2title'"' != "" {
		local they = `tbuf' + `font2high'
		gdi textvalign=baseline
		gdi textangle=0
		gdi texthalign=center
		gdi textchange
		gdi text `midcol' `they'  `t2title'
		local tbuf = `they' + `mygapv'
		local tbuf = `tbuf' + `mygapv' /* looks better with extra gap */
	}

	if `"`l1title'"' != "" {
		local thex = `lbuf' + `font1wide'
		gdi textangle=90
		gdi textvalign=middle
		gdi texthalign=center
		gdi textchange
		gdi text  `thex' `midrow' `l1title'
		local lbuf = `thex' + `mygaph'
	}
	if `"`r1title'"' != "" {
		local thex = `gdi(xmetric)'-`rbuf'-`adjusttext'+`titletext'
		gdi textangle=90
		gdi textvalign=middle
		gdi texthalign=center
		gdi textchange
		gdi text `thex' `midrow' `r1title'
		local rbuf = `rbuf' + `font1wide' + `mygaph'
	}

	/* change to inner vertical title font size */
	gdi textsize=`fontsize'+ (`fontsize'*(12/100))
	gdi textchange

	if `"`l2title'"' != "" {
		local thex = `lbuf' + `font2wide'+ `titletext'
		gdi textangle=90
		gdi textvalign=middle
		gdi texthalign=center
		gdi textchange
		gdi text `thex' `midrow'  `l2title'
		local lbuf = `thex' + `mygaph'
	}
	else if "`defaultl2'" != "" {
		local thex = `lbuf' + `font2wide'
		gdi textangle=90
		gdi textvalign=middle
		gdi texthalign=center
		gdi textchange
		gdi text `thex' `midrow'  `defaultl2'
		local lbuf = `thex' + `mygaph'
	}
	if `"`r2title'"' != "" {
		local thex = `gdi(xmetric)'-`rbuf'-`adjusttext'
		gdi textangle=90
		gdi textvalign=middle
		gdi texthalign=center
		gdi textchange
		gdi text  `thex' `midrow'  `r2title'
		local rbuf = `rbuf' + `font2wide' + `mygaph'
		local rbuf = `rbuf' + `mygaph' /* looks better with extra gap */
	}
	else if "`defaultr2'" != "" {
		local thex = `gdi(xmetric)'-`rbuf'- `adjusttext'
		gdi textangle=90
		gdi textvalign=middle
		gdi texthalign=center
		gdi textchange
		gdi text `thex' `midrow'  `defaultr2'
		local rbuf = `rbuf' + `font1wide' + `mygaph'
		local rbuf = `rbuf' + `mygaph' /* looks better with extra gap */
	}

	/* change to regular font size */

	gdi textsize=`fontsize'
	gdi textchange

	/* take care of bottom and left axis */
	if "`vertlabels'" != "" {
		tempvar lchars
		capture confirm string var `xlabel'
		if _rc ~= 0 {
			qui gen byte `lchars' = length(string(`xlabel')) /*
							*/ if `atx' < .
		}
		else {
			qui gen byte `lchars' = ustrlen(`xlabel') if `atx' < .
		}
		qui summ `lchars', meanonly
		local vrows1 = r(max)
		local vrows = r(max)
		if "`xlabel2'" != "" {
			qui replace `lchars' = ustrlen(`xlabel2') if `atx' < .
			qui summ `lchars', meanonly
			local vrows2 = r(max)
			local vrows = `vrows' + `vrows2'
		}
		local bthey = `gdi(ymetric)'-`bbuf' - (`vrows'-1)*`fonthigh'
		if "`xlabel2'" != "" {
			local bthey = `bthey' - `mygapv'
		}
		local newbbuf = `bbuf' + `vrows'*`fonthigh' + `mygapv'
		if "`xlabel2'" != "" {
			local newbbuf = `newbbuf' + `mygapv'
		}
	}
	else { /* horizontal labels */
		local bthey = `gdi(ymetric)'-`bbuf'
		local newbbuf = `bbuf' + `fonthigh' + `mygapv'
		if "`xlabel2'" != "" {
			local bthey = `bthey' - `fonthigh' - `mygapv'
			local newbbuf = `newbbuf' + `fonthigh' + `mygapv'
		}
	}

	if "`axis'"' != "noaxis" {
		gdi linergb = `textred' `textgreen' `textblue'
		gdi penchange
		/* take care of left axis */
		if "`ticks'`extraticks'" != "" {
			/* setup and make call to do left axis */
			local lbuf2 = `lbuf' + `gap'*`fontwide' - `radj'
			local lbuf3 = `lbuf2' + `mygaph' + `fontwide' - `radj'
			XXlaxis `gap' `lbuf2' `lbuf3' `maxy' `tbuf' `newbbuf' /*
				*/ `tickwidth' "`ticks'" "`ticklabs'" /*
				*/ "`extraticks'" `fonthigh'
			local lbuf = `lbuf3' + `mygaph'
		}
		if "`rticks'`rextraticks'" != "" {
			/* setup and make call to do right axis */
			local rbuf2 = `rbuf' + `gap'*`fontwide'
			local rbuf3 = `rbuf2' + `mygaph' + `fontwide'
			XXraxis `gap' `rbuf3' `rbuf2' `maxy' `tbuf' `newbbuf' /*
				*/ `tickwidth' "`rticks'" "`rticklabs'" /*
				*/ "`rextraticks'" `fonthigh'
			local rbuf = `rbuf3' + `mygaph'
		}
		gdi linergb = `treered' `treegreen' `treeblue'
		gdi penchange
	}

	if "`axis'"' != "noaxis" {
		if "`rticks'`rextraticks'" != "" {
			local tmpbthey = `bthey'+ 310
		}
		else {
			local tmpbthey = `bthey'
		}

		XXbaxis `xlabel' "`xlabel2'" `maxx' `atx' `lbuf' /*
			*/ `rbuf' `tmpbthey' "`vrows1'" "`vrows2'" `fonthigh' `mygapv' 
	}
	else {
		/* take care of bottom "axis" labeling */
		XXbaxis `xlabel' "`xlabel2'" `maxx' `atx' `lbuf' `rbuf' `bthey' /*
			*/ "`vrows1'" "`vrows2'" `fonthigh' `mygapv'
	}
	local bbuf = `newbbuf'

	/* Now the tree drawing begins */
	gdi linergb = `treered' `treegreen' `treeblue'
	gdi penchange

	if "`quick'" != "" {
		QuickTree `maxx' `maxy' `atx' `y' `lbuf' `rbuf' `tbuf' `bbuf'
	}
	else {
		DrawTree `maxx' `maxy' `atx' `y' `lbuf' `rbuf' `tbuf' `bbuf'
	}
    } /* end: capture noisily */
	local rc = _rc
	gdi end

	if "`saving'" != "" {
		_asis save `saving'
	}

	exit `rc'
end


program define QuickTree
	args maxx maxy atx y lbuf rbuf tbuf bbuf

	XXLine `atx'[`maxx'] 0 `atx'[`maxx'] `maxy' /*
				*/ `maxx' `maxy' `lbuf' `rbuf' `tbuf' `bbuf'

	local maxxm1 = `maxx' - 1
	forvalues i = 1/`maxxm1' {
		XXLine `atx'[`i'] 0 `atx'[`i'] `y'[`i'] /*
				*/ `maxx' `maxy' `lbuf' `rbuf' `tbuf' `bbuf'
		local ip1 = `i' + 1
		forvalues j = `ip1'/`maxx' {
			if `y'[`j'] >= `y'[`i'] {
				local tox `j'
				continue, break
			}
		}
		XXLine `atx'[`i'] `y'[`i'] `atx'[`tox'] `y'[`i'] /*
				*/ `maxx' `maxy' `lbuf' `rbuf' `tbuf' `bbuf'
	}

end


program define DrawTree
	args maxx maxy atx y lbuf rbuf tbuf bbuf

	tempvar aty diff
	qui gen double `aty' = 0 if `atx' < .
	qui gen double `diff' = `y' if `atx' < .

	local change 1
	local dotcnt 0
	while `dotcnt' < `maxx' - 1 {
		local atj 0
		local i 1
		while `i' <= `maxx' {
			if `atx'[`i'] < . {
				if ((`atj' == 0)|(`y'[`i'] < `y'[`atj'])) & /*
							*/ (`diff'[`i'] != 0) {
					XXLine `atx'[`i'] `aty'[`i'] /*
						*/ `atx'[`i'] `y'[`i'] /*
						*/ `maxx' `maxy' /*
						*/ `lbuf' `rbuf' `tbuf' `bbuf'
					qui replace `aty' = `y'[`i'] in `i'
				}
				else if (`diff'[`i'] != 0) & /*
						*/ (`aty'[`i'] != `y'[`atj']) {
					XXLine `atx'[`i'] `aty'[`i'] /*
						*/ `atx'[`i'] `y'[`atj'] /*
						*/ `maxx' `maxy' /*
						*/ `lbuf' `rbuf' `tbuf' `bbuf'
					qui replace `aty' = `y'[`atj'] in `i'
				}
				local atj `i'
			}
			local i = `i' + 1
		}
		qui replace `diff' = `y' - `aty'
		local atj 0
		local i 1
		while `i' <= `maxx' {
			if `atx'[`i'] < . {
				if (`diff'[`i'] != 0) & (`diff'[`atj'] == 0) {
					XXLine `atx'[`atj'] `aty'[`atj'] /*
						*/ `atx'[`i'] `aty'[`i'] /*
						*/ `maxx' `maxy' /*
						*/ `lbuf' `rbuf' `tbuf' `bbuf'
					qui replace `atx' = (`atx'[`i'] + /*
						*/ `atx'[`atj'])/2 in `i'
					qui replace `atx' = . in `atj'
					local dotcnt = `dotcnt' + 1
				}
				local atj `i'
			}
			local i = `i' + 1
		}
	}
end


program define XXLine

	local x1 = `1'
	local y1 = `2'
	local x2 = `3'
	local y2 = `4'
	local maxx = `5'
	local maxy = `6'
	local lbuf = `7'	/* left buffer   */
	local rbuf = `8'	/* right buffer  */
	local tbuf = `9'	/* top buffer    */
	local bbuf = `10'	/* bottom buffer */
	local adj  = 140

	/* Stata -gdi- dimension limits

		upper left corner is  (0             , 0            )
		lower left corner is  (`gdi(ymetric)' , 0            )
		upper right corner is (0             , `gdi(xmetric)')
		lower right corner is (`gdi(ymetric)' , `gdi(xmetric)')

	   But we will only use from

		upper left corner  (`tbuf'              ,`lbuf'        )
		lower left corner  (`gdi(ymetric)'-`bbuf',`lbuf'        )
		upper right corner (`tbuf'              ,`gdi(xmetric)'-`rbuf')
		lower right corner (`gdi(ymetric)'-`bbuf',`gdi(xmetric)'-`rbuf')
	*/
	local nrows `gdi(ymetric)' /* Stata max row dimension */
	local ncols `gdi(xmetric)' /* Stata max column dimension */

	local r1 = `nrows'-`bbuf'-(`nrows'-`bbuf'-`tbuf')*`y1'/`maxy'
	local r2 = `nrows'-`bbuf'-(`nrows'-`bbuf'-`tbuf')*`y2'/`maxy'
	local c1 = `lbuf' + (`ncols'-`rbuf'-`lbuf')*`x1'/`maxx' - `adj'
	local c2 = `lbuf' + (`ncols'-`rbuf'-`lbuf')*`x2'/`maxx' - `adj'

	gdi line  `c1' `r1' `c2' `r2'
end


program define XXbaxis
	args xlab xlab2 maxx atx lbuf rbuf they vrows1 vrows2 fonthigh mygapv
	local nrows = `gdi(ymetric)' /* Stata max row dimension */
	local ncols = `gdi(xmetric)' /* Stata max column dimension */
	local adjusthgt = 265
	local adjx = 140

	tempvar rind cind
	qui gen double `cind' = `lbuf' + (`ncols'-`rbuf'-`lbuf')*`atx'/`maxx' /*
								*/ if `atx' < .
	capture confirm string var `xlab'
	if _rc ~= 0 {
		tempvar zzz
		qui gen str1 `zzz' = ""
		qui replace `zzz' = string(`xlab') if `atx' < .
	}
	else {
		local zzz `xlab'
	}
	gdi texthalign=center
	gdi textangle=0
	gdi textchange

	if "`vrows1'" != "" {
		tempvar azz
		qui gen str1 `azz' = ""
		qui gen int `rind' = .
		forvalues i = 1/`vrows1' {
			qui replace `rind' = `they' if `atx' < .
			qui replace `azz' = " " if `atx' < .
			qui replace `azz' = usubstr(`zzz',`i',1) /*
			*/ if usubstr(`zzz',`i',1) != "" & `atx' < .
			local N = _N
			forvalues j = 1/`N' {
				if (`atx'[`j'] < .) {
					local y = `rind'[`j'] - `adjusthgt'
					local x = `cind'[`j'] - `adjx'
					local str = `azz'[`j']
					gdi text `x' `y' `str'
				}
			}
			local they = `they' + `fonthigh'
		}
	}
	else {
		qui gen int `rind' = `they' if `atx' < .
		local N = _N
		forvalues j = 1/`N' {
			if (`atx'[`j'] < .) {
				local y = `rind'[`j']-`adjusthgt'
				local x = `cind'[`j'] - `adjx'
				local str = `zzz'[`j']
				gdi text `x' `y' `str'
			}
		}
		local they = `they' + `fonthigh'
	}

	if "`xlab2'" != "" {
		local zzz `xlab2'
		local they = `they' + `mygapv'
		if "`vrows2'" != "" {
			forvalues i = 1/`vrows2' {
				qui replace `rind' = `they' if `atx' < .
				qui replace `azz' = " " if `atx' < .
				qui replace `azz' = usubstr(`zzz',`i',1) if /*
					*/ usubstr(`zzz',`i',1) != "" & `atx'< .
				local N = _N
				forvalues j = 1/`N' {
					if (`atx'[`j'] < .) {
						local y=`rind'[`j']-`adjusthgt'
						local x = `cind'[`j'] - `adjx'
						local str = `azz'[`j']
						gdi text `x' `y' `str'
					}
				}
				local they = `they' + `fonthigh'
			}
		}
		else {
			qui replace `rind' = `they' if `atx' < .
			local N = _N
			forvalues j = 1/`N' {
				if (`atx'[`j'] < .) {
					local y = `rind'[`j']-`adjusthgt'
					local x = `cind'[`j'] - `adjx'
					local str = `zzz'[`j']
					gdi text `x' `y' `str'
				}
			}

		}
	}
end


program define XXlaxis
	args gap numspot axspot maxy tbuf bbuf tickw ticks ticklabs /*
		*/ extraticks fonthigh
	/* gap is the value of the gap() option (number of spaces the numbers
		are given to display in)
	   numspot is the rightmost place for the numbers
	   axspot is the place for the axis line and any ticks should
		extend to the left of that
	   maxy is the maximum y value in the graph
	   tbuf is the top title buffer area (need to stay out of)
	   bbuf is the bottom title buffer area (need to stay out of)
	   tickw is the width of a tick mark
	   ticks is a list of tick locations
	   ticklabs is a list of the real labels for the ticks
	   extraticks is a list of extra tick marks to make without labels
	   fonthigh is the height of the font (for centering tick labels)
	*/

	local nrows `gdi(ymetric)' /* Stata max row dimension */
	local tickbeg = `axspot' - `tickw'

	/* draw the line */
	local ybot = `nrows'-`bbuf'

	gdi line `axspot' `ybot' `axspot' `tbuf'

	/* take care of ticks with labels */
	local tickn : word count `ticks'
	gdi texthalign=right
	gdi textangle=0
	gdi textchange

	forvalues i = 1/`tickn' {
		local atick : word `i' of `ticks'
		local tmpy = `ybot' - (`ybot'-`tbuf')*`atick'/`maxy'
		gdi line `tickbeg' `tmpy' `axspot' `tmpy'
		local atlab : word `i' of `ticklabs'
		local atlab = string(`atlab',"%`gap'.0g")
		gdi text  `numspot' `tmpy'  `atlab'
	}

	/* take care of extra ticks */
	foreach atick of local extraticks {
		local tmpy = `ybot' - (`ybot'-`tbuf')*`atick'/`maxy'
		gdi line `tickbeg' `tmpy' `axspot' `tmpy'
	}
end


program define XXraxis
	args gap axspotd numspotd maxy tbuf bbuf tickw ticks ticklabs /*
		*/ extraticks fonthigh
	/* gap is the value of the gap() option (number of spaces the numbers
		are given to display in)
	   axspotd is the amount to come in from far left to place the axis
		line and any ticks should extend to the right of that
	   numspotd is the amount to come in from far left to place leftmost
		place for the numbers
	   maxy is the maximum y value in the graph
	   tbuf is the top title buffer area (need to stay out of)
	   bbuf is the bottom title buffer area (need to stay out of)
	   tickw is the width of a tick mark
	   ticks is a list of tick locations
	   ticklabs is a list of the real labels for the ticks
	   extraticks is a list of extra tick marks to make without labels
	   fonthigh is the height of the font (for centering tick labels)
	*/

	local nrows `gdi(ymetric)' /* Stata max row dimension */
	local ncols `gdi(xmetric)' /* Stata max col dimension */

	local axspot = `ncols' - `axspotd'
	local tickend = `ncols' - `axspotd' + `tickw'
	local numspot = `ncols' - `numspotd'

	/* draw the line */
	local ybot = `nrows'-`bbuf'
	gdi line `axspot' `ybot' `axspot' `tbuf'

	/* take care of ticks with labels */
	local tickn : word count `ticks'
	gdi textvalign= baseline
	gdi textangle=0
	gdi texthalign=left
	gdi textchange
	forvalues i = 1/`tickn' {
		local atick : word `i' of `ticks'
		local tmpy = `ybot' - (`ybot'-`tbuf')*`atick'/`maxy'
		gdi line `axspot' `tmpy' `tickend' `tmpy'
		local atlab : word `i' of `ticklabs'
		local atlab = string(`atlab',"%`gap'.0g")
		local tmpy = `tmpy' + `fonthigh'/2
		gdi text  `numspot' `tmpy'  `atlab'
	}

	/* take care of extra ticks */
	foreach atick of local extraticks {
		local tmpy = `ybot' - (`ybot'-`tbuf')*`atick'/`maxy'
		gdi line `axspot' `tmpy' `tickend' `tmpy'
	}
end


program define GetSigDigits, rclass
	/* returns -x- truncated (not rounded) to -digits- significant digits */
	args x digits

	if `x' == 0 {
		return local answer 0
	}
	else {
		local z = int(log10(abs(`x')))
		if `z' > 0 {
			local z = `z' + 1
		}
		local z = 10^(`z' - `digits')
		local z = int(`x'/`z')*`z'
		return local answer `z'
	}
end
