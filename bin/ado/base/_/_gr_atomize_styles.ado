*! version 1.0.0  07apr2002
program define _gr_atomize_styles
	version 8
	
	syntax [anything(name=name)]

	gr_current name : `name' 

	capture noisily {
		
		StripStyleEdits `name'

		global T_n 0				/* set up globals */
		global T_topname `name'
		.__Map = .null.new

		AtomizeAll `name'
	}
	local rc = _rc

	capture _cls free __Map
	capture mac drop T_topname
	capture mac drop T_n

	if `rc' {
		exit `rc'
	}

end

program define StripStyleEdits
	args name

	tempname nlog
	.`nlog' = {}
	forvalues i = 1/0`.`name'.__LOG.arrnels' {
		local line `.`name'.__LOG[`i']'

		local unused : subinstr local line 		/*
			*/ ".setstyle" "" , count(local ct1)
		local unused : subinstr local line 		/*
			*/ ".remake_as_copy" "" , count(local ct2)

		gettoken att rest : line , parse("=")
		if "`rest'" != "" {
			gettoken tok att : att , parse(".")
			while "`att'" != "" {
				if "`att'" != "" & "`tok'" != "." {
					local nm `nm'.`tok'
				}
				gettoken tok att : att , parse(".")
			}
			local styleed 0`.`name'`nm'.isofclass style'
		}
		else	local styleed 0
		

		if !`ct1'`ct2'`styleed' {
			.`nlog'.Arrpush `line'
		}
	}

	.`name'.__LOG : .`nlog'.ref
end


program define AtomizeAll
	version 8

	args name

	if ! 0`.`name'.isofclass style' {		/* not a style	*/
		RecurseAttribs `name'
		exit
	}

	gettoken unused pushnm : name , parse(".")

	local keynm `.`name'.classname'`.`name'.styledex'		
						/* stylename.<orig_styledex> */

	if "`.__Map.`keynm'.uname'" != "" {	  /* already atomized */
		.`name'.setstyle, style(`.__Map.`keynm'') /* pick up from map */
		.${T_topname}.__LOG.Arrpush 				/*
			*/ `pushnm'.setstyle, style(`.__Map.`keynm'')
		exit
	}
	
	if 0`.`name'.isofclass codestyle' {		/* a code style */
		.${T_topname}.__LOG.Arrpush 				/*
			*/ `pushnm'.setstyle , style(`.`name'.stylename')
	}
	else {						/* remake as atom */
		local newatom _Atom$T_n
		global T_n = $T_n + 1

		.__Map.Declare `keynm' = "`newatom'"	/* maintain map */

		.`name'.remake_as_copy `newatom'		
		.${T_topname}.__LOG.Arrpush `pushnm'.remake_as_copy `newatom'

						/* map both old and new dex */
		local keynm2 `.`name'.classname'`.`name'.styledex'		
		.__Map.Declare `keynm2' = "`newatom'"  

		SetValues `name'
	}

	RecurseAttribs `name'

end

program define RecurseAttribs
	args name
						/* recurse on all attribs */

	foreach attrib_arr in instancemv dynamicmv {
		if 0`.`name'.`attrib_arr'.arrnels' {
			AtomizeArr `name'.`attrib_arr'
		}
	}
end

program define AtomizeArr
	args name

	forvalues i = 1/0`.`name'.arrnels' {
		local attrib `name'[`i']

		if 0`.`attrib'._style_drillable' {
			AtomizeAll `attrib'
		}
		else if "`.`attrib'.isa'" == "array" {
			AtomizeArr `attrib'
		}
	}
end

program define SetValues
	args name


	foreach arr in instancemv dynamicmv {
		local nm `name'.`arr'
		gettoken unused pushnm : nm , parse(".")

		forvalues i = 1/0`.`nm'.arrnels' {
			local attrib `nm'[`i']
			if "`.`nm'[`i'].isa'" == "double" {
				.${T_topname}.__LOG.Arrpush		/*
					*/ `pushnm'[`i'] = `.`nm'[`i']'
			}
			else if "`.`nm'[`i'].isa'" == "string" {
				.${T_topname}.__LOG.Arrpush		/*
					*/ `pushnm'[`i'] = `"`.`nm'[`i']'"'
			}
		}
	}



end
