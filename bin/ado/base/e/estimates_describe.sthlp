{smcl}
{* *! version 2.1.12  19oct2017}{...}
{viewerdialog "estimates describe" "dialog estimates_describe"}{...}
{vieweralsosee "[R] estimates describe" "mansection R estimatesdescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{viewerjumpto "Syntax" "estimates_describe##syntax"}{...}
{viewerjumpto "Menu" "estimates_describe##menu"}{...}
{viewerjumpto "Description" "estimates_describe##description"}{...}
{viewerjumpto "Links to PDF documentation" "estimates_describe##linkspdf"}{...}
{viewerjumpto "Option" "estimates_describe##option"}{...}
{viewerjumpto "Remarks" "estimates_describe##remarks"}{...}
{viewerjumpto "Examples" "estimates_describe##examples"}{...}
{viewerjumpto "Stored results" "estimates_describe##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[R] estimates describe} {hline 2}}Describe estimation results{p_end}
{p2col:}({mansection R estimatesdescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{opt est:imates} {opt des:cribe}

{p 8 12 2}
{opt est:imates} {opt des:cribe}
{it:name}

{p 8 12 2}
{opt est:imates} {opt des:cribe}
{cmd:using} {it:{help filename}}
[{cmd:,} 
{opt number(#)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estimates} {cmd:describe} describes the current (active) estimates.
Reported are the command line that produced the estimates, any title that was
set by {helpb estimates title}, and any notes that were added by
{helpb estimates notes}.

{pstd}
{cmd:estimates} {cmd:describe} {it:name} does the same but reports 
results for estimates stored by {helpb estimates store}.

{pstd}
{cmd:estimates} {cmd:describe} {cmd:using} {it:{help filename}} does the same
but reports results for estimates saved by 
{helpb estimates save}.  If {it:filename} contains
multiple sets of estimates (saved in it by {cmd:estimates} {cmd:save,}
{cmd:append}), the number of sets of estimates is also reported.
If {it:filename} is specified without an extension, 
{cmd:.ster} is assumed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estimatesdescribeQuickstart:Quick start}

        {mansection R estimatesdescribeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt number(#)} specifies that
the {it:#}th set of estimation results from {it:{help filename}} be described.
This assumes that multiple sets of estimation results have been saved
in {it:filename} by {cmd:estimates} {cmd:save,} {cmd:append}.
The default is {cmd:number(1)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:estimates} {cmd:describe} can be used to describe the estimation 
results currently in memory, 

	. {cmd:estimates describe}

	  Estimation results produced by

	     . regress mpg weight displ if foreign

{pstd} 
or to describe results saved by {cmd:estimates} {cmd:save} in a 
{cmd:.ster} file:

	. {cmd:estimates describe using final}

	  Estimation results "Final results" saved on 12apr2009 14:20,
	  produced by

	     . logistic myopic age sex drug1 drug2 if complete==1

	  Notes:
	    1.  Used file patient.dta
	    2.  "datasignature myopic age sex drug1 drug2 if complete==1" 
	        reports 148:5(58763):2252897466:3722318443
	    3.  must be reviewed by rgg


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit a regression{p_end}
{phang2}{cmd:. regress mpg gear turn}{p_end}

{pstd}Add a note{p_end}
{phang2}{cmd:. estimates notes: My basic results}{p_end}

{pstd}Describe the results{p_end}
{phang2}{cmd:. estimates describe}{p_end}

{pstd}Save the results{p_end}
{phang2}{cmd:. estimates save basic}

{pstd}Describe stored results{p_end}
{phang2}{cmd:. probit foreign mpg gear}{p_end}
{phang2}{cmd:. estimates store myprobit}{p_end}
{phang2}{cmd:. estimates describe myprobit}

{pstd}Describe results saved to disk{p_end}
{phang2}{cmd:. estimates describe using basic}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estimates describe} and
{cmd:estimates describe} {it:name} store the following in {cmd:r()}:

	Macros
	    {cmd:r(title)}           title
	    {cmd:r(cmdline)}         original command line

{pstd}
{cmd:estimates} {cmd:describe} {cmd:using} {it:filename} stores the 
above and the following in {cmd:r()}:

	Scalars
	    {cmd:r(datetime)}        {cmd:%tc} value of date/time file saved
	    {cmd:r(nestresults)}     number of sets of estimation results in file
