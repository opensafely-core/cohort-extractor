*! version 1.1.6  23jan2019

* macro definitions for __sub_expr

/* flags for object type						*/
local SUBEXPR_NULL		0
local SUBEXPR_UNDEFINED		1
local SUBEXPR_GROUP		2
local SUBEXPR_EXPRESSION	3
local SUBEXPR_VARIABLE		4
local SUBEXPR_LV		5
local SUBEXPR_PARAM		6
local SUBEXPR_LC_PARAM		7
local SUBEXPR_FV		8
local SUBEXPR_FV_PARAM		9
local SUBEXPR_LV_PARAM		10
local SUBEXPR_MATRIX            11

/* names associated with object types					*/
local SUBEXPR_STR_UNDEFINED	`""undefined""'
local SUBEXPR_STR_EQUATION	`""equation""'
local SUBEXPR_STR_GROUP		`""group""'
local SUBEXPR_STR_EXPRESSION	`""expression""'
local SUBEXPR_STR_LC		`""linear combination""'
local SUBEXPR_STR_VARIABLE	`""variable""'
local SUBEXPR_STR_LV		`""latent variable""'
local SUBEXPR_STR_PARAM		`""free parameter""'
local SUBEXPR_STR_LC_PARAM	`""LC parameter""'
local SUBEXPR_STR_FV		`""factor variable""'
local SUBEXPR_STR_FV_PARAM	`""FV parameter""'
local SUBEXPR_STR_LV_PARAM	`""LV parameter""'
local SUBEXPR_STR_MATRIX	`""matrix""'

/* group type index, also index into array of strings			*/
local SUBEXPR_GROUP_EXPRESSION	2	// named expression
local SUBEXPR_GROUP_LC		3	// Stata's linear form
local SUBEXPR_GROUP_PARAM	4	// parameter group
local SUBEXPR_EQ_EXPRESSION	5	// depvar = expression
local SUBEXPR_EQ_LC		6	// depvar indepvars
local SUBEXPR_EQUATION		10
local SUBEXPR_EXPRESSION	11

local SUBEXPR_INSTANCE_ID_INIT	-1	// initialization object flag
					//  expression has TS operators
local SUBEXPR_VAR_GROUP 	`""$""'
local SUBEXPR_MAT_GROUP		`""%""'
local SUBEXPR_GROUP_SYMBOL 	`""@""'
local SUBEXPR_LV_GROUP 		`""&""'
local SUBEXPR_PARAM_GROUP 	`""/""'

local SUBEXPR_STR_GROUP_EXPRESSION `""named expression""'
local SUBEXPR_STR_GROUP_EQ_EXPR    `""equation expression""'	// add
local SUBEXPR_STR_GROUP_LC	   `""linear combination""'
local SUBEXPR_STR_GROUP_EQ_LC	   `""equation linear combination""'
local SUBEXPR_STR_GROUP_PARAM	   `""parameter group""'
local SUBEXPR_STR_EQ_EXPRESSION	   `""equation""'
local SUBEXPR_STR_EQ_LC		   `""linear equation""'

local SUBEXPR_PARSE_NONE	0
local SUBEXPR_PARSE_EQUATION	100
local SUBEXPR_PARSE_EQUATION_LC	101
local SUBEXPR_PARSE_EXPRESSION 	102

local SUBEXPR_MAYBE		-1
local SUBEXPR_FALSE		0
local SUBEXPR_TRUE		1
local SUBEXPR_OFF		0
local SUBEXPR_ON		1

local SUBEXPR_ALLCAPS		2

/* LV path tokens							*/
local SUBEXPR_OP_NEST		`"">""'
local SUBEXPR_OP_CROSS		`""#""'

local SUBEXPR_YHAT		`""_yhat""'

/* flags for expression display __sub_expr_xxx::traverse_expr()		*/
local SUBEXPR_CONDENSED		201
local SUBEXPR_FULL		202
local SUBEXPR_DISPLAY  		203	// full, but for display
local SUBEXPR_SUBSTITUTED	204

/* flags for special handling __sub_expr::set_special()			*/
local SUBEXPR_SPECIAL_HSYMBOLS	210
local SUBEXPR_SPECIAL_APP_NONE	220	// no special handling
local SUBEXPR_SPECIAL_APP_REG	222	// general application
local SUBEXPR_SPECIAL_APP_BAYES	223	// Bayes application
local SUBEXPR_SPECIAL_APP_MENL	224	// menl application

