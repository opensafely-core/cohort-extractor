*! version 1.0.9  17jan2014

// ---------------------------------------------------------------------------
//  Parse tickset settings and options and push the associated edits of the
//  named object onto the specified log.
//
//	Usage:  ._gs_parse_and_log_tickset log axisnm ticknm  
//		<settings and options>

program _gs_parse_and_log_tickset
	version 9

	gettoken log     0 : 0
	gettoken axisnm  0 : 0
	gettoken ticknm  0 : 0
	gettoken datesok 0 : 0

	syntax [anything(name=labels)] [ , ADD CUSTOM noRESCALE * ]

	if `"`labels'"' != `""' & "`add'" == "" {
		.`log'.Arrpush .`axisnm'.`ticknm'.clear
	}

	Rules       `log' `axisnm' `ticknm' "`datesok'" `labels'
	NumTextList `log' `axisnm'.`ticknm' "`add'" "`rescale'"		///
		     "`custom'" "`datesok'" `r(rest)'

	if `"`labels'"' != `""' {
		.`log'.Arrpush .`axisnm'.reset_scale reinit
	}


	Options     `log' `axisnm' `ticknm' , `options' `custom'

//	local 0 `", `r(rest)'"'
//	syntax [, FAKE_OPT_FOR_BETTER_MSG ]
end


// ----------------------------------------------------------------------------
//  #<#> relies on the tickset style having the same name in the style as
//       the name of tickset in the axis.  Let #1 imply minmax
program Rules , rclass

	gettoken log     0 : 0
	gettoken axisnm  0 : 0
	gettoken ticknm  0 : 0
	gettoken datesok 0 : 0

	local name `axisnm'.`ticknm'

	gettoken tok  rest : 0 ,  parse(" #(")

	if `"`tok'"' == `"#"' {					// #<#>
		gettoken tok2 rest : rest , parse(" #")
		if `"`tok2'"' == `"#"' {			// ##<#>
			gettoken tok2 rest : rest
			local pgm suggest_between_ticks
		}
		else {
			local pgm suggest_ticks
		}

		capture confirm integer number `tok2'
		if _rc {
			di as error ///
			`"invalid tick rule, `tok2' not an integer"'
			exit 198
		}

		.`log'.Arrpush						     ///
		   .`axisnm'.style.editstyle `ticknm'style(numticks(`tok2')) ///
		   editcopy
		.`log'.Arrpush .`name'.`pgm' `tok2'

		return local rest `"`rest'"'
		exit
	}

	if `"`tok'"' == `"minmax"' {				// "minmax"
		.`log'.Arrpush					         ///
		   .`axisnm'.style.editstyle `ticknm'style(numticks(1))  ///
		   editcopy
		.`log'.Arrpush .`name'.minmax_ticks 

		return local rest `"`rest'"'
		exit
	}

	if `"`tok'"' == `"none"' {				// "none"
		.`log'.Arrpush .`name'.none_ticks 

		return local rest `"`rest'"'
		exit
	}

	if `"`tok'"' == `"."' {					// no rule
		return local rest `"`rest'"'
		exit
	}

								// #(#)#
	if "`datesok'" != "" & "`tok'" == "(" {
		local rest `"`tok'`rest'"'
		gettoken tok rest : rest , parse(" ()") match(par)
	}
	gettoken tok2 rest : rest , parse(" ()") match(par)
	if `"`par'"' == `"("' {
		if "`datesok'" == "" {
			gettoken tok3 rest : rest , parse(" ()")

			if "`tok3'" == "" {
				return local rest `"`0'"'
				exit
			}

			capture numlist `"`tok' `tok2' `tok3'"' , min(3) max(3)
			if ! _rc  {
				if `tok' < `tok3' {
					.`log'.Arrpush .`name'.range_ticks ///
						`tok' `tok3' `tok2'
	
					return local rest `"`rest'"'
					exit
				}
			}
		}
		else {
			gettoken tok3 rest : rest , parse(" ()") match(par)

			if "`tok3'" == "" {
				return local rest `"`0'"'
				exit
			}

			capture {
		    		confirm integer number `tok2'
		    		_confirm_number_or_date (`tok')
		    		_confirm_number_or_date (`tok3')
			}
			if !_rc {
				.`log'.Arrpush .`name'.range_ticks ///
					(`tok') (`tok3') `tok2'

				return local rest `"`rest'"'
				exit
			}
		}
	}

	return local rest `"`0'"'				// not a rule
end

// ----------------------------------------------------------------------------
//  numlist [`"label'"] [numlist ["label"]] ...

program NumTextList , rclass

	gettoken log     0 : 0
	gettoken name    0 : 0
	gettoken add     0 : 0
	gettoken rescale 0 : 0
	gettoken custom  0 : 0
	gettoken datesok 0 : 0
	local rest `"`0'"'

	gettoken test : rest
	if ("`test'" == "") local rest

	while `"`rest'"' != `""' {
		gettoken nlist1 rest1 : rest , parse(`)		// either quote
		gettoken nlist2 rest2 : rest , parse(`"""')
		local rc 0
		if `:length local nlist1' < `:length local nlist2' {
			local nlist `nlist1'
			local rest  `"`rest1'"'
		}
		else {
			local nlist `nlist2'
			local rest  `"`rest2'"'
		}
		if "`datesok'" == "" {
			capture numlist `"`nlist'"'		// must have
			local numlist `r(numlist)'		// numlist or #
			local rc = _rc
		}
		else {
			local numlist
			gettoken tok rest2 : nlist , ///
				parse(" ()") match(par1)
			while `"`tok'"' != "" {
				gettoken tok2 : rest2, ///
					parse(" ()") match(par2)
				capture confirm integer number `tok2'
				if "`par2'" == "" | c(rc) {
					if "`par1'" != "" {
						local tok (`tok')
					}
					capture _confirm_number_or_date `tok'
					if _rc {
						local rc = _rc
						continue, break
					}
					local numlist `"`numlist' `tok'"'
				}
				else {
					// parse: date(#)date
					gettoken tok2 rest2: rest2, ///
						parse(" ()") match(par2)
					gettoken tok3 rest2: rest2, ///
						parse(" ()") match(par3)
					capture {
		    				confirm integer number `tok2'
		    				_confirm_number_or_date (`tok')
		    				_confirm_number_or_date (`tok3')
					}
					if c(rc) {
						local rc = _rc
						continue, break
					}
					else {
					.`log'.Arrpush .`name'.range_ticks ///
						(`tok') (`tok3') `tok2'
					}
				}
				gettoken tok rest2 : rest2 , ///
					parse(" ()") match(par1)
			}
		}
		if `rc' {
			di as error `"invalid label specifier, :`0':"'
			exit 198
		}


		if `"`rest'"' != `""' {				// maybe label
			gettoken label : rest, qed(qed)
			if 0`qed' {
				gettoken label rest : rest
				local numlist `"`numlist' `"`label'"'"'
			}
		}
		if `"`numlist'"' != "" {
			local list `"`list' `numlist'"'
		}
	}

	if `"`list'"' != `""' {
		.`log'.Arrpush .`name'.add_ticks `list' , `rescale' `custom'
		if "`add'" == "" {
			.`log'.Arrpush .`name'.set_default 0
		}
	}
