*! version 1.0.2  26jan2012

/*
	transmorphic et = u_mi_ehold_init()

	u_mi_ehold_set_omit(et, "<names>")
		e(<names>) are to be ignored by u_mi_ehold_*()
		You should u_mi_ehold_set_omit(et, "b V Cns")

	u_mi_ehold_set_scalar(et, "<names>" [, forcemissing])

		e(<names>) are static scalars
		do not need to be declared if forcemiss==0
		forcemiss==1 means set as . at the end.

		Not here, but could be added are 
			u_mi_ehold_set_macro(et, "<names>" [, forcemissing])
			u_mi_ehold_set_matrix(et, "<names>" [, forcemissing])

	u_mi_ehold_set_varying_macro(et, "<names>" [forcemissing])
		e(<names>) are varying macros.
		if (forcedmissing | varying ) {
			posted as missing 
			e[<names>_vl_mi] posted
		}
		else {
			posted as e(<names>)
		}

	u_mi_ehold_set_varying_scalar(et, "<names>" [, forcemissing])
		e(<names>) are varying macros.
		if (forcedmissing | varying ) {
			posted as .
			e[<names>_vs_mi] posted
		}
		else {
			posted e(<names>)
		}

	u_mi_ehold_set_varying_matrix(et, "<names>" [, forcemissing])
		if (forcedmissing | varying ) {
			posted as .
			e[<names>_vm_mi] posted, corresponding to r(N)==min
			(if all r(N) equal, then from m=1)
		}
		else {
			posted as e(<names>)
		}

	u_mi_ehold_update(et)
		call repeatedly after estimation.


	u_mi_ehold_post(et)
		call to post results.
		You should already have e(b), e(V), e(Cns) if needed posted
		Does not matter what else is posted.
			
	u_mi_ehold_free(et)
		To free memory
		Calling this optional.
*/

set matastrict on

version 11

local DEBUG		0

local Aarray		transmorphic
local RS		real scalar
local RR		real rowvector
local RM		real matrix
local RC		real colvector
local SS		string scalar
local SR		string rowvector
local SC		string colvector
local SM		string matrix
local PS		pointer scalar
local PR		pointer rowvector

local boolean		real scalar
local			True	1
local			False	0

local Tycode		real scalar
local Ty_none		0
local Ty_macro		1
local Ty_scalar		2
local Ty_matrix		3

local Excode		real scalar
local ExcodeRow		real rowvector
local 			Ex_none		0
local 			Ex_Smacro	1
local 			Ex_Sscalar	2
local 			Ex_Smatrix	3
local 			Ex_Vmacro	4
local 			Ex_Vscalar	5
local 			Ex_Vmatrix	6
local 			Ex_omitted	7

local voidit		u_mi_ehold_sub_voidit


/* -------------------------------------------------------------------- */
local VLFMT		`""e(%s_vl_mi)""'
local VSFMT		`""e(%s_vs_mi)""'
local VMFMT		`""e(%s_vm_mi)""'
local VLNAME		`""e(names_vvl_mi)""'
local VSNAME		`""e(names_vvs_mi)""'
local VMNAME		`""e(names_vvm_mi)""'

/* -------------------------------------------------------------------- */
local Etimename		u_mi_ehold_etimedf
local Etime		struct `Etimename' scalar
local Etime_add_element	`Etimename'addel

mata:
struct `Etimename'
{
	`RS'			m

	`Aarray' 		idx 	/* i = idx[name] 		*/
	`ExcodeRow'		ex	/* ex[i], type of element 	*/
	`PR'			p	/*  p[i], pointer to element	*/
}

void `Etime_add_element'(`Etime' et, `SS' name, `Excode' ex, pointer scalar p)
{
	asarray(et.idx, name, rows(et.ex)+1)
	et.ex = et.ex \ ex
	et.p  = et.p  \ p
}
end
	
