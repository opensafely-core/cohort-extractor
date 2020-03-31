{smcl}
{* *! version 2.1.4  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "mansection SEM semandgsempathnotation"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{vieweralsosee "[SEM] Intro 6" "mansection SEM Intro6"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem path notation extensions" "help sem path notation extensions"}{...}
{vieweralsosee "[SEM] gsem path notation extensions" "help gsem path notation extensions"}{...}
{viewerjumpto "Syntax" "sem_and_gsem_path_notation##syntax"}{...}
{viewerjumpto "Description" "sem_and_gsem_path_notation##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_and_gsem_path_notation##linkspdf"}{...}
{viewerjumpto "Options" "sem_and_gsem_path_notation##options"}{...}
{viewerjumpto "Remarks" "sem_and_gsem_path_notation##remarks"}{...}
{viewerjumpto "Examples" "sem_and_gsem_path_notation##examples"}{...}
{p2colset 1 37 39 2}{...}
{p2col:{bf:[SEM] sem and gsem path notation} {hline 2}}Command syntax for
path diagrams{p_end}
{p2col:}({mansection SEM semandgsempathnotation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:paths} ... [{cmd:,} {opt covariance()} {opt variance()} 
            {opt means()}]

{p 8 12 2}
{cmd:gsem} {it:paths} ... [{cmd:,} {opt covariance()} {opt variance()} 
            {opt means()}]

{pstd}
{it:paths} specifies the direct paths between the variables of your model.

{pstd}
The model to be fit is fully described by {it:paths}, 
{opt covariance()}, {opt variance()}, and {opt means()}.


{marker description}{...}
{title:Description}

{pstd}
The command syntax for describing your SEM is fully
specified by {it:paths}, {opt covariance()}, {opt variance()}, and 
{opt means()}.  How this works is described below.

{pstd}
If you are using {cmd:sem}, also see
{helpb sem path notation extensions:[SEM] sem path notation extensions} for
documentation of the {cmd:group()} option for comparing different groups in
the data.  The syntax of the elements described below is modified when
{cmd:group()} is specified.

{pstd}
If you are using {cmd:gsem}, also see
{helpb gsem path notation extensions:[SEM] gsem path notation extensions} for
documentation on specification of family-and-link for generalized (nonlinear)
response variables,
specification of multilevel latent variables,
specification of categorical latent variables, and
specification of multiple-group models.
The syntax of the elements described below is modified when the
{opt group()} option for comparing different groups or the {opt lclass()}
option for categorical latent variables is specified.

{pstd}
Either way, read this section first.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semandgsempathnotationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt covariance()} is used to

{phang2}
1.  specify that a particular covariance path of your model that usually is
assumed to be 0 be estimated,

{phang2}
2.  specify that a particular covariance path that usually is assumed to be
nonzero is not to be estimated (to be constrained to be 0),

{phang2}
3.  constrain a covariance path to a fixed value, such as 0, 0.5, 1, etc., and

{phang2}
4.  constrain two or more covariance paths to be equal.

{phang}
{opt variance()} does the same as {opt covariance()} except it does it with
variances.

{phang}
{opt means()} does the same as {opt covariance()} except it does it with
means.


{marker remarks}{...}
{title:Remarks}

{pstd}
Path notation is used by the {cmd:sem} and {cmd:gsem} commands
to specify the model to be fit, for example,

{phang2}{cmd:. sem (x1 x2 x3 x4 <- X)}{p_end}

{phang2}{cmd:. gsem (L1 -> x1 x2 x3 x4 x5)}
           {cmd:(L2 -> x6 x7 x8 x9 x10)}{p_end}

{pstd}
In the path notation,

{phang}
1.  Latent variables are indicated by a {it:name} in which at least the first
letter is capitalized.

{phang}
2.  Observed variables are indicated by a {it:name} in which at least the first
letter is lowercased.  Observed variables correspond to variable names in the
dataset.

{phang}
3.  Error variables, while mathematically a special case of latent variables,
are considered in a class by themselves.  For {cmd:sem}, every endogenous
variable (whether observed or latent) automatically has an error variable
associated with it.  For {cmd:gsem}, the same is true of Gaussian endogenous
variables (and latent variables, which are Gaussian).  The error variable
associated with endogenous variable {it:name} is {cmd:e.}{it:name}.

{phang}
4.  Paths between variables are written as

{phang3}{cmd:(}{it:name1} {cmd: <- } {it:name2}{cmd:)}{p_end}

{p 8 8 2}
or

{phang3}{cmd:(}{it:name2} {cmd: -> } {it:name1}{cmd:)}{p_end}

{p 8 8 2}
There is no significance to which coding is used.

{phang}
5.  Paths between the same variables can be combined: The paths

{phang3}{cmd:(}{it:name1}{cmd: <- }{it:name2}{cmd:) (}{it:name1}
{cmd: <- }{it:name3}{cmd:)}{p_end}

{p 8 8 2}
can be combined as

{phang3}{cmd:(}{it:name1} {cmd: <- }{it:name2 name3}{cmd:)}{p_end}

{p 8 8 2}
or as

{phang3}{cmd:(}{it:name2 name3} {cmd: ->  }{it:name1}{cmd:)}{p_end}

{p 8 8 2}
The paths

{phang3}{cmd:(}{it:name1 <- name3}{cmd:) (}{it:name2} {cmd: <- }
{it:name3}{cmd:)}{p_end}

{p 8 8 2}
can be combined as

{phang3}{cmd:(}{it:name1 name2} {cmd: <- } {it:name3}{cmd:)}{p_end}


{marker varcov}{...}
{space 4}{title:Specifying variances and covariances}

{phang}
6.  Variances and covariances (curved paths) between variables are indicated
by options.  Variances are indicated by

{phang3}{cmd:..., ... var(}{it:name1}{cmd:)}{p_end}

{p 8 8 2}
Covariances are indicated by

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:)}{p_end}

