{smcl}
{* *! version 1.3.5  15may2018}{...}
{viewerdialog cs "dialog cs"}{...}
{viewerdialog csi "dialog csi"}{...}
{vieweralsosee "[R] Epitab" "mansection R Epitab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] dstdize" "help dstdize"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "[U] 19 Immediate commands" "help immed"}{...}
{viewerjumpto "Syntax" "cs##syntax"}{...}
{viewerjumpto "Menu" "cs##menu"}{...}
{viewerjumpto "Description" "cs##description"}{...}
{viewerjumpto "Links to PDF documentation" "cs##linkspdf"}{...}
{viewerjumpto "Options for cs" "cs##options_cs"}{...}
{viewerjumpto "Options for csi" "cs##options_csi"}{...}
{viewerjumpto "Examples" "cs##examples"}{...}
{viewerjumpto "Video example" "cs##video"}{...}
{viewerjumpto "Stored results" "cs##results"}{...}
{viewerjumpto "References" "cs##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] Epitab} {hline 2}}Tables for epidemiologists (cs and csi)
{p_end}
{p2col:}({mansection R Epitab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:cs} {it:var_case var_exposed} {ifin}
[{it:{help cs##weight:weight}}]
[{cmd:,} {it:{help cs##cs_options:cs_options}}]

{p 8 14 2}{cmd:csi} {it:#a #b #c #d} [{cmd:,} {it:{help cs##csi_options:csi_options}}]

{synoptset 24 tabbed}{...}
{marker cs_options}{...}
{synopthdr :cs_options}
{synoptline}
{syntab:Options}
{synopt :{cmd:by(}{varlist} [{cmd:,} {opt mis:sing}]{cmd:)}}stratify on {it:varlist}{p_end}
{synopt :{opt es:tandard}}combine external weights with within-stratum statistics{p_end}
{synopt :{opt is:tandard}}combine internal weights with within-stratum statistics{p_end}
{synopt :{opth s:tandard(varname)}}combine user-specified weights with within-stratum statistics{p_end}
{synopt :{opt p:ool}}display pooled estimate{p_end}
{synopt :{opt noc:rude}}do not display crude estimate{p_end}
{synopt :{opt noh:om}}do not display homogeneity test{p_end}
{synopt :{opt rd}}calculate standardized risk difference{p_end}
{synopt :{opth b:inomial(varname)}}number of subjects variable{p_end}
{synopt :{opt or}}report odds ratio{p_end}
{synopt :{opt w:oolf}}use Woolf approximation to calculate SE and CI of the odds ratio{p_end}
{synopt :{opt e:xact}}calculate Fisher's exact p{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 21}{...}
{marker csi_options}{...}
{synopthdr :csi_options}
{synoptline}
{synopt :{opt or}}report odds ratio{p_end}
{synopt :{opt w:oolf}}use Woolf approximation to calculate SE and CI of the odds ratio{p_end}
{synopt :{opt e:xact}}calculate Fisher's exact p{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:cs}

{phang2}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
    {bf:Cohort study risk-ratio etc.}

    {title:csi}

{phang2}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
     {bf:Cohort study risk-ratio etc. calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cs} is used with cohort study data with equal follow-up time per subject
and sometimes with cross-sectional data.  Risk is then the proportion of
subjects who become cases.  It calculates point estimates and confidence 
intervals for the risk difference, risk ratio, and (optionally) the odds ratio,
along with attributable or prevented fractions for the exposed and total
population.  {cmd:csi} is the immediate form of {cmd:cs}; see {help immed}.
Also see {manhelp logistic R} for related commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R EpitabQuickstart:Quick start}

        {mansection R EpitabRemarksandexamples:Remarks and examples}

        {mansection R EpitabMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_cs}{...}
{title:Options for cs}

{dlgtab:Options}

{phang}
{cmd:by(}{varlist} [{cmd:,} {opt missing}]{cmd:)} specifies that the tables be
stratified on {it:varlist}.  Missing categories in {it:varlist} are omitted
from the stratified analysis, unless option {cmd:missing} is specified within
{cmd:by()}.  Within-stratum statistics are shown then combined with
Mantel-Haenszel weights.  If {opt estandard}, {opt istandard}, or
{cmd:standard()} is also specified (see below), the weights specified are used
in place of Mantel-Haenszel weights.

{phang}
{opt estandard}, {opt istandard}, and {opth standard(varname)}
request that within-stratum statistics be combined with 
external, internal, or user-specified weights to produce a standardized 
estimate.  These options are mutually exclusive and can be used only when 
{opt by()} is also specified.  (When {opt by()} is specified without one of 
these options, Mantel-Haenszel weights are used.)

{pmore}
{opt estandard} external weights are the total number of unexposed.

{pmore}
{cmd:istandard} internal weights are the total number of exposed controls.
{opt istandard} can be used to produce, among other things, standardized
mortality ratios (SMRs).

{pmore}
{opt standard(varname)} allows user-specified weights.  {it:varname} 
must contain a constant within stratum and be nonnegative.  The scale of 
{it:varname} is irrelevant.

{phang}
{opt pool} specifies that, in a stratified 
analysis, the directly pooled estimate also be displayed.  The pooled estimate 
is a weighted average of the stratum-specific estimates using inverse-variance 
weights, which are the inverse of the variance of the stratum-specific estimate.
{opt pool} is relevant only if {opt by()} is also specified.

{phang}
{opt nocrude} specifies that in a stratified
analysis the crude estimate -- an estimate obtained without regard to 
strata -- not be displayed.  {opt nocrude} is relevant only if {opt by()} 
is also specified.

{phang}
{opt nohom} specifies that a chi-squared 
test of homogeneity not be included in the output of a stratified analysis.  
This tests whether the exposure effect is the same across strata and can be 
performed for any pooled estimate -- directly pooled or Mantel-Haenszel.  
{opt nohom} is relevant only if {opt by()} is also specified.

{phang}
{opt rd} may be used only with {opt estandard}, {opt istandard}, or
{opt standard()}.  It requests that {opt cs} calculate the standardized risk
difference rather than the default risk ratio.

{phang}
{opth binomial(varname)} supplies the 
number of subjects (cases plus controls) for binomial frequency records.  For 
individual and simple frequency records, this option is not used.

{phang}
{opt or} 
reports the calculation of the odds ratio in addition to the risk ratio if 
{opt by()} is not specified.  With {opt by()}, {opt or} specifies that a 
Mantel-Haenszel estimate of the combined odds ratio be made rather than the 
Mantel-Haenszel estimate of the risk ratio.  In either case, this is the same 
calculation that would be made by {helpb cc} and {helpb cci}.  Typically,
{cmd:cc}, {cmd:cci}, or {helpb tabodds} is preferred for calculating odds
ratios.  

{phang}
{opt woolf} requests that the
{help cs##W1955:Woolf (1955)} approximation, also known as the Taylor
expansion, be used for calculating the standard error and confidence interval
for the odds ratio.  By default, {cmd:cs} with the {cmd:or} option reports the
{help cs##C1956:Cornfield (1956)} interval.

{phang}
{opt exact} requests that Fisher's exact 
p be calculated rather than the chi-squared and its significance level.  We
recommend specifying {opt exact} whenever samples are small. 
When the least-frequent cell contains 
1,000 cases or more, there will be no appreciable difference between the exact 
significance level and the significance level based on the chi-squared, but the
exact significance level will take considerably longer to calculate.  
{opt exact} does not affect whether exact confidence intervals are calculated.
Commands always calculate exact confidence intervals where they can, unless
{opt cornfield} or {opt woolf} is specified.

{phang}
{opt level(#)} 
specifies the confidence level, as a
percentage, for confidence intervals.  The default is {cmd:level(95)} or as
set by {helpb set level}.


{marker options_csi}{...}
{title:Options for csi}

{phang}
{opt or} 
reports the calculation of the odds ratio in addition to the risk ratio if 
{opt by()} is not specified.  With {opt by()}, {opt or} specifies that a 
Mantel-Haenszel estimate of the combined odds ratio be made rather than the 
Mantel-Haenszel estimate of the risk ratio.  In either case, this is the same 
calculation that would be made by {helpb cc} and {helpb cci}.  Typically,
{cmd:cc}, {cmd:cci}, or {helpb tabodds} is preferred for calculating odds
ratios.  

{phang}
{opt woolf} requests that the
{help cs##W1955:Woolf (1955)} approximation, also known as the Taylor
expansion, be used for calculating the standard error and confidence interval
for the odds ratio.  By default, {cmd:csi} with the {cmd:or} option reports the
{help cs##C1956:Cornfield (1956)} interval.

{phang}
{opt exact} requests that Fisher's exact 
p be calculated rather than the chi-squared and its significance level.  We
recommend specifying {opt exact} whenever samples are small.  
When the least-frequent cell contains 
1,000 cases or more, there will be no appreciable difference between the exact 
significance level and the significance level based on the chi-squared, but the
exact significance level will take considerably longer to calculate.  
{opt exact} does not affect whether exact confidence intervals are calculated.
Commands always calculate exact confidence intervals where they can, unless
{opt cornfield} or {opt woolf} is specified.

{phang}
{opt level(#)} 
specifies the confidence level, as a
percentage, for confidence intervals.  The default is {cmd:level(95)} or as
set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse csxmpl}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Calculate risk differences, risk ratios, etc.{p_end}
{phang2}{cmd:. cs case exp [fw=pop]}

{pstd}Immediate form of above command{p_end}
{phang2}{cmd:. csi 7 12 9 2}

{pstd}Same as above, but calculate Fisher's exact p rather than the chi-squared
{p_end}
{phang2}{cmd:. csi 7 12 9 2, exact}

{pstd}Calculate risk differences, risk ratios, etc., and report the odds
ratio{p_end}
{phang2}{cmd:. cs case exp [fw=pop], or}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ugdp}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Perform stratified analysis of cumulative incidence data{p_end}
{phang2}{cmd:. cs case exposed [fw=pop], by(age)}

{pstd}Same as above, but report the odds ratio, rather than the risk
ratio{p_end}
{phang2}{cmd:. cs case exposed [fw=pop], by(age) or}

{pstd}Perform stratified analysis using internally weighted standardized
estimates{p_end}
{phang2}{cmd:. cs case exposed [fw=pop], by(age) istandard}

{pstd}Perform stratified analysis using externally weighted standardized
estimates{p_end}
{phang2}{cmd:. cs case exposed [fw=pop], by(age) estandard}

{pstd}Create a variable that is always equal to 1{p_end}
{phang2}{cmd:. generate wgt = 1}

{pstd}Perform stratified analysis of the standardized risk ratio, weighting each
age category equally{p_end}
{phang2}{cmd:. cs case exposed [fw=pop], by(age) standard(wgt)}

{pstd}Perform stratified analysis of the standardized risk difference, weighting
each age category equally{p_end}
{phang2}{cmd:. cs case exposed [fw=pop], by(age) standard(wgt) rd}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=ZYaYUpgahv4":Risk ratios calculator}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cs} and {cmd:csi} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(rd)}}risk difference{p_end}
{synopt:{cmd:r(lb_rd)}}lower bound of CI for {cmd:rd}{p_end}
{synopt:{cmd:r(ub_rd)}}upper bound of CI for {cmd:rd}{p_end}
{synopt:{cmd:r(rr)}}risk ratio{p_end}
{synopt:{cmd:r(lb_rr)}}lower bound of CI for {cmd:rr}{p_end}
{synopt:{cmd:r(ub_rr)}}upper bound of CI for {cmd:rr}{p_end}
{synopt:{cmd:r(or)}}odds ratio{p_end}
{synopt:{cmd:r(lb_or)}}lower bound of CI for {cmd:or}{p_end}
{synopt:{cmd:r(ub_or)}}upper bound of CI for {cmd:or}{p_end}
{synopt:{cmd:r(afe)}}attributable (prev.) fraction among exposed{p_end}
{synopt:{cmd:r(lb_afe)}}lower bound of CI for {cmd:afe}{p_end}
{synopt:{cmd:r(ub_afe)}}upper bound of CI for {cmd:afe}{p_end}
{synopt:{cmd:r(afp)}}attributable fraction for the population{p_end}
{synopt:{cmd:r(crude)}}crude estimate ({cmd:cs} only){p_end}
{synopt:{cmd:r(lb_crude)}}lower bound of CI for {cmd:crude}{p_end}
{synopt:{cmd:r(ub_crude)}}upper bound of CI for {cmd:crude}{p_end}
{synopt:{cmd:r(pooled)}}pooled estimate ({cmd:cs} only){p_end}
{synopt:{cmd:r(lb_pooled)}}lower bound of CI for {cmd:pooled}{p_end}
{synopt:{cmd:r(ub_pooled)}}upper bound of CI for {cmd:pooled}{p_end}
{synopt:{cmd:r(chi2_mh)}}Mantel-Haenszel heterogeneity chi-squared ({cmd:cs}
	only){p_end}
{synopt:{cmd:r(chi2_p)}}pooled heterogeneity chi-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom ({cmd:cs} only){p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(p_exact)}}2-sided Fisher's exact p ({cmd:exact} only){p_end}
{synopt:{cmd:r(p1_exact)}}1-sided Fisher's exact p ({cmd:exact} only){p_end}


{marker references}{...}
{title:References}

{marker C1956}{...}
{phang}
Cornfield, J. 1956. A statistical problem arising from retrospective studies.
In Vol. 4 of {it:Proceedings of the Third Berkeley Symposium}, ed.
J. Neyman, 135-148. Berkeley, CA: University of California Press.

{marker W1955}{...}
{phang}
Woolf, B. 1955. On estimating the relation between blood group disease.
{it:Annals of Human Genetics} 19: 251-253.
Reprinted in
{it:Evolution of Epidemiologic Ideas: Annotated Readings on Concepts and Methods},
ed. S. Greenland, pp. 108-110. Newton Lower Falls, MA: Epidemiology Resources.
{p_end}
