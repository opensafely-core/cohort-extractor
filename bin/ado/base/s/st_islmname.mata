*! version 1.0.0  15oct2004
version 9.0
mata:

real scalar st_islmname(string scalar s) return(s=="" ? 0 : st_isname("_" + s))

end
