*! version 1.0.1  16jun2011
program _fr_zyx2legend_parse_and_log , rclass
	gettoken log          0 : 0
	gettoken contour_view 0 : 0

						// allow multiple plegend()
	local 0 `", `0'"'
	syntax [ , PLEGend(string asis) * ]
	local rest `"`options'"'			// in case of null loop

	while `"`plegend'"' != `""' {

		local 0 `", `plegend'"'
		syntax [ ,						///
			POSition(string) RING(string) STYle(string) 	///
			ORDER(string asis)				///
			NOSPAN SPAN * ]

		if `"`style'"' != `""' {		// accept last seen
			local ustyle `style'
		}
		if `"`position'"' != `""' {
			local uposition `position'
		}
		if `"`ring'"' != `""' {
			local uring `ring'
		}
		if `"`order'"' != `""' {
			local uorder `order'
		}
		if `"`nospan'"' != `""' {
			local uspan no
		}
		if `"`span'"' != `""' {
			local uspan yes
		}

		local uoptions `uoptions' (`options')	// collect

		local 0 `", `rest'"'
		syntax [ , PLEGend(string asis) * ]
		local rest `"`options'"'
	}


	if `"`ustyle'"' == `""' {			// default style
		local ustyle scheme
	}

							// style controlled

	if `"`uposition'"' != "" {		// position()
		.style.editstyle zyx2legend_position(`uposition') editcopy
		.`log'.Arrpush .style.editstyle				///
			       zyx2legend_position(`uposition') editcopy
	}
	if 0`.style.zyx2legend_ring.setting' == 0 {	
		local pos on
	}
	else {
		local pos  `.style.zyx2legend_position.relative_position'
		local posd `.style.zyx2legend_position.relative_pos'
	}

	if `"`uring'"' != "" {			// ring()
		.`log'.Arrpush .style.editstyle zyx2legend_ring(`uring') ///
			editcopy
		if `"`uring'"' == `"inside"' {
			local uring 0
		}
		else {
			if `"`uring'"' == `"outside"' {
				local uring 1
			}
		}
	}
	else {
		local uring = `.style.zyx2legend_ring.setting' + 1
	}
	if `"`uring'"' == `"0"' {
		local pos on
	}

	if "`uspan'" != "" {				// handle spanning
		.`log'.Arrpush .style.editstyle zyx2legend_span(`uspan') ///
			editcopy
	}
	else	local uspan `.style.zyx2legend_span.stylename'

	if "`uspan'" == "yes" {
		if "`pos'" != "on" {
			if "`pos'" == "above" | "`pos'" == "below" {
				local span spancols(all) spanfit(left right)
			}
			else {
				local span spanrows(all) spanfit(above below)
			}
		}
	}

							// push view
	if "`.plegend.isa'" == "" {
		.`log'.Arrpush .insert (plegend = .zyx2legend_g.new,	  ///
			view(\`.`contour_view'.objkey') style(`ustyle')) ///
			`pos' plotregion1 , ring(`uring') `span'

		tempname tleg				// too bad, but need
		.`tleg' = .zyx2legend_g.new , style(`ustyle')
		local leg .`tleg'
	}
	else {
		local leg .plegend
	}


	if "`.plegend.isa'" == "" {
						// over-ride box alignment
		.`log'.Arrpush .plegend.style.editstyle 		     ///
		   box_alignment(`.style.zyx2legend_position.compass2style') ///
		       editcopy
	}

	SetLegPos `log' `posd'

	local i 0
	while `++i' < 20 & `"`uoptions'"' != `""' {

		gettoken opts uoptions : uoptions , match(unused) bind
		_fr_area_parse_and_log `log' plegend REGion  , `opts'
		ParseLogOpts  `log' , `r(rest)'
		local titleopts `"`titleopts' `r(rest)'"'
	}

	`leg'.parse_and_log_titles `log' .plegend `titleopts'

	.`log'.Arrpush .plegend.rebuild

						// below run after build
	ParseLogLabel `log' , `r(rest)'

	if `"`uorder'"' != `""' {
		.`log'.Arrpush .plegend.parse_order `uorder'
	}

	local 0 `", `r(rest)'"'
	syntax [, FAKE_OPT_FOR_BETTER_MSG ]

	.`log'.Arrpush .plegend.repositionkeys

	return local rest `"`rest'"'
end



