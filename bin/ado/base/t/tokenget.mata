*! version 1.0.0  05feb2015

/*
	t = tokeninit([wchars [, pchars [, qchars [, allownum [, allowhex]]]]])

	t = tokeninitstata()

	void             tokenset(t, string scalar s)

	string rowvector tokengetall(t)
	string scalar    tokenget(t)
	string scalar    tokenpeek(t)
	string scalar    tokenrest(t)

	real scalar      tokenoffset(t)
        void             tokenoffset(t, real scalar offset)

	string scalar    tokenwchars(t)
	void             tokenwchars(t, string scalar wchars)

	string rowvector tokenpchars(t)
	void             tokenpchars(t, string rowvector pchars)

	string rowvector tokenqchars(t)
	void             tokenqchars(t, string rowvector qchars)

	real scalar      tokenallownum(t)
	void             tokenallownum(t, real scalar allownum)

	real scalar      tokenallowhex(t)
	void             tokenallowhex(t, real scalar allowhex)
	
	where, 

		transmorphic      t              (handle)

		string scalar     wchars         (white-space characters)
		string rowvector  pchars         (parsing characters)
		string rowvector  qchars         (quote characters)

		real scalar       allownum       (parse numbers)
		real scalar       allowhex       (parse hex numbers)
*/

version 10.0

local Tinfo	"struct tokeninfo scalar"

mata:
	
struct tokeninfo {
	pointer(string scalar) scalar	pstr
	real scalar			offset
	string scalar			wchars, orig_wchars
	string rowvector		pchars, orig_pchars
	string rowvector		qchars, orig_qchars
	string scalar			stopchars
	real scalar			allownumhex
}



