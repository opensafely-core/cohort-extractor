*! version 1.1.0   05jul2017
program gr_query
	version 8

	gettoken cma : 0, parse(", ")
	if "`cma'"=="," {
		syntax [, SCHemes SYSTEM]
		if "`schemes'"!="" {
			QueryScheme
			exit
		}
	}
	else	gettoken type 0 : 0, parse(", ")
	syntax [, SYSTEM]

	if "`system'"=="" {
		local synonyms `" "addedline gridline" "by bygraph" "compassdir compass2dir" "markerlabel label" "markersize symbolsize" "textsize gsize" "justification horizontal" "orientation tb_orient" "alignment vertical_textstyle" "p series" "valign vertical" "vposition above_below" "clockpos clockdir" "ringpos gridringstyle" "linealignment alignstroke""'

		local delete "above_below alignstroke axis axisstyleold bar barlabel barlabelpos bygraph bygraphstyleg1 clockdir compass1dir compass2dir compass3dir dottype fillpattern graph gridline gsize horizontal influenced_yesno inout intensity label medtype ord piegraph pielabel pietype_g plotregion relative_posn relsize series shade star sunflower symbolsize tickset tb_orient this tickposition transform valign vertical vertical_text vposition xyaddviews yxbartype_g y2xtype yxtype yxyxtype yesno"
	}

	if "`type'"=="" {
		QueryTypes `"`synonyms'"' "`delete'"
	}
	else	QueryStyles `"`synonyms'"' `type'
end


program QueryScheme
	stypop populate __STYLES scheme .scheme
	di as txt 
	di as txt "Available schemes are"
	di as txt 
	forvalues i = 1/`.__STYLES.scheme.arrnels' {
		local el `.__STYLES.scheme[`i']'
		capture find_hlp_file scheme_`el'
		if _rc==0 {
			di as res _col(5) "`el'" ///
	_col(20) as txt "see help {help scheme_`el'##|_new:scheme_`el'}"
		}
		else	di as res _col(5) "`el'"
	}
end


program QueryTypes
	args synonyms delete

	local path `"`c(adopath)'"'
	local subdirs ///
