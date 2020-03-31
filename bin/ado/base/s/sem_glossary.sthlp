{smcl}
{* *! version 1.0.17  22may2019}{...}
{vieweralsosee "[SEM] Glossary" "mansection SEM Glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem and gsem" "help sem"}{...}
{viewerjumpto "Description" "sem_glossary##description"}{...}
{viewerjumpto "Glossary" "sem_glossary##glossary"}{...}
{viewerjumpto "Reference" "sem_glossary##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[SEM] Glossary}}{p_end}
{p2col:({mansection SEM Glossary:View complete PDF manual entry})}{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
Please read.  The terms defined below are used throughout the documentation,
sometimes without explanation.


{marker glossary}{...}
{title:Glossary}

{phang}
{marker ADF}{...}
{bf:ADF}, {bf:method(adf)}.
        ADF stands for asymptotic distribution free and is a method
        used to obtain fitted parameters for standard linear SEMs.
	ADF is used by {cmd:sem}
        when the {cmd:method(adf)} option is specified.  Other available methods
        are {help sem_glossary##ML:ML}, {help sem_glossary##QML:QML}, and
	{help sem_glossary##MLMV:MLMV}.

{phang}
{marker anchoring}{...}
{bf:anchoring}, {bf:anchor variable}.
        A variable is said to be the anchor of a latent variable if the
        path coefficient between the latent variable and the anchor variable
        is constrained to be 1.  {cmd:sem} and {cmd:gsem} use anchoring as a
        way of normalizing latent variables and thus identifying the model.

{phang}
{marker baseline_model}{...}
{bf:baseline model}.
        A baseline model is a covariance model -- a model of fitted means 
        and covariances of observed variables without any other paths -- with
        most of the covariances constrained to be 0.  That is, a baseline
        model is a model of fitted means and variances but typically not all
        the covariances.  Also see 
	{it:{help sem_glossary##saturated_model:saturated model}}.
	Baseline models apply only to standard linear SEMs.

{phang}
{bf:Bentler-Weeks matrices}.
     The Bentler and Weeks {help sem glossary##Bentler1980:(1980)}
     formulation of standard linear SEMs places the results in a series of
     matrices organized around how results are calculated.  See 
     {helpb sem estat framework:[SEM] estat framework}.

{marker bootstrap}{...}
{phang}
{bf:bootstrap}, {bf:vce(bootstrap)}.
The bootstrap is a replication method for obtaining variance estimates.
Consider an estimation method E for estimating theta.  Let theta-hat be
the result of applying E to dataset D containing N observations.  The
bootstrap is a way of obtaining variance estimates for theta-hat from
repeated estimates theta_1-hat, theta_2-hat, ..., where each
theta_i-hat is the result of applying E to a dataset of size N drawn
with replacement from D.
See {helpb sem option method:[SEM] sem option method()} and
{helpb bootstrap:[R] bootstrap}.

{pmore}
{cmd:vce(bootstrap)} is allowed with {cmd:sem} but not {cmd:gsem}.  You
can obtain bootstrap results by prefixing the {cmd:gsem} command with
{cmd:bootstrap:}, but remember to specify {cmd:bootstrap}'s {cmd:cluster()}
and {cmd:idcluster()} options if you are fitting a multilevel model.  See
{manlink SEM Intro 9}.

{marker Builder}{...}
{phang}
{bf:Builder}.
     The Builder is Stata's graphical interface for building {cmd:sem} and
     {cmd:gsem} models.  The Builder is also known as the SEM Builder.
     See {manlink SEM Intro 2}, {helpb sem_builder:[SEM] Builder}, and
     {helpb gsem_builder:[SEM] Builder, generalized}.

{marker categorical_latent_variable}{...}
{phang}
{bf:categorical latent variable}.
      A categorical latent variable has levels that represent unobserved
      groups in the population.  Latent classes are identified with the levels
      of the categorical latent variables and may represent healthy and
      unhealthy individuals, consumers with different buying preferences, or
      different motivations for delinquent behavior.  Categorical latent
      variables are allowed in {cmd:gsem} but not in {cmd:sem}.  See
      {manhelp gsem_lclass_options SEM:gsem lclass options} and
      {manlink SEM Intro 2}.

{phang}
{bf:CFA}, {bf:CFA models}.
        CFA stands for confirmatory factor analysis.  It is 
        a way of analyzing measurement models.
        CFA models is a synonym for
        {help sem_glossary##measurement_models:measurement models}.

{phang}
{marker cluster}{...}
{bf:cluster}, {bf:vce(cluster clustvar)}.
        Cluster is the name we use for the generalized
        Huber/White/sandwich estimator of the VCE, 
        which is the {cmd:robust} technique generalized to relax 
        the assumption that errors are independent across observations 
        to be that they are independent across clusters of observations.
        Within cluster, errors may be correlated.
        
{pmore}
        Clustered standard errors are reported when {cmd:sem} or {cmd:gsem}
        option {cmd:vce(cluster} {it:clustvar}{cmd:)} is specified.  The
        other available techniques are
	{help sem_glossary##OIM:OIM},
	{help sem_glossary##OPG:OPG},
	{help sem_glossary##robust:robust},
	{help sem_glossary##bootstrap:bootstrap}, and
	{help sem_glossary##jackknife:jackknife}.
	Also available for {cmd:sem} only is
        {help sem_glossary##EIM:EIM}.

{marker coefdeter}{...}
{phang}
{bf:coefficient of determination}.
        The coefficient of determination is the fraction (or percentage) 
        of variation (variance) explained by an equation of a model.  The
        coefficient of determination is thus like R^2 in
        linear regression.

{phang}
{bf:command language}.
        Stata's {cmd:sem} and {cmd:gsem} command provides a way to specify
        SEMs.  The alternative is to use the Builder to
        draw path diagrams; see {manlink SEM Intro 2}, 
	{helpb Builder:[SEM] Builder}, and
	{helpb Builder_generalized:[SEM] Builder, generalized}.

{phang}
{bf:complementary log-log regression}.
     Complementary log-log regression is a term for generalized linear
     response functions that are family Bernoulli, link clog-log.  It is used
     for binary outcome data.  Complementary log-log regression is also known
     in Stata circles as clog-log regression or just clog-log. See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:conditional normality assumption}.
        See
        {it:{help sem glossary##normality_assumption:normality assumption, joint and conditional}}.

{phang}
{bf:constraints}.  See
     {it:{help sem glossary##parameter_constraints:parameter constraints}}.

{marker continuous_latent_variable}{...}
{phang}
{bf:continuous latent variable}.
    A continuous latent variable is an unobserved variable, such as
    mathematical ability, with values that are assumed to follow a continuous
    distribution.  Both {cmd:sem} and {cmd:gsem} allow continuous latent
    variables that are assumed to follow a Gaussian distribution with a mean
    and variance that are either estimated or constrained to a specific value
    for identification. See
    {help sem_glossary##identification:{it:identification}}.

{phang}
{bf:correlated uniqueness model}.
        A correlated uniqueness model is a kind of measurement model in
        which the errors of the measurements have a structured
        correlation.  See {manlink SEM Intro 5}.

{phang}
{bf:crossed-effects models}.
	See {it:{help sem glossary##multilevel_models:multilevel models}}.

{phang}
{bf:curved path}.
	See {it:{help sem glossary##path:path}}.

{phang}
{bf:degree-of-freedom adjustment}.
        In estimates of variances and covariances, a finite-population
        degree-of-freedom adjustment is sometimes applied to make the
        estimates unbiased.

{pmore}
        Let's write an estimated variance as sigma_ii hat and write the
        "standard" formula for the variance as
        sigma_ii hat = S_ii/N.  If sigma_ii hat is the variance of
        observable variable x_i, it can be readily proven that S_ii/N
        is a biased estimate of the variances in samples of size N and that
        S_ii/(N-1) is an unbiased estimate.  It is usual to
        calculate variances with S_ii/(N-1), which is to say the
        "standard" formula has a multiplicative degree-of-freedom adjustment
        of N/(N-1) applied to it.

{pmore}
        If Sigma_ii hat is the variances of estimated parameter beta_i, a
        similar finite-population degree-of-freedom adjustment can
        sometimes be derived that will make the estimate unbiased.  For
        instance, if beta_i is a coefficient from a linear regression,
        an unbiased estimate of the variance of regression coefficient
        beta_i is S/(N-p-1), where p is the total number of regression
        coefficients estimated excluding the intercept.  In other cases,
        no such adjustment can be derived.  Such estimators have no
        derivable finite-sample properties, and one is left only with the
        assurances provided by its provable asymptotic properties.  In
        such cases, the variance of coefficient beta_i is calculated as
        S/N, which can be derived on theoretical grounds.  SEM is an
        example of such an estimator.

{pmore}
        SEM is a remarkably flexible estimator and can reproduce results
        that can sometimes be estimated by other estimators.  SEM might
        produce asymptotically equivalent results, or it might produce
        identical results depending on the estimator.  Linear regression
        is an example in which {cmd:sem} and {cmd:gsem} produce the same 
	results as {cmd:regress}.  The reported standard errors, however, will
	not look identical because the linear-regression estimates have the
	finite-population degree-of-freedom adjustment applied to them and the
	SEM estimates do not.  To see the equivalence, you must undo the
	adjustment on the reported linear regression standard errors by
        multiplying them by sqrt{(N-p-1)/N}.

{phang}
{marker direct}{...}
{bf:direct}, {bf:indirect}, and {bf:total effects}.
         Consider the following system of equations:

            y_1 = b_10 + b_11 y_2 + b_12 x_1 + b_13 x_3 + e_1
            y_2 = b_20 + b_21 y_3 + b_22 x_1 + b_23 x_4 + e_2
            y_3 = b_30 + b_32 x_1 + b_33 x_5 + e_3

{pmore}
         The total effect of x_1 on y_1 is 
         b_12 + b_11 b_22 + b_11 b_21 b_32.  
         It measures the full change in y_1 based on allowing x_1 to vary
         throughout the system.

{pmore}
         The direct effect of x_1 on y_1 is b_12.  It measures
         the change in y_1 caused by a change in x_1 holding other
         endogenous variables -- namely, y_2 and y_3 -- constant.

{pmore}
         The indirect effect of x_1 on y_1 is obtained by subtracting
         the total and direct effects and is thus b_11 b_22 + b_11 b_21
         b_32.

{phang}
{marker EIM}{...}
{bf:EIM}, {bf:vce(eim)}.
        EIM stands for expected information matrix, defined 
        as the inverse of the negative of the expected value of the matrix of
        second derivatives, usually of the log-likelihood function.  The
        EIM is an estimate of the VCE.  EIM standard 
        errors are reported when {cmd:sem} option {cmd:vce(eim)} is specified. 
	EIM is available only with {cmd:sem}.
        The other available techniques for {cmd:sem} are
	{help sem_glossary##OIM:OIM},
	{help sem_glossary##OPG:OPG},
        {help sem_glossary##robust:robust},
        {help sem_glossary##cluster:cluster},
        {help sem_glossary##bootstrap:bootstrap}, and
        {help sem_glossary##jackknife:jackknife}.

{phang}
{marker endogenous_variable}{...}
{bf:endogenous variable}.
        A variable, observed or latent, is endogenous (determined by the
        system) if any path points to it.  Also see
        {it:{help sem glossary##exogenous_variable:exogenous variable}}.

{phang}
{marker error}{...}
{bf:error}, {bf:error variable}.
        The error is random disturbance e in a linear equation: 

		y = b_0 + b_1 x_1 + b_2 x_2 + ... + e

{pmore}
        An error variable is an unobserved endogenous variable in path
        diagrams corresponding to e.  Mathematically, error variables
        are just another example of latent endogenous variables, but in
        {cmd:sem} and {cmd:gsem},
        error variables are considered to be in a class by
        themselves.  All endogenous variables -- observed and latent --
        have a corresponding error variable.  Error variables
        automatically and inalterably have their path coefficients fixed
        to be 1.  Error variables have a fixed naming convention in the
        software.  If a variable is the error for (observed or latent)
        endogenous variable {cmd:y}, then the residual variable's name
        is {cmd:e.y}.

{pmore}
        In {cmd:sem} and {cmd:gsem}, error variables are uncorrelated with
        each other unless explicitly indicated otherwise.  That indication is 
        made in path diagrams by drawing a curved path between the error 
        variables and is made in command notation by including 
        {cmd:cov(e.}{it:name1}{cmd:*e.}{it:name2}{cmd:)} 
        among the options specified on the {cmd:sem} command.
 	In {cmd:gsem}, errors for family Gaussian, link log responses are not
	allowed to be correlated.

{phang}
{bf:estimation method}.
        There are a variety of ways that one can solve for the
        parameters of an SEM.  Different methods
        make different assumptions about the data-generation process,
        so it is important that you choose a method appropriate for
        your model and data; see {manlink SEM Intro 4}.

{phang}
{marker exogenous_variable}{...}
{bf:exogenous variable}.
        A variable, observed or latent, is exogenous (determined outside
        the system) if paths only originate from it or, equivalently, no path
        points to it.  In this manual, we do not distinguish whether exogenous
	variables are strictly exogenous -- that is, uncorrelated with the
	errors.  Also see
        {it:{help sem glossary##endogenous_variable:endogenous variable}}.

{phang}
{bf:family distribution}.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:fictional data}.
        Fictional data are data that have no basis in reality even though they
        might look real; they are data that are made up for use in examples.

{phang}
{bf:finite mixture model}.
        A finite mixture model (FMM) is a
        {help sem_glossary##latent_class_model:latent class model}
        in which parameters of a regression model are allowed to vary
        across classes.  The regression model may have a linear or
        {help sem_glossary##generalized_linear_response_functions:generalized linear response function}.

{phang}
{marker first_order_variables}{...}
{bf:first- and second-order latent variables}.
        If a latent variable is measured by other latent variables only, 
        the latent variable that does the measuring is called 
        first-order latent variable, and the latent variable being 
        measured is called the second-order latent variable. 

{marker first_level_variables}{...}
{phang}
{bf:first-, second-, and higher-level (latent) variables}.
        Consider a multilevel model of patients within doctors within
        hospitals.
        First-level variables are variables that vary at the
        observational (patient) level.  Second-level variables vary across
        doctors but are constant within doctors.  Third-level variables
        vary across hospitals but are constant within hospitals.
        This jargon is used whether variables are latent or not.

{phang}
{bf:full joint and conditional normality assumption}.
        See
        {it:{help sem glossary##normality_assumption:normality assumption, joint and conditional}}.

{phang}
{bf:gamma regression}.
     Gamma regression is a term for generalized linear response
     functions that are family gamma, link log.
     It is used for continuous, nonnegative, positively skewed data.
     Gamma regression is also known as log-gamma regression.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:Gaussian regression}.
     Gaussian regression is another term for linear regression.
     It is most often used when referring to generalized linear response
     functions.  In that framework, Gaussian regression is
     family Gaussian, link identity.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{marker generalized_linear_response_functions}{...}
{phang}
{bf:generalized linear response functions}.
        Generalized linear response functions include
        linear functions and include functions such as
        probit, logit, multinomial logit, ordered probit, ordered logit,
        Poisson, and more.

{pmore}
	These generalized linear functions are described by a link function g()
	and statistical distribution F.  The link function g() specifies how
	the response variable y_i is related to a linear equation of the
	explanatory variables, {bf:x}_i beta, and the family F specifies the
        distribution of y_i:

                g{E(y_i)} = {bf:x}_i beta,     y_i sim F

{pmore}
        If we specify that g() is the identity function and
        $F$ is the Gaussian (normal) distribution, then we have linear
        regression.  If we specify that g() is the logit function and
        F the Bernoulli distribution, then we have logit (logistic)
        regression.

{pmore}
        In this generalized linear structure, the family may be
        Gaussian, gamma,  Bernoulli, binomial, Poisson,
        negative binomial, ordinal, or multinomial.
        The link function may be the identity,
        log, logit, probit, or complementary log-log.

{pmore}
        {cmd:gsem} fits models with generalized linear response functions.

{marker GMM}{...}
{phang}
{bf:generalized method of moments}.
        Generalized method of moments (GMM) is a method used to obtain
 	fitted parameters.  In this
        documentation, GMM is referred to as {help sem_glossary##ADF:ADF},
        which stands
        for asymptotic distribution free and is available fr use with {cmd:sem}.
        Other available methods for use with {cmd:sem} are
	{help sem_glossary##ML:ML},
        {help sem_glossary##QML:QML},
        {help sem_glossary##ADF:ADF}, and
	{help sem_glossary##MLMV:MLMV}.

{pmore}
        The SEM moment conditions are cast in terms of second moments,
        not the first moments used in many other applications associated with
        GMM.

{marker generalized_SEM}{...}
{phang}
{bf:generalized SEM}.
        Generalized SEM is a term we have coined to mean SEM optionally allowing
     {help sem glossary##generalized_linear_response_functions:generalized linear response functions},
     {help sem glossary##multilevel_models:multilevel models},
        or
     {help sem glossary##categorical_latent_variable:categorical latent variables}.
        {cmd:gsem} fits generalized SEMs.

{phang}
{bf:GMM}.
        See {it:{help sem glossary##GMM:generalized method of moments}}.

{phang}
{bf:goodness-of-fit statistic}.
        A goodness-of-fit statistic is a value designed to measure 
        how well the model reproduces some aspect of the data the model 
        is intended to fit.  SEM reproduces the 
        first- and second-order moments of the data, with an emphasis 
        on the second-order moments, and thus goodness-of-fit statistics 
        appropriate for use after {cmd:sem} compare the predicted 
        covariance matrix (and mean vector) with the matrix (and vector) 
        observed in the data.

{marker gsem}{...}
{phang}
{bf:gsem}.
        {cmd:gsem} is the Stata command that fits generalized SEMs.
	Also see {it:{help sem_glossary##sem:sem}}.

{phang}
{bf:GUI}.
        See
	{it:{help sem glossary##Builder:Builder}}.

{phang}
{marker identification}{...}
{bf:identification}.
        Identification refers to the conceptual constraints on
        parameters of a model that are required for the model's remaining
        parameters to have a unique solution.  A model is said to be
        unidentified if these constraints are not supplied. 
        These constraints are of two types:  substantive constraints
        and normalization constraints.

{pmore}
        Normalization constraints have to do with the fact that one scale
        works as well as another for each continuous latent variable in the
	model.  One can think, for instance, of propensity to write software as
	being measured on a scale of 0 to 1, 1 to 100, or any other scale.  The
	normalization constraints are the constraints necessary to choose one
	particular scale.  The normalization constraints are provided
	automatically by {cmd:sem} and {cmd:gsem} by
	{help sem glossary##anchoring:anchoring} with unit loadings. 

{pmore}
        Substantive constraints are the constraints you specify about your 
        model so that it has substantive content.  Usually, these constraints
        are 0 constraints implied by the paths omitted, 
        but they can include explicit parameter constraints as well.  It is
        easy to write a model that is not identified for substantive reasons;
        see {manlink SEM Intro 4}.

{phang}
{marker indicator_variables}{...}
{bf:indicator variables}, {bf:indicators}.
	The term "indicator variable" has two meanings.  An indicator variable
	is a 0/1 variable that contains whether something is true.
        The other usage is as a synonym for
	{help sem glossary##measurement_variables:measurement variables}.

{phang}
{bf:indirect effects}.  See
       {it:{help sem glossary##direct:direct, indirect, and total effects}}.

{phang}
{bf:initial values}.  See
       {it:{help sem glossary##starting_values:starting values}}.

{phang}
{marker intercept}{...}
{bf:intercept}.
        An intercept for the equation of endogenous variable y,
        observed or latent, is the path coefficient from {cmd:_cons} to y.
        {cmd:_cons} is Stata-speak for the built-in variable containing 
        1 in all observations.  In SEM-speak, {cmd:_cons} is an 
        observed exogenous variable.

{marker jackknife}{...}
{phang}
{bf:jackknife}, {bf:vce(jackknife)}.
The jackknife is a replication method for obtaining variance estimates.
Consider an estimation method E for estimating theta.  Let theta-hat be
the result of applying E to dataset D containing N observations.  The
jackknife is a way of obtaining variance estimates for theta-hat from
repeated estimates theta_1-hat, theta_2-hat, ..., theta_N-hat, where
each theta_i-hat is the result of applying E to D with observation i
removed.  See {helpb sem option method:[SEM] sem option method()} and
{helpb jackknife:[R] jackknife}.

{pmore}
{cmd:vce(jackknife)} is allowed with {cmd:sem} but not {cmd:gsem}.
You can obtain jackknife results by prefixing the {cmd:gsem}
command with {cmd:jackknife:}, but remember to specify {cmd:jackknife}'s
{cmd:cluster()} and {cmd:idcluster()} options if you are fitting a multilevel
model.  See {manlink SEM Intro 9}.

{phang}
{bf:joint normality assumption}.
        See 
        {it:{help sem glossary##normality_assumption:normality assumption, joint and conditional}}.

{phang}
{bf:Lagrange multiplier tests}.
        Synonym for {help sem glossary##score_tests:score tests}.

{marker latent_class_analysis}{...}
{phang}
{bf:latent class analysis}.
        Latent class analysis is useful for identifying and understanding
        unobserved groups in a population.  When performing a latent
        class analysis, we fit models that include a
        {help sem_glossary##categorical_latent_variable:categorical latent variable}
	with levels called latent classes that correspond to the unobserved
	groups.  In latent class analysis, we can compare models with differing
	numbers of latent classes and different sets of constraints on
	parameters to determine the best-fitting model.  For a given model, we
	can compare parameter estimates across classes.  We can estimate the
	proportion of the population in each latent class.  And we can predict
	the probabilities that the individuals in our sample belong to each
	latent class.

{marker latent_class_model}{...}
{phang}
{bf:latent class model}.
        Any model with a
        {help sem_glossary##categorical_latent_variable:categorical latent variable}
        that is fit as part of a
        {help sem_glossary##latent_class_analysis:latent class analysis}.
        In some literature, latent class models are more narrowly defined to
        include only categorical latent variables and the binary or categorical
        observed variables that are indicators of class membership, but we do
        not make such a restriction. See {manlink SEM Intro 5}.

{phang}
{bf:latent cluster model}.
	A type of {help sem_glossary##latent_class_model:latent class model}
	with continuous observed outcomes.

{phang}
{bf:latent growth model}.
        A latent growth model is a kind of measurement model in which 
        the observed values are collected over time and are allowed to follow a 
        trend.  See {manlink SEM Intro 5}.
        
{phang}
{bf:latent profile model}.
        A type of {help sem_glossary##latent_class_model:latent class model}
        with continuous observed outcomes.

{phang}
{marker latent_variable}{...}
{bf:latent variable}.
        A variable is latent if it is not observed.  A variable is
        latent if it is not in your dataset but you wish it were.  You wish
        you had a variable recording the propensity to commit violent crime,
        or socioeconomic status, or happiness, or true ability, or even
        income accurately recorded.  Latent variables are sometimes described
        as imagined variables.

{pmore}
        In the software, latent variables are usually indicated by having 
        at least their first letter capitalized.

{pmore}
        Also see
	{help sem_glossary##continuous_latent_variable:{it:continuous latent variable}},
       {help sem_glossary##categorical_latent_variable:{it:categorical latent variable}},
        {it:{help sem glossary##first_order_variables:first- and second-order latent variables}},
        {it:{help sem glossary##first_level_variables:first-, second-, and higher-level (latent) variables}},
	and
	{it:{help sem glossary##observed_variables:observed variables}}.

{phang}
{bf:linear regression}.
        Linear regression is a kind of SEM 
        in which there is a single equation. 
        See {manlink SEM Intro 5}.

{phang}
{bf:link function}.
        See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:logit regression}.
     Logit regression is a term for generalized linear response
     functions that are family Bernoulli, link logit.
     It is used for binary outcome data.
     Logit regression is also known as
     logistic regression and also simply as logit.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:manifest variables}.
        Synonym for {help sem glossary##observed_variables:observed variables}.

{phang}
{bf:measure}, {bf:measurement}, {bf:x a measurement of X}, {bf:x measures X}.
        See
	{it:{help sem glossary##measurement_variables:measurement variables}}.

{phang}
{marker measurement_models}{...}
{bf:measurement models}, {bf:measurement component}.
        A measurement model is a particular kind of model that deals
        with the problem of translating observed values to values suitable for
        modeling.  Measurement models are often combined with structural
        models and then the measurement model part is referred to as the
        measurement component.
        See {manlink SEM Intro 5}.

{phang}
{marker measurement_variables}{...}
{bf:measurement variables}, {bf:measure}, {bf:measurement}, {bf:x a measurement of X}, {bf:x measures X}.
        Observed variable x is a measurement of latent variable X
        if there is a path connecting x-> X.  Measurement variables
        are modeled by measurement models.  Measurement variables are
        also called {help sem glossary##indicator_variables:indicator variables}.

{phang}
{bf:method}.
        Method is just an English word and should be read in context. 
        Nonetheless, method is used here usually to refer to the 
        method used to solve for the fitted parameters of an SEM.
	Those methods are
	{help sem_glossary##ML:ML},
        {help sem_glossary##QML:QML}, 
	{help sem_glossary##MLMV:MLMV}, and
	{help sem_glossary##ADF:ADF}.  Also see
        {it:{help sem_glossary##technique:technique}}.

{phang}
{bf:MIMIC}.  See
        {it:{help sem_glossary##MIMIC:multiple indicators and multiple causes}}.

{phang}
{bf:mixed-effects models}.  See
        {it:{help sem_glossary##multilevel_models:multilevel models}}.

{phang}
{marker ML}{...}
{bf:ML}, {bf:method(ml)}.
        ML stands for maximum likelihood.  It is a method used to 
        obtain fitted parameters.  ML is the default method used by 
        {cmd:sem} and {cmd:gsem}.  Other available methods for {cmd:sem} are
	{help sem_glossary##QML:QML}, 
	{help sem_glossary##MLMV:MLMV}, and
	{help sem_glossary##ADF:ADF}.
	Also available for {cmd:gsem} is 
	{help sem_glossary##QML:QML}.

{phang}
{marker MLMV}{...}
{bf:MLMV}, {bf:method(mlmv)}.
	MLMV stands for maximum likelihood with missing values.  It is
        an ML method to obtain fitted parameters in the presence of
	missing values.  ML is the method used by {cmd:sem} and {cmd:gsem} 
        when the 
	{cmd:method(mlmv)} option is specified; {cmd:method(mlmv)} is not
 	available with {cmd:gsem}.  Other available methods for use with 
        {cmd:sem} are
	{help sem_glossary##ML:ML}, 
	{help sem_glossary##QML:QML}, and {help sem_glossary##ADF:ADF}.
	These other methods omit from the
        calculation observations that contain missing values.

{phang}
{bf:modification indices}.
	Modification indices are score tests for adding 
        paths where none appear.  The paths can be for either coefficients or 
        covariances.

{phang}
{bf:moments (of a distribution)}.
        The moments of a distribution are the expected values of
        powers of a random variable or centralized (demeaned) powers of a
        random variable.  As used here, the first moments are the expected or
        observed means, and the second moments are the expected or observed
        variances and covariances.

{marker multilevel_models}
{phang}
{bf:multilevel models}.
        Multilevel models are models that include unobserved effects
        (latent variables) for different groups in the data.
        For instance, in a dataset of students, groups of students
        might share the same teacher.
        If the teacher's identity is recorded in the data, then one
        can introduce a latent variable that is constant within
        teacher and that varies across teachers.   This is called a
        two-level model.

{pmore}
        If teachers could in turn be grouped into schools, and school
        identities were recorded in the data, then one can introduce another
        latent variable that is constant within school and varies across
        schools.  This is called a three-level (nested-effects) model.

{pmore}
        In the above example, observations (students) are said to be nested
        within teacher nested within school.  Sometimes there is no such
        subsequent nesting structure.  Consider workers nested within
        occupation and industry.  The same occupations appear in various
        industries and the same industries appear within various occupations.
        We can still introduce latent variables at the occupation and
        industry level.  In such cases, the model is called a
        crossed-effects model.

{pmore}
        The latent variables that we have discussed are also known
        as random effects.  Any coefficients on observed variables
        in the model are known as the fixed portion of the model.
        Models that contain fixed and random portions are known as
        mixed-effects models.

{phang}
{bf:multinomial logit regression}.
     Multinomial logit regression is a term for generalized linear response
     functions that are family multinomial, link logit.
     It is used for categorical-outcome data when the outcomes cannot be
     ordered.  Multinomial logit regression is also known as
     multinomial logistic regression and as mlogit in Stata circles.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:multiple correlation}.
	The multiple correlation is the correlation between endogenous variable
        y and its linear prediction.

{marker MIMIC}{...}
{phang}
{bf:multiple indicators and multiple causes}. 
	Multiple indicators and multiple causes
        is a kind of structural model in which observed causes determine a
        latent variable, which in turn determines multiple indicators.  See
        {manlink SEM Intro 5}.

{phang}
{marker multivariate_regression}{...}
{bf:multivariate regression}.
        Multivariate regression is a kind of structural model in which
        each member of a set of observed endogenous variables is a function
        of the same set of observed exogenous variables and a unique random
        disturbance term.  The disturbances are correlated.  Multivariate
        regression is a special case of
        {help sem glossary##SUREG:seemingly unrelated regression}.

{phang}
{bf:negative binomial regression}.
     Negative binomial regression is a term for generalized linear response
     functions that are family negative binomial, link log.
     It is used for count data that are overdispersed relative to Poisson.
     Negative binomial regression is also known as nbreg in Stata circles.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:nested-effects models}.
        See
     {it:{help sem glossary##multilevel_models:multilevel models}}.


{phang}
{marker nonrecursive_models}{...}
{bf:nonrecursive (structural) model (system)}, 
{bf:recursive (structural) model (system)}.
        A structural model (system) is said to be nonrecursive if there
        are paths in both directions between one or more pairs of endogenous
        variables.  A system is recursive if it is a system -- it has
        endogenous variables that appear with paths from them -- and it is
        not nonrecursive.

{pmore}
        A nonrecursive model may be unstable.  Consider, for instance, 

            y_1 = 2 y_2 + 1 x_1 + e_1
            y_2 = 3 y_1 - 2 x_2 + e_2

{pmore}
        This model is unstable.  To see this, without loss of generality,
        treat x_1 + e_1 and  2x_2 + e_2 as if they were both 0.  Consider
	y_1 = 1 and y_2 = 1.  Those values result in new values
	y_1 = 2 and y_2 = 3, and those result in new values
	y_1 = 6 and y_2 = 6, and those result in new values ....
	Continue in this manner, and you reach infinity for both endogenous
	variables.  In the jargon of the mathematics used to check for this
	property, the eigenvalues of the coefficient matrix lie outside the
        unit circle.

{pmore}
        On the other hand, consider these values:

            y_1 = 0.5 y_2 + 1 x_1 + e_1
            y_2 = 1.0 y_1 - 2 x_2 + e_2

{pmore}
        These results are stable in that the resulting values converge
        to y_1 = 0 and y_2 = 0.  In the jargon of the mathematics used to
        check for this property, the eigenvalues of the coefficient
        matrix lie inside the unit circle.

{pmore}
        Finally, consider the values 

            y_1 = 0.5 y_2 + 1 x_1 + e_1
            y_2 = 2.0 y_1 - 2 x_2 + e_2

{pmore}
        Start with y_1 = 1 and y_2 = 1.  That yields new values
        y_1 = 0.5, and y_2 = 2 and that yields new values y_1 = 1
        and y_2 = 1, and that yields new values y_1 = 0.5 and y_2 = 2, and
        it will oscillate forever.  In the
        jargon of the mathematics used to check for this property, the
        eigenvalues of the coefficient matrix lie on the unit circle.  These
        coefficients are also considered to be unstable.
 
{marker normality_assumption}{...}
{phang}
{bf:normality assumption, joint and conditional}.
    The derivation of the standard, linear SEM estimator usually
    assumes the full joint normality of the observed and latent variables.
    However, full joint normality can replace the assumption of normality
    conditional on the values of the exogenous variables,
    and all that is lost is one goodness-of-fit test (the test reported by
    {cmd:sem} on the output) and the justification for use of optional
    method MLMV for dealing with missing values.  This substitution of
    assumptions is important for researchers who cannot reasonably assume
    normality of the observed variables.  This includes any researcher
    including, say, variables age and age-squared in his or her model.

{pmore}
    Meanwhile, the generalized SEM makes only the conditional
    normality assumption.

{pmore}
    Be aware that even though the full joint normality assumption is
    not required for the standard linear SEM, {cmd:sem}
    calculates the log-likelihood value under that assumption.
    This is irrelevant except that log-likelihood values reported by
    {cmd:sem} cannot be compared with log-likelihood values reported
    by {cmd:gsem}, which makes the lesser assumption.

{pmore}
    See {manlink SEM Intro 4}.

{phang}
{bf:normalization constraints}.  See
      {it:{help sem glossary##identification:identification}}.

{phang}
{bf:normalized residuals}.  See
     {it:{help sem glossary##standardized_residuals:standardized residuals}}.

{phang}
{marker observed_variables}{...}
{bf:observed variables}.
         A variable is observed if it is a variable in your dataset.  In
         this documentation, we often refer to observed variables by using
         {cmd:x1}, {cmd:x2}, ..., {cmd:y1}, {cmd:y2}, and so on; in
         reality, observed variables have names such as {cmd:mpg},
         {cmd:weight}, {cmd:testscore}, and so on.

{pmore}
         In the software, observed variables are usually indicated by 
         having names that are all lowercase.

{pmore}
         Also see {it:{help sem glossary##latent_variable:latent variable}}.

{phang}
{marker OIM}{...}
{bf:OIM}, {bf:vce(oim)}.
        OIM stands for observed information matrix, defined 
        as the inverse of the negative of the matrix of second derivatives, 
        usually of the log-likelihood function.  The OIM is an
        estimate of the VCE.  OIM is the default VCE
        that {cmd:sem} and {cmd:gsem} report.  The other available techniques
        are
	{help sem_glossary##EIM:EIM},
	{help sem_glossary##OPG:OPG},
	{help sem_glossary##robust:robust},
	{help sem_glossary##cluster:cluster},
	{help sem_glossary##bootstrap:bootstrap}, and
	{help sem_glossary##jackknife:jackknife}.

{phang}
{marker OPG}{...}
{bf:OPG}, {bf:vce(opg)}.
        OPG stands for outer product of the gradients, defined as the
        cross product of the observation-level first derivatives, usually of
        the log-likelihood function.  The OPG is an estimate of the
        VCE.  The other available techniques are 
	{help sem_glossary##OIM:OIM},
	{help sem_glossary##EIM:EIM},
        {help sem_glossary##robust:robust},
	{help sem_glossary##cluster:cluster}.
	{help sem_glossary##bootstrap:bootstrap}, and
	{help sem_glossary##jackknife:jackknife}.

{phang}
{bf:ordered complementary log-log regression}.
     Ordered complementary log-log regression is a term for
     generalized linear response
     functions that are family ordinal, link clog-log.
     It is used for ordinal-outcome data.
     Ordered complementary log-log regression is also known as
     oclog-log in Stata circles.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:ordered logit regression}.
     Ordered logit regression is a term for generalized linear response
     functions that are family ordinal, link logit.
     It is used for ordinal outcome data.
     Ordered logit regression is also known as ordered logistic regression,
     as just ordered logit, and
     as ologit in Stata circles.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{bf:ordered probit regression}.
     Ordered probit regression is a term for generalized linear response
     functions that are family ordinal, link probit.
     It is used for ordinal-outcome data.
     Ordered probit regression is also known as just ordered probit and
     known as oprobit in Stata circles.  See
     {it:{help sem glossary##generalized_linear_response_functions:generalized linear response functions}}.

{phang}
{marker parameter_constraints}{...}
{bf:parameter constraints}.
         Parameter constraints are restrictions placed on the parameters
         of the model.  These constraints are typically in the form of 0 
         constraints and equality constraints.  A 0 constraint is implied,
         for instance, when no path is drawn connecting x with y.  An
	 equality constraint is specified when one path coefficient is forced
	 to be equal to another or one covariance is forced to be
	 equal to another.

{pmore}
         Also see {it:{help sem glossary##identification:identification}}.
       
{phang}
{bf:parameters}, {bf:ancillary parameters}.
        The parameters are the to-be-estimated coefficients of 
        a model.  These include all path coefficients, means, variances, and 
        covariances.  In mathematical notation, the theoretical parameters are
        often written as theta = (alpha, beta, mu,
        Sigma), where alpha is the vector of intercepts, 
        beta is the vector of path coefficients, mu is the vector
        of means, and Sigma is the matrix of variances and covariances.
        The resulting parameter estimates are written as theta hat.

{pmore}
	Ancillary parameters are extra parameters beyond the ones just
	described that concern the distribution.  These include the scale
	parameter of gamma regression, the dispersion parameter for negative
	binomial regression, and the cutpoints for ordered probit, logit, and
	clog-log regression, and the like.  These parameters are also included
	in theta.

{phang}
{marker path}{...}
{bf:path}.
        A path, typically shown as an arrow drawn from one variable to
        another, states that the first variable is determined by the second
        variable, at least partially.  If x -> y, or equivalently
        y <- x, then
        y_j = alpha + ... + beta x_j + ... + e.y_j,
        where beta is said to be the x -> y path coefficient.  The
        ellipses are included to account for paths to y from other variables.
        alpha is said to be the intercept and is automatically added when
        the first path to y is specified.

{pmore}
        A curved path is a curved line connecting two variables, and it
        specifies that the two variables are allowed to be correlated.  If
        there is no curved path between variables, the variables are usually
        assumed to be uncorrelated.  We say usually because correlation is
        assumed among all observed exogenous variables and, in the command
        language, assumed among all latent variables, and if some of the
        correlations are not desired, they must be suppressed.  Many authors
        refer to covariances rather than correlations.  Strictly speaking, the
        curved path denotes a nonzero covariance.  A correlation is often
        called a {help sem glossary##standardized_covariance:standardized covariance}.

{pmore}
        A curved path can connect a variable to itself, and in that case, it
        indicates a variance.  In path diagrams in this manual, we typically 
        do not show such variance paths even though variances are assumed.

{phang}
{bf:path coefficient}.
        The path coefficient is specified by a path; see 
       {it:{help sem glossary##path:path}}.
        Also see {it:{help sem glossary##intercept:intercept}}.

{phang}
{bf:path diagram}.
        A path diagram is a graphical representation that shows the
        relationships among a set of variables using
       {help sem glossary##path:paths}.
        See {manlink SEM Intro 2} for a description of path diagrams.

{phang}
{bf:path notation}.
        Path notation is a syntax defined by the authors of Stata's
	{cmd:sem} and {cmd:gsem} commands for entering path diagrams in a
	command language.  Models to be fit may be specified in path notation
	or they may be drawn using path diagrams into the Builder.

{phang}
{bf:Poisson regression}.
     Poisson regression is a term for generalized linear response functions
     that are family Poisson, link log.  It is used for count data.  See
	{it:{help sem_glossary##generalized_linear_response_functions:generalized_linear_response_functions}}.

{phang}
{bf:probit regression}.
     Probit regression is a term for generalized linear response functions
     that are family Bernoulli, link probit.  It is used for binary outcome
     data.  Probit  regression is also known simply as probit.  See
	{it:{help sem_glossary##generalized_linear_response_functions:generalized_linear_response_functions}}.

{phang}
{bf:p-value}.
        P-value is another term for the reported significance
        level associated with a test.  Small p-values indicate
        rejection of the null hypothesis.

{phang}
{marker QML}{...}
{bf:QML}, {bf:method(ml) vce(robust)}.
        QML stands for quasimaximum likelihood.  It is a method used to 
        obtain fitted parameters and a technique used to obtain the
        corresponding VCE.  QML is used by {cmd:sem} and {cmd:gsem}
	when options {cmd:method(ml)} and {cmd:vce(robust)} are specified.
        Other available methods are
	{help sem_glossary##ML:ML},
        {help sem glossary##MLMV:MLMV}, and
	{help sem_glossary##ADF:ADF}.
        Other available techniques are
	{help sem_glossary##OIM:OIM}, {help sem_glossary##EIM:EIM},
	{help sem_glossary##OPG:OPG},
	{help sem_glossary##cluster:cluster},
	{help sem_glossary##bootstrap:bootstrap}, and
	{help sem_glossary##jackknife:jackknife}.

{phang}
{bf:quadrature}.
	Quadrature is  generic method for performing numerical integration.
	{cmd:gsem} uses quadrature in any model including latent variables
	(excluding error variables).  {cmd:sem}, being limited to linear
	models, does not need to perform quadrature.

{phang}
{bf:random-effects models}.
	See {it:{help sem_glossary##multilevel_models:multilevel_models}}.


{phang}
{bf:regression}.
         A regression is a model in which an endogenous variable is 
         written as a function of other variables, parameters to be 
         estimated, and a random disturbance.

{phang}
{bf:reliability}.
         Reliability is the proportion of the variance of a variable not
         due to measurement error.  A variable without measure error has
         reliability 1.

{phang}
{bf:residual}.
         In this manual,  we reserve the word "residual" for the difference
         between the observed and fitted moments of an SEM.
         We use the word "error" for the disturbance 
         associated with a (Gaussian) linear equation; see
         {it:{help sem glossary##error:error}}.
         Also see
         {it:{help sem glossary##standardized_residuals:standardized residual}}.

{phang}
{marker robust}{...}
{bf:robust}, {bf:vce(robust)}.
	Robust is the name we use here for the Huber/White/sandwich 
        estimator (technique) of the VCE. 
        This technique requires fewer assumptions than most other techniques.
        In particular, it merely assumes that the errors are independently 
        distributed across observations and thus allows the errors 
        to be heteroskedastic.  Robust standard errors are reported when 
        the {cmd:sem} ({cmd:gsem}) option {cmd:vce(robust)} is specified.
        The other available techniques are
	{help sem_glossary##OIM:OIM}, {help sem_glossary##EIM:EIM},
	{help sem_glossary##OPG:OPG},
	{help sem_glossary##cluster:cluster},
	{help sem_glossary##bootstrap:bootstrap}, and
	{help sem_glossary##jackknife:jackknife}.

{phang}
{marker saturated_model}{...}
{bf:saturated model}.
	A saturated model is a full covariance model -- a model of 
        fitted means and covariances of observed variables with any 
        restrictions on the values.  Also see
        {it:{help sem glossary##baseline_model:baseline model}}.
	Saturated models apply only to standard linear SEMs.

{phang}
{marker score_tests}{...}
{bf:score tests}, {bf:Lagrange multiplier tests}.
        A score test is a test based on first derivatives of a
        likelihood function.  Score tests are especially convenient for
        testing whether constraints on parameters should be relaxed or
        parameters should be added to a model.  Also see
        {it:{help sem glossary##Wald_tests:Wald tests}}.

{phang}
{bf:scores}.
	Scores has two unrelated meanings.  First, scores
        is the observation-by-observation first-derivatives of the 
        (quasi) log-likelihood function.  When we use the word "scores", 
        this is what we mean.  Second, in the factor-analysis literature, 
        scores (usually in the context of factor scores) refers to 
        the expected value of a latent variable conditional on 
        all the observed variables.  We refer to this simply as the predicted 
        value of the latent variable.

{phang}
{bf:second-level latent variable}.  See
       {it:{help sem glossary##first_level_variables:first-, second-, and higher-order latent variables}}.

{phang}
{bf:second-order latent variable}.  See
       {it:{help sem glossary##first_order_variables:first- and second-order latent variables}}.

{phang}
{marker SUREG}{...}
{bf:seemingly unrelated regression}.
        Seemingly unrelated regression is a kind of structural model in
        which each member of a set of observed endogenous variables is a
        function of a set of observed exogenous variables and a unique random
        disturbance term.  The disturbances are correlated and the sets of
        exogenous variables may overlap.  If the sets of exogenous variables
        are identical, this is referred to as
       {help sem glossary##multivariate_regression:multivariate regression}.

{phang}
{bf:SEM}.
        SEM stands for structural equation modeling and for 
        structural equation model.  We use SEM in capital 
        letters when writing about theoretical or conceptual 
        issues as opposed to issues of the particular implementation 
        of SEM in Stata with the {cmd:sem} or {cmd:gsem} commands.

{marker sem}{...}
{phang}
{bf:sem}.
        {cmd:sem} is the Stata command that fits
	standard linear SEMs.  Also see 
       {it:{help sem glossary##gsem:gsem}}.

{marker SSD}
{phang}
{bf:SSD}, {bf:ssd}.  See
       {it:{help sem glossary##SSD:summary statistics data}}.

{phang}
{bf:standard linear SEM}.
	An SEM without multilevel effects in which all
	response variables are given by a linear equation.  Standard linear
	SEM is what most people mean when they refer to just SEM.  Standard
	linear SEMs are fit by {cmd:sem}, although they can also be
	fit by {cmd:gsem}; see
       {it:{help sem glossary##generalized_SEM:generalized SEM}}.

{phang}
{marker standardized_coefficient}{...}
{bf:standardized coefficient}.
        In a linear equation y = ... bx + ..., the standardized
        coefficient beta^* is (sigma_y hat/sigma_x hat)b.  Standardized
        coefficients are scaled to units of standard deviation change in y
        for a standard deviation change in x.

{phang}
{marker standardized_covariance}{...}
{bf:standardized covariance}.
        A standardized covariance between y and x is equal to the
        correlation of y and x, that is, it is equal to
        sigma_(xy) / sigma_x sigma_y.  The covariance is equal to the
        correlation when variables are standardized to have variance 1.

{phang}
{marker standardized_residuals}{...}
{bf:standardized residuals}, {bf:normalized residuals}.
         Standardized residuals are residuals adjusted so that they 
         follow a standard normal distribution.  The difficulty is that 
         the adjustment is not always possible.  Normalized residuals
         are residuals adjusted according to a different formula that 
         roughly follow a standard normal distribution.  Normalized residuals
         can always be calculated.

{phang}
{marker starting_values}{...}
{bf:starting values}.
        The estimation methods provided by {cmd:sem} and {cmd:gsem} are
	iterative.  The starting values are values for each of the parameters 
        to be estimated that are used to initialize the estimation process.
        The {cmd:sem} and {cmd:gsem} provide starting values automatically, 
        but in some cases, these are not good enough and you must 
        both diagnose the problem and provide better starting values.
        See {manlink SEM Intro 12}.

{phang}
{marker structural}{...}
{bf:structural equation model}.
        Different authors use the term "structural equation model" in different
        ways, but all would agree that an SEM 
        model sometimes carries the connotation of being a 
        {help sem glossary##structural_model:structural model}
        with a measurement component, that is, combined with a
        {help sem glossary##measurement_models:measurement model}.

{phang}
{marker structural_model}{...}
{bf:structural model}.
        A structural model is a model in which the parameters are not
        merely a description but are believed to be of a causal nature.
        Obviously, SEM can fit structural models and thus so can
        {cmd:sem}.  Neither SEM nor {cmd:sem} and {cmd:gsem}.
	Neither SEM, {cmd:sem}, nor {cmd:gsem} are limited to fitting
        structural models, however.

{pmore}
        Structural models often have multiple equations and dependencies
        between endogenous variables, although that is not a
        requirement.

{pmore}
        See {manlink SEM Intro 5}.  Also see
	{it:{help sem glossary##structural:structural equation model}}.

{phang}
{bf:structured (correlation or covariance)}.  See
        {it:{help sem glossary##unstructured:unstructured and structured (correlation or covariance)}}.

{phang}
{bf:substantive constraints}.
        See {it:{help sem glossary##identification:identification}}.

{phang}
{marker SSD}{...}
{bf:summary statistics data}.
        Data are sometimes 
        available only in summary statistics form, as 
        means and covariances; means, standard deviations or 
        variances, and correlations; covariances; standard deviations
        or variances and correlations; or correlations.
        SEM can be used to fit models with such data in 
        place of the underlying raw data.  The {cmd:ssd} command 
        creates datasets containing summary statistics.

{marker technique}{...}
{phang}
{bf:technique}.
        Technique is just an English word and should be read in context.
        Nonetheless, technique is usually used here to refer to the technique 
        used to calculate the estimated VCE.  Those techniques are 
	{help sem_glossary##OIM:OIM}, {help sem_glossary##EIM:EIM},
	{help sem_glossary##OPG:OPG},
        {help sem glossary##robust:robust},
	{help sem_glossary##cluster:cluster},
	{help sem_glossary##bootstrap:bootstrap}, and
	{help sem_glossary##jackknife:jackknife}.

{pmore}
        Technique is also used to refer to the available techniques used
        by {cmd:ml}, Stata's optimizer and likelihood maximizer, to
        find the solution.

{phang}
{bf:total effects}.  See
       {it:{help sem glossary##direct:direct, indirect, and total effects}}.

{phang}
{bf:unstandardized coefficient}.
	A coefficient that is not standardized.  If
        {cmd:mpg} = -0.006 x {cmd:weight} + 39.44028,
        then -0.006 is an
	unstandardized coefficient and, as a matter of fact, is measured in
        mpg-per-pound units.

{phang}
{marker unstructured}{...}
{bf:unstructured and structured (correlation or covariance)}.
        A set of variables, typically error variables, is said to have an
        unstructured correlation or covariance if the covariance matrix has
        no particular pattern imposed by theory.  If a pattern is imposed, 
        the correlation or covariance is said to be structured.

{marker VCE}{...}
{phang}
{bf:variance-covariance matrix of the estimator}.
        The estimator is the formula used to solve for the fitted
        parameters, sometimes called the fitted coefficients.  The VCE
        is the estimated variance-covariance matrix of the parameters.
        The diagonal elements of the VCE are the variances of the
        parameters; the square roots of those elements
        are the reported standard errors of the parameters.

{phang}
{bf:VCE}.  See
       {it:{help sem glossary##VCE:variance-covariance matrix of the estimator}}.

{phang}
{marker Wald_tests}{...}
{bf:Wald tests}.  A Wald test is a statistical test based on the
estimated variance-covariance matrix of the parameters.  Wald tests are
especially convenient for testing possible constraints to be placed on
the estimated parameters of a model.  Also see 
{it:{help sem glossary##score_tests:score tests}}.

{marker WLS}{...}
{phang}
{bf:weighted least squares}.
        Weighted least squares (WLS) is a method used to obtain fitted
        parameters.  In this documentation, WLS is referred to as
        {help sem glossary##ADF:ADF}, which stands for asymptotic distribution
	free.  Other available methods are 
	{help sem_glossary##ML:ML}, {help sem_glossary##QML:QML}, and
	{help sem_glossary##MLMV:MLMV}.
        ADF is, in fact, a specific kind of the more generic WLS.

{phang}
{bf:WLS}.
        See {it:{help sem glossary##WLS:weighted least squares}}.
{p_end}


{marker reference}{...}
{title:Reference}

{marker Bentler1980}{...}
{phang}
Bentler, P. M., and D. G. Weeks. 1980.  Linear structural equations with latent
variables.  {it:Psychometrika} 45: 289-308.
{p_end}
