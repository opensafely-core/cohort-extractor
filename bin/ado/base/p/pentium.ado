*! version 1.0.2  13jun2000
program define pentium
	version 4.0
	tempname x 
	scalar x = 824633702449
	if (1/x)*x-1 == 0 { 
		di in gr /*
		*/ "This computer does not have the Pentium's FDIV bug"
	}
	else {
		di in gr /* 
		*/ "This computer has the Pentium's FDIV bug."
	}
end
