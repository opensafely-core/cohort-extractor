*! version 1.1.7  09sep2019
program define gr_use
	version 10

	syntax anything(name=filenm id=file) [ , * ]
	local 0 `", `options'"'

	local filenm0 `filenm'
	capture gs_fileinfo `filenm' , suffix
	local filenm `"`r(fn)'"'

	if "`r(ft)'" == "old"  {			// old format graph
		syntax [, FAKE_OPT_FOR_BETTER_MSG ]
		graph7 using `"`filenm'"'
		exit
	}

	if "`r(ft)'" == "asis"  {			// asis graph
		syntax [, FAKE_OPT_FOR_BETTER_MSG ]
		_asis use `"`filenm'"'
		exit
	}

	if "`r(ft)'" != "live"  {
		gs_fileinfo `"`filenm0'"' , suffix
		exit 198
	}

							// live graph

	nobreak {
		mata: st_local("filenm", __filemkabsolute(`"`filenm'"'))
	}

	syntax [ , Name(string) SCHeme(passthru) REFSCHeme		///
		   PLAY(string asis) noSTYLEs noDRAW ]

	local 0 `name'
	syntax [anything(name=name)] [ , replace ]
        if "`name'" == "" {
	    if (_caller() < 10) {
		local replace replace
	    }
	    else {
		_gs_path2memname name replace `"`filenm'"'
	    }
	}

	gr_setscheme , `scheme' `refscheme'
	gr_current name : `name' , newgraph `replace'

	capture noisily {
		.__Map = .null.new			// global 

		/* rebuild the object */
		gr_read `name' `"`filenm'"' 0`="`styles'"!=""'		///
			 0`= "`scheme'"=="" '
	} 
	local rc = _rc

	capture _cls free __Map

	if `rc' {
		exit `rc'
	}

	if "`draw'" == "" {
		gr_draw `name'
	}

	.`name'.filename = `"`filenm'"'
	_gs_addgrname `name'				// register graph name

	if `"`play'"' != `""' {
		gr_play `"`play'"'			// play recording
	}

end


// ----------------------------------------------------------------------------
// return an absolute pathname

local SS	string scalar

mata:

`SS' __pathmkabsolute(`SS' path)
{
	`SS'	curdir, toret

	curdir = pwd()
	chdir(path)
	toret = pwd()
	chdir(curdir)
	return(toret)
}

`SS' __filemkabsolute(`SS' file)
{
	`SS'	curdir, fname, toret
	pragma unset curdir
	pragma unset fname

	pathsplit(file, curdir, fname)
	if (curdir == "") {
		curdir = pwd()
	}
	else {
		curdir = __pathmkabsolute(curdir)
	}

	toret = pathjoin(curdir, fname)
	return(toret)
}

end