/* -------------------------------------------------------------------- */
local Smacroname	u_mi_ehold_smacrodf
local Smacro		struct `Smacroname' scalar
local newSmacro		`Smacroname'new
local setSmacro		`Smacroname'set
local updateSmacro	`Smacroname'update
local postSmacro	`Smacroname'post
local voidSmacro	`Smacroname'void
local listSmacro	`Smacroname'list

mata:
struct `Smacroname' 
{
	`RS'			lastm
	`boolean'		varies, forcemissing
	`SS'			value
}

`Smacro' `newSmacro'(`boolean' forcemissing)
{
	`Smacro'	smac

	smac.lastm        = 0
	smac.varies       = `False'
	smac.forcemissing = forcemissing
	return(smac)
}

void `setSmacro'(`Smacro' smac, `SS' name, `RS' m)
{
	smac.lastm  = m
	smac.varies = `False'
	smac.value  = st_global(sprintf("e(%s)", name))
}

void `updateSmacro'(`Smacro' smac, `SS' name, `RS' m)
{
	if (smac.varies) return
	if (smac.lastm != m-1) {
		smac.varies = `True' 
		smac.lastm  = m 
		return
	}

	if (m==1) `setSmacro'(smac, name, m)
	else {
		if (smac.value != st_global(sprintf("e(%s)", name))) {
			smac.varies = `True'
		}
		smac.lastm = m
	}
}

`boolean' `postSmacro'(`RS' m, `SS' name, `Smacro' smac)
{
	st_global(sprintf("e(%s)", name), 
			(smac.varies | smac.forcemissing | m>smac.lastm ? 
			"" : smac.value))
	return(smac.varies)
}

void `voidSmacro'(`Smacro' smac, `RS' m)
{
	smac.varies = `True'
	smac.lastm  = m
}
end

if (`DEBUG') {
	mata:
	void `listSmacro'(`Smacro' smac)
	{
		printf("{txt}   SMacro lastm=%f varies=%f fm=%f value=|%s|\n", 
				smac.lastm, smac.varies, smac.forcemissing,
				smac.value)
	}
end
}

/* -------------------------------------------------------------------- */
local Sscalarname	u_mi_ehold_sscalardf
local Sscalar		struct `Sscalarname' scalar
local newSscalar	`Sscalarname'new
local setSscalar	`Sscalarname'set
local updateSscalar	`Sscalarname'update
local postSscalar	`Sscalarname'post
local voidSscalar	`Sscalarname'void
local listSscalar	`Sscalarname'list

mata:
struct `Sscalarname'
{
	`RS'			lastm
	`boolean'		varies
	`boolean'		forcemissing
	`RS'			value
}

`Sscalar' `newSscalar'(`boolean' forcemissing)
{
	`Sscalar'	ssca

	ssca.lastm        = 0 
	ssca.forcemissing = forcemissing
	ssca.varies       = `False'
	return(ssca)
}

void `setSscalar'(`Sscalar' ssca, `SS' name, `RS' m)
{
	ssca.lastm  = m
	ssca.varies = `False'
	ssca.value  = st_numscalar(sprintf("e(%s)", name))
}

void `updateSscalar'(`Sscalar' ssca, `SS' name, `RS' m)
{
	if (ssca.varies) return

	if (ssca.lastm != m-1) {
		ssca.varies = `True' 
		ssca.lastm = m 
		return
	}

	if (m==1) `setSscalar'(ssca, name, m)
	else {
		if (ssca.value != st_numscalar(sprintf("e(%s)", name))) {
			ssca.varies = `True'
		}
		ssca.lastm = m
	}
}

`boolean' `postSscalar'(`RS' m, `SS' name, `Sscalar' ssca)
{
	`SS'	fullname

	fullname = sprintf("e(%s)", name)
	if (ssca.lastm == 0) {
		st_global(fullname, "")
		return(`False')
		/*NOTREACHED*/
	}
	st_numscalar(fullname, 
		(ssca.varies | ssca.forcemissing | m>ssca.lastm ? 
							. : ssca.value))
	return(ssca.varies)
}

