{smcl}
{* *! version 1.0.1  05feb2020}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{title:Default initial values with multiple chains}

{pstd}
Option {cmd:nchains()} with {helpb bayesmh} or the {helpb bayes} prefix
generates multiple simulation chains.  Each chain should use different initial
values for model parameters.  By default, maximum likelihood estimates (if
available) are used as initial values for the first chain, and random initial
values are used for subsequent chains.  Whenever
{help j_bayes_nchainsinit##feasible:feasible}, random initial values are
generated from the prior distributions; see
{help j_bayes_nchainsinit##randinit:How are default initial values generated?}
for details.

{pstd}
Default initial values are provided for convenience. To detect nonconvergence, 
you should use
{help bayes_glossary##overdispersed_initial_value:overdispersed initial values}
with multiple chains.  Randomly generated default initial values are not
guaranteed to produce overdispersed initial values for all chains.  To fully
explore convergence, we recommend that you specify your own initial values
with multiple chains; see 
{help j_bayes_nchainsinit##initspec:How do I specify initial values for multiple chains?}

{pstd}
To see the initial values used, you can specify option {cmd:initsummary}
during estimation.  You can also check initial values prior to estimation by
specifying option {cmd:dryrun}.  The initial values are also stored in
matrix {cmd:e(init)} after estimation.

{pstd}
See {mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}} in {bf:[BAYES] bayesmh} and 
{mansection BAYES bayesRemarksandexamplesInitialvalues:{it:Initial values}} in 
{bf:[BAYES] bayes}.


{marker randinit}{...}
{title:How are default initial values generated?}

{pstd}
Option {cmd:nchains()} with {helpb bayesmh} or {helpb bayes_prefix:bayes},
by default, generates random initial values for model parameters for all but
the first chain.  Random initial values are generated from the prior
distributions whenever {help j_bayes_nchainsinit##feasible:feasible}, but you
can always specify {help j_bayes_nchainsinit##initspec:your own}.

{pstd}
For improper priors {cmd:flat}, {cmd:jeffreys}, and {opt jeffreys(#)}, 
{cmd:bayesmh} and the {cmd:bayes} prefix cannot draw random initial values 
directly from these priors.  Doing so would typically produce extreme values 
for model parameters for which the log likelihood would be missing.  See 
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}} in {bf:[BAYES] bayesmh} and 
{mansection BAYES bayesRemarksandexamplesInitialvalues:{it:Initial values}} in 
{bf:[BAYES] bayes} for details about how {cmd:bayesmh} and the {cmd:bayes} 
prefix generate default initial values with multiple chains.  We recommend
that, particularly with these priors, you provide your own initial values for
multiple chains; see 
{help j_bayes_nchainsinit##initspec:How do I specify initial values for multiple chains?}


{marker initspec}{...}
{title:How do I specify initial values for multiple chains?}

{pstd}
In the presence of multiple chains, you may often need to specify your own 
initial values. {helpb bayesmh} and {helpb bayes_prefix:bayes} provide 
options for you to do this: {cmd:init1()} specifies initial values for the 
first chain, {cmd:init2()} for the second chain, and so on.  The 
specification of options {cmd:init}{it:#}{cmd:()} is the same as that of 
option {cmd:initial()}, which specifies initial values when there is only 
one chain; see {help bayesmh##initspec:bayesmh, initial()} and 
{help bayes##initspec:bayes, initial()} for details.  In the presence of
multiple chains, option {cmd:initial()} is synonymous with option {cmd:init1()}
and specifies initial values for the first chain.

{pstd}
Suppose you have three chains. You can specify initial values for all three
chains using options {cmd:init}{it:#}{cmd:()}:

{pstd}
{cmd:.} {it:...}{cmd:, init1({a} 0 {b} 0) init2({a} 100 {b} 0.5) init3({a} -10 {b} 1)}

{pstd}
Or you can specify initial values only for the second chain and use the 
default initial values for chains 1 and 3:

{pstd}
{cmd:.} {it:...}{cmd:, init2({a} 100 {b} .5)}

{pstd}
Or you can specify initial values for any combination of chains.

{pstd}
In the above, we used fixed initial values.  We can also generate initial 
values randomly.  For example, we generate random initial values from a
normal distribution for parameter {cmd:{a}} and from a uniform distribution 
for parameter {cmd:{b}} by typing

{pstd}
{cmd:.} {it:...}{cmd:, init1({a} rnormal(0,1) {b} runiform(0,0.1))}{p_end}
{pstd}
>{cmd:      init2({a} rnormal(100,1) {b} runiform(0.4,0.6))}{p_end}
{pstd}
>{cmd:      init3({a} rnormal(-10,1) {b} runiform(0.9,1))}{p_end}

{pstd}
We can use other {help random_number_functions:random-number functions}.
More generally, we can use any Stata {help exp:expression} that evaluates to a
number to specify initial values.

{pstd}
For convenience, there is also option {cmd:initall()}, which applies 
the same specification for initial values to all chains.  This option can be 
useful when random initial values are used for all chains.  For example,

{pstd}
{cmd:.} {it:...}{cmd:, initall({a} rnormal(0, 100) {b} runiform(0,1))}

{pstd}
Although different initial values will be used for all chains, they are not
guaranteed to be 
{help bayes_glossary##overdispersed_initial_value:overdispersed}.  To ensure
that initial values are overdispersed, you will need to provide your own
initial values for all chains.

{pstd}
You should not specify fixed initial values in {cmd:initall()} because the
same initial values will be used by all chains.

{pstd}
See {mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh}, 
{mansection BAYES bayesRemarksandexamplesInitialvalues:{it:Initial values}}
in {bf:[BAYES] bayes}, and
{mansection BAYES bayesmhRemarksandexamplesMultiplechainsusingoverdispersedinitialvalues:{it:Multiple chains using overdispersed initial values}}
in {bf:[BAYES] bayesmh}.


{marker feasible}{...}
{title:Could not find feasible initial values when running multiple chains}

{pstd}
You specified option {cmd:nchains()} with {helpb bayesmh} or 
{helpb bayes_prefix:bayes} to simulate multiple chains but received a warning
message "could not find feasible initial state" for some of the chains.
If you specified your own initial values for the chains that failed, check
the feasibility of these initial values.  Otherwise, you are likely having
trouble with the default random initialization of the parameters.

{pstd}
Random initial values are generated when you specify option {cmd:nchains()} or
option {cmd:initrandom} and when you use random-number functions to specify
{help j_bayes_nchainsinit##initspec:your own} initial values.

{pstd}
When random initial values are generated from prior distributions, extreme
values may be produced for model parameters for some prior distributions,
especially for noninformative priors.  This may lead to missing log-likelihood
values.  The commands will attempt to generate several different sets of
initial values before terminating the simulation of a particular chain and
issuing the warning message.  In this case, you must specify your own initial
values for that chain; see 
{help j_bayes_nchainsinit##initspec:How do I specify initial values for multiple chains?}

{pstd}
See {mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} and 
{mansection BAYES bayesRemarksandexamplesInitialvalues:{it:Initial values}}
in {bf:[BAYES] bayes}.
{p_end}
