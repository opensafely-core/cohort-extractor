{smcl}
{* *! version 1.1.7  15may2018}{...}
{findalias asfrsyntaxwt}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrwest}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] Survey" "help survey"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{viewerjumpto "Remarks" "weight##remarks"}{...}
{viewerjumpto "fweights" "weight##fweights"}{...}
{viewerjumpto "pweights" "weight##pweights"}{...}
{viewerjumpto "aweights" "weight##aweights"}{...}
{viewerjumpto "iweights" "weight##iweights"}{...}
{viewerjumpto "Examples" "weight##examples"}{...}
{title:Title}

{pstd}
{findalias frsyntaxwt} {hline 2} Weights


{marker remarks}{...}
{title:Remarks}

{pstd}
Most Stata commands can deal with weighted data.  Stata allows four kinds of
weights:

{p 4 8 2}1.  {cmd:fweight}s, or frequency weights, are weights that
indicate the number of duplicated observations.

{p 4 8 2}2.  {cmd:pweight}s, or sampling weights, are weights that denote
the inverse of the probability that the observation is included because of the
sampling design.

{p 4 8 2}3.  {cmd:aweight}s, or analytic weights, are weights that are
inversely proportional to the variance of an observation; that is, the variance
of the jth observation is assumed to be sigma^2/w_j, where w_j are the
weights.  Typically, the observations represent averages and the weights are
the number of elements that gave rise to the average.  For most Stata
commands, the recorded scale of {cmd:aweight}s is irrelevant; Stata internally
rescales them to sum to N, the number of observations in your data, when it
uses them.

{p 4 8 2}4.  {cmd:iweight}s, or importance weights, are weights that
indicate the "importance" of the observation in some vague sense.
{cmd:iweight}s have no formal statistical definition; any command that
supports {cmd:iweight}s will define exactly how they are treated.  
Usually, they are intended for use by programmers who want to produce a certain
computation.

{pstd}
The general syntax is

{p 12 12 2}
{it:command} {it:...} {cmd:[}{it:weightword}{cmd:=}{it:exp}{cmd:]} {it:...}

    For example:

{phang2}{cmd:. anova y x1 x2 x1*x2 [fweight=pop]}

{phang2}{cmd:. regress avgy avgx1 avgx2 [aweight=cellpop]}

{phang2}{cmd:. regress y x1 x2 x3 [pweight=1/prob]}

{phang2}{cmd:. scatter y x [aweight=y2], mfcolor(none)}

{pstd}
You type the square brackets.

{pstd}
Stata allows abbreviations: {cmd:fw} for {cmd:fweight}, {cmd:aw} for
{cmd:aweight}, and so on.  You could type

{phang2}{cmd:. anova y x1 x2 x1*x2 [fw=pop]}

{phang2}{cmd:. regress avgy avgx1 avgx2 [aw=cellpop]}

{phang2}{cmd:. regress y x1 x2 x3 [pw=1/prob]}

{phang2}{cmd:. scatter y x [aw=y2], mfcolor(none)}

{pstd}
Also, each command has its own idea of the "natural" kind of weight.
If you type

{phang2}{cmd:. regress avgy avgx1 avgx2 [w=cellpop]}

{pstd}
the command will tell you what kind of weight it is assuming and perform
the request as if you specified that kind of weight.

{pstd}
There are synonyms for some of the weight types.  {cmd:fweight} can also be
referred to as {cmd:frequency} (abbreviation {cmd:freq}).  {cmd:aweight} can
be referred to as {cmd:cellsize} (abbreviation {cmd:cell}):

{phang2}{cmd:. anova y x1 x2 x1*x2 [freq=pop]}

{phang2}{cmd:. regress avgy avgx1 avgx2 [cell=cellpop]}


{marker fweights}{...}
{title:{cmd:fweight}s}

{pstd}
Frequency {cmd:fweight}s indicate replicated data.  The weight tells the
command how many observations each observation really represents.
{cmd:fweight}s allow data to be stored more parsimoniously.  The weighting
variable contains positive integers.  The result of the command is the same as
if you duplicated each observation however many times and then ran the command
unweighted.


{marker pweights}{...}
{title:{cmd:pweight}s}

{pstd}
Sampling {cmd:pweight}s indicate the inverse of the probability that this
observation was sampled.  Commands that allow {cmd:pweight}s typically provide
a {cmd:vce(cluster} {it:clustvar}{cmd:)} option.  These can be combined to
produce estimates for unstratified cluster-sampled data.  If you must also
deal with issues of stratification, see {manhelp Survey SVY}.


{marker aweights}{...}
{title:{cmd:aweight}s}

{pstd}
Analytic {cmd:aweight}s are typically appropriate when you are dealing with
data containing averages.  For instance, you have average income and average
characteristics on a group of people.  The weighting variable contains the
number of persons over which the average was calculated (or a number
proportional to that amount).


{marker iweights}{...}
{title:{cmd:iweight}s}

{pstd}
This weight has no formal statistical definition and is a catch-all
category.  The weight somehow reflects the importance of the observation and
any command that supports such weights will define exactly how such weights
are treated.


{marker examples}{...}
{title:Examples}

{phang2}{cmd:. webuse hanley}{p_end}
{pstd}The next four commands are equivalent{p_end}
{phang2}{cmd:. roctab disease rating [fweight=pop]}{p_end}
{phang2}{cmd:. roctab disease rating [fw=pop]}{p_end}
{phang2}{cmd:. roctab disease rating [freq=pop]}{p_end}
{phang2}{cmd:. roctab disease rating [weight=pop]}

{phang2}{cmd:. webuse total}{p_end}
{phang2}{cmd:. total heartatk [pw=swgt], over(sex)}

{phang2}{cmd:. webuse byssin}{p_end}
{phang2}{cmd:. anova prob workplace smokes race workplace#smokes [aw=pop]}

{phang2}{cmd:. webuse nhanes2f}{p_end}
{phang2}{cmd:. svyset psuid [pw=finalwgt], strata(stratid)}{p_end}
{phang2}{cmd:. svy: ologit health female black age c.age#c.age}{p_end}
{phang2}{cmd:. ologit health female black age c.age#c.age [iw=finalwgt]}{p_end}
