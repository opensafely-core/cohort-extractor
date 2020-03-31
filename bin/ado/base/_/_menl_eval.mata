*! version 1.0.4  24jul2018

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

local MENL_EM_DELTA_TRIANGULAR = 1

mata:

mata set matastrict on

/* moptimize nr evaluator for LME stage of Linstrom & Bates algorithm	*/
void _menl_lme_eval(transmorphic M, real scalar todo, real rowvector b,
		real colvector lf, real matrix g, real matrix H)
{
	real scalar rc, validate
	pointer (class __menl_lme) scalar lme

	lme = moptimize_util_userinfo(M,1)

	lme->set_todo(todo)
	/* validate RE covariances if mopt linear search & profile like	*/
	validate = (todo==0 & lme->algorithm()==`MENL_LBATES_LME_PROFILE')
	rc = lme->set_subexpr_coef(b,validate)
	if (rc) {
		if (rc==506 & !todo) {
			/* a covariance not positive definite
			 *  force a line search step half		*/
			lf = .
			lme = NULL
			return
		}
		errprintf("{p}%s{p_end}\n",lme->errmsg())
		lme = NULL
		exit(rc)
	}
	lf = lme->evaluate()
	if (todo) {
		g = _menl_derivatives(*lme,b)

		if (todo == 2) {
			H = _menl_Hessian(*lme,b)
		}
	}
	lme = NULL
}

/* moptimize q evaluator for NLS initial estimates			*/
void _menl_nls_eval(transmorphic M, real scalar todo, real rowvector b,
		real colvector r, real matrix S)
{
	real scalar rc
	pointer (class __menl_nls) scalar nls

	pragma unused todo
	pragma unused S

	nls = moptimize_util_userinfo(M,1)

	nls->set_todo(todo)
	if (rc=nls->set_subexpr_coef(b)) {
		if (rc & !todo) {
			/* bad step; force a step-halve			*/
			r = J(nls->n(),1,.)
			nls = NULL
			return
		}
		errprintf("{p}%s{p_end}\n",nls->errmsg())
		nls = NULL
		exit(rc)
	}
	r = nls->evaluate()
	if (todo) {
		S = _menl_scores(*nls,b,r)
	}
	nls = NULL
}

/* moptimize nr evaluator for NLM					*/
void _menl_nlm_eval(transmorphic M, real scalar todo, real rowvector b,
		real colvector lf, real matrix g, real matrix H)
{
	real scalar rc, validate
	pointer (class __menl_nlm) scalar nlm

	nlm = moptimize_util_userinfo(M,1)

	nlm->set_todo(todo)
	/* validate residual covariances if mopt linear search 		*/
	validate = (todo==0)
	rc = nlm->set_subexpr_coef(b,validate)
	if (rc) {
		if (rc==506 & !todo) {
			/* a covariance not positive definite
			 *  force a line search step half		*/
			lf = .
			nlm = NULL
			return
		}
		errprintf("{p}%s{p_end}\n",nlm->errmsg())
		nlm = NULL
		exit(rc)
	}
	lf = nlm->evaluate()
	if (todo) {
		g = _menl_derivatives(*nlm,b)
		if (todo == 2) {
			H = _menl_Hessian(*nlm,b)
		}
	}
	nlm = NULL
}

/* moptimize q evaluator for GNLS				*/
void _menl_gnls_eval(transmorphic M, real scalar todo, real rowvector b,
		real colvector r, real matrix S)
{
	real scalar rc
	pointer (class __menl_gnls) scalar gnls

	pragma unused todo
	pragma unused S

	gnls = moptimize_util_userinfo(M,1)

	gnls->set_todo(todo)
	if (rc=gnls->set_subexpr_coef(b)) {
		if (rc & !todo) {
			/* bad step; force a step-halve			*/
			r = J(gnls->n(),1,.)
			gnls = NULL
			return
		}
		errprintf("{p}%s{p_end}\n",gnls->errmsg())
		gnls = NULL
		exit(rc)
	}
	r = gnls->evaluate()
	if (todo) {
		S = _menl_scores(*gnls,b,r)
	}
	gnls = NULL
}

real matrix _menl_scores(class __menl_lbates_base obj, real rowvector b0,
                real colvector f)
{
        real scalar i, k, del, n, bi, rc, eps, cns
	real rowvector b, b1, a
        string scalar errmsg
        real matrix S, F, T

	pragma unset T
	pragma unset a

        rc = 0
        eps = epsilon(1)^(1/3)

	if (cns=obj.constraint_T_a(T,a)) {
		b = b0*T
	}
	else {
		b = b0
	}
        k = cols(b)
        n = rows(f)
        S = J(n,k,0)
	F = J(n,2,0)
        for (i=1; i<=k; i++) {
                bi = b[i]
                del = eps*(abs(bi)+eps)

                b[i] = bi + del
		if (cns) {
			b1 = b*T' + a
		}
		else {
			b1 = b
		}
                if (rc=obj.set_subexpr_coef(b1)) {
                	b[i] = bi
                        errmsg = obj.errmsg()
                        break
                }
                F[.,1] = obj.evaluate()

                b[i] = bi - del
		if (cns) {
			b1 = b*T' + a
		}
		else {
			b1 = b
		}
                if (rc=obj.set_subexpr_coef(b1)) {
                	b[i] = bi
                        errmsg = obj.errmsg()
                        break
                }
                F[.,2] = -obj.evaluate()
                b[i] = bi
                if (missing(F)) {
                       rc = 498
                        errmsg = "function evaluation resulted in missing " +
                                "values while computing scores"
                        break
                }
                S[.,i] = quadrowsum(F):/(2*del)
        }
	if (cns) {
		S = S*T'
	}
        /* put back original                                            */
        if (rc=obj.set_subexpr_coef(b0)) {
                errmsg = obj.errmsg()
        }
        if (rc) {
                errprintf("{p}%s; computations cannot proceed{p_end}\n",errmsg)
                exit(rc)
        }
        return(S)
}

real matrix _menl_derivatives(class __menl_lbates_base obj, real rowvector b)
{
	real scalar eps, cns
	real rowvector del, g, a
	real matrix G, T

	pragma unset del
	pragma unset G
	pragma unset a
	pragma unset T

	eps = epsilon(1)^(1/3)

	if (cns=obj.constraint_T_a(T,a)) {
		_menl_function_delta(obj,b,eps,G,del,`MENL_FALSE',T,a)
	}
	else {
		_menl_function_delta(obj,b,eps,G,del)
	}
	g = quadcolsum(G):/(2:*del)
	if (cns) {
		g = g*T'
	}

	return(g)
}

