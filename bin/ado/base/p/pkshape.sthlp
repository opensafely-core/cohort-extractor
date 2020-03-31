{smcl}
{* *! version 1.1.7  11may2019}{...}
{viewerdialog pkshape "dialog pkshape"}{...}
{vieweralsosee "[R] pkshape" "mansection R pkshape"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pk" "help pk"}{...}
{viewerjumpto "Syntax" "pkshape##syntax"}{...}
{viewerjumpto "Menu" "pkshape##menu"}{...}
{viewerjumpto "Description" "pkshape##description"}{...}
{viewerjumpto "Links to PDF documentation" "pkshape##linkspdf"}{...}
{viewerjumpto "Options" "pkshape##options"}{...}
{viewerjumpto "Remarks" "pkshape##remarks"}{...}
{viewerjumpto "Examples" "pkshape##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] pkshape} {hline 2}}Reshape (pharmacokinetic) Latin-square data{p_end}
{p2col:}({mansection R pkshape:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:pkshape} {it:id sequence period1 period2} [{it:periodlist}]
[{cmd:,} {it:options}]

{pstd}
Variable {it:id} specifies unique subject identifiers.  Variable {it:sequence}
specifies the sequence (numeric or string) in which treatments were received.
Variables {it:period1}, {it:period2}, and so on specify the pharmacokinetic
measurements such as AUC in the corresponding periods.

{synoptset 19}{...}
{synopthdr}
{synoptline}
{synopt :{opth o:rder(strings:string)}}apply treatments in specified order; required with numeric {it:sequence}{p_end}
{synopt :{opth out:come(newvar)}}name for outcome variable; default is
{cmd:outcome(outcome)}{p_end}
{synopt :{opth tr:eatment(newvar)}}name for treatment variable; default is
{cmd:treatment(treat)}{p_end}
{synopt :{opth car:ryover(newvar)}}name for carryover variable; default is
{cmd:carryover(carry)}{p_end}
{synopt :{opth seq:uence(newvar)}}name for sequence variable; default is
{cmd:sequence(sequence)}{p_end}
{synopt :{opth per:iod(newvar)}}name for period variable; default is
{cmd:period(period)}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Other >}
     {bf:Reshape pharmacokinetic Latin-square data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pkshape} reshapes data for use with {helpb anova}, {helpb pkcross}, and
{helpb pkequiv}.  Latin-square and crossover data are often organized in a
manner that cannot be analyzed easily with Stata.  {cmd:pkshape} reorganizes
the data in memory for use in Stata.

{pstd}
{cmd:pkshape} is one of the pk commands.  Please read {helpb pk} before
reading this entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pkshapeQuickstart:Quick start}

        {mansection R pkshapeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth order:(strings:string)} specifies the order in which treatments were
applied when generating the sequence, treatment, and carryover variables in
the reorganized data.  This option is required if the input sequence variable,
{it:sequence}, is numeric.  It is not allowed if {it:sequence} is a string
variable.  For crossover designs, any washout periods can be indicated with
the number 0.

{phang}
{opth outcome(newvar)} specifies the name for the outcome variable in the
reorganized data.  By default, {cmd:outcome(outcome)} is used.

{phang}
{opth treatment(newvar)} specifies the name for the treatment variable in the
reorganized data.  By default, {cmd:treatment(treat)} is used.

{phang}
{opth carryover(newvar)} specifies the name for the carryover variable in the
reorganized data.  By default, {cmd:carryover(carry)} is used.

{phang}
{opth sequence(newvar)} specifies the name for the sequence variable in the
reorganized data.  By default, {cmd:sequence(sequence)} is used.

{phang}
{opth period(newvar)} specifies the name for the period variable in the
reorganized data.  By default, {cmd:period(period)} is used.


{marker remarks}{...}
{title:Remarks}

{pstd}
Often, data from a Latin-square experiment are naturally organized in a manner
that Stata cannot manage easily.  {cmd:pkshape} reorganizes Latin-square data
so that they can be used with {helpb anova} or any {helpb pk} command.  This
reorganization includes the classic 2 x 2 crossover design commonly used in
pharmaceutical research, as well as many other Latin-square designs.


{marker examples}{...}
{title:Examples}

    {hline}
{phang}{cmd:. webuse chowliu}{p_end}
{phang}{cmd:. pkshape id seq period1 period2, order(RT TR)}{p_end}
    {hline}
{phang}{cmd:. webuse music, clear}{p_end}
{phang}{cmd:. pkshape id seq day1 day2 day3 day4 day5}{p_end}
{phang}{cmd:. anova outcome seq period treat}{p_end}
    {hline}
{phang}{cmd:. webuse applesales, clear}{p_end}
{phang}{cmd:. pkshape id seq p1 p2 p3, order(bca abc cab) seq(pattern) treat(displays)}{p_end}
{phang}{cmd:. anova outcome pattern displays id|pattern}{p_end}
    {hline}
