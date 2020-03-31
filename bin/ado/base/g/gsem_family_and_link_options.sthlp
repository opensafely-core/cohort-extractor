{smcl}
{* *! version 1.2.6  17jul2019}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] gsem family-and-link options" "mansection SEM gsemfamily-and-linkoptions"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem path notation extensions" "help gsem_path_notation_extensions"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem_and_gsem_path_notation"}{...}
{viewerjumpto "Syntax" "gsem_family_and_link_options##syntax"}{...}
{viewerjumpto "Description" "gsem_family_and_link_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_family_and_link_options##linkspdf"}{...}
{viewerjumpto "Options" "gsem_family_and_link_options##options"}{...}
{viewerjumpto "Remarks" "gsem_family_and_link_options##remarks"}{...}
{viewerjumpto "Examples" "gsem_family_and_link_options##examples"}{...}
{p2colset 1 39 41 2}{...}
{p2col:{bf:[SEM] gsem family-and-link options} {hline 2}}Family-and-link
options{p_end}
{p2col:}({mansection SEM gsemfamily-and-linkoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {it:{help sem_and_gsem_path notation:paths}} ...{cmd:,} ...
    {it:family_and_link_options}

{synoptset 28}{...}
{synopthdr:family_and_link_options}
{synoptline}
{synopt :{opth f:amily(gsem_family_and_link_options##family:family)}}distribution family; default is {cmd:family(gaussian)}{p_end}
{synopt :{opth li:nk(gsem_family_and_link_options##link:link)}}link function;
default varies per family{p_end}

{synopt :{opt cloglog}}synonym for {cmd:family(bernoulli) link(cloglog)}{p_end}
{synopt :{opt exponential}}synonym for {cmd:family(exponential) link(log)}{p_end}
{synopt :{opt gamma}}synonym for {cmd:family(gamma) link(log)}{p_end}
{synopt :{opt logit}}synonym for {cmd:family(bernoulli) link(logit)}{p_end}
{synopt :{opt loglogistic}}synonym for {cmd:family(loglogistic) link(log)}{p_end}
{synopt :{opt lognormal}}synonym for {cmd:family(lognormal) link(log)}{p_end}
{synopt :{opt llogistic}}synonym for {cmd:family(llogistic) link(log)}{p_end}
{synopt :{opt lnormal}}synonym for {cmd:family(lnormal) link(log)}{p_end}
{synopt :{opt mlogit}}synonym for {cmd:family(multinomial) link(logit)}{p_end}
{synopt :{opt nbreg}}synonym for {cmd:family(nbreg mean) link(log)}{p_end}
{synopt :{opt ocloglog}}synonym for {cmd:family(ordinal) link(cloglog)}{p_end}
{synopt :{opt ologit}}synonym for {cmd:family(ordinal) link(logit)}{p_end}
{synopt :{opt oprobit}}synonym for {cmd:family(ordinal) link(probit)}{p_end}
{synopt :{opt poisson}}synonym for {cmd:family(poisson) link(log)}{p_end}
{synopt :{opt probit}}synonym for {cmd:family(bernoulli) link(probit)}{p_end}
{synopt :{opt regress}}synonym for {cmd:family(gaussian) link(identity)}{p_end}
{synopt :{opt weibull}}synonym for {cmd:family(weibull) link(log)}{p_end}

{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} with
coefficient constrained to 1{p_end}
{synoptline}

{marker family}{...}
{synopthdr:family}
{synoptline}
{synopt :{opt gau:ssian} [{cmd:,} {it:{help gsem_family_and_link_options##opts_table:options}}]}Gaussian (normal); the default{p_end}
{synopt :{opt be:rnoulli}}Bernoulli{p_end}
{synopt :{opt bet:a}}beta{p_end}
{synopt :{opt bin:omial} [{it:#} | {varname}]}binomial; default number of
binomial trials is 1{p_end}
{synopt :{opt o:rdinal}}ordinal{p_end}
{synopt :{opt m:ultinomial}}multinomial{p_end}
{synopt :{opt poi:sson} [{cmd:,} {it:{help gsem_family_and_link_options##poisson:poisson}}]}Poisson{p_end}
{synopt :{opt nb:inomial} [{cmd:mean} | {cmdab:cons:tant}]}negative binomial; default dispersion is {cmd:mean}{p_end}
{synopt :{opt e:xponential} [{cmd:,} {it:{help gsem_family_and_link_options##survival:survival}}]}exponential{p_end}
{synopt :{opt gam:ma} [{cmd:,} {it:{help gsem_family_and_link_options##survival:survival}}]}gamma{p_end}
{synopt :{opt logl:ogistic} [{cmd:,} {it:{help gsem_family_and_link_options##survival:survival}}]}loglogistic{p_end}
{synopt :{opt logn:ormal} [{cmd:,} {it:{help gsem_family_and_link_options##survival:survival}}]}lognormal{p_end}
{synopt :{opt w:eibull} [{cmd:,} {it:{help gsem_family_and_link_options##survival:survival}}]}Weibull{p_end}
{synopt :{opt pointmass} {it:#}}point-mass density at {it:#}{p_end}
{synoptline}

{marker link}{...}
{synopthdr:link}
{synoptline}
{synopt :{opt iden:tity}}identity{p_end}
{synopt :{opt log}}log{p_end}
{synopt :{opt logit}}logit{p_end}
{synopt :{opt prob:it}}probit{p_end}
{synopt :{opt clog:log}}complementary log-log{p_end}
{synoptline}

{marker opts_table}{...}
{synopthdr:options}
{synoptline}
{synopt :{opth ld:epvar(varname)}}lower depvar for interval-response data{p_end}
{synopt :{opth ud:epvar(varname)}}upper depvar for interval-response data{p_end}
{synopt :{cmdab:lc:ensored(}{varname}|{it:#}{cmd:)}}lower limit for left-censoring{p_end}
{synopt :{cmdab:rc:ensored(}{varname}|{it:#}{cmd:)}}upper limit for right-censoring{p_end}
{synoptline}
{p 4 6 2}
Only allowed with {cmd:family(gaussian)} with {cmd:link(identity)}.
{p_end}

{marker poisson}{...}
{synopthdr:poisson}
{synoptline}
{synopt :{cmdab:lt:runcated(}{varname}|{it:#}{cmd:)}}lower limit for left-truncation{p_end}
{synoptline}

{marker survival}{...}
{synopthdr:survival}
{synoptline}
{synopt :{cmdab:lt:runcated(}{varname}|{it:#}{cmd:)}}lower limit for left-truncation{p_end}
{synopt :{opth fail:ure(varname)}}indicator for failure event{p_end}
{synopt :{opt ph}}proportional hazards parameterization{p_end}
{synopt :{opt aft}}accelerated failure-time parameterization{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt ph} is allowed only with families
{cmd:exponential}
and
{opt weibull}.
{p_end}
{p 4 6 2}
{opt aft} is allowed only with families
{cmd:exponential},
{cmd:gamma},
{cmd:loglogistic},
{cmd:lognormal},
and
{cmd:weibull}.
{p_end}

{pstd}
If you specify both {cmd:family()} and {cmd:link()}, not all 
combinations make sense.
You may choose from the following combinations:

                                 identity  log  logit  probit  cloglog
            {hline 60}
            Gaussian                D       x
            Bernoulli                             D      x        x
            beta                                  D      x        x
            binomial                              D      x        x
            ordinal                               D      x        x
            multinomial                           D
            Poisson                         D
            negative binomial               D
            exponential                     D
            Weibull                         D
            gamma                           D
            loglogistic                     D
            lognormal                       D
            pointmass               D
	    {hline 60}
            D denotes the default.


{marker description}{...}
{title:Description}

{pstd}
{cmd:gsem} not only allows models of the form 
y_i = {bf:x}_i beta + u_i but also allows

           g{E(y_i)} = {bf:x}_i beta
                 y_i sim F

{pstd}
where you can choose F and g() from a menu.  F is called the family, and g()
is called the link.  One set of choices is the Gaussian distribution for F and
the identity function for g(). In that case, {cmd:gsem} reproduces linear
regression.  Other combinations of g() and F produce other popular models,
including logit (also known as logistic regression), probit, multinomial
logit, Poisson regression, and more. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsemfamily-and-linkoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth family:(gsem family and link options##family:family)} and
{opth link:(gsem family and link options##family:linkname)}
     specify F and g().  If neither is specified, linear regression is assumed.

{pmore} 
     Two of the families allow optional arguments:

{phang2}
{cmd:family(binomial} [{it:#} | {varname}]{cmd:)}
    specifies that data are in binomial form, that is, that the response
    variable records the number of successes from a series of Bernoulli
    trials.  The number of trials is given either as a constant number or as
    a varname that allows the number of trials to vary over observations, or
    it is not given at all.  In the last case, the number of trials is 
    thus equivalent to specifying {cmd:family(bernoulli)}.

{phang2} 
{cmd:family(nbinomial} [{cmd:mean} | {cmd:constant}]{cmd:)}
     specifies a negative binomial model, a Poisson model with overdispersion. 
     Be aware, however, that even Poisson models can have overdispersion 
     if latent variables are included in the model.  Let's use the term 
     "conditional overdispersion" to refer to dispersion above and beyond 
     that implied by latent variables, if any. 

{pmore2} 
     That conditional overdispersion can take one of two forms.  In mean
     overdispersion, the conditional overdispersion is a linear function of the
     conditional (predicted) mean.  Constant overdispersion refers to 
     the conditional overdispersion being, of course, constant.  

{pmore2}
     If you do not specify {cmd:mean} or {cmd:constant}, then {cmd:mean} is 
     assumed. 

{pmore}
{cmd:family(pointmass} {it:#}{cmd:)} is a special family allowed when
{opt lclass()} is also specified.

{phang} 
{cmd:cloglog}, 
{cmd:exponential}, 
{cmd:gamma}, 
{cmd:logit}, 
{cmd:loglogistic}, 
{cmd:lognormal}, 
{cmd:llogistic}, 
{cmd:lnormal}, 
{cmd:mlogit}, 
{cmd:nbreg}, 
{cmd:ocloglog}, 
{cmd:ologit}, 
{cmd:oprobit}, 
{cmd:poisson}, 
{cmd:probit},
{cmd:regress},
and 
{cmd:weibull}
are shorthands for specifying popular models. 

{phang}
{opth exposure:(varname:varname_e)} and {opth offset:(varname:varname_o)}
    are most commonly used with families {cmd:poisson} and {cmd:nbreg},
    that is, they typically concern count models.

{pmore}
    {cmd:exposure()} specifies a variable that reflects the amount 
    of exposure -- usually measured in time units -- for each observation 
    over which the responses were counted.  
    If one observation was exposed for twice the time of another, 
    and the observations were otherwise identical, one would expect 
    twice as many events to be counted. 
    To assume that, ln(varname_e) is entered into
    {bf:x}_i beta with coefficient constrained to be 1.

{pmore}
    {cmd:offset()} enters {it:varname_o} into 
    {bf:x}_i beta with coefficient constrained to be 1.
    {cmd:offset()} is just another way of specifying {cmd:exposure()} 
    where the offset variable is the log of amount of exposure. 

{pmore}
    If neither {cmd:exposure()} nor {cmd:offset()} is specified, 
    observations are assumed to have equal amounts of exposure. 

{phang}
{opth ldepvar(varname)} and {opth udepvar(varname)} specify that each
observation can be point data, interval data, left-censored data, or
right-censored data.  The type of data for a given observation is determined
by the values in {it:y_i} and {it:varname}.  The following specifications are
equivalent:

{pmore2}
{it:depvar1} {cmd:<-} {cmd:...} {cmd:,} {cmd:family(gaussian, udepvar(}{it:depvar2}{cmd:))}

{pmore2}
{it:depvar2} {cmd:<-} {cmd:...} {cmd:,} {cmd:family(gaussian, ldepvar(}{it:depvar1}{cmd:))}

{pmore}
Thus only one of {opt ldepvar()} or {opt udepvar()} is allowed.
In either case, {it:depvar1} and {it:depvar2} should have the following form:

             Type of data {space 16} {it:depvar1}  {it:depvar2}
             {hline 46}
             point data{space 10}{it:a} = [{it:a},{it:a}]{space 4}{it:a}{space 8}{it:a} 
             interval data{space 11}[{it:a},{it:b}]{space 4}{it:a}{space 8}{it:b}
             left-censored data{space 3}(-inf,{it:b}]{space 4}{cmd:.}{space 8}{it:b}
             right-censored data{space 3}[{it:a},inf){space 4}{it:a}{space 8}{cmd:.} 
             {hline 46}

{phang}
{cmd:lcensored(}{varname}|{it:#}{cmd:)} and
{opt rcensored(varname|#)} indicate the lower and upper limits for censoring,
respectively.  You may specify only one.

{pmore}
{opt lcensored(arg)} specifies that observations with {it:y_i} {ul:<}
{it:arg} are left-censored and the remaining observations are not.

{pmore}
{opt rcensored(arg)} specifies that observations with {it:y_i} {ul:<}
{it:arg} are right-censored and the remaining observations are not.

{pmore}
Neither {opt lcensored()} nor {opt rcensored()} may not be combined with
{opt ldepvar()} or {opt udepvar()}.

{phang}
{cmd:ltruncated(}{varname}|{it:#}{cmd:)} indicates the lower limits for
truncation.

{pmore}
{opt ltruncated(arg)} specifies that the distribution is truncated
on the left at {it:arg}, meaning that {it:y_i} {ul:<} {it:arg} is not within
the support for the corresponding distribution family.  This option rescales
the underlying density function to accommodate the truncated support for
{it:y_i}.  This means that values of {it:y_i} that are less than or equal to
{it:arg} do not contribute to the likelihood.  For survival families, this
means that time (time at risk) starts at {it:arg} instead of at 0.

{phang}
{opt failure(varname)} specifies the failure event.

{pmore}
If {opt failure()} is not specified, all observations are assumed to indicate
a failure.

{pmore}
If {opt failure(varname)} is specified, {it:varname} is interpreted as an
indicator variable; 0 and missing mean censored, and all other values are
interpreted as representing failure.

{phang}
{opt ph} specifies the proportional hazards parameterization and is
allowed with families
{opt exponential}
and
{opt weibull}.
This is the default parameterization for these families.

{phang}
{opt aft} specifies the accelerated failure-time parameterization and is
allowed with families
{opt exponential},
{opt gamma},
{opt loglogistic},
{opt lognormal},
and
{opt weibull}.
This is an optional parameterization for {opt exponential} and {opt weibull}
but the only parameterization for the others.


{marker remarks}{...}
{title:Remarks}

{pstd}
See
{it:{mansection SEM gsemfamily-and-linkoptionsRemarksandexamples:Remarks and examples}}
of {bf:[SEM] gsem family-and-link options} for further information. 


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_1fmm}{p_end}

{pstd}Fit a measurement model using the Bernoulli family and probit link to 
model each response{p_end}
{phang2}{cmd:. gsem (X -> x1 x2 x3 x4), family(bernoulli) link(probit)}{p_end}

{pstd}Fit the model above using the {cmd:probit} shortcut{p_end}
{phang2}{cmd:. gsem (X -> x1 x2 x3 x4), probit}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lbw}{p_end}

{pstd}Fit a model with one logistic regression and one Poisson 
regression{p_end}
{phang2}{cmd:. gsem (low <- ptl age smoke ht lwt i.race ui, logit)}{break}
	{cmd:(ptl <- age smoke ht, poisson)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_sysdsn1}{p_end}

{pstd}Fit a multinomial logistic regression model{p_end}
{phang2}{cmd:. gsem (i.insure <- i.nonwhite age i.male), mlogit}{p_end}
