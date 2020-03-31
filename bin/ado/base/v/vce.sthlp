{smcl}
{* 23sep2002}{...}
{hline}
help for {hi:vce}{right:dialog:  {dialog vce}{space 18}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:vce} continues to work but, as of Stata 9, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb estat vce} for an updated command.


{title:Display variance-covariance matrix of estimators after model estimation}

{p 8 12 2}{cmd:vce} [{cmd:,} {cmdab:c:orr} {cmdab:r:ho} ]


{title:Description}

{p 4 4 2}
{cmd:vce} displays the variance-covariance matrix of the estimators (VCE)
after model fitting.  {cmd:vce} may be used after any estimation command.

{p 4 4 2}
To obtain a copy of the variance-covariance matrix for manipulation, type
{cmd:matrix V = e(V)}

{p 4 4 2}
{cmd:vce} merely displays the matrix; it does not fetch it.


{title:Options}

{p 4 8 2}{cmd:corr} and {cmd:rho} are synonyms; either displays the matrix as a
correlation rather than a covariance matrix.


{title:Examples}

    {cmd:. regress mpg weight displ}
    {cmd:. vce}

    {cmd:. logistic outcome age sex}
    {cmd:. vce, corr}


{title:Also see}

{p 4 13 2}
Manual:  {hi:[U] 23 Estimation and post-estimation commands},{break}
{hi:[R] vce}

{p 4 13 2}
{space 2}Help:  {help estcom}, {help postest}
