{smcl}
{* *! version 1.1.11  09may2019}{...}
{vieweralsosee "[M-4] Stata" "mansection M-4 Stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_stata##contents"}{...}
{viewerjumpto "Description" "m4_stata##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_stata##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_stata##remarks"}{...}
{viewerjumpto "Reference" "m4_stata##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-4] Stata} {hline 2}}Stata interface functions
{p_end}
{p2col:}({mansection M-4 Stata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 22}Function{col 40}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 16}{c TRC}
{col 5}{hline 3}{c RT}{it: Access to data }{c LT}{hline}
{col 5}   {c BLC}{hline 16}{c BRC}

{col 5}{bf:{help mf_st_nvar:st_nvar()}}{...}
{col 22}{cmd:st_nvar()}{...}
{col 40}number of variables
{col 22}{cmd:st_nobs()}{...}
{col 40}number of observations

{col 5}{bf:{help mf_st_data:st_data()}}{...}
{col 22}{cmd:st_data()}{...}
{col 40}load numeric data from Stata into matrix
{col 22}{cmd:st_sdata()}{...}
{col 40}load string data from Stata into matrix

{col 5}{bf:{help mf_st_store:st_store()}}{...}
{col 22}{cmd:st_store()}{...}
{col 40}store numeric data in Stata dataset
{col 22}{cmd:st_sstore()}{...}
{col 40}store string data in Stata dataset

{col 5}{bf:{help mf_st_view:st_view()}}{...}
{col 22}{cmd:st_view()}{...}
{col 40}make view onto Stata dataset
{col 22}{cmd:st_sview()}{...}
{col 40}same; string variables

{col 5}{bf:{help mf_st_subview:st_subview()}}{...}
{col 22}{cmd:st_subview()}{...}
{col 40}make view from view

{col 5}{bf:{help mf_st_viewvars:st_viewvars()}}{...}
{col 22}{cmd:st_viewvars()}{...}
{col 40}identify variables and observations 
{col 22}{cmd:st_viewobs()}{...}
{col 40}corresponding to view

{col 5}   {c TLC}{hline 26}{c TRC}
{col 5}{hline 3}{c RT}{it: Variable names & indices }{c LT}{hline}
{col 5}   {c BLC}{hline 26}{c BRC}

{col 5}{bf:{help mf_st_varindex:st_varindex()}}{...}
{col 22}{cmd:st_varindex()}{...}
{col 40}variable indices from variable names

{col 5}{bf:{help mf_st_varname:st_varname()}}{...}
{col 22}{cmd:st_varname()}{...}
{col 40}variable names from variable indices

{col 5}   {c TLC}{hline 26}{c TRC}
{col 5}{hline 3}{c RT}{it: Variable characteristics }{c LT}{hline}
{col 5}   {c BLC}{hline 26}{c BRC}

{col 5}{bf:{help mf_st_varrename:st_varrename()}}{...}
{col 22}{cmd:st_varrename()}{...}
{col 40}rename Stata variable

{col 5}{bf:{help mf_st_vartype:st_vartype()}}{...}
{col 22}{cmd:st_vartype()}{...}
{col 40}storage type of Stata variable
{col 22}{cmd:st_isnumvar()}{...}
{col 40}whether variable is numeric
{col 22}{cmd:st_isstrvar()}{...}
{col 40}whether variable is string

{col 5}{bf:{help mf_st_varformat:st_varformat()}}{...}
{col 22}{cmd:st_varformat()}{...}
{col 40}obtain/set format of Stata variable
{col 22}{cmd:st_varlabel()}{...}
{col 40}obtain/set variable label
{col 22}{cmd:st_varvaluelabel()}{...}
{col 40}obtain/set value label

{col 5}{bf:{help mf_st_vlexists:st_vlexists()}}{...}
{col 22}{cmd:st_vlexists()}{...}
{col 40}whether value label exists
{col 22}{cmd:st_vldrop()}{...}
{col 40}drop value 
{col 22}{cmd:st_vlmap()}{...}
{col 40}map values 
{col 22}{cmd:st_vlsearch()}{...}
{col 40}map text 
{col 22}{cmd:st_vlload()}{...}
{col 40}load value label
{col 22}{cmd:st_vlmodify()}{...}
{col 40}create or modify value label

{col 5}   {c TLC}{hline 45}{c TRC}
{col 5}{hline 3}{c RT}{it: Temporary variables & time-series operators }{c LT}{hline}
{col 5}   {c BLC}{hline 45}{c BRC}

{col 5}{bf:{help mf_st_tempname:st_tempname()}}{...}
{col 22}{cmd:st_tempname()}{...}
{col 40}temporary variable name
{col 22}{cmd:st_tempfilename()}{...}
{col 40}temporary filename

{col 5}{bf:{help mf_st_tsrevar:st_tsrevar()}}{...}
{col 22}{cmd:st_tsrevar()}{...}
{col 40}create time-series op.varname
{col 22}{cmd:_st_tsrevar()}{...}
{col 40}same

{col 5}   {c TLC}{hline 44}{c TRC}
{col 5}{hline 3}{c RT}{it: Adding & removing variables & observations }{c LT}{hline}
{col 5}   {c BLC}{hline 44}{c BRC}

{col 5}{bf:{help mf_st_addobs:st_addobs()}}{...}
{col 22}{cmd:st_addobs()}{...}
{col 40}add observations to Stata dataset

{col 5}{bf:{help mf_st_addvar:st_addvar()}}{...}
{col 22}{cmd:st_addvar()}{...}
{col 40}add variable to Stata dataset

{col 5}{bf:{help mf_st_dropvar:st_dropvar()}}{...}
{col 22}{cmd:st_dropvar()}{...}
{col 40}drop variables
{col 22}{cmd:st_dropobsin()}{...}
{col 40}drop specified observations
{col 22}{cmd:st_dropobsif()}{...}
{col 40}drop selected observations
{col 22}{cmd:st_keepvar()}{...}
{col 40}keep variables
{col 22}{cmd:st_keepobsin()}{...}
{col 40}keep specified observations
{col 22}{cmd:st_keepobsif()}{...}
{col 40}keep selected observations

{col 5}{bf:{help mf_st_updata:st_updata()}}{...}
{col 22}{cmd:st_updata()}{...}
{col 40}query/set data-have-changed flag

{col 5}   {c TLC}{hline 26}{c TRC}
{col 5}{hline 3}{c RT}{it: Executing Stata commands }{c LT}{hline}
{col 5}   {c BLC}{hline 26}{c BRC}

{col 5}{bf:{help mf_stata:stata()}}{...}
{col 22}{cmd:stata()}{...}
{col 40}execute Stata command

{col 5}{bf:{help mf_st_macroexpand:st_macroexpand()}}{...}
{col 22}{cmd:st_macroexpand()}{...}
{col 40}expand Stata macros

{col 5}   {c TLC}{hline 49}{c TRC}
{col 5}{hline 3}{c RT}{it: Accessing e(), r(), s(), macros, matrices, etc. }{c LT}{hline}
{col 5}   {c BLC}{hline 49}{c BRC}

{col 5}{bf:{help mf_st_global:st_global()}}{...}
{col 22}{cmd:st_global()}{...}
{col 40}obtain/set Stata global
{col 22}{cmd:st_global_hcat()}{...}
{col 40}obtain hidden/historical status

{col 5}{bf:{help mf_st_local:st_local()}}{...}
{col 22}{cmd:st_local()}{...}
{col 40}obtain/set local Stata macro

{col 5}{bf:{help mf_st_numscalar:st_numscalar()}}{...}
{col 22}{cmd:st_numscalar()}{...}
{col 48}obtain/set Stata numeric scalar
{col 22}{cmd:st_numscalar_hcat()}{...}
{col 48}obtain hidden/historical status
{col 22}{cmd:st_strscalar()}{...}
{col 48}obtain/set Stata string scalar

{col 5}{bf:{help mf_st_matrix:st_matrix()}}{...}
{col 22}{cmd:st_matrix()}{...}
{col 48}obtain/set Stata matrix
{col 22}{cmd:st_matrix_hcat()}{...}
{col 48}obtain hidden/historical status
{col 22}{cmd:st_matrixrowstripe()}{...}
{col 48}obtain/set row labels
{col 22}{cmd:st_matrixcolstripe()}{...}
{col 48}obtain/set column labels
{col 22}{cmd:st_replacematrix()}{...}
{col 48}replace existing Stata matrix

{* do not add to manual; this is an undocumented help file only}{...}
{col 5}{bf:{help mf_st_lchar:st_lchar()}}{...}
{col 22}{cmd:st_lchar()}{...}
{col 40}obtain/set "long" characteristics
{col 22}{cmd:ado_intolchar()}{...}
{col 40}set long characteristic from ado
{col 22}{cmd:ado_fromlchar()}{...}
{col 40}obtain long characteristic from ado

{col 5}{bf:{help mf_st_dir:st_dir()}}{...}
{col 22}{cmd:st_dir()}{...}
{col 40}obtain list of Stata objects

{col 5}{bf:{help mf_st_rclear:st_rclear()}}{...}
{col 22}{cmd:st_rclear()}{...}
{col 40}clear {cmd:r()}
{col 22}{cmd:st_eclear()}{...}
{col 40}clear {cmd:e()}
{col 22}{cmd:st_sclear()}{...}
{col 40}clear {cmd:s()}

{col 5}   {c TLC}{hline 24}{c TRC}
{col 5}{hline 3}{c RT}{it: Parsing & verification} {c LT}{hline}
{col 5}   {c BLC}{hline 24}{c BRC}

{col 5}{bf:{help mf_st_isname:st_isname()}}{...}
{col 22}{cmd:st_isname()}{...}
{col 40}whether valid Stata name
{col 22}{cmd:st_islmname()}{...}
{col 40}whether valid local macro name

{col 5}{bf:{help mf_st_isfmt:st_isfmt()}}{...}
{col 22}{cmd:st_isfmt()}{...}
{col 40}whether valid {cmd:%}{it:fmt}
{col 22}{cmd:st_isnumfmt()}{...}
{col 40}whether valid numeric {cmd:%}{it:fmt}
{col 22}{cmd:st_isstrfmt()}{...}
{col 40}whether valid string {cmd:%}{it:fmt}

{col 5}{bf:{help mf_abbrev:abbrev()}}{...}
{col 22}{cmd:abbrev()}{...}
{col 40}abbreviate strings

{col 5}{bf:{help mf_strtoname:strtoname()}}{...}
{col 22}{cmd:strtoname()}{...}
{col 40}translate strings to Stata names

{col 5}   {c TLC}{hline 13}{c TRC}
{col 5}{hline 3}{c RT}{it: Data frames }{c LT}{hline}
{col 5}   {c BLC}{hline 13}{c BRC}

{col 5}{bf:{help mf_st_frame:st_frame*()}}{...}
{col 22}{cmd:st_framecurrent()}{...}
{col 40}return or change current frame
{col 22}{cmd:st_framecreate()}{...}
{col 40}make new frame
{col 22}{cmd:st_framedrop()}{...}
{col 40}drop (eliminate) existing frame
{col 22}{cmd:st_framedropabc()}{...}
{col 40}drop all but current frame
{col 22}{cmd:st_framerename()}{...}
{col 40}rename frame
{col 22}{cmd:st_framecopy()}{...}
{col 40}copy contents of one frame to another
{col 22}{cmd:st_framereset()}{...}
{col 40}reset to empty {cmd:default} frame
{col 22}{cmd:st_frameexists()}{...}
{col 40}whether frame name already exists
{col 22}{cmd:st_framedir()}{...}
{col 40}obtain vector of existing frame names
{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions interface with Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 StataRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The following manual entries have to do with getting data from or putting 
data into Stata:

{p2colset 9 30 32 2}{...}
	{bf:{help mf_st_data:[M-5] st_data()}}      Load copy of current Stata dataset
{p2col:{bf:{help mf_st_view:[M-5] st_view()}}}Make matrix that is a view onto current Stata dataset{p_end}
	{bf:{help mf_st_store:[M-5] st_store()}}     Modify values stored in current Stata dataset
	{bf:{help mf_st_nvar:[M-5] st_nvar()}}      Numbers of variables and observations

{p 4 4 2}
In some cases, you may find yourself needing to translate variable names
into variable indices and vice versa:

	{bf:{help mf_st_varname:[M-5] st_varname()}}   Obtain variable names from variable indices
	{bf:{help mf_st_varindex:[M-5] st_varindex()}}  Obtain variable indices from variable names
	{bf:{help mf_st_tsrevar:[M-5] st_tsrevar()}}   Create time-series op.varname variables

{p 4 4 2}
The other functions mostly have to do with getting and putting Stata's 
scalars, matrices, and returned results:

	{bf:{help mf_st_local:[M-5] st_local()}}     Obtain strings from and put strings into Stata
{p2col:{bf:{help mf_st_global:[M-5] st_global()}}}Obtain strings from and put strings into global macros{p_end}
{p2col:{bf:{help mf_st_numscalar:[M-5] st_numscalar()}}}Obtain values from and put values into Stata scalars{p_end}
	{bf:{help mf_st_matrix:[M-5] st_matrix()}}    Obtain and put Stata matrices

{p 4 4 2}
The {cmd:stata()} function, documented in 

	{bf:{help mf_stata:[M-5] stata()}}        Execute Stata command

{p 4 4 2}
allows you to cause Stata to execute a command that you construct in a 
string.
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2008.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0040":Mata Matters: Macros}.
{it:Stata Journal} 8: 401-412.
{p_end}
