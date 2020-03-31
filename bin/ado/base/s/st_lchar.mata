*! version 1.1.1  06nov2017

version 10


local MAXSIZE	67700
local MAXSIZEp1	= `MAXSIZE' + 1

mata:

mata set matastrict on


transmorphic st_lchar(string scalar basename, string scalar charname, 
			|string scalar s)
{
	if (args()==2) return(st_lchar_read(basename, charname))

	st_lchar_write(basename, charname, s)
}


void ado_intolchar(string scalar basename, string scalar charname, 
		string scalar macname)
{
	st_lchar(basename, charname, st_local(macname))
}


void ado_fromlchar(string scalar macname, 
		string scalar basename, string scalar charname)
{
	st_local(macname, st_lchar(basename, charname))
}

/* -------------------------------------------------------------------- */

/*static*/ void st_lchar_write(string scalar basename, string scalar charname, 
			       string scalar s)
{
	real scalar	i, l, rl, pos
	string scalar   sp
	
	st_lchar_rm(basename, charname)
	rl  = strlen(s)
	for (pos=i=1; rl>0; i++) {
		l = (rl>`MAXSIZE' ? `MAXSIZE' : rl)
		sp = ubsubstr(s, pos, l)
		if(sp == "") {
			sp = bsubstr(s, pos, l)		
		}
		l = bstrlen(sp) 
		st_global(sprintf("%s[%s%g]", basename, charname, i), sp)
		pos = pos + l 
		rl  = rl  - l 
	}
}


/*static*/ string scalar st_lchar_read(
			string scalar basename, string scalar charname)
{
	real scalar	i
	string scalar	s, t

	s = ""
	for (i=1; 1; i++) {
		if (
		    (t=st_global(sprintf("%s[%s%g]", basename, charname, i)))
		    == ""
                    ) {
			return(s)
		}
		s = s + t
	}
	/*NOTREACHED*/
}


/*static*/ void st_lchar_rm(string scalar basename, string scalar charname)
{
	real scalar	i
	string scalar	fullname

	for (i=1; 1; i++) {
		fullname = sprintf("%s[%s%g]", basename, charname, i)
		if (st_global(fullname)=="") return
		st_global(fullname, "")
	}
	/*NOTREACHED*/
}

end
