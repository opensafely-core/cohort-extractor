*! version 1.1.5  29jan2019
program define dyndoc
	version 16.0
	
	syntax anything(everything) [, SAVing(string)  		/// 
			REPlace					///
			noREMove				///
			hardwrap				///
			embedimage				///
			nomsg					///
			nostop					///
			pegdown					///
			docx					///
			flexdocx				///
			]
			
	gettoken file opargs : anything

	if("`docx'" !="" & "`flexdocx'" != "") {
di in error "options {bf:docx} and {bf:flexdocx} may not be combined"
		exit 198				
	}
	
	local srcfile = strtrim("`file'")
	confirm file "`srcfile'"

	local destfile = strtrim(`"`saving'"')
	if (`"`destfile'"' == "") {
		if("`docx'" != ""  | "`flexdocx'" != "") {
			mata:(void)pathchangesuffix("`srcfile'", "docx", "destfile", 0)		
		}
		else {
			mata:(void)pathchangesuffix("`srcfile'", "html", "destfile", 0)	
		}
	}
	
	mata:_getfileextension(`"`destfile'"', "destext") 
	
	mata: (void)pathresolve(pwd(), `"`destfile'"', "destfile") 	

	dyntext `"`srcfile'"' `opargs', saving(`"`destfile'"') 	///
		`replace' `remove' `stop' `embedimage' 

	local basepath
	mata:_getpathparent("`destfile'", "basepath") 
	
	tempfile mlogfile
	qui copy "`destfile'" `"`mlogfile'"'
	
	if("`docx'" == ""  & "`flexdocx'"== "") {
		if("`destext'" == ".docx") {
			local docx = "docx"
		}
	}
	
	markdown `"`mlogfile'"',            ///  
	         saving(`"`destfile'"')     ///  
	         replace                    ///  
	        `hardwrap'                  ///  
	        `embedimage'                ///  
	        `msg'                       ///  
	        `pegdown'                   ///  
	        `flexdocx'                  ///  
	        `docx'                      ///  
	         basedir("`basepath'")
end

mata:
void _getfileextension(string scalar path, 
	string scalar loc)
{
	string scalar p
	
	p = strtrim(strlower(pathsuffix(path)))
	st_local(loc, p) 
}

void _getpathparent( string scalar path, 
                     string scalar loc)
{
	string scalar p
	
	p = pathgetparent(path)
	st_local(loc, p) 
}
end
