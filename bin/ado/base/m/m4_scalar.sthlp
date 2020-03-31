{smcl}
{* *! version 1.3.0  14jun2018}{...}
{vieweralsosee "[M-4] Scalar" "mansection M-4 Scalar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_scalar##contents"}{...}
{viewerjumpto "Description" "m4_scalar##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_scalar##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_scalar##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-4] Scalar} {hline 2}}Scalar mathematical functions
{p_end}
{p2col:}({mansection M-4 Scalar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 22}Function{col 39}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Complex }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 7}{bf:{help mf_re:Re()}}{...}
{col 22}{cmd:Re()}{...}
{col 39}real part
{col 22}{cmd:Im()}{...}
{col 39}imaginary part

{col 7}{bf:{help mf_c:C()}}{...}
{col 22}{cmd:C()}{...}
{col 39}make complex

{col 5}   {c TLC}{hline 14}{c TRC}
{col 5}{hline 3}{c RT}{it: Sign related }{c LT}{hline}
{col 5}   {c BLC}{hline 14}{c BRC}

{col 7}{bf:{help mf_abs:abs()}}{...}
{col 22}{cmd:abs()}{...}
{col 39}absolute value (length if complex)

{col 7}{bf:{help mf_sign:sign()}}{...}
{col 22}{cmd:sign()}{...}
{col 39}sign function
{col 22}{cmd:quadrant()}{...}
{col 39}quadrant of value

{col 7}{bf:{help mf_dsign:dsign()}}{...}
{col 22}{cmd:dsign()}{...}
{col 39}FORTRAN-like DSIGN function

{col 7}{bf:{help mf_conj:conj()}}{...}
{col 22}{cmd:conj()}{...}
{col 39}complex conjugate

{col 5}   {c TLC}{hline 30}{c TRC}
{col 5}{hline 3}{c RT}{it: Transcendental & square root }{c LT}{hline}
{col 5}   {c BLC}{hline 30}{c BRC}

{col 7}{bf:{help mf_exp:exp()}}{...}
{col 22}{cmd:exp()}{...}
{col 39}exponentiation
{col 22}{cmd:ln()}, {cmd:log()}{...}
{col 39}natural logarithm
{col 22}{cmd:log10()}{...}
{col 39}base-10 logarithm
{col 22}{cmd:expm1()}{...}
{col 39}{cmd:exp()}-1
{col 22}{cmd:ln1p()}, {cmd:log1p()}{...}
{col 39}natural logarithm of (1+{it:x})
{col 22}{cmd:ln1m()}, {cmd:log1m()}{...}
{col 39}natural logarithm of (1-{it:x})

{col 7}{bf:{help mf_sqrt:sqrt()}}{...}
{col 22}{cmd:sqrt()}{...}
{col 39}square root

{col 7}{bf:{help mf_sin:sin()}}{...}
{col 22}{cmd:sin()}{...}
{col 39}sine
{col 22}{cmd:cos()}{...}
{col 39}cosine
{col 22}{cmd:tan()}{...}
{col 39}tangent
{col 22}{cmd:asin()}{...}
{col 39}arcsine
{col 22}{cmd:acos()}{...}
{col 39}arccosine
{col 22}{cmd:atan()}{...}
{col 39}arctangent
{col 22}{cmd:arg()}{...}
{col 39}arctangent of complex
{col 22}{cmd:atan2()}{...}
{col 39}two-argument arctangent
{col 22}{cmd:sinh()}{...}
{col 39}hyperbolic sine
{col 22}{cmd:cosh()}{...}
{col 39}hyperbolic cosine
{col 22}{cmd:tanh()}{...}
{col 39}hyperbolic tangent
{col 22}{cmd:asinh()}{...}
{col 39}inverse-hyperbolic sine
{col 22}{cmd:acosh()}{...}
{col 39}inverse-hyperbolic cosine
{col 22}{cmd:atanh()}{...}
{col 39}inverse-hyperbolic tangent
{col 22}{cmd:pi()}{...}
{col 39}value of {it:pi}

