{smcl}
{* *! version 1.3.4  04jun2018}{...}
{viewerdialog manova "dialog manova"}{...}
{vieweralsosee "[MV] manova" "mansection MV manova"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] manova postestimation" "help manova postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[P] anovadef" "help anovadef"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{vieweralsosee "[MV] mvtest" "help mvtest"}{...}
{vieweralsosee "[D] reshape" "help reshape"}{...}
{vieweralsosee "[SEM] sem" "help sem"}{...}
{viewerjumpto "Syntax" "manova##syntax"}{...}
{viewerjumpto "Menu" "manova##menu"}{...}
{viewerjumpto "Description" "manova##description"}{...}
{viewerjumpto "Links to PDF documentation" "manova##linkspdf"}{...}
{viewerjumpto "Options" "manova##options"}{...}
{viewerjumpto "Remarks" "manova##remarks"}{...}
{viewerjumpto "Examples" "manova##examples"}{...}
{viewerjumpto "Stored results" "manova##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MV] manova} {hline 2}}Multivariate analysis of variance and covariance
{p_end}
{p2col:}({mansection MV manova:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:manova} {depvarlist} {cmd:=} {it:termlist}
{ifin}
[{it:{help manova##weight:weight}}]
[{cmd:,} {it:options}]

{pstd}
where {it:termlist} is a {help fvvarlist:factor-variable list} with the
following additional features:

{phang2}
o  Variables are assumed to be categorical; use the {cmd:c.} factor-variable
    operator to override this.
{p_end}
{phang2}
o  The {cmd:|} symbol (indicating nesting) may be used in place of the
    {cmd:#} symbol (indicating interaction).
{p_end}
{phang2}
o  The {cmd:/} symbol is allowed after a {it:term} and indicates that the
    following {it:term} is the error term for the preceding {it:term}s.


{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opt dropemp:tycells}}drop empty cells from the design matrix{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, and {cmd:statsby} are allowed; see
{help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp manova_postestimation MV:manova postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis >}
     {bf:MANOVA, multivariate regression, and related > MANOVA}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:manova} command fits multivariate analysis-of-variance (MANOVA) and multivariate
analysis-of-covariance (MANCOVA) models for balanced and unbalanced designs,
including designs with missing cells, and for factorial, nested, or mixed
designs, or designs involving repeated measures.

{pstd}
The {helpb mvreg} command will display the coefficients, standard errors,
etc., of the multivariate regression model underlying the last run of
{cmd:manova}.

{pstd}
See {manhelp anova R} for univariate ANOVA and ANCOVA models.
See {manhelp mvtest_covariances MV:mvtest covariances} for Box's test of
MANOVA's assumption that the covariance matrices of the groups are the same,
and see {manhelp mvtest_means MV:mvtest means} for multivariate tests of means
that do not make this assumption.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV manovaQuickstart:Quick start}

        {mansection MV manovaRemarksandexamples:Remarks and examples}

        {mansection MV manovaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant term (intercept) from the model.

{phang}
{opt dropemptycells} drops empty cells from the design matrix.  If
{cmd:c(emptycells)} is set to {cmd:keep} (see {helpb set emptycells}), this
option temporarily resets it to {cmd:drop} before running the MANOVA model.  If
{cmd:c(emptycells)} is already set to {cmd:drop}, this option does nothing.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:#} symbol indicates interaction.  The
{cmd:|} symbol indicates nesting ({cmd:a|b} is read "{cmd:a} is nested within
{cmd:b}").
A {cmd:/} between {it:term}s indicates that the {it:term} to the right of the
slash is the error term for the {it:term}s to the left of the slash.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse metabolic}

{pstd}One-way MANOVA{p_end}
{phang2}{cmd:. manova y1 y2 = group}

{pstd}View the underlying multivariate regression model{p_end}
{phang2}{cmd:. mvreg}

{pstd}View the underlying multivariate regression model with 90% confidence
intervals and displaying the base categories{p_end}
{phang2}{cmd:. mvreg, level(90) base}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse jaw}

{pstd}Two-way MANOVA{p_end}
{phang2}{cmd:. manova y1 y2 y3 = gender fracture gender#fracture}

{pstd}The same model, but less typing{p_end}
{phang2}{cmd:. manova y* = gender##fracture}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse videotrainer}{p_end}

{pstd}Manova with nested data{p_end}
{phang2}{cmd:. manova primary extra = video / store|video /}
			{cmd:associate|store|video /, dropemptycells}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reading2}{p_end}

{pstd}Split-plot MANOVA{p_end}
{phang2}{cmd:. manova score comp = pr / cl|pr sk pr#sk / cl#sk|pr /}
            {cmd:gr|cl#sk|pr /, dropemptycells}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse biochemical}

{pstd}MANCOVA{p_end}
{phang2}{cmd:. manova y1 y2 y3 = group c.x1 c.x2}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nobetween}{p_end}
{phang2}{cmd:. gen mycons = 1}

{pstd}MANOVA with repeated measures data{p_end}
{phang2}{cmd:. manova test1 test2 test3 = mycons, noconstant}{p_end}
{phang2}{cmd:. mat c = (1,0,-1 \ 0,1,-1)}{p_end}
{phang2}{cmd:. manovatest mycons, ytransform(c)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:manova} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(df_}{it:#}{cmd:)}}degrees of freedom for term {it:#}{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:manova}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(indepvars)}}names of the right-hand-side variables{p_end}
{synopt:{cmd:e(term_}{it:#}{cmd:)}}term {it:#}{p_end}
{synopt:{cmd:e(errorterm_}{it:#}{cmd:)}}error term for term {it:#} (defined for terms using
nonresidual error){p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(r2)}}R-squared for each equation{p_end}
{synopt:{cmd:e(rmse)}}RMSE for each equation{p_end}
{synopt:{cmd:e(F)}}F statistic for each equation{p_end}
{synopt:{cmd:e(p_F)}}p-value for F test for each equation{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector (a stacked version of {cmd:e(B)}){p_end}
{synopt:{cmd:e(B)}}coefficient matrix{p_end}
{synopt:{cmd:e(E)}}residual-error SSCP matrix{p_end}
{synopt:{cmd:e(xpxinv)}}generalized inverse of X'X{p_end}
{synopt:{cmd:e(H_m)}}hypothesis SSCP matrix for the overall model{p_end}
{synopt:{cmd:e(stat_m)}}multivariate statistics for the overall model{p_end}
{synopt:{cmd:e(eigvals_m)}}eigenvalues of {cmd:E^-1H} for the overall model{p_end}
{synopt:{cmd:e(aux_m)}}{cmd:s}, {cmd:m}, and {cmd:n} values for the overall
              model{p_end}
{synopt:{cmd:e(H_}{it:#}{cmd:)}}hypothesis SSCP matrix for term {it:#}{p_end}
{synopt:{cmd:e(stat_}{it:#}{cmd:)}}multivariate statistics for term {it:#} (if computed){p_end}
{synopt:{cmd:e(eigvals_}{it:#}{cmd:)}}eigenvalues of {cmd:E^-1H} for term {it:#} (if computed){p_end}
{synopt:{cmd:e(aux_}{it:#}{cmd:)}}{cmd:s}, {cmd:m}, and {cmd:n} values for
              term {it:#} (if computed){p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
