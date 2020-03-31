*! version 1.0.1  24jan2018

/*
	lmbuild <libname>, <options> <notdocumented_options>

	    <libname> may be specified w/ or w/o -.mlib- extension. 

	    <options>:
			new      build new library (default)
			replace  replace existing library
			add      add  to existing library 

			dir(PERSONAL|SITE|.|<dirname>)

	    <notdocumented_options>:

			createdir
			debug

	Directory PERSONAL is the default if -dir()- not specified.
	Directory PERSONAL is created if necessary. 
	Other directories must already exist. 

	-createdir- causes dir(<dirname>) to create the directory path 
	if necessary.  It is for use in certification scripts. 

	-debug- causes a trace of the execution of the recursive mkdir 
	routine. 

	THIS ADO FILE CANNOT USE MATA FUNCTIONS!
        The purpose of -lmbuild- is to write the Mata functions currently
	in memory to a .mlib library.  Mata functions in the ado-file 
	would not be a problem; they are properly hidden.  The problem is 
	that execution of them may cause additional library functions 
	to be loaded, and those functions are exposed and so would be 
	placed in the library. 
*/

program lmbuild 
	version 13  // sic

	capture noi ///
		syntax anything(id="libname") ///
			[, NEW REPLACE ADD DIR(string) SIZE(string) ///
			   CREATEDIR DEBUG]

	if (_rc) {
		local rc = _rc
		exit `rc'
		/*NOTREACHED*/
	}

	local debug = ("`debug'"!="")

	local createdir = cond("`createdir'"!="", 1, 0)

	local anything = subinstr(`"`anything'"', "\", "/", .)
	local      dir = subinstr(`"`dir'"',   "\", "/", .)

	proc_libname         libname : `"`anything'"'
	proc_replace_options     how : "`new'`replace'`add'"
	proc_dir_option          dir : `"`dir'"' "`createdir'" "`debug'"
	proc_size_option	size : `"`size'"' `"`how'"'

	tempfile temppath 
	get_tempfilename tempfn : `"`temppath'"'
	local tempfn `"l`tempfn'"'

	capture noisily ///
		xeq `"`libname'"' "`how'" `"`dir'"' `"`tempfn'"' "`size'"
	nobreak {
		local rc = _rc
		capture erase `"`tempfn'.mlib"'
	}
	exit `rc'
end

/* -------------------------------------------------------------------- */ 
					/* input processing		*/

program proc_libname
	args macro colon fn

	if (`"`fn'"'=="") {
		di as err "invalid {it:libname}"
		exit 198
	}

	if (strpos(`"`fn'"', "/")) { 
		di as err "invalid {it:libname}" 
		exit 198
	}

	if (substr(`"`fn'"', 1, 1) != "l") {
		di as err "invalid {it:libname}"
		di as err "{p 4 4 2}"
		di as err "{it:libname} must begin with the letter {bf:l}."
		di as err "Specify {it:libname} with or without the"
		di as err "{bf:.mlib} extension."
		di as err "{p_end}"
		exit 198
	}

	get_file_extension sfx : `"`fn'"'
	if (`"`sfx'"' == ".mlib") {
		local fn = substr(`"`fn'"', 1, strlen(`"`fn'"')-5)
	}
	else if (`"`sfx'"' != "") {
		di as err "invalid {it:libname}"
		di as err _column(4) "{it:libnames} must end in {bf:.mlib}."
		exit 198
	}
	c_local `macro' `"`fn'"'
end


program proc_replace_options
	args macro colon ops

	if ("`ops'"=="new" | "`ops'"=="replace" | "`ops'"=="add") {
		c_local `macro' `ops'
		exit
	}
	if ("`ops'"=="") {
		c_local `macro' new
		exit
	}

	di as err "too many options"
	di as err "{p 4 4 2}"
	di as err "Only one of {bf:new}, {bf:replace}, or {bf:add}"
	di as err "may be specified."
	di as err "{p_end}"
	exit 198
end


program proc_dir_option
	args macro colon dir createdir debug

	if (`"`dir'"'=="" | `"`dir'"'=="PERSONAL") {
		path_usable_form  dir : `"`c(sysdir_personal)'"'
		recursive_mkdir         `"`dir'"' 1 `debug'
	}
	else if (`"`dir'"' == "SITE") {
		path_usable_form dir : `"`c(sysdir_site)'"'
	}
	else {
		path_usable_form dir : `"`dir'"'
		if (`createdir') {
			recursive_mkdir `"`dir'"' 1 `debug'
		}
	}
	add_trailing_slash dir : `"`dir'"'

	assert_dir_exists  `"`dir'"'
	c_local `macro' `"`dir'"'
end

program get_tempfilename
	args macro colon tempfile

	local n = subinstr(`"`tempfile'"', "\", "/", .)
	local n = strreverse(`"`n'"')
	local l = strpos(`"`n'"', "/")
	if (`l') {
		local n = substr(`"`n'"', 1, `l'-1)
	}
	local n = strreverse(`"`n'"')
	local n = subinstr(`"`n'"', ".", "_", .)
	c_local `macro' `"`n'"'
end

program proc_size_option
	args macro dir size how

	if ("`size'"=="") {
		c_local `macro'
		exit
	}

	if (c(stata_version)<14) {
		di as err "option {bf:size()} not allowed"
		di as err "{p 4 4 2}"
		di as err "{bf:lmbuild} does not allow the option"
		di as err "with Stata 13."
		di as err "{p_end}"
		exit 198
		/*NOTREACHED*/
	}

	if ("`how'"!="new" & "`how'"!="replace") {
		di as err "option {bf:size()} not allowed"
		di as err "{p 4 4 2}"
		di as err "{bf:size()} may only be used with"
		di as err "{bf:lmbuild new} and {bf:lmbuild replace}."
		di as err "{p_end}"
		exit 198
		/*NOTREACHED*/
	}

	capture confirm integer number `size'
	if (_rc==0) {
		if (`size'>=2 & `size'<=2048) {
			c_local `macro' ", size(`size')"
			exit
			/*NOTREACHED*/
		}
	}

	di as err "option {bf:size()} invalid"
	di as err "{p 4 4 2}"
	di as err "{bf:size(}{it:#}{bf:)} specifies the maximum"
	di as err "number of functions that can be stored in the"
	di as err "library.  The default is {bf:size(1024)}, meaning"
	di as err "1024 functions.  The allowed range is 2 to 2048."
	di as err "{p_end}"
	exit 198
	/*NOTREACHED*/
