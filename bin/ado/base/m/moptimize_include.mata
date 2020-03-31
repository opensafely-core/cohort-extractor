*! version 1.1.0  08mar2016

// Data types ---------------------------------------------------------------

local MoptStruct		struct mopt__struct scalar

// --------------------------------------------------------------------------

local MOPT_S_default		NULL

// moptimize_version()
local MOPT_version_default		1
local MOPT_caller_version_default	c("version")

// moptimize_init_depvar()
local MOPT_depvars_default	NULL
local MOPT_ndepvars_default	0
local MOPT_obs_default		0

// moptimize_init_obs()
local MOPT_obs_default		.

// moptimize_init_eq_n()
// moptimize_init_eq_indepvars()
// moptimize_init_eq_cons()
// moptimize_init_eq_name()
// moptimize_init_eq_colnames()
// moptimize_init_eq_offset()
// moptimize_init_eq_exposure()
local MOPT_neq_default		1
local MOPT_eqlist_default	NULL
local MOPT_eqcons_default	1
local MOPT_eqnames_default	`""""'
local MOPT_eqcoefs_default	NULL
local MOPT_eqcolnames_default	NULL
local MOPT_eqbounds_default	.
local MOPT_eqoffset_default	NULL
local MOPT_eqexposure_default	0
local MOPT_eqfreeparm_default	0

// moptimize_init_kaux()
local MOPT_kaux_default		0

// moptimize_init_diparm()
local MOPT_diparm_default	J(0,1,"")

// moptimize_init_title()
local MOPT_title_default	`""""'

local MOPT_valid_default	`OPT_onoff_off'

// moptimize_init_nuserinfo() and moptimize_init_userinfo()
local MOPT_nuinfo_default	0
local MOPT_nuinfo_max		9	// NOTE:  Changing MOPT_nuinfo_max is
					// safe, but is discouraged, 9 should
					// be plenty given Mata has
					// structures.
local MOPT_uinfolist_default	J(1,`MOPT_nuinfo_max',NULL)

// moptimize_init_weight()
local MOPT_wname_default	`""""'
local MOPT_weights_default	NULL

// moptimize_init_svy()
local MOPT_svy_default		`OPT_onoff_off'

// moptimize_init_search()
local MOPT_search_default	`OPT_onoff_on'

// moptimize_init_search_feasible()
local MOPT_feasible_default	1000

// moptimize_init_search_repeat()
local MOPT_repeat_default	10

// moptimize_init_search_rescale()
local MOPT_rescale_default	`OPT_onoff_on'

// moptimize_init_search_random()
local MOPT_restart_default	`OPT_onoff_off'

// moptimize_init_vcetype()
local j -1
local MOPT_vcetype`++j'		`""""'
local MOPT_vcetype_none		`j'
local MOPT_vcetype`++j'		`""oim""'
local MOPT_vcetype_oim		`j'
local MOPT_vcetype`++j'		`""opg""'
local MOPT_vcetype_opg		`j'
local MOPT_vcetype`++j'		`""robust""'
local MOPT_vcetype_robust	`j'
local MOPT_vcetype`++j'		`""cluster""'
local MOPT_vcetype_cluster	`j'
local MOPT_vcetype`++j'		`""svy""'
local MOPT_vcetype_svy		`j'
local MOPT_vcetype_max		`j'
local MOPT_vcetype_default	`MOPT_vcetype_none'

// items not having an output routine ---------------------------------------
local MOPT_eqdims_default	J(0,0,.)

local MOPT_scale_default	J(1,0,.)
local MOPT_h_default		J(1,0,.)

// items governing Stata objects --------------------------------------------
local MOPT_need_views_default		0
local MOPT_st_user_default		`""""'
local MOPT_st_userprolog_default	`""""'
local MOPT_st_trace_default		`""""'
local MOPT_st_touse_default		`""""'
local MOPT_st_depvars_default		`""""'
local MOPT_st_eqlist_default		`""""'
local MOPT_st_eqoffset_default		`""""'
local MOPT_st_wvar_default		`""""'
local MOPT_k_autoCns_default		0
local MOPT_st_drop_macros_default	1
local MOPT_st_regetviews_default	0
local MOPT_st_tsops_default		0
local MOPT_check_default		`OPT_onoff_off'
local MOPT_st_rc_default		0
local MOPT_norc_default			`OPT_onoff_off'

// strings that point to Stata objects --------------------------------------
local MOPT_st_p_default		`""""'
local MOPT_st_v_default		`""""'
local MOPT_st_g_default		`""""'
local MOPT_st_H_default		`""""'
local MOPT_st_scores_default	`""""'
local MOPT_st_cmd_args_default	`""""'
local MOPT_st_tmp_w_default	`""""'

// pointers to views --------------------------------------------------------
local MOPT_xb_default		J(0,0,.)

