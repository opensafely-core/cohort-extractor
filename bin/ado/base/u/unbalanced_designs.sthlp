{smcl}
{* *! version 1.0.6  21mar2019}{...}
{vieweralsosee "[PSS-4] Unbalanced designs" "mansection PSS-4 Unbalanceddesigns"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{viewerjumpto "Syntax" "unbalanced designs##syntax"}{...}
{viewerjumpto "Description" "unbalanced designs##description"}{...}
{viewerjumpto "Links to PDF documentation" "unbalanced_designs##linkspdf"}{...}
{viewerjumpto "Options" "unbalanced designs##options"}{...}
{viewerjumpto "Examples" "unbalanced designs##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[PSS-4] Unbalanced designs} {hline 2}}Specifications for
unbalanced designs{p_end}
{p2col:}({mansection PSS-4 Unbalanceddesigns:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Two samples, compute sample size for unbalanced designs

{p 6 8 2}
Compute total sample size

{p 8 16 2}
{it:cmdname} ...{cmd:,} {opth nrat:io(numlist)} 
[{opt nfrac:tional}] ...

{p 6 8 2}
Compute one group size given the other

{p 8 16 2}
{it:cmdname} ..., {cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} 
{cmd:compute(N1}|{cmd:N2)} 
[{opt nfrac:tional}] ...


{pstd}
Two samples, specify sample size for unbalanced designs

{p 6 8 2}
Specify total sample size and allocation ratio

{p 8 16 2}
{it:cmdname} ...{cmd:,} {opth n(numlist)} {opth nrat:io(numlist)} 
[{opt nfrac:tional}] ...

{p 6 8 2}
Specify one of the group sizes and allocation ratio

{p 8 16 2}
{it:cmdname} ...{cmd:,} {cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} {opth nrat:io(numlist)} 
[{opt nfrac:tional}] ...

{p 6 8 2}
Specify total sample size and one of the group sizes

{p 8 16 2}
{it:cmdname} ...{cmd:,} {opt n(numlist)} {cmd:n}{it:#}{cmd:(}{it:{help numlist}}{cmd:)} ...

{p 6 8 2}
Specify group sizes

{p 8 16 2}
{it:cmdname} ...{cmd:,} {opth n1(numlist)} {opth n2(numlist)} ...


{phang}
{it:cmdname} can be either {cmd:power} for power analysis or {cmd:ciwidth} for
precision analysis.


{marker twosampopts}{...}
{synoptset 20 tabbed}{...}
{synopthdr :twosampleopts}
{synoptline}
{p2coldent :* {opth n(numlist)}}total sample size{p_end}
{p2coldent :* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent :* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent :* {opth nrat:io(numlist)}}ratio of sample sizes, {cmd:N2/N1}; default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt: {cmd:compute(N1}|{cmd:N2)}}solve for {cmd:N1} given {cmd:N2} or for {cmd:N2} given {cmd:N1}{p_end}
{synopt: {cmdab:nfrac:tional}}allow fractional sample sizes{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist


{marker description}{...}
{title:Description}

{pstd}
This entry describes the specifications of unbalanced designs for two-sample
studies, including power and sample-size analysis for two-sample hypothesis
tests and precision and sample-size analysis of two-sample CIs.  See
{manhelp power PSS-2} for a general introduction to the {cmd:power} command
for power analysis and {manhelp ciwidth PSS-3} for a general introduction to
the {cmd:ciwidth} command for precision analysis.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-4 UnbalanceddesignsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker mainopts}{...}
{dlgtab:Main}

{* INCLUDE help pss_twosamplesdes *}
{phang}
{opth n(numlist)} specifies the total number of subjects in the study.

{pmore}
When used with {cmd:power}, this sample size is used for power or effect-size
determination.  If {cmd:n()} is specified, the power is computed.  If {cmd:n()}
and {cmd:power()} or {cmd:beta()} are specified, the minimum effect size that
is likely to be detected in a study is computed.

{pmore}
When used with {cmd:ciwidth}, this sample size is used to compute the
CI width and probability of CI width.

{phang}
{opth n1(numlist)} specifies the number of subjects in the control group.

{pmore}
When used with {cmd:power}, this sample size is used for power or effect-size
determination.

{pmore}
When used with {cmd:ciwidth}, this sample size is used to compute the CI width
and probability of CI width.

{phang}
{opth n2(numlist)} specifies the number of subjects in the experimental group.
It is used for the same computations as {opt n1(numlist)}, as mentioned above.

{phang}
{opth nratio(numlist)} specifies the sample-size ratio of the experimental
group relative to the control group, {cmd:N2/N1}.  The default is
{cmd:nratio(1)}, meaning equal allocation between the two groups.

{pmore}
When used with {cmd:power}, this ratio is used for power and effect-size
determination for two-sample tests.

{pmore}
When used with {cmd:ciwidth}, this ratio is used for computing CI width and
probability of CI width for two-sample CIs.

{phang}
{cmd:compute(N1}{c |}{cmd:N2)} requests that one of the group sample sizes be
computed given the other one, instead of the total sample size.  To compute the
control-group sample size, you must specify {cmd:compute(N1)} and the 
experimental-group sample size in {cmd:n2()}.  Alternatively, to compute the 
experimental-group sample size, you must specify {cmd:compute(N2)} and the 
control-group sample size in {cmd:n1()}.

{phang}
{opt nfractional} specifies that fractional sample sizes be allowed.  When
this option is specified, fractional sample sizes are used in the intermediate
computations and are also displayed in the output.


{marker examples}{...}
{title:Examples}

{pstd}
   Compute the required sample size for an unbalanced design 
    assuming a control-group mean of 0, an experimental-group mean of 1,
    a significance level of 5%, and desired power of 80%; assume
    our experimental group is twice the size of the control group{p_end}
{phang2}{cmd:. power twomeans 0 1, nratio(2)}

{pstd}
   Compute the power of the test in the previous example, assuming a
   sample size of 30{p_end}
{phang2}{cmd:. power twomeans 0 1, n(30) nratio(2)}
{p_end}