void _menl_function_delta(class __menl_lbates_base obj, real rowvector b,
		real scalar eps, real matrix G, real rowvector del, 
		|real scalar mydel, real matrix T, real matrix a)
{
	real scalar i, k, bi, rc, cns
	real rowvector b0, b1
	string scalar errmsg

	cns = args()==8
	mydel = (missing(mydel)?`MENL_FALSE':(mydel!=`MENL_FALSE'))
	rc = 0
	b0 = b
	if (cns) {
		b0 = b0*T
	}
	k = cols(b0)
	if (!mydel) {
		del = J(1,k,0)
	}
	G = J(2,k,0)
	for (i=1; i<=k; i++) {
		bi = b0[i]
		if (mydel == `MENL_FALSE') {
			del[i] = eps*(abs(bi)+eps)
		}
		b0[i] = bi + del[i]
		if (cns) {
			b1 = b0*T'+a
		}
		else {
			b1 = b0
		}
		if (rc=obj.set_subexpr_coef(b1)) {
			b0[i] = bi
			errmsg = obj.errmsg()
			break
		}
		G[1,i] = obj.evaluate()

		b0[i] = bi - del[i]
		if (cns) {
			b1 = b0*T'+a
		}
		else {
			b1 = b0
		}
		if (rc=obj.set_subexpr_coef(b1)) {
			b[i] = bi
			errmsg = obj.errmsg()
			break
		}
		G[2,i] = -obj.evaluate()
		b0[i] = bi
		if (missing(G[.,i])) {
			rc = 498
			errmsg = "function evaluation resulted in missing " +
				"values while computing derivatives"
			break
		}
	}
	/* put back original						*/
	if (rc=obj.set_subexpr_coef(b)) {
		errmsg = obj.errmsg()
	}
	if (rc) {
		errprintf("{p}%s; computations cannot proceed{p_end}\n",errmsg)
		exit(rc)
	}
}
real matrix _menl_Hessian(class __menl_lbates_base obj, real rowvector b)
{
	real scalar i, k, eps, del, bi, rc, zero, mydel, cns
	string scalar errmsg
	real rowvector del1, b0, b1, a
	real matrix G1, G2, H, T

	pragma unset del1
	pragma unset a
	pragma unset T
	pragma unset G1
	pragma unset G2

	rc = 0
	mydel = `MENL_TRUE'
	zero = epsilon(1)
	eps = zero^(1/4)
	b0 = b
	if (cns=obj.constraint_T_a(T,a)) {
		b0 = b0*T
	}
	k = cols(b0)
	H = J(k,k,0)
	
	for (i=1; i<=k; i++) {
		bi = b0[i]
		if (abs(bi)<zero) {
			del = eps
		}
		else {
			del = eps*(abs(bi)+eps)
		}

		b0[i] = bi + del
		if (cns) {
			b1 = b0*T' + a
			_menl_function_delta(obj,b1,eps,G1,del1,0,T,a)
		}
		else {
			_menl_function_delta(obj,b0,eps,G1,del1)
		}	

		b0[i] = bi - del
		if (cns) {
			b1 = b0*T' + a
			_menl_function_delta(obj,b1,eps,G2,del1,mydel,T,a)
		}
		else {
			_menl_function_delta(obj,b0,eps,G2,del1,mydel)
		}
		H[i,.] = quadcolsum(G1\-G2):/(4*del:*del1)
		b0[i] = bi
	}
	/* put back original						*/
	if (rc=obj.set_subexpr_coef(b)) {
		errmsg = obj.errmsg()
	}
	if (rc) {
		errprintf("{p}%s; computations cannot proceed{p_end}\n",errmsg)
		exit(rc)
	}
	if (cns) {
		H = T*H*T'
	}
	H = (H+H'):/2	// make symmetric

	return(H)
}

end
exit
