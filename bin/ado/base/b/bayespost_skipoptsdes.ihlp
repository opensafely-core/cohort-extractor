{* *! version 1.0.0  04dec2018}{...}
{phang}
{opt skip(#)} specifies that every {it:#} observations from the MCMC sample
not be used for computation.  The default is {cmd:skip(0)} or to use all
observations in the MCMC sample.  Option {opt skip()} can be used to subsample
or thin the chain.  {opt skip(#)} is equivalent to a thinning interval of
{it:#}+1.  For example, if you specify {cmd:skip(1)}, corresponding to the
thinning interval of 2, the command will skip every other observation in the
sample and will use only observations 1, 3, 5, and so on in the computation.
If you specify {cmd:skip(2)}, corresponding to the thinning interval of 3, the
command will skip every 2 observations in the sample and will use only
observations 1, 4, 7, and so on in the computation. {cmd:skip()} does not thin
the chain in the sense of physically removing observations from the sample, as
is done by, for example, {cmd:bayesmh}'s {cmd:thinning()} option.  It only
discards selected observations from the computation and leaves the original
sample unmodified.
{p_end}