{col 5}   {c TLC}{hline 19}{c TRC}
{col 5}{hline 3}{c RT}{it: Factorial & gamma }{c LT}{hline}
{col 5}   {c BLC}{hline 19}{c BRC}

{col 7}{bf:{help mf_factorial:factorial()}}{...}
{col 22}{cmd:factorial()}{...}
{col 39}factorial
{col 22}{cmd:lnfactorial()}{...}
{col 39}natural logarithm of factorial
{col 22}{cmd:gamma()}{...}
{col 39}gamma function
{col 22}{cmd:lngamma()}{...}
{col 39}natural logarithm of gamma function
{col 22}{cmd:digamma()}{...}
{col 39}derivative of {cmd:lngamma()}
{col 22}{cmd:trigamma()}{...}
{col 39}second derivative of {cmd:lngamma()}

{col 5}   {c TLC}{hline 28}{c TRC}
{col 5}{hline 3}{c RT}{it: Modulus & integer rounding }{c LT}{hline}
{col 5}   {c BLC}{hline 28}{c BRC}

{col 7}{bf:{help mf_mod:mod()}}{...}
{col 22}{cmd:mod()}{...}
{col 39}modulus

{col 7}{bf:{help mf_trunc:trunc()}}{...}
{col 22}{cmd:trunc()}{...}
{col 39}truncate to integer
{col 22}{cmd:floor()}{...}
{col 39}round down to integer 
{col 22}{cmd:ceil()}{...}
{col 39}round up to integer 
{col 22}{cmd:round()}{...}
{col 39}round to closest integer or multiple

{col 5}   {c TLC}{hline 7}{c TRC}
{col 5}{hline 3}{c RT}{it: Dates }{c LT}{hline}
{col 5}   {c BLC}{hline 7}{c BRC}

{col 7}{bf:{help mf_date:date()}}{...}
{col 22}{cmd:clock()}{...}
{col 39}{cmd:%tc} of string
{col 22}{cmd:mdyhms()}{...}
{col 39}{cmd:%tc} of mon., day, yr., hr., min., & sec.
{col 22}{cmd:dhms()}{...}
{col 39}{cmd:%tc} of {cmd:%td}, hour, minute, and second
{col 22}{cmd:hms()}{...}
{col 39}{cmd:%tc} of hour, minute, and second
{col 22}{cmd:hh()}{...}
{col 39}hour of {cmd:%tc}
{col 22}{cmd:mm()}{...}
{col 39}minute of {cmd:%tc}
{col 22}{cmd:ss()}{...}
{col 39}second of {cmd:%tc}
{col 22}{cmd:dofc()}{...}
{col 39}{cmd:%td} of {cmd:%tc}

{col 22}{cmd:Cofc()}{...}
{col 39}{cmd:%tC} of {cmd:%tc}
{col 22}{cmd:Clock()}{...}
{col 39}{cmd:%tC} of string
{col 22}{cmd:Cmdyhms()}{...}
{col 39}{cmd:%tC} of mon., day, yr., hr., min., & sec.
{col 22}{cmd:Cdhms()}{...}
{col 39}{cmd:%tC} of {cmd:%td}, hour, minute, and second
{col 22}{cmd:Chms()}{...}
{col 39}{cmd:%tC} of hour, minute, and second
{col 22}{cmd:hhC()}{...}
{col 39}hour of {cmd:%tC}
{col 22}{cmd:mmC()}{...}
{col 39}minute of {cmd:%tC}
{col 22}{cmd:ssC()}{...}
{col 39}second of {cmd:%tC}
{col 22}{cmd:dofC()}{...}
{col 39}{cmd:%td} of {cmd:%tC}