{phang3}{cmd:..., ... cov(}{it:name2}{cmd:*}{it:name1}{cmd:)}{p_end}

{p 8 8 2}
There is no significance to the order of the names.

{p 8 8 2}
The actual names of the options are {opt variance()} and {opt covariance()},
but they are invariably abbreviated as {cmd:var()} and {cmd:cov()},
respectively.

{p 8 8 2}
The {opt var()} and {opt cov()} options are the same option, so a variance can
be typed as

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:)}{p_end}

{p 8 8 2}
and a covariance can be typed as

{phang3}{cmd:..., ... var(}{it:name1}{cmd:*}{it:name2}{cmd:)}{p_end}

{phang}
7.  Variances may be combined, covariances may be combined, and variances and
covariances may be combined.

{p 8 8 2}
If you have
 
{phang3}{cmd:..., ... var(}{it:name1}{cmd:) var(}{it:name2}{cmd:)}{p_end}

{p 8 8 2}
you may code this as

{phang3}{cmd:..., ... var(}{it:name1 name2}{cmd:)}{p_end}

{p 8 8 2}
If you have

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:) cov(}{it:name2}{cmd:*}{it:name3}{cmd:)}{p_end}

{p 8 8 2}
you may code this as

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:*}{it:name2 name2}{cmd:*}{it:name3}{cmd:)}{p_end}

{p 8 8 2}
All the above combined can be coded as

{phang3}{cmd:..., ... var(}{it:name1 name2 name1}{cmd:*}{it:name2 name2}{cmd:*}{it:name3}{cmd:)}{p_end}

{p 8 8 2}
or as

{phang3}{cmd:..., ... cov(}{it:name1 name2 name1}{cmd:*}{it:name2 name2}{cmd:*}{it:name3}{cmd:)}{p_end}