void `voidSscalar'(`Sscalar' ssca, `RS' m)
{
	ssca.varies = `True'
	ssca.lastm  = m
}
end

if (`DEBUG') {
	mata:
	void `listSscalar'(`Sscalar' ssca)
	{
		printf(
		"{txt}    Sscalar lastm=%f varies=%f fm=%f value=%10.0g\n",
		ssca.lastm, ssca.varies, ssca.forcemissing, ssca.value)
	}
	end
}
/* -------------------------------------------------------------------- */

local Smatrixname	u_mi_ehold_smatrixdf
local Smatrix		struct `Smatrixname' scalar
local newSmatrix	`Smatrixname'new
local setSmatrix	`Smatrixname'set
local updateSmatrix	`Smatrixname'update
local postSmatrix	`Smatrixname'post
local voidSmatrix	`Smatrixname'void
local listSmatrix	`Smatrixname'list
mata:
struct `Smatrixname'
{
	`RS'			lastm
	`boolean'		varies
	`boolean'		forcemissing
	`RM'			mat
	`SM'			rowstripe, colstripe
}

`Smatrix' `newSmatrix'(`boolean' forcemissing)
{
	`Smatrix'	smat

	smat.lastm        = 0 
	smat.varies       = `False'
	smat.forcemissing = forcemissing
	return(smat)
}

void `setSmatrix'(`Smatrix' smat, `SS' name, `RS' m)
{
	`SS'	fullname

	smat.lastm     = m
	smat.varies    = `False'
	smat.mat       = st_matrix(fullname=sprintf("e(%s)", name))
	smat.rowstripe = st_matrixrowstripe(fullname)
	smat.colstripe = st_matrixcolstripe(fullname)
}

void `updateSmatrix'(`Smatrix' smat, `SS' name, `RS' m)
{
	if (smat.varies) return
	if (smat.lastm != m-1) {
		smat.varies = `True' 
		smat.lastm = m 
		return
	}

	if (m==1) `setSmatrix'(smat, name, m)
	else {
		if (smat.mat != st_matrix(sprintf("e(%s)", name))) {
			smat.varies = `True'
		}
		smat.lastm = m
	}
}

`boolean' `postSmatrix'(`RS' m, `SS' name, `Smatrix' smat)
{
	`SS'	fullname

	pragma unused m

	fullname = sprintf("e(%s)", name)

	if (smat.lastm==0) {
		st_global(fullname, "")
		return(`False')
	}

	if (smat.varies | smat.forcemissing) st_matrix(fullname, .)
	else {
		st_matrix(fullname, smat.mat)
		if (rows(smat.rowstripe))
			st_matrixrowstripe(fullname, smat.rowstripe)
		if (rows(smat.colstripe))
			st_matrixcolstripe(fullname, smat.colstripe)
	}
	return(smat.varies)
}

void `voidSmatrix'(`Smatrix' smat, `RS' m)
{
	smat.varies = `True'
	smat.lastm  = m
}
end
if (`DEBUG') {
	mata:
	void `listSmatrix'(`Smatrix' smat)
	{
		printf(
		"{txt}   Smatrix lastm=%f varies=%f fm=%f\n", 
			smat.lastm, smat.varies, smat.forcemissing)
		printf("mat is:\n") 
		smat.mat
		printf("rowstripe is\n") 
		smat.rowstripe
		printf("colstripe is\n") 
		smat.colstripe
	}
	end
}

/* -------------------------------------------------------------------- */

