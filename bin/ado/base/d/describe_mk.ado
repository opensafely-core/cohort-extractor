*! version 1.0.1  21feb2013

program describe_mk, rclass
	version 11
	syntax [varlist], [CLEAR REPLACE]

	// option -replace- used by caller; ignored here

	if ("`clear'"=="" & c(changed)) {
		di as err "no; data in memory would be lost"
		di as err "{p 4 4 2}"
		di as err "Specify {bf:describe} ...{bf:, replace clear} to"
		di as err "perform the command anyway."
		di as err "{p_end}"
		exit 4
		/*NOTREACHED*/
	}

	local N = _N
	local filedate `"`c(filedate)'"'
	local filename `"`c(filename)'"'
	mata: get_filename_to_display("filename_to_display", `"`filename'"')
	if (_N & c(k)) {
		mata: get_firstvar("firstvar")
		quietly describe `firstvar', varlist
		local sortedby `"`r(sortlist)'"'
	}

	mata: describe_mk("varlist")
	if (_N) {
		sort position
	}
	char _dta[d_sortedby] `"`sortedby'"'
	char _dta[d_N]        `N'
	char _dta[d_filedate] `"`filedate'"'
	char _dta[d_filename] `"`filename'"'

	label var position  "variable number"
	label var name      "variable name"
	label var type      "storage type"
	label var isnumeric "whether numeric or string"
	label var format    "display format"
	label var varlab    "variable label"
	label var vallab    "value label name"
	label data         `"describe `filename_to_display'"'
end

/* -------------------------------------------------------------------- */
version 11
local RS	real scalar
local RR	real rowvector
local RC	real colvector

local SS	string scalar
local SR	string rowvector
local SC	string colvector

local Info	struct vninfodf scalar


mata:

struct vninfodf {
	`RS'	position
	`SC'	name
	`SC'	type
	`RC'	isnumeric
	`SC'	fmt
	`SC'	vallab
	`SC'	varlab

	`RS'	N
}
	

/* -------------------------------------------------------------------- */
void describe_mk(`SS' varlist_mac)
{
	`Info'	in

	init_info(in)
	set_info(in, st_local(varlist_mac))
	post_info_to_data(in)
}


/* -------------------------------------------------------------------- */
void init_info(`Info' in)
{
	in.N        = st_nobs()
}


void set_info(`Info' in, `SS' varlist)
{
	`RS'	i, j, n
	`SR'	names
	`RR'	idx

	if (varlist == "") {
		set_info_u(in, n=st_nvar())
		for (i=1; i<=n; i++) set_info_var(in, i, i)
	}
	else {
		names = tokens(varlist)
		idx   = st_varindex(names, 0)
		n     = cols(names)

		set_info_u(in, n)
		for (j=1; j<=n; j++) set_info_var(in, j, idx[j])
	}
}


void set_info_u(`Info' in, `RS' n)
{
	in.position = in.isnumeric = J(n, 1, .)
	in.name     = in.type = in.fmt = in.vallab = in.varlab = J(n, 1, "")
}


void set_info_var(`Info' in, `RS' j, `RS' i)
{
	in.position[j]  = i
	in.name[j]      = st_varname(i)
	in.type[j]      = st_vartype(i)
	in.isnumeric[j] = st_isnumvar(i)
	in.fmt[j]       = st_varformat(i)
	in.vallab[j]    = st_varvaluelabel(i)
	in.varlab[j]    = strrtrim(st_varlabel(i))
}
	


/* -------------------------------------------------------------------- */
void post_info_to_data(`Info' in)
{
	`RS'	n

	st_dropvar(.)
	(void) st_addvar("int",              "position")
	(void) st_addvar(strtype(in.name),   "name")
	(void) st_addvar(strtype(in.type),   "type")
	(void) st_addvar("byte",             "isnumeric")
	(void) st_addvar(strtype(in.fmt),    "format")
	(void) st_addvar(strtype(in.vallab), "vallab")
	(void) st_addvar(strtype(in.varlab), "varlab")

	if ((n = rows(in.position))) {
		st_addobs(n)
		st_store( ., "position", in.position)
		st_sstore(., "name",     in.name)
		st_sstore(., "type",     in.type)
		st_store( ., "isnumeric",in.isnumeric)
		st_sstore(., "format",   in.fmt)
		st_sstore(., "vallab",   in.vallab)
		st_sstore(., "varlab",   in.varlab)
	}
}

`SS' strtype(`SC' strvector)
{
	`RS'	maxl
	`RS'	l

	maxl = c("maxstrvarlen")
	l = colmax(strlen(strvector))
	if (l==0 | l==.) l = 1
	else if (l>maxl)  l = maxl

	return(sprintf("str%f", l))
}

void get_firstvar(`SS' macname) st_local(macname, st_varname(1))

void get_filename_to_display(`SS' macname, `SS' filename)
{
	st_local(macname, (strtrim(filename)=="") ? 
			 "<unnamed>" : pathbasename(filename))
}

end