{phang}
8.  All variables except endogenous variables are assumed to have a variance;
it is only necessary to code the {cmd:var()} option if you wish to place a
constraint on the variance or specify an initial value.  See items
   {help sem and gsem path notation##item11:11},
   {help sem and gsem path notation##item12:12},
   {help sem and gsem path notation##item13:13}, and
   {help sem and gsem path notation##item16:16} below.
   (In {cmd:gsem}, the variance and covariances of observed exogenous variables
    are not estimated and thus {cmd:var()} cannot be used with them.)

{p 8 8 2}
Endogenous variables have a variance, of course, but that is the variance
implied by the model.  If {it:name} is an endogenous variable,
then {cmd:var(}{it:name}{cmd:)} is invalid.  The error variance of the
endogenous variable is {cmd:var(e.}{it:name}{cmd:)}.

{phang}
9.  Variables mostly default to being correlated:

{phang3}
a.  All exogenous variables are assumed to be correlated with each other,
whether observed or latent.

{phang3}
b.  Endogenous variables are never directly correlated, although their
associated error variables can be.

{phang3}
c.  All error variables are assumed to be uncorrelated with each other.

{p 8 8 2}
You can override these defaults on a variable-by-variable basis with the
{cmd:cov()} option.

{p 8 8 2}
To assert that two variables are uncorrelated that otherwise would be assumed
to be correlated, constrain the covariance to be 0:

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:@0)}{p_end}

{p 8 8 2}
To allow two variables to be correlated that otherwise would be assumed to be
uncorrelated, simply specify the existence of the covariance:

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:)}{p_end}

{p 8 8 2}
This latter is especially commonly done with errors:

{phang3}{cmd:..., .. cov(e.}{it:name1}{cmd:*e.}{it:name2}{cmd:)}{p_end}

{p 8 8 2}
(In {cmd:gsem}, you may not use the {cmd:cov()} option with observed exogenous
variables.  You also may not use {cmd:cov()} with error terms associated with
family Gaussian, link log.)

{phang}
10.  Means of variables are indicated by the following option:

{phang3}{cmd:..., ... means(}{it:name}{cmd:)}{p_end}

{p 8 8 2}
Variables mostly default to having nonzero means:

{phang2}
a.  All observed exogenous variables are assumed to have nonzero means.
In {cmd:sem}, the means can be constrained using the {cmd:means()} option, but
only if you are performing {cmd:noxconditional} estimation; see
{helpb sem_option_noxconditional:[SEM] sem option noxconditional}.

{phang2}
b.  Latent exogenous variables are assumed to have mean 0.  Means of latent
variables are not estimated by default.  If you specify enough normalization
constraints to identify the mean of a latent exogenous variable, you can
specify {opt means(Name)} to indicate that the mean should be estimated in
either.

{phang2}
c.  Endogenous variables have no separate mean.  Their means are those implied
by the model.  The {cmd:means()} option may not be used with endogenous
variables.

{phang2}
d.  Error variables have mean 0 and this cannot be modified.  The
{cmd:means()} option may not be used with error variables.

{p 8 8 2}
To constrain the mean to a fixed value, such as 57, code

{phang3}{cmd:..., ... means(}{it:name}{cmd:@57)}{p_end}

{p 8 8 2}
Separate {cmd:means()} options may be combined:

{phang3}{cmd:..., ... means(}{it:name1}{cmd:@57} {it:name2}{cmd:@100)}{p_end}

{marker item11}{...}
{p 3 8 2}
11.  Fixed-value constraints may be specified for a path, variance,
covariance, or mean by using {cmd:@} (the "at" symbol).  For example, {p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:@1)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:@1} {it:name3}{cmd:@1)}{p_end}

{phang3}{cmd:..., ... var(}{it:name}{cmd:@100)}{p_end}

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:*}{it:name2}{cmd:@223)}{p_end}

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:@1} {it:name2}{cmd:@1} {it:name1}{cmd:*}{it:name2}{cmd:@.8)}{p_end}

{phang3}{cmd:..., ... means(}{it:name}{cmd:@57)}{p_end}

{marker item12}{...}
{p 3 8 2}
12.  Symbolic constraints may be specified for a path, variance, covariance,
or mean by using {cmd:@} (the "at" symbol).  For example,

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:@c1}{cmd:) (}{it:name3}
{cmd:<-} {it:name4}{cmd:@c1}{cmd:)}{p_end}

