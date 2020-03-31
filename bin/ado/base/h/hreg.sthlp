{smcl}
{* *! version 1.0.3  11feb2011}{...}
{title:Out-of-date commands}

    Rather than typing{col 41}Type
    {hline 29}        {hline 33}
    {cmd:hreg} {it:yvar xvars}{col 41}{cmd:regress} {it:yvar xvars}{cmd:, robust}
    {cmd:hreg} {it:yvar xvars}{cmd:, group(}{it:gvar}{cmd:)}{col 41}{cmd:regress} {it:yvar xvars}{cmd:, cluster(}{it:gvar}{cmd:)}
    {cmd:hreg} {it:yvar xvars} {cmd:[pw=}{it:w}{cmd:]}{col 41}{cmd:regress} {it:yvar xvars} {cmd:[pw=}{it:w}{cmd:]}
    {hline 29}        {hline 33}
{col 41}Note:  {cmd:cluster()} implies {cmd:robust}
{col 48}{cmd:pweight}s implies {cmd:robust}

{pstd}
The same applies to the other h* commands:  use the base command with options
{cmd:robust} and {cmd:cluster()}.

{pstd}
The only difference is that the new {cmd:robust} option applies a
degree-of-freedom correction to the VCE that the old h* commands did not.
{cmd:robust} is better.

    For help on the equivalent to{col 41}See
    {hline 29}{col 41}{hline 29}
    {cmd:hreg}{col 41}help {helpb regress}
    {cmd:hareg}{col 41}help {helpb areg}
    {cmd:hlogit}{col 41}help {helpb logit}
    {cmd:hprobit}{col 41}help {helpb probit}
    {cmd:hereg}{col 41}help {helpb streg}
    {hline 29}{col 41}{hline 29}

{pstd}
Programmers:  {cmd:_huber} is replaced by {helpb _robust}.
{p_end}
