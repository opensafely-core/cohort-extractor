{* *! version 1.0.0  22jun2019}{...}
{phang2}
{cmd:serule} selects lambda* based on the "one-standard-error rule"
recommended by Hastie, Tibshirani, and Wainwright (2015, 13-14) instead of the
lambda that minimizes the CV function.  The one-standard-error rule selects
the largest lambda for which the CV function is within a standard error of the
minimum of the CV function.
