*! version 1.0.0  01mar2018

if "$STPARAMVECTOR_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

class __stparam_vector extends __stmatrix
{
    protected:
	real matrix m_ieqs
	string vector m_eqs

    protected:
	void new()
	void destroy()

	real scalar equation_index()

	real scalar set_coef_by_stripe()
	real scalar set_coef_by_index()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar set_equation()
	real scalar set_coefficients()
	real scalar equation_stripe()
}

end

global STPARAMVECTOR_MATAH_INCLUDED 1

exit
