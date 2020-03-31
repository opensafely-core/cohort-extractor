{smcl}
{* *! version 1.12.13  03feb2020}{...}
{vieweralsosee "[P] version" "mansection P version"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{viewerjumpto "Syntax" "version##syntax"}{...}
{viewerjumpto "Description" "version##description"}{...}
{viewerjumpto "Links to PDF documentation" "version##linkspdf"}{...}
{viewerjumpto "Options" "version##options"}{...}
{viewerjumpto "Remarks" "version##remarks"}{...}
{viewerjumpto "Summary of version changes" "version##summary"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] version} {hline 2}}Version control{p_end}
{p2col:}({mansection P version:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Show version number to which command interpreter is set

	{cmdab:vers:ion}


{phang}
    Interactively or in do-files (but not in ado-files or programs defined by {helpb program})

{p 9 9 2}
        Set command interpreter to version {it:#} 
        and set other features such as random-number generators (RNGs) to
	version {it:#}

	    {cmdab:vers:ion} {it:#}

	    {cmdab:vers:ion} {it:#}{cmd::} {it:command}


    In ado-files or programs (but not interactively or in do-files)

{p 9 9 2}
	Set command interpreter to version {it:#}, but do not set other
	features such as RNGs to version {it:#}

	    {cmdab:vers:ion} {it:#} [{cmd:,} {cmd:born(}{it:ddMONyyyy}{cmd:)}]

	    {cmdab:vers:ion} {it:#} [{cmd:,} {cmd:born(}{it:ddMONyyyy}{cmd:)}]{cmd::}  {it:command}


    Everywhere (interactively, in do-files, in ado-files, and in programs)

        Set only the other features such as RNGs to version {it:#}

	    {cmdab:vers:ion} {it:#}{cmd:,} {cmd:user}

	    {cmdab:vers:ion} {it:#}{cmd:,} {cmd:user}{cmd::}  {it:command}


{marker description}{...}
{title:Description}

{pstd}
{cmd:version} with no arguments shows the current internal version number to
which the command interpreter is set.  It can be used interactively, in
do-files, or in ado-files. 

{pstd}
{cmd:version} {it:#} sets the command interpreter and other features such as
random-number generators to version {it:#}.  {cmd:version} {it:#} is used to
allow old programs to run correctly under more recent versions of Stata and to
ensure that new programs run correctly under future versions of Stata.

{pstd}
{cmd:version} {it:#}{cmd::} executes {it:command} under version {it:#} and
then resets the version to what it was before the
{cmd:version} {it:#}{cmd::} ... command was given.

{pstd}
For information about external version control, see {manhelp which R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P versionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:born(}{it:ddMONyyyy}{cmd:)} is rarely specified and indicates that the
Stata executable must be dated {it:ddMONyyyy} (for example, 13Jul2013) or later.
StataCorp and users sometimes write programs in ado-files that require the
Stata executable to be of a certain date.  The {cmd:born()} option allows us or
the author of an ado-file to ensure that ado-code that requires a certain
updated executable is not run with an older executable.

{pmore}
    Generally all that matters is the version number, so you would
    not use the {cmd:born()} option.  You use {cmd:born()} in the rare case
    that you are exploiting a feature added to the executable after the
    initial release of that version of Stata.  See {help whatsnew} to browse
    the features added to the current version of Stata since its original
    release.

{marker userversion}{...}
{phang}
{cmd:user} causes {cmd:version} to backdate other features of Stata.
For instance, the results of Stata's random-number generators (RNGs)
change -- improve -- with each version of Stata.  The RNGs are 
said to be under user-version control rather than version control. 

{pmore}
If you type {cmd:version} {it:#} interactively or in your do-files, Stata not
only understands old syntax but also backdates (removes) improvements made
after {it:#}, such as those to the RNGs.  You do not have to specify the
{cmd:user} option.  The modern version of Stata will still produce the same
results as it produced in the past. 

{pmore}
Programmers:  When you type {cmd:version} {it:#} in your programs and
ado-files, Stata does not backdate the other improvements.  If, for some
reason, you want to force the other improvements to be backdated, specify the
{cmd:user} option.  Option {cmd:user} is seldom used except by those
(say, developers at StataCorp) needing to test that Stata works properly.


{marker remarks}{...}
{title:Remarks}

{pstd}
All programs and do-files written for the current version of Stata should
include {cmd:version {ccl stata_version}} as the first executable statement.

{pstd}
Programs and do-files written for earlier releases should include the
appropriate {cmd:version} line at the top.

{pstd}
Stata is continually being improved, meaning that programs and do-files
written for older versions might stop working.  The solution is to specify the
version of Stata that you are using at the top of programs and do-files that
you write, for example,

	{hline 33} begin myprog.do {hline 3}
	{cmd:version {ccl stata_version}}

	use mydata, clear
	regress ...
	...
	{hline 35} end myprog.do {hline 3}


	{hline 31} begin example.ado {hline 3}
	program myprog
		{cmd:version {ccl stata_version}}
		...
	end
	{hline 33} end example.ado {hline 3}

{pstd}
Future versions of Stata will then continue to interpret your programs
correctly.

{pstd}
All programs distributed by StataCorp have a version statement; thus, old
programs work even if Stata has changed.


{marker summary}{...}
{title:Summary of version changes}

{pstd}
There have been many changes made to Stata over the years.  Most do not
matter in the sense that they will not break old programs even if the version
is not set correctly.  However, some changes in Stata will break old programs
unless the version number is set back to the appropriate version number.  The
list below outlines these important changes.  This list is probably of
interest only to those trying to update an old program to a new version's
syntax -- most people will just set the version number appropriately
instead and not worry about any of this.


    {title:If you set version to less than 16.1}

{phang2}1.  The default number of iterations, as controlled by
        {helpb set maxiter}, will be 16000.


    {title:If you set version to less than 16.0}

{phang2}1.  Stata will allow the name {cmd:_se} to be used when creating
	a variable, matrix, or scalar.

{phang2}2.  {helpb margins saving:margins} with the {cmd:saving()}
	option will save the standard errors of the estimated margin
	values using a variable named {cmd:_se} instead of
	{cmd:_se_margin}.

{phang2}3.  {helpb list} will assign a default base level for factor
	variables when one is not already specified.

{phang2}4.  {helpb summarize} will assign a default base level for factor
	variables when one is not already specified.

{phang2}5.  {helpb mean}, {helpb proportion}, {helpb ratio}, and {helpb total}
	will not use or support factor-variable notation.
	Empty cells identified with unobserved level combinations of
	variables in the {cmd:over()} option are dropped.

{phang2}6.  {helpb proportion} will allow the previously documented
	{cmd:missing} option.  This option treated missing values as
	valid categories, rather than being omitted from the analysis.

{phang2}7.  {helpb mean} will no longer post {cmd:e(sd)}, the vector of
	standard deviation estimates.

{phang2}8.  {helpb bayesstats ess} will not display efficiency summaries
        in the header such as minimum efficiency, average efficiency, and
        maximum efficiency over the model parameters.

{phang2}9.  Stata functions {helpb colnumb()} and {helpb rownumb()},
	extended macro functions {helpb macro##macro_fcn:colnumb} and
        {helpb macro##macro_fcn:rownumb}, and Mata functions
	{helpb mf_st_ms_utils:st_matrixcolnumb()} and
        {helpb mf_st_ms_utils:st_matrixrownumb()} no longer support
        abbreviations in references to matrix stripe elements.

{phang2}10. {helpb import delimited} has no restriction on the number of rows
	when searching for a binding quote when option {cmd:bindquote(strict)}
	is specified.

{phang2}11. {cmd:c(changed)} will not be updated for any of the following:

                - modifying characteristics for a dataset or variable
                - modifying notes of a dataset or variable
                - modifying the label of a dataset or variable
                - modifying the format of a variable
                - using {helpb compress} on the dataset resulting in a change
                  of a variables storage type

{phang2}12. {helpb hetprobit} will label the log-standard deviation as
	{cmd:lnsigma2}, rather than {cmd:lnsigma}, in both output and matrix
	stripe.

{phang2}13. {helpb bayesmh} and {helpb bayes} prefix commands will not save 
         variable {cmd:_chain} in simulation datasets. Variable {cmd:_chain} is 
         used for indicating the chain number, and it is present even when 
         there is only one chain.  

{phang2}14. {helpb total} will accept {helpb aweight}s.
	Support for {cmd:aweight}s was removed from this command because
	the interpretation of {cmd:aweight}ed data is nonsensical for
	the total.  {cmd:total} was never documented to support
	{cmd:aweight}s but accepted them prior to Stata 16.

{phang2}15. {helpb arfima} residual variance parameter in {bf:e(b)} and
	{bf:e(V)} is labeled {bf:sigma2:_cons}.

{phang2}16. {helpb mgarch ccc}, {helpb mgarch dcc}, and {helpb mgarch vcc}
	correlation parameters in {bf:e(b)} and {bf:e(V)} are labeled
	{bf:corr(}{it:level_i}{bf:,}{it:level_j}{bf:):_cons}.
	The DCC and VCC lambda parameters are labeled 
	{bf:Adjustment:lambda}{it:i}.
	The t-distribution degrees-of-freedom parameter is labeled
	{bf:df:_cons}.

{phang2}17. {helpb mgarch dvech} sigma parameter in {bf:e(b)} and {bf:e(V)}
	is labeled {bf:Sigma0:_cons}.  The t-distribution degrees-of-freedom
	parameter is labeled {bf:df:_cons}.

{phang2}18. {helpb svar} matrix {bf:A}, {bf:B}, and {bf:C} parameters in
	{bf:e(b)} and {bf:e(V)} are labeled 
	{bf:a_}{it:i}{bf:_}{it:j}{bf::_cons},
	{bf:b_}{it:i}{bf:_}{it:j}{bf::_cons}, and
	{bf:c_}{it:i}{bf:_}{it:j}{bf::_cons}.

{phang2}19. {helpb sspace} dependent variable and state variance component 
	parameters in {bf:e(b)} and {bf:e(V)} are labeled 
	{bf:var(}{it:depvar_i}{bf:):_cons} and 
	{bf:var(}{it:state_i}{bf:):_cons}.

{phang2}20. {helpb dfactor} dependent variable and factor variance component 
	parameters in {bf:e(b)} and {bf:V(b)} are labeled 
	{bf:var(}{it:depvar_i}{bf:):_cons} and 
	{bf:var(}{it:factor_i}{bf:):_cons}.

{phang2}21. {helpb ivprobit} and {helpb ivtobit} arctangent correlation and
	log standard deviation parameters in {bf:e(b)} and {bf:e(V)} are
	labeled {bf:athrho}{it:i}{bf:_}{it:j}{bf::_cons} and
	{bf:lnsigma_}{it:j}{bf::_cons}.

{phang2}22. {helpb bayesmh} and {helpb bayes} prefix commands do not label 
         the variables in the MCMC datasets.  

{phang2}23. {helpb nlogit} dissimilarity and inclusive-value parameters in
	 {bf:e(b)} and {bf:e(V)} are labeled {it:value_label}{bf:_tau:_cons}.

{phang2}24. {helpb matrix coleq} and {helpb matrix roweq} interpret free
	parameter specification {cmd:/}{it:parm} as a shortcut for
	{cmd:/:}{it:parm}.

{phang2}25. {helpb import dbase} and {helpb import delimited} are not
	r-class commands and do not return the number of observations and the
	number of variables imported.

{phang2}26. {helpb nestreg} does not support factor-variable notation.

{phang2}27. {helpb stepwise} does not support factor-variable notation
	and will exit with an error message if it encounters between-term
	collinearity.


    {title:If you set version to less than 15.1}

{phang2}1.  {helpb esizei} for F tests after ANOVA has the following
changes:{p_end}
	{p 12 15}a. Epsilon-squared is labeled using "Omega-Squared", and
	the naive confidence limits are also reported in the table.{p_end}
	{p 12 15}b. The modern omega-squared statistic is no longer
	reported.{p_end}

{phang2}2.  {helpb estat esize} has the following changes:{p_end}
	{p 12 15}a. Epsilon-squared is labeled using "Omega-Squared" and,
	when the {opt omega} option is specified, is reported with confidence
	limits.{p_end}
	{p 12 15}b. The {opt epsilon} option is not allowed.{p_end}

{phang2}3.  {helpb merge} will evaluate its {cmd:keep()} option before
	evaluating its {cmd:assert()} option; thus, it will not result in an
	error in cases where {cmd:keep()} discarded certain observations that
	would have violated the specified {cmd:assert()} option.

{phang2}4.  {helpb drop} and {helpb keep} do not clear results stored in
        {cmd:r()}. They do not store {cmd:r(N_drop)} and {cmd:r(k_drop)}, the
        number of observations and number of variables dropped, respectively. 

{phang2}5.  {helpb gsem} assumes the {cmd:listwise} option when the
	    {cmd:lclass()} option is specified.

{phang2}6.  {helpb zipfile} and {cmd:unzipfile} use a 32-bit library to
            compress and uncompress zip files, which limits file size to
            2 GBs.


    {title:If you set version to less than 15.0}

{phang2}1.  Scale and auxiliary parameters revert to the
	    {it:eqname}{cmd::_cons} form instead of {cmd:/}{it:eqname}
	    for the following estimation commands:

		{helpb biprobit}
		{helpb etpoisson}
		{helpb etregress}
		{helpb gsem_command:gsem}
		{helpb heckman}
		{helpb heckoprobit}
		{helpb heckprobit}
		{helpb irt}
		{helpb ivpoisson}
		{helpb mecloglog}
		{helpb meglm}
		{helpb melogit}
		{helpb menbreg}
		{helpb meologit}
		{helpb meoprobit}
		{helpb mepoisson}
		{helpb meprobit}
		{helpb mestreg}
		{helpb nbreg}
		{helpb ologit}
		{helpb oprobit}
		{helpb rocfit}
		{helpb scobit}
		{helpb sem_command:sem}
		{helpb streg}
		{helpb tnbreg}
		{helpb tobit}
		{helpb truncreg}
		{helpb xtcloglog}
		{helpb xtintreg}
		{helpb xtlogit}
		{helpb xtnbreg}
		{helpb xtologit}
		{helpb xtoprobit}
		{helpb xtpoisson}
		{helpb xtprobit}
		{helpb xttobit}
		{helpb zinb}

{phang2}2.  {helpb tobit} uses the old syntax; see {helpb tobit_14}.
	    The linear equation name is reverted to {cmd:model}, and
	    the scale parameter is reverted to {cmd:sigma:_cons}.

{phang2}3.  {helpb ml} translates {cmd:/}{it:eqname} to
	    {cmd:(}{it:eqname}{cmd::)} instead of
	    {cmd:(}{it:eqname}{cmd::, freeparm)}.

{phang2}4.  {helpb xttobit} and {helpb xtintreg} do not, by default,
	    calculate and display the likelihood-ratio test against
	    the pooled model. 

{phang2}5.  The variables within the column names of covariance
	    estimates are reversed for the following estimation commands:

		{helpb gsem}
		{helpb meglm}
		{helpb melogit}
		{helpb meprobit}
		{helpb mecloglog}
		{helpb meologit}
		{helpb meoprobit}
		{helpb mepoisson}
		{helpb menbreg}
		{helpb mestreg}

{phang2}6.  {cmd:javacall} does not require the {opt jars()} option to find
	    JAR files, although it is recommended.  If the {opt jars()} option
	    is not specified, then all JAR files along the ado-path will be
	    added to the class-path for the plugin.

{phang2}7.  {cmd:estat gof} and {cmd:estat ggof} after {cmd:sem} compute
	    the standardized root mean squared residual (SRMR) by
	    standardizing the fitted covariance elements using fitted
	    variances instead of the sample variances.

{phang2}8.  {helpb bayesmh} excludes omitted regression coefficients such as 
            base levels of factor variables from the estimation matrices 
            {cmd:e(init)}, {cmd:e(Cov)}, {cmd:e(ess)}, {cmd:e(mcse)}, 
            {cmd:e(sd)}, {cmd:e(median)}, {cmd:e(mean)}, and {cmd:e(cri)}.

{phang2}9.  {helpb xtstreg}, {helpb mestreg}, and {helpb gsem} will use a
	    Weibull log likelihood shifted by
	    {cmd:log(}{it:depvar}{cmd:)} for each observation with a
	    failure.

{phang2}10. {helpb streg}'s {cmd:strata()} option does not treat the stratum
	    variable as a factor variable during estimation. Instead, it
 	    generates stratum-specific indicators (dummy variables) for the
 	    stratum variable, includes them in the model, and then leaves them
 	    behind after estimation in the current dataset.
            For example, if {cmd:strata(drug)} is specified and {opt drug}
            contains values of 1, 2, and 3, {cmd:streg, strata(drug)} will
            generate two dummy variables called {cmd:_Sdrug_2} and 
            {cmd:_Sdrug_3} and will include them as independent variables in 
	    the main equation and as covariates in the equations for ancillary
            parameters (if any).

{phang2}11. If user version is less than 15, the levels of factor
	    variables are tracked with the factor instead of the term,
	    even if {cmd:set fvtrack term} is in effect.
	    See {helpb set fvtrack}.

{phang2}12. {helpb icd10 clean} removes the period from the code in the
            specified variable when it standardize the format of codes.

{phang2}13. {helpb frontier} and {helpb xtfrontier} reverts auxiliary parameter 
	    to {cmd:/ilgtgamma} instead of {cmd:/lgtgamma}.

{phang2}14. {helpb bayesmh} with nonlinear models follows different rules when
            you specify linear combinations within substitutable expressions.
	    {p_end}
            {p 12 15}a. When you specify {cmd:{xb: x1 x2}}, the constant term
                       is not included automatically. That is,
                       {bind:{cmd:{xb: x1 x2}}} is equivalent to
                       {bind:{cmd:{xb_x1}*x1 + {xb_x2}*x2}}.{p_end}
            {p 12 15}b. Options {cmd:noconstant} and {cmd:xb} are not allowed
                        within linear-combination specifications.{p_end}
            {p 12 15}c. Regression coefficients of linear combinations are
                       defined as 
		       {cmd:{c -(}}{it:xbname}{cmd:_}{it:varname}{cmd:{c )-}}.
                       For example, if you specify a linear combination
                       {bind:{cmd:{xb: x1 x2}}}, you refer to regression
                       coefficients of variables {cmd:x1} and {cmd:x2} as
                       {cmd:{xb_x1}} and {cmd:{xb_x2}}.{p_end}
            {p 12 15}d. The specification {cmd:{xb:z}} corresponds to the
                       linear combination containing variable {cmd:z}; that
                       is, {cmd:{xb_z}*z}.{p_end}
            {p 12 12}In addition, {cmd:bayesmh} uses a different ordering of
            parameters of nonlinear specifications during simulation and when
            displaying results.  It simulates and displays parameters in the
            same order as they appear in the nonlinear expression.{p_end}

{phang2}15. Matrix stripe name elements using {cmd:var()} or {cmd:cov()}
	    will not be transformed to a canonical form.  For example, a
	    stripe element specified as {cmd:cov(a)} will not be
	    transformed to {cmd:var(a)}, and a stripe element specified as
	    {cmd:var(a,b)} will not be transformed to {cmd:cov(a,b)}.


    {title:If you set version to less than 14.2}

{phang2}1.  {helpb icd10} will use the old syntax and option names.

{phang2}2.  {cmd:predict} after
            {helpb irt_hybrid_postestimation##predict:irt},
            {helpb gsem_predict:gsem},
            {helpb meglm_postestimation##predict:meglm},
            {helpb melogit_postestimation##predict:melogit},
            {helpb meprobit_postestimation##predict:meprobit},
            {helpb mecloglog_postestimation##predict:mecloglog},
            {helpb meologit_postestimation##predict:meologit},
            {helpb meoprobit_postestimation##predict:meoprobit},
            {helpb mepoisson_postestimation##predict:mepoisson},
            {helpb menbreg_postestimation##predict:menbreg},
            and {helpb mestreg_postestimation##predict:mestreg} requires the
            original estimation sample for computing empirical Bayes means,
            empirical Bayes modes, and other predictions that are conditional
            on them.

{phang2}3.  {helpb gmm_postestimation##predict:predict} defaults to option
	    {cmd:residuals} instead of {cmd:xb}.


    {title:If you set version to less than 14.1}

{phang2}1.  {helpb ci} and {helpb cii} use the old syntax; see {helpb ci_14_0}.

{phang2}2.  {helpb eteffects}, {helpb teffects}, and {helpb stteffects}
	    will put the {cmd:r.} contrast operator on the factor
	    variable in the potential-outcome mean equation
	    ({cmd:POmean}).

{phang2}3.  The {helpb ivprobit} parameterization of the covariance parameters
	    has changed for models with more than one endogenous covariate.
	    The Cholesky factored covariance parameterization has been
	    replaced with the {helpb trig_functions:atanh} transformation
	    for the correlation parameters and the {helpb math_functions:log}
	    transformation for the standard deviations.  Transformed
	    correlation parameters are labeled in the stripe of the coefficient
	    vector as {bf:athrho{it:i}_{it:j}}, {it:i}>{it:j}, and the
	    transformed standard-deviation parameters are labeled
	    {bf:lnsigma{it:i}}, {it:i} {ul on}>{ul off} 2.

{phang2}4.  {helpb ivprobit_postestimation##predict:predict, pr} after
	    {bf:ivprobit} and 
	    {helpb ivtobit_postestimation##predict:predict, pr} after 
	    {bf:ivtobit} now include the residuals from the endogenous 
	    model when computing the probabilities.  The estimates from
	    {bf:ivprobit} or {bf:ivtobit} must be run under version 14.1 or
	    higher.

{phang2}5.  {bf:predict} after {helpb xttobit} and {helpb xtintreg} will
	    allow options {bf:pr0()}, {bf:e0()}, and {bf:ystar0()}.

{phang2}6.  {helpb putexcel} will use the old formatting syntax and overwrite
	    cell formats by default.

{phang2}7.  {helpb import delimited} will use a tab character ({cmd:\t})
	    instead of a comma as the default delimiter if it cannot 
	    automatically determine the delimiter used in the file.


    {title:If you set version to less than 14.0}

{phang2}1.  As of Stata 14, Stata's random-number generators (RNGs)
            were improved, renamed, and restructured; see 
            {manhelp set_seed R:set seed}.  The default RNG in Stata 14
            is the 64-bit Mersenne Twister ({cmd:mt64}).  Before 14,
            the RNG was the 32-bit KISS ({cmd:kiss32}). If user version 
            is 14, RNG results are based on {cmd:mt64}. If user version is 
            less than 14, RNG results are based on {cmd:kiss32}.  This
            also affects the results of commands that use the RNGs, such as
            {helpb bootstrap}, {helpb bsample}, and the {helpb mi}
	    suite of commands.

{phang2}2.  If the current RNG is {cmd:kiss32} and the {cmd:kiss32} seed has
	    been set to version 13.1 or earlier, then {cmd:runiform()}
	    generates a random variate on the interval [0,1).  As of Stata 14,
	    {cmd:runiform()} generates random variates on the interval (0,1)
            for all RNGs.

{phang2}3.  {helpb destring}'s {cmd:ignore()} option treats {cmd:asbytes}
 	    as the default rather than {cmd:aschars}.

{phang2}4.  {helpb etregress} reports the treatment coefficient without
            using factor-variable notation (see {helpb fvvarlist}).  An 
            {cmd:lf} evaluator is also used in maximum likelihood estimation 
            (see {helpb ml}).  

{phang2}5.  {helpb icd9} and {helpb icd9p} subcommands {cmd:check} and
	     {cmd:generate} (with option {cmd:description}) will alter the
             sort order.  (Under later versions, they preserve sort order.)

{phang2}6.  {helpb ksmirnov} reports the corrected p-value for one-sample
	    and two-sample tests.

{phang2}7.  {helpb margins} after {helpb mixed} with multilevel weights will
            use only the observation-level weights when computing means.

{phang2}8.  {helpb margins}, after the following estimation commands,
	    changes its default prediction 
	    when neither option {opt predict()} nor option {opt expression()}
	    is specified.

{phang3}a.  For {helpb heckoprobit}, the default is the marginal probability
	    for the first outcome.

{phang3}b.  For
	    {helpb manova}, {helpb mvreg},
	    {helpb mgarch ccc},
	    {helpb mgarch dcc},
	    {helpb mgarch dvech},
	    {helpb mgarch vcc},
	    {helpb reg3},
	    {helpb sureg},
	    {helpb varbasic},
	    {helpb var},
	    and
	    {helpb vec},
	    the default is the linear prediction for the first equation.

{phang3}c.  For
	    {helpb mlogit}, {helpb mprobit},
	    {helpb ologit}, {helpb oprobit},
	    and
	    {helpb slogit},
	    the default is the probability for the first outcome.

{phang3}d.  For
	    {helpb meologit}, {helpb meoprobit},
	    and
	    {helpb meqrlogit},
	    the default is the probability for the first outcome.
	    For models with random effects, this default will typically
	    cause an error because empirical Bayes estimates are not
	    allowed with {cmd:margins}.

{phang3}e.  For {helpb clogit} and {helpb xtlogit:xtlogit,fe}, the default
	    will cause an error because {cmd:predict(pc1)} is not allowed
	    with {cmd:margins}.

{phang3}f.  For {helpb gsem}, the default is the expected value for the first
	    outcome.
	    For {cmd:family(multinomial)} and {cmd:family(ordinal)}, the
	    default is the probability for the first level of the first
	    outcome.
	    For models with latent variables, this default will
	    typically cause an error because empirical Bayes estimates
	    are not allowed with {cmd:margins}.

{phang3}g.  For {helpb rologit}, the default will cause an error because
	    {cmd:predict(pr)} is not allowed with {cmd:margins}.

{phang3}h.  For {helpb sem}, the default will cause an error because
	    {cmd:predict(xb)} is not syntactically compatible with
	    {cmd:margins}.

{phang2}9.  {helpb mi impute pmm}, by default, will perform imputation using
	     one nearest neighbor; that is, it will assume option {cmd:knn(1)}.

{p 7 12 2}
       10.  {helpb mlogit} and {helpb mprobit} will not account for the base
	    outcome equation when constraints are specified using equation
	    indices.  For example,

		{cmd:sysuse auto}
		{cmd:constraint 1 [#2]turn = [#2]trunk}
		{cmd:mlogit rep78 turn trunk, baseoutcome(1) constraint(1)}

{pmore2}    will result in {cmd:[3]turn = [3]trunk} instead of 
	    {cmd:[2]turn = [2]trunk}.

{pmore2}    {cmd:mlogit} and {cmd:mprobit} will not allow constraints defined
	    using outcome values that are associated with a value label.  For
	    example,

		{cmd:label define replab 1 "A" 2 "B" 3 "C" 4 "D" 5 "E"}
		{cmd:label values rep78 replab}
		{cmd:constraint 2 [2]turn = [2]trunk}
		{cmd:mprobit rep78 turn trunk, baseoutcome(1) constraint(1)}

{pmore2}    will drop constraint 2.

{pmore2}    {cmd:mprobit}'s estimated coefficients will only be accessible
	    using the outcome value when the equation name is the outcome
	    value.

{p 7 12 2}
       11.  {helpb gsem_predict:predict} after {helpb gsem} defaults to
	    using the empirical Bayes mean estimates instead of computing
	    predictions that are marginal with respect to latent variables.

{p 7 12 2}
       12.  The default predictions after
	    {helpb meglm_postestimation##predict:meglm},
	    {helpb melogit_postestimation##predict:melogit},
	    {helpb meprobit_postestimation##predict:meprobit},
	    {helpb mecloglog_postestimation##predict:mecloglog},
	    {helpb meologit_postestimation##predict:meologit},
	    {helpb meoprobit_postestimation##predict:meoprobit},
	    {helpb mepoisson_postestimation##predict:mepoisson},
	    and
	    {helpb menbreg_postestimation##predict:menbreg}
	    are computed using the empirical Bayes mean estimates instead of
	    computing predictions that are marginal with respect to the random
	    effects.

{p 7 12 2}
       13.  {helpb reg3} and {helpb sureg} will let collinear variables be
	    identified using matrix inversion instead of using
	    {helpb _rmcoll}.

{p 7 12 2}
       14.  {helpb svy jackknife} will use the default delete-1 multiplier
	    instead of unit values specified in the {opt multiplier()}
	    suboption of option {opt jkrweight()} of {helpb svyset}.


    {title:If you set version to less than 13.1}

{phang2}1.  {helpb mecloglog}, {helpb melogit}, and {helpb meprobit} retain
	    perfect predictors for binary outcome models unless the
	    {opt noasis} option is specified.

{phang2}2.  {helpb bootstrap} and {helpb bsample} with option
	    {opt idcluster()} will create a unique identifier for each
	    resampled cluster but only within strata if the {opt strata()}
	    option is specified.


    {title:If you set version to less than 13.0}

{phang2}1.  The two-argument version of {helpb f_normalden:normalden()} and 
            {helpb f_lnnormalden:lnnormalden()}, respectively, return the
            rescaled standard normal density and its log.  The rescaled
            standard normal density can be interpreted as the density of s*X
            at s*x, where X is standard normal.  The Mata functions
            {helpb mf_normalden:normalden()} and
            {helpb mf_lnnormalden:lnnormalden()} have matching behavior.

{phang2}2.  {helpb margins} will
	    use the standard normal distribution for p-value and confidence
	    interval calculations even if computing margins of the linear
	    prediction and if the current estimation results have
	    the residual degrees of freedom posted to {cmd:e(df_r)}.

{phang2}3.  {helpb nlcom} and {helpb predictnl} will
	    use the {it:t} distribution for p-value and confidence
	    interval calculations if the current estimation results have the
	    residual degrees of freedom posted to {cmd:e(df_r)}.

{phang2}4.  {helpb testnl} will use the {it:F} distribution for p-value
	    calculations if the current estimation results have the residual
	    degrees of freedom posted to {cmd:e(df_r)}.

{phang2}5.  {helpb estimates table} will recognize the original meaning of the
	    {opt label} option, which is to display variable labels rather
	    than variable names.

{phang2}6.  {helpb proportion} will use the normal approximation to compute
	    the limits of confidence intervals.

{phang2}7.  {helpb tsreport}, by default, produces no output and only saves
            {cmd:r(N_gaps)}.

{phang2}8.  {helpb boxcox_postestimation##predict:predict} after {helpb boxcox}
            allows statistic {opt xbt}.  Additionally, statistics {opt yhat}
            and {opt residuals} are estimated using the back-transform method,
            while version 13 uses the smearing method to compute predicted
            values.

{phang2}9.  When you use {help macro}s, the results of
            {help exp:string expressions} will have leading spaces trimmed.

{p 7 12 2}
10.  {helpb sem} will report zero-valued constraints on covariances
	     between exogenous variables.

{p 7 12 2}
11.  {helpb merge} will evaluate its {cmd:keep()} option before evaluating
     its {cmd:assert()} option; thus it will not result in an error in
     cases where {cmd:keep()} discarded certain observations that would
     have violated the specified {cmd:assert()} option.

{p 7 12 2}
12.  {helpb decode} will create strings of at most 244 characters long,
     even if value labels are longer than that.

{p 7 12 2}
13.  {helpb infix} with the {cmd:str} type specification will create strings
     of at most 244 characters long.

{p 7 12 2}
14.  {helpb infile1:infile} (free format) will create strings of at most
     244 characters long.

{p 7 12 2}
15.  {helpb file:file write} will write at most 244 characters of the
     result of a string expression.

{p 7 12 2}
16.  The domain of the degrees-of-freedom argument of functions 
     {helpb nchi2()}, {helpb invnchi2()}, and {helpb npnchi2()} will be from 1
     to 200 (integers only). In version 13.0, this domain is from 2e-10 to
     1e+6 (may be nonintegral). The domain (or range) of the noncentrality
     parameter in functions {cmd:nchi2()}, {cmd:invnchi2()}, and
     {cmd:npnchi2()} will be from 0 to 1,000.  In version 13.0, this
     domain (or range) is from 0 to 10,000. The Mata functions 
     {helpb mf_normalden:nchi2()}, {helpb mf_normalden:invnchi2()}, and 
     {helpb mf_normalden:npnchi2()} have matching behavior. 


    {title:If you set version to less than 12.1}

{phang2}1.  {helpb qreg} uses the original standard-error calculation instead
            of the improved calculation in version 12.1 that uses a better
            bandwidth and offers options to control the density estimator.

{phang2}2.  {helpb rnormal()} under user-version 12.0 may produce different
            variates than {cmd:rnormal()} produces under user-version 12.1.  The
            version of {cmd:rnormal()} is determined by the version at
            the time you {helpb set seed} (see
            {help version##seed_version:item 4} under
            "If you set version to less than 11.2").  Variates produced under
            version 12.1 are identical to those produced under version 11.2.


    {title:If you set version to less than 12.0}

{phang2}1.  {helpb xtmixed} will report restricted maximum-likelihood (REML) 
            results.  If you want maximum likelihood (ML) results, you must
            specify the {cmd:mle} option.

{phang2}2.  {helpb poisson_postestimation##estatgof:estat gof} after
            {helpb poisson} will report only the deviance statistic by
            default.  To get the Pearson statistic, you must specify the
            {cmd:pearson} option.

{phang2}3.  {helpb cnsreg} will not check for collinear variables prior to
            estimation even if the {opt collinear} option is not specified.

{phang2}4.  {helpb margins} behaves as if {cmd:estimtolerance(1e-7)} was
	    specified even if a different value is specified.

{phang2}5.  {helpb sfrancia} uses the Box-Cox transformation instead of an
            algorithm based on the log transformation for approximating the
            sampling distribution of the W' statistic for testing normality.

{phang2}6.  {helpb mi estimate} computes fractions of missing information
            and relative efficiencies using large-sample degrees of freedom
            rather than using a small-sample adjustment.

{phang2}7.  {helpb mi impute monotone} omits imputation variables that
            do not contain any missing values in the imputation sample from
            the imputation model.


    {title:If you set version to less than 11.2}

{phang2}
1.  {helpb drawnorm} produces different results because of changes in
    the {cmd:rnormal()} function, which are described below.

{phang2}
2.  {helpb mi impute} produces different results because of changes in
    the {cmd:rnormal()} function, which are described below.  The statistical
    properties of these results are neither better nor worse than modern
    results, but they are different.

{phang2}
3.  Function {helpb rnormal()}, the Gaussian random-number generation
    function, produces different values before user-version 11.2.
    These pseudo-random number sequences
    were found to be insufficiently random for certain applications.

{marker seed_version}{...}
{phang2}
4.  {it:Aside:} Version control for all random-number generators is specified
    at the time the {helpb set seed} command is given, not at the time the
    random-number generation function such as {cmd:rnormal()} is used.  For
    instance, typing

		. {it:(assume user-version is set to be 11.2 or later)}

		. {cmd:set seed 123456789}

		. {it:any_command ...}

{p 12 12 2}
    causes {it:any_command} to use that version of {cmd:rnormal()} even
    if {it:any_command} is an ado-file containing an explicit {cmd:version}
    statement setting the version to less than 11.2.  This occurs because the
    version of {cmd:rnormal()} that is used was determined at the time the
    seed was set, and the seed was set under version 11.2 or later.

{p 12 12 2}
    This works in both directions.  Consider

		. {cmd:version 11.1: set seed 123456789}

		. {it:any_command ...}

{p 12 12 2}
    In this case, {it:any_command} uses the older version of {cmd:rnormal()}
    because the seed was set under version 11.1, before {cmd:rnormal()} was
    updated.  {it:any_command} uses the older version of {cmd:rnormal()} even
    if {it:any_command} itself includes an explicit {cmd:version} statement
    setting the version to 11.2 or later.

{p 12 12 2}
    Thus both older and newer ado-files can use the newer or older
    {cmd:rnormal()}, and they can do so without modification.  The only case
    in which you need to modify a do-file or ado-file is when it is older, it
    contains {cmd:set seed}, and you now want it to use the new
    {cmd:rnormal()}.  In that case, find the {cmd:set seed} command in the
    do-file or ado-file,

		  {cmd:version 10}              // {it:for example}
		  ...
		  {cmd:set seed 123456789}
		  ...

{p 12 12 2}
     and change it to read

		  {cmd:version 10}              // {it:for example}
		  ...
		  {cmd:version 11.2: set seed 123456789}
		  ...

{p 12 12 2}
    You need to change only the one line.

{phang2}
5.  {it:Aside, continued:}
    Everything written above about prefixing {cmd:set seed} with a
    {cmd:version} is irrelevant if you are restoring the seed to a state
    previously obtained from {helpb set_seed##state:c(rngstate)}:

		  {cmd:set seed X075bcd151f123bb5159a55e50022865700023e53}

{p 12 12 2}
    The string state {cmd:X075bcd151f123bb5159a55e50022865700023e53} includes
    the version number at the time the seed was set.  Prefixing the above
    with {cmd:version}, whether older or newer, will do no harm but
    is unnecessary.


    {title:If you set version to less than 11.1}

{phang2}1.  {helpb xtnbreg:xtnbreg, re} returns {cmd:xtn_re} in {cmd:e(cmd2)},
            and {helpb xtnbreg:xtnbreg, fe} returns {cmd:xtn_fe} in
            {cmd:e(cmd2)}.  As of version 11.1, {cmd:xtnbreg} instead returns
            the {cmd:e(model)} macro, containing {cmd:re}, {cmd:fe}, or
            {cmd:pa}, indicating which model was specified.


    {title:If you set version to less than 11.0}

{phang2}1.  {helpb anova} reverts to pre-Stata 11 syntax.  Options
            {cmd:category()}, {cmd:class()}, {cmd:continuous()},
            {cmd:regress}, {cmd:anova}, {cmd:noanova}, and {cmd:detail} are
            allowed, while factor-variable notation (the {cmd:i.} and {cmd:c.}
            operators) is not allowed.  The {cmd:*} symbol indicates
            interaction (instead of {cmd:#}), and therefore {cmd:*}, {cmd:-},
            and {cmd:?} are not allowed for variable-name expansion.
            Noninteger and negative values are allowed as category levels.

{phang2}2.  {helpb correlate}'s {cmd:_coef} option is allowed.

{phang2}3.  {helpb ereturn display} ignores the scalars in {cmd:e()}.  As of
	    version 11, {cmd:ereturn} {cmd:display} checks that the value of
	    scalar {cmd:e(k_eq)} contains the number of equations in
	    {cmd:e(b)} if it is set.

{phang2}4.  {helpb manova} reverts to pre-Stata 11 syntax.  Options
            {cmd:category()}, {cmd:class()}, {cmd:continuous()}, and
            {cmd:detail} are allowed, while factor-variable notation (the
            {cmd:i.} and {cmd:c.} operators) is not allowed.  The {cmd:*}
            symbol indicates interaction (instead of {cmd:#}), and therefore
            {cmd:*}, {cmd:-}, and {cmd:?} are not allowed for variable-name
            expansion.  Noninteger and negative values are allowed as category
            levels.

{phang2}5.  {helpb odbc insert} will insert data by constructing an SQL insert
            statement and will not use parameterized inserts.

{phang2}6.  {helpb odbc load} will quote the table name used in the SQL
            SELECT statement that loads your data unless the {opt noquote}
            option is used.

{phang2}7.  {helpb outfile} will not export date-formatted variables as
            strings.

{phang2}8.  {helpb predict} options {cmd:scores} and {cmd:csnell} after
            {helpb stcox} will produce partial, observation-level diagnostics
            instead of subject-level diagnostics.  This matters only if you
            have multiple records per subject in your survival data.

{phang2}9.  Abbreviating {helpb predict} option {cmd:scores} with {cmd:sc}
            after {helpb stcox} is allowed.  Modern syntax requires {cmd:sco}
            minimally.

{p 7 12 2}
       10.  {helpb predict} options {cmd:mgale} and {cmd:csnell} after
            {helpb streg} will produce partial, observation-level diagnostics
            instead of subject-level diagnostics.  This matters only if you
            have multiple records per subject in your survival data.

{p 7 12 2}
       11.  Abbreviating {helpb predict} option {cmd:csnell} with {cmd:cs}
            after {helpb streg} is allowed.  Modern syntax requires {cmd:csn}
            minimally.

{p 7 12 2}
       12.  {helpb xtreg:xtreg, re vce(robust)} uses the 
            Huber/White/sandwich estimator of the variance-covariance of the
            estimator (VCE).  As of version 11, {cmd:xtreg, re vce(robust)}
            is equivalent to  
            {cmd:xtreg, re vce(cluster }{it:panelvar}{cmd:)},
            where {it:panelvar} identifies the panels.

{p 7 12 2}
       13.  {helpb logistic}, {helpb logit}, {helpb blogit}, and
            {helpb mlogit} will not display the exponentiated constant when
            coefficients are displayed in "eform", for example, odds-ratios
            instead of coefficients in logistic regression.


    {title:If you set version to less than 10.1}

{phang2}1.  Function {helpb Binomial()} is allowed.  The modern replacement
            for {cmd:Binomial()} is {helpb binomialtail()}.

{phang2}2.  {helpb canon} will display raw coefficients and conditionally
	    estimated standard errors and confidence intervals in a standard
	    estimation table by default, rather than raw coefficients in
	    matrix form.

{phang2}3.  {helpb drawnorm} uses {cmd:invnormal(uniform())} to generate
            normal random variates instead of using {helpb rnormal()}.

{phang2}4.  {helpb egen} function {cmd:mode()} with option {cmd:missing} will
            not treat missing values as a category.

{phang2}5.  The {helpb reshape} J variable value and variable labels and all
            xij variable labels, when reshaping from long to wide and back to
            long, will not be preserved.

{phang2}6.  {helpb xtmixed}, {helpb xtmelogit}, and {helpb xtmepoisson},
            without an explicit level variable (or {cmd:_all}) followed by a
            colon in the random-effects specification, assume a specification
            of {cmd:_all:}.


    {title:If you set version to less than 10}

{phang2}1.  {helpb ca} and {helpb camat}, instead of reporting percent
            inertias, report inertias such that their sums equal the total
            inertia.

{phang2}2.  {helpb cf}{cmd:, verbose} produces the same output as {cmd:cf, all}.

{phang2}3.  {helpb clear} will perform the same list of actions as
            {cmd:clear all}, except for 
            {helpb program:program drop _all}.

{phang2}4.  {helpb cnreg} and {helpb tobit} will no longer accept the
            {opt vce()} option.

{phang2}5.  {helpb datasignature} runs {helpb _datasignature}, which is what
            the {cmd:datasignature} command was in Stata 9.

{phang2}6.  Functions {cmd:norm()}, {cmd:normd()}, {cmd:normden()},
            {cmd:invnorm()}, and {cmd:lnfact()}, which were
            renamed in Stata 9, are allowed.  The corresponding modern
            functions are  {helpb normal()}, {helpb normalden()},
            {helpb normalden()}, {helpb invnormal()}, and
            {helpb lnfactorial()}.

{phang2}7.  {helpb graph use} will name the graph and window Graph, rather
            than naming after the filename, unless the {cmd:name()} option is
            specified.

{phang2}8.  {helpb mdslong}'s {cmd:force} option corrects problems with the
            supplied proximity information and multiple measurements on (i,j)
            are averaged.  In version 10, measurements for (i,j) and (j,i) are
	    averaged if {cmd:force} is specified, but additional multiple
	    measurements result in an error even if {cmd:force} is specified.

{phang2}9.  {helpb mkspline} calculates percentiles for linear splines using
            {helpb egen}'s {cmd:pctile()} function instead of using the 
            {helpb centile} command.  In addition, {helpb fweight}s are not
            allowed for linear splines.

{p 7 12 2}
       10.  {helpb mlogit} had the following name changes in its
            {cmd:e()} results:

   		Old name	 	  New name
		{hline 37}
		{cmd:e(basecat)}		{cmd:e(baseout)}
		{cmd:e(ibasecat)}		{cmd:e(ibaseout)}
		{cmd:e(k_cat)}			{cmd:e(k_out)}
		{cmd:e(cat)}			{cmd:e(out)}

{p 7 12 2}
       11.  {helpb odbc load} will import date-and-time variables as {cmd:%td}
            instead of {cmd:%tc}, and TIME data types will be imported as
            strings.

{p 7 12 2}
       12.  {cmd:score}, a command associated with the {cmd:factor} command of
            Stata 8, is allowed.

{p 7 12 2}
       13.  {helpb sts graph}'s {opt risktable()} option and
            {helpb sts list}'s {opt survival} option are not allowed.

{p 7 12 2}
       14.  {cmd:syntax} {cmd:[,} {it:whatever}{cmd:(real} {it:...}{cmd:)]}
            uses a {cmd:%9.0g} format instead of a {cmd:%18.0g} format for
            the number placed in the {it:whatever} local macro.

{p 7 12 2}
       15.  {helpb xtabond} will use the version 9 {cmd:xtabond} instead of
            {helpb xtdpd} to perform the computations, the output will be in
            differences instead of levels, and the constant will be a time
            trend instead of a constant in levels.  {cmd:estat abond} and
            {cmd:estat sargan} will not work, and {cmd:predict} will have the
            version 9 syntax.

{p 7 12 2}
       16.  {helpb xtlogit}, {helpb xtprobit}, {helpb xtcloglog},
            {helpb xtintreg}, {helpb xttobit}, and
            {helpb xtpoisson:xtpoisson, normal} random-effects models will
            use default {cmd:intmethod(aghermite)}.


    {title:If you set version to less than 9.2}

{phang2}1.  Mata {help m2_struct:structures} introduced in Stata 9.2 are
            available even if you set version to less than 9.2.  The only
            version control issue is that the format of {cmd:.mlib} libraries
            is different.  You do not need to recompile old Mata code.
            However, because of the format change, you will not be able to add
            new members to old libraries.  Libraries cannot contain a mix of
            old and new code.  To add new members, you must first rebuild the
            old library.


    {title:If you set version to less than 9.1}

{phang2}1.  {helpb logit}, {helpb probit}, and {helpb dprobit} will accept
            {helpb aweight}s.  Support for {cmd:aweight}s was removed from
	    these commands because the interpretation of {cmd:aweight}ed data
            is nonsensical for these models.

{phang2}2.  {helpb nl} will not allow the {opt vce()} option; no longer
            reports each parameter as its own equation; reports the previous
            sum of squares after each iteration instead of the new sum of
            squares in the iteration log; reports an overall model F test;
            allows fewer {cmd:predict} options; and will not allow {helpb mfx}
            or {helpb lrtest} postestimation commands.

{phang2}3.  {helpb permute} uses one random uniform variable (instead of two)
            to generate Monte Carlo permutations of the permute variable.

{phang2}4.  {helpb xtreg:xtreg, fe} adjusts the robust-cluster VCE for
            the within transform. 

{phang2}5.  {helpb xtreg:xtreg, fe} and {helpb xtreg:xtreg, re} do not
            require that the panels are nested within the clusters when
            computing the cluster-robust VCE.


    {title:If you set version to less than 9}

{phang2}1.  {helpb svyset} reverts to pre-Stata 9 syntax and logic.
            The dataset must be {cmd:svyset} by the pre-Stata 9 {cmd:svyset}
            command to use the pre-Stata 9 estimation commands 
		{cmd:svygnbreg},
		{cmd:svyheckman},
		{cmd:svyheckprob},
		{cmd:svyivreg},
		{cmd:svylogit},
		{cmd:svymlogit},
		{cmd:svynbreg},
		{cmd:svyologit},
		{cmd:svyoprobit},
		{cmd:svypoisson},
		{cmd:svyprobit},
		and
		{cmd:svyregress}.

{phang2}2.  {helpb factor}, {helpb pca}, and related commands 
            revert to pre-Stata 9 behavior.

{p 12 12 2}
            To begin with, {cmd:factor} and {cmd:pca} store things differently.
            Before Stata 9, these commands were a strange mix of e-class and
            r-class; they set {cmd:e(sample)} but otherwise mostly stored
            results in {cmd:r()}.  They also stored secret matrices under odd
            names that everyone knew about and fetched via {cmd:matrix get()}.
            All of that is restored.

{p 12 12 2}
            Second, {cmd:factor,} {cmd:ml} {cmd:protect} uses a 
            different random-number generator, one that is not 
            settable by the more modern {cmd:factor}'s {cmd:seed()} option.

{p 12 12 2}
            Third, {helpb rotate} reverts to pre-Stata 9 syntax and logic.

{p 12 12 2}
            Fourth, 
            old command {cmd:score} stops issuing warning messages that it is
            out of date.

{p 12 12 2}
            Finally, 
            old command {cmd:greigen} works as it used to work, syntax 
            and logic.  (As of Stata 9, {cmd:greigen} was undocumented and
            configured to call through to the modern {cmd:screeplot}.)

{phang2}3.  {helpb nl} reverts to pre-Stata 9 syntax.

{phang2}4.  {helpb bootstrap}, {helpb bstat}, and {helpb jknife} 
            revert to pre-Stata 9 syntax and logic.

{phang2}5.  {helpb rocfit} reverts to pre-Stata 9 syntax and logic.

{phang2}6.  {helpb sw} reverts to pre-Stata 9 syntax and logic.

{phang2}7.  {helpb cluster dendrogram}
            reverts to pre-Stata 9 syntax and logic.

{phang2}8.  Pre-Stata 8 {it:[sic]} command {cmd:xthausman} 
            will work.  {cmd:xthausman} was replaced by {helpb hausman} in 
            Stata 8.

{p 8 12 2}
        9.  {helpb irf graph} and {helpb xtline} allow the 
            {cmd:byopts()} option to be
            abbreviated {cmd:by()} rather than requiring at least 
            {cmd:byop()}.

{p 7 12 2}
       10.  {helpb dotplot} will allow the {cmd:by()} option as
            a synonym for the {cmd:over()} option.

{p 7 12 2}
       11.  {helpb glm} defaults the {cmd:iterate()} option to 50 
            rather than {cmd:c(maxiter)}.

{p 7 12 2}
       12.  {helpb histogram} places white space below 
            the horizontal axis.

{p 7 12 2}
       13.  {helpb ml:ml display} changes the look of 
            survey results.

{p 7 12 2}
       14.  {helpb ologit} and {helpb oprobit}  revert 
	    to pre-Stata 9 logic in how {cmd:e(b)} and {cmd:e(V)} are 
            stored.  Results were stored in two equations, with all 
            cutpoints stored in the second.

{p 7 12 2}
       15.  {helpb tobit} and {helpb cnreg}  revert 
	    to pre-Stata 9 logic in how {cmd:e(b)} and {cmd:e(V)} are 
            stored.  Results were stored in one equation
            containing both coefficients and the ancillary variance 
            parameter.

{p 7 12 2}
       16.  {helpb tabstat} returns a result in matrix 
            {cmd:r(StatTot)} rather than {cmd:r(StatTotal)}.
 
{p 7 12 2}
       17.  {helpb glogit} and {helpb gprobit}, 
            the 
            weighted-least-squares estimators, 
            use a different formula for the weights.
            In Stata 9, a
            new (better) formula was adopted, see 
            Greene (1997, 
            {it:Econometric Analysis, 3rd ed.}, 
	    Prentice Hall, 896).

{p 7 12 2}
       18.  {helpb xtintreg},
		{helpb xtlogit}, 
		{helpb xtprobit}, 
		{helpb xtcloglog}, 
		{helpb xtpoisson}, 
		and
		{helpb xttobit}
	     revert to using nonadaptive Gauss-Hermite quadrature rather 
             than adaptive quadrature.  Also, the {cmd:quad()} option
             (modern name {cmd:intpoints()}) comes back to life.

{p 7 12 2}
       19.  {cmd:set help} will be allowed (but it will not do 
            anything).

{p 7 12 2}
       20.  In input, {cmd:\\} will be substituted to {cmd:\}
            always, not just after 
            the macro-substitution characters {cmd:$} and {cmd:`}.


    {title:If you set version to 8.1 or less}

{phang2}1.  {helpb graph twoway} default axis titles show the
		labels or variable names for all variables plotted on an axis
		instead of leaving the axis title blank when the axis
		represents multiple variables.{p_end}

{phang2}2.  {helpb clogit} will not allow the {cmd:vce()} option nor many of
                the {cmd:ml} {helpb maximize} options.


    {title:If you set version to 8.0 or less}

{phang2}1.  {helpb ml} ignores the {cmd:constraint()} option if there are no
		predictors in the first equation.{p_end}

{phang2}2.  {helpb outfile} automatically includes the extended missing-value
		codes ({cmd:.a}, {cmd:.b}, ..., {cmd:.z}) in its output.  With
		version 8.1 or later, extended missing-value codes are treated
		like the system missing value {cmd:.} and are changed to null
		strings ({cmd:""}) unless the {cmd:missing} and {cmd:comma}
		options are specified.


    {title:If you set version to 7.0 or less}

{phang2}1.  {helpb graph} uses the old syntax; see {helpb graph7}.{p_end}

{phang2}2.  {helpb estimates} reverts to the previous interpretation and
		syntax, and {helpb _estimates} and {helpb ereturn} are not
		recognized as Stata commands.{p_end}

{phang2}3.  The {helpb svy} commands allow the {helpb svyset} parameters to
		be specified as part of the command.{p_end}

{phang2}4.  Also, the following commands revert to their old
		syntax: {helpb ac}, {helpb acprplot}, {helpb avplot},
		{helpb avplots}, {helpb bootstrap}, {helpb bs}, {helpb bsample},
		{helpb bstat}, {helpb cchart}, {helpb cprplot}, {helpb cumsp},
		{helpb cusum}, {helpb dotplot}, {helpb findit}, {helpb fracplot},
		{helpb gladder}, {helpb greigen}, {helpb grmeanby},
		{helpb histogram}, {helpb intreg}, {helpb kdensity},
		{helpb lowess}, {helpb lroc}, {helpb lsens}, {helpb ltable},
		{helpb lvr2plot}, {helpb newey}, {helpb pac}, {helpb pchart},
		{helpb pchi}, {helpb pergram}, {helpb pkexamine}, {helpb pksumm},
		{helpb pnorm}, {helpb qchi}, {helpb qladder}, {helpb qnorm},
		{helpb qqplot}, {helpb quantile}, {helpb rchart}, {helpb roccomp},
		{helpb rocplot}, {helpb roctab}, {helpb rvfplot}, {helpb rvpplot},
		{helpb serrbar}, {helpb shewhart}, {helpb simulate},
		{helpb spikeplot}, {helpb stci}, {helpb stcoxkm}, {helpb stcurve},
		{helpb stphplot}, {helpb stphtest}, {helpb strate}, {helpb sts},
		{helpb symplot}, {helpb tabodds}, {helpb test}, {helpb wntestb},
		{helpb xchart}, and {helpb xcorr}.  Most of these are
                because of the change of the {helpb graph} command.{p_end}

{phang2}5.  Throughout Stata,
		{cmd:.} == {cmd:.a} == {cmd:.b} == ... == {cmd:.z}.{p_end}

{phang2}6.  Missing values in matrices are less likely to be accepted.{p_end}

{phang2}7.  {cmd:generate} {it:x} {cmd:=} {it:string_expression} will
		produce an error; you are required to specify the type; see
		{manhelp generate D}.{p_end}

{phang2}8.  {helpb ifcmd:if}, {helpb while}, {helpb foreach}, {helpb forvalues},
		and other commands that use the open and close braces,
		{cmd:{c -(}} and {cmd:{c )-}}, often allow the item
		enclosed in the braces to appear on the same line as the
		braces.{p_end}

{phang2}9.  {helpb test} allows the coefficient names not to match 1 to 1
		(regardless of order) when testing equality of coefficients of
		two equations.  The test is performed on the coefficients
		in common.{p_end}

{p 7 12 2}10.  {helpb list} allows the {cmd:doublespace} option, which is then
		treated as if it were the {cmd:separator(1)} option.  Also,
		even with the version set to 7.0 or less, {cmd:list} uses the
		new style of listing unless the {cmd:clean} option is specified
		to remove the dividing and separating lines.{p_end}

{p 7 12 2}11.  {helpb outfile} uses right justification for strings.{p_end}

{p 7 12 2}12.  {helpb reldif():reldif}{cmd:(}{it:x}{cmd:,}{it:y}{cmd:)} with
		{it:x} and {it:y} as equal missing values, such as
		{cmd:reldif(.r,.r)}, returns system missing ({cmd:.}) instead
		of 0.{p_end}

{p 7 12 2}13.  {helpb query}, in addition to showing all the settings normally
		shown, shows the values of {helpb set} parameters that apply
		only to the earlier versions.{p_end}

{p 7 12 2}14.  {helpb matrix score}, when looking up variable names
		associated with the elements of the specified vector, expands
		variable name abbreviations.{p_end}

{p 7 12 2}15.  {helpb xthausman} continues to work (for one more release) but
		recommends the use of {helpb hausman} instead.{p_end}


    {title:If you set version to 6.0 or less}

{phang2}1.  Macro substitution is made on the basis of the first seven (local)
		or eight (global) characters of the name;
                {cmd:`thisthatwhat'} is the same as {cmd:`thistha'}.{p_end}

{phang2}2.  {helpb syntax} returns the result of parsing a long option name in
		the local macro formed from the first seven characters of the
		option name.{p_end}

{phang2}3.  {helpb display} starts in non-SMCL mode; the {cmd:in smcl}
		directive may be used to set smcl mode on.{p_end}

{phang2}4.  {cmd:invt(}{it:df}{cmd:,}{it:p}{cmd:)} returns the inverse
		two-tailed cumulative t distribution;
		{cmd:invttail(}{it:df}{cmd:,(1-}{it:p}{cmd:)/2)} is a new
		alternative to {cmd:invt(}{it:df}{cmd:,}{it:p}{cmd:)}.  In
		version 13.0, {cmd:invt(}{it:df}{cmd:,}{it:p}{cmd:)} returns
		the inverse cumulative Student's t distribution: if
		{cmd:t(}{it:df}{cmd:,}{it:t}{cmd:)} = {it:p}, then
		{cmd:invt(}{it:df}{cmd:,}{it:p}{cmd:)} = {it:t}.{p_end}

{phang2}5.  {cmd:invchi()} works; {cmd:invchi2(}{it:a}{cmd:,1-}{it:b}{cmd:)}
		is a new alternative to {cmd:invchi(}{it:a}{cmd:,}{it:b}{cmd:)}.
		{p_end}

{phang2}6.  {helpb post} will allow expressions that are not bound in
		parentheses.{p_end}

{phang2}7.  Option {cmd:basehazard()} is allowed in {helpb cox} and
	    {helpb stcox}; it has been renamed to {cmd:basehc()},
	    which is understood regardless of version setting.{p_end}

{phang2}8.  {helpb log:log using} can have a {cmd:noproc} option.{p_end}

{phang2}9.  {cmd:log close}, {cmd:log off}, and {cmd:log on} will close, turn
		off, or turn on a {helpb cmdlog} if present and a {helpb log} is
		not.{p_end}

{p 7 12 2}10.  {cmd:set log linesize}, {cmd:set log pagesize},
		{cmd:set display linesize}, and {cmd:set display pagesize}
		are allowed.{p_end}

{p 7 12 2}11.  Extended {helpb macro} functions {cmd:log},
	       {cmd:set log linesize}, and {cmd:set log pagesize} enabled.
	       {p_end}

{p 7 12 2}12.  {helpb insheet} will recognize only the first eight characters of
		variable names and will provide default names for variables
		if the first eight characters are not unique.{p_end}

{p 7 12 2}13.  {helpb jackknife} (or {cmd:jknife}) will call the older
		{help stb:STB} version of the command.{p_end}


    {title:If you set version to 5.0 or less}

{phang2}1.  {cmd:date()} defaults to twentieth century for two-digit
	    years.{p_end}

{phang2}2.  {helpb predict} becomes the built-in command equivalent to
		{helpb _predict}.{p_end}

{phang2}3.  {cmd:,} & {cmd:\} matrix operators allow the first matrix to not
  	    exist; now use {cmd:nullmat()}.{p_end}

{phang2}4.  {helpb matrix} ...{cmd:=get(_b)} returns a matrix instead of a row
		vector after {helpb mlogit}.{p_end}

{phang2}5.  {helpb test} after {helpb anova} understands the {cmd:error()}
	       option instead of the new "{cmd:/}" syntax.{p_end}

{phang2}6.  {helpb ologit} and {helpb oprobit} default weight types are
		{cmd:aweight}s.{p_end}

{phang2}7.  {helpb heckman} default weight type is {cmd:fweight}s.{p_end}

{phang2}8.  {helpb svyregress}, {helpb svylogit}, and {helpb svyprobit} compute
		meff and meft by default.{p_end}

{p 8 16 2}[Note:  For {helpb xtgee}, {helpb xtpoisson}, and {helpb xtprobit},
	  the default will not be {cmd:aweight}s as you would expect under
		version control; {cmd:iweight}s is the default despite setting
		the version number back to 5.0.]{p_end}


    {title:If you set version to 4.0 or less}

{phang2}1.  -2^2 = (-2)^2 = 4{space 7}(After 4.0: -2^2 = -(2^2) = -4){p_end}

{phang2}2.  {helpb describe} sets the contents of {cmd:_result()}
	    differently.{p_end}

{phang2}3.  {helpb merge} does not automatically promote variables.{p_end}

{phang2}4.  {helpb logit} and {helpb probit} default weight types are
		{cmd:aweight}s.{p_end}

{phang2}5.  {cmd:set prefix} is shown by {helpb query}.{p_end}

{phang2}6.  {cmd:hareg}, {cmd:hereg}, {cmd:hlogit}, {cmd:hprobit}, and
	    {cmd:hreg} work.{p_end}

{phang2}7.  {helpb collapse} has the old syntax.{p_end}


    {title:If you set version to 3.1 or less}

{phang2}1.  {cmd:uniform()} refers to the old random-number generator.{p_end}

{phang2}2.  {cmd:set seed} sets the old random-number seed.{p_end}

{phang2}3.  {helpb replace} defaults to {cmd:nopromote} behavior.{p_end}

{phang2}4.  The old %macro notation is allowed (it no longer is).{p_end}


    {title:If you set version to 3.0 or less}

{phang2}1.  {help tempfile}s are not automatically erased.{p_end}


    {title:If you set version to 2.5 or less}

{phang2}1.  Missing strings are stored as {hi:"."} by {helpb infile}.{p_end}


    {title:If you set version to 2.1 or less}

{phang2}1.  {helpb display} does not respect {helpb quietly}.{p_end}

{phang2}2.  Macros hold numbers in short format.{p_end}


{title:Using the old Stata 3.1 random-number generator}

{pstd}
{cmd:uniform()} and {cmd:set seed} refer to the old Stata 3.1 random-number
generator if you set version 3.1 or earlier.  You can also access
the old random-number generator even with version set to {ccl stata_version}
by referring to {cmd:uniform0()}.  You can set the old random-number
generator's seed by typing {cmd:set seed0} -- it works just like
{cmd:set seed}; see {helpb seed}.  The initial seed of the old
random-number generator is {cmd:set seed0 1001}.

{pstd}
There is no reason you should want to use the old random-number generator.
It was satisfactory but the new one is better.
{p_end}
