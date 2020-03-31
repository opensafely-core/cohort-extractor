{smcl}
{* *! version 1.2.4  11may2018}{...}
{vieweralsosee "[MI] Technical" "mansection MI Technical"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{viewerjumpto "Description" "mi_technical##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_technical##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_technical##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] Technical} {hline 2}}Details for programmers{p_end}
{p2col:}({mansection MI Technical:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
Technical information for programmers who wish to extend 
{cmd:mi} is provided below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI TechnicalRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

        {help mi_technical##notation:Notation}
	{help mi_technical##styles:Definition of styles}
	    {help mi_technical##style_all:Style all}
	    {help mi_technical##style_wide:Style wide}
	    {help mi_technical##style_mlong:Style mlong}
	    {help mi_technical##style_flong:Style flong}
	    {help mi_technical##style_flongsep:Style flongsep}
	    {help mi_technical##style_flongsep_sub:Style flongsep_sub}
	{help mi_technical##newcmd:Adding new commands to mi}
	{help mi_technical##outline:Outline for new commands}
	{help mi_technical##utility:Utility routines}
	    {help mi_technical##assert_set:u_mi_assert_set}
	    {help mi_technical##certify:u_mi_certify_data}
	    {help mi_technical##no_sys_vars:u_mi_no_sys_vars and u_mi_no_wide_vars}
	    {help mi_technical##zap_chars:u_mi_zap_chars}

	    {help mi_technical##xeq:u_mi_xeq_on_tmp_flongsep}
	    {help mi_technical##tmp:u_mi_get_flongsep_tmpname}
	    {help mi_technical##erase:mata: u_mi_flongsep_erase()}

	    {help mi_technical##sortback:u_mi_sortback}
	    {help mi_technical##use:u_mi_save and u_mi_use}
	    {help mi_technical##swap:mata: u_mi_wide_swapvars()}

	    {help mi_technical##fixchars:u_mi_fixchars}
	    {help mi_technical##cpchars:mata: u_mi_cpchars_get() and mata: u_mi_cpchars_put()}
	    {help mi_technical##instvar:mata: u_mi_get_mata_instanced_var()}

	    {help mi_technical##ptrace:mata: u_mi_ptrace_*()}

	{help mi_technical##xxxset:How to write other set commands to work with mi}


{marker notation}{...}
{title:Notation}

{col 9}{it:M} = {it:#} of imputations 

{col 9}{it:m} = imputation number
{col 9}          0.  original data with missing values
{col 9}          1.  first imputation dataset 
{col 9}           .  
{col 9}           .  
{col 9}          {it:M}.  last imputation dataset

{col 9}{it:N} = number of obs. in {it:m}=0


{marker styles}{...}
{title:Definition of styles}

{p 4 4 2}
Style describes how the {cmd:mi} data are stored.
There are four styles:
{help mi_technical##style_wide:wide},
{help mi_technical##style_mlong:mlong},
{help mi_technical##style_flong:flong}, and 
{help mi_technical##style_flongsep:flongsep}.


{marker style_all}{...}
    {title:Style all}

{col 9}Characteristics:
{col 13}{cmd:_dta[_mi_marker]}{...}
{col 35}"{cmd:_mi_ds_1}"

{p 8 8 2}
Description:
{cmd:_dta[_mi_marker]} is set with all styles, including {cmd:flongsep_sub}.
The definitions below apply only if 
{cmd:"`_dta[_mi_marker]'"} = 
{cmd:"_mi_ds_1"}.



{marker style_wide}{...}
    {title:Style wide}

{col 9}Characteristics:
{col 13}{cmd:_dta[_mi_style]}{...}
{col 35}"{cmd:wide}"
{col 13}{cmd:_dta[_mi_M]}{...}
{col 35}{it:M}
{col 13}{cmd:_dta[_mi_ivars]}{...}
{col 35}imputed variables; variable list
{col 13}{cmd:_dta[_mi_pvars]}{...}
{col 35}passive variables; variable list
{col 13}{cmd:_dta[_mi_rvars]}{...}
{col 35}regular variables; variable list
{col 13}{cmd:_dta[_mi_update]}{...}
{col 35}time last updated; {cmd:%tc}_value/1000

{col 9}Variables:
{col 13}{cmd:_mi_miss}{...}
{col 35}whether incomplete; 0 or 1
{col 13}{cmd:_}{it:#}{cmd:_}{it:varname}{...}
{col 35}{it:varname} for {it:m}={it:#}, defined for each
{col 37}{cmd:`_dta[_mi_ivars]'} and {cmd:`_dta[_mi_pvars]'}

{p 8 8 2}
Description:
    {it:m}=0, {it:m}=1, ..., {it:m}={it:M} are stored
    in one dataset with {it:_N} = {it:N} observations.  Each imputed and
    passive variable has {it:M} additional variables associated with it.
    If variable {cmd:bp} contains the values in {it:m}=0, then
    values for {it:m}=1 are contained in variable {cmd:_1_bp},
    values for {it:m}=2 in {cmd:_2_bp}, and so on.
    {cmd:wide} stands for {it:wide}.


{marker style_mlong}{...}
    {title:Style mlong}

{col 9}Characteristics:
{col 13}{cmd:_dta[_mi_style]}{...}
{col 35}"{cmd:mlong}"
{col 13}{cmd:_dta[_mi_M]}{...}
{col 35}{it:M}
{col 13}{cmd:_dta[_mi_N]}{...}
{col 35}{it:N}
{col 13}{cmd:_dta[_mi_n]}{...}
{col 35}{it:#} of obs. in marginal 
{col 13}{cmd:_dta[_mi_ivars]}{...}
{col 35}imputed variables; variable list
{col 13}{cmd:_dta[_mi_pvars]}{...}
{col 35}passive variables; variable list
{col 13}{cmd:_dta[_mi_rvars]}{...}
{col 35}regular variables; variable list
{col 13}{cmd:_dta[_mi_update]}{...}
{col 35}time last updated; {cmd:%tc}_value/1000

{col 9}Variables:
{col 13}{cmd:_mi_m}{...}
{col 35}{it:m};  0, 1, ..., {it:M}
{col 13}{cmd:_mi_id}{...}
{col 35}ID; 1, ..., {it:N}
{col 13}{cmd:_mi_miss}{...}
{col 35}whether incomplete; 0 or 1 if {cmd:_mi_m}=0, else {cmd:.}

{p 8 8 2}
Description:
    {it:m=0}, {it:m=1}, ..., {it:m}={it:M} are stored
    in one dataset with {it:_N} = {bind:{it:N} + {it:M}*{it:n}}
    observations,
    where {it:n} is the number of incomplete observations in {it:m}=0.
    {cmd:mlong} stands for {it:marginal long}.


{marker style_flong}{...}
    {title:Style flong}

{col 9}Characteristics:
{col 13}{cmd:_dta[_mi_style]}{...}
{col 35}"{cmd:flong}"
{col 13}{cmd:_dta[_mi_M]}{...}
{col 35}{it:M}
{col 13}{cmd:_dta[_mi_N]}{...}
{col 35}{it:N}
{col 13}{cmd:_dta[_mi_ivars]}{...}
{col 35}imputed variables; variable list
{col 13}{cmd:_dta[_mi_pvars]}{...}
{col 35}passive variables; variable list
{col 13}{cmd:_dta[_mi_rvars]}{...}
{col 35}regular variables; variable list
{col 13}{cmd:_dta[_mi_update]}{...}
{col 35}time last updated; {cmd:%tc}_value/1000

{col 9}Variables:
{col 13}{cmd:_mi_m}{...}
{col 35}{it:m};  0, 1, ..., {it:M}
{col 13}{cmd:_mi_id}{...}
{col 35}ID; 1, ..., {it:N}
{col 13}{cmd:_mi_miss}{...}
{col 35}whether incomplete; 0 or 1 if {cmd:_mi_m}=0, else {cmd:.}

{p 9 9 2}
Description:
    {it:m}=0, {it:m}=1, ..., {it:m}={it:M} are stored
    in one dataset with {it:_N} = {bind:{it:N} + {it:M}*{it:N}}
    observations, where
    {it:N} is the number of observations in {it:m}=0.
    {cmd:flong} stands for {it:full long}.


{marker style_flongsep}{...}
    {title:Style flongsep}

{col 9}Characteristics:
{col 13}{cmd:_dta[_mi_style]}{...}
{col 35}"{cmd:flongsep}"
{col 13}{cmd:_dta[_mi_name]}{...}
{col 35}{it:name}
{col 13}{cmd:_dta[_mi_M]}{...}
{col 35}{it:M}
{col 13}{cmd:_dta[_mi_N]}{...}
{col 35}{it:N}
{col 13}{cmd:_dta[_mi_ivars]}{...}
{col 35}imputed variables; variable list
{col 13}{cmd:_dta[_mi_pvars]}{...}
{col 35}passive variables; variable list
{col 13}{cmd:_dta[_mi_rvars]}{...}
{col 35}regular variables; variable list
{col 13}{cmd:_dta[_mi_update]}{...}
{col 35}time last updated; {cmd:%tc}_value/1000

{col 9}Variables:
{col 13}{cmd:_mi_id}{...}
{col 35}ID; 1, ..., {it:N}
{col 13}{cmd:_mi_miss}{...}
{col 35}whether incomplete; 0 or 1


{p 8 8 2}
Description:
    {it:m}=0, {it:m=1}, ..., {it:m}={it:M} are each separate
    {cmd:.dta} datasets.  If {it:m}=0 data are stored
    in {cmd:pat.dta}, then {it:m}=1 data are stored in {cmd:_1_pat.dta},
    {it:m}=2 in {cmd:_2_pat.dta}, and so on.

{p 8 8 2}
    The definitions above apply only to {it:m}=0, the dataset 
    named {cmd:`_dta[_mi_name]'.dta}.
    See {it:{help mi_technical##style_flongsep_sub:flongsep_sub}} directly
    below for {it:m}>0.
    {cmd:flongsep} stands for {it:full long and separate}.


{marker style_flongsep_sub}{...}
    {title:Style flongsep_sub}

{col 9}Characteristics:
{col 13}{cmd:_dta[_mi_style]}{...}
{col 35}"{cmd:flongsep_sub}"
{col 13}{cmd:_dta[_mi_name]}{...}
{col 35}{it:name}
{col 13}{cmd:_dta[_mi_m]}{...}
{col 35}{it:m};  0, 1, ..., {it:M}

{col 9}Variables:
{col 13}{cmd:_mi_id}{...}
{col 35}ID; 1, ..., {it:N}

{p 8 8 2}
Description:  The description above applies to the datasets
{cmd:_`_dta[_mi_m]'_`_dta[_mi_name]'.dta}.  There are {it:M} 
such datasets recording {it:m}=1, ..., {it:M} used by the 
{cmd:flongsep} style directly above.


{marker newcmd}{...}
{title:Adding new commands to mi}

{p 4 4 2}
New commands are written in ado.  
Name the new command {cmd:mi_cmd_}{it:newcmd} and store it 
in 
{cmd:mi_cmd_}{it:newcmd}{cmd:.ado}.  When the user types 
{cmd:mi} {it:newcmd} ..., {cmd:mi_cmd_}{it:newcmd}{cmd:.ado} will be executed.

{pstd}
See {mansection P programpropertiesRemarksandexamplesWritingprogramsforusewithmi:{it:Writing programs for use with mi}} of [P] {bf:program properties}
for details on how to write estimation commands for use with the
{cmd:mi estimate} prefix.


{marker outline}{...}
{title:Outline for new commands}

	{cmd:program} {cmd:mi_cmd_}{it:newcmd}{cmd:, rclass}{right:(1)    }
		{cmd:version {ccl stata_version}}

		{cmd:u_mi_assert_set}{right:(2)    }

		{cmd:syntax} ... {cmd:[,} ... {cmd:noUPdate} ...{cmd:]}{right:(3)    }

		...

		{cmd:u_mi_certify_data, acceptable}{right:(4)    }

		...

		{cmd:if ("`update'"=="") {c -(}}
			{cmd:u_mi_certify_data, proper}{right:(5)    }
		{cmd:{c )-}}

		...
	{cmd:end}

{p 4 4 2}
Notes:

{p 8 12 2}
1.  The command may be {cmd:rclass}; that is not required.
    It may be {cmd:eclass} instead if you wish.

{p 8 12 2}
2.  {cmd:u_mi_assert_set} verifies that the data are {cmd:mi} data;
    see {it:{help mi_technical##assert_set:u_mi_assert_set}} below.

{p 8 12 2}
3.  If you intend for your command to use {cmd:mi} {cmd:update} to update 
    the data before performing its intended task, include a
    {cmd:noupdate} option; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.  
    Some commands instead or in addition run {cmd:mi} {cmd:update} 
    to perform cleanup 
    after performing their task.  Such use does not require a 
    {cmd:noupdate} option.

{p 8 12 2}
4.  {cmd:u_mi_certify_data} is the internal routine that performs
    {cmd:mi} {cmd:update}.  An update is divided into two parts, called
    acceptable and proper.  All commands should verify that the data are
    acceptable; see {it:{help mi_technical##certify:u_mi_certify_data}} below.

{p 8 12 2}
5.  {cmd:u_mi_certify_data,} {cmd:proper} performs the second step of 
    {cmd:mi} {cmd:update}; 
    it verifies that acceptable data are proper.  Whether you verify 
    properness is up to you, but if you do, you are supposed to include 
    a {cmd:noupdate} option to skip running the check.


{marker utility}{...}
{title:Utility routines}

{p 4 4 2}
The only information you absolutely need to know is that 
already revealed.
Using the utility routines described below,
however, will simplify your programming task and make your code
appear more professional to the end user.

{p 4 4 2}
As you read what follows, remember that 
you may review the source code for the routines by using 
{bf:{help viewsource:viewsource}}.
If you wanted to see the source for {cmd:u_mi_assert_set}, you would
type {cmd:viewsource} {cmd:u_mi_assert_set.ado}.
If you do this, you will sometimes see
that the routines allow options not 
documented below.  Ignore those options; they may not appear in 
future releases.

{p 4 4 2}
Using {cmd:viewsource}, you may also review examples of the utility 
commands being used by viewing the source of the 
{cmd:mi} commands we have written.  Each {cmd:mi} command appears in 
the file {cmd:mi_cmd_}{it:command}{cmd:.ado}.  Also remember 
that other {cmd:mi} commands make useful utility routines.  For 
instance, if your new command makes passive variables, 
use {cmd:mi} {cmd:register} to register them.  Always call existing 
{cmd:mi} commands through {cmd:mi}; code 
{cmd:mi} {cmd:passive} and not {cmd:mi_cmd_passive}.


{marker assert_set}{...}
    {title:u_mi_assert_set}

{p 8 12 2}
{cmd:u_mi_assert_set}
[{it:desired_style}]

{p 4 4 2}
This utility verifies that data are {cmd:mi} and optionally of the desired 
style; it issues the appropriate error message and stops 
execution if not. 
The optional argument 
{it:desired_style} can be {cmd:wide}, {cmd:mlong}, {cmd:flong}, or 
{cmd:flongsep}, but is seldom specified.  When not specified, any style 
is allowed.


{marker certify}{...}
{title:u_mi_certify_data}

{p 8 40 2}
{cmd:u_mi_certify_data}
[{cmd:,}
{cmd:acceptable}
{cmd:proper}
{cmdab:noup:date}
{cmd:sortok}
]

{p 4 4 2}
This command performs {cmd:mi} {cmd:update}.  {cmd:mi} {cmd:update} 
is equivalent to {cmd:u_mi_certify_data,} {cmd:acceptable} {cmd:proper}
{cmd:sortok}.  

{p 4 4 2}
Specify one or both of {cmd:acceptable} and {cmd:proper}.  If the 
{cmd:noupdate} option is specified, then {cmd:proper} is specified. 
The {cmd:sortok} option specifies that {cmd:u_mi_certify_data} need
not spend extra time to preserve and restore the original sort order of the
data.

{p 4 4 2}
An update is divided into two parts.
In the first part, called acceptable, {it:m}=0 and the 
{cmd:_dta[_mi_*]} characteristics are certified.
Your program will use the information recorded in those characteristics, and
before that information can be trusted, the data must be certified as
acceptable.
Do not trust any {cmd:_dta[_mi_*]} characteristics until you have 
run {cmd:u_mi_certify_data,} {cmd:acceptable}.

{p 4 4 2}
{cmd:u_mi_certify_data,} {cmd:proper} verifies that data known to be 
acceptable are proper.  In practice, this means that 
in addition to trusting {cmd:m}=0, you can trust {cmd:m}>0.

{p 4 4 2}
Running 
{cmd:u_mi_certify_data,} {cmd:acceptable}
might actually result in the data being certified as proper, 
although you cannot depend on 
that.  When you run 
{cmd:u_mi_certify_data,} {cmd:acceptable}
and 
certain problems are observed in {it:m}=0, they are fixed in 
all {it:m}, which can lead to other problems being detected, and 
by the time the whole process is through, the data are proper.


{marker no_sys_vars}
{title:u_mi_no_sys_vars and u_mi_no_wide_vars}

{p 8 12 2}
{cmd:u_mi_no_sys_vars}{bind: }
{cmd:"}{it:variable_list}{cmd:"}
[{cmd:"}{it:word}{cmd:"}]

{p 8 12 2}
{cmd:u_mi_no_wide_vars}
{cmd:"}{it:variable_list}{cmd:"}
[{cmd:"}{it:word}{cmd:"}]

{p 4 4 2}
These routines are for use in parsing user input.

{p 4 4 2}
{cmd:u_mi_no_sys_vars}
verifies that the specified list of variable names does not include 
any {cmd:mi} system variables such as {cmd:_mi_m}, {cmd:_mi_id}, 
{cmd:_mi_miss}, etc.

{p 4 4 2}
{cmd:u_mi_no_wide_vars}
verifies that the specified list of variable names does not include
any style wide {it:m}>0 variables of the form {cmd:_}{it:#}{it:_varname}.
{cmd:u_mi_no_wide_vars} may be called with any style of data but does 
nothing if the style is not wide.

{p 4 4 2}
Both functions issue appropriate error messages if problems are found.
If {it:word} is specified, the error message will be 
"{it:word} may not include ...".  Otherwise, the error message is 
"may not specify ...".


{marker zap_chars}{...}
{title:u_mi_zap_chars}

{p 8 12 2}
{cmd:u_mi_zap_chars}

{p 4 4 2}
{cmd:u_mi_zap_chars}
deletes all {cmd:_dta[_mi_*]} characteristics from the data in memory.


{marker xeq}{...}
{title:u_mi_xeq_on_tmp_flongsep}

{p 8 12 2}
{cmd:u_mi_xeq_on_tmp_flongsep}
[{cmd:,} 
{cmd:nopreserve}]{cmd::}  {it:command}

{p 4 4 2}
{cmd:u_mi_xeq_on_tmp_flongsep}
executes 
{it:command} 
on the data in memory, said data converted to style flongsep, and 
then converts the flongsep result back to the original style.
If the data already are flongsep, a temporary copy is made and, 
at the end, posted back to the original.  
Either way, 
{it:command} is run on a temporary copy of the 
data.  If anything goes wrong, the user's original data are restored;
that is, they are restored unless {cmd:nopreserve} is specified. 
If {it:command} completes without error, 
the flongsep data in memory are converted back to the original style
the original data are discarded.

{p 4 4 2}
It is not uncommon
to write commands that can deal only with flongsep data, and yet 
these seem to users as if they work with all styles. 
That is because the routines use 
{cmd:u_mi_xeq_on_tmp_flongsep}.
They start by allowing any style, but the guts of the routine are 
written assuming flongsep.
{cmd:mi} {cmd:stjoin} is implemented in this way.
There are two parts to {cmd:mi} {cmd:stjoin}:
{cmd:mi_cmd_stjoin.ado} and 
{cmd:mi_sub_stjoin_flongsep.ado}.
{cmd:mi_cmd_stjoin.ado} ends with 

	{cmd:u_mi_xeq_on_tmp_flongsep:  mi_sub_stjoin_flongsep `if', `options'}

{p 4 4 2}
{cmd:mi_sub_stjoin_flongsep} does all the work, while
{cmd:u_mi_xeq_on_tmp_flongsep} handles the issue of converting to flongsep and
back again.
The 
{cmd:mi_sub_stjoin_flongsep} subroutine must appear in its own ado-file 
because 
{cmd:u_mi_xeq_on_tmp_flongsep} is itself implemented as an ado-file.
{cmd:u_mi_xeq_on_tmp_flongsep} 
would be unable to find the subroutine otherwise.


{marker tmp}{...}
{title:u_mi_get_flongsep_tmpname}

{p 8 12 2}
{cmd:u_mi_get_flongsep_tmpname}
{it:macname} {cmd::} {it:basename}

{p 4 4 2}
{cmd:u_mi_get_flongsep_tmpname}
creates a temporary flongsep name based on {it:basename} and stores 
it in the local macro {it:macname}.
{cmd:u_mi_xeq_on_tmp_flongsep}, for your information, obtains the 
temporary name it uses from this routine. 

{p 4 4 2}
{cmd:u_mi_get_flongsep_tmpname}
is seldom used directly because 
{cmd:u_mi_xeq_on_tmp_flongsep}
works well for shifting temporarily into flongsep mode, and 
{cmd:u_mi_xeq_on_tmp_flongsep}
does a lot more than just getting a name under which the data should be 
temporarily stored.
There are instances, however, when one needs to be more involved 
in the conversion.  For examples, see the source 
{cmd:mi_cmd_append.ado} and 
{cmd:mi_cmd_merge.ado}.  The issue these two routines face is 
that they need to shift two input datasets to flongsep, then they 
create a third from them, and that is the only one that needs to be 
shifted back to the original style. 
So these two commands 
handle the conversions themselves using 
{cmd:u_mi_get_flongsep_tmpname}
and {helpb mi convert}.

{p 4 4 2}
For instance, they start with something like 

	{cmd:u_mi_get_flongsep_tmpname master : __mimaster}

{p 4 4 2}
That creates a temporary name suitable for use with 
{cmd:mi} {cmd:convert} and stores it in 
{cmd:`master'}.  The suggested name is {cmd:__mimaster}, but if 
that name is in use, then
{cmd:u_mi_get_flongsep_tmpname}
will form from it 
{cmd:__mimaster1}, or 
{cmd:__mimaster2}, etc.  We recommend that you specify a 
{it:basename} that begins with {cmd:__mi}, which is to say, 
two underscores followed by {cmd:mi}.

{p 4 4 2}
Next you must appreciate that it is your responsibility 
to eliminate the temporary files.  You do that by coding something like 

	...
	{cmd}local origstyle "`_dta[_mi_style]'"
	if ("`origstyle'"=="flongsep") {c -(}
		local origstyle "`origstyle' `_dta[_mi_name]'"
	{c )-}
	u_mi_get_flongsep_tmpname master : __mimaster
	capture {c -(}
		quietly mi convert flongsep `master'
		...
		...
		quietly mi convert `origstyle', clear replace
	{c )-}
	nobreak {
		local rc = _rc
		mata: u_mi_flongsep_erase("`master'", 0, 0)
		if (`rc') {c -(}
			exit `rc'
		{c )-}
	{c )-}{txt}

{p 4 4 2}
The other thing to note above is our use of {cmd:mi} {cmd:convert}
{cmd:`master'} to convert our data to flongsep under the name 
{cmd:`master'}.  What, you might wonder, happens if our data already 
is flongsep?  A nice feature of {cmd:mi} {cmd:convert} is that when
run on data that are already flongsep, it performs an 
{bf:{help mi_copy:mi copy}}.


{marker erase}{...}
{title:mata: u_mi_flongsep_erase()}}

{p 8 12 2}
{cmd:mata: u_mi_flongsep_erase("}{it:name}{cmd:",}
{it:from} [{cmd:,}
{it:output}]{cmd:)}

{p 12 12 2}
where

{p 16 20 2}
{it:name}{bind:         }{it:string}; flongsep name
{p_end}
{p 16 20 2}
{it:from}{bind:         }{it:#}; where to begin erasing
{p_end}
{p 16 20 2}
{it:output}{bind:       }0|1; whether to produce output

{p 4 4 2}
{cmd:mata: u_mi_flongsep_erase()}
is the internal version of 
{bf:{help mi_erase:mi erase}}; 
use whichever is more convenient.

{p 4 4 2}
Input {it:from} is usually specified as 0 and then 
{cmd:mata: u_mi_flongsep_erase()}
erases {it:name}{cmd:.dta}, {cmd:_1_}{it:name}{cmd:.dta},
{cmd:_2_}{it:name}{cmd:.dta}, and so on.
{it:from} may be specified as a number greater than zero, however, 
and then erased are 
{it:_<from>_}{it:name}{cmd:.dta},
{it:_<from+1>_}{it:name}{cmd:.dta},
{it:_<from+2>_}{it:name}{cmd:.dta}, ....

{p 4 4 2}
If {it:output} is 0, no output is produced; otherwise, the erased 
files are also listed.  If {it:output} is not specified, files are 
listed.

{p 4 4 2}
See {view u_mi.mata, adopath asis:viewsource u_mi.mata}
for the source code for this routine.


{marker sortback}{...}
{title:u_mi_sortback}

{p 8 12 2}
{cmd:u_mi_sortback} {it:varlist}

{p 4 4 2}
{cmd:u_mi_sortback} removes dropped variables from {it:varlist} and sorts 
the data on the remaining variables.  The routine is for dealing with 
sort-preserve problems when 
{cmd:program} {it:name}{cmd:,}
{cmd:sortpreserve} is not adequate, such 
as when the data might be subjected to substantial editing between 
the preserving of the sort order and the restoring of it.
To use {cmd:u_mi_sortback}, first record the order of the data:

	{cmd}local sortedby : sortedby
	tempvar recnum
	gen long `recnum' = _n
	quietly compress `recnum'{txt}

{p 4 4 2}
Later, when you want to restore the sort order, you code 

	{cmd:u_mi_sortback `sortedby' `recnum'}


{marker use}{...}
{title:u_mi_save and u_mi_use}

{p 8 12 2}
{cmd:u_mi_save}
{bind:   }{it:macname}
{cmd::}
{it:filename}
[{cmd:,} {it:save_options}]

{p 8 12 2}
{cmd:u_mi_use}{bind: }
{cmd:`"`}{it:macname}{cmd:'"'}
{it:filename}
[{cmd:,} {cmd:clear} {cmdab:nol:abel}]

{p 12 12 8}
{it:save_options} are as described in {bf:{help save:[D] save}}.
{cmd:clear} and {cmd:nolabel} are as described in 
{bf:{help use:[D] use}}.
In both commands, {it:filename} must be specified in quotes 
if it contains any special characters or blanks.

{p 4 4 2}
It is sometimes necessary to save data in a temporary file and 
reload them 
later.  In such cases, when the data are reloaded, you would like to
have the original {cmd:c(filename)}, {cmd:c(filedate)}, and {cmd:c(changed)}
restored.
{cmd:u_mi_save} saves that information in {it:macname}.
{cmd:u_mi_use} restores the information from the information 
saved in {it:macname}.  Note the use of compound quotes around 
{cmd:`}{it:macname}{cmd:'} in {cmd:u_mi_use}; they are not optional.


{marker swap}{...}
{title:mata: u_mi_wide_swapvars()}

{p 8 12 2}
{cmd:mata: u_mi_wide_swapvars(}{it:m}{cmd:,} {it: tmpvarname}{cmd:)}

{p 12 12 2}
where

{p 16 20 2}
{it:m}{bind:            }{it:#}; 1 <= {it:#} <= {it:M}
{p_end}
{p 16 20 2}
{it:tmpvarname}{bind:   }{it:string}; name from {cmd:tempvar}
{p_end}

{p 4 4 2}
This utility is for use with wide data only.
For each variable name contained in 
{cmd:_dta[_mi_ivars]}
and
{cmd:_dta[_mi_pvars]}, 
{cmd:mata: u_mi_wide_swapvars()} 
swaps the contents of {it:varname} with {cmd:_}{it:m}{cmd:_}{it:varname}.
Argument 
{it:tmpvarname} must be the 
name of a temporary variable obtained from 
command {cmd:tempvar}, and the variable must not exist. 
{cmd:mata:} {cmd:u_mi_wide_swapvars()} will use this variable 
while swapping.
See {bf:{help macro:[P] macro}} for more information on {cmd:tempvar}.

{p 4 4 2}
This function is its own inverse, assuming 
{cmd:_dta[_mi_ivars]}
and
{cmd:_dta[_mi_pvars]}
have not changed.

{p 4 4 2}
See {view u_mi.mata, adopath asis:viewsource u_mi.mata}
for the source code for this routine.


{marker fixchars}{...}
{title:u_mi_fixchars}

{p 8 12 2}
{cmd:u_mi_fixchars}
[{cmd:,}
{cmd:acceptable}
{cmd:proper}]

{p 4 4 2}
{cmd:u_mi_fixchars} 
makes the data and variable characteristics the same in {it:m}=1, {it:m}=2,
..., {it:m}={it:M} as they are in {it:m}=0.  The options specify what is
already known to be true about the data, that the data are known to be
acceptable or known to be proper.  If neither is specified, you are stating
that you do not know whether the data are even acceptable.  
That is okay.
{cmd:u_mi_fixchars} handles performing whatever certification is required.
Specifying the options makes {cmd:u_mi_fixchars} run faster.

{p 4 4 2}
This stabilizing of the characteristics is not about {cmd:mi}'s 
characteristics; that is handled by {cmd:u_mi_certify_data}.  Other 
commands of Stata set and use characteristics, while {cmd:u_mi_fixchars} 
ensures that those characteristics are the same across all {it:m}.


{marker cpchars}{...}
{title:mata: u_mi_cpchars_get() and mata: u_mi_cpchars_put()}

{p 8 12 2}
{cmd:mata: u_mi_cpchars_get(}{it:matavar}{cmd:)}

{p 8 12 2}
{cmd:mata: u_mi_cpchars_put(}{it:matavar}{cmd:,} {c -(}{cmd:0}|{cmd:1}|{cmd:2}{c )-}{cmd:)}

{p 12 12 2}
where {it:matavar} is a Mata 
{help m6_glossary##transmorphic:transmorphic} variable.
Obtain {it:matavar} from 
{bf:{help mi_technical##instvar:u_mi_get_mata_instanced_var()}}
when using these functions from Stata.

{p 4 4 2}
These routines replace the characteristics in one 
dataset with those of another.  They are used to implement 
{cmd:u_mi_fixchars}.

{p 4 4 2}
{cmd:mata: u_mi_cpchars_get(}{it:matavar}{cmd:)}
stores in {it:matavar} the characteristics of the data in memory.
The data in memory remain unchanged.

{p 4 4 2}
{cmd:mata: u_mi_cpchars_put(}{it:matavar}{cmd:,} {it:#}{cmd:)}
replaces the characteristics of the data in memory with those
previously recorded in {it:matavar}.  The second argument
specifies the treatment of {cmd:_dta[_mi_*]} characteristics:

	{cmd:0}      delete them in the destination data
	{cmd:1}      copy them from the source just like any other characteristic
	{cmd:2}      retain them as-is from the destination data.


{marker instvar}{...}
{title:mata: u_mi_get_mata_instanced_var()}

{p 8 12 2}
{cmd:mata: u_mi_get_mata_instanced_var("}{it:macname}{cmd:",}
{cmd:"}{it:basename}{cmd:"}
[{cmd:,} {it:i_value}]{cmd:)}

{p 12 12 2}
where

{p 16 20 2}
{it:macname}{bind:      }name of local macro
{p_end}
{p 16 20 2}
{it:basename}{bind:     }suggested name for instanced variable
{p_end}
{p 16 20 2}
{it:i_value}{bind:      }initial value for instanced variable
{p_end}

{p 4 4 2}
{cmd:mata: u_mi_get_mata_instanced_var()}
creates a new Mata global variable, initializes it with {it:i_value}
or as a 0 {it:x} 0 real, and places its name in local macro 
{it:macname}.
Typical usage is

	{cmd}local var
	capture noisily {c -(}
		mata: u_mi_get_mata_instanced_var("var", "myvar"){txt}
		...
		... {it:use} {cmd:`var'} {it:however you wish} ...
		...{cmd}
	{c )-}
	nobreak {c -(}
		local rc = _rc
		capture mata: mata drop `var'
		if (`rc') {c -(}
			exit `rc'
		{c )-}
	{c )-}{txt}
		

{marker ptrace}{...}
{title:mata: u_mi_ptrace_*()}

{p 8 12 2}
{it:h} {cmd:=} 
{cmd:u_mi_ptrace_open("}{it:filename}{cmd:",}
{c -(}{cmd:"r"}|{cmd:"w"}{c )-}
[{cmd:,} 
{c -(}{cmd:0}|{cmd:1}{c )-}]{cmd:)}

{p 8 12 2}
{cmd:u_mi_ptrace_write_stripes(}{it:h}{cmd:,}
{it:id}{cmd:,} 
{it:ynames}{cmd:,}
{it:xnames}{cmd:)}

{p 8 12 2}
{cmd:u_mi_ptrace_write_iter(}{it:h}{cmd:,}
{it:m}{cmd:,}
{it:iter}{cmd:,}
{it:B}{cmd:,}
{it:V}{cmd:)}

{p 8 12 2}
{cmd:u_mi_ptrace_close(}{it:h}{cmd:)}

{p 8 12 2}
{cmd:u_mi_ptrace_safeclose(}{it:h}{cmd:)}

{p 16 16 2}
The above are Mata functions, where{break}
{it:h}, if it is declared, should be declared transmorphic{break}
{it:id} is a string scalar{break}
{it:ynames} and {it:xnames} are string scalars{break}
{it:m} and {it:iter} are real scalars{break}
{it:B} and {it:V} are real matrices; {it:V} must be symmetric

{p 4 4 2}
These routines write parameter-trace files; see 
{bf:{help mi_ptrace:[MI] mi ptrace}}.
The procedure is 1) open the file; 2) write the stripes; 
3) repeatedly write iteration information; and 4) close the file.

{p 8 12 2}
1.  Open the file:
    {it:filename} may be specified with or without a file suffix.
    Specify the second argument as {cmd:"w"}.  The third argument should 
    be {cmd:1} if the file may be replaced when it exists, and {cmd:0}
    otherwise.

{p 8 12 2}
2.  Write the stripes:
    Specify {it:id} as the name of your routine or as {cmd:""};
    {cmd:mi} {cmd:ptrace} {cmd:describe} will show this string as the 
    creator of the file if the string is not {cmd:""}.
    {it:ynames} and {it:xnames} are both string scalars containing 
    space-separated names or, possibly, {it:op}{cmd:.}{it:names}.

{p 8 12 2}
3.  Repeatedly write iteration information:
    Written are 
    {it:m}, the imputation number; {it:iter}, the iteration number; 
    {it:B}, the matrix of coefficients; and {it:V}, the variance matrix.
    {it:B} must be {it:ny} {it:x} {it:nx} and {it:V} must be {it:ny} {it:x}
    {it:ny} and symmetric, where 
    {it:nx} = {cmd:length(tokens(}{it:xnames}{cmd:))} and 
    {it:ny} = {cmd:length(tokens(}{it:ynames}{cmd:))}.

{p 8 12 2}
4.  Close the file:  In Mata, use {cmd:u_mi_ptrace_close(}{it:h}{cmd:)}.
    It is highly recommended that, before step 1, {it:h} be obtained 
    from inside Stata (not Mata) using 
    {cmd:mata:} {cmd:u_mi_get_mata_instanced_var("h", "}{it:myvar}{cmd:")}.
    If you follow this advice, include a 
    {cmd:mata:} {cmd:u_mi_ptrace_safeclose(`h')}
    in the ado-file cleanup code.  This will ensure that open files are 
    closed if the user presses {hi:Break} or something else causes your
    routine to exit before the file is closed.  A correctly written program
    will have two closes, one in Mata and another in the ado-file, although 
    you could omit the one in Mata.
    See 
    {it:{help mi_technical##instvar:u_mi_get_mata_instanced_var()}}
    directly above.

{p 4 4 2}
Also included in {cmd:u_mi_ptrace_*()} are routines to read 
parameter-trace files.  You should not need these routines because 
users will use Stata command {cmd:mi} {cmd:ptrace} {cmd:use} 
to load the file you have 
written.  If you are interested, however, then type
{view u_mi_ptrace.mata, adopath asis:viewsource u_mi_ptrace.mata}.


{marker xxxset}{...}
{title:How to write other set commands to work with mi}

{p 4 4 2}
This section concerns the writing of other set commands such as 
{bf:{help stset:[ST] stset}} or {bf:{help xtset:[XT] xtset}} -- set commands
having nothing to do with {cmd:mi} -- so that they properly work with
{cmd:mi}.

{p 4 4 2}
The definition of a set command is any command that creates characteristics
in the data, 
and possibly creates variables in the data, 
that other commands in the suite will subsequently
access.  Making such set commands work with {cmd:mi} is mostly {cmd:mi}'s
responsibility, but there is a little you need to do to assist {cmd:mi}.
Before dealing with that, 
however, write and debug your set command ignoring {cmd:mi}.  
Once that is done, go back and add a few lines to your
code.  We will pretend your set command is named {cmd:mynewset}
and your original code looks something like this: 

	{cmd:program mynewset}
		...
		{cmd:syntax} ... {cmd:[,} ...{cmd:]}
		...
	{cmd:end}

{p 4 4 2}
Our goal is to make it so that {cmd:mynewset} will not run on {cmd:mi} data
while simultaneously making it so that {cmd:mi} can call it (the user types
{cmd:mi} {cmd:mynewset}).  When the user types {cmd:mi} {cmd:mynewset},
{cmd:mi} will 1) give {cmd:mynewset} a clean, {it:m}=0 dataset on which it can
run and 2) duplicate whatever {cmd:mynewset} does to {it:m}=0 on {it:m}=1,
{it:m}=2, ..., {it:m}={it:M}.

{p 4 4 2} 
To achieve this, modify your code to look like this:

	{cmd:program mynewset}
		...
		{cmd:syntax} ... {cmd:[,} ...{cmd:MI]}{right:(1)    }
		{cmd:if ("`mi'"=="") {c -(}}{right:(2)    }
			{cmd:u_mi_not_mi_set "mynewset"}
			{cmd:local checkvars "*"}{right:(3)    }
		{cmd:{c )-}}
		{cmd:else {c -(}}
			{cmd:local checkvars "u_mi_check_setvars settime"}{right:(3)    }
		{cmd:{c )-}}
		...
		{cmd:`checkvars' `varlist'}{right:(4)    }
		...
	{cmd:end}


{p 4 4 2} 
That is, 

{p 8 12 2}
  1.  Add the {cmd:mi} option to any options you already have.

{p 8 12 2}
  2.  If the {cmd:mi} option is not specified, execute {cmd:u_mi_not_mi_set}, 
      passing to it the name of your set command.  
      If the data are not {cmd:mi}, then
      {cmd:u_mi_not_mi_set} will do nothing.
      If the data are {cmd:mi}, then
      {cmd:u_mi_not_mi_set} will
      issue an error telling the user to run 
      {cmd:mi} {cmd:mynewset}. 
      
{p 8 12 2}
  3.  Set new local macro {cmd:checkvars} to {cmd:*} if the 
      {cmd:mi} option is not specified, and otherwise to
      {cmd:u_mi_check_setvars}.  We should mention 
      that the {cmd:mi} option will be specified when {cmd:mi} {cmd:mynewset} 
      calls {cmd:mynewset}.

{p 8 12 2}
  4.  Run {cmd:`checkvars'} on any 
      input variables {cmd:mynewset} uses that must not vary across {it:m}. 
      {cmd:mi} does not care about other variables or even about new 
      variables {cmd:mynewset} might create; it cares only about 
      existing variables that should not vary across {it:m}.

{p 12 12 2}
      Let's understand
      what "{cmd:`checkvars'} {it:varlist}" does.  If the {cmd:mi} option was
      not specified, the line expands to "{cmd:*} {it:varlist}", which is a
       comment, and does nothing.  If the {cmd:mi} option was specified,
      the line expands to "{cmd:u_mi_check_setvars} {cmd:settime}
      {it:varlist}".  We are calling {cmd:mi} routine
      {cmd:u_mi_check_setvars}, telling it that we are calling at set time,
      and passing along {it:varlist}.  {cmd:u_mi_check_setvars} 
      will verify that {it:varlist} does not contain {cmd:mi} system
      variables or variables that vary across {it:m}.  Within {cmd:mynewset},
      you may call {cmd:`checkvars'} repeatedly if that is convenient.

{p 4 4 2}
You have completed the changes to {cmd:mynewset}.
You finally need to write one short program that reads 

	{cmd:program mi_cmd_mynewset}
		{cmd:version {ccl stata_version}}
		{cmd:mi_cmd_genericset `"mynewset `0'"' "_mynewset_x _mynewset_y"}
	{cmd:end}{txt}

{p 4 4 2}
In the above, we assume that {cmd:mynewset} might add one or two variables 
to the data named {cmd:_mynewset_x} and {cmd:_mynewset_y}.  
List in the second argument all variables {cmd:mynewset} might create.
If {cmd:mynewset} never creates new variables,
then the program should read

	{cmd:program mi_cmd_mynewset}
		{cmd:version {ccl stata_version}}
		{cmd:mi_cmd_genericset `"mynewset `0'"'}
	{cmd:end}{txt}

{p 4 4 2}
You are done.
{p_end}
