{* *! version 1.0.5  21mar2019}{...}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
   {cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; default is
   {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}total sample size; required to compute power or 
effect size{p_end}
{p2coldent:* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent:* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, {cmd:N2/N1}; default is
{cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt: {cmd:compute(N1}|{cmd:N2)}}solve for {cmd:N1} given {cmd:N2} or for
{cmd:N2} given {cmd:N1}{p_end}
