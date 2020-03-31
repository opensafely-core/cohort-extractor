{smcl}
{* *! version 1.1.13  19sep2018}{...}
{viewerdialog "sts test" "dialog sts_test"}{...}
{vieweralsosee "[ST] sts test" "mansection ST ststest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] sts generate" "help sts_generate"}{...}
{vieweralsosee "[ST] sts graph" "help sts_graph"}{...}
{vieweralsosee "[ST] sts list" "help sts_list"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power exponential" "help power exponential"}{...}
{vieweralsosee "[PSS-2] power logrank" "help power logrank"}{...}
{viewerjumpto "Syntax" "sts_test##syntax"}{...}
{viewerjumpto "Menu" "sts_test##menu"}{...}
{viewerjumpto "Description" "sts_test##description"}{...}
{viewerjumpto "Links to PDF documentation" "sts_test##linkspdf"}{...}
{viewerjumpto "Options" "sts_test##options"}{...}
{viewerjumpto "Examples" "sts_test##examples"}{...}
{viewerjumpto "Video example" "sts_test##video"}{...}
{viewerjumpto "Stored results" "sts_test##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ST] sts test} {hline 2}}Test equality of survivor functions{p_end}
{p2col:}({mansection ST ststest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}
{cmd:sts} {opt t:est} {varlist} {ifin} [{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt l:ogrank}}perform log-rank test of equality; the default{p_end}
{synopt :{opt c:ox}}perform Cox test of equality{p_end}
{synopt :{opt w:ilcoxon}}perform Wilcoxon-Breslow-Gehan test of equality{p_end}
{synopt :{opt tw:are}}perform Tarone-Ware test of equality{p_end}
{synopt :{opt p:eto}}perform Peto-Peto-Prentice test of equality{p_end}
{synopt :{opt f:h(p q)}}perform generalized Fleming-Harrington test of equality{p_end}
{synopt :{opt tr:end}}test trend of the survivor function across three or more ordered groups{p_end}
{synopt :{opth st:rata(varlist)}}perform stratified test on {it:varlist}, displaying overall test results{p_end}
{synopt :{opt d:etail}}display individual test results; modifies {opt strata()}{p_end}

{syntab:Options}
{synopt :{opt mat(mname_1 mname_2)}}store vector {cmd:u} in {it:mname_1} and matrix {cmd:V} in {it:mname_2}{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt not:itle}}suppress title{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:sts test}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
Note that {opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified
using {cmd:stset}; see {manhelp stset ST}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
        {bf:Test equality of survivor functions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sts test} tests the equality of survivor functions across two or more
groups.  The log-rank, Cox, Wilcoxon-Breslow-Gehan, Tarone-Ware,
Peto-Peto-Prentice, and Fleming-Harrington tests are provided, in both
unstratified and stratified forms.

{pstd}
{cmd:sts test} also provides a test for trend.

{pstd}
{cmd:sts test} can be used with single- or multiple-record or single- or
multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST ststestQuickstart:Quick start}

        {mansection ST ststestRemarksandexamples:Remarks and examples}

        {mansection ST ststestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt logrank}, {opt cox}, {opt wilcoxon}, {opt tware}, {opt peto}, 
and {opt fh(p q)} specify the test of equality desired.  {opt logrank} is the
default, unless the data are {helpb pweight}ed, in which case {opt cox} is the
default and is the only possibility. 

{pmore}
{cmd:wilcoxon} specifies the Wilcoxon-Breslow-Gehan test; {cmd:tware}, the
Tarone-Ware test; {cmd:peto}, the Peto-Peto-Prentice test; and {cmd:fh()}, the
generalized Fleming-Harrington test. The Fleming-Harrington test requires two
arguments, {it:p} and {it:q}.  When {it:p} = 0 and {it:q} = 0, the
Fleming-Harrington test reduces to the log-rank test; when {it:p} = 1 and
{it:q} = 0, the test reduces to the Mann-Whitney-Wilcoxon test.

{phang}
{opt trend} specifies that a test for trend of the survivor function across
three or more ordered groups be performed.

{phang}
{opth strata(varlist)} requests that a stratified test be performed.

{phang}
{opt detail} modifies {opt strata()}; it requests that, in addition to
the overall stratified test, the tests for the individual strata
be reported.  {opt detail} is not allowed with {opt cox}.

{dlgtab:Options}

{phang}
{opt mat(matname_1 matname_2)} requests that the vector {cmd:u} be stored in
{opt mname_1} and that matrix {cmd:V} be stored in {it:mname_2}.  The other
tests are rank tests of the form u'V^(-1)u.  This option may not be used with
{opt cox}.

{phang}
{opt noshow} prevents {cmd:sts test} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned
at the top of the output of every st command; see {manhelp stset ST}.

{phang}
{opt notitle} requests that the title printed above the test be suppressed.


{marker examples}{...}
{title:Examples of log-rank test}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stan3}

{pstd}Log-rank test{p_end}
{phang2}{cmd:. sts test posttran}

{pstd}Create variables reflecting different periods of acceptance{p_end}
{phang2}{cmd:. generate group = 1 if year <= 69}{p_end}
{phang2}{cmd:. replace group = 2 if year >= 70 & year <= 72}{p_end}
{phang2}{cmd:. replace group = 3 if year >= 73}

{pstd}Stratified log-rank test{p_end}
{phang2}{cmd:. sts test posttran, strata(group)}

{pstd}Stratified log-rank test, showing within-stratum tests{p_end}
{phang2}{cmd:. sts test posttran, strata(group) detail}


{title:Examples of Wilcoxon (Breslow-Gehan) test}

{pstd}Wilcoxon test{p_end}
{phang2}{cmd:. sts test posttran, wilcoxon}

{pstd}Stratified Wilcoxon test{p_end}
{phang2}{cmd:. sts test posttran, wilcoxon strata(group)}

{pstd}Stratified Wilcoxon test, showing within-stratum tests{p_end}
{phang2}{cmd:. sts test posttran, wilcoxon strata(group) detail}


{title:Examples of Tarone-Ware test}

{pstd}Tarone-Ware test{p_end}
{phang2}{cmd:. sts test posttran, tware}

{pstd}Stratified Tarone-Ware test{p_end}
{phang2}{cmd:. sts test posttran, tware strata(group)}

{pstd}Stratified Tarone-Ware test, showing within-stratum tests{p_end}
{phang2}{cmd:. sts test posttran, tware strata(group) detail}


{title:Examples of Peto-Peto-Prentice test}

{pstd}Peto-Peto-Prentice test{p_end}
{phang2}{cmd:. sts test posttran, peto}

{pstd}Stratified Peto-Peto-Prentice test{p_end}
{phang2}{cmd:. sts test posttran, peto strata(group)}

{pstd}Stratified Peto-Peto-Prentice test, showing within-stratum tests{p_end}
{phang2}{cmd:. sts test posttran, peto strata(group) detail}


{title:Examples of generalized Fleming-Harrington tests}

{pstd}Generalized Fleming-Harrington test with weight 1 at all failure
times{p_end}
{phang2}{cmd:. sts test posttran, fh(0 0)}

{pstd}Generalized Fleming-Harrington test with more weight given to later
failures{p_end}
{phang2}{cmd:. sts test posttran, fh(0 3)}

{pstd}Generalized Fleming-Harrington test with more weight given to earlier 
failures{p_end}
{phang2}{cmd:. sts test posttran, fh(2 0)}

{pstd}Stratified generalized Fleming-Harrington test with more weight given to
later failures{p_end}
{phang2}{cmd:. sts test posttran, fh(0 3) strata(group)}

{pstd}Same as above, but showing within-stratum tests{p_end}
{phang2}{cmd:. sts test posttran, fh(0 3) strata(group) detail}


{title:Examples of trend test}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse marubini, clear}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/9}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, fail(event) noshow}

{pstd}Log-rank test using exposure variable {cmd:group}{p_end}
{phang2}{cmd:. sts test group}

{pstd}Log-rank test using exposure variable {cmd:dose}{p_end}
{phang2}{cmd:. sts test dose}

{pstd}Trend test using same weights as log-rank test, and using exposure
variable {cmd:group}{p_end}
{phang2}{cmd:. sts test group, trend}

{pstd}Trend test using same weights as log-rank test, and using exposure
variable {cmd:dose}{p_end}
{phang2}{cmd:. sts test dose, trend}

{pstd}Trend using same weights as Peto-Peto-Prentice test, and using exposure
variable {cmd:dose}{p_end}
{phang2}{cmd:. sts test dose, peto trend}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=W1uympJV7Ko&list=UUVk4G4nEtBS4tLOyHqustDA":How to test the equality of survivor functions using nonparametric tests}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sts test} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(df_tr)}}degrees of freedom, trend test{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(chi2_tr)}}chi-squared, trend test{p_end}
{p2colreset}{...}
