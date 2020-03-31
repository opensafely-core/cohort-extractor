{smcl}
{* *! version 1.1.14  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi extract" "mansection MI miextract"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] mi replace0" "help mi replace0"}{...}
{viewerjumpto "Syntax" "mi_extract##syntax"}{...}
{viewerjumpto "Menu" "mi_extract##menu"}{...}
{viewerjumpto "Description" "mi_extract##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_extract##linkspdf"}{...}
{viewerjumpto "Options" "mi_extract##options"}{...}
{viewerjumpto "Remarks" "mi_extract##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi extract} {hline 2}}Extract original or imputed data from
 mi data{p_end}
{p2col:}({mansection MI miextract:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi extract} {it:#} [{cmd:,} {it:options}]{...}

{p 4 4 2}
where 0 <= {it:#} <= {it:M}

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:clear}}okay to replace unsaved data in memory{p_end}

{synopt:{cmdab:esamp:le(}...{cmd:)}}rarely specified option{p_end}
{synopt:{cmdab:esamp:le(}{varname}{cmd:)}}...syntax when {it:#} > 0{p_end}
{synopt:{cmdab:esamp:le(}{varname} {it:#_e}{cmd:)}}...syntax when {it:#} = 0;
       1 <= {it:#_e} <= {it:M}{p_end}
{synoptline}
{p2colreset}{...}
	

{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:extract} {it:#} replaces the data in memory with the 
data for {it:m}={it:#}.  The data are not {cmd:mi} {cmd:set}.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miextractRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:clear} specifies that it is okay to replace the data in memory
    even if the current data have not been saved to disk.

{p 4 8 2}
{cmd:esample(}{varname} [{it:#_e}]{cmd:)}
    is rarely specified.
    It is for use after {bf:{help mi_estimate:mi estimate}}
    when the {cmd:esample(}{it:newvar}{cmd:)} option was specified to store
    in {it:newvar} 
    the {cmd:e(sample)} for {it:m}=1, {it:m}=2, ..., {it:m}={it:M}.
    It is now desired to extract the data for one {it:m} and 
    for {cmd:e(sample)} set correspondingly. 

{p 8 8 2}
    {cmd:mi} {cmd:extract} {it:#}{cmd:,}
    {cmd:esample(}{it:varname}{cmd:)}, {it:#}>0, is the 
    usual case in this unlikely event. 
    One extracts one of the imputation datasets and redefines {cmd:e(sample)}
    based on the {cmd:e(sample)} previously stored for {it:m}={it:#}.

{p 8 8 2}
    The odd case is {cmd:mi} {cmd:extract} {cmd:0,}
    {cmd:esample(}{it:varname} {it:#_e}{cmd:)}, where {it:#_e}>0.
    One extracts the original data but defines {cmd:e(sample)} 
    based on the {cmd:e(sample)} previously stored for {it:m}={it:#_e}.
    
{p 8 8 2}
    Specifying the {cmd:esample()} option changes the sort order of the data.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If you wanted to give up on {cmd:mi} and just get your original data back, 
you could type 

	. {cmd:mi extract 0}

{p 4 4 2}
You might do this if you wanted to send your original data to a coworker 
or you wanted to try a different approach to dealing with the missing 
values in these data.  Whatever the reason, the result is that 
the original data replace the data in memory.  The
data are not {cmd:mi} {cmd:set}.  Your original {cmd:mi} data remain 
unchanged.

{p 4 4 2}
If you suspected there was something odd about the imputations
in {it:m}=3, you could type 

	. {cmd:mi extract 3}

{p 4 4 2}
You would then have a dataset in memory that looked just like your 
original, except the missing values of the imputed and passive variables would 
be replaced with the imputed and passive values from {it:m}=3.  The data are
not {cmd:mi} {cmd:set}.  Your original data remain unchanged.
{p_end}
