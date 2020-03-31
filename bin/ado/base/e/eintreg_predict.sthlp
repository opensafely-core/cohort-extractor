{smcl}
{* *! version 1.0.4  19jun2019}{...}
{viewerdialog "predict after eintreg" "dialog eintreg_p"}{...}
{viewerdialog "predict after xteintreg" "dialog eintreg_p"}{...}
{vieweralsosee "[ERM] eintreg predict" "mansection ERM eintregpredict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg" "help eintreg"}{...}
{vieweralsosee "[ERM] eintreg postestimation" "help eintreg postestimation"}{...}
{viewerjumpto "Syntax" "eintreg predict##syntax"}{...}
{viewerjumpto "Description" "eintreg predict##description"}{...}
{viewerjumpto "Links to PDF documentation" "eintreg_predict##linkspdf"}{...}
{viewerjumpto "Options for statistics" "eintreg predict##opts_stat"}{...}
{viewerjumpto "Options for how results are calculated" "eintreg predict##opts_how"}{...}
{viewerjumpto "Examples" "eintreg predict##examples"}{...}
{p2colset 1 26 35 2}{...}
{p2col:{bf:[ERM] eintreg predict} {hline 2}}predict after eintreg and
xteintreg{p_end}
{p2col:}({mansection ERM eintregpredict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
You previously fit the model 

            {cmd:eintreg yl yu x1} ...{cmd:,} ...

{pstd}
The equation specified immediately after the {cmd:eintreg} command
is called the main equation.  It is

            {cmd:y}_i = beta_0 + beta_1{cmd:x1}_i + ... + e_i.{cmd:y}

{pstd}
where {cmd:yl}_i {ul:<} y_i {ul:<} {cmd:yu}_i.

{pstd}
Or perhaps you had panel data and you fit the model with {cmd:xteintreg}
by typing

            {cmd:xteintreg yl yu x1} ...{cmd:,} ...

{pstd}
Then the main equation would be

            {cmd:y}_{ij} = beta_0 + beta_1{cmd:x1}_{ij} + ... + u_i.{cmd:y} + v_{ij}.{cmd:y}

{pstd}
where {cmd:yl}_{ij} {ul:<} y_{ij} {ul:<} {cmd:yu}_{ij}.

{pstd}
In either case, {cmd:predict} calculates predictions for {cmd:y} in the main
equation.  The other equations in the model are called auxiliary equations or
complications.  Our discussion follows the cross-sectional case with a single
error term, but it applies to the panel-data case when we collapse the random
effects and observation-level error terms,
e_{ij}.{cmd:y} = u_i.{cmd:y} + v_{ij}.{cmd:y}.

{pstd}
The syntax of {cmd:predict} is

{p 8 16 2}
{cmd:predict} {dtype} {newvar}
{ifin}
[{cmd:,} {it:stdstatistics} {it:howcalculated}]

{marker stdstatistics_options}{...}
{synoptset 25}{...}
{synopthdr:stdstatistics}
{synoptline}
{synopt :{opt m:ean}}linear prediction; the default{p_end}
{synopt :{opt xb}}linear prediction excluding all complications{p_end}
{synopt :{opt ys:tar(a,b)}}E(y*_j), y*_j = max{c -(}a, min(y_j, b){c )-}{p_end}
{synoptline}
{p 4 6 2}
{it:a} and {it:b} are numeric values, missing ({cmd:.}), or variable names.

{marker howcalculated_options}{...}
{synopthdr:howcalculated}
{synoptline}
{synopt :default}not fixed; base values from data{p_end}
{synopt :{opth fix:(eintreg_predict##endogvars:endogvars)}}fix specified
endogenous covariates{p_end}
{synopt :{opth base:(eintreg_predict##valspecs:valspecs)}}specify base values
of any variables{p_end}
{synopt :{opth targ:et(eintreg_predict##valspecs:valspecs)}}more convenient
way to specify {opt fix()} and {opt base()}{p_end}
{synoptline}

{p 4 6 2}
Note: The {cmd:fix()} and {cmd:base()} options affect results
only in models with endogenous variables in the main equation.
The {cmd:target()} option is sometimes a more convenient way 
to specify the {cmd:fix()} and {cmd:base()} options.

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
{cmd:eintreg} or {cmd:xteintreg}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM eintregpredictRemarksandexamples:Remarks and examples}

        {mansection ERM eintregpredictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker opts_stat}{...}
{title:Options for statistics}

{phang}
{opt mean}
specifies that the linear prediction be calculated.  In each
observation, the linear prediction is the expected value of the
dependent variable y conditioned on the covariates.
Results depend on how complications are handled, which is
determined by the
{help eintreg_predict##howcalculated_options:{it:howcalculated}} options.

{phang}
{cmd:xb} specifies that the linear prediction be calculated 
ignoring all complications.  This prediction corresponds to 
what would be observed in data in which all the covariates in 
the main equation were exogenous.

{phang}
{opt ystar(a,b)}
specifies that the linear prediction be censored between 
{it:a} and {it:b}.  If {it:a} is missing ({cmd:.}), then 
{cmd:a} is treated as -infty.  If {it:b} is missing ({cmd:.}), then 
{it:b} is treated as +infty.  {it:a} and {it:b} can be 
specified as numeric values, missing ({cmd:.}), or variable names.


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
{cmd:base(}{varname} {cmd:=} ...{cmd:)} specifies a list of 
variables from any equation and values for them.  Those values
will be used in calculating the expected value of
e_i.{cmd:y} (or e_{ij}.{cmd:y} in the panel case).  Errors from other
equations spill over into the main equation because of correlations between
errors.  The correlations were estimated when the model was fit.  The amount of
spillover depends on those correlations and the values of the errors.  This
issue was discussed in {manlink ERM Intro 3} and is discussed further in
 {mansection ERM eregresspredictRemarksandexamples:{it:Remarks and examples}}
 of {bf:[ERM] eregress predict}.

{phang}
{cmd:target(}{varname} {cmd:=} ...{cmd:)} is sometimes a more convenient way to
specify the {cmd:fix()} and {cmd:base()} options.  You specify a list of
variables from the main equation and values for them.  Those values override
the values of the variables calculating beta_0 + beta_1{cmd:x1}_i + ....
Use of {cmd:target()} is discussed in
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
{cmd:. eintreg gpal gpau income, endogenous(hsgpa = income i.hscomp)}{p_end}
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
{cmd:hsgpa} and college GPA{p_end}
{phang2}
{cmd:. predict gpa_base2, base(hsgpa=orig)}{p_end}

{pstd}
Clean up{p_end}
{phang2}
{cmd:. replace hsgpa=orig}
{p_end}
