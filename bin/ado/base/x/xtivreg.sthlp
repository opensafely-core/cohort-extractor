{smcl}
{* *! version 1.2.2  15mar2019}{...}
{viewerdialog xtivreg "dialog xtivreg"}{...}
{vieweralsosee "[XT] xtivreg" "mansection XT xtivreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtivreg postestimation" "help xtivreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[XT] xtabond" "help xtabond"}{...}
{vieweralsosee "[XT] xteregress" "help xteregress"}{...}
{vieweralsosee "[XT] xthtaylor" "help xthtaylor"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtivreg##syntax"}{...}
{viewerjumpto "Menu" "xtivreg##menu"}{...}
{viewerjumpto "Description" "xtivreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtivreg##linkspdf"}{...}
{viewerjumpto "Options for RE model" "xtivreg##options_re"}{...}
{viewerjumpto "Options for BE model" "xtivreg##options_be"}{...}
{viewerjumpto "Options for FE model" "xtivreg##options_fe"}{...}
{viewerjumpto "Options for FD model" "xtivreg##options_fd"}{...}
{viewerjumpto "Examples" "xtivreg##examples"}{...}
{viewerjumpto "Stored results" "xtivreg##results"}{...}
{viewerjumpto "References" "xtivreg##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[XT] xtivreg} {hline 2}}Instrumental variables and two-stage least squares for panel-data models{p_end}
{p2col:}({mansection XT xtivreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
GLS random-effects (RE) model

{p 8 16 2}{cmd:xtivreg} {depvar} [{it:{help varlist:varlist_1}}] 
{cmd:(}{it:{help varlist:varlist_2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin} 
[{cmd:, re} {it:{help xtivreg##reoptions:RE_options}}]


{phang}
Between-effects (BE) model

{p 8 16 2}{cmd:xtivreg} {depvar} [{it:{help varlist:varlist_1}}]
{cmd:(}{it:{help varlist:varlist_2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin} 
{cmd:, be} [{it:{help xtivreg##beoptions:BE_options}}]


{phang}
Fixed-effects (FE) model

{p 8 16 2}{cmd:xtivreg} {depvar} [{it:{help varlist:varlist_1}}]
{cmd:(}{it:{help varlist:varlist_2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin} 
{cmd:, fe} [{it:{help xtivreg##feoptions:FE_options}}]


{phang}
First-differenced (FD) estimator

{p 8 16 2}{cmd:xtivreg} {depvar} [{it:{help varlist:varlist_1}}]
{cmd:(}{it:{help varlist:varlist_2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin} 
{cmd:, fd} [{it:{help xtivreg##fdoptions:FD_options}}]


{marker reoptions}{...}
{synoptset 19 tabbed}{...}
{synopthdr :RE_options}
{synoptline}
{syntab:Model}
{synopt :{opt re}}use random-effects estimator; the default{p_end}
{synopt :{opt ec:2sls}}use Baltagi's EC2SLS random-effects estimator{p_end}
{synopt :{opt nosa}}use the Baltagi-Chang estimators of the variance components{p_end}
{synopt :{opt reg:ress}}treat covariates as exogenous and ignore instrumental variables{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional}, 
         {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
	 {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage estimates{p_end}
{synopt :{opt sm:all}}report t and F statistics instead of Z and chi-squared statistics{p_end}
{synopt :{opt th:eta}}report theta{p_end}
{synopt :{it:{help xtivreg##re_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
  
{marker beoptions}{...}
{synoptset 19 tabbed}{...}
{synopthdr :BE_options}
{synoptline}
{syntab:Model}
{synopt :{opt be}}use between-effects estimator{p_end}
{synopt :{opt reg:ress}}treat covariates as exogenous and ignore instrumental variables{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
       {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
       {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage estimates{p_end}
{synopt :{opt sm:all}}report {it:t} and {it:F} statistics instead of {it:Z} and chi-squared statistics{p_end}
{synopt :{it:{help xtivreg##be_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker feoptions}{...}
{synoptset 19 tabbed}{...}
{synopthdr :FE_options}
{synoptline}
{syntab:Model}
{synopt :{opt fe}}use fixed-effects estimator{p_end}
{synopt :{opt reg:ress}}treat covariates as exogenous and ignore instrumental variables{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
         {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
         {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage estimates{p_end}
{synopt :{opt sm:all}}report {it:t} and {it:F} statistics instead of {it:Z} and chi-squared statistics{p_end}
{synopt :{it:{help xtivreg##fe_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
  
{marker fdoptions}{...}
{synoptset 19 tabbed}{...}
{synopthdr :FD_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt fd}}use first-differenced estimator{p_end}
{synopt :{opt reg:ress}}treat covariates as exogenous and ignore instrumental variables{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt conventional},
         {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
         {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt first}}report first-stage estimates{p_end}
{synopt :{opt sm:all}}report {it:t} and {it:F} statistics instead of {it:Z} and chi-squared statistics{p_end}
{synopt :{it:{help xtivreg##fd_display_options:display_options}}}control
columns and column formats, row spacing, line width, and display of omitted
variables{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{p 4 6 2}
A panel variable must be specified. For  {cmd:xtivreg, fd}, a time variable must also be specified. Use {helpb xtset}.{p_end}
{p 4 6 2}
{it:varlist_1} and {it:varlist_iv} may contain factor variables, except
       for the {cmd:fd} estimator; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}, {it:varlist_1}, {it:varlist_2}, and {it:varlist_iv} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt by} and {opt statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtivreg_postestimation XT:xtivreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Endogenous covariates >}
     {bf:Instrumental-variables regression (FE, RE, BE, FD)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtivreg} offers five different estimators for fitting panel-data models
in which some of the right-hand-side covariates are endogenous.  These
estimators are two-stage least-squares generalizations of simple panel-data
estimators for exogenous variables. {cmd:xtivreg} with the
{cmd:be} option uses the two-stage least-squares between estimator.
{cmd:xtivreg} with the {cmd:fe} option uses the two-stage least-squares within
estimator.  {cmd:xtivreg} with the {cmd:re} option uses a two-stage
least-squares random-effects estimator.  There are two implementations: G2SLS
from {help xtivreg##BV1987:Balestra and Varadharajan-Krishnakumar (1987)} and
EC2SLS from Baltagi.  The Balestra and Varadharajan-Krishnakumar G2SLS is the
default because it is computationally less expensive.  Baltagi's EC2SLS can be
obtained by specifying the {cmd:ec2sls} option.  {cmd:xtivreg} with the
{cmd:fd} option requests the two-stage least-squares first-differenced
estimator.

{pstd}
See {help xtivreg##B2013:Baltagi (2013)} for an introduction to panel-data
models with endogenous covariates.  For the derivation and application of the
first-differenced estimator, see
{help xtivreg##AH1981:Anderson and Hsiao (1981)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtivregQuickstart:Quick start}

        {mansection XT xtivregRemarksandexamples:Remarks and examples}

        {mansection XT xtivregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_re}{...}
{title:Options for RE model}

{dlgtab:Model}

{phang}
{opt re} requests the G2SLS random-effects estimator.  {opt re} is the default.

{phang}
{opt ec2sls} requests Baltagi's EC2SLS random-effects estimator
instead of the default Balestra and Varadharajan-Krishnakumar estimator.

{phang}
{opt nosa} specifies that the Baltagi-Chang estimators of the variance
components be used instead of the default adapted Swamy-Arora estimators.

{phang}
{opt regress} specifies that all the covariates be treated as exogenous
and that the instrument list be ignored.  Specifying {opt regress}
causes {cmd:xtivreg} to fit the requested panel-data regression model of
{depvar} on {it:{help varlist:varlist_1}} and {it:varlist_2}, ignoring
{it:varlist_iv}.

{dlgtab:SE/Robust}

INCLUDE help xt_vce_asymptall

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtregMethodsandformulasxtreg,re:{it:xtreg, re}} in
{it:Methods and formulas} of {bf:[XT] xtreg}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-stage regressions be displayed.

{phang}
{opt small} specifies that t statistics be reported instead of Z statistics
and that F statistics be reported instead of chi-squared statistics.

{phang}
{opt theta} specifies that the output should include the estimated value of
theta used in combining the between and fixed estimators.  For balanced data,
this is a constant, and for unbalanced data, a summary of the values is
presented in the header of the output.

{marker re_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtivreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_be}{...}
{title:Options for BE model}

{dlgtab:Model}

{phang}
{opt be} requests the between regression estimator.

{phang}
{opt regress} specifies that all the covariates be treated as exogenous
and that the instrument list be ignored.  Specifying {opt regress}
causes {cmd:xtivreg} to fit the requested panel-data regression model of
{depvar} on {it:{help varlist:varlist_1}} and {it:varlist_2}, ignoring
{it:varlist_iv}.

{dlgtab:SE/Robust}

INCLUDE help xt_vce_asymptall

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtregMethodsandformulasxtreg,fe:{it:xtreg, fe}} in
{it:Methods and formulas} of {bf:[XT] xtreg}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-stage regressions be displayed.

{phang}
{opt small} specifies that t statistics be reported instead of Z statistics
and that F statistics be reported instead of chi-squared statistics.

{marker be_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtivreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_fe}{...}
{title:Options for FE model}

{dlgtab:Model}

{phang}
{opt fe} requests the fixed-effects (within) regression estimator.  

{phang}
{opt regress} specifies that all the covariates be treated as exogenous
and that the instrument list be ignored.  Specifying {opt regress}
causes {cmd:xtivreg} to fit the requested panel-data regression model of
{depvar} on {it:{help varlist:varlist_1}} and {it:varlist_2}, ignoring
{it:varlist_iv}.

{dlgtab:SE/Robust}

INCLUDE help xt_vce_asymptall

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtregMethodsandformulasxtreg,fe:{it:xtreg, fe}} in
{it:Methods and formulas} of {bf:[XT] xtreg}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-stage regressions be displayed.

{phang}
{opt small} specifies that t statistics be reported instead of Z statistics
and that F statistics be reported instead of chi-squared statistics.

{marker fe_display_options}{...}
INCLUDE help displayopts_list

{pstd}
The following option is available with {opt xtivreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_fd}{...}
{title:Options for FD model}

{dlgtab:Model}

{phang}
{opt noconstant}; see
 {helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt fd} requests the first-differenced regression estimator.

{phang}
{opt regress} specifies that all the covariates be treated as exogenous
and that the instrument list be ignored.  Specifying {opt regress}
causes {cmd:xtivreg} to fit the requested panel-data regression model of
{depvar} on {it:{help varlist:varlist_1}} and {it:varlist_2}, ignoring
{it:varlist_iv}.

{dlgtab:SE/Robust}

INCLUDE help xt_vce_asymptall

{pmore}
{cmd:vce(conventional)}, the default, uses the conventionally derived variance
estimator for generalized least-squares regression.

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
{cmd:vce(cluster} {it:panelvar}{cmd:)}; see
{mansection XT xtregMethodsandformulasxtreg,fe:{it:xtreg, fe}} in
{it:Methods and formulas} of {bf:[XT] xtreg}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt first} specifies that the first-stage regressions be displayed.

{phang}
{opt small} specifies that t statistics be reported instead of Z statistics
and that F statistics be reported instead of chi-squared statistics.

{marker fd_display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

{pstd}
The following option is available with {opt xtivreg} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse abdata}{p_end}

{pstd}First-differenced estimator{p_end}
{phang2}{cmd:. xtivreg n l2.n l(0/1).w l(0/2).(k ys) yr1981-yr1984}
                  {cmd:(l.n = l3.n), fd}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}

{pstd}Fixed-effects model{p_end}
{phang2}{cmd:. xtivreg ln_w age c.age#c.age not_smsa (tenure = union south), fe}

{pstd}GLS random-effects model{p_end}
{phang2}{cmd:. xtivreg ln_w age c.age#c.age not_smsa 2.race}
              {cmd:(tenure = union birth south), re}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtivreg, re} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_rz)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if panels balanced, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:gamma}, {cmd:lnormal}){p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(r2_w)}}R-squared for within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared for overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared for between model{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(F)}}model F ({cmd:small} only){p_end}
{synopt:{cmd:e(m_p)}}p-value from model test{p_end}
{synopt:{cmd:e(thta_min)}}minimum theta{p_end}
{synopt:{cmd:e(thta_5)}}theta, 5th percentile{p_end}
{synopt:{cmd:e(thta_50)}}theta, 50th percentile{p_end}
{synopt:{cmd:e(thta_95)}}theta, 95th percentile{p_end}
{synopt:{cmd:e(thta_max)}}maximum theta{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtivreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(instd)}}instrumented variables{p_end}
{synopt:{cmd:e(model)}}{cmd:g2sls} or {cmd:ec2sls}{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:xtivreg, be} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(df_rz)}}residual degrees of freedom for the between-transformed 
             regression{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(rs_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(r2_w)}}R-squared for within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared for overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared for between model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}model Wald{p_end}
{synopt:{cmd:e(chi2_p)}}p-value for model chi-squared test{p_end}
{synopt:{cmd:e(F)}}F statistic ({cmd:small} only){p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtivreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(instd)}}instrumented variables{p_end}
{synopt:{cmd:e(model)}}{cmd:be}{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:xtivreg, fe} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom ({cmd:small} only){p_end}
{synopt:{cmd:e(df_rz)}}residual degrees of freedom for the within-transformed 
         regression{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:gamma}, {cmd:lnormal}){p_end}
{synopt:{cmd:e(corr)}}corr(u_i, Xb){p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(r2_w)}}R-squared for within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared for overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared for between model{p_end}
{synopt:{cmd:e(chi2)}}model Wald (not {cmd:small}){p_end}
{synopt:{cmd:e(chi2_p)}}p-value for model chi-squared test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(F)}}F statistic ({cmd:small} only){p_end}
{synopt:{cmd:e(F_f)}}F for H_0: u_i=0{p_end}
{synopt:{cmd:e(F_fp)}}p-value for F for H_0: u_i=0{p_end}
{synopt:{cmd:e(df_a)}}degrees of freedom for absorbed effect{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtivreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(instd)}}instrumented variables{p_end}
{synopt:{cmd:e(model)}}{cmd:fe}{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:xtivreg, fd} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom ({cmd:small} only){p_end}
{synopt:{cmd:e(df_rz)}}residual degrees of freedom for first-differenced
             regression{p_end}
{synopt:{cmd:e(g_min)}}smallest group size{p_end}
{synopt:{cmd:e(g_avg)}}average group size{p_end}
{synopt:{cmd:e(g_max)}}largest group size{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(sigma)}}ancillary parameter ({cmd:gamma}, {cmd:lnormal}){p_end}
{synopt:{cmd:e(corr)}}corr(u_i, Xb){p_end}
{synopt:{cmd:e(sigma_u)}}panel-level standard deviation{p_end}
{synopt:{cmd:e(sigma_e)}}standard deviation of epsilon_it{p_end}
{synopt:{cmd:e(r2_w)}}R-squared for within model{p_end}
{synopt:{cmd:e(r2_o)}}R-squared for overall model{p_end}
{synopt:{cmd:e(r2_b)}}R-squared for between model{p_end}
{synopt:{cmd:e(chi2)}}model Wald (not {cmd:small}){p_end}
{synopt:{cmd:e(chi2_p)}}p-value for model chi-squared test{p_end}
{synopt:{cmd:e(rho)}}rho{p_end}
{synopt:{cmd:e(F)}}F statistic ({cmd:small} only){p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtivreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(instd)}}instrumented variables{p_end}
{synopt:{cmd:e(model)}}{cmd:fd}{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker AH1981}{...}
{phang}
Anderson, T. W., and C. Hsiao. 1981.  Estimation of dynamic models with error
components. {it:Journal of the American Statistical Association} 76: 598-606.

{marker BV1987}{...}
{phang}
Balestra, P., and J. Varadharajan-Krishnakumar. 1987. Full information
estimations of a system of simultaneous equations with error component
structure. {it:Econometric Theory} 3: 223-246.

{marker B2013}{...}
{phang}
Baltagi, B. H. 2013.
{browse "http://www.stata.com/bookstore/eapd.html":{it:Econometric Analysis of Panel Data}. 5th ed.}
Chichester, UK: Wiley.
{p_end}
