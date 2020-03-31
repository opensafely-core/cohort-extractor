{smcl}
{* *! version 1.0.15  12apr2019}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi reshape" "mansection MI mireshape"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi replace0" "help mi_replace0"}{...}
{vieweralsosee "[D] reshape" "help reshape"}{...}
{viewerjumpto "Syntax" "mi_reshape##syntax"}{...}
{viewerjumpto "Menu" "mi_reshape##menu"}{...}
{viewerjumpto "Description" "mi_reshape##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_reshape##linkspdf"}{...}
{viewerjumpto "Options" "mi_reshape##options"}{...}
{viewerjumpto "Remarks" "mi_reshape##remarks"}{...}
{viewerjumpto "Examples" "mi_reshape##examples"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi reshape} {hline 2}}Reshape mi data{p_end}
{p2col:}({mansection MI mireshape:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{marker overview}{...}
    Overview

{pmore}
{it}(The words {rm:long} and {rm:wide} in what follows have nothing to do 
with mi styles mlong, flong, flongsep, and wide; they have 
to do with reshape's concepts.){rm}

	       {it:long}
              {c TLC}{hline 12}{c TRC}                  {it:wide}
              {c |} {it:i  j}  {it:stub} {c |}                 {c TLC}{hline 16}{c TRC}
              {c |}{hline 12}{c |}                 {c |} {it:i}  {it:stub}{bf:1} {it:stub}{bf:2} {c |}
              {c |} 1  {bf:1}   4.1 {c |}     reshape     {c |}{hline 16}{c |}
              {c |} 1  {bf:2}   4.5 {c |}   <{hline 9}>   {c |} 1    4.1   4.5 {c |}
              {c |} 2  {bf:1}   3.3 {c |}                 {c |} 2    3.3   3.0 {c |}
              {c |} 2  {bf:2}   3.0 {c |}                 {c BLC}{hline 16}{c BRC}
              {c BLC}{hline 12}{c BRC}


	      To go from long to wide:

{col 52}{it:j} existing variable
{col 51}/
		    {cmd:mi reshape wide} {it:stub}{cmd:, i(}{it:i}{cmd:) j(}{it:j}{cmd:)}


	      To go from wide to long:

		    {cmd:mi reshape long} {it:stub}{cmd:, i(}{it:i}{cmd:) j(}{it:j}{cmd:)}
{col 51}\
{col 52}{it:j} new variable
	

{p 4 8 2}
Basic syntax

{phang2}
Convert mi data from long form to wide form

{p 12 16 2}
{cmd:mi reshape} {helpb mi reshape##overview:wide}
{it:stubnames}{cmd:,}
{cmd:i(}{varlist}{cmd:)}
{cmd:j(}{varname}{cmd:)}
[{it:options}]

{phang2}
Convert mi data from wide form to long form

{p 12 16 2}
{cmd:mi reshape} {helpb mi reshape##overview:long}
{it:stubnames}{cmd:,}
{cmd:i(}{varlist}{cmd:)}
{cmd:j(}{varname}{cmd:)}
[{it:options}]

{col 9}{it:options}{col 29}Description
{col 9}{hline 59}
{...}
{col 9}{cmd:i(}{varlist}{cmd:)}{...}
{col 29}{it:i} variable(s)

{col 9}{cmd:j(}{varname} [{it:values}]{cmd:)}{...}
{col 29}long->wide:  {it:j}, existing variable
{col 29}wide->long:  {it:j}, new variable
{col 29}optionally specify values to subset {it:j} 

{col 9}{cmdab:s:tring}{...}
{col 29}{it:j} is string variable (default numeric)
{col 9}{hline 59}

{col 9}where {it:values} is{...}
{col 29}{it:#}[{cmd:-}{it:#}] [...]{...}
{col 54}if {it:j} is numeric (default)
{col 29}{cmd:"}{it:string}{cmd:"} [{cmd:"}{it:string}{cmd:"} ...]{...}
{col 54}if {it:j} is string

{pmore}
and where {it:stubnames} are variable names (long->wide), or stubs of 
    variable names (wide->long).  Unlike {helpb reshape}, {it:stubnames}
    may not contain {cmd:@} to denote where {it:j} appears in the name; all
    {it:stubnames} must follow the style {it:stub#}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:reshape} is Stata's {cmd:reshape} for {cmd:mi} data;
see {bf:{help reshape:[D] reshape}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mireshapeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 4 2}
See {bf:{help reshape:[D] reshape}} for descriptions of the other options.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The {cmd:reshape} command you specify is carried out on the {it:m}=0 data
and then the result is duplicated in {it:m}=1, {it:m}=2, ..., {it:m}={it:M}.

{p 4 4 2}
In {cmd:mi reshape}, all variables corresponding to the same {it:stubnames} 
must be registered of the same {cmd:mi} type: {cmd:imputed}, {cmd:passive}, or
{cmd:regular}.
{p_end}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshapem1}{p_end}
{phang2}{cmd:. mi describe}

{pstd}List the data for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list}

{pstd}Convert data from wide form to long form{p_end}
{phang2}{cmd:. mi reshape long inc ue, i(id) j(year)}

{pstd}List the result for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list, sepby(id)}

{pstd}Convert data back from long form to wide form{p_end}
{phang2}{cmd:. mi reshape wide inc ue, i(id) j(year)}{p_end}
{phang2}{cmd:. mi xeq 1: list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshapem4, clear}{p_end}
{phang2}{cmd:. mi describe}

{pstd}List the data for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list}

{pstd}Convert the data from wide form to long form, allowing
sex to take on string values{p_end}
{phang2}{cmd:. mi reshape long inc, i(id) j(sex) string}

{pstd}List the result for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list, sepby(id)}

{pstd}Convert the data back from long form to wide form{p_end}
{phang2}{cmd:. mi reshape wide inc, i(id) j(sex) string}

    {hline}
