{smcl}
{* *! version 1.2.4  20dec2018}{...}
{viewerdialog stir "dialog stir"}{...}
{vieweralsosee "[ST] stir" "mansection ST stir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "[ST] stsum" "help stsum"}{...}
{viewerjumpto "Syntax" "stir##syntax"}{...}
{viewerjumpto "Menu" "stir##menu"}{...}
{viewerjumpto "Description" "stir##description"}{...}
{viewerjumpto "Links to PDF documentation" "stir##linkspdf"}{...}
{viewerjumpto "Options" "stir##options"}{...}
{viewerjumpto "Examples" "stir##examples"}{...}
{viewerjumpto "Video example" "stir##video"}{...}
{viewerjumpto "Stored results" "stir##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[ST] stir} {hline 2}}Report incidence-rate comparison{p_end}
{p2col:}({mansection ST stir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:stir} {it:exposedvar} {ifin} [{cmd:,} {it:options}]

{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth st:rata(varname)}}stratify on {it:varname}{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}

{syntab:Options}
{synopt :{opt ird}}report incidence-rate difference rather than ratio{p_end}
{synopt :{opt es:tandard}}combine external weights with within-stratum statistics{p_end}
{synopt :{opt is:tandard}}combine internal weights with within-stratum statistics{p_end}
{synopt :{opth s:tandard(varname)}}combine user-specified weights with within-stratum statistics{p_end}
{synopt :{opt p:ool}}display pooled estimate{p_end}
{synopt :{opt noc:rude}}do not display crude estimate{p_end}
{synopt :{opt noh:om}}do not display homogeneity test{p_end}
{synopt :{opt tb}}calculate test-based confidence intervals{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Options except {opt noshow}, {opt tb}, and {opt level(#)} are relevant only if
{opt strata()} is specified.{p_end}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stir}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{p 4 6 2}
{opt fweight}s and {opt iweight}s may be specified using {cmd:stset};
see {manhelp stset ST}.  {cmd:stir} may not be used with {opt pweight}ed data.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
     {bf:Report incidence-rate comparison}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stir} reports point estimates and confidence intervals for the
incidence-rate ratio (IRR) and incidence-rate difference.
Stratified IRRs may be standardized to produce standardized mortality
ratios.

{pstd}
{cmd:stir} can be used with single- or multiple-record and single- or multiple
failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stirQuickstart:Quick start}

        {mansection ST stirRemarksandexamples:Remarks and examples}

        {mansection ST stirMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth strata(varname)} specifies that the calculation be stratified on 
{it:varname}, which may be a numeric or string variable.  Within-stratum 
statistics are shown and then combined with Mantel-Haenszel weights.

{phang}
{opt noshow} prevents {cmd:stir} from showing the key st variables.  This 
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned 
at the top of the output of every st command; see {manhelp stset ST}.

{dlgtab:Options}

{phang}
{opt ird}, {opt estandard}, {opt istandard}, {opth standard(varname)}, 
{opt pool}, {opt nocrude}, and {opt nohom} are relevant only if {opt strata()}
is specified; see {manhelp Epitab R}.

{phang}
{opt tb} and {opt level(#)} are relevant in all cases; see {manhelp Epitab R}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse page2}

{pstd}Report incidence-rate ratio and difference for exposed and unexposed
groups{p_end}
{phang2}{cmd:. stir group}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hip3}

{pstd}Show st settings{p_end}
{phang2}{cmd:. stset}

{pstd}Calculate standardized IRRs, weighting each
gender by the person-time of the exposed group and displaying a pooled estimate
of the IRR{p_end}
{phang2}{cmd:. stir protect, strata(male) istandard pool}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=ItmXrcfpTfE&list=UUVk4G4nEtBS4tLOyHqustDA":How to calculate incidence rates and incidence-rate ratios}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stir} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}one-sided p-value{p_end}
{synopt:{cmd:r(ird)}}incidence-rate difference{p_end}
{synopt:{cmd:r(lb_ird)}}lower bound of CI for {cmd:ird}{p_end}
{synopt:{cmd:r(ub_ird)}}upper bound of CI for {cmd:ird}{p_end}
{synopt:{cmd:r(irr)}}incidence-rate ratio{p_end}
{synopt:{cmd:r(lb_irr)}}lower bound of CI for {cmd:irr}{p_end}
{synopt:{cmd:r(ub_irr)}}upper bound of CI for {cmd:irr}{p_end}
{synopt:{cmd:r(afe)}}attributable (prev.) fraction among exposed{p_end}
{synopt:{cmd:r(lb_afe)}}lower bound of CI for {cmd:afe}{p_end}
{synopt:{cmd:r(ub_afe)}}upper bound of CI for {cmd:afe}{p_end}
{synopt:{cmd:r(afp)}}attributable fraction for the population{p_end}
{synopt:{cmd:r(chi2_mh)}}Mantel-Haenszel homogeneity chi-squared{p_end}
{synopt:{cmd:r(chi2_p)}}pooled homogeneity chi-squared{p_end}
{synopt:{cmd:r(pooled)}}pooled IRR (or IRD) for estimate{p_end}
{synopt:{cmd:r(lb_pooled)}}lower bound of pooled confidence interval{p_end}
{synopt:{cmd:r(ub_pooled)}}upper bound of pooled confidence interval{p_end}
{synopt:{cmd:r(crude)}}crude IRR (or IRD) for estimate{p_end}
{synopt:{cmd:r(lb_crude)}}lower bound of crude confidence interval{p_end}
{synopt:{cmd:r(ub_crude)}}upper bound of crude confidence interval{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{p2colreset}{...}
