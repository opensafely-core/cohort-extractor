{smcl}
{* *! version 1.3.7  18feb2020}{...}
{viewerdialog mfp "dialog mfp"}{...}
{vieweralsosee "[R] mfp" "mansection R mfp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mfp postestimation" "help mfp postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fp" "help fp"}{...}
{viewerjumpto "Syntax" "mfp##syntax"}{...}
{viewerjumpto "Menu" "mfp##menu"}{...}
{viewerjumpto "Description" "mfp##description"}{...}
{viewerjumpto "Links to PDF documentation" "mfp##linkspdf"}{...}
{viewerjumpto "Options" "mfp##options"}{...}
{viewerjumpto "Remarks" "mfp##remarks"}{...}
{viewerjumpto "Examples" "mfp##examples"}{...}
{viewerjumpto "Stored results" "mfp##results"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] mfp} {hline 2}}Multivariable fractional polynomial
models{p_end}
{p2col:}({mansection R mfp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mfp}
	[{cmd:,}
		{it:options}]
        {cmd::} {it:{help mfp##reg_cmd:regression_cmd}}
	[{it:{help mfp##reg_cmd:yvar1}} [{it:{help mfp##reg_cmd:yvar2}}]]
	{it:{help mfp##reg_cmd:xvarlist}}
	{ifin}
        [{it:{help mfp##weight:weight}}]
	[{cmd:,} {it:regression_cmd_options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model 2}
{synopt :{opt seq:uential}}use the Royston and Altman model-selection algorithm;
default uses closed-test procedure{p_end}
{synopt :{opt cyc:les(#)}}maximum number of iteration cycles; default is
{cmd:cycles(5)}{p_end}
{synopt :{opt dfd:efault(#)}}default maximum degrees of freedom; default is
{cmd:dfdefault(4)}{p_end}
{synopt :{opt cent:er(cent_list)}}specification of centering for the
independent variables{p_end}
{synopt :{opt al:pha(alpha_list)}}p-values for testing between FP models;
default is {cmd:alpha(0.05)}{p_end}
{synopt :{opt df(df_list)}}degrees of freedom for each predictor{p_end}
{synopt :{opth po:wers(numlist:numlist)}}list of FP powers to use;
default is {bind:{cmd:powers(-2 -1(.5)1 2 3)}}{p_end}

{syntab :Adv. model}
{synopt :{cmdab:xo:rder(+}|{cmd:-}|{cmd:n)}}order of entry into model-selection
algorithm; default is {cmd:xorder(+)}{p_end}
{synopt :{opt sel:ect(select_list)}}nominal p-values for selection on each
predictor{p_end}
{synopt :{opt xp:owers(xp_list)}}FP powers for each
predictor{p_end}
{synopt :{opth zer:o(varlist)}}treat nonpositive values of specified predictors
as zero when FP is transformed{p_end}
{synopt :{opth cat:zero(varlist)}}add indicator variable for specified
predictors{p_end}
{synopt :{opt all}}include
	out-of-sample observations in generated variables{p_end}

{syntab :Reporting}
{synopt :{opt lev:el(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help mfp##display_options:display_options}}}control column
        formats and line width{p_end}
{synoptline}

{synopthdr :regression_cmd_options}
{synoptline}
{syntab :Adv. model}
{synopt :{it:regression_cmd_options}}options appropriate to the regression command in use{p_end}
{synoptline}
{p2colreset}{...}

{marker weight}{...}
{p 4 6 2}
All weight types supported by {it:regression_cmd} are allowed; see
{help weight}.{p_end}
{p 4 6 2}
See {helpb mfp postestimation:[R] mfp postestimation} for features available
after estimation.{p_end}
{p 4 6 2}
{opt fp generate} may be used to create new variables containing fractional
polynomial powers.  See {helpb fp:[R] fp}.{p_end}

{pstd}
{marker reg_cmd}where

{pin}
{it:regression_cmd} may be
{helpb clogit},
{helpb glm},
{helpb intreg}, 
{helpb logistic},
{helpb logit},
{helpb mlogit},
{helpb nbreg},
{helpb ologit},
{helpb oprobit},
{helpb poisson},
{helpb probit},
{helpb qreg},
{helpb regress},
{helpb rreg},
{helpb stcox},
{helpb stcrreg},
{helpb streg},
or
{helpb xtgee}.

{pin}
{it:yvar1} is not allowed for {opt streg}, {opt stcrreg}, and {opt stcox}.
For these commands, you must first {helpb stset} your data.

{pin}
{it:yvar1} and {it:yvar2} must both be specified when {it:regression_cmd} is
{opt intreg}.

{pin}
{it:xvarlist} has elements of type {varlist} or {cmd:(}{it:varlist}{cmd:)}
or both, for example, {cmd:x1 x2 (x3 x4 x5)}.

{pin}
Elements enclosed in parentheses are tested jointly for inclusion in the
model and are not eligible for fractional polynomial transformation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Fractional polynomials >}
    {bf:Multivariable fractional polynomial models} 


{marker description}{...}
{title:Description}

{pstd}
{opt mfp} selects the multivariable fractional polynomial (MFP) model that best
predicts the outcome variable from the right-hand-side variables in
{it:{help varlist:xvarlist}}.

{pstd}
For univariate fractional polynomials, {cmd:fp} can be used to fit a wider range
of models than {cmd:mfp}.  See {helpb fp:[R] fp} for more details.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mfpQuickstart:Quick start}

        {mansection R mfpRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model 2}

{phang}
{opt sequential} chooses the sequential fractional polynomial (FP) selection
algorithm (see
{mansection R mfpRemarksandexamplesMethodsofFPmodelselection:{it:Methods of FP model selection}}
in {bf:[R] mfp}).

{phang}
{opt cycles(#)} sets the maximum number of iteration cycles
    permitted.  {cmd:cycles(5)} is the default.

{phang}
{opt dfdefault(#)} determines the default maximum degrees of
    freedom (df) for a predictor. The default is {cmd:dfdefault(4)}
    (second-degree FP).

{phang}
{opt center(cent_list)}
defines the centering of the covariates {it:{help varname:xvar1}},
    {it:xvar2}, ... of {it:{help varlist:xvarlist}}.  The default is
    {cmd:center(mean)}, except for binary
    covariates, where it is {opt center(#)}, with {it:#} being the lower
    of the two distinct values of the covariate.
    A typical item in {it:cent_list} is
    {varlist}{cmd::}{c -(}{opt mean}|{it:#}|{opt no}{c )-}.
    Items are separated by commas.  The first item is special in that
    {it:varlist} is optional, and if it is omitted, the default is reset to
    the specified value ({opt mean}, {it:#}, or {opt no}).  For example,
    {cmd:center(no, age:mean)} sets the default to {opt no} (that is, no
    centering) and the centering of {opt age} to {opt mean}.

{phang}
{opt alpha(alpha_list)}
    sets the significance levels for testing between FP models
    of different degrees. The rules for {it:alpha_list} are the same as
    those for {it:df_list} in the {helpb mfp##df:df()} option.
    The default nominal p-value (significance level, selection level) is 0.05
    for all variables.

{pmore}
	Example: {cmd:alpha(0.01)} specifies that all variables have an FP
	selection level of 1%.

{pmore}
	Example: {cmd:alpha(0.05, weight:0.1)} specifies that all variables
	except {opt weight} have an FP selection level of 5%; {opt weight}
	has a level of 10%.

{phang}{marker df}
{opt df(df_list)}
    sets the df for each predictor. The df (not
    counting the regression constant, {cmd:_cons}) is twice the degree of the
    FP, so, for example, an {it:{help varname:xvar}} fit as a second-degree FP
    (FP2) has 4 df.  The first item in {it:df_list} may be either {it:#} or
    {varlist}{cmd::}{it:#}.  Subsequent items must be
    {it:varlist}{cmd::}{it:#}.  Items are separated by commas, and
    {it:varlist} is specified in the usual way for variables.  With the first
    type of item, the df for all predictors is taken to be {it:#}.  With the
    second type of item, all members of {it:varlist} (which must be a subset
    of {it:{help varlist:xvarlist}}) have {it:#} df.

{pmore}
    The default number of degrees of freedom for a predictor of type
    {it:varlist} specified in {it:xvarlist} but not in {it:df_list} is
    assigned according to the number of distinct (unique) values of the
    predictor, as follows:

            {hline 43}
            # of distinct values    Default df
            {hline 43}
                      1             (invalid predictor)
                     2-3            1
                     4-5            min(2, {opt dfdefault()})
                     {ul:>}6             {opt dfdefault()}
            {hline 43}

{pmore}
    Example:  {cmd:df(4)}{break}
    All variables have 4 df.

{pmore}
    Example:  {cmd:df(2, weight displ:4)}{break}
    {opt weight} and {opt displ} have 4 df; all other variables have 2 df.

{pmore}
    Example:  {cmd:df(weight displ:4, mpg:2)}{break}
    {opt weight} and {opt displ} have 4 df, {opt mpg} has 2 df; all other
    variables have default df.

{phang}{marker powers}
{opth powers(numlist)} is the set of FP powers to
    be used. The default set is -2, -1, -0.5, 0, 0.5, 1, 2, 3 (0 means log).

{dlgtab:Adv. model}

{phang}
{cmd:xorder(+}|{cmd:-}|{cmd:n)}
    determines the order of entry of the covariates into the model-selection
    algorithm. The default is {cmd:xorder(+)}, which enters them in decreasing
    order of significance in a multiple linear regression (most significant
    first). {cmd:xorder(-)} places them in reverse significance order, whereas
    {cmd:xorder(n)} respects the original order in {it:{help varlist:xvarlist}}.

{phang}
{opt select(select_list)}
    sets the nominal p-values (significance levels) for variable selection by
    backward elimination.  A variable is dropped if its removal causes a
    nonsignificant increase in deviance.  The rules for {it:select_list} are
    the same as those for {it:df_list} in the {helpb mfp##df:df()} option.
    Using the default selection level of 1 for all variables forces them all
    into the model.  Setting the nominal p-value to be 1 for a given variable
    forces it into the model, leaving others to be selected or not. The
    nominal p-value for elements of {it:{help varlist:xvarlist}} bound by
    parentheses is specified by including {opt (varlist)} in {it:select_list}.

{pmore}
    Example:  {cmd:select(0.05)}{break}
    All variables have a nominal p-value of 5%.

{pmore}
    Example:  {cmd:select(0.05, weight:1)}{break}
    All variables except {opt weight} have a nominal p-value of 5%;
    {opt weight} is forced into the model.

{pmore}
    Example:  {cmd:select(a (b c):0.05)}{break}
    All variables except {opt a}, {opt b}, and {opt c} are forced into the
    model.  {opt b} and {opt c} are tested jointly with 2 df at the 5%
    level, and {opt a} is tested singly at the 5% level.

{phang}
{opt xpowers(xp_list)}
    sets the permitted FP powers for covariates
    individually.  The rules for {it:xp_list} are the same as for {it:df_list}
    in the {helpb mfp##df:df()} option. The default selection is the same as
    that for the {helpb mfp##powers:powers()} option.

{pmore}
    Example:  {cmd:xpowers(-1 0 1)}{break}
    All variables have powers -1, 0, 1.

{pmore}
    Example:  {cmd:xpowers(x5:-1 0 1)}{break}
    All variables except {cmd:x5} have default powers; {cmd:x5} has powers
    -1, 0, 1.

{phang}
{opth zero(varlist)}
    treats negative and zero values of members of {it:varlist} as zero
    when FP transformations are applied.  By default, such variables are
    subjected to a preliminary linear transformation to avoid negative and zero
    values, as described in the
    {helpb fp##scale:scale} option of {manhelp fp R}.
    {it:varlist} must be part of {it:{help varlist:xvarlist}}.

{phang}
{opth catzero(varlist)}
    is a variation on {opt zero()}; see
    {it:{mansection R mfpRemarksandexamplesZerosandzerocategories:Zeros and zero categories}}
    in {bf:[R] mfp}.  {it:varlist} must be part of {it:{help varlist:xvarlist}}.

{phang}
{it:regression_cmd_options} may be any of the options appropriate to
    {it:{help mfp##reg_cmd:regression_cmd}}.

{phang}
{cmd:all} includes out-of-sample observations when generating the 
FP variables.
By default, the generated FP variables contain missing values outside
the estimation sample.

{dlgtab:Reporting}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For elements in {it:xvarlist} not enclosed in parentheses, {cmd:mfp} leaves
variables in the data named {cmd:I}{it:xvar}{cmd:__1},
{cmd:I}{it:xvar}{cmd:__2}, ...,  where {it:xvar} represents the first four
letters of the name of {it:xvar1}, and so on for {it:xvar2}, {it:xvar3}, etc.
The new variables contain the best-fitting FP powers of
{it:xvar1}, {it:xvar2}, ....
                                                                                

{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit MFP regression{p_end}
{phang2}{cmd:. mfp: regress mpg weight displacement foreign}{p_end}

{pstd}Specify 4 df for weight and displacement and 1 df for all other variables
{p_end}
{phang2}{cmd:. mfp, df(1, weight displ:4): regress mpg weight displacement}
   {cmd:foreign}{p_end}

{pstd}Force {cmd:foreign} into the model; set a backward-elimination threshold
of 0.05 for all other variables; specify 1 df for {cmd:foreign} and 2 df for
the other variables{p_end}
{phang2}{cmd:. mfp, select(0.05, foreign:1) df(2, foreign:1): regress mpg}
    {cmd:weight displacement foreign}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse brcancer, clear}{p_end}
{phang2}{cmd:. stset rectime, fail(censrec)}{p_end}

{pstd}Fit MFP Cox regression; force hormon into the model and set a
backward-elimination threshold of 0.05 for the other variables{p_end}
{phang2}{cmd:. mfp, select(0.05, hormon:1): stcox x1 x2 x3 x4a x4b x5 x6 x7}
   {cmd:hormon, nohr}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to what {it:regression_cmd} stores, {cmd:mfp} stores the following
in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(fp_nx)}}number of predictors in {it:xvarlist}{p_end}
{synopt:{cmd:e(fp_dev)}}deviance of final model fit{p_end}
{synopt:{cmd:e(Fp_id}{it:#}{cmd:)}}initial degrees of freedom for the {it:#}th element of
{it:xvarlist}{p_end}
{synopt:{cmd:e(Fp_fd}{it:#}{cmd:)}}final degrees of freedom for the {it:#}th element of
{it:xvarlist}{p_end}
{synopt:{cmd:e(Fp_al}{it:#}{cmd:)}}FP selection level for the {it:#}th element of
{it:xvarlist}{p_end}
{synopt:{cmd:e(Fp_se}{it:#}{cmd:)}}backward elimination selection level for the {it:#}th
element of {it:xvarlist}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(fp_cmd)}}{cmd:fracpoly}{p_end}
{synopt:{cmd:e(fp_cmd2)}}{cmd:mfp}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(fracpoly)}}command used to fit the selected model using
    {cmd:fracpoly}{p_end}
{synopt:{cmd:e(fp_fvl)}}variables in final model{p_end}
{synopt:{cmd:e(fp_depv)}}{it:yvar1} ({it:yvar2}){p_end}
{synopt:{cmd:e(fp_opts)}}estimation command options{p_end}
{synopt:{cmd:e(fp_x1)}}first variable in {it:xvarlist}{p_end}
{synopt:{cmd:e(fp_x2)}}second variable in {it:xvarlist}{p_end}
{synopt:...}{p_end}
{synopt:{cmd:e(fp_x}{it:N}{cmd:)}}last variable in {it:xvarlist}, N={cmd:e(fp_nx)}
{p_end}
{synopt:{cmd:e(fp_k1)}}power for first variable in {it:xvarlist} (*){p_end}
{synopt:{cmd:e(fp_k2)}}power for second variable in {it:xvarlist} (*){p_end}
{synopt:...}{p_end}
{synopt:{cmd:e(fp_k}{it:N}{cmd:)}}power for last var. in {it:xvarlist} (*),
               N={cmd:e(fp_nx)}{p_end}

{pstd}
Note: (*) contains `.' if the variable is not selected in the final model.
{p_end}
{p2colreset}{...}
