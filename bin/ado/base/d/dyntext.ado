*! version 1.0.3  10sep2019
program dyntext
	version 16
	
	syntax anything(everything), SAVing(string) [ 		/// 
		REPlace					///
		noREMove				///
		embedimage				///			
		nostop					///
		]

	gettoken file opargs : anything
	confirm file `"`file'"'

	local srcfile = strtrim("`file'")
	local destfile = strtrim("`saving'")

	mata: (void)pathresolve(pwd(), "`destfile'", "destfile") 

	local issame = 0
	mata: (void)filesarethesame("`srcfile'", "`destfile'", "issame")
	
	if ("`issame'" == "1") {
di in error "target file can not be the same as the source file"
		exit 602			
	}
	
	if (`"`replace'"' == "") {
		confirm new file `"`destfile'"'
	}
	
	tempfile mlogfile
	tempname mlogname	
	
	qui log using `"`mlogfile'"', text replace nomsg name(`mlogname')

	cap noi _dyntext `"`srcfile'"' `opargs', `stop' `embedimage' basedir("`destfile'")
	local error = _rc
	qui log close `mlogname'		

	if ("`error'" != "0") {
		exit `error'
	}
	
	if _rc  {
		exit 198
	}	
	
	if ("`remove'" == "") {
		tempfile mclean
		if "`stop'" != "" {
			cap noi mata: _text_file_remove("`mlogfile'", "`mclean'", 0)
		}			
		else {
			cap noi mata: _text_file_remove("`mlogfile'", "`mclean'", 1)			
		}
		if _rc {
			exit 198	
		}
		qui copy `"`mclean'"' `"`destfile'"', replace
	}
	else {
		qui copy `"`mlogfile'"' `"`destfile'"', replace		
	}
end

mata:

real scalar _findtag(string scalar line,
	real scalar startpos,
	string scalar tag, 
	real scalar minlen,
	real scalar isendtag,
	real scalar tagbeg,
	real scalar tagend,
	real scalar stop
	)
{
	real scalar posb, pose, plen
	real scalar posco
	string scalar part, part1
	
	posb = pose = 0
	tagbeg = tagend = 0

	posb = _strpos_start(line, "<<", startpos)
	if(posb == 0) {
		return(0)
	}

	pose =  _strpos_start(line, ">>", posb)
	if(pose == 0) {
		return(0)		
	}
		
	plen = pose - posb - 1 - 1
	part = substr(line, posb+2, plen)
	part = strtrim(part)
	
	if(isendtag) {
		if(strpos(part, "/") != 1) {
			return(0)
		}

		part  = substr(part, 2, .)	
		part = strtrim(part)
	}
	
	part1 = ""
	posco = strpos(part, ":")
	if(posco != 0) {
		part1 = strtrim(substr(part, posco+1, .))
		part = strtrim(substr(part, 1, posco-1))
	}
	
	if(isminabbrev(part, tag, minlen)) {
		if(strlen(part1) != 0) {
			if(isendtag) {
errprintf("attribute {bf:%s} invalid for end tag {bf:/dd_remove}\n", part1)  							
			}
			else {
errprintf("attribute {bf:%s} invalid for tag {bf:dd_remove}\n", part1)  			
			}
			if(stop) {
				return(-1)
			}			
		}
		else {
			tagbeg = posb
			tagend = pose + 1
			return(1)
		}
	}
		
	startpos = posb + 1
	return(_findtag(line,
		startpos,
		tag, 
		minlen,
		isendtag,
		tagbeg,
		tagend,
		stop
		))
}
		
string scalar lineremove( real scalar fin,
			real scalar fout,
			string scalar line, 
			real scalar skip,
			real scalar newskip,
			real scalar stop
			)
{
	string scalar res 
	real scalar findb, finde
	real scalar tagb_b, tagb_e, tage_b, tage_e

	findb = finde = 0 
	tagb_b = tagb_e = tage_b = tage_e = 0
			
	findb = _findtag(line, 1, "dd_remove",  6, 0, tagb_b, tagb_e, stop) 
	if(findb < 0) {
		fclose(fin)
		fclose(fout)
		exit(198)
	}
	finde = _findtag(line, 1, "dd_remove",  6, 1, tage_b, tage_e, stop)  
	if(finde < 0) {
		fclose(fin)
		fclose(fout)
		exit(198)	
	}

	if(findb == 0 && finde == 0) {
		newskip = skip
		
		if(newskip) {
			return("")
		}
		else {
			return(line)
		}
	}
	
	if(skip) {
		if(finde == 0) {
			newskip = skip
			return("")
		}

		res = substr(line, tage_e+1)
		return(lineremove(fin, fout, res, !skip, newskip, stop))
	}
	else {
		if(findb == 0) {
			newskip = skip
			return(line)
		}
		
		res = substr(line, 1, tagb_b-1)
		line = substr(line, tagb_e+1)
		return(res+lineremove(fin, fout, line, !skip, newskip, stop))	
	}
}						 

void _text_file_remove( string scalar fsrc, 
			string scalar fdest, 
			real scalar stop
			)
{
	real scalar fin
	real scalar fout
	string scalar line
	real scalar isskip
	real scalar newskip
	
	fin  = _fopen(fsrc, "r")
	if(fin < 0) {
		exit(-fin) 
	}
	
	fout = _fopen(fdest, "w")
	if(fout < 0) {
		fclose(fin)
		exit(-fout) 
	}
	
	isskip = newskip = 0 
	while ((line = fgetnl(fin)) != J(0, 0, "")) {
		line = lineremove(fin, fout, line, isskip, newskip, stop)
		isskip = newskip
		if(line != "") {
			fwrite(fout, line)
		}
	}
	
	fclose(fin)
	fclose(fout)
}										
end
