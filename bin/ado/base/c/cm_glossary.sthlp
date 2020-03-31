{smcl}
{* *! version 1.0.0  28apr2019}{...}
{vieweralsosee "[CM] Glossary" "mansection CM Glossary"}{...}
{viewerjumpto "Description" "cm_glossary##description"}{...}
{viewerjumpto "Glossary" "cm_glossary##glossary"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[CM] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection CM Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:alternatives}.
The set of alternatives are the possible choices a decision maker can
pick or rank.

{phang}
{bf:alternative-specific variable}.
When a variable varies across alternatives, it is
called alternative specific.  An alternative-specific variable may 
vary across alternatives only or across both alternatives and 
cases.

{phang}
{bf:alternatives variable}.
A numeric or string variable that identifies the alternatives.
Some models require an alternatives variable and some do not.

{phang}
{bf:balanced}.
When choice sets are the same for every case, we say that they are
balanced.

{phang}
{bf:case}.
This is a Stata term for the set of Stata observations representing a single
decision.  A case contains one observation for each of the possible
alternatives that the decision maker could have chosen or ranked.

{phang}
{bf:case ID variable}.
A variable that identifies the cases.  For independent cross-sectional 
data, this variable identifies the decision makers.

{phang}
{bf:case-specific variable}.
When a variable is constant within a case, it is called case specific.

{phang}
{bf:choice set}.
The set of alternatives a decision maker could have chosen or ranked.
The choice sets can vary across cases.

{phang}
{bf:discrete choice}.
When each decision maker picks a single alternative from his or her
set of possible alternatives, it is called a discrete choice.

{phang}
{bf:independence of irrelevant alternatives (IIA)}.
The IIA property is true when adding another alternative to the set of
alternatives does not change the relative probabilities of choosing 
alternatives from the initial set of alternatives.

{phang}
{bf:observation}.
For choice models in Stata, there is a difference between Stata observations
and statistical observations.  We call a statistical observation a case.
When we refer to an observation, we mean a Stata observation -- one row in the
dataset.

{phang}
{bf:panel data}.
When decision makers make multiple choices at different time points,
the data are panel data.  A panel variable identifies decision makers,
and a time variable identifies the time points.

{phang}
{bf:rank-ordered alternatives}.
When each decision maker ranks his or her possible alternatives, we say
we have rank-ordered alternatives.

{phang}
{bf:unbalanced}.
When choice sets are not the same for every case, we say that they are
unbalanced.

{phang}
{bf:utility}.
Choice models are typically formulated using a latent continuous variable,
called the utility, for each alternative.  The largest value of the 
utility for each case represents the alternative chosen for discrete choices.
For rank-ordered alternatives, the ranking of the values of the utilities
gives the rank ordering of the choices.
{p_end}
