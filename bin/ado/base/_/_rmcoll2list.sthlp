{smcl}
{* *! version 1.0.4  27jun2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_rmcoll2list##syntax"}{...}
{viewerjumpto "Description" "_rmcoll2list##description"}{...}
{viewerjumpto "Options" "_rmcoll2list##options"}{...}
{viewerjumpto "Remarks" "_rmcoll2list##remarks"}{...}
{title:Title}

{p2colset 5 25 27 2}{...}
{p2col:{hi:[P] _rmcoll2list} {hline 2}}Programmer's command to check for 
collinearity in the union of two lists of variables{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:_rmcoll2list}{cmd:,} {opt alist(varlist)} {opt blist(varlist)}
{opt normwt(varname)} {opt touse(varname)} [{cmd:name(}{it:string}{cmd:)}]

{synoptset 18}{...}
{synopthdr}
{synoptline}
{synopt: {opt alist(varlist)}}first list of variables{p_end}
{synopt: {opt blist(varlist)}}second list of variables{p_end}
{synopt: {opt normwt(varname)}}normalized weight variable{p_end}
{synopt: {opt touse(varname)}}marks estimation sample{p_end}
{synopt: {cmd:name(}{it:string}{cmd:)}}used to label output{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_rmcoll2list} takes two lists of variables, A and B; forms the
union of the two lists; and then checks for collinearity, removing variables
in the B list if necessary to obtain a linearly independent set.  The
variables in A are assumed to be linearly independent, as are
the variables in B; you must use {cmd:_rmcoll} or some such on
each list individually before calling {cmd:_rmcoll2list}.  Returned in
{cmd:r(blist)} is the subset of the B list that together with the A list
forms a linearly independent set of variables.


{marker options}{...}
{title:Options}

{phang} 
{opt alist(varlist)} contains the first list of variables.

{phang} 
{opt blist(varlist)} contains the second set of variables.  
These variables are considered for elimination to obtain a linearly 
independent set.

{phang} 
{opt normwt(varname)} contains a normalized weight variable.  
If your command takes {cmd:fweight}s, {cmd:pweight}s, {cmd:aweight}s, or
{cmd:iweight}s, you must create a new variable containing the normalized
weights, where the normalization process is discussed in 
{it:Methods and formulas} of {bf:[R] regress}.  This is necessary because Mata
understands only one type of weight variable.  If your command does not accept
weights, create a temporary variable containing one for every observation.

{phang}
{opt touse(varname)} contains a 0/1 variable that marks the estimation 
sample.

{phang}
{cmd:name(}{it:string}{cmd:)} controls how dropped variables are labeled.
See {it:Remarks} below.


{marker remarks}{...}
{title:Remarks}

{pstd} 
{cmd:_rmcoll2list} is used to form a linearly independent set of
variables from two smaller sets of linearly independent variables,
removing variables from the second list if necessary.  For example,
{cmd:ivregress} first checks that the set of endogenous and included
exogenous regressors are not collinear.  It then checks that the
additional instruments are not collinear.  Finally, it calls
{cmd:_rmcoll2list} to ensure that the endogenous, exogenous, and
instrumental variables are not collinear, eliminating instruments if
necessary to avoid collinearity.  By using {cmd:_rmcoll2list} instead of
{cmd:_rmcoll}, we ensure that additional instruments are eliminated (if
necessary) and that our noncollinear set of endogenous and exogenous
regressors is kept intact.

{pstd} 
If the {cmd:name(}{it:string}{cmd:)} option is not specified and a 
member of the second list must be removed, the message

{pmore}
note: {it:varname} dropped because of collinearity

{pstd}
is displayed.  If you specify, say, {cmd:name(inst)}, because your 
command has an option named {cmd:inst()}, the error message is

{pmore}
note: {it:varname} dropped from inst() because of collinearity
{p_end}
