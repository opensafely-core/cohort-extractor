{smcl}
{* *! version 1.4.7  29may2018}{...}
{viewerdialog rologit "dialog rologit"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rologit postestimation" "help rologit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[R] nlogit" "help nlogit"}{...}
{vieweralsosee "[R] slogit" "help slogit"}{...}
{viewerjumpto "Syntax" "rologit##syntax"}{...}
{viewerjumpto "Menu" "rologit##menu"}{...}
{viewerjumpto "Description" "rologit##description"}{...}
{viewerjumpto "Options" "rologit##options"}{...}
{viewerjumpto "Examples" "rologit##examples"}{...}
{viewerjumpto "A note on data organization" "rologit##note"}{...}
{viewerjumpto "Stored results" "rologit##results"}{...}
{viewerjumpto "References" "rologit##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] rologit} {hline 2}}Rank-ordered logistic regression{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rrologit.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:rologit} has been renamed to {helpb cmrologit}.  {cmd:rologit}
continues to work but, as of Stata 16, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:rologit} {depvar} {indepvars} {ifin}
[{it:{help rologit##weight:weight}}]{cmd:,}
   {opth gr:oup(varname)} 
   [{it:options}]

{synoptset 19 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Model}
{p2coldent: * {opth gr:oup(varname)}}identifier variable that links the
alternatives{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with 
coefficient constrained to 1{p_end}
{synopt :{opt inc:omplete(#)}}use {it:#} to code unranked alternatives; 
default is {cmd:incomplete(0)}{p_end}
{synopt :{opt rev:erse}}reverse the preference order{p_end}
{synopt :{opt note:strhs}}keep right-hand-side variables that do not vary
      within group{p_end}
{synopt :{opt ties(spec)}}method to handle ties: {opt exactm}, {opt breslow}, 
{opt efron}, or {opt none}{p_end}

{syntab:SE/Robust}
{synopt :{opth "vce(rologit##vcetype:vcetype)"}}{it:vcetype} may be {opt oim},
   {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
   {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help rologit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help rologit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}*{opt group(varname)} is required.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife}, {cmd:rolling},
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed,
except with {cmd:ties(efron)}; see {help weight}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp rologit_postestimation R:rologit postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Rank-ordered logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:rologit} fits the rank-ordered logistic regression model by
maximum likelihood
({help rologit##BCH1981:Beggs, Cardell, and Hausman 1981}).  This model is also
known as the Plackett-Luce model
({help rologit##M1995:Marden 1995}), as the exploded logit model
({help rologit##PS1978:Punj and Staelin 1978}),
and as the choice-based method of  conjoint analysis
({help rologit##HBBA2010:Hair et al. 2010}).

{pstd}
{cmd:rologit} expects the data to be in long form, similar to {cmd:clogit},
in which each of the ranked alternatives forms an observation; all observations
related to an individual are linked together by the variable that you specify
in the {opt group()} option.  The distinction from {cmd:clogit} is that
{depvar} in {cmd:rologit} records the rankings of the alternatives, whereas
for {cmd:clogit}, {it:depvar} marks only the best alternative by a value not
equal to zero.  {cmd:rologit} interprets equal scores of {it:depvar} as ties.
The ranking information may be incomplete "at the bottom" (least preferred
alternatives).  That is, unranked alternatives may be coded as 0 or as a
common value that may be specified with the {opt incomplete()} option.

{pstd}
If your data record only the unique alternative, {cmd:rologit}
fits the same model as {cmd:clogit}.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth group(varname)} is required, and it specifies the identifier variable
(numeric or string) that links the alternatives for an individual, which have
been compared and rank ordered with respect to one another.

{phang}
{opth offset(varname)}; see
      {helpb estimation options##offset():[R] estimation options}.

{phang}
{opt incomplete(#)} specifies the numeric value used to code alternatives
that are not ranked.  It is assumed that unranked alternatives are less
preferred than the ranked alternatives (that is, the data record the ranking of
the most preferred alternatives).  It is not assumed that subjects are
indifferent between the unranked alternatives.  {it:#} defaults to 0.

{phang}
{opt reverse} specifies that in the preference order, a higher number
means a less attractive alternative.  The default is that higher values
indicate more attractive alternatives.  The rank-ordered logit model
is not symmetric in the sense that reversing the ordering simply leads 
to a change in the signs of the coefficients.

{phang}
{opt notestrhs} suppresses the test that the independent variables vary within
(at least some of) the groups.  Effects of variables that are always constant
are not identified.  For instance, a rater's gender cannot directly affect his
or her rankings; it could affect the rankings only via an interaction with a
variable that does vary over alternatives.

{phang}
{opt ties(spec)} specifies the method for handling ties (indifference between
alternatives) (see {manhelp stcox ST} for details): 

{p2colset 9 19 21 2}{...}
{p2col :{opt ex:actm}}exact marginal likelihood (default){p_end}
{p2col :{opt bre:slow}}Breslow's method (default if {cmd:pweight}s specified)
{p_end}
{p2col :{opt efr:on}}Efron's method (default if robust VCE){p_end}
{p2col :{cmd:none}}no ties allowed{p_end}
{p2colreset}{...}

{marker vcetype}{...}
{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
If {cmd:ties(exactm)} is specified, {it:vcetype} may be only {opt oim},
{opt bootstrap}, or {opt jackknife}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}. 

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt iter:ate(#)}, {opt tr:ace},
[{cmd:{ul:no}}]{cmd:{ul:lo}}{cmd:g}, {opt tol:erance(#)}, 
{opt ltol:erance(#)}, 
{opt nrtol:erance(#)}, and {opt nonrtol:erance};
see {manhelp maximize R}.  These options are seldom used.

{pstd}
The following option is available with {opt rologit} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}
You have data in which subjects ranked up to four options.  {cmd:rologit}
requires that the data be in "long format", in which the responses of one 
subject are recorded in different records (observations).

{center:caseid    depvar   option   x1    x2   male}
{center:   1         4        1      1     0      0}
{center:   1         2        2      0     1      0}
{center:   1         3        3      0     0      0}
{center:   1         1        4      1     1      0}

{center:   2         1        1      3     0      0}
{center:   2         3        2      0     1      0}
{center:   2         3        3      2     1      0}
{center:   2         4        4      1     2      0}

{center:   3         1        1      3     1      1}
{center:   3         3        2      1     1      1}
{center:   3         4        4      0     1      1}

{center:   4         2        1      1     1      1}
{center:   4         1        2      1     1      1}
{center:   4         0        3      0     1      1}
{center:   4         0        4      1     0      1}

{pstd}
where 0 indicates that subject 4 only specified his two most
favorable alternatives. In this example

{pmore}
subject 1 has ranking

{pmore2}
option_1 > option_3 > option_2 > option_4

{pmore}
subject 2 has a ranking with ties,

{pmore2}
option_4 > option_2 == option_3 > option_1

{pmore}
subject 3 ranked a subset of alternatives, ignoring option 3,

{pmore2}
option_4 > option_2 > option_1

{pmore}
subject 4 had an incomplete ranking

{pmore2}
option_1 > option_2 > (option_3,option_4)

{pstd}
Subject 4 ranked option_1 highest among all four options, and ranked
option_2 highest among the remaining three options.  His preference ordering
among option_3 and option_4, however, is not known.

{pmore}{cmd:. webuse rologitxmpl2}{p_end}

{pstd}
You can fit a rank-ordered logit model for the four alternatives as

{pmore}{cmd:. rologit depvar x1 x2, group(caseid)}{p_end}

{pstd}
More complicated models may be formulated as well.  We can perform a
likelihood-ratio test that men and women rank the options in the same way
(note that the main effect of gender is not identified),

{pmore}{cmd:. estimates store base}{p_end}
{pmore}{cmd:. rologit depvar x1 x2 male#c.x1 male#c.x2, group(caseid)}{p_end}
{pmore}{cmd:. estimates store full}{p_end}
{pmore}{cmd:. lrtest base full}{p_end}


{marker note}{...}
{title:A note on data organization}

{pstd}
Sometimes your data will be in a "wide format" in which the ranking
of options are described in a series of variables, rather than in different
observations that are associated with one subject.

	caseid  opt1  opt2  opt3  opt4
	  1       4     2     3     1
	  2       1     3     3     4
	  3       1     3     .     4
	  4       2     1     0     0

{pstd}
You may want to verify that this information is identical to the data in
long format listed above.  The Stata command {helpb reshape} makes the
transformation between "long" and "wide" formats quite simple,

{pmore}{cmd:. reshape long opt, i(caseid) j(option)}{p_end}
{pmore}{cmd:. drop if missing(opt)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rologit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood of the null model ("all rankings are
	equiprobable"){p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R^2{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(g_min)}}minimum group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}maximum group size{p_end}
{synopt:{cmd:e(code_inc)}}value for incomplete preferences{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rologit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(group)}}name of {cmd:group()} variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(reverse)}}{cmd:reverse}, if specified{p_end}
{synopt:{cmd:e(ties)}}{cmd:breslow}, {cmd:efron}, {cmd:exactm}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BCH1981}{...}
{phang}
Beggs, S., S. Cardell, and J. A. Hausman. 1981. Assessing the potential demand
for electric cars.  {it:Journal of Econometrics} 17: 1-19.

{marker HBBA2010}{...}
{phang}
Hair, J. F., Jr., W. C. Black, and B. J. Babin, and R. E. Anderson. 2010.
{it:Multivariate Data Analysis}. 7th ed.  Upper Saddle River, NJ: Pearson.

{marker M1995}{...}
{phang}
Marden, J. I. 1995. {it:Analyzing and Modeling Rank Data}. 
London: Chapman & Hall.

{marker PS1978}{...}
{phang}
Punj, G. N., and R. Staelin. 1978. The choice process for graduate business
schools.  {it:Journal of Marketing Research} 15: 588-598.
{p_end}
