*! version 1.0.1  06nov2017

local tol = 1e-10

mata

void _boxcox_smearing(string scalar smear, string vector ntvars, ///
string vector tvars, real scalar yore, string scalar touse, ///
real scalar zero)

{
	real matrix Xn, Xt
	real scalar theta, lambda, knt, kt
	real vector y, beta, ind, betan, betat
	string matrix stripe 
	string scalar model

	pragma unused yore

	model = st_global("e(model)")
	beta = st_matrix("e(b)")
	stripe = st_matrixcolstripe("e(b)")
	ntvars = tokens(ntvars)
	knt = length(ntvars)
	tvars = tokens(tvars)
	kt = length(tvars)

	if (knt) {
		
		Xn    = st_data(., ntvars, touse)
		betan = select(beta, (stripe[.,1]:=="Notrans")')
	}
	if (kt) {

		Xt    = st_data(., tvars, touse)
		betat = select(beta, (stripe[.,1]:=="Trans")')
	}

	y    = st_data(., st_global("e(depvar)"), touse)
	
	ind = (stripe[.,1]:=="lambda")'
	
	if (any(ind)) {
	
		lambda = select(beta, ind)
	} 
	ind[.] = (stripe[.,1]:=="theta")'

	if (any(ind)) {

		theta = select(beta, ind) 
	}
	
	if (model=="lhsonly") {

		 _boxcox_lhs(theta, betan, Xn, y, zero)
	}
	else if (model=="lambda") {

		_boxcox_lambda(lambda, betan, betat, Xn, Xt, y, zero)
	}
	else if (model=="theta") {

		 _boxcox_theta(theta, lambda, betan, betat, ///
			Xn, Xt, y, zero)
	}
	else if (model=="rhsonly") {

		_boxcox_rhs(lambda, betan, betat, Xn, Xt, y)
	}

	st_store(., smear, touse, y)
}

/* STATIC */

void _boxcox_lhs(real scalar theta, real vector betan, real matrix Xn, 
real vector y, real scalar zero)

{

	real vector ehat, xb
	real scalar nc, n, i, nc2, pw
	
	n    = rows(y)
	xb   = Xn*betan'
	
	if (abs(theta) > `tol') {

		y[.] = (y:^theta :-1)/theta
		pw   = 1/theta

		if (zero == 1) {	
			
			ehat = y - xb

			if (1) {

				 _boxcox_smearing_u(theta, xb, ehat, y)
			}
			else {
				for (i = 1; i<=n; i++) {

					nc2    = theta*(xb[i] :+ ehat) :+ 1			
					nc     = sum(nc2 :>0 :&  nc2 :!=.)
	
					if (colmissing(nc2)==n) {
	
						y[i]= .
					}
					else {
	
						y[i] = (1/nc)*sum((nc2):^(pw))
					}
				}
			}
		}
		else if (zero == 0) {
		
			y[.] = (theta*xb :+ 1):^pw
		}
	}
	else {	
		y[.] = ln(y)
		ehat = y - xb

		if (zero == 1) {
		
			for (i = 1; i<=n; i++) {
	
				nc2    = exp(xb[i] :+ ehat)
				nc     = sum(nc2 :>0 :&  nc2 :!=.)
	
				if (colmissing(nc2)==n) {
	
					y[i]= .
				}
				else {

					y[i] = (1/nc)*sum(nc2)
				}
			}	
		}
		else if (zero == 0) {

			y[.] = exp(xb)
		}
	}


}

void _boxcox_lambda(real scalar lambda, real vector betan, real vector betat,
real matrix Xn, real matrix Xt, real vector y, real scalar zero)

{

	real vector ehat, xb
	real scalar nc, n, i, nc2, pw
	n    = rows(y)

	if (abs(lambda) > `tol') {
		
		y[.] = (y:^lambda :-1)/lambda
		pw   = 1/lambda
		Xt[.,.] = (Xt:^lambda :-1)/lambda
		xb   = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}

		if (zero==1) {
		
			ehat = y - xb

			if (1) {

				_boxcox_smearing_u(lambda, xb, ehat, y)
			}
			else {	
				for (i = 1; i<=n; i++) {
	
					nc2    = lambda*(xb[i] :+ ehat) :+ 1
					nc     = sum(nc2 :>0 :&  nc2 :!=.)
	
					if (colmissing(nc2)==n) {
	
						y[i]= .
					}
					else {
	
						y[i] = (1/nc)*sum((nc2):^(pw))
					}
				}
			}
		}
		else if (zero==0) {

			y[.] = (lambda*xb :+1):^pw
		}
	}
	else {
	
		y[.] = ln(y)
		Xt[.,.] = ln(Xt)
		xb      = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}

		if (zero==1) {
			ehat = y -xb
			for (i = 1; i<=n; i++) {
	
				nc2    = exp(xb[i] :+ ehat)
				nc     = sum(nc2 :>0 :&  nc2 :!=.)
		
				if (colmissing(nc2)==n) {
	
					y[i]= .
				}
				else {
	
					y[i] = (1/nc)*sum((nc2))
				}
			}
		}
		else if (zero==0) {
	
			y[.] = exp(xb)
		}
	}
}

