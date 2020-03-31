{smcl}
{* *! version 1.0.4  19jun2019}{...}
{viewerdialog "predict after eoprobit" "dialog eoprobit_p"}{...}
{viewerdialog "predict after xteoprobit" "dialog eoprobit_p"}{...}
{vieweralsosee "[ERM] eoprobit predict" "mansection ERM eoprobitpredict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eoprobit" "help eoprobit"}{...}
{vieweralsosee "[ERM] eoprobit postestimation" "help eoprobit postestimation"}{...}
{viewerjumpto "Syntax" "eoprobit predict##syntax"}{...}
{viewerjumpto "Description" "eoprobit predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "eoprobit_predict##linkspdf"}{...}
{viewerjumpto "Options for statistics" "eoprobit predict##opts_stat"}{...}
{viewerjumpto "Options for how results are calculated" "eoprobit predict##opts_how"}{...}
{viewerjumpto "Examples" "eoprobit predict##examples"}{...}
{p2colset 1 27 35 2}{...}
{p2col:{bf:[ERM] eoprobit predict} {hline 2}}predict after eoprobit and
xteoprobit{p_end}
{p2col:}({mansection ERM eoprobitpredict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
You previously fit the model 

            {cmd:eoprobit y x1} ...{cmd:,} ...

{pstd}
The equation specified immediately after the {cmd:eoprobit} command
is called the main equation.  It is

            Pr(y_i=m) = Pr(c_{m-1} {ul:<} {bf:x}_i beta + e_i.{cmd:y} {ul:<} c_m)

{pstd}
Or perhaps you had panel data and you fit the model with {cmd:xteoprobit}
by typing

            {cmd:xteoprobit y x1} ...{cmd:,} ...

{pstd}
Then the main equation would be

{p 12 14 2}
            Pr(y_{ij}=m) = Pr(c_{m-1} {ul:<} {bf:x}_{ij}beta + u_{i}.{cmd:y} + v_{ij}.{cmd:y} {ul:<} c_m)

{pstd}
In either case, note that the equation produces a probability for each outcome
m, m = 1 to M.  {cmd:predict} calculates predictions for the
probabilities in the main equation.  The other equations in the model are
called auxiliary equations or complications.  Our discussion follows the
cross-sectional case with a single error term, but it applies to the panel-data
case when we collapse the random effects and observation-level error terms,
e_{ij}.{cmd:y} = u_i.{cmd:y} + v_{ij}.{cmd:y}.

{pstd}
The syntax of {cmd:predict} is

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {help varlist:{it:newvarlist}}{c )-} 
{ifin}
[{cmd:,} {it:stdstatistics} {it:howcalculated}]

{marker stdstatistics_options}{...}
{synoptset 25}{...}
{synopthdr:stdstatistics}
{synoptline}
{synopt :{opt pr}}probability of each outcome; the default{p_end}
{synopt :{opt outlevel(#)}}calculate probability for m = {it:#} only{p_end}
{synopt :{opt xb}}linear prediction excluding all complications{p_end}
{synoptline}

{marker howcalculated_options}{...}
{synopthdr:howcalculated}
{synoptline}
{synopt :default}not fixed; base values from data{p_end}
{synopt :{opth fix:(eoprobit_predict##endogvars:endogvars)}}fix specified
endogenous covariates{p_end}
{synopt :{opth base:(eoprobit_predict##valspecs:valspecs)}}specify base values
of any variables{p_end}
{synopt :{opth targ:et(eoprobit_predict##valspecs:valspecs)}}more convenient
way to specify {opt fix()} and {opt base()}{p_end}
{synoptline}

{p 4 6 2}
Note: The {opt fix()} and {opt base()} options affect results
only in models with endogenous variables in the main equation.
The {opt target()} option is sometimes a more convenient way 
to specify the {opt fix()} and {opt base()} options.

{marker endogvars}{...}
{phang}
{it:endogvars} are names of one or more endogenous variables
      appearing in the main equation.

{marker valspecs}{...}
{phang}
{it:valspecs} specify the values for variables at which 
       predictions are to be evaluated.  Each {it:valspec} is of the 
       form

	  {it:varname} {cmd:=} {it:#}

	  {it:varname} {cmd:=} {cmd:(}{it:exp}{cmd:)}

	  {it:varname} {cmd:=} {it:othervarname}

{pmore}
For instance, {opt base(valspecs)} could be {cmd:base(w1=0)} or
{cmd:base(w1=0 w2=1)}.

{pstd}
Notes:

{phang2}
(1) {cmd:predict} can also calculate treatment-effect statistics.
      See {helpb erm_predict_treatment:[ERM] predict treatment}.

{phang2}
(2) {cmd:predict} can also make predictions for the other 
      equations in addition to the main-equation predictions 
      discussed here.  See {helpb erm_predict_advanced:[ERM] predict advanced}.


{marker description}{...}
{title:Description}

{pstd}
In this entry, we show how to create new variables containing
observation-by-observation predictions after fitting a model with
{cmd:eoprobit} or {cmd:xteoprobit}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM eoprobitpredictRemarksandexamples:Remarks and examples}

        {mansection ERM eoprobitpredictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker opts_stat}{...}
{title:Options for statistics}

{phang}
{opt pr}
calculates the predicted probability for each outcome.
In each observation, the predictions are the probabilities
conditioned on the covariates.  Results depend on how
complications are handled, which is determined by the
{help eoprobit_predict##howcalculated_options:{it:howcalculated}} options.

{phang}
{opt outlevel(#)}
 specifies to calculate 
 only the probability for outcome m = {it:#} 
rather than calculating M probabilities.
 If you do not specify this option, y records three 
 outcomes. You type 

{phang3}
{cmd:. predict p1 p2 p3}

{pmore}
 to obtain the probabilities for each outcome.  If you want 
 only the probability of the third outcome, you can type 

{phang3}
{cmd:. predict p3, outlevel(#3)}

{pmore}
 If the third outcome corresponded to {cmd:y==3}, you could 
 instead type 

{phang3}
{cmd:. predict p3, outlevel(3)}

{pmore}
 If the third outcome corresponded to {cmd:y==57}, you could 
 instead type 

{phang3}
{cmd:. predict p3, outlevel(57)}

{pmore}
 Most users number the outcomes 1, 2, and 3.  Some users number 
 them 0, 1, and 2.  You could even number them 3, 5, and 57.
 Stata does not care how they are numbered.

{phang}
{opt xb} specifies that the linear prediction be calculated 
ignoring all complications.


{marker opts_how}{...}
{title:Options for how results are calculated}

{pstd}
By default, predictions are calculated taking into account all
complications.  This is discussed in
{mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.

{phang}
{cmd:fix(}{varname} ...{cmd:)} specifies a list of endogenous variables from
the main equation to be treated as if they were exogenous.  This was discussed
in {manlink ERM Intro 3} and is discussed further in
{mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.

{phang}
{cmd:base(}{varname} {cmd:=} ...{cmd:)} specifies a list of variables from any
equation and values for them.  If {opt eoprobit} and {cmd:xteoprobit} were
fitting linear models, we would tell you those values will be used in
calculating the expected value of e_i.{cmd:y} (or e_{ij}.{cmd:y} in the panel
case).  That thinking will not mislead you but is not formally correct in the
case of {opt eoprobit} and {cmd:xteoprobit}.  Linear or nonlinear, errors from
other equations spill over into the main equation because of correlations
between errors.  The correlations were estimated when the model was fit.  The
amount of spillover depends on those correlations and the values of the
errors.  This issue was discussed in {manlink ERM Intro 3} and is further
discussed in
{mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.

{phang}
{cmd:target(}{varname} {cmd:=} ...{cmd:)} is sometimes a more convenient way 
 to specify the {cmd:fix()} and {cmd:base()} options.
 You specify a list of 
 variables from the main equation and values for them.
 Those values override the values of the variables 
 calculating beta_0 + beta_1{cmd:x1}_i + ....
 Use of {opt target()} is discussed in
 {mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
 of {bf:[ERM] eregress predict}.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse womenhlth}{p_end}
{phang2}
{cmd:. eoprobit health i.exercise grade, endogenous(insured = grade i.workschool, probit)}{p_end}
{phang2}
{cmd:. generate orig=insured}{p_end}

{pstd}
Predict the probability of having excellent health, accounting for endogeneity of {cmd:insured}{p_end}
{phang2}
{cmd:. predict exhlth, outlevel(5)}{p_end}

{pstd}
Predict the probability having excellent health, treating {cmd:insured} as exogenous{p_end}
{phang2}
{cmd:. predict exhlth_fix, outlevel(5) fix(insured)}{p_end}

{pstd}
Predict the probability having excellent health, setting {cmd:insured=1} and treating it as exogenous{p_end}
{phang2}
{cmd:. replace insured=1}{p_end}
{phang2}
{cmd:. predict exhlth_fix1, outlevel(5) fix(insured)}{p_end}

{pstd}
Predict the probability of having excellent health, setting {cmd:insured=1} and accounting for {cmd:workschool}
and the unobserved characteristics that lead to correlation between {cmd:health} and {cmd:insured}{p_end}
{phang2}
{cmd:. predict exhlth_base1, outlevel(5) base(insured=orig)}{p_end}

{pstd}
Clean up{p_end}
{phang2}
{cmd:. replace insured=orig}
{p_end}
