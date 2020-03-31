*! version 1.1.6  27mar2019
program define markdown
	version 16.0
	
	syntax anything, SAVing(string) [ 		/// 
		REPlace					///
		hardwrap				///
		EMBEDIMage				///
		nomsg					///
		pegdown					///
		flexdocx				///
		docx					///
		basedir(string)			///
		]

	if("`docx'" !="" & "`flexdocx'" != "") {
di in error "options {bf:docx} and {bf:flexdocx} may not be combined"
		exit 198				
	}

	tokenize `"`anything'"'
	local srcfile `"`1'"'
	local fn2 `"`2'"'
	if ("`fn2'"!="") {
		di "invalid syntax"
		exit 198
	}
	confirm file `"`srcfile'"'
	
	local destfile = strtrim("`saving'")

	mata: (void)pathresolve(pwd(), "`destfile'", "destfile") 
	
	local issame = 0
	mata: (void)filesarethesame("`srcfile'", "`destfile'", "issame")
	
	if ("`issame'" == "1") {
di in error "target file can not be the same as the source file"
		exit 602			
	}
		
	if ("`replace'" == "") {
		confirm new file `"`destfile'"'
	}

	local hwrap = 0
	if ("`hardwrap'" != "") {
		local hwrap = 1
	}	

	local ispegdown = 0
	if ("`pegdown'" != "") {
		local ispegdown = 1
	}

	mata:_getfileextension(`"`destfile'"', "destext") 	
	if("`docx'" == ""  & "`flexdocx'"== "") {
		if("`destext'" == ".docx") {
			local docx = "docx"
		}
	}
	
	local isdocx = 0
	if ("`flexdocx'" != "") {
		local isdocx = 1
	}	
	
	local isembedimage = 0
	if ("`embedimage'" != "") {
		local isembedimage = 1
	}	
	
	tempfile tmpfile
	if "`docx'" != "" {
		tempfile tmphtml
		mata:markdown_tohtml("`srcfile'", "`tmphtml'", `hwrap', `ispegdown', `isembedimage', "`basedir'")
		html2docx "`tmphtml'", saving("`tmpfile'") base("`basedir'") nomsg
	}
	else {
		if ("`isdocx'" == "0") {
			if "`basedir'"=="" {
				mata: (void)pathresolve(pwd(), `"`srcfile'"', "srcfilefullpath")
				mata: (void)_getfileparentpath(`"`srcfilefullpath'"', "basedir")
			}
			mata:markdown_tohtml("`srcfile'", "`tmpfile'", `hwrap', `ispegdown', `isembedimage', "`basedir'")
		}	
		else if ("`isdocx'" == "1") {
			mata:markdown_todocx("`srcfile'", "`tmpfile'", "`basedir'")	
		}
	}
	
	qui copy "`tmpfile'" "`destfile'", replace
	if ("`msg'" == "") {
		if ("`isdocx'" == "0") { 
			if (substr("`destfile'", 1, 1)=="/") {
				local flink = subinstr("file:`destfile'", " ", "%20", .)			
			}
			else {
				local flink = subinstr("file:/`destfile'", " ", "%20", .)
			}
di in smcl `"successfully converted {browse "`flink'":"`destfile'"}"' 				
		}
		else {
di in smcl `"successfully converted {browse "`destfile'":"`destfile'"}"' 						
		}
	}
end

mata:
void markdown_tohtml(   string scalar src, 
			string scalar dest, 
			real scalar hwrap, 
			real scalar pegdown, 
			real scalar isembedimage,
			string scalar basedir
			)
{
	real scalar res
	
	if(pegdown) {
		res = _dyndoc_tohtml(src, dest, hwrap)
	}
	else {
		res = _dyndoc_flexmark(src, dest, hwrap, isembedimage, basedir)		
	}
	
	if(res != 0) {
errprintf("{bf:markdown} failed to convert file\n")
		exit(601)
	}
}

void markdown_todocx(   string scalar src, 
			string scalar dest, 
			string scalar basedir)
{
	real scalar res
	
	res = _dyndoc_flexmark_docx(src, dest, basedir)		
	
	if(res != 0) {
errprintf("{bf:markdown} failed to convert file\n")
		exit(601)
	}
}

void _getfileextension(string scalar path, 
	string scalar loc)
{
	string scalar p
	
	p = strtrim(strlower(pathsuffix(path)))
	st_local(loc, p) 
}

void _getfileparentpath(string scalar file, 
	string scalar loc)
{
	string scalar p
	
	p = strtrim(strlower(pathgetparent(file)))
	st_local(loc, p) 
}

end
