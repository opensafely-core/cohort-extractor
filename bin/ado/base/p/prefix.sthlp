{smcl}
{* *! version 1.1.11  18may2019}{...}
{findalias asfrprefix}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (estimation)" "help estcom"}{...}
{viewerjumpto "Syntax" "prefix##syntax"}{...}
{viewerjumpto "Description" "prefix##description"}{...}
{viewerjumpto "Remarks" "prefix##remarks"}{...}
{viewerjumpto "Examples" "prefix##examples"}{...}
{title:Title}

{p 4 13 2}{findalias frprefix}


{marker syntax}{...}
{title:Syntax}

	{it:prefix ...}{cmd::} {it:command} {it:...}

{p2colset 5 18 20 2}{...}
{p2col:{it:prefix}}Description{p_end}
{p2line}
{p2col:{helpb by}}run command on subsets of data{p_end}
{p2col:{helpb frames prefix:frame}}run command on the data in a
specified frame{p_end}
{p2col:{helpb statsby}}same as {cmd:by}, but collect statistics from each
	run{p_end}
{p2col:{helpb rolling}}run command on moving subsets and collect
	statistics{p_end}

{p2col:{helpb bootstrap}}run command on bootstrap samples{p_end}
{p2col:{helpb jackknife}}run command on jackknife subsets of data{p_end}
{p2col:{helpb permute}}run command on random permutations{p_end}
{p2col:{helpb simulate}}run command on manufactured data{p_end}

{p2col:{helpb svy}}run command and adjust results for survey sampling{p_end}
{p2col:{helpb mi estimate}}run command on multiply imputed data and adjust
         results for multiple imputation (MI){p_end}

{p2col:{helpb bayes}}fit model as a Bayesian regression{p_end}
{p2col:{helpb fmm}}fit model using finite mixture modeling{p_end}

{p2col:{helpb nestreg}}run command with accumulated blocks of regressors
	and report nested model comparison tests{p_end}
{p2col:{helpb stepwise}}run command with stepwise variable
	inclusion/exclusion{p_end}

{p2col:{helpb xi}}run command after expanding factor variables and 
	interactions; for most commands, using factor variables is preferred
        to using {cmd:xi} (see {help fvvarlist}){p_end}

{p2col:{helpb fp}}run command with fractional polynomials of one regressor
        {p_end}
{p2col:{helpb mfp}}run command with multiple fractional polynomial regressors 
        {p_end}

{p2col:{helpb capture}}run command and capture its return code{p_end}
{p2col:{helpb noisily}}run command and show the output{p_end}
{p2col:{helpb quietly}}run command and suppress the output{p_end}
{p2col:{helpb version}}run command under specified version{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The last group -- {cmd:capture}, {cmd:noisily}, {cmd:quietly}, and
{cmd:version} -- deal with programming Stata and, for historical
reasons, {cmd:capture}, {cmd:noisily}, and {cmd:quietly} allow you to omit
the colon.


{marker description}{...}
{title:Description}

{pstd}
Prefix commands operate on other Stata commands.  They modify the input,
modify the output, or repeat execution of the {it:command}.  For example,
{helpb mfp} modifies the varlist of {it:command} by including fractional
polynomial terms.  {helpb svy} modifies the results of {it:command} to account
for complex survey data.  {helpb by} executes {it:command} on subgroups of the
data.

{pstd}
See {help language} for an overview of the Stata language.


{marker remarks}{...}
{title:Remarks}

{pstd}
Prefix commands are not allowed in all contexts.  For instance, {helpb svy},
{helpb nestreg}, and {helpb stepwise} may be used only with supported
estimation commands.  {helpb bootstrap}, {helpb jackknife}, ... make no sense
when combined with a command like {helpb generate}.

{pstd}
Many of the prefix commands can be combined.  For instance,

{phang2}
{cmd:nestreg: svy: regress brate (medage) (medagesq) (reg2-reg4)}

{pstd}
However, some combinations of prefix commands are not allowed.  For example,

{phang2}
{cmd:bootstrap: statsby: logit diabetes female age}

{pstd}
is not allowed because {cmd:statsby} saves results to a dataset and not in
{cmd:r()} or {cmd:e()}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. by foreign (make), sort: summarize rep78}{p_end}
{phang}{cmd:. statsby, by(foreign): regress mpg gear turn}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. bootstrap, reps(100): regress mpg weight gear foreign}

{phang}{cmd:. webuse nhanes2d, clear}{p_end}
{phang}{cmd:. svy, subpop(female): logistic highbp height weight age c.age#c.age}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. mfp: regress mpg weight displacement foreign}{p_end}
{phang}{cmd:. bayes: regress price length i.foreign}{p_end}
