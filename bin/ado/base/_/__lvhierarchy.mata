*! version 1.1.4  04sep2019

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __tempnames.matah
quietly include `"`r(fn)'"'

findfile __lvhierarchy.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __lvhierarchy::new()
{
	clear()

	m_tnames.set_prefix("LVHIER")
}

void __lvhierarchy::destroy()
{
	clear()
}

void __lvhierarchy::clear()
{
	real scalar i, j, k, k1

	k = length(m_paths)
	for (i=1; i<=k; i++) {
		m_paths[i] = NULL
	}
	m_touse = ""
	m_paths = J(1,0,NULL)		// LV path
	m_LVs = J(1,0,"")		// LV names
	k = length(m_iREvars)
	/* remove Stata index temporary variables 			*/
	m_tnames.clear()
	m_iREvars = J(1,0,"")		// RE Stata index varnames
	m_kRE = J(1,0,0)		// # RE's
	m_indexh = J(0,2,0)
	/* panel information for the selected hierarchy			*/
	m_resolved = `HIER_FALSE'
	m_ih = 0
	m_gvar = ""
	k = length(m_hinfo)
	for (i=1; i<=k; i++) {
		k1 = length(m_hinfo[i].hinfo)
		for (j=1; j<=k1; j++) {
			m_hinfo[i].hinfo[j] = NULL
		}
		m_hinfo[i].hrange = J(1,0,0)
		m_hinfo[i].pinfo = J(0,0,0)
		m_hinfo[i].hvars = J(1,0,"")
		m_hinfo[i].panels = J(0,1,0)
		m_hinfo[i].iorder = J(0,1,0)
	}
	m_hinfo = _lvhinfo(1)
}

string scalar __lvhierarchy::errmsg()
{
	return(m_errmsg)
}

string vector __lvhierarchy::LVnames()
{
	return(m_LVs)
}

string scalar __lvhierarchy::groupvar()
{
	return(m_gvar)
}

string scalar __lvhierarchy::touse()
{
	return(m_touse)
}

void __lvhierarchy::set_touse(string scalar touse)
{
	/* no variable checking						*/
	m_touse = touse
}

real scalar __lvhierarchy::has_groupvar()
{
	return(ustrlen(m_gvar)>0)
}

real scalar __lvhierarchy::set_groupvar(string scalar gvar)
{
	m_gvar = gvar
	if (!ustrlen(m_gvar)) {
		return(0)
	}
	if (missing(st_varindex(m_gvar))) {
		m_errmsg = sprintf("group variable {bf:%s} not found",m_gvar)
		return(111)
	}
	return(0)
}

real scalar __lvhierarchy::add_path(pointer (class __lvpath) tpath,
			string scalar touse, |real scalar strict_hier) 
{
	real scalar i, k, j, o, o0, kid
	real vector io, order, order0
	real colvector id
	string scalar name
	string vector names, idh, ids

	pragma unset id

	strict_hier = (missing(strict_hier)?`HIER_TRUE':
		(strict_hier==`HIER_TRUE'))
	k = path_count()
	name = tpath->name()
	for (i=1; i<=k; i++) {
		if (m_paths[i]->name() == name) {
			/* programmer error				*/
			m_errmsg = sprintf("multiple instances of %s {bf:%s} " +
				"exist",tpath->LATENT_VARIABLE,name)
			return(498)
		}
		if (m_paths[i]->isequal(*tpath)) {
			names = (tokens(m_LVs[i]),name)
			io = order(names',1)'
			m_LVs[i] = invtokens(names[io])
			return(0)
		}
	}
	idh = tpath->hierarchy()
	/* check that hierarchy id variables are integer valued		*/
	kid = length(idh)
	for (i=1; i<=kid; i++) {
		ids = tokens(idh[i])
		for (j=1; j<=length(ids); j++) {
			if (any(ids[j]:==tpath->m_hsyms)) {
				continue
			}
			st_view(id,.,ids[j],touse)
			if (any((floor(floatround(id)):!=id))) {
				m_errmsg = sprintf("index variable {bf:%s} " +
					"of %s {bf:%s[%s]} is not integer " +
					"valued; this is not allowed",ids[j],
					tpath->LATENT_VARIABLE,tpath->name(),
					tpath->path())
				return(459)
			}
		}
	}
	if (strict_hier) {
		for (i=1; i<=k; i++) {
			if (!m_paths[i]->iscompatible(*tpath)) {
				m_errmsg = sprintf("%s {bf:%s} with path " +
					"{bf:%s} conflicts with {bf:%s[%s]}",
					tpath->LATENT_VARIABLE,tpath->name(),
					tpath->path(),m_paths[i]->name(),
					m_paths[i]->path())
				return(498)
			}
		}
	}
	j = k+1
	order = tpath->order()
	o = length(order)
	for (i=1; i<=k; i++) {
		order0 = m_paths[i]->order()
		o0 = length(order0)
		if (o0 > o) {
			j = i
			break
		}
		if (o0 == o) {
			if (order0[o0] > order[o]) {
				j = i
				break
			}
		}
	}
	if (j > k) {
		m_LVs = (m_LVs,tpath->name())
		m_paths = (m_paths,tpath)
	}
	else if (j == 1) {
		m_LVs = (tpath->name(),m_LVs)
		m_paths = (tpath,m_paths)
	}
	else {
		m_LVs = (m_LVs[|1\j-1|],tpath->name(),m_LVs[|j\k|])
		m_paths = (m_paths[|1\j-1|],tpath,m_paths[|j\k|])
	}
	return(0)
}

string scalar __lvhierarchy::LV_index_stvar(string scalar LV)
{
	real scalar i, k
	string vector LVi

	k = path_count()
	if (length(m_iREvars) != k) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::LV_index_stvar()}: LV " +
			"index vector has not been generated{p_end}")
		exit(498)
	}
	for (i=1; i<=k; i++) {
		LVi = tokens(m_LVs[i])
		if (any(LV:==LVi)) {
			return(m_iREvars[i])
		} 
	}
	return("")
}

string scalar __lvhierarchy::path_index_stvar(class __lvpath scalar tree)
{
	real scalar i, k

	k = path_count()
	if (length(m_iREvars) != k) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::path_index_stvar()}: LV " +
			"index vector has not been generated{p_end}\n")
		exit(498)
	}
	for (i=1; i<=k; i++) {
		if (m_paths[i]->isequal(tree)) {
			return(m_iREvars[i])
		} 
	}
	return("")
}

real colvector __lvhierarchy::index_vector(real scalar ipath,
			|string scalar touse)
{
	real scalar k

	k = path_count()
	if (length(m_iREvars) != k) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::index_vector()}: LV " +
			"index vector has not been generated{p_end}\n")
		exit(498)
	}
	if (ipath<1 | ipath>k) {
		errprintf("{p}{bf:__lvhierarchy::index_vector()}: index " +
			"%g is out of range [1,%g]{p_end}\n",ipath,k)
		exit(503)
	}
	if (ustrlen(touse)) {
		/* subsample						*/
		return(st_data(.,m_iREvars[ipath],touse))
	}
	return(st_data(.,m_iREvars[ipath]))
}

real colvector __lvhierarchy::LV_index_vector(string scalar LV,
			|string scalar touse)
{
	real scalar i, k
	string vector LVi

	k = path_count()
	if (length(m_iREvars) != k) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::LV_index_vector()}: LV " +
			"index vector has not been generated{p_end}")
		exit(498)
	}
	for (i=1; i<=k; i++) {
		LVi = tokens(m_LVs[i])
		if (any(LV:==LVi)) {
			return(index_vector(i,touse))
		} 
	}
	return(J(0,1,0))
}

real colvector __lvhierarchy::path_index_vector(class __lvpath tree,
			|string scalar touse)
{
	real scalar i, k

	k = path_count()
	if (length(m_iREvars) != k) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::path_index_vector()}: LV " +
			"index vector has not been generated{p_end}")
		exit(498)
	}
	for (i=1; i<=k; i++) {
		if (m_paths[i]->isequal(tree)) {
			return(index_vector(i,touse))
		} 
	}
	return(J(0,1,0))
}

real scalar __lvhierarchy::LV_index_count(string scalar LV)
{
	real scalar i, k
	string vector LVi

	k = path_count()
	if (length(m_iREvars) != k) {
		return(0)
	}
	for (i=1; i<=k; i++) {
		LVi = tokens(m_LVs[i])
		if (any(LV:==LVi)) {
			return(m_kRE[i])
		} 
	}
	return(0)
}

real scalar __lvhierarchy::resolve_paths()
{
	real scalar i, j, k, l, kh, kh1, lh, mx, n, kf
	real vector jh, io
	string vector hi, hj, LVs
	pointer (real vector) vector hier
	pointer (class __lvpath) vector paths

	k = path_count()
	if (!k) {
		/* no hierarchy						*/
		m_resolved = `HIER_TRUE'
		m_indexh = J(0,2,0)
		return(0)
	}
	if (k == 1) {
		m_indexh = J(1,2,1)	// hierarchy group index ranges
		m_resolved = `HIER_TRUE'
		return(0)
	}
	hier = J(1,0,NULL)
	mx = 1
	for (i=1; i<=k; i++) {
		hi = m_paths[i]->hierarchy()
		lh = length(hi)
		if (lh > mx) {
			mx = lh
		}
		if (lh == 1) {
			hier = (hier,&J(1,1,i))
		}
	}
	n = length(hier)
	io = J(1,n,0)
	/* sort by path order, e.g. order(a) = 1, order(a#b) = 2	*/
	for (i=1; i<=n; i++) {
		j = (*hier[i])[1]
		hi = m_paths[j]->hierarchy()
		io[i] = length(tokens(hi)) + 1/(n-i+2)	// add tie breaker
	}
	io = order(io',1)'
	hier = hier[io]
	if (mx > 1) {
		for (kh=2; kh<=mx; kh++) {
			kh1 = kh-1
			for (i=1; i<=k; i++) {
				hi = m_paths[i]->hierarchy()
				if (length(hi) != kh) {
					continue
				}
				kf = 0
				for (j=1; j<=n; j++) {
					jh = *hier[j]
					lh = length(jh)
					hj = m_paths[jh[lh]]->hierarchy()
					if (length(hj) != kh1) {
						continue
					}
					if (any(hj!=hi[|1\kh1|])) {
						continue
					}
					hier[j] = &J(1,1,(jh,i))
					kf++
				}
				if (!kf) {	// add to ordered hierarchy
					hier = (hier,&J(1,1,i))
					n++
				}
			}
		}
	}
	/* copy data members before reordering				*/
	paths = m_paths
	LVs = m_LVs

	m_indexh = J(n,2,0)	// hierarchy group index ranges
	lh = 0
	for (i=1; i<=n; i++) {
		jh = *hier[i]
		kh = length(jh)
		m_indexh[i,1] = lh+1
		for (j=1; j<=kh; j++) {
			l = jh[j]
			m_paths[++lh] = paths[l]
			m_LVs[lh] = LVs[l]
		}
		m_indexh[i,2] = lh
	}
	m_resolved = `HIER_TRUE'

	return(0)
}

real scalar __lvhierarchy::gen_sort_order(|string scalar tvar,
			string scalar gvar)
{
	real scalar i, j, k, k1, ih, kh, n, m
	real vector hrange, io
	real matrix ix, jo
	string vector pvars

	/* assumption:  hierarchy has been resolved			*/
	kh = hier_count() 	// # hierarchical groups (crossed)
	/* m_touse is the same estimation sample used to generate 
	 *  LV indices							*/
	if (!ustrlen(m_touse)) {
		/* programmer error					*/
		m_errmsg = "failed to create hierarchical sort order; " +
			"no estimation sample available"
		return(111)
	}
	m_ih = 0
	jo = J(0,0,0)
	n = sum(st_data(.,m_touse))
	if (ustrlen(gvar)) {
		/* assumption: gvar exists				*/
		jo = st_data(.,gvar,m_touse)
		m_gvar = gvar
	}
	if (ustrlen(tvar)) {	// time variable provided
		/* assumption: tvar exists				*/
		m_tvar = tvar	
		if (rows(jo)) {
			jo = (jo,st_data(.,tvar,m_touse))
		}
		else {
			jo = st_data(.,tvar,m_touse)
		}
	}
	else if (rows(jo)) {
		io = 1::n	// cannot append 1::n directly?
		jo = (jo,io)	// stable sort
	}
	else {
		jo = 1::n	// stable sort
	}
	/* kh could equal zero, no hierarchy				*/
	m_hinfo = _lvhinfo(kh)
	for (ih=1; ih<=kh; ih++) {
		hrange = m_indexh[ih,.] // index range for hierarchy ih
		k = hrange[2]-hrange[1]+1
		m_hinfo[ih].hrange = hrange
		m_hinfo[ih].kpath = k
		m_hinfo[ih].hvars = J(1,0,"")

		/* sort for single hierarchy				*/
		ix = J(0,0,.)
		i = m_hinfo[ih].hrange[2]	// lowest branch
		pvars = m_paths[i]->hierarchy()	// path variables
		k = length(m_paths[i]->m_hsyms)
		if (has_groupvar() & k) {
			m_errmsg = sprintf("cannot have a group variable " +
				"{bf:%s} with special hierarchy symbols " +
				"{bf:%s}",m_gvar,
				invtokens(m_paths[i]->m_hsyms))
			return(498)
		}
		for (j=1; j<=k; j++) {
			io = strmatch(pvars,m_paths[i]->m_hsyms[j])
			if (any(io)) {
				pvars = select(pvars,1:-io)
			}
			if (!length(pvars)) {
				break
			}
		}
		m = length(pvars)
		if (m) {
			if (has_groupvar()) {
				if (any(io=strmatch(pvars,m_gvar))) {
					if (io[m] != 1) {
						/* group var is in path
						 *  and not the last	*/
						m_errmsg = sprintf("group " +
						 "variable {bf:%s} conflicts " +
						 "with hierarchy {bf:%s}: " +
						 "group variable must be " +
						 "nested within the hierarchy",
						 m_gvar,m_paths[i]->path())
						return(498)
					}
				}
			}
			m_hinfo[ih].hvars = pvars
			ix = st_data(.,pvars,m_touse)
			k1 = m+cols(jo)
			/* stable sort with jo on the end		*/
			m_hinfo[ih].iorder = order((ix,jo),1..k1)
		}
		else {
			m_hinfo[ih].iorder = J(0,1,0)
		}
	}

	/* level 0, residual, order					*/
	m_iorder = order(jo,1..cols(jo))

	return(0)
}

real scalar __lvhierarchy::path_hierarchy_index(class __lvpath path)
{
	real scalar i, k, ipath, ih, kh
	real vector hr

	/* return hierarchy index containing path			*/
	k = path_count()
	if (!k) {
		return(0)	// nothing to do
	}
	if (!m_resolved) {
		errprintf("{p}no hierarchy contains path %s; hierarchy has " +
			"not been resolved{p_end}\n",path.path())
		exit(498)
	}
	kh = hier_count() 	// # hierarchical groups (crossed)
	if (!kh) {
		return(0)
	}
	ipath = 0
	for (i=1; i<=k; i++) {
		if (m_paths[i]->isequal(path)) {
			ipath = i
			break;
		} 
	}
	if (!ipath) {
		return(0)
	}
	for (ih=1; ih<=kh; ih++) {
		hr = m_hinfo[ih].hrange
		if (ipath>=hr[1] & ipath<=hr[2]) {
			return(ih)
		}
	}
	return(0)
}

/* set hierarchy index for sort order and panel information		*/
real scalar __lvhierarchy::set_current_hierarchy_index(real scalar ih)
{
	if (!m_resolved) {
		m_errmsg = "failed to set current hierarchy; hierarchy " +
			"paths have not been resolved"
		return(498)
	}
	if (ih<0 | ih>hier_count()) {
		m_errmsg = sprintf("invalid hierarchy index %g; must be " +
			"in [0,%g]",ih,hier_count())
		return(498)
	}
	m_ih = ih

	return(0)
}

real scalar __lvhierarchy::current_hierarchy_index()
{
	return(m_ih)
}

real colvector __lvhierarchy::current_sort_order()
{
	if (!m_ih) {
		return(m_iorder)
	}
	return(m_hinfo[m_ih].iorder)
}

real scalar __lvhierarchy::gen_current_panel_info(|string scalar touse,
			string scalar path, string scalar group)
{
	real scalar i, j, k, kh, hasgrp, igvar, nooutput, n
	real scalar depth, mxdepth
	real colvector REindex
	string scalar cmd, sp, gvar, vlist
	string vector hier

	if (!m_resolved) {
		m_errmsg = "failed to create panel index variable; " +
			"hierarchy paths have not been resolved"
		return(498)
	}
	if (length(m_iREvars) != path_count()) {
		m_errmsg = "failed to create panel index variable; " +
			"hierarchy is not properly initialized"
		return(498)
	}
	path = ""
	kh = hier_count() 	// # hierarchical groups
	if (m_ih > kh) {
		m_errmsg = "failed to create panel index variable; " +
			"current panel index is invalid"
		return(498)
	}
	mxdepth = 0
	vlist = sp = ""
	hasgrp = has_groupvar()
	if (!ustrlen(touse)) {
		touse = m_touse
	}

	if (m_ih) {
		/* assumption: programmer has sorted the data in Stata
		 *  using ::sort_order() variable			*/
		j = m_hinfo[m_ih].hrange[1]-1
		k = m_hinfo[m_ih].kpath 
		m_hinfo[m_ih].hinfo = J(1,k,NULL)
		for (i=1; i<=k; i++) {
			/* panel info for individual paths
			 *  must reestablish view of the index variable
			 *  view is lost in the sort			*/
			j++
			depth = length(m_paths[j]->hierarchy())
			if (depth > mxdepth) {
				hier = m_paths[j]->hierarchy()
				mxdepth = depth
			}
			REindex = st_data(.,m_iREvars[j],touse)
			m_hinfo[m_ih].hinfo[i] = &panelsetup(REindex,1)
			if (hasgrp) {
				vlist = vlist + sp + m_iREvars[j]
				sp = " "
			}
		}
	}
	group = ""
	if (hasgrp) {
		gvar = st_tempname()
		vlist = vlist + sp + m_gvar
		group = m_gvar
		cmd = sprintf("egen long %s = group(%s) if %s",gvar,vlist,touse)
		nooutput = `HIER_TRUE'
		if (_stata(cmd,nooutput)) {
			m_errmsg = sprintf("failed to create group index " +
				"from variables {bf:%s}",vlist)
			return(498)
		}
		igvar = st_varindex(gvar)
		if (m_ih) {
			m_hinfo[m_ih].panels = st_data(.,igvar,touse)
			m_hinfo[m_ih].pinfo = panelsetup(m_hinfo[m_ih].panels,1)
		}
		else {
			/* residual panels using specified group 
			 * variable					*/
			m_groups = st_data(.,igvar,touse)
			m_ginfo = panelsetup(m_groups,1)
		}
		(void)st_dropvar(igvar)
	}
	else if (m_ih) {
		/* residual panels using hierarchy lowest level		*/
		m_ipanelvar = j	// current Stata panel variable 
		m_hinfo[m_ih].panels = REindex
		m_hinfo[m_ih].pinfo = *(m_hinfo[m_ih].hinfo[k])
	}
	else {
		/* panel is the dataset					*/
		n = sum(st_data(.,touse))
		m_groups = J(n,1,1)
		m_ginfo = (1,n)
	}
	path = invtokens(hier)

	return(0)
}

real colvector __lvhierarchy::current_panel_vector()
{
	if (!m_resolved) {
		errprintf("failed to return current hierarchy panel vector; " +
			"hierarchy paths have not been resolved\n")
		exit(498)
	}
	/* assumption: gen_current_panel_info() has been called		*/
	if (!m_ih) {
		return(m_groups)
	}
	return(m_hinfo[m_ih].panels)
}

real matrix __lvhierarchy::current_panel_info()
{
	if (!m_resolved) {
		errprintf("failed to return current hierarchy panel info; " +
			"hierarchy paths have not been resolved\n")
		exit(498)
	}
	/* assumption: gen_current_panel_info() has been called		*/
	if (!m_ih) {
		return(m_ginfo)
	}
	return(m_hinfo[m_ih].pinfo)
}

real scalar __lvhierarchy::gen_LV_indices(string scalar touse, 
			|real scalar sort)
{
	real scalar i, k, rc, nooutput
	real colvector REindex
	string scalar cmd, tname
	string vector hier, hall

	sort = (missing(sort)?0:1)
	nooutput = `HIER_TRUE'
	k = path_count()
	/* generate single index variable from LV paths	
	 * Lindstrom & Bates algorithm penalized LS algorithm
	 * need a different algorithm for quadrature			*/
	m_iREvars = J(1,k,"")
	m_kRE = J(1,k,0)
	set_touse(touse)	// should be the largest estimation sample
	for (i=1; i<=k; i++) {
		m_iREvars[i] = m_tnames.new_name(m_tnames.VARIABLE)
		hier = m_paths[i]->hierarchy()
		/* look for _n	or _all					*/
		hall = tokens(invtokens(hier))
		if (any("_n":==hall)) {
			tname = st_tempname()
			cmd = sprintf("gen long %s = _n if %s",tname,m_touse)
			if (rc=_stata(cmd,nooutput)) {
				m_errmsg = sprintf("failed to generate %s " +
					"index variable for path {bf:%s}",
					m_paths[i]->LATENT_VARIABLE,
					m_paths[i]->path())
				return(rc)
			}
			cmd = sprintf("egen long %s = group(%s) if %s",
				m_iREvars[i],tname,m_touse)
		}
		else if (any("_all":==hall)) {
			cmd = sprintf("gen byte %s = 1 if %s",m_iREvars[i],
				m_touse)
		}
		else {
			cmd = sprintf("egen long %s = group(%s) if %s",
				m_iREvars[i],invtokens(hier),m_touse)
		}
		if (rc=_stata(cmd,nooutput)) {
			m_errmsg = sprintf("failed to generate %s index " +
				"variable for path {bf:%s}",
				m_paths[i]->LATENT_VARIABLE,
				m_paths[i]->path())
			return(rc)
		}
		/* must be a view; data order (sort) will likely change	*/
		// m_REindex[i] = &J(0,1,0)
		REindex = st_data(.,m_iREvars[i],m_touse)
		if (!length(REindex)) {
			m_errmsg = sprintf("random effects index variable " +
				"for LV path {bf:%s} has length zero",
				m_paths[i]->path())
			return(2000)
		}
		m_kRE[i] = max(REindex)
		if (missing(m_kRE[i])) {
			/* should no happen				*/
			m_errmsg = sprintf("invalid random effects index " +
				"variable for LV path {bf:%s}",
				m_paths[i]->path())
			return(498)
		}
	}
	return(0)
}

real scalar __lvhierarchy::path_count()
{
	return(length(m_paths))
}

string matrix __lvhierarchy::paths()
{
	real scalar i, k
	string vector paths

	k = path_count()
	paths = J(k,2,"")
	for (i=1; i<=k; i++) {
		paths[i,1] = m_LVs[i]
		paths[i,2] = m_paths[i]->path()
	}
	return(paths)
}

string vector __lvhierarchy::hier_LVs(real scalar ih)
{
	string vector lvs

	if (ih<1 | ih>hier_count()) {
		return(J(1,0,""))
	}
	lvs = m_LVs[|m_hinfo[ih].hrange[1]\m_hinfo[ih].hrange[2]|]

	return(lvs)
}

string vector __lvhierarchy::hier_paths(real scalar ih)
{
	real scalar i, j
	string vector paths

	if (ih<1 | ih>hier_count()) {
		return(J(1,0,""))
	}
	paths = J(1,m_hinfo[ih].kpath,"")
	j = 0
	for (i=m_hinfo[ih].hrange[1]; i<=m_hinfo[ih].hrange[2]; i++) {
		paths[++j] = m_paths[i]->path()
	}
	return(paths)
}

real matrix __lvhierarchy::hier_indices()
{
	/* hierarchical group membership indices			*/
	return(m_indexh)
}

real scalar __lvhierarchy::hier_count()
{
	/* number of hierarchical groups				*/
	return(rows(m_indexh))
}

pointer (class _lvhinfo) scalar __lvhierarchy::current_hinfo()
{
	if (!m_ih) {
		return(NULL)	// residual level
	}
	return(hinfo(m_ih))
}

pointer (class _lvhinfo) scalar __lvhierarchy::hinfo(real scalar h)
{
	real scalar kh

	kh = hier_count()
	if (h<1 | h>kh) {
		return(NULL)
	}
	if (length(m_hinfo) != kh) {
		/* programmer error					*/
		errprintf("hierarchy panel information has not been " +
			"initialized\n")
		exit(503)
	}
	
	/* panel information for hierarchy h				*/
	return(&m_hinfo[h])
}

string vector __lvhierarchy::path_LVnames(string scalar path)
{
	real scalar i, k, rc
	string scalar pathi
	class __lvpath scalar lvpath

	if (rc=lvpath.init("__tree",path)) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::path_LVnames()}: invalid " +
			"path specification {bf:%s}{p_end}\n",path)
		exit(rc)
	}
	path = lvpath.path()	// canonical form
	k = path_count()
	for (i=1; i<=k; i++) {
		pathi = m_paths[i]->path()
		if (pathi == path) {
			return(tokens(m_LVs[i]))
		}
	}
	return(J(1,0,""))	
}

