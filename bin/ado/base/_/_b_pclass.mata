*! version 1.0.5  20mar2019

mata:

class _b_pclass {

protected:

	transmorphic	A

public:

	void		new()

	real	scalar	value()

}

// public routines ----------------------------------------------------------

void _b_pclass::new()
{
	A	= asarray_create("string", 1)
	asarray_notfound(A, .)

	// NOTE: changes to the key/value pairs in 'A' requires an
	// update to _b_pclass.sthlp

	// default -- nothing special
	asarray(A,	"default",	0)
	asarray(A,	"none",		0)

	// coefficient -- nothing special
	asarray(A,	"coef",		1)

	// auxiliary -- suppress test stat and pvalue
	asarray(A,	"aux",		2)

	// mean -- nothing special
	asarray(A,	"mean",		3)

	// variance -- suppress test stat and pvalue and
	//             performs log transform for CI
	asarray(A,	"var",		4)

	// covariance -- nothing special
	asarray(A,	"cov",		5)

	// correlation -- tanh transform
	asarray(A,	"corr",		6)

	// correlation -- logit transform for CI
	asarray(A,	"cilogit",	7)

	// undisplayed parameter
	asarray(A,	"ignore",	8)

	// variance -- truncate lower CI limit at 0
	asarray(A,	"VAR",		100)

	// bseonly -- suppress test stat, pvalue, and CI
	asarray(A,	"bseonly",	101)

	// variance -- truncate lower CI limit at 0
	// 		add separator from VAR group
	asarray(A,	"VAR1",		102)
	
	// 104-107 are used in _xtme_estatsd.ado and _gsem_estat_sd.mata
	
	// sd -- base group
	asarray(A,	"group0",		104)
	
	// sd -- remaining groups
	asarray(A,	"groupj",		105)
	
	// correlation
	asarray(A,	"tanh",			106)
	
	// rho
	asarray(A,	"invlogit",		107)

	// distribution df
	asarray(A,	"df",			110)
}

real scalar _b_pclass::value(string scalar key)
{
	return(asarray(A, key))
}

end
