{smcl}
{* *! version 1.0.11  22mar2018}{...}
{viewerdialog "esize" "dialog esize"}{...}
{viewerdialog "esizei" "dialog esizei"}{...}
{vieweralsosee "[R] esize" "mansection R esize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "esize##syntax"}{...}
{viewerjumpto "Menu" "esize##menu"}{...}
{viewerjumpto "Description" "esize##description"}{...}
{viewerjumpto "Links to PDF documentation" "esize##linkspdf"}{...}
{viewerjumpto "Options" "esize##options"}{...}
{viewerjumpto "Examples" "esize##examples"}{...}
{viewerjumpto "Video example" "esize##video"}{...}
{viewerjumpto "Stored results" "esize##results"}{...}
{viewerjumpto "References" "esize##references"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] esize} {hline 2}}Effect size based on mean comparison{p_end}
{p2col:}({mansection R esize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Effect sizes for two independent samples using groups

{p 8 14 2}
{cmd:esize} {opt two:sample}
{varname}
{ifin}{cmd:,}
{opth by:(varlist:groupvar)}
[{it:{help esize##options_tbl:options}}]


{pstd}
Effect sizes for two independent samples using variables

{p 8 14 2}
{cmd:esize} {opt unp:aired}
{varname:1}
{cmd:==}
{varname:2}
{ifin}{cmd:,}
[{it:{help esize##options_tbl:options}}]


{pstd}
Immediate form of effect sizes for two independent samples

{p 8 14 2}
{cmd:esizei}
{it:#obs1}
{it:#mean1}
{it:#sd1}
{it:#obs2}
{it:#mean2}
{it:#sd2}
[{cmd:,}
{it:{help esize##options_tbl:options}}]


{pstd}
Immediate form of effect sizes for F tests after an ANOVA

{p 8 14 2}
{cmd:esizei}
{it:#df1}
{it:#df2}
{it:#F}
[{cmd:,} {opt l:evel(#)}]


{synoptset 16 tabbed}{...}
{marker options_tbl}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt coh:ensd}}report Cohen's d ({help esize##C1988:1988}){p_end}
{synopt:{opt hed:gesg}}report Hedges's g ({help esize##H1981:1981}){p_end}
{synopt:{opt gla:ssdelta}}report Glass's Delta (Smith and Glass {help esize##G1977:1977}) 
	using each group's standard deviation{p_end}
{synopt:{opt pbc:orr}}report the point-biserial correlation coefficient 
	(Pearson {help esize##P1909:1909}){p_end}
{synopt:{opt all:}}report all estimates of effect size{p_end}
{synopt:{opt une:qual}}use unequal variances{p_end}
{synopt:{opt w:elch}}use Welch's ({help esize##W1947:1947}) approximation{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{opt by} is allowed with {cmd:esize}; see {helpb by:[D] by}.{p_end}


{marker menu}{...}
{title:Menu}

    {title:esize} 

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses}
       {bf:> Effect size based on mean comparison}

    {title:esizei}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses}
       {bf:> Effect-size calculator}


{marker description}{...}
{title:Description}

{pstd}
{opt esize} calculates effect sizes for comparing the difference between the
means of a continuous variable for two groups.  In the first form, {opt esize}
calculates effect sizes for the difference between the mean of
{varname} for two groups defined by {it:{help varname:groupvar}}.  In the
second form, {opt esize} calculates effect sizes for the difference
between {it:varname1} and {it:varname2}, assuming unpaired data.  

{pstd}
{opt esizei} is the immediate form of {opt esize}; see {help immed}.
In the first form, {opt esizei} calculates the effect size for comparing the
difference between the means of two groups.  In the second form, 
{opt esizei} calculates the effect size for an F test after an ANOVA.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R esizeQuickstart:Quick start}

        {mansection R esizeRemarksandexamples:Remarks and examples}

        {mansection R esizeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by:(varlist:groupvar)} specifies the {it:groupvar} that defines the two
groups that {opt esize} will use to estimate the effect sizes.  Do not confuse
the {opt by()} option with the {cmd:by} prefix; you can specify both.

{phang}
{opt cohensd} specifies that Cohen's d ({help esize##C1988:1988}) be reported.

{phang}
{opt hedgesg} specifies that Hedges's g ({help esize##H1981:1981}) be reported.

{phang}
{opt glassdelta} specifies that Glass's Delta
(Smith and Glass {help esize##G1977:1977}) be reported.

{phang}
{opt pbcorr} specifies that the point-biserial correlation coefficient 
	(Pearson {help esize##P1909:1909}) be reported.

{phang}
{opt all} specifies that all estimates of effect size be reported.  The default
	is Cohen's d and Hedges's g.

{phang}
{opt unequal} specifies that the data not be assumed to have equal variances.

{phang}
{opt welch} specifies that the approximate degrees of freedom for the test
   be obtained from Welch's formula
   ({help ttest##W1947:1947}) rather than Satterthwaite's approximation
   formula ({help ttest##S1946:1946}), which is the default when {opt unequal}
   is specified.  Specifying {opt welch} implies {opt unequal}.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
	intervals.  The default is {cmd:level(95)} or as set by 
	{help set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse depression}{p_end}

{pstd}Effect size for two independent samples using {cmd:by()}{p_end}
{phang2}{cmd:. esize twosample qu1, by(sex)}{p_end}

{pstd}Effect size by race for two independent samples using {cmd:by()}{p_end}
{phang2}{cmd:. by race, sort: esize twosample qu1, by(sex) all}{p_end}

{pstd}Estimate bootstrap confidence intervals for effect sizes{p_end}
{phang2}{cmd:. bootstrap r(d) r(g), reps(1000) nodots nowarn:}
        {cmd:esize twosample qu1, by(sex)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fuel}

{pstd}Effect size for two independent samples using unpaired{p_end}
{phang2}{cmd:. esize unpaired mpg1==mpg2}

{pstd}Immediate form of {opt esizei} for comparing two means based on
Kline ({help esize##K2013:2013}, tables 4.2 and 4.3);
obs1=30, mean1=13, sd1=2.74, obs2=30, mean2=11, sd2=2.24{p_end}
{phang2}{cmd:. esizei 30 13 2.74 30 11 2.24}       

{pstd}Immediate form of {opt esizei} for the results of an ANOVA 
based on Smithson ({help esize##S2001:2001}, 623);
df_num=4, df_den=50, F=4.2317{p_end}
{phang2}{cmd:. esizei 4 50 4.2317, level(90)}   

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=h95_wu-OFY8":Tour of effect sizes}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:esize} and {cmd:esizei} for comparing two means store the following in
{cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:r(d)}}Cohen's d{p_end}
{synopt:{cmd:r(lb_d)}}lower confidence bound for Cohen's d{p_end}
{synopt:{cmd:r(ub_d)}}upper confidence bound for Cohen's d{p_end}
{synopt:{cmd:r(g)}}Hedges's g{p_end}
{synopt:{cmd:r(lb_g)}}lower confidence bound for Hedges's g{p_end}
{synopt:{cmd:r(ub_g)}}upper confidence bound for Hedges's g{p_end}
{synopt:{cmd:r(delta1)}}Glass's Delta for group 1{p_end}
{synopt:{cmd:r(lb_delta1)}}lower confidence bound for Glass's Delta
	for group 1{p_end}
{synopt:{cmd:r(ub_delta1)}}upper confidence bound for Glass's Delta
	for group 1{p_end}
{synopt:{cmd:r(delta2)}}Glass's Delta for group 2{p_end}
{synopt:{cmd:r(lb_delta2)}}lower confidence bound for Glass's Delta
	for group 2{p_end}
{synopt:{cmd:r(ub_delta2)}}upper confidence bound for Glass's Delta 
	for group 2{p_end}
{synopt:{cmd:r(r_pb)}}point-biserial correlation coefficient{p_end}
{synopt:{cmd:r(lb_r_pb)}}lower confidence bound for the point-biserial 
	correlation coefficient{p_end}
{synopt:{cmd:r(ub_r_pb)}}upper confidence bound for the point-biserial 
	correlation coefficient{p_end}
{synopt:{cmd:r(N_1)}}sample size n_1{p_end}
{synopt:{cmd:r(N_2)}}sample size n_2{p_end}
{synopt:{cmd:r(df_t)}}degrees of freedom{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{p2colreset}{...}


{pstd}
{cmd:esizei} for F tests after ANOVA stores the following in {cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:r(eta2)}}eta-squared{p_end}
{synopt:{cmd:r(lb_eta2)}}lower confidence bound for eta-squared{p_end}
{synopt:{cmd:r(ub_eta2)}}upper confidence bound for eta-squared{p_end}
{synopt:{cmd:r(epsilon2)}}epsilon-squared{p_end}
{synopt:{cmd:r(omega2)}}omega-squared{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker C1988}{...}
{phang}
Cohen, J. 1988.
{it:Statistical Power Analysis for the Behavioral Sciences}. 2nd ed.
Hillsdale, NJ: Erlbaum.

{marker H1981}{...}
{phang}
Hedges, L. V. 1981.
Distribution theory for Glass's estimator of effect size and related estimators.
{it:Journal of Educational Statistics} 6: 107-128.

{marker K2013}{...}
{phang}
Kline, R. B. 2013.
{it:Beyond Significance Testing: Statistics Reform in the Behavioral Sciences}.
Washington, DC: American Psychological Association.

{marker P1909}{...}
{phang}
Pearson, K. 1909.
On a new method of determining correlation between a measured character A, and 
a character B, of which only the percentage of cases wherein B exceeds (or 
falls short of) a given intensity is recorded for each grade of A.
{it:Biometrika} 7: 96-105.

{marker S1946}{...}
{phang}
Satterthwaite, F. E. 1946.
An approximate distribution of estimates of variance components.
{it:Biometrics Bulletin} 2: 110-114.

{marker G1977}{...}
{phang}
Smith, M. L., and G. V. Glass. 1977.
Meta-analysis of psychotherapy outcome studies.  
{it:American Psychologist} 32: 752-760.

{marker S2001}{...}
{phang}
Smithson, M. 2001.
Correct confidence intervals for various regression effect sizes and
parameters: The importance of noncentral distributions in computing intervals.
{it:Educational and Psychological Measurement} 61: 605-632.

{marker W1947}{...}
{phang}
Welch, B. L. 1947.
The generalization of `student's' problem when several different population
variances are involved. {it:Biometrika} 34: 28-35.
{p_end}
