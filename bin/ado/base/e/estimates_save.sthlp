{smcl}
{* *! version 2.2.3  19oct2017}{...}
{viewerdialog "estimates save" "dialog estimates_save"}{...}
{viewerdialog "estimates use" "dialog estimates_use"}{...}
{vieweralsosee "[R] estimates save" "mansection R estimatessave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "estimates_save##syntax"}{...}
{viewerjumpto "Menu" "estimates_save##menu"}{...}
{viewerjumpto "Description" "estimates_save##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_save##linkspdf"}{...}
{viewerjumpto "Options" "estimates_save##options"}{...}
{viewerjumpto "Remarks" "estimates_save##remarks"}{...}
{viewerjumpto "Stored results" "estimates_save##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[R] estimates save} {hline 2}}Save and use estimation results{p_end}
{p2col:}({mansection R estimatessave:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {cmd:save}
{it:{help filename}}
[{cmd:,} 
{cmd:append}
{cmd:replace}]

{p 8 12 2}
{opt est:imates} {cmd:use}{bind: }
{it:{help filename}}
[{cmd:,} 
{opt number(#)}]


{p 8 28 2}
{opt est:imates} {cmd:esample:} 
[{it:{help varlist}}]
{ifin}
{weight}{break}
[{cmd:,}
{cmd:replace}
{cmdab:str:ingvars(}{varlist}{cmd:)}
{cmdab:zero:weight}]

{p 8 12 2}
{opt est:imates} {cmd:esample} 


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:save} {it:{help filename}} saves the current (active)
estimation results in {it:filename}.

{pstd}
{cmd:estimates} {cmd:use} {it:filename} loads the results saved in 
{it:filename} into the current (active) estimation results.

{pstd}
In both cases, if {it:filename} is specified without an extension, 
{cmd:.ster} is assumed.

{pstd}
{cmd:estimates} {cmd:esample:} (note the colon) resets {cmd:e(sample)}.
After 
{cmd:estimates} {cmd:use} {it:filename}, 
{cmd:e(sample)} is set to contain 0, meaning that none of the observations 
currently in memory was used in obtaining the estimates.

{pstd}
{cmd:estimates} {cmd:esample} (without a colon) displays how {cmd:e(sample)} is
currently set.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatessaveQuickstart:Quick start}

        {mansection R estimatessaveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt append}, used with {cmd:estimates} {cmd:save}, specifies that results
be appended to an existing file.  If the file does not already exist,
a new file is created.

{phang}
{cmd:replace}, used with {cmd:estimates} {cmd:save}, specifies that 
    {it:{help filename}} can be replaced if it already exists.

{phang}
{opt number(#)}, used with {cmd:estimates} {cmd:use}, specifies that
the {it:#}th set of estimation results from {it:{help filename}} be loaded.
This assumes that multiple sets of estimation results have been saved
in {it:filename} by {cmd:estimates} {cmd:save,} {cmd:append}.
The default is {cmd:number(1)}.

{phang}
{cmd:replace}, used with {cmd:estimates} {cmd:esample:}, specifies 
    that {cmd:e(sample)} can be replaced even if it is already set.

{phang}
{cmd:stringvars(}{varlist}{cmd:)}, used with {cmd:estimates}
    {cmd:esample:}, specifies string variables.  Observations containing 
    variables that contain {cmd:""} will be omitted from {cmd:e(sample)}.

{phang}
{cmd:zeroweight}, used with {cmd:estimates} {cmd:esample:}, specifies that
    observations with zero weights are to be included in {cmd:e(sample)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {bf:{help estimates:[R] estimates}} for an overview of the {cmd:estimates}
commands.

{pstd}
For a description of {cmd:estimates} {cmd:save} and {cmd:estimates} {cmd:use},
see {it:{help estimates##saving:Saving and using estimation results}} in
{bf:{help estimates:[R] estimates}}.

{pstd}
The rest of this entry concerns {cmd:e(sample)}.

{pstd}
Remarks are presented under the following headings:

	{help estimates_save##setting:Setting e(sample)}
	{help estimates_save##resetting:Resetting e(sample)}
	{help estimates_save##determining:Determining who set e(sample)}


{marker setting}{...}
{title:Setting e(sample)}

{pstd}
After {cmd:estimates} {cmd:use} {it:filename}, the situation is 
nearly identical to what it was immediately after you fit the model.
The one difference is that {cmd:e(sample)} is set to 0.

{pstd} 
{cmd:e(sample)} is Stata's function to mark which observations among 
those currently in memory were used in producing the estimates.
For instance, you might type 

	. {cmd:regress mpg weight displ if foreign}
	  {it:(output omitted)}

	. {cmd:summarize mpg if e(sample)}
	  {it:(output omitted)}

{pstd}
and {cmd:summarize} would report the summary statistics for the observations
{cmd:regress} in fact used, which would exclude not only observations
for which {cmd:foreign} = 0 but also any observations for which
{cmd:mpg}, {cmd:weight}, or {cmd:displ} was missing.

{pstd} 
If you saved the above estimation results and then reloaded them, however, 
{cmd:summarize} {cmd:mpg} {cmd:if} {cmd:e(sample)} would produce

	. {cmd:summarize mpg if e(sample)}

	{txt}    Variable {c |}       Obs        Mean    Std. Dev.       Min        Max
	{hline 13}{c +}{hline 56}
                 mpg {c |}{txt}         0

{pstd}
Stata thinks that none of these observations was used in producing 
the estimates currently loaded.

{pstd}
What else could Stata think?  When you {cmd:estimates} {cmd:use}
{it:filename}, you do not have to have the original data in memory.  Even
if you do have data in memory that look like the original data, they might not
be.  Setting {cmd:e(sample)} to 0 is the safe thing to do.
There are some postestimation statistics, for instance, that are 
appropriate only when calculated on the estimation sample.  Setting 
{cmd:e(sample)} to 0 ensures that if you ask for one of them, 
you will get back a null result.

{pstd}
We recommend that you leave {cmd:e(sample)} set to 0.  But what if you really
need to calculate that postestimation statistic?  Well, you can get it, but
you are going to be responsible for setting {cmd:e(sample)} correctly.
Here we just happen to know that all the observations with
{cmd:foreign} = 1 were used, so we can type 

	. {cmd:estimates esample:  if foreign}

{pstd}
If all the observations had been used, we could simply type 

	. {cmd:estimates esample:}

{pstd} 
The safe thing to do, however, is to look at the estimation command --
{cmd:estimates} {cmd:describe} will show it to you -- and then type 

	. {cmd:estimates esample:  mpg weight displ if foreign}

{pstd}
We include all observations with {cmd:foreign} = 1, excluding any
with missing values in the {cmd:mpg}, {cmd:weight}, or {cmd:displ} variable,
that are to be treated as the estimation sample.


{marker resetting}{...}
{title:Resetting e(sample)}

{pstd}
{cmd:estimates} {cmd:esample:} will allow you to not only set but also reset
{cmd:e(sample)}.  If {cmd:e(sample)} has already been set (say that you just
fit the model) and you try to set it, you will see

	. {cmd:estimates esample:  mpg weight displ if foreign}
	{err:no; e(sample) already set}
	r(322);

{pstd}
Here you can specify the {cmd:replace} option:

	. {cmd:estimates esample:  mpg weight displ if foreign, replace}

{pstd}
We do not recommend resetting {cmd:e(sample)}, but the situation can 
arise where you need to.  Imagine that you {cmd:estimates} {cmd:use} 
{it:filename}, you set {cmd:e(sample)}, and then you realize that you set it 
wrong.  Here you would want to reset it.


{marker determining}{...}
{title:Determining who set e(sample)}

{pstd}
{cmd:estimates} {cmd:esample} without a colon will report whether and how
{cmd:e(sample)} was set.  You might see 

	. {cmd:estimates esample}
	  e(sample) set by estimation command

{pstd} 
or

	. {cmd:estimates esample}
	  e(sample) set by user

{pstd}
or

	. {cmd:estimates esample}
	  e(sample) not set (0 assumed)


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estimates} {cmd:esample} without the colon stores macro {cmd:r(who)}, 
which will contain {cmd:cmd}, {cmd:user}, or {cmd:zero'd}.
{p_end}
