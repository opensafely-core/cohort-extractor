*! version 1.4.3  06jan2020
version 12

local sumcmds	mean proportion ratio total
local NOADJUSTALL tukey snk duncan dunnett scheffe
local pwcmds	pwcompare pwmean

local k_notes	10

findfile _b_stat_include.mata
include `"`r(fn)'"'

mata:

class _b_stat {

protected:

	// settings
	string	scalar	_bmat			// e(b)
	string	scalar	_vmat			// e(V)
	string	scalar	_Cnsmat			// e(Cns)
	string	scalar	_emat			// e(error)
	string	scalar	_dfmat			// e(df_mi)
	string	scalar	_cimat			// cimatrix() option
	string	scalar	_nmat			// e(_N)
	string	scalar	_mmat			// margins
	string	scalar	_mvmat			// margin variances
	string	scalar	_memat			// margin error codes
	string	scalar	_bstdmat		// standardized coefs

	real	scalar	_cmdextras
	real	scalar	_dfmiss
	string	scalar	_pclassmat		// e(b_pclass)

	real	scalar	_eq_check

	real	scalar	_neq

	real	scalar	_eform
	real	scalar	_eformall
	real	scalar	_percent
	real	scalar	_noskip
	real	scalar	_noprob

	real	scalar	_ndiparm
	string	vector	_diparm

	real	scalar	_df			// e(df_r)
	real	scalar	_level

	string	scalar	_mcompare		// multiple comparisons
	real	scalar	_mc_all

	real	scalar	_semstd

	real	scalar	_citype		// citype(type, [unadjusted])
	real	scalar	_ciadj		// =1 if unadjusted, =2 if adjusted

	string	vector	_eqselect

	// work space
	real	scalar	k_eq			// e(k_eq)
	real	scalar	k_aux			// e(k_aux)
	real	scalar	k_eq_skip		// e(k_eq_skip)
	real	scalar	k_extra			// e(k_extra)
	real	scalar	k_eform			// e(k_eform)

	real	vector	eq_count
	real	vector	eq_select
	real	vector	el_select

	real	scalar	is_cmmix
	real	scalar	is_me
	real	scalar	is_mi
	real	scalar	is_groups
	real	scalar	do_groups

	string	scalar	_cmd			// e(cmd)	if _cmdextras
	string	scalar	_cmd2			// e(cmd2)	if _cmdextras
	string	scalar	_prefix			// e(prefix)	if _cmdextras

	real	vector	bmat
	real	matrix	vmat
	real	matrix	Cnsmat
	real	vector	emat
	real	vector	dfmat
	real	vector	nmat
	real	vector	mmat
	real	matrix	mvmat
	real	matrix	memat
	real	matrix	bstdmat

	class _b_pclass scalar PC
	real	matrix	pclassmat

	real	scalar	has_bmat
	real	scalar	has_vmat
	real	scalar	has_Cnsmat
	real	scalar	has_emat
	real	scalar	has_dfmat
	real	scalar	has_cimat
	real	scalar	has_nmat
	real	scalar	has_mmat
	real	scalar	has_mvmat
	real	scalar	has_memat
	real	scalar	has_bstdmat

	real	scalar	useCns_label

	real	scalar	dim

	real	matrix	eq_info
	real	scalar	neq

	real	matrix	lf_info
	real	scalar	nlf

	real	matrix	diparm_info
	string	matrix	diparm_label
	real	matrix	diparm_select
	real	scalar	k_diparm
	real	matrix	diparm_table
	string	matrix	diparm_stripe
	real	vector	diparm_Cns

	real	matrix	term_index
	real	vector	term_levels
	real	vector	term_size

	string	vector	notes

	// results
	string	matrix	stripe
	string	matrix	altstripe
	string	vector	eqprefix
	real	vector	se
	real	vector	stat
	real	vector	extra
	real	vector	pvalue
	real	vector	crit
	real	matrix	ci
	real	vector	eform
	real	matrix	info
	string	vector	groups
	real	vector	k_grps
	string	vector	label
	string	scalar	mctitle

	// private subroutines
	void		fill_eq_count()
	void		fill_eq_select()
	void		fill_extra_scheffe()
	void		fill_extra_snk()
	void		fill_extra_common()
	void		fill_crit()
	void		fill_groups_wrk_bal()
	void		fill_groups_wrk_unbal()
	void		fill_groups()
	void		fill_pvalue()
	void		fill_ci()
	void		fill_cilogit()
	void		fill_ciwilson()
	void		fill_ciexact()
	void		fill_ciagresti()
	void		fill_cijeffreys()
	void		fill_eform()
	void		do_sem_extras()
	void		do_nlogit_extras()
	void		fill_mcinfo()
	void		compute_groups()
	void		compute_p_ci()
	void		count_diparms()
	void		fill_diparm()
	void		fill_diparms()

	void		reset_mcompare()
	
	real vector	ciset_n()

public:

	void		new()

			set_bmat()
			set_vmat()
			set_Cnsmat()
			set_emat()
			set_dfmat()
			set_cimat()
			set_nmat()
			set_mmat()
			set_mvmat()
			set_memat()
			set_bstdmat()

			set_cmdextras()
			set_dfmissing()
			set_pclassmat()

			set_eq_check()

			set_neq()

			set_eform()
			set_eformall()
			set_percent()
			set_noskip()
			set_noprob()

			set_eqselect()

			set_ndiparm()
			set_diparm()

			set_df()
			set_level()

			set_mcompare()
			set_mc_all()

			set_semstd()

			set_citype()

virtual	void		validate()

	real	scalar	k_eq()
	real	scalar	k_aux()
	real	scalar	k_eq_skip()
	real	scalar	k_extra()
	real	scalar	k_eform()

	void		compute()

	real	scalar	has_results()
	string	matrix	stripe()
	real	scalar	neq()
	real	vector	se()
	real	vector	stat()
	real	vector	pvalue()
	real	vector	crit()
	real	matrix	ci()
	string	vector	groups()
	real	vector	k_groups()
	string	scalar	mctitle()
virtual	void		post_results()
}

// private subroutines ------------------------------------------------------

void _b_stat::fill_eq_count()
{
	eq_count = J(1,dim,1)
	if (k_eq_skip == 0) {
		return
	}
	real	scalar	eq0
	real	scalar	eq1
	real	scalar	i0
	real	scalar	i1
	real	scalar	k

	eq0	= _neq + 1
	eq1	= _neq + k_eq_skip
	i0	= eq_info[eq0,1]
	i1	= eq_info[eq1,2]
	k	= i1 - i0 + 1
	eq_count[|i0\i1|] = J(1,k,0)
}

void _b_stat::fill_eq_select()
{
	_b_eq_select(stripe, _eqselect, eq_select, el_select)

	if (cols(_eqselect)) {
		k_eform = nlf
	}
}

void _b_stat::fill_extra_scheffe()
{
	real	scalar	k
	real	scalar	m0
	real	scalar	m1
	real	scalar	b0
	real	scalar	b1
	real	scalar	i
	real	matrix	V
	real	matrix	rnk
	real	matrix	mts
	real	scalar	minus

	if (has_mvmat) {
		mts	= st_matrixcolstripe_term_size(_mvmat)
		minus	= 1
	}
	else {
		minus	= 0
	}
	extra	= J(dim, 1, 1)
	k	= rows(term_levels)
	m1 = b1	= 0
	for (i=1; i<=k; i++) {
		b0 = b1 + 1
		b1 = b1 + term_size[i]
		if (has_mvmat) {
			m0 = m1 + 1
			m1 = m1 + mts[i]
			V = mvmat[|_2x2(m0,m0,m1,m1)|]
		}
		else {
			V = vmat[|_2x2(b0,b0,b1,b1)|]
		}
		rnk = term_levels[i] - diag0cnt(V) - minus
		extra[|_2x2(b0,1,b1,1)|] = J(term_size[i],1,rnk)
	}
}

