{smcl}
{* *! version 1.2.7  26mar2018}{...}
{vieweralsosee "[ST] Glossary" "mansection ST Glossary"}{...}
{viewerjumpto "Description" "st_glossary##description"}{...}
{viewerjumpto "Glossary" "st_glossary##glossary"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ST] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection ST Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{marker accelerated_ft_model}{...}
{phang}
{bf:accelerated failure-time model}.
A model in which everyone has, in a sense, the same survivor function,
S(tau), and an individual's tau_j is a function of his or her
characteristics and of time, such as 
{bind:tau_j = t*exp(b_0 + b_1*x_{1j} + b_2*x_{2j})}.

{phang}
{bf:AFT, accelerated failure time}.
     See {it:{help st_glossary##accelerated_ft_model:accelerated failure-time model}}.

{phang}
{bf:analysis time}.
     Analysis time is like time, except that 0 has a special meaning:  
     {it:t}=0 is the time of onset of risk, the time when failure first became
     possible.

{pmore}
     Analysis time is usually not what is recorded in a dataset.  
     A dataset of patients might record calendar time.
     Calendar time must then be mapped to analysis time.

{pmore}
     The letter {it:t} is reserved for time in analysis-time
     units.  The term time is used for time measured in other units.

{pmore}
     The origin is the time corresponding to {it:t}=0, which 
     can vary subject to subject.  Thus
     {it:t} = time - origin.

{phang}
{bf:at risk}.
     A subject is at risk from the instant the first failure event becomes
     possible and usually stays that way until failure, but 
     a subject can have periods of being at risk and not at risk.

{phang}
{bf:attributable fraction}. An attributable fraction is the reduction in the
risk of a disease or other condition of interest when a particular risk factor
is removed.

{phang}
{bf:baseline}.
     In survival analysis, baseline is the state at which the covariates,
     usually denoted by the row vector {bf:x}, are zero.  For example, if the
     only measured covariate is systolic blood pressure, the baseline survivor
     function would be the survivor function for someone with zero systolic
     blood pressure.  This may seem ridiculous, but covariates are usually
     centered so that the mathematical definition of baseline (covariate is
     zero) translates into something meaningful (mean systolic blood
     pressure).

{phang}
{bf:boundary kernel}.
    A boundary kernel is a special kernel used to smooth hazard functions in
    the boundaries of the data range.  Boundary kernels are applied when the
    {cmd:epan2}, {cmd:biweight}, or {cmd:rectangle} {cmd:kernel()} is
    specified with {cmd:stcurve, hazard} or {cmd:sts graph, hazard}.

{marker case1intcens}{...}
{phang}
{bf:case I interval-censored data} or {bf:current status data}.
     Case I interval-censored data occur when the only survival information
     available is whether the event of interest occurred before or after the
     observed time, leading to data in which an observation is either
     left-censored or right-censored. Case I interval-censored data can be
     viewed as a special case of case II interval-censored data without
     uncensored and interval-censored on ({it:t_l},{it:t_u}] observations.

{marker case2intcens}{...}
{phang}
{bf:case II interval-censored data} or {bf:general interval-censored data}.
     Case II interval censored data occur when, for some observations, we do
     not know the exact failure time {it:t}, but only know that the failure
     happened within a random time interval ({it:t_l}, {it:t_u}], or before the
     left endpoint of the time interval {it:t_l}, or after the right endpoint of
     the time interval {it:t_u}.

{phang}
{bf:cause-specific hazard}. 
    In a competing-risks analysis, the cause-specific hazard is the hazard 
    function that generates the events of a given type.  For example, if heart
    attack and stroke are competing events, then the cause-specific hazard for
    heart attacks describes the biological mechanism behind heart attacks
    independently of that for strokes.  Cause-specific hazards can be modeled
    using Cox regression, treating the other events as censored.

{phang}
{marker censored}{...}
{bf:censored}, {bf:uncensored}, {bf:left-censored}, {bf:right-censored}, and
{bf:interval-censored}.
     An observation is censored when the exact time of failure is not known,
     and it is uncensored when the exact time of failure is known.

{pmore}
     An observation is left-censored when the exact time of failure is not
     known; it is merely known that the failure occurred before {it:t_l}.
     Suppose that the event of interest is becoming employed.  If a subject is
     already employed when first interviewed, his outcome is left-censored.

{pmore}
    An observation is right-censored when the time of failure is not know; it
    is merely known that the failure occurred after {it:t_r}.  If a patient
    survives until the end of a study, the patient's time of death is
    right-censored.

{pmore}
    An observation is interval-censored when the time of failure is not known;
    it is merely known that the failure occurred after {it:t_l} but before
    {it:t_r}.  Suppose that the event of interest is an onset of breast
    cancer.  Patients are assessed periodically during their yearly checkups.
    The actual time of the onset of the disease, if present, is rarely known.
    Often, it is only known that the disease happened between the last and the
    current checkups.  The time to the onset of breast cancer is then
    interval-censored.

{pmore}
    In common usage, censored without a modifier means right-censored.

{pmore}
    Also see {it:{help st_glossary##truncation:truncation, left-truncation, and right-truncation}}.

{phang}
{bf:CIF}.  See {it:{help st_glossary##CIF:cumulative incidence function}}.

{phang}
{bf:competing risks}.
    Competing risks models are survival-data models in which the failures are 
    generated by more than one underlying process.  For example, death may
    be caused by either heart attack or stroke.  There are various methods
    for dealing with competing risks.  One direct way is to duplicate 
    failures for one competing risk as censored observations for the other
    risk and stratify on the risk type.  Another is to directly model the
    cumulative incidence of the event of interest in the presence of competing
    risks.  The former method uses {helpb stcox} and the latter,
    {helpb stcrreg}.

{phang}
{bf:confounding}.
    In the analysis of contingency tables, factor or interaction effects
    are said to be confounded when the effect of one factor is combined 
    with that of another.  For example, the effect of alcohol consumption 
    on esophageal cancer may be confounded with the effects of age, 
    smoking, or both.  In the presence of confounding, it is often useful to
    stratify on the confounded factors that are not of primary interest, in the
    above example, age and smoking.

{phang}
{bf:count-time data}.  See {it:{help st_glossary##ct_data:ct data}}.

{phang}
{bf:covariates}.  
Covariates are
     the explanatory variables that appear in a model.  For instance, if
     survival time were to be explained by age, sex, and treatment, then those
     variables would be the covariates.  
     Also see {it:{help st_glossary##timevarying:time-varying covariates}}.

{phang}
{bf:crude estimate}.  A crude estimate has not been adjusted for the effects of
other variables.  Disregarding a stratification variable, for example, yields a
crude estimate.

{phang}
{marker ct_data}{...}
{bf:ct data}.
    ct stands for count time.  ct data are an aggregate organized like a life
    table.  Each observation records a time, the number known to fail at that
    time, the number censored, and the number of new entries.
    See {helpb ctset:[ST] ctset}.

{phang}
{bf:cumulative hazard}.
See {it:{help st_glossary##hazard:hazard, cumulative hazard, and hazard ratio}}.

{phang}
{bf:cumulative incidence estimator}. In a competing-risks analysis, the
cumulative incidence estimator estimates the cumulative incidence function
(CIF).  Assume for now that you have one event of interest (type 1)
and one competing event (type 2).  The cumulative incidence estimator for type
1 failures is then obtained by

             ^                         ^        ^
            CIF_1(t) = sum_{j:t_j {ul:<} t} h_1(t_j) S(t_{j-1})

{pmore}
with

            ^                              ^          ^
            S(t) = prod_{j:t_j {ul:<} t} {c -(}1 - h_1(t_j) - h_2(t_j){c )-}

{pmore}
The t_j index the times at which events (of any type) occur, and 
h_1[hat](t_j) and h_2[hat](t_j) are the cause-specific hazard contributions for
type 1 and type 2, respectively.  S[hat](t) estimates the probability that
you are event free at time t.

{pmore}
The above generalizes to multiple competing events in the obvious way.

{phang}
{marker CIF}{...}
{bf:cumulative incidence function}.
     In a competing-risks analysis, the cumulative incidence function, or
     CIF, is the probability that you will observe the event of primary
     interest before a given time.  Formally,

        CIF(t) = P(T {ul:<} t and event type of interest) 

{pmore}
     for time-to-failure, T.

{phang}
{bf:cumulative subhazard}.
See {it:{help st_glossary##subhazard:subhazard, cumulative subhazard, and subhazard ratio}}.

{phang}
{bf:current status data}.
See {it:{help st_glossary##case1intcens:case I interval-censored data}}.

{phang}
{marker DFBETA}{...}
{bf:DFBETA}.
    A DFBETA measures the change in the regressor's coefficient
    because of deletion of that subject.  Also see
    {it:{help st_glossary##partial_DFBETA:partial DFBETA}}.

{phang}
{bf:effect size}.
    The effect size is the size of the clinically significant difference
    between the treatments being compared, often expressed as the hazard ratio
    (or the log of the hazard ratio) in survival analysis.

{phang}
{bf:event}.  
An event is
    something that happens at an instant in time, such as being exposed 
    to an environmental hazard, being diagnosed as myopic, or becoming 
    employed.

{pmore}
    The failure event is of special interest in survival analysis, but 
    there are other equally important events, such as the exposure event,
    from which analysis time is defined.

{pmore}
    In st data, events occur at the end of the recorded 
    time span.

{phang}
{bf:event of interest}.  In a competing-risks analysis, the event of
interest is the event that is the focus of the analysis, that for which
the cumulative incidence in the presence of competing risks is estimated.

{phang}
{bf:failure event}.
    Survival analysis is really time-to-failure analysis, and the 
    failure event is the event under analysis.  The failure event
    can be death, heart attack, myopia, or finding employment.  Many
    authors -- including Stata -- write as if the failure event can
    occur only once per subject, but when we do, we are being sloppy.
    Survival analysis encompasses repeated failures, and all of Stata's
    survival analysis features can be used with repeated-failure data.

{phang}
{bf:frailty}.
    In survival analysis, it is often assumed that subjects are
    alike -- homogeneous -- except for their observed differences.
    The probability that subject {it:j} fails at time {it:t} may be a function
    of {it:j}'s covariates and random chance.  Subjects {it:j} and {it:k}, if
    they have equal covariate values, are equally likely to fail.

{pmore}
    Frailty relaxes that assumption.  The probability that subject {it:j} fails
    at time {it:t} becomes a function of {it:j}'s covariates and {it:j}'s
    unobserved frailty value, {it:M}_{it:j}.  Frailty {it:M} is assumed to
    be a random variable.  Parametric survival models can be fit even 
    in the presence of such heterogeneity.

{pmore}
    Shared frailty refers to the case in which groups of subjects share the 
    same frailty value.  For instance, subjects 1 and 2 may share frailty
    value {it:M} because they are genetically related.  Both parametric and
    semiparametric models can be fit under the shared-frailty
    assumption.

{phang}
{marker future_history}{...}
{bf:future history}.
    Future history is information recorded after a subject 
is no longer at risk.  
    The word history is often dropped, and the term becomes simply
    future.  Perhaps the failure event is cardiac infarction, and you
    want to know whether the subject died soon in the future, in which
    case you might exclude the subject from analysis.

{pmore}
    Also see {it:{help st_glossary##past_history:past history}}.

{phang}
{bf:gaps}.
    Gaps refers to gaps in observation between entry time and exit time; 
    see {it:{help st_glossary##under_observation:under observation}}.  

{phang}
{bf:general interval-censored data}.
See {it:{help st_glossary##case2intcens:case II interval-censored data}}.

{marker hazard}{...}
{phang}
{bf:hazard}, {bf:cumulative hazard}, and {bf:hazard ratio}.
    The hazard or hazard rate at time {it:t}, {it:h(t)}, is the
    instantaneous rate of failure at time {it:t} conditional on survival until
    time {it:t}.  Hazard rates can exceed 1.  Say that the hazard rate were 3.
    If an individual faced a constant hazard of 3 over a unit interval and if
    the failure event could be repeated, the individual would be expected to
    experience three failures during the time span.

{pmore}
    The cumulative hazard, {it:H(t)}, is the integral of the hazard
    function {it:h(t)}, from 0 (the onset of risk) to {it:t}.
    It is the total number of failures that would be expected to occur 
    up until time {it:t}, 
    if the failure event could be repeated.  The relationship between 
    the cumulative hazard function, {it:H(t)}, and the survivor 
    function, {it:S(t)}, is 

		{it:S(t)} = exp{c -(}-H(t){c )-}

		{it:H(t)} = -ln{c -(}S(t){c )-}

{pmore}
    The hazard ratio is the ratio of the hazard function evaluated 
    at two different values of the covariates:  
    {it:h}({it:t}|{bf:x})/{it:h}({it:t}|{bf:x}_0).
    The hazard ratio is often called the relative hazard, especially 
    when {it:h}({it:t}|{bf:x}_0) is the baseline hazard function.

{phang}
{bf:hazard contributions}.  Hazard contributions are the increments of the
estimated cumulative hazard function obtained through either a nonparametric
or semiparametric analysis.  For these analysis types, the estimated
cumulative hazard is a step function that increases every time a failure
occurs.  The hazard contribution for that time is the magnitude of that
increase.

{pmore}
Because the time between failures usually varies from failure to failure,
hazard contributions do not directly estimate the hazard.  However, one
can use the hazard contributions to formulate an estimate of the hazard
function based on the method of smoothing.

{phang}
{bf:ID variable}.
    An ID variable identifies groups; equal values of an ID
    variable indicate that the observations are for the same group.  For
    instance, a stratification ID variable would indicate the strata to which
    each observation belongs.

{pmore}
    When an ID variable is referred to without
    modification, it means subjects, and
    usually this occurs in multiple-record st data.  In multiple-record data,
    each physical observation in the dataset represents a time span, and the
    ID variable ties the separate observations together:

	{it:idvar}      {it:t}0        {it:t}
	{hline 23}
	    1       0        5
	    1       5        7

{pmore}
    ID variables are usually numbered 1, 2, ..., but that is not
    required.  An ID variable might be numbered 1, 3, 7, 22, ..., or
    -5, -4, ..., or even 1, 1.1, 1.2, ....

{phang}
{bf:incidence} and {bf:incidence rate}.
Incidence is the number of new failures (for example, number of new cases of a
disease) that occur during a specified period in a population at risk (for
example, of the disease).

{pmore}
    Incidence rate is incidence divided by the sum of the length of time 
    each individual was exposed to the risk.

{pmore}
    Do not confuse incidence with prevalence.  Prevalence is the fraction 
    of a population that has the disease.  Incidence refers to the rate 
    at which people contract a disease, whereas prevalence is the 
    total number actually sick at a given time.  

{phang}
{bf:interval-censored data}.
See {help st_glossary##case1intcens:{it:case I interval-censored data or current status data}}
and
{help st_glossary##case2intcens:{it:case II interval-censored data of general interval-censored data}}.

{phang}
{bf:Kaplan-Meier product-limit estimate}.
The is an estimate of the survivor function, which is the product of
conditional survival to each time at which an event occurs.  The simple form of
the calculation, which requires tallying the number at risk and the number who
die and at each time, makes accounting for censoring easy.  The resulting
estimate is a step function with jumps at the event times.

{phang}
{bf:left-censored}.
   See {it:{help st_glossary##censored:censored, uncensored, left-censored, right-censored, and interval-censored}}.

{phang}
{bf:left-truncation}.
   See {it:{help st_glossary##truncation:truncation, left-truncation, and right-truncation}}.      

{phang}
{bf:life table}.
Also known as a mortality table or actuarial table, a life table is a table
that shows for each analysis time the fraction that survive to that time.  In
mortality tables, analysis time is often age.

{phang}
{marker likelihood}{...}
{bf:likelihood displacement value}.
    A likelihood displacement value is an influence measure of the effect of
    deleting a subject on the overall coefficient vector.  Also see
    {it:{help st_glossary##partial_likelihood:partial likelihood displacement value}}.

{phang}
{marker LMAX}{...}
{bf:LMAX value}.
    An LMAX value is an influence measure of the effect of deleting a
    subject on the overall coefficient vector and is based on an eigensystem
    analysis of efficient score residuals.  Also see
    {it:{help st_glossary##partial_LMAX:partial LMAX value}}.

{phang}
{bf:multiarm trial}.
    A multiarm trial is a trial comparing survivor functions of more than two
    groups.

{phang}
{bf:multiple-record st data}.
   See {it:{help st_glossary##st_data:st data}}.

{phang}
{bf:odds} and {bf:odds ratio}.
    The odds in favor of an event are {it:o} = {it:p}/(1-{it:p}), where {it:p}
    is the probability of the event.  Thus if {it:p}=0.2, the odds are 0.25, and
    if {it:p}=0.8, the odds are 4.

{pmore}
    The log of the odds is
    ln({it:o}) = logit({it:p}) = ln{c -(}{it:p}/(1-{it:p}){c )-}, and
    logistic-regression models, for instance, fit ln({it:o}) as a linear
    function of the covariates.

{pmore}
    The odds ratio is a ratio of two odds:  {it:o}_1/{it:o}_0.  
    The individual odds that appear in the ratio are usually for an 
    experimental group and a control group, or two different demographic 
    groups.

{phang}
{bf:offset variable} and {bf:exposure variable}.
  An offset variable is a
    variable that is to appear on the right-hand side of a model with
    coefficient 1:

            {it:y}_{it:j} = offset_{it:j} + {it:b}_0 + {it:b}_1{it:x}_{it:j} + ...

{pmore}
    In the above, {it:b}_0 and {it:b}_1 are to be estimated.  The
    offset is not constant.  Offset variables are often included to account
    for the amount of exposure.  Consider a model where the number of events
    observed over a period is the length of the period multiplied by the
    number of events expected in a unit of time:

            {it:n}_{it:j} = {it:T}_{it:j}  {it:e}({it:X}_{it:j})

{pmore}
    When we take logs, this becomes 

            log({it:n}_{it:j}) = log({it:T}_{it:j}) + log{c -(}{it:e}({it:X}_{it:j}){c )-}

{pmore}
    ln({it:T}_{it:j}) is an offset variable in this model.  

{pmore}
    When the log of a variable is an offset variable, the variable is said 
    to be an exposure variable.  In the above, {it:T}_{it:j} is an exposure
    variable.

{phang}
{marker partial_DFBETA}{...}
{bf:partial DFBETA}.  A partial DFBETA measures the change in the
regressor's coefficient because of deletion of that individual record.  In
single-record data, the partial DFBETA is equal to the DFBETA.
Also see {it:{help st_glossary##DFBETA:DFBETA}}.

{phang}
{marker partial_likelihood}{...}
{bf:partial likelihood displacement value}.  A partial likelihood displacement
value is an influence measure of the effect of deleting an individual
record on the coefficient vector.  For single-record data, the partial
likelihood displacement value is equal to the likelihood displacement
value.  Also see
    {it:{help st_glossary##likelihood:likelihood displacement value}}.

{phang}
{marker partial_LMAX}{...}
{bf:partial LMAX value}.  A partial LMAX value is an influence measure
of the effect of deleting an individual record on the overall coefficient
vector and is based on an eigensystem analysis of efficient score residuals.
In single-record data, the partial LMAX value is equal to the LMAX value.
Also see {it:{help st_glossary##LMAX:LMAX value}}.

{phang}
{marker past_history}{...}
{bf:past history}.
    Past history is 
    information recorded about a subject before the subject was both 
    at risk and under observation.  Consider a dataset that contains
    information on subjects from birth to death and an analysis in which
    subjects became at risk once diagnosed with a particular kind of cancer.
    The past history on the subject would then refer to records before the
    subjects were diagnosed.

{pmore}
    The word history is often dropped, and the term becomes simply 
    past.  For instance, we might want to know whether a subject smoked in
    the past.

{pmore}
    Also see {it:{help st_glossary##future_history:future history}}.

{phang}
{bf:penalized log-likelihood function}.
This is a log-likelihood function that contains an added term, usually referred
to as a roughness penalty, that reduces its value when the model overfits the
data.  In Cox models with frailty, such functions are used to prevent the
variance of the frailty from growing too large, which would allow the
individual frailty values to perfectly fit the data.

{phang}
{marker power}{...}
{bf:power}.
    The power of a test is the probability of correctly rejecting the null
    hypothesis when it is false.  It is often denoted as 1-beta in
    statistical literature, where beta is the type II error probability.
    Commonly used values for power are 80% and 90%.  Also see
    {it:{help st_glossary##type1:type I error}} and
    {it:{help st_glossary##type2:type II error}}.

{phang}
{bf:proportional hazards model}.
This is a model in which, between individuals, the ratio of the instantaneous
failure rates (the hazards) is constant over time.

{phang}
{bf:right-censored}.
   See {it:{help st_glossary##censored:censored, uncensored, left-censored, right-censored, and interval-censored}}.

{phang}
{bf:right-truncation}.
   See {it:{help st_glossary##truncation:truncation, left-truncation, and right-truncation}}.   

{phang}
{bf:risk factor}.
This is a variable associated with an increased or decreased risk of failure.

{phang}
{bf:risk pool}.
At a particular point in time, this is the subjects at risk of failure.

{phang}
{bf:semiparametric model}.
This is a model that is not fully parameterized.  The Cox proportional hazards
model is such a model:

{pmore2}
h(t) = h_o(t)*exp(b_1*x_1 + b_2*x_2 + ...)

{pmore}
In the Cox model, h_o(t) is left unparameterized and not even estimated.
Meanwhile, the relative effects of covariates are parameterized as
exp(b_1*x_1 + b_2*x_2 + ...).

{phang}
{bf:shape parameter}.
     A shape parameter governs the shape of a probability distribution.  One
     example is the parameter {it:p} of the Weibull model.

{phang}
{bf:single-record st data}.
   See {it:{help st_glossary##st_data:st data}}.

{phang}
{bf:singleton-group data}.
A singleton is a frailty group that contains only 1 observation.
A dataset containing only singletons is known as singleton-group data.

{phang}
{bf:SMR}.
See {it:{help st_glossary##SMR:standardized mortality (morbidity) ratio}}.

{phang}
{bf:snapshot data}.
   Snapshot data are those
     in which each record contains the values of a set
     of variables for a subject at an instant in time.  The name 
     arises because each observation is like a snapshot of the subject.
     
{pmore}
     In snapshot datasets, one usually has a group of observations 
     (snapshots) for each subject.  

{pmore}
     Snapshot data must be converted to st data before they can be analyzed.
     This requires making assumptions about what happened between 
     the snapshots.  See {helpb snapspan:[ST] snapspan}.

{phang}
{bf:spell data}. Spell data are survival data in which each record represents
a fixed period, consisting of a begin time, an end time, possibly a
censoring/failure indicator, and other measurements (covariates) taken during
that specific period.

{phang}
{marker st_data}{...}
{bf:st data}.
    st stands for survival time.
    In survival-time data, each observation represents a span of 
    survival, recorded in variables {it:t0} and {it:t}.  For instance, 
    if in an observation {it:t0} were 3 and {it:t} were 5, the
    span would be ({it:t0},{it:t}], meaning from just after {it:t0} up
    to and including {it:t}.

{pmore}
    Sometimes variable {it:t0} is not recorded; {it:t0} is then
    assumed to be 0.  In such a dataset, an observation that had {it:t}=5
    would record the span (0,5].  

{pmore}
    Each observation also includes a variable {it:d}, called the failure 
    variable, which contains 0 or nonzero (typically, 1).  The failure
    variable records what happened at the end of the span:  0, the subject was
    still alive (had not yet failed) or 1, the subject died (failed).

{pmore}
    Sometimes variable {it:d} is not recorded; {it:d} is then
    assumed to be 1.  In such a dataset, all time-span observations would
    be assumed to end in failure.

{pmore}
    Finally, each observation in an st dataset can record the entire history 
    of a subject or each can record a part of the history.  In the latter case, 
    groups of observations record the full history.  One observation might 
    record the period (0,5] and the next, (5,8].  In such
    cases, there is a variable ID that records the subject for which the
    observation records a time span.  Such data are called multiple-record st
    data.  When each observation records the entire history of a
    subject, the data are called single-record st data.  In the single-record
    case, the ID variable is optional.
    
{pmore}
See {helpb stset:[ST] stset}.

{marker SMR}{...}
{phang}
{bf:standardized mortality (morbidity) ratio}.
    Standardized mortality (morbidity) ratio (SMR) is the
    observed number of deaths divided by the expected number of deaths.  It is
    calculated using indirect standardization:  you take the population of the
    group of interest -- say, by age, sex, and other factors -- and
    calculate the expected number of deaths in each cell (expected being
    defined as the number of deaths that would have been observed if those in
    the cell had the same mortality as some other population).  You then take
    the ratio to compare the observed with the expected number of deaths.  For
    instance,

	          (1)               (2)            (1) x (2)      (4)
               Population   Deaths per 100,000    Expected {it:#}   Observed
        Age    of group     in general pop.       of deaths    deaths
        {hline 64}
        25-34    95,965           105.2             100.9          92
        34-44    78,280           203.6             159.4         180
        44-54    52,393           428.9             224.7         242
        55-64    28,914           964.6             278.9         312
        {hline 64}
        Total                                       763.9         826
        
               SMR  =  826 / 763.9  =  1.08

{phang}
{bf:stratified model}.
    A stratified survival model constrains regression coefficients to be equal
    across levels of the stratification variable, while allowing other
    features of the model to vary across strata.

{phang}
{bf:stratified test}.
    A stratified test is performed separately for each stratum.  The
    stratum-specific results are then combined into an overall test statistic.

{marker subhazard}{...}
{phang}
{bf:subhazard}, {bf:cumulative subhazard}, and {bf:subhazard ratio}.  In a
competing-risks analysis, the hazard of the subdistribution (or subhazard for
short) for the event of interest (type 1) is defined formally as

{phang2}
h_1[bar](t) = lim_delta -> 0
{c -(}(P(t < T {ul:<} t + delta and event type 1) | T > t or (T {ul:<} t and not event type 1)/delta{c )-}

{pmore}
Less formally, think of this hazard as that which generates failure events of
interest while keeping subjects who experience competing events "at risk" so
that they can be adequately counted as not having any chance of failing.

{pmore}
The cumulative subhazard H_1[bar](t) is the integral of the subhazard
function hbar_1(t), from 0 (the onset of risk) to t. The cumulative
subhazard plays a very important role in competing-risks analysis.  The
cumulative incidence function (CIF) is a direct function of the
cumulative subhazard:

        CIF_1(t) = 1 - exp{c -(}-Hbar_1(t){c )-}

{pmore}
The subhazard ratio is the ratio of the subhazard function evaluated at two
different values of the covariates: hbar_1(t | {bf:x}) / hbar_1(t | {bf:x}_0).
The subhazard ratio is often called the relative subhazard, especially when
hbar_1(t | {bf:x}_0) is the baseline subhazard function.

{phang}
{bf:survival-time data}.  See {it:{help st_glossary##st_data:st data}}.

{phang}
{bf:survivor function}.
    Also known as the survivorship function and the survival function, 
    the survivor function, {it:S(t)}, is 1) the probability of surviving 
    beyond time {it:t}, or equivalently, 2) the probability that there is no
    failure event prior to {it:t}, 3) the proportion of the 
    population surviving to time {it:t}, or equivalently, 4) the reverse
    cumulative distribution function of {it:T}, the time to the failure event:
    {it:S(t)} = Pr({it:T}>{it:t}).  Also see 
    {it:{help st_glossary##hazard:hazard}}.

{phang}
{bf:thrashing}.
    Subjects are said to thrash when they are censored and immediately reenter
    with different covariates.

{phang}
{marker timevarying}{...}
{bf:time-varying covariates}.
    Time-varying covariates appear in a survival model whose values vary over
    time.  The values of the covariates vary, not the
    effect.  For instance, in a proportional hazards model, the log hazard at
    time {it:t} might be {it:b} x age_{it:t} + {it:c} x treatment_{it:t}.
    Variable age might be time varying, meaning that as the subject ages, the
    value of age changes, which correspondingly causes the hazard to change.
    The effect {it:b}, however, remains constant.

{pmore}
    Time-varying variables are either continuously varying or discretely 
    varying.  

{pmore}
    In the continuously varying case, the value of the variable {it:x} at time
    {it:t} is {it:x}_{it:t} = {it:x}_{it:o} + {it:f}({it:t}), where {it:f}()
    is some function and often is the identity function, so that
    {it:x}_{it:t} = {it:x}_{it:o} + {it:t}.

{pmore}
    In the discretely varying case, the value of {it:x} changes at 
    certain times and often in no particular pattern:

             {it:idvar}     {it:t0}       {it:t}        {it:bp}
             {hline 32}
             1         0        5        150
             1         5        7        130
             1         7        9        135

{pmore}
    In the above data, the value of {it:bp} is 150 over the period
    (0,5], then 130 over (5,7], and 135 over (7,9].

{phang}
{marker truncation}{...}
{bf:truncation, left-truncation, and right-truncation}.
     In survival analysis, truncation occurs when subjects are observed only
     if their failure times fall within a certain observational period of a
     study.  Censoring, on the other hand, occurs when subjects are observed
     for the whole duration of a study, but the exact times of their failures
     are not known; it is known only that their failures occurred within a
     certain time span.

{pmore}
     Left-truncation occurs when subjects come under observation only if
     their failure times exceed some time {it:t}_{it:l}.
     It is only because they did not fail before {it:t}_{it:l} that we even
     knew about their existence.  Left-truncation differs from left-censoring
     in that, in the censored case, we know that the subject failed before time
     {it:t}_{it:l}, but we just do not know exactly when.

{pmore}
     Imagine a study of patient survival after surgery, where patients cannot
     enter the sample until they have had a post-surgical test.  The patients'
     survival times will be left-truncated.  This is a "delayed entry"
     problem, one common type of left-truncation.

{pmore}
     Right-truncation occurs when subjects come under observation only if
     their failure times do not exceed some time {it:t}_{it:r}.
     Right-truncated data typically occur in registries.  For example, a
     cancer registry includes only subjects who developed a cancer by a
     certain time, and thus survival data from this registry will be
     right-truncated.

{phang}
{marker type1}{...}
{bf:type I error} or {bf:false-positive result}. 
     The type I error of a test is the error of rejecting the null hypothesis
     when it is true.  The probability of committing a type I error,
     significance level of a test, is often denoted as alpha in statistical
     literature.  One traditionally used value for alpha is 5%.  Also see
     {it:{help st_glossary##type2:type II error}} and
     {it:{help st_glossary##power:power}}.


{phang}
{marker type2}{...}
{bf:type II error} or {bf:false-negative result}. 
     The type II error of a test is the error of not rejecting the null
     hypothesis when it is false.  The probability of committing a type II error
     is often denoted as beta in statistical literature.  Commonly used values
     for beta are 20% or 10%.  Also see
     {it:{help st_glossary##type1:type I error}} and
     {it:{help st_glossary##power:power}}.

{phang}
{marker under_observation}{...}
{bf:under observation}.
    A subject is under observation when failure events, should they occur, 
    would be observed (and so recorded in the dataset).  Being under
    observation does not mean that a subject is necessarily at risk.  
    Subjects usually come under observation before they are at risk.  The
    statistical concern is with periods when subjects are at risk but not
    under observation, even when the subject is (later) known not to have
    failed during the hiatus.

{pmore}
    In such cases, since failure events would not have been observed, 
    the subject necessarily had to survive the observational hiatus, and 
    that leads to bias in statistical results unless the hiatus is
    accounted for properly.

{pmore}
    Entry time and exit time record when a subject first and last comes under
    observation, between which there may be observational gaps, but usually
    there are not.  There is only one entry time and one exit time for each
    subject.  Often, entry time corresponds to analysis time {it:t}=0, or
    before, and exit time corresponds to the time of failure.

{pmore}
    Delayed entry means that the entry time occurred after {it:t}=0.
{p_end}
