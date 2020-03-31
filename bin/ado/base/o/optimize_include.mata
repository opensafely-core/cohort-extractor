*! version 1.5.0  23aug2019

// Data types ---------------------------------------------------------------

local OptStruct			struct opt__struct scalar

local Errcode			real scalar

// Error codes and their messages -------------------------------------------

local Errcode_notfeasible	1
local Errtext_notfeasible	`""initial values not feasible""'
local Errcode_badconstr		2
local Errtext_badconstr		`""redundant or inconsistent constraints""'
local Errcode_value_missing	3
local Errtext_value_missing	`""missing values returned by evaluator""'
local Errcode_H_notdefinite	4
local Errtext_H_notPSD		`""Hessian is not positive semidefinite""'
local Errtext_H_notNSD		`""Hessian is not negative semidefinite""'
local Errcode_discon_miss	5
local Errtext_discon_miss	///
`""could not calculate numerical derivatives -- discontinuous region with missing values encountered""'
local Errcode_discon_flat	6
local Errtext_discon_flat	///
`""could not calculate numerical derivatives -- flat or discontinuous region encountered""'
local Errcode_discon		7
local Errtext_discon		///
`""cannot compute an improvement -- discontinuous region encountered""'
local Errcode_flat		8
local Errtext_flat		///
`""cannot compute an improvement -- flat region encountered""'
local Errcode_unstable		9
local Errtext_unstable		///
`""Hessian could not be updated -- Hessian is unstable""'

local Errcode_bad_tech		10
local Errtext_bad_tech		`""technique unknown""'
local Errcode_bad_tech_comb	11
local Errtext_bad_tech_comb	`""incompatible combination of techniques""'
local Errcode_no_step		12
local Errtext_no_step		`""singular H method unknown""'
local Errcode_stripe_invalid	13
local Errtext_stripe_invalid	`""matrix stripe invalid for parameter vector""'
local Errcode_tol_negative	14
local Errtext_tol_negative	///
`""negative convergence tolerance values are not allowed""'
local Errcode_invalid_p0	15
local Errtext_invalid_p0	`""invalid starting values""'
local Errcode_no_calluser	16
local Errtext_no_calluser	`""optimize() subroutine not found""'
local Errcode_simplex_req	17
local Errtext_simplex_req	`""simplex delta required""'
local Errcode_simplex_bad_dim	18
local Errtext_simplex_bad_dim	///
`""simplex delta not conformable with parameter vector""'
local Errcode_simplex_small	19
local Errtext_simplex_small	///
`""simplex delta value too small (must be greater than 10*ptol in absolute value)""'
local Errcode_eval_debug	20
local Errtext_eval_debug	`""evaluator type requires the nr technique""'
local Errcode_no_eval		21
local Errtext_no_eval		///
`""evaluator type not allowed with the specified technique ""'
local Errcode_no_loop		22
local Errtext_no_loop		`""optimize() subroutine not found""'
local Errcode_bhhh_req		23
local Errtext_bhhh_req		///
`""evaluator type not allowed with bhhh technique""'
local Errcode_no_user		24
local Errtext_no_user		`""evaluator function required""'
local Errcode_no_p0		25
local Errtext_no_p0		`""starting values for parameters required""'
local Errcode_p0_missing	26
local Errtext_p0_missing	`""missing parameter values not allowed""'
local Errcode_invalid_evaltype	27
local Errtext_invalid_evaltype	`""invalid evaluator type""'

local Errcode_weights		400
local Errtext_weights		`""weights not specified""'
local Errcode_search_feasible	401
local Errtext_search_feasible	`""could not find feasible values""'
local Errcode_stata_rc		402
local Errtext_stata_rc		`""Stata program evaluator returned an error""'
local Errcode_no_views		403
local Errtext_no_views		///
`""views are required when the evaluator is a Stata program""'
local Errcode_by_weights	404
local Errtext_by_weights	`""weights not constant within group""'
local Errcode_freeparm		405
local Errtext_freeparm		`""{it:xvars} not allowed with {bf:freeparm}""'

// Default values and other settings ----------------------------------------

// optimize_version()
local OPT_version_default	1.1

// general on/off switch
local OPT_onoff0		`""off""'
local OPT_onoff_off		0
local OPT_onoff1		`""on""'
local OPT_onoff_on		1
local OPT_onoff_max		1

