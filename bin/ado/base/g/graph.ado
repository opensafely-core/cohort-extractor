*! version 1.3.4  27mar2019
program graph
	if d(`=c(born_date)') < d(23Jul2004) {
		di as err "your Stata executable is out of date"
		di as err "    type -update executable- at the Stata prompt"
		exit 498
	}

	local ver = string(_caller())

	if      (_caller() < 8.2)  version 8
	else if (_caller() < 10 )  version 8.2
	else			   version 10

	gdi record    = yes			// both for safety
	gdi maybedraw = yes


	if "`._Gr_Global.isa'" == "" {
		._Gr_Global = .global_g.new
	}

	._Gr_Global.callerver = "`ver'"

	capture noisily Graph `0'
	local rc = _rc

	gdi record    = yes			// all three for safety
	gdi maybedraw = yes
	gdi end

	exit `rc'
end

program Graph



	if `"`0'"' == `""' {					
		if `"`.__GRAPHCMD'"' != `""' {
			local 0 `.__GRAPHCMD'			// replay
		}
		else {
			di as error "no existing graph command to replay"
			exit 198
		}
	}

	local orig_cmd `0'

	gettoken do 0 : 0, parse(" ,")
	local orig2 `"`0'"'
	local ldo = length("`do'")

	if "`do'" == bsubstr("draw",1,max(4,`ldo')) { 		// draw/display
		gr_draw_replay `0'
		exit
	}

	if "`do'" == bsubstr("display",1,max(2,`ldo')) { 	// draw/display
		gr_draw_replay `0'
		exit
	}

	if "`do'" == bsubstr("save",1,max(4,`ldo')) { 		// save
		gr_save `0'
		exit
	}

	if "`do'" == bsubstr("use",1,max(3,`ldo')) { 		// use
		gr_use `0'
		exit
	}

	if "`do'" == bsubstr("print",1,max(5,`ldo')) { 		// print
		gr_print `0'
		exit
	}

	if "`do'" == bsubstr("dir",1,max(3,`ldo')) { 		// dir
		gr_dir `0'
		exit
	}

	if "`do'" == bsubstr("describe",1,max(1,`ldo')) { 	// describe
		gr_describe `0'
		exit
	}

	if "`do'" == bsubstr("drop",1,max(4,`ldo')) { 		// drop
		gr_drop `0'
		exit
	}

	if "`do'" == bsubstr("close",1,max(5,`ldo')) { 		// close
		gr_close `0'
		exit
	}

	if "`do'" == bsubstr("rename",1,max(6,`ldo')) { 		// rename
		gr_rename `0'
		exit
	}

	if "`do'" == bsubstr("copy",1,max(4,`ldo')) { 		// copy
		gr_copy `0'
		exit
	}

	if "`do'" == bsubstr("export",1,max(5,`ldo')) { 		// export
		gr_export `0'
		exit
	}

	if "`do'" == bsubstr("query",1,max(1,`ldo')) { 		// query
		gr_query `0'
		exit
	}

	if "`do'" == bsubstr("play",1,max(4,`ldo')) { 		// play
		gr_play `0'
		exit
	}

	if "`do'" == bsubstr("set",1,max(3,`ldo')) { 		// set
		gr_set `0'
		exit
	}

	if "`do'" == bsubstr("replay",1,max(6,`ldo')) { 		// replay
		gr_replay_mult `0'
		exit
	}


	if "`do'" == bsubstr("using",1,max(3,`ldo')) { 		// using
		ErrUsing
		exit 198
	}

	if "`do'" == "addplot" {				// parse addplot
		local subsubcmd `do'
	}
	else {
		gettoken subsubcmd rest : 0 , parse(" ,")
		if "`subsubcmd'" == "addplot" {
			local 0 `"`rest'"'
		}
	}
	local tmp `"`0'"'
	if `"`tmp'"' == `""' & `"`do'"' != "fp" {
		di as error "graph specification required"
		exit 198
	}


						// options handled here
	local my_opts noDRAW NAME(string) 				///
		SCHeme(passthru) COPYSCHeme noREFSCHeme 		///
		XSIZe(passthru)  YSIZe(passthru)			///
		FXSIZe(passthru) FYSIZe(passthru)			///
		BY(string asis) SAVing(string asis)			///
		PLAY(string asis)

						// all options used by any graph
	local graph_opts 						///
		TItle(string) SUBtitle(string) CAPtion(string)		///
		NOTE(string) LEGend(string)				///
		T1title(string) T2title(string) B1title(string)		///
		B2title(string) L1title(string) L2title(string)		///
		R1title(string) R2title(string)				///
		XLabels(string)  YLabels(string)  TLabels(string)	///
		XTICks(string)   YTICks(string)   TTICks(string)	///
		XMLabels(string) YMLabels(string) TMLabels(string)	///
		XMTicks(string)  YMTicks(string)  TMTicks(string)	///
		XOptions(string) YOptions(string)			///
		XTitle(string)   YTitle(string)   TTitle(string)

	_parse expand cmd glob : 0 , common(`my_opts' `graph_opts')

	MergeBy glob_op : , `glob_op'			// multiple by()

	local 0 , `glob_op'				// pull off my options
	syntax [ , `my_opts' * ]
	local glob_op `options'
	if ("`refscheme'" != "norefscheme")	local refscheme refscheme
	else					local refscheme

	local name0 `name'				// name from option

	if "`subsubcmd'" == "addplot" {			// handle edits/addplots
		gr_current name : `name'
		if ! 0`.`name'.isofclass twowaygraph_g' {
			di as error "Graph family `.`name'.classname' does" ///
			    " not support addplot".
			exit 198
		}
		_parse canonicalize full : cmd glob		// canonicalize
		.`name'.addplots `full'
	}
	else {

		local 0 `name'				// handle graph name
		syntax [anything(name=name)] [ , replace ]
		if "`name'" == "" {
			local replace replace
		}

							// handle scheme
		gr_setscheme , `scheme' `copyscheme' `refscheme' 


		_unab_do do : `do'			// build the graph
		if `"`by'"' == `""' {
			if "`do'" == "combine" {
				gr_current name : `name' , newgraph	///
							  `replace' nofree
				tempname tgraph
				_parse canonicalize full : cmd glob	
				.`tgraph' : .`do'graph_g.new `full'

				if (0`.`name'.isofclass graph_g')	///
					class free `name'
				gr_current name : `name' , newgraph `replace'
				.`name' = .`tgraph'.ref
			}
			else if "`do'" != "twoway" {
				gr_current name : `name' , newgraph `replace'
				.`name' : .`do'graph_g.new `orig2'
			}
			else {
				gr_current name : `name' , newgraph `replace'
								// canonicalize
				_parse canonicalize full : cmd glob
				capture noi .`name' : .`do'graph_g.new `full'
				if (_rc == 4023)  InvalidFamily `do'
				else if (_rc)     exit _rc
			}
		}
		else {						// by graph
			gr_current name : `name' , newgraph `replace'

			noisily  .`name' = .bygraph_g.new
			local gb_if `"`glob_if'"'
			local gb_in `"`glob_in'"'
			local gb_op `"`glob_op'"'
			local glob_if 
			local glob_in
			local glob_op
						      // partially canonicalize
			_parse canonicalize full : cmd glob    

			if `"`gb_if'`gb_in'"' == `""' & 0`cmd_n' <= 1 {
				local 0 `full'
				syntax [ anything(equalok) ] [if] [in]	///
				       [aw fw pw] [ , * ]
				local gb_if `if'
				local gb_in `in'
			}
			if "`do'"=="bar" | "`do'"=="hbar" | 		///
			   "`do'"=="box" | "`do'"=="hbox" |		///
			   "`do'"=="dotchart" {
				GetBarCmd full : `orig2'
				local gb_op
			}
			if "`do'" == "pie" {
				GetPieCmd by full : `"`by'"' `orig2'
				local gb_op
			}
			capture noisily .`name'.parse_make `do' `"`by'"'   ///
				`"`gb_if'"' `"`gb_in'"' `"`gb_op'"' `full'
			if (_rc == 4023)  InvalidFamily `do'
			else if (_rc)     exit _rc
		}
		if "`.`name'._scheme.isa'" != "" {
			set curscm `.`name'._scheme.objkey'
		}
	}

	SetFixedSize `name' , `fxsize' `fysize'		// fixed x or y size

	if "`draw'" == "" {				// draw the graph
		.`name'.drawgraph , `xsize' `ysize'
	}

	.`name'.record_header `orig_cmd'		// record header info

	_gs_addgrname `name'				// register graph name

	if `"`play'"' != `""' {
		gr_play `"`play'"'
	}

	if `"`saving'"' != `""' {
//		if "`name0'" == "" {
			gr_save `"`name'"' `saving'
//		}
//		else {
//			version 9: gr_save `"`name'"' `saving'
//		}
	}

	.__GRAPHCMD = `"`orig_cmd'"'			// save cmd for replay

	capture .`name'.ClearEditor			// clear graph editor

	/* capture _cls free __SCHEME  */
		/* just let hang around for now, gr_setscheme will remove when
		 * it needs a new temporary space */
end


program _unab_do
	args domac colon do

	if "`do'" == "2" {
		c_local `domac' twoway
		exit
	}

	local 0 `", `do'"'
	syntax [ , DOTchart MATrix TWoway * ]

	c_local `domac' `dotchart' `matrix' `twoway' `options'
end


program SetFixedSize
	gettoken name 0 : 0

	syntax [ , FYSIZe(real 0) FXSIZe(real 0) ]			// sic
	syntax [ , FYSIZe(string) FXSIZe(string) ]
	
	if `"`fxsize'`fysize'"' == `""' {
		exit
	}

	if "`fxsize'" != "" {
		.`name'.xstretch.set fixed
		.`name'.fixed_xsize = `fxsize'
		.`name'.__LOG.Arrpush .xstretch.set fixed
		.`name'.__LOG.Arrpush .fixed_xsize = `fxsize'
	}

	if "`fysize'" != "" {
		.`name'.ystretch.set fixed
		.`name'.fixed_ysize = `fysize'
		.`name'.__LOG.Arrpush .ystretch.set fixed
		.`name'.__LOG.Arrpush .fixed_ysize = `fysize'
	}
end

// Parse the by() off of the original full command.  This lets the (asis)
// through unscathed.  Also add option allcat.
program GetBarCmd
	gettoken lhs   0 : 0 , parse(" :")
	gettoken colon 0 : 0 , parse(" :")
	// , original command is left in 0

	syntax [anything(equalok)] [aw pw fw] [if] [in] [ , BY(string asis) * ]

	local if0 `"`if'"'
	local in0 `"`in'"'
	if (`"`exp'"' != `""')  local wtopt `"[`weight'`exp']"'

	while `"`by'"' != `""' {
		local 0 `", `options'"'
		syntax [, BY(string asis) * ]
	}


	c_local `lhs' `"`anything' `wtopt' `if0' `in0' , `options' allcat"'
end

program GetPieCmd
	gettoken lhs_by   0 : 0 , parse(" :")
	gettoken lhs_full 0 : 0 , parse(" :")
	gettoken colon    0 : 0 , parse(" :")
	gettoken full_by  0 : 0 , parse(" :")
	// , original command is left in 0

	syntax [anything(equalok)] [aw pw fw] [if] [in] [ ,		///
		SORT BY(string asis) * ]

	local if0 `"`if'"'
	local in0 `"`in'"'
	if (`"`exp'"' != `""')  local wtopt `"[`weight'`exp']"'

	while `"`by'"' != `""' {
		local 0 `", `options'"'
		syntax [, BY(string asis) * ]
	}


	if "`sort'" != "" {
		local hold_opt `"`options'"'
		local 0 `"`full_by'"'
		syntax [varlist] [, *]
		c_local `lhs_by' `"`varlist' , `options' ilegends"'
		local options `"`hold_opt'"'
	}
	else	c_local `lhs_by' `"`full_by'"'

	c_local `lhs_full'	///
	`"`anything' `wtopt' `if0' `in0' , `sort' `options' allcategories"'


end


// Merge multiple by()'s into a single by

program MergeBy
	gettoken resmac 0 : 0
	gettoken colon  0 : 0

	syntax [, BY(string asis) * ]
	while `"`by'"' != `""' {
		ByParts byvlist byopts : `by'

		if "`byvlist'" != "" {
			local byvarlist "`byvlist'"
		}

		if `"`byopts'"' != `""' {
			local byoptions `"`byoptions' `byopts'"'
		}

		local 0 `", `options'"'
		syntax [, BY(string asis) * ]
	}

	if `"`byvarlist'`byoptions'"' == "" {
		c_local `resmac' `"`options'"'
	}
	else {
		if `"`byvarlist'"' == `""' {
			di as error "varlist required in by()"
			exit 100
		}
		c_local `resmac' `"`options' by(`byvarlist', `byoptions')"'
	}
end

program ByParts
	gettoken vlmac  0 : 0
	gettoken optmac 0 : 0
	gettoken colon  0 : 0

	syntax [varlist(default=none)] [, *]

	c_local `vlmac' `varlist'
	c_local `optmac' `options'
end


program InvalidFamily
	args family

	di ""
	di as error in smcl "{cmd:`family'} is not a valid graph subcommand"
	exit 198
end

program ErrUsing

di as error in smcl "{p 0 8}{bf:graph using} is no longer supported; type {bf:graph use}.  If you are trying to use an old format Stata 7 graph, type {bf:graph7 using}.{p_end}"

end
