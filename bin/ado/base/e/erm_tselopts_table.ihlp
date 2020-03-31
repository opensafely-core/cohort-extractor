{* *! version 1.0.2  26mar2019}{...}
{marker tselopts}{...}
{synoptset 31 tabbed}{...}
{synopthdr:tselopts}
{synoptline}
{syntab :Model}
{p2coldent:* {cmd:ll(}{varname}|{it:#}{cmd:)}}left-censoring variable or limit{p_end}
{p2coldent:* {cmd:ul(}{varname}|{it:#}{cmd:)}}right-censoring variable or limit{p_end}
{synopt :{opt main}}add censored selection variable to main equation{p_end}
{synopt :{opt nore}}do not include random effects in tobit selection model{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model
with coefficient constrained to 1{p_end}
{synoptline}
{p 4 6 2}* You must specify either {cmd:ll()} or {cmd:ul()}.{p_end}