// optimize_init_which()
local OPT_which0		`""max""'
local OPT_which_max		0
local OPT_which1		`""min""'
local OPT_which_min		1
local OPT_which_last		1
local OPT_which_default		`OPT_which_max'

// optimize_init_conv_ndami()
local OPT_conv_ndami_default	`OPT_onoff_off'

// optimize_init_conv_warning()
local OPT_conv_warn_default	`OPT_onoff_on'

// optimize_init_evaluator()
local OPT_user_default		NULL

// optimize_init_iterprolog()
local OPT_userprolog_default	NULL

// optimize_init_derivprolog()
local OPT_userprolog2_default	NULL

// optimize_init_evaluatortype()
local OPT_evaltype_d		1
local OPT_evaltype_v		2
local OPT_evaltype_q		3
local OPT_evaltype_lf		4
local OPT_evaltype_e		5

local OPT_evaltype_max		5
local OPT_evaltype_default	`""d0""'
local MOPT_evaltype_default	`""lf""'

// optimize_init_evaluations()
local OPT_evalcount_default	`OPT_onoff_off'

// optimize_init_technique()
local OPT_technique_bfgs	`""bfgs""'
local OPT_technique_bhhh	`""bhhh""'
local OPT_technique_dfp		`""dfp""'
local OPT_technique_nm		`""nm""'
local OPT_technique_nr		`""nr""'
local OPT_technique_gn		`""gn""'
local OPT_technique_default	`"`OPT_technique_nr'"'

local QUASI `""bfgs bhhh dfp""'

// for cycling over a multiple of techniques
local OPT_cycle_names_default	`""""'
local OPT_cycle_counts_default	5
local OPT_cycle_iter_default	1
local OPT_cycle_idx_default	1

// optimize_init_singularHmethod()
local OPT_singularH_m_marquardt	`""m-marquardt""'
local OPT_singularH_hybrid	`""hybrid""'
local OPT_singularH_default	`"`OPT_singularH_m_marquardt'"'

// optimize_init_step_forward()
local OPT_step_forward_default	`OPT_onoff_on'

// optimize_init_conv_maxiter()
local OPT_maxiter_default	c("maxiter")

// optimize_init_conv_ptol()
local OPT_ptol_default		1e-6

// optimize_init_conv_vtol()
local OPT_vtol_default		1e-7

// optimize_init_conv_gtol()
local OPT_gtol_default		.

// optimize_init_conv_nrtol()
local OPT_nrtol_default		1e-5

// optimize_init_conv_ignorenrtol()
local OPT_ignorenrtol_default	`OPT_onoff_off'

// optimize_init_conv_notconcave()
local OPT_notconcave_default	.

// optimize_init_tracelevel()
// WARNING:  While the string identifiers for the trace items will remain
// fixed from here on out, the corresponding numeric values can change over
// time with the addition of new trace items.  The only exception here is that
// "none" will always be mapped to 0.
local OPT_tracelvl0		`""none""'
local OPT_tracelvl_none		0
local OPT_tracelvl1		`""value""'
local OPT_tracelvl_value	1
local OPT_tracelvl2		`""tolerance""'
local OPT_tracelvl_tol		2
local OPT_tracelvl3		`""step""'
local OPT_tracelvl_step		3
local OPT_tracelvl4		`""paramdiffs""'
local OPT_tracelvl4alt		`""coefdiffs""'
local OPT_tracelvl_pdiffs	4
local OPT_tracelvl5		`""params""'
local OPT_tracelvl5alt		`""coefs""'
local OPT_tracelvl_params	5
local OPT_tracelvl6		`""gradient""'
local OPT_tracelvl_gradient	6
local OPT_tracelvl7		`""hessian""'
local OPT_tracelvl_hessian	7
local OPT_tracelvl_max		7
local OPT_tracelvl_default	`OPT_tracelvl_value'

// optimize_init_trace_*()
local OPT_trace_value_default		1
local OPT_trace_dots_default		0
local OPT_trace_tol_default		0
local OPT_trace_pdiffs_default		0
local OPT_trace_step_default		0
local OPT_trace_params_default		0
local OPT_trace_gradient_default	0
local OPT_trace_hessian_default		0

// optimize_init_valueid()
local OPT_value_id_default	`""f(p)""'

// optimize_init_valueid()
local OPT_iter_id_default	`""Iteration""'

// optimize_init_constraints()
local OPT_constraints_default	J(0,1,.)

// user arguments

// optimize_init_narguments() and optimize_init_argument()
local OPT_nargs_default		0
local OPT_nargs_max		9	// WARNING: Changing OPT_nargs_max
					// requires that functions be added to
					// optimize_calluser.mata.  Changing
					// this macro is discouraged, 9 should
					// be plenty given that Mata has
					// structures.
local OPT_arglist_default	J(1,`OPT_nargs_max',NULL)

// optimize_init_negH()
local OPT_negH_default		0

// optimize_init_weight()
local OPT_weights_default	J(1,1,1)

// optimize_init_weighttype()
local OPT_wtype0		`""""'
local OPT_wtype_none		0
local OPT_wtype1		`""fweight""'
local OPT_wtype_f		1
local OPT_wtype2		`""aweight""'
local OPT_wtype_a		2
local OPT_wtype3		`""pweight""'
local OPT_wtype_p		3
local OPT_wtype4		`""iweight""'
local OPT_wtype_i		4
local OPT_wtype_max		4
local OPT_wtype_default		`OPT_wtype_none'

// optimize_init_nmsimplexdeltas()
local OPT_simplex_delta_default	J(1,0,.)

// optimize_init_params()
local OPT_p0_default		J(1,0,.)

// optimize_result_value0()
local OPT_v0_default		.

// optimize_result_params()
local OPT_params_default	J(1,0,.)

// optimize_result_value()
local OPT_value_default		.

// optimize_result_gradient()
local OPT_gradient_default	J(1,0,.)

// optimize_result_Hessian()
local OPT_hessian_default	J(0,0,.)

// optimize_result_iterations()
local OPT_iter_default		0

// optimize_result_converged()
local OPT_converged_default	0
local OPT_convtol_default	.

// optimize_result_iterationlog()
local OPT_log_length		20
local OPT_log_default		J(`OPT_log_length',1,0)

