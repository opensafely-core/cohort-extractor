{smcl}
{* *! version 1.1.3  10may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi import flong" "mansection MI miimportflong"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] mi import" "help mi_import"}{...}
{viewerjumpto "Syntax" "mi_import_flong##syntax"}{...}
{viewerjumpto "Menu" "mi_import_flong##menu"}{...}
{viewerjumpto "Description" "mi_import_flong##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_import_flong##linkspdf"}{...}
{viewerjumpto "Options" "mi_import_flong##options"}{...}
{viewerjumpto "Remarks" "mi_import_flong##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[MI] mi import flong} {hline 2}}Import flong-like data into mi
{p_end}
{p2col:}({mansection MI miimportflong:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi import flong}{cmd:,}
{it:required_options}
[{it:true_options}]

{synoptset 20}{...}
{synopthdr:required_options}
{synoptline}
{synopt:{cmd:m(}{varname}{cmd:)}}name of variable containing {it:m}{p_end}
{synopt:{cmd:id(}{varlist}{cmd:)}}identifying variable(s){p_end}
{synoptline}

{synopthdr:true_options}
{synoptline}
{synopt:{cmdab:imp:uted(}{varlist}{cmd:)}}imputed variables to be registered
{p_end}
{synopt:{cmdab:pas:sive(}{varlist}{cmd:)}}passive variables to be registered
{p_end}
{synopt:{cmd:clear}}okay to replace unsaved data in memory{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:flong} imports flong-like data, that is, data in
which {it:m}=0, {it:m}=1, ..., {it:m}={it:M} are all recorded in one {cmd:.dta}
dataset.  

{p 4 4 2}
{cmd:mi} {cmd:import} {cmd:flong} converts the data to {cmd:mi} flong style.
The data are {cmd:mi} {cmd:set}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimportflongRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:m(}{varname}{cmd:)} and {cmd:id(}{varlist}{cmd:)} are required.
    {cmd:m(}{it:varname}{cmd:)} specifies the variable that takes on values 0,
    1, ..., {it:M}, the variable that identifies observations corresponding to 
    {it:m}=0, {it:m}=1, ..., {it:m}={it:M}.  {it:varname}=0 identifies
    the original data, {it:varname}=1 identifies {it:m}=1, and so on.

{p 8 8 2}
    {cmd:id(}{it:varlist}{cmd:)} specifies the variable or variables that 
    uniquely identify observations within {cmd:m()}.

{p 4 8 2}
{cmd:imputed(}{varlist}{cmd:)} and {cmd:passive(}{it:varlist}{cmd:)}
    are truly optional options, although it would be unusual if
    {cmd:imputed()} were not specified.

{p 8 8 2}
    {cmd:imputed(}{it:varlist}{cmd:)} specifies the names of the 
    imputed variables.
    
{p 8 8 2}
    {cmd:passive(}{it:varlist}{cmd:)} specifies the names of the 
    passive variables, if any.

{p 4 8 2}
{cmd:clear}
    specifies that it is okay to replace the data in memory even if they 
    have changed since they were saved to disk.  Remember, 
    {cmd:mi} {cmd:import} {cmd:flong} starts with flong-like data in 
    memory and ends with {cmd:mi} flong data in memory.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The procedure to convert flong-like data to {cmd:mi} flong is this:

{p 8 12 2}
1.  {cmd:use} the unset data.

{p 8 12 2}
2.  Issue the {cmd:mi} {cmd:import} {cmd:flong} command.

{p 8 12 2}
3.  Perform the checks outlined in 
    {it:{help mi_import##warning:Using mi import nhanes1, ice, flong, and flongsep}}
    of {bf:{help mi_import:[MI] mi import}}.

{p 8 12 2}
4.  Use {bf:{help mi_convert:mi convert}} to convert the data to a more 
    convenient style, such as wide or mlong.

{p 4 4 2}
For instance, you have the following unset data:

	. {cmd:webuse ourunsetdata}
        . {cmd:list, separator(2)}

{p 4 4 2}
You are told that these data contain the original data ({cmd:m}=0) and 
two imputations ({cmd:m}=1 and {cmd:m}=2), that variable {cmd:b} 
is imputed, and that variable {cmd:c} is passive and in fact equal to 
{cmd:a}+{cmd:b}.
These are the same data discussed in {bf:{help mi_styles:[MI] Styles}}
but in unset form.

{p 4 4 2}
The fact that these data are nicely sorted is irrelevant.  To import these
data, type

	. {cmd:mi import flong, m(m) id(subject) imputed(b) passive(c)} 

{p 4 4 2}
These data are short enough that we can list the result:

        . {cmd:list, separator(2)}

{p 4 4 2}
We will now perform the checks outlined in 
{it:{help mi_import##warning:Using mi import nhanes1, ice, flong, and flongsep}}
of {bf:{help mi_import:[MI] mi import}}, 
which are to run 
{cmd:mi} {cmd:describe}
and 
{cmd:mi} {cmd:varying}
to verify that variables are registered correctly:

	. {cmd:mi describe}
	. {cmd:mi varying}

{p 4 4 2}
We discover that unregistered variable {cmd:m} 
is {help mi_glossary##def_varying:super varying}
(see {bf:{help mi_glossary:[MI] Glossary}}).
Here we no longer need {cmd:m}, so we will drop the variable
and rerun {cmd:mi} {cmd:varying}.
We will find that there are no remaining problems, so 
we will convert our data to our preferred wide style:

	. {cmd:drop m}
	. {cmd:mi varying}
	. {cmd:mi convert wide, clear}
	. {cmd:list}
