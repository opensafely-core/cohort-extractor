{smcl}
{* *! version 1.3.6  15may2018}{...}
{viewerdialog cc "dialog cc"}{...}
{viewerdialog cci "dialog cci"}{...}
{vieweralsosee "[R] Epitab" "mansection R Epitab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] dstdize" "help dstdize"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "[U] 19 Immediate commands" "help immed"}{...}
{viewerjumpto "Syntax" "cc##syntax"}{...}
{viewerjumpto "Menu" "cc##menu"}{...}
{viewerjumpto "Description" "cc##description"}{...}
{viewerjumpto "Links to PDF documentation" "cc##linkspdf"}{...}
{viewerjumpto "Options for cc" "cc##options_cc"}{...}
{viewerjumpto "Options for cci" "cc##options_cci"}{...}
{viewerjumpto "Examples" "cc##examples"}{...}
{viewerjumpto "Video examples" "cc##videos"}{...}
{viewerjumpto "Stored results" "cc##results"}{...}
{viewerjumpto "References" "cc##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] Epitab} {hline 2}}Tables for epidemiologists (cc and cci)
{p_end}
{p2col:}({mansection R Epitab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:cc} {it:var_case var_exposed} {ifin}
[{it:{help cc##weight:weight}}]
[{cmd:,} {it:{help cc##cc_options:cc_options}}]

{p 8 14 2}{cmd:cci} {it:#a #b #c #d} [{cmd:,} {it:{help cc##cci_options:cci_options}}]

{synoptset 24 tabbed}{...}
{marker cc_options}{...}
{synopthdr:cc_options}
{synoptline}
{syntab:Options}
{synopt :{cmd:by(}{varname} [{cmd:,} {opt mis:sing}]{cmd:)}}stratify on {it:varname}{p_end}
{synopt :{opt es:tandard}}combine external weights with within-stratum statistics{p_end}
{synopt :{opt is:tandard}}combine internal weights with within-stratum statistics{p_end}
{synopt :{opth s:tandard(varname)}}combine user-specified weights with within-stratum statistics{p_end}
{synopt :{opt p:ool}}display pooled estimate{p_end}
{synopt :{opt noc:rude}}do not display crude estimate{p_end}
{synopt :{opt noh:om}}do not display homogeneity test{p_end}
{synopt :{opt bd}}perform Breslow-Day homogeneity test{p_end}
{synopt :{opt t:arone}}perform Tarone's homogeneity test{p_end}
{synopt :{opth b:inomial(varname)}}number of subjects variable{p_end}
{synopt :{opt co:rnfield}}use Cornfield approximation to calculate CI of the odds ratio{p_end}
{synopt :{opt w:oolf}}use Woolf approximation to calculate SE and CI of the odds ratio{p_end}
{synopt :{opt e:xact}}calculate Fisher's exact p{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 21}{...}
{marker cci_options}{...}
{synopthdr :cci_options}
{synoptline}
{synopt :{opt co:rnfield}}use Cornfield approximation to calculate CI of the odds ratio{p_end}
{synopt :{opt w:oolf}}use Woolf approximation to calculate SE and CI of the odds ratio{p_end}
{synopt :{opt e:xact}}calculate Fisher's exact p{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:cc}

{phang2}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
      {bf:Case-control odds ratio}

    {title:cci}

{phang2}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
       {bf:Case-control odds-ratio calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cc} is used with case-control and cross-sectional data.  It
calculates point estimates and confidence intervals for the odds ratio, along
with attributable or prevented fractions for the exposed and total population.
{cmd:cci} is the immediate form of {cmd:cc}; see {help immed}.  Also see
{manhelp logistic R} for related commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R EpitabQuickstart:Quick start}

        {mansection R EpitabRemarksandexamples:Remarks and examples}

        {mansection R EpitabMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_cc}{...}
{title:Options for cc}

{dlgtab:Options}

{phang}
{cmd:by(}{it:varname} [{cmd:,} {opt missing}]{cmd:)} specifies that the tables
be stratified on {it:varname}.  Missing categories in {it:varname} are omitted
from the stratified analysis, unless option {cmd:missing} is specified within
{cmd:by()}.  Within-stratum statistics are shown and then combined with
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
{opt estandard} external weights are the number of unexposed controls.

{pmore}
{cmd:istandard} internal weights are the number of exposed
controls.  {opt istandard} can be used to produce, among other things,
standardized mortality ratios (SMRs).

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
{opt bd} specifies that Breslow and Day's chi-squared test of 
homogeneity be included in the output of a stratified analysis.  This tests 
whether the exposure effect is the same across strata.  {opt bd} is relevant 
only if {opt by()} is also specified.

{phang}
{opt tarone} specifies that Tarone's chi-squared test of homogeneity, which is
a correction to the Breslow-Day test, be included in the output of a
stratified analysis.  This tests whether the exposure effect is the same
across strata.  {opt tarone} is relevant only if {opt by()} is also specified.

{phang}
{opth binomial(varname)} supplies the 
number of subjects (cases plus controls) for binomial frequency records.  For 
individual and simple frequency records, this option is not used.

{phang}
{opt cornfield} requests that the 
{help cc##C1956:Cornfield (1956)} approximation be used to calculate the
confidence interval of the odds ratio.  By default, {cmd:cc} reports an exact
interval. 

{phang}
{opt woolf} requests that the
{help cc##W1955:Woolf (1955)} approximation, also known as the Taylor
expansion, be used for calculating the standard error and confidence interval
for the odds ratio.  By default, {cmd:cc} reports an exact interval.

{phang}
{opt exact} requests that Fisher's exact 
p be calculated rather than the chi-squared and its significance level.  We
recommend specifying {opt exact} whenever samples are small.
When the least-frequent cell contains 1,000 cases or more, there will be no
appreciable difference between the exact significance level and the
significance level based on the chi-squared, but the exact significance level
will take considerably longer to calculate.  {opt exact} does not affect
whether exact confidence intervals are calculated.  Commands always calculate
exact confidence intervals where they can, unless {opt cornfield} or
{opt woolf} is specified.

{phang}
{opt level(#)} specifies the confidence level, as a 
percentage, for confidence intervals.  The default is {cmd:level(95)} or as 
set by {helpb set level}.


{marker options_cci}{...}
{title:Options for cci}

{phang}
{opt cornfield} requests that the 
{help cc##C1956:Cornfield (1956)} approximation be used to calculate the
confidence interval of the odds ratio.  By default, {cmd:cci} reports an exact
interval. 

{phang}
{opt woolf} requests that the
{help cc##W1955:Woolf (1955)} approximation, also known as the Taylor
expansion, be used for calculating the standard error and confidence interval
for the odds ratio.  By default, {cmd:cci} reports an exact interval.

{phang}
{opt exact} requests that Fisher's exact 
p be calculated rather than the chi-squared and its significance level.  We
recommend specifying {opt exact} whenever samples are small.  
When the least-frequent cell contains 1,000 cases or more, there will be no
appreciable difference between the exact significance level and the
significance level based on the chi-squared, but the exact significance level
will take considerably longer to calculate.  {opt exact} does not affect
whether exact confidence intervals are calculated.  Commands always calculate
exact confidence intervals where they can, unless {opt cornfield} or
{opt woolf} is specified.

{phang}
{opt level(#)} specifies the confidence level, as a 
percentage, for confidence intervals.  The default is {cmd:level(95)} or as 
set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ccxmpl}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Calculate odds ratio, etc.{p_end}
{phang2}{cmd:. cc case exposed [fw=pop]}

{pstd}Immediate form of above command{p_end}
{phang2}{cmd:. cci 4 386 4 1250}

{pstd}Same as above, but calculate Fisher's exact p rather than the
chi-squared{p_end}
{phang2}{cmd:. cci 4 386 4 1250, exact}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse downs}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Perform stratified analysis of the odds ratio{p_end}
{phang2}{cmd:. cc case exposed [fw=pop], by(age)}

{pstd}Same as above, but report Tarone's chi-squared test of homogeneity{p_end}
{phang2}{cmd:. cc case exposed [fw=pop], by(age) tarone}{p_end}
    {hline}


{marker videos}{...}
{title:Video examples}

{phang}
{browse "http://www.youtube.com/watch?v=RKWYNI7AORw":Odds ratios for case-control data}

{phang}
{browse "http://www.youtube.com/watch?v=CHTfzJLSbWM":Stratified analysis of case-control data}

{phang}
{browse "http://www.youtube.com/watch?v=A1c4ElvFHIE":Odds ratios calculator}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cc} and {cmd:cci} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(p1_exact)}}one-sided p-value for Fisher's exact test{p_end}
{synopt:{cmd:r(p_exact)}}two-sided p-value for Fisher's exact test{p_end}
{synopt:{cmd:r(or)}}odds ratio{p_end}
{synopt:{cmd:r(lb_or)}}lower bound of CI for {cmd:or}{p_end}
{synopt:{cmd:r(ub_or)}}upper bound of CI for {cmd:or}{p_end}
{synopt:{cmd:r(afe)}}attributable (prev.) fraction among exposed{p_end}
{synopt:{cmd:r(lb_afe)}}lower bound of CI for {cmd:afe}{p_end}
{synopt:{cmd:r(ub_afe)}}upper bound of CI for {cmd:afe}{p_end}
{synopt:{cmd:r(afp)}}attributable fraction for the population{p_end}
{synopt:{cmd:r(crude)}}crude estimate ({cmd:cc} only){p_end}
{synopt:{cmd:r(lb_crude)}}lower bound of CI for {cmd:crude}{p_end}
{synopt:{cmd:r(ub_crude)}}upper bound of CI for {cmd:crude}{p_end}
{synopt:{cmd:r(pooled)}}pooled estimate ({cmd:cc} only){p_end}
{synopt:{cmd:r(lb_pooled)}}lower bound of CI for {cmd:pooled}{p_end}
{synopt:{cmd:r(ub_pooled)}}upper bound of CI for {cmd:pooled}{p_end}
{synopt:{cmd:r(chi2_p)}}pooled heterogeneity chi-squared{p_end}
{synopt:{cmd:r(chi2_bd)}}Breslow-Day chi-squared{p_end}
{synopt:{cmd:r(df_bd)}}degrees of freedom for Breslow-Day chi-squared{p_end}
{synopt:{cmd:r(chi2_t)}}Tarone chi-squared{p_end}
{synopt:{cmd:r(df_t)}}degrees of freedom for Tarone chi-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}


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
