*! version 1.4.1  20mar2018
program matlist
	version 11

	if _caller() < 11 {
		matlist_10 `0'
		exit
	}
	syntax anything(id="matrix name or matrix expression" name=M) [, *]

	tempname m hold
	matrix `m' = `M'

	_return hold `hold'
	capture noisily MatList `m', `options'
	local rc = c(rc)
	_return restore `hold'
	exit `rc'
end

program MatList
	version 8
	#del ;
	syntax anything(id="matrix name or matrix expression" name=m)
	[,
	
	// options of matrix list
		TITle(str)                  // title to be displayed
		TINDent(numlist integer max=1 >=0)
		ROWtitle(str)               // column header for row names
		NAMes2(str)                 //		
		noNAMes                     // no row/column names
		COLEQONLY		    // show only column equation names 
		ROWEQONLY		    // show only row equation names 
		SHOWCOLEQ(str)              // how to deal with column eqns
		COLORCOLEQ(str)             // color for column equations   
		KEEPCOLEQ                   // keeps columns of eqn together
		ALIGNCOLNames(str)          // how column names are aligned
		noBlank                     // suppresses first blank line
		noHAlf                      // display all, even if symmetric
		noHeader                    // allowed, but silently ignored
		nodotz                      // display .z as blanks
		UNDERscore                  // convert _ to blanks in labels
		LINESIZE(numlist integer max=1 >=40 <=255) // linesize 
		
	// detailed formatting per column
		CSPec(str)                  // column specifications
		RSPec(str)                  // row specifications

	// format styles
		LINes(str)
		FORmat(str)
		TWidth(numlist integer max=1 >=5)
		LEFT(numlist integer max=1 >=0)
		RIGHT(numlist integer max=1 >=0)
		BORder
		BORder2(str)
		BOTTOMLine		    // undocumented

	// misc
		DEBUG                       // undocumented
		ROWEQASTXT		    // undocumented
	] ;
	#del cr

	if ("`roweqastxt'"!="") {
		local roweqstyle txt
	}
	else {
		local roweqstyle res
	}

// handling of stripes: names and equations -----------------------------------

	if "`names'" != "" & `"`names2'"' != "" {
		dis as err "names and names() are exclusive"
		exit 198
	}
	if "`names'" != "" {
		local show_rownames = 0
		local show_colnames = 0
	}
	else {
		ParseNames `names2'
		local show_rownames = inlist("`s(names)'", "all", "rows")
		local show_colnames = inlist("`s(names)'", "all", "columns")
	}
	if "`coleqonly'" != "" & !inlist("`s(names)'","all","columns") {
		dis as err "coleqonly may not be combined with " ///
			"names(rows), names(none) or nonames"
		exit 198
	}
	local show_coleqonly = `:length local coleqonly'

	if "`roweqonly'" != "" & !inlist("`s(names)'","all","rows") {
		dis as err "roweqonly may not be combined with " ///
			"names(columns), names(none) or nonames"
		exit 198
	}
	local show_roweqonly = `:length local roweqonly'

	local c1   = 1 - `show_rownames'
	local c1p1 = `c1'+1
	local c    = colsof(`m')
	local cp1  = `c'+1

	local r1   = 1 - `show_colnames'
	local r1p1 = `r1'+1
	local r    = rowsof(`m')
	local rp1  = `r'+1

	local reqns : roweq `m', quote
	local show_roweq = (`"`:list uniq reqns'"' != `""_""')

	local ceqns : coleq `m', quote
	local show_coleq = (`"`:list uniq ceqns'"' != `""_""')
	
	if !`show_coleq' { 
		if "`keepcoleq'" != "" { 
			dis as err "column equations not found; " /// 
		 	           "option keepcoleq invalid"
			exit 198
		}
		if `"`coleq'"' != "" { 
			dis as err "column equations not found; " /// 
		 	           "option coleq() invalid"
			exit 198
		}
	}	
	
	ParseSHOWCOLEQ `showcoleq' 
	local coleq_method `s(showcoleq)' 
	
	ParseCOLORCOLEQ `colorcoleq' 
	local colorcoleq `s(colorcoleq)' 
	
	ParseALIGNCOLNames `aligncolnames' 
	local aligncolnames `s(aligncolnames)' 

// misc

	if `"`linesize'"' == "" {
		local linesize c(linesize)
	}

	// showlower (for symmetric matrices only)
	local loweronly = 0
	if `r' == `c' {
		local loweronly = issym(`m') & ("`half'" == "")
	}

/* ----------------------------------------------------------------------------
   cspec() == column formatting

       s_spec [c_spec s_spec]*

           c_spec: [w#] [b|i|s] [c|e|r|t] %fmt

           s_spec: [o#]{|&}[o#]

       columns of the table are indexed

           where     0 = text
                     j = column j of the matrix j=1..c

       column separators are indexed  0/1..c+1

           where     j   is the separator before column j
           and      c+1  is the separator after the last column

           o# denotes the number of spaces before/after separator
           defaults to 1 "inside" table and to 0 on the outside.

       macro     description
       ---------------------------------------------------------------
       fmt#      display format for column #
       font#     font (bf sf it) for column #
       mode#     color of column #
       wcol#     width of column #
       align#    alignment of column #

       bsep#     number of leading spaces in colsep #
       asep#     number of trailing spaces in colsep #
       sep#      line 0/1 in colsep #
       wsep#     width of colsep #

   -------------------------------------------------------------------
   rspec() = row formatting options ([&-]*)

       rows of the table are indexed
		   where     0 = text
		             i = row i of the matrix i=1..r

       macro    description
       ---------------------------------------------------------------
       rsep<i>   i=0    before text row with column headers
		         i=1    before  numerical row 1
		         ...
		         i=r    before numerical row r (last row)
		        i=r+1   after  numerical row r (last row)
   ----------------------------------------------------------------------------
*/

	if `"`rspec'`cspec'"' != "" {

	// style options not allowed

		NotAllowed lines()  `"`lines'"'
		NotAllowed format() `"`format'"'
		NotAllowed twidth() `"`twidth'"'
		NotAllowed left()   `"`left'"'
		NotAllowed right()  `"`right'"'
		NotAllowed border   `"`border'"'

	// both rspec() and cspec() expected

		if `"`rspec'"' == "" {
			dis as err "rspec() required with cspec()"
			exit 198
		}
		if `"`cspec'"' == "" {
			dis as err "cspec() required with rspec()"
			exit 198
		}

	// parse cspec() -- column specifications

		local cspec0 `cspec'
		local dflt_sep  0 0 0 1

		// column with row names
		if `show_rownames' {
			GetSepSpec  bsep0 sep0 asep0 cspec0 /// 
			   `"`cspec0'"' `dflt_sep'
			GetColSpec  fmt0 font0 mode0 wcol0 ///
			   align0 cspec0 `"`cspec0'"' sf txt ralign
			local junk  : display `fmt0' "a"
			local dflt_sep  1 1 1 1
		}

		// numerical columns
		forvalues j = 1 / `c' {
			GetSepSpec  bsep`j' sep`j' asep`j' cspec0 ///
			   `"`cspec0'"' `dflt_sep'
			GetColSpec  fmt`j' font`j' mode`j' wcol`j' ///
			   align`j' cspec0 `"`cspec0'"' sf res ralign
			local junk  : display `fmt`j'' 1
			local dflt_sep  1 1 1 1
		}

		// right-most separator
		GetSepSpec  bsep`cp1' sep`cp1' asep`cp1' cspec0 /// 
		   `"`cspec0'"' 0 0 1 0

		if `"`cspec0'"' != "" {
			dis as err `"extraneous input in cspec(): `cspec0'"'
			exit 198
		}

	// parse rspec() -- row specifications

		local rspec0 `rspec'
		forvalues i = `r1' / `rp1' {
			// undocumented behavior: | is equivalent to -
			gettoken tok rspec0 : rspec0, parse("&-| ")
			if `"`tok'"' == "" {
				dis as err "too few specifications in rspec()"
				exit 198
			}
			else if !inlist("`tok'","&","-","|") {
				dis as err "invalid horizontal separator " /// 
				    "specification `tok'"
				exit 198
			}
			local rsep`i' = ("`tok'" != "&")
		}

		if `"`rspec0'"' != "" {
			dis as err `"extraneous input in rspec(): `rspec0'"'
			exit 198
		}
	}