{phang3}{cmd:..., ... var(}{it:name1}{cmd:@c1}
{it:name2}{cmd:@c1}{cmd:) cov(}{it:name1}{cmd:@1} {it:name2}{cmd:@1}
{it:name3}{cmd:@1} {it:name1}{cmd:*}{it:name2}{cmd:@c2}
{it:name1}{cmd:*}{it:name3}{cmd:@c2}{cmd:)}{p_end}

{phang3}{cmd:..., ... means(}{it:name1}{cmd:@c1} {it:name2}{cmd:@c1}{cmd:)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:@c1}{cmd:) ..., var(}{it:name3}{cmd:@c1}{cmd:) means(}{it:name4}{cmd:@c1}{cmd:)}{p_end}

{p 8 8 2}
Symbolic names are just names from 1 to 32 characters in length.  Symbolic
constraints constrain equality.  For simplicity, all constraints below will
have names {cmd:c1}, {cmd:c2}, ... 

{marker item13}{...}
{p 3 8 2}
13.  Linear combinations of symbolic constraints may be specified for
a path, variance, covariance, or mean by using {cmd:@} (the "at" sign).  For
example,

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:@c1}{cmd:) (}{it:name3} {cmd:<-}
{it:name4}{cmd:@(2*c1}{cmd:))}{p_end}

{phang3}{cmd:..., ... var(}{it:name1}{cmd:@c1} {it:name2}{cmd:@(c1}{cmd:/2))}{p_end}

{phang3}{cmd:..., ... cov(}{it:name1}{cmd:@1} {it:name2}{cmd:@1}
{it:name3}{cmd:@1} {it:name1}{cmd:*}{it:name2}{cmd:@c1}
{it:name1}{cmd:*}{it:name3}{cmd:@(c1}{cmd:/2))}{p_end}

{phang3}{cmd:..., ... means(}{it:name1}{cmd:@c1} {it:name2}{cmd:@(3*c1}{cmd:+10))}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:@(c1}{cmd:/2)) ..., var(}{it:name3}{cmd:@c1}{cmd:) means(}{it:name4}{cmd:@(2*c1}{cmd:))}{p_end}

{p 3 8 2}
14.  All equations in the model are assumed to have an intercept (to include
observed exogenous variable {cmd:_cons}) unless the {cmd:noconstant} option
(abbreviation {cmd:nocons}) is specified, and then all equations are assumed
not to have an intercept (not to include {cmd:_cons}).  (There are some
exceptions to this in {cmd:gsem} because some generalized linear models have
no intercept or even the concept of an intercept.)

{p 8 8 2}
Regardless of whether {cmd:noconstant} is specified, you may explicitly refer
to observed exogenous variable {cmd:_cons}.

{p 8 8 2}
The following path specifications are ways of writing the same model:

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:) (}{it:name1} {cmd:<-} {it:name3}{cmd:)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:) (}{it:name1} {cmd:<-} {it:name3}{cmd:) (}{it:name1} {cmd:<-} {cmd:_cons)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3}{cmd:)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3} {cmd:_cons)}{p_end}

{p 8 8 2}
There is no reason to explicitly specify {cmd:_cons} unless you have also
specified the {cmd:noconstant} option and want to include {cmd:_cons} in some
equations but not others, or regardless of whether you specified the 
{cmd:noconstant} option, you want to place a constraint on its path
coefficient.  For example,

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3} {cmd:_cons@c1}{cmd:) (}{it:name4} {cmd:<-} {it:name5} {cmd:_cons@c1}{cmd:)}{p_end}

{p 3 8 2}
15.  The {cmd:noconstant} option may be specified globally or within a path
specification.  That is,

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3}{cmd:) (}{it:name4} {cmd:<-} {it:name5}{cmd:), nocon}{p_end}

{p 8 8 2}
suppresses the intercepts in both equations. Alternatively,

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3}{cmd:, nocon) (}{it:name4} {cmd:<-} {it:name5}{cmd:)}{p_end}

