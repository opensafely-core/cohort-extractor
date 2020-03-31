{smcl}
{* *! version 1.1.5  30mar2018}{...}
{vieweralsosee "[SVY] svymarkout" "mansection SVY svymarkout"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] mark" "help mark"}{...}
{vieweralsosee "[P] program properties" "help program_properties"}{...}
{viewerjumpto "Syntax" "svymarkout##syntax"}{...}
{viewerjumpto "Description" "svymarkout##description"}{...}
{viewerjumpto "Links to PDF documentation" "svymarkout##linkspdf"}{...}
{viewerjumpto "Remarks" "svymarkout##remarks"}{...}
{viewerjumpto "Example" "svymarkout##example"}{...}
{viewerjumpto "Stored results" "svymarkout##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[SVY] svymarkout} {hline 2}}Mark
observations for exclusion on the basis of survey characteristics{p_end}
{p2col:}({mansection SVY svymarkout:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:svymarkout} [{it:markvar}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:svymarkout} is a programmer's command that resets the values of
{it:markvar} to contain 0 wherever any of the survey-characteristic variables
(previously set by {helpb svyset}) contain missing values.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY svymarkoutRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:svymarkout} assumes that {it:markvar} was created by {cmd:marksample} or
{cmd:mark}; see {manhelp mark P}.  This command is most helpful for developing
estimation commands that use {opt ml} to fit models using maximum
pseudolikelihood directly, instead of relying on the {cmd:svy} prefix;
see {manhelp program_properties P:program properties} for a
discussion of how to write programs to be used with the {cmd:svy} prefix.


{marker example}{...}
{title:Example}

    {cmd:program} {it:mysvyprogram}{cmd:,} ...
	    ...
	    {cmd:syntax} ...
	    {cmd:marksample touse}
	    {cmd:svymarkout `touse'}
	    ...
    {cmd:end}
    

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:svymarkout} stores the following in {cmd:s()}:

    Macros
        {cmd:s(weight)}     weight variable set by {cmd:svyset}
