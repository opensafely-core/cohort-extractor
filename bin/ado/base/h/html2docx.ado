*! version 1.0.1  18sep2019
program define html2docx
	version 16.0
	syntax anything [, SAVing(string)		///
			REPlace		///
			nomsg		///
			base(string)		///
			_assumenoextension		///
			] 
			
	gettoken file opargs : anything
	
	local srcfile = strtrim("`file'")
	mata: (void)_ispathurl(`"`srcfile'"', "isurl") 	

	if("`isurl'" != "1") {
		if "`_assumenoextension'" == "" {
			// append extension .html if source file has no extension
			mata:_fix_fie_extension("`srcfile'", ".html", "srcfile")
		}
		mata: (void)pathresolve(pwd(), `"`srcfile'"', "srcfile") 	
		confirm file "`srcfile'"
	}
	
	local destfile = strtrim(`"`saving'"')
	if (`"`destfile'"' == "") {
		if("`isurl'" == "1") {
di in error "target file required if source is a URL"
			exit 198
		}
		else {
			mata:(void)pathchangesuffix("`srcfile'", "docx", "destfile", 0)		
		}
	}		

	if "`_assumenoextension'" == "" {
		// append docx to destfile is destfile has no extension 
		mata:_fix_fie_extension("`destfile'", ".docx", "destfile")
	}
	mata: (void)pathresolve(pwd(), `"`destfile'"', "destfile") 
	
	mata: docx_fromhtml_wrk(`"`srcfile'"', `"`destfile'"', /// 
		`"`base'"', `"`replace'"')
		
	if ("`msg'" == "") {
di in smcl `"successfully converted {browse "`destfile'":"`destfile'"}"' 
	}
end

version 16.0

local RS	real scalar
local SS	string scalar
local SR	string rowvector

mata:
void docx_fromhtml_wrk(`SS' file, `SS' savefile, `SS' basedir, `SS' replace)
{
	`SS'  dest
	`RS'  rep, ret
	
	rep = 0
	if (savefile != "") {
		dest = savefile
		rep = 0
		if (replace != "") {
			rep = 1
		}
		if (fileexists(dest) != 0 & rep == 0) {
errprintf("file %s already exists\n", dest) 
errprintf("you must specify the {bf:replace} option\n")
			exit(198)
		}
	}
	
	ret = _docx_from_html(file, dest, basedir)
	if (ret < 0) {
errprintf("failed to convert file to docx; file may not be well-formed html document\n") 
		exit(198)
	}
}

void _ispathurl(`SS' path, `SS' loc)
{
	`RS' p
	
	p = pathisurl(path)
	if(p != 0) {
		st_local(loc, "1")
	}
	else {
		st_local(loc, "0")	
	}
}

void _fix_fie_extension(`SS' path, `SS' ext, `SS' loc)
{
	`SS' cur_ext
	`SS' new_path
	
	cur_ext =  pathsuffix(path)
	
	new_path = path
	if(cur_ext == "") {
		if(strpos(ext, ".") == 1) {
			new_path = path + ext
		}
		else {
			new_path = path + "." + ext
		}
	}
	st_local(loc, new_path)	
}
end

exit

