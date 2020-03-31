{smcl}
{* *! version 1.0.28  15may2018}{...}
{vieweralsosee "[MI] Glossary" "mansection MI Glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{viewerjumpto "Description" "mi_glossary##description"}{...}
{viewerjumpto "Glossary" "mi_glossary##glossary"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[MI] Glossary}}{p_end}
{p2col:({mansection MI Glossary:View complete PDF manual entry})}{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
Please read.  The terms defined below are used throughout the documentation,
sometimes without explanation.


{marker glossary}{...}
{title:Glossary}

{marker def_arbitrary}{...}
{p 4 8 2}
{bf:arbitrary missing pattern}.
    Any missing-value pattern.  Some imputation methods are suitable only
    when the pattern of missing values is special, such as a 
    {help mi_glossary##def_monotone:monotone-missing pattern}.  
    An imputation method suitable for use with an arbitrary missing pattern 
    may be used regardless of the pattern.

{p 4 8 2}
{bf:augmented regression}.
    Regression performed on the augmented data, the data with a few extra
    observations with small weights.  The data are augmented in a way that
    prevents perfect prediction, which may arise during estimation of
    categorical data.  See 
    {mansection MI miimputeRemarksandexamplesTheissueofperfectpredictionduringimputationofcategoricaldata:{it:The issue of perfect prediction during imputation of categorical data}}
     under {it:Remarks and examples} of {bf:[MI] mi impute}.

{p 4 8 2}
{bf:burn-between period}.
    The number of iterations between two draws
    of an {help mi_glossary##def_MCMC:MCMC} sequence such
    that these draws may be regarded as independent.

{p 4 8 2}
{bf:burn-in period}.
    The number of iterations it takes for an
    {help mi_glossary##def_MCMC:MCMC} sequence to reach stationarity.

{p 4 8 2}
{bf:casewise deletion}.
    See {it:{help mi_glossary##def_listwise:listwise deletion}}.

{p 4 8 2}
{bf:chained equations}.
    See {it:{help mi_glossary##def_FCS:fully conditional specification}}.

{marker def_complete}{...}
{p 4 8 2}
{bf:complete and incomplete observations}.
    An observation in the {it:m}=0 data is said to be complete if no  
    {help mi_glossary##def_imputed:imputed} variable in the observation
    contains {help mi_glossary##def_hardmissing:soft missing} ({cmd:.}).
    Observations that are not complete are said to be incomplete.

{p 4 8 2}
{bf:complete data}.
    Data that do not contain any missing values.

{marker complete_DF}{...}
{p 4 8 2}
{bf:complete degrees of freedom}.
    The degrees of freedom that would have been used for inference if the data
    were complete.

{p 4 8 2}
{bf:complete DF}.
    See {it:{help mi_glossary##complete_DF:complete degrees of freedom}}.

{p 4 8 2}
{bf:complete-cases analysis}.
    See {it:{help mi_glossary##def_listwise:listwise deletion}}.

{p 4 8 2}
{bf:complete-data analysis}.
    The analysis or estimation performed on the complete data, the data for
    which all values are observed.  This term does not refer to analysis or
    estimation performed on the subset of complete observations.  Do not
    confuse this with
    {help mi_glossary##def_completed_data_analysis:completed-data analysis}.

{p 4 8 2}
{bf:completed data}.
    See {it:{help mi_glossary##def_imputed_data:imputed data}}.

{marker def_completed_data_analysis}{...}
{p 4 8 2}
{bf:completed-data analysis}.
    The analysis or estimation performed on the made-to-be completed (imputed)
    data.  This term does not refer to analysis or estimation performed 
    on the subset of complete observations.

{p 4 8 2}
{bf:conditional imputation}.
    Imputation performed using a conditional sample, a restricted part of
    the sample.  Missing values outside the
    conditional sample are replaced with a conditional constant, the
    constant value of the imputed variable in the nonmissing observations
    outside the conditional sample.  See
    {mansection MI miimputeRemarksandexamplesConditionalimputation:{it:Conditional imputation}}
    under {it:Remarks and examples} of {bf:[MI] mi impute}.

{p 4 8 2}
{bf:DA}.
    See {it:{help mi_glossary##def_DA:data augmentation}}.

{marker def_DA}{...}
{p 4 8 2}
{bf:data augmentation}.
    An {help mi_glossary##def_MCMC:MCMC} method used for the imputation of
    missing data.

{p 4 8 2}
{bf:EM}.
    See {it:{help mi_glossary##def_EM:expectation-maximization algorithm}}.

{marker def_EM}{...}
{p 4 8 2}
{bf:expectation-maximization algorithm}.
     In the context of MI, an iterative procedure for obtaining
     maximum likelihood or posterior-mode estimates in the presence of 
     missing data. 

{p 4 8 2}
{bf:FCS}.
    See {it:{help mi_glossary##def_FCS:fully conditional specification}}.

{p 4 8 2}
{bf:flong data}.
    See {it:{help mi_glossary##def_style:style}}.

{p 4 8 2}
{bf:flongsep data}.
    See {it:{help mi_glossary##def_style:style}}.

{p 4 8 2}
{bf:FMI}.
    See {it:{help mi_glossary##def_FMI:fraction of missing information}}.

{marker def_FMI}{...}
{p 4 8 2}
{bf:fraction of missing information}.
    The ratio of information lost due to the missing data to the total
    information that would be present if there were no missing data.

{p 8 8 2}
    An equal FMI test is a test under the assumption that FMIs are
    equal across parameters.

{p 8 8 2}
    An unrestricted FMI test is a test without the equal FMI
    assumption.

{marker def_FCS}{...}
{p 4 8 2}
{bf:fully conditional specification}.
    Consider imputation variables X_1, X_2, ..., X_p.  Fully conditional
    specification of the prediction equation for X_j includes all variables
    except X_j; that is, variables {bf:X}_{-j} = (X_1, X_2, ..., X_{j-1},
    X_{j+1}, ..., X_p).

{marker def_hardmissing}{...}
{p 4 8 2}
{bf:hard missing and soft missing}.
    A hard missing value is a value of {cmd:.a}, {cmd:.b}, ..., {cmd:.z}
    in {it:m}=0 in an imputed variable.  Hard missing values are not 
    replaced in {it:m}>0. 

{p 8 8 2}
    A soft missing value is a value of {cmd:.} in {it:m}=0 in an 
    {help mi_glossary##def_imputed:imputed variable}.  If an imputed variable 
    contains soft missing, then that value is eligible to be imputed, 
    and perhaps is imputed, in {it:m}>0.

{p 8 8 2}
    Although you can use the terms hard missing and soft missing for 
    passive, regular, and unregistered variables, it has no special 
    significance in terms of how the missing values are treated.

{marker def_ignorable}{...}
{p 4 8 2}
{bf:ignorable missing-data mechanism}.
    The missing-data mechanism is said to be ignorable if missing data are
    {help mi_glossary##def_MAR:missing at random} and the parameters of the
    data model and the parameters of the missing-data mechanism are distinct;
    that is, the joint distribution of the model and the missing-data parameters
    can be factorized into two independent marginal distributions of model
    parameters and of missing-data parameters.

{marker def_imputed}{...}
{p 4 8 2}
{bf:imputed, passive, and regular variables}.
    An imputed variable is a variable that has 
    missing values and for which you have or will have imputations.

{p 8 8 2}
    A passive variable is a {help mi_glossary##def_varying:varying variable} that is a function of imputed 
    variables or of other passive variables.  A passive variable
    will have missing values in {it:m}=0 and varying values for 
    observations in {it:m}>0.

{p 8 8 2}
    A regular variable is a variable that is neither imputed nor passive
    and that has the same values, whether missing or not, in all {it:m}.

{p 8 8 2}
    Imputed, passive, and regular variables can be registered
    using the {bf:{help mi_set:mi register}} command.  
    You are required to register imputed variables, and we recommend that you 
    register passive variables.  Regular variables can also be registered.
    See {it:{help mi_glossary##def_registered:registered and unregistered variables}}.

{p 8 8 2}
INCLUDE help mi_longvarnames

{marker def_imputed_data}{...}
{p 4 8 2}
{bf:imputed data}.
    Data in which all missing values are imputed.

{p 4 8 2}
{bf:incomplete observations}.
    See {it:{help mi_glossary##def_complete:complete and incomplete observations}}.

{p 4 8 2}
{bf:ineligible missing value}.
    An ineligible missing value is a missing value in a to-be-imputed variable
    that is due to inability to calculate a result rather than an
    underlying value being unobserved.  For instance, assume that variable
    {cmd:income} had some missing values and so you wish to impute it.
    Because {cmd:income} is skewed, you decide to impute the log of income,
    and you begin by typing

	   . {cmd:generate lnincome = log(income)}

{p 8 8 2}
    If {cmd:income} contained any zero values, the corresponding missing
    values in {cmd:lnincome} would be ineligible missing values.  To ensure
    that values are subsequently imputed correctly, it is of vital importance
    that any ineligible missing values be recorded as
    {help mi_glossary##def_hardmissing:hard missing}.  You would do 
    that by typing

	   . {cmd:replace lnincome = .a if lnincome==. & income!=.}

{p 8 8 2}
    As an aside, if after imputing {cmd:lnincome} using 
    {bf:{help mi_impute:mi impute}}, you wanted to fill in 
    {cmd:income}, {cmd:income} surprisingly would be a passive variable 
    because {cmd:lnincome} is the imputed variable and {cmd:income} 
    would be derived from it.  You would type 

	   . {cmd:mi register passive income}

	   . {cmd:mi passive: replace income = cond(lnincome==.a, 0, exp(lnincome))}

{p 8 8 2}
    In general, you should avoid using transformations that produce
    ineligible missing values to avoid the loss of information contained in
    other variables in the corresponding observations.  For example, in the
    above, for zero values of {cmd:income} we could have assigned the log of
    income, {cmd:lnincome}, to be the smallest value that can be stored as
    {cmd:double}, because the logarithm of zero is negative infinity:

	   . {cmd:generate lnincome = cond(income==0, mindouble(), log(income))}

{p 8 8 2}
    This way, all observations for which {cmd:income==0} will be used in the
    imputation model for {cmd:lnincome}.

{p 4 8 2}
{bf:jackknifed standard error}.
    See {it:{help mi_glossary##def_MCE:Monte Carlo error}}.

{marker def_listwise}{...}
{p 4 8 2}
{bf:listwise deletion}, {bf:casewise deletion}.
     Omitting from analysis observations containing missing values.

{marker def_M}{...}
{p 4 8 2}
{bf:M}, {bf:m}.
    {it:M} is the number of imputations.  {it:m} refers to a particular 
    imputation, {it:m} = 1, 2, ..., {it:M}.
    In {cmd:mi}, {it:m}=0 is used to refer to the original data, the data
    containing the missing values.  Thus {cmd:mi} data in effect contain
    {it:M}+1 datasets, corresponding to {it:m}=0, {it:m}=1, ..., and
    {it:m}={it:M}.

{p 4 8 2}
{bf:MAR}.
    See {it:{help mi_glossary##def_MAR:missing at random}}.

{marker def_MCMC}{...}
{p 4 8 2}
{bf:Markov chain Monte Carlo}.
    A class of methods for simulating random draws from otherwise intractable
    multivariate distributions.  The Markov chain has the desired
    distribution as its equilibrium distribution.

{p 4 8 2}
{bf:MCAR}.
    See {it:{help mi_glossary##def_MCAR:missing completely at random}}.

{p 4 8 2}
{bf:MCE}.
    See {it:{help mi_glossary##def_MCE:Monte Carlo error}}.

{p 4 8 2}
{bf:MCMC}.
    See {it:{help mi_glossary##def_MCMC:Markov chain Monte Carlo}}.

{marker def_mi_data}{...}
{p 4 8 2}
{bf:mi data}.
     Any data that have been {bf:{help mi_set:mi set}}, whether directly by
     {cmd:mi} {cmd:set} or indirectly by {bf:{help mi_import:mi import}}.  The
     {cmd:mi} data might have no imputations (have {it:M}=0) and no imputed
     variables, at least yet, or they might have {it:M}>0 and no imputed
     variables, or vice versa.  An {cmd:mi} dataset might have {it:M}>0 and
     imputed variables, but the missing values have not yet been replaced with
     imputed values.  Or {cmd:mi} data might have {it:M}>0 and imputed
     variables and the missing values of the imputed variables filled in with
     imputed values.

{marker def_MAR}{...}
{p 4 8 2}
{bf:missing at random}.
    Missing data are said to be missing at random (MAR) if the probability
    that data are missing does not depend on unobserved data but may depend on
    observed data.  Under MAR, the missing-data values do not contain any
    additional information given observed data about the missing-data
    mechanism.  Thus the process that causes missing data can be ignored.

{marker def_MCAR}{...}
{p 4 8 2}
{bf:missing completely at random}.
    Missing data are said to be missing completely at random (MCAR) if the
    probability that data are missing does not depend on observed or
    unobserved data.  Under MCAR, the missing data values are a simple random
    sample of all data values, so any analysis that discards the missing
    values remains consistent, albeit perhaps inefficient.

{marker def_MNAR}{...}
{p 4 8 2}
{bf:missing not at random}.
    Missing data are missing not at random (MNAR) if the probability that data
    are missing depends on unobserved data.  Under MNAR, a missing-data
    mechanism (the process that causes missing data) must be modeled to obtain
    valid results.

{p 4 8 2}
{bf:mlong data}.
    See {it:{help mi_glossary##def_style:style}}.

{p 4 8 2}
{bf:MNAR}.
    See {it:{help mi_glossary##def_MNAR:missing not at random}}.

{marker def_monotone}{...}
{p 4 8 2}
{bf:monotone-missing pattern}, {bf:monotone missingness}.
    A special pattern of missing values in which 
    if the variables are ordered from least to most missing, then 
    all observations of a variable contain missing in the observations 
    in which the prior variable contains missing.

{marker def_MCE}{...}
{p 4 8 2}
{bf:Monte Carlo error}.
    Within the multiple-imputation context, a Monte Carlo error is defined as
    the standard deviation of the multiple-imputation results across repeated
    runs of the same imputation procedure using the same data.  The Monte
    Carlo error is useful for evaluating the statistical reproducibility of 
    multiple-imputation results.  See 
    {it:{mansection MI miestimateRemarksandexamplesExample6MonteCarloerrorestimates:Example 6: Monte Carlo error estimates}}
    under {it:Remarks and examples} of {bf:[MI] mi estimate}.

{marker original_data}{...}
{p 4 8 2}
{bf:original data}.
    Original data are the data as originally collected, with missing 
    values in place.  In {cmd:mi} data, the original data are stored in 
    {it:m}=0.  The original data can be extracted from {cmd:mi} data by using
    {bf:{help mi_extract:mi extract}}.

{p 4 8 2} 
{bf:passive variable}.
    See 
    {it:{help mi_glossary##def_imputed:imputed, passive, and regular variables}}.

{marker def_registered}{...}
{p 4 8 2}
{bf:registered and unregistered variables}.
    Variables in {cmd:mi} data can be registered as 
    {help mi_glossary##def_imputed:imputed, passive, or regular}
    by using the {cmd:mi} {cmd:register} command; see
    {bf:{help mi_set:[MI] mi set}}.

{p 8 8 2}
    You are required to register imputed variables.  

{p 8 8 2}
    You should register passive variables; if your data are 
    style wide, you are required to register them.
    The {bf:{help mi_passive:mi passive}} command makes creating 
    passive variables easy, and it automatically registers them for you.

{p 8 8 2}
    Whether you register regular variables is up to you.
    Registering them is safer in all styles except wide, where it 
    does not matter.  By definition, regular variables should be the same
    across {it:m}.  In the long styles, you can unintentionally create
    variables that vary.  If the variable is registered, {cmd:mi} will
    detect and fix your mistakes.

{p 8 8 2}
    {help mi_glossary##def_varying:Super-varying variables}, 
    which rarely occur and can be stored 
    only in flong and flongsep data, should never be registered.

{p 8 8 2}
    The registration status of variables is listed by the 
    {bf:{help mi_describe:mi describe}} command.

{p 4 8 2}
{bf:regular variable}.
    See {it:{help mi_glossary##def_imputed:imputed, passive, and regular variables}}.

{marker re}{...}
{p 4 8 2}
{bf:relative efficiency}.
    Ratio of variance of a parameter given estimation with finite {it:M} 
    to the variance if {it:M} were infinite.
    
{* literature says -due to-, not -because of-}{...}
{marker RVI}{...}
{p 4 8 2}
{bf:relative variance increase}.
     The increase in variance of a parameter estimate due to nonresponse.

{p 4 8 2}
{bf:RVI}.
    See {it:{help mi_glossary##RVI:relative variance increase}}.

{marker def_style}{...}
{p 4 8 2}
{bf:style}.
    Style refers to the format in which the {cmd:mi} data are stored.
    There are four styles:  flongsep, flong,
    mlong, and wide.  You can ignore styles, except
    for making an original selection, 
    because all {cmd:mi} commands work regardless of style.  
    You will be able to work more efficiently, however, if you understand the
    details of the style you are using; 
    see {bf:{help mi_styles:[MI] Styles}}.  Some tasks are easier in one style
    than another.  You can switch between styles by using the 
    {bf:{help mi_convert:mi convert}} command.

{p 8 8 2}
    The flongsep style is best avoided unless your data are too big to fit
    into one of the other styles.  In flongsep style, a separate
    {cmd:.dta} set is created for {it:m}=0, for {it:m=1}, ..., and 
    for {it:m}={it:M}. 
    Flongsep is best avoided because {cmd:mi}
    commands work more slowly with it.

{p 8 8 2}
    In all the other styles, the {it:M}+1 datasets are stored in 
    one {cmd:.dta} file.  The other styles are both more convenient
    and more efficient.  

{p 8 8 2}
    The most easily described of these {cmd:.dta} styles is 
    flong; however, flong is also best avoided
    because mlong style is every bit as 
    convenient as flong, and mlong is memorywise more efficient.
    In flong, each observation in the original
    data is repeated {it:M} times in the {cmd:.dta} dataset, once for
    {it:m}=1, again for {it:m}=2, and so on.
    Variable {cmd:_mi_m} records {it:m} and takes on values 
    0, 1, 2, ..., {it:M}.
    Within each value of {it:m}, 
    variable {cmd:_mi_id} takes on values 1, 2, ..., {it:N} and thus connects
    imputed with original observations.

{p 8 8 2} 
    The mlong style is recommended.  It is efficient and easy to use.
    Mlong is much like flong except that 
    {help mi_glossary##def_complete:complete} observations
    are not repeated.  

{p 8 8 2}
    Equally recommended is the wide style.
    In wide, each {help mi_glossary##def_imputed:imputed and passive variable} 
    has an additional 
    {it:M} variables associated with it, one for the variable's value 
    in {it:m}=1, another for its value in {it:m}=2, and so on.
    If an imputed or passive variable is named {it:vn}, then
    the values of {it:vn} in {it:m}=1 are stored in variable 
    {cmd:_1_}{it:vn}; 
    the values for {it:m=2}, in {cmd:_2_}{it:vn}; and so on.

{p 8 8 2}
    What makes mlong and wide so convenient?  In
    mlong, there is a one-to-one correspondence of your idea of a
    variable and Stata's idea of a variable -- variable {it:vn} refers
    to {it:vn} for all values of {it:m}.  In wide, there is a
    one-to-one correspondence of your idea of an observation and Stata's idea
    -- physical observation 5 is observation 5 in all datasets.

{p 8 8 2}
    Choose the style that matches the problem at hand.  
    If you want to create new variables or modify existing ones, choose 
    mlong.  If you want to drop observations or create new ones, 
    choose wide.  You can switch styles with the 
    {bf:{help mi_convert:mi convert}} command.

{p 8 8 2}
    For instance, 
    if you want to create new variable {cmd:ageXexp} equal to 
    {cmd:age*exp} and your data are mlong, you can just type 
    {cmd:generate} {cmd:ageXexp} {cmd:=} {cmd:age*exp}, and that will work even 
    if {cmd:age} and {cmd:exp} are imputed, passive, or a mix.
    Theoretically, the right way to do that is to type {cmd:mi} {cmd:passive:}
    {cmd:generate} 
    {cmd:agexExp} {cmd:=} {cmd:age*exp}, but concerning variables, 
    if your data are mlong, you can work the usual Stata
    way.

{p 8 8 2}
    If you want to drop observation 20 or drop 
    {cmd:if} {cmd:sex==2}, if your data are wide, you can just type
    {cmd:drop} {cmd:in} {cmd:20} or {cmd:drop} {cmd:if} {cmd:sex==2}.  Here 
    the "right" way to do the problem is to type the {cmd:drop} command
    and then remember to type {cmd:mi} {cmd:update} so that {cmd:mi} can 
    perform whatever machinations are required to carry out the change
    throughout {it:m}>0; however, in the wide form, there are no machinations
    required.

{p 4 8 2}
{bf:super-varying variables}.
   See {it:{help mi_glossary##def_varying:varying and super-varying variables}}.

{p 4 8 2}
{bf:unregistered variables}.
    See {it:{help mi_glossary##def_registered:registered and unregistered variables}}.

{marker def_varying}{...}
{p 4 8 2}
{bf:varying and super-varying variables}.
    A variable is said to be varying if its values in the incomplete
    observations differ across {it:m}.  Imputed and
    passive variables are varying.  Regular variables are 
    nonvarying.  Unregistered variables can be either.

{p 8 8 2}
    Imputed variables are supposed to vary because their incomplete
    values are filled in with different imputed values, although 
    an imputed variable can be temporarily nonvarying
    if you have not imputed its values yet.  Similarly, passive
    variables should vary because they are or will be filled in based on
    values of varying imputed variables.

{p 8 8 2}
    A variable is said to be super varying if its values in the complete
    observations differ across {it:m}.  The existence of super-varying
    variables is usually an indication of error.  It makes no sense for a
    variable to have different values in, say, {it:m}=0 and {it:m}=2 in the
    complete observations -- in observations that contain no missing values.
    That is, it makes no sense unless the values of the variable is a function of
    the values of other variables across multiple observations.  If variable
    {cmd:sumx} is the sum of {cmd:x} across observations, and if {cmd:x} is
    imputed, then {cmd:sumx} will differ across {it:m} in all observations
    after the first observation in which {cmd:x} is imputed.

{p 8 8 2}
    The {bf:{help mi_varying:mi varying}} command will identify varying and 
    super-varying variables, as well as nonvarying imputed and passive 
    variables.  {bf:{help mi_varying:[MI] mi varying}} explains how to 
    fix problems when they are due to error.

{p 8 8 2}
    Some problems that theoretically could arise cannot arise because 
    {cmd:mi} will not let them.  For instance, an imputed variable could 
    be super varying and that would obviously be a serious error.
    Or a regular variable could be varying and that, too, would be a 
    serious error.  When you register a variable, {cmd:mi} fixes any 
    such problems and, from that point on, watches for problems and 
    fixes them as they arise.

{p 8 8 2}
    Use {cmd:mi} {cmd:register} to register 
    variables; see {bf:{help mi_set:[MI] mi set}}.  
    You can perform the checks and fixes at any time by running 
    {bf:{help mi_update:mi update}}.
    Among other things, {cmd:mi} {cmd:update} replaces values of
    regular variables in {it:m}>0 with their values from
    {it:m}=0; it
    replaces values of imputed variables in {it:m}>0 with their
    nonmissing values from {it:m}=0; and it replaces 
    values of passive variables in incomplete observations of {it:m}>0 with
    their {it:m}=0 values.  {cmd:mi} {cmd:update} follows a hands-off 
    policy with respect to unregistered variables.

{p 8 8 2}
    If you need super-varying variables, use flong or 
    flongsep style and do not register the variable.
    You must use one of the flong styles because in the wide and 
    mlong styles, there is simply no place to store super-varying 
    values.

{p 4 8 2}
{bf:wide data}.
    See {it:{help mi_glossary##def_style:style}}.

{p 4 8 2}
{bf:WLF}.
    See {it:{help mi_glossary##WLF:worst linear function}}.

{marker WLF}{...}
{p 4 8 2}
{bf:worst linear function}.
     A linear combination of all parameters being estimated by an 
     iterative procedure that is thought to converge slowly. 
{p_end}
