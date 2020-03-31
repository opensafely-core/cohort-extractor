{smcl}
{* *! version 1.0.7  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem ssd options" "mansection SEM semssdoptions"}{...}
{vieweralsosee "[SEM] Intro 11" "mansection SEM Intro11"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] ssd" "help ssd"}{...}
{viewerjumpto "Syntax" "sem_ssd_options##syntax"}{...}
{viewerjumpto "Description" "sem_ssd_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_ssd_options##linkspdf"}{...}
{viewerjumpto "Options" "sem_ssd_options##options"}{...}
{viewerjumpto "Remarks" "sem_ssd_options##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[SEM] sem ssd options} {hline 2}}Options for use with
summary statistics data{p_end}
{p2col:}({mansection SEM semssdoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:paths} ...{cmd:,} ... {it:ssd_options}


{synoptset 24}{...}
{synopthdr:ssd_options}
{synoptline}
{synopt :{opt sel:ect()}}alternative to {opt if} {it:exp} for SSD{p_end}
{synopt :{opt forcecor:relations}}allow groups and pooling of SSD correlations{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
Data are sometimes available in summary statistics form only.  These summary
statistics include means, standard deviations or variances, and correlations
or covariances.  These summary statistics can be used by {cmd:sem} in place of
the underlying raw data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semssdoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt select()} is an alternative to {cmd:if} {it:exp} when you are using
summary statistics data (SSD).  Where you might usually type

{phang2}{cmd: . sem ... if agegrp==1 | agegrp==3 | agegrp==5, ...}{p_end}

{p 8 8 2}
with SSD in memory, you type

{phang2}{cmd:. sem ..., ... select(1 3 5)}{p_end}

{p 8 8 2}
See {helpb sem option select:[SEM] sem option select()} and
{manlink SEM Intro 11}.

{phang}
{opt forcecorrelations} tells {cmd:sem} that it may make calculations that
would usually be considered suspicious with SSD that contain only a subset of
means, variances (standard deviations), and covariances (correlations).  Do
not specify this option unless you appreciate the statistical issues that we
are about to discuss.  There are two cases where {opt forcecorrelations} is
relevant.

{p 8 8 2}
In the first case, {cmd:sem} is unwilling to produce {opt group()} estimates
if one or more (usually all) of the groups have only correlations defined.
You can override that by specifying {opt forcecorrelations}, and {cmd:sem} will
assume unit variances for the group or groups that have correlations only.
Doing this is suspect unless you make {opt ginvariant()} all parameters
that are dependent on covariances or unless you truly know that the variances
are indeed 1.

{p 8 8 2}
In the second case, {cmd:sem} is unwilling to pool across groups unless you
have provided means and covariances (or means and correlations and standard
deviations or variances).  Without that information, should the need for
pooling arise, {cmd:sem} issues an error message.  The 
{opt forcecorrelations} option specifies that {cmd:sem} ignore its rule and
pool correlation matrices, treating correlations as if they were covariances
when variances are not defined and treating means as if they were 0 when means
are not defined.  The only justification for making the calculation in this
way is that variances truly are 1 and means truly are 0.

{p 8 8 2}
Understand that there is nothing wrong with using pure correlation data, or
covariance data without the means, so long as you fit models for individual
groups.  Doing anything across groups basically requires that {cmd:sem} have
the covariance and mean information.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Intro 11}.{p_end}
