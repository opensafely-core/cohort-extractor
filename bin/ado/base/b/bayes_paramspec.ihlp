{* *! version 1.0.2  15may2018}{...}
{phang}
{it:paramspec} can be one of the following: 

{p 8 8 2}
{cmd:{c -(}}{it:eqname}{cmd::}{it:param}{cmd:{c )-}} refers to a 
parameter {it:param} with equation name {it:eqname};

{p 8 8 2}
{cmd:{c -(}}{it:eqname}{cmd::}{cmd:{c )-}} refers to all model parameters
with equation name {it:eqname};

{p 8 8 2}
{cmd:{c -(}}{it:eqname}{cmd::}{it:paramlist}{cmd:{c )-}} refers to 
parameters with names in {it:paramlist} and with equation name {it:eqname}; or

{p 8 8 2}
{cmd:{c -(}}{it:param}{cmd:{c )-}} refers to all parameters named {it:param}
from all equations.

{p 8 8 2}
In the above, {it:param} can refer to a matrix name, in which case it will
imply all elements of this matrix. See {it:{mansection BAYES BayesianpostestimationRemarksandexamplesDifferentwaysofspecifyingmodelparameters:Different ways of specifying model parameters}} in {bf:[BAYES] Bayesian postestimation}
for examples.
{p_end}
