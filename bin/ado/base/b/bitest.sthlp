{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog bitest "dialog bitest"}{...}
{viewerdialog bitesti "dialog bitesti"}{...}
{vieweralsosee "[R] bitest" "mansection R bitest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{viewerjumpto "Syntax" "bitest##syntax"}{...}
{viewerjumpto "Menu" "bitest##menu"}{...}
{viewerjumpto "Description" "bitest##description"}{...}
{viewerjumpto "Links to PDF documentation" "bitest##linkspdf"}{...}
{viewerjumpto "Option" "bitest##option"}{...}
{viewerjumpto "Examples" "bitest##examples"}{...}
{viewerjumpto "Stored results" "bitest##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] bitest} {hline 2}}Binomial probability test{p_end}
{p2col:}({mansection R bitest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Binomial probability test

{p 8 15 2}
{cmd:bitest}
	{varname} {cmd:==} {it:#p} {ifin}
        [{it:{help bitest##weight:weight}}]
	[{cmd:,} {opt d:etail}]


    Immediate form of binomial probability test

{p 8 16 2}
{cmd:bitesti}
	{it:#N} {it:#succ} {it:#p} [{cmd:,} {opt d:etail}]


{phang}
{opt by} is allowed with {cmd:bitest}; see {manhelp by D}.

{marker weight}{...}
{phang}
{opt fweight}s are allowed with {cmd:bitest}; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:bitest}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses >}
        {bf:Binomial probability test}

    {title:bitesti}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses >}
        {bf:Binomial probability test calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bitest} performs exact hypothesis tests for binomial random variables.
The null hypothesis is that the probability of a success on a trial is
{it:#p}.  The total number of trials is the number of nonmissing values of
{varname} (in {cmd:bitest}) or {it:#N} (in {cmd:bitesti}).  The number of
observed successes is the number of 1s in {it:varname} (in {cmd:bitest}) or
{it:#succ} (in {cmd:bitesti}).  {it:varname} must contain only 0s, 1s, and
missing.

{pstd}
{cmd:bitesti} is the immediate form of {cmd:bitest}; see {help immed} for a
general introduction to immediate commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R bitestQuickstart:Quick start}

        {mansection R bitestRemarksandexamples:Remarks and examples}

        {mansection R bitestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{dlgtab:Advanced}

{phang}
{opt detail} shows the probability of the observed number of successes, k_obs;
the probability of the number of successes on the opposite tail of the
distribution that is used to compute the two-sided p-value, k_opp; and the
probability of the point next to k_opp.  This information can be safely
ignored.  See the 
{mansection R bitestRemarksandexamplestechnote:technical note} in
{bf:[R] bitest} for details.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse quick}{p_end}

{pstd}Test whether probability of success equals 0.3{p_end}
{phang2}{cmd:. bitest quick == 0.3}{p_end}
{phang2}{cmd:. bitest quick == 0.3, detail}{p_end}

{pstd}Test if probability of success = 0.5, given 3 successes in 10
trials{p_end}
{phang2}{cmd:. bitesti 10 3 .5}{p_end}

{pstd}Test if probability of success = 0.000001, given 36 successes in 2.5
million trials{p_end}
{phang2}{cmd:. bitesti 2500000 36 .000001}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bitest} and {cmd:bitesti} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number N of trials{p_end}
{synopt:{cmd:r(P_p)}}assumed probability p of success{p_end}
{synopt:{cmd:r(k)}}observed number k of successes{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(k_opp)}}opposite extreme k{p_end}
{synopt:{cmd:r(P_k)}}probability of observed k ({cmd:detail} only){p_end}
{synopt:{cmd:r(P_oppk)}}probability of opposite extreme k ({cmd:detail}
	only){p_end}
{synopt:{cmd:r(k_nopp)}}k next to opposite extreme ({cmd:detail} only){p_end}
{synopt:{cmd:r(P_noppk)}}probability of k next to opposite extreme
	({cmd:detail} only){p_end}
{p2colreset}{...}