real scalar __lvhierarchy::set_path_LVname_order(string scalar path,
			 string vector LVnames)
{
	real scalar i, j, k, m, rc
	string scalar pathi
	string vector names	
	class __lvpath scalar lvpath

	/* calling program ordered the LVnames to correspond to		*/
	/*  RE covariances in an array					*/
	if (rc=lvpath.init("__tree",path)) {
		/* programmer error					*/
		errprintf("{p}{bf:__lvhierarchy::path_LVnames()}: invalid " +
			"path specification {bf:%s}{p_end}\n",path)
		exit(rc)
	}
	path = lvpath.path()	// canonical form
	k = path_count()
	for (i=1; i<=k; i++) {
		pathi = m_paths[i]->path()
		if (pathi == path) {
			/* make sure all names are accounted for	*/
			names = tokens(m_LVs[i])
			rc = 0
			if ((m=length(names)) != length(LVnames)) {
				rc = 503
			}
			else {
				for (j=1; j<=m; j++) {	
					if (!any(strmatch(LVnames,names[j]))) {
						rc = 498
						break
					}
				}
			}
			if (rc) {
				m_errmsg = sprintf("could not reorder " +
					"%ss for path %s; names do not " +
					"match",lvpath.LATENT_VARIABLE,path)
				return(rc)
			}
			m_LVs[i] = invtokens(LVnames)
			break
		}
	}
	return(0)
}

