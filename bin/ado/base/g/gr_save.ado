*! version 1.2.2  09sep2019
program define gr_save
	version 10
	
	syntax anything [, REPLACE ASIS ]

	gettoken name   anything : anything
	gettoken filenm nothing  : anything

	if `"`filenm'"' == `""' {
		local filenm `"`name'"'
		local name
	}

	if `"`filenm'"' == `""' {
		di as error `"filename name required"'
		exit 198
	}
	if `"`nothing'"' != `""' {
		di as error `"invalid syntax, `nothing' not allowed"'
		exit 198
	}

	if "`name'" == "" {
		local name `._Gr_Global.current_graph_resync'
	}

	if "`asis'" != "" | "`name'" == "" {	
		if "`name'" != "" & 					///
		   "`name'" != "`._Gr_Global.current_graph_resync'" {
			gr_current name : `name' , drawifchg
		}
		_asis save `"`filenm'"' , `replace'		// asis save
		exit
	}

	_addgph filenm : `"`filenm'"'

	gr_current name : `name' , drawifchg

	capture noisily {
						/* save and replay name  */
						/* set up globals */
		tempname loghndl holdmap
		global T_loghndl `loghndl'
		file open `loghndl' using `"`filenm'"' , text write `replace'

		.__Map = .null.new
		global T_savesers 1

		_gs_wrfilehdr `loghndl' `name'			// file header

						/* save off the components */
		foreach type in serset scheme graph_g lgrid {
			.`name'.saveall `type' 1		
		}

		file close `loghndl' 

	} 					/* end capture noisily */
	local rc = _rc

	capture _cls free __Map
	capture mac drop T_loghndl
	capture mac drop T_savesers

	if `rc' {
		exit `rc'
	}


	local filenm0 `"`filenm'"'

	nobreak {
		mata: st_local("filenm", __filemkabsolute(`"`filenm'"'))
	}

	.`name'.filename = `"`filenm'"'
	.`name'.dirty = 0
	_gedi dirtychanged

//	if (! (0`exists') & _caller() >= 10) {
//		gr_rename `name' `newname'
//		if ("`._Gr_Global.edit_graph'" != "")			///
//			._Gr_Global.edit_graph = "`newname'"
//	}

	di in green `"(file `filenm0' saved)"'

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
