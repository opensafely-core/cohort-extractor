*! version 1.0.1  11jul2017

// Parses options for an areastyle and posts those edits to the specified log.
//
// Option marginonly specifies that only the margin option is recognized,
// though all other options are allowed.


program _fr_area_parse_and_log , rclass
	gettoken log       0 : 0
	gettoken object    0 : 0
	gettoken parseopt  0 : 0

	local opt = lower("`parseopt'")

	syntax [ , `parseopt'(string) * ]

	while `"``opt''"' != `""' {
		_fr_area_parse_and_log_once `log' "`object'" , ``opt''

		local 0 `", `options'"'
		syntax [ , `parseopt'(string) * ]
	}

	return local rest `"`options'"'
end


program _fr_area_parse_and_log_once
	gettoken log    0 : 0
	gettoken object 0 : 0

	syntax [ , STYle(string)        ISTYle(string)		///
		   LStyle(string)	ILStyle(string)		///
		   LColor(string)	ILColor(string)		///
		   LWidth(string)	ILWidth(string)		///
		   LPattern(string)	ILPattern(string)	///
		   LAlign(string)	ILAlign(string)		///
		   SHADEStyle(string)	ISHADEStyle(string)	///
		   FColor(string)	IFColor(string)		///
		   Color(string)        IColor(string)		///
		   INTENsity(string)    IINTENsity(string)		///
		   Margin(string)	MARGINONLY ]

	local obox_eds  `"`style'"'
	local ibox_eds  `"`istyle'"'
	local oline_eds `"`lstyle'"'
	local iline_eds `"`ilstyle'"'
	local ofill_eds `"`shadestyle'"'
	local ifill_eds `"`ishadestyle'"'

	foreach opt in color width pattern align {
		if `"`l`opt''"' != `""' {
			local oline_eds `"`oline_eds' `opt'(`l`opt'')"'
		}
		if `"`il`opt''"' != `""' {
			local iline_eds `"`iline_eds' `opt'(`il`opt'')"'
		}
	}

	if `"`color'"' != `""' {
		local oline_eds `"`oline_eds' color(`color')"'
		local ofill_eds `"`ofill_eds' color(`color')"'
	}
	if `"`icolor'"' != `""' {
		local iline_eds `"`iline_eds' color(`icolor')"'
		local ifill_eds `"`ifill_eds' color(`icolor')"'
	}

	if `"`fcolor'"' != `""' {
		local ofill_eds `"`ofill_eds' color(`fcolor')"'
	}
	if `"`ifcolor'"' != `""' {
		local ifill_eds `"`ifill_eds' color(`ifcolor')"'
	}

	if `"`intensity'"' != `""' {
		local ofill_eds `"`ofill_eds' intensity(`intensity')"'
	}
	if `"`iintensity'"' != `""' {
		local ifill_eds `"`ifill_eds' intensity(`iintensity')"'
	}

	if `"`oline_eds'"' != `""' {
		local obox_eds `"`obox_eds' linestyle(`oline_eds')"'
	}
	if `"`iline_eds'"' != `""' {
		local ibox_eds `"`ibox_eds' linestyle(`iline_eds')"'
	}

	if `"`ofill_eds'"' != `""' {
		local obox_eds `"`obox_eds' shadestyle(`ofill_eds')"'
	}
	if `"`ifill_eds'"' != `""' {
		local ibox_eds `"`ibox_eds' shadestyle(`ifill_eds')"'
	}

	if "`object'" != "" {
		local obj "`object'."
	}

	if "`marginonly'" == "" {
	    if `"`obox_eds'"' != `""' {
		.`log'.Arrpush	///
		    .`obj'style.editstyle boxstyle(`obox_eds') editcopy
	    }
	    if `"`ibox_eds'"' != `""' {
		.`log'.Arrpush	///
		    .`obj'style.editstyle inner_boxstyle(`ibox_eds') editcopy
	    }
	}
	if `"`margin'"' != `""' {
		.`log'.Arrpush .`obj'style.editstyle margin(`margin') editcopy
	}
	

end
