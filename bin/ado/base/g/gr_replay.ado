*! version 1.1.0  16jul2014
program define gr_replay

	syntax [anything(name=orig)] [, name(string) noDRAW		/*
		*/ SCHeme(passthru) COPYSCHeme REFSCHeme noSTYLEs	/*
		*/ XSIZe(passthru) YSIZe(passthru)			/*
		*/ CMD1(string) CMD2(string) CMD3(string) CMD4(string) 	/*
		*/ CMD5(string) CMD6(string) CMD7(string) CMD8(string) 	/*
		*/ CMD9(string) ]

	
	gr_current orig : `orig'
	gs_stat exists `orig'
	if `"`name'"' != `""' {
		local 0 `name'
		syntax name(name=name) [ , replace ]

		gr_current name : `name' , newgraph `replace'
	}
	gr_setscheme , `scheme' `copyscheme' `refscheme'

capture noisily {
						/* save and replay orig  */
						/* set up globals */
	tempfile logfile
	tempname loghndl holdmap
	global T_loghndl `loghndl'
	file open `loghndl' using `"`logfile'"' , text write

	.__Map = .null.new

	_gs_wrfilehdr `loghndl' `orig'				// file header 

						/* save off the components */
	foreach type in serset scheme graph_g lgrid {
		.`orig'.saveall `type' 1		
	}

	file close `loghndl' 

	if ("`name'"  == "")  local name `orig'

	.`holdmap' = .__Map.ref			/* leave only sersets in map */
	class free __Map
	.__Map = .null.new
	forvalues i = 1/0`.`holdmap'.dynamicmv.arrnels' {
		if "`.`holdmap'.dynamicmv[`i'].classname'" != "serset" &   ///
		   "`.`holdmap'.dynamicmv[`i'].classname'" != "mataserset_g" {
			continue, break
		}
		class nameof `.`holdmap'.objkey' dynamicmv[`i']
		.__Map.Declare `r(name)' = .`holdmap'.dynamicmv[`i'].ref
	}

						/* rebuild the object */
	gr_read `name' `"`logfile'"' 0`="`styles'"!=""' 0`="`scheme'"==""'


} /* end capture noisily */
	local rc = _rc

	capture class free __Map			// clean up
	capture mac drop T_loghndl
	if `rc' {
		exit `rc'
	}

						/* run the cmd`i' s */
	forvalues i = 1/9 {
		if `"`cmd`i''"' == `""' {
			continue, break
		}
		.`name'.`cmd`i''
	}

	if "`draw'" == "" {
		.`name'.drawgraph , `xsize' `ysize'
	}

	_gs_addgrname `name'				// register graph name

end