`Tinfo' tokeninit(| string scalar     wchars,
		    string rowvector  pchars,
		    string rowvector  qchars, 
		    real scalar       allownum,
		    real scalar	      allowhex
		 )
{
	`Tinfo'		t
	real scalar	args

	t.pstr = NULL
	t.offset = 0

	args = args()

	t.orig_wchars = (args<1 ? " " : wchars)
	t.orig_pchars = pchars
	t.orig_qchars = (args<3 ? (`""""', `"`""'"') : qchars)

	_token_init(t, 
			t.orig_wchars,
			t.orig_pchars,
			t.orig_qchars, 
			(args<4 ? 0 : allownum),
			(args<5 ? 0 : allowhex)
		  )
	// _token_dump(t)
	return(t)
}


`Tinfo' tokeninitstata()
{
	return(tokeninit(
		" ", 
		(	"\", "~", "!", "=", ":", ";", ",", 
			"?", "!", "@", "#", 
			"==", "!=", ">=", "<=", "<", ">",
			"&", "|", "&&", "||", 
			"+", "-", "++", "--", "*", "/", "^",
			"(", ")", "[", "]", "{", "}"
		),

		(
			`""""', `"`""'"', char(96)+char(39)
		),
		1, 1)
	)
}


void tokenset(`Tinfo' t, string scalar s)
{
	t.pstr = &s 
	t.offset = 0
}


string rowvector tokengetall(`Tinfo' t)
{
	string rowvector	res
	real scalar		i, base

	res = J(1, 100, "")
	base = 0
	while (1) { 
		for (i=1; i<=100; i++) {
			if ((res[base+i] = tokenget(t))=="") {
				base = base + i - 1 
				return(base ? res[|1\base|] : J(1,0,""))
			}
		}
		res = res, J(1, 100, "")
		base = base + 100
	}
	/*NOTREACHED*/
}

string scalar tokenget(`Tinfo' t)
{
	return(_tokenget(*t.pstr, t.offset, 
			t.wchars, t.pchars, t.qchars,
			t.stopchars,
			t.allownumhex))
	/* Built-in routine _tokenget() performs tokenget() but, 
	   rather than taking the structure as an argument, it 
	   requires the members of the structures.
	*/
}


string scalar tokenpeek(`Tinfo' t)
{
	real scalar	offset
	string scalar	result

	offset = t.offset 
	result = tokenget(t)
	t.offset = offset
	return(result)
}

string scalar tokenrest(`Tinfo' t)
{
	return(bsubstr(*t.pstr, t.offset+1, .))
}


transmorphic tokenoffset(`Tinfo' t, |real scalar offset)
{
	real scalar	off, len

	if (args()==1) return(t.offset+1)

	off = offset-1
	if (off<0) off = 0 
	else if (off>(len=strlen(*t.pstr))) off = len
	t.offset = off
	return
}


transmorphic tokenwchars(`Tinfo' t, |string scalar wchars)
{
	if (args()==1) return(t.orig_wchars)
	t.orig_wchars = wchars
	_token_init_chars(t, t.orig_wchars, t.orig_pchars, t.orig_qchars)
}


transmorphic tokenpchars(`Tinfo' t, |string rowvector pchars)
{
	if (args()==1) return(t.orig_pchars)
	t.orig_pchars = pchars
	_token_init_chars(t, t.orig_wchars, t.orig_pchars, t.orig_qchars)
}


transmorphic tokenqchars(`Tinfo' t, |string rowvector qchars)
{
	if (args()==1) return(t.orig_qchars)
	t.orig_qchars = qchars
	_token_init_chars(t, t.orig_wchars, t.orig_pchars, t.orig_qchars)
}

transmorphic tokenallownum(`Tinfo' t, |real scalar allownum)
{
	real scalar	oldallownum, oldallowhex

	oldallownum = floor(t.allownumhex/2)
	oldallowhex = t.allownumhex - 2*oldallownum

	if (args()==1) return(oldallownum)
	_token_init_allownumhex(t, allownum, oldallowhex)
}

transmorphic tokenallowhex(`Tinfo' t, |real scalar allowhex)
{
	real scalar	oldallownum, oldallowhex

	oldallownum = floor(t.allownumhex/2)
	oldallowhex = t.allownumhex - 2*oldallownum

	if (args()==1) return(oldallowhex)
	_token_init_allownumhex(t, oldallownum, allowhex)
}


/* -------------------------------------------------------------------- */

/* static */ void _token_init(`Tinfo' t, 
		string scalar     wchars, 
		string rowvector  pchars,
		string rowvector  qchars,
		real scalar	  allownum,
		real scalar	  allowhex)
{
	_token_init_allownumhex(t, allownum, allowhex)
	_token_init_chars(t, wchars, pchars, qchars)
}


/* static */ void _token_init_allownumhex(`Tinfo' t, 
			real scalar allowhex, real scalar allownum)
{
	t.allownumhex = (allownum==1)*2 + (allowhex==1)
}


/* static */ void _token_init_chars(`Tinfo' t, 
		string scalar     wchars, 
		string rowvector  pchars,
		string rowvector  qchars)
{
	real scalar		i, n, n1, n2, base, n3
	real rowvector		len
	string colvector	w
	string rowvector	stopchars

	/* ------------------------------------------------------------ */
	t.wchars = wchars

	/* ------------------------------------------------------------ */
	t.qchars = _token_order_chars(qchars)
	_token_verify_qchars(t.qchars)

	/* ------------------------------------------------------------ */
	if (length(t.qchars)) {
		len = strlen(t.qchars):/2
		t.pchars = _token_order_chars(
				(pchars, 
				 bsubstr(t.qchars, 1, len), 
				 bsubstr(t.qchars, len:+1, .)
				)
			    )
	}
	else {
		t.pchars = _token_order_chars(pchars)
	}
	/* ------------------------------------------------------------ */
	n1 = strlen(wchars)
	n2 = length(t.pchars)
	n3 = length(t.qchars)

	if (n = n1+n2+2*n3) {
		w = J(n, 1, "")
		for (i=1; i<=n1; i++) w[i] = bsubstr(wchars, i, 1)
		if (n2) w[|n1+1\n1+n2|] = bsubstr(t.pchars,1,1)'
		if (n3) {
			base = n1+n2
			w[|base+1\base+n3|] = bsubstr(t.qchars,1,1)'
			base = base + n3
			for (i=1; i<=n3; i++) {
				w[base+i] = bsubstr(t.qchars[i], 
						   strlen(t.qchars[i])/2+1, 1)
			}
		}
		w = uniqrows(w)
		stopchars = ""
		for (i=1; i<=length(w); i++) stopchars = stopchars + w[i]
		t.stopchars = stopchars
	}
	else 	t.stopchars = ""
	/* ------------------------------------------------------------ */
}

/* static */ string rowvector _token_order_chars(string rowvector chars)
{
	string colvector	w
	real colvector		x
	real scalar		n, l, i, j

	if ((n=length(chars))==0) return(chars)
	if (l = sum(chars:=="")) {
		if (l==n) return(J(1, 0, ""))
		w = J(n-l, 1, "")
		for (i=j=1; i<=n; i++) {
			if (chars[i]!="") w[j++] = chars[i]
		}
	}
	else	w = chars'

	w = uniqrows(w)
	x = sort( ((1::length(w)), (-strlen(w))), (2,1))
	return((w[x[,1]])')
}

/* static */ void _token_verify_qchars(string rowvector qchars)
{
	real scalar		i, n, l
	string colvector	w, rhs, lhs
	real rowvector		lens

	if ((n = length(qchars))==0) return
	lens = strlen(qchars)
	if (sum(lens:==2) + sum(lens:==4) == n) {
		w = qchars'
		lhs = rhs = J(n, 1, "")
		for (i=1; i<=n; i++) {
			lhs[i] = bsubstr(w[i], 1, l = lens[i]/2)
			rhs[i] = bsubstr(w[i], l+1, .)
		}
		if (length(uniqrows(lhs))==n &
		    length(uniqrows(rhs))==n ) return
	}
	_error("argument qchars invalid")
}



/* -- BEGIN COMMENTED OUT CODE ----------------------------------------
void _token_dump(`Tinfo' t)
{
	real scalar	i

	if (t.pstr!=NULL) {
		printf("*t.pstr   = |%s|\n", *t.pstr)
	}
	else	printf(" t.pstr   = NULL\n")

	printf(" t.offset = %g\n", t.offset)
	printf(" t.wchars = |%s|\n", t.wchars)

	printf(" t.pchars =")
	for (i=1; i<=length(t.pchars); i++) {
		printf(" |%s|", t.pchars[i])
	}
	printf("\n") 

	printf(" t.qchars =")
	for (i=1; i<=length(t.qchars); i++) {
		printf(" |%s|", t.qchars[i])
	}
	printf("\n") 

	printf(" t.stopch = |%s|\n", t.stopchars)
	printf(" t.allow  = %g\n", t.allownumhex)
	
}
---------------------------------------------END COMMENTED OUT CODE --- */

end
