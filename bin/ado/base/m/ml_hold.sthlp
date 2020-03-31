{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{viewerjumpto "Syntax" "ml_hold##syntax"}{...}
{viewerjumpto "Description" "ml_hold##description"}{...}
{viewerjumpto "Option" "ml_hold##option"}{...}
{viewerjumpto "Remarks" "ml_hold##remarks"}{...}
{viewerjumpto "Acknowledgment" "ml_hold##ack"}{...}
{title:Title}

{p 4 17 2}
{hi:[P] ml hold} {hline 2} Using ml recursively


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:ml} {cmd:hold} [, {cmdab:noi:sily} ]

{p 8 12 2}
{cmd:ml} {cmd:unhold} [, {cmdab:noi:sily} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:ml} {cmd:hold} and {cmd:ml} {cmd:unhold} are commands for {cmd:ml}
programmers.  They provide the tools required to call {cmd:ml} {cmd:model}
recursively.

{pstd}
{cmd:ml} {cmd:hold} renames all global macros, scalars, matrices, and
variables created by the {cmd:ml} {cmd:model} command.  This allows you to use
{cmd:ml} to optimize one likelihood during the optimization of another
likelihood.

{pstd}
{cmd:ml} {cmd:unhold} restores all global macros, scalars, matrices, and
variables renamed by {cmd:ml} {cmd:hold}.  This restores Stata to the state
defined by the previous {cmd:ml} {cmd:model} command.  Thus you can continue
to optimize the previous likelihood, possibly using the results of the
currently finished {cmd:ml} optimization.


{marker option}{...}
{title:Option}

{phang}
{cmd:noisily} causes both {cmd:ml} {cmd:hold} and {cmd:ml} {cmd:unhold} to
display messages related to each global macro, scalar, matrix, and variable
created/modified by the {cmd:ml} {cmd:model} command.  This option is
available for debugging purposes.


{marker remarks}{...}
{title:Remarks}

{pstd}
To illustrate, we will fit the negative binomial distribution using the method
of profile likelihoods instead of full maximum likelihood estimation.  Thus we
will optimize the {it:beta} coefficients while treating the {it:alpha}
parameter as a nuisance parameter.