// optimize_result_evaluations()
local OPT_cnt_evals_default	0

// pointer to routine that calls the users evaluator function
local OPT_valid_default		`OPT_onoff_off'

// indicator for debug type evaluators
local OPT_debugeval_default	0

// pointer to routine that calls the users evaluator function
local OPT_calluser_default	NULL
local OPT_callprolog_default	NULL

// pointer to routine that calls calluser and repackages the results
local OPT_eval_default		NULL

// pointer to singularH routine
local OPT_singularH_stepper_default	NULL

// pointer to technique's looping routine
local OPT_loop_default		NULL

// dimension of the parameter vector
local OPT_dim_default		0

// dimension of the parameter vector
local OPT_H_default		`OPT_hessian_default'

// counter for # of backed-up steps
local OPT_concave_default	0

// counter for # of backed-up steps
local OPT_backup_default	0
local OPT_backup_min		6

// scales for numerical derivatives
local OPT_scale_default		1
local OPT_h_default		1
local OPT_holdscale_default	0
local OPT_userscale_default	0

// constraints:  indicator
local OPT_hasCns_false		0
local OPT_hasCns_true		1
local OPT_hasCns_default	`OPT_hasCns_false'

// constraints:  T matrix
local OPT_T_default		J(0,0,.)

// constraints:  a vector
local OPT_a_default		J(0,0,.)

// copy of the previous parameter vector
local OPT_oldparams_default	J(0,0,.)

// copy of the previous parameter vector
local OPT_oldgrad_default	J(0,0,.)

// counter for number of times alternative Hessian was reset
local OPT_reset_default		0
local OPT_reset_max		10

// multiplier for eigen system split, only used with hybrid
local OPT_eigen_default		1e-7

// simplex object
local OPT_simplex_default	J(0,0,.)

// simplex object
local OPT_simvals_default	J(0,1,.)

// simplex object
local OPT_simorder_default	J(0,1,.)

// # of notes in the simplex object
local OPT_simnodes_default	0

// optimize's error code
local OPT_oerrorcode_default	0

// error code
local OPT_errorcode_default	0

// error message
local OPT_errortext_default	`""""'

// verbose
local OPT_verbose_default	1

// ucall
local OPT_ucall_default		0

// invert
local OPT_invert_default	`OPT_onoff_on'

// row-vectorized versions of value and gradient
local OPT_value_v_default	J(0,1,.)
local OPT_gradient_v_default	J(0,0,.)

// matrix stripes associated with the parameter vector
local OPT_stripes_default	J(0,2,"")

// A matrix used in Gauss-Newton optimization
local OPT_gn_A_default		NULL

// doopt -- early convergence check used by Stata's originally internal ML
// estimation commands
local OPT_doopt_default		0

