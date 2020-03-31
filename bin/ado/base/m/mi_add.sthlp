{smcl}
{* *! version 1.1.4  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi add" "mansection MI miadd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi append" "help mi_append"}{...}
{vieweralsosee "[MI] mi merge" "help mi_merge"}{...}
{viewerjumpto "Syntax" "mi add##syntax"}{...}
{viewerjumpto "Menu" "mi add##menu"}{...}
{viewerjumpto "Description" "mi add##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_add##linkspdf"}{...}
{viewerjumpto "Options" "mi add##options"}{...}
{viewerjumpto "Remarks" "mi add##remarks"}{...}
{viewerjumpto "Stored results" "mi add##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MI] mi add} {hline 2}}Add imputations from another mi dataset{p_end}
{p2col:}({mansection MI miadd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi} {cmd:add} {varlist}
{cmd:using} {it:{help filename}}
[{cmd:,} {it:options}]

{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:assert(master)}}assert all observations found in master{p_end}
{synopt:{cmd:assert(match)}}assert all observations found in master and in using
{p_end}

{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 8 2}
Notes:

{p 8 14 2}
1.  Jargon:{break}
    match variables = {it:varlist}, variables on which match performed{break}
    {bind:         }master = data in memory{break}
    {bind:          }using = data on disk ({it:filename})

{p 8 12 2}
2.  Master must be {cmd:mi} {cmd:set}.

{p 8 12 2}
3.  Using must be {cmd:mi} {cmd:set}.

{p 8 12 2}
4.  {it:filename} must be enclosed in double quotes if {it:filename}
    contains blanks or other special characters.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:add} adds the imputations from the using dataset on disk to the
end of the master dataset in memory.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miaddRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:assert(}{it:results}{cmd:)} 
    specifies how observations are expected to match.  If results are not as 
    you expect, an error message will be issued and the master data left 
    unchanged.

{phang2}
    {cmd:assert(master)} specifies that you expect a match for every 
    observation in the master, although there may be extra observations 
    in the using that {cmd:mi} {cmd:add} is to ignore.

{phang2}
    {cmd:assert(match)} specifies that you expect every observation in 
    the master to match an observation in the using and vice versa.

{p 8 8 2}
    The default is that the master may have observations that are 
    missing from the using and vice versa.  Only observations in 
    common are used by {cmd:mi} {cmd:add}.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Think of the result produced by {cmd:mi} {cmd:add} as being 

          {c TLC}{hline 52}{c TRC}
          {c |}  Result                   Source{col 64}{c |}
	  {c LT}{hline 52}{c RT}
          {c |}  {it:m} = 0                    {it:m} = 0 from master{col 64}{c |}
          {c |}  {it:m} = 1                    {it:m} = 1 from master{col 64}{c |}
          {c |}  {it:m} = 2                    {it:m} = 2 from master{col 64}{c |}
          {c |}    .                        .{col 64}{c |}
          {c |}    .                        .{col 64}{c |}
          {c |}  {it:m} = {it:M_master}             {it:m} = {it:M_master} from master{col 64}{c |}
          {c |}  {it:m} = {it:M_master} + 1         {it:m} = 1 from using {col 64}{c |}
          {c |}  {it:m} = {it:M_master} + 2         {it:m} = 2 from using {col 64}{c |}
          {c |}    .                        .{col 64}{c |}
          {c |}    .                        .{col 64}{c |}
          {c |}  {it:m} = {it:M_master} + {it:M_using}   {it:m} = {it:M_using} from using{col 64}{c |}
          {c BLC}{hline 52}{c BRC}

{p 4 4 2}
That is, the original data in the master remain unchanged.  All that happens
is the imputed data from the using are added to the end of the master as
additional imputations.

{p 4 4 2}
For instance, say you discover that you and a coworker has been working on the
same data.  You have added {it:M}=20 imputations to your data.
Your coworker has separately added {it:M}=17.  To combine the data, type 
something like

	. {cmd:use mydata}

	. {cmd:mi add patientid using karensdata}
	(17 imputations added; {it:M}=37)

{p 4 4 2}
The only thing changed in your data is {it:M}.  If your coworker's data 
have additional variables, they are ignored.  If your coworker has 
variables registered differently from how you have them registered, that 
is ignored.  If your coworker has not yet registered as imputed a 
variable that you have registered as imputed, that is noted in the output.
You might see 

	. {cmd:use mydata}

	. {cmd:mi add patientid using karensdata}
	(17 imputations added; {it:M}=37)
        (imputed variable grade not found in using data;
            added imputations contain {it:m}=0 values for that variable)


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi add} stores the following in {cmd:r()}:

	Scalars
	    {cmd:r(m)}              number of added imputations
	    {cmd:r(unmatched_m)}    number of unmatched master obs.
	    {cmd:r(unmatched_u)}    number of unmatched using obs.

	Macros
            {cmd:r(imputed_f)}      variables for which imputed found
            {cmd:r(imputed_nf)}     variables for which imputed not found
