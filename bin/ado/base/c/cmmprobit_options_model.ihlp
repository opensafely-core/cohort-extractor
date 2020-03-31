{* *! version 1.0.1  12dec2018}{...}
{dlgtab:Model}

{phang}{opth case(varname)} specifies the variable that identifies each case.
This variable identifies the individuals or entities making a choice.
{opt case()} is required.

{phang}{opth alternatives(varname)} specifies the variable that identifies the
alternatives for each case.  The number of alternatives can vary with each
case; the maximum number of alternatives is 20.  {opt alternatives()} is
required.

{phang}{opth casevars(varlist)} specifies the case-specific variables that are
constant for each {opt case()}. If there are a maximum of J alternatives,
there will be J-1 sets of coefficients associated with {opt casevars()}.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:Model 2}

{phang}
{opt correlation(correlation)} specifies the correlation structure of the
latent-variable errors.

{phang2}
{cmd:correlation(unstructured)} is the most general and has J(J-3)/2+1
unique correlation parameters.  This is the default unless {cmd:stdev()}
or {cmd:structural} are specified.

{phang2}
{cmd:correlation(exchangeable)} provides for one correlation coefficient
common to all latent variables, except the latent variable associated with the
{opt basealternative()} option.

{phang2}
{cmd:correlation(independent)} assumes that all correlations are zero.  

{phang2}
{cmd:correlation(pattern} {it:matname}{cmd:)} and {cmd:correlation(fixed}
{it:matname}{cmd:)} give you more flexibility in defining the correlation
structure.  See
{mansection CM cmmprobitRemarksandexamplesVariancestructures:{it:Variance structures}}
in {hi:[CM] cmmprobit} for more information.

{phang}
{opt stddev(stddev)} specifies the variance structure of the
latent-variable errors.

{phang2}
{cmd:stddev(heteroskedastic)} is the most general and has J-2 estimable
parameters.  The standard deviations of the latent-variable errors for the
alternatives specified in {opt basealternative()} and {opt scalealternative()}
are fixed to one.

{phang2}
{cmd:stddev(homoskedastic)} constrains all the standard deviations to equal
one.

{phang2}
{cmd:stddev(pattern} {it:matname}{cmd:)} or
{cmd:stddev(fixed} {it:matname}{cmd:)} give you added flexibility in defining
the standard deviation parameters.  See
{mansection CM cmmprobitRemarksandexamplesVariancestructures:{it:Variance structures}}
in {hi:[CM] cmmprobit} for more information.

{phang}{opt structural} requests the J x J structural covariance
parameterization instead of the default J-1 x J-1 differenced covariance
parameterization (the covariance of the latent errors differenced with
that of the base alternative).  The differenced covariance parameterization
will achieve the same MSL regardless of the choice of
{opt basealternative()} and {opt scalealternative()}.  On the other hand, the
structural covariance parameterization imposes more normalizations that may
bound the model away from its maximum likelihood and thus prevent
convergence with some datasets or choices of {opt basealternative()} and
{opt scalealternative()}.

{phang}{opt factor(#)} requests that the factor covariance structure of
dimension {it:#} be used.  The {cmd:factor()} option can be used with the 
{cmd:structural} option but cannot be used with {cmd:stddev()} or
{cmd:correlation()}.  A {it:#} x J (or {it:#} x J-1) matrix, C, is used to
factor the covariance matrix as I + C'C, where I is the identity matrix of
dimension J (or J-1).  The column dimension of C depends on whether the
covariance is structural or differenced.  The row dimension of C, {it:#}, must
be less than or equal to {cmd:floor(}(J(J-1)/2-1)/(J-2){cmd:)}, because there
are only J(J-1)/2-1 identifiable variance-covariance parameters.  This
covariance parameterization may be useful for reducing the number of covariance
parameters that need to be estimated.

{pmore}
If the covariance is structural, the column of C corresponding to the 
base alternative contains zeros.  The column corresponding to the scale
alternative has a one in the first row and zeros elsewhere.  If the 
covariance is differenced, the column corresponding to the scale alternative
(differenced with the base) has a one in the first row and zeros elsewhere.

{phang}{opt noconstant} suppresses the J-1 alternative-specific constant terms.

{phang}{opt basealternative(#|lbl|str)} specifies the alternative used to
normalize the latent-variable location (also referred to as the level of
utility).  The base alternative may be specified as a number, label,
or string.  The standard deviation for the latent-variable error associated
with the base alternative is fixed to one, and its correlations with all other
latent-variable errors are set to zero.  The default is the first
alternative when sorted.  If a {cmd:fixed} or {cmd:pattern} matrix is
given in the {opt stddev()} and {opt correlation()} options, the 
{opt basealternative()} will be implied by the fixed standard deviations and
correlations in the matrix specifications.  {opt basealternative()} cannot be
equal to {opt scalealternative()}.

{phang}{opt scalealternative(#|lbl|str)} specifies the alternative used to
normalize the latent-variable scale (also referred to as the scale of utility).
The scale alternative may be specified as a number, label, or string.
The default is to use the second alternative when sorted.  If a
{cmd:fixed} or {cmd:pattern} matrix is given in the {opt stddev()} option, 
the {opt scalealternative()} will be implied by the fixed standard deviations
in the matrix specification.  {opt scalealternative()} cannot be equal to the
{opt basealternative()}.

{pmore}
If a {cmd:fixed} or {cmd:pattern} matrix is given for the {cmd:stddev()}
option, the base alternative and scale alternative are implied by
the standard deviations and correlations in the matrix specifications,
and they need not be specified in the {cmd:basealternative()} and
{cmd:scalealternative()} options.

{phang}{opt altwise} specifies that alternativewise deletion be used when
marking out observations due to missing values in your variables.  The default
is to use casewise deletion; that is, the entire group of observations
making up a case is deleted if any missing values are encountered.  This
option does not apply to observations that are marked out by the {cmd:if} or
{cmd:in} qualifier or the {cmd:by} prefix.
{p_end}