end

					/* input processing		*/
/* -------------------------------------------------------------------- */ 

/* -------------------------------------------------------------------- */ 
					/* execution 			*/
program xeq 
	args lib how dir tlib sizeoption

	/*
	     Variable     example             comment
	     -----------------------------------------------------------
	     how          new                 new|add|replace

	     dir          ~/ado/per/          directory of user's library
	     lib          ltry                name of user's library
	     tlib         lSt013_03           name of temporary library

             f_tlib       lSt013_03.mlib      full path of tlib
	     f_lib        ~/ado/per/ltry.mlib full path of libname

	     p_flib       ~\ado/per\ltry.mlib or
                          ~/ado/per/ltry.mlib

	     -----------------------------------------------------------
	     Note:  dir has an ending forward slash.
	*/


	local f_tlib  = `"`tlib'.mlib"'
	local f_lib   = `"`dir'`lib'.mlib"'

	path_printable_form pf_lib : `"`f_lib'"'

	/*
	di `"  1 lib  |`lib'|"'
	di `"  2 how  |`how'|"'
	di `"  3 dir  |`dir'|"'
	di `"  4 tlib |`tlib'|"'
	di `"  5 size |`sizeoption'|"'

	di `"  f_lib  |`f_lib'|"'
	di `"  f_tlib |`f_tlib'|"'
	*/

	if ("`how'"=="new") {
		assert_library_notfound `"`f_lib'"'

		quietly mata: mata mlib create `tlib' `sizeoption'
		        mata: mata mlib    add `tlib' *()
		nobreak {
			copy `"`f_tlib'"' `"`f_lib'"', public
			di as txt `"new library {bf:`pf_lib'} created"'
			erase `"`f_tlib'"'
		}
		quietly mata: mata mlib index
		exit
		/*NOTREACHED*/
	}

	if ("`how'" == "add") {
		assert_library_exists `"`f_lib'"'

		copy `"`f_lib'"' `"`f_tlib'"'
		mata: mata mlib add `tlib' *()

		nobreak {
			erase `"`f_lib'"'
			copy `"`f_tlib'"' `"`f_lib'"', public
			di as txt `"existing library {bf:`pf_lib'} updated"'
			erase `"`f_tlib'"'
		}
		exit
		/*NOTREACHED*/
	}

	if ("`how'"=="replace") {
		capture confirm file `"`f_lib"'
		local libexists = (_rc==0)

		quietly mata: mata mlib create `tlib' `sizeoption'
		        mata: mata mlib    add `tlib' *()
		nobreak {
			if (`libexists') {
				erase `"`f_lib'"'
			}
			copy `"`f_tlib'"' `"`f_lib'"', public 
			erase `"`f_tlib'"'

			if (`libexists') {
				di as txt ///
				`"existing library {bf:`pf_lib'} replaced"'
			}
			else {
				di as txt ///
				`"new library {bf:`pf_lib'} created"'
			}
		}
		if (!`libexists') {
			quietly mata: mata mlib index
		}
		exit
		/*NOTREACHED*/
	}

	/*NOTREACHED*/
	error(9) 
end

					/* execution 			*/
/* -------------------------------------------------------------------- */ 


/* -------------------------------------------------------------------- */ 
					/* filename & path  utilities	*/

program path_printable_form
	args macro colon path

	if (c(os)=="Windows") {
		local ppath = subinstr(`"`path'"', "/", "\", .)
		c_local `macro' `"`ppath'"'
	}
	else {
		c_local `macro' `"`path'"'
	}
end

