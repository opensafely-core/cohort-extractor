{smcl}
{* *! version 1.0.6  22may2019}{...}
{vieweralsosee "[ERM] Glossary" "mansection ERM Glossary"}{...}
{viewerjumpto "Description" "erm_glossary##description"}{...}
{viewerjumpto "Glossary" "erm_glossary##glossary"}{...}
{viewerjumpto "References" "erm_glossary##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[ERM] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection ERM Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{marker average_structural_function}{...}
{phang}
{bf:average structural function}.
        The average structural function (ASF) is used to calculate 
        predicted values of ERMs. 

{pmore}
        The ASF averages out the heterogeneity caused by the
        endogeneity from a conditional mean or a conditional
        probability in a model with endogenous covariates. Applying the
        ASF to a conditional mean produces an average
        structural mean (ASM). Applying the ASF to a
        conditional probability produces an average structural
        probability (ASP).  Contrasts of ASMs or ASPs produced by a
	covariate change define a causal structural effect.
	Blundell and Powell ({help erm_glossary##BP2003:2003},
	{help erm_glossary##BP2004:2004})
	and Wooldridge ({help erm_glossary##W2005:2005},
	{help erm_glossary##W2014:2014})
         are seminal papers that define and extend the ASF. See
        Wooldridge ({help erm_glossary##W2010:2010}, 22-24)
	for a textbook introduction.

{phang}
{bf:average structural mean}.
        The average structural mean (ASM) is the result of
        applying the 
	{help erm_glossary##average_structural_function:average structural function}
	to a conditional mean.

{phang}
{bf:average structural probability}.
        The average structural probability (ASP) is the result
        of applying the
	{help erm_glossary##average_structural_function:average structural function}
	to a conditional probability.

{phang}
{bf:average treatment effect}.
   See {help erm_glossary##treatment_effects:{it:treatment effects}}.

{marker ATET}{...}
{phang}
{bf:average treatment effect on the treated}.
        See {help erm_glossary##treatment_effects:{it:treatment effects}}.

{phang}
{bf:average treatment effect on the untreated}.
        See {help erm_glossary##treatment_effects:{it:treatment effects}}.

{marker binary_variable}{...}
{phang}
{bf:binary variable}.
        A binary variable is any variable that records two values, the
        two values representing false and true, such as whether a
        person is sick.  We usually speak of the two values as being 0
        and 1 with 1 meaning true, but Stata requires merely that 0
        means false and nonzero and nonmissing mean true.  Also see
        {help erm_glossary##continuous_variable:{it:continuous variable}},
        {help erm_glossary##categorical_variable:{it:categorical variable}}, and
        {help erm_glossary##interval_variable:{it:interval variable}}.

{marker categorical_variable}{...}
{phang}
{bf:categorical variable}.
         A categorical variable is a variable that records the category 
         number for, say, lives in the United States, lives in Europe, and lives
         in Asia.  Categorical variables play no special role in this
         manual, but
	 {help erm_glossary##ordered_categorical_variable:ordered categorical variables} do.  The
	 example given is unordered.  The categories United States, Europe,
	 and Asia have no natural ordering.  We listed the United States first
	 only because the author of this manual happens to live in the United
	 States.

{pmore}
         The way we use the term, categorical variables usually record
         two or more categories, and the term binary variable is used
         for categorical variables having two categories.

{pmore}
         We usually speak of categorical variables as if they take 
         on the values 1, 2, ....  Stata does not require 
         that.  However, the values do need to be integers. 

{marker censored}{...}
{phang}
{bf:censored}, {bf:left-censored}, {bf:right-censored}, and
{bf:interval-censored}.
        Censoring involves not observing something but knowing when 
        and where you do not observe it. 

{pmore}
	For instance, sometimes patients, subjects, or units being studied --
	observations in your dataset -- have values equal to missing.
	Such observations are said to be censored when there is a reason they
	are missing.  A variable is missing because a potential worker chooses
	not to work, because a potential patient chooses not to be a patient,
	because a potential subject was not prescribed the treatment, etc.
	Such censored outcomes cause difficulty when there is an unobserved
	component to the reason they are censored that is correlated with the
	outcome being studied.  ERM option {cmd:select()} addresses these
	issues.

{pmore}
	Another type of censoring -- interval-censoring -- involves not
	observing a value precisely but knowing its range.  You do not observe
	blood pressure, but you know it is in the range 120 to 140.  Or you
	know it is less than 120 or greater than 160.  ERM command
	{cmd:eintreg} fits models in which the dependent variable is
	interval-censored.

{pmore}
        Left-censoring is open-ended interval-censoring in which
        measurements below a certain value are unobserved.  Blood
        pressure is less than 120.

{pmore}
        Right-censoring is open-ended interval-censoring in which 
        measurements above a certain value are unobserved.
        Blood pressure is above 160. 
    
{phang}
{bf:conditional mean}.
        The conditional mean of a variable is the expected value based
        on a function of other variables.  If y is a linear
        function of x_1 and x_2 -- y = beta_0 + beta_1x_1 +
        beta_2x_2 + noise -- then the conditional mean of
        y for x_1 = 2 and x_2 = 4 is beta_0 + 2beta_1 + 4beta_2.

{phang}
{bf:confounding variable, confounder}.
	A confounding variable is an omitted explanatory variable in a  
        model that is correlated with variables included in the model.
        The fitted coefficients on the observed variables will include 
        the effect of the variables, as intended, plus the effect of
        being correlated with the omitted variable.  

{pmore}
        Confounders are often omitted from the model because they are 
        unobserved.   See {manlink ERM Intro 3}.

{marker continuous_variable}{...}
{phang}
{bf:continuous variable}.
        A continuous variable is a variable taking on any value on the
        number line.  In this manual, however, we use the term to mean
        the variable is not a
	{help erm_glossary##binary_variable:binary variable}, not a 
        {help erm_glossary##categorical_variable:categorical variable},
	and not an 
        {help erm_glossary##interval_variable:interval variable}.

{phang}
{bf:counterfactual}.
	The result that would be expected from a thought experiment 
        that assumes things counter to what are currently true. 
        What would be the average income if everyone had one more year 
        of schooling? What would be the effect of an experimental medical 
        treatment if the treatment were made widely available?
        Stata's {cmd:margins} command produces statistical answers to 
        these kinds of thought experiments and reports standard errors
        as well.

{phang}
{bf:counterfactual predictions}.
	Counterfactual predictions are used when you have endogenous
	covariates in your main equation and you wish to estimate
	either counterfactuals or the effect on the outcome of
	changing the values of covariates.  They are obtained
	using {cmd:predict} options {cmd:base()} and {cmd:fix()}.

{marker covariate}{...}
{phang}
{bf:covariate}.
        A covariate is a variable appearing on the right-hand side
        (RHS) of a model.  Covariates can be exogenous or
        endogenous, but when the term is used without qualification, it
        usually means exogenous covariate.  Covariates are also known as
        explanatory variables.  Also see
	{help erm_glossary##endogenous_covariate:{it:endogenous covariate}}
        and
	{help erm_glossary##exogenous_covariate:{it:exogenous covariate}}.

{marker dependent_variable}{...}
{phang}
{bf:dependent variable}.
        A dependent variable is a variable appearing on the left-hand
	side of an equation in a model.  It is the variable to
        be explained.  Every equation of a model has a dependent
        variable.  The term "the dependent variable" is often used in
        this manual to refer to the dependent variable of the
        {help erm_glossary##main_equation:main equation}.
	Also see {manlink ERM Intro 3}.

{phang}
{bf:endogenous and exogenous treatment assignment}.
	See {help erm_glossary##treatment_assignment:{it:treatment assignment}}.

{marker endogenous_covariate}{...}
{phang}
{bf:endogenous covariate}.
        An endogenous covariate is a
	{help erm_glossary##covariate:covariate} appearing in a
        model 1) that is correlated with omitted variables that also
        affect the outcome; 2) that is measured with error; 3) that is
        affected by the dependent variable; or 4) that is correlated with the
        model's error.  See {manlink ERM Intro 3}.

{marker endogenous_sample_selection}{...}
{phang}
{bf:endogenous sample selection}.
        Endogenous sample selection refers to situations in which the
        subset of the data used to fit a model has been selected in a
        way correlated with the model's outcome.  

{pmore}
        Mechanically, the subset used is the subset containing
        nonmissing values of variables used by the model.  A variable
        is unobserved -- contains missing values -- because a potential
        worker chooses not to work, because a potential patient chooses
        not to be a patient, because a potential subject was not
        prescribed the treatment, etc.  Such censored outcomes cause
        difficulty when there is an unobserved component to the reason
        they are censored that is correlated with the outcome being
        studied.  

{pmore}
        ERM option {cmd:select()} can address these issues 
        when the dataset contains observations for which the 
        dependent variable  was missing. 

{phang}
{bf:error}.
	Error is the random component (residual) appearing
        at the end of the equations in a model.  These errors account for 
        the unobserved information explaining the outcome variable.
        Errors in this manual are written as e.{it:depvarname},
        such as y = beta_0 + beta_1x_1 + beta_2x_2 + e.y.

{marker exogenous_covariate}{...}
{phang}
{bf:exogenous covariate}.
        An exogenous covariate is a 
	{help erm_glossary##covariate:covariate} that is
        uncorrelated with the error term in the model.  See
	{manlink ERM Intro 3}.

{phang}
{bf:explanatory variable}.
	Explanatory variable is another word for
	{help erm_glossary##covariate:covariate}.

{phang}
{bf:extended regression models}.
         Extended regression models (ERMs) are generalized structural
         equation models that allow identity and probit links and Gaussian,
         binomial, and ordinal families for the main outcome. They extend
         interval regression, ordered probit, probit, and linear regression
         models by accommodating endogenous covariates, nonrandom and
         endogenous treatment assignment, and endogenous sample selection.

{phang}
{bf:individual-level treatment effect}. 
        An individual-level
	{help erm_glossary##treatment_effects:treatment effect}
	is the difference
        in the individual’s outcome that would occur when given one
        treatment instead of another.  It is the difference between two
        potential outcomes for the individual.  The blood pressure
        after taking a pill minus the blood pressure were the pill not
        taken is the individual-level treatment effect of the pill on
        blood pressure.

{phang}
{bf:informative missingness}.
        See {help erm_glossary##missingness:{it:missingness}}. 

{marker instrument}{...}
{phang}
{bf:instrument}.
	Instrument is an informal word for
	{help erm_glossary##instrumental_variable:instrumental variable}.
        
{marker instrumental_variable}{...}
{phang}
{bf:instrumental variable}.
        An instrumental variable is a variable that affects an 
        {helpb erm_glossary##endogenous_covariate:endogenous covariate}
	but does not affect the 
        {help erm_glossary##dependent_variable:dependent variable}.
	See {manlink ERM Intro 3}.

{phang}
{bf:interval measurement}.
        Interval measurement is a synonym for interval-censored. 
	See {help erm_glossary##censored:{it:censored}}.
       
{marker interval_variable}{...}
{phang}
{bf:interval variable}.
        An interval variable is actually a pair of variables that record
        the lower and upper bounds for a variable whose
        precise values are unobserved.  {cmd:ylb} and {cmd:yub}
        might record such values for a variable y.  Then it
        is known that, for each observation i, {cmd:ylb}_i {ul:<}
        y {ul:<} {cmd:yub}_i.  ERM estimation command {cmd:eintreg}
	fits such models.  Also see
	{help erm_glossary##censored:{it:censored}}.

{phang}
{bf:interval-censored}.
	See {help erm_glossary##censored:{it:censored}}.

{phang}
{bf:left-hand-side (LHS) variable}.
        A left-hand-side variable is another word for 
      {help erm_glossary##dependent_variable:dependent variable}.  

{phang}
{bf:loss to follow-up}.
     Subjects are lost to follow-up if they do not complete the course of the
     study for reasons unrelated to the event of interest.  For example, loss
     to follow-up occurs if subjects move to a different area or decide to no
     longer participate in a study.  Loss to follow-up should not be confused
     with administrative censoring.  If subjects are lost to follow-up, the
     information about the outcome these subjects would have experienced at the
     end of the study, had they completed the study, is unavailable.

{marker main_equation}{...}
{phang}
{bf:main equation}.
       The main equation in an ERM is the first equation
       specified, the equation appearing directly after the {cmd:eregress},
       {cmd:eintreg}, {cmd:eprobit}, or {cmd:eoprobit}
       command.  The purpose of ERMs is to produce valid
       estimates of the coefficients in the main equation, meaning the
       structural coefficients, in the presence of complications such
       as endogeneity, selection, or treatment assignment.

{phang}
{bf:measurement error, measured with error}.
        A variable measured with error has recorded value 
        equal to x + epsilon, where x is the true value.
        The error is presumably uncorrelated with all other errors 
        in the model.  In that case, fitted coefficients will be 
        biased toward zero.  See {manlink ERM Intro 3}.

{phang}
{bf:missing at random (MAR)}.
        See {help erm_glossary##missingness:{it:missingness}}.

{phang}
{bf:missing completely at random (MCAR)}.
	See {help erm_glossary##missingness:{it:missingness}}.

{phang}
{bf:missing not at random (MNAR)}.
        See {help erm_glossary##missingness:{it:missingness}}.

{marker missingness}{...}
{phang}
{bf:missingness}.
        Missingness refers to how missing observations in data occur.
        The categories are {bind:1) missing} not at random (MNAR),
	{bind:2) missing} at random (MAR), and {bind:3) missing}
        completely at random (MCAR).

{pmore}
        In what follows we will refer to missing observations to mean 
        not only observations entirely missing from a dataset but also
        the omitted observations because of missing values when
        fitting models.

{pmore}
        MNAR observations refer to cases in which 
        the missingness depends on the outcome under study. 
        The solution in this case is to model that dependency.
        When observations are missing because of missing values, 
        ERM option {cmd:select()} can be used to model the 
        missingness.

{pmore}
        MAR observation refer to cases in which 
        the missingness does not depend on the outcome under study
        but does depend on other variables correlated with the outcome.
        The solution for some of the problems raised is to include
        those other variables as covariates in your model.
        Importantly, you do not need to model the reason for
        missingness.

{pmore}
        MCAR observations are just that and
        obviously not a problem other than to cause loss of efficiency.

{pmore}
        The MNAR and MAR cases are known jointly 
        as informative missingness.

{phang}
{bf:multivalued treatment}.
	A multivalued treatment is a treatment with more than two arms.
        See {help erm_glossary##treatment_arms:{it:treatment arms}}. 

{phang}
{bf:observational data}.
	Observational data are data collected over which the 
        researcher had no control.  The opposite of observational 
        data is experimental data.  Use of observational data often
        introduces statistical issues that experimental data would not. 
        For instance, in a treatment study based on observational data, 
        researchers had no control over treatment assignment; thus 
        the treatment assignment needs to be modeled. 

{phang}
{bf:omitted variables}.
        Omitted variables is an informal term for
	{help erm_glossary##covariate:covariates}
        that should appear in the model but do not.  They do not
        because they are unmeasured, because of ignorance or other
        reasons.  Problems arise when the variables that are not
        omitted are correlated with the omitted variables.

{marker ordered_categorical_variable}{...}
{phang}
{bf:ordered categorical variable}.
        An ordered categorical variable is a 
        {help erm_glossary##categorical_variable:categorical variable}
        in which the categories can be ordered, such as 
        healthy, sick, and very sick.  Actually recorded in the 
        variable are integers such as 1, 2, and 3.  
        The integers need not be sequential, but they must reflect the ordering.

{pmore}
        Also see {help erm_glossary##binary_variable:{it:binary variable}} and 
        {help erm_glossary##continuous_variable:{it:continuous variable}}.

{phang}
{bf:outcome variable}.
        See {help erm_glossary##dependent_variable:{it:dependent variable}}.

{marker potential_outcome}{...}
{phang}
{bf:potential outcome}.
     Potential outcome is a term used in the treatment-effects
     literature.  It is the outcome an individual would have had if
     given a specific treatment.  Individual in this case means
     conditional on the individual's covariates, which are
     in the main equation in models fit by ERMs.  It is the
     outcome that would have been observed for that individual.  For
     instance, each patient in a study has one potential blood pressure
     after taking a pill and another had he or she not taken it.
     Also see {help erm_glossary##treatment_effects:{it:treatment effects}}.

{marker potential_outcome_means}{...}
{phang}
{bf:potential-outcome means}.
     Potential-outcome means (POMs) is a term used in the
     treatment-effects literature.  They are the means (averages) of
     {help erm_glossary##potential_outcome:potential outcomes}.
     The average treatment effect (see
     {help erm_glossary##treatment_effects:{it:treatment effects}})
     is the difference between the potential-outcome mean for treated and
     untreated over the population.

{marker recursive_structural_model}{...}
{phang}
{bf:recursive (structural) model}.
      ERMs fit recursive models.  A model is not
      recursive when one endogenous variable depends (includes
      its equation) on another endogenous variable that depends on the
      first.  Said in symbols, when A depends on B, which
      depends on A.  A model is also not recursive when A
      depends on B depends on C, which depends on A,
      and so on.  See {manlink ERM Triangularize}.
    
{phang}
{bf:reverse causation and simultaneous causation}.
      We use the term reverse causation in this manual when the
      {help erm_glossary##dependent_variable:dependent variable}
      in the main equation of an ERM
      affects a {help erm_glossary##covariate:covariate} as well as
      when the covariate affects the
      dependent variable.  Stressed persons may be physically unhealthy
      because they are stressed and further stressed because they are
      unhealthy.  When a covariate suffers from reverse causation, the
      solution is to make it endogenous and find
      {help erm_glossary##instrument:instruments} for it.

{pmore}
      Our use of the term reverse causation is typical of how it is
      used elsewhere.  Reverse causation is a reason to make a variable
      endogenous.  Reverse causation is discussed in {manlink ERM Intro 3}.

{pmore}
      The term simultaneous causation is sometimes used as a synonym for
      reverse causation elsewhere, but we draw a distinction.  We use
      the term when two already endogenous variables affect each other.
      Simultaneous causation is discussed in {manlink ERM Triangularize}. 

{phang}
{bf:right-hand-side (RHS) variable}.
        A right-hand-side variable is another word for
	{help erm_glossary##covariate:covariate}. 

{phang}
{bf:sample selection}.
        Sample selection is another term for 
        {help erm_glossary##endogenous_sample_selection:endogenous sample selection}.

{phang}
{bf:selection}.
	Selection is another term for
	{help erm_glossary##endogenous_sample_selection:endogenous sample selection}.

{phang}
{bf:selection on unobservables}.
        Selection on unobservables is another term for 
        {help erm_glossary##endogenous_sample_selection:endogenous sample selection}.

{phang}
{bf:simultaneous causation}.
        See {help erm_glossary##recursive_structural_model:{it:recursive (structural) model}}.

{phang}
{bf:simultaneous system}.
        A simultaneous system is a multiple-equation model in which 
        dependent variables can affect each other freely.  The
        equation for {cmd:y1} could include {cmd:y2}, and the equation
        for {cmd:y2} include {cmd:y1}.  ERMs cannot fit
        simultaneous systems.  Because the focus of ERMs is on
        one equation in particular -- the main equation -- you can
        substitute the covariates for {cmd:y1} into the {cmd:y2}
        equation to form the reduced-form result and still obtain
        estimates of the structural parameters of the {cmd:y1}
        equation.  In this manual, we discuss this issue using the terms
        reverse causation and
	{help erm_glossary##recursive_structural_model:recursive (structural) model}.
        In the manual, it is discussed in {manlink ERM Triangularize}.

{phang}
{bf:TE}.
	See {help erm_glossary##treatment_effects:{it:treatment effect}}.

{phang}
{bf:tobit estimator}.
        Tobit is an estimation technique for dealing with
        dependent variables that are censored.  The classic tobit model
        dealt with left-censoring, in which the outcome variable was
        recorded as zero if it would have been zero or below.  The
        estimator has since been generalized to dealing with models in
        which observations can be left-censored, right-censored, or
        interval-censored.  See
	{help erm_glossary##censored:{it:censored}}.

{marker treatment}{...}
{phang}
{bf:treatment}.
	A treatment is a drug, government program, or anything else 
        administered to a patient, job seeker, etc., in hopes of 
        improving an outcome.

{marker treatment_arms}{...}
{phang}
{bf:treatment arms}.
        Sometimes, experiments are run on more than one 
	{help erm_glossary##treatment:treatment}
        simultaneously.  Each different treatment is called an arm 
        of the treatment.  The controls (those not treated) are also 
        an arm of the treatment. 

{marker treatment_assignment}{...}
{phang}
{bf:treatment assignment}.
        Treatment assignment is the process by which subjects are 
        assigned to a {help erm_glossary##treatment_arms:treatment arm}.
	That process can be 
        endogenous or exogenous, meaning that the random component 
        (error) in the assignment is correlated or is not correlated
        with the outcomes of the treatments.  It is often endogenous 
        because doctors assign subjects or subjects choose based 
        in part on unobserved factors correlated with the treatment's 
        outcome. 

{marker treatment_effects}{...}
{phang}
{bf:treatment effects}.
        A treatment effect (TE) is the effect of a treatment in
        terms of a measured outcome such as blood pressure, ability to
        walk, likelihood of finding employment, etc.  The statistical
        problem is to measure the effect of a treatment in the presence
        of complications such as censoring, treatment assignment, and
        so on. 

{pmore}
        ERMs fit treatment-effect models when one of the
        options {cmd:entreat()} or {cmd:extreat()} is specified for
        endogenous or exogenous treatment assignment.  Meanwhile, the
        outcome model is specified in the main equation.  

{pmore}
        The TE is, for each person,
        the difference in the predicted outcomes based on the
        covariates in the main equation given that treatment is locked
        at treated or untreated.  

{pmore}
        The treatment effect on the treated (TET) is,
        for each person who was treated, the difference in the
        predicted outcomes based on the covariates in the main equation
        and the fact that they were assigned to or choose to be
        treated.

{pmore}
        The treatment effect on the untreated (TEU) is,
        for each person who was not treated, the difference in predicted
        outcomes based on the covariates in the main equation and the
        fact that they were assigned to or choose not to be treated.

{pmore}
        The average treatment effect (ATE) is an estimate
        of the average effect in a population after accounting for
        statistical issues.

{pmore}
        The average effect on the treated (ATET) is
        an estimate of the average effect that would have been observed
        for those who were in fact treated in the data.

{pmore}
        The average effect on the untreated (ATEU) is
        an estimate of the average effect that would have been observed
        for those who were in fact not treated in the data.

{phang}
{bf:triangular system}.
      See {help erm_glossary##recursive_structural_model:{it:recursive (structural) model}}.


{marker references}{...}
{title:References}

{marker BP2003}{...}
{phang}
Blundell, R. W., and J. L. Powell. 2003. Endogeneity in nonparametric and
semiparametric regression models. In
{it:Advances in Economics and Econometrics: Theory and Applications, Eighth World Congress},
ed. M. Dewatripont, L. P. Hansen, and S. J. Turnovsky, vol. 2, 312-357.
Cambridge: Cambridge University Press.

{marker BP2004}{...}
{phang}
------. 2004. Endogeneity in semiparametric binary response models.
{it:Review of Economic Studies} 71: 655-679.

{marker W2005}{...}
{phang}
Wooldridge, J. M. 2005. Unobserved heterogeneity and estimation of average
partial effects. In
{it:Identification and Inference for Econometric Models: Essays in Honor of Thomas Rothenberg},
ed. D.  W. K. Andrews and J. H. Stock, 27-55.
New York: Cambridge University Press.

{marker W2010}{...}
{phang}
------. 2010.
{browse "http://www.stata.com/bookstore/cspd.html":{it:Econometric Analysis of Cross Section and Panel Data}}. 2nd ed.
Cambridge, MA: MIT Press.

{marker W2014}{...}
{phang}
------. 2014. Quasi-maximum likelihood estimation and testing for nonlinear
models with endogenous explanatory variables.
{it:Journal of Econometrics} 182: 226-234.
{p_end}
