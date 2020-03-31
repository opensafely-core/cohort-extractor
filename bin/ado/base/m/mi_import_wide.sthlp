{smcl}
{* *! version 1.0.13  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi import wide" "mansection MI miimportwide"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] mi import" "help mi_import"}{...}
{viewerjumpto "Syntax" "mi_import_wide##syntax"}{...}
{viewerjumpto "Menu" "mi_import_wide##menu"}{...}
{viewerjumpto "Description" "mi_import_wide##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_import_wide##linkspdf"}{...}
{viewerjumpto "Options" "mi_import_wide##options"}{...}
{viewerjumpto "Remarks" "mi_import_wide##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[MI] mi import wide} {hline 2}}Import wide-like data into mi
{p_end}
{p2col:}({mansection MI miimportwide:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi import wide} [{cmd:,} {it:options}]

{synoptset 18}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:imp:uted(}{it:{help mi_import_wide##mvlist:mvlist}}{cmd:)}}imputed variables{p_end}
{synopt:{cmdab:pas:sive(}{it:{help mi_import_wide##mvlist:mvlist}}{cmd:)}}passive variables{p_end}
{synopt:{cmdab:dups:ok}}allow variable to be posted repeatedly{p_end}
{synopt:{cmd:drop}}drop imputed and passive after posting{p_end}
{synopt:{cmd:clear}}okay to replace unsaved data in memory{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:wide} imports wide-like data, that is, data in which 
{it:m}=0, {it:m}=1, ..., {it:m}={it:M} values of imputed and passive 
variables are recorded in separate variables.

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:wide} converts the data to {cmd:mi} wide style
and {cmd:mi} {cmd:set}s the data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimportwideRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mvlist}{...}
{p 4 8 2}
{cmd:imputed(}{it:mvlist}{cmd:)} and {cmd:passive(}{it:mvlist}{cmd:)}
    specify the imputed and passive variables.

{p 8 8 2}
    For instance, if the data had two imputed variables, {cmd:x} and {cmd:y};
    {cmd:x} and {cmd:y} contained the {it:m}=0 values; the
    corresponding {it:m}=1, {it:m}=2, and {it:m}=3 values of {cmd:x} were in
    {cmd:x1}, {cmd:x2}, and {cmd:x3}; and the corresponding values of {cmd:y}
    were in {cmd:y1}, {cmd:y2}, and {cmd:y3}, then the {cmd:imputed()} option
    would be specified as

		{cmd:imputed(x=x1 x2 x3  y=y1 y2 y3)}

{p 8 8 2}
    If variable {cmd:y2} were missing from the data, you would specify

		{cmd:imputed(x=x1 x2 x3  y=y1 . y3)}

{p 8 8 2}
    The same number of imputations must be specified for each variable.

{p 4 8 2}
{cmd:dupsok}
    specifies that it is okay if you specify the same variable name 
    for two different imputations.  This would be an odd thing to do, 
    but if you specify {cmd:dupsok}, then you can specify 

		{cmd:imputed(x=x1 x1 x3  y=y1 y2 y3)}

{p 8 8 2}
    Without the {cmd:dupsok} option, the above would be treated as an error.

{p 4 8 2}
{cmd:drop}
    specifies that the original variables containing values for 
    {it:m}=1, {it:m}=2, ..., {it:m}={it:M} are to be dropped from the 
    data once {cmd:mi} {cmd:import} {cmd:wide} has recorded the values.
    This option is recommended.

{p 4 8 2}
{cmd:clear}
    specifies that it is okay to replace the data in memory even if they
    have changed since they were last saved to disk.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The procedure to convert wide-like data to {cmd:mi} wide style is this:

{p 8 12 2}
    1.  {cmd:use} the unset data; see {manhelp use D}.

{p 8 12 2}
    2.  Issue the {cmd:mi} {cmd:import} {cmd:wide} command.

{p 8 12 2}
    3.  Use {bf:{help mi_describe:mi describe}} and 
        {bf:{help mi_varying:mi varying}} to verify that the 
        result is as you anticipated.

{p 8 12 2}
    4.  Optionally, use {bf:{help mi_convert:mi convert}} to convert 
        the data to what you consider a more convenient style.

{p 4 4 2}
For instance, you have been given unset dataset {cmd:wi.dta} 
and have been told that it contains variables {cmd:a}, {cmd:b}, and {cmd:c}; 
that variable {cmd:b} is imputed and contains {it:m}=0 values; 
that variables {cmd:b1} and {cmd:b2} contain the {it:m}=1 and 
{it:m}=2 values; that variable {cmd:c} is passive (equal to {cmd:a}+{cmd:b})
and contains {it:m}=0 values; and that variables {cmd:c1} and {cmd:c2}
contain the corresponding {it:m}=1 and {it:m}=2 values.
Here are the data:

	. {cmd:webuse wi}
	. {cmd:list}

{p 4 4 2}
These are the same data discussed in {bf:{help mi_styles:[MI] Styles}}.
To import these data, type

	. {cmd:mi import wide, imputed(b=b1 b2  c=c1 c2) drop}

{p 4 4 2}
These data are short enough that we can list the result:

	. {cmd:list}

{p 4 4 2}
Returning to the procedure, we run {cmd:mi} {cmd:describe} 
and {cmd:mi} {cmd:varying} on the result:

	. {cmd:mi describe}

{p 4 4 2}
Perhaps you would prefer seeing these data in flong style:

	. {cmd:mi convert flong, clear}
	. {cmd:list, separator(2)}
