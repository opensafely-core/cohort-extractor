{smcl}
{* *! version 1.1.4  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem reporting options" "mansection SEM semreportingoptions"}{...}
{findalias assembequal}{...}
{findalias assemcorr}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{viewerjumpto "Syntax" "sem_reporting_options##syntax"}{...}
{viewerjumpto "Description" "sem_reporting_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_reporting_options##linkspdf"}{...}
{viewerjumpto "Options" "sem_reporting_options##options"}{...}
{viewerjumpto "Remarks" "sem_reporting_options##remarks"}{...}
{viewerjumpto "Examples" "sem_reporting_options##examples"}{...}
{viewerjumpto "Reference" "sem_reporting_options##reference"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[SEM] sem reporting options} {hline 2}}Options affecting
reporting of results{p_end}
{p2col:}({mansection SEM semreportingoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {help sem_and_gsem path notation:{it:paths}} ...{cmd:,} ...
     {it:reporting_options}

{p 8 12 2}
{cmd:sem,} {it:reporting_options}


{synoptset 19}{...}
{synopthdr:reporting_options}
{synoptline}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt stand:ardized}}display standardized coefficients and values{p_end}
{synopt :{opt coefl:egend}}display coefficient legend{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt nodes:cribe}}do not display variable classification table{p_end}
{synopt :{opt nohead:er}}do not display header above parameter table{p_end}
{synopt :{opt nofoot:note}}do not display footnotes below parameter table{p_end}
{synopt :{opt notable}}do not display parameter tables{p_end}
{synopt :{opt nofvlab:el}}display group values rather than value labels{p_end}
{synopt :{opt fvwrap(#)}}allow {it:#} lines when wrapping long value labels{p_end}
{synopt :{opt fvwrapon(style)}}apply {it:style} for wrapping long value labels;
{it:style} may be {cmd:word} or {cmd:width}{p_end}

{synopt :{opt byparm}}display results in a single table with rows arranged by
parameter{p_end}
{synopt :{opt showg:invariant}}report all estimated parameters{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
These options control how {cmd:sem} displays estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semreportingoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt standardized} displays standardized values, that is, "beta"
values for coefficients, correlations for covariances, and 1s for variances.
Standardized values are obtained using model-fitted variances
({help sem reporting options##Bollen1989:Bollen 1989}, 124-125).
We recommend caution in the
interpretation of standardized values, especially with multiple groups.

{phang}
{opt coeflegend} displays the legend that reveals how to specify estimated
coefficients in {opt _b[]} notation, which you are sometimes required to
use when specifying postestimation commands.

{phang}
{opt nocnsreport} suppresses the display of the constraints.
Fixed-to-zero constraints that are automatically set by {cmd:sem} are not
shown in the report to keep the output manageable.

{phang}
{opt nodescribe} suppresses display of the variable classification table.

{phang}
{opt noheader} suppresses the header above the parameter table, the display
that reports the final log-likelihood value, number of observations, etc.

{phang}
{opt nofootnote} suppresses the footnotes displayed below the parameter table.

{phang}
{opt notable} suppresses the parameter table.

{phang}
{opt nofvlabel} displays group values rather than value labels.

{phang}
{opt fvwrap(#)} specifies how many lines to allow when long value labels must be
wrapped.  Labels requiring more than {it:#} lines are truncated.  This option
overrides the {cmd:fvwrap} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang}
{opt fvwrapon(style)} specifies whether value labels that wrap will break
at word boundaries or break based on available space.

{phang2}
{cmd:fvwrapon(word)}, the default, specifies that value labels break at
word boundaries.

{phang2}
{cmd:fvwrapon(width)} specifies that value labels break based on available
space.

{pmore}
This option overrides the {cmd:fvwrapon} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang}
{opt byparm} specifies that estimation results with multiple groups
be reported in a single table with rows arranged by parameter.  The
default is to report results in separate tables for each group.

{phang}
{opt showginvariant} specifies that each estimated parameter be reported in the
parameter table.  The default is to report each invariant parameter only once.
This option is only effective with the {cmd:byparm} option.


{marker remarks}{...}
{title:Remarks}

{pstd}
Any of the above options may be specified when you fit the model or when you
redisplay results, which you do by specifying nothing but options after the
{cmd:sem} command:

{phang2}{cmd:. sem (...) (...), ...}{p_end}
{phang2}{it:(original output displayed)}

{phang2}{cmd:. sem}{p_end}
{phang2}{it:(output redisplayed)}

{phang2}{cmd:. sem, standardized}{p_end}
{phang2}{it:(standardized output displayed)}

{phang2}{cmd:. sem, coeflegend}{p_end}
{phang2}{it:(coefficient-name table displayed)}

{phang2}{cmd:. sem}{p_end}
{phang2}{it:(output redisplayed)}

{pstd}
See {findalias sembequal} and {findalias semcorr}.  


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Display standardized coefficients{p_end}
{phang2}{cmd:. sem, standardized}{p_end}

{pstd}Display coefficient legend{p_end}
{phang2}{cmd:. sem, coeflegend}{p_end}

{pstd}Only display the parameter table{p_end}
{phang2}{cmd:. sem, nofootnote noheader nocnsreport}{p_end}

{pstd}Report all estimated parameters{p_end}
{phang2}{cmd:. sem, showginvariant}{p_end}


{marker reference}{...}
{title:Reference}

{marker Bollen1989}{...}
{phang}
Bollen, K. A. 1989.  {it:Structural Equations with Latent Variables}.  New
York: Wiley.
{p_end}
