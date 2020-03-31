{smcl}
{* *! version 1.2.2  17feb2020}{...}
{vieweralsosee "[R] BIC note" "mansection R BICnote"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat ic" "help estat ic"}{...}
{vieweralsosee "[R] estimates stats" "help estimates_stats"}{...}
{viewerjumpto "Description" "bic note##description"}{...}
{viewerjumpto "Links to PDF documentation" "bic_note##linkspdf"}{...}
{viewerjumpto "Remarks" "bic note##remarks"}{...}
{viewerjumpto "References" "bic note##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] BIC note} {hline 2}}Calculating and interpreting BIC{p_end}
{p2col:}({mansection R BICnote:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry discusses a statistical issue that arises when using 
the Bayesian information criterion (BIC) to compare models.

{pstd}
Stata calculates BIC using {it:N} = {cmd:e(N)}, unless {cmd:e(N_ic)} has
been set; in that instance, it uses {it:N} = {cmd:e(N_ic)}.  For example,
choice-model {helpb cm} commands set {cmd:e(N_ic)} to the number of cases
because these commands use a data arrangement in which multiple Stata
observations represent a single statistical observation, which is called a
case.

{pstd}
Sometimes, it would be better if a different {it:N} than {cmd:e(N)} were used.
Commands that calculate BIC have an {cmd:n()} option, allowing you to specify
the {it:N} to be used.

{pstd}
In summary, 

{p 8 12 2}
1.  If you are comparing results estimated by the same estimation command,
    using the default BIC calculation is probably fine.  There is an
    issue, but most researchers would ignore it.

{p 8 12 2}
2.  If you are comparing results estimated by different estimation commands,
    you need to be on your guard.

{p 12 16 2}
    a.  If the different estimation commands share the same definitions of
        observations, independence, and the like, you are back in case 1.

{p 12 16 2}
     b.  If they differ in these regards, you need to think about the value 
         of {it:N} that should be used.
         For example, {helpb logit} and {helpb xtlogit} differ in that 
         the former assumes independent observations and the latter, 
         independent panels.

{p 12 16 2}
     c.  If estimation commands differ in the events being used over which 
         the likelihood function is calculated, the information criteria
         may not be comparable at all.  We say information criteria 
         because this would apply equally to the Akaike information criterion
	 (AIC), as well as to the BIC.  
         For instance, {helpb streg} and {helpb stcox} produce such 
         incomparable results. The events used by {cmd:streg} are the actual 
         survival times, whereas the events used by {cmd:stcox} are 
         failures within risk pools, conditional on 
         the times at which failures occurred.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R BICnoteRemarksandexamples:Remarks and examples}

        {mansection R BICnoteMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help bic_note##background:Background}
	{help bic_note##problem:The problem of determining N}
	    {help bic_note##ex1:Example 1}
	    {help bic_note##ex2:Example 2}
	{help bic_note##problem2:The problem of conformable likelihoods}
	{help bic_note##aic:The first problem does not arise with AIC; the second problem does}
	{help bic_note##diy:Calculating BIC correctly}


{marker background}{...}
{title:Background}

{pstd}
The AIC and the BIC are two popular measures for comparing maximum likelihood
models.  AIC and BIC are defined as 

		AIC = -2*ln(likelihood) + 2*{it:k}

		BIC = -2*ln(likelihood) + ln({it:N})*{it:k}

{p 8 8 2}
where

		  {it:k} = number of parameters estimated

		  {it:N} = number of observations

{pstd}
We are going to discuss AIC along with BIC because AIC has some of the problems 
that BIC has, but not all.

{pstd}
AIC and BIC can be viewed as measures that combine fit and
complexity.  Fit is measured negatively by -2*ln(likelihood); the larger the
value, the worse the fit.  Complexity is measured positively, either by
2*{it:k} (AIC) or ln({it:N})*{it:k} (BIC).  

{pstd}
Given two models fit on the same data, the model with the smaller 
value of the information criterion is considered to be better.

{pstd}
There is substantial literature on these measures: see
{help bic note##A1974:Akaike (1974)};
{help bic note##R1995:Raftery (1995)};
{help bic note##SIK1986:Sakamoto, Ishiguro, and Kitagawa (1986)}; and
{help bic note##S1978:Schwarz (1978)}.

{pstd} 
When Stata calculates the above measures, it uses the rank of {cmd:e(V)} for
{it:k} and it uses {cmd:e(N)} for {it:N}.  {cmd:e(V)} and {cmd:e(N)} are
Stata notation for results stored by the estimation command.  {cmd:e(V)} is
the variance-covariance matrix of the estimated parameters, and {cmd:e(N)} is
the number of observations in the dataset used in calculating the result.


{marker problem}{...}
{title:The problem of determining N} 

{pstd}
The difference between AIC and BIC is that AIC uses the constant 2 
to weight {it:k}, whereas BIC uses ln({it:N}).  

{pstd}
Determining that the value of {it:N} should be used is problematic.  Despite
appearances, the definition "{it:N} is the number of observations" is not easy
to make operational.  {it:N} does not appear in the likelihood function
itself, {it:N} is not the output of a standard statistical formula, and what
is an observation is often subjective.


{marker ex1}{...}
{title:Example 1}

{pstd}
Often, what is meant by {it:N} is obvious.  Consider a simple
logit model.  What is meant by {it:N} is the number of observations that 
are statistically independent and that corresponds to {it:M}, the number of 
observations in the dataset used in the calculation. 
We will write {it:N}={it:M}.

{pstd}
But now assume that the same dataset has a grouping variable and the data are
thought to be clustered within group.  To keep the problem simple, let's
pretend that there are {it:G} groups and {it:m} observations within group, so
that {it:M} = {it:G}*{it:m}.  Because you are worried about intragroup
correlation, you fit your model with {cmd:xtlogit}, grouping on the grouping
variable.  Now, you wish to calculate BIC.  What is the {it:N} that should be
used?  {it:N}={it:M} or {it:N}={it:G}?

{pstd}
That is a deep question.  If the observations really are 
independent, then you should use {it:N}={it:M}.  If the observations within
group are not just correlated but are duplicates of one another, and
they had to be so, then you should use {it:N}={it:G}.
Between
those two extremes, you should probably use a number between {it:M} and
{it:G}, but determining what that number should be from measured correlations
is difficult.  Using {it:N}={it:M} is conservative in that, if
anything, it overweights complexity.  Conservativeness, however, is 
subjective, too:  using {it:N}={it:G} could be considered more
conservative in that fewer constraints are being placed on the data.

{pstd}
When the estimated correlation is high, our  
reaction would be that using {it:N}={it:G} is probably more reasonable. 
Our first reaction, however, would be that using BIC to compare models 
is probably a misuse of the measure.

{pstd}
Stata uses {it:N}={it:M}.  An informal survey of
web-based literature suggests that {it:N}={it:M} is the popular choice.

{pstd}
There is another reason, not so good, to choose {it:N}={it:M}.  It makes 
across-model comparisons more likely to be valid when performed without 
thinking about the issue.
Say that you wish to compare the {helpb logit} and {helpb xtlogit} results.
Thus, you need to calculate 

		BIC_p = -2*ln(likelihood_p) + ln({it:N_p})*{it:k}

		BIC_x = -2*ln(likelihood_x) + ln({it:N_x})*{it:k}

{pstd} 
Whatever 
{it:N} you use, you must use the same {it:N} in both formulas.  
Stata's choice of {it:N}={it:M} at least meets that test.


{marker ex2}{...}
{title:Example 2}

{pstd}
In the above example, using {it:N}={it:M} is reasonable.  Now, let's look at
when using {it:N}={it:M} is wrong even if popular.

{pstd}
Consider a model fit by {helpb stcox}.  Using {it:N}={it:M} is certainly
wrong if for no other reason than {it:M} is not even a well-defined number.
The same data can be represented by different datasets with different
numbers of observations.  For example, in one dataset, there might be one
observation per subject.  In another, the same subjects could have two records
each, the first recording the first half of the time at risk and the second
recording the remaining part.  All statistics calculated by Stata on either
dataset would be the same, but {it:M} would be different.

{pstd}
Deciding on the right definition, however, is difficult.  Viewed one way, 
{it:N} in the Cox regression case should be the number of risk pools, {it:R},
because the Cox regression calculation is made on the basis of the independent
risk pools.  Viewed another way, {it:N} should be the number of subjects,
{it:N_subj}, because, even though the likelihood function is based on risk
pools, the parameters estimated are at the subject
level.

{pstd}
You can decide which argument you prefer.

{pstd}
For parametric survival models, in single-record data, {it:N}={it:M} is 
unambiguously correct.  For multirecord data, there is an argument 
for {it:N}={it:M} and for {it:N}={it:N_subj}.


{marker problem2}{...}
{title:The problem of conformable likelihoods}

{pstd}
The problem of conformable likelihoods does not concern {it:N}.  Researchers
sometimes use information criteria such as BIC and AIC to make comparisons
across models.  For that to be valid, the likelihoods must be conformable;
that is, the likelihoods must all measure the same thing.

{pstd}
It is common to think of the likelihood function as the Pr(data|parameters), 
but in fact, the likelihood is

		Pr(particular events in the data | parameters)

{pstd}
You must ensure that the events are the same.

{pstd}
For instance, they are not the same in the semiparametric Cox regression and
the various parametric survival models.  In Cox regression, the events 
are, at each failure time, that the subjects observed to fail in fact failed,
given that failures occurred at those times.  In the parametric models, the
events are that each subject failed exactly when the subject was observed to
fail.

{pstd}
The formula for AIC and BIC is

		measure = -2*ln(likelihood) + complexity

{pstd}
When you are comparing models, if the likelihoods are measuring different events, 
even if the models obtain estimates of the same parameters, 
differences in the information measures are irrelevant.


{marker aic}{...}
{title:The first problem does not arise with AIC; the second problem does}

{pstd}
Regardless of model, the problem of defining {it:N} never arises with AIC
because {it:N} is not used in the AIC calculation.  AIC uses a constant 2 to
weight complexity as measured by {it:k}, rather than ln({it:N}).

{pstd}
For both AIC and BIC, however, the likelihood functions must be conformable;
that is, they must be measuring the same event.


{marker diy}{...}
{title:Calculating BIC correctly}

{pstd}
When using BIC to compare results, and especially when using BIC to 
compare results from different models, you should think carefully 
about how {it:N} should be defined.  Then specify that number by using 
the {cmd:n()} option:

	. {cmd:estimates stats full sub, n(74)}

	{hline 6}{c TT}{hline 57}
  	Model {c |}  Obs    ll(null)   ll(model)   df        AIC         BIC
	{hline 6}{c +}{hline 57}
      	 full {c |}  102   -45.03321   -20.59083    4   49.18167    58.39793
      	  sub {c |}  102   -45.03321   -27.17516    3   60.35031    67.26251
	{hline 6}{c BT}{hline 57}
	Note:  N = 74 used in calculating BIC

{pstd} 
Both {cmd:estimates} {cmd:stats} and {cmd:estat} {cmd:ic} allow the 
{cmd:n()} option; see 
{bf:{help estimates_stats:[R] estimates stats}}
and 
{bf:{help estat ic:[R] estat ic}}.


{marker references}{...}
{title:References}

{marker A1974}{...}
{phang}
Akaike, H. 1974. A new look at the statistical model identification.
{it:IEEE transactions on Automatic Control} 19: 716-723.

{marker R1995}{...}
{phang}
Raftery, A. 1995. Bayesian model selection in social research. In Vol. 25
of {it:Sociological Methodology}, ed. P. V. Marsden, 111-163.
Oxford: Blackwell.

{marker SIK1986}{...}
{phang}
Sakamoto, Y., M. Ishiguro, and G. Kitagawa. 1986.
{it:Akaike Information Criterion Statistics}. Dordrecht, The Netherlands:
Reidel.

{marker S1978}{...}
{phang}
Schwarz, G. 1978. Estimating the dimension of a model.
{it:Annals of Statistics} 6: 461-464.
{p_end}
