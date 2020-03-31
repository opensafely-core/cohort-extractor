{smcl}
{* *! version 1.0.11  12dec2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem estimation options" "mansection SEM semestimationoptions"}{...}
{vieweralsosee "[SEM] Intro 8" "mansection SEM Intro8"}{...}
{vieweralsosee "[SEM] Intro 9" "mansection SEM Intro9"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem option method()" "help sem_option_method"}{...}
{vieweralsosee "[SEM] sem option noxconditional" "help sem_option_noxconditional"}{...}
{viewerjumpto "Syntax" "sem_estimation_options##syntax"}{...}
{viewerjumpto "Description" "sem_estimation_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_estimation_options##linkspdf"}{...}
{viewerjumpto "Options" "sem_estimation_options##options"}{...}
{viewerjumpto "Remarks" "sem_estimation_options##remarks"}{...}
{viewerjumpto "Examples" "sem_estimation_options##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[SEM] sem estimation options} {hline 2}}Options affecting
estimation{p_end}
{p2col:}({mansection SEM semestimationoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {help sem and gsem path notation:{it:paths}} 
... {cmd:,} ... {it:estimation_options}


{synoptset 28}{...}
{synopthdr:estimation_options}
{synoptline}
{synopt :{opt meth:od}{cmd:(}{it:{help sem_option_method##method:method}{cmd:)}}}{it:method} may be {opt ml}, {opt mlmv}, or {opt adf}{p_end}
{synopt :{opt vce}{cmd:(}{it:{help sem_option_method##vcetype:vcetype}{cmd:)}}}{it:vcetype} may be {opt oim}, {opt eim}, {opt opg}, {opt sbentler}, {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}
{synopt :{opt nm1}}compute sample variance rather than ML variance {p_end}
{synopt :{opt noxcond:itional}}compute covariances, etc., of observed exogenous
    variables{p_end}
{synopt :{opt allmiss:ing}}for use with {cmd:method(mlmv)} {p_end}
{synopt :{opt noivstart}}skip calculation of starting values {p_end}

{synopt :{opt noest:imate}}do not fit the model; instead show starting
     values{p_end}

{synopt :{it:{help sem_estimation_options##maximize_options:maximize_options}}}control the maximization process for specified model; seldom used{p_end}
{synopt :{opt satopt:s}{cmd:(}{it:{help sem_estimation_options##satopts:maximize_options}{cmd:)}}}control the maximization process for saturated model; seldom used{p_end}
{synopt :{opt baseopt:s}{cmd:(}{it:{help sem_estimation_options##baseopts:maximize_options}{cmd:)}}}control the maximization process for baseline model; seldom used{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
These options control how results are obtained.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semestimationoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt method()} and {opt vce()} specify the method used to obtain parameter
estimates and the technique used to obtain the variance-covariance matrix of
the estimates. 
See {helpb sem_option_method:[SEM] sem option method()}.

{phang}
{opt nm1} specifies that the variances and covariances used in the SEM
equations be the sample variances (divided by N-1) and not the asymptotic
variances (divided by N).   This is a minor technical issue of little
importance unless you are trying to match results from other software that
assumes sample variances.  {cmd:sem} assumes asymptotic variances.

{phang}
{opt noxconditional} states that you wish to include the means, variances, and
covariances of the observed exogenous variables among the parameters to be
estimated by {cmd:sem}.  See 
{helpb sem_option_noxconditional:[SEM] sem option noxconditional}.

{phang}
{opt allmissing} specifies how missing values be treated when 
{cmd:method(mlmv)} is also specified.

{p 8 8 2}
Usually, {cmd:sem} omits from the estimation sample observations that contain
missing values of any of the observed variables used in the model.  
{cmd:method(mlmv)}, however, can deal with these missing values, and in that
case, observations containing missing are not omitted.

{p 8 8 2}
Even so, {cmd:sem,} {cmd:method(mlmv)} does omit observations containing
{cmd:.a}, {cmd:.b}, ..., {cmd:.z} from the estimation sample.  {cmd:sem}
assumes you do not want these observations used because the missing value is
not missing at random.  If you want {cmd:sem} to include these observations in
the estimation sample, specify the {opt allmissing} option.

{phang}
{opt noivstart} is an arcane option that is most of use to programmers.  It
specifies that {cmd:sem} is to skip efforts to produce good starting values
with instrumental-variables techniques, techniques that require computer time.
If you specify this option, you should specify all the starting values.  Any
starting values not specified will be assumed to be 0 (means, path
coefficients, and covariances) or some simple function of the data
(variances).

{phang}
{cmd:noestimate} specifies that the model is not to be fit.  Instead,
        starting values are to be shown and they are to be shown using the
        {cmd:coeflegend} style of output.  An important use of this is to
        improve starting values when your model is having difficulty
        converging.  You can do the following:

{phang2}{cmd:. sem ..., ... noestimate}

{phang2}{cmd:. matrix b = e(b)}{p_end}
{phang2}. ... (modify elements of b) ...

{phang2}{cmd:. sem ..., ... from(b)}

{marker maximize_options}{...}
{phang}
{it:maximize_options} specify the standard and rarely specified options for
controlling the maximization process for {cmd:sem};
see {helpb maximize:[R] Maximize}.  The relevant options for {cmd:sem} are
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt tol:erance(#)},
{opt ltol:erance(#)}, and
{opt nrtol:erance(#)}.

{marker satopts}{...}
{phang}
{cmd:satopts(}{it:{help sem_estimation_options##maximize_options:maximize_options}}{cmd:)} is a rarely specified option and is only relevant if you specify 
the {cmd:method(mlmv)} option.  {cmd:sem} reports a test for model versus
saturated at the bottom of the output.  Thus {cmd:sem} needs to obtain the
saturated fit.  In the case of {cmd:method(ml)} or {cmd:method(adf)},
{cmd:sem} can make a direct calculation.  In the other case of
{cmd:method(mlmv)}, {cmd:sem} must actually fit the saturated model.  The
maximization options specified inside {cmd:satopts()} control that
maximization process.  It is rare that you need to specify the {cmd:satopts()}
option, even if you find it necessary to specify the overall
{it:maximize_options}.

{marker baseopts}{...}
{phang}
{cmd:baseopts(}{it:{help sem_estimation_options##maximize_options:maximize_options}}{cmd:)} 
is a rarely specified option and an irrelevant one unless you also specify
{cmd:method(mlmv)} or {cmd:method(adf)}.  When fitting the model, {cmd:sem}
records information about the baseline model for later use by {cmd:estat gof},
should you use that command.  Thus {cmd:sem} needs to obtain the baseline
fit.  In the case of {cmd:method(ml)}, {cmd:sem} can make a direct
calculation.  In the cases of {cmd:method(mlmv)} and {cmd:method(adf)},
{cmd:sem} must actually fit the baseline model.  The maximization options
specified inside {cmd:baseopts()} control that maximization process.  It is
rare that you need to specify the {cmd:baseopts()} option even if you find it
necessary to specify the overall {it:maximize_options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The most commonly specified option among this group is {opt vce()}.  See
{helpb sem option method:[SEM] sem option method()},
{manlink SEM Intro 8}, and
{manlink SEM Intro 9}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cfa_missing}{p_end}

{pstd}Fit CFA model using maximum likelihood{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X)}{p_end}

{pstd}Compute sample variance{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), nm1}{p_end}

{pstd}Treat all missing values as missing for {cmd:method(mlmv)}{p_end}
{phang2}{cmd:. sem (test1 test2 test3 test4 <- X), method(mlmv) allmissing}{p_end}
