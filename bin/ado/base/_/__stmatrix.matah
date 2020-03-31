*! version 1.0.4  25mar2018

if "$STMATRIX_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

class __stmatrix
{
    protected:
	string scalar m_name
	real matrix m_matrix
	string matrix m_colstripe
	string matrix m_rowstripe
	string scalar m_errmsg

	static real scalar m_tol

    public:
	static real scalar ROW
	static real scalar COLUMN

    protected:
	void new()
	void destroy()
	void clear()

	real scalar validate()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	string scalar name()

	real matrix m()
	real scalar rows()
	real scalar cols()
	string matrix stripe()
	string matrix rowstripe()
	string matrix colstripe()
	void st_matrix()		// post matrix to Stata
	void st_matrix_ns()		// post matrix to Stata, no stripe
	real scalar st_getmatrix()	// retrieve Stata matrix
	void display()			// display 

	real scalar el()
	real scalar set_el()
	real scalar set_block()

	real scalar isequal()

	real scalar set_name()
	real scalar set_stripe()

 	string scalar errmsg()
}

end

global STMATRIX_MATAH_INCLUDED 1

exit

