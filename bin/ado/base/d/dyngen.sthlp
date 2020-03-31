{smcl}
{* *! version 1.0.0  20oct2017}{...}
{viewerdialog dyngen "dialog dyngen"}{...}
{vieweralsosee "[D] dyngen" "mansection D dyngen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{findalias asfrdatatypes}{...}
{findalias asfrexp}{...}
{viewerjumpto "Syntax" "dyngen##syntax"}{...}
{viewerjumpto "Menu" "dyngen##menu"}{...}
{viewerjumpto "Description" "dyngen##description"}{...}
{viewerjumpto "Links to PDF documentation" "dyngen##linkspdf"}{...}
{viewerjumpto "Option" "dyngen##option"}{...}
{viewerjumpto "Example" "dyngen##example"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] dyngen} {hline 2}}Dynamically generate new values of variables
{p_end}
{p2col:}({mansection D dyngen:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax} 

        {cmd:dyngen} {cmd:{c -(}}
            {cmd:update} {varname}_1 {cmd:=} {it:{help exp}} [{it:{help if}}] [{cmd:,} {opt m:issval(#)}]
            .
            .
            .
            {cmd:update} {varname}_N {cmd:=} {it:{help exp}} [{it:{help if}}] [{cmd:,} {opt m:issval(#)}]
        {cmd:{c )-}} {ifin}

{phang}
{varname}_n, n = 1, ..., N, must already exist in the dataset.{p_end}
{phang}
{it:exp} must be a valid expression and may include time-series operators; see
{findalias frtsvarlists}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Dynamically generate new values}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dyngen} replaces the value of variables when two or more variables depend
on each other's lagged values.  Use {cmd:dyngen} when the values for the whole
set of variables must be computed for an observation before moving to the next
observation.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D dyngenRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt missval(#)} specifies the value to use in place of missing values when
performing calculations.  This option is particularly useful when referring to
lags that exist prior to the data.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
        {cmd:. input time x1 x2}

		time 	x1	x2
          1.  {cmd:1 3 1}
          2.  {cmd:2 4 4}
          3.  {cmd:3 5 2}
          4.  {cmd:4 5 1}
          5.  {cmd:5 2 1}
          6.  {cmd:end}


{pstd}Copy {cmd:x1} and {cmd:x2} to {cmd:d1} and {cmd:d2}, which will store
the dynamically updated values{p_end}
{phang2}{cmd:. generate d1=x1}{p_end}
{phang2}{cmd:. generate d2=x2}

{pstd}Summarize the data to find the means{p_end}
{phang2}{cmd:. summarize d1 d2}

{pstd}Dynamically generate new values of variables {cmd:d1} and {cmd:d2},
substituting the means from the summarization in place of missings{p_end}
        {cmd:. dyngen {c -(}}
          1.  {cmd:update d1 = .4*d1 + .1*d2[_n-1], missval(12.2)}
          2.  {cmd:update d2 = .2*d1[_n-1] + .3*d2[_n-1], missval(277)}
          3.  {cmd:{c )-}}

{pstd}List the results{p_end}
{phang2}{cmd:. list x1 x2 d*}{p_end}
