*! version 1.2.1  24oct2013 

version 12

local _ERROR_NOT_STATIONARY 1
local _ERROR_NOT_INVERTABLE 2
local _ERROR_COMMON_ROOTS 3
local _ERROR_INVALID_FRACT_INT 4
local _ERROR_SERIES_FAILURE 5
local _ERROR_ACF_FAILURE 6
local _ERROR_ARFIMA_PARAM 7
local _ERROR_INVALID_VAR 8

mata:
mata set matastrict on

/* compute the ACF of a ARFIMA(p,d,q) process				*/
/* returns a vector of length n+1:					*/
/* 	acf[1] = var(y[i]), acf[h] = cov(y[i],y[i+h])			*/

real colvector arfimaacf(real scalar n, real colvector phi, 
		real colvector theta, real scalar d, real scalar v)
{
	real scalar ec, rc, min_n
	real colvector acf

	pragma unset ec

	min_n = 2*(rows(phi)+rows(theta))
	if (min_n < n) min_n = n
	acf = _arfimaacf(min_n,phi,theta,d,v,ec)
	if (!ec) return(acf[|1\n+1|])

	rc = 3498
	if (ec == `_ERROR_NOT_STATIONARY') {
		errprintf("AR(%g) process is not stationary\n", length(phi))
	}
	else if (ec == `_ERROR_NOT_INVERTABLE') {
		errprintf("MA(%g) process is not invertible\n", length(theta))
	}
	else if (ec == `_ERROR_COMMON_ROOTS') {
		errprintf("{p}AR(%g) and MA(%g) polynomials have common ",
			length(phi), length(theta))
		errprintf("roots{p_end}\n")
	}
	else if (ec == `_ERROR_INVALID_FRACT_INT') {
		errprintf("{p}fractional integration parameter is out of ")
		errprintf("range{p_end}\n")
		rc = 3300
	}
	else if (ec == `_ERROR_SERIES_FAILURE') {
		errprintf("{p}computations for the hypergeometric series ")
		errprintf("coefficients failed{p_end}\n")
	}
	else if (ec == `_ERROR_ACF_FAILURE') {
		errprintf("{p}ACF for ARFMA(0,%g,0) process failed{p_end}\n", d)
	}
	else if (ec == `_ERROR_ARFIMA_PARAM') {
		errprintf("{p}one or more ARFIMA parameters are missing")
		errprintf("{p_end}\n")
	}
	else if (ec == `_ERROR_INVALID_VAR') {
		errprintf("{p}variance parameter is less than or equal to ")
		errprintf("zero{p_end}\n")
		rc = 3300
	}
	else {
		errprintf("failed to compute ACF\n")
	}
	exit(rc)
}