// display styles -------------------------------------------------------------

	else {
		ParseLines  `lines'
		local lstyle `s(lstyle)'

		if "`border2'" != "" {
			ParseBorder `border2'
			local border_arg `s(border)'
		}
		else if "`border'" != "" {
			local border_arg top bottom left right
		}

		if "`lstyle'" == "" {
			local lstyle = cond(`show_roweq'|`show_coleq', /// 
			   "eq" ,"oneline")
		}

		if (`"`left'"'   == "") local left   =  0
		if (`"`right'"'  == "")	local right  =  0
		if (`"`twidth'"' == "") local twidth = 12

		if `"`format'"' == "" {
			local format %9.0g
		}
		else {
			capture local junk : display `format' 1
			if _rc {
				dis as err "invalid %format `format'"
				exit 120
			}
		}
		if `show_rownames' {
			local fmt0  %`twidth's
		}
		forvalues j = 1 / `c' {
			local fmt`j' `format'
		}

	// initialize settings for all styles

		if `show_rownames' {
			local font0   sf
			local mode0   txt
			local align0  ralign
		}

		forvalues j = 1 / `c' {
			local font`j'   sf
			local mode`j'   res
			local align`j'  ralign
		}

		// separator: before table
		local bsep`c1' = `left'
		local  sep`c1' = 0
		local asep`c1' = 0

		// separator: between numerical entries
		forvalues j = `c1p1' / `c' {
			local bsep`j' = 1
			local  sep`j' = 0
			local asep`j' = 1
		}

		// separator: after numerical entries
		local bsep`cp1' = 1
		local  sep`cp1' = 0
		local asep`cp1' = `right'

		forvalues i = `r1' / `rp1' {
			local rsep`i' = 0
		}

	// adjust settings for display styles

		if "`lstyle'" == "oneline" {
			// the first row and column is divided off the rest
			local asep0 = 0
			local  sep1 = `show_rownames'
			local rsep1 = `show_colnames'
		}
		else if "`lstyle'" == "rowtotal" {    
			// the first and last row is divided off the rest
			local asep0   = 0
			local  sep1   = `show_rownames'
			local rsep1   = `show_colnames'
			local rsep`r' = 1
		}
		else if "`lstyle'" == "coltotal" {
			// the first and last column is divided off the rest
			local  sep1 = `show_rownames' 
			local rsep1 = `show_colnames'  
			local  sep`c' = 1
		}
		else if "`lstyle'" == "rctotal" {
			// the last row and column is divided off the rest
			local asep0   = 0
			local  sep1   = `show_rownames'
			local rsep1   = `show_colnames'
			local rsep`r' = 1
			local  sep`c' = 1
		}
		else if "`lstyle'" == "cells" {
			forvalues j = `c1p1' / `c' {
				local sep`j' = 1
			}
			forvalues i = `r1p1' / `r' {
				local rsep`i' = 1
			}
		}
		else if "`lstyle'" == "columns" {
			forvalues j = `c1p1' / `c' {
				local sep`j' = 1
			}
			local rsep`r1p1' = `show_colnames'
		}
		else if "`lstyle'" == "rows" {
			forvalues i = `r1p1' / `r' {
				local rsep`i' = 1
			}
			local sep`c1p1' = `show_rownames'
		}
		else if "`lstyle'" == "eq" {
			local  sep`c1p1' = `show_rownames'
			local rsep`r1p1' = `show_colnames'

			// add vertical lines between equations
			local ceq  : coleq `m' , quote
			gettoken eqhold ceq : ceq
			forvalues j = 2 / `c' {
				gettoken eq ceq : ceq
				if `"`eq'"' != `"`eqhold'"' {
					local sep`j' = 1
					local eqhold `eq'
				}
			}

			// add horizontal lines between equations
			local req  : roweq `m' , quote
			gettoken eqhold req : req
			forvalues i = 2 / `r' {
				gettoken eq req : req
				if `"`eq'"' != `"`eqhold'"' {
					local rsep`i' = 1
					local eqhold `eq'
				}
			}
		}
		else if "`lstyle'" == "none" {
			// nothing
		}	
		else {
			_stata_internalerror
		}

	// border

		if index("`border_arg'", "top")  {
			local rsep`r1'  = 1   // before first
		}
		if index("`border_arg'", "bottom")  {
			local rsep`rp1' = 1   // after last
		}
		if index("`border_arg'", "left")  {
			local  sep`c1' = 1    // before first
			local asep`c1' = 1
		}
		if index("`border_arg'", "right")  {
			local  sep`cp1' = 1
			local bsep`cp1' = 1   // after last
		}
	}

	if "`bottomline'" != "" {
		local rsep`rp1' = 1   // force bottom line
	}

// initialize stuff before drawing table --------------------------------------

	// wcol<j> width of column j, excl white space before/after sep
	// Wcol<j> width of column j, incl white space before/after sep

	if `show_rownames' {
		if ("`wcol0'" == "")  local wcol0 0
		local wcol0 = max(`wcol0',udstrlen(`"`:display `fmt0' "a"'"'))
		local Wcol0 = `asep0' + `wcol0' + `bsep1'
	}
	forvalues j = 1 / `c' {
		if ("`wcol`j''" == "")  local wcol`j' 0
		local temp : display `fmt`j'' 1
		local wcol`j' = max(`wcol`j'',udstrlen(`"`temp'"'))
		local Wcol`j' = `asep`j'' + `wcol`j'' + `bsep`=`j'+1''
	}	
	
	// the drawing characters to be used if a line is wanted.  
	// The macros with extension 0 are referenced in case no line 
	// is needed; these should evaluate to "nothing".

	local  Vch1  "{c |}"     // Vertical bar

	local TLch1  "{c TLC}"   // Top    Left
	local CLch1  "{c  LT}"   // Center Left
	local BLch1  "{c BLC}"   // Bottom Left

	local TCch1  "{c  TT}"   // Top    Center
	local CCch1  "{c   +}"
	local BCch1  "{c  BT}"

	local TRch1  "{c TRC}"   // Top    Right
	local CRch1  "{c  RT}"
	local BRch1  "{c BRC}"

	// prepare string elements of table

	// abbreviated strings to be displayed in first column
	if `show_rownames' {
	   	local rowtitle = udsubstr(`"`rowtitle'"',1,`wcol0')		
	   	
		local rnames : rownames `m'
		forvalues i = 1 / `r' {
			gettoken rn rnames : rnames
			local rname`i' = abbrev(`"`rn'"',`wcol0')
			if "`underscore'" != "" {
				local rname`i' = ///
				   subinstr(`"`rname`i''"',"_"," ",.)
			}
		}
	}
	local cnames : colnames `m'

	if `"`reqns'"' != "" {
		forvalues i = 1 / `r' {
			gettoken req`i' reqns : reqns
		}
	}

	// for column headers: merging within equation names 

        if "`coleq_method'" == "combined" {
        	local coleq_method combine
        	local ceq_align    rcenter 
        }
        else if "`coleq_method'" == "lcombined" { 
               	local coleq_method combine
	       	local ceq_align    lalign
	}
        else if "`coleq_method'" == "rcombined" { 
               	local coleq_method combine
	       	local ceq_align    ralign
	}

	// splitting row and column elements similar to -matrix list-

	if `show_colnames' {
		_ms_op_info `m'
		if r(fvops) | r(tsops) | r(fnops) {
			local wcol : copy local wcol1
			forval i = 2/`c' {
				if `wcol' > `wcol`i'' {
					local wcol : copy local wcol`i'
				}
			}
			local kcs 2
			if `wcol' > 4 {
				_ms_split `m', width(`wcol') nocolon
				local kcs = r(k_cols)
				forval i = 1/`c' {
					forval j = 1/`kcs' {
						local cs_`i'_`j' ///
							`"`r(str`i'_`j')'"'
					}
				}
			}
		}
		else {
			local kcs 2
			forval i = 1/`c' {
				_ms_split `m', width(`wcol`i'') nocolon
				local cs_`i'_1 `"`r(str`i'_1)'"'
				local cs_`i'_2 `"`r(str`i'_2)'"'
			}
		}
	}
	if `show_rownames' {
		if `wcol0' > 4 {
			_ms_split `m', row abbrev width(`wcol0') nocolon
			local krs = r(k_cols)
			forval i = 1/`r' {
				forval j = 1/`krs' {
					local rs_`i'_`j' `"`r(str`i'_`j')'"'
					if "`underscore'" != "" {
						local rs_`i'_`j' = ///
							subinstr( ///
							  `"`rs_`i'_`j''"', ///
							  "_"," ",.)
					}
				}
			}
			local krsm1 = `krs' - 1
		}
	}

// debug ----------------------------------------------------------------------

	if "`debug'" != "" {
		dis as txt _n "Settings: "_n
		forvalues j = `c1' / `c' {
			#del ; 
			dis as txt "column `j': fmt={res:`fmt`j''} " 
			           " font={res:`font`j''} " 
			           " mode={res:`mode`j''} " 
			           " align={res:`align`j''} "
			           " wcol={res:`wcol`j''} "
			           " Wcol={res:`Wcol`j''}" ;
			#del cr			           
		}
		dis
		forvalues j = 0 / `cp1' {
			#del ; 
			dis as txt "Column sep `j':" 
			           " bsep="  %1s "`bsep`j''" 
			           "  sep="  %1s "`sep`j''" 
			           "  asep=" %1s "`asep`j''" ;
			#del cr
		}
		dis
		forvalues i = 0 / `rp1' {
			dis as txt "   Row sep `i': rsep=`rsep`i''"
		}
	}

