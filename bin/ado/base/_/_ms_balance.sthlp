{smcl}
{* *! version 1.0.3  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_ms_balance##syntax"}{...}
{viewerjumpto "Description" "_ms_balance##description"}{...}
{viewerjumpto "Options" "_ms_balance##options"}{...}
{viewerjumpto "Stored results" "_ms_balance##results"}{...}
{title:Title}

{p2colset 4 20 23 2}{...}
{p2col:{hi:[P] _ms_balance}}{hline 2}
Adjust {cmd:e(b)} by balancing factor-variable covariates
{p_end}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_ms_balance} [{it:indepvars}] [{cmd:,} {opt zero} {opt strict}] 


{marker description}{...}
{title:Description}

{pstd}
{cmd:_ms_balance} is a programmer's command that makes an adjusted copy of
{cmd:e(b)} by balancing the specified factor-variable covariates in its column
stripe.  The column names in the adjusted copy of {cmd:e(b)} will no longer
refer to the variables in {it:indepvars}, and elements that referenced these
variables will have been multiplied by a fraction representing a balancing of
the levels of the factors in {it:indepvars}.


{marker options}{...}
{title:Options}

{phang}
{opt zero} specifies that empty cells be treated as true zero estimates with
zero variance.  This results in a multiplier of 1/k for each factor
variable in {it:indepvars}, where k is the number of levels for a given
factor variable in {it:indepvars}.  Interactions containing multiple variables
in {it:indepvars} will be adjusted by the multiplier from each participating
factor variable.

{pmore}
By default, {cmd:_ms_balance} uses a multiplier that ignores empty cells.  An
interaction with k levels and e empty cells will have a multiplier
of 1/(k-e) if all its factor variables are in {it:indepvars}.
Otherwise, the multiplier is determined by the number of nonempty cells for
each level-combination of factor variables not in {it:indepvars}.

{phang}
{opt strict} specifies that an error be raised if there are any empty cells
involving the factor variables in {it:indepvars}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_ms_balance} stores the following in {cmd:r()}:

{p2colset 9 20 24 2}{...}
{pstd}Matrix{p_end}
{p2col: {cmd:r(b)}}adjusted copy of {cmd:e(b)}{p_end}
{p2col: {cmd:r(mult)}}row vector of the multipliers associated with each
         element of the original {cmd:e(b)}{p_end}
