{smcl}
{* *! version 1.0.18  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute chained" "mansection MI miimputechained"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute monotone" "help mi_impute_monotone"}{...}
{vieweralsosee "[MI] mi impute mvn" "help mi_impute_mvn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_chained##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_chained##menu"}{...}
{viewerjumpto "Description" "mi_impute_chained##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_chained##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_chained##options"}{...}
{viewerjumpto "Examples" "mi_impute_chained##examples"}{...}
{viewerjumpto "Stored results" "mi_impute_chained##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[MI] mi impute chained} {hline 2}}Impute missing values using chained equations{p_end}
{p2col:}({mansection MI miimputechained:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}Default specification of prediction equations, basic syntax

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:chain:ed}
{cmd:(}{it:{help mi_impute_chained##uvmethod:uvmethod}}{cmd:)}
       {it:{help mi_impute_chained##ivars:ivars}} 
[{cmd:=} {it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi_impute_chained##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:{help mi_impute_chained##opts1:options}}]


{p 4 4 2}Default specification of prediction equations, full syntax

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:chain:ed} {it:lhs}
[{cmd:=} {it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi_impute_chained##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:{help mi_impute_chained##opts1:options}}]


{p 4 4 2}Custom specification of prediction equations

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:chain:ed} {it:lhsc}
[{cmd:=} {it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi_impute_chained##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}}
 {it:{help mi_impute_chained##opts1:options}}]


{marker lhs}{...}
{phang}
where {it:lhs} is {it:lhs_spec} [{it:lhs_spec} [...]] and {it:lhs_spec} is

{phang2}
{cmd:(}{it:{help mi_impute_chained##uvmethod:uvmethod}} [{it:{help if}}] 
[{cmd:,} {it:{help mi_impute_chained##uvspec_options:uvspec_options}}]{cmd:)}
         {it:{help mi_impute_chained##ivars:ivars}}

{marker lhsc}{...}
{phang}
{it:lhsc} is {it:lhsc_spec} [{it:lhsc_spec} [...]] and {it:lhsc_spec} is

{phang2}
{cmd:(}{it:{help mi_impute_chained##uvmethod:uvmethod}} [{it:{help if}}] 
[{cmd:,} {opth incl:ude(mi_impute_chained##xspec:xspec)} {opth omit(varlist)}
{opt noimp:uted} {it:{help mi_impute_chained##uvspec_options:uvspec_options}}]{cmd:)}
{it:{help mi_impute_chained##ivars:ivars}}

{marker ivars}{...}
{phang}
{it:ivars} (or {it:newivar} if {it:uvmethod} is {cmd:intreg})
are the names of the imputation variables.

{marker uvspec_options}{...}
{phang}
{it:uvspec_options} are {opt asc:ontinuous}, {opt noi:sily}, and the
method-specific {it:options} as described in the manual entry for each
{help mi_impute_chained##uvmethod:univariate imputation method}.

{phang}
The {cmd:include()}, {cmd:omit()}, and {cmd:noimputed} options allow you to
customize the default prediction equations.


{marker uvmethod}{...}
{synoptset 20}{...}
{synopthdr:uvmethod}
{synoptline}
{synopt: {opt reg:ress}}linear regression for a continuous variable;
       {manhelp mi_impute_regress MI:mi impute regress}{p_end}
{synopt: {opt pmm}}predictive mean matching for a continuous variable;
       {manhelp mi_impute_pmm MI:mi impute pmm}{p_end}
{synopt: {opt truncreg}}truncated regression for a continuous variable with a restricted range;
       {manhelp mi_impute_truncreg MI:mi impute truncreg}{p_end}
{synopt: {opt intreg}}interval regression for a continuous partially observed (censored) variable; {manhelp mi_impute_intreg MI:mi impute intreg}{p_end}
{synopt: {opt logi:t}}logistic regression for a binary variable; 
       {manhelp mi_impute_logit MI:mi impute logit}{p_end}
{synopt: {opt olog:it}}ordered logistic regression for an ordinal variable; 
       {manhelp mi_impute_ologit MI:mi impute ologit}{p_end}
{synopt: {opt mlog:it}}multinomial logistic regression for a nominal variable;
       {manhelp mi_impute_mlogit MI:mi impute mlogit}{p_end}
{synopt: {opt poisson}}Poisson regression for a count variable;
       {manhelp mi_impute_poisson MI:mi impute poisson}{p_end}
{synopt: {opt nbreg}}negative binomial regression for an overdispersed count variable;
       {manhelp mi_impute_nbreg MI:mi impute nbreg}{p_end}
{synoptline}


{marker opts1}{...}
{synoptset 20 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:MICE options}
{synopt:{opt burn:in(#)}}specify number of iterations for the burn-in period; 
default is {cmd:burnin(10)}{p_end}
{synopt:{opt chainonly}}perform chained iterations for the length of the
burn-in period without creating imputations in the data{p_end}
{synopt:{opt aug:ment}}perform augmented regression in the presence of perfect prediction for all categorical imputation variables{p_end}
{synopt:{opt noimp:uted}}do not include imputation variables in any prediction equation{p_end}
{synopt:{opt boot:strap}}estimate model parameters using sampling with replacement{p_end}
{synopt:{helpb mi_impute_chained##savetrace:savetrace(...)}}save summaries of imputed values from each iteration in {it:filename}{cmd:.dta}{p_end}

{syntab:Reporting}
{synopt: {opt dryrun}}show conditional specifications without imputing data{p_end}
{synopt: {opt report}}show report about each conditional specification{p_end}
{synopt: {opt chaindots}}display dots as chained iterations are performed{p_end}
{synopt: {opt showe:very(#)}}display intermediate results from every {it:#}th iteration{p_end}
{synopt: {opth showi:ter(numlist)}}display intermediate results from every iteration in {it:numlist}{p_end}

{syntab:Advanced}
{synopt: {opt orderasis}}impute variables in the specified order{p_end}
{synopt: {opt nomonotone}}impute using chained equations even when variables follow a monotone-missing pattern; default is to use monotone method{p_end}
{synopt: {opt nomonotonechk}}do not check whether variables follow a monotone-missing pattern{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:mi} {cmd:set} your data before using {cmd:mi} {cmd:impute}
{cmd:chained}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi} {cmd:register} {it:ivars} as imputed before using {cmd:mi}
{cmd:impute} {cmd:chained}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:aweight}s ({cmd:regress}, {cmd:pmm}, {cmd:truncreg}, and
{cmd:intreg} only), {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi} {cmd:impute} {cmd:chained} fills in missing values in multiple
variables iteratively by using chained equations, a sequence of univariate
imputation methods with 
{help mi_glossary##def_FCS:fully conditional specification} (FCS) of
prediction equations.  It accommodates arbitrary missing-value patterns.  You
can perform separate imputations on different subsets of the data by specifying
the {cmd:by()} option.  You can also account for frequency, analytic (with continuous
variables only), importance, and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputechainedRemarksandexamples:Remarks and examples}

        {mansection MI miimputechainedMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:add()}, {cmd:replace}, {cmd:rseed()}, {cmd:double}, {cmd:by()}; see
{manhelp mi_impute MI:mi impute}.

{pstd}
The following options appear on a Specification dialog that appears when you
click on the {bf:Create ...} button on the {bf:Main} tab.  The {cmd:include()}, 
{cmd:omit()}, and {cmd:noimputed} options allow you to customize the default
prediction equations.

{marker xspec}{...}
{phang}
{opt include(xspec)} specifies that {it:xspec} be included in
prediction equations of all imputation variables corresponding to the current
left-hand-side specification {it:{help mi_impute_chained##lhsc:lhsc_spec}}.
{it:xspec} includes complete variables and expressions of imputation variables
bound in parentheses.  If the {opt noimputed} option is specified 
within {it:lhsc_spec} or with {opt mi impute chained}, then
{it:xspec} may also include imputation variables.  {it:xspec} may contain
factor variables; see {help fvvarlist}.

{phang}
{opth omit(varlist)} specifies that {it:varlist} be omitted from the
prediction equations of all imputation variables corresponding to the current
left-hand-side specification {it:{help mi_impute_chained##lhsc:lhsc_spec}}.
{it:varlist} may include complete variables or imputation variables.
{it:varlist} may contain factor variables; see {help fvvarlist}.  In
{opt omit()}, you should list variables to be omitted exactly as they appear in
the prediction equation (abbreviations are allowed).  For example, if variable
{opt x1} is listed as a factor variable, use {cmd:omit(i.x1)} to omit it from
the prediction equation.

{phang}
{opt noimputed} specifies that no imputation variables automatically
be included in prediction equations of imputation variables corresponding to the
current {it:uvmethod}.

{phang}
{it:uvspec_options} are options specified within each univariate imputation
method, {it:uvmethod}.  {it:uvspec_options} include {opt asc:ontinuous},
{opt noi:sily}, and the method-specific {it:options} as described in the manual
entry for each univariate imputation method.

{phang2}
{opt ascontinuous} specifies that categorical imputation variables
corresponding to the current {it:uvmethod} be included as continuous in all
prediction equations.  This option is only allowed when {it:uvmethod} is
{cmd:logit}, {cmd:ologit}, or {cmd:mlogit}.

{phang2}
{opt noisily} specifies that the output from the current univariate model fit
to the observed data be displayed.  This option is useful in combination with
the {opt showevery(#)} or {opt showiter(numlist)} option to display
results from a particular univariate imputation model for specific iterations.

{dlgtab:MICE options}

{phang}
{opt burnin(#)} specifies the number of iterations for the burn-in period for
each chain (one chain per imputation).  The default is {cmd:burnin(10)}.  This
option specifies the number of iterations necessary for a chain to reach
approximate stationarity or, equivalently, to converge to a stationary
distribution.  The required length of the burn-in period will depend on the
starting values used and the missing-data patterns observed in the data.  It
is important to examine the chain for convergence to determine an adequate
length of the burn-in period prior to obtaining imputations; see
{it:{mansection MI miimputechainedRemarksandexamplesConvergenceofMICE:Convergence of MICE}}
under {it:Remarks and examples} in {bf:[MI] mi impute chained}.  The provided
default is what current literature recommends.  However, you are responsible
for determining that sufficient iterations are performed.

{phang}
{opt chainonly} specifies that {cmd:mi impute chained} perform chained
iterations for the length of the burn-in period and then stop.  This option is
useful in combination with {cmd:savetrace()} to examine the convergence of the
method prior to imputation.  No imputations are created when {cmd:chainonly}
is specified, so {cmd:add()} or {cmd:replace} is not required with
{bind:{cmd:mi impute chained, chainonly}} and they are ignored if specified.

{phang}
INCLUDE help mi_impute_uvopt_augment
This option is equivalent to specifying {cmd:augment} within univariate
specifications of all categorical imputation methods: {cmd:logit},
{cmd:ologit}, and {cmd:mlogit}.

{phang}
{opt noimputed} specifies that no imputation variables automatically
be included in any of the prediction equations.  This option is seldom used.
This option is convenient if you wish to use different sets of imputation
variables in all prediction equations.  It is equivalent to specifying
{cmd:noimputed} within all univariate specifications.

{phang}
INCLUDE help mi_impute_uvopt_bootstrap
This option is equivalent to specifying {cmd:bootstrap} within all univariate
specifications.

{marker savetrace}{...}
{phang}
{cmd:savetrace(}{help filename:{it:filename}}[{cmd:,} {it:traceopts}]{cmd:)}
specifies to save the means and standard deviations of imputed values from
each iteration to a Stata dataset called {it:filename}{cmd:.dta}.  If
the file already exists, the {cmd:replace} suboption specifies to overwrite
the existing file.  {cmd:savetrace()} is useful for monitoring convergence of
the chained algorithm.  This option cannot be combined with {cmd:by()}.

{phang2}
{it:traceopts} are {cmd:replace}, {cmd:double}, and {cmd:detail}.

{phang3}
{cmd:replace} indicates that {it:filename}{cmd:.dta} be overwritten if it
exists.

{phang3}
{cmd:double} specifies that the variables be stored as {cmd:double}s, meaning
8-byte reals.  By default, they are stored as {cmd:float}s, meaning 4-byte
reals.  See {helpb datatypes:[D] Data types}.

{phang3}
{cmd:detail} specifies that additional summaries of imputed values including
the smallest and the largest values and the 25th, 50th, and 75th percentiles
are saved in {it:filename}{cmd:.dta}.

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see
{manhelp mi_impute MI:mi impute}.  {cmd:noisily} specifies that the output
from all univariate conditional models fit to the observed data be displayed.
{cmd:nolegend} suppresses all imputation table legends that include a legend
with the titles of the univariate imputation methods used, a legend about
conditional imputation when {cmd:conditional()} is used within univariate
specifications, and group legends when {cmd:by()} is specified.

{phang}
{cmd:dryrun} specifies to show the conditional specifications that would be
used to impute each variable without actually imputing data.  This option is
recommended for checking specifications of conditional models prior to
imputation.

{phang}
{cmd:report} specifies to show a report about each univariate conditional
specification.  This option, in a combination with {cmd:dryrun}, is
recommended for checking specifications of conditional models prior to
imputation.

{phang}
{opt chaindots} specifies that all chained iterations be displayed as dots.  An
{cmd:x} is displayed for every failed iteration.

{phang}
{opt showevery(#)} specifies that intermediate regression output be
displayed from every {it:#}th iteration.  This option requires
{cmd:noisily}.  If {cmd:noisily} is specified with {cmd:mi impute chained},
then the output from the specified iterations is displayed for all univariate
conditional models.  If {cmd:noisily} is used within a univariate
specification, then the output from the corresponding univariate model from
the specified iterations is displayed.

{phang}
{opth showiter(numlist)} specifies that intermediate regression output be
displayed for each iteration in {it:numlist}.  This option requires
{cmd:noisily}.  If {cmd:noisily} is specified with {cmd:mi impute chained},
then the output from the specified iterations is displayed for all univariate
conditional models.  If {cmd:noisily} is used within a univariate
specification, then the output from the corresponding univariate model from
the specified iterations is displayed.

{dlgtab:Advanced}

{phang}
{cmd:force}; see {manhelp mi_update MI:mi impute}.

{phang}
{cmd:orderasis} requests that the variables be imputed in the specified order.
By default, variables are imputed in order from the most observed to the least
observed.

{phang}
{opt nomonotone}, a rarely used option, specifies not to use monotone
imputation and to proceed with chained iterations even when imputation
variables follow a monotone-missing pattern.  {opt mi impute chained} checks
whether imputation variables have a monotone missing-data pattern and, if they
do, imputes them using the monotone method (without iteration).  If
{opt nomonotone} is used, {opt mi impute chained} imputes variables iteratively
even if variables are monotone-missing.

{phang}
{opt nomonotonechk} specifies not to check whether imputation variables follow a
monotone-missing pattern.  By default, {opt mi impute chained} checks whether
imputation variables have a monotone missing-data pattern and, if they do,
imputes them using the monotone method (without iteration).  If 
{opt nomonotonechk} is used, {opt mi impute chained} does not check the
missing-data pattern and imputes variables iteratively even if variables are
monotone-missing.  Once imputation variables are established to have an
arbitrary missing-data pattern, this option may be used to avoid potentially
time-consuming checks; the monotonicity check may be time consuming when a
large number of variables is being imputed.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate}; see {manhelp noupdate_option MI:noupdate option}.


{marker examples}{...}
{title:Examples:  Default prediction equations}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart8s0}
{p_end}

{pstd}
    Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
    Examine missing-data patterns
{p_end}
{phang2}
{cmd:. mi misstable pattern}
{p_end}

{pstd}
Impute {cmd:bmi} and {cmd:age} using linear regression
{p_end}
{phang2}
{cmd:. mi impute chained (regress) bmi age = attack smokes hsgrad female, add(10)}
{p_end}

{pstd}
Impute {cmd:bmi} using predictive mean matching and {cmd:age} using linear regression
{p_end}
{phang2}
{cmd:. mi impute chained (pmm, knn(5)) bmi (regress) age = attack smokes hsgrad female, replace}
{p_end}


{title:Examples:  Custom prediction equations}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart8s0, clear}
{p_end}

{pstd}
Impute {cmd:bmi} using predictive mean matching and {cmd:age} using linear
regression; omit {cmd:hsgrad} from the prediction equation for {cmd:bmi}
{p_end}
{phang2}
{cmd:. mi impute chained ///}{break}
{cmd:    (pmm, knn(5) omit(hsgrad)) bmi ///}{break}
{cmd:    (regress) age = attack smokes hsgrad female, add(10)}
{p_end}

{pstd}
In the above, impute {cmd:age} using predictive mean matching and include age
squared to the prediction equation for {cmd:bmi}
{p_end}
{phang2}
{cmd:. mi impute chained ///}{break}
{cmd:    (pmm, knn(5) omit(hsgrad) include((age^2))) bmi ///}{break}
{cmd:    (pmm, knn(5)) age = attack smokes hsgrad female, replace}
{p_end}


{title:Examples:  Imputing on subsamples}

{pstd}
In the previous example, impute {cmd:bmi} and {cmd:age} separately for males
and females; display dots as imputations are performed
{p_end}
{phang2}
{cmd:. mi impute chained ///}{break}
{cmd:    (pmm, knn(5) omit(hsgrad) include((age^2))) bmi ///}{break}
{cmd:    (pmm, knn(5)) age = attack smokes hsgrad, replace by(female) dots}
{p_end}


{title:Examples:  Conditional imputation}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart10s0, clear}
{p_end}

{pstd}
    Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
    Impute {cmd:bmi} and {cmd:age} using predictive mean matching, and
    {cmd:smokes} and {cmd:hightar} using logistic regression; impute
    {cmd:hightar} using only observations for which {cmd:smokes==1}
{p_end}
{phang2}
{cmd:. mi impute chained ///}{break}
{cmd:    (pmm, knn(5)) bmi ///}{break}
{cmd:    (pmm, knn(5)) age ///}{break}
{cmd:    (logit, cond(if smokes==1) omit(i.smokes)) hightar ///}{break}
{cmd:    (logit) smokes = attack hsgrad female, add(10)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute chained} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables{p_end}
{synopt:{cmd:r(burnin)}}number of burn-in iterations{p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not
specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:chained}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(uvmethods)}}names of univariate imputation methods{p_end}
{synopt:{cmd:r(init)}}type of initialization{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample in each group (per variable)
{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample in each group (per variable)
{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample in each group (per variable){p_end}
