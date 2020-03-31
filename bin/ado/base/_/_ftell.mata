*! version 1.0.0  15oct2004
version 9.0
mata:

real scalar _ftell(real scalar fh) return(_fseek(fh, 0, 0))

end
