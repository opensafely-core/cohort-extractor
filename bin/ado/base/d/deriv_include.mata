*! version 1.0.0  22oct2007
version 10

// Data types ---------------------------------------------------------------

local DerivStruct		struct deriv__struct scalar

local Errcode			real scalar

// Error codes and their messages -------------------------------------------

local Errcode_invalid_todo	1
local Errtext_invalid_todo	`""invalid todo argument""'
local Errcode_no_user		2
local Errtext_no_user		`""evaluator function required""'
local Errcode_no_params		3
local Errtext_no_params		`""parameter values required""'
local Errcode_missing		4
local Errtext_missing		`""parameter values not feasible""'

// WARNING: do not change the following error codes, they correspond to the
// same values used by -optimize()- which uses -_deriv()- to compute numerical
// derivatives

local Errcode_discon_miss	5
local Errtext_discon_miss	///
`""could not calculate numerical derivatives -- discontinuous region with missing values encountered""'
local Errcode_discon_flat	6
local Errtext_discon_flat	///
`""could not calculate numerical derivatives -- flat or discontinuous region encountered""'
local Errcode_no_calluser	16
local Errtext_no_calluser	`""deriv() subroutine not found""'
local Errcode_Hessian_t		17
local Errtext_Hessian_t		///
`""Hessian calculations not allowed with type t evaluators""'

// Named constants ----------------------------------------------------------

local TRUE			1
local FALSE			0

local DERIV_nargs_default	0
local DERIV_nargs_max		9	// WARNING: Changing deriv_nargs_max
					// requires that functions be added to
					// deriv_calluser.mata.  Changing this
					// macro is discouraged, 9 should be
					// plenty given that Mata has
					// structures.

local DERIV_goals_default	(1e-8, 1e-7)
local DERIV_S_default		1
local DERIV_scale0_default	J(D.vdim,D.pdim,`DERIV_S_default')
local DERIV_scale_default	J(D.vdim,D.pdim,.)
local DERIV_h0_default		J(1,D.pdim,`DERIV_S_default')
local DERIV_h_default		J(1,D.pdim,.)
local DERIV_flat_maxiter	4

local DERIV_evaltype_d		0
local DERIV_evaltype_v		1
local DERIV_evaltype_t		2

local DERIV_search_off		0
local DERIV_search_interpol	1
local DERIV_search_bracket	2

