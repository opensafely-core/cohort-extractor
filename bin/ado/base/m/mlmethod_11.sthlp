{smcl}
{* *! version 1.2.4  10oct2017}{...}
{cmd:help mlmethod_11}{right:{help prdocumented:previously documented}}
{hline}

{p2colset 4 14 16 2}{...}
{p2col :{manlink R ml} {hline 2}}User-written evaluator programs for use with ml
methods lf, d0, d1, d2, e1, e2, v0, v1, and v2{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[The names associated with {bf:ml}'s evaluator types was changed
in version 11.
This help file documents {cmd:ml}'s old syntax and as such is 
probably of no interest to you.  You do not have to translate calls to
{cmd:ml} in old do-files to modern syntax because Stata continues
to understand both old and new syntaxes.   This help file is 
provided for those wishing to debug or understand old code.
Click {help ml:here} for the help file of the modern 
{cmd:ml} command.]{rm}


{title:Description}

{pstd}
The {helpb ml} command requires a Mata function or Stata program
that evaluates the log-likelihood function.
This function or program is generically referred to as a user-written
evaluator.
Evaluator functions written in Mata are documented in 
{helpb moptimize_11##syn_alleval:moptimize_11}.
Evaluator programs written in Stata are documented here.

{pstd}
The {cmd:ml} support commands {cmd:mleval}, {cmd:mlsum}, {cmd:mlvecsum},
{cmd:mlmatsum}, and {cmd:mlmatbysum} are helpful in writing d0, d1, d2, e1,
e2, v0, v1, and v2 evaluator programs; see {help mleval_11}.


{title:Method lf evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args lnfj theta1 theta2} {it:...}{p_end}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:quietly gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:quietly replace `lnfj' =} {it:...}{p_end}
	{cmd:end}

    where

{p 8 24 2}{cmd:`lnfj'} {space 4} variable to be filled in with
observation-by-observation values of ln l_j{p_end}
{p 8 24 2}{cmd:`theta1'} {space 2} variable containing evaluation of 1st
equation theta_1j = x_1j * b_1{p_end}
{p 8 24 2}{cmd:`theta2'} {space 2} variable containing evaluation of 2nd
equation theta_2j = x_2j * b_2{p_end}
	...


{title:Method d0 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 16 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 16 2}{cmd:args todo b lnf}{p_end}
{p 12 16 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 16 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 16 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 16 2}// if you need to create any intermediate results: {p_end}
{p 12 16 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 16 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 16 2}{cmd:mlsum `lnf' =} {it:...}{p_end}
	{cmd:end}

    where

{p 8 22 2}{cmd:`todo'} {space 2} always contains 0 (may be ignored){p_end}
{p 8 22 2}{cmd:`b'} {space 5} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnf'} {space 3} scalar to be filled in with overall lnL{p_end}


{title:Method d1 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnf g}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:mlsum `lnf' =} {it:...}{p_end}
{p 12 18 2}{cmd:if (`todo'==0 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:tempname d1 d2} {it:...}{p_end}
{p 12 18 2}{cmd:mlvecsum `lnf' `d1' =} formula for
dlnl_j/dtheta_1j{cmd:, eq(1)}{p_end}
{p 12 18 2}{cmd:mlvecsum `lnf' `d2' =} formula for
dlnl_j/dtheta_2j{cmd:, eq(2)}{p_end}
	    {it:...}
{p 12 18 2}{cmd:matrix `g' = (`d1',`d2',} {it:...} {cmd:)}{p_end}
	{cmd:end}

    where

{p 8 23 2}{cmd:`todo'} {space 3} contains 0 or 1;{p_end}
{p 22 22 2}0 ==> {cmd:`lnf'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnf'} and {cmd:`g'} to be filled in{p_end}
{p 8 23 2}{cmd:`b'} {space 6} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 23 2}{cmd:`lnf'} {space 4} scalar to be filled in with overall lnL{p_end}
{p 8 23 2}{cmd:`g'} {space 6} row vector to be filled in with overall g =
dlnL/db{p_end}


{title:Method d2 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnf g H}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:mlsum `lnf' =} {it:...}{p_end}
{p 12 18 2}{cmd:if (`todo'==0 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:tempname d1 d2} {it:...}{p_end}
{p 12 18 2}{cmd:mlvecsum `lnf' `d1' =} formula for
dlnl_j/dtheta_1j{cmd:, eq(1)}{p_end}
{p 12 18 2}{cmd:mlvecsum `lnf' `d2' =} formula for
dlnl_j/dtheta_2j{cmd:, eq(2)}{p_end}
	    {it:...}
{p 12 18 2}{cmd:matrix `g' = (`d1',`d2',} {it:...} {cmd:)}{p_end}
{p 12 18 2}{cmd:if (`todo'==1 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:tempname d11 d12 d22} {it:...}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d11' =} formula for
d^2lnl_j/dtheta_1j^2{cmd:, eq(1)}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d12' =} formula for
d^2lnl_j/(dtheta_1j dtheta_2j){cmd:, eq(1,2)}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d22' =} formula for
d^2lnl_j/dtheta_2j^2{cmd:, eq(2)}{p_end}
	    {it:...}
{p 12 18 2}{cmd:matrix `H' = (`d11',`d12',} {it:...} {cmd:\ `d12'',`d22',}
{it:...} {cmd:)}{p_end}
	{cmd:end}

    where

{p 8 22 2}{cmd:`todo'} {space 2} contains 0, 1, or 2;{p_end}
{p 22 22 2}0 ==> {cmd:`lnf'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnf'} and {cmd:`g'} to be filled in;{p_end}
{p 22 22 2}2 ==> {cmd:`lnf'}, {cmd:`g'}, and {cmd:`H'} to be filled in{p_end}
{p 8 22 2}{cmd:`b'} {space 5} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnf'} {space 3} scalar to be filled in with overall lnL{p_end}
{p 8 22 2}{cmd:`g'} {space 5} row vector to be filled in with overall g =
dlnL/db{p_end}
{p 8 22 2}{cmd:`H'} {space 5} matrix to be filled in with overall 
Hessian H = d^2lnL/dbdb'{p_end}


{title:Method e1 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnf g} {cmd:H g1} {cmd:g2} {it:...}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:mlsum `lnf' =} {it:...}{p_end}
{p 12 18 2}{cmd:if (`todo'==0 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:quietly replace `g1' =} formula for dlnl_j/dtheta_1j{p_end}
{p 12 18 2}{cmd:quietly replace `g2' =} formula for dlnl_j/dtheta_2j{p_end}
	    {it:...}
	{cmd:end}

    where

{p 8 23 2}{cmd:`todo'} {space 3} contains 0 or 1;{p_end}
{p 22 22 2}0 ==> {cmd:`lnf'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnf'}, {cmd:`g1'}, {cmd:`g2'}, {it:...},
to be filled in{p_end}
{p 8 23 2}{cmd:`b'} {space 6} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 23 2}{cmd:`lnf'} {space 4} scalar to be filled in with overall lnL{p_end}
{p 8 23 2}{cmd:`g'} {space 6} argument to be ignored{p_end}
{p 8 23 2}{cmd:`H'} {space 6} argument to be ignored{p_end}
{p 8 23 2}{cmd:`g1'} {space 5} variable to be filled in with
dlnl_j/dtheta_1j{p_end}
{p 8 23 2}{cmd:`g2'} {space 5} variable to be filled in with
dlnl_j/dtheta_2j{p_end}
	...


{title:Method e2 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnf g H g1 g2} {it:...}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:mlsum `lnf' =} {it:...}{p_end}
{p 12 18 2}{cmd:if (`todo'==0 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:quietly replace `g1' =} formula for dlnl_j/dtheta_1j{p_end}
{p 12 18 2}{cmd:quietly replace `g2' =} formula for dlnl_j/dtheta_2j{p_end}
	    {it:...}
{p 12 18 2}{cmd:if (`todo'==1) exit}{p_end}
{p 12 18 2}{cmd:tempname d11 d12 d22} {it:...}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d11' =} formula for
d^2lnl_j/dtheta_1j^2{cmd:, eq(1)}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d12' =} formula for
d^2lnl_j/(dtheta_1j dtheta_2j){cmd:, eq(1,2)}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d22' =} formula for
d^2lnl_j/dtheta_2j^2{cmd:, eq(2)}{p_end}
	    {it:...}
{p 12 18 2}{cmd:matrix `H' = (`d11',`d12',} {it:...} {cmd:\ `d12'',`d22',}
{it:...} {cmd:)}{p_end}
	{cmd:end}

    where

{p 8 22 2}{cmd:`todo'} {space 2} contains 0, 1, or 2;{p_end}
{p 22 22 2}0 ==> {cmd:`lnf'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnf'}, {cmd:`g1'}, {cmd:`g2'}, {it:...},
to be filled in;{p_end}
{p 22 22 2}2 ==> {cmd:`lnf'}, {cmd:`g1'}, {cmd:`g2'}, {it:...}, and {cmd:`H'}
to be filled in;{p_end}
{p 8 22 2}{cmd:`b'} {space 5} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnf'} {space 3} scalar to be filled in with overall lnL{p_end}
{p 8 23 2}{cmd:`g'} {space 5} argument to be ignored{p_end}
{p 8 22 2}{cmd:`H'} {space 5} matrix to be filled in with overall 
Hessian H = d^2lnL/dbdb'{p_end}
{p 8 22 2}{cmd:`g1'} {space 4} variable to be filled in with
dlnl_j/dtheta_1j{p_end}
{p 8 22 2}{cmd:`g2'} {space 4} variable to be filled in with
dlnl_j/dtheta_2j{p_end}
	...


{title:Method v0 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 16 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 16 2}{cmd:args todo b lnfj}{p_end}
{p 12 16 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 16 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 16 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 16 2}// if you need to create any intermediate results: {p_end}
{p 12 16 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 16 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 16 2}{cmd:quietly replace `lnfj' =} {it:...}{p_end}
	{cmd:end}

    where

{p 8 22 2}{cmd:`todo'} {space 2} always contains 0 (may be ignored){p_end}
{p 8 22 2}{cmd:`b'} {space 5} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnfj'} {space 2} variable to be filled in with
values of the log-likelihood ln l_j{p_end}


{title:Method v1 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnfj g H g1 g2} {it:...}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar lnf tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:quietly replace `lnfj' =} {it:...}{p_end}
{p 12 18 2}{cmd:mlsum `lnf' = `lnfj'}{p_end}
{p 12 18 2}{cmd:if (`todo'==0 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:quietly replace `g1' =} formula for dlnl_j/db_1{p_end}
{p 12 18 2}{cmd:quietly replace `g2' =} formula for dlnl_j/db_2{p_end}
	{cmd:end}

    where

{p 8 23 2}{cmd:`todo'} {space 3} contains 0 or 1;{p_end}
{p 22 22 2}0 ==> {cmd:`lnfj'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnfj'}, {cmd:`g1'}, {cmd:`g2'}, ... to
be filled in{p_end}
{p 8 23 2}{cmd:`b'} {space 6} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnfj'} {space 3} variable to be filled in with
values of the log-likelihood ln l_j{p_end}
{p 8 23 2}{cmd:`g'} {space 6} argument to be ignored{p_end}
{p 8 23 2}{cmd:`H'} {space 6} argument to be ignored{p_end}
{p 8 23 2}{cmd:`g1'} {space 5} variable to be filled in with
dlnl_j/db_1{p_end}
{p 8 23 2}{cmd:`g2'} {space 5} variable to be filled in with
dlnl_j/db_2{p_end}
	...


{title:Method v2 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnfj g H} {cmd:g1} {cmd:g2} {it:...}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar lnf tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:quietly replace `lnfj' =} {it:...}{p_end}
{p 12 18 2}{cmd:mlsum `lnf' = `lnfj'}{p_end}
{p 12 18 2}{cmd:if (`todo'==0 | `lnf'>=.) exit}{p_end}
{p 12 18 2}{cmd:tempname d1 d2} {it:...}{p_end}
{p 12 18 2}{cmd:quietly replace `g1' =} formula for dlnl_j/db_1{p_end}
{p 12 18 2}{cmd:quietly replace `g2' =} formula for dlnl_j/db_2{p_end}
	    {it:...}
{p 12 18 2}{cmd:if (`todo'==1) exit}{p_end}
{p 12 18 2}{cmd:tempname d11 d12 d22} {it:...}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d11' =} formula for
d^2lnl_j/dtheta_1j^2{cmd:, eq(1)}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d12' =} formula for
d^2lnl_j/(dtheta_1j dtheta_2j){cmd:, eq(1,2)}{p_end}
{p 12 18 2}{cmd:mlmatsum `lnf' `d22' =} formula for
d^2lnl_j/dtheta_2j^2{cmd:, eq(2)}{p_end}
	    {it:...}
{p 12 18 2}{cmd:matrix `H' = (`d11',`d12',} {it:...} {cmd:\ `d12'',`d22',}
{it:...} {cmd:)}{p_end}
	{cmd:end}

    where

{p 8 22 2}{cmd:`todo'} {space 2} contains 0, 1, or 2;{p_end}
{p 22 22 2}0 ==> {cmd:`lnfj'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnfj'} and {cmd:`g'} to be filled in;{p_end}
{p 22 22 2}2 ==> {cmd:`lnfj'}, {cmd:`g'}, and {cmd:`H'} to be filled in{p_end}
{p 8 22 2}{cmd:`b'} {space 5} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnfj'} {space 2} variable to be filled in with
values of the log-likelihood ln l_j{p_end}
{p 8 22 2}{cmd:`g'} {space 5} row vector to be filled in with overall g =
dlnL/db{p_end}
{p 8 22 2}{cmd:`H'} {space 5} matrix to be filled in with overall
Hessian H = d^2lnL/dbdb'{p_end}
{p 8 22 2}{cmd:`g1'} {space 4} variable to be filled in with
dlnl_j/db_1{p_end}
{p 8 22 2}{cmd:`g2'} {space 4} variable to be filled in with
dlnl_j/db_2{p_end}
	...


{title:Global macros for use by all evaluators}

{p 8 23 2}{cmd:$ML_y1}{space 5}name of first dependent variable{p_end}
{p 8 23 2}{cmd:$ML_y2}{space 5}name of second dependent variable, if any{p_end}
	...
{p 8 23 2}{cmd:$ML_samp}{space 3}variable containing 1 if observation to be used;
0 otherwise{p_end}
{p 8 23 2}{cmd:$ML_w}{space 6}variable containing weight associated with
observation or 1 if no weights specified{p_end}

{pstd}
Method lf evaluators can ignore {cmd:$ML_samp}, but restricting
calculations to the {cmd:$ML_samp==1} subsample will speed execution.  Method
lf evaluators must ignore {cmd:$ML_w}; application of weights is handled
by the method itself.

{pstd}
Method d0, d1, d2, e1, e2, v0, v1, and v2 evaluators can ignore {cmd:$ML_samp} as long as
{cmd:ml model}'s {cmd:nopreserve} option is not specified.  These methods
will run more quickly if {cmd:nopreserve} is specified.
These evaluators can ignore {cmd:$ML_w} only
if they use {cmd:mlsum}, {cmd:mlvecsum}, and {cmd:mlmatsum} to produce final
results; see {help mleval}.


{title:Also see}

{psee}
Manual:  {manlink R ml}

{psee}
{space 2}Help:  {help ml_11},
{help mleval_11},
{help moptimize_11};
{manhelp macro P},
{manhelp matrix P},
{manhelp program P}
{p_end}
