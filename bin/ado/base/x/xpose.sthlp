{smcl}
{* *! version 1.1.17  19jun2019}{...}
{viewerdialog xpose "dialog xpose"}{...}
{vieweralsosee "[D] xpose" "mansection D xpose"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] reshape" "help reshape"}{...}
{vieweralsosee "[D] stack" "help stack"}{...}
{viewerjumpto "Syntax" "xpose##syntax"}{...}
{viewerjumpto "Menu" "xpose##menu"}{...}
{viewerjumpto "Description" "xpose##description"}{...}
{viewerjumpto "Links to PDF documentation" "xpose##linkspdf"}{...}
{viewerjumpto "Options" "xpose##options"}{...}
{viewerjumpto "Examples" "xpose##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] xpose} {hline 2}}Interchange observations and variables{p_end}
{p2col:}({mansection D xpose:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:xpose, clear} [{it:options}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {opt clear}}reminder that untransposed data will be lost if not previously saved{p_end}
{synopt :{opt f:ormat}}use largest numeric display format from untransposed data{p_end}
{synopt :{opth f:ormat(%fmt)}}apply specified format to all variables in transposed data{p_end}
{synopt :{opt v:arname}}add variable {opt _varname} containing original variable names{p_end}
{synopt :{opt prom:ote}}use the most compact data type that preserves numeric accuracy{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:clear} is required.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Interchange observations and variables}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xpose} transposes the data, changing variables into observations and
observations into variables.  All new variables -- that is, those created
by the transposition -- are made the default storage type.  Thus any
original variables that were strings will result in observations containing
missing values.  (If you transpose the data twice, you will lose the contents
of string variables.)


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D xposeQuickstart:Quick start}

        {mansection D xposeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt clear} is required and is supposed to remind you that the
untransposed data will be lost (unless you have saved the data previously).

{phang}
{opt format} specifies that the largest numeric display format from your
untransposed data be applied to the transposed data.

{phang}
{opth format(%fmt)} specifies that the specified numeric
display format be applied to all variables in the transposed data.

{phang}
{opt varname} adds the new variable {hi:_varname} to the transposed data
containing the original variable names.  Also, with or without the
{cmd:varname} option, if the variable {hi:_varname} exists in the dataset
before transposition, those names will be used to name the variables after
transposition.  Thus transposing the data twice will (almost) yield the
original dataset.

{phang}
{opt promote} specifies that the transposed data use the most compact
numeric {help data types:data type} that preserves the original data accuracy.

{pmore}
If your data contain any variables of type {opt double}, all variables
in the transposed data will be of type {opt double}.  

{pmore}
If variables of type {opt float} are present, but there are no variables of
type {opt double} or {opt long}, the transposed variables will be of type
{opt float}.  If variables of type {opt long} are present, but there are no
variables of type {opt double} or {opt float}, the transposed variables will
be of type {opt long}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse xposexmpl}

    List the original data
{phang2}{cmd:. list}

{pstd}Interchange observations and variables, and store original variable
names in {cmd:_varname}{p_end}
{phang2}{cmd:. xpose, clear varname}

    List the results
{phang2}{cmd:. list}

{pstd}Restore original data{p_end}
{phang2}{cmd:. xpose, clear}

{pstd}A list shows that the data have been restored{p_end}
{phang2}{cmd:. list}

{pstd}Interchange observations and variables, store original variable names in
{cmd:_varname}, and use {cmd:%6.2f} format on numeric variables{p_end}
{phang2}{cmd:. xpose, clear varname format(%6.2f)}

{pstd}List the results{p_end}
{phang2}{cmd:. list}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse xposexmpl, clear}

{pstd}Describe the original data{p_end}
{phang2}{cmd:. describe}

{pstd}Interchange observations and variables, store original variable names in
{cmd:_varname}, and apply largest numeric display format from untransformed
data to variables in transposed data{p_end}
{phang2}{cmd:. xpose, clear varname format}

{pstd}Describe the resulting data{p_end}
{phang2}{cmd:. describe}{p_end}
    {hline}