void __lvhierarchy::display()
{
	real scalar i, h, k
	string vector lv
	string matrix paths
	class __lvpath scalar lvpath

	if (!(k=path_count())) {
		return
	}
	if (length(m_kRE) != k) {
		m_kRE = J(1,k,.)
	}
	lv = tokens(lvpath.LATENT_VARIABLE)
	lv[1] = strproper(lv[1])
	
	printf("{txt}\n\n{col 5}%s hierarchy\n\n",invtokens(lv))
	printf("{ul on}{col 5}%s{col 25}path{col 48}hierarchy" +
		"{col 60}# RE{ul off}\n",lvpath.LATENT_VARIABLE)
	paths = paths()
	h = 1
	for (i=1; i<=k; i++) {
		if (i > m_indexh[h,2]) {
			h++
		}
		printf("{txt}%g{res}{col 5}%s{col 25}%s{col 53}%g{col 60}%g\n",
			i,paths[i,1],paths[i,2],h,m_kRE[i])
	}
	printf("\n")
}

void __lvhierarchy::return_post(real scalar ereturn,|string scalar touse)
{
	real scalar i, h, k
	string scalar level, re
	string matrix paths
	class __stmatrix scalar stats

	if (!m_resolved) {
		/* programmer error					*/
		errprintf("{p}failed to post hierarchy information; " +
			"hierarchy paths have not been resolved{p_end}\n")
		exit(498)
	}
	ereturn = (missing(ereturn)?`HIER_FALSE':(ereturn!=`HIER_FALSE'))
	if (ereturn) {
		re = "e"
	}
	else {
		re = "r"
	}
	if (!ustrlen(touse)) {
		touse = m_touse
	}
	h = hier_count()
	st_numscalar(sprintf("%s(k_hierarchy)",re),h,"hidden")
	if (has_groupvar()) {
		/* group (panel) variable				*/
		st_global(sprintf("%s(groupvar)",re),m_gvar)
	}
	if (h) {
		k = path_count()
		if (!k) {
			/* programmer error				*/
			errprintf("{p}failed to post hierarchy information; " +
				"invalid hierarchy information{p_end}\n")
			exit(498)
		}
		paths = paths()
		h = 1
		level = sprintf("(%s %s)",paths[1,`HIERARCHY_PATH'],
				paths[1,`HIERARCHY_LV_NAMES'])
		for (i=2; i<=k; i++) {
			if (i > m_indexh[h,2]) {
				h++
				level = sprintf("(%s %s)",
					paths[i,`HIERARCHY_PATH'],
					paths[i,`HIERARCHY_LV_NAMES'])
			}
			else {
				level = level + sprintf(" (%s %s)",
					paths[i,`HIERARCHY_PATH'],
					paths[i,`HIERARCHY_LV_NAMES'])
			}
		}
		st_global(sprintf("%s(hierarchy)",re),level)
	}
	stats = hierarchy_stats(touse)
	stats.st_matrix(sprintf("%s(hierstats)",re))
}

class __stmatrix scalar __lvhierarchy::hierarchy_stats(string scalar touse)
{
	real scalar i, i1, j, k, k1, mean, kRE
	real rowvector minmax
	real colvector cnt, REindex
	real matrix hstats
	string vector hier
	string matrix rstripe
	class __stmatrix scalar sthstats

	sthstats.erase()
	k = k1 = path_count()
	if (has_groupvar()) {
		if (k) {
			hier = m_paths[k]->hierarchy()
			i1 = length(hier)
			if (hier[i1] != m_gvar) {
				k1++
			}
		}
		else {
			k1++
		}
	}
	if (!k1) {
		return(sthstats)
	}
	hstats = J(k1,4,0)
	rstripe = J(k1,2,"")
	i1 = 0
	
	for (i=1; i<=k; i++) {
		rstripe[++i1,2] = m_paths[i]->path()
		REindex = st_data(.,m_iREvars[i],touse)
		kRE = max(REindex)
		cnt = J(kRE,1,0)
		for (j=1; j<=m_kRE[i]; j++) {
			cnt[j] = sum(REindex:==j)
		}
		minmax = minmax(cnt)
		mean = mean(cnt)
		hstats[i1,.] = (kRE,mean,minmax)
	}
	if (k1 > k) {
		rstripe[++i1,2] = m_gvar
		if (!m_ih) {
			cnt = m_ginfo[.,2]-m_ginfo[.,1]:+1
		}
		else {
			cnt = m_hinfo[m_ih].pinfo[.,2]-
				m_hinfo[m_ih].pinfo[.,1]:+1
		}
		minmax = minmax(cnt)
		mean = mean(cnt)
		hstats[i1,.] = (length(cnt),mean,minmax)
	}
	(void)sthstats.set_matrix(hstats)
	(void)sthstats.set_rowstripe(rstripe)
	(void)sthstats.set_colstripe((J(4,1,""),("count"\"mean"\"min"\"max")))

	return(sthstats)
}

end

exit
