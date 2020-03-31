{smcl}
{* *! version 1.0.0  07feb2020}{...}
{vieweralsosee "[CM] cmclogit" "mansection CM cmclogit"}{...}
{vieweralsosee "[CM] cmmixlogit" "mansection CM cmmixlogit"}{...}
{vieweralsosee "[CM] cmxtmixlogit" "mansection CM cmxtmixlogit"}{...}
{title:Odds ratios and relative-risk ratios in multinomial choice models}

{pstd}
Choice models fit by {cmd:cmclogit}, {cmd:cmmixlogit}, and {cmd:cmxtmixlogit} 
display exponentiated coefficients when the {cmd:or} option is specified.
These models allow both alternative-specific and case-specific covariates, and
the interpretation of exponentiated coefficients differs depending on the type
of covariate.  For alternative-specific variables, the exponentiated
coefficients are odds ratios, as the option name implies.  However, for
case-specific variables, exponentiated coefficients are interpreted as
relative-risk ratios, similar to a conventional multinomial logistic
regression as fit by {cmd:mlogit} with the {cmd:rrr} option.
{p_end}
