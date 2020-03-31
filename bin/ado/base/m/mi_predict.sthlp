{smcl}
{* *! version 1.0.9  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi predict" "mansection MI mipredict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate postestimation" "help mi estimate postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{viewerjumpto "Syntax" "mi_predict##syntax"}{...}
{viewerjumpto "Menu" "mi_predict##menu"}{...}
{viewerjumpto "Description" "mi_predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_predict##linkspdf"}{...}
{viewerjumpto "Options" "mi_predict##options"}{...}
{viewerjumpto "Examples" "mi_predict##examples"}{...}
{viewerjumpto "References" "mi_predict##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi predict} {hline 2}}Obtain multiple-imputation predictions{p_end}
{p2col:}({mansection MI mipredict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Obtain multiple-imputation linear predictions

{p 8 16 2}
{cmd:mi} {cmd:predict} {dtype} {newvar} [{it:{help if}}]
    {cmd:using} {it:miestfile}
   [{cmd:,} {it:{help mi predict##predict_options:predict_options}}
            {it:{help mi predict##mioptions:options}}]


{pstd}
Obtain multiple-imputation nonlinear predictions

{p 8 16 2}
{cmd:mi} {cmd:predictnl} {dtype} {newvar} =
     {it:{help mi predict##pnl_exp:pnl_exp}}
     [{it:{help if}}] {cmd:using} {it:miestfile}
     [{cmd:,} {it:{help mi predict##pnl_options:pnl_options}}
              {it:{help mi predict##mioptions:options}}]

{phang}
{it:miestfile}{cmd:.ster} contains estimation results previously saved by
{cmd:mi} {cmd:estimate, saving(}{it:miestfile}{cmd:)}; see
{manhelp mi_estimate MI:mi estimate}.

{marker pnl_exp}{...}
{phang}
{it:pnl_exp} is any valid Stata expression and may also contain calls to two
special functions unique to {cmd:predictnl}: {cmd:predict()} and {cmd:xb()};
see {manhelp predictnl R} for details.

{marker predict_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr:predict_options}
{synoptline}
{syntab:Predict options}
{synopt :{opt xb}}calculate linear prediction; the default{p_end}
{synopt :{opt stdp}}calculate standard error of the prediction{p_end}
{synopt :{opt nooff:set}}ignore any {opt offset()} or {opt exposure()}
variable{p_end}
{synopt :{opt eq:uation}{cmd:(}{it:eqno}{cmd:)}}specify equations after multiple-equation commands{p_end}
{synoptline}

{marker pnl_options}{...}
{synoptset 29 tabbed}{...}
{synopthdr:pnl_options}
{synoptline}
{syntab:Predict options}
{synopt :{opth se(newvar)}}create {it:newvar} containing standard errors{p_end}
{synopt :{opth var:iance(newvar)}}create {it:newvar} containing
variances{p_end}
{synopt :{opth w:ald(newvar)}}create {it:newvar} containing the Wald test
statistic{p_end}
{synopt :{opth p(newvar)}}create {it:newvar} containing the significance level
(p-value) of the Wald test{p_end}
{synopt :{opth ci:(newvarlist:newvars)}}create {it:newvars} containing lower and upper
confidence intervals{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opth bvar:iance(newvar)}}create {it:newvar} containing
between-imputation variances{p_end}
{synopt :{opth wvar:iance(newvar)}}create {it:newvar} containing
within-imputation variances{p_end}
{synopt :{opth df(newvar)}}create {it:newvar} containing MI degrees of freedom{p_end}
{synopt: {opt nosmall}}do not apply small-sample correction to degrees of
    freedom{p_end}
{synopt :{opth rvi(newvar)}}create {it:newvar} containing relative variance increases{p_end}
{synopt :{opth fmi(newvar)}}create {it:newvar} containing fractions of missing information{p_end}
{synopt :{opth re(newvar)}}create {it:newvar} containing relative efficiencies{p_end}

{syntab :Advanced}
{synopt :{opt iter:ate(#)}}maximum iterations for finding optimal step size to
compute completed-data numerical derivatives of {it:pnl_exp}; default is
100{p_end}
{synopt :{opt force}}calculate completed-data standard errors, etc., even when
possibly inappropriate{p_end}
{synoptline}

{marker mioptions}{...}
{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:MI options}
{synopt:{opt ni:mputations(#)}}specify number of imputations to use in computation; default is to use all existing imputations{p_end}
{synopt:{opth i:mputations(numlist)}}specify which imputations to use in computation{p_end}
{synopt:{opth est:imations(numlist)}}specify which estimation results to use in computation{p_end}
{synopt:{opth esample(varname)}}restrict the prediction to the estimation subsample identified by a binary variable {it:varname}{p_end}
{synopt:{opt storecomp:leted}}store completed-data predictions in the imputed
data; available only in the flong and flongsep styles{p_end}

{syntab:Reporting}
{synopt:{opt replay}}replay command-specific results from each individual estimation in {it:miestfile}{cmd:.ster}{p_end}
{synopt:{opt cmdleg:end}}display the command legend{p_end}

{synopt: {opt noup:date}}do not perform {cmd:mi update}; see 
{manhelp mi_noupdate_option MI:noupdate option}{p_end}
{synopt:{opt noerrn:otes}}suppress error notes associated with failed
estimation results in {it:miestfile}{cmd:.ster}{p_end}
{synopt:{opt showimp:utations}}show imputations saved in {it:miestfile}{cmd:.ster}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt noupdate}, {opt noerrnotes}, and {opt showimputations} do not appear in
the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi predict using} {it:miestfile} is for use after {cmd:mi estimate,}
{opt saving(miestfile)}{cmd::} ... to obtain multiple-imputation
(MI) linear predictions or their standard errors.

{p 4 4 2}
{cmd:mi predictnl using} {it:miestfile} is for use after {cmd:mi estimate,}
{opt saving(miestfile)}{cmd::} ... to obtain MI (possibly)
nonlinear predictions, their standard errors, and other statistics, including
statistics specific to MI.

{p 4 4 2}
MI predictions, their standard errors, and other statistics are obtained by
applying Rubin's combination rules observationwise to the completed-data
predictions, predictions computed for each imputation
({help mi predict##WRW2011:White, Royston, and Wood 2011}).  The results are
stored in the original data ({it:m}=0).  See {manhelp predict R} and 
{manhelp predictnl R} for details about the computation of the completed-data
predictions.

{p 4 4 2}
{cmd:mi predict} and {cmd:mi predictnl} may change the sort order of the data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mipredictRemarksandexamples:Remarks and examples}

        {mansection MI mipredictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Predict options}

{phang}
{cmd:xb}, {cmd:stdp}, {cmd:noffset}, {opt equation(eqno)}; see 
{manhelp predict R}.

{phang}
{opt se(newvar)}, {opt variance(newvar)}, {opt wald(newvar)}, {opt p(newvar)},
{opt ci(newvars)}, {opt level(#)}; see {manhelp predictnl R}.  These options
store the specified MI statistics in variable {it:newvar} in the original data
({it:m}=0).  {cmd:level()} is relevant in combination with {cmd:ci()} only.
If {cmd:storecompleted} is specified, then {it:newvar} contains the respective
completed-data estimates in the imputed data ({it:m}>0).  Otherwise,
{it:newvar} is missing in the imputed data.

{phang}
{opth bvariance(newvar)} adds {it:newvar} of storage type {it:type}, where for
each {cmd:i} in the prediction sample, {it:newvar}{cmd:[i]} contains the
estimated between-imputation variance of {it:pnl_exp}{cmd:[i]}.
{cmd:storecompleted} has no effect on {cmd:bvariance()}.

{phang}
{opth wvariance(newvar)} adds {it:newvar} of storage type {it:type}, where for
each {cmd:i} in the prediction sample, {it:newvar}{cmd:[i]} contains the
estimated within-imputation variance of {it:pnl_exp}{cmd:[i]}.
{cmd:storecompleted} has no effect on {cmd:wvariance()}.

{phang}
{opth df(newvar)} adds {it:newvar} of storage type {it:type}, where for
each {cmd:i} in the prediction sample, {it:newvar}{cmd:[i]} contains the
estimated MI degrees of freedom of {it:pnl_exp}{cmd:[i]}.  If
{cmd:storecompleted} is specified, then {it:newvar} in the imputed data will
contain the complete-data degrees of freedom as saved by {cmd:mi estimate}.
In the absence of the complete-data degrees of freedom or if {cmd:nosmall} is
used, then {it:newvar} is missing in the imputed data, even if
{cmd:storecompleted} is specified.

{phang}
{cmd:nosmall} specifies that no small-sample correction be made to the degrees
of freedom.  By default, the small-sample correction of
{help mi predict##BR1999:Barnard and Rubin (1999)} is used.  This option has
an effect on the results stored by {cmd:p()}, {cmd:ci()}, {cmd:df()},
{cmd:fmi()}, and {cmd:re()}.

{phang}
{opth rvi(newvar)} adds {it:newvar} of storage type {it:type}, where for
each {cmd:i} in the prediction sample, {it:newvar}{cmd:[i]} contains the
estimated relative variance increase of {it:pnl_exp}{cmd:[i]}.
{cmd:storecompleted} has no effect on {cmd:rvi()}.

{phang}
{opth fmi(newvar)} adds {it:newvar} of storage type {it:type}, where for
each {cmd:i} in the prediction sample, {it:newvar}{cmd:[i]} contains the
estimated fraction of missing information of {it:pnl_exp}{cmd:[i]}.
{cmd:storecompleted} has no effect on {cmd:fmi()}.

{phang}
{opth re(newvar)} adds {it:newvar} of storage type {it:type}, where for
each {cmd:i} in the prediction sample, {it:newvar}{cmd:[i]} contains the
estimated relative efficiency of {it:pnl_exp}{cmd:[i]}.
{cmd:storecompleted} has no effect on {cmd:re()}.

{dlgtab:MI options}

{phang}
{opt nimputations(#)} specifies that the first {it:#} imputations
be used; {it:#} must be 2 <= {it:#} <= M. The default is to
use all imputations, M.
Only one of {cmd:nimputations()}, {cmd:imputations()}, or {cmd:estimations()}
may be specified.

{phang}
{opth imputations(numlist)} specifies which imputations to use.  The
default is to use all of them.  {it:numlist} must contain at least two
numbers corresponding to the imputations saved in {it:miestfile}{cmd:.ster}.
You can use the {cmd:showimputations} option to display imputations currently
saved in {it:miestfile}{cmd:.ster}.
Only one of {cmd:nimputations()}, {cmd:imputations()}, or {cmd:estimations()}
may be specified.

{phang}
{opth estimations(numlist)} does the same thing as {opt imputations(numlist)},
but this time the imputations are numbered differently.  Say that
{it:miestfile}{cmd:.ster} was created by {cmd:mi estimate} and {cmd:mi estimate}
was told to limit itself to imputations 1, 3, 5, and 9.  With
{cmd:imputations()}, the imputations are still numbered 1, 3, 5, and 9.  With
{cmd:estimations()}, they are numbered 1, 2, 3, and 4.  Usually, one does not
specify a subset of imputations when using {cmd:mi estimate}, and so usually,
the {cmd:imputations()} and {cmd:estimations()} options are identical.  The
specified {it:numlist} must contain at least two numbers.  Only one of
{cmd:nimputations()}, {cmd:imputations()}, or {cmd:estimations()} may be
specified.

{phang}
{opt esample(varname)} restricts the prediction to the estimation sample
identified by a binary variable {it:varname}.  By default, predictions are
obtained for all observations in the original data.  Variable {it:varname}
cannot be registered as imputed or passive and cannot vary across imputations.

{phang}
{opt storecompleted} stores completed-data predictions in the newly created
variables in each imputation.  By default, the imputed data contain missing
values in the newly created variables.  The {cmd:storecompleted} option may be
specified only if the data are flong or flongsep; see 
{manhelp mi_convert MI:mi convert} to convert to one of those styles.

{dlgtab:Reporting}

{phang}
{cmd:replay} replays estimation results from {it:miestfile}{cmd:.ster},
previously saved by {cmd:mi estimate,} {opt saving(miestfile)}.

{phang}
{cmd:cmdlegend} requests that the command line corresponding to the estimation
command used to produce the estimation results saved in
{it:miestfile}{cmd:.ster} be displayed.

{dlgtab:Advanced}

{phang}
{opt iterate(#)}, {cmd:force}; see {manhelp predictnl R}.

{pstd}
The following options are available with {cmd:mi predict} and 
{cmd:mi predictnl} but are not shown in the dialog box:

{phang}
{cmd:noupdate} in some cases suppresses the automatic {cmd:mi update} this
command might perform; see 
{manhelp noupdate_option MI:noupdate option}.  This option is rarely
used.

{phang}
{cmd:noerrnotes} suppresses notes about failed estimation results.  These
notes appear when {it:miestfile}{cmd:.ster} contains estimation results,
previously saved by {cmd:mi estimate,} {opt saving(miestfile)}, from
imputations for which the estimation command used with {cmd:mi estimate}
failed to estimate parameters. 

{phang}
{cmd:showimputations} displays imputation numbers corresponding to the
estimation results saved in {it:miestfile}{cmd:.ster}.


{marker examples}
{title:Example:  Obtain MI linear predictions and other statistics}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse mhouses1993s30}{p_end}
{phang2}{cmd:. mi estimate, saving(miest): regress price tax sqft age nfeatures ne custom corner}{p_end}

{pstd}
Compute linear predictions
{p_end}
{phang2}
{cmd:. mi predict xb_mi using miest}
{p_end}
{phang2}
{cmd:. mi xeq 0: summarize price xb_mi}
{p_end}

{pstd}
Compute standard errors of the linear predictions
{p_end}
{phang2}
{cmd:. mi predict stdp_mi using miest, stdp}
{p_end}

{pstd}
Compute linear predictions only for custom homes
{p_end}
{phang2}
{cmd:. mi predict xb_custom_mi if custom using miest}
{p_end}

{pstd}
Compute 95% confidence intervals and fractions of missing information of the
linear predictions
{p_end}
{phang2}
{cmd:. mi predictnl xb1_mi = predict(xb) using miest, ci(cil_mi ciu_mi) fmi(fmi)} 
{p_end}
{phang2}
{cmd:. mi xeq 0: summarize fmi}
{p_end}

{pstd}
When you are through, erase file containing previous estimates
{p_end}
{phang2}
{cmd:. erase miest.ster}
{p_end}


{title:Example:  Obtain MI linear predictions for the estimation sample}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse mhouses1993s30, clear}{p_end}

{pstd}
Convert to the flong style
{p_end}
{phang2}{cmd:. mi convert flong}{p_end}

{pstd}
Store estimation sample in variable {cmd:touse}
{p_end}
{phang2}{cmd:. mi estimate, saving(miest) esample(touse): regress price tax sqft age nfeatures ne custom corner}{p_end}

{pstd}
Compute linear predictions for the estimation sample
{p_end}
{phang2}
{cmd:. mi predict xb_mi using miest, esample(touse)}
{p_end}

{pstd}
In addition, store completed-data linear predictions in the imputed data
{p_end}
{phang2}
{cmd:. mi predict xb_mi_all using miest, esample(touse) storecompleted}
{p_end}
{phang2}
{cmd:. mi xeq: summarize xb_mi_all}
{p_end}

{pstd}
When you are through, erase file containing previous estimates
{p_end}
{phang2}
{cmd:. erase miest.ster}
{p_end}


{title:Example:  Obtain MI estimates of probabilities}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse mheart1s20, clear}{p_end}
{phang2}{cmd:. mi estimate, saving(miest): logit attack smokes age bmi hsgrad female}{p_end}

{pstd}
Compute probability of a positive outcome via the inverse-logit transformation of the MI linear prediction
{p_end}
{phang2}
{cmd:. mi predict xb_mi using miest}
{p_end}
{phang2}
{cmd:. mi xeq: generate phat = invlogit(xb_mi)}
{p_end}

{pstd}
Compute probability of a positive outcome by applying combination rules directly to the completed-data estimates of a positive outcome (less commonly used)
{p_end}
{phang2}
{cmd:. mi predictnl phat_mi = predict(pr) using miest}
{p_end}
{phang2}
{cmd:. mi xeq 0: summarize phat phat_mi}
{p_end}

{pstd}
When you are through, erase file containing previous estimates
{p_end}
{phang2}
{cmd:. erase miest.ster}
{p_end}


{title:Example:  Obtain other MI predictions}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse mdrugtrs25, clear}{p_end}
{phang2}{cmd:. mi stset studytime, failure(died)}{p_end}
{phang2}{cmd:. mi estimate, sav(miest): streg drug age, dist(weibull)}{p_end}

{pstd}
Compute median survival time by applying combination rules on a log scale and then transforming the results back to the original scale{p_end}
{phang2}
{cmd:. mi predictnl p50_lntime_mi = ln(predict(median time)) using miest}
{p_end}
{phang2}
{cmd:. mi xeq: generate p50_time_mi = exp(p50_lntime_mi)}
{p_end}
{phang2}
{cmd:. mi xeq 0: summarize p50_time_mi}
{p_end}

{pstd}
Equivalently,{p_end}
{phang2}
{cmd:. mi predictnl p50_lntime1_mi = predict(median lntime) using miest}
{p_end}
{phang2}
{cmd:. mi xeq: generate p50_time1_mi = exp(p50_lntime1_mi)}
{p_end}
{phang2}
{cmd:. mi xeq 0: summarize p50_time_mi p50_time1_mi}
{p_end}

{pstd}
When you are through, erase file containing previous estimates
{p_end}
{phang2}
{cmd:. erase miest.ster}
{p_end}


{title:Example:  Obtain MI predictions after multiple-equation commands}

{pstd}
Setup
{p_end}
{phang2}{cmd:. webuse mheart1s20, clear}{p_end}
{phang2}{cmd:. mi estimate, saving(miest): mlogit attack smokes age bmi hsgrad female}{p_end}

{pstd}
Compute linear predictions for the two equations of {cmd:attack} (linear
prediction is zero for the base category, category {cmd:0})
{p_end}
{phang2}
{cmd:. mi predict xb_0_mi using miest}
{p_end}
{phang2}
{cmd:. mi predict xb_1_mi using miest, equation(#2)}
{p_end}
{phang2}
{cmd:. mi xeq 0: summarize xb_0_mi xb_1_mi}
{p_end}

{pstd}
Compute nonlinear functions of predictions.  For example, compute
observation-specific odds of a heart attack using the definition of odds as a
ratio of the two probabilities
{p_end}
{phang2}
{cmd:. mi predictnl odds_mi = predict(equation(1))/predict(equation(0)) using miest, se(odds_stdp)}
{p_end}

{pstd}
When you are through, erase file containing previous estimates
{p_end}
{phang2}
{cmd:. erase miest.ster}
{p_end}


{marker references}{...}
{title:References}

{marker BR1999}{...}
{phang}
Barnard, J., and D. B. Rubin. 1999. Small-sample degrees of freedom with
multiple imputation. {it:Biometrika} 86: 948-955.

{marker WRW2011}{...}
{phang}
White, I. R., P. Royston, and A. M. Wood. 2011.  Multiple imputation using 
chained equations: Issues and guidance for practice.  
{it:Statistics in Medicine} 30: 377-399.
{p_end}
