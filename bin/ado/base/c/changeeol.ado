*! version 1.1.1  29jun2009
program	changeeol 
	version 10

	syntax anything , eol(string) [ replace force] 

	tokenize `"`anything'"'
	local fn1 `"`1'"'
	local fn2 `"`2'"'

	if ("`fn2'"=="") {
		di "invalid syntax"
		exit 198
	}

	if `"`eol'"' == "dos" {
		local eol "windows"
	}

	if !(`"`eol'"'=="windows" | `"`eol'"'=="unix" | `"`eol'"'=="mac" | `"`eol'"'=="classicmac") {
		di "eol '`eol'' not allowed"
		exit 198 
	} 
	confirm file `"`fn1'"'	
	
	if ("`force'" == "") {
		qui hexdump `fn1', analyze
		if (r(format)=="BINARY") {
			di as err "`fn1' is a binary file; specify option " ///
			          "force to force conversion"
			exit 621 
		}
	}

	capture confirm file `"`fn2'"'
	local rc = _rc
	if (`rc' == 0 & "`replace'" != "replace" ) {
		di as err `"file `fn2' already exists"'
		exit 602
	} 

	if (`rc' == 601) {
		if ("`replace'" == "replace") {
			di `"(note: file `fn2' not found)"'
		}
		mata: addcr_f(`"`fn1'"', `"`fn2'"', "`eol'")
	}
	else {
		tempfile tempfn2
		mata: addcr_f(`"`fn1'"', `"`tempfn2'"', "`eol'")
		copy `"`tempfn2'"' `"`fn2'"', `replace'
	}
end

mata:
void addcr_f(string scalar fn1, string scalar fn2, string scalar platform)
{
	real scalar fh1
	real scalar fh2
	string scalar line

	if ((fh1 = _fopen(fn1, "r")) <0 ) {
		errprintf("file %s could not be opened\n", fn1)
		exit(601)
	}
	
	if ((fh2 = _fopen(fn2, "rw")) < 0) {
		fclose(fh1)
		errprintf("file %s could not be opened\n", fn2)
		exit(601)
	}
	fseek(fh2,0,-1)
	ftruncate(fh2)
		
        while (1) {
		line = fget(fh1)
		if (line == J(0,0,"")) {
			break	
		}
		fwrite(fh2, line)
		if (platform=="windows" | platform=="classicmac") {
			fwrite(fh2, char(13))
		}
		if (platform=="windows" | platform=="unix" | platform=="mac") {
			fwrite(fh2, char(10))
		}
        }

	(void) _fclose(fh2)
	(void) _fclose(fh1)
}
end
