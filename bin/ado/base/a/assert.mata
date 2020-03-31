*! version 1.0.0  15oct2004
version 9.0
mata:

	/*
		void assert(real scalar)

		returns if scalar is true, aborts if false
	*/

void assert(real scalar t)
{
	if (t==0) _error("assertion is false")
}

end
