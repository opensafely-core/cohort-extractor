*! version 1.0.1  15oct2019
program define gr_table
	version 8

	syntax anything(name=gphlist id="graph list") [ , 		/*
		*/ COPIES noDRAW REPLACE				/*
		*/ COLFirst ROWFirst					/*
		*/ Cols(numlist integer >0 min=0 max=1) 		/*
		*/ Rows(numlist integer >0 min=0 max=1) 		/*
		*/ SCHeme(passthru) COPYSCHeme REFSCHeme 		/*
		*/ COMMONscheme noSTYLEs 				/*
		*/ XSIZE(passthru) YSIZE(passthru) ]

// consider allowing  anylist to contain paren bound strings that are 
// expanded to their views or write another table where all new objects are 
// that way
	if 0`cols' & 0`rows' {
		di as error "options {bf:rows()} and {bf:cols()} may not be specified together"
		exit 198
	}
	if "`colfirst'" != "" & "`rowfirst'" != ""  {
		di as error "options {bf:rowfirst} and {bf:colfirst} may not be specified together"
		exit 198
	}

	if "`commonscheme'`nostyles'" != "" {		/* implies copies */
		local copies copies
	}

	local cfirst = "`colfirst'" != ""

	gettoken newname gphlist : gphlist

							/* check names */
	foreach graph of local gphlist {
		if ! 0`.`graph'.isofclass view' {
			di as error "`graph' is not a view"
			exit 198
		}
	}

							/* set current graph */
	gr_current newname : `newname' , newgraph `replace'	
	gr_setscheme , `scheme' `copyscheme' `refscheme'

	if "`commonscheme'" != "" {			/* common schemes */
		local gscm scheme(`.`c(curscm)'.objkey') refscheme
	}

							/* set locations */
	local n `:word count `gphlist''

	if 0`cols' {
		local rows    = 1 + int((`n' - 1) / `cols')
	} 
	else if 0`rows' {
		local cols = 1 + int((`n' - 1) / `rows')
	}
	else {
		local r = sqrt(`n')
		local cols = int(`r') + ((`r' - int(`r')) > .01)
		local rows = 1 + int((`n' - 1) / `cols')
	}

	.`newname' = .lgrid.new				/* place graphs */

	local r `rows'
	local c 1

	tempname gphcpy
	if `cfirst' {
	    foreach graph of local gphlist {
	    	if "`copies'" == "" {
	        	.`newname'.insert (`graph' = .`graph'.ref) at `r--' `c'
		}
		else {
			gr_replay `graph' , copy(`gphcpy') nodraw 	/*
				*/ `nostyles' `gscm'
	        	.`newname'.insert (`graph' = .`gphcpy'.ref) at `r--' `c'
		}
		if `r' == 0 {
		    local r `rows'
		    local `c++'
		}
	    }
	}
	else {
	    foreach graph of local gphlist {
	    	if "`copies'" == "" {
			.`newname'.insert (`graph' = .`graph'.ref) at `r' `c++'
		}
		else {
			gr_replay `graph' , copy(`gphcpy') nodraw 	/*
				*/ `nostyles' `gscm'
			.`newname'.insert (`graph' = .`gphcpy'.ref) at `r' `c++'
		}
		if `c' > `cols' {
			local c 1
			local `r--'
		}
	    }
	}

	gr_current newname : `newname' 		/* must reset if copies made */

	if "`draw'" == "" {					/* draw */
		.`newname'.drawgraph , `xsize' `ysize'
	}

end

exit
