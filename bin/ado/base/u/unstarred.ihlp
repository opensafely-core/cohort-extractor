{* *! version 1.0.1  29mar2007}{...}
{p 4 6 2} Unstarred statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.  Starred statistics are calculated only for the estimation
sample, even when {cmd:if e(sample)} is not specified.{p_end}
