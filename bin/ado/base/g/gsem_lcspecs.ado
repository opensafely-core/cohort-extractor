*! version 1.0.1  09sep2019
program gsem_lcspecs
	version 15
	syntax [varname(numeric default=none)] [if] [in] [, lcpaths *]

	// NOTE: this subroutine loops through the specified lclass()
	// options, building the following macros:
	//
	// 	lcvars		- list of latent class varnames
	// 	lcnlevs		- list of latent class level counts
	// 	lcbases		- list of latent class base levels
	// 	options		- remaining unparsed options

	gsem_parse_lclass, `options'

	if `"`options'"' != "" {
		local 0 `", `options'"'
		syntax [, NULLOP]
		exit 198	// [sic]
	}

	if "`varlist'" != "" {
		marksample touse
	}

	// output
	// 	r(lcspecs)
	mata: st_gsem_lcspecs()
end

mata:

void st_gsem_lcspecs()
{
	string	scalar	lcspec
	string	vector	lcvars
	real	vector	lcnlevs
	string	vector	levs
	real	scalar	dim
	real	scalar	lcpaths
	real	scalar	i
	string	scalar	jpref
	real	scalar	j, jj
	string	scalar	kpref
	real	scalar	k, kk
	string	scalar	gvar
	real	matrix	G
	real	matrix	ginfo
	string	vector	list

	lcvars = tokens(st_local("lcvars"))
	lcnlevs = strtoreal(tokens(st_local("lcnlevs")))

	dim = cols(lcvars)

	lcpaths = st_local("lcpaths") != ""
	lcspec = ""
	if (lcpaths) {
		lcspec = sprintf("%s %s",
				lcspec,
				invtokens(lcvars))
	}

	for (i=1; i<=dim; i++) {
		levs = strofreal(1..lcnlevs[i])
		levs = levs :+ "." :+ lcvars[i]
		lcspec = sprintf("%s %s",
				lcspec,
				invtokens(levs))
	}

	for (j=1; j<dim; j++) {
	for (jj=1; jj<=lcnlevs[j]; jj++) {
		jpref = sprintf("%f.%s#",jj,lcvars[j])
		for (i=j+1; i<=dim; i++) {
			levs = strofreal(1..lcnlevs[i])
			levs = levs :+ "." :+ lcvars[i]
			levs = jpref :+ levs
			lcspec = sprintf("%s %s",
					lcspec,
					invtokens(levs))
		} // i
	} // jj
	} // j

	for (k=1; k<dim; k++) {
	for (kk=1; kk<=lcnlevs[k]; kk++) {
		kpref = sprintf("%f.%s#",kk,lcvars[k])
		for (j=k+1; j<dim; j++) {
		for (jj=1; jj<=lcnlevs[j]; jj++) {
			jpref = sprintf("%s%f.%s#",kpref,jj,lcvars[j])
			for (i=j+1; i<=dim; i++) {
				levs = strofreal(1..lcnlevs[i])
				levs = levs :+ "." :+ lcvars[i]
				levs = jpref :+ levs
				lcspec = sprintf("%s %s",
						lcspec,
						invtokens(levs))
			} // i
		} // jj
		} // j
	} // kk
	} // k

	st_rclear()

	gvar = st_local("varlist")
	if (gvar == "" | lcpaths) {
		st_global("r(lcspeclist)", substr(lcspec,2,.))
		return
	}


	G	= st_data(., gvar, st_local("touse"))
	G	= sort(G,1)
	ginfo	= panelsetup(G, 1)
	G	= G[ginfo[,1],]'
	if (any(G :< 0) | any(G :!= floor(G))) {
		st_global("r(lcspeclist)", substr(lcspec,2,.))
		return
	}
	list	= tokens(lcspec)

	levs	= strofreal(G) :+ "." :+ gvar
	dim	= cols(G)
	lcspec	= sprintf("%s %s",
			lcspec,
			invtokens(levs))

	for (i=1; i<=dim; i++) {
		levs = sprintf("%f.%s#",G[i],gvar) :+ list
		lcspec	= sprintf("%s %s",
				lcspec,
				invtokens(levs))
	}

	st_global("r(lcspeclist)", substr(lcspec,2,.))
}

end

exit