end


// ----------------------------------------------------------------------------
program Options , rclass
	gettoken log     0 : 0
	gettoken axisnm  0 : 0
	gettoken ticknm  0 : 0

	local name `axisnm'.style.`ticknm'

	syntax [ , NOTICKs TICKs NOLABels LABELS			///
		   NOSHOWLABels SHOWLABels NOVALuelabels VALuelabels	///
		   ANGle(string) ALTernate ALTGAP(string) STYle(string)	///
		   TSTYle(string) TLength(string)			///
		   TPosition(string) LABGAP(string)			///
		   TLSTYle(string) TLWidth(string)			///
		   TLColor(string) TLPattern(string)			///
		   LABSTYle(string) LABSize(string) LABColor(string)	///
		   LABJustification(string) LABAlignment(string)	///
		   NOPGMGRID PGMGRID					///
		   NOGrid Grid GStyle(string)				///
		   NOGEXtend GEXtend					///
		   NOGMIN GMIN NOGMAX GMAX 				///
		   GLStyle(string) 					///
		   GLWidth(string) GLColor(string)			///
		   GLPattern(string) FORmat(string) AXis(string)	///
		   CUSTOM ]
		   					// axis() ignored

	local set_eds   `"`style'"'		// init tickset style edits
	local tick_eds  `"`tstyle'"'		// init tick    style edits
	local label_eds `"`labstyle'"'		// init label   style edits
	local tline_eds `"`tlstyle'"'		// init tick line style edits
	local grid_eds  `"`gstyle'"'		// init grid style edits
	local gline_eds `"`glstyle'"'		// init grid line style edits


						// ticksetstyle edits
	if "`angle'" != "" {
		local set_eds `"`set_eds' tickangle(`angle')"'
	}
	if "`alternate'" != "" {
		local set_eds `"`set_eds' alternate(yes)"'
	}
	if "`altgap'" != "" {
		local set_eds `"`set_eds' alternate_gap(`altgap')"'
	}
	if "`novaluelabels'" != "" {
		local set_eds `"`set_eds' use_labels(no)"'
	}
	if "`valuelabels'" != "" {
		local set_eds `"`set_eds' use_labels(yes)"'
	}

						// tickstyle edits
	if "`tlength'" != "" {
		local tick_eds `"`tick_eds' length(`tlength')"'
	}
	if "`tposition'" != "" {
		local tick_eds `"`tick_eds' position(`tposition')"'
	}
	if "`labgap'" != "" {
		local tick_eds `"`tick_eds' textgap(`labgap')"'
	}
	if "`noticks'" != "" {
		local tick_eds `"`tick_eds' show_ticks(no)"'
	}
	if "`ticks'" != "" {
		local tick_eds `"`tick_eds' show_ticks(yes)"'
	}
	if "`noshowlabels'`nolabels'" != "" {
		local tick_eds `"`tick_eds' show_labels(no)"'
	}
	if "`showlabels'`labels'" != "" {
		local tick_eds `"`tick_eds' show_labels(yes)"'
	}

						// label textstyle edits
	if "`labsize'" != "" {
		local label_eds `"`label_eds' size(`labsize')"'
	}
	if "`labcolor'" != "" {
		local label_eds `"`label_eds' color(`labcolor')"'
	}
	if "`labjustification'" != "" {
		local label_eds `"`label_eds' horizontal(`labjustification')"'
	}
	if "`labalignment'" != "" {
		local label_eds `"`label_eds' vertical(`labalignment')"'
	}


						// tick linestyle edits
	foreach opt in width color pattern {
		if `"`tl`opt''"' != `""' {
			local tline_eds `"`tline_eds' `opt'(`tl`opt'')"'
		}
	}

						// gridstyle edits
	if "`nogextend'" != `""' {
		local grid_eds `"`grid_eds' extend_low(no)"'
		local grid_eds `"`grid_eds' extend_high(no)"'
	}
	if "`gextend'" != `""' {
		local grid_eds `"`grid_eds' extend_low(yes)"'
		local grid_eds `"`grid_eds' extend_high(yes)"'
	}
	if "`nogmin'" != `""' {
		local grid_eds `"`grid_eds' draw_min(no) force_nomin(yes)"'
	}
	if "`gmin'" != `""' {
		local grid_eds `"`grid_eds' draw_min(yes)"'
	}
	if "`nogmax'" != `""' {
		local grid_eds `"`grid_eds' draw_max(no) force_nomax(yes)"'
	}
	if "`gmax'" != `""' {
		local grid_eds `"`grid_eds' draw_max(yes)"'
	}

						// grid linestyle edits
	if "`glcolor'" != "" {
		local gline_eds `"`gline_eds' color(`glcolor')"'
	}
	if "`glwidth'" != "" {
		local gline_eds `"`gline_eds' width(`glwidth')"'
	}
	if "`glpattern'" != "" {
		local gline_eds `"`gline_eds' pattern(`glpattern')"'
	}

						// grid shown
	if "`nopgmgrid'" != "" {
		.`log'.Arrpush						///
		     .`axisnm'.style.editstyle draw_`ticknm'_grid(no) editcopy
	}
	if "`pgmgrid'" != "" {
		.`log'.Arrpush						///
		     .`axisnm'.style.editstyle draw_`ticknm'_grid(yes) editcopy
	}
	if "`nogrid'" != "" {
		.`log'.Arrpush						///
		     .`axisnm'.style.editstyle draw_`ticknm'_grid(no) editcopy
	}
	if "`grid'" != "" {
		.`log'.Arrpush						///
		     .`axisnm'.style.editstyle draw_`ticknm'_grid(yes) editcopy
	}


						// assemble the big edit

	if `"`tline_eds'"' != `""' {
		local tline_eds `"linestyle(`tline_eds')"'
	}
	if `"`label_eds'"' != `""' {
		local label_eds `"textstyle(`label_eds')"'
	}
	if `"`tick_eds'`tline_eds'`label_eds'"' != `""' {
		local tick_eds `"tickstyle(`tick_eds' `tline_eds' `label_eds')"'
	}

	if `"`gline_eds'"' != `""' {
		local gline_eds `"linestyle(`gline_eds')"'
	}
	if `"`grid_eds'`gline_eds'"' != `""' {
		local grid_eds `"gridstyle(`grid_eds' `gline_eds')"'
	}

						// log the edit
	if "`custom'" == "" {
	    if `"`set_eds'`tick_eds'`grid_eds'"' != `""' {
		local set_eds `ticknm'style(`set_eds' `tick_eds' `grid_eds')
		.`log'.Arrpush .`axisnm'.style.editstyle `set_eds' editcopy
	    }
	}
	else {
	    if `"`set_eds'`tick_eds'"' != `""' {
		.`log'.Arrpush .`axisnm'.`ticknm'.set_custom		///
			\`.`axisnm'.style.`ticknm'style.objkey'		///
			`set_eds' `tick_eds'
	    }
	}

	if `"`format'"' != `""' {			// log the format
		capture local unused : di `format' 1
		if _rc {
			di as error `"invalid format, `format'"'
			exit 198
		}

		.`log'.Arrpush .`axisnm'.`ticknm'.label_format = `"`format'"'
	}

end

exit
