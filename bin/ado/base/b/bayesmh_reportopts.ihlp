{* *! version 1.0.2  04dec2018}{...}
{synopt :{opt clev:el(#)}}set credible interval level; default is {cmd:clevel(95)}{p_end}
{synopt :{opt hpd}}display HPD credible intervals instead of the default equal-tailed credible intervals{p_end}
INCLUDE help bayesmh_eform
{synopt :{opt batch(#)}}specify length of block for batch-means calculations;
default is {cmd:batch(0)}{p_end}
{synopt :{cmdab:sav:ing(}{help filename:{it:filename}}{cmd:, replace)}}save
simulation results to {it:filename}{cmd:.dta}{p_end}
{synopt :{opt nomodelsumm:ary}}suppress model summary{p_end}
{synopt :{opt noexpr:ession}}suppress output of expressions from model
summary{p_end}
{synopt :{opt chainsdetail}}display detailed simulation summary for each
chain{p_end}
{synopt :[{cmd:no}]{opt dots}}suppress dots or display dots every 100
iterations and iteration numbers every 1,000 iterations; default is {cmd:nodots}{p_end}
{synopt :{cmd:dots(}{it:#}[{cmd:,} {opt every(#)}]{cmd:)}}display dots as
simulation is performed {p_end}
{synopt :[{cmd:no}]{opth show:(bayesmh##paramref:paramref)}}specify model
parameters to be excluded from or included in the output{p_end}
{synopt :{cmdab:showre:ffects}[{cmd:(}{it:{help bayesian_postestimation##bayesian_post_reref:reref}}{cmd:)}]}specify that all or a subset of random-effects parameters be included in the output{p_end}
{synopt :{opt notab:le}}suppress estimation table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt title(string)}}display {it:string} as title above the table of
parameter estimates{p_end}
{synopt :{help bayesmh##display_options:{it:display_options}}}control spacing,
line width, and base and empty cells{p_end}
