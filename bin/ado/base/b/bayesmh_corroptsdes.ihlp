{* *! version 1.0.0  10jan2017}{...}
{phang}
{opt corrlag(#)} specifies the maximum autocorrelation lag used for
calculating effective sample sizes.  The default is
min{500,{cmd:mcmcsize()}/2}.  The
total autocorrelation is computed as the sum of all lag-k autocorrelation
values for k from 0 to either {opt corrlag()} or the index at which the
autocorrelation becomes less than {opt corrtol()} if the latter is less than
{opt corrlag()}.
INCLUDE help bayesmh_corrlagbatch

{phang}
{opt corrtol(#)} specifies the autocorrelation tolerance used for calculating
effective sample sizes.  The default is {cmd:corrtol(0.01)}. For a given model
parameter, if the absolute value of the lag-k autocorrelation is less than
{opt corrtol()}, then all autocorrelation lags beyond the kth lag are
discarded.
INCLUDE help bayesmh_corrtolbatch
