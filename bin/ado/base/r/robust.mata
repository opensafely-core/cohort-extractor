*! version 1.3.1  24oct2018
version 10

local Errcode	real scalar

local Errcode_noobs		1
local Errtext_noobs		`""no observations""'
local Errcode_conformability	2
local Errtext_conformability	`""conformability error""'
local Errcode_nodim		3
local Errtext_nodim		`""no equations specified""'
local Errcode_wtype		4
local Errtext_wtype		`""invalid weight type""'
local Errcode_post_negative	5
local Errtext_post_negative	`""poststratum weights must be >= 0""'
local Errcode_post_notconstant	6
local Errtext_post_notconstant	///
`""poststratum weights must be constant within poststrata""'
local Errcode_fpc_negative	7
local Errtext_fpc_negative	`""fpc must be >= 0""'
local Errcode_fpc_notconstant	8
local Errtext_fpc_notconstant	///
`""fpc for all observations within a stratum must be the same""'
local Errcode_fpc_invalid	9
local Errtext_fpc_invalid	///
`""fpc must be <= 1 if a rate, or >= no. sampled units per stratum if unit totals""'

local RobustStruct struct robust__struct scalar

local ROB_skip_setup_default	0
local ROB_scores_default	"&J(0,0,.)"
local ROB_xvars_default		"J(1,1,NULL)"
local ROB_touse_default		"&J(0,1,.)"
local ROB_subuse_default	"&J(0,1,.)"
local ROB_w_default		"&J(0,1,.)"
local ROB_post_default		"&J(0,2,.)"
local ROB_fpc_default		"&J(0,0,.)"
local ROB_stsu_default		"&J(0,0,.)"
local ROB_strid_default		"&J(0,0,.)"
local ROB_uid_default		"&J(0,0,.)"

local ROB_real		0
local ROB_tsok		1
local ROB_strok1	2
local ROB_strok		3

local i1 "{col 5}"
local i2 "{col 10}"
local i3 "{col 15}"
local c2 "{col 46}"

mata:

struct robust__struct {
	// output
	real			matrix		V
	real			matrix		V_srswr
	real			matrix		V_srswrsub
	real			scalar		N
	real			scalar		N_strata
	real			scalar		N_clust
	real			scalar		sum_w
	real			scalar		N_sub
	real			scalar		sum_wsub
	real			scalar		census
	real			scalar		singleton
	real			scalar		N_strata_omit
	real			rowvector	_N_postsize
	real			rowvector	_N_postsum
	real			rowvector	_N_strata
	real			rowvector	_N_strata_single
	real			rowvector	_N_strata_certain
	// input
	real			scalar		neq
	real			rowvector	eqcons
	real			scalar		wtype
	real			scalar		stages
	real			scalar		k_strata
	real			scalar		k_units
	real			scalar		singleu
	real			scalar		minus
	real			scalar		svyset
	real			scalar		svyg
	real			scalar		skip_setup
	pointer(real matrix)	scalar		covmat
	pointer(real matrix)	scalar		pm_scores
	pointer(real matrix)	scalar		pm_calscores
	pointer(real matrix)	rowvector	pm_xvars
	pointer(real colvector)	scalar		pm_touse
	pointer(real colvector)	scalar		pm_subuse
	pointer(real colvector)	scalar		pm_w
	pointer(real colvector)	rowvector	units
	pointer(real colvector)	rowvector	strata
	pointer(real colvector)	rowvector	fpc
	pointer(real matrix)	scalar		pm_post
	real			scalar		dosrs
	real			scalar		verbose
	// Stata vars
	string			scalar		st_scores
	string			scalar		st_calscores
	string			rowvector	st_xvars
	string			scalar		st_touse
	string			scalar		st_subuse
	string			scalar		st_subpop
	string			rowvector	st_units
	string			rowvector	st_strata
	string			rowvector	st_fpc
	string			scalar		st_w_temp
	string			scalar		st_w
	string			scalar		st_post
	string			scalar		calmethod
	string			scalar		calmodel
	string			scalar		calopts
	// pointers to temporary storage
	pointer(real matrix)	scalar		pm_fpc
	pointer(real matrix)	scalar		pm_stsu
	pointer(real matrix)	scalar		pm_strid
	pointer(real matrix)	scalar		pm_uid
	// internal elements
	real			scalar		ucall
	real			scalar		errorcode
	string			scalar		errortext
}

// robust_init*() routines --------------------------------------------------

transmorphic scalar robust_init()
{
	`RobustStruct' R

	// output elements
	R.V			= J(0,0,.)
	R.V_srswr		= J(0,0,.)
	R.V_srswrsub		= J(0,0,.)
	R.N			= .
	R.N_strata		= .
	R.N_clust		= .
	R.sum_w			= .
	R.N_sub			= .
	R.sum_wsub		= .
	R.census		= .
	R.singleton		= .
	R.N_strata_omit		= .
	R._N_postsize		= J(1,0,.)
	R._N_postsum		= J(1,0,.)
	R._N_strata		= J(1,0,.)
	R._N_strata_single	= J(1,0,.)
	R._N_strata_certain	= J(1,0,.)

	// input elements
	rob__set_eqsize(R, 1)
	rob__set_stagesize(R, 1)
	R.wtype			= 0
	R.k_strata		= 0
	R.k_units		= 0
	R.singleu		= 0
	R.minus			= 1
	R.svyset		= 0
	R.svyg			= 0
	R.skip_setup		= `ROB_skip_setup_default'
	R.pm_scores		= `ROB_scores_default'
	R.pm_calscores		= `ROB_scores_default'
	R.pm_touse		= `ROB_touse_default'
	R.pm_subuse		= `ROB_subuse_default'
	R.pm_w			= `ROB_w_default'
	R.pm_post		= `ROB_post_default'
	R.pm_fpc		= `ROB_fpc_default'
	R.pm_stsu		= `ROB_stsu_default'
	R.pm_strid		= `ROB_strid_default'
	R.pm_uid		= `ROB_uid_default'
	R.dosrs			= 0
	R.ucall			= 0
	R.verbose		= 1
	R.errorcode		= 0
	R.errortext		= ""

	// Stata input elements
	R.st_scores		= ""
	R.st_xvars		= J(1,1,"")
	R.st_touse		= ""
	R.st_subuse		= ""
	R.st_subpop		= ""
	R.st_units		= ""
	R.st_strata		= ""
	R.st_fpc		= ""
	R.st_w			= ""
	R.st_post		= ""
	R.calmethod		= ""
	R.calmodel		= ""
	R.calopts		= ""

	return(R)
}

function robust_init_verbose(`RobustStruct' R, | scalar verbose)
{
	if (args() == 1) {
		return(R.verbose)
	}
	if (isstring(verbose)) {
		if (verbose == "on") {
			R.verbose = 1
		}
		else if (verbose == "off") {
			R.verbose = 0
		}
		else {
			errprintf("invalid verbose argument")
			exit(3498)
		}
	}
	else if (isreal(verbose)) {
		R.verbose = (verbose != 0)
	}
	else {
		errprintf("invalid verbose argument")
		exit(3498)
	}
}