void _b_stat::fill_extra_snk()
{
	real	vector	order
	real	scalar	eq
	real	scalar	k
	real	scalar	i
	real	scalar	ii, oii
	real	scalar	jj, ojj
	real	scalar	pos
	real	scalar	nlevel
	real	vector	morder
	real	scalar	start
	real	scalar	i_term

	morder	= order((st_matrixcolstripe_term_index(_mmat), mmat'), (1..3))
	k	= cols(mmat)
	order	= J(1,k,0)
	order[morder] = 1..k
	start	= 0
	i_term	= 1
	pos	= 0
	for (eq=1; eq<=neq; eq++) {
		k = term_index[eq_info[eq,2],2]
		for (i=1; i<=k; i++) {
			nlevel	= term_levels[i_term]
			for (ii=1; ii<nlevel; ii++) {
				oii = order[start+ii]
				for (jj=ii+1; jj<=nlevel; jj++) {
					ojj = order[start+jj]
					pos++
					extra[pos] = abs(ojj - oii) + 1
				}
			}
			start	= start + nlevel
			i_term++
		}
	}
}

void _b_stat::fill_extra_common()
{
	real	scalar	eq
	real	scalar	k
	real	scalar	i
	real	scalar	j
	real	scalar	pos
	real	scalar	pos0
	real	scalar	i_term
	real	vector	omit

	omit = st_matrixcolstripe_term_omit(_bmat)
	if (_mc_all) {
		if (k_eq_skip) {
			omit = term_size - omit
			omit = select(omit, eq_count)
			k = sum(omit)
		}
		else {
			k = sum(term_size-omit)
		}
		count_diparms()
		extra = J(1,dim,k+k_diparm)
		return
	}
	i_term	= 1
	pos	= 1
	for (eq=1; eq<=neq; eq++) {
		k = term_index[eq_info[eq,2],2]
		for (i=1; i<=k; i++) {
			pos0	= pos
			extra[pos] = term_size[i_term] - omit[i_term]
			pos++
			for (j=2; j<=term_size[i_term]; j++) {
				extra[pos] = extra[pos0]
				pos++
			}
			i_term++
		}
	}
}

void _b_stat::fill_crit()
{
	real	scalar	alpha
	real	scalar	pos
	real	scalar	i_term
	real	scalar	df
	real	scalar	eq
	real	scalar	k
	real	scalar	i
	real	scalar	pos0
	real	scalar	nlevel
	real	scalar	j
	real	scalar	do_all

	alpha	= (100-_level)/100
	do_all = has_dfmat | anyof(tokens("snk duncan"), _mcompare)
	if (!do_all & _mcompare == "noadjust") {
		crit = J(1,dim,_mc_crit(_mcompare, _df, alpha, 1, .))
		return
	}

	pos	= 1
	i_term	= 1
	df	= _df
	for (eq=1; eq<=neq; eq++) {
		k = term_index[eq_info[eq,2],2]
		for (i=1; i<=k; i++) {
			pos0	= pos
			nlevel	= term_levels[i_term]
			if (has_dfmat) {
				df = dfmat[pos]
			}
			crit[pos] = _mc_crit(	_mcompare,
						df,
						alpha,
						nlevel,
						extra[pos])
			if (df ==. & _dfmiss) {
				crit[pos] = .
			}
			pos++
			for (j=2; j<=term_size[i_term]; j++) {
				if (has_dfmat) {
					df = dfmat[pos]
				}
				if (do_all) {
					crit[pos] = _mc_crit(
						_mcompare,
						df,
						alpha,
						nlevel,
						extra[pos])
					if (df ==. & _dfmiss) {
						crit[pos] = .
					}
				}
				else {
					crit[pos] = crit[pos0]
				}
				pos++
			}
			i_term++
		}
	}
}

void _b_stat::fill_groups_wrk_bal(
	real	scalar	nlevel,				// input:
	real	scalar	start,				// input:
	real	scalar	pwstart,			// input:
	real	vector	morder,				// input:
	real	scalar	lastgrp,			// updated:
	real	vector	pwgroup,			// updated:
	string	vector	groups)				// updated:
{
	real	scalar	rc
	real	scalar	diff
	real	scalar	ii, oii, iii
	real	scalar	jj, ojj, jjj
	real	scalar	pos
	string	scalar	char
	real	vector	has_grp

	rc	= 0
	lastgrp = 0
	for (diff=nlevel-1; diff>0; diff--) {
	    for (ii=1; ii+diff<=nlevel; ii++) {
		jj	= ii + diff
		oii	= morder[start+ii] - start
		ojj	= morder[start+jj] - start
		pos	= _mc_pos(oii,ojj,nlevel) + pwstart

		if (pwgroup[pos] == 0) {
		    if (abs(stat[pos]) <= crit[pos]) {
			lastgrp++
			char = _mc_group(lastgrp, rc)
			if (rc) {
				groups = J(0,1,"")
				groups = J(0,1,"")
				do_groups = 0
				return
			}
			has_grp = J(nlevel,1,0)
			has_grp[ojj] = lastgrp
			for (iii=ii; iii<jj; iii++) {
			    oii = morder[start+iii] - start
			    has_grp[oii] = lastgrp
			for (jjj=iii+1; jjj<=jj; jjj++) {
			    ojj = morder[start+jjj] - start
			    pos  = _mc_pos(oii,ojj,nlevel) + pwstart
			    pwgroup[pos]  = lastgrp
			} // jjj
			} // iii
			ojj = start
			for (jj=1; jj<=nlevel; jj++) {
			    ojj++
			    groups[ojj] = groups[ojj] +
			    	(has_grp[jj] ? char : " ")
			}
		    }
		}
	    }
	}
}

void _b_stat::fill_groups_wrk_unbal(
	real	scalar	nlevel,				// input:
	real	scalar	start,				// input:
	real	scalar	pwstart,			// input:
	real	vector	morder,				// input:
	real	scalar	lastgrp,			// updated:
	string	vector	groups)				// updated:
{
	real	scalar	rc
	real	vector	term_morder
	real	scalar	i
	real	scalar	j
	string	scalar	char
	real	scalar	jj
	real	scalar	pos
	real	vector	new_grp
	real	vector	has_grp
	real	vector	add_grp
	real	matrix	not_sig

	not_sig	= I(nlevel)
	has_grp	= J(nlevel,nlevel,0)
	for (i=1; i<=nlevel; i++) {
	    for (j=i+1; j<=nlevel; j++) {
		pos	= _mc_pos(i,j,nlevel) + pwstart
		if (abs(stat[pos]) <= crit[pos]) {
		    not_sig[j,i] = 1
		}
	    } // j
	} // i
	_makesymmetric(not_sig)
	term_morder = morder[|_2x2(start+1,1,start+nlevel,1)|] :- start
	not_sig = not_sig[term_morder,term_morder]
	lastgrp = 0
	for (i=1; i<=nlevel; i++) {
	    for (j=i+1; j<=nlevel; j++) {
		new_grp = not_sig[,j]
		if (new_grp[i] == 0) {
		    continue
		}
		add_grp = new_grp
		for (jj=1; jj<=lastgrp; jj++) {
			if (has_grp[i,jj]) {
				add_grp = add_grp - has_grp[,jj]
			}
		}
		new_grp = (add_grp :== 1)
		add_grp = select(add_grp[|_2x2(i,1,nlevel,1)|],
				 not_sig[|_2x2(i,i,nlevel,i)|])
		if (anyof(add_grp,1)) {
		    lastgrp++
		    new_grp[i] = 1
		    new_grp[|_2x2(j,1,nlevel,1)|] =
			not_sig[|_2x2(j,j,nlevel,j)|]
		    has_grp[|_2x2(i,lastgrp,nlevel,lastgrp)|] =
			new_grp[|_2x2(i,1,nlevel,1)|] :*
			not_sig[|_2x2(i,i,nlevel,i)|]
		}
	    }
	} // i
	if (lastgrp) {
		rc = 0
		has_grp[term_morder,] = has_grp
		for (i=1; i<=lastgrp; i++) {
			jj = start
			char = _mc_group(i, rc)
			if (rc) {
				groups = J(0,1,"")
				groups = J(0,1,"")
				do_groups = 0
				return
			}
			for (j=1; j<= nlevel; j++) {
				jj++
				groups[jj] = groups[jj] +
				(has_grp[j,i] ? char : " ")
			}
		}
	}
}

void _b_stat::fill_groups()
{
	real	vector	morder
	real	scalar	start
	real	scalar	pwstart
	real	scalar	eq
	real	scalar	k
	real	scalar	eq_term
	real	scalar	nlevel
	real	scalar	ncmp
	real	scalar	i_term
	real	scalar	lastgrp
	real	vector	se_term
	real	vector	se_first
	real	vector	pwgroup

	pragma unset lastgrp

	k_grps	= J(rows(term_levels),1,.)
	if (_mc_all) {
		do_groups = 0
	}
	if (!do_groups) {
	    	groups = J(0,1,"")
		return
	}
	groups	= J(cols(mmat),1,"")
	pwgroup	= J(dim,1,0)
	morder	= order((st_matrixcolstripe_term_index(_mmat), mmat'), (1..3))
	start	= 0
	pwstart	= 0
	i_term	= 1
	for (eq=1; eq<=neq; eq++) {
	    k = term_index[eq_info[eq,2],2]
	    for (eq_term=1; eq_term<=k; eq_term++) {
		nlevel	= term_levels[i_term]
		ncmp	= nlevel*(nlevel-1)/2

		se_term	= se[|_2x2(1,pwstart+1,1,pwstart+ncmp)|]
		se_first = J(1,ncmp,se_term[1])
		if (max(reldif(se_term,se_first)) < `reldif_tol') {
			fill_groups_wrk_bal(	nlevel,
						start,
						pwstart,
						morder,
						lastgrp,
						pwgroup,
						groups)
		}
		else {
			fill_groups_wrk_unbal(	nlevel,
						start,
						pwstart,
						morder,
						lastgrp,
						groups)
		}
		if (do_groups == 0) {
			return
		}

		k_grps[i_term] = lastgrp
		start = start + nlevel
		pwstart = pwstart + ncmp
		i_term++
	    } // eq_term
	} // eq
}

void _b_stat::fill_pvalue()
{
	real	scalar	pos
	real	scalar	i_term
	real	scalar	df
	real	scalar	eq
	real	scalar	eq0
	real	scalar	eq1
	real	scalar	k
	real	scalar	i
	real	scalar	nlevel
	real	scalar	j
	string	scalar	name
	string	scalar	opt

	pos	= 1
	i_term	= 1
	df	= _df
	for (eq=1; eq<=neq; eq++) {
		k = term_index[eq_info[eq,2],2]
		for (i=1; i<=k; i++) {
			nlevel	= term_levels[i_term]
			for (j=1; j<=term_size[i_term]; j++) {
				if (has_dfmat) {
					df = dfmat[pos]
				}
				pvalue[pos] = _mc_pvalue(	_mcompare,
								df,
								stat[pos],
								nlevel,
								extra[pos])
				if (df == . & _dfmiss) {
					pvalue[pos] = .
				}
				if ((pclassmat[pos] == PC.value("VAR")) |
					(pclassmat[pos] == PC.value("VAR1"))) {
					if (stat[pos] > `chibar_eps') {
						pvalue[pos] = pvalue[pos]/2
					}
				}
				else if (pclassmat[pos] == PC.value("aux")) {
					stat[pos] = .b
					pvalue[pos] = .b
				}
				else if (pclassmat[pos] == PC.value("bseonly")) {
					stat[pos] = .b
					pvalue[pos] = .b
				}
				pos++
			}
			i_term++
		}
	}
	if (has_vmat & k_aux) {
		if (_noprob) {
			eq0 = _neq + k_eq_skip + 1
			eq1 = _neq + k_eq_skip + k_aux
			for (i=eq0; i<=eq1; i++) {
				i_term = eq_info[i,1]
				stat[i_term]	= .b
				pvalue[i_term]	= .b
			}
		}
		else {
			eq0 = _neq + k_eq_skip + 1
			eq1 = _neq + k_eq_skip + k_aux
			for (i=eq0; i<=eq1; i++) {
				name	= sprintf("e(diparm_opt%f)", i)
				opt	= st_global(name)
				if (strpos(opt, "noprob")) {
					i_term = eq_info[i,1]
					stat[i_term]	= .b
					pvalue[i_term]	= .b
				}
			}
		}
	}
}

void _b_stat::fill_ci()
{
	real	scalar	i
	real	scalar	r
	real	scalar	pq
	real	scalar	eq0
	real	scalar	eq1
	real	scalar	i_term
	string	scalar	name
	string	scalar	opt

	fill_crit()
	if (has_cimat) {
		return
	}
	if (_citype == `ci_logit') {
		fill_cilogit()
	}
	else if (_citype == `ci_wilson') {
		fill_ciwilson()
	}
	else if (_citype == `ci_exact') {
		fill_ciexact()
	}
	else if (_citype == `ci_agresti') {
		fill_ciagresti()
	}
	else if (_citype == `ci_jeffreys') {
		fill_cijeffreys()
	}
	else {
		ci[1,.] = bmat :- crit:*se
		ci[2,.] = bmat :+ crit:*se
	}
	if (anyof(pclassmat, PC.value("var"))
            | anyof(pclassmat, PC.value("bseonly"))) {
		for (i=1; i<=dim; i++) {
			if (pclassmat[i] == PC.value("bseonly")) {
				ci[.,i] = J(2,1,.b)
			}
			else if (pclassmat[i] == PC.value("var")) {
				stat[i] = .b
				pvalue[i] = .b
				ci[.,i] = J(2,1,.)
				if (bmat[i] > 0) {
					r = exp(crit[i]*se[i]/bmat[i])
					ci[1,i] = bmat[i]/r
					ci[2,i] = bmat[i]*r
				}
			}
		}
	}
	if (anyof(pclassmat, PC.value("corr"))) {
		for (i=1; i<=dim; i++) {
			if (pclassmat[i] == PC.value("corr")) {
// atanh(x) = (1/2){ln(1+x) - ln(1-x)}
// d atanh(x) / d x    =  (1/2)(1/(1+x) + 1/(1-x))
//	ci = atanh(x) - crit[i]*se[i]*(1/2)(1/(1+bmat[i]) + 1/(1-bmat[i])),
//	     atanh(x) + crit[i]*se[i]*(1/2)(1/(1+bmat[i]) + 1/(1-bmat[i]))
//	new ci = tanh(cil),tanh(ciu)
				ci[.,i] = J(2,1,.)
				if (bmat[i] >= -1 & bmat[i] <= 1) {
					r = crit[i]*se[i]*(1/2)*	///
						(1/(1+bmat[i]) + 1/(1-bmat[i]))
					ci[1,i] = tanh(atanh(bmat[i])-r)
					ci[2,i] = tanh(atanh(bmat[i])+r)
				}
			}
		}
	}
	if (anyof(pclassmat, PC.value("cilogit"))) {
		for (i=1; i<=dim; i++) {
			if (pclassmat[i] == PC.value("cilogit")) {
				stat[i] = .b
				pvalue[i] = .b
				r = logit(bmat[i])
				pq = bmat[i]*(1-bmat[i])
				ci[1,i] = invlogit(r:-crit[i]:*se[i]:/pq)
				ci[2,i] = invlogit(r:+crit[i]:*se[i]:/pq)
			}
		}
	}
	if (anyof(se, 0) | anyof(pclassmat, PC.value("VAR")) |
		anyof(pclassmat, PC.value("VAR1"))) {
		for (i=1; i<=dim; i++) {
			if (se[i] == 0) {
				ci[.,i] = J(2,1,.)
			}
			else if ((pclassmat[i] == PC.value("VAR")) |
				(pclassmat[i] == PC.value("VAR1"))) {
				if (ci[1,i] < 0) {
					ci[1,i] = 0
				}
			}
		}
	}
	if (has_vmat & k_aux) {
		eq0 = _neq + k_eq_skip + 1
		eq1 = _neq + k_eq_skip + k_aux
		for (i=eq0; i<=eq1; i++) {
			name	= sprintf("e(diparm_opt%f)", i)
			opt	= st_global(name)
			if (strpos(opt, "ci(log)")) {
				i_term = eq_info[i,1]
				r = exp(crit[i_term]*se[i_term]/bmat[i_term])
				ci[1,i_term] = bmat[i_term]/r
				ci[2,i_term] = bmat[i_term]*r
				if (ci[1,i_term] < 0) {
					ci[1,i_term] = 0
				}
			}
		}
	}
}

void _b_stat::fill_cilogit()
{
	real	vector	logit
	real	vector	pq

	logit	= logit(bmat)
	pq	= bmat:*(1:-bmat)

	ci[1,.] = invlogit(logit:-crit:*se:/pq)
	ci[2,.] = invlogit(logit:+crit:*se:/pq)
}

void _b_stat::fill_ciwilson()
{
	real	scalar	alpha, z
	real	vector	p1p, num1, num2, den, nact

	nact	= ciset_n(nmat)
	p1p	= bmat:*(1:-bmat)
	alpha	= 1 - (100-_level)/200
	z	= invnormal(alpha)
	num1	= bmat :+ z^2:/(2*nact)
	num2	= z * sqrt( p1p:/nact :+ z^2 :/ (4*nact:^2) )
	den	= 1 :+ z:^2 :/ nact

	ci[1,.] = (num1 :- num2) :/ den
	ci[2,.] = (num1 :+ num2) :/ den
}

void _b_stat::fill_ciexact()
{
	real	scalar	alpha
	real	vector	x, v1, v2, v3, v4, f1, f2, nact

	nact	= ciset_n(nmat)
	alpha	= (100-_level)/200
	x	= bmat:*nact
	v1	= 2:*x
	v2	= 2:*(nact :- x :+ 1)
	v3	= 2:*(x :+ 1)
	v4	= 2:*(nact :-x)

	f1 = invF(v1,v2,alpha)
	f2 = invF(v3,v4,1-alpha)

	ci[1,.] = v1:*f1 :/ (v2 :+ v1:*f1)
	ci[2,.] = v3:*f2 :/ (v4 :+ v3:*f2)
}

void _b_stat::fill_ciagresti()
{
	real	scalar	alpha, z
	real	vector	x, n, p1pn, nact

	nact 	= ciset_n(nmat)
	alpha	= 1 - (100-_level)/200
	z	= invnormal(alpha)
	x	= bmat:*nact :+ (z^2:/2)
	n	= nact :+ 2:*(z^2:/2)
	x	= x :/ n
	p1pn	= sqrt( x:*(1:-x) :/ n )

	ci[1,.] = x :- z :* p1pn
	ci[2,.] = x :+ z :* p1pn
}

void _b_stat::fill_cijeffreys()
{
	real	scalar	alpha
	real	vector	x, a1, b1, nact

	nact 	= ciset_n(nmat)
	alpha	= (100-_level)/200
	x	= bmat:*nact
	a1	= x :+ 0.5
	b1	= nact :-x :+ 0.5

	ci[1,.] = invibeta(a1,b1,alpha)
	ci[2,.] = invibeta(a1,b1,1-alpha)
}

void _b_stat::fill_eform()
{
	if (_eform == 0) {
		eform = J(1,dim,0)
		return
	}
	if (length(lf_info) == 0) {
		eform = J(1,dim,0)
		return
	}
	real	scalar	edim
	real	vector	expidx

	if (k_eform == 0) {
		k_eform = 1
	}

	if (is_cmmix) {
		expidx = selectindex(1:-(pclassmat:>1))
		edim = cols(expidx)
	}
	else {
		edim = lf_info[k_eform,2]
		expidx = 1..edim
	}
	bmat[expidx] = exp(bmat[expidx])
	if (has_vmat) {
		se[expidx] = se[expidx] :* bmat[expidx]
		ci[.,expidx] = exp(ci[.,expidx])
	}
	if (edim < dim) {
		eform = J(1,dim,0)
		eform[expidx] = J(1,edim,1)
	}
	else {
		eform = J(1,dim,1)
	}
}

void _b_stat::do_sem_extras()
{
	string	scalar	block
	real	scalar	pos
	real	scalar	eq
	real	scalar	el1
	real	scalar	el2
	real	scalar	nels
	real	scalar	el
	real	scalar	r

	// Use the log transformation to compute the CIs for the variance
	// parameters.  The covariance parameters will use the usual normal
	// approximation.

	block	= ""
	pos	= 0
	for (eq=1; eq<=neq; eq++) {
		el1 = eq_info[eq,1]
		el2 = eq_info[eq,2]
		nels = el2 - el1 + 1
		for (el=1; el<=nels; el++) {
			pos++
(void)			_sem_eq_block(	stripe[pos,1],
					stripe[pos,2],
					pclassmat[pos],
					block)
			if (block != "variance") {
				continue
			}
			stat[pos] = .b
			pvalue[pos] = .b
			if (has_cimat) {
				continue
			}
			ci[.,pos] = J(2,1,.)
			if (bmat[pos] > 0) {
				r = exp(crit[pos]*se[pos]/bmat[pos])
				ci[1,pos] = bmat[pos]/r
				ci[2,pos] = bmat[pos]*r
			}
		}
	}
}

void _b_stat::do_nlogit_extras()
{
	real	scalar	i
	real	scalar	ii
	real	scalar	k_levels
	real	scalar	j
	real	scalar	el
	real	scalar	has_const
	real	scalar	k_ind2vars
	string	scalar	ename
	real	matrix	altmat
	real	matrix	k_altern
	string	vector	alteqs
	string	vector	ind2vars
	real	scalar	k_alteqs
	real	scalar	i_base

	// Use the log transformation to compute the CIs for the variance
	// parameters.  The covariance parameters will use the usual normal
	// approximation.

	k_levels	= _b_get_scalar("e(levels)", 0)
	if (k_levels < 2) {
		return
	}
	j = 1
	if (_b_get_scalar("e(k_indvars)", 0)) {
		j++
	}
	for (i=1; i<=k_levels; i++) {
		if (i < k_levels) {
			ename = sprintf("e(const%f)", i)
			has_const = _b_get_scalar(ename, 0)
			ename = sprintf("e(ind2vars%f)", i)
			ind2vars = tokens(st_global(ename))
		}
		else {
			has_const = _b_get_scalar("e(const)", 0)
			ind2vars = tokens(st_global("e(ind2vars)"))
		}
		k_ind2vars = length(ind2vars)

		if (k_ind2vars + has_const == 0) {
			continue
		}

		if (i < k_levels) {
			if (k_ind2vars) {
				ename = sprintf("e(alt_ind2vars%f)", i)
				altmat = st_matrix(ename)
			}

			ename = sprintf("e(alteqs%f)", i)
			alteqs = tokens(st_global(ename))

			ename = sprintf("e(i_base%f)", i)
			i_base = _b_get_scalar(ename, 0)
		}
		else {
			if (k_ind2vars) {
				altmat = st_matrix("e(alt_ind2vars)")
			}

			alteqs = tokens(st_global("e(alteqs)"))

			i_base = _b_get_scalar("e(i_base)", 0)
		}
		k_alteqs = length(alteqs)
		if (rows(altmat) != k_alteqs) {
			altmat = J(k_alteqs, k_ind2vars, 1)
		}

		for (ii=1; ii<=k_alteqs; ii++) {
			if (ii == i_base) {
				if (any(altmat[ii,.])) {
					j++
				}
			}
			else {
				j++
			}
		}
	}
	if (j > neq) {
		return
	}
	k_altern = st_matrix("e(k_altern)")
	el = eq_info[j,1]
	for (i=1; i<k_levels; i++) {
		for (ii=1; ii<=k_altern[1,i]; ii++) {
			if (el <= dim) {
				stat[el] = .b
				pvalue[el] = .b
			}
			el++
		}
	}
}

void _b_stat::fill_mcinfo()
{
	real	matrix	omit
	real	matrix	size
	real	scalar	i_term
	real	scalar	eq
	real	scalar	el
	real	scalar	k
	real	scalar	i

	omit	= st_matrixcolstripe_term_omit(_bmat)
	if (is_groups) {
		size	= st_matrixcolstripe_term_size(_mmat)
	}
	else {
		size	= st_matrixcolstripe_term_size(_bmat)
	}
	if (_mc_all) {
		info	= J(1, 3, .)
		info[1,3] = sum(size-omit)
		return
	}
	info	= J(rows(term_size), 3, .)
	i_term	= 1
	for (eq=1; eq<=neq; eq++) {
		el	= 1
		k	= term_index[eq_info[eq,2],2]
		for (i=1; i<=k; i++) {
			info[i_term,1]	= eq
			info[i_term,2]	= el
			info[i_term,3]	= term_size[i_term] - omit[i_term]
			el = el + size[i_term]
			i_term++
		}
	}
}

void _b_stat::compute_groups()
{
	real	scalar	i

	fill_crit()
	fill_groups()
	_bmat	= _mmat
	_vmat	= _mvmat
	_emat	= _memat
	bmat	= mmat
	emat	= memat
	has_emat = has_memat
	label	= J(1,cols(bmat),"")
	stripe	= st_matrixcolstripe(_bmat)
	term_index = st_matrixcolstripe_term_index(_bmat)
	eq_info	= panelsetup(stripe, 1)
	dim	= length(bmat)
	se	= sqrt(diagonal(mvmat))
	pclassmat = J(1,dim,PC.value("default"))
	if (has_emat) {
		for (i=1; i<=cols(bmat); i++) {
			if (emat[i] != 0) {
				label[i] = notes[8]
				groups[i] = ""
				bmat[i] = .
				se[i] = .
				k_grps[term_index[i,2]] = 0
			}
		}
	}
}

void _b_stat::compute_p_ci()
{
	real	vector	hold

	if (_cmd == "sem") {
		// NOTE: -sem- has it's own idea for the values in
		// -e(b_pclass)- so we work around this by doing the
		// standard/default calculations, then fixing the CIs
		// for variances by calling the do_sem_extras() utility
		// later.

		hold = pclassmat
		pclassmat = J(1,cols(hold),PC.value("default"))
	}
	fill_diparms()
	fill_pvalue()
	fill_ci()
	fill_eform()

	if (_cmd == "sem") {
		pclassmat = hold
		do_sem_extras()
	}
	if (_cmd == "nlogit") {
		do_nlogit_extras()
	}
}

void _b_stat::count_diparms()
{
	transmorphic	t
	real	scalar	i
	string	scalar	tok

	t = tokeninit(" ", ",", (`""""', `"`""'"', char(96)+char(39), "()"))

	k_diparm = 0
	for (i=1; i<=_ndiparm; i++) {
		tokenset(t, _diparm[i])
		tok	= tokenget(t)
		if (!anyof(tokens("__sep__ __bot__ __lab__"), tok)) {
			k_diparm++
		}
	}
}

void _b_stat::fill_diparm(real scalar i, transmorphic t, string scalar extra)
{
	real	scalar	rc
	string	scalar	tok
	string	scalar	args
	string	scalar	eqname
	string	scalar	lab
	real	scalar	len
	real	scalar	eqlab
	real	scalar	b
	real	scalar	el
	string	scalar	comment
	real	scalar	prob

	// rows of diparm_table:
	//
	// 1:	value
	// 2:	std. err.
	// 3:	z or t
	// 4:	pvalue
	// 5:	ll for CI
	// 6:	ul for CI
	// 7:	df
	// 8:	crit
	// 9:	eform

	// rows of diparm_info:
	//
	// 1:	computation indicator
	// 2:	index

	prob	= .
	tok	= tokenget(t)
	if (tok == "__sep__") {
		diparm_info[1,i] = `diparm_sep'
	}
	else if (tok == "__bot__") {
		diparm_info[1,i] = `diparm_bot'
	}
	else if (tok == "__lab__") {
		eqlab	= 0
		b	= .b
		lab	= ""
		comment	= ""
		tok	= tokenget(t)
		len	= strlen(tok)
		if (tok == ",") {
			tok	= tokenget(t)
			len	= strlen(tok)
		}
		else if (len) {
			exit(error(198))
		}
		while (len) {
			if (tok == bsubstr("label",1,max((3,len)))) {
				tok	= tokenget(t)
				len	= strlen(tok)
				if (bsubstr(tok,1,1) != "(") {
					exit(error(198))
				}
				if (bsubstr(tok,len,1) != ")") {
					exit(error(198))
				}
				lab	= strtrim(bsubstr(tok,2,len-2))
				if (strmatch(lab, `"`"*"'"')) {
					len = strlen(lab)
					lab	= strtrim(bsubstr(lab,3,len-4))
				}
				if (strmatch(lab, `""*""')) {
					len = strlen(lab)
					lab	= strtrim(bsubstr(lab,2,len-2))
				}
			}
			else if (tok == bsubstr("eqlabel",1,max((5,len)))) {
				eqlab = 1
			}
			else if (tok == "value") {
				tok	= tokenget(t)
				len	= strlen(tok)
				if (bsubstr(tok,1,1) != "(") {
					exit(error(198))
				}
				if (bsubstr(tok,len,1) != ")") {
					exit(error(198))
				}
				tok	= bsubstr(tok,2,len-2)
				b	= strtoreal(tok)
			}
			else if (tok == "comment") {
				tok	= tokenget(t)
				len	= strlen(tok)
				if (bsubstr(tok,1,1) != "(") {
					exit(error(198))
				}
				if (bsubstr(tok,len,1) != ")") {
					exit(error(198))
				}
				comment	= strtrim(bsubstr(tok,2,len-2))
				if (strmatch(comment, `"`"*"'"')) {
				    len = strlen(comment)
				    comment = strtrim(bsubstr(comment,3,len-4))
				}
				if (strmatch(comment, `""*""')) {
				    len = strlen(comment)
				    comment = strtrim(bsubstr(comment,2,len-2))
				}
				comment	= "  " + comment
			}
			else {
				exit(error(198))
			}
			tok	= tokenget(t)
			len	= strlen(tok)
		}
		if (strlen(lab) == "") {
			exit(error(198))
		}
		if (b != .) {
			if (eqlab) {
				diparm_info[1,i] = `diparm_veqlab'
			}
			else {
				diparm_info[1,i] = `diparm_vlabel'
			}
			diparm_table[1,i] = b
		}
		else if (eqlab) {
			diparm_info[1,i] = `diparm_eqlab'
		}
		else {
			diparm_info[1,i] = `diparm_label'
		}
		diparm_label[1,i] = lab
		diparm_label[2,i] = comment
	}
	else {
		eqname	= tok
		args	= tok
		lab	= ""
		comment	= ""
		tok	= tokenget(t)
		if (anyof(`varcov', eqname) & strmatch(tok, "(*)")) {
			eqname	= eqname + tok
			args	= args + tok
			tok	= tokenget(t)
		}
		while (strlen(tok)) {
			if (tok == "label") {
				tok	= tokenget(t)
				len	= strlen(tok)
				if (bsubstr(tok,1,1) != "(") {
					exit(error(198))
				}
				if (bsubstr(tok,len,1) != ")") {
					exit(error(198))
				}
				lab	= strtrim(bsubstr(tok,2,len-2))
				if (strmatch(lab, `"`"*"'"')) {
					len = strlen(lab)
					lab	= strtrim(bsubstr(lab,3,len-4))
				}
				if (strmatch(lab, `""*""')) {
					len = strlen(lab)
					lab	= strtrim(bsubstr(lab,2,len-2))
				}
			}
			else if (any(strmatch(tok, "(*)"))) {
				args = sprintf("%s%s", args, tok)
			}
			else {
				if (tok == "noprob") {
					prob = 0
				}
				else if (tok == "prob") {
					prob = 1
				}
				args = sprintf("%s %s", args, tok)
			}
			tok	= tokenget(t)
		}
	if (strlen(lab) == 0) {
		lab = tokens(args)[1]
		rc = _stata(sprintf("_ms_parse_parts %s", lab), 1)
		if (rc == 0) {
		    if (	st_numscalar("r(omit)") &
		    		st_global("r(type)") != "interaction") {
			if (length(st_numscalar("r(base)"))) {
				if (st_numscalar("r(base)")) {
					lab = sprintf("%f%s.%s",
						st_numscalar("r(level)"),
						st_global("r(ts_op)"),
						st_global("r(name)"))
					comment	= "(base)"
				}
			}
			else {
				lab = st_global("r(ts_op)")
				if (strlen(lab)) {
					lab = sprintf("/%s.%s",
						lab,
						st_global("r(name)"))
				}
				else {
					lab = "/" + st_global("r(name)")
				}
				comment = "(omitted)"
			}
		    }
		    else {
			lab = "/" + lab
		    }
		}
	}

		rc = _stata(sprintf(	"_diparm %s %s",
					args,
					extra))
		if (rc) exit(rc)
		el = st_numscalar("r(i)")
		if (el) {
			diparm_info[1,i] = `diparm_aux'
			diparm_info[2,i] = el
		}
		else {
			diparm_info[1,i] = `diparm_trans'
		}
		diparm_table[1,i] = st_numscalar("r(est)")
		diparm_table[2,i] = st_numscalar("r(se)")
		if (strlen(comment) == 0) {
			if (diparm_table[1,i] == 0 &
			    (diparm_table[2,i] == 0 |
			     missing(diparm_table[2,i]))) {
				comment = "(omitted)"
			}
		}
		if ((missing(prob) & el == 0) | prob == 0) {
			diparm_table[3,i] = .b
			diparm_table[4,i] = .b
		}
		else {
			diparm_table[3,i] = st_numscalar("r(z)")
			diparm_table[4,i] = st_numscalar("r(p)")
		}
		diparm_table[5,i] = st_numscalar("r(lb)")
		diparm_table[6,i] = st_numscalar("r(ub)")
		diparm_table[7,i] = st_numscalar("r(df)")
		diparm_table[8,i] = st_numscalar("r(crit)")
		diparm_table[9,i] = 0
		diparm_label[1,i] = lab
		diparm_label[2,i] = comment
		diparm_Cns[1,i] = st_numscalar("r(cns)")
	}
}

void _b_stat::fill_diparms()
{
	if (_ndiparm == 0) {
		return
	}

	transmorphic	t
	string	scalar	extra
	real	scalar	i
	real	scalar	j
	real	scalar	pos
	real	scalar	inc_j
	string	scalar	eqname

	diparm_info	= J(2, _ndiparm, .b)
	diparm_table	= J(9, _ndiparm, .b)
	diparm_label	= J(2, _ndiparm, "")
	diparm_Cns	= J(1, _ndiparm, 0)

	t = tokeninit(" ", ",", (`""""', `"`""'"', char(96)+char(39), "()"))
	extra	= sprintf("level(%g) notab bmat(%s) vmat(%s) dfmat(%s)",
				_level,
				_bmat == "e(b)" ? "" : _bmat,
				_vmat == "e(V)" ? "" : _vmat,
				_vmat == "e(V)" ? "" : _dfmat)

	for (i=1; i<=_ndiparm; i++) {
		tokenset(t, _diparm[i])
		fill_diparm(i, t, extra)
	}

	diparm_select = diparm_info[1,.] :> 0
	k_diparm = sum(diparm_select)
	if (k_diparm) {
		diparm_stripe	= J(k_diparm,2,"")
		inc_j	= 0
		j	= 1
		pos	= 1
		eqname	= sprintf("_diparm%f", j)
		for (i=1; i<=_ndiparm; i++) {
			if (diparm_info[1,i] == `diparm_aux') {
				diparm_stripe[pos,.]=stripe[diparm_info[2,i],.]
				pos++
				if (inc_j == 0) {
					inc_j = 1
				}
			}
			else if (diparm_info[1,i] == `diparm_trans') {
				diparm_stripe[pos,1] = eqname
				diparm_stripe[pos,2] = diparm_label[1,i]
				pos++
				inc_j = 0
			}
			else if (diparm_info[1,i] == `diparm_vlabel') {
				diparm_stripe[pos,1] = eqname
				diparm_stripe[pos,2] = diparm_label[1,i]
				pos++
				inc_j = 0
			}
			else if (diparm_info[1,i] == `diparm_veqlab') {
				diparm_stripe[pos,1] = diparm_label[1,i]
				diparm_stripe[pos,2] = "_cons"
				pos++
				if (inc_j == 0) {
					inc_j = 1
				}
			}
			if (inc_j == 1) {
				j++
				eqname	= sprintf("_diparm%f", j)
				inc_j = .
			}
		}
	}
}

real vector _b_stat::ciset_n(real vector nmat)
{
	real	scalar	alpha, z
	real	vector	n

	if (_ciadj) {
		n = bmat:*(1:-bmat) :/ se:^2
		if (_ciadj==2) {
			alpha = 1 - (100-_level)/200
			z = invnormal(alpha)
			n = n:*(z / invt(_df,alpha)):^2
		}
	}
	else {
		n = nmat
	}
	return(n)
}

// public subroutines -------------------------------------------------------

void _b_stat::new()
{
	// settings
	_cmdextras	= 0
	_dfmiss		= 0
	_eq_check	= 1
	_eform		= 0
	_eformall	= 0
	_percent	= 0
	_noskip		= 0
	_noprob		= 0

	_df		= .
	_level		= c("level")
	_mc_all		= 0

	_semstd		= 0
	_citype		= `ci_default'

	has_Cnsmat	= 0
	useCns_label	= 0

	// work space
	is_groups	= 0
	do_groups	= 0
	k_diparm	= 0
}

function _b_stat::set_bmat(|string scalar name)
{
	if (args() == 0) {
		return(_bmat)
	}
	_bmat = name
}

function _b_stat::set_vmat(|string scalar name)
{
	if (args() == 0) {
		return(_vmat)
	}
	_vmat = name
}

function _b_stat::set_Cnsmat(|string scalar name)
{
	if (args() == 0) {
		return(_Cnsmat)
	}
	_Cnsmat = name
}

function _b_stat::set_emat(|string scalar name)
{
	if (args() == 0) {
		return(_emat)
	}
	_emat = name
}

function _b_stat::set_dfmat(|string scalar name)
{
	if (args() == 0) {
		return(_dfmat)
	}
	_dfmat = name
}

function _b_stat::set_cimat(|string scalar name)
{
	if (args() == 0) {
		return(_cimat)
	}
	_cimat = name
}

function _b_stat::set_nmat(|string scalar name)
{
	if (args() == 0) {
		return(_nmat)
	}
	_nmat = name
}

function _b_stat::set_mmat(|string scalar name)
{
	if (args() == 0) {
		return(_mmat)
	}
	_mmat = name
}

function _b_stat::set_mvmat(|string scalar name)
{
	if (args() == 0) {
		return(_mvmat)
	}
	_mvmat = name
}

function _b_stat::set_memat(|string scalar name)
{
	if (args() == 0) {
		return(_memat)
	}
	_memat = name
}

function _b_stat::set_bstdmat(|string scalar name)
{
	if (args() == 0) {
		return(_bstdmat)
	}
	_bstdmat = name
}

function _b_stat::set_cmdextras(|string scalar onoff)
{
	if (args() == 0) {
		if (_cmdextras) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_cmdextras = 1
	}
	else {
		_cmdextras = 0
	}
}

function _b_stat::set_dfmissing(|string scalar onoff)
{
	if (args() == 0) {
		if (_dfmiss) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_dfmiss = 1
	}
	else {
		_dfmiss = 0
	}
}

function _b_stat::set_pclassmat(|string scalar name)
{
	if (args() == 0) {
		return(_pclassmat)
	}
	_pclassmat = name
}

function _b_stat::set_eq_check(|string scalar onoff)
{
	if (args() == 0) {
		if (_eq_check) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_eq_check = 1
	}
	else {
		_eq_check = 0
	}
}

function _b_stat::set_neq(|real scalar n)
{
	if (args() == 0) {
		return(_neq)
	}
	if (n < 0) {
		_neq = .
	}
	else {
		_neq = n
	}
}

function _b_stat::set_eform(|string scalar onoff)
{
	if (args() == 0) {
		if (_eform) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_eform = 1
	}
	else {
		_eform = 0
	}
}

function _b_stat::set_eformall(|string scalar onoff)
{
	if (args() == 0) {
		if (_eformall) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_eformall = 1
	}
	else {
		_eformall = 0
	}
}

function _b_stat::set_percent(|string scalar onoff)
{
	if (args() == 0) {
		if (_percent) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_percent = 1
	}
	else {
		_percent = 0
	}
}

function _b_stat::set_noskip(|string scalar onoff)
{
	if (args() == 0) {
		if (_noskip) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_noskip = 1
	}
	else {
		_noskip = 0
	}
}

function _b_stat::set_noprob(|string scalar onoff)
{
	if (args() == 0) {
		if (_noprob) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_noprob = 1
	}
	else {
		_noprob = 0
	}
}

function _b_stat::set_eqselect(|string scalar eqselect)
{
	if (args() == 0) {
		return(invtokens(_eqselect))
	}
	_eqselect = tokens(eqselect)
}

function _b_stat::set_ndiparm(|real scalar ndiparm)
{
	if (args() == 0) {
		return(_ndiparm)
	}

	if (missing(ndiparm)) {
		_ndiparm = 0
	}
	else {
		if (ndiparm < 0) {
			errprintf("invalid ndiparm setting\n")
			exit(198)
		}
		_ndiparm = floor(ndiparm)
	}
	_diparm = J(1,_ndiparm,"")
	k_diparm = 0
}

function _b_stat::set_diparm(real scalar i, |string scalar diparm)
{
	if (i > _ndiparm) {
		errprintf("ndiparm setting too small\n")
		exit(198)
	}
	if (args() == 1) {
		return(_diparm[i])
	}

	if (strpos(diparm, ",")) {
		_diparm[i] = diparm
	}
	else {
		_diparm[i] = diparm + ","
	}
}

function _b_stat::set_df(|real scalar df)
{
	if (args() == 0) {
		return(_df)
	}
	if (missing(df)) {
		_df = .
	}
	else {
		_df = df
	}
}

function _b_stat::set_level(|real scalar level)
{
	if (args() == 0) {
		return(_level)
	}
	if (missing(level)) {
		_level = c("level")
	}
	else {
		if (level < 10 | level > 99.99) {
		    errprintf("level must be between 10 and 99.99 inclusive\n")
		    exit(198)
		}
		_level = level
	}
}

void _b_stat::reset_mcompare(|string scalar name)
{
	if (args()) {
		set_mcompare(name)
	}
	if (anyof(tokens("`pwcmds'"), _cmd)) {
		if (_mcompare == "noadjust") {
			mctitle	= "Unadjusted"
		}
	}
}

function _b_stat::set_mcompare(|string scalar name)
{
	if (args() == 0) {
		return(_mcompare)
	}
	real	scalar	len

	len = strlen(name)
	if (name == bsubstr("noadjust",1, max((5,len))) | len == 0) {
		_mcompare	= "noadjust"
		mctitle		= ""
	}
	else if (name == bsubstr("bonferroni",1, max((3,len)))) {
		_mcompare	= "bonferroni"
		mctitle		= "Bonferroni"
	}
	else if (name == bsubstr("sidak",1, max((3,len)))) {
		_mcompare	= "sidak"
		mctitle		= "Sidak"
	}
	else if (name == bsubstr("scheffe",1, max((3,len)))) {
		_mcompare	= "scheffe"
		mctitle		= "Scheffe"
	}
	else if (name == bsubstr("tukey",1, max((3,len)))) {
		_mc_check_method("tukey")
		_mcompare	= "tukey"
		mctitle		= "Tukey"
	}
	else if (name == "snk") {
		_mc_check_method("snk")
		_mcompare	= "snk"
		mctitle		= "SNK"
	}
	else if (name == bsubstr("duncan",1, max((3,len)))) {
		_mc_check_method("duncan")
		_mcompare	= "duncan"
		mctitle		= "Duncan"
	}
	else if (name == bsubstr("dunnett",1, max((3,len)))) {
		_mc_check_method("dunnet")
		_mcompare	= "dunnett"
		mctitle		= "Dunnett"
	}
	else {
		errprintf("method %s not recognized\n", name)
		exit(198)
	}
}

function _b_stat::set_mc_all(|string scalar name)
{
	if (args() == 0) {
		if (_mc_all) {
			return("adjustall")
		}
		return("")
	}
	real scalar len

	len = strlen(name)
	if (name == bsubstr("adjustall", 1, max((3,len)))) {
		_mc_all = 1
	}
	else {
		_mc_all = 0
	}
}

function _b_stat::set_semstd(|string scalar onoff)
{
	if (args() == 0) {
		if (_semstd) {
			return("on")
		}
		return("off")
	}
	if (onoff == "on") {
		_semstd = 1
	}
	else {
		_semstd = 0
	}
}

function _b_stat::set_citype(|string scalar citype)
{
	real	scalar	len
	string	scalar	ciname, ciadj
	string	vector	names

	if (args() == 0) {
		if (_citype == `ci_normal') {
			return("normal")
		}
		if (_citype == `ci_logit') {
			return("logit")
		}
		if (_citype == `ci_wilson') {
			return("wilson")
		}
		if (_citype == `ci_exact') {
			return("exact")
		}
		if (_citype == `ci_agresti') {
			return("agresti")
		}
		if (_citype == `ci_jeffreys') {
			return("jeffreys")
		}
		return("")
	}

	names = tokens(citype,", ")
	if (cols(names) == 0) {
		names = ""
	}
	ciname = names[1]

	if (cols(names) > 2) {
		ciadj = names[3]
	}
	else {
		ciadj = J(1,1,"")
	}

	if (_prefix == "svy" | st_global("e(vcetype)") == "Robust") {
		if (ciadj==bsubstr("unadjusted",1,max((strlen(ciadj),5)))) {
			_ciadj = 1
		}
		else 	_ciadj = 2
	}
	else {
		_ciadj = 0
	}

	len = strlen(ciname)
	if (ciname == bsubstr("normal",1,max((len,4)))) {
		_citype = `ci_normal'
	}
	else if (ciname == "wald") {
		_citype = `ci_normal'
	}
	else if (ciname == "logit") {
		_citype = `ci_logit'
	}
	else if (ciname == "wilson") {
		_citype = `ci_wilson'
	}
	else if (ciname == "exact") {
		_citype = `ci_exact'
	}
	else if (ciname == bsubstr("agresti",1,max((len,5)))) {
		_citype = `ci_agresti'
	}
	else if (ciname == bsubstr("jeffreys",1,max((len,4)))) {
		_citype = `ci_jeffreys'
	}
	else if (ciname == "") {
		_citype = `ci_default'
	}
	else {
		errprintf("invalid {bf:citype()} option;\n")
		errprintf("{bf:%s} is not a recognized CI type\n", ciname)
		exit(198)
	}
}

void _b_stat::validate()
{
	string	scalar	msg
	string	scalar	p
	real	scalar	recover
	real	scalar	i

	// NOTE: if you add more notes, you must update the notes array
	// in u_mi_estimate.ado

	notes	= J(1,`k_notes',"")
	notes[1]	= "(no observations)"
	notes[2]	= "(stratum with 1 PSU detected)"
	notes[3]	= "(sum of weights equals zero)"
	notes[4]	= "(denominator estimate equals zero)"
	notes[5]	= "(omitted)"
	notes[6]	= "(base)"
	notes[7]	= "(empty)"
	notes[8]	= "(not estimable)"
	notes[9]	= "(constrained)"
	notes[10]	= "(no path)"

	is_me	= 0
	is_mi	= st_global("e(mi)") == "mi"
	is_cmmix= 0
	if (_cmdextras) {
		_cmd = is_mi ? st_global("e(cmd_mi)") : st_global("e(cmd)")
		_prefix = st_global("e(prefix)")
		if (strlen(st_global("e(cmd2)"))) {
			_cmd2 = st_global("e(cmd2)")
		}
		if (anyof(tokens("gsem meglm"), _cmd) |
		    anyof(tokens("gsem meglm"), _cmd2)) {
			is_me = _b_get_scalar("e(mecmd)", 0)
		}
		if (anyof(tokens("cmmixlogit cmxtmixlogit"), _cmd)) {
			is_cmmix = 1
		}
	}

	if (_cmd == "sem" & _semstd) {
		if (_bmat == "" & _vmat == "" & _Cnsmat == "") {
			if (st_macroexpand("`"+"e(b_std)"+"'") == "matrix"
			 &  st_macroexpand("`"+"e(V_std)"+"'") == "matrix") {
				_bmat = "e(b_std)"
				_vmat = "e(V_std)"

			  if (st_macroexpand("`"+"e(Cns)"+"'") == "matrix") {
				_Cnsmat = "e(Cns)"
			  }

			}
			else {
				_semstd = 0
			}
		}
	}

	if (_bmat == "") {
		_bmat = "e(b)"
	}
	has_bmat = strlen(_bmat)
	if (has_bmat) {
		bmat = st_matrix(_bmat)
		has_bmat = (cols(bmat) != 0 & rows(bmat) == 1) |
			   (st_macroexpand("`"+"e(b)"+"'") == "matrix")
	}
	if (!has_bmat) {
		errprintf("point estimates required\n")
		exit(322)
	}

	if (_bmat == "e(b)") {
		if (_vmat == "") {
			_vmat = "e(V)"
		}
		if (strlen(_Cnsmat) == 0) {
			if (st_macroexpand("`"+"e(Cns)"+"'") == "matrix") {
				_Cnsmat = "e(Cns)"
			}
		}
		useCns_label = _b_get_scalar("e(useCns_label)")
		if (missing(useCns_label)) {
			useCns_label = 0
		}
	}
	has_vmat = strlen(_vmat)
	if (has_vmat) {
		vmat = st_matrix(_vmat)
		has_vmat = (cols(vmat) != 0 & rows(vmat) != 0) |
			   (st_macroexpand("`"+"e(V)"+"'") == "matrix")
	}
	has_Cnsmat = strlen(_Cnsmat)
	if (has_Cnsmat) {
		Cnsmat = st_matrix(_Cnsmat)
		has_Cnsmat = rows(Cnsmat)
	}

	if (_bmat == "e(b)") {
		if (_emat == "") {
			if (st_macroexpand("`"+"e(error)"+"'") == "matrix") {
				_emat = "e(error)"
			}
		}
	}
	has_emat = strlen(_emat)
	if (has_emat) {
		emat = st_matrix(_emat)
	}

	if (strlen(_nmat) == 0) {
		if (st_macroexpand("`"+"e(_N)"+"'") == "matrix") {
			_nmat = "e(_N)"
		}
	}
	has_nmat = strlen(_nmat)
	if (has_nmat) {
		nmat = st_matrix(_nmat)
	}

	has_mmat = strlen(_mmat)
	if (has_mmat) {
		mmat = st_matrix(_mmat)
	}

	has_mvmat = strlen(_mvmat)
	if (has_mvmat) {
		mvmat = st_matrix(_mvmat)
	}

	has_memat = strlen(_memat)
	if (has_memat) {
		memat = st_matrix(_memat)
	}

	has_bstdmat = strlen(_bstdmat)
	if (has_bstdmat) {
		bstdmat = st_matrix(_bstdmat)
	}

	if (_mc_all) {
		if (anyof(tokens("`NOADJUSTALL'"), _mcompare)) {
errprintf("option adjustall is not allowed with option %s\n", _mcompare)
			exit(198)
		}
	}

	if (is_groups) {
		if (!anyof(tokens("`pwcmds'"), _cmd)) {
errprintf("option groups require results from pwcompare\n")
			exit(198)
		}
		if (_mcompare == "dunnet") {
errprintf("only one of option groups or dunnet is allowed\n")
			exit(198)
		}
		if (!has_mvmat) {
errprintf("option groups requires margin variances\n")
			exit(198)
		}
	}

	if (is_mi) {
		if (_dfmat == "") {
			_dfmat = "e(df_mi)"
		}
	}
	has_dfmat = strlen(_dfmat)
	if (has_dfmat) {
		dfmat = st_matrix(_dfmat)
	}
	has_cimat = strlen(_cimat)
	if (has_cimat) {
		ci = st_matrix(_cimat)
	}

	dim	= length(bmat)
	nlf	= .
	if (st_matrixcolnfreeparms(_bmat)) {
		stripe	= st_matrixcolstripe(_bmat)
		for (i=1; i<=dim; i++) {
			if (substr(stripe[i,1],1,1) == "/") {
				stripe[i,1] = sprintf("%s:%s",
						stripe[i,1],
						stripe[i,2])
			}
		}
		lf_info	= panelsetup(stripe, 1)
		nlf	= rows(lf_info)
	}

	stripe	= st_matrixcolstripe(_bmat)
	eqprefix= st_matrixcolprefixnames(_bmat)
	eq_info	= panelsetup(stripe, 1)
	neq	= rows(eq_info)
	if (nlf == .) {
		lf_info = eq_info
		nlf = neq
	}
	if (has_vmat) {
		_b_check_rows(_vmat, vmat, length(bmat))
		_b_check_cols(_vmat, vmat, length(bmat))
	}
	if (has_emat) {
		_b_check_cols(_emat, emat, length(bmat))
	}
	if (has_dfmat) {
		_b_check_cols(_dfmat, dfmat, length(bmat))
	}
	if (has_cimat) {
		_b_check_cols(_cimat, ci, length(bmat))
	}

	recover = 0
	if (st_matrixcolnfreeparms(_bmat)) {
		_eq_check = 0
	}
	else if (_bmat != "e(b)") {
		recover = 1
	}

	k_eform	= .
	if (_eq_check) {
		k_eq = _b_get_scalar("e(k_eq)")
		if (missing(k_eq)) {
			k_eq = neq
		}
		else if (k_eq > neq) {
			if (recover) {
				_eq_check = 0
			}
			else {
				errprintf(
"estimation command error: e(k_eq) is larger than the number of equations\n")
				exit(322)
			}
		}
		k_aux = _b_get_scalar("e(k_aux)")
		if (missing(k_aux)) {
			k_aux = 0
		}
		if (_noskip) {
			k_eq_skip = 0
		}
		else {
			k_eq_skip = _b_get_scalar("e(k_eq_skip)")
			if (missing(k_eq_skip)) {
				k_eq_skip = 0
			}
		}
		k_extra = _b_get_scalar("e(k_extra)")
		if (missing(k_extra)) {
			k_extra = 0
		}
		if (k_aux | k_eq_skip | k_extra) {
			if (k_eq != neq) {
				if (recover) {
					_eq_check = 0
				}
				else {
					errprintf(
"estimation command error: e(k_eq) does not equal the number of equations\n")
					exit(322)
				}
			}
		}
		if (anyof(tokens("mlogit mprobit"), _cmd)) {
			k_eform = k_eq - k_extra
		}
		else {
			k_eform = _b_get_scalar("e(k_eform)")
			if (missing(k_eform)) {
				k_eform = 1
			}
			if (k_eform > nlf) {
				k_eform = nlf
			}
		}
	}
	if (_eq_check == 0) {
		k_eq		= neq
		k_aux		= 0
		k_eq_skip	= 0
		k_extra		= 0
		k_eform = _b_get_scalar("e(k_eform)")
		if (missing(k_eform)) {
			k_eform = 1
		}
		if (k_eform > nlf) {
			k_eform = 1
		}
	}
	if (k_aux | k_eq_skip | k_extra) {
		if (k_eq != neq) {
			errprintf(
"estimation command error: e(k_eq) does not equal the number of equations\n")
			exit(322)
		}
	}
	if (!missing(_neq)) {
		k_aux		= 0
		k_eq_skip	= 0
		k_extra		= 0
		if (_eformall) {
			lf_info = eq_info
			nlf = neq
			k_eform = _neq
		}
	}
	else {
		_neq = k_eq - k_aux - k_extra - k_eq_skip
		if (_neq < 0) {
			msg	= ""
			p	= ""
			if (k_aux) {
				msg = sprintf(	"%s%s%s",
						msg,
						p,
						"e(k_aux)")
				p = " + "
			}
			if (k_eq_skip) {
				msg = sprintf(	"%s%s%s",
						msg,
						p,
						"e(k_eq_skip)")
				p = " + "
			}
			if (k_extra) {
				msg = sprintf(	"%s%s%s",
						msg,
						p,
						"e(k_extra)")
				p = " + "
			}
			errprintf(
"estimation command error: e(k_eq) is less than %s\n", msg)
			exit(322)
		}
	}
	if (missing(k_eform)) {
		k_eform = 1
	}
	if (_pclassmat == "") {
		if (st_macroexpand("`"+"e(b_pclass)"+"'") == "matrix") {
			_pclassmat = "e(b_pclass)"
		}
	}
	if (strlen(_pclassmat)) {
		pclassmat = st_matrix(_pclassmat)
	}
	if (cols(pclassmat) != dim) {
		pclassmat = J(1,dim,PC.value("default"))
	}
	if (_cmdextras) {
		if (_cmd == "sem") {
			_mcompare = "noadjust"
			_mc_all = 0
			useCns_label = 1
			if (has_vmat) {
				altstripe = st_matrixcolstripe(_vmat)
			}
		}
		if (_cmd == "gsem") {
			if (has_vmat) {
				altstripe = st_matrixcolstripe(_vmat)
			}
		}
	}

	reset_mcompare()
}

real scalar _b_stat::k_eq()
{
	return(k_eq)
}

real scalar _b_stat::k_aux()
{
	return(k_aux)
}

real scalar _b_stat::k_eq_skip()
{
	return(k_eq_skip)
}

real scalar _b_stat::k_extra()
{
	return(k_extra)
}

real scalar _b_stat::k_eform()
{
	return(k_eform)
}

void _b_stat::compute()
{
	real	scalar	reset_se0
	real	scalar	i
	real	scalar	k
	real	scalar	eq
	real	scalar	el
	real	scalar	err
	real	vector	sub
	real	matrix	C
	string	scalar	opt
	string	scalar	ms_info
	real	scalar	is_aux
	real	scalar	is_sumcmd

	stat	= J(1,dim,.)
	pvalue	= J(1,dim,.)
	if (has_cimat == 0) {
		ci	= J(2,dim,.)
	}
	label	= J(1,dim,"")

	if (!has_vmat) {
		if (_percent) bmat = 100*bmat
	}

	term_index	= st_matrixcolstripe_term_index(_bmat)
	term_size	= st_matrixcolstripe_term_size(_bmat)
	if (max(term_size) == 1 & !_mc_all) {
		if (_mcompare != "noadjust") {
			displayas("txt")
			opt = _mcompare
			if (!anyof(tokens("`pwcmds'"), _cmd)) {
				opt = sprintf("mcompare(%s)", opt)
			}
			printf("{p 0 6 2}")
			printf("note: option %s ignored since ", opt)
			if (rows(term_size) > 1) {
				printf("all terms provide only one comparison")
			}
			else {
				printf("there is only one comparison")
			}
			printf("{p_end}")
		}
		reset_mcompare("noadjust")
	}
	if (has_mmat) {
		term_levels	= st_matrixcolstripe_term_levels(_mmat)
	}
	else {
		if (anyof(tokens("tukey snk duncan dunnett"), _mcompare)) {
			errprintf("method %s requires margins\n", _mcompare)
			exit(198)
		}
		term_levels	= st_matrixcolstripe_term_levels(_bmat)
	}

	is_sumcmd = anyof(tokens("`sumcmds'"), _cmd)
				// any changes below for setting se[] to be
				// missing may need to be replicated in
				// u_mi_estimate_display.ado
				// and lmatasrc/ado/_mi_inference.mata
	reset_se0 = !is_sumcmd
	
	if (_prefix == "svy") {
		if (!missing(_b_get_scalar("e(census)", .))) {
			reset_se0 = _b_get_scalar("e(census)") != 1
		}
	}
	else if (reset_se0 == 0) {
		reset_se0 = _b_get_scalar("e(singleton)", 0) == 1
	}
	if (has_vmat) {
	    se	= sqrt(diagonal(vmat))'
	    if (reset_se0) {
		sub = se :== 0
		if (any(sub)) {
			for (i=1; i<=dim; i++) {
				if (sub[i]) {
					se[i] = .
				}
			}
		}
	    }
	    else if ((is_sumcmd & !is_mi) |
		 (is_sumcmd & is_mi & _bmat=="e(b_mi)")) {
		if (is_mi) {
			sub = st_matrix("e(_N_min_mi)")
		}
		else sub = st_matrix("e(_N)")
		if (length(sub) != dim) {
			sub = J(1,dim,1)
		}
		else {
			sub = (sub :<= 1)
		}
		for (i=1; i<=dim; i++) {
			if (sub[i]) {
				se[i] = .
			}
		}
	    }
	}

	ms_info	= sprintf("_ms_element_info, mat(%s)", _bmat)
	ms_info	= ms_info + " eq(#%f) el(%f)"

	i = 0
	for (eq=1; eq<=neq; eq++) {
		is_aux = (eq >= _neq + k_eq_skip + 1)	&
			 (eq <= _neq + k_eq_skip + k_aux)
		if (!is_aux) {
			if (substr(stripe[eq_info[eq,1],1],1,1) == "/") {
				is_aux = 1
			}
		}
		k = eq_info[eq,2] - eq_info[eq,1] + 1
		for (el=1; el<=k; el++) {
			i++

			stata(sprintf(ms_info, eq, el))
			label[i] = st_global("r(note)")
			if (is_aux) {
				if (label[i] == notes[5]) {
					label[i] = notes[9]
				}
			}

			if (has_vmat) {
			    if (missing(se[i])) {
				if (bmat[i] == 0) {
					if (useCns_label) {
						label[i] = notes[9]
					}
					else if (strlen(label[i]) == 0) {
						label[i] = notes[5]
					}
				}
				else if (has_Cnsmat) {
					C = Cnsmat[,i]
					if (any(C)) {
						label[i] = notes[9]
					}
					else if (label[i] == notes[5]) {
						label[i] = ""
					}
				}
			    }
			}
			if (has_emat) {
				// changes to this portion of the code may need
				// to be replicated in u_mi_estimate_display.ado
				// and lmatasrc/ado/_mi_inference.mata
				err = emat[i]
				if (floor(err) != err) {
					err = 0
				}
				if (err < 1 | err > `k_notes') {
					err = 0
				}
				if (err) {
					label[i] = notes[err]
					if ((err >= 1 & err <= 4) | err == 8) {
						if (err > 1) {
							bmat[i] = .
						}
						if (has_vmat) {
							se[i] = .
						}
					}
					else if (is_sumcmd & err == 7) {
						if (has_vmat) {
							se[i] = .
						}
					}
				}
			}
		}
	}

	if (has_vmat == 0) {
		return
	}

	stat	= bmat :/ se

	extra	= J(1,dim,1)
	pvalue	= J(1,dim,.)
	crit	= J(1,dim,.)
	fill_eq_count()
	fill_eq_select()
	if (_mcompare == "scheffe") {
		fill_extra_scheffe()
	}
	else if (anyof(tokens("snk duncan"), _mcompare)) {
		fill_extra_snk()
	}
	else if (!anyof(tokens("tukey dunnett noadjust"), _mcompare)) {
		fill_extra_common()
	}

	fill_mcinfo()
	if (is_groups) {
		compute_groups()
	}
	else {
		compute_p_ci()
	}

	if (_percent) {
		bmat 	= 100*bmat
		se 	= 100*se
		ci 	= 100*ci
	}
}

real scalar _b_stat::has_results()
{
	return(has_vmat)
}

string matrix _b_stat::stripe()
{
	return(stripe)
}

real scalar _b_stat::neq()
{
	return(neq)
}

real vector _b_stat::se()
{
	return(se)
}

real vector _b_stat::stat()
{
	return(stat)
}

real vector _b_stat::pvalue()
{
	return(pvalue)
}

real vector _b_stat::crit()
{
	return(crit)
}

real matrix _b_stat::ci()
{
	return(ci)
}

string vector _b_stat::groups()
{
	return(groups)
}

real vector _b_stat::k_groups()
{
	return(k_grps)
}

string scalar _b_stat::mctitle()
{
	return(mctitle)
}

void _b_stat::post_results(string scalar prefix, string scalar suffix)
{
	string	scalar	name
	string	scalar	myprefix
	string	matrix	cstripe
	string	matrix	rstripe
	real	scalar	n
	real	scalar	i
	real	matrix	t
	real	scalar	pwhide

	pwhide	= anyof(tokens("`pwcmds'"), _cmd)
	if (prefix == "") {
		myprefix = "mc"
		if (pwhide) {
			pwhide = strlen(suffix) == 0
		}
	}
	else {
		myprefix = prefix
		pwhide	= 0
	}
	st_rclear()
	if (is_groups) {
		st_global("r(mcmethod)", _mcompare)

		st_matrix("r(k_groups)", k_grps)
		n = length(groups)
		for (i=1; i<=n; i++) {
			st_global(sprintf("r(groups%f)",i), groups[i])
		}
		return
	}

	name	= sprintf("r(%smethod%s)", myprefix, suffix)
	if (pwhide) {
		st_global(name, _mcompare, "hidden")
	}
	else {
		st_global(name, _mcompare)
	}
	if (_mc_all & _mcompare != "noadjust") {
		name	= sprintf("r(%sadjustall%s)", myprefix, suffix)
		st_global(name, "adjustall")
	}
	name	= sprintf("r(%stitle%s)", myprefix, suffix)
	if (pwhide) {
		st_global(name, mctitle, "hidden")
	}
	else {
		st_global(name, mctitle)
	}

	name	= sprintf("r(%stable%s)", prefix, suffix)
	if (has_vmat) {
		if (has_dfmat) {
			t =	bmat		\
				se		\
				stat		\
				pvalue		\
				ci		\
				dfmat		\
				crit		\
				eform
		}
		else {
			t =	bmat		\
				se		\
				stat		\
				pvalue		\
				ci		\
				J(1,dim,_df)	\
				crit		\
				eform
		}
		rstripe = J(9,2,"")
		rstripe[1,2] = "b"
		rstripe[2,2] = "se"
		rstripe[3,2] = has_dfmat | !missing(_df) ? "t" : "z"
		rstripe[4,2] = "pvalue"
		rstripe[5,2] = "ll"
		rstripe[6,2] = "ul"
		rstripe[7,2] = "df"
		rstripe[8,2] = "crit"
		rstripe[9,2] = "eform"
		st_numscalar("r(level)", _level)
	}
	else {
		t = bmat
		rstripe = J(1,2,"")
		rstripe[1,2] = "b"
	}
	cstripe	= stripe
	if (k_eq_skip) {
		t = select(t, eq_count)
		cstripe = select(cstripe, eq_count')
	}
	else if (anyof(eq_select,0)) {
		t = select(t, el_select)
		cstripe = select(cstripe, el_select')
		label = select(label, el_select)
		dim = cols(t)
	}
	if (k_diparm) {
		real matrix td

		td = select(diparm_table, diparm_select)
		if (!has_vmat) {
			td = td[1,.]
		}
		t = t, td
		cstripe = cstripe \ diparm_stripe
	}
	if (length(t) == 0) {
		return
	}
	st_matrix(name, t)
	st_matrixcolstripe(name, cstripe)
	st_matrixrowstripe(name, rstripe)
	if (prefix == "" & suffix == "") {
		i = _stata("_put_coef_table")
		if (i) exit(i)
	}
	for (i=1; i<=dim; i++) {
		if (strlen(label[i])) {
			name = sprintf("r(label%f)",i)
			st_global(name, label[i], "hidden")
		}
	}
	for (i=1; i<=k_diparm; i++) {
		if (diparm_Cns[i]) {
			name = sprintf("r(label%f)",dim+i)
			st_global(name, notes[9], "hidden")
		}
	}
	st_global("r(citype)", set_citype(), "hidden")
	if (_ciadj==1) {
		st_global("r(ciadj)", "unadjusted", "hidden")
	}
}

end
