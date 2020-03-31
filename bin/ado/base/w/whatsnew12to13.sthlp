{smcl}
{* *! version 1.2.6  29jan2020}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{title:What's new in release 13.0 (compared with release 12)}

{pstd}
This file lists the changes corresponding to the creation of Stata
release 13.0:

    {c TLC}{hline 63}{c TRC}
    {c |} help file        contents                     years           {c |}
    {c LT}{hline 63}{c RT}
    {c |} {help whatsnew16}       Stata 16.0 and 16.1          2019 to present {c |}
    {c |} {help whatsnew15to16}   Stata 16.0 new release       2019            {c |}
    {c |} {help whatsnew15}       Stata 15.0 and 15.1          2017 to 2019    {c |}
    {c |} {help whatsnew14to15}   Stata 15.0 new release       2017            {c |}
    {c |} {help whatsnew14}       Stata 14.0, 14.1, and 14.2   2015 to 2017    {c |}
    {c |} {help whatsnew13to14}   Stata 14.0 new release       2015            {c |}
    {c |} {help whatsnew13}       Stata 13.0 and 13.1          2013 to 2015    {c |}
    {c |} {bf:this file}        Stata 13.0 new release       2013            {c |}
    {c |} {help whatsnew12}       Stata 12.0 and 12.1          2011 to 2013    {c |}
    {c |} {help whatsnew11to12}   Stata 12.0 new release       2011            {c |}
    {c |} {help whatsnew11}       Stata 11.0, 11.1, and 11.2   2009 to 2011    {c |}
    {c |} {help whatsnew10to11}   Stata 11.0 new release       2009            {c |}
    {c |} {help whatsnew10}       Stata 10.0 and 10.1          2007 to 2009    {c |}
    {c |} {help whatsnew9to10}    Stata 10.0 new release       2007            {c |}
    {c |} {help whatsnew9}        Stata  9.0, 9.1, and 9.2     2005 to 2007    {c |}
    {c |} {help whatsnew8to9}     Stata  9.0 new release       2005            {c |}
    {c |} {help whatsnew8}        Stata  8.0, 8.1, and 8.2     2003 to 2005    {c |}
    {c |} {help whatsnew7to8}     Stata  8.0 new release       2003            {c |}
    {c |} {help whatsnew7}        Stata  7.0                   2001 to 2002    {c |}
    {c |} {help whatsnew6to7}     Stata  7.0 new release       2000            {c |}
    {c |} {help whatsnew6}        Stata  6.0                   1999 to 2000    {c |}
    {c BLC}{hline 63}{c BRC}
{hline}

{pstd}
Most recent changes are listed first.


{hline 3} {hi:more recent updates} {hline}

{pstd}
See {help whatsnew13}.


{hline 3} {hi:Stata 13.0 release 17jun2013} {hline}

{title:Remarks}

{pstd}
We will list all the changes, item by item, but first, here are the highlights.


{marker highlights}{...}
    {title:What's new (highlights)}

{pstd}
Here are the highlights.  There are more, and do not assume that because 
we mention a category, we have mentioned everything new in the category.
Detailed sections follow the highlights.

{marker WnStrls}{...}
{phang2}
1.  {bf:Long strings/BLOBs}.{break}
    The maximum length of string variables increases from 244 to 2,000,000,000
    characters.  The standard string storage types {cmd:str1}, {cmd:str2},
    ..., {cmd:str244} now continue to {cmd:str2045}, and after that
    comes {cmd:strL}, pronounced sturl.  All of Stata's string
    functions work with two-billion-character-long strings, as do the
    rest of Stata's features, including importing, exporting, and 
    ODBC.  {cmd:strL} variables can contain binary strings.  New
    functions,
     {helpb whatsnew12to13##fileread():fileread()}
    and
     {helpb whatsnew12to13##filewrite():filewrite()},
    make it easy to read and write entire files to and from {cmd:strL}s.

{pmore2}
    See {findalias frstr}.

{pmore2}
    (BLOB stands for binary large object, jargon used by database 
    programmers.)

{marker WnTreatmentEffects}{...}
{phang2}
2.  {bf:Treatment effects.}{break}
    A new suite of features allows you to estimate average treatment
    effects (ATE), average treatment effects on the treated
    (ATET), and potential-outcome means (POMs).  Binary,
    multilevel, and multivalued treatments are supported.  You can model
    outcomes that are continuous, binary, count, or nonnegative.

{pmore2}
    Treatment-effects estimators measure the causal effect of
    treatment on an outcome in observational data.

{pmore2}
    Different treatment-effects estimators are provided for different
    situations.

{pmore2}
    When you know the determinants of participation (but not the
    determinants of outcome), inverse-probability weights (IPW) and
    propensity-score matching are provided.

{pmore2}
    When you know the determinants of outcome (but not the determinants
    of participation), regression adjustment and covariate matching
    are provided.

{pmore2}
    When you know the determinants of both, the doubly robust methods
    augmented IPW and IPW with regression adjustment are
    provided.  These methods are doubly robust because you need to be right
    about only the specification of outcome, or of participation.

{pmore2}
    Also provided are two estimators that do not require conditional
    independence.  Conditional independence means that the treatment
    and observed outcome are uncorrelated conditional on observed
    covariates.  Put another way, conditional independence implies
    selection on observables.  New estimation commands {cmd:etregress}
    and {cmd:etpoisson} relax the assumption.  ({cmd:etregress} is an
    updated form of old command {cmd:treatreg}; {cmd:etpoisson} is
    new.)

{pmore2}
    See the all-new
    {mansection TE teTreatmentEffects:{it:Stata Treatment-Effects Reference Manual}},
    and in particular, see {helpb teffects intro:[TE] teffects intro}.

{pmore2}
    By the way, if treatment effects interest you, also see
    {findalias gsemtreat}, where we use {cmd:gsem} -- another new
    feature of Stata 13 -- to fit an endogenous treatment-effects model that
    can be modified to allow for generalized linear outcomes and multilevel
    effects.

{marker WnGsem}{...}
{phang2}
3.  {bf:Multilevel mixed effects and generalized linear structural equation modeling (SEM).}{break}
    In addition to standard linear SEMs, Stata now provides what we
    are calling generalized SEMs for short.  
    Generalized SEMs allow for generalized linear response 
    functions and allow for multilevel mixed effects.

{pmore2}
    Generalized linear response functions include binary outcomes
    (probit, logit, cloglog), count outcomes (Poisson, negative binomial),
    categorical outcomes (multinomial logit), ordered outcomes (ordered
    probit, ordered logit, ordered cloglog), and more, which is to say,
    generalized linear models (GLMs).  

{pmore2}
    Multilevel mixed effects include nested random effects such as effects
    within patient within doctor within hospital and crossed random effects.
    Multilevel mixed effects also include random intercepts and random
    slopes.

{pmore2}
    In the language of SEM, "multilevel mixed effects" means
    latent variables at different levels of the data.  This means
    Stata 13 can fit multilevel measurement models and multilevel
    structural equation models.

{pmore2}
    See {manlink SEM Intro 1}.

{pmore2}
    Economists:  See {findalias gsemsel}, where we show how to 
    use Stata 13's new SEM features to fit the Heckman selection
    model, which can be extended to generalized linear outcomes and random
    effects and random slopes.

{marker WnMestar}{...}
{phang2}
4.  {bf:New multilevel mixed-effects models.}{break}
    Multilevel mixed-effects estimation has been improved and expanded and is
    now the subject of its own manual.  Stata had 3 multilevel 
    estimation commands; now it has 11.

{pmore2}
    The eight new multilevel mixed-effects estimation commands are

                {helpb melogit}     logistic regression
                {helpb meprobit}    probit regression
                {helpb mecloglog}   complementary log-log regression
                {helpb meologit}    ordered logistic regression
                {helpb meoprobit}   ordered probit regression
                {helpb mepoisson}   Poisson regression
                {helpb menbreg}     negative binomial regression
                {helpb meglm}       generalized linear models

{pmore2}
    These new estimation commands allow for constraints on variance
    components, provide robust and cluster-robust standard errors, and
    are fast.

{pmore2}
    The three existing multilevel estimation commands have
    been renamed:  {cmd:xtmixed} is now
    {helpb mixed}, {cmd:xtmelogit} is now
    {helpb meqrlogit}, and {cmd:xtmepoisson} is now
    {helpb meqrpoisson}.  All three now present
    results by default in the variance metric rather than the
    standard deviation metric.

{pmore2}
    As we said, multilevel mixed-effects modeling is now the subject of
    its own manual.  See 
    {mansection ME me:{it:Stata Multilevel Mixed-Effects Reference Manual}},
    and in particular, see {helpb me:[ME] me}.

{marker WnForecast}{...}
{phang2}
5.  {bf:Forecasts based on systems of equations.}{break}
    Stata's new {cmd:forecast} command allows you to combine estimation
    results from multiple Stata commands or other sources to produce
    dynamic or static forecasts and produce forecast intervals.  

{pmore2}
    You begin by fitting the equations of your model using Stata's
    estimation commands, or you can enter results that you obtained
    elsewhere.  Then you use {cmd:forecast} to specify identities and 
    exogenous variables to obtain a baseline forecast. 
    Once you produce the baseline forecast, you can specify alternative 
    paths for some variables and obtain forecasts based on those
    alternative paths.  Thus you can produce forecasts under
    alternative scenarios and explore impacts of differing policies.

{pmore2}
    You can use {cmd:forecast}, for example, to produce macroeconomic 
    forecasts.

{pmore2}
    In addition, {cmd:forecast} is particularly easy to use because
    {cmd:forecast} also provides an intuitive, interactive control panel to
    guide you and, if you do something wrong, {cmd:forecast} itself offers
    advice on how to fix the problem.

{pmore2}
    See {helpb forecast:[TS] forecast}.

{marker WnPSS}{...}
{phang2}
6.  {bf:Power and sample size.}{break}
    The new {cmd:power} command performs power and sample-size analysis. 
    Included are 

                Comparison of a mean to a reference value
                Comparison of a proportion to a reference value
                Comparison of a variance to a reference value
                Comparison of a correlation to a reference value

                Comparison of two independent means
                Comparison of two independent proportions
                Comparison of two independent variances
                Comparison of two independent correlations

                Comparison of two paired means
                Comparison of two paired proportions

{pmore2}
    Results can be displayed in customizable tables and graphs.

{pmore2}
    An integrated GUI lets you select your analysis type, input
    assumptions, and obtain desired results. 

{pmore2}
    Power and sample size is the subject of its own manual. 
    See {it:Stata Power and Sample-Size Reference Manual};
    start by seeing {bf:[PSS] Intro}.

{marker WnXtstar}{...}
{phang2}
7.  {bf:New and extended panel-data estimators.}{break}
    Two new random-effects panel-data estimation commands are added:

                {helpb xtoprobit}   ordered probit regression
                {helpb xtologit}    ordered logistic regression

{pmore2}
    These new commands allow for cluster-robust standard errors.

{pmore2}
    The following previously existing random-effects panel-data estimation
    commands now allow for cluster-robust standard errors:

                {helpb xtprobit}    probit regression
                {helpb xtlogit}     logistic regression
                {helpb xtcloglog}   complementary log-log regression
                {helpb xtpoisson}   Poisson regression

{pmore2}
    See {helpb xt:[XT] xt} for a complete list of all of Stata's 
    panel-data estimators.  

{marker WnEsize}{...}
{phang2}
8.  New commands are provided for calculating effect sizes after 
    estimation in the way behavioral scientists, and especially 
    psychologists, want to see them.  Cohen's d, Hedges's g, 
    Glass's Delta, eta^2, and omega^2, with confidence 
    intervals, are now provided:
       
{phang3}
a.  New commands {cmd:esize} and {cmd:esizei} calculate
            effect sizes comparing the difference between the
               means of a continuous variable for two groups.  See
               {helpb esize:[R] esize}.

{phang3}
b.  New postestimation command {cmd:estat} {cmd:esize}
	    computes effect sizes for linear models after {cmd:anova} and
	    {cmd:regress}.  See
	    {helpb regress postestimation:[R] regress postestimation}.

{marker WnProjectManager}{...}
{phang2}
9.  {bf:Project Manager.}{break}
    The new Project Manager lets you organize your analysis
    files -- your do-files, ado-files, datasets, raw files, etc.
    You can have multiple projects, and each can contain hundreds of
    files, or just a few.

{pmore2}
    You can see all the files in a project at a glance, filter on
    filenames, and click to open, edit, or run.

{pmore2}
    Projects are portable, meaning that you can pick the whole
    collection up at once and move it across computers or share it with
    colleagues.

{pmore2}
    Try it.  Get started from the Do-file Editor by selecting
    {bf:File > New > Project ...}

{pmore2}
    See {helpb Project Manager:[P] Project Manager}.

{marker WnJava}{...}
{p 7 12 2}
10.  {bf:Java plugins}. {break}
    You can now call Java methods directly from Stata. 
    You can take advantage of the plethora of existing Java libraries 
    or write your own Java code.   
    You call Java using Stata's new {cmd:javacall} command.
    See {helpb java:[P] java} and see 
    the Java-Stata API specification at 
    {browse "http://www.stata.com/java/api/":http://www.stata.com/java/api/}.

{pmore2}
    Java recently encountered some negative publicity regarding security
    concerns.  
    That publicity was about Java and web browsers automatically loading and
    running Java code from untrusted websites.  It does not apply to Stata's
    implementation of Java.  Stata's implementation is about running Java code
    already installed on your computer from known and trusted sources.


    {title:What's new that you will want to know}

{marker WnCls}{...}
{p 7 12 2}
11.  {bf:You can clear the Results window}.{break}
        Use the new {cmd:cls} command.  See {helpb cls:[R] cls}.

{p 7 12 2}
12.  {bf:Value labels of factor variables used to label output}.{break}
        You use variable {cmd:i.sex}, and output now shows {cmd:male} and 
	{cmd:female} in your model rather than {cmd:0} and {cmd:1} if variable
	{cmd:sex} has a value label.  You can control how output looks.  See
	more details below in
	{helpb whatsnew12to13##WnFacvarsVallabs:[U] 1.3.3 What's new in statistics (general)}.

{p 7 12 2}
13.  {bf:Programmers can create Word and Excel files from Stata}.{break}
        You can add paragraphs, insert images, insert tables, poke into 
        individual cells, and more. 

{pmore2} See {helpb mf__docx:[M-5] _docx*()} to create Word documents.

{pmore2} See {helpb putexcel:[P] putexcel} and
         {helpb mf_xl:[M-5] xl()} to interact with Excel files. 

{pmore2} By the way, Stata could already import and export Excel files; see 
        {helpb import excel:[D] import excel}. 

{marker WnSearch}{...}
{p 7 12 2}
14.  {bf:Searching is better}.{break}
	Here's why:

{phang3}
a.  {bf:Help >  Search...} and the {cmd:search} command 
                now default to searching the Internet as well as Stata's
                local keyword database.  If you do not want that, type
                {cmd:set searchdefault local, permanently} to set
                Stata 13 to the old default.

{phang3}
b.  {cmd:search} without options now displays its results 
                in the Viewer rather than in the Results window.
                (If any options are specified, however, results appear in the
                Results window.)

{phang3}
c.  Existing command {cmd:findit} is no longer documented
                but continues to work.  Changes to {cmd:search} 
                make {cmd:search} into the equivalent of {cmd:findit}.

{pmore2} See {helpb search:[R] search}.

{marker WnHelp}{...}
{p 7 12 2}
15.  {bf:help now searches when no help is found}.{break}
        {cmd:help} {it:xyz} now invokes {cmd:search} {it:xyz}
        if {it:xyz} is not found.  See {helpb help:[R] help}. 

{p 7 12 2}
16.  Stata now supports secure HTTP (HTTPS) and 
        FTP.  You can, for instance, {cmd:use} datasets from 
        sites using either of the protocols.  
        See {findalias frweb}.
        
{p 7 12 2}
17.  Concerning the Data Editor, 

{phang3}
a.  noncontiguous column selections are now allowed. 

{phang3}
b.  {cmd:encode}, {cmd:decode}, {cmd:destring}, and {cmd:tostring} 
                have been added as operations that can be performed on
                selected variables.

{phang3}
c.  the {it:Delete} key can now be used to drop data.

{pmore2} See {bf:[GS] 6 Using the Data Editor}
   ({mansection GSM 6UsingtheDataEditor:GSM},
    {mansection GSU 6UsingtheDataEditor:GSU}, or
    {mansection GSW 6UsingtheDataEditor:GSW}).

{p 7 12 2}
18.  Concerning the Do-file Editor, 

{phang3}
a.  matching braces are highlighted. 

{phang3}
b.  an adjustable column guide has been added.  

{phang3}
c.  you can now zoom in and out. 

{phang3}
d.  you can convert between the different types of 
                end-of-line characters used by Windows and by 
                Mac and Unix. 

{pmore2} See {bf:[GS] 13 Using the Do-file Editor---automating Stata}
   ({mansection GSM 13UsingtheDo-fileEditor---automatingStata:GSM},
    {mansection GSU 13UsingtheDo-fileEditor---automatingStata:GSU}, or
    {mansection GSW 13UsingtheDo-fileEditor---automatingStata:GSW}).

{p 7 12 2}
19.  Concerning Stata's GUI, 

{phang3}
a.  the Properties window now displays the sorted-by variables. 

{phang3}
b.  the {bf:Jump To} menu in the
                Viewer now allows you to jump to the top of the page.

{phang3}
c.  Stata for Windows now supports Windows high-contrast themes.

{marker WnDta}{...}
{p 7 12 2}
20.  {bf:.dta file format has changed}.{break}
        The file format has changed because of the new {cmd:strL}
        variables.  Stata 13 can, of course, read old-format datasets.
        If you need to create datasets in the previous format -- used by
        Stata 11 and Stata 12 -- use the {cmd:saveold} command.  See
        {helpb save:[D] save}.  If you want to know the details of the new
        {cmd:.dta} format, type {cmd:help dta}.

{p 7 12 2}
21.  {bf:Official directory ado/updates no longer used}.{break}
        Official ado-file updates are no longer stored in 
        directory {it:installation-directory}{cmd:/ado/updates/}.
        Updates are now applied to {cmd:ado/base} directly.  Modern
        operating systems do not approve of applications such as Stata
        having multiple files of the same name.  The updates process
        remains the same.

{p 7 12 2}
22.  {bf:Videos}.{break}
        Type {cmd:help videos} to list and link to the videos on 
        Stata's YouTube channel.  We provide dozens of tutorials on Stata's
        features.

{p 7 12 2}
23.  {bf:Fast PDF-manual navigation}.{break}
        There are now links at the top of each manual entry to 
        jump directly to section headings, and on each page's header, 
        there is a link to take you to the beginning of the entry. 

{pmore2} If you did not know already, clicking on the blue manual reference
        in the title of a help file jumps to the PDF
        documentation.

{p 7 12 2}
24.  {bf:Manuals have color graphs}.{break}
        If you want to use the same color graph scheme we use in the 
        manuals, type {cmd:set scheme s2gcolor}.  See
	{helpb scheme s2:[G-4] scheme s2}.

{marker vignettes}{...}
{p 7 12 2}
25.  {bf:Ten new vignettes}.{break}
        Scientific history buffs will want to read about the following: 

{phang3}
a. {mansection G-2 graphpieRemarksandexamplesv_nightingale:Florence Nightingale}

{phang3}
b. {mansection R correlateMethodsandformulasv_david:Florence Nightingale David},
         a different person from Florence Nightingale

{phang3}
c. {mansection FN StatisticalfunctionsFunctionsv_dunnett:Charles William Dunnett}

{phang3}
d. {mansection TS ucmMethodsandformulasv_harvey:Andrew Charles Harvey}

{phang3}
e. {mansection R esizeMethodsandformulasv_hays:William Lee Hays}

{phang3}
f. {mansection R esizeMethodsandformulasv_kerlinger:Fred Nichols Kerlinger}

{phang3}
g. {mansection R EpitabAcknowledgmentsv_laneclaypon:Janet Elizabeth Lane-Claypon}

{phang3}
h. {mansection ST stcoxpostestimationRemarksandexamplesv_martingale:martingale}

{phang3}
i. {mansection R IntroRemarksandexamplesv_scott:Elizabeth L. "Betty" Scott}

{phang3}
j. {mansection R EpitabAcknowledgmentsv_snow:John Snow}


{pstd}
The following two items were added during the Stata 12 release: 

{p 7 12 2}
26.  New command {cmd:icc} computes intraclass correlation coefficients
        for one-way random-effects models, two-way random-effects models, and
        two-way mixed-effects models for both individual and average
        measurements.  Intraclass correlations measure consistency of
        agreement or absolute agreement.
        See {helpb icc:[R] icc}.

{p 7 12 2}
27.  New postestimation command {cmd:estat icc} computes intraclass
        correlations at each nesting level for nested random-effects models
        fit by {cmd:mixed} and {cmd:melogit}.
        See {helpb mixed postestimation:[ME] mixed postestimation} and 
        {helpb melogit postestimation:[ME] melogit postestimation}. 


    {title:What's new in statistics (general)}

{pstd}
Already mentioned as highlights of the release were 
{help whatsnew12to13##WnTreatmentEffects:treatment effects}, 
{help whatsnew12to13##WnGsem:generalized SEMs},
{help whatsnew12to13##WnMestar:multilevel mixed-effects models}, 
{help whatsnew12to13##WnPSS:power and sample size}, 
and
{help whatsnew12to13##WnXtstar:panel-data estimators}.
The following are also new:

{p 7 12 2}
28.  Concerning sample-selection estimation commands, 

{phang3}
a.  new estimation command {cmd:heckoprobit} fits the parameters 
                of an ordered probit model with sample selection. 
                See {helpb heckoprobit:[R] heckoprobit}. 

{phang3}
b.  existing estimation  command {cmd:heckprob} is renamed 
                {cmd:heckprobit}.  See {helpb heckprobit:[R] heckprobit}.

{p 7 12 2}
29.  Existing estimation command {cmd:hetprob} is renamed
        {cmd:hetprobit}.  See {helpb hetprobit:[R] hetprobit}.

{p 7 12 2}
30.  New estimation command {cmd:ivpoisson} fits the parameters
        of a Poisson regression model with endogenous regressors. 
        Estimates can be obtained using the GMM or 
        control-function estimators.  
        See {helpb ivpoisson:[R] ivpoisson}. 

{p 7 12 2}
31.  New command {cmd:mlexp} allows you to specify
        maximum likelihood models without writing an evaluator program.
        You can instead specify an expression representing the
	log-likelihood function in much the same way you would with {cmd:nl},
	{cmd:nlsur}, or {cmd:gmm}.  See {helpb mlexp:[R] mlexp}.

{p 7 12 2}
32.  Concerning fractional polynomials, 

{phang3}
a.  new prefix command {cmd:fp:} replaces {cmd:fracpoly} for
                fitting models with fractional polynomial regressors.  
                You type 

                . {cmd:fp} ...{cmd::} {it:estimation command}

{pmore2} Results are the same.  The new {cmd:fp} command 
                supports more estimation commands, it is easier to use, 
                and it is more flexible.  You can substitute the same 
                fractional polynomial into multiple places of 
                the estimation command, which is especially useful 
                in multiple-equation models.  You may now use 
                factor-variable notation in the estimation command.

{phang3}
b.  {helpb fp:fp generate} replaces {cmd:fracgen}. 

{phang3}
c.  {helpb fp plot}
                replaces {cmd:fracplot}. 

{phang3}
d.  {helpb fp predict}
                replaces {cmd:fracpred}. 

{phang3}
e.  commands {cmd:fracpoly} and {cmd:fracgen} are no longer 
                documented but continue to work.  Commands 
                {cmd:fracplot} and {cmd:fracpred} are still documented 
                for use after {helpb mfp}. 

{pmore2} See {helpb fp:[R] fp}. 

{p 7 12 2}
33.  Concerning quantile-regression estimation commands, 

{phang3}
a.  existing estimation command {cmd:qreg} now accepts
                option {cmd:vce(robust)}.

{phang3}
b.  existing estimation commands {cmd:qreg}, {cmd:iqreg},
		 {cmd:sqreg}, and {cmd:bsqreg} now allow factor variables to
		 be used.

{pmore2} See {helpb qreg:[R] qreg}.

{p 7 12 2}
34.  Syntax and methodology for {cmd:predict} after {cmd:boxcox} 
        have changed.  Predicted values are now calculated using 
        Duan's smearing method by default.  The previous 
        back-transformed predicted-values estimates are provided if
        {cmd:predict}'s {cmd:btransform} option is specified and 
        under version control.  See
	{helpb boxcox postestimation:[R] boxcox postestimation}.

{marker WnFacvarsVallabs}{...}
{p 7 12 2}
35.  Value labels of factor variables are now used by default 
        to label estimation output.  The numeric values (levels) were 
        previously used and continue to be used if the factor variables 
        are unlabeled.  There are three new display options that may be used
        with estimation commands affecting how this works:

{phang3}
a.  Option {cmd:nofvlabel} displays factor-variable level 
                values, just as Stata 12 did previously. (You can 
                {cmd:set fvlabel off} to make {cmd:nofvlabel} the 
                default.) 

{phang3}
b.  Option {opt fvwrap(#)} specifies the number of lines
                to allow when long value labels must be wrapped.  Labels
		requiring more than {it:#} lines are truncated.
		{cmd:fvwrap(1)} is the default.  You can change the default by
		using {cmd:set fvwrap} {it:#}.

{phang3}
c.  Option {cmd:fvwrapon()} specifies whether
                value labels that wrap will break at word boundaries. 

{pmore3} {cmd:fvwrapon(word)} is the default, meaning to break 
                at word boundaries. 

{pmore3} {cmd:fvwrapon(width)} specifies that line breaks may occur 
                arbitrarily so as to maximize use of available space. 

{pmore3} You can change the defaults by using {cmd:set fvwrapon width} or
        {cmd:set fvwrapon word}.

{pmore2} Current default settings are shown by {cmd:query} and also
         stored in {cmd:c(fvlabel)}, {cmd:c(fvwrap)}, and {cmd:c(fvwrapon)}.

{pmore2} See {helpb set showbaselevels:[R] set showbaselevels} and
             {helpb creturn:[P] creturn}. 

{p 7 12 2}
36.  Existing estimation command {cmd:proportion} now uses the logit
        transform when computing the limits of the confidence interval.
        The original behavior of using the normal approximation is
	preserved under version control or when the new {cmd:citype(normal)}
	option is specified.  See {helpb proportion:[R] proportion}.

{p 7 12 2}
37.  Concerning existing command {cmd:margins}, 

{phang3}
a.  option {cmd:at()} has new suboption {cmd:generate()},
                which allows you to specify an expression to replace the
                values for any continuous variable in the model.  For
                example, you can compute the predictive margins at
                {cmd:x+1} by typing

                . {cmd:margins, at(x = generate(x+1))}

{pmore3} {cmd:at(generate())} can be combined with contrasts to
                estimate the effect of giving each subject an additional
                amount of {cmd:x},

                . {cmd:margins, at((asobserved) _all) at(x= generate(x+1)) ///}
		       {cmd:contrast(at(r._at))}

{pmore3}
      See {mansection R margins,contrastRemarksandexamplesEstimatingtreatmenteffectswithmargins:{it:Estimating treatment effects with margins}} in
                 {bf:[R] margins, contrast}.

{phang3}
b.  {cmd:margins} automatically uses the t distribution
                 for computing p-values and confidence intervals when
                 appropriate, which is after linear regression and
                 ANOVA and whenever degrees of freedom are posted to
                 {cmd:e(df_r)}.

{pmore3} The previous default behavior of always using the
                 standard normal distribution for all p-values and
                 confidence intervals is preserved under version
                 control.

{phang3}
c.   new option {opt df(#)} specifies that 
		  {cmd:margins} is to use the t distribution when it
		  otherwise would not.

{pmore2} See {helpb margins:[R] margins}.

{p 7 12 2}
38.  {cmd:nlcom} and {cmd:predictnl} 
        now use the standard normal distribution for computing
        p-values and confidence intervals.  
        Original behavior was to compute the p-values and CIs based
        on the t distribution in some cases.  Original behavior is preserved
        under version control.  In addition, if you want p-values and
	confidence intervals calculated using the t distribution, use new
	option {opt df(#)} to specify the degrees of freedom.

{pmore2} {cmd:testnl}'s calculated test statistic is now chi-squared rather
        than F unless you specify the {cmd:df()} option.

{pmore2}
        See {helpb nlcom:[R] nlcom}, {helpb predictnl:[R] predictnl}, and
	{helpb testnl:[R] testnl}.

{p 7 12 2}
39.  {cmd:contrast}, {cmd:pwcompare}, and {cmd:lincom}
        have new option {opt df(#)} to use the t distribution in
        computing p-values and confidence intervals.
        For {cmd:contrast}, this option also causes the Wald table to use 
        the F distribution. 

{pmore2} See {helpb contrast:[R] contrast}, {helpb pwcompare:[R] pwcompare},
        and {helpb lincom:[R] lincom}. 

{p 7 12 2} 
40.  {cmd:estimates table}'s option {cmd:label} is renamed
        {cmd:varlabel}. 
        Original option {cmd:label} is allowed under version control. 
	See {helpb estimates table:[R] estimates table}.

{p 7 12 2}
41.  The previously existing {cmd:sampsi} command is no longer
	documented because it is replaced by the new {cmd:power} command -- a
	highlight of the release.  See {helpb power:[PSS] power}.

{p 7 12 2}
42.  Existing functions 
        {opt normalden(x,mu,sigma)}
        and 
        {opt lnnormalden(x,mu,sigma)}
        now allow you to omit 
        argument mu or 
        arguments mu and sigma. 
        mu=0 and sigma=1 is assumed.
        See {helpb normalden()}, {helpb lnnormalden()}, 
        and {helpb functions:[FN] Functions by category}. 

{marker WnSDF}{...}
{p 7 12 2}
43.  The following new functions are added:

{p2colset 15 35 37 2}{...}
{synopt:{cmd:t(}{it:df}{cmd:,}{it:t}{cmd:)}}cumulative Student's {it:t} distribution{p_end}
{synopt:{cmd:invt(}{it:df}{cmd:,}{it:p}{cmd:)}}inverse cumulative Student's {it:t} distribution{p_end}

{synopt:{cmd:ntden(}{it:df}{cmd:,}{it:np}{cmd:,}{it:t}{cmd:)}}density of
noncentral Student's {it:t} distribution{p_end}
{synopt:{cmd:nt(}{it:df}{cmd:,}{it:np}{cmd:,}{it:t}{cmd:)}}cumulative
noncentral Student's {it:t} distribution{p_end}
{synopt:{cmd:npnt(}{it:df}{cmd:,}{it:t}{cmd:,}{it:p}{cmd:)}}noncentrality
parameter of noncentral Student's {it:t} distribution{p_end}
{synopt:{cmd:nttail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:t}{cmd:)}}right-tailed
noncentral Student's {it:t} distribution{p_end}
{synopt:{cmd:invnttail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)}}inverse of
right-tailed noncentral Student's {it:t} distribution{p_end}

{synopt:{cmd:nF(}{it:df_1}{cmd:,}{it:df_2}{cmd:,}{it:np}{cmd:,}{it:f}{cmd:)}}cumulative
noncentral {it:F} distribution{p_end}
{synopt:{cmd:npnF(}{it:df_1}{cmd:,}{it:df_2}{cmd:,}{it:f}{cmd:,}{it:p}{cmd:)}}noncentrality
parameter of noncentral {it:F} distribution{p_end}

{synopt:{cmd:chi2den(}{it:df}{cmd:,}{it:x}{cmd:)}}density of chi-squared distribution{p_end}

{synopt:{cmd:fileread(}{it:f}{cmd:)}}return the contents of a file as a
string{p_end}
{synopt:{cmd:filewrite(}{it:f}{cmd:,}{it:s}[{cmd:,}{it:r}]{cmd:)}}create or
overwrite file with the contents of a string{p_end}
{synopt:{cmd:fileexists(}{it:f}{cmd:)}}check whether a file exists{p_end}
{synopt:{cmd:filereaderror(}{it:s}{cmd:)}}use results returned by
{cmd:fileread()} to determine whether an I/O error occurred{p_end}
{p2colreset}{...}

{pmore2} See {cmd:help} {it:functionname}{cmd:()} and
    {helpb functions:[FN] Functions by category}. 


    {title:What's new in statistics (SEM)}

{pstd}
We have already mentioned 
{help whatsnew12to13##WnGsem:a highlight of the release}, 
the new {cmd:gsem} (see {manlink SEM Intro 1}) command, for fitting
generalized SEMs.  The following are also new: 

{p 7 12 2}
44.  Existing estimation command {cmd:sem} has new option {cmd:noestimate},
        which is useful when you are having convergence
        problems; you can use it to get the starting values into a
        Stata matrix (vector) that you can then modify to use as alternative
        starting values.  See {manlink SEM Intro 12}.

{p 7 12 2}
45.  {cmd:sem} now supports time-series operators on all 
        observed variables.   See {helpb sem_command:[SEM] sem}. 

{p 7 12 2}
46.  You can now use postestimation command {cmd:margins} after {cmd:sem}.
        See {manlink SEM Intro 7}.

{p 7 12 2}
47.  {cmd:sem} no longer reports in the estimation output any
        zero-valued constraints on covariances between exogenous
        variables; absence of the covariance indicates the presence of the
        constraint.  Original behavior is preserved under version 
        control.  

{p 7 12 2}
48.  The new options for controlling display of factor variables 
        with value labels mentioned in
        {helpb whatsnew12to13##WnFacvarsVallabs:[U] 1.3.3 What's new in statistics (general)} -- {cmd:nofvlabel},
       {opt fvwrap(#)}, and
	{opt fvwrapon(word|width)} -- work with {it:varname} of {cmd:sem,}
	{opt group(varname)}.  {cmd:sem} itself does not allow factor
	variables, but the factor-variable display options nonetheless work
	with {opt group(varname)}.

{pmore2} Thus old options {cmd:wrap()} and {cmd:nolabel} are now
        officially {cmd:fvwrap()} and {cmd:fvnolabel}, although the old
        option names continue to work as synonyms.  See
	{helpb sem reporting options:[SEM sem reporting options}.

{p 7 12 2}
49.  We now show how to construct path diagrams at the end of each 
        estimation example in the manual. 
        See {findalias semsfmm}, 
            {findalias semtfmm}, ....


{marker newts}{...}
    {title:What's new in statistics (time series)}

{pstd}
We have already mentioned a 
{help whatsnew12to13##WnForecast:highlight of the release}, the new 
{helpb forecast:[TS] forecast} command.  The following are also
new:

{marker import_haver}{...}
{p 7 12 2}
50.  New command {cmd:import haver} (available with Stata for Windows
        only) replaces old command {cmd:haver}.  {cmd:import haver}
        imports economic and financial data from Haver Analytics
        databases.  See {helpb import haver:[D] import haver}.

{p 7 12 2}
51.  Existing command {cmd:tsreport} now provides better
        information about gaps in time-series and panel datasets,
        including the length of each gap.  

{pmore2} In addition, {cmd:tsreport} will provide information about 
        missing values in variables even where there are no gaps.

{pmore2} See {helpb tsreport:[TS] tsreport}.

{pmore2} Also see item {help whatsnew12to13##bcal_create:55} in
{helpb whatsnew12to13##newdm:[U] 1.3.8 What's new in data management}
for information on the new command {cmd:bcal create}.


    {title:What's new in statistics (longitudinal/panel data)}

{p 7 12 2}
We have already mentioned a 
{help whatsnew12to13##WnXtstar:highlight of the release},
new and extended panel-data estimators.


    {title:What's new in statistics (survival analysis)}

{p 7 12 2}
52.  Shared frailty survival models can no longer be fit when there
       is delayed entry or there are gaps in time under observation.  Said
       differently, {cmd:stcox} and {cmd:streg} no longer allow option
       {cmd:shared()} when there are delayed entry or gaps.  The use of shared
       frailty models to fit truncated survival data leads to inconsistent
       results unless the frailty distribution is independent of the
       covariates and the truncation point, which rarely happens in practice.
       If you have such data and can make the independence assumption -- which
       is unlikely -- estimation can be forced by specifying undocumented
       option {cmd:forceshared}.  See {helpb stcox:[ST] stcox} and
       {helpb streg:[ST] streg}.  See {help st_forceshared} for
       information on the {cmd:forceshared} option.

{p 7 12 2}
53.  Output produced by existing commands {cmd:stset}, {cmd:streset}, and
        {cmd:cttost} more accurately labels time at risk.  What was
        labeled "total time at risk" is now labeled "total time at
        risk and under observation".  See {helpb stset:[ST] stset} and
        {helpb cttost:[ST] cttost}.


{marker newdm}{...}
    {title:What's new in data management}

{pstd}
We have already mentioned a
{help whatsnew12to13##WnStrls:highlight of the release},
long strings/BLOBs.

{p 7 12 2}
54.  New commands {cmd:import delimited} and {cmd:export} {cmd:delimited}
supersede old commands {cmd:insheet} and {cmd:outsheet}.  This is not just a
renaming. 

{pmore2} {cmd:import delimited} supports several different quoting methods.
        Some packages, for instance, use {cmd:""} in the middle of a string 
        to represent an embedded double quote.  Others do not. 

{pmore2} {cmd:import delimited} now allows column and row ranges (subsets). 

{pmore2} Use {cmd:import delimited}'s GUI to see a preview
        of the data and how they will be read.  You can also customize the
	GUI. 

{pmore2} Of course, {cmd:import delimited} and {cmd:export delimited} support
        Stata 13's new {cmd:strL}s. 

{pmore2} See {helpb import delimited:[D] import delimited}.

{marker bcal_create}{...}
{p 7 12 2}
55.  existing command {cmd:bcal} has new subcommand {cmd:create} 
        to create a business calendar from the current 
        dataset automatically.  {cmd:bcal create} infers business
        holidays and closures from gaps in the data. 
        See {helpb bcal:[D] bcal}. 

{p 7 12 2}
56.  String expressions now support string duplication via 
        multiplication.  For example, {cmd:3*"abc"} evaluates to 
        {cmd:"abcabcabc"}.  See {helpb strdup()} or
	{helpb functions:[FN] Functions by category}. 

{p 7 12 2}
57.  Concerning long strings, that is, {cmd:strL}s, 

{phang3}
a.  existing command {cmd:compress} has new option {cmd:nocoalesce} in support
of the new {cmd:strL} string storage type.  By default, {cmd:compress}
coalesces the storage used to store duplicated {cmd:strL} values.
{cmd:nocoalesce} prevents this.

{pmore3} In addition, {cmd:compress} always considers demoting
                {cmd:strL} variables to {cmd:str}{it:#} variables if
                that would save memory.

{pmore3} See {helpb compress:[D] compress}. 

{phang3}
b.  the output of existing command {cmd:memory} has changed
		to include information on new string storage type {cmd:strL}.
		See {helpb memory:[D] memory}.

{phang3}
c.  the options of existing command {cmd:ds}, such as {cmd:has()}
	       and {cmd:not()}, now understand {cmd:string} to mean both
	       {cmd:strL} and {cmd:str}{it:#}, {cmd:strL} to mean
	       {cmd:strL}, and {cmd:str#} to mean {cmd:str1}, {cmd:str2},
	       ..., {cmd:str2045}.  See {helpb ds:[D] ds}.

{phang3}
d.  existing command {cmd:type} has new option {opt lines(#)} to list the
first {it:#} lines of the file.  See {helpb type:[D] type}.

{pmore2} Also see item {help whatsnew12to13##import_haver:50} in
{helpb whatsnew12to13##newts:[U] 1.3.5 What's new in statistics (time series)}
for information on the new command {cmd:import haver}.


    {title:What's new in Mata}

{p 7 12 2}
58.  {bf:Programmers can create Word and Excel files from Stata}.{break}
        You can add paragraphs, insert images, insert tables, poke into
        individual cells, and more.  

{pmore2} See {helpb mf__docx:[M-5] _docx*()} to create Word documents.

{pmore2} See {helpb putexcel:[P] putexcel} and 
             {helpb mf_xl:[M-5] xl()} to interact with Excel files. 

{pmore2} By the way, Stata could already import and export Excel files; see
        {helpb import excel:[D] import excel}.  

{p 7 12 2}
59.  New functions in {cmd:solvenl()} allow you to solve 
        arbitrary systems of nonlinear equations.  
        Gauss--Seidel, damped Gauss--Seidel, Broyden--Powell, and 
        Newton--Raphson techniques are provided. 
        See {helpb mf_solvenl:[M-5] solvenl()}. 

{p 7 12 2}
60.  The same statistical functions added to Stata have been 
        added to Mata, namely,
        
                Noncentral Student's t
                {it:p} = {cmd:nt(}{it:df}{cmd:,} {it:np}{cmd:,} {it:t}{cmd:)}
                {it:d} = {cmd:ntden(}{it:df}{cmd:,} {it:np}{cmd:,} {it:t}{cmd:)}
                {it:q} = {cmd:nttail(}{it:df}{cmd:,} {it:np}{cmd:,} {it:t}{cmd:)}
                {it:t} = {cmd:invnttail(}{it:df}{cmd:,} {it:np}{cmd:,} {it:q}{cmd:)}
               {it:np} = {cmd:npnt(}{it:df}{cmd:,} {it:t}{cmd:,} {it:p}{cmd:)}

                Student's t
                {it:p} = {cmd:t(}{it:df}{cmd:,} {it:t}{cmd:)}
                {it:t} = {cmd:invt(}{it:df}{cmd:,} {it:p}{cmd:)}

                Noncentral F
                {it:p} = {cmd:nF(}{it:df_1}{cmd:,} {it:df_2}{cmd:,} {it:np}{cmd:,} {it:f}{cmd:)}
               {it:np} = {cmd:npnF(}{it:df_1}{cmd:,} {it:df_2}{cmd:,} {it:f}{cmd:,} {it:p}{cmd:)}

                chi-squared
                {it:d} = {cmd:chi2den(}{it:df}{cmd:,} {it:x}{cmd:)}

{pmore2} See {helpb mf_normal:[M-5] normal()}.

{p 7 12 2}
61.  New function {cmd:selectindex()} returns a vector of
          indices for which v{cmd:[}j{cmd:]} not equal 0.  For instance,
          if v = (6, 0, 7, 0, 8), then
	  {cmd:selectindex(}v{cmd:)} = (1, 3, 5).
	  {cmd:selectindex()} is useful with logical expressions,
	  such as {cmd:x[selectindex(x:>1000)]}. See
	  {helpb mf_select:[M-5] select()}.


    {title:What's new in programming}

{pstd}
We have already mentioned the 
{help whatsnew12to13##WnProjectManager:Project Manager} and 
{help whatsnew12to13##WnJava:Java plugins} as highlights of the release. 
The following are also new:

{p 7 12 2}
62.  New command {cmd:putexcel} writes Stata expressions, matrices,
         and stored results to an Excel file.  Excel 1997/2003 ({cmd:.xls})
         files and Excel 2007/2010 ({cmd:.xlsx}) files are supported.
         See {helpb putexcel:[P] putexcel}. 

{pmore2} Mata programmers will also be interested in 
         {helpb mf_xl:[M-5] xl()}, a class to interact with Excel files. 

{p 7 12 2}
63.  A new set of Mata functions provide the ability to 
         create Word documents.
         See {helpb mf__docx:[M-5] _docx*()}. 

{p 7 12 2}
64.  Concerning {cmd:strL}s, 

{phang3}
a.  {cmd:strL} is now a reserved word.

{phang3}
b.  the maximum length of a string in string expressions
             increases from 244 to 2-billion characters.
             See {help limits}. 
            
{phang3}
c. new {cmd:c(maxstrlvarlen)} returns the maximum possible length
              for {cmd:strL} variables.

{phang3}
d.  {cmd:confirm} ... {cmd:variable} now
             understands {cmd:str}{it:#} to mean any {cmd:str1}, {cmd:str2},
             ..., {cmd:str2045} variable;
             {cmd:strL} to mean {cmd:strL}; and {cmd:string} to
             mean {cmd:str}{it:#} or {cmd:strL}.
             See {helpb confirm:[P] confirm}.

{marker fileread()}{...}
{phang3}
e.  new function {cmd:fileread(}{it:filename} [{cmd:,} {it:startpos}
[{cmd:,} {it:length}]]{cmd:)} returns the contents of 
             {it:filename}.   See {helpb fileread()}
             and {helpb functions:[FN] Functions by category}.

{marker filewrite()}{...}
{phang3}
f.  new function {cmd:filewrite(}{it:filename}{cmd:,} {it:s}
	     [{cmd:,} {c -(}{cmd:1}|{cmd:2}{c )-}]{cmd:)} writes {it:s} to
	     the specified {it:filename}, optionally overwriting {cmd:1} or
	     appending {cmd:2}.  See {helpb filewrite()} and
	     {helpb functions:[FN] Functions by category}.

{phang3}
g.  new function {opt fileexists(filename)} returns 
	    {cmd:1} if the specified {it:filename} exists, and returns
	    {cmd:0} otherwise. 

{phang3}
h.  new function {opt filereaderror(s)} returns {cmd:0} or a
	    positive integer, said value having the interpretation of a return
	    code.  It is used like this 

{p 16 18 2}
{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:)}
     {cmd:if fileexists(}{it:filename}{cmd:)}{p_end}
{p 16 18 2}
{cmd:. assert filereaderror(}{it:s}{cmd:)==0}

{pmore3}or this 

{p 16 18 2}
{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:)}
      {cmd:if fileexists(}{it:filename}{cmd:)}{p_end}
{p 16 18 2}
{cmd:. generate} {it:rc} {cmd:= filereaderror(}{it:s}{cmd:)}

{pmore3}
    That is, {opt filereaderror(s)} is used on the result returned by
    {opt fileread(filename)} to determine whether an I/O error
    occurred. 

{pmore3}
    In the example, we only {cmd:fileread()} files that {cmd:fileexist()}. 
    That is not required.  If the file does not exist, that will be detected 
    by {cmd:filereaderror()} as an error.  The way we showed the example, 
    we did not want to read missing files as errors.  If we wanted to 
    treat missing files as errors, we would have coded

{p 16 18 2}
{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:)}{p_end}
{p 16 18 2}
{cmd:. assert filereaderror(}{it:s}{cmd:)==0} 

{pmore3}
    or

{p 16 18 2}
{cmd:. generate strL} {it:s} {cmd:= fileread(}{it:filename}{cmd:)}{p_end}
{p 16 18 2}
{cmd:. generate} {it:rc} {cmd:= filereaderror(}{it:s}{cmd:)}

{p 7 12 2}
65.  New command {cmd:expr_query} {it:exp} returns in {cmd:r()} the 
        variables used in expression {it:exp}.  See 
        {help undocumented} and see {helpb expr_query}. 

{p 7 12 2}
66.  The maximum number of elements in a numlist increases 
        from 1,600 to 2,500.  See {findalias frnumlist}.

{p 7 12 2}
67.  Existing command {cmd:ereturn} {cmd:post} now allows 
        posting of noninteger as well as integer {cmd:dof()} values.

{p 7 12 2}
68.  New {cmd:c(hostname)} returns the computer's hostname.
        See {helpb creturn:[P] creturn}.

{p 7 12 2}
69. New {cmd:c(maxvlabellen)} returns the maximum possible length for
          a value label.


    {title:What's new, Mac only}

{pstd}
    In addition to all the above What's New items, which apply to 
    all platforms, Stata for Mac has several of its own new features:

{p 7 12 2}
70.  The Do-file Editor in Stata for Mac has been completely rewritten. 
        It now includes 

{phang3} o  code folding 

{phang3} o  more robust syntax highlighting that is consistent with
             highlighting in Windows and Unix

{phang3} o more color options for customizing its appearance

{phang3} o the ability to save the syntax-highlighting colors 
             as separate themes

{phang3} o  line ending preservation and normalization, which is 
             useful for working in a mixed platform environment where
             do-files are exchanged between Windows and Macs

{phang3} o text-size zooming 
             without having to change the font or font size

{phang3} o  more drag-and-drop options

{phang3} o  more control over the appearance of printed files

{p 7 12 2}
71.  The Command window now has the same syntax highlighting as the 
        Do-file Editor. 

{p 7 12 2}
72.  There is a new path control that not only shows the current working
        directory but also can change the current working directory
        and open Stata files without having to use the Open dialog.

{p 7 12 2}
73.  Mac OS X 10.7 GUI enhancements
        such as full-screen support and textured backgrounds for
        spring-back scrolling are now supported.

{p 7 12 2}
74.  There is a new interface for saving and managing saved preferences.

{p 7 12 2}
75.  Applescript is better supported and enables users to directly access
        Stata macros, scalars, stored results, and datasets.

{p 7 12 2}
76.  Stata for Mac is now 64-bit only and allows the application's
        file size to be roughly 67% smaller.


    {title:What's more}

{pstd}
We have not listed all the changes, but we have listed the important ones.

{pstd}
Stata is continually being updated. Those between-release updates are
available for free over the Internet. 

{pstd}
Type {cmd:update query} and follow the instructions.

{pstd}
We hope that you enjoy Stata 13.


{hline 8} {hi:previous updates} {hline}

{pstd}
See {help whatsnew12}.{p_end}

{hline}
