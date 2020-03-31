{* *! version 1.0.0  27feb2019}{...}
{p2coldent:* {opth n(numlist)}}total sample size; required to compute
  CI width and probability of CI width{p_end}
{p2coldent:* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent:* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, {cmd:N2/N1}; default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt :{cmd:compute(N1}|{cmd:N2)}}solve for {cmd:N1} given {cmd:N2} or for {cmd:N2} given {cmd:N1}{p_end}