// ----------------------------------------------------------------------------
// output!
// ----------------------------------------------------------------------------

// title and header

if "`blank'" == "" {
	display
}
if `"`title'"' != "" {
	if "`tindent'" == "" {
		local tindent = 0 // `bsep`c1''
	}
	dis as txt `"{p `tindent' `tindent' 2}`title'{p_end}"' _n
}

// table, wrapping columns if necessary ---------------------------------------

// tokenize column equations
local j = 0
foreach eq of local ceqns { 
	local ceq`++j' `eq' 
}	

local j2 = 0
while `j2' < `c' {
	if (`j2' > 0) display

	// display columns j1..j2 (boundaries included, row names excluded) 
	//
	// at least column is displayed, j2>=j1, even if it does not fit
	//
	// if keepcoleq, equations are kept together if possible.

	// continue where we left off in previous block
	local j1   = `j2'+1
	local j1p1 = `j1'+1

	// at least one column (j1=j2)
	local j2 = `j1'
	local jwidth = `bsep`c1''+`sep`c1''+`Wcol`j1''+`sep`cp1''+`asep`cp1''
	if `show_rownames' {
		local jwidth = `jwidth' + `Wcol0' + `sep1'
	}

	if "`keepcoleq'" == "" { 
		// increase j2 to maximal value that still fits
		local trymore = (`j2'<`c') & (`jwidth'<`linesize')
		while `trymore' {
			local j2p = `j2'+1
			local jwidthp = `jwidth' + `sep`j2p'' + `Wcol`j2p''
			if `jwidthp' <= `linesize' {
				local j2      = `j2p'
				local jwidth  = `jwidthp'
				local trymore = `j2' < `c'
			}
			else {
				local trymore = 0
			}
		}
	}
	else {
		// increase j2 to maximal value with same eq
		local trymore = (`j2'<`c') & (`jwidth'<`linesize')
		while `trymore' {
			local j2p = `j2'+1
			local jwidthp = `jwidth' + `sep`j2p'' + `Wcol`j2p''
			if (`jwidthp' <= `linesize') & /// 
			   ("`ceq`j1''" == "`ceq`j2p''") {
				local j2      = `j2p'
				local jwidth  = `jwidthp'
				local trymore = `j2' < `c'
			}
			else {
				local trymore = 0
			}
		}
			
		// we have j1..j2; add only "complete" equations
		local trymore = (`j2'<`c') & (`jwidth'<`linesize')
		while `trymore' { 
			local j3 = `j2'+1
			local j4 = `j3' 
			while "`ceq`j3''"=="`ceq`j4''" & `j4'<=`c' {
				local ++j4
			}
			local --j4
			
			// width including j3..j4
			local jwidthp = `jwidth' 
			forvalues j = `j3'/`j4' { 
				local jwidthp = `jwidthp' + `sep`j''+`Wcol`j''
			}
			
			// add if extra equation fits
			if `jwidthp' < `linesize' { 
				local j2 = `j4' 
				local jwidth = `jwidthp' 
				local trymore = (`j2' < `c')
			}
			else {
				local trymore = 0
			}	
		}
	}

	// horizontal line : top-style

	if `rsep`r1'' {
		dis as txt "{space `bsep`c1''}`TLch`sep`c1'''" _c
		if `show_rownames' {
			dis "{hline `Wcol0'}`TCch`sep`c1p1'''" _c
		}
		forvalues j = `j1' / `=`j2'-1' {
			local jp1 = `j'+1
			dis "{hline `Wcol`j''}`TCch`sep`jp1'''" _c
		}
		dis "{hline `Wcol`j2''}`TRch`sep`cp1'''"
	}

	// display header for columns j1..j2

	// (a) column equations
	if (`show_colnames' & `show_coleq') | `show_coleqonly' {
		dis as txt "{space `bsep`c1''}`Vch`sep`c1'''" _c
		if `show_rownames' {
			dis "{space `Wcol0'}`Vch`sep`c1p1'''" _c
		}
			
		if "`coleq_method'" == "each" {

			// repeat equation names above each column
				
			forvalues j = `j1' / `j2' {
				local jp1 = `j'+1
				if `wcol`j'' > 4 { 
					_ms_split `m', width(`wcol`j'') ///
					    nocolon
					local jm1 = `j'-1
					local ceq `"`r(str`j'_1)'"'
				}
				else { 
					local ceq = /// 
						udsubstr("`ceq`j''",1,`wcol`j'')					
				}
				local hasop = bsubstr("`ceq'",-1,1) == ":"
				if `hasop' {
					local wcol = `wcol`j'' + 1
					local bsep = `bsep`jp1'' - 1
					if `bsep' < 0 {
						local bsep 0
					}
				}
				else {
					local wcol : copy local wcol`j'
					local bsep : copy local bsep`jp1'
				}

				#del ; 
				dis as `colorcoleq' 
				    `"{space `asep`j''}"'
				    `"{ralign `wcol':`ceq'}"'
				    `"{space `bsep'}"' 
				    as txt cond(`j'==`j2', 
				      "`Vch`sep`cp1'''",
				      "`Vch`sep`jp1'''" ) _c ;
				#del cr	   
			}
			dis
		}
		else if "`coleq_method'" == "first" {
			
			// repeat eq names only when it first occurs
				
			local ceqhold
			forvalues j = `j1' / `j2' {
				local jp1 = `j'+1
				gettoken ceq ceqns : ceqns
				if `"`ceq'"' != `"`ceqhold'"' {
					if `wcol`j'' > 4 { 
						_ms_split `m', ///
						    width(`wcol`j'') nocolon
						local jm1 = `j'-1
						local ceqab `"`r(str`j'_1)'"'
					} 
					else {
						local ceqab = /// 
							udsubstr(`"`ceq'"',1,`wcol`j'')						
					}
					
					#del ;
					dis as `colorcoleq' 
					    `"{space `asep`j''}"'
					    `"{lalign `wcol`j'':`ceqab'}"' 
					    `"{space `bsep`jp1''}"' _c ; 
					#del cr
					local ceqhold `ceq'
				}
				else {
					dis as txt `"{space `Wcol`j''}"' _c
				}
				dis as txt cond(`j'==`j2',      /// 
				           `"`Vch`sep`cp1'''"', ///
				           `"`Vch`sep`jp1'''"') _c
			}
			dis
		}
		else if "`coleq_method'" == "combine" {
			
			// combine columns with same equation name 
			// and display header above with ceq_align alignment
			// column sep lines "inside" are not drawn
				
			gettoken ceqhold ceqns  : ceqns 
			
			local eqw = `wcol`j1'' 
			local beq = `asep`j1''  
			
			forvalues j = `= `j1'+1' / `j2' { 
				gettoken ceq ceqns : ceqns
				local jp1 = `j'+1 
				if `"`ceq'"' == `"`ceqhold'"' {
					local eqw = `eqw' + `asep`j'' + /// 
					   `sep`j'' + `bsep`jp1'' + `wcol`j''
				}
				else {
					if `eqw' > 4 { 
					    _ms_split `m', width(`eqw') ///
						nocolon
					    local jm1 = `j'-1
					    local ceqab `"`r(str`jm1'_1)'"'
					}
					else {
						local ceqab = ///
							udsubstr(`"`ceqhold'"',1,`eqw')						
					}

					#del ;
					dis as `colorcoleq' 
					    `"{space `beq'}"'      
					    `"{`ceq_align' `eqw':`ceqab'}"'
				            `"{space `bsep`j''}"'
				            as txt 
				            `"`Vch`sep`j'''"' _c ; 
					#del cr
							
					local ceqhold `ceq'
					local eqw = `wcol`j''
					local beq = `asep`j'' 
				}
			}

			if `eqw' > 4 { 
				local ceqab = abbrev(`"`ceqhold'"',  `eqw')
			}
			else { 
				local ceqab = udsubstr(`"`ceqhold'"',1,`eqw')
			}	
			#del ;
			dis as `colorcoleq' 
			    `"{space `beq'}"'
			    `"{`ceq_align' `eqw':`ceqab'}"'
		            `"{space `bsep`cp1''}"' 
		            as txt `"`Vch`sep`cp1'''"' ; 
			#del cr
		}
		else {
			_stata_internalerror
		}	
	}

	// (b) column names
		
	if `show_colnames' & !`show_coleqonly' {
	    forvalues jj = 2/`kcs' {
		dis as txt "{space `bsep`c1''}`Vch`sep`c1'''" _c
		if `show_rownames' {
			if `jj' == `kcs' {
				dis `"{space `asep0'}"'             /// 
				    `"{ralign `wcol0':`rowtitle'}"' ///
				    `"{space `bsep1'}`Vch`sep`c1p1'''"' _c
			}
			else {
				dis `"{space `asep0'}"'   /// 
				    `"{ralign `wcol0':}"' ///
				    `"{space `bsep1'}`Vch`sep`c1p1'''"' _c
			}
		}
		forvalues j = `j1' / `j2' {
			local jp1 = `j'+1
			local cnj : word `j' of `cnames'
			local next 0
			if `wcol`j'' > 4 { 
				local abvj  : copy local cs_`j'_`jj'
				local next  : length local cs_`j'_`=`jj'+1'
			} 
			else if `jj' == `kcs' { 
				local abvj  = udsubstr("`cnj'",1,`wcol`j'')				
			}
			
			if "`underscore'" != "" {
				local abvj = subinstr(`"`abvj'"',"_"," ",.)
			}
			local hasop 0
			if `next' {
				local hasop = strpos(".*|@#", bsubstr("`abvj'",-1,1))
			}
			if "`aligncolnames'" == "ralign" & `hasop' {
				local wcol = `wcol`j'' + 1
				local bsep = `bsep`jp1'' - 1
				if `bsep' < 0 {
					local bsep 0
				}
			}
			else {
				local wcol : copy local wcol`j'
				local bsep : copy local bsep`jp1'
			}
			#del ;
			dis `"{space `asep`j''}"'
			    `"{`aligncolnames' `wcol':`abvj'}"' 
			    `"{space `bsep'}"' 
			    as txt 
			    cond(`j'==`j2',"`Vch`sep`cp1'''", 
			                   "`Vch`sep`jp1'''" ) _c ;
			#del cr			                   
		}
		dis
	    }
	}

	// display data columns j1..j2

	local reqhold
	local lowi = cond(`loweronly',`j1',1)
	forvalues i = `lowi' / `r' {
		if !`loweronly' {
			local showhline = /// 
			  `rsep`i'' & (`i'!=1 | `show_colnames')
		}
		else {
			local showhline = cond(`i'==`lowi', /// 
			   `rsep1' & `show_colnames', `rsep`i'')
		}

		if `showhline' {
			dis as txt "{space `bsep`c1''}`CLch`sep`c1'''" _c
			if `show_rownames' {
				dis "{hline `Wcol0'}`CCch`sep`c1p1'''" _c
			}
			forvalues j = `j1' / `=`j2'-1' {
				local jp1 = `j'+1
				dis "{hline `Wcol`j''}`CCch`sep`jp1'''" _c
			}
			dis "{hline `Wcol`j2''}`CRch`sep`cp1'''"
		}

		// line with equation name
		
		if (`show_rownames') & (`show_roweq') | `show_roweqonly'{
		   if (`"`req`i''"' != `"`reqhold'"') {
		   	if `wcol0' > 4 { 
				local reqab : copy local rs_`i'_1
				local dcol = udstrlen(`"`reqab'"')
				if `dcol' > `wcol0' {
					local reqab = abbrev(`"`reqab'"', `wcol0')
				}
		   	}
		   	else {
				local reqab = udsubstr(`"`req`i''"',1,`wcol0')
			}		   	
			#del ; 
			dis as txt 
			    `"{space `bsep`c1''}"'
			    `"`Vch`sep`c1'''"'
			    `"{`roweqstyle':{lalign `Wcol0':`reqab'}}"'
			    `"`Vch`sep`c1p1'''"' _c ;
			#del cr
			forvalues j = `j1' / `=`j2'-1' {
				local jp1 = `j'+1 
				dis "{space `Wcol`j''}`Vch`sep`jp1'''" _c
			}
			dis "{space `Wcol`j2''}`Vch`sep`cp1'''"
			local reqhold `req`i''
		   }
		}

	// data lines
		
		if `show_rownames' {
		    if `wcol0' > 4 {
			forval ii = 2/`krs' {
			    local hasop 0
			    if `:length local rs_`i'_`=`ii'+1'' {
				local hasop = strpos(".*@|#",	///
					bsubstr("`rs_`i'_`ii''",-1,1))
			    }
			    if `hasop' {
				local wcol = `wcol0' + 1
				local bsep = `bsep1' - 1
				if `bsep' < 0 {
					local bsep 0
				}
			    }
			    else {
				local wcol : copy local wcol0
				local bsep : copy local bsep1
			    }
			    if `show_roweqonly' {
				local rs_`i'_`ii' = " "
			    }
			    if `:length local rs_`i'_`ii'' | `show_roweqonly' {
				dis as txt "{space `bsep`c1''}`Vch`sep`c1'''" _c
				dis `"{space `asep0'}"' ///
				    `"{ralign `wcol':`rs_`i'_`ii''}"' ///
				    `"{space `bsep'}`Vch`sep`c1p1'''"' _c
				if `ii' < `krs' {
				    forvalues j = `j1' / `=`j2'-1' {
					local jp1 = `j'+1 
					dis "{space `Wcol`j''}" ///
					    "`Vch`sep`jp1'''" _c
				    }
				    dis "{space `Wcol`j2''}`Vch`sep`cp1'''"
				}
			    }
			}
		    }
		    else {
			dis as txt "{space `bsep`c1''}`Vch`sep`c1'''" _c
			dis `"{space `asep0'}"' ///
			    `"{ralign `wcol0':`rname`i''}"' ///
			    `"{space `bsep1'}`Vch`sep`c1p1'''"' _c
		    }
		}
		else {
			dis as txt "{space `bsep`c1''}`Vch`sep`c1'''" _c
		}
		forvalues j = `j1' / `j2' {
			#del ;
			local ifcond = 
			   (("`dotz'" != "") & (`m'[`i',`j']==.z)) 
			   |
			   ((`loweronly') & (`j' > `i')) ;
			#del cr   

			if `ifcond' {
				local fmtm  "{space `wcol`j''}"
			}
			else {
				local fmtm : display `fmt`j'' `m'[`i',`j']
			}

			local jp1 = `j'+1
			#del ;
			dis "{space `asep`j''}"
			    "{`align`j'' `wcol`j'':{`mode`j'':{`font`j'':`fmtm'}}}"
			    "{space `bsep`jp1''}" 
			    as txt
			    cond(`j'==`j2', "`Vch`sep`cp1'''",
			                    "`Vch`sep`jp1'''") _c ;
			#del cr
		}
		dis
	}

	// horizontal line : bottom-style

	if `rsep`rp1'' {
		dis as txt "{space `bsep`c1''}`BLch`sep`c1'''" _c
		if `show_rownames' {
			dis as txt "{hline `Wcol0'}`BCch`sep`c1p1'''" _c
		}
		forvalues j = `j1' / `=`j2'-1' {
			local jp1 = `j'+1
			dis "{hline `Wcol`j''}`BCch`sep`jp1'''" _c
		}
		dis "{hline `Wcol`j2''}`BRch`sep`cp1'''"
	}

} // loop over blocks
end

