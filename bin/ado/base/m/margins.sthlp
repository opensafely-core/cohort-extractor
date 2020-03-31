{smcl}
{* *! version 1.4.17  18feb2020}{...}
{viewerdialog margins "dialog margins"}{...}
{vieweralsosee "[R] margins" "mansection R margins"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] margins, contrast" "help margins_contrast"}{...}
{vieweralsosee "[R] margins, pwcompare" "help margins_pwcompare"}{...}
{vieweralsosee "[R] margins postestimation" "help margins postestimation"}{...}
{vieweralsosee "[R] marginsplot" "help marginsplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] nlcom" "help nlcom"}{...}
{vieweralsosee "[R] predict" "help predict"}{...}
{vieweralsosee "[R] predictnl" "help predictnl"}{...}
{viewerjumpto "Syntax" "margins##syntax"}{...}
{viewerjumpto "Menu" "margins##menu"}{...}
{viewerjumpto "Description" "margins##description"}{...}
{viewerjumpto "Links to PDF documentation" "margins##linkspdf"}{...}
{viewerjumpto "Options" "margins##options"}{...}
{viewerjumpto "Examples" "margins##examples"}{...}
{viewerjumpto "Video examples" "margins##video"}{...}
{viewerjumpto "Addendum:  Syntax of at()" "margins##atspec"}{...}
{viewerjumpto "Stored results" "margins##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] margins} {hline 2}}Marginal means, predictive margins, and
marginal effects
{p_end}
{p2col:}({mansection R margins:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin}
[{it:{help margins##weight:weight}}]
[{cmd:,} 
{it:{help margins##response_options:response_options}}
{it:{help margins##options_table:options}}] 

{pstd}
where {it:marginlist} is a list of factor variables or interactions that
appear in the current estimation results.  The variables may be typed 
with or without the {cmd:i.} prefix, and you may use any factor-variable
syntax:

		. {cmd:margins i.sex i.group i.sex#i.group}

		. {cmd:margins sex group sex#i.group}

		. {cmd:margins sex##group}

{marker response_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr:response_options}
{synoptline}
{syntab :Main}
{synopt:{opt pr:edict(pred_opt)}}estimate
	margins for {cmd:predict,} {it:pred_opt}{p_end}
{synopt:{opt exp:ression}{cmd:(}{it:{help margins##pnl:pnl_exp}}{cmd:)}}estimate
	margins for {it:pnl_exp}{p_end}
{synopt:{opth dydx(varlist)}}estimate
	marginal effect of variables in {it:varlist}{p_end}
{synopt:{opth eyex(varlist)}}estimate
	elasticities of variables in {it:varlist}{p_end}
{synopt:{opth dyex(varlist)}}estimate
	semielasticity -- d({it:y})/d(ln{it:x}){p_end}
{synopt:{opth eydx(varlist)}}estimate
	semielasticity -- d(ln{it:y})/d({it:x}){p_end}
{synopt:{opt cont:inuous}}treat factor-level indicators as continuous{p_end}
{synoptline}

{marker options_table}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt:{opt grand}}add 
	the overall margin; default if no {it:marginlist}{p_end}

{syntab :At}
{synopt:{cmd:at(}{it:{help margins##atspec:atspec}{cmd:)}}}estimate 
	margins at specified values of covariates{p_end}
{synopt:{opt atmeans}}estimate 
	margins at the means of covariates{p_end}
{synopt:{opt asbal:anced}}treat
	all factor variables as balanced{p_end}

{syntab :if/in/over}
{synopt:{opth over(varlist)}}estimate
	margins at unique values of {it:varlist}{p_end}
{synopt:{cmd:subpop(}{it:{help margins##subspec:subspec}}{cmd:)}}estimate
	margins for subpopulation{p_end}

{syntab :Within}
{synopt:{opth within(varlist)}}estimate
	margins at unique values of the nesting factors in {it:varlist}{p_end}

{syntab:Contrast}
{synopt :{it:contrast_options}}any 
	options documented in {manhelp margins_contrast R:margins, contrast}
        {p_end}

{syntab:Pairwise comparisons}
{synopt :{it:pwcompare_options}}any 
	options documented in {manhelp margins_pwcompare R:margins, pwcompare}{p_end}

{syntab:SE}
{synopt:{cmd:vce(delta)}}estimate SEs using delta method; the default{p_end}
{synopt:{cmd:vce(unconditional)}}estimate SEs allowing for sampling of covariates{p_end}
{synopt:{opt nose}}do not estimate SEs{p_end}

{syntab :Advanced}
{synopt:{opt noweight:s}}ignore
	weights specified in estimation{p_end}
{synopt:{opt noe:sample}}do
	not restrict {cmd:margins} to the estimation sample{p_end}
{synopt:{opt emptycells}{cmd:(}{it:{help margins##empspec:empspec}{cmd:)}}}treatment of empty cells for balanced factors{p_end}
{synopt:{opt estimtol:erance(tol)}}specify numerical tolerance used to determine estimable functions; default is {cmd:estimtolerance(1e-5)}{p_end}
{synopt:{opt noestimcheck}}suppress estimability
	checks{p_end}
{synopt :{opt force}}estimate margins
	despite potential problems{p_end}
{synopt :{opt chain:rule}}use the
	chain rule when computing derivatives{p_end}
{synopt :{opt nochain:rule}}do
	not use the chain rule{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opth mcomp:are(margins##method:method)}}adjust for multiple
	comparisons; default is {cmd:mcompare(noadjust)}{p_end}
{synopt:{opt noatlegend}}suppress 
	legend of fixed covariate values{p_end}
{synopt:{opt post}}post margins and their VCE as estimation results{p_end}
{synopt :{it:{help margins##display_options:display_options}}}control
       columns and column formats, row spacing, line width, and
       factor-variable labeling
       {p_end}

{synopt :{opt df(#)}}use t distribution with {it:#} degrees of freedom for
      computing p-values and confidence intervals{p_end}
{synoptline}

{p2colreset}{...}
{marker method}{...}
{synoptset 22}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt noadj:ust}}do not adjust for multiple comparisons; the default{p_end}
{synopt:{opt bon:ferroni} [{opt adjustall}]}Bonferroni's method; adjust across all terms{p_end}
{synopt:{opt sid:ak} [{opt adjustall}]}Sidak's method; adjust across all terms{p_end}
{synopt:{opt sch:effe}}Scheffe's method{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
Time-series operators are allowed if they were used in the estimation.
{p_end}
{pstd}
See {bf:{help margins##at_op:at()}} under  
{it:Options} for a description of {it:atspec}.{p_end}
{marker weight}{...}
{pstd}
{cmd:fweight}s, {cmd:aweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed;
see {help weight}.
{p_end}
{p 4 6 2}
{opt df(#)} does not appear in the dialog box.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
Margins are statistics calculated from predictions of a previously fit
model at fixed values of some covariates and averaging or otherwise
integrating over the remaining covariates.

{pstd}
The {cmd:margins} command estimates margins of responses for
specified values of covariates and presents the results as a table.  

{pstd}
Capabilities include estimated marginal means, least-squares means, average
and conditional marginal and partial effects (which may be reported as
derivatives or as elasticities), average and conditional adjusted
predictions, and predictive margins.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R marginsQuickstart:Quick start}

        {mansection R marginsRemarksandexamples:Remarks and examples}

        {mansection R marginsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
{it:Warning:}
{it:The option descriptions are brief and use jargon.}
{it:Skip to} 
{bf:{mansection R marginsRemarksandexamples:Remarks and examples}} in
{bf:[R] margins}
{it:if you are}
{it:reading about} {cmd:margins} 
{it:for the first time.}

{dlgtab:Main}

{phang} 
{opt predict(pred_opt)} and {opt expression(pnl_exp)} 
    are mutually exclusive; they specify the response.
    If neither is specified, the response will be the default 
    prediction that would be produced by {cmd:predict} after the underlying
    estimation command.
    Some estimation commands,
    such as {helpb mlogit postestimation##margins:mlogit},
    document a different default prediction for {cmd:margins} than for
    {cmd:predict}.

{phang2}
    {opt predict(pred_opt)} specifies the option(s) to be specified with 
    the {cmd:predict} command to produce the variable that will be used as the
    response.  After estimation by {cmd:logistic}, you could
    specify {cmd:predict(xb)} to obtain linear predictions rather than
    the {cmd:predict} command's default, the probabilities.

{pmore2}
    Multiple {opt predict()} options can be specified to compute margins of
    multiple predictions simultaneously.

{marker pnl}{...}
{phang2}
    {opt expression(pnl_exp)} specifies the response as an expression.
    See {it:{mansection R predictnlDescription:Description}} and
    {it:{mansection R predictnlRemarksandexamples:Remarks and examples}} in
    {bf:[R] predictnl} for a
    full description of {it:pnl_exp}.  After estimation by {cmd:logistic}, you
    might specify {cmd:expression(exp(predict(xb)))} to use relative odds
    rather than probabilities as the response.  For examples, see
    {it:{mansection R marginsRemarksandexamplesExample12Marginsofaspecifiedexpression:Example 12: Margins of a specified expression}} in {manlink R margins}.

{phang}
{opth dydx(varlist)}, {opt eyex(varlist)}, {opt dyex(varlist)}, and
{opt eydx(varlist)} 
    request that {cmd:margins} report derivatives of the response 
    with respect to {it:varlist} rather than on the response itself.
    {cmd:eyex()}, {cmd:dyex()}, and {cmd:eydx()} report derivatives 
    as elasticities; see 
{it:{mansection R marginsRemarksandexamplesExpressingderivativesaselasticities:Expressing derivatives as elasticities}} in {manlink R margins}.
    
{phang}
{opt continuous}
    is relevant only when one of {cmd:dydx()} or
    {cmd:eydx()} is also specified.
    It specifies that the levels of factor variables be treated
    as continuous; see
{it:{mansection R marginsRemarksandexamplesDerivativesversusdiscretedifferences:Derivatives versus discrete differences}} in {manlink R margins}.
    This option is implied if there is a single-level factor variable
    specified in {opt dydx()} or {opt eydx()}.

{phang}
{opt grand} specifies that the overall margin be reported. 
        {cmd:grand} is assumed when {it:marginlist} is empty.

{dlgtab:At}

{marker at_op}{...}
{phang} 
{opt at(atspec)} 
    specifies values for covariates to be treated as fixed.

{phang2}
    {cmd:at(age=20)} fixes covariate {cmd:age} to the value specified.
    {cmd:at()} may be used to fix continuous or factor covariates.

{phang2}
    {cmd:at(age=20 sex=1)} simultaneously fixes covariates {cmd:age} 
    and {cmd:sex} at the values specified.  

{phang2} 
    {cmd:at(age=(20 30 40 50))} fixes age first at 20, then at 30, ....
    {cmd:margins} produces separate results for each specified value.

{phang2}
    {cmd:at(age=(20(10)50))} does the same as 
    {cmd:at(age=(20 30 40 50))}; that is, you may specify a 
    {help numlist}.

{phang2}
    {cmd:at((mean) age{bind:  }(median) distance)} 
    fixes the covariates at the 
    summary statistics specified.
    {cmd:at((p25) _all)} fixes all covariates at their 25th percentile values.
    See {it:{help margins##atspec:Syntax of at()}} 
    for the full list of summary-statistic modifiers.

{phang2} 
    {cmd:at((mean) _all{bind:  }(median) x{bind:  }x2=1.2{bind:  }z=(1 2 3))}
    is read from left to right, with latter specifiers overriding former
    ones.  Thus, all covariates are fixed at their means except for 
    {cmd:x} (fixed at its median), {cmd:x2} (fixed at 1.2), and 
    {cmd:z} (fixed first at 1, then at 2, and finally at 3).

{phang2} 
    {cmd:at((means) _all{bind:  }(asobserved) x2)}
    is a convenient way to set all covariates except {cmd:x2} to the mean.

{pmore} 
    Multiple {cmd:at()} options can be specified, and each will 
    produce a different set of margins.

{pmore} 
    See {it:{help margins##atspec:Syntax of at()}} for more information.

{phang}
{opt atmeans} 
    specifies that covariates be fixed at their means and 
    is shorthand for {cmd:at((mean) _all)}.  
    {cmd:atmeans} 
    differs from {cmd:at((mean) _all)} in that {cmd:atmeans} will affect
    subsequent {cmd:at()} options.  
    For instance, 

		. {cmd:margins} ...{cmd:, atmeans  at((p25) x)  at((p75) x)} 

{pmore}
    produces two sets of margins with both sets evaluated at the means of all
    covariates except {cmd:x}.

{phang}
{opt asbalanced}
    is shorthand for {cmd:at((asbalanced) _factor)} and 
    specifies that factor covariates be evaluated as though there
    were an equal number of observations in each level;
    see 
    {it:{mansection R marginsRemarksandexamplesObtainingmarginsasthoughthedatawerebalanced:Obtaining margins as though the data were balanced}} in {manlink R margins}.
    {cmd:asbalanced} differs from {cmd:at((asbalanced) _factor)}
    in that {cmd:asbalanced} will affect subsequent {cmd:at()} options
    in the same way as {cmd:atmeans} does.

{dlgtab:if/in/over}

{phang}
{opth over(varlist)} specifies that separate sets of margins be estimated
    for the groups defined by {it:varlist}.  The variables in {it:varlist}
    must contain nonnegative integer (or missing) values.  The variables need
    not be covariates in your model.  When {cmd:over()} is combined with the
    {cmd:vce(unconditional)} option, each group is treated as a subpopulation;
    see {manlink SVY Subpopulation estimation}.

{marker subspec}{...}
{phang}
{cmd:subpop(}[{varname}] [{it:{help if}}]{cmd:)} 
    is intended for use with the {cmd:vce(unconditional)} option.  
    It specifies that margins be estimated for the single subpopulation
    identified by the indicator variable or by the {cmd:if} expression 
    or by both.  Zero or missing indicates that the observation be excluded; 
    nonzero or nonmissing, that it be included.
    See {manlink SVY Subpopulation estimation} for why {cmd:subpop()}
    is preferred to {cmd:if} expressions and {helpb in} ranges when also using
    {cmd:vce(unconditional)}.
    If {cmd:subpop()} is used without {cmd:vce(unconditional)}, it 
    is treated merely as an additional {cmd:if} qualifier.

{dlgtab:Within}

{phang}
{opt within(varlist)} 
    allows for nested designs.  {it:varlist} contains the nesting variable(s)
    over which margins are to be estimated.
    See 
    {it:{mansection R marginsRemarksandexamplesObtainingmarginswithnesteddesigns:Obtaining margins with nested designs}} in {manlink R margins}.
    As with {cmd:over(}{it:varlist}{cmd:)}, when 
    {cmd:within(}{it:varlist}{cmd:)} is combined with 
    {cmd:vce(unconditional)}, each level of the variables in {it:varlist} 
    is treated as a subpopulation.

{dlgtab:Contrast}

{phang}
{it:contrast_options} 
        are any of the options documented in
        {manhelp margins_contrast R:margins, contrast}.

{dlgtab:Pairwise comparisons}

{phang}
{it:pwcompare_options} 
        are any of the options documented in
        {manhelp margins_pwcompare R:margins, pwcompare}.

{dlgtab:SE}

{phang}
{cmd:vce(delta)} and {cmd:vce(unconditional)} 
    specify how the VCE and, correspondingly, standard errors are calculated.

{phang2}
    {cmd:vce(delta)} is the default.  The delta method is applied to 
    the formula for the response and the VCE of the estimation command.
    This method assumes that values of the covariates
    used to calculate the response are 
    given or, if all covariates are not fixed using {cmd:at()},
    that the data are given.

{phang2}
    {cmd:vce(unconditional)} specifies that the covariates that are not fixed
    be treated in a way that accounts for their having been sampled.  The VCE
    is estimated using the linearization method.  This method allows for
    heteroskedasticity or other violations of distributional assumptions and 
    allows for correlation among the observations in the same  manner as 
    {cmd:vce(robust)} and {cmd:vce(cluster }{it:...}{cmd:)}, which
    may have been specified with the estimation command.  This method 
    also accounts for complex survey designs if the data are {cmd:svyset}. See
    {it:{mansection R marginsRemarksandexamplesObtainingmarginswithsurveydataandrepresentativesamples:Obtaining margins with survey data and representative samples}} in {manlink R margins}.
     When you use complex survey data, this method requires that the
     linearized variance estimation method be used for the model.
     See {manlink SVY svy postestimation} for an
     {mansection SVY svypostestimationRemarksandexamplessvypost_repbased:example}
     of {cmd:margins} with replication-based methods.

{phang} 
{opt nose}
     suppresses calculation of the VCE and standard errors.
     See 
{it:{mansection R marginsRemarksandexamplesRequirementsformodelspecification:Requirements for model specification}} in {manlink R margins}
     for an example of the use of this option.

{dlgtab:Advanced}

{phang}
{opt noweights}
    specifies that any weights specified on the previous estimation command 
    be ignored by {cmd:margins}.  By default, {cmd:margins} uses the weights
    specified on the estimator to average responses and to compute summary
    statistics.  If {it:weights} are specified on the
    {cmd:margins} command, they override previously specified weights, making
    it unnecessary to specify {cmd:noweights}.  The {cmd:noweights} option is
    not allowed after {cmd:svy:} estimation when the  
    {cmd:vce(unconditional)} option is specified.

{pmore}
    For multilevel models, such as {helpb meglm}, the default behavior is to
    construct a single weight value for each observation by multiplying
    the corresponding multilevel weights within the given observation.

{phang}
{opt noesample} 
    specifies that {cmd:margins} not restrict its computations to the
    estimation sample used by the previous estimation command.
    See 
{it:{mansection R marginsRemarksandexamplesExample15Marginsevaluatedoutofsample:Example 15: Margins evaluated out of sample}} in {manlink R margins}.

{pmore}
    With the default delta-method VCE, {opt noesample} margins may
    be estimated on samples other
    than the estimation sample; such results are valid under the
    assumption that the data used are treated as being given.

{pmore}
    You can specify {cmd:noesample} and {cmd:vce(unconditional)} together, but
    if you do, you should be sure that the data in memory correspond
    to the original {cmd:e(sample)}.   To show that you understand that, 
    you must also specify the {cmd:force} option.  Be aware that making 
    the {cmd:vce(unconditional)} calculation on a sample different from 
    the estimation sample would be equivalent to 
    estimating the coefficients on one set of data and computing the scores
    used by the linearization on another set; see {manlink P _robust}.
    
{marker empspec}{...}
{phang}
{cmd:emptycells(strict)} and {cmd:emptycells(reweight)}
     are relevant only when the {cmd:asbalanced} option is also specified.
     {cmd:emptycells()} specifies how empty cells are handled in interactions
     involving factor variables that are being treated 
     as balanced; see
{it:{mansection R marginsRemarksandexamplesObtainingmarginsasthoughthedatawerebalanced:Obtaining margins as though the data were balanced}} in {manlink R margins}.

{phang2}
    {cmd:emptycells(strict)} is the default; it specifies that margins 
    involving empty cells be treated as not estimable.

{phang2}
    {cmd:emptycells(reweight)} specifies that the effects of the observed
    cells be increased to accommodate any missing cells.  This makes the
    margin estimable but changes its interpretation.  
    {cmd:emptycells(reweight)} is implied when the {cmd:within()} option
    is specified.

{phang}
{opt estimtolerance(tol)} specifies the numerical tolerance used to
determine estimable functions.  The default is {cmd:estimtolerance(1e-5)}.

{pmore}
A linear combination of the model coefficients {it:z} is found to be not
estimable if

{pmore2}
{cmd:mreldif(}{it:z}{cmd:,} {it:z*H}{cmd:)} > {it:tol}

{pmore}
where {it:H} is defined in 
{mansection R marginsMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt noestimcheck}
    specifies that {cmd:margins} not check for estimability.  By default, the
    requested margins are checked and those found not estimable are reported
    as such.  Nonestimability is usually caused by empty cells.  If
    {cmd:noestimcheck} is specified, estimates are computed in the usual way
    and reported even though the resulting estimates are manipulable, which is
    to say they can differ across equivalent models having different
    parameterizations.  See
{it:{mansection R marginsRemarksandexamplesEstimabilityofmargins:Estimability of margins}} in {manlink R margins}.
    
{phang} 
{opt force} 
    instructs {cmd:margins} to proceed in some situations where it would
    otherwise issue an error message because of apparent violations of
    assumptions.  Do not be casual about specifying {cmd:force}.  You need to
    understand and fully evaluate the statistical issues.  For an example
    of the use of {cmd:force}, see 
{it:{mansection R marginsRemarksandexamplesUsingmarginsaftertheestimatesusecommand:Using margins after the estimates use command}} in {manlink R margins}.

{phang}
{opt chainrule} and {opt nochainrule} specify whether {cmd:margins} uses 
     the chain rule when numerically computing derivatives.
     You need not specify these options when using {cmd:margins} after any
     official Stata estimator; {cmd:margins} will choose the appropriate
     method automatically.

{pmore}
    Specify {cmd:nochainrule} after estimation by a community-contributed
    command.  We recommend using {cmd:nochainrule}, even though {cmd:chainrule}
    is usually safe and is always faster.  {cmd:nochainrule} is safer because
    it makes no assumptions about how the parameters and covariates join to
    form the response. 

{pmore}
    {cmd:nochainrule} is implied when the {cmd:expression()} option is
    specified.

{dlgtab:Reporting}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt mcompare(method)}
specifies the method for computing p-values and confidence intervals 
that account for multiple comparisons within a factor-variable term.

{pmore}
Most methods adjust the comparisonwise error rate, alpha_c, to 
achieve a prespecified experimentwise error rate, alpha_e.

{phang2}
{cmd:mcompare(noadjust)} 
is the default; it specifies no adjustment.

{center: alpha_c = alpha_e}

{phang2}
{cmd:mcompare(bonferroni)} 
adjusts the comparisonwise error rate based on the upper limit of the
Bonferroni inequality

{center: alpha_e <= m * alpha_c}

{pmore2}
where {it:m} is the number of comparisons within the term.

{pmore2}
The adjusted comparisonwise error rate is

{center: alpha_c = alpha_e/m}

{phang2}
{cmd:mcompare(sidak)}
adjusts the comparisonwise error rate based on the upper limit of the 
probability inequality

{center:alpha_e <= 1 - (1 - alpha_c)^m}

{pmore2}
where {it:m} is the number of comparisons within the term.

{pmore2}
The adjusted comparisonwise error rate is

{center:alpha_c = 1 - (1 - alpha_e)^(1/m)}

{pmore2}
This adjustment is exact when the {it:m} comparisons are independent.

{phang2}
{cmd:mcompare(scheffe)}
controls the experimentwise error rate using the F or chi-squared
distribution with degrees of freedom equal to the rank of the term.

{phang2}
{cmd:mcompare(}{it:method} {cmd:adjustall)} specifies that the
multiple-comparison adjustments count all comparisons across all terms rather
than performing multiple comparisons term by term. This leads to more
conservative adjustments when multiple variables or terms are specified in
{it:marginslist}.  This option is compatible only with the {cmd:bonferroni} and
{cmd:sidak} methods.

{phang}
{opt noatlegend} 
    specifies that the legend showing the fixed values of covariates be
    suppressed.

{phang} 
{opt post} 
causes {cmd:margins} to behave like a Stata estimation (e-class) command.
{cmd:margins} posts the vector of estimated margins along with the
estimated variance-covariance matrix to {cmd:e()}, so you can treat the
estimated margins just as you would results from any other estimation
command.  For example, you could use {cmd:test} to perform simultaneous tests
of hypotheses on the margins, or you could use {cmd:lincom} to create linear
combinations.  See
{it:{mansection R marginsRemarksandexamplesExample10Testingmargins---contrastsofmargins:Example 10: Testing margins -- contrasts of margins}} in {manlink R margins}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt vsquish},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}.

{phang2}
{opt noci} 
suppresses confidence intervals from being reported in the coefficient table.

{phang2}
{opt nopvalues}
suppresses p-values and their test statistics from being reported in the
coefficient table.

{phang2}
{opt vsquish} 
specifies that the blank space separating factor-variable terms or
time-series-operated variables from other variables in the model be suppressed.

{phang2}
{opt nofvlabel} displays factor-variable level values rather than attached value
labels.  This option overrides the {cmd:fvlabel} setting; see 
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt fvwrap(#)} allows long value labels to wrap the first {it:#}
lines in the coefficient table.  This option overrides the
{cmd:fvwrap} setting; see {helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt fvwrapon(style)} specifies whether value labels that wrap will break
at word boundaries or break based on available space.

{phang3}
{cmd:fvwrapon(word)}, the default, specifies that value labels break at
word boundaries.

{phang3}
{cmd:fvwrapon(width)} specifies that value labels break based on available
space.

{pmore2}
This option overrides the {cmd:fvwrapon} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt cformat(%fmt)} specifies how to format margins, standard errors, and
confidence limits in the table of estimated margins.

{phang2}
{opt pformat(%fmt)} specifies how to format p-values in the table of estimated margins.

{phang2}
{opt sformat(%fmt)} specifies how to format test statistics in the 
table of estimated margins.

{phang2}
{opt nolstretch} specifies that the width of the table of estimated margins
not be automatically widened to accommodate longer variable names. The default,
{cmd:lstretch}, is to automatically widen the table of estimated margins up to
the width of the Results window.  To change the default, use
{helpb lstretch:set lstretch off}.  {opt nolstretch} is not shown in the dialog
box.

{pstd}
The following option is available with {opt margins} but is not shown in the
dialog box:

{phang}
{opt df(#)} specifies that the t distribution with {it:#} degrees of
freedom be used for computing p-values and confidence intervals.
The default typically is to use the standard normal distribution.
However, if the estimation command computes the residual degrees of
freedom ({cmd:e(df_r)}) and {cmd:predict(xb)} is specified with {cmd:margins},
the default is to use the t distribution with {cmd:e(df_r)} degrees of
freedom.


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:margins} and examples with discussion see
{it:{mansection R marginsRemarksandexamples:Remarks and examples}} in
{manlink R margins}.


{title:Examples:  obtaining margins of responses}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse margex}

{pstd}A simple case after regress{p_end}
{phang2}{cmd:. regress y i.sex i.group}{p_end}
{phang2}{cmd:. margins sex}{p_end}

{pstd}A simple case after logistic{p_end}
{phang2}{cmd:. logistic outcome i.sex i.group}{p_end}
{phang2}{cmd:. margins sex}{p_end}

{pstd}Average response versus response at average{p_end}
{phang2}{cmd:. margins sex}{p_end}
{phang2}{cmd:. margins sex, atmeans}{p_end}

{pstd}Multiple margins from one {cmd:margins} command{p_end}
{phang2}{cmd:. margins sex group}{p_end}

{pstd}Margins with interaction terms{p_end}
{phang2}{cmd:. logistic outcome i.sex i.group sex#group}{p_end}
{phang2}{cmd:. margins sex group}{p_end}

{pstd}Margins with continuous variables{p_end}
{phang2}{cmd:. logistic outcome i.sex i.group sex#group age}{p_end}
{phang2}{cmd:. margins sex group}{p_end}

{pstd}Margins of continuous variables{p_end}
{phang2}{cmd:. logistic outcome i.sex i.group sex#group age}{p_end}
{phang2}{cmd:. margins sex group}{p_end}
{phang2}{cmd:. margins, at(age=40)}{p_end}
{phang2}{cmd:. margins, at(age=(30 35 40 45 50))}{p_end}
{phang3}Or, equivalently{p_end}
{phang2}{cmd:. margins, at(age=(30(5)50))}{p_end}

{pstd}Margins of interactions{p_end}
{phang2}{cmd:. margins sex#group}{p_end}

{pstd}Margins of a specified prediction{p_end}
{phang2}{cmd:. tobit ycn i.sex i.group sex#group age, ul(90)}{p_end}
{phang2}{cmd:. margins sex, predict(ystar(.,90))}{p_end}

{pstd}Margins of a specified expression{p_end}
{phang2}{cmd:. margins sex, expression( predict(ystar(.,90)) / predict(xb) )}

{pstd}Margins with multiple outcomes (responses){p_end}
{phang2}{cmd:. mlogit group i.sex age}{p_end}
{phang2}{cmd:. margins sex}{p_end}
{phang2}{cmd:. margins sex, predict(outcome(1))}{p_end}

{pstd}Margins with multiple equations{p_end}
{phang2}{cmd:. sureg (y = i.sex age) (distance = i.sex i.group)}{p_end}
{phang2}{cmd:. margins sex}{p_end}
{phang2}{cmd:. margins sex, predict(equation(y))}{p_end}
{phang2}{cmd:. margins sex,}
     {cmd:expression(predict(equation(y)) - predict(equation(distance)))}{p_end}

{pstd}Margins evaluated out of sample{p_end}
{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. tobit ycn i.sex i.group sex#group age, ul(90)}{p_end}
{phang2}{cmd:. webuse peach}{p_end}
{phang2}{cmd:. margins sex, predict(ystar(.,90)) noesample}


{title:Examples:  obtaining marginal effects}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. logistic outcome treatment##group age c.age#c.age treatment#c.age}

{pstd}Average marginal effect (partial effects) of one covariate{p_end}
{phang2}{cmd:. margins, dydx(treatment)}{p_end}

{pstd}Average marginal effects of all covariates{p_end}
{phang2}{cmd:. margins, dydx(*)}{p_end}

{pstd}Marginal effects evaluated over the response surface{p_end}
{phang2}{cmd:. margins group, dydx(treatment) at(age=(20(10)60))}{p_end}


{title:Examples:  obtaining margins with survey data and representative samples}

{pstd}Inferences for populations, margins of response{p_end}
{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. logistic outcome i.sex i.group sex#group age, vce(robust)}{p_end}
{phang2}{cmd:. margins sex group, vce(unconditional)}{p_end}

{pstd}Inferences for populations, marginal effects{p_end}
{phang2}{cmd:. margins, dydx(*) vce(unconditional)}{p_end}

{pstd}Inferences for populations with svyset data{p_end}
{phang2}{cmd:}{p_end}
{phang2}{cmd:. webuse nhanes2}{p_end}
{phang2}{cmd:. svyset}{p_end}
{phang2}{cmd:. svy: logistic highbp sex##agegrp##c.bmi}{p_end}
{phang2}{cmd:. margins agegrp, vce(unconditional)}{p_end}


{title:Examples:  obtaining margins as though the data were balanced}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse acmemanuf}{p_end}

{pstd}Balancing using asbalanced{p_end}
{phang2}{cmd:. regress y pressure##temp}{p_end}
{phang2}{cmd:. margins, asbalanced}{p_end}

{pstd}Balancing nonlinear responses{p_end}
{phang2}{cmd:. logistic acceptable pressure##temp}{p_end}
{phang2}{cmd:. margins, asbalanced}{p_end}

{pstd}Treating a subset of covariates as balanced{p_end}
{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. regress y arm##sex sex##agegroup}{p_end}
{phang2}{cmd:. margins, at((asbalanced) arm)}{p_end}
{phang2}{cmd:. margins, at((asbalanced) arm agegroup)}{p_end}
{phang2}{cmd:. margins, at((asbalanced) arm agegroup sex)}{p_end}

{pstd}Balancing in the presence of empty cells{p_end}
{phang2}{cmd:. webuse estimability}{p_end}
{phang2}{cmd:. regress y sex##group}{p_end}
{phang2}{cmd:. margins sex, asbalanced}{p_end}
{phang2}{cmd:. margins sex, asbalanced emptycells(reweight)}{p_end}


{marker video}{...}
{title:Video examples}

{phang}
{browse "http://www.youtube.com/watch?v=XAG4CbIbH0k":Introduction to margins, part 1: Categorical variables}

{phang}
{browse "http://www.youtube.com/watch?v=L9-PWY79aVA":Introduction to margins, part 2: Continuous variables}

{phang}
{browse "http://www.youtube.com/watch?v=43uX4D_7uaI":Introduction to margins, part 3: Interactions}


{marker atspec}{...}
{title:Addendum:  {it:Syntax of at()}}

{pstd}
In option {cmd:at(}{it:atspec}{cmd:)},
{it:atspec} may contain one or more of the following specifications:

{p 12 12 2}
{it:varlist}

{p 12 12 2}
{cmd:(}{it:stat}{cmd:)} {it:varlist} 

{p 12 12 2}
{it:varname} {cmd:=} {it:#}

{p 12 12 2}
{it:varname} {cmd:= (}{it:{help numlist}}{cmd:)} 

{p 12 12 2}
{it:varname} {cmd:=} {opth gen:erate(exp)}

{pstd}
where

{p 12 15 2}
    1. {it:varname}s must be covariates in the current estimation results.

{p 12 15 2}
    2. Variable names (whether in {it:varname} or {it:varlist}) 
       may be continuous variables, factor variables, or virtual level
       variables, such as {cmd:age}, {cmd:group}, or {cmd:3.group}.

{p 12 15 2}
3. {it:varlist} may also be one of three standard lists:
{p_end}
{p 19 22 2}
a. {opt _all} (all covariates),
{p_end}
{p 19 22 2}
b. {opt _f:actor} (all factor-variable covariates), or
{p_end}
{p 19 22 2}
c. {opt _c:ontinuous} (all continuous covariates).
{p_end}

{p 12 15 2}
4. Specifications are processed from left to right with latter specifications 
   overriding previous ones.

{p 12 15 2}
5. {it:stat} can be any of the following:

{p2colset 5 22 24 2}{...}
{p2line}
{p2col :}         				{space 44}Variables{p_end}
{p2col :{it:stat}} Description			{space 32}allowed{p_end}
{p2line}
{p2col :{opt asobs:erved}} at observed values in the sample (default)
			{space 1}all{p_end}
{p2col :{opt mean}}   means (default for {it:varlist})  {space 16}all{p_end}
{p2col :{opt median}} medians			{space 36}continuous{p_end}
{p2col :{opt p1}}     1st percentile		{space 29}continuous{p_end}
{p2col :{opt p2}}     2nd percentile		{space 29}continuous{p_end}
{p2col :{it:...}}     3rd-49th percentiles {space 23}continuous{p_end}
{p2col :{opt p50}}    50th percentile (same as {cmd:median}) 
						{space 11}continuous{p_end}
{p2col :{it:...}}     51st-97th percentiles {space 22}continuous{p_end}
{p2col :{opt p98}}    98th percentile		{space 28}continuous{p_end}
{p2col :{opt p99}}    99th percentile		{space 28}continuous{p_end}
{p2col :{opt min}}    minimums			{space 35}continuous{p_end}
{p2col :{opt max}}    maximums			{space 35}continuous{p_end}
{p2col :{opt zero}}   fixed at zero		{space 30}continuous{p_end}
{p2col :{opt base}}   base level 		{space 33}factors{p_end}
{p2col :{opt asbal:anced}} all levels equally probable and sum to 1
						{space 3}factors{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Any {it:stat} except {cmd:zero}, {cmd:base}, and {cmd:asbalanced} may be
prefixed with an {cmd:o} to get the overall statistic -- the sample over all
{cmd:over()} groups.  For example, {cmd:omean}, {cmd:omedian}, and {cmd:op25}.
Overall statistics differ from their correspondingly named statistics only
when the {cmd:over()} or {cmd:within()} option is specified.  When no
{it:stat} is specified, {cmd:mean} is assumed.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:margins} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_sub)}}subpopulation observations{p_end}
{synopt:{cmd:r(N_clust)}}number of clusters{p_end}
{synopt:{cmd:r(N_psu)}}number of sampled PSUs, survey data only{p_end}
{synopt:{cmd:r(N_strata)}}number of strata, survey data only{p_end}
{synopt:{cmd:r(df_r)}}variance degrees of freedom, survey data only{p_end}
{synopt:{cmd:r(N_poststrata)}}number of post strata, survey data only{p_end}
{synopt:{cmd:r(k_predict)}}number of {opt predict()} options{p_end}
{synopt:{cmd:r(k_margins)}}number of terms in {it:marginlist}{p_end}
{synopt:{cmd:r(k_by)}}number of subpopulations{p_end}
{synopt:{cmd:r(k_at)}}number of {opt at()} options{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:margins}{p_end}
{synopt:{cmd:r(cmdline)}}command as typed{p_end}
{synopt:{cmd:r(est_cmd)}}{cmd:e(cmd)} from original estimation results{p_end}
{synopt:{cmd:r(est_cmdline)}}{cmd:e(cmdline)}
	from original estimation results{p_end}
{synopt:{cmd:r(title)}}title in output{p_end}
{synopt:{cmd:r(subpop)}}{it:subspec} from {cmd:subpop()}{p_end}
{synopt:{cmd:r(model_vce)}}{it:vcetype} from estimation command{p_end}
{synopt:{cmd:r(model_vcetype)}}Std. Err. title from estimation command{p_end}
{synopt:{cmd:r(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:r(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:r(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:r(margins)}}{it:marginlist}{p_end}
{synopt:{cmd:r(predict}{it:#}{cmd:_opts)}}the {it:#}th {cmd:predict()} option{p_end}
{synopt:{cmd:r(predict}{it:#}{cmd:_label)}}label from the {it:#}th {cmd:predict()} option{p_end}
{synopt:{cmd:r(expression)}}response expression{p_end}
{synopt:{cmd:r(xvars)}}{it:varlist} from {cmd:dydx()}, {cmd:dyex()},
					{cmd:eydx()}, or {cmd:eyex()}{p_end}
{synopt:{cmd:r(derivatives)}}"", "dy/dx", "dy/ex", "ey/dx", "ey/ex"{p_end}
{synopt:{cmd:r(over)}}{it:varlist} from {cmd:over()}{p_end}
{synopt:{cmd:r(within)}}{it:varlist} from {cmd:within()}{p_end}
{synopt:{cmd:r(by)}}union of {cmd:r(over)} and {cmd:r(within)} lists{p_end}
{synopt:{cmd:r(by}{it:#}{cmd:)}}interaction notation identifying the {it:#}th
					subpopulation{p_end}
{synopt:{cmd:r(atstats}{it:#}{cmd:)}}the {it:#}th {cmd:at()} specification
{p_end}
{synopt:{cmd:r(emptycells)}}{it:empspec} from {cmd:emptycells()}{p_end}
{synopt:{cmd:r(mcmethod)}}{it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mcadjustall)}}{opt adjustall} or empty{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(b)}}estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the estimates{p_end}
{synopt:{cmd:r(Jacobian)}}Jacobian matrix{p_end}
{synopt:{cmd:r(_N)}}sample size corresponding to each margin estimate{p_end}
{synopt:{cmd:r(at)}}matrix of values from the {cmd:at()} options{p_end}
{synopt:{cmd:r(chainrule)}}chain rule information from the fitted model{p_end}
{synopt:{cmd:r(error)}}margin estimability codes;{break}
        {cmd:0} means estimable,{break}
        {cmd:8} means not estimable{p_end}
{synopt:{cmd:r(table)}}matrix
        containing the margins with their standard errors, test statistics,
        p-values, and confidence intervals{p_end}
{p2colreset}{...}


{pstd}
{cmd:margins} with the {cmd:post} option also stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_sub)}}subpopulation observations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(N_psu)}}number of sampled PSUs, survey data only{p_end}
{synopt:{cmd:e(N_strata)}}number of strata, survey data only{p_end}
{synopt:{cmd:e(df_r)}}variance degrees of freedom, survey data only{p_end}
{synopt:{cmd:e(N_poststrata)}}number of post strata, survey data only{p_end}
{synopt:{cmd:e(k_predict)}}number of {opt predict()} options{p_end}
{synopt:{cmd:e(k_margins)}}number of terms in {it:marginlist}{p_end}
{synopt:{cmd:e(k_by)}}number of subpopulations{p_end}
{synopt:{cmd:e(k_at)}}number of {opt at()} options{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:margins}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(est_cmd)}}{cmd:e(cmd)} from original estimation results{p_end}
{synopt:{cmd:e(est_cmdline)}}{cmd:e(cmdline)}
	from original estimation results{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(subpop)}}{it:subspec} from {cmd:subpop()}{p_end}
{synopt:{cmd:e(model_vce)}}{it:vcetype} from estimation command{p_end}
{synopt:{cmd:e(model_vcetype)}}Std. Err. title from estimation command{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}, or just {cmd:b} if {cmd:nose} is specified{p_end}
{synopt:{cmd:e(margins)}}{it:marginlist}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}
{synopt:{cmd:e(predict}{it:#}{cmd:_opts)}}the {it:#}th {cmd:predict()} option{p_end}
{synopt:{cmd:e(predict}{it:#}{cmd:_label)}}label from the {it:#}th {cmd:predict()} option{p_end}
{synopt:{cmd:e(expression)}}prediction expression{p_end}
{synopt:{cmd:e(xvars)}}{it:varlist} from {cmd:dydx()}, {cmd:dyex()},
					{cmd:eydx()}, or {cmd:eyex()}{p_end}
{synopt:{cmd:e(derivatives)}}"", "dy/dx", "dy/ex", "ey/dx", "ey/ex"{p_end}
{synopt:{cmd:e(over)}}{it:varlist} from {cmd:over()}{p_end}
{synopt:{cmd:e(within)}}{it:varlist} from {cmd:within()}{p_end}
{synopt:{cmd:e(by)}}union of {cmd:r(over)} and {cmd:r(within)} lists{p_end}
{synopt:{cmd:e(by}{it:#}{cmd:)}}interaction notation identifying the {it:#}th
					subpopulation{p_end}
{synopt:{cmd:e(atstats}{it:#}{cmd:)}}the {it:#}th {cmd:at()} specification
{p_end}
{synopt:{cmd:e(emptycells)}}{it:empspec} from {cmd:emptycells()}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimates{p_end}
{synopt:{cmd:e(Jacobian)}}Jacobian matrix{p_end}
{synopt:{cmd:e(_N)}}sample size corresponding to each margin estimate{p_end}
{synopt:{cmd:e(error)}}error code corresponding to {cmd:e(b)}{p_end}
{synopt:{cmd:e(at)}}matrix of values from the {cmd:at()} options{p_end}
{synopt:{cmd:e(chainrule)}}chain rule information from the fitted model{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
