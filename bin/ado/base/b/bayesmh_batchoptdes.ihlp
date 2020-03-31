{* *! version 1.0.1  03apr2019}{...}
{phang}
{opt batch(#)} specifies the length of the block for calculating batch means
and MCSE using batch means.  The default is {cmd:batch(0)}, which means no
batch calculations.  When {cmd:batch()} is not specified, MCSE is computed
using effective sample sizes instead of batch means.  Option {cmd:batch()} may
not be combined with {cmd:corrlag()} or {cmd:corrtol()}.