// ----------------------------------------------------------------------------
// parsing subroutines
// ----------------------------------------------------------------------------

program NotAllowed
	args optname value

	if `"`value'"' != "" {
		dis as err /// 
		    `"option `optname' not allowed with rspec() and cspec()"'
		exit 198
	}
end

program ParseLines, sclass
	local 0 ,`0'
	syntax [, CElls COlumns COLTotal eq None Oneline /// 
	          Rows RCTotal ROWTotal ]

	local opt `cells' `columns' `coltotal' `eq' `none' `oneline' ///
	   `rows' `rctotal' `rowtotal'
	if `:list sizeof opt' > 1 {
		dis as err "lines() expects a single lstyle specification"
		exit 198
	}

	sreturn clear
	sreturn local lstyle  `opt'
end

program ParseBorder, sclass
	local 0 ,`0'
	syntax [, Top Left Right Bottom COLumns ROWs ALL None ]

	if "`all'" != "" {
		local columns columns
		local rows    rows
	}
	if "`columns'" != "" {
		local left  left
		local right right
	}
	if "`rows'" != "" {
		local top    top
		local bottom bottom
	}
	sreturn clear
	sreturn local border `top' `bottom' `left' `right'
end

program ParseNames, sclass
	local 0 ,`0'
	syntax [, All Columns Rows None ]

	local opt `all' `columns' `rows' `none'
	if "`opt'" == "" {
		local opt all
	}
	opts_exclusive "`opt'" names

	sreturn clear
	sreturn local names `opt'
end

program ParseSHOWCOLEQ, sclass
	local 0 ,`0' 
	syntax [, Each Combined First Lcombined Rcombined ]
	
	local opt `each' `combined' `first' `lcombined' `rcombined' 
	if "`opt'" == "" { 
		local opt first
	}
	opts_exclusive "`opt'" showcoleq
	
	sreturn clear
	sreturn local showcoleq `opt' 
end

program	ParseCOLORCOLEQ, sclass
	local 0 ,`0' 
	syntax [, Res Txt ]

	local opt `res' `txt' 
	if "`opt'" == "" { 
		local opt txt
	}
	opts_exclusive "`opt'" colorcoleq
	
	sreturn clear
	sreturn local colorcoleq `opt' 
end

program ParseALIGNCOLNames, sclass 
	local 0 , `0' 
	syntax [, Center Ralign Lalign ]

	local opt `center' `ralign' `lalign' 
	if "`opt'" == "" { 
		local opt ralign
	}
	opts_exclusive "`opt'" aligncolnames
	
	sreturn clear
	sreturn local aligncolnames `opt'
end	


// parses off from input the specification of the next column
// returning in rest the remainder of the input
//
program GetColSpec
	args fmt font mode wcol align rest input ///
	     Dfont Dmode Dalign

	local Font  `Dfont'
	local Mode  `Dmode'
	local Align `Dalign'

	gettoken spec Rest : input , parse("o|&") // note: no space

	while trim(`"`spec'"') != "" {
		gettoken tok spec : spec
		local tok = trim("`tok'")
		if bsubstr(`"`tok'"',1,1) == "%" {
			local Fmt `tok'
		}
		else if bsubstr(`"`tok'"',1,1) == "w" {
			local Wcol = bsubstr("`tok'",2,.)
			confirm integer number `Wcol'
		}
		else if "`tok'" == "s" {
			local Font sf
		}
		else if "`tok'" == "b" {
			local Font bf
		}
		else if "`tok'" == "i" {
			local Font it
		}
		else if "`tok'" == "L" {
			local Align lalign
		}
		else if "`tok'" == "R" {
			local Align ralign
		}
		else if "`tok'" == "C" {
			local Align center
		}
		else if "`tok'" == "t" {
			local Mode txt
		}
		else if "`tok'" == "r" {
			local Mode res
		}
		else if "`tok'" == "e" {
			local Mode err
		}
		else if "`tok'" == "c" {
			local Mode cmd
		}
		else {
			dis as err `"option cspec() invalid; "' /// 
			           `"unknown input `tok'"'
			exit 198
		}
	}

	c_local `fmt'   `Fmt'
	c_local `font'  `Font'
	c_local `mode'  `Mode'
	c_local `wcol'  `Wcol'
	c_local `align' `Align'
	c_local `rest'  `Rest'