void _boxcox_theta(real scalar theta, real scalar lambda, real vector betan, 
real vector betat, real matrix Xn, real matrix Xt, real vector y, ///
real scalar zero)

{

	real vector ehat, xb
	real scalar nc, n, i, nc2, pw
	n    = rows(y)
	
	if (abs(lambda) > `tol' & abs(theta)>`tol') {

		y[.] = (y:^theta :-1)/theta
		pw   = 1/theta
		Xt[.,.] = (Xt:^lambda :-1)/lambda
		xb   = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}

		if (zero == 1) { 
		ehat = y - xb	 
		
			if (1) {

				_boxcox_smearing_u(theta, xb, ehat, y)
			}
			else {
				for (i = 1; i<=n; i++) {
	
					nc2    = theta*(xb[i] :+ ehat) :+ 1
					nc     = sum(nc2 :>0 :&  nc2 :!=.)
			
					if (colmissing(nc2)==n) {
	
						y[i]= .
					}
					else {
	
						y[i] = (1/nc)*sum((nc2):^(pw))
					}
				}
			}
		}
		else if (zero == 0) {

			y[.] = (theta*xb :+ 1):^pw
		}
	}
	if  (abs(lambda) > `tol' & abs(theta) <=`tol') {

		y[.] = ln(y)
		Xt[.,.] = (Xt:^lambda :-1)/lambda
		xb   = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}
		if (zero == 1) {
		
			ehat = y - xb	 
		
			for (i = 1; i<=n; i++) {
	
				nc2    = exp(xb[i] :+ ehat)	
				nc     = sum(nc2 :>0 :&  nc2 :!=.)
	
				if (colmissing(nc2)==n) {
	
					y[i]= .
				}
				else {
	
					y[i] = (1/nc)*sum(nc2)
				}
			}
		}
		else if (zero==0) {
		
			y[.] = exp(xb)
		}
	}
	if  (abs(lambda) <= `tol' & abs(theta) <=`tol') {

		y[.] = ln(y)
		Xt[.,.] = ln(Xt)
		xb      = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}
		
		if (zero == 1) {
		
			ehat = y -xb
			
			for (i = 1; i<=n; i++) {
	
				nc2    = exp(xb[i] :+ ehat)	
				nc     = sum(nc2 :>0 :&  nc2 :!=.)

				if (colmissing(nc2)==n) {
	
					y[i]= .
				}
				else {
	
					y[i] = (1/nc)*sum((nc2))
				}
			}
		}
		else if (zero==0) {

			y[.] = exp(xb)
		}
	}

	if  (abs(lambda) <= `tol' & abs(theta) > `tol') {

		y[.] = (y:^theta :-1)/theta
		pw   = 1/theta
		Xt[.,.] = ln(Xt)
		xb      = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}
		
		if (zero == 1) {
	
			ehat = y -xb

			for (i = 1; i<=n; i++) {
	
				nc2    = theta*(xb[i] :+ ehat) :+ 1
				nc     = sum(nc2 :>0 :&  nc2 :!=.)
	
				if (colmissing(nc2)==n) {
	
					y[i]= .
				}
				else {
	
					y[i] = (1/nc)*sum((nc2):^(pw))
				}
			}
		}
		else if (zero == 0) {
	
			y[.] = (theta*xb :+1):^pw
		}
	}  
}

void _boxcox_rhs(real scalar lambda, real vector betan, real vector betat,
real matrix Xn, real matrix Xt, real vector y)

{

	real vector xb


	if (abs(lambda) > `tol') {
		
		Xt[.,.] = (Xt:^lambda :-1)/lambda
		xb   = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}

		y[.] = xb
	}	
	else {

		Xt[.,.] = ln(Xt)
		xb      = Xt*betat'

		if (rows(Xn)) {

			xb[.]= xb + Xn*betan'
		}
		
		y[.] = xb

	}
}


end
