*! version 1.0.1  06nov2015
version 14

mata:

/* extract moptimize_init_*() options parsed by Stata program -mlopts-	*/
void moptimize_init_mlopts(transmorphic scalar M, string scalar mlopts)
{
	string scalar arg, arg1, tok
	transmorphic t, t1

	t = tokeninit(" ","","()")
	tokenset(t,mlopts)
	arg = tokenget(t)
	t1 = tokeninit("()")

	while (strlen(arg)) {
		arg1 = ""
		if (strmatch(arg,"trace")) {
			moptimize_init_trace_coefs(M, "on")
		}
		else if (strmatch(arg,"gradient")) {
			moptimize_init_trace_gradient(M, "on")
		}
		else if (strmatch(arg,"hessian")) {
			moptimize_init_trace_Hessian(M, "on")
		}
		else if (strmatch(arg,"showstep")) {
			moptimize_init_trace_step(M, "on")
		}
		else if (strmatch(arg,"nonrtolerance")) {
			moptimize_init_conv_ignorenrtol(M, "on")
		}
		else if (strmatch(arg,"showtolerance")) {
			moptimize_init_trace_tol(M, "on")
		}
		else if (strmatch(arg,"difficult")) {
			moptimize_init_singularHmethod(M, "hybrid")
		}
		else {
			arg1 = tokenget(t)
			tokenset(t1,arg1)
			tok = tokenget(t1)
			if (strmatch(arg,"technique")) {
				moptimize_init_technique(M, tok)
			}
			else if (strmatch(arg,"iterate")) {
				moptimize_init_conv_maxiter(M, strtoreal(tok))
			}
			else if (strmatch(arg,"tolerance")) {
				moptimize_init_conv_ptol(M, strtoreal(tok))
			}
			else if (strmatch(arg,"ltolerance")) {
				moptimize_init_conv_vtol(M, strtoreal(tok))
			}
			else if (strmatch(arg,"nrtolerance")) {
				moptimize_init_conv_nrtol(M, strtoreal(tok))
			}
			else {
				arg = arg1
			}
		}
		if (!strmatch(arg,arg1)) {
			arg = tokenget(t)
		}
	}
}

end
exit
