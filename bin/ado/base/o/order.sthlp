{smcl}
{* *! version 1.2.8  19oct2017}{...}
{viewerdialog order "dialog order"}{...}
{vieweralsosee "[D] order" "mansection D order"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{viewerjumpto "Syntax" "order##syntax"}{...}
{viewerjumpto "Menu" "order##menu"}{...}
{viewerjumpto "Description" "order##description"}{...}
{viewerjumpto "Links to PDF documentation" "order##linkspdf"}{...}
{viewerjumpto "Options" "order##options"}{...}
{viewerjumpto "Examples" "order##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] order} {hline 2}}Reorder variables in dataset{p_end}
{p2col:}({mansection D order:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}{opt order}
{varlist} [{cmd:,} {it:options}]

{synoptset 16}{...}
{synopthdr}
{synoptline}
{synopt :{opt first}}move {varlist} to beginning of dataset; the default{p_end}
{synopt :{opt last}}move {varlist} to end of dataset{p_end}
{synopt :{opth b:efore(varname)}}move {varlist} before {it:varname}{p_end}
{synopt :{opth a:fter(varname)}}move {varlist} after {it:varname}{p_end}
{synopt :{opt alpha:betic}}alphabetize {varlist} and move it to beginning of dataset{p_end}
{synopt :{opt seq:uential}}alphabetize {varlist} keeping numbers sequential and move it to beginning of dataset{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Change order of variables}


{marker description}{...}
{title:Description}

{pstd}
{opt order} relocates {varlist} to a position depending on
which option you specify.  If no option is specified, {cmd:order} relocates
{it:varlist} to the beginning of the dataset in the order in which the
variables are specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D orderQuickstart:Quick start}

        {mansection D orderRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt first} shifts {varlist} to the beginning of the dataset.  This
is the default.

{phang}
{opt last} shifts {varlist} to the end of the dataset.

{phang}
{opth before(varname)} shifts {varlist} before {it:varname}.

{phang}
{opth after(varname)} shifts {varlist} after {it:varname}.

{phang}
{opt alphabetic} alphabetizes {varlist} and moves it to the beginning of the
dataset.  For example, here is a varlist in {cmd:alphabetic} order:
{cmd:a x7 x70 x8 x80 z}.  If combined with another option, {opt alphabetic}
just alphabetizes {it:varlist}, and the movement of {it:varlist} is controlled
by the other option.

{phang}
{opt sequential} alphabetizes {varlist}, keeping variables with the same
ordered letters but with differing appended numbers in sequential order. 
{it:varlist} is moved to the beginning of the dataset.  For example, here
is a varlist in {cmd:sequential} order: {cmd:a x7 x8 x70 x80 z}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto4}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Move {cmd:make} and {cmd:mpg} to the beginning of the dataset{p_end}
{phang2}{cmd:. order make mpg}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Make {cmd:length} be the last variable in the dataset{p_end}
{phang2}{cmd:. order length, last}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Make {cmd:weight} be the third variable in the dataset{p_end}
{phang2}{cmd:. order weight, before(price)}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Alphabetize the variables{p_end}
{phang2}{cmd:. order _all, alphabetic}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}{p_end}
