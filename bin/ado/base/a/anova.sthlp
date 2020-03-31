{smcl}
{* *! version 1.4.6  13may2019}{...}
{viewerdialog anova "dialog anova"}{...}
{vieweralsosee "[R] anova" "mansection R anova"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova postestimation" "help anova postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] icc" "help icc"}{...}
{vieweralsosee "[R] loneway" "help loneway"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{vieweralsosee "[PSS-2] power oneway" "help power oneway"}{...}
{vieweralsosee "[PSS-2] power repeated" "help power repeated"}{...}
{vieweralsosee "[PSS-2] power twoway" "help power twoway"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SEM] sem" "help sem"}{...}
{viewerjumpto "Syntax" "anova##syntax"}{...}
{viewerjumpto "Menu" "anova##menu"}{...}
{viewerjumpto "Description" "anova##description"}{...}
{viewerjumpto "Links to PDF documentation" "anova##linkspdf"}{...}
{viewerjumpto "Options" "anova##options"}{...}
{viewerjumpto "Remarks" "anova##remarks"}{...}
{viewerjumpto "Examples" "anova##examples"}{...}
{viewerjumpto "Video examples" "anova##video"}{...}
{viewerjumpto "Stored results" "anova##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] anova} {hline 2}}Analysis of variance and covariance
{p_end}
{p2col:}({mansection R anova:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:anova}
{varname}
[{it:termlist}]
{ifin}
[{it:{help anova##weight:weight}}]
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
o  The {cmd:/} symbol is allowed after a term and indicates that the
    following term is the error term for the preceding terms.

{synoptset 23 tabbed}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opth rep:eated(varlist)}}variables in {it:term}s that are
repeated-measures variables{p_end}
{synopt:{opt p:artial}}use partial (or marginal) sums of squares{p_end}
{synopt:{opt se:quential}}use sequential sums of squares{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opt dropemp:tycells}}drop empty cells from the design matrix{p_end}

{syntab:Adv. model}
{synopt:{opt bse(term)}}between-subjects error term in repeated-measures
ANOVA{p_end}
{synopt:{opth bseunit(varname)}}variable representing lowest unit in the
between-subjects error term{p_end}
{synopt:{opth group:ing(varname)}}grouping variable for computing pooled
covariance matrix{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife}, and {opt statsby}
are allowed; see {help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}
See {manhelp anova_postestimation R:anova postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > ANOVA/MANOVA >}
      {bf:Analysis of variance and covariance}


{marker description}{...}
{title:Description}

{pstd}
The {opt anova} command fits analysis-of-variance (ANOVA) and
analysis-of-covariance (ANCOVA) models for balanced and unbalanced designs,
including designs with missing cells; for repeated-measures ANOVA; and for
factorial, nested, or mixed designs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R anovaQuickstart:Quick start}

        {mansection R anovaRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth repeated(varlist)} indicates the names of the
categorical variables in the {it:term}s that are to be treated as
repeated-measures variables in a repeated-measures ANOVA or ANCOVA.

{phang}
{opt partial} presents the ANOVA table using partial (or marginal) sums
of squares.  This setting is the default.  Also see the {opt sequential}
option.

{phang}
{opt sequential} presents the ANOVA table using sequential sums of squares.

{phang}
{opt noconstant} suppresses the constant term (intercept) from the ANOVA
or regression model.

{phang}
{opt dropemptycells} drops empty cells from the design matrix.  If
{cmd:c(emptycells)} is set to {cmd:keep} (see {helpb set emptycells}), this
option temporarily resets it to {cmd:drop} before running the ANOVA model.  If
{cmd:c(emptycells)} is already set to {cmd:drop}, this option does nothing.

{dlgtab:Adv. model}

{phang}
{opt bse(term)} indicates the between-subjects error term in
a repeated-measures ANOVA.  This option is needed only in the rare case when
the {opt anova} command cannot automatically determine the between-subjects
error term.

{phang}
{opth bseunit(varname)} indicates the variable representing
the lowest unit in the between-subjects error term in a repeated-measures
ANOVA.  This option is rarely needed because the {opt anova} command
automatically selects the first variable listed in the between-subjects error
term as the default for this option.

{phang}
{opth grouping(varname)} indicates a variable that determines which
observations are grouped together in computing the covariance matrices that
will be pooled and used in a repeated-measures ANOVA.  This option is
rarely needed because the {opt anova} command automatically selects the
combination of all variables except the first (or as specified in the
{opt bseunit()} option) in the between-subjects error term as the default for
grouping observations.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:anova} uses least squares to fit the linear models known as ANOVA or
ANCOVA (henceforth referred to simply as ANOVA models).

{pstd}
If you want to fit one-way ANOVA models, you may find the {helpb oneway} or
{helpb loneway} command more convenient. If you are interested in MANOVA or
MANCOVA, see {helpb manova}.

{pstd}
The {helpb regress} command is used to fit the underlying regression model
corresponding to an ANOVA model fit using the {cmd:anova} command.  Type
{cmd:regress} after {cmd:anova} to see the coefficients, standard errors, etc.,
of the regression model for the last run of {cmd:anova}.

{pstd}
Structural equation modeling provides a more general framework for fitting ANOVA
models; see the
{mansection SEM sem:{it:Stata Structural Equation Modeling Reference Manual}}.


{marker examples}{...}
{title:Examples}

{pstd}One-way ANOVA{p_end}
{phang2}{cmd:. webuse systolic}{p_end}
{phang2}{cmd:. anova systolic drug}{p_end}

{pstd}Two-way ANOVA{p_end}
{phang2}{cmd:. anova systolic drug disease}{p_end}

{pstd}Two-way factorial ANOVA{p_end}
{phang2}{cmd:. anova systolic drug disease drug#disease}{p_end}

{pstd}or more simply{p_end}
{phang2}{cmd:. anova systolic drug##disease}{p_end}

{pstd}Three-way  factorial ANOVA{p_end}
{phang2}{cmd:. webuse manuf}{p_end}
{phang2}{cmd:. anova yield temp chem temp#chem meth temp#meth chem#meth temp#chem#meth}{p_end}

{pstd}or more simply{p_end}
{phang2}{cmd:. anova yield temp##chem##meth}{p_end}

{pstd}ANCOVA{p_end}
{phang2}{cmd:. webuse census2}{p_end}
{phang2}{cmd:. quietly summarize age}{p_end}
{phang2}{cmd:. generate mage = age - r(mean)}{p_end}
{phang2}{cmd:. anova drate region c.mage region#c.mage}{p_end}

{pstd}Nested ANOVA{p_end}
{phang2}{cmd:. webuse machine, clear}{p_end}
{phang2}{cmd:. anova output machine / operator|machine /, dropemptycells}{p_end}

{pstd}Split-plot ANOVA{p_end}
{phang2}{cmd:. webuse reading}{p_end}
{phang2}{cmd:. anova score prog / class|prog skill prog#skill / class#skill|prog / group|class#skill|prog /, dropemptycells}{p_end}

{pstd}Repeated-measures ANOVA{p_end}
{phang2}{cmd:. webuse t43}{p_end}
{phang2}{cmd:. anova score person drug, repeated(drug)}{p_end}


{marker video}{...}
{title:Video examples}

{phang}
{browse "http://www.youtube.com/watch?v=Kb9WG4o9zLk":Analysis of covariance in Stata}

{phang}
{browse "http://www.youtube.com/watch?v=3g1Yj7Vd0mE":Two-way ANOVA in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:anova} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ss_}{it:#}{cmd:)}}sum of squares for term {it:#}{p_end}
{synopt:{cmd:e(df_}{it:#}{cmd:)}}numerator degrees of freedom for term
	{it:#}{p_end}
{synopt:{cmd:e(ssdenom_}{it:#}{cmd:)}}denominator sum of squares for term
	{it:#} (when using nonresidual error){p_end}
{synopt:{cmd:e(dfdenom_}{it:#}{cmd:)}}denominator degrees of freedom for term
	{it:#} (when using nonresidual error){p_end}
{synopt:{cmd:e(F_}{it:#}{cmd:)}}F statistic for term {it:#} (if computed){p_end}
{synopt:{cmd:e(N_bse)}}number of levels of the between-subjects error
	term{p_end}
{synopt:{cmd:e(df_bse)}}degrees of freedom for the between-subjects error
	term{p_end}
{synopt:{cmd:e(box}{it:#}{cmd:)}}Box's conservative epsilon for a particular
	combination of repeated variables ({cmd:repeated()} only){p_end}
{synopt:{cmd:e(gg}{it:#}{cmd:)}}Greenhouse-Geisser epsilon for a particular
	combination of repeated variables ({cmd:repeated()} only){p_end}
{synopt:{cmd:e(hf}{it:#}{cmd:)}}Huynh-Feldt epsilon for a particular
	combination of repeated variables ({cmd:repeated()} only){p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:anova}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(varnames)}}names of the right-hand-side variables{p_end}
{synopt:{cmd:e(term_}{it:#}{cmd:)}}term {it:#}{p_end}
{synopt:{cmd:e(errorterm_}{it:#}{cmd:)}}error term for term {it:#} (when using
	nonresidual error){p_end}
{synopt:{cmd:e(sstype)}}type of sum of squares; {cmd:sequential} or
	{cmd:partial}{p_end}
{synopt:{cmd:e(repvars)}}names of repeated variables ({cmd:repeated()}
	only){p_end}
{synopt:{cmd:e(repvar}{it:#}{cmd:)}}names of repeated variables for a
	particular combination ({cmd:repeated()} only){p_end}
{synopt:{cmd:e(model)}}{cmd:ols}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(Srep)}}covariance matrix based on repeated measures
	({cmd:repeated()} only){p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