"style _ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"

	gettoken d path : path, parse(" ;")
	while `"`d'"' != "" {
		if `"`d'"' != ";" {
			local d : sysdir `"`d'"'

			capture local x : dir "`d'" files "*.style"
			if _rc==0 {
				local x : list clean x
				GetType x : `x'
				local list : list list | x
			}

			foreach l of local subdirs {
				capture local x : dir "`d'`l'" files "*.style"
				if _rc==0 {
					local x : list clean x
					GetType x : `x'
					local list : list list | x
				}
			}
		}
		gettoken d path : path, parse(" ;")
	}
	local list : list uniq list

	if `"`synonyms'"' != "" { 
		local toadd
		foreach el of local synonyms {
			local toadd `toadd' `:word 1 of `el''
		}
		local list : list list | toadd
	}
	if `"`delete'"' != "" {
		local list : list list - delete
	}

	local list : list sort list

	local last "a"
	foreach el of local list {
		if bsubstr("`el'",1,1)!="`last'" {
			local list2 `"`list2' " ""'
			local last = bsubstr("`el'",1,1)
		}
		local list2 `"`list2' `el'style"'
	}
	local list `list2'


	di _n as txt "Styles used in {cmd:graph} options are{it}"
	di as txt
	DisplayInCols res 4 0 0 `list'

	local n : word count `list'
	if `n' > 1 {
		local first "second"
		local x : word 2 of `list'
	}
	else {
		local first "first"
		local x : word 1 of `list'
	}

	di as txt
	di as txt "{p 4 4 2}"
	di as txt "{rm}To find out more about a style, type"
	di as txt "-{cmd:graph query {txt:<}{it:stylename}{txt:>}}-;"
	di as txt "for instance,"
	di as txt "-{cmd:graph query `x'}-."
	di as txt `"(You may omit the "style" on the end.)"'
	di as txt "{p_end}"
end

program QueryStyles
	args synonyms origtype 

	if bsubstr("`origtype'", -5, 5) == "style" {
		local origtype = bsubstr("`origtype'", 1, length("`origtype'")-5)
	}
	Synonym type : `origtype' `synonyms'
	if bsubstr("`type'", -5, 5) == "style" {
		local type = bsubstr("`type'", 1, length("`type'")-5)
	}

	GetStyles list : `type'
	if "`list'"=="" {
		GetStyles list : `type'style
		if "`list'"=="" {
noi di in red "capture which `type'style.class"
			capture which `type'style.class
			if _rc {
			    di as err "{p 0 4 2}"
			    di as err "there is no type `origtype'"
			    di as err "and thus no styles for it{break}"
			    di as err "type -graph query- for a list of types"
			    di as err "{p_end}"
			    exit 111
			}
			local no_named 1
		}
	}
	capture AddToList_`type' list2
	if _rc==0 { 
		local list : list list | list2
		local list : list sort list
	}

	if 0`no_named' {
	      di _n as res "{it:`origtype'style}" as txt " has no named styles"
	}
	else {
		di _n as res "{it:`origtype'style}" as txt " may be" _n
		DisplayInCols res 4 0 0 `list'
	}

	capture find_hlp_file `origtype'style
	if _rc==0 {
		di as txt 
		di as txt "{p 4 4 2}"
		di as txt "For information on {it:`origtype'style} and how"
		di as txt "to use it, see help {it:{help `origtype'style##|_new:`origtype'style}}."
		di as txt "{p_end}"
	}
end


program GetStyles
	args dest colon type

	local l : adosubdir `type'.style

	local path `"`c(adopath)'"'
	gettoken d path : path, parse(" ;")
	while `"`d'"' != "" {
		if `"`d'"' != ";" {
			local d : sysdir `"`d'"'

			capture local x : dir "`d'" files "`type'-*.style"
			if _rc==0 {
				local x : list clean x
				GetStyle x : `x'
				local list : list list | x
			}
			capture local x : dir "`d'`l'" files "`type'-*.style"
			if _rc==0 {
				local x : list clean x
				GetStyle x : `x'
				local list : list list | x
			}
		}
		gettoken d path : path, parse(" ;")
	}
	local list : list uniq list
	c_local `dest' : list sort list
end


program GetType 
	gettoken d     0 : 0
	gettoken colon 0 : 0

	foreach el of local 0 {
		local l = index("`el'", "-")
		if `l' {
			local x = bsubstr("`el'", 1, `l'-1)
			if bsubstr("`x'", -5, 5)=="style" {
				local x = bsubstr("`x'", 1, length("`x'")-5)
			}
			local list `list' `x'
		}
	}
	c_local `d' : list uniq list
end

program GetStyle
	gettoken d     0 : 0
	gettoken colon 0 : 0

	foreach el of local 0 {
		local l = index("`el'", "-")
		if `l' {
			local x = bsubstr("`el'", `l'+1, .)
			local x = bsubstr("`x'", 1, index("`x'",".style")-1)

						// ignore p1 ... p15<xyz>
			if bsubstr("`x'",1,1) != "p" ||			///
			   bsubstr("`x'",2,1) <  "0" || bsubstr("`x'",2,1) > "9" {
				local list `list' `x'
			}
		}
	}
	c_local `d' : list uniq list
end


program Synonym
	gettoken d     0 : 0
	gettoken colon 0 : 0
	gettoken type  0 : 0

	foreach el of local 0 {
		if "`type'" == "`:word 1 of `el''" {
			local type "`:word 2 of `el''"
			continue, break
		}
	}
	c_local `d' "`type'"
end




program DisplayInCols /* sty #indent #pad #wid <list>*/
	gettoken sty    0 : 0
	gettoken indent 0 : 0
	gettoken pad    0 : 0
	gettoken wid	0 : 0

	local indent = cond(`indent'==. | `indent'<0, 0, `indent')
	local pad    = cond(`pad'==. | `pad'<1, 2, `pad')
	local wid    = cond(`wid'==. | `wid'<0, 0, `wid')
	
	local n : list sizeof 0
	if `n'==0 { 
		exit
	}

	foreach x of local 0 {
		local wid = max(`wid', length(`"`x'"'))
	}

	local wid = `wid' + `pad'
	local cols = int((`c(linesize)'+1-`indent')/`wid')

	if `cols' < 2 { 
		if `indent' {
			local col "column(`=`indent'+1)"
		}
		foreach x of local 0 {
			di as `sty' `col' `"`x'"'
		}
		exit
	}
	local lines = `n'/`cols'
	local lines = int(cond(`lines'>int(`lines'), `lines'+1, `lines'))

	/* 
	     1        lines+1      2*lines+1     ...  cols*lines+1
             2        lines+2      2*lines+2     ...  cols*lines+2
             3        lines+3      2*lines+3     ...  cols*lines+3
             ...      ...          ...           ...               ...
             lines    lines+lines  2*lines+lines ...  cols*lines+lines

             1        wid
	*/


	* di "n=`n' cols=`cols' lines=`lines'"
	forvalues i=1(1)`lines' {
		local top = min((`cols')*`lines'+`i', `n')
		local col = `indent' + 1 
		* di "`i'(`lines')`top'"
		forvalues j=`i'(`lines')`top' {
			local x : word `j' of `0'
			di as `sty' _column(`col') `"`x'"' _c
			local col = `col' + `wid'
		}
		di as `sty'
	}
end


program GetFiles
	args result colon suffix
	local subdirs "style _ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"

	local path `"`c(adopath)'"'
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
end


program AddToList_connect
	c_local `1' "stepstair"
end



exit