program define PosMap
	args mac color poschar

	if "`poschar'" == "l" {
		c_local `mac' leftof
		exit
	}
	if "`poschar'" == "r" {
		c_local `mac' rightof
		exit
	}
	if "`poschar'" == "t" {
		c_local `mac' above
		exit
	}
	if "`poschar'" == "b" {
		c_local `mac' below
		exit
	}

	c_local `mac' on
end


// ----------------------------------------------------------------------------

program ParseLogOpts , rclass
	gettoken log 0 : 0

	syntax [ , 							///
		NODRAWView DRAWView					///
		ALL STYLEONLY						///
		HOLes(numlist integer >0 max=300) 			///
		TEXTWidth(string)					///
		XOFFSET(real -99999) YOFFSET(real -99999)		///
		STYle(string) 						///
		Rows(numlist integer >0 min=0 max=1)			///
		NOCOLFirst COLFirst					///
		Cols(numlist integer >0 min=0 max=1) 			///
		NOTEXTFirst TEXTFirst NOSTACked STACked 		///
		ROWGap(string asis) COLGap(string asis)			///
		KEYGap(string asis)					///
		SYMPlacement(string)					///
		SYMXsize(string asis) SYMYsize(string asis)		///
		NOFORCESize FORCESize					///
		BMargin(string) BPLACEment(string)			///
		NOBEXpand BEXpand					///
		WIDTH(string) HEIGHT(string)				///
		REVersekey NODRAW DRAW ON OFF				///
		* ]

								// textstyle
	if `"`options'"' != `""' {				
	    _fr_tbstyle_parse_and_log `log' plegend.style labelstyle , `options'
	    return local rest `"`r(rest)'"'			// return
	}

								// View edits
	if "`nodrawview'" != "" {		// sic, drawview and draw differ
		.`log'.Arrpush .plegend.draw_view.set_false
	}
	if "`drawview'" != "" {
		.`log'.Arrpush .plegend.draw_view.set_true
	}
	if "`all'" != "" {
		.`log'.Arrpush .plegend._all = 1
	}
	if "`styleonly'" != "" {
		.`log'.Arrpush .plegend._styleonly = 1
	}
	if `"`textwidth'"' != `""' {
	      .`log'.Arrpush .plegend.labelwidth.editstyle `textwidth' editcopy
	}
	if `xoffset' != -99999 {
		.`log'.Arrpush .plegend.xoffset = `xoffset'
	}
	if `yoffset' != -99999 {
		.`log'.Arrpush .plegend.yoffset = `yoffset'
	}

	.`log'.Arrpush .plegend.holes = "`:list uniq holes'"

								// Style edits
	local eds `style'

	if 0`rows' {
		local eds `"`eds' rows(`rows')"'
	}
	if 0`cols' {
		local eds `"`eds' cols(`cols')"'
	}

	if "`nocolfirst'" != "" {
		local eds `"`eds' col_first(no)"'
	}
	if "`colfirst'" != "" {
		local eds `"`eds' col_first(yes)"'
	}
	if "`notextfirst'" != "" {
		local eds `"`eds' text_first(no)"'
	}
	if "`textfirst'" != "" {
		local eds `"`eds' text_first(yes)"'
	}
	if "`nostacked'" != "" {
		local eds `"`eds' stacked(no)"'
	}
	if "`stacked'" != "" {
		local eds `"`eds' stacked(yes)"'
	}

	if `"`rowgap'"' != `""' {
		local eds `"`eds' row_gap(`rowgap')"'
	}
	if `"`colgap'"' != `""' {
		local eds `"`eds' col_gap(`colgap')"'
	}
	if `"`keygap'"' != `""' {
		local eds `"`eds' key_gap(`keygap')"'
	}

	if `"`symplacement'"' != `""' {
		local eds `"`eds' key_position(`symplacement')"'
	}

	if `"`symxsize'"' != `""' {
		local eds `"`eds' key_xsize(`symxsize')"'
	}
	if `"`symysize'"' != `""' {
		local eds `"`eds' key_ysize(`symysize')"'
	}
	if "`noforcesize'" != "" {
		local eds `"`eds' force_keysize(no)"'
	}
	if "`forcesize'" != "" {
		local eds `"`eds' force_keysize(yes)"'
	}
	if "`reversekey'" != "" {
		local eds `"`eds' reversekey(yes)"'
	}

	if `"`bmargin'"' != `""' {
		local eds `"`eds' boxmargin(`bmargin')"'
	}

	if `"`nobexpand'"' != `""' {
		.`log'.Arrpush .plegend.xstretch.set fixed
	}
	if `"`bexpand'"' != `""' {
		.`log'.Arrpush .plegend.xstretch.set free
	}

	if `"`width'"' != `""' {
		.`log'.Arrpush .plegend.fixed_xsize  = `width'
	}
	if `"`height'"' != `""' {
		.`log'.Arrpush .plegend.fixed_ysize = `height'
	}

	if `"`bplacement'"' != `""' {
		local eds `"`eds' box_alignment(`bplacement')"'
	}

	if "`nodraw'`off'" != `""' {
		local eds `"`eds' force_draw(no)"'
		local eds `"`eds' force_nodraw(yes)"'
	}
	if "`draw'`on'" != `""' {
		local eds `"`eds' force_draw(yes)"'
		local eds `"`eds' force_nodraw(no)"'
	}

	if `"`eds'"' != `""' {
		.`log'.Arrpush .plegend.style.editstyle `eds' editcopy
	}


end


// ----------------------------------------------------------------------------

program ParseLogLabel , rclass
	gettoken log 0 : 0

	syntax [ , LABel(string asis) * ]

	while `"`label'"' != `""' {
		gettoken dex label : label 

		capture confirm integer number `dex'

		if _rc {
			di as error "`dex' not an integer in option label()"
			exit 198
		}

		.`log'.Arrpush .plegend.labels[`dex'] = `"`label'"'

		local 0 `", `options'"'
		syntax [ , LABel(string asis) * ]
	}

	return local rest `"`options'"'
end

// ----------------------------------------------------------------------------

program SetLegPos
	args log posd

	if "`posd'" != "" {
		.`log'.Arrpush .plegend.style.editstyle			///
			myposition(`posd') editcopy
	}

/*
	if "`posd'" == "left" | "`posd'" == "right" {
		.`log'.Arrpush .plegend.style.editstyle	rows(0) editcopy
		.`log'.Arrpush .plegend.style.editstyle	cols(1) editcopy
		.`log'.Arrpush .plegend.style.editstyle	cols(1) editcopy
	}
	else if "`posd'" == "above" | "`posd'" == "below" {
		.`log'.Arrpush .plegend.style.editstyle	rows(1) editcopy
		.`log'.Arrpush .plegend.style.editstyle	cols(2) editcopy
		.`log'.Arrpush .plegend.style.editstyle			///
			labelstyle(box_alignment(center)) editcopy
	}
*/

end

