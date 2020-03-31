*! version 1.2.1  11may2017

local diparm_sep	-1
local diparm_bot	-2
local diparm_label	-3
local diparm_eqlab	-4
local diparm_aux	1
local diparm_trans	2
local diparm_vlabel	3
local diparm_veqlab	4

local ci_normal		0
local ci_wald		`ci_normal'
local ci_logit		1
local ci_wilson		2
local ci_exact		3	// Clopper-Pearson
local ci_agresti	4	// Agresti-Coull
local ci_jeffreys	5

local ci_default	`ci_normal'

local varcov	`"tokens("var cov")"'

local chibar_eps	1e-5

local reldif_tol	1e-7

local pclass_none	0
local pclass_var	100
local pclass_notest	101