/* message flags __sub_expr_xxx::update() __sub_expr_xxx::data()	*/
local SUBEXPR_HINT_VARLIST	501
local SUBEXPR_HINT_DATAOBJ	502
local SUBEXPR_HINT_REMOVEOBJ	503
local SUBEXPR_HINT_COVARIATE	504
local SUBEXPR_HINT_OPERATOR	505
local SUBEXPR_HINT_VALUE	506
local SUBEXPR_HINT_COEF_INDEX	507
local SUBEXPR_HINT_SUBEXPR	508
local SUBEXPR_HINT_TNAME	509
local SUBEXPR_HINT_REFCOUNT	510
local SUBEXPR_HINT_PARAMTYPE	511
local SUBEXPR_HINT_PATH		512
local SUBEXPR_HINT_COUNT	513
local SUBEXPR_HINT_UNLINK	514
local SUBEXPR_HINT_HIERARCHY	515
local SUBEXPR_HINT_MATRIX	516	// Mata matrix
local SUBEXPR_HINT_STMATRIX	517	// __stmatrix
local SUBEXPR_HINT_COLSTRIPE	518
local SUBEXPR_HINT_ROWSTRIPE	519
local SUBEXPR_HINT_MATSTRIPE	520
local SUBEXPR_HINT_FV		521
local SUBEXPR_HINT_FV_CLEAR	522
local SUBEXPR_HINT_FV_NAMES	523
local SUBEXPR_HINT_MARK_DIRTY	530
local SUBEXPR_HINT_PATH_TREE	531
local SUBEXPR_HINT_VALIDATE	532
local SUBEXPR_HINT_PARAM	533
local SUBEXPR_HINT_PARAM_CLEAR	534
local SUBEXPR_HINT_REMOVE_PARAM	535
local SUBEXPR_HINT_FIXED_PARAM	536
local SUBEXPR_HINT_PARAM_VEC	537
local SUBEXPR_HINT_INSTANCE_ID	538
local SUBEXPR_HINT_COMPONENT	539
local SUBEXPR_HINT_EQUATION_OBJ	540
local SUBEXPR_HINT_LV_NAMES	541
local SUBEXPR_HINT_INITOBJ	542
local SUBEXPR_HINT_PROPERTIES	543
local SUBEXPR_HINT_TSINIT_REQ	544
local SUBEXPR_HINT_GROUP_TYPE	545
local SUBEXPR_HINT_GROUP_STYPE	546
local SUBEXPR_HINT_TS_ORDER	547

/* flags for parsing state		// completed:			*/

local SUBEXPR_DIRTY_READY	0	// ready to initialize and/or evaluate
local SUBEXPR_DIRTY_RESOLVED_COV 1	// resolved covariances
local SUBEXPR_DIRTY_RESOLVED_EXP 2	// resolved expressions
local SUBEXPR_DIRTY_RESOLVE	3	// resolving exprs; intermediate state
local SUBEXPR_DIRTY_RESOLVED_HIER 4	// resolved hierarchy before expr.
local SUBEXPR_DIRTY_PARSED	5	// parsed at least one equation/expr
local SUBEXPR_DIRTY_UNDEFINED	6	// nothing

/* flags for LHS types							*/
local SUBEXPR_EVAL_NULL		300
local SUBEXPR_EVAL_SCALAR	301
local SUBEXPR_EVAL_VECTOR	302
local SUBEXPR_EVAL_MATRIX	303

/* flags for expression state						*/
local SUBEXPR_EVAL_DIRTY	350	// needs evaluation
local SUBEXPR_EVAL_CLEAN	351	// tempvar/scalar/matrix ready

local SUBEXPR_EVAL_IDLE		500
local SUBEXPR_EVAL_EXPR		501
local SUBEXPR_EVAL_INIT		502
local SUBEXPR_EVAL_VARLIST	503	// flags to prevent stack dump
local SUBEXPR_EVAL_TS_ORDER	504	//  if user creates recursive
local SUBEXPR_EVAL_DEPENDENCY	505	//  expression
local SUBEXPR_EVAL_TS_RECURSIVE 506

local SUBEXPR_METRIC_EST	0
local SUBEXPR_METRIC_VAR	1
local SUBEXPR_METRIC_SD		2
local SUBEXPR_METRIC_USER	3
local SUBEXPR_METRIC_RESID	10

/* PROPS in powers of 10; prop_on = mod(floor(m_prop/prop),2)		*/
local SUBEXPR_PROP_TS_OP	10
local SUBEXPR_PROP_TS_INIT	100
local SUBEXPR_PROP_TEMPLATE	1000
local SUBEXPR_PROP_LINEAR_FORM	10000

local SUBEXPR_ERROR_TSINIT	1000
local SUBEXPR_ERROR_LAG_EQ	1001
local SUBEXPR_ERROR_RECURSIVE	1002
local SUBEXPR_ERROR_EXECUTION_FAILURE	1003
exit
