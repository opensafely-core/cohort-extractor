{smcl}
{* *! version 1.1.4  25sep2018}{...}
{viewerdialog estat "dialog sem_estat, message(-ggof-) name(sem_estat_ggof)"}{...}
{vieweralsosee "[SEM] estat ggof" "mansection SEM estatggof"}{...}
{findalias assemggof}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] estat eqgof" "help sem_estat_eqgof"}{...}
{vieweralsosee "[SEM] estat gof" "help sem_estat_gof"}{...}
{vieweralsosee "[SEM] sem group options" "help sem_group_options"}{...}
{viewerjumpto "Syntax" "sem_estat_ggof##syntax"}{...}
{viewerjumpto "Menu" "sem_estat_ggof##menu"}{...}
{viewerjumpto "Description" "sem_estat_ggof##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estat_ggof##linkspdf"}{...}
{viewerjumpto "Option" "sem_estat_ggof##option"}{...}
{viewerjumpto "Remarks" "sem_estat_ggof##remarks"}{...}
{viewerjumpto "Examples" "sem_estat_ggof##examples"}{...}
{viewerjumpto "Stored results" "sem_estat_ggof##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[SEM] estat ggof} {hline 2}}Group-level goodness-of-fit
	statistics{p_end}
{p2col:}({mansection SEM estatggof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:ggof} [{cmd:,} {opth for:mat(%fmt)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Group statistics > Group-level goodness of fit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat ggof} is for use after estimation with {cmd:sem,} {opt group()}.

{pstd}
{cmd:estat ggof} displays, by
group, the standardized root mean squared residual (SRMR), the coefficient
of determination (CD), and the model versus saturated chi-squared along with
its associated degrees of freedom and p-value. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM estatggofRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}{opth format(%fmt)}
specifies the display format.  The default is {cmd:format(%9.3f)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {findalias semggof}.

{pstd}
{cmd:estat ggof} provides group-level goodness-of-fit statistics
after estimation by {cmd:sem,} {opt group()}; see 
{helpb sem group options:[SEM] sem group options}.

{pstd}
The SRMR, CD, and chi-squared statistics are not computed for models fit by
{cmd:gsem}; therefore, {cmd:estat ggof} is not for use after estimation with
{cmd:gsem, group()}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
	{cmd: (Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Group-level goodness-of-fit statistics{p_end}
{phang2}{cmd:. estat ggof}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat ggof} stores the following in {cmd:r()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Scalars}{p_end}
{synopt:{cmd:r(N_groups)}}number of groups{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2: Matrices}{p_end}
{synopt:{cmd:r(gfit)}}fit statistics{p_end}
{synopt:{cmd:r(gfit_sb)}}Satorra-Bentler scaled fit statistics{p_end}
{p2colreset}{...}
