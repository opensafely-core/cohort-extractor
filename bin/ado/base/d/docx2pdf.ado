*! version 1.0.1  18sep2019
program define docx2pdf
	version 16.0

	syntax anything(everything) [, SAVing(string)  		/// 
			REPlace		/// 
			nomsg		/// 
			_assumenoextension		/// 
		]

	gettoken file opargs : anything

	local srcfile = strtrim("`file'")
	if "`_assumenoextension'" == "" {
		// append extension .docx if source file has no extension
		mata:_fix_fie_extension("`srcfile'", ".docx", "srcfile")
	}
	mata: (void)pathresolve(pwd(), `"`srcfile'"', "srcfile") 	
	confirm file "`srcfile'"

	local destfile = strtrim(`"`saving'"')
	if (`"`destfile'"' == "") {
		mata:(void)pathchangesuffix("`srcfile'", "pdf", "destfile", 0)		
	}

	if "`_assumenoextension'" == "" {
		// append .pdf to destfile is destfile has no extension 
		mata:_fix_fie_extension("`destfile'", ".pdf", "destfile")
	}	
	mata: (void)pathresolve(pwd(), `"`destfile'"', "destfile") 	

	mata: docx_topdf_wrk(`"`srcfile'"', `"`destfile'"', `"`replace'"')
	if ("`msg'" == "") {
di in smcl `"successfully converted {browse "`destfile'":"`destfile'"}"' 
	}
end

version 16.0

local RS        real scalar
local SS        string scalar
local SR        string rowvector

mata:
void docx_topdf_wrk(`SS' file, `SS' savefile, `SS' replace)
{
	`SS'		dest
	`RS'		rep, ret
		
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
	
	ret = _docx_to_pdf(file, dest)
	if (ret < 0) {
errprintf("failed to convert file to pdf; file may not be valid docx document\n") 
		exit(198)
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