program path_usable_form
	args macro colon path

	if (c(os)=="Windows") {
		local upath = subinstr(`"`path'"', "\", "/", .)
		c_local `macro' `"`upath'"'
	}
	else {
		c_local `macro' `"`path'"'
	}
end

program remove_trailing_slashes 
	args  clean colon dir

	while (substr(`"`dir'"', -1, 1)=="/") {
		local l   = strlen(`"`dir'"')
		local dir = substr(`"`dir'"', 1, `l'-1) 
	}
	c_local `clean' `"`dir'"'
end

program add_trailing_slash 
	args  result colon dir

	local l = strlen(`"`dir'"')
	if (substr(`"`dir'"', `l', 1)!="/") {
		local dir = `"`dir'"' + "/"
	}
	c_local `result' `"`dir'"'
end

program get_file_extension 
	args macro colon fn

	local rfn = strreverse(`"`fn'"')
	local   l = strpos(`"`rfn'"', ".")
	if (`l') {
		local sfx = strreverse(substr(`"`rfn'"', 1, `l'))
		c_local `macro' `"`sfx'"'
	}
	else {
		c_local `macro' ""
	}
end

					/* filename & path  utilities	*/
/* -------------------------------------------------------------------- */ 


/* -------------------------------------------------------------------- */ 
					/* file & dir utilities		*/


program assert_library_exists
	args libpath

	capture confirm file `"`libpath'"'
	if (_rc==0) {
		exit
	}
	path_printable_form plibpath : `"`libpath'"'

	di as err `"library `plibpath' not found"'
	exit 601
end

program assert_library_notfound
	args libpath

	capture confirm file `"`libpath'"'
	if (_rc) {
		exit
	}

	path_printable_form plibpath : `"`libpath'"'

	di as err `"library `plibpath' already exists"'
	di as err "{p 4 4 2}"
	di as err "Specify option {bf:add} to add members to the"
	di as err "existing library, or specify option {bf:replace}."
	di as err "{p_end}"
	exit 602
end


program whether_dir_exists
	args macro colon dir

	local curdir = c(pwd)
	nobreak {
		capture cd `"`dir'"'
		local rc = _rc
		local result = (_rc==0)
		quietly cd `"`curdir'"'
	}
	c_local `macro' `result'
end


program assert_dir_exists 
	args dir

	whether_dir_exists exists : `"`dir'"'
	if (`exists') {
		exit
	}
	di as err `"directory `dir' does not exist"'
	exit 601
end


program recursive_mkdir
	args	dir firstcall debug

	/* 
		1st call is    recursive_mkdir "`"`dir'"'" 1 0|1
	*/

	if (`debug') {
		di `"mmd BEGIN "`dir'" `firstcall'"'
	}

	/* ------------------------------------------------------------ */
	if (`firstcall') {
		path_usable_form  d : `"`dir'"'
	}
	else {
		local d = `"`dir'"'
	}

	/* ------------------------------------------------------------ */
					/* done if dir exists		*/

	whether_dir_exists exists : `"`d'"'
	if (`exists') {
		if (`debug') {
			di `"    mmd "`d'" exists"
			di `"mmd END"'
		}
		exit
	}
		
	/* ------------------------------------------------------------ */
					/* simple case if no slashes	*/

	remove_trailing_slashes d : `"`d'"'

	local l = strpos(`"`d'"', "/") 
	if (`l'==0) { 
		if (`debug') {
			di `"    mmd mkdir "`d'" (no slashes case)"'
			di `"mmd END"'
		}
		mkdir `"`d'"'
		exit
	}

	/* ------------------------------------------------------------ */
					/* recursive case if slashes	*/

	/* 
	    Example 1:
		d  = /a/b   we want 
		d1 = /a/
		d2 = b
			d = /a

	    Example 2:
		d  = c:/a/b 
		d1 = c:/a/
		d2 = b
			d  = c:/a
			d1 = c:/
			d2 = a

	    Example 3:
		d  = /a//b
		d1 = /a//
		d2 = b
			d = /a 
			d1 = /
			d2 = a

	    Example 4:
		d  = //dublin/a/b
		d1 = //dublin/a/
		d2 = b
			d  = //dublin/a
			d1 = //dublin/
			d2 = a
				d = //dublin
				d1 = //
				d2 = dublin
	*/

					/* split into d1 and d2 	*/
					/* recurse to make d1		*/
					/* finally make d2		*/

	local r  = strreverse(`"`d'"')
	local l  = strpos(`"`r'"', "/")
	local d1 = strreverse(substr(`"`r'"', `l',     .))
	local d2 = strreverse(substr(`"`r'"',  1 , `l'-1))

	if (`debug') {
		di `"    mmd d1 = "`d1'""'
		di `"    mmd d2 = "`d2'""'
		di `"    mmd RECURSE using d1="`d1'""'
	}
				
	recursive_mkdir `"`d1'"' 0 `debug'
	if (`debug') {
		di `"    mmd back from recursion, d1 and d2 are again"'
		di `"    mmd d1 = "`d1'""'
		di `"    mmd d2 = "`d2'""'
		di `"    mmd mkdir "`d1'`d2'""'
	}
	mkdir `"`d1'`d2'"'
	if (`debug') {
		di `"mmd END"'
	}
end

					/* file & dir utilities		*/
/* -------------------------------------------------------------------- */ 

