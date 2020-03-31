{smcl}
{* *! version 1.1.1  27feb2019}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{viewerjumpto "Error codes" "power_errors##errors"}{...}
{title:Why does the power table or the ciwidth table have missing entries?}

{pstd}
You executed the {manhelp power PSS-2:power} or {manhelp ciwidth PSS-3:ciwidth} command for a set of multiple
values and received a table containing missing entries.  Missing entries in
the table indicate that the computation failed for some combinations of
the specified values of parameters.  With {cmd:power}, this happens most typically when you
specify an overlapping set of values for the
{help pss_glossary##def_nullval:null parameter} and the 
{help pss_glossary##def_altval:alternative parameter}; see 
{help power_errors##power:{it:Missing table entries for the power command}}.
With {cmd:ciwidth}, this happens, for instance, when you specify a sample size that is larger than the population size; 
see {help power_errors##ciwidth:{it:Missing table entries for the ciwidth command}}.


{marker power}{...}
{title:Missing table entries for the power command}

{pstd}
Suppose you typed the following:

{pstd}
{cmd: . power onemean (0 1) (1 2)}
{p_end}

    Performing iteration ...

    Estimated sample size for a one-sample mean test
    t test
    Ho: m = m0  versus  Ha: m != m0

      +---------------------------------------------------------+
      |   alpha   power       N   delta      m0      ma      sd |
      |---------------------------------------------------------|
      |     .05      .8      10       1       0       1       1 |
      |     .05      .8       5       2       0       2       1 |
      |     .05      .8       .       0       1       1       1 |
      |     .05      .8      10       1       1       2       1 |
      +---------------------------------------------------------+
      Warning: some of the computations failed; execute each 
               computation separately to see the specific error

{pstd}
The value for the sample size {cmd:N} in the third row is missing.  To
investigate what caused this computation to fail, we can look at the 
matrix of errors by typing

{pstd}
{cmd:. matrix list r(error_codes)}

    r(error_codes)[1,4]
        c1  c2  c3  c4
    r1   0   0  14   0

{pstd}
The third column of the matrix contains the error code 14.  We can find the
corresponding description of this error in the 
{help power_errors##errors:table} below of errors produced by the {cmd:power}
command.  The error code 14 corresponds to the error situation "difference is
invalid", which may arise in a number of situations but typically means that
the specified reference and comparison values are the same.

{pstd}
To identify the specific situation for which this error occurred, we rerun the
{cmd:power} command using the values of parameters from the third row.

{pstd}
{cmd: . power onemean 1 1}
{p_end}
{pstd}
{red:null and alternative means are equal; this is not allowed}{p_end}
{pstd}{search r(198):r(198);}{p_end}

{pstd}
The specified values for the null mean and the alternative mean are the same,
which the {cmd:power onemean} command does not allow.


{marker ciwidth}{...}
{title:Missing table entries for the ciwidth command}

{pstd}
Suppose you typed the following:

{pstd}
{cmd: . ciwidth onemean, n(100(20)200) probwidth(0.8) fpc(180)}
{p_end}

    Estimated width for a one-mean CI
    Student's t two-sided CI

      +--------------------------------------------------+
      |   level       N Pr_width   width      sd     fpc |
      |--------------------------------------------------|
      |      95     100       .8   .2796       1     180 |
      |      95     120       .8   .2196       1     180 |
      |      95     140       .8   .1652       1     180 |
      |      95     160       .8   .1088       1     180 |
      |      95     180       .8       .       1     180 |
      |      95     200       .8       .       1     180 |
      +--------------------------------------------------+
      Warning: some of the computations failed; execute each computation
                separately to see the specific error

{pstd}
The values for the CI width, {cmd:width}, in the fifth and sixth rows are missing.  To
investigate what caused these computations to fail, we can look at the
matrix of errors by typing

{pstd}
{cmd:. matrix list r(error_codes)}

	r(error_codes)[1,6]
    	     c1  c2  c3  c4  c5  c6
	r1   0   0   0   0  16  16

{pstd}
The fifth and sixth columns of the matrix contain the error code 16.  We
can find the corresponding description of this error in the {help power_errors##errors:table} below of errors produced by the {cmd:power}
and {cmd:ciwidth} commands. The error code 16 corresponds to the error
situation "finite population correction is invalid". The sample size
should be less than the population size. In this case, the sample sizes are
equal to or greater than the population size.

{pstd}
To identify the specific situation for which this error occurred, we
rerun the {cmd:ciwidth} command using the values of parameters from the
sixth row.

{pstd}
{cmd: . ciwidth onemean, n(200) probwidth(0.8) fpc(180)}
{p_end}
{pstd}
{red: {bf:fpc()}: incorrect specification;}{p_end}
{p 8 12 2}
{red: {bf:fpc()} must contain either values in [0,1) representing sampling rates or}{p_end}
{p 8 12 2}
{red: values greater than the sample size representing population sizes.}{p_end}
{p 8 12 2}
{red: {bf:fpc()} may not contain a mixture of sampling rates and population sizes. }{p_end}
{pstd}{search r(198):r(198);}{p_end}


{marker errors}{...}
{title:Error codes and error descriptions}

{p2colset 9 20 22 2}{...}
{synopt:Error}{p_end}
{synopt:code}Error text{p_end}
{p2line}
{synopt :0}(no error encountered){p_end}

{synopt :10-39}input errors{p_end}
{synopt :11}sample size is invalid{p_end}
{synopt :12}correlation is invalid{p_end}
{synopt :13}mean is invalid{p_end}
{synopt :14}difference is invalid{p_end}
{synopt :15}ratio is invalid{p_end}
{synopt :16}finite population correction is invalid{p_end}
{synopt :17}proportion is invalid{p_end}
{synopt :18}variance or standard deviation is invalid{p_end}
{synopt :19}proportion sum is invalid{p_end}
{synopt :20}covariance matrix is not positive definite{p_end}
{synopt :21}null contrast is equal to C*mu{p_end}
{synopt :22}delta is too small{p_end}
{synopt :23}odds ratio is invalid{p_end}
{synopt :24}hazard ratio is invalid{p_end}
{synopt :25}log hazard-ratio is invalid{p_end}
{synopt :26}correlation is too extreme{p_end}
{synopt :27}power is too small{p_end}
{synopt :28}hazard is invalid{p_end}
{synopt :29}coefficient is invalid{p_end}
{synopt :30}trend is invalid{p_end}
{synopt :31}standard deviation of the error term is invalid{p_end}
{synopt :32}R-squared is invalid{p_end}
{synopt :33}intraclass correlation is invalid{p_end}
{synopt :34}coefficient of variation for cluster sizes is invalid{p_end}

{synopt :40-69}computation errors{p_end}
{synopt :41}computed sample size invalid{p_end}
{synopt :42}computed proportion invalid{p_end}
{synopt :43}computed difference invalid{p_end}
{synopt :44}computed correlation invalid{p_end}
{synopt :45}computed repeated-measures Geisser-Greenhouse correction
	invalid{p_end}
{synopt :46}computed sample size less than 2{p_end}
{synopt :47}computed number of clusters is not positive{p_end}
{synopt :50}initial value for the iterative search is invalid{p_end}
{synopt :51}sample size initial value exceeds the population size{p_end}
{synopt :55}operation is invalid for this computation{p_end}
{synopt :60}power computation failed (for {cmd:power}), or 
	    precision computation failed (for {cmd:ciwidth}), or probability of CI width computation failed (for {cmd:ciwidth}){p_end}
{synopt :61}computed sample size did not achieve the target power (for {cmd:power}), or the target precision (for {cmd:ciwidth}), or the target probability of CI width (for {cmd:ciwidth}){p_end}
{synopt :62}given number of clusters or sample size cannot achieve the requested power{p_end}

{synopt :70-99}iterative solution errors{p_end}
{synopt :74}initial value is a missing value{p_end}
{synopt :76}maximum iterations reached{p_end}
{synopt :77}missing values encountered when evaluating the power function (for {cmd:power}), or the precision function (for {cmd:ciwidth}), or the probability of CI width function (for {cmd:ciwidth}){p_end}
{synopt :89}power function (for {cmd:power}), or precision function (for {cmd:ciwidth}), or probability of CI width function (for {cmd:ciwidth}) could not be evaluated at the initial values{p_end}
{synopt :90}derivatives could not be computed at the initial values{p_end}
{synopt :91}search found a local minimum of the power function (for {cmd:power}), or the precision function (for {cmd:ciwidth}), or the probability of CI width (for {cmd:ciwidth}){p_end}
{synopt :92}derivatives could not be calculated{p_end}
{synopt :97}fatal error occurred in the power function (for {cmd:power}), or the precision function (for {cmd:ciwidth}), or the probability of CI width function (for {cmd:ciwidth}){p_end}
{p2line}
{p2colreset}{...}
