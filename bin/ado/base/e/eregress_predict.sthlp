{smcl}
{* *! version 1.0.4  19jun2019}{...}
{viewerdialog "predict after eregress" "dialog eregress_p"}{...}
{viewerdialog "predict after xteregress" "dialog eregress_p"}{...}
{vieweralsosee "[ERM] eregress predict" "mansection ERM eregresspredict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eregress" "help eregress"}{...}
{vieweralsosee "[ERM] eregress postestimation" "help eregress postestimation"}{...}
{viewerjumpto "Syntax" "eregress predict##syntax"}{...}
{viewerjumpto "Description" "eregress predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "eregress_predict##linkspdf"}{...}
{viewerjumpto "Options for statistics" "eregress predict##opts_stat"}{...}
{viewerjumpto "Options for how results are calculated" "eregress predict##opts_how"}{...}
{viewerjumpto "Examples" "eregress predict##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[ERM] eregress predict} {hline 2}}predict after eregress and
xteregress{p_end}
{p2col:}({mansection ERM eregresspredict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
You previously fit the model 

            {cmd:eregress y x1} ...{cmd:,} ...

{pstd}
The equation specified immediately after the {cmd:eregress} command
is called the main equation.  It is

            {cmd:y}_i = beta_0 + beta_1{cmd:x1}_i + ... + e_i.{cmd:y}

{pstd}
Or perhaps you had panel data and you fit the model with {cmd:xteregress}
by typing

            {cmd:xteregress y x1} ...{cmd:,} ...

{pstd}
Then the main equation would be

{p 12 14 2}
     {cmd:y}_{ij} = beta_0 + beta_1 {cmd:x1}_{ij} +
             ... + u_i.{cmd:y} + v_{ij}.{cmd:y}

{pstd}
In either case, {cmd:predict} calculates predictions for {cmd:y} in the main
equation.  The other equations in the model are called auxiliary equations or
complications.  Our discussion follows the cross-sectional case with a single
error term, but it applies to the panel-data case when we collapse the random
effects and observation-level error terms, e_{ij}.{cmd:y} = u_i.{cmd:y} +
v_{ij}.{cmd:y}.

{pstd}
The syntax of {opt predict} is

{p 8 16 2}
{cmd:predict} {dtype} {newvar}
{ifin}
[{cmd:,} {it:stdstatistics} {it:howcalculated}]

{marker stdstatistics_options}
{synoptset 25}{...}
{synopthdr:stdstatistics}
{synoptline}
{synopt :{opt m:ean}}linear prediction; the default{p_end}
{synopt :{opt xb}}linear prediction excluding all complications{p_end}
{synoptline}

{marker howcalculated_options}{...}
{synopthdr:howcalculated}
{synoptline}
{synopt :default}not fixed; base values from data{p_end}
{synopt :{opth fix:(eregress_predict##endogvars:endogvars)}}fix specified
endogenous covariates{p_end}
{synopt :{opth base:(eregress_predict##valspecs:valspecs)}}specify base values
of any variables{p_end}
{synopt :{opth targ:et(eregress_predict##valspecs:valspecs)}}more convenient
way to specify {cmd:fix()} and {cmd:base()}{p_end}
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
(1) {opt predict} can also calculate treatment-effect statistics.
      See {helpb erm_predict_treatment:[ERM] predict treatment}.

{phang2}
(2) {opt predict} can also make predictions for the other 
      equations in addition to the main-equation predictions 
      discussed here.  See {helpb erm_predict_advanced:[ERM] predict advanced}.


{marker description}{...}
{title:Description}

{pstd}
In this entry, we show how to create new variables containing
observation-by-observation predictions after fitting a model with
{cmd:eregress} and {cmd:xteregress}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM eregresspredictRemarksandexamples:Remarks and examples}

        {mansection ERM eregresspredictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker opts_stat}{...}
{title:Options for statistics}

{phang}
{opt mean}
specifies that the linear prediction be calculated.  In each
observation, the linear prediction is the expected value of the
dependent variable conditioned on the covariates.
Results depend on how complications are handled, which is
determined by the
{help eregress_predict##howcalculated_options:{it:howcalculated}} options.

{phang}
{opt xb} specifies that the linear prediction be calculated 
ignoring all complications.  This prediction corresponds to 
what would be observed in data in which all the covariates in 
the main equation were exogenous.


{marker opts_how}{...}
{title:Options for how results are calculated}

{pstd}
By default, predictions are calculated taking into account all
complications.  This is discussed in
{mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.

{phang}
{cmd:fix(}{varname} ...{cmd:)} specifies a list of endogenous variables
from the main equation to be treated as if they were exogenous.
This was discussed in {manlink ERM Intro 3} and is discussed further
in {mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.

{phang}
{cmd:base(}{varname} {cmd:=} ...{cmd:)} specifies a list of variables from any
equation and values for them.  Those values will be used in calculating the
expected value of e_i.{cmd:y} (or e_{ij}.{cmd:y} in the panel case).
Errors from other equations spill over into
the main equation because of correlations between errors.  The correlations
were estimated when the model was fit.  The amount of spillover depends on
those correlations and the values of the errors.  This issue was discussed in
{manlink ERM Intro 3} and is discussed further in
{mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.

{phang}
{cmd:target(}{varname} {cmd:=} ...{cmd:)} is sometimes a more convenient way to
specify the {opt fix()} and {opt base()} options.  You specify a list of
variables from the main equation and values for them.  Those values override
the values of the variables calculating beta_0 + beta_1{cmd:x1}_i + ....
Use of {opt target()} is discussed in
{mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
of {bf:[ERM] eregress predict}.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse class10}{p_end}
{phang2}
{cmd:. eregress gpa income, endogenous(hsgpa = income i.hscomp)}{p_end}
{phang2}
{cmd:. generate orig=hsgpa}{p_end}

{pstd}
Predict college GPA, accounting for endogeneity of {cmd:hsgpa}{p_end}
{phang2}
{cmd:. predict gpahat}{p_end}

{pstd}
Predict college GPA, treating {cmd:hsgpa} as exogenous{p_end}
{phang2}
{cmd:. predict gpafix, fix(hsgpa)}{p_end}

{pstd}
Predict college GPA, setting {cmd:hsgpa=2} and treating it as exogenous{p_end}
{phang2}
{cmd:. replace hsgpa=2}{p_end}
{phang2}
{cmd:. predict gpafix2, fix(hsgpa)}{p_end}

{pstd}
Predict college GPA, setting {cmd:hsgpa=2} and accounting for {cmd:hscomp}
and the unobserved characteristics that lead to correlation between 
{cmd:hsgpa} and {cmd:gpa} {p_end}
{phang2}
{cmd:. predict gpa_base2, base(hsgpa=orig)}{p_end}

{pstd}
Clean up{p_end}
{phang2}
{cmd:. replace hsgpa=orig}
{p_end}