{p 8 8 2}
suppresses the intercept in the first equation but not the second, whereas

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3}{cmd:) (}{it:name4} {cmd:<-} {it:name5}{cmd:, nocon)}{p_end}

{p 8 8 2}
suppresses the intercept in the second equation but not the first.

{p 8 8 2}In addition, consider the equation

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2} {it:name3}{cmd:, nocons)}{p_end}

{p 8 8 2}
This can be written equivalently as

{phang3}{cmd:(}{it:name1} {cmd:<-} {it:name2}{cmd:, nocons) (}{it:name1} {cmd:<-} {it:name3}{cmd:, nocons)}{p_end}

{marker item16}{...}
{p 3 8 2}
16.  Initial values (starting values) may be specified for a path,
variance, covariance, or mean by using the {opt init(#)} suboption:

{phang3}{cmd:(}{it:name1} {cmd:<-} {cmd:(}{it:name2}{cmd:, init(0)))}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {cmd:(}{it:name2}{cmd:, init(0))} {it:name3}{cmd:)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {cmd:(}{it:name2}{cmd:, init(0)) (}{it:name3}{cmd:, init(5)))}{p_end}

{phang3}{cmd: ..., ... var((}{it:name3}{cmd:, init(1)))}{p_end}

{phang3}{cmd:..., ... cov((}{it:name4}{cmd:*}{it:name5}{cmd:, init(.5)))}{p_end}

{phang3}{cmd:..., ... means((}{it:name5}{cmd:, init(0)))}{p_end}

{p 8 8 2}
The initial values may be combined with symbolic constraints:

{phang3}{cmd:(}{it:name1} {cmd:<-} {cmd:(}{it:name2}{cmd:@c1}{cmd:, init(0)))}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {cmd:(}{it:name2}{cmd:@c1}{cmd:, init(0))} {it:name3}{cmd:)}{p_end}

{phang3}{cmd:(}{it:name1} {cmd:<-} {cmd:(}{it:name2}{cmd:@c1}{cmd:, init(0)) (}{it:name3}{cmd:@c2}{cmd:, init(5)))}{p_end}

{phang3}{cmd:..., ... var((}{it:name3}{cmd:@c1}{cmd:, init(1)))}{p_end}

{phang3}{cmd:..., ... cov((}{it:name4}{cmd:*}{it:name5}{cmd:@c1}{cmd:, init(.5)))}{p_end}

{phang3}{cmd:..., ... means((}{it:name5}{cmd:@c1}{cmd:, init(0)))}{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
These examples demonstrate path notation using the {cmd:sem} command, but 
{cmd:sem} could be replaced with {cmd:gsem} in each case.  See 
{helpb sem path notation extensions} and {helpb gsem path notation extensions} 
for examples demonstrating unique features of path notation for each command.


{title:Examples: Basic path notation}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}A simple regression model{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length)}{p_end}

{pstd}Same model as above{p_end}
{phang2}{cmd:. sem (mpg <- turn ) (mpg <- trunk) (mpg <- length)}{p_end}

{pstd}Constrain constant to be zero{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length _cons@0)}{p_end}

{pstd}Same as above, but with the {opt noconstant} option{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length), noconstant}{p_end}


{title:Examples: Specifying the covariance() and variance() options}

{pstd}Fit a recursive structural model{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk price) (trunk <- length)}{p_end}

{pstd}Estimate the covariance between the errors of {cmd:mpg} and {cmd:trunk}{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk price) (trunk <- length),}{break}
	{cmd:covariance(e.mpg*e.trunk)}{p_end}

{pstd}Constrain the error variance of {cmd:mpg} to be {cmd:10}{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length) (trunk <- price),}{break}
	{cmd:variance(e.mpg@10)}{p_end}


{title:Examples: Specifying the means() option}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_1fmm}{p_end}

{pstd}A one-factor measurement model{p_end}
{phang2}{cmd:. sem (X -> x1 x2 x3 x4)}{p_end}

{pstd}Constrain the mean of {cmd:X} to be {cmd:5}{p_end}
{phang2}{cmd:. sem (X -> x1 x2 x3 x4), means(X@5)}{p_end}
