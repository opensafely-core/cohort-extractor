{smcl}
{* *! version 1.0.1  20aug2014}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{viewerjumpto "Syntax" "margins_generate##syntax"}{...}
{viewerjumpto "Description" "margins_generate##description"}{...}
{viewerjumpto "Option" "margins_generate##option"}{...}
{viewerjumpto "Remarks" "margins_generate##remarks"}{...}
{viewerjumpto "Stored results" "margins_generate##results"}{...}
{title:Title}

{p2colset 4 28 33 2}{...}
{p2col:{hi:[R] margins, generate()}}{hline 2} Create margin-response variables in the
current dataset
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin} {weight}
[{cmd:,} 
{opt gen:erate(stub)}
{it:{help margins##response_options:response_options}}
{it:{help margins##options_table:options}}] 


{marker description}{...}
{title:Description}

{pstd}
{cmd:margins,} {opt generate()} creates a new variable containing the response
values used to produce each margin or marginal effect reported by
{cmd:margins}.


{marker option}{...}
{title:Option}

{phang}
{opt generate(stub)} creates a new variable containing the response
values used to produce each margin or marginal effect reported by
{cmd:margins}.
The variables are named consecutively, starting with {it:stub}{cmd:1}.
{cmd:margins} will skip over variable names that already exist.
{it:stub} may not exceed 16 characters in length.

{pmore}
{opt generate()} is not allowed with contrasts; see
{helpb margins_contrast:margins, contrast}.

{pmore}
{opt generate()} is not allowed with pairwise comparisons; see
{helpb margins_pwcompare:margins, pwcompare}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Suppose we are interested in the effects of a regressor on the predicted
probability from a logistic regression.  Here is the setup.

{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. logistic outcome i.sex i.group sex#group age}{p_end}

{pstd}
We can compute the average marginal effect of {cmd:age} on the predicted
probability for {cmd:outcome}.

{phang2}{cmd:. margins, dydx(age) generate(dage)}{p_end}

{pstd}
The new variable {cmd:dage1} contains the values that were summarized to
produce the average marginal effect reported by {cmd:margins}.
We can plot this variable against {cmd:age}.

{phang2}{cmd:. scatter dage1 age}{p_end}

{pstd}
This scatterplot is not very helpful; the markers do not distinguish
themselves according to the levels of {cmd:sex} or {cmd:group}.
Let's use the {cmd:by()} option to help separate the plots according to
{cmd:sex} and {cmd:group}.

{phang2}{cmd:. scatter dage1 age, by(sex group)}{p_end}

{pstd}
To overlay line plots, we will first {helpb sort} on {cmd:age} and then use
{cmd:if} conditions to identify the plots that correspond to the levels of
{cmd:sex} and {cmd:group}.  We also need to specify our own labels for the
legend.

{p  8}{cmd:. sort age}{p_end}
{p  8}{cmd:. line dage1 age if 0.sex&1.group ||}{p_end}
{p 10}{cmd:  line dage1 age if 0.sex&2.group ||}{p_end}
{p 10}{cmd:  line dage1 age if 0.sex&3.group ||}{p_end}
{p 10}{cmd:  line dage1 age if 1.sex&1.group ||}{p_end}
{p 10}{cmd:  line dage1 age if 1.sex&2.group ||}{p_end}
{p 10}{cmd:  line dage1 age if 1.sex&3.group ||}{p_end}
{p 12}{cmd:  , legend(label(1 female, group 1)}{p_end}
{p 21}{cmd:           label(2 female, group 2)}{p_end}
{p 21}{cmd:           label(3 female, group 3)}{p_end}
{p 21}{cmd:           label(4 male, group 1)}{p_end}
{p 21}{cmd:           label(5 male, group 2)}{p_end}
{p 21}{cmd:           label(6 male, group 3))}{p_end}

{pstd}
Suppose we were interested in the effects of {cmd:age} when setting all other
predictors at their means.
The other predictors are factor variables, so let's see how the effects of
{cmd:age} differ when we use the sample means (observed relative frequencies)
of {cmd:sex} and {cmd:group} compared with treating them as balanced.

{pstd}
First, let's compute the effects of {cmd:age} at the means.

{phang2}{cmd:. margins, dydx(age) at((means) sex group) generate(dage)}{p_end}

{pstd}
The default label is not very informative in this case, so we will use our own.

{phang2}
{cmd:. label variable dage2 "dydx(age) at means of factors sex and age"}
{p_end}

{pstd}
Second, we compute the effects of {cmd:age} while treating the factors as
balanced and give the generated variable our own label.

{phang2}{cmd:. margins, dydx(age) asbalanced generate(dage)}{p_end}
{phang2}
{cmd:. label variable dage2 "dydx(age) treating sex and age as balanced"}
{p_end}

{pstd}
Now we can plot these two response variables.

{phang2}{cmd:. line dage2 dage3 age, legend(cols(1))}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:margins,} {cmd:generate()} stores the following additional results in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(generate)}}list of new variables created because of the {cmd:generate()} option{p_end}
{p2colreset}{...}

{pstd}
{cmd:margins,} {cmd:generate()} with the {opt post} option also stores the
following additional results in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(generate)}}list of new variables created because of the {cmd:generate()} option{p_end}
{p2colreset}{...}