real colvector _arfimaacf(real scalar n, real colvector phi, 
		real colvector theta, real scalar d, real scalar v,
		real scalar ec)
{
	real scalar i, j, p, q, eps
	complex colvector phi1, theta1

	ec = 0
	eps = epsilon(2^20)
	if (missing(phi) | missing(theta) | missing(d) | missing(v)) {
		ec = `_ERROR_ARFIMA_PARAM'
		return(J(n+1,1,.))
	}
	if (d<=-1.0 | d>=0.5) {
		ec = `_ERROR_INVALID_FRACT_INT'
		return(J(n+1,1,.))
	}
	if ((q=length(theta))) {
		theta1 = C(theta)
		/* invertibility check					*/
		if (any(abs(theta1=polyroots((1,theta1'))'):<=1)) {
			ec = `_ERROR_NOT_INVERTABLE'
			return(J(n+1,1,.))
		}
		/* reset length in case theta is padded with zeros	*/
		q = length(theta1)
	}
	if ((p=length(phi))) {
		phi1 = C(phi)
		/* stationary check					*/
		if (any(abs(phi1=polyroots((1,-phi1'))'):<=1)) {
			ec = `_ERROR_NOT_STATIONARY'
			return(J(n+1,1,.))
		}
		/* reset length in case phi is padded with zeros	*/
		p = length(phi1)
		/* check for common roots				*/
		for (j=1; j<=q; j++) {
			for (i=1; i<=p; i++) {
				if (reldif(phi1[i],theta1[j])<eps) {
					ec = `_ERROR_COMMON_ROOTS'
					return(J(n+1,1,.))
				}
			}
		}
		phi1[.] = C(1):/phi1
	}
	if (v <= 0.0) {
		ec = `_ERROR_INVALID_VAR'
		return(J(n+1,1,.))
	}
	if (abs(d)<eps) return(_arma_acf(n,phi1,theta,v))

	return(_arfima_acf(n,phi1,theta,d,v,ec))
}

/* acf function in Palma (2007) eq. 3.22; Sowell (1992) eq. 9		*/
/* STATIC */
real colvector _arfima_acf(real scalar n, complex colvector phi, 
		real colvector theta, real scalar d, real scalar v,
		real scalar ec)
{
	real scalar p, q, pq1, pq2, g, hmin, hmax
	real colvector acf0
	real rowvector vh
	complex colvector psi
	complex rowvector xi, phi1
	complex matrix H

	pragma unset H

	/* assumption d != 0						*/
	ec = 0
	q = length(theta)
	p = length(phi)
	
	if (q) psi = C(_arfima_psi(theta))
	
	if (p) {
		/* stationary assumption 				*/
		/* AR(p): phi(L) = prod(1:-phi:*L)			*/
		/*  xi = 1:/(phi:*_arma_xi(phi))' 			*/
		/*  incorporate 1/phi in _hypergeometricseries_u()	*/
		xi = _arma_xi(phi)'
		/* full range of hypergeometric series coefficients	*/
		hmin = p-q-n
		hmax = -hmin
		vh = (hmin,hmax)
		phi1 = phi'

		/* hypergeometric series a = d, b = 1, c = 1-d, using	*/
		/*  variation by Doornik & Ooms (2003), p.339,		*/
		/*  g() = F()/phi -1.  We do not divide xi above by phi	*/
		if (_hypergeometricseries_u(vh,d,1-d,phi,H)) {
			ec = `_ERROR_SERIES_FAILURE'
			return(J(n+1,1,.))
		}
	}
	g = gamma(1-2*d)/gamma(1-d)/gamma(d)
	pq1 = p-q
	pq2 = p+q
	vh = (pq1-n,pq2)

	acf0 = _arfima_0d0_acf(vh,d,g)

	if (missing(acf0[1])) {
		ec = `_ERROR_SERIES_FAILURE'
		return(J(n+1,1,.))
	}
	return(arfimaacf_u(n,phi1,psi,H,acf0,xi,v))
}

/* Zinde-Walsh (1988), eqs. 4.3-4.6					*/
/* Karanasos (1998), eqs. 3.6, 3.6a, 3.6b				*/
/* STATIC */
real colvector _arma_acf(real scalar n, complex colvector phi, 
			real colvector theta, real scalar v)
{
	real scalar p, q, i, j, k, q1, n1, j1, j2
	complex scalar z
	complex rowvector xi
	complex colvector acf, ti, tp 
	complex matrix P, Q, L, R, S

	p = length(phi)
	q = length(theta)
	q1 = q+1
	n1 = n+1
	if (n1<p) n1 = p

	acf = J(n1,1,C(0))
	if (p) {
		/* assumption: stationary				*/
		/* AR(p): phi(L) = prod(1:-phi:*L)			*/
		xi = _arma_xi(phi)'

		P = J(n1,p,C(1))
		P[|2,1\2,p|] = phi'

		for (i=3; i<=n1; i++) {
			P[|i,1\i,p|] = P[|i-1,1\i-1,p|]:*phi'
		}
		xi[.] = P[|p,1\p,p|]:/xi
	}
	if (q) {
		/* assumption: invertible				*/
		tp = -theta
		ti = C((-1\tp))
		Q = J(q,q,C(0))
		for (j=1; j<=q; j++) {
			Q[|j,j\q,j|] = ti[|1\(q1-j)|]:*tp[|j\q|]
		}
	}
	if (p & q) {
		/* assumption: no common roots for AR and MA 		*/
		/*  polynomials						*/
		L = J(q1,p,C(sum(theta:^2)+1))
		S = J(q,p,C(0))
		R = J(2*q+1,p,C(1))
		j1 = q+2
		j2 = q
		for (j=1; j<=q; j++) {
			R[j1,.] = R[j1-1,.]:*phi'
			R[j2,.] = R[j2+1,.]:/phi'
			S[j,.] = colsum(Q[|j,j\q,j|]*(R[j1,.]:+R[j2,.]))
			j2 = j2 - 1
			j1 = j1 + 1		
		}
		for (j=1; j<=q; j++) {
			i = j+1
			j1 = q1+j
			L[1,.] = L[1,.] + colsum((2:*Q[|j,j\q,j|]*R[j1,.]))
			L[i,.] = L[i,.] + colsum(S[|1,1\j,p|])

			j1 = j1+1
			j2 = j1-2*j
			for (k=i; k<=q; k++) {
				L[i,.] = L[i,.]+colsum(Q[|k,k\q,k|]*
						(R[j1,.]:+R[j2,.]))
				j1 = j1 + 1
				j2 = j2 + 1
			}
		}
		/* section 4, corollary 1, Karanasos (1998)		*/
		z = C(1)
		for (i=1; i<=p; i++) z = z*L[q1,i]

		if (abs(z):<epsilon(1)) {
			errprintf("common roots in the AR and MA polynomials\n")
			acf[1] = C(.)
			return(Re(acf))
		}
		if (n > q) {
			acf = J(n1,1,C(0))
			P[.,.] = P:*xi
			acf[|1\q1|] = rowsum(L:*P[|1,1\q1,p|])
			acf[|q+2\n1|] = rowsum(J(n-q,1,L[q1,.]):*
					P[|q+2,1\n1,p|])
		}
		else acf = rowsum(L[|1,1\n1,p|]:*P)
	}
	else if (q) {
		acf = J(n+1,1,C(0))
		acf[1] = ti'ti
		q1 = q
		if (n<q) q1 = n

		for (j=1; j<=q1; j++) {
			acf[j+1] = sum(Q[|j,j\q,j|])
		}
	}
	else if (p) acf = C(rowsum(P:*xi))
	else acf[1] = 1

	if (v!=1.0) acf[.] = v:*acf

	if (n+1<p) acf = acf[|1\n+1|]

	return(Re(acf))
}

/* returns phi/xi(), xi() function in Palma (2007) eq. 3.22 		*/
/* STATIC */
complex colvector _arma_xi(numeric colvector phi)
{
	real scalar p
	complex matrix P1, P2

	p = length(phi)
	if (!p) return(1)

	P1 = 1:-phi*conj(phi')
	P2 = J(1,p,phi):-J(p,1,conj(phi'))
	_diag(P2,J(p,1,C(1)))

	return(_arma_colprod(P1:*P2))
}

/* STATIC */
numeric colvector _arma_colprod(numeric matrix X)
{
	real scalar i
	numeric colvector x
	
	x = X[.,1]

	for (i=2; i<=cols(X); i++) x[.] = x:*X[.,i]

	return(x)
}

/* autocovariance of ARFIMA(0,d,0), Palma (2007) eq. 3.21		*/
/* STATIC */
real colvector _arfima_0d0_acf(real vector h, real scalar d, |real scalar g)
{
	real scalar i, n
	real colvector vh, gv, g1

	n = h[2]-h[1]+1
	gv = J(n,1,0)
	if (d<=-1 | d>=0.5) {
		gv[1] = .
		return(gv)
	}
	if (missing(g)) g = gamma(1-2*d)/gamma(1-d)/gamma(d)

	if (h[1] >= 1) {
		vh = range(h[1],h[2],1)
		gv[.] = exp(lngamma(vh:+d):-lngamma(1:+vh:-d))
		i = 1
	}
	else {
		i = 0
		if (h[2] >= 0) {
			if (d > 0) {
				vh = range(max((0,h[1])),h[2],1)
				if (h[1]<0) i = -h[1]+1
				else i = 1
			}
			else if (h[2] >= 1) {
				vh = range(max((1,h[1])),h[2],1)
				if (h[1]<=0) i = -h[1]+2
				else i = 1
			}
		}
		if (i) {
			gv[|i\n|] = exp(lngamma(vh:+d):-lngamma(1:+vh:-d))
			n = i-1
		}
		if (n > 0) {
			if (d>0) vh = range(h[1],min((h[2],-1)),1)
			else vh = range(h[1],min((h[2],0)),1)

			g1 = gamma(vh:+d)
			i = sum(abs(g1):<=smallestdouble())+1
			if (i<=n) gv[|i\n|] = g1[|i\n|]:/gamma(1:+vh[|i\n|]:-d)

			/* asymptotic, h-> -inf				*/
			/* eq 8.328(2), Gradshteyn & Ryzhik (1980)	*/
			if (i>1) gv[|1\i-1|] = abs(vh[|1\i-1|]):^(2*d-1)
		}
	}
	gv[.] = g:*gv

	return(gv)
}

/* psi function, Palma (2007) eq. 3.22					*/
/* STATIC */
real colvector _arfima_psi(real colvector theta)
{
	real scalar q, i, k, q1
	real colvector psi, t

	q = length(theta)
	if (!q) return(1)

	t = (1\theta)
	psi = J(2*q+1,1,0)
	k = 2*q+2
	q1 = q+1
	for (i=q; i>=0; i--) psi[--k] = sum(t[|i+1\q1|]:*t[|1\q1-i|])

	/* symmetry							*/
	for (i=k-1; i>0; --i) psi[i] = psi[++k]
	
	return(psi)
}

end
exit

References:

Beran, J. (1998) Statistics for Long-Memory Processes. Chapman & Hall.

Doornik, J.A. and M. Ooms (2003) Computational aspects of maximum likelihood
   estimation of autoregressive fractionally integrated moving average models.
   Computational Statistics & Data Analysis 42, 333-348.

Gradshteyn, I.S. and I.M. Ryzhik. (1980) Tables of Integrals, Series, and 
   Products. Academic Press, Inc.

Karanasos, M. (1998) A new method for obtaining the autcovariance of an ARIMA
   model: an exact form solution. Econometric Theory 14, 622-640.

McLeod, I. (1975) Derivation of the theoretical autocovariance function of
   autoregressive-moving average time series. Applied Statistics 24, p255-256.

Palma, W. (2007) Long-Memory Time Series, Theory and Methods. Wiley.

Sowell, F. (1992), Maximum likelihood estimation of stationary univariate
   fractionally integrated time series models. Journal of Econometrics 53,
   165-188.

Zinde-Walsh, V. (1988), Some exact formulae for autoregressive moving average
   processes. Economic Theory, 4, 384-402.
