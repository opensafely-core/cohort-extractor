*! version 1.0.0  15oct2004
version 9.0
mata:

numeric matrix tanh(numeric matrix u) 
{
	numeric matrix 	eu, emu 

	eu = exp(u) 
	emu = exp(-u) 
	return( (eu-emu):/(eu+emu) )
}

end
