*! version 1.0.0  26feb2015
program define renamevarno
	version 14
	args varid newname nothing 
	capture confirm integer number `varid'
	if _rc {
		if strlen(strtrim("`varid'")) > 0 {
			di as err `"first argument {bf:`varid'} invalid, must be a positive integer"'
		}
		else {
			di as err `"first argument not specified, must specify a positive integer"'		
		}
		exit 198
	}

	if `varid'<0 {
		di as err `"first argument {bf:`varid'} invalid, must be a positive integer"'
		exit 198
	}
	
	capture confirm existence `newname'
	if _rc { 
		di as err `"second argument not specified, must specify a new variable name"'
		exit 198
	}

	capture confirm existence `nothing'
	if _rc==0 { 
		di as error `"{bf:`nothing'} found where nothing expected"'
		exit 198
	}
	
	mata:rename_fast(`varid', `"`newname'"')
end

mata:
void rename_fast(real scalar varid, string scalar newname)
{
	real scalar	kvar, rc
	string scalar   name, cmd
		
	kvar = st_nvar() ;
	if(varid < 1 || varid > kvar) {
		errprintf("variable number {bf:%g} out of range, must be between 1 and %g\n", varid, kvar)
		exit(198) 
	}
	
	name = st_varname(varid)
	cmd  = sprintf("_rename %s %s", name, newname)  
	if (rc=_stata(cmd)) {
		exit(rc)
	}
}
end 
