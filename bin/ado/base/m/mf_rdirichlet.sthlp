{smcl}
{* *! version 1.0.2  27dec2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "mf_rdirichlet##syntax"}{...}
{viewerjumpto "Description" "mf_rdirichlet##description"}{...}
{viewerjumpto "Conformability" "mf_rdirichlet##conformability"}{...}
{viewerjumpto "Source code" "mf_rdirichlet##source"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col:{bf:[M-5] rdirichlet()} {hline 2}}Dirichlet random variates
{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 31 2}
{it:real matrix}{bind:  }
{cmd:rdirichlet(}{it:real scalar r}{cmd:,} {it:real vector A}{cmd:)}


{marker description}{...}
{title:Description}

{marker rdirichlet}{...}
{p 4 4 2}
{cmd:rdirichlet(}{it:r}{cmd:,} {it:A}{cmd:)} returns an {it:r x k} real matrix
containing Dirichlet random variates with vector {it:A} of {it:k} shape
parameters.  {it:A} can be a row or column vector.  For every element {it:a} of
{it:A}, 1e-3 {ul:<} {it:a} {ul:<} 1e+8.  Each row of the returned matrix is a
Dirichlet({it:A}) random-variate vector.


{marker conformability}{...}
{title:Conformability}

    {cmd:rdirichlet(}{it:r}{cmd:,} {it:A}{cmd:)}:
                {it:r}:  1 {it:x} 1
                {it:A}:  {it:k x} 1 or 1 {it:x k}
           {it:result}:  {it:r x k}


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
