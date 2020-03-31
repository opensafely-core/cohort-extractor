{smcl}
{* *! version 1.3.4  15may2018}{...}
{viewerdialog ir "dialog ir"}{...}
{viewerdialog iri "dialog iri"}{...}
{vieweralsosee "[R] Epitab" "mansection R Epitab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] dstdize" "help dstdize"} {...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "[U] 19 Immediate commands" "help immed"}{...}
{viewerjumpto "Syntax" "ir##syntax"}{...}
{viewerjumpto "Menu" "ir##menu"}{...}
{viewerjumpto "Description" "ir##description"}{...}
{viewerjumpto "Links to PDF documentation" "ir##linkspdf"}{...}
{viewerjumpto "Options" "ir##options"}{...}
{viewerjumpto "Examples" "ir##examples"}{...}
{viewerjumpto "Video example" "ir##video"}{...}
{viewerjumpto "Stored results" "ir##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] Epitab} {hline 2}}Tables for epidemiologists (ir and iri)
{p_end}
{p2col:}({mansection R Epitab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}{cmd:ir} {it:var_case} {it:var_exposed} {it:var_time} {ifin}
[{it:{help ir##weight:weight}}]
[{cmd:,} {it:{help ir##ir_options:ir_options}}]

{p 8 14 2}{cmd:iri} {it:#a #b #N1 #N2} [{cmd:,} {opt l:evel(#)}]

{synoptset 24 tabbed}{...}
{marker ir_options}{...}
{synopthdr :ir_options}
{synoptline}
{syntab:Options}
{synopt :{cmd:by(}{varname} [{cmd:,} {opt mis:sing}]{cmd:)}}stratify on {it:varname}{p_end}
{synopt :{opt es:tandard}}combine external weights with within-stratum statistics{p_end}
{synopt :{opt is:tandard}}combine internal weights with within-stratum statistics{p_end}
{synopt :{opth s:tandard(varname)}}combine user-specified weights with within-stratum statistics{p_end}
{synopt :{opt p:ool}}display pooled estimate{p_end}
{synopt :{opt noc:rude}}do not display crude estimate{p_end}
{synopt :{opt noh:om}}do not display homogeneity test{p_end}
{synopt :{opt ird}}calculate standard incidence-rate difference{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:ir}
{phang2}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
       {bf:Incidence-rate ratio}

    {title:iri}

{phang2}
{bf:Statistics > Epidemiology and related > Tables for epidemiologists >}
        {bf:Incidence-rate ratio calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ir} is used with incidence-rate (incidence-density or person-time) data.
It calculates point estimates and confidence intervals for the incidence-rate 
ratio and difference, along with attributable or prevented fractions for the 
exposed and total population.  {cmd:iri} is the immediate form of {cmd:ir}; see
{help immed}.  Also see {manhelp poisson R} and {manhelp stcox ST} for related
commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R EpitabQuickstart:Quick start}

        {mansection R EpitabRemarksandexamples:Remarks and examples}

        {mansection R EpitabMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{cmd:by(}{varname} [{cmd:,} {opt missing}]{cmd:)} specifies that the tables be
stratified on {it:varname}.  Missing categories in {it:varname} are omitted
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
{opt estandard} external weights are the person-time for the unexposed
controls.

{pmore}
{cmd:istandard} internal weights are the person-time for the exposed controls.
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
{opt ird} may be used only with {opt estandard}, {opt istandard}, or
{opt standard()}.  It requests that {cmd:ir} calculate the standardized 
incidence-rate difference rather than the default incidence-rate ratio.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse irxmpl}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Calculate incidence-rate ratios, differences, etc.{p_end}
{phang2}{cmd:. ir cases exposed time}

{pstd}Immediate form of above command{p_end}
{phang2}{cmd:. iri 15 41 19017 28010}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse rm}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Perform stratified analysis of the incidence-rate ratio{p_end}
{phang2}{cmd:. ir deaths male pyears, by(age)}

{pstd}Same as above, but report 90% confidence intervals{p_end}
{phang2}{cmd:. ir deaths male pyears, by(age) level(90)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse dollhill2}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Perform stratified analysis of the incidence-rate ratio, reporting 90% 
confidence intervals{p_end}
{phang2}{cmd:. ir deaths smokes pyears, by(age) level(90)}

{pstd}Perform stratified analysis of the standardized incidence-rate ratio,
reporting 90% confidence intervals{p_end}
{phang2}{cmd:. ir deaths smokes pyears, by(age) level(90) istandard}

{pstd}Same as above, but also display the directly pooled estimate{p_end}
{phang2}{cmd:. ir deaths smokes pyears, by(age) level(90) istandard pool}

{pstd}Same as above, but compute the standardized incidence-rate difference,
rather than the incidence-rate ratio{p_end}
{phang2}{cmd:. ir deaths smokes pyears, by(age) level(90) istandard pool ird}

{pstd}Perform stratified analysis of the standardized incidence-rate ratio,
making weights proportional to person-time of the unexposed group{p_end}
{phang2}{cmd:. ir deaths smokes pyears, by(age) estandard}

{pstd}Create a variable that is always equal to 1{p_end}
{phang2}{cmd:. generate conswgt = 1}

{pstd}Perform stratified analysis of the standardized incidence-rate ratio,
weighting each age category equally{p_end}
{phang2}{cmd:. ir deaths smokes pyears, by(age) standard(conswgt)}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=6JANRVFxqAw":Incidence-rate ratios calculator}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ir} and {cmd:iri} store the following in {cmd:r()}:

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
{synopt:{cmd:r(crude)}}crude estimate ({cmd:ir} only){p_end}
{synopt:{cmd:r(lb_crude)}}lower bound of CI for {cmd:crude}{p_end}
{synopt:{cmd:r(ub_crude)}}upper bound of CI for {cmd:crude}{p_end}
{synopt:{cmd:r(pooled)}}pooled estimate ({cmd:ir} only){p_end}
{synopt:{cmd:r(lb_pooled)}}lower bound of CI for {cmd:pooled}{p_end}
{synopt:{cmd:r(ub_pooled)}}upper bound of CI for {cmd:pooled}{p_end}
{synopt:{cmd:r(chi2_mh)}}Mantel-Haenszel homogeneity chi-squared ({cmd:ir}
	only){p_end}
{synopt:{cmd:r(chi2_p)}}pooled homogeneity chi-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom ({cmd:ir} only){p_end}
