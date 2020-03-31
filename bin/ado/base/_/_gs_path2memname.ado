*! version 1.0.1  09sep2019

// Converts a graph pathname into a memory name for the graph

program _gs_path2memname 
	version 10
	args namemac replacemac filenm exists

	local filenm `filenm'					// sic
	nobreak {
		mata: st_local("filenm", __filemkabsolute(`"`filenm'"'))
	}

					// Use existing memory name if any
					// have the same full pathname
	foreach gr in `._Gr_Global.graphlist' {
		if `"`filenm'"' == `"`.`gr'.filename'"' {
			c_local `replacemac' "replace"
			c_local `namemac' "`gr'"
			local found 1
		}
	}

	if (0`found') {
		if ("`exists'" != "")  c_local `exists' 1
		exit						// Exit
	}

					// get simple filename
	mata: st_local("name", pathrmsuffix(pathbasename(`"`filenm'"')))

	capture confirm names `name'
	local  ng = _rc						// not a name
	if (! `ng') local ng = `:list sizeof name' - 1		// not a name
	if (! `ng') local ng = ("`.`name'.isa'" != "")		// exists or
								// reserved
	if (! `ng') {						// more reserved
		local exclude alignment axis barview cell clockdir	///
			code codestyle color container dimension	///
			fillpattern fixedcode gdi graphsize grid gsize 	///
			intensity linecolor linepattern linestyle	///
			linewidth logcmd mapping margin null numstyle	///
			object pieview plotregion scale scheme series	///
			serset spacer style subview symbol textbox text	///
			transform vartype vertical view yesno

		local ng `:list posof "`name'" in exclude'
	}

	if `ng' {
		local i 1
		while "`.graph`i'.isa'" != "" {
			local ++i
		}

		c_local `namemac' "graph`i'"

		if ("`exists'" != "")  c_local `exists' 1
	}
	else {
		c_local `namemac' "`name'"

		if ("`exists'" != "")  c_local `exists' 0
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
