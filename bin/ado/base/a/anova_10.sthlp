{smcl}
{* *! version 1.2.10  22may2009}{...}
{* based on version 1.2.6  26apr2007 of anova.sthlp}{...}
{* this help file does not appear in the manual}{...}
{cmd:help anova_10}{right:also see:  {help anova_postestimation_10}}
{right: {help previously documented}{space 2}}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col:{hi:[R] anova} {hline 2}}{cmd:anova} syntax prior to version 11{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[{bf:anova} syntax was changed as of version 11.  This help file documents
{cmd:anova}'s old syntax and as such is probably of no interest to you.  If
you have set {helpb version} to less than 11 in your old do-files, you do not
have to translate {cmd:anova}s to modern syntax.  This help file is provided
for those wishing to debug or understand old code.  Click {help anova:here}
for the help file of the modern {cmd:anova} command.]{rm}


{title:Syntax}

{p 8 14 2}
{cmdab:an:ova}
{varname}
[{it:term} [{cmd:/}] [{it:term} [{cmd:/}] {it:...}]]
{ifin}
{weight}
[{cmd:,} {it:options}]

{p 8 14 2}
where {it:term} is of the form {space 2}{it:varname}[{c -(}{cmd:*}|{cmd:|}{c )-}{it:varname}[{it:...}]]

{synoptset 23 tabbed}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opth ca:tegory(varlist)}}variables in {it:terms} that are categorical or
class{p_end}
{synopt:{opth cl:ass(varlist)}}synonym for
{cmd:category(}{it:varlist}{cmd:)}{p_end}
{synopt:{opth cont:inuous(varlist)}}variables in {it:terms} that are
continuous{p_end}
{synopt:{opth rep:eated(varlist)}}variables in {it:terms} that are
repeated-measures variables{p_end}
{synopt:{opt p:artial}}use partial (or marginal) sums of squares{p_end}
{synopt:{opt se:quential}}use sequential sums of squares{p_end}
{synopt:{opt nocons:tant}}suppress constant term{p_end}

{syntab:Adv. model}
{synopt:{opt bse(term)}}between-subjects error term in repeated-measures
ANOVA{p_end}
{synopt:{opth bseunit(varname)}}variable representing lowest unit in the
between-subjects error term{p_end}
{synopt:{opth group:ing(varname)}}grouping variable for computing pooled
covariance matrix{p_end}

{syntab:Reporting}
{synopt:{opt r:egress}}display the regression table{p_end}
{synopt:[{cmdab:no:}]{opt an:ova}}display or suppress the ANOVA table{p_end}
{synopt:{opt d:etail}}show mapping from values to level numbers for
categorical variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed; see {help prefix}.
{p_end}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}
See {help anova_postestimation_10} for features
available after estimation.{p_end}


{title:Description}

{pstd}
The {opt anova} command fits analysis-of-variance (ANOVA) and
analysis-of-covariance (ANCOVA) models for balanced and unbalanced designs,
including designs with missing cells; for repeated-measures ANOVA; and for
factorial, nested, or mixed designs.  {opt anova} can also be used to produce
regression estimates by those who have no interest in ANOVA and ANCOVA
output.

{pstd}
If you want to fit one-way ANOVA models, you may find the {opt oneway} or
{opt loneway} command more convenient; see {manhelp oneway R} and
{manhelp loneway R}.  If you are interested in MANOVA or MANCOVA, see
{manhelp manova MV}.


{title:Options}

{dlgtab:Model}

{phang}
{opth category(varlist)} indicates the names of the variables
in the {it:terms} that are categorical or class variables.  Stata ordinarily
assumes that all variables are categorical variables, so this
option need not be specified.  If you specify this option, however, the
variables referred to in the {it:terms} that are not listed in the
{cmd:category()} option are assumed to be continuous.  Also see the
{cmd:class()} and {cmd:continuous()} options.

{phang}
{opth class(varlist)} is a synonym for {opt category(varlist)}.

{phang}
{opth continuous(varlist)} indicates the names of the
variables in the {it:terms} that are continuous.  Stata ordinarily assumes that
all variables are categorical.  Also see the {cmd:category()} and
{cmd:class()} options.

{phang}
{opth repeated(varlist)} indicates the names of the
categorical variables in the {it:terms} that are to be treated as
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

{dlgtab:Adv. model}

