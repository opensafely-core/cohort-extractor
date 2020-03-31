{* *! version 1.0.0  22jun2019}{...}
{phang}
{cmd:resample}[{cmd:(}{it:#}{cmd:)}] specifies that sample splitting be
repeated and results averaged.  This reduces the effects of the randomness of
sample splitting on the estimated coefficients.  Not specifying {cmd:resample}
or {opt resample(#)} is equivalent to specifying {cmd:resample(1)}.  In other
words, by default no resampling is done.  Specifying {cmd:resample} alone is
equivalent to specifying {cmd:resample(10)}.  That is, sample splitting is
repeated 10 times.  For each sample split, lassos are computed.  So when this
option is not specified, lassos are repeated {opt xfolds(#)} times.  But when
{opt resample(#)} is specified, lassos are repeated {opt xfolds(#)} x 
{opt resample(#)} times.  Thus, while we recommend using {cmd:resample} to get
final results, note that it can be an extremely time-consuming procedure.
