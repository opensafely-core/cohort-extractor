{* *! version 1.0.1  04dec2018}{...}
{synopt :{opt nchains(#)}}number of chains; default is to simulate one
chain{p_end}
{synopt :{opt mcmcs:ize(#)}}MCMC sample size; default is
{cmd:mcmcsize(10000)}{p_end}
{synopt :{opt burn:in(#)}}burn-in period; default is {cmd:burnin(2500)}{p_end}
{synopt :{opt thin:ning(#)}}thinning interval; default is
{cmd:thinning(1)}{p_end}
{synopt :{opt rseed(#)}}random-number seed{p_end}
{synopt :{opth excl:ude(bayesmh##paramref:paramref)}}specify model parameters to be excluded from the simulation results{p_end}
