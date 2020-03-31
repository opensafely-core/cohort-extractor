*! version 1.0.2  27sep2007
program define gr_read
	version 8
	args name filenm nostyles use_schemes 

	_addgph filenm : `"`filenm'"'

	tempname loghndl redo
	file open `loghndl' using `"`filenm'"' , text read

	
	_gs_rdfilehdr `"`filenm'"' `loghndl'
						// ignore version for now

	/*
	.`redo' = {}					/* empty array */ 
	*/

capture noisily {
	._Gr_Cglobal.reading = 1
	global T_useschemes 0`use_schemes'
	global T_nostyles = 0`nostyles'

					/* find and process <BeginItem>'s */
	local fileloc 0
	file read `loghndl' line
	while r(eof) == 0 {
		DoItem rc : 0`use_schemes' `loghndl' `line'

		/*
		if `rc'== 9898 {
			.`redo'[`.`redo'.arrnels'+1] = `fileloc'
		}
		*/
		if `rc' {
			di in red "error (`rc') reading file"
		}

		file seek `loghndl' query
		local fileloc `r(loc)'

		file read `loghndl' line
	}

/* ( assuming no need to redo
				/* this is unlikely if not impossible */
	local ct 1
	local redoing 1			
	while `redoing' {
		local redoing 0

		forvalues i = 1/`.`redo'.arrnels' {
			if `redo'[`i'] == -1 {
				continue
			}

			file seek `redo'[`i']
			file read `loghndl' line

			DoItem rc : `loghndl' `line'

			if `rc' == 9898 {
				local redoing 1		/* still redoing */
			}
			else if `rc' {
				di in red "2: error (`rc') reading file"
			}
			else	`redo'[`i'] = -1	/* read OK */
		}

di in white "Items saved out of order; recreating.  level = `ct++'"
	}
end redo ) */

} /* end capture */
local rc = _rc

	._Gr_Cglobal.reading = 0
	capture mac drop T_useschemes
	capture mac drop T_nostyles

	file close `loghndl'

				      /* assign final object created to name */
	if 0`.__Map.dynamicmv.arrnels' {
		.`name'.ref = .__Map.dynamicmv[`.__Map.dynamicmv.arrnels'].ref
		.`name'.gversion   = ._Gr_Cglobal.gversion
		.`name'.clsversion = ._Gr_Cglobal.clsversion
	}

	exit `rc'

end

program define DoItem

	gettoken rcmac       line : 0		/* local for return code    */
	gettoken colon       line : line	/* :  (separator)	    */
	gettoken use_schemes line : line	/* use item's own schemes   */
	gettoken loghndl     line : line	/* log file handle and line */

	tokenize `"`line'"'
	args id class origkey scheme_tag scheme_key
	if "`id'" != "<BeginItem>" {				/* error */
		di in red "Error in file, skipping lines:"
	}
	while "`id'" != "<BeginItem>" & r(eof) == 0  {
		di in red `"`line'"'
		file read `loghndl' line
		tokenize `"`line'"'
		args id class origkey scheme_tag scheme_key
	}

	local rc 0

	if "`.__Map.`origkey'.isa'" != "" {
								/* skip item */
		while "`id'" != "<EndItem>" & r(eof) == 0  {
			file read `loghndl' line
			gettoken id : line
		}
		/*
		di in red "Error in file, item `origkey' of class "   /*
			*/ "`class' already created".
		*/
	}
	else {
		if 0`use_schemes' {
			if "`scheme_tag'" == "<UseScheme>" {
				set curscm `.__Map.`scheme_key'.objkey'
			}
		}
		else {
			if "`class'" == "scheme" {		// skip
				while "`id'" != "<EndItem>" & r(eof) == 0  {
					file read `loghndl' line
					gettoken id : line
				}
				c_local `rcmac' 0
				exit				// Exit
			}
		}

		capture noi .__Map.Declare `origkey' = .`class'.new ,	/*
				*/ readlog(`loghndl')
		local rc = _rc
	}

	c_local `rcmac' `rc'
end