function robust_init_scores(`RobustStruct' R, |scores)
{
	if (args() == 1) {
		if (length(*R.pm_scores)) {
			return(*R.pm_scores)
		}
		if (strlen(R.st_scores)) {
			return(rob__st_view(R, R.st_scores, `ROB_real'))
		}
		return(J(0,0,.))
	}
	R.st_scores	= ""
	if (isreal(scores)) {
		R.pm_scores = &scores
	}
	else {
		R.st_scores = rob__check_varnames(
			scores, 1, ., "scores", `ROB_real')
	}
}

function robust_init_eq_n(`RobustStruct' R, |real scalar neq)
{
	if (args() == 1) {
		return(R.neq)
	}
	rob__set_eqsize(R,neq,1)
}

void robust_reset_eq_n(`RobustStruct' R, real scalar neq)
{
	rob__set_eqsize(R,neq,0)
}

function robust_init_eq_indepvars(
	`RobustStruct'	R,
	real	scalar	eq,
	|		xvars,
		scalar	cons
)
{
	rob__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq <= R.neq) {
			if (R.pm_xvars[eq] != NULL) {
				return(*R.pm_xvars[eq])
			}
		}
		if (strlen(R.st_xvars[eq])) {
			return(rob__st_view(R, R.st_xvars[eq], `ROB_tsok'))
		}
		return(J(0,0,.))
	}
	if (eq > R.neq) {
		rob__set_eqsize(R, eq, 1)
	}
	R.pm_xvars[eq]	= NULL
	R.st_xvars[eq]	= ""
	if (isreal(xvars)) {
		if (length(xvars)) {
			R.pm_xvars[eq] = &xvars
		}
	}
	else {
		R.st_xvars[eq] = rob__check_varnames(
			xvars, 0, ., "indepvars", `ROB_tsok')
	}
	if (args() == 4) {
		robust_init_eq_cons(R, eq, cons)
	}
}

function robust_init_eq_cons(
	`RobustStruct'	R,
	real	scalar	eq,
	|	scalar	cons	// indicator for presence of constant
)
{
	if (args() == 2) {
		rob__check_eqnum(eq, R.neq)
		return(opt__onoff_numtostr(R.eqcons[eq]))
	}
	rob__check_eqnum(eq, .)
	if (eq > R.neq) {
		rob__set_eqsize(R, eq, 1)
	}
	R.eqcons[eq] = opt__onoff(cons, "cons")
}

function robust_init_touse(`RobustStruct' R, |touse)
{
	if (args() == 1) {
		if (length(*R.pm_touse)) {
			return(*R.pm_touse)
		}
		if (strlen(R.st_touse)) {
			return(rob__st_view(R, R.st_touse, `ROB_real'))
		}
		return(J(0,1,.))
	}
	R.pm_touse	= `ROB_touse_default'
	R.st_touse	= ""
	if (isreal(touse)) {
		R.pm_touse = &touse
	}
	else {
		R.st_touse = rob__check_varnames(
			touse, 0, 1, "touse", `ROB_real')
	}
}

function robust_init_subuse(`RobustStruct' R, |string scalar subuse)
{
	if (args() == 1) {
		return(R.st_subuse)
	}
	R.st_subuse = subuse
}

function robust_init_subpop(`RobustStruct' R, |subpop)
{
	if (args() == 1) {
		if (length(*R.pm_subuse)) {
			return(*R.pm_subuse)
		}
		if (strlen(R.st_subuse)) {
			return(rob__st_view(R, R.st_subuse, `ROB_real'))
		}
		return(J(0,1,.))
	}
	R.skip_setup	= `ROB_skip_setup_default'
	R.pm_subuse	= `ROB_subuse_default'
	R.st_subuse	= ""
	R.st_subpop	= ""
	if (isreal(subpop)) {
		R.pm_subuse = &subpop
	}
	else {
		if (! isstring(subpop)) {
			// error
			R.st_subpop = rob__check_varnames(
				subpop, 0, 1, "subpop", `ROB_real')
		}
		else if (length(subpop) != 1) {
			R.st_subpop = rob__check_varnames(
				subpop, 0, 1, "subpop", `ROB_real')
		}
		else if (length(tokens(subpop)) <= 1) {
			R.st_subpop = rob__check_varnames(
				subpop, 0, 1, "subpop", `ROB_real')
		}
		else {
			R.st_subpop = subpop
		}
	}
}

function robust_init_svyset(`RobustStruct' R, |scalar svyset)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(R.svyset))
	}
	R.skip_setup	= `ROB_skip_setup_default'
	R.svyset = opt__onoff(svyset, "svyset")
}

function robust_init_svyg(`RobustStruct' R, |scalar svyg)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(R.svyg))
	}
	R.skip_setup	= `ROB_skip_setup_default'
	R.svyg = opt__onoff(svyg, "svyg")
}

function robust_init_skip_setup(`RobustStruct' R, |scalar skip_setup)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(R.skip_setup))
	}
	R.skip_setup = opt__onoff(skip_setup, "skip setup")
}

function robust_init_weight(`RobustStruct' R, |w, string scalar wtype)
{
	if (args() == 1) {
		if (length(*R.pm_w)) {
			return(*R.pm_w)
		}
		if (strlen(R.st_w)) {
			return(rob__st_view(R, R.st_w, `ROB_real'))
		}
		return(J(0,1,.))
	}
	R.pm_w	= `ROB_w_default'
	R.st_w	= ""
	if (isreal(w)) {
		R.pm_w = &w
	}
	else {
		R.st_w = rob__check_varnames(w, 0, 1, "weight", `ROB_real')
	}
	if (args() == 3) {
		robust_init_weighttype(R, wtype)
	}
}

function robust_init_weighttype(`RobustStruct' R, |string scalar wtype)
{
	if (args() == 1) {
		if (R.wtype == 1) {
			return("fweight")
		}
		if (R.wtype == 2) {
			return("aweight")
		}
		return("pweight")
	}

	real scalar len
	len = strlen(wtype)
	if (len == 0) {
		R.wtype = 0
	}
	else if (wtype == bsubstr("pweight",1,max((2,len)))) {
		R.wtype = 0
	}
	else if (wtype == bsubstr("iweight",1,max((2,len)))) {
		R.wtype = 0
	}
	else if (wtype == bsubstr("fweight",1,max((2,len)))) {
		R.wtype = 1
	}
	else if (wtype == bsubstr("aweight",1,max((2,len)))) {
		R.wtype = 2
	}
	else {
		errprintf("invalid weight type\n")
		exit(3498)
	}
}

function robust_init_nstages(`RobustStruct' R, |real scalar stages)
{
	if (args() == 1) {
		return(R.stages)
	}
	rob__set_stagesize(R, stages, 1)
}

function robust_init_stage_units(
	`RobustStruct'	R,
	real	scalar	i,
	|		units
)
{
	rob__check_stage(i, .)
	if (args() == 2) {
		if (i <= R.stages) {
			if (R.units[i] != NULL) {
				return(*R.units[i])
			}
			if (strlen(R.st_units[i])) {
				return(rob__st_view(	R,
							R.st_units[i],
							`ROB_strok'))
			}
		}
		return(J(0,1,.))
	}
	if (i > R.stages) {
		rob__set_stagesize(R, i, 1)
	}
	R.units[i]	= NULL
	R.st_units[i]	= ""
	if (isreal(units)) {
		if (length(units)) {
			R.units[i] = &units
		}
	}
	else {
		R.st_units[i] = rob__check_varnames(
			units, 0, 1, "units", `ROB_strok')
	}
}

function robust_init_stage_strata(
	`RobustStruct'	R,
	real	scalar	i,
	|		strata
)
{
	rob__check_stage(i, .)
	if (args() == 2) {
		if (i <= R.stages) {
			if (R.strata[i] != NULL) {
				return(*R.strata[i])
			}
			if (strlen(R.st_strata[i])) {
				return(rob__st_view(	R,
							R.st_strata[i],
							`ROB_strok'))
			}
		}
		return(J(0,1,.))
	}
	if (i > R.stages) {
		rob__set_stagesize(R, i, 1)
	}
	R.strata[i]	= NULL
	R.st_strata[i]	= ""
	if (isreal(strata)) {
		if (length(strata)) {
			R.strata[i] = &strata
		}
	}
	else {
		R.st_strata[i] = rob__check_varnames(
			strata, 0, 1, "strata", `ROB_strok')
	}
}

function robust_init_stage_fpc(
	`RobustStruct'	R,
	real	scalar	i,
	|		fpc
)
{
	rob__check_stage(i, .)
	if (args() == 2) {
		if (i <= R.stages) {
			if (R.fpc[i] != NULL) {
				return(*R.fpc[i])
			}
			if (strlen(R.st_fpc[i])) {
				return(rob__st_view(	R,
							R.st_fpc[i],
							`ROB_real'))
			}
		}
		return(J(0,1,.))
	}
	if (i > R.stages) {
		rob__set_stagesize(R, i, 1)
	}
	R.fpc[i]	= NULL
	R.st_fpc[i]	= ""
	if (isreal(fpc)) {
		if (length(fpc)) {
			R.fpc[i] = &fpc
		}
	}
	else {
		R.st_fpc[i] = rob__check_varnames(
			fpc, 0, 1, "fpc", `ROB_real')
	}
}

function robust_init_singleunit(`RobustStruct' R, |string scalar singleu)
{
	if (args() == 1) {
		if (R.singleu == 1) {
			return("certainty")
		}
		if (R.singleu == 2) {
			return("scaled")
		}
		if (R.singleu == 3) {
			return("centered")
		}
		return("missing")
	}
	if (singleu == "") {
		R.singleu = 0
	}
	else if (singleu == "missing") {
		R.singleu = 0
	}
	else if (singleu == "certainty") {
		R.singleu = 1
	}
	else if (singleu == "scaled") {
		R.singleu = 2
	}
	else if (singleu == "centered") {
		R.singleu = 3
	}
	else {
		errprintf("invalid singleunit argument\n")
		exit(3498)
	}
}

function robust_init_minus(`RobustStruct' R, |real scalar minus)
{
	if (args() == 1) {
		return(R.minus)
	}
	if (R.minus < 0) {
		errprintf("negative minus value not allowed\n")
		exit(3498)
	}
	if (R.minus != trunc(R.minus)) {
		errprintf("noninteger minus value not allowed\n")
		exit(3498)
	}
	R.minus = minus
}

function robust_init_poststrata(`RobustStruct' R, |post)
{
	if (args() == 1) {
		if (length(*R.pm_post)) {
			return(*R.pm_post)
		}
		if (strlen(R.st_post)) {
			return(rob__st_viewpost(R))
		}
		return(J(0,2,.))
	}
	R.pm_post	= `ROB_post_default'
	R.st_post	= ""
	if (isreal(post)) {
		if (length(post)) {
			R.pm_post = &post
		}
	}
	else {
		R.st_post = rob__check_varnames(
			post, 0, 2, "poststrata", `ROB_strok1')
	}
	if (strlen(R.st_post)) {
		R.st_post = rob__check_varnames(
			post, 2, 2, "poststrata", `ROB_strok1')
	}
	if (length(*R.pm_post)) {
		if (cols(*R.pm_post) < 2) {
			errprintf("too few columns in poststrata matrix\n")
			exit(102)
		}
		if (cols(*R.pm_post) > 2) {
			errprintf("too many columns in poststrata matrix\n")
			exit(103)
		}
	}
}

function robust_init_covmat(`RobustStruct' R, |real matrix covmat)
{
	if (args() == 1) {
		if (R.covmat != NULL) {
			return(*R.covmat)
		}
		return(J(0,0,.))
	}
	if (length(covmat)) {
		R.covmat = &covmat
	}
	else {
		R.covmat = NULL
	}
}

function robust_init_V_srs(`RobustStruct' R,| real scalar dosrs)
{
	if (args() == 1) {
		return(R.dosrs)
	}
	R.dosrs = (dosrs != 0)
}

// robust_name*() routines --------------------------------------------------

string scalar robust_name_scores(`RobustStruct' R)
{
	if (strlen(R.st_scores)) {
		return(R.st_scores)
	}
	if (length(*R.pm_scores)) {
		return(nameexternal(R.pm_scores))
	}
	return("")
}

string scalar robust_name_eq_indepvars(`RobustStruct' R, real scalar eq)
{
	rob__check_eqnum(eq, .)
	if (eq <= R.neq) {
		if (strlen(R.st_xvars)) {
			return(R.st_xvars)
		}
		if (R.pm_xvars[eq] != NULL) {
			return(nameexternal(R.pm_xvars[eq]))
		}
	}
	return("")
}

string scalar robust_name_touse(`RobustStruct' R)
{
	if (strlen(R.st_touse)) {
		return(R.st_touse)
	}
	if (length(*R.pm_touse)) {
		return(nameexternal(R.pm_touse))
	}
	return("")
}

string scalar robust_name_subpop(`RobustStruct' R)
{
	if (strlen(R.st_subpop)) {
		return(R.st_subpop)
	}
	if (R.st_subuse == "") {
		if (length(*R.pm_subuse)) {
			return(nameexternal(R.pm_subuse))
		}
	}
	return("")
}

string scalar robust_name_weight(`RobustStruct' R)
{
	if (strlen(R.st_w)) {
		return(R.st_w)
	}
	if (length(*R.pm_w)) {
		return(nameexternal(R.pm_w))
	}
	return("")
}

string scalar robust_name_stage_units(`RobustStruct' R, real scalar i)
{
	rob__check_stage(i, .)
	if (i <= R.stages) {
		if (strlen(R.st_units[i])) {
			return(R.st_units[i])
		}
		if (R.units[i] != NULL) {
			return(nameexternal(R.units[i]))
		}
	}
	return("")
}

string scalar robust_name_stage_strata(`RobustStruct' R, real scalar i)
{
	rob__check_stage(i, .)
	if (i <= R.stages) {
		if (strlen(R.st_strata[i])) {
			return(R.st_strata[i])
		}
		if (R.strata[i] != NULL) {
			return(nameexternal(R.strata[i]))
		}
	}
	return("")
}

string scalar robust_name_stage_fpc(`RobustStruct' R, real scalar i)
{
	rob__check_stage(i, .)
	if (i <= R.stages) {
		if (strlen(R.st_fpc[i])) {
			return(R.st_fpc[i])
		}
		if (R.fpc[i] != NULL) {
			return(nameexternal(R.fpc[i]))
		}
	}
	return("")
}

string scalar robust_name_poststrata(`RobustStruct' R)
{
	if (strlen(R.st_post)) {
		return(R.st_post)
	}
	if (length(R.pm_post)) {
		return(nameexternal(R.pm_post))
	}
	return("")
}

string scalar robust_name_calmethod(`RobustStruct' R)
{
	return(R.calmethod)
}

// robust_*setup() routines -------------------------------------------------

void robust_svy_setup(`RobustStruct' R)
{
	`Errcode'		ec
	string	scalar		name
	string	scalar		svyopts
	real	scalar		n, i

	if (R.skip_setup) {
		return
	}
	if (!R.svyset &	!R.svyg			&
			!strlen(R.st_subpop)	&
			!strlen(R.st_units[1])	&
			!strlen(R.st_strata[1])	&
			!strlen(R.st_fpc[1])) {
		R.st_subuse = ""
		return
	}

	if (!strlen(R.st_touse)) {
		R.st_touse	= st_varname(mopt__st_tempvar(1, "byte", 1))
	}

	if (!strlen(R.st_subuse)) {
		R.st_subuse = st_tempname()
	}

	if (R.svyset) {
		svyopts	= "svy calibrate"
	}
	else {
	    if (strlen(R.st_units[1])) {
		svyopts = sprintf("%s cluster(%s)", svyopts, R.st_units[1])
	    }
	    if (strlen(R.st_strata[1])) {
		svyopts = sprintf("%s strata(%s)", svyopts, R.st_strata[1])
	    }
	    if (strlen(R.st_fpc[1])) {
		svyopts = sprintf("%s fpc(%s)", svyopts, R.st_fpc[1])
	    }
	}

	R.st_w_temp = st_tempname()
	ec = _stata(sprintf(
		"_svy_setup %s %s %s, %s subpop(%s)",
			R.st_touse,
			R.st_subuse,
			R.st_w_temp,
			svyopts,
			R.st_subpop
		))
	if (ec) exit(ec)

	if (! R.svyset) {
		if (R.svyg) {
			ec = _stata("svyset", 1)
			if (ec) exit(ec)
			robust_init_singleunit(R, st_global("r(singleunit)"))
			robust_init_stage_fpc(R, 1, st_global("r(fpc1)"))
		}
		return
	}

	// call 'robust_init*()' for the svy characteristics from 'svyset'

	robust_init_weight(R,	R.st_w_temp,
				st_global("r(wtype)"))
	n = st_numscalar("r(stages)")
	if (! length(n)) {
		// NOTE: 'st_numscalar()' returns a 0x0 when the object
		// doesn't exist.
		n = 1
	}
	rob__set_stagesize(R, n, 0)
	for (i=1; i<=n; i++) {
		robust_init_stage_units(R, i,
			st_global(sprintf("r(su%f)", i)))
		robust_init_stage_strata(R, i,
			st_global(sprintf("r(strata%f)", i)))
		robust_init_stage_fpc(R, i,
			st_global(sprintf("r(fpc%f)", i)))
	}
	name	= st_global("r(poststrata)")
	if (strlen(name)) {
		name = sprintf("%s %s", name,
			st_global("r(postweight)"))
		robust_init_poststrata(R, name)
	}

	robust_init_singleunit(R, st_global("r(singleunit)"))

	R.calmethod	= st_global("r(calmethod)")
	R.calmodel	= st_global("r(calmodel)")
	R.calopts	= st_global("r(calopts)")
}

// robust() routine ---------------------------------------------------------

real matrix robust(`RobustStruct' R)
{
	R.ucall = 0
	(void) rob__compute(R)
	return(robust_result_V(R))
}

`Errcode' _robust(`RobustStruct' R)
{
	`Errcode'	ec

	R.ucall = 1
	ec = rob__compute(R)
	return(ec)
}

`Errcode' rob__compute(`RobustStruct' R)
{
	`Errcode'		ec
	real	scalar		i, j, k
	real	matrix		order
	real	rowvector	r_scalars
	pragma unset r_scalars

	ec = rob__validate(R)
	if (ec) return(ec)

	if (R.pm_stsu != NULL) {
		order = J(1,R.k_strata+R.k_units, .)
		k = (R.k_units > R.k_strata ? R.k_units : R.k_strata)
		j = 1
		for (i=1; i<=k; i++) {
			if (i <= R.k_strata) {
				order[j] = i
				j++
			}
			if (i <= R.k_units) {
				order[j] = R.k_strata+i
				j++
			}
		}
		order = order(*R.pm_stsu,order)
	}
	else {
		order = J(0,1,.)
	}

	if (rows(*R.pm_w) < 2) {
		R.pm_w = &J(rows(*R.pm_scores),1,1)
	}
	if (R.calmethod != "") {
		R.pm_subuse = R.pm_touse
	}
	else if (rows(*R.pm_subuse) == 0) {
		R.pm_subuse = &J(rows(*R.pm_scores),1,1)
	}

	if (R.dosrs) {
		R.V_srswr = 0
	}

	if (R.calmethod != "") {
		rob__cal_scores(R)
	}

	ec = _robust_work(
		R.V=0,				// output
		R.V_srswr,
		R.V_srswrsub,
		r_scalars,
		R._N_postsize,
		R._N_postsum,
		R._N_strata,
		R._N_strata_single,
		R._N_strata_certain,
		order,				// input
		(*R.pm_scores),
		(*R.pm_calscores),
		R.pm_xvars,
		R.eqcons,
		(*R.pm_touse),
		(*R.pm_subuse),
		(*R.pm_w),
		R.wtype,
		R.stages,
		(*R.pm_fpc),
		(*R.pm_strid),
		(*R.pm_uid),
		(*R.pm_post),
		R.singleu,
		R.minus
	)
	if (ec) {
		R.errorcode = ec
		rob__errorhandler(R)
		return(R.errorcode)
	}

	R.N		= r_scalars[1]
	R.N_strata	= r_scalars[2]
	R.N_clust	= r_scalars[3]
	R.sum_w		= r_scalars[4]
	R.N_sub		= r_scalars[5]
	R.sum_wsub	= r_scalars[6]
	R.census	= r_scalars[7]
	R.singleton	= r_scalars[8]
	R.N_strata_omit	= r_scalars[9]

	// free temporarily allocated memory
	R.pm_uid	= &J(0,0,.)
	R.pm_strid	= &J(0,0,.)
	R.pm_fpc	= &J(0,0,.)
	R.pm_stsu	= &J(0,0,.)

	return(0)
}

// robust_result_*() routines -----------------------------------------------

void robust_result_post2r(`RobustStruct' R)
{
	string	rowvector	name
	string	scalar		hcat
	real	scalar		n, i

	if (robust_init_svyset(R) == "on") {
		hcat = "visible"
	}
	else {
		hcat = "hidden"
	}
	name	= robust_name_weight(R)
	if (strlen(name) & name != R.st_w_temp) {
		st_global("r(wtype)", robust_init_weighttype(R))
		st_global("r(wexp)", sprintf("= %s", name))
		st_global("r(wvar)", name)
	}

	n	= R.stages
	st_numscalar("r(stages)", n, hcat)
	for (i=1; i<=n; i++) {
		st_global(sprintf("r(su%f)", i),
			robust_name_stage_units(R, i))
		st_global(sprintf("r(strata%f)", i),
			robust_name_stage_strata(R, i))
		st_global(sprintf("r(fpc%f)", i),
			robust_name_stage_fpc(R, i))
	}
	if (strlen(R.st_post)) {
		name	= tokens(R.st_post)
		st_global("r(poststrata)", name[1])
		st_global("r(postweight)", name[2])
	}
	st_global("r(singleunit)", robust_init_singleunit(R), hcat)

	st_numscalar("r(N_clust)",		robust_result_N_clust(R))
	st_numscalar("r(N_strata)",		robust_result_N_strata(R))
	st_numscalar("r(N)",			robust_result_N(R))
	st_numscalar("r(sum_w)",		robust_result_sum_w(R))
	name	= robust_name_subpop(R)
	if (strlen(name)) {
		st_global("r(subpop)",		name)
		st_numscalar("r(N_sub)",	robust_result_N_sub(R))
		st_numscalar("r(sum_wsub)",	robust_result_sum_wsub(R))
	}
	st_numscalar("r(census)",		robust_result_census(R))
	st_numscalar("r(singleton)",		robust_result_singleton(R))
	st_numscalar("r(N_strata_omit)",	robust_result_N_strata_omit(R),
						hcat)
	st_matrix("r(_N_strata)",	  	robust_result_stage_strata(R),
						hcat)
	st_matrix("r(_N_strata_single)",  	robust_result_stage_single(R),
						hcat)
	st_matrix("r(_N_strata_certain)",	robust_result_stage_certain(R),
						hcat)
	n = cols(robust_result_postsize(R))
	if (n != 0) {
		st_numscalar("r(N_poststrata)",	n)
		st_matrix("r(_N_postsize)",	robust_result_postsize(R))
		st_matrix("r(_N_postsum)",	robust_result_postsum(R))
	}
}

void robust_result_post2e(`RobustStruct' R)
{
	string	rowvector	name
	real	scalar		n, i

	st_numscalar("e(N_psu)",		robust_result_N_clust(R))
	st_numscalar("e(N_strata)",		robust_result_N_strata(R))
	st_numscalar("e(df_r)",			robust_result_N_clust(R) -
						robust_result_N_strata(R))
	st_numscalar("e(N)",			robust_result_N(R))
	st_numscalar("e(N_pop)",		robust_result_sum_w(R))
	name	= robust_name_subpop(R)
	if (strlen(name)) {
		st_global("e(subpop)",		name)
		st_numscalar("e(N_sub)",	robust_result_N_sub(R))
		st_numscalar("e(N_subpop)",	robust_result_sum_wsub(R))
	}
	st_numscalar("e(census)",		robust_result_census(R))
	st_numscalar("e(singleton)",		robust_result_singleton(R))
	st_numscalar("e(N_strata_omit)",	robust_result_N_strata_omit(R))
	st_matrix("e(_N_strata)",	  	robust_result_stage_strata(R))
	st_matrix("e(_N_strata_single)",  	robust_result_stage_single(R))
	st_matrix("e(_N_strata_certain)", 	robust_result_stage_certain(R))
	n = cols(robust_result_postsize(R))
	if (n != 0) {
		name	= tokens(R.st_post)
		st_global("e(poststrata)", 	name[1])
		st_global("e(postweight)", 	name[2])
		st_numscalar("e(N_poststrata)",	n)
		st_matrix("e(_N_postsize)",	robust_result_postsize(R))
		st_matrix("e(_N_postsum)",	robust_result_postsum(R))
	}

	// survey design characteristics
	name	= robust_name_weight(R)
	if (strlen(name) & name != R.st_w_temp) {
		st_global("e(wtype)",		robust_init_weighttype(R))
		st_global("e(wexp)",		sprintf("= %s", name))
		st_global("e(wvar)",		name)
	}
	n	= R.stages
	st_numscalar("e(stages)", n)
	for (i=1; i<=n; i++) {
		st_global(sprintf("e(su%f)",i), robust_name_stage_units(R,i))
		st_global(
		sprintf("e(strata%f)",i),	robust_name_stage_strata(R,i))
		st_global(sprintf("e(fpc%f)",i),robust_name_stage_fpc(R,i))
	}
	st_global("e(singleunit)",		robust_init_singleunit(R))
}

real matrix robust_result_V(`RobustStruct' R)
{
	real matrix V
	V = R.V
	if (R.covmat != NULL) {
		V = makesymmetric((*R.covmat)*V*(*R.covmat))
	}
	return(V)
}

real matrix robust_result_V_srs(`RobustStruct' R)
{
	if (! R.dosrs) {
		return(J(rows(R.V),cols(R.V),.))
	}
	real matrix V
	V = (1-robust_result_N(R)/robust_result_sum_w(R))*R.V_srswr
	if (R.covmat != NULL) {
		V = makesymmetric((*R.covmat)*V*(*R.covmat))
	}
	return(V)
}

real matrix robust_result_V_srswr(`RobustStruct' R)
{
	if (! R.dosrs) {
		return(J(rows(R.V),cols(R.V),.))
	}
	real matrix V
	V = R.V_srswr
	if (R.covmat != NULL) {
		V = makesymmetric((*R.covmat)*V*(*R.covmat))
	}
	return(V)
}

real matrix robust_result_V_srssub(`RobustStruct' R)
{
	if (! R.dosrs) {
		return(J(rows(R.V),cols(R.V),.))
	}
	real matrix V
	V = (1-robust_result_N_sub(R)/robust_result_sum_wsub(R)):*R.V_srswrsub
	if (R.covmat != NULL) {
		V = makesymmetric((*R.covmat)*V*(*R.covmat))
	}
	return(V)
}

real matrix robust_result_V_srswrsub(`RobustStruct' R)
{
	if (! R.dosrs) {
		return(J(rows(R.V),cols(R.V),.))
	}
	real matrix V
	V = R.V_srswrsub
	if (R.covmat != NULL) {
		V = makesymmetric((*R.covmat)*V*(*R.covmat))
	}
	return(V)
}

real scalar robust_result_N(`RobustStruct' R)
{
	return(R.N)
}

real scalar robust_result_N_strata(`RobustStruct' R)
{
	return(R.N_strata)
}

real scalar robust_result_N_clust(`RobustStruct' R)
{
	return(R.N_clust)
}

real scalar robust_result_sum_w(`RobustStruct' R)
{
	return(R.sum_w)
}

real scalar robust_result_N_sub(`RobustStruct' R)
{
	return(R.N_sub)
}

real scalar robust_result_sum_wsub(`RobustStruct' R)
{
	return(R.sum_wsub)
}

real scalar robust_result_census(`RobustStruct' R)
{
	return(R.census)
}

real scalar robust_result_singleton(`RobustStruct' R)
{
	return(R.singleton)
}

real scalar robust_result_N_strata_omit(`RobustStruct' R)
{
	return(R.N_strata_omit)
}

real rowvector robust_result_postsize(`RobustStruct' R)
{
	return(R._N_postsize)
}

real rowvector robust_result_postsum(`RobustStruct' R)
{
	return(R._N_postsum)
}

real rowvector robust_result_stage_strata(`RobustStruct' R)
{
	return(R._N_strata)
}

real rowvector robust_result_stage_single(`RobustStruct' R)
{
	return(R._N_strata_single)
}

real rowvector robust_result_stage_certain(`RobustStruct' R)
{
	return(R._N_strata_certain)
}

`Errcode' robust_result_errorcode(`RobustStruct' R)
{
	return(R.errorcode)
}

string scalar robust_result_errortext(`RobustStruct' R)
{
	return(R.errortext)
}

`Errcode' robust_result_returncode(`RobustStruct' R)
{
	if (R.errorcode) {
		if (R.errorcode == `Errcode_noobs') {
			return(2000)
		}
		if (R.errorcode == `Errcode_nodim') {
			return(100)
		}
		if (R.errorcode == `Errcode_wtype') {
			return(198)
		}
		if (R.errorcode == `Errcode_post_negative') {
			return(465)
		}
		if (R.errorcode == `Errcode_post_notconstant') {
			return(464)
		}
		if (R.errorcode == `Errcode_fpc_negative') {
			return(460)
		}
		if (R.errorcode == `Errcode_fpc_notconstant') {
			return(461)
		}
		if (R.errorcode == `Errcode_fpc_invalid') {
			return(462)
		}
		return(3498)
	}
	return(0)
}

// robust_query() routine ---------------------------------------------------

void robust_query(`RobustStruct' R)
{
	real	scalar	needscores
	real	scalar	needunits
	real	scalar	needfpc
	real	scalar	i, j, m, n
	string	vector	names
	string	scalar	name

	needscores	= 0
	needunits	= 0
	needfpc		= 0

	printf("{text}Settings for robust() {hline}\n")

	name = R.st_scores
	if (!strlen(name)) {
		name = nameexternal(R.pm_scores)
	}
	if (!strlen(name)) {
		name = "{error:<not set>}"
		needscores = 1
	}
	else {
		name = sprintf("{res:%s}", name)
	}
	printf("\nEquation-level scores:`c2'%s\n", name)

	if (R.covmat != NULL) {
		name = nameexternal(R.covmat)
		if (strlen(name)) {
			name = sprintf("{res:%s}", name)
		}
		else {
			name = "<tmp>"
		}
	}
	else {
		name = "<identity matrix>"
	}
	printf("\nCovariance matrix:`c2'%s\n", name)

	n = R.neq
	if (n==0) {
		printf("\nEquations:`c2'none\n")
	}
	for (i=1; i<=n; i++) {
		printf("\nEquation %f:\n", i)
		if (R.st_xvars[i] != "") {
			names = _st_ivarlist(R.st_xvars[i])
			m = length(names)
			for (j=1; j<=m; j++) {
				printf("`i1'predictor %5.0f:`c2'{result:%s}\n",
					j, names[j])
			}
		}
		else if (R.pm_xvars[i] != NULL) {
			name = nameexternal(R.pm_xvars[i])
			printf("`i1'predictors:`c2'{result:%s}\n", name)
		}
		else {
			printf("`i1'predictors:`c2'<none>\n")
		}
		if (R.eqcons[i]) {
			printf("`c2'{res:_cons}\n")
		}
	}

	n = R.stages
	for (i=1; i<=n; i++) {
		printf("\nStage %f:\n", i)
		if (strlen(R.st_units[i])) {
			name = sprintf("{result:%s}", R.st_units[i])
		}
		else if (R.units[i] != NULL) {
			name = nameexternal(R.units[i])
			if (strlen(name)) {
				name = sprintf("{result:%s}", name)
			}
			else {
				name = "<tmp>"
			}
		}
		else {
			if (i==n) {
				name = "<obs>"
			}
			else {
				name = "{error:<not set>}"
				needunits = 1
			}
		}
		printf("`i1'Units:`c2'%s\n", name)
		if (strlen(R.st_strata[i])) {
			name = sprintf("{result:%s}", R.st_strata[i])
		}
		else if (R.strata[i] != NULL) {
			name = nameexternal(R.strata[i])
			if (strlen(name)) {
				name = sprintf("{result:%s}", name)
			}
			else {
				name = "<tmp>"
			}
		}
		else {
			name = "<one>"
		}
		printf("`i1'Strata:`c2'%s\n", name)
		if (strlen(R.st_fpc[i])) {
			name = sprintf("{result:%s}", R.st_fpc[i])
		}
		else if (R.fpc[i] != NULL) {
			name = nameexternal(R.fpc[i])
			if (strlen(name)) {
				name = sprintf("{result:%s}", name)
			}
			else {
				name = "<tmp>"
			}
		}
		else {
			if (i==n) {
				name = "<with replacement>"
			}
			else {
				name = "{error:<not set>}"
				needfpc = 1
			}
		}
		printf("`i1'FPC:`c2'%s\n", name)
	}

	if (strlen(R.st_w)) {
		name = sprintf("{res:%s}", R.st_w)
	}
	else if (length(*R.pm_w)) {
		name = nameexternal(R.pm_w)
		if (strlen(name)) {
			name = sprintf("{res:%s}", name)
		}
		else {
			name = "<tmp>"
		}
	}
	else {
		name = "<none>"
	}
	printf("\nWeights:`c2'%s\n", name)
	if (name != "<none>") {
		printf("Weight type:`c2'{res:%s}\n", robust_init_weighttype(R))
	}

	names = J(1,0,"")
	if (strlen(R.st_post)) {
		names = tokens(R.st_post)
		printf("\nPoststrata variable:`c2'{result:%s}\n", names[1])
		printf("Postweight variable:`c2'{result:%s}\n", names[2])
	}
	else if (length(*R.pm_post)) {
		name = nameexternal(R.pm_post)
		if (strlen(name)) {
			name = sprintf("{res:%s}", name)
		}
		else {
			name = "<tmp>"
		}
		printf("\nPoststratification matrix:`c2'%s\n", name)
	}

	name = R.st_touse
	if (strlen(name)) {
		name = sprintf("{res:%s}", name)
	}
	else if (length(*R.pm_touse)) {
		name = nameexternal(R.pm_touse)
		if (strlen(name)) {
			name = sprintf("{res:%s}", name)
		}
		else {
			name = "<tmp>"
		}
	}
	else {
		name = "<none>"
	}
	printf("\nSample indicator:`c2'%s\n", name)

	if (strlen(R.st_subpop)) {
		name = sprintf("{res:%s}", R.st_subpop)
	}
	else if (length(*R.pm_subuse)) {
		name = nameexternal(R.pm_subuse)
		if (strlen(name)) {
			name = sprintf("{res:%s}", name)
		}
		else {
			name = "<tmp>"
		}
	}
	else {
		name = "<none>"
	}
	printf("\nSubpopulation indicator:`c2'%s\n", name)

	name = sprintf("{res:%s}", robust_init_singleunit(R))
	printf("\nSingle unit:`c2'%s\n", name)

	printf("\nPerform extra SRS calculations:`c2'{res:%s}\n",
		(R.dosrs ? "on" : "off"))

	printf("\nMinus adjustment:`c2'{res:%g}\n", R.minus)

	if (needscores) {
		printf(
"\nNote:  The equation-level scores have not been specified.")
	}
	if (needunits) {
		printf(
"\nNote:  Some sampling stages require that sampling units be specified.")
	}
	if (needfpc) {
		printf(
"\nNote:  Some sampling stages require that the FPC be specified.")
	}
	printf("\n")
}

// utilities ----------------------------------------------------------------

string scalar rob__st_genid(
	`RobustStruct'	R,
	string	scalar	idvar
)
{
	`Errcode'	ec
	string	scalar	tempvar

	tempvar = st_tempname()
	ec = _stata(sprintf(`"_rob_genid %s "%s" %s"',
		tempvar, R.st_touse, idvar))
	if (ec) exit(ec)
	return(tempvar)
}

`Errcode' rob__validate(`RobustStruct' R)
{
	real	scalar		i, j
	real	scalar		getdata
	real	scalar		stages
	real	scalar		k_strata
	real	scalar		k_stsu
	real	scalar		has_stage
	pointer	colvector	allnull

	R.errorcode = 0
	R.errortext = ""

	// perform setup, then get the views from the Stata input elements

	robust_svy_setup(R)

	if (R.st_touse != "") {
		R.pm_touse = &rob__st_view(R, R.st_touse, `ROB_real')
	}
	if (R.st_subuse != "") {
		R.pm_subuse = &rob__st_view(R, R.st_subuse, `ROB_real')
	}
	if (R.st_scores != "") {
		R.pm_scores = &rob__st_view(R, R.st_scores, `ROB_real')
	}
	if (any(R.st_xvars :!= "")) {
		for (i=1; i<=R.neq; i++) {
			getdata	= strlen(R.st_xvars[i])
			if (getdata) {
				for (j=1; j<i; j++) {
					if (R.st_xvars[i] == R.st_xvars[j]) {
						R.pm_xvars[i] = R.pm_xvars[j]
						getdata = 0
						break
					}
				}
			}
			if (getdata) {
				R.pm_xvars[i] = &rob__st_view(	R,
								R.st_xvars[i],
								`ROB_tsok')
			}
		}
	}
	if (R.st_w != "") {
		R.pm_w = &rob__st_view(R, R.st_w, `ROB_real')
	}
	if (R.st_post != "") {
		R.pm_post = &rob__st_viewpost(R)
	}

	stages 	= R.stages
	allnull	= J(1,stages,NULL)
	has_stage =	R.units  != allnull		|
			R.strata != allnull		|
			!all(!strlen(R.st_units))	|
			!all(!strlen(R.st_strata))

	if (has_stage & R.units == allnull & R.strata == allnull) {
		// I can be more efficient here if I know that all the survey
		// stages are defined by Stata variables

		string	scalar	oldstrata
		string	vector	st_stsu

		k_strata	= stages
		for (i=stages; i>0 ; i--) {
			if (! strlen(R.st_strata[i])) {
				(void) --k_strata
			}
			else {
				break
			}
		}

		i = k_strata + stages - (strlen(R.st_units[stages]) == 0)
		st_stsu = J(1, i, "")
		oldstrata = R.st_touse
		for (i=1; i<=stages; i++) {
			if (strlen(R.st_strata[i])) {
				st_stsu[i] = R.st_strata[i]
			}
			else if (i < k_strata) {
				st_stsu[i] = oldstrata
			}
			if (strlen(R.st_units[i])) {
				st_stsu[i+k_strata] = R.st_units[i]
				oldstrata = R.st_units[i]
			}
			else if (i<stages) {
				errprintf(
"stage %f sampling units variable is missing\n", i)
				exit(3498)
			}
		}

		R.pm_stsu	= &rob__st_view(R,
						invtokens(st_stsu),
						`ROB_strok')
		k_stsu		= cols(st_stsu)
		R.k_strata	= k_strata
		R.k_units	= k_stsu - k_strata
		if (R.k_strata) {
			real	matrix	strid
			pragma unset strid

			st_subview(strid, (*R.pm_stsu), ., (1\R.k_strata))
			R.pm_strid	= &strid
		}
		if (R.k_units) {
			real	matrix	uid
			pragma unset uid

			st_subview(uid, (*R.pm_stsu), .,
				((R.k_strata+1)\k_stsu))
			R.pm_uid	= &uid
		}
	}
	else if (has_stage) {
		real	matrix	stsu
		real	scalar	N

		for (i=1; i<=stages; i++) {
			if (strlen(R.st_units[i]) & R.units[i] == NULL) {
				R.units[i] = &rob__st_view(
					R, R.st_units[i], `ROB_strok')
			}
			if (strlen(R.st_strata[i]) & R.strata[i] == NULL) {
				R.strata[i] = &rob__st_view(
					R, R.st_strata[i], `ROB_strok')
			}
		}

		k_strata	= stages
		for (i=stages; i>0 ; i--) {
			if (R.strata[i] == NULL) {
				(void) --k_strata
			}
			else {
				break
			}
		}

		if (stages > 1) {
			if (R.units[1] == NULL) {
				errprintf(
				"stage 1 sampling units vector is missing\n")
				exit(3498)
			}
			N = rows(*R.units[1])
		}
		else {
			if (R.units[1] != NULL) {
				N = rows(*R.units[1])
			}
			else {
				N = rows(*R.strata[1])
			}
		}

		i = k_strata + stages - (R.units[stages] == NULL)
		stsu = J(N, i, .)
		for (i=1; i<=stages; i++) {
			if (R.units[i] != NULL) {
				if (N != rows(*R.units[i])) {
					errprintf(
"conformability error in stage %f sampling units vector\n", i)
					exit(3498)
				}
				stsu[|_2x2(1,i+k_strata,N,i+k_strata)|] =
					(*R.units[i])
			}
			else if (i<stages) {
				errprintf(
"stage %f sampling units vector is missing\n", i)
				exit(3498)
			}
			if (R.strata[i] != NULL) {
				if (N != rows(*R.strata[i])) {
					errprintf(
"conformability error in stage %f strata vector\n", i)
					exit(3498)
				}
				stsu[|_2x2(1,i,N,i)|] = (*R.strata[i])
			}
			else if (i < k_strata) {
				if (i == 1) {
					stsu[|_2x2(1,i,N,i)|] = J(N,1,1)
				} 
				else {
					stsu[|_2x2(1,i,N,i)|] = (*R.units[i-1])
				}
			}
		}

		R.pm_stsu	= &stsu
		k_stsu		= cols(stsu)
		R.k_strata	= k_strata
		R.k_units	= k_stsu - k_strata
		if (R.k_strata) {
			R.pm_strid	= &stsu[|1,1\N,R.k_strata|]
		}
		if (R.k_units) {
			R.pm_uid	= &stsu[|1,(R.k_strata+1)\N,k_stsu|]
		}
	}
	else if (stages > 1) {
		if (R.units[1] == NULL) {
			errprintf(
			"stage 1 sampling units vector is missing\n")
			exit(3498)
		}
	}
	has_stage = R.fpc != allnull | !all(!strlen(R.st_fpc))
	if (has_stage & R.fpc == allnull) {
		// check for missing FPC variables
		for (i=1; i<stages; i++) {
			if (!strlen(R.st_fpc[i])) {
				errprintf(
				"stage %f FPC variable is missing\n", i)
				exit(3498)
			}
		}
		R.pm_fpc = &rob__st_view(R, invtokens(R.st_fpc), `ROB_real')
	}
	else if (has_stage) {
		real scalar fpcmat
		real scalar k_fpc

		if (R.fpc[1] == NULL) {
			errprintf("stage 1 FPC vector is missing\n")
			exit(3498)
		}
		N = rows(*R.fpc[1])
		k_fpc = stages - (R.fpc[stages] == NULL)
		fpcmat = J(N, k_fpc, .)
		for (i=1; i<stages; i++) {
			// check for missing FPC variables
			if (R.fpc[i] == NULL) {
				errprintf(
				"stage %f FPC vector is missing\n", i)
				exit(3498)
			}
			fpcmat[|_2x2(1,i,N,i)|] = (*R.fpc[i])
		}
		if (R.fpc[stages] != NULL) {
			fpcmat[|_2x2(1,stages,N,stages)|] = (*R.fpc[stages])
		}
		R.pm_fpc = &fpcmat
	}

	return(0)
}

real matrix rob__st_viewpost(`RobustStruct' R)
{
	string	rowvector	postvars

	// Make the new poststrata id variable contain contiguous integer
	// values starting from 1.

	postvars	= tokens(R.st_post)
	postvars[1]	= rob__st_genid(R, postvars[1])

	return(rob__st_view(R, invtokens(postvars), `ROB_real'))
}

real matrix rob__st_view(
	`RobustStruct'	R,
	string	scalar	vlist,
	real	scalar	vartype
)
{
	real	matrix		data
	real	rowvector	idxlist
	string	rowvector	namelist
	real	rowvector	stroklist
	real	scalar		n, i
	pragma unset data

	// NOTE: 'st_varindex()' causes Stata to move the hidden
	// 'e(sample)' variable to the end of the variable indices;
	// better to do this now then to leave it to chance after
	// creating this view.

	if (vartype == `ROB_strok1' | vartype == `ROB_strok') {
		namelist	= tokens(vlist)
		n		= length(namelist)
		if (vartype == `ROB_strok') {
			stroklist	= J(1,n,1)
		}
		else {
			stroklist	= J(1,n,0)
			stroklist[1]	= 1
		}
		for (i=1; i<=n; i++) {
			if (st_isstrvar(namelist[i])) {
				if (!stroklist[i]) {
					errprintf(
"string variable %s found where numeric variable required\n",
					namelist[i])
					exit(3498)
				}
				namelist[i] = rob__st_genid(R,namelist[i])
			}
		}
		idxlist		= st_varindex(namelist)
		st_view(data, ., idxlist, R.st_touse)
	}
	else {
		st_view(data, ., vlist, R.st_touse)
	}
	return(data)
}

string scalar rob__check_varnames(
	transmorphic	varlist,
	real	scalar	nmin,
	real	scalar	nmax,
	string	scalar	name,
	real	scalar	vartype
)
{
	real	scalar		i, n
	real	scalar		opsok, ec
	string	rowvector	vlist
	real	rowvector	stroklist

	if (!isstring(varlist)) {
		errprintf("invalid %s argument\n", name)
		exit(198)
	}

	opsok	= vartype == `ROB_tsok'
	n	= length(varlist)
	if (! n) {
		errprintf("invalid %s argument\n", name)
		exit(198)
	}
	vlist	= strtrim(invtokens(rowshape(varlist,1)))

	if (strlen(vlist) == 0) {
		n	= 0
	}
	else {
		ec = _st_varlist(vlist, opsok, opsok)
		if (ec) exit(ec)
		vlist = _st_ivarlist(vlist)
		n	= length(vlist)
	}
	if (n < nmin | n > nmax) {
		errprintf("invalid %s argument\n", name)
		if (n < nmin) {
			exit(102)
		}
		exit(103)
	}
	if (n == 0) {
		return("")
	}

	if (vartype == `ROB_strok') {
		stroklist	= J(1,n,1)
	}
	else if (vartype == `ROB_strok1') {
		stroklist	= J(1,n,0)
		stroklist[1]	= 1
	}
	else {
		stroklist	= J(1,n,0)
	}

	for (i=1; i<=n; i++) {
		if (!stroklist[i]) {
			if (! strpos(vlist[i], ".")) {
				if (st_isstrvar(vlist[i])) {
					errprintf(
"string variable %s found where numeric variable required\n",
					vlist[i])
					exit(3498)
				}
			}
		}
	}
	return(invtokens(vlist))
}

void rob__check_eqnum(real scalar eq, real scalar neq)
{
	if (eq < 1 | eq > neq | missing(eq) | eq!=trunc(eq)) {
		errprintf("invalid equation index\n")
		exit(3498)
	}
}

function rob__set_eqsize(
	`RobustStruct'	R,
	real	scalar	neq,
	|real	scalar	update
)
{
	transmorphic	t
	real	scalar	neq0

	if (args() == 2) {
		update = 0
	}
	if (update) {
		neq0 = min((neq, R.neq))
	}
	R.neq	= neq

	if (update) {
		swap(t=., R.pm_xvars)
		R.pm_xvars	= J(1,neq,NULL)
		R.pm_xvars[|1\neq0|] = t[|1\neq0|]

		swap(t=., R.st_xvars)
		R.st_xvars	= J(1,neq,"")
		R.st_xvars[|1\neq0|] = t[|1\neq0|]

		swap(t=., R.eqcons)
		R.eqcons	= J(1,neq,1)
		R.eqcons[|1\neq0|] = t[|1\neq0|]
	}
	else {
		R.pm_xvars	= J(1,neq,NULL)
		R.st_xvars	= J(1,neq,"")
		R.eqcons	= J(1,neq,1)
	}
}

void rob__check_stage(real scalar i, real scalar stages)
{
	if (i < 1 | i > stages | missing(i) | i != trunc(i)) {
		errprintf("invalid stage index\n")
		exit(3498)
	}
}

void rob__set_stagesize(
	`RobustStruct'	R,
	real	scalar	i,
	|real	scalar	update
)
{
	transmorphic	t
	real	scalar	n0

	if (i < 1 | missing(i) | i != trunc(i)) {
		errprintf("invalid number of stages\n")
		exit(3498)
	}
	if (args() == 2) {
		update = 0
	}
	if (update) {
		if (i == R.stages) {
			// nothing to do
			return
		}
		n0 = min((i, R.stages))
	}

	R.stages = i

	if (update) {
		swap(t=., R.units)
		R.units = J(1, i, NULL)
		R.units[|1\n0|] = t[|1\n0|]
	}
	else	R.units = J(1, i, NULL)

	if (update) {
		swap(t="", R.st_units)
		R.st_units = J(1, i, "")
		R.st_units[|1\n0|] = t[|1\n0|]
	}
	else	R.st_units = J(1, i, "")

	if (update) {
		swap(t=., R.strata)
		R.strata = J(1, i, NULL)
		R.strata[|1\n0|] = t[|1\n0|]
	}
	else	R.strata = J(1, i, NULL)

	if (update) {
		swap(t="", R.st_strata)
		R.st_strata = J(1, i, "")
		R.st_strata[|1\n0|] = t[|1\n0|]
	}
	else	R.st_strata = J(1, i, "")

	if (update) {
		swap(t=., R.fpc)
		R.fpc = J(1, i, NULL)
		R.fpc[|1\n0|] = t[|1\n0|]
	}
	else	R.fpc = J(1, i, NULL)

	if (update) {
		swap(t="", R.st_fpc)
		R.st_fpc = J(1, i, "")
		R.st_fpc[|1\n0|] = t[|1\n0|]
	}
	else	R.st_fpc = J(1, i, "")
}

void rob__errorhandler(`RobustStruct' R)
{
	if (!R.errorcode) return
	if (R.errorcode == `Errcode_noobs') {
		R.errortext = `Errtext_noobs'
	}
	else if (R.errorcode == `Errcode_conformability') {
		R.errortext = `Errtext_conformability'
	}
	else if (R.errorcode == `Errcode_nodim') {
		R.errortext = `Errtext_nodim'
	}
	else if (R.errorcode == `Errcode_wtype') {
		R.errortext = `Errtext_wtype'
	}
	else if (R.errorcode == `Errcode_post_negative') {
		R.errortext = `Errtext_post_negative'
	}
	else if (R.errorcode == `Errcode_post_notconstant') {
		R.errortext = `Errtext_post_notconstant'
	}
	else if (R.errorcode == `Errcode_fpc_negative') {
		R.errortext = `Errtext_fpc_negative'
	}
	else if (R.errorcode == `Errcode_fpc_notconstant') {
		R.errortext = `Errtext_fpc_notconstant'
	}
	else if (R.errorcode == `Errcode_fpc_invalid') {
		R.errortext = `Errtext_fpc_invalid'
	}
	else {
		R.errortext = "unexpected internal error"
	}
	if (R.verbose) {
		errprintf("{p}\n")
		errprintf("%s\n", R.errortext)
		errprintf("{p_end}\n")
	}
	if (R.ucall) return
	exit(robust_result_returncode(R))
}

void rob__cal_scores(`RobustStruct' R)
{
	real	scalar	ec
	string	scalar	cmd
	string	scalar	slist
	string	scalar	scores
	string	vector	nlist
	real	vector	idx
	real	scalar	eq
	real	scalar	dim
	real	matrix	X
	real	matrix	S

	pragma unset X
	pragma unset S

	if (strlen(R.st_scores)) {
		slist	= tokens(R.st_scores)
	}
	else {
		slist	= J(1,cols((*R.pm_scores)),"")
	}

	scores = J(1,0,"")
	for (eq=1; eq<=R.neq; eq++) {
		if (strlen(R.st_xvars[eq])) {
			st_view(X, ., R.st_xvars[eq], R.st_touse)
			dim = cols(X)
			nlist = st_tempname(dim)
			idx = _st_addvar("double", nlist)
			if (idx[1] < 0) {
				exit(error(-idx))
			}
			st_view(S, ., nlist, R.st_touse)
			S[,] = X:*(*R.pm_scores)[,eq]
			scores = scores, nlist
		}
		if (R.eqcons[eq]) {
			if (slist[eq] != "") {
				scores = scores, slist[eq]
			}
			else {
				nlist = st_tempname()
				idx = _st_addvar("double", nlist)
				if (idx[1] < 0) {
					exit(error(-idx))
				}
				st_view(S, ., nlist, R.st_touse)
				S[,] = (*R.pm_scores)[,eq]
				scores = scores, nlist
			}
		}
	}

	cmd = sprintf(
		"_svycal_residuals %s if %s, stub(%s) subuse(%s) wcal(%s)",
		invtokens(scores),
		R.st_touse,
		st_tempname(),
		R.st_subuse,
		R.st_w)
	ec = _stata(cmd)
	if (ec) exit(ec)
	R.st_calscores = st_global("r(varlist)")
	R.pm_calscores = &rob__st_view(R, R.st_calscores, `ROB_real')
	R.st_scores = invtokens(scores)
	R.pm_scores = &rob__st_view(R, R.st_scores, `ROB_real')
	dim = cols(tokens(R.st_scores))
	R.eqcons = J(1,dim,1)
	R.st_xvars = J(1,dim,"")
	R.pm_xvars = J(1,dim,NULL)
}

// functions exclusively intended for the -_robust2- command ----------------

void _robust2()
{
	real	matrix	V_srs
	real	matrix	V_srssub
	real	matrix	V_srssub_wr
	real	matrix	V_srs_wr
	real	scalar	i, neq
	real	scalar	hasfpc
	string	scalar	name
	string	scalar	SM_v
	string	scalar	SM_vsrs
	transmorphic	R

	SM_v = st_local("v")
	SM_vsrs = st_local("vsrs")

	R = robust_init()
	if (strlen(st_local("svy"))) {
		robust_init_svyset(R, "on")
	}
	if (strlen(st_local("svyg"))) {
		robust_init_svyg(R, "on")
	}
	robust_init_subpop(R,	st_local("subpop"))
	robust_init_touse(R,	st_local("touse"))
	robust_init_scores(R,	st_local("varlist"))
	neq = strtoreal(st_local("k_scores"))
	robust_init_eq_n(R, neq)
	for (i=1; i<=neq; i++) {
		robust_init_eq_indepvars(R,i,
			st_local(sprintf("eq%f",i)),
			st_local(sprintf("cons%f",i))=="")
	}
	robust_init_weight(R,		st_local("wvar"))
	robust_init_weighttype(R,	st_local("wtype"))
	name	= st_local("cluster")
	if (strlen(name)) {
		robust_init_stage_units(R, 1, name)
	}
	name	= st_local("strata")
	if (strlen(name)) {
		robust_init_stage_strata(R, 1, name)
	}
	name	= st_local("fpc")
	if (strlen(name)) {
		robust_init_stage_fpc(R, 1, name)
	}
	robust_init_singleunit(R,	st_local("singleu"))
	robust_init_minus(R,		strtoreal(st_local("minus")))
	robust_init_covmat(R,		st_matrix(SM_v))
	robust_init_V_srs(R, SM_vsrs != "")

	if (_robust(R)) {
		exit(robust_result_returncode(R))
	}

	// saved results
	st_rclear()
	robust_result_post2r(R)

	st_matrix(SM_v, robust_result_V(R))
	name	= robust_name_stage_fpc(R, 1)
	hasfpc = strlen(name)
	if (SM_vsrs != "") {
		st_local("fpc1", name)
		if (hasfpc) {
			V_srs    = robust_result_V_srs(R)
			V_srssub = robust_result_V_srssub(R)
		}
		else {
			V_srs    = robust_result_V_srswr(R)
			V_srssub = robust_result_V_srswrsub(R)
		}
		st_matrix(SM_vsrs, V_srs)
		st_matrix(SM_vsrs+"sub", V_srssub)
		if (hasfpc) {
			V_srs_wr    = robust_result_V_srswr(R)
			V_srssub_wr = robust_result_V_srswrsub(R)
			st_matrix(SM_vsrs+"wr", V_srs_wr)
			st_matrix(SM_vsrs+"subwr", V_srssub_wr)
		}
	}
	st_local("subuse", robust_init_subuse(R))
}

end
