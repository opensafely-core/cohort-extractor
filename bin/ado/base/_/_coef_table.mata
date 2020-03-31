*! version 2.3.1  01nov2018
version 12

local sumcmds mean proportion ratio total

mata:

void _coef_table()
{
	class _b_table scalar T
	string	vector	coefttl
	real	scalar	first
	real	scalar	nofirst
	real	scalar	neq
	real	scalar	offsetonly1
	real	scalar	k_diparm
	real	scalar	i
	real	scalar	j
	string	scalar	offset
	string	vector	blist
	string	vector	offsetlist

	blist = "", "e(b)", "e(b_mi)"
	T = _b_table()
	T.set_bmat(st_local("bmatrix"))
	T.set_vmat(st_local("vmatrix"))
	T.set_Cnsmat(st_local("cnsmatrix"))
	T.set_emat(st_local("ematrix"))
	T.set_dfmat(st_local("dfmatrix"))
	T.set_cimat(st_local("cimatrix"))
	T.set_extrarowmat(st_local("rowmatrix"), st_local("norowci"))
	T.set_eqmat(st_local("eqmatrix"))
	T.set_mmat(st_local("mmatrix"))
	T.set_mvmat(st_local("mvmatrix"))
	T.set_memat(st_local("mematrix"))
	T.set_bstdmat(st_local("bstdmatrix"))
	if (length(st_numscalar("e(df_r)"))) {
		T.set_df(st_numscalar("e(df_r)"))
	}
	T.set_level(strtoreal(st_local("level")))
	T.set_mcompare(st_local("method"))
	T.set_mc_all(st_local("all"))

	T.set_type(st_local("type"))
	T.set_showginv(strlen(st_local("showginvariant")) ? "on" : "off")
	T.set_nofoot(strlen(st_local("nofootnote")) ? "on" : "off")
	T.set_semstd(strlen(st_local("standardized")) ? "on" : "off")
	T.set_sort(strlen(st_local("sort")) ? "on" : "off")
	T.set_cmdextras(strlen(st_local("cmdextras")) ? "on" : "off")
	T.set_dfmissing(strlen(st_local("dfmissing")) ? "on" : "off")
	T.set_pisemat(st_local("pisematrix"))
	T.set_pclassmat(st_local("pclassmatrix"))
	T.set_lstretch(st_local("lstretch") == "nolstretch" ? "off" : "on")
	if (st_local("fvignore") != "") {
		T.set_fvignore(strtoreal(st_local("fvignore")))
		T.set_flignore(st_local("flignore") == "" ? "off" : "on")
	}
	T.set_diopts(st_local("diopts"))
	T.set_eq_check(strlen(st_local("noeqcheck")) == 0 ? "on" : "off")
	T.set_markdown(strlen(st_local("markdown")) ? "on" : "off")

	T.set_depname(st_local("depname"))
	coefttl		= J(1,2,"")
	coefttl[1]	= st_local("coeftitle2")
	if (strlen(coefttl[1])) {
		coefttl[2]	= st_local("coefttl")
	}
	else {
		coefttl[1]	= st_local("coefttl")
	}
	T.set_coefttl(coefttl)
	T.set_pttl(st_local("ptitle"))
	T.set_cittl(st_local("cititle"))

	T.set_cnsreport(st_local("cnsreport"))
	T.set_mclegend(strlen(st_local("nomclegend")) ? "off" : "on")
	T.set_clreport(strlen(st_local("noclustreport")) ? "off" : "on")

	T.set_cformat(st_local("cformat"))
	T.set_sformat(st_local("sformat"))
	T.set_pformat(st_local("pformat"))
	T.set_rowcformat(st_local("rowcformat"))
	T.set_rowsformat(st_local("rowsformat"))
	T.set_rowpformat(st_local("rowpformat"))
	offsetlist = tokens(st_local("offsetlist"))

	T.set_plus(strlen(st_local("plus")) ? "on" : "off")

	if (any(st_global("e(cmd)") :== tokens("`sumcmds'"))) {
		first	= 0
		nofirst = 1
	}
	else {
		first	= strlen(st_local("first"))
		nofirst	= strlen(st_local("nofirst"))
	}
	if (first) {
		T.set_eq_hide("on")
		neq = 1
	}
	else {
		neq = strtoreal(st_local("neq"))
		if (missing(neq)) {
			neq = -1
		}
		if (nofirst | neq > 0) {
			T.set_eq_hide("off")
		}
	}
	T.set_neq(neq)
	T.set_eform(strlen(st_local("eform")) ? "on" : "off")
	T.set_eformall(strlen(st_local("eformall")) ? "on" : "off")
	T.set_percent(strlen(st_local("percent")) ? "on" : "off")
	T.set_noskip(strlen(st_local("noskip")) ? "on" : "off")
	T.set_separator(strtoreal(st_local("separator")))
	T.set_noprob(strlen(st_local("notest")) ? "on" : "off")
	T.set_eqselect(st_local("eqselect"))

	T.validate()

	if (T.set_eq_check() == "on" | anyof(blist, T.set_bmat())) {
		offsetonly1 = strlen(st_local("offsetonly1"))
		if (offsetonly1) {
			offset	= st_global("e(offset1)")
			if (strlen(offset) == 0) {
				offset	= st_global("e(offset)")
			}
			T.set_offset(max((1,T.k_eform())), offset)
		}
		else {
			neq = T.set_neq()
			if (neq == 0) {
				neq = 1
			}
			for (i=1; i<=neq; i++) {
				offset	= st_global(sprintf("e(offset%f)",i))
				if (strlen(offset) == 0) {
					offset	= st_global("e(offset)")
				}
				T.set_offset(i,offset)
				offset	= ""
			}
		}
	}
	else if (cols(offsetlist)) {
		neq = T.set_neq()
		if (neq > cols(offsetlist)) {
			neq = cols(offsetlist)
		}
		for (i=1; i<=neq; i++) {
			T.set_offset(i,offsetlist[i])
		}
	}

	k_diparm = strtoreal(st_local("k"))
	if (missing(k_diparm)) {
		k_diparm = 0
	}
	T.set_ndiparm(k_diparm)
	j	= 1
	for (i=1; i<=k_diparm; i++, j++) {
		T.set_diparm(j, st_local(sprintf("diparm%f",i)))
	}
	T.set_citype(st_local("citype"))

	T.compute()
	T.report_table()
	T.post_results(st_local("prefix"), st_local("suffix"))
}

end
