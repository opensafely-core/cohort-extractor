{smcl}
{* *! version 2.0.0  02mar2015}{...}
{findalias asfrestimate}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "help postestimation commands" "help postestimation_commands"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{viewerjumpto "Description" "estimation##description"}{...}
{viewerjumpto "Examples" "estimation##examples"}{...}
{title:Title}

{pstd}
{findalias frestimate}


{marker description}{...}
{title:Description}

{pstd}
See {help postestimation commands} for a list of Stata's postestimation
commands.   See {help estcom} for a description of estimation commands 
and their properties.

{pstd}
Estimation commands store results in {hi:e()}.  These stored results
remain available until the next estimation command is executed.
{hi:e()} acts as a function that returns the value of the named estimation
result from the last estimation command.  You can see what is available by
typing

	{cmd:. ereturn list}

{pstd}
after an estimation command.  See 
{helpb ereturn} and {helpb return}.

{pstd}
All estimation commands store {hi:e(sample)}, indicating which observations
were used in the estimation.  This can then be used with almost any
Stata command after estimation to restrict that command to the estimation
sample.


{marker examples}{...}
{title:Examples}

{pstd}
We use {helpb logit}; other estimation commands may also be used.{p_end}
{phang2}{cmd:. webuse lbw}{p_end}
{phang2}{cmd:. logit low i.smoke i.race age}

{pstd}
We can view the estimation matrices:{p_end}
{p 8 12 2}{cmd:. matrix list e(b)}{p_end}
{p 8 12 2}{cmd:. matrix list e(V)}

{pstd}
The {helpb estat vce} command provides another way of viewing the
covariance matrix:{p_end}
{p 8 12 2}{cmd:. estat vce}{p_end}
{p 8 12 2}{cmd:. estat vce, corr}{p_end}
{p 8 12 2}{cmd:. estat vce, eigen}

{pstd}
We can examine the Akaike and Bayesian information criteria:{p_end}
{p 8 12 2}{cmd:. estat ic}

{pstd}
We can summarize the variables involved in the estimation command over
the observations used in the estimation:{p_end}
{p 8 12 2}{cmd:. estat summarize}

{pstd}
Other postestimation commands may also be used.{p_end}
{p 8 12 2}{cmd:. margins smoke, at(age=15(5)45))}{p_end}
{p 8 12 2}{cmd:. marginsplot}{p_end}
{p 8 12 2}{cmd:. contrast race}{p_end}
{p 8 12 2}{cmd:. pwcompare race, effects mcompare(scheffe)}{p_end}
{p 8 12 2}{cmd:. lincom 1.smoke + 20*age}{p_end}
{p 8 12 2}{cmd:. linktest}{p_end}
{p 8 12 2}{cmd:. test 2.race = 3.race}{p_end}
{p 8 12 2}{cmd:. predict r, residuals}

{pstd}
The {cmd:coeflegend} option tells us how we can specify coefficients
in postestimation commands, such as {cmd:test}.{p_end}
{p 8 12 2}{cmd:. logit, coeflegend}

{pstd}
{hi:e(sample)} can be used with any other Stata command after
estimation.{p_end}
{p 8 12 2}{cmd:. summarize age if e(sample), detail}{p_end}
{p 8 12 2}{cmd:. summarize age if !e(sample), detail}

{pstd}
We can even obtain predictions on different data:{p_end}
{p 8 12 2}{cmd:. webuse newautos, clear}{p_end}
{p 8 12 2}{cmd:. predict mpg}{p_end}