{col 22}{cmd:date()}{...}
{col 39}{cmd:%td} of string
{col 22}{cmd:mdy()}{...}
{col 39}{cmd:%td} of month, day, and year
{col 22}{cmd:yw()}{...}
{col 39}{cmd:%tw} of year and week
{col 22}{cmd:ym()}{...}
{col 39}{cmd:%tm} of year and month
{col 22}{cmd:yq()}{...}
{col 39}{cmd:%tq} of year and quarter
{col 22}{cmd:yh()}{...}
{col 39}{cmd:%th} of year and half
{col 22}{cmd:cofd()}{...}
{col 39}{cmd:%tc} of {cmd:%td}
{col 22}{cmd:Cofd()}{...}
{col 39}{cmd:%tC} of {cmd:%td}

{col 22}{cmd:dofb()}{...}
{col 39}{cmd:%td} of {cmd:%tb}
{col 22}{cmd:bofd()}{...}
{col 39}{cmd:%tb} of {cmd:%td}

{col 22}{cmd:month()}{...}
{col 39}month of {cmd:%td}
{col 22}{cmd:day()}{...}
{col 39}day-of-month of {cmd:%td}
{col 22}{cmd:year()}{...}
{col 39}year of {cmd:%td}
{col 22}{cmd:dow()}{...}
{col 39}day-of-week of {cmd:%td}
{col 22}{cmd:week()}{...}
{col 39}week of {cmd:%td}
{col 22}{cmd:quarter()}{...}
{col 39}quarter of {cmd:%td}
{col 22}{cmd:halfyear()}{...}
{col 39}half-of-year of {cmd:%td}
{col 22}{cmd:doy()}{...}
{col 39}day-of-year of {cmd:%td}

{col 22}{cmd:yearly()}{...}
{col 39}{cmd:%ty} of string
{col 22}{cmd:yofd()}{...}
{col 39}{cmd:%ty} of {cmd:%td}
{col 22}{cmd:dofy()}{...}
{col 39}{cmd:%td} of {cmd:%ty}

{col 22}{cmd:halfyearly()}{...}
{col 39}{cmd:%th} of string
{col 22}{cmd:hofd()}{...}
{col 39}{cmd:%th} of {cmd:%td}
{col 22}{cmd:dofh()}{...}
{col 39}{cmd:%td} of {cmd:%th}

{col 22}{cmd:quarterly()}{...}
{col 39}{cmd:%tq} of string
{col 22}{cmd:qofd()}{...}
{col 39}{cmd:%tq} of {cmd:%td}
{col 22}{cmd:dofq()}{...}
{col 39}{cmd:%td} of {cmd:%tq}

{col 22}{cmd:monthly()}{...}
{col 39}{cmd:%tm} of string
{col 22}{cmd:mofd()}{...}
{col 39}{cmd:%tm} of {cmd:%td}
{col 22}{cmd:dofm()}{...}
{col 39}{cmd:%td} of {cmd:%tm}

{col 22}{cmd:weekly()}{...}
{col 39}{cmd:%tw} of string
{col 22}{cmd:wofd()}{...}
{col 39}{cmd:%tw} of {cmd:%td}
{col 22}{cmd:dofw()}{...}
{col 39}{cmd:%td} of {cmd:%tw}

{col 22}{cmd:hours()}{...}
{col 39}hours of milliseconds
{col 22}{cmd:minutes()}{...}
{col 39}minutes of milliseconds
{col 22}{cmd:seconds()}{...}
{col 39}seconds of milliseconds
{col 22}{cmd:msofhours()}{...}
{col 39}milliseconds of hours
{col 22}{cmd:msofminutes()}{...}
{col 39}milliseconds of minutes
{col 22}{cmd:msofseconds()}{...}
{col 39}milliseconds of seconds

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
With a few exceptions, the above functions are what most people would consider
scalar functions, although in fact all will work with matrices, in an
element-by-element fashion.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 ScalarRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
For other mathematical functions, see 

{col 8}{...}
{bf:{help m4_matrix:[M-4] Matrix}}{...}
{col 30}Matrix mathematical functions

{col 8}{...}
{bf:{help m4_mathematical:[M-4] Mathematical}}{...}
{col 30}Important mathematical functions

{col 8}{...}
{bf:{help m4_statistical:[M-4] Statistical}}{...}
{col 30}Statistical functions
