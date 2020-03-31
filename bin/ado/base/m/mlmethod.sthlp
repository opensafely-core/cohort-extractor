{smcl}
{* *! version 1.3.4  23oct2017}{...}
{vieweralsosee "[R] ml" "mansection R ml"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "mleval" "help mleval"}{...}
{vieweralsosee "[M-5] moptimize()" "help mf_moptimize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{viewerjumpto "Description" "mlmethod##description"}{...}
{viewerjumpto "Links to PDF documentation" "mlmethod##linkspdf"}{...}
{viewerjumpto "Method lf evaluators" "mlmethod##method_lf"}{...}
{viewerjumpto "Method d0 evaluators" "mlmethod##method_d0"}{...}
{viewerjumpto "Method d1 evaluators" "mlmethod##method_d1"}{...}
{viewerjumpto "Method d2 evaluators" "mlmethod##method_d2"}{...}
{viewerjumpto "Method lf0 evaluators" "mlmethod##method_lf0"}{...}
{viewerjumpto "Method lf1 evaluators" "mlmethod##method_lf1"}{...}
{viewerjumpto "Method lf2 evaluators" "mlmethod##method_lf2"}{...}
{viewerjumpto "Method gf0 evaluators" "mlmethod##method_gf0"}{...}
{viewerjumpto "Global macros for use by all evaluators" "mlmethod##globals"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] ml} {hline 2}}User-written
evaluator programs for use with ml methods
lf, d0, d1, d2, lf0, lf1, lf2, and gf0{p_end}
{p2col:}({mansection R ml:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {helpb ml} command requires a Mata function or Stata program
that evaluates the log-likelihood function.
This function or program is generically referred to as a user-written
evaluator.
Evaluator functions written in Mata are documented in 
{helpb mf_moptimize##syn_alleval:[M-5] moptimize()}.
Evaluator programs written in Stata are documented here.

{pstd}
The {cmd:ml} support commands {cmd:mleval}, {cmd:mlsum}, {cmd:mlvecsum},
{cmd:mlmatsum}, and {cmd:mlmatbysum} are helpful in writing
d0, d1, d2,
lf0, lf1, lf2,
and gf0 evaluator programs; see {help mleval}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mlRemarksandexamples:Remarks and examples}

        {mansection R mlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker method_lf}{...}
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


{marker method_d0}{...}
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


{marker method_d1}{...}
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


{marker method_d2}{...}
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


{marker method_lf0}{...}
{title:Method lf0 evaluators}

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
observation-by-observation values of ln l_j{p_end}


{marker method_lf1}{...}
{title:Method lf1 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnfj} {cmd:g1} {cmd:g2} {it:...}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:quietly replace `lnfj' =} {it:...}{p_end}
{p 12 18 2}{cmd:if (`todo'==0) exit}{p_end}
{p 12 18 2}{cmd:quietly replace `g1' =} formula for dlnl_j/dtheta_1j{p_end}
{p 12 18 2}{cmd:quietly replace `g2' =} formula for dlnl_j/dtheta_2j{p_end}
	    {it:...}
	{cmd:end}

    where

{p 8 23 2}{cmd:`todo'} {space 3} contains 0 or 1;{p_end}
{p 22 22 2}0 ==> {cmd:`lnfj'} to be filled in;{p_end}
{p 22 22 2}1 ==> {cmd:`lnfj'}, {cmd:`g1'}, {cmd:`g2'}, {it:...},
to be filled in{p_end}
{p 8 23 2}{cmd:`b'} {space 6} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 23 2}{cmd:`lnfj'} {space 3} variable to be filled in with
observation-by-observation values of ln l_j{p_end}
{p 8 23 2}{cmd:`g1'} {space 5} variable to be filled in with
dlnl_j/dtheta_1j{p_end}
{p 8 23 2}{cmd:`g2'} {space 5} variable to be filled in with
dlnl_j/dtheta_2j{p_end}
	...


{marker method_lf2}{...}
{title:Method lf2 evaluators}

{p 8 14 2}{cmd:program} {it:progname}{p_end}
{p 12 18 2}{cmd:version {ccl stata_version}}{p_end}
{p 12 18 2}{cmd:args todo b lnfj g1 g2} {it:...} {cmd:H}{p_end}
{p 12 18 2}{cmd:tempvar theta1 theta2} {it:...}{p_end}
{p 12 18 2}{cmd:mleval `theta1' = `b', eq(1)}{p_end}
{p 12 18 2}{cmd:mleval `theta2' = `b', eq(2)}    // if there is a theta2{p_end}
	    {it:...}
{p 12 18 2}// if you need to create any intermediate results:{p_end}
{p 12 18 2}{cmd:tempvar tmp1 tmp2} {it:...}{p_end}
{p 12 18 2}{cmd:gen double `tmp1' =} {it:...}{p_end}
	    {it:...}
{p 12 18 2}{cmd:quietly replace `lnfj' =} {it:...}{p_end}
{p 12 18 2}{cmd:if (`todo'==0) exit}{p_end}
{p 12 18 2}{cmd:quietly replace `g1' =} formula for dlnl_j/dtheta_1j{p_end}
{p 12 18 2}{cmd:quietly replace `g2' =} formula for dlnl_j/dtheta_2j{p_end}
	    {it:...}
{p 12 18 2}{cmd:if (`todo'==1) exit}{p_end}
{p 12 18 2}{cmd:tempname d11 d12 d22 lnf} {it:...}{p_end}
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
{p 22 22 2}1 ==> {cmd:`lnfj'}, {cmd:`g1'}, {cmd:`g2'}, {it:...},
to be filled in;{p_end}
{p 22 22 2}2 ==> {cmd:`lnfj'}, {cmd:`g1'}, {cmd:`g2'}, {it:...}, and {cmd:`H'}
to be filled in;{p_end}
{p 8 22 2}{cmd:`b'} {space 5} full parameter row vector b=(b_1,b_2,...,b_E){p_end}
{p 8 22 2}{cmd:`lnfj'} {space 2} variable to be filled in with
observation-by-observation values of ln l_j{p_end}
{p 8 22 2}{cmd:`g1'} {space 4} variable to be filled in with
dlnl_j/dtheta_1j{p_end}
{p 8 22 2}{cmd:`g2'} {space 4} variable to be filled in with
dlnl_j/dtheta_2j{p_end}
	...
{p 8 22 2}{cmd:`H'} {space 5} matrix to be filled in with overall 
Hessian H = d^2lnL/dbdb'{p_end}


{marker method_gf0}{...}
{title:Method gf0 evaluators}

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


{marker globals}{...}
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
Method d0, d1, d2, lf0, lf1, lf2, and gf0 evaluators can ignore
{cmd:$ML_samp} as long as
{cmd:ml model}'s {cmd:nopreserve} option is not specified.  These methods
will run more quickly if {cmd:nopreserve} is specified.
These evaluators can ignore {cmd:$ML_w} only
if they use {cmd:mlsum}, {cmd:mlvecsum}, and {cmd:mlmatsum} to produce final
results; see {help mleval}.
{p_end}
