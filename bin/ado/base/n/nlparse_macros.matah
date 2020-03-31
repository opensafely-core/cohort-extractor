*! version 1.0.1  01aug2019
/* macros used by Mata function _nlparse()				*/

/* keep macro indicies in sync with C enumerated type
 *
 * typedef enum { Constant, Symbol, Expression, Subexpr, Parameter,
 *	ParGroup, Path, LatentVar, Function, Arglist, Operator, Lincom,
 *	Options} nodeEnum;						*/

local NULL		0
local CONSTANT		1
local SYMBOL		2
local LINCOM		3
local EXPRESSION	4
local EQUATION		5
local SUBEXPR		6
local PARAMETER		7
local PARGROUP		8
local LATENTVAR		9
local PATHOP		10
local ATOP		11
local LVPARAM		12
local FUNCTION		13
local ARGLIST		14
local VARLIST		15
local OPERATOR		16
local FACTOROP		17
local TSOP		18
local OPTIONS		19
local VECTOR		20
local MATRIX		21
local KTYPES		`MATRIX'

local STR_CONSTANT	`""constant""'
local STR_SYMBOL	`""symbol""'
local STR_LINCOM	`""linear combination""'
local STR_EXPRESSION	`""expression""'
local STR_EQUATION	`""equation""'
local STR_SUBEXPR	`""substitutable expression""'
local STR_PARAMETER	`""parameter""'
local STR_PARGROUP	`""parameter group""'
local STR_LATENTVAR	`""latent variable""'
local STR_PATHOP	`""path operator""'
local STR_ATOP		`""at operator""'
local STR_LVPARAM	`""LV parameter""'
local STR_FUNCTION	`""function""'
local STR_ARGLIST	`""argument list""'
local STR_VARLIST	`""variable list""'
local STR_OPERATOR	`""operator""'
local STR_FACTOROP	`""factor variable operator""'
local STR_TSOP		`""time series operator""'
local STR_OPTIONS	`""options""'
local STR_VECTOR	`""vector""'
local STR_MATRIX	`""matrix""'

local PT_STR_TYPES `"`STR_CONSTANT',`STR_SYMBOL',`STR_LINCOM'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_EXPRESSION',`STR_EQUATION'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_SUBEXPR',`STR_PARAMETER'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_PARGROUP',`STR_LATENTVAR'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_PATHOP',`STR_ATOP'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_LVPARAM',`STR_FUNCTION'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_ARGLIST',`STR_VARLIST'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_OPERATOR',`STR_FACTOROP'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_TSOP',`STR_OPTIONS'"'
local PT_STR_TYPES `"`PT_STR_TYPES',`STR_VECTOR',`STR_MATRIX'"'

local ABR_CONSTANT	`""const""'
local ABR_SYMBOL	`""syml""'
local ABR_LINCOM	`""LC""'
local ABR_EXPRESSION	`""expr""'
local ABR_EQUATION	`""eq""'
local ABR_SUBEXPR	`""subexpr""'
local ABR_PARAMETER	`""par""'
local ABR_PARGROUP	`""pargrp""'
local ABR_LATENTVAR	`""LV""'
local ABR_PATHOP	`""pathop""'
local ABR_ATOP		`""@""'
local ABR_LVPARAM	`""LVpar""'
local ABR_FUNCTION	`""fun""'
local ABR_ARGLIST	`""argl""'
local ABR_VARLIST	`""varl""'
local ABR_OPERATOR	`""opr""'
local ABR_FACTOROP	`""fopr""'
local ABR_TSOP		`""tsopr""'
local ABR_OPTIONS	`""opt""'
local ABR_VECTOR	`""vec""'
local ABR_MATRIX	`""mat""'

local PT_ABR_TYPES `"`ABR_CONSTANT',`ABR_SYMBOL',`ABR_LINCOM'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_EXPRESSION',`ABR_EQUATION'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_SUBEXPR',`ABR_PARAMETER'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_PARGROUP',`ABR_LATENTVAR'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_PATHOP',`ABR_ATOP'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_LVPARAM',`ABR_FUNCTION'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_ARGLIST',`ABR_VARLIST'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_OPERATOR',`ABR_FACTOROP'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_TSOP',`ABR_OPTIONS'"'
local PT_ABR_TYPES `"`PT_ABR_TYPES',`ABR_VECTOR',`ABR_MATRIX'"'

local TRUE 1
local FALSE 0

exit
