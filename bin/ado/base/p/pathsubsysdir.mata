*! version 1.0.1  06nov2017
version 9.0
mata:

string rowvector pathsubsysdir(string rowvector dir)
{
	real scalar		i
	string scalar		lhs, rhs, el
	string rowvector	res 

	pragma unset lhs
	pragma unset rhs

	res = J(1, cols(dir), "")
	for (i=1; i<=cols(dir); i++) {
		el = dir[i]
		if (el=="STATA") 		el = c("sysdir_stata")
		else if (el=="UPDATES") 	el = c("sysdir_updates")
		else if (el=="BASE") 		el = c("sysdir_base")
		else if (el=="SITE") 		el = c("sysdir_site")
		else if (el=="PLUS") 		el = c("sysdir_plus")
		else if (el=="PERSONAL") 	el = c("sysdir_personal")
		else if (el=="OLDPLACE") 	el = c("sysdir_oldplace")
		else if (el=="FUTURE") {
			pathsplit(c("sysdir_updates"), lhs, rhs)
			el = pathjoin(lhs, "future"+c("dirsep"))
		}
		res[i] = el 
	}
	return(res)
}

end
