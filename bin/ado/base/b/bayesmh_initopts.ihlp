{* *! version 1.0.2  04dec2018}{...}
{synopt: {opth init:ial(bayesmh##initspec:initspec)}}specify initial values
for model parameters with a single chain{p_end}
{synopt: {cmd:init}{it:#}{cmd:(}{it:{help bayesmh##initspec:initspec}}{cmd:)}}specify initial values for {it:#}th chain;
requires {cmd:nchains()}{p_end}
{synopt: {opth initall:(bayesmh##initspec:initspec)}}specify initial values
for all chains; requires {cmd:nchains()}{p_end}
{synopt: {opt nomleinit:ial}}suppress the use of maximum likelihood estimates
as starting values{p_end}
{synopt: {opt initrand:om}}specify random initial values{p_end}
{synopt: {opt initsumm:ary}}display initial values used for simulation{p_end}
