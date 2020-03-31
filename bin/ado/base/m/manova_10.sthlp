{smcl}
{* *! version 1.0.9  15jun2010}{...}
{* based on version 1.0.6  17may2007 of manova.sthlp}{...}
{* this help file does not appear in the manual}{...}
{cmd:help manova_10} {right:also see:  {help manova_postestimation_10}}
{right:{help previously documented}{space 3}}
{hline}

{title:Title}

{p 4 21 2}
{hi:[MV] manova} {hline 2} {cmd:manova} syntax prior to version 11

{p 12 12 8}
{it}[{bf:manova} syntax was changed as of version 11.  This help file
documents {cmd:manova}'s old syntax and as such is probably of no interest to
you.  If you have set {helpb version} to less than 11 in your old do-files,
you do not have to translate {cmd:manova}s to modern syntax.  This help file
is provided for those wishing to debug or understand old code.  Click
{help manova:here} for the help file of the modern {cmd:manova} command.]{rm}


{title:Syntax}

{p 8 15 2}{cmdab:mano:va} {depvarlist} {cmd:=}
{it:term} [[{cmd:/}] [{it:term} [{cmd:/}] {it:...}]]
{ifin} {weight}
[{cmd:,} {it:options}]

{pstd}
where {it:term} is of the
form {space 2} {it:varname}[{c -(}{cmd:*}|{cmd:|}{c )-}{it:varname}[{it:...}]]


{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opth ca:tegory(varlist)}}names of variables in the {it:terms} that
	are categorical or class{p_end}
{synopt:{opth cl:ass(varlist)}}synonym for {opt category(varlist)}{p_end}
{synopt:{opth cont:inuous(varlist)}}names of variables in the {it:terms} that
	are continuous{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}

{syntab:Reporting}
{synopt:{opt d:etail}}report categorical variable value mappings{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, and {cmd:statsby} are allowed;
see {help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weight}
{p_end}
{p 4 6 2}
See {help manova_postestimation_10} for features
available after estimation.{p_end}


{title:Description}

{pstd}
The {cmd:manova} command fits multivariate analysis-of-variance (MANOVA) and multivariate
analysis-of-covariance (MANCOVA) models for balanced and unbalanced designs,
including designs with missing cells, and for factorial, nested, or mixed
designs, or designs involving repeated measures.

{pstd}
See {manhelp anova R} for univariate ANOVA and ANCOVA models.


{title:Options}

{dlgtab:Model}

{phang}
{opt category(varlist)} indicates the names of the variables in the {it:terms}
that are categorical or class variables.  Stata ordinarily assumes that all
variables are categorical variables, so usually this option need not
be specified.  If you specify this option, however, the variables referred to 
in the {it:terms} that are not listed in the {opt category()} option are
assumed to be continuous.  Also see the {opt class()} and {opt continuous()}
options.

{phang}
{opt class(varlist)} is a synonym for {opt category(varlist)}.

{phang}
{opt continuous(varlist)} indicates the names of the variables in the
{it:terms} that are continuous.  Stata ordinarily assumes that all variables
are categorical variables.  Also see the {opt category()} and {opt class()}
options.

{phang}
{opt noconstant} suppresses the constant term (intercept) from the model.

{dlgtab:Reporting}

{phang}
{opt detail} presents a table showing the actual values of the categorical
variables along with their mapping into level numbers.  You may specify this
option at estimation or upon replay, for example, {cmd:manova, detail}.


{title:Remarks}

{pstd}
The {cmd:*} in the definition of a {it:term} indicates interaction.  The
{cmd:|} indicates nesting ({cmd:a|b} is said: {cmd:a} is nested within {cmd:b}).
A {cmd:/} between {it:terms} indicates that the {it:term} to the right of the
slash is the error {it:term} for the {it:terms} to the left of the slash.


{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/metabolic}

{pstd}One-way MANOVA{p_end}
{phang2}{cmd:. version 10.1: manova y1 y2 = group}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/jaw}

{pstd}Two-way MANOVA{p_end}
{phang2}{cmd:. version 10.1: manova y1 y2 y3 = gender fracture gender*fracture}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/rash2}{p_end}

{pstd}Manova with nested data{p_end}
{phang2}{cmd:. version 10.1: manova response response2 = t / c|t / d|c|t / p|d|c|t /}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/reading2}{p_end}

{pstd}Split-plot MANOVA{p_end}
{phang2}{cmd:. version 10.1: manova score comp = pr / cl|pr sk pr*sk / cl*sk|pr /}
            {cmd:gr|cl*sk|pr /}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/biochemical}

{pstd}MANCOVA{p_end}
{phang2}{cmd:. version 10.1: manova y1 y2 y3 = group x1 x2, continuous(x1 x2)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use http://www.stata-press.com/data/r10/nobetween}{p_end}
{phang2}{cmd:. gen mycons = 1}

{pstd}MANOVA with repeated measures data{p_end}
{phang2}{cmd:. version 10.1: manova test1 test2 test3 = mycons, noconstant}{p_end}
{phang2}{cmd:. mat c = (1,0,-1 \ 0,1,-1)}{p_end}
{phang2}{cmd:. manovatest mycons, ytransform(c)}{p_end}
    {hline}


{title:Saved results}

{pstd}
{cmd:manova} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(k_eq)}}number of equations{p_end}
{synopt:{cmd:e(df_}{it:#}{cmd:)}}degrees of freedom for term {it:#}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:manova}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvars)}}names of dependent variables{p_end}
{synopt:{cmd:e(indepvars)}}names of the right-hand-side variables{p_end}
{synopt:{cmd:e(term_}{it:#}{cmd:)}}term {it:#}{p_end}
{synopt:{cmd:e(errorterm_}{it:#}{cmd:)}}error term for term {it:#} (defined for terms using
nonresidual error){p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}{cmd:b_nonames V_nonames}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector (a stacked version of {cmd:e(B)}){p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(B)}}coefficient matrix{p_end}
{synopt:{cmd:e(E)}}residual-error SSCP matrix{p_end}
{synopt:{cmd:e(xpxinv)}}generalized inverse of X'X{p_end}
{synopt:{cmd:e(H_m)}}hypothesis SSCP matrix for the overall model{p_end}
{synopt:{cmd:e(stat_m)}}multivariate statistics for the overall model{p_end}
{synopt:{cmd:e(eigvals_m)}}eigenvalues of {cmd:E^-1H} for the overall model{p_end}
{synopt:{cmd:e(aux_m)}}s, m, and n values for the overall model{p_end}
{synopt:{cmd:e(H_}{it:#}{cmd:)}}hypothesis SSCP matrix for term {it:#}{p_end}
{synopt:{cmd:e(stat_}{it:#}{cmd:)}}multivariate statistics for term {it:#} (if computed){p_end}
{synopt:{cmd:e(eigvals_}{it:#}{cmd:)}}eigenvalues of {cmd:E^-1H} for term {it:#} (if computed){p_end}
{synopt:{cmd:e(aux_}{it:#}{cmd:)}}s, m, and n values for term {it:#} (if computed){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:Also see}

{psee}
Manual:  {help previously documented}

{psee}
{space 2}Help:  {manhelp manova MV}
{p_end}
