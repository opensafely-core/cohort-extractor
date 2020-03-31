*! version 1.1.0  22may2007

// ---------------------------------------------------------------------------
//  Drawing program for the yxview specified in `mytype'.

program _fr_droplines_draw
	args mytype

	local basetype = cond("`.basestyle'" == "" , "line" , "`.basestyle'")
	local switch = 0`.yxswitch'

	if `"`basetype'"' == "area" {
		BaseDraw `basetype' `mytype'
	}

	if `"`.droplines'"' != `""' {
		.style.line.setgdifull

		if `.base' < . {
			local base `.base'
		}
		else {
			if ! `switch' {
				local min = `.`.plotregion'.yscale.curmin'
				local max = `.`.plotregion'.yscale.curmax'
			}
			else {
				local min = `.`.plotregion'.xscale.curmin'
				local max = `.`.plotregion'.xscale.curmax'
			}
			if `min' <= 0 & `max' >= 0 {  
				local base 0
			}
			else {
				local base = cond(`max' < 0 , `max' , `min')
			}
		}

		if ! `switch' {
			foreach xy in `.droplines' {
				gettoken x y : xy
				gdi line `x' `base' `x' `y'
			}
		}
		else {
			foreach xy in `.droplines' {
				gettoken y x : xy
				gdi line `base' `y' `x' `y'
			}
		}
	}

	if `"`basetype'"' != "area" {
		BaseDraw `basetype' `mytype'
	}

end

program BaseDraw
	args basetype mytype

	capture noisily {
		.type.setstyle , style(`basetype')
		.draw
	}
	local rc = _rc
	.type.setstyle , style(`mytype')
	if `rc' {
		exit `rc'
	}
end

exit