local Vmacroname	u_mi_ehold_vmacrodf
local Vmacro		struct `Vmacroname' scalar
local newVmacro		`Vmacroname'new
local setVmacro		`Vmacroname'set
local updateVmacro	`Vmacroname'update
local postVmacro	`Vmacroname'post
local voidVmacro	`Vmacroname'void
local extendVmacro	`Vmacroname'extend
local listVmacro	`Vmacroname'list
mata:
struct `Vmacroname'
{
    /*  `RS'			lastm  = rows(values)	*/
	`SC'			values
	`boolean'		varies
	`boolean'		forcemissing
}
`Vmacro' `newVmacro'(`boolean' forcemissing)
{
	`Vmacro'	vmac

	vmac.varies       = `False'
	vmac.forcemissing = forcemissing
	return(vmac)
}

void `setVmacro'(`Vmacro' vmac, `SS' name, `RS' m)
{
	pragma unused m
	vmac.values  = st_global(sprintf("e(%s)", name))
	vmac.varies  = `False'
}

void `updateVmacro'(`Vmacro' vmac, `SS' name, `RS' m)
{
	`SS'	contents

	if (m==1) `setVmacro'(vmac, name, m)
	else {
		`extendVmacro'(vmac, m-1)
		contents = st_global(sprintf("e(%s)", name))
		if (!vmac.varies) {
			vmac.varies = (contents != vmac.values[1])
		}
		vmac.values = vmac.values \ contents
	}
}

`boolean' `postVmacro'(`RS' m, `SS' name, `Vmacro' vmac)
{
	`RS'	i, lastm
	`SS'	fullname, cnts, lq, rq

	fullname = sprintf("e(%s)", name)

	if ((lastm = rows(vmac.values))==0) {
		st_global(fullname, "")
		return(`False')
		/*NOTREACHED*/
	}
	if (vmac.varies | vmac.forcemissing) {
		st_global(fullname, "")
		`extendVmacro'(vmac, m)
		lq = "`" + `"""'
		rq = `"""' + "'"
		cnts = lq + vmac.values[1] + rq
		for (i=2; i<=lastm; i++) {
			cnts = cnts + " " + lq + vmac.values[i] + rq
		}
		st_global(sprintf(`VLFMT', name), cnts)
	}
	else	st_global(fullname, vmac.values[1])
	return(vmac.varies)
}

void `voidVmacro'(`Vmacro' vmac, `RS' m)
{
	`extendVmacro'(vmac, m)
}

void `extendVmacro'(`Vmacro' vmac, `RS' m)
{
	if (rows(vmac.values)==m) return

	if (rows(vmac.values) < m) {
		vmac.values = vmac.values \ J(m-rows(vmac.values), 1, "")
	}
	else 	vmac.values = vmac.values[|1\m|]
	vmac.varies = `True'
}
end
if (`DEBUG') {
	mata:
	void `listVmacro'(`Vmacro' vmac)
	{
		`RS' 	i

		printf("{txt}   Vmacro rows(values) = %f\n varies=%f fm=%f\n",
			rows(vmac.values), vmac.varies, vmac.forcemissing)
		if (rows(vmac.values)) {
			for (i=1; i<=rows(vmac.values); i++) {
				printf("  %f=|%s|", i, vmac.values[i])
			}
			printf("\n") 
		}
	}
	end
}


/* -------------------------------------------------------------------- */

local Vscalarname	u_mi_ehold_vscalardf
local Vscalar		struct `Vscalarname' scalar
local newVscalar	`Vscalarname'new
local setVscalar	`Vscalarname'set
local updateVscalar	`Vscalarname'update
local postVscalar	`Vscalarname'post
local voidVscalar	`Vscalarname'void
local extendVscalar	`Vscalarname'extend
local listVscalar	`Vscalarname'list
mata:
struct `Vscalarname'
{
    /*  `RS'			lastm  = rows(values)	*/
	`RC'			values
	`boolean'		varies
	`boolean'		forcemissing
}
`Vscalar' `newVscalar'(`boolean' forcemissing)
{
	`Vscalar'	vsca

	vsca.varies       = `False'
	vsca.forcemissing = forcemissing
	return(vsca)
}

void `setVscalar'(`Vscalar' vsca, `SS' name, `RS' m)
{
	pragma unused m
	vsca.values  = st_numscalar(sprintf("e(%s)", name))
	vsca.varies  = `False'
}

void `updateVscalar'(`Vscalar' vsca, `SS' name, `RS' m)
{
	`RS'	value

	if (m==1) `setVscalar'(vsca, name, m)
	else {
		`extendVscalar'(vsca, m-1)
		value = st_numscalar(sprintf("e(%s)", name))
		if (value != vsca.values[1]) vsca.varies = `True'
		vsca.values = vsca.values \ value
	}
}

`boolean' `postVscalar'(`RS' m, `SS' name, `Vscalar' vsca)
{
	`SS'	fullname

	fullname = sprintf("e(%s)", name)

	if (rows(vsca.values)==0) {
		st_global(fullname, "")
		return(`False')
		/*NOTREACHED*/
	}
	if (vsca.varies | vsca.forcemissing) {
		st_numscalar(fullname, .)
		if (vsca.varies) {
			`extendVscalar'(vsca, m)
			st_matrix(sprintf(`VSFMT', name), vsca.values)
			}
		}
	else 	st_numscalar(fullname, vsca.values[1])
	return(vsca.varies)
}

void `voidVscalar'(`Vscalar' vsca, `RS' m)
{
	`extendVscalar'(vsca, m)
}

void `extendVscalar'(`Vscalar' vsca, `RS' m)
{
	if (rows(vsca.values)==m) return

	if (rows(vsca.values) < m) {
		vsca.values = vsca.values \ J(m-rows(vsca.values), 1, .)
	}
	else 	vsca.values = vsca.values[|1\m|]
	vsca.varies = `True'
}
end
if (`DEBUG') {
	mata:
	void `listVscalar'(`Vscalar' vsca)
	{
		`RS' 	i

		printf("{txt}   Vscalar rows(values)=%f varies=%f fm=%f\n", 
			rows(vsca.values), vsca.varies, vsca.forcemissing)
		if (rows(vsca.values)) {
			for (i=1; i<=rows(vsca.values); i++) {
				printf("  %f=%g", i, vsca.values[i])
			}
			printf("\n") 
		}
	}
	end
}

/* -------------------------------------------------------------------- */
	

local Vmatrixname	u_mi_ehold_vmatrixdf
local Vmatrix		struct `Vmatrixname' scalar
local newVmatrix	`Vmatrixname'new
local setVmatrix	`Vmatrixname'set
local updateVmatrix	`Vmatrixname'update
local postVmatrix	`Vmatrixname'post
local voidVmatrix	`Vmatrixname'void
local listVmatrix	`Vmatrixname'list
mata:
struct `Vmatrixname'
{
	`RS'			lastm
	`RS'			minN
	`boolean'		varies
	`boolean'		forcemissing
	`RM'			mat
	`SM'			rowstripe, colstripe
}
`Vmatrix' `newVmatrix'(`boolean' forcemissing)
{
	`Vmatrix'	vmat

	vmat.lastm        = 0
	vmat.minN         = .
	vmat.varies       = `False'
	vmat.forcemissing = forcemissing
	return(vmat)
}  

void `setVmatrix'(`Vmatrix' vmat, `SS' name, `RS' m)
{
	`SS'	fullname

	fullname = sprintf("e(%s)", name)

	vmat.minN      = st_numscalar("e(N)")
	vmat.mat       = st_matrix(fullname)
	vmat.rowstripe = st_matrixrowstripe(fullname)
	vmat.colstripe = st_matrixcolstripe(fullname)
	vmat.lastm     = m
	vmat.varies    = `False'
}

void `updateVmatrix'(`Vmatrix' vmat, `SS' name, `RS' m)
{
	`RM'		mat
	`SS'		fullname
	`boolean'	nofullname

	if (m==1) `setVmatrix'(vmat, name, m)
	else {
		if (!(vmat.varies)) {
			fullname = sprintf("e(%s)", name)
			mat      = st_matrix(fullname)
			if (mat != vmat.mat) vmat.varies = `True'
			nofullname = `False'
		}
		else	nofullname = `True' 

		if (st_numscalar("e(N)") < vmat.minN) {
			if (nofullname) fullname = sprintf("e(%s)", name)
			vmat.minN      = st_numscalar("e(N)")
			vmat.mat       = (nofullname ? st_matrix(fullname) :
					 	       mat)
			vmat.rowstripe = st_matrixrowstripe(fullname)
			vmat.colstripe = st_matrixcolstripe(fullname)
			vmat.lastm     = m
		}
	}
}

`boolean' `postVmatrix'(`RS' m, `SS' name, `Vmatrix' vmat)
{
	`SS' fullname, fullname2

	pragma unused m

	fullname = sprintf("e(%s)", name)
	if (vmat.lastm==0) {
		st_global(fullname, "")
		return(`False')
	}

	if (vmat.varies | vmat.forcemissing) {
		st_matrix(fullname, .)

		fullname2 = sprintf(`VMFMT', name)
		st_matrix(fullname2, vmat.mat)
		if (rows(vmat.rowstripe))
			st_matrixrowstripe(fullname2, vmat.rowstripe)
		if (rows(vmat.colstripe))
			st_matrixcolstripe(fullname2, vmat.colstripe)
	}
	else {
		st_matrix(fullname, vmat.mat)
		if (rows(vmat.rowstripe))
			st_matrixrowstripe(fullname, vmat.rowstripe)
		if (rows(vmat.colstripe))
			st_matrixcolstripe(fullname, vmat.colstripe)
	}
	return(vmat.varies)
}
	
void `voidVmatrix'(`Vmatrix' vmat, `RS' m)
{
	pragma unused m
	vmat.varies = `True'
}

end
if (`DEBUG') {
	mata:
	void `listVmatrix'(`Vmatrix' vmat)
	{
		`RS' 	i
		printf("{txt}   Vmatrix lastm=%f minN=%f varies=%f fm=%f\n", 
			vmat.lastm, vmat.minN, vmat.varies, vmat.forcemissing)

		printf("mat is\n")
		vmat.mat
		printf("rowstripe is\n") 
		vmat.rowstripe
		printf("colstripe is\n") 
		vmat.colstripe
	}
	end
}


mata:
/* -------------------------------------------------------------------- */

`Etime' u_mi_ehold_init()
{
	`Etime'		et

	et.m    = 0 

	et.idx = asarray_create()
	asarray_notfound(et.idx, 0)

	et.ex = J(0, 1, `Ex_none')
	et.p  = J(0, 1, NULL)

	return(et)
}

void u_mi_ehold_free(et)
{
	et = .
}


void u_mi_ehold_set_omit(`Etime' et, `SS' names_to_omit)
{
	`RS'		i
	`SR'		names

	names = tokens(names_to_omit)
	for (i=1; i<=length(names); i++) {
		`Etime_add_element'(et, names[i], `Ex_omitted', NULL)
	}
}


void u_mi_ehold_set_scalar(`Etime' et, `SS' names_to_miss, |`boolean' forcemiss) 
{
	`RS'	i
	`SR'	names

	if (args()==2) forcemiss = `False'

	names = tokens(names_to_miss)
	for (i=1; i<=length(names); i++) {
		`Etime_add_element'(et, names[i], 
				`Ex_Sscalar', &(`newSscalar'(forcemiss)))
	}
}


void u_mi_ehold_set_varying_macro(`Etime' et, `SS' names_to_vary,
						|`boolean' forcemiss) 
{
	`RS'	i
	`SR'	names

	if (args()==2) forcemiss = `False'

	names = tokens(names_to_vary)
	for (i=1; i<=length(names); i++) {
		`Etime_add_element'(et, names[i], 
				`Ex_Vmacro', &(`newVmacro'(forcemiss)))
	}
}


void u_mi_ehold_set_varying_scalar(`Etime' et, `SS' names_to_vary, 
							| `boolean' forcemiss)
{
	`RS'	i
	`SR'	names

	if (args()==2) forcemiss = `False'

	names = tokens(names_to_vary)
	for (i=1; i<=length(names); i++) {
		`Etime_add_element'(et, names[i], 
				`Ex_Vscalar', &(`newVscalar'(forcemiss)))
	}
}


void u_mi_ehold_set_varying_matrix(`Etime' et, `SS' names_to_vary, 
							| `boolean' forcemiss)
{
	`RS'	i
	`SR'	names

	if (args()==2) forcemiss = `False'

	names = tokens(names_to_vary)
	for (i=1; i<=length(names); i++) {
		`Etime_add_element'(et, names[i], 
				`Ex_Vmatrix', &(`newVmatrix'(forcemiss)))
	}
}


void u_mi_ehold_update(`Etime' et)
{
	`RS'	i
	`SC'	els

	(void) ++(et.m)

	els = st_dir("e()", "macro", "*")
	for (i=1; i<=length(els); i++) {
		u_mi_ehold_update_macro(et, els[i])
	}

	els = st_dir("e()", "numscalar", "*")
	for (i=1; i<=length(els); i++) {
		u_mi_ehold_update_scalar(et, els[i])
	}


	els = st_dir("e()", "matrix", "*")
	for (i=1; i<=length(els); i++) {
		u_mi_ehold_update_matrix(et, els[i])
	}
}


void u_mi_ehold_update_macro(`Etime' et, `SS' name)
{
	`RS'		i
	`Excode'	ex
	`PS'		p

	if ((i  = asarray(et.idx, name)) == 0) {
		`Etime_add_element'(et, name, `Ex_Smacro', &(`newSmacro'(0)))
		i = asarray(et.idx, name)
		if (et.m>1) {
			`voidSmacro'(*(et.p[i]), 1)
			return 
			/*NOTREACHED*/
		}
	}

	ex = et.ex[i]
	p  = et.p[i]

	if (ex==`Ex_Smacro') {
		`updateSmacro'(*p, name, et.m)
	}
	else if (ex==`Ex_Vmacro') {
		`updateVmacro'(*p, name, et.m)
	}
	else {
		`voidit'(ex, p, et.m)
	}
}

void u_mi_ehold_update_scalar(`Etime' et, `SS' name)
{
	`RS'		i
	`Excode'	ex
	`PS'		p


	if ((i  = asarray(et.idx, name)) == 0) {
		`Etime_add_element'(et, name, `Ex_Sscalar', &(`newSscalar'(0)))
		i = asarray(et.idx, name)
		if (et.m>1) {
			`voidSscalar'(*(et.p[i]), 1)
			return 
			/*NOTREACHED*/
		}
	}

	ex = et.ex[i]
	p  = et.p[i]

	if (ex==`Ex_Sscalar') {
		`updateSscalar'(*p, name, et.m)
	}
	else if (ex==`Ex_Vscalar') {
		`updateVscalar'(*p, name, et.m)
	}
	else {
		`voidit'(ex, p, et.m)
	}
}

void u_mi_ehold_update_matrix(`Etime' et, `SS' name)
{
	`RS'		i
	`Excode'	ex
	`PS'		p

	if ((i  = asarray(et.idx, name)) == 0) {
		`Etime_add_element'(et, name, `Ex_Smatrix', &(`newSmatrix'(0)))
		i = asarray(et.idx, name)
		if (et.m>1) {
			`voidSmatrix'(*(et.p[i]), 1)
			return 
			/*NOTREACHED*/
		}
	}

	ex = et.ex[i]
	p  = et.p[i]

	if (ex==`Ex_Smatrix') {
		`updateSmatrix'(*p, name, et.m)
	}
	else if (ex==`Ex_Vmatrix') {
		`updateVmatrix'(*p, name, et.m)
	}
	else {
		`voidit'(ex, p, et.m)
	}
}


void `voidit'(`Excode' ex, `PS' p, `RS' m)
{
	if (ex==`Ex_Smacro')         `voidSmacro'(*p, m)
	else if (ex==`Ex_Sscalar')   `voidSscalar'(*p, m)
	else if (ex==`Ex_Smatrix')   `voidSmatrix'(*p, m)
	else if (ex==`Ex_Vmacro')    `voidVmacro'(*p, m)
	else if (ex==`Ex_Vscalar')   `voidVscalar'(*p, m)
	else if (ex==`Ex_Vmatrix')   `voidVmatrix'(*p, m)
}



void u_mi_ehold_post(`Etime' et)
{
	`RS'		i, j
	`SC'		names
	`SS'		vary_l, vary_s, vary_m
	`Excode'	ex
	`PS'		p

	vary_l = vary_s = vary_m = ""
	names = asarray_keys(et.idx)
	for (i=1; i<=rows(names); i++) {
		if ((j = asarray(et.idx, names[i]))) {
			ex = et.ex[j]
			p  = et.p[j]
			if (ex==`Ex_Smacro') {
				if (`postSmacro'(et.m, names[i], *p)) {
					vary_l = vary_l + names[i] + " " 
				}
			}
			else if (ex==`Ex_Sscalar') {
				if (`postSscalar'(et.m, names[i], *p)) {
					vary_s = vary_s + names[i] + " "
				}
			}
			else if (ex==`Ex_Smatrix') {
				if (`postSmatrix'(et.m, names[i], *p)) {
					vary_m = vary_m + names[i] + " "
				}
			}
			else if (ex==`Ex_Vmacro') {
				if (`postVmacro'(et.m, names[i], *p)) {
					vary_l = vary_l + names[i] + " "
				}
			}
			else if (ex==`Ex_Vscalar') {
				if (`postVscalar'(et.m,names[i], *p)) {
					vary_s = vary_s + names[i] + " "
				}
			}
			else if (ex==`Ex_Vmatrix') {
				if (`postVmatrix'(et.m, names[i], *p)) {
					vary_m = vary_m + names[i] + " "
				}
			}
		}
	}
	if (vary_l != "") st_global(`VLNAME', strrtrim(vary_l))
	if (vary_s != "") st_global(`VSNAME', strrtrim(vary_s))
	if (vary_m != "") st_global(`VMNAME', strrtrim(vary_m))
}
end

if (`DEBUG') {
	mata:
	void debug_list_et(`Etime' et)
	{
		`RS'	i, j
		`SC'	names

		printf("{hline}\n")
		printf("m = %g\n", et.m)
		printf("rows(ex)   = %g\n", rows(et.ex))
		printf("rows(p)    = %g\n", rows(et.ex))
		printf("els of idx = %g\n", asarray_elements(et.idx))

		names = sort(asarray_keys(et.idx), 1)
		for (i=1; i<=length(names); i++) {
			j = asarray(et.idx, names[i])
			printf("{txt}%f. %s ex=%f", j, names[i], et.ex[j])
			et.p[j]
			debug_list_mbr(et.ex[j], et.p[j])
			printf("{txt}\n") 
		}
		printf("{hline}\n")
	}

	void debug_list_mbr(`Excode' ex, `PS' p)
	{
		if (ex==`Ex_Smacro') 	`listSmacro'(*p)
		if (ex==`Ex_Sscalar') 	`listSscalar'(*p)
		if (ex==`Ex_Smatrix') 	`listSmatrix'(*p)
		if (ex==`Ex_Vmacro') 	`listVmacro'(*p)
		if (ex==`Ex_Vscalar') 	`listVscalar'(*p)
		if (ex==`Ex_Vmatrix') 	`listVmatrix'(*p)
	}
	end
}

