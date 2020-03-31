*! version 1.0.0  02jun2011

version 12

mata:

mata set matastrict on

real matrix arfimapsdensity(real scalar n,  real colvector phi, 
			real colvector theta, real scalar d, real scalar v, 
			real scalar pspectrum, |real vector range)
{
	real scalar ec, m, eps
	real colvector sd, gamma, r
	complex colvector phi1, theta1

	pragma unset ec

	eps = epsilon(2^20)
	phi1 = C(phi)
	theta1 = C(theta)

	if (args()>6) r = _arfimavalidate(n,phi1,theta1,d,v,range)
	else r = _arfimavalidate(n,phi1,theta1,d,v)

	sd = _armapsectrum(r,phi,theta,v)

	if (!pspectrum) {
		m = max((length(phi),length(theta)))+1

		if (length(phi1)) phi1 = C(1):/phi1

		ec = 0
		if (abs(d)>eps) gamma = _arfima_acf(m,phi1,theta,d,v,ec)
		else gamma = _arma_acf(m,phi1,theta,v)

		if (ec) sd[.] = J(length(sd),1,.)
		else sd[.] = sd:/gamma[1]
	}
	if (abs(d)>eps) sd[.] = sd:*abs(C(1):-exp(C(0,r))):^(-2*d)

	return((sd,r))
}

/* STATIC */
real colvector _arfimavalidate(real scalar n, complex colvector phi, 
		complex colvector theta, real scalar d, real scalar v, 
		|real vector range)
{
	real scalar i, j, n0, p, q, one, eps

	if (args() > 5) {
		if (length(range) != 2) {
			errprintf("{bf:range} must be a vector of ")
			errprintf("length 2\n")
			exit(3200)
		}
		if (range[1]<0 | range[1]>range[2] | range[2]>pi()) {
			errprintf("{bf:range} must be in [0,pi()]\n")
			exit(3300)
		}
	}
	else range = (0,pi())

	n0 = floor(n+0.5)
	one = 1+ 2^-8
	if (n0 < 2) {
		errprintf("{bf:n} must be an integer greater than 1\n")
		exit(3300) 
	}
	if (d<=-1 | d>0.5) {
		errprintf("{p}fractional difference parameter must be in ")
		errprintf("(-1,0.5]{p_end}\n")
		exit(3300)
	}
	if (v <= 0) {
		errprintf("{p}variance parameter is less than or equal to \n")
		errprintf("zero{p_end}\n")
		exit(3300)
	}
	if ((p=length(phi))) {
		if (any(abs(phi=polyroots((1,-phi'))'):<=one)) {
			errprintf("{p}AR polynomial has roots less than or ")
			errprintf("near to one{p_end}\n")
			exit(3498)
		}
	}
	if ((q=length(theta))) {
		if (any(abs(theta=polyroots((1,theta'))'):<=one)) {
			errprintf("MA polynomial has roots less than or ")
			errprintf("near to one\n")
			exit(3498)
		}
		eps = 2^-16
		/* check for common roots				*/
		for (j=1; j<=p; j++) {
			for (i=1; i<=q; i++) {
				if (abs(phi[j]-theta[i])<eps*abs(phi[j])) {
					errprintf("{p}AR(%g) and MA(%g) ",
						length(phi), length(theta))
					errprintf("polynomials have common ")
					errprintf("roots{p_end}\n")
					exit(3498)
				}
			}
		}
	}
	return(rangen(range[1],range[2],n0))
}

/* STATIC */
real matrix _armapsectrum(real colvector r, real vector phi, 
		real vector theta, real scalar v) 
{
	real scalar i, p, q, pq, n
	complex colvector fp, fq, f

	p = length(phi)
	q = length(theta)
	pq = max((p,q))
	n = length(r)

	fp = fq = J(n,1,C(0))
	if (pq) f = exp(-C(0,r))

	for (i=pq; i>=1; i--) {
		if (i<=p) fp[.] = f:*(C(phi[i]):+fp)
		if (i<=q) fq[.] = f:*(C(theta[i]):+fq)
	}
	return(v:*Re(abs(C(1):+fq):^2:/abs(C(1):-fp):^2):/(2*pi()))
}

end
exit