{phang}
{opt bse(term)} indicates the between-subjects error term in
a repeated-measures ANOVA.  This option is needed only in the rare case when
the {opt anova} command cannot automatically determine the between-subjects
error term.

{phang}
{opth bseunit(varname)} indicates the variable representing
the lowest unit in the between-subjects error term in a repeated-measures
ANOVA.  This option is rarely needed since the {opt anova} command
automatically selects the first variable listed in the between-subjects error
term as the default for this option.

{phang}
{opth grouping(varname)} indicates a variable that determines which
observations are grouped together in computing the covariance matrices that
will be pooled and used in a repeated-measures ANOVA.  This option is
rarely needed since the {opt anova} command automatically selects the
combination of all variables except the first (or as specified in the
{opt bseunit()} option) in the between-subjects error term as the default for
grouping observations.

{dlgtab:Reporting}

{phang}
{opt regress} presents the regression output corresponding to the specified
model.  Specifying {opt regress} implies the {opt noanova} option, so if you
want both the regression output and ANOVA table, you must also specify the
{opt anova} option.  You need not specify the {opt regress} option at the time
of estimation.  You can obtain the underlying regression estimates at any time
by typing {cmd:anova, regress}.

{phang}
[{opt no}]{opt anova} indicates that the ANOVA table be or not be
displayed.  The {opt anova} command typically displays the ANOVA table, and in
those cases, the {opt noanova} option suppresses the display.  For instance,
typing {cmd:anova, detail noanova} would show the {opt detail} output
for the last ANOVA model while suppressing the ANOVA table itself.

{pmore}
If you specify the {opt regress} option, the ANOVA table is automatically
suppressed.  Then also specifying the {opt anova} option would show
both the regression output and the ANOVA table.

{phang}
{opt detail} presents a table showing the actual values of the
categorical variables along with their mapping into level numbers.  You do not
have to specify this option at the time of estimation.  You can obtain the
output at any time by typing {cmd:anova, detail}.


{title:Examples}

{pstd}{title:One-way ANOVA}

{phang2}{cmd:. use http://www.stata-press.com/data/r10/systolic}{p_end}
{phang2}{cmd:. version 10.1: anova systolic drug}{p_end}

{pstd}{title:Two-way ANOVA}

{phang2}{cmd:. version 10.1: anova systolic drug disease}{p_end}

{pstd}{title:Two-way factorial ANOVA}

{phang2}{cmd:. version 10.1: anova systolic drug disease drug*disease}{p_end}

{pstd}{title:Three-way  factorial ANOVA}

{phang2}{cmd:. use http://www.stata-press.com/data/r10/manuf}{p_end}
{phang2}{cmd:. version 10.1: anova yield temp chem temp*chem meth temp*meth chem*meth temp*chem*meth}{p_end}

{pstd}{title:Three-way factorial ANCOVA}

{phang2}{cmd:. use http://www.stata-press.com/data/r10/sysage}{p_end}
{phang2}{cmd:. version 10.1: anova systolic drug disease age disease*age, continuous(age)}{p_end}

{pstd}{title:Nested ANOVA}

{phang2}{cmd:. use http://www.stata-press.com/data/r10/machine}{p_end}
{phang2}{cmd:. version 10.1: anova output machine / operator|machine /}{p_end}

{pstd}{title:Split-plot ANOVA}

{phang2}{cmd:. use http://www.stata-press.com/data/r10/reading}{p_end}
{phang2}{cmd:. version 10.1: anova score prog / class|prog skill prog*skill / class*skill|prog / group|class*skill|prog /}{p_end}

{pstd}{title:Repeated-measures ANOVA}

{phang2}{cmd:. use http://www.stata-press.com/data/r10/t43}{p_end}
{phang2}{cmd:. version 10.1: anova score person drug, repeated(drug)}{p_end}


{title:Saved results}

{pstd}
{cmd:anova} saves the following in {cmd:e()}:

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
{synopt:{cmd:e(repvars}{it:#}{cmd:)}}names of repeated variables for a
	particular combination ({cmd:repeated()} only){p_end}
{synopt:{cmd:e(model)}}{cmd:ols}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}{cmd:b_nonames V_nonames}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

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


{title:Also see}

{psee}
Manual:  {help previously documented}
{p_end}

{psee}
{space 2}Help:  {manhelp anova R}
{p_end}
