{smcl}
{* *! version 1.0.6  20mar2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{viewerjumpto "Syntax" "_b_pclass##syntax"}{...}
{viewerjumpto "Description" "_b_pclass##description"}{...}
{title:Title}

{pstd}
{hi:[P] _b_pclass} {hline 2}
Programmer's utility for constructing e(b_pclass)


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_b_pclass} {it:lname} {cmd::} {it:key}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_b_pclass} maintains the list of key and value pairs used to set the
elements of {cmd:e(b_pclass)}, which in turn is used to control the
calculations and output produced in estimation results.
See {manhelp _coef_table P}.

{pstd}
In the above syntax, {cmd:_b_pclass} determines the value corresponding
to {it:key} and returns it in the local macro named {it:lname}.

{pstd}
Here is the list of the keys, their values, and a brief description.

        {it:key}	{it:value}	Description
        {hline 70}
        default        0      generic model parameter
        coef           1      model coefficient
        aux            2      auxiliary parameter, suppress test/p-value
        mean           3      mean parameter
        var            4      variance parameter, suppress test/p-value,
                              log transform for CI
        cov            5      covariance parameter
        corr           6      correlation parameter, tanh transform for CI
        cilogit        7      probability parameters, suppress test/p-value,
                              logit transform for CI
        ignore         8      parameter that should not be displayed in table, 
                              suppress point estimate, standard error, 
                              test, and p-value
        VAR          100      variance parameter, truncate lower CI at 0
        bseonly      101      suppress test/p-value and CI
        VAR1         102      variance parameter, truncate lower CI at 0,
			      separated from the VAR, value 101, group
	df	     110      distribution degrees-of-freedom parameter
        {hline 70}

{pstd}
{helpb sem_command:sem} uses a separate system for managing the values in
{cmd:e(b_pclass)}.
{p_end}
