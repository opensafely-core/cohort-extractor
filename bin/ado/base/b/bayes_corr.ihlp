{* *! version 1.0.0  12mar2015}{...}
{phang}
{opt corrlag(#)} specifies the maximum autocorrelation lag used for
calculating effective sample sizes.  The default is
min{c -(}500,{cmd:mcmcsize()}/2{c )-}.  The total autocorrelation is computed
as the sum of all lag-k autocorrelation values for k from 0 to either
{cmd:corrlag()} or the index at which the autocorrelation becomes less than
{cmd:corrtol()} if the latter is less than {cmd:corrlag()}.
Options {cmd:corrlag()} and {cmd:batch()} may not be combined.

{phang}
{opt corrtol(#)} specifies the autocorrelation tolerance used for
calculating effective sample sizes.  The default is {cmd:corrtol(0.01)}. For a
given model parameter, if the absolute value of the lag-k autocorrelation is
less than {cmd:corrtol()}, then all autocorrelation lags beyond the kth lag
are discarded.  Options {cmd:corrtol()} and {cmd:batch()} may not be combined.
{p_end}
