*! version 1.0.0  11feb2011
program _fr_clegend_parse_and_log , rclass
	gettoken log          0 : 0
	gettoken contour_view 0 : 0

						// allow multiple clegend()
	local 0 `", `0'"'
	syntax [ , CLEGend(string asis) * ]
	local rest `"`options'"'			// in case of null loop

	while `"`clegend'"' != `""' {

		local 0 `", `clegend'"'
		syntax [ ,						///
			POSition(string) RING(string) STYle(string) 	///
			NOSPAN SPAN ALTAXIS * ]

		if `"`style'"' != `""' {		// accept last seen
			local ustyle `style'
		}
		if `"`position'"' != `""' {
			local uposition `position'
		}
		if `"`ring'"' != `""' {
			local uring `ring'
		}
		if `"`nospan'"' != `""' {
			local uspan no
		}
		if `"`span'"' != `""' {
			local uspan yes
		}
		if `"`altaxis'"' != `""' {
			local ualtaxis `altaxis'
		}

		local uoptions `uoptions' (`options')	// collect

		local 0 `", `rest'"'
		syntax [ , CLEGend(string asis) * ]
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
		local uring `.style.zyx2legend_ring.setting'
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
	if "`.clegend.isa'" == "" {
		.`log'.Arrpush .insert (clegend = .clegend_g.new,	///
			`ualtaxis' view(\`.`contour_view'.objkey')	///
			style(`ustyle'))				///
			`pos' plotregion1 , ring(`uring') `span'

		tempname tleg				// too bad, but need
		.`tleg' = .clegend_g.new , style(`ustyle')
		local leg .`tleg'
	}
	else {
		local leg ".clegend"
	}


	if "`.clegend.isa'" == "" {
						// over-ride box alignment
		.`log'.Arrpush .clegend.style.editstyle 		     ///
		   box_alignment(`.style.zyx2legend_position.compass2style') ///
		       editcopy
	}

	SetLegPos `log' `posd'

	local i 0
	while `++i' < 20 & `"`uoptions'"' != `""' {

		gettoken opts uoptions : uoptions , match(unused) bind
		_fr_area_parse_and_log `log' clegend REGion  , `opts'
		ParseLogOpts  `log' , `r(rest)'
		local titleopts `"`titleopts' `r(rest)'"'
	}

	`leg'.parse_and_log_titles `log' .clegend `titleopts'

	.`log'.Arrpush .clegend.plotregion1.reset_scales
	.`log'.Arrpush .clegend.SetFixedDim

	.`log'.Arrpush .zaxis1.ref = .clegend.zaxis.ref

	local 0 `", `r(rest)'"'
	syntax [, FAKE_OPT_FOR_BETTER_MSG ]

	return local rest `"`rest'"'
end



// ----------------------------------------------------------------------------

program ParseLogOpts , rclass
	gettoken log 0 : 0

	syntax [ , 							///
		NODRAWView DRAWView					///
		XOFFSET(real -99999) YOFFSET(real -99999)		///
		STYle(string) 						///
		NOFORCESize FORCESize					///
		BMargin(string) BPLACEment(string)			///
		NOBEXpand BEXpand					///
		WIDTH(string) HEIGHT(string)				///
		NODRAW DRAW ON OFF					///
		* ]

								// textstyle
	if `"`options'"' != `""' {				
	    _fr_tbstyle_parse_and_log `log' clegend.style labelstyle , `options'
	    return local rest `"`r(rest)'"'			// return
	}

								// View edits
	if "`nodraw'" != "" | "`off'" != "" {
		.`log'.Arrpush .clegend.draw_view.set_false
	}
	if "`draw'" != "" | "`on'" != "" {
		.`log'.Arrpush .clegend.draw_view.set_true
	}
	if `xoffset' != -99999 {
		.`log'.Arrpush .clegend.xoffset = `xoffset'
	}
	if `yoffset' != -99999 {
		.`log'.Arrpush .clegend.yoffset = `yoffset'
	}

								// Style edits
	local eds `style'

	if `"`bmargin'"' != `""' {
		local eds `"`eds' boxmargin(`bmargin')"'
	}

	if `"`nobexpand'"' != `""' {
		.`log'.Arrpush .clegend.xstretch.set fixed
	}
	if `"`bexpand'"' != `""' {
		.`log'.Arrpush .clegend.xstretch.set free
	}

	if `"`width'"' != `""' {
		local eds `"`eds' width(`width')"'
	}
	if `"`height'"' != `""' {
		local eds `"`eds' height(`height')"'
	}

	if `"`bplacement'"' != `""' {
		local eds `"`eds' box_alignment(`bplacement')"'
	}

	if `"`eds'"' != `""' {
		.`log'.Arrpush .clegend.style.editstyle `eds' editcopy
		.`log'.Arrpush .clegend.SetFixedDim
	}

end


// ----------------------------------------------------------------------------

program SetLegPos
	args log posd

	if "`posd'" != "" {
		.`log'.Arrpush .clegend.style.editstyle			///
			myposition(`posd') editcopy
	}

end

