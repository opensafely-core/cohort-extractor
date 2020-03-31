*! version 1.0.2  19dec2017

local STATE_START 	1
local STATE_NAME 	2
local STATE_VALUE  	3

local FALSE	0
local TRUE	1

mata:

mata set matastrict on 

real scalar _initial_numlist_copy(string scalar numlist, real rowvector b, 
			|string scalar errmsg)
{
	real scalar i, k, k1, kt, val
	string vector tokens

	errmsg = ""
	tokens = tokens(numlist)
	kt = length(tokens)
	k = cols(b)
	k1 = min((k,kt))
	for (i=1; i<=k1; i++) {
		val = strtoreal(tokens[i])
		if (missing(val)) {
			errmsg = sprintf("the %gth value of the number " +
				"list {bf:%s} is not valid",i,tokens[i])
			return(109)
		}
		b[i] = val
	}
	return(0)
}

real scalar _initial_vector_copy(real rowvector b0, real rowvector b, 
				|string scalar errmsg)
{
	real scalar k

	errmsg = ""
	k = min((cols(b0),cols(b)))
	b[|1\k|] = b0[|1\k|]

	return(0)
}

real scalar _initial_vector_byname(real rowvector b0, string matrix stripe0,
			real rowvector b, string matrix stripe, 
			|real scalar skip, string scalar errmsg)
{
	real scalar i, k0, k, rc

	rc = 0
	skip = (missing(skip)?`FALSE':(skip!=`FALSE'))
	errmsg = ""
	k0 = cols(b0)
	if (rows(stripe0)!=k0 | cols(stripe0)!=2) {
		errmsg = sprintf("invalid stripe matrix; expected a %g x 2 " +
				"string matrix",k0)
		return(503)
	}
	k = cols(b)
	if (rows(stripe)!=k | cols(stripe)!=2) {
		errmsg = sprintf("invalid stripe matrix; expected a %g x 2 " +
				"string matrix",k)
		return(503)
	}
	for (i=1; i<=k0; i++) {
		rc = initial_set_vector_value(stripe0[i,1],stripe0[i,2],b0[1,i],
				b,stripe,skip,errmsg)
		if (rc) {
			break
		}
	}
	return(rc)
}

string scalar initial_strip_omitted(string scalar stro)
{
	string scalar str, tok
	transmorphic t

	t = tokeninit("","o.")
	tokenset(t,stro)
	str = ""
	while (ustrlen(tok=tokenget(t)))
	{
		if (tok == "o.") {
			str = str + "."
		}
		else {
			str = str + tok
		}
	}
	return(str)
}

real scalar initial_set_vector_value(string scalar eq0, string vector param,
			transmorphic value, real rowvector b,
			string matrix stripe, |real scalar skip,
			string scalar errmsg)
{
	real scalar slash, i, j, k, kp, keq, x
	string scalar eq, tname
	real colvector ieq, ip
	string colvector params

	if (isstring(value)) {
		tname = st_tempname()
	}
	skip = (missing(skip)?`FALSE':(skip!=`FALSE'))
	slash = `FALSE'
	eq = eq0
	k = cols(b)
	if (!strlen(eq)) {
		slash = `TRUE'
	}
	else {
		ieq = (eq:==stripe[.,1])
		slash = !any(ieq)
	}
	if (slash) {
		eq  = "/"+eq
		ieq = (eq:==stripe[.,1])
	}
	if (!any(ieq)) {
		if (skip) {
			return(0)
		}
		if (eq == "/") {
			errmsg = sprintf("free parameter {bf:%s} not found",
				param[1])
		}
		else {
			errmsg = sprintf("equation {bf:%s} not found",eq0)
		}
		return(507)
	}
	ieq = select(1..k,ieq')'
	keq = length(ieq)
	if (!(kp=length(param))) {
		/* make repeated calls in case of value = runiform()	*/
		for (i=1; i<=keq; i++) {
			if (isstring(value)) {
				x = _parse_initial_get_value(value,tname)
				if (missing(x)) {
					errmsg = sprintf("initialization " +
						"expression {bf:%s} does " +
						"not evaluate to a real " +
						"value",value)
					return(416)
				}
			}
			else {
				x = value
			}
			b[1,ieq[i]] = x
		}
	}
	else {
		params = stripe[ieq,2]
		for (i=1; i<=kp; i++) {
			ip = (param[i]:==params)
			if (!any(ip)) {
				if (skip) {
					return(0)
				}
				errmsg = sprintf("coefficient {bf:%s:%s} not " +
					"found",eq0,param[i])
				return(507)
			}
			if (sum(ip) > 1) {
				errmsg = sprintf("multiple definitions of " +
					"coefficient {bf:%s:%s} found",eq0,
					param[i])
				return(507)
			}
			j = select(ieq',ip')[1]
			if (isstring(value)) {
				x = _parse_initial_get_value(value,tname)
				if (missing(x)) {
					errmsg = sprintf("initialization " +
						"expression {bf:%s} does not " +
						"evaluate to a real value",
						value)
					return(416)
				}
			}
			else {
				x = value
			}
			b[1,j] = x
		}
	}
	return(0)
}

real scalar _parse_initial_vector(string scalar values0, real rowvector b, 
			string matrix stripe, |real scalar skip,
			string scalar errmsg)
{
	real scalar k, state, rc
	string scalar tok, tok1, expr, values
	string vector names
	transmorphic tp

	skip = (missing(skip)?`FALSE':(skip!=`FALSE'))
	values = ustrtrim(values0)
	if (!ustrlen(values)) {
		return(0)	// nothing to do
	}
	k = cols(b)
	if (rows(stripe)!=k | cols(stripe)!=2) {
		errmsg = sprintf("invalid stripe matrix; expected a %g x 2 " +
			"string matrix",k)
		return(503)
	}
	rc = 0
	tok1 = ""
	names = J(1,0,"")
	tp = tokeninit(" ",("="),("{}"))
	tokenset(tp, values)
	state = `STATE_START'
	while ((tok=tokenget(tp)) != "") {
		tok = strtrim(tok)
		if (!(k=strlen(tok))) {
			continue	// should not happen
		}
		if (state <= `STATE_NAME') {
			if (state == `STATE_START' & length(names)) {
				errmsg = sprintf("no initial values " +
					"specified for parameters {bf:%s}",
					invtokens(names,"}, {bf:"))
				return(198)
			}
			rc = _initial_get_vec_names(tok,names,state)
			if (rc) {
				/* add some context			*/
				if (k==1 & tok=="{") {
					expr = "{char 123}"+tokenpeek(tp)
				}
				else if (strlen(tok1)) {
					expr = tok1+" "+tok+" "+tokenpeek(tp)
				}
				else {
					expr = tok+" "+tokenpeek(tp)
				}
			}
		}
		if (state == `STATE_VALUE') {
			if (tok == "=") {
				tok1 = tok1+tok
				tok = tokenget(tp)
			}
			rc = _parse_initial_set_matrix(names,tok,b,stripe,
					skip,errmsg)
			if (rc) {
				return(rc)
			}
			/* ready for next param specification		*/
			state = `STATE_START'
			names = J(1,0,"")
		}
		if (rc) {
			errmsg = sprintf("invalid initialization expression " +
				"{bf:%s}", expr)
			return(rc)
		}

		tok1 = tok
	}
	if (!rc & state!=`STATE_START') {
		if (length(names)) {
			errmsg = sprintf("no initial values specified for " +
				"parameters {bf:%s}",invtokens(names,"}, {bf:"))
		}
		else {
			errmsg = "an error occurred while parsing initial " +
				"values"
		}
		return(198)
	}
	return(0)
}

real scalar _initial_get_vec_names(string scalar expr0, string vector names0,
			real scalar state)
{
	real scalar k, rc
	string scalar expr, c
	string vector names

	k = strlen(expr0)
	names = J(1,0,"")
	c = substr(expr0,1,1)
	if (c=="{" | c=="/") {
		if (k == 1) {
			return(198)
		}
		k--
		if (c == "{") {
			k--
		}
		expr = strtrim(substr(expr0,2,k))
		if (rc=_initial_get_vec_names1(expr,names)) {
			return(rc)
		}
	}
	else if (st_isname(expr0)) {
		names = J(1,1,expr0)
	}
	else if (!missing(strtoreal(expr0))) {
		state = `STATE_VALUE'
		return(0)
	}
	else if (rc=_initial_get_vec_names1(expr0,names)) {
		if (length(names0)) {
			state = `STATE_VALUE'
			return(0)
		}
		else {
			return(rc)
		}
	}
	names0 = (names0,names)
	state = `STATE_NAME'

	return(0)
} 

real scalar _initial_get_vec_names1(string scalar expr, string vector names)
{
	real scalar k
	string vector tokens
	transmorphic te

	/* check for eq:name1 name2 ...					*/
	te = tokeninit("",(":"))
	tokenset(te,expr)
	tokens = strtrim(tokengetall(te))
	if ((k=length(tokens)) == 3) {
		names = expr
	}
	else if (k==2) {
		if (tokens[1] == ":") {
			/* :name1 name2 ...			*/
			names = strtrim(tokens(tokens[2]))
			if (!_parse_initial_isname(names)) {
				return(198)
			}
		}
		else {
			names = expr	// whole group reference
		}
	}
	else if (k == 1) {
		names = tokens(expr)
		if (!_parse_initial_isname(names)) {
			return(198)
		}
	}
	else {
		return(198)
	}
	if (!(k=length(names))) {
		return(198)
	}
	return(0)
}

real scalar _parse_initial_isname(string vector names)
{
	real scalar i, k

	k = length(names)
	if (!k) {
		return(0)
	}
	for (i=1; i<=k; i++) {
		if (!st_isname(names[i])) {
			return(0)
		}
	}
	return(1)
}

real scalar _parse_initial_get_value(string scalar tok, string scalar tname)
{
	real scalar val, nooutput
	string scalar expr

	val = strtoreal(tok)
	if (missing(val) & st_isname(tok)) {
		val = st_numscalar(tok)
		if (!rows(val) | !cols(val)) {
			/* not sure why I have to do this		*/
			val = .
		}
	}
	if (missing(val)) {
		/* evaluate expression					*/
		nooutput = 1
		expr = sprintf("scalar %s = %s",tname,tok)
		(void)_stata(expr,nooutput)
		val = st_numscalar(tname)
		if (!rows(val) | !cols(val)) {
			/* not sure why I have to do this		*/
			val = .
		}
		else {
			expr = sprintf("scalar drop %s",tname)
			(void)_stata(expr,nooutput)
		}	
	}
	return(val)
}

real scalar _parse_initial_set_matrix(string vector names, string scalar sval,
			real rowvector b, string matrix stripe, 
			real scalar skip, string scalar errmsg)
{
	real scalar i, k, kn, rc
	string scalar eq
	string vector param, eqname
	transmorphic te

	rc = 0
	kn = length(names)
	for (i=1; i<=kn; i++) {
		eq = ""
		param = J(1,0,"")
		te = tokeninit("",(":"))
		tokenset(te, names[i])
		eqname = strtrim(tokengetall(te))
		if ((k=length(eqname)) == 3) {
			eq = eqname[1]
			/* could be more than one parameter to set	*/
			param = strtrim(tokens(eqname[3]))

		}
		else if (k==2) {
			if (eqname[2]==":") {
				/* set entire equation			*/
				eq = eqname[1]
			}
			else {
				/* could be more than one parameter to
				 *  set					*/
				param = strtrim(tokens(eqname[2]))
			}
		}
		else {
			param = eqname[1]
		}
		rc = initial_set_vector_value(eq,param,sval,b,stripe,skip,
			errmsg) 
		if (rc) {
			return(rc)
		}
	}
	return(rc)
}

end
exit
