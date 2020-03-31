{* *! version 1.0.1  14feb2020}{...}
{phang3}
{cmd:serule} selects lambda* based on the "one-standard-error rule" recommended
by {help elasticnet##HTW2015:Hastie, Tibshirani, and Wainwright (2015, 13-14)}
instead of the lambda that minimizes the CV function.  The one-standard-error
rule selects the largest lambda for which the CV function is within a standard
error of the minimum of the CV function.