end


// parses off the information for the next separator
//
program GetSepSpec
	args bsep         /// number of spaces before
	     sep          /// 1 specifies hline, otherwise 0
	     asep         /// number of spaces after
	     rest         /// remainder of input after parsing of separator
	///
	     input        /// input string
	     bsep_d0      /// default: bsep if sep==0
	     asep_d0      /// default: asep if sep==0
	     bsep_d1      /// default: bsep if sep==1
	     asep_d1       // default: asep if sep==1

	gettoken tok input : input, parse(" |&")
	if bsubstr(`"`tok'"',1,1) == "o" {
		local b = bsubstr(`"`tok'"',2,.)
		confirm integer number `b'
		gettoken tok input : input, parse(" |&")
	}

	if !inlist(`"`tok'"',"&","|") {
		dis as err `"& or | expected, `tok' found"'
		exit 198
	}

	local s = ("`tok'" == "|")

	gettoken tok : input, parse(" |&")
	if bsubstr(`"`tok'"',1,1) == "o" {
		gettoken tok input : input, parse(" |&")
		local a = bsubstr(`"`tok'"',2,.)
		confirm integer number `a'
	}

	if ("`b'" == "") local b = cond(`s',`bsep_d1',`bsep_d0')
	if ("`a'" == "") local a = cond(`s',`asep_d1',`asep_d0')

	c_local `bsep'  `b'
	c_local `sep'   `s'
	c_local `asep'  `a'
	c_local `rest'  `input'
end
exit

Future extensions

  cspec: compact syntax to declare formatting of multiple columns at once
  rspec: default to "one line" 
