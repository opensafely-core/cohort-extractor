{smcl}
{* *! version 1.0.5  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem option select()" "mansection SEM semoptionselect()"}{...}
{vieweralsosee "[SEM] Intro 11" "mansection SEM Intro11"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{viewerjumpto "Syntax" "sem_option_select##syntax"}{...}
{viewerjumpto "Description" "sem_option_select##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_option_select##linkspdf"}{...}
{viewerjumpto "Option" "sem_option_select##option"}{...}
{viewerjumpto "Remarks" "sem_option_select##remarks"}{...}
{viewerjumpto "Examples" "sem_option_select##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[SEM] sem option select()} {hline 2}}Using sem with summary
statistics data{p_end}
{p2col:}({mansection SEM semoptionselect():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} ... [{cmd:,} ... {cmd:select(}{it:#} [{it:#} ...]{cmd:)} ...]


{marker description}{...}
{title:Description}

{pstd}
{cmd:sem} may be used with summary statistics data (SSD), data containing
only summary statistics such as the means, standard deviations or variances,
and correlations and covariances of the underlying, raw data.

{pstd}
You enter SSD with the {cmd:ssd} command; see {helpb ssd:[SEM] ssd}.

{pstd}
To fit a model with {cmd:sem}, there is nothing special you have to do
except specify the {opt select()} option where you would usually specify
{cmd:if} {it:{help exp}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semoptionselect()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt select(# [# ...])}
is allowed only when you have SSD in memory.  It specifies which groups should
be used.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Intro 11}.

{pstd}
{cmd:sem} option {opt select()} is the SSD alternative for {cmd:if} 
{it:exp} if you only had the underlying, raw data in memory.  With the
underlying raw data, where you would usually type

{phang2}{cmd:. sem ... if agegrp==1 | agegrp==3, ...}{p_end}

{pstd}
with SSD in memory, you type

{phang2}{cmd:. sem ..., ... select(1 3)}{p_end}

{pstd}
You may select only groups for which you have separate summary statistics
recorded in your summary statistics dataset; the {cmd:ssd describe} command
will list the group variable, if any.  See {helpb ssd:[SEM] ssd}.

{pstd}
By the way, {opt select()} may be combined with {cmd:sem} option 
{opt group()}.  Where you might usually type

{phang2}{cmd:. sem ... if agegrp==1 | agegrp==3, ... group(agegrp)}{p_end}

{pstd}
you could type

{phang2}{cmd:. sem ..., ... select(1 3) group(agegrp)}{p_end}

{pstd}
The above restricts {cmd:sem} to age groups 1 and 3, so the result will be
estimation of a combined model of age groups 1 and 3 with some coefficients
allowed to vary between the groups and other coefficients constrained to be
equal across the groups.  See {helpb sem_group options:[SEM] sem group options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}
{phang2}{cmd:. ssd describe}{p_end}

{pstd}Two-factor measurement model with groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Use option {opt select()} to perform analysis only on group 1{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4), group(grade) select(1)}{p_end}