{pstd}
Treating {it:alpha} as a nuisance parameter (actually we will be optimizing
ln({it:alpha})), let's assume we have a candidate value so that our conditional
likelihood evaluator is

        {cmd}{sf}{ul off}program mynbreg_lf
                version {ccl stata_version}
                args lnf xb

                tempvar m p

                local y $ML_y1
                local lnalpha $MY_lnalpha
                gen double `m' = exp(-$MY_lnalpha)

                quietly replace `lnf' = lngamma(`m'+`y')	///
			- lngamma(`y'+1)			///
                        - lngamma(`m')				///
			- `m'*ln(1+exp(`xb'+`lnalpha'))		///
                        - `y'*ln(1+exp(-`xb'-`lnalpha'))
        end{reset}

{pstd}
Here we are assuming the value of ln({it:alpha}) is saved in the global macro
{cmd:MY_lnalpha} (or {cmd:$MY_lnalpha} could contain the name of a variable or
scalar), everything else in {cmd:mynbreg_lf} is standard to {cmd:ml}
programming.

{pstd}
Now if we have a candidate for the value of {it:alpha}, we could
interactively estimate the {it:beta} coefficients (conditionally on this
candidate {it:alpha}) by typing:

	{cmd}. use ...
	. global MY_lnalpha = ...
	. ml model lf mynbreg_lf (beta: {it:yvar} = {it:xvars}) , {it:options}
	. ml max , {it:options}
	{reset}{...}

{pstd}
This is essentially what the likelihood evaluator for {it:alpha} will do. The
only detail we must remember is to {cmd:ml} {cmd:hold} the current {cmd:ml}
{cmd:model} environment before we optimize the conditional likelihood.  The
likelihood for optimizing ln({it:alpha}) is

        {cmd}{sf}{ul off}program mynbreg_alpha_d0
                version {ccl stata_version}
                args todo b lnf
		tempvar lnalpha
		mleval `lnalpha' = `b', eq(1)
                local y $ML_y1
                global MY_lnalpha `lnalpha'

                ml hold
                quietly ml model lf mynbreg_lf		///
			(xb: `y' = $MY_x, $MY_offset),	///
                        maximize
                ml unhold

                scalar `lnf' = e(ll)
        end{reset}

{pstd}
Notice that we use global macros to pass the names of the predictors and the
offset option associated with the {it:beta} coefficients.  Thus we can now fit
the negative binomial model using the method of profile likelihoods by calling
{cmd:ml} {cmd:model} twice: first to find the maximum likelihood estimate for
{it:alpha}, and then to estimate the {it:beta} coefficients conditionally on the
MLE of {it:alpha}.


	{cmd}. global MY_x ...				// {txt}{it:x vars}
	{cmd}. global MY_offset offset(...)		// {txt}{it:offset} {it:option}
	{cmd}. ml model lf mynbreg_alpha_d0 (y =), maximize ...
	{cmd}. tempname lnalpha
	{cmd}. matrix `lnalpha' = e(b)
	{cmd}. scalar `lnalpha' = `lnalpha'[1,1]
	{cmd}. global MY_lnalpha `lnalpha'
	{cmd}. ml model lf mynbreg_lf (y = $MY_x, $MY_offset), maximize ...
	{cmd}. ml display{reset}

{pstd}
After testing your likelihood evaluators, you could then easily create a new
estimation command as described in
{it:{browse "http://www.stata.com/bookstore/mle.html":Maximum Likelihood Estimation with Stata, 3rd Edition}}
(Gould, Pitblado, and Sribney 2006).  For example,

        {cmd}{sf}{ul off}program mynbreg
                version {ccl stata_version}
                if replay() {c -(}
                        if (`"`e(cmd)'"' != "mynbreg") error 301
                        Display `0'
                {c )-}
                else {c -(}
                        Estimate `0'
                {c )-}
        end

        program Estimate, eclass
                syntax varlist [,                       ///
                        offset(passthru)                ///
                        exposure(passthru)              ///
                        noLOg                           ///
                        *                               ///
                ]

                if `"`offset'"' != "" & `"`exposure'"' != "" {c -(}
                        di as err ///
                        "options offset() and exposure() may not be combined"
                        exit 198
                {c )-}
                mlopts mlopts diopts , `options'
                if "`log'" != "" {c -(}
                        local star "*"
                {c )-}

                tempname lnalpha

                gettoken y xvars : varlist

                macro drop MY_*
                global MY_x `xvars'
                global MY_offset `offset' `exposure'

                `star' di
                `star' di as txt "Fitting profile likelihood:"
                ml model d0 mynbreg_alpha_d0 (`y' : `y' = ) , ///
				`mlopts' `log' maximize

                macro drop MY_*
                matrix `lnalpha' = e(b)
                scalar `lnalpha' = `lnalpha'[1,1]
                global MY_lnalpha `lnalpha'

                `star' di
                `star' di as txt "Fitting full likelihood:"
                ml model lf mynbreg_lf                          ///
                        (                                       ///
                                `y' : `y' = `xvars',            ///
                                `offset' `exposure'             ///
                        ) , `mlopts' `log' maximize
                macro drop MY_*

                ereturn local title "Negative binomial via profile likelihood"
                ereturn scalar lnalpha = `lnalpha'
                ereturn scalar alpha = exp(`lnalpha')
                ereturn local cmd mynbreg

                Display , `diopts'
        end

        program Display
                ml display
        end{reset}

{pstd}
One final note on this example.  Statistically speaking, the covariance matrix
values (of the {it:beta} coefficients) obtained from this method (profile
likelihood) are not full information maximum likelihood variance estimates,
rather they are conditional on the observed MLE of {it:alpha}.


{marker ack}{...}
{title:Acknowledgment}

{pstd}
Mead Over, The World Bank, provided helpful suggestions for the implementation
of {cmd:ml hold} and {cmd:ml unhold}.
{p_end}
