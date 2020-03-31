{smcl}
{* *! version 2.1.4  15may2018}{...}
{vieweralsosee "[M-5] sin()" "mansection M-5 sin()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_sin##syntax"}{...}
{viewerjumpto "Description" "mf_sin##description"}{...}
{viewerjumpto "Conformability" "mf_sin##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_sin##diagnostics"}{...}
{viewerjumpto "Source code" "mf_sin##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] sin()} {hline 2}}Trigonometric and hyperbolic functions
{p_end}
{p2col:}({mansection M-5 sin():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
	{it:numeric matrix} {cmd:sin(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:cos(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:tan(}{it:numeric matrix Z}{cmd:)} 


{p 8 12 2}
	{it:numeric matrix} {cmd:asin(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:acos(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:atan(}{it:numeric matrix Z}{cmd:)}


{p 8 12 2}
	{it:real matrix}{bind:    }{cmd:atan2(}{it:real matrix X}{cmd:,} {it:real matrix Y}{cmd:)}


{p 8 12 2}
	{it:real matrix}{bind:    }{cmd:arg(}{it:complex matrix Z}{cmd:)} 


{p 8 12 2}
	{it:numeric matrix} {cmd:sinh(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:cosh(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:tanh(}{it:numeric matrix Z}{cmd:)}


{p 8 12 2}
	{it:numeric matrix} {cmd:asinh(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:acosh(}{it:numeric matrix Z}{cmd:)}

{p 8 12 2}
	{it:numeric matrix} {cmd:atanh(}{it:numeric matrix Z}{cmd:)}


{p 8 12 2}
	{it:real scalar}{bind:    }{cmd:pi()}


{marker description}{...}
{title:Description}

{p 4 4 2}
        {cmd:sin(}{it:Z}{cmd:)}, {cmd:cos(}{it:Z}{cmd:)}, and
        {cmd:tan(}{it:Z}{cmd:)} return the appropriate trigonometric functions.
	Angles are measured in radians.  All return real if the argument is
        real and complex if the argument is complex.

{p 8 8 2}
	{cmd:sin(}{it:x}{cmd:)}, {it:x} real, returns the sine of {it:x}. 
        {cmd:sin()} returns a value between -1 and 1.

{p 8 8 2}
	{cmd:sin(}{it:z}{cmd:)}, {it:z} complex, returns the complex sine of 
        {it:z}, mathematically defined as 
        {exp({it:i}*{it:z})-exp(-{it:i}*{it:z})}/2{it:i}.

{p 8 8 2}
	{cmd:cos(}{it:x}{cmd:)}, {it:x} real, returns the cosine of {it:x}. 
        {cmd:cos()} returns a value between -1 and 1.

{p 8 8 2}
	{cmd:cos(}{it:z}{cmd:)}, {it:z} complex, returns the complex cosine of 
        {it:z}, mathematically defined as 
        {exp({it:i}*{it:z})+exp(-{it:i}*{it:z})}/2.

{p 8 8 2}
	{cmd:tan(}{it:x}{cmd:)}, {it:x} real, returns the tangent of {it:x}. 

{p 8 8 2}
	{cmd:tan(}{it:z}{cmd:)}, {it:z} complex, returns the complex tangent of 
        {it:z}, mathematically defined as sin({it:z})/cos({it:z}).

{p 4 4 2}
    {cmd:asin(}{it:Z}{cmd:)}, {cmd:acos(}{it:Z}{cmd:)}, and
    {cmd:atan(}{it:Z}{cmd:)} return the appropriate inverse trigonometric
    functions.  Returned results are in radians.  All return real if the
    argument is real and complex if the argument is complex.

{p 8 8 2}
        {cmd:asin(}{it:x}{cmd:)}, {it:x} real, returns arcsine in the range 
        [-{it:pi}/2,{it:pi}/2].  
        If {it:x} < -1 or {it:x} > 1, missing ({cmd:.}) is returned.

{p 8 8 2}
        {cmd:asin(}{it:z}{cmd:)}, {it:z} complex, returns the complex 
        arcsine, mathematically defined as 
        -{it:i}*ln{{it:i}*{it:z} + sqrt(1-{it:z}*{it:z})}.
        Re(asin()) is chosen to be in the interval [-{it:pi}/2,{it:pi}/2].

{p 8 8 2}
        {cmd:acos(}{it:x}{cmd:)}, {it:x} real, returns arccosine in the range 
        [0,{it:pi}]. 
        If {it:x} < -1 or {it:x} > 1, missing ({cmd:.}) is returned.

{p 8 8 2}
        {cmd:acos(}{it:z}{cmd:)}, {it:z} complex, returns the complex 
        arccosine, mathematically defined as 
        -{it:i}*ln{{it:z} + sqrt({it:z}*{it:z}-1)}.
        Re(acos()) is chosen to be in the interval [0,{it:pi}].

{p 8 8 2}
        {cmd:atan(}{it:x}{cmd:)}, {it:x} real, returns arctangent in the range 
        (-{it:pi}/2,{it:pi}/2). 

{p 8 8 2}
        {cmd:atan(}{it:z}{cmd:)}, {it:z} complex, returns the complex 
        arctangent, mathematically defined as 
	ln{(1+{it:i}{it:z})/(1-{it:i}{it:z})}/(2{it:i}).
        Re(atan()) is chosen to be in the interval [0,{it:pi}].


{p 4 4 2}
    {cmd:atan2(}{it:X}{cmd:,} {it:Y}{cmd:)} returns the radian value in the
    range (-{it:pi},{it:pi}] of the angle of the vector determined by
    ({it:X},{it:Y}), the result being in the range [0,{it:pi}] for quadrants 1
    and 2 and [0,-{it:pi}) for quadrants 4 and 3.  {it:X} and {it:Y} must be
    real.  {cmd:atan2(}{it:X}{cmd:,} {it:Y}{cmd:)} is equivalent to
    {cmd:arg(C(}{it:X}{cmd:,} {it:Y}{cmd:))}.

{p 4 4 2}
    {cmd:arg(}{it:Z}{cmd:)} returns the arctangent of
    {cmd:Im(}{it:Z}{cmd:)/}{cmd:Re(}{it:Z}{cmd:)} in the correct quadrant, the
    result being in the range (-{it:pi},{it:pi}]; [0,{it:pi}] in quadrants 1
    and 2 and [0,-{it:pi}) in quadrants 4 and 3.  {cmd:arg(}{it:Z}{cmd:)} is
    equivalent to {cmd:atan2(Re(}{it:Z}{cmd:), Im(}{it:Z}{cmd:))}.


{p 4 4 2}
    {cmd:sinh(}{it:Z}{cmd:)}, {cmd:cosh(}{it:Z}{cmd:)}, and
    {cmd:tanh(}{it:Z}{cmd:)} return the hyperbolic sine, cosine, and
    tangent, respectively.  The returned value is real if the argument is real
    and complex if the argument is complex.

{p 8 8 2}
	{cmd:sinh(}{it:x}{cmd:)}, {it:x} real, returns the inverse 
        hyperbolic sine of {it:x}, mathematically defined as 
        {exp({it:x})-exp(-{it:x})}/2.

{p 8 8 2}
	{cmd:sinh(}{it:z}{cmd:)}, {it:z} complex, returns the complex 
        hyperbolic sine of {it:z}, mathematically defined as 
        {exp({it:z})-exp(-{it:z})}/2.

{p 8 8 2}
	{cmd:cosh(}{it:x}{cmd:)}, {it:x} real, returns the inverse 
        hyperbolic cosine of {it:x}, mathematically defined as 
        {exp({it:x})+exp(-{it:x})}/2.

{p 8 8 2}
	{cmd:cosh(}{it:z}{cmd:)}, {it:z} complex, returns the complex 
        hyperbolic cosine of {it:z}, mathematically defined as 
        {exp({it:z})+exp(-{it:z})}/2.

{p 8 8 2}
	{cmd:tanh(}{it:x}{cmd:)}, {it:x} real, returns the inverse 
        hyperbolic tangent of {it:x}, mathematically defined as 
	sinh({it:x})/cosh({it:x}).

{p 8 8 2}
	{cmd:tanh(}{it:z}{cmd:)}, {it:z} complex, returns the complex 
        hyperbolic tangent of {it:z}, mathematically defined as 
	sinh({it:z})/cosh({it:z}).

{p 4 4 2}
    {cmd:asinh(}{it:Z}{cmd:)}, {cmd:acosh(}{it:Z}{cmd:)}, and
    {cmd:atanh(}{it:Z}{cmd:)} return the inverse hyperbolic sine, cosine,
    and tangent, respectively.  The returned value is real if the argument is
    real and complex if the argument is complex.  

{p 8 8 2}
        {cmd:asinh(}{it:x}{cmd:)}, {it:x} real, returns the inverse hyperbolic 
        sine.

{p 8 8 2}
        {cmd:asinh(}{it:z}{cmd:)}, {it:z} complex, returns the 
        complex inverse hyperbolic sine, mathematically defined as 
	ln{{it:z}+sqrt({it:z}*{it:z}+1)}.
	Im(asinh()) is chosen to be in the interval [-{it:pi}/2,{it:pi}/2].

{p 8 8 2}
        {cmd:acosh(}{it:x}{cmd:)}, {it:x} real, returns the inverse hyperbolic 
        cosine.  If {it:x} < 1, missing ({cmd:.}) is returned.

{p 8 8 2}
        {cmd:acosh(}{it:z}{cmd:)}, {it:z} complex, returns the 
        complex inverse hyperbolic cosine, mathematically defined as 
        ln{{it:z} + sqrt({it:z}*{it:z}-1)}.
	Im(acosh()) is chosen to be in the interval [-{it:pi},{it:pi}];
        Re(acosh()) is chosen to be nonnegative.

{p 8 8 2}
        {cmd:atanh(}{it:x}{cmd:)}, {it:x} real, returns the inverse hyperbolic 
        tangent.  If |{it:x}|>1, missing ({cmd:.}) is returned.

{p 8 8 2}
        {cmd:atanh(}{it:z}{cmd:)}, {it:z} complex, returns the 
        complex inverse hyperbolic tangent, mathematically defined as 
	ln{(1+{it:z})/(1-{it:z})}/2.
	Im(atanh()) is chosen to be in the interval [-{it:pi}/2,{it:pi}/2].

{p 4 4 2}
	{cmd:pi()} returns the value of {it:pi}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:atan2(}{it:X}{cmd:,} {it:Y}{cmd:)}:
{p_end}
                {it:X}:  {it:r1 x c1}
                {it:Y}:  {it:r2 x c2}, {it:X} and {it:Y} r-conformable
           {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})

{p 4 4 2}
{cmd:pi()} returns a 1 {it:x} 1 scalar.

{p 4 4 2}
All other functions return a matrix of the same dimension as input
containing element-by-element calculated results.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    All functions return missing for real arguments when the result
    would be complex.  For instance, {cmd:acos(2)} = ., whereas
    {cmd:acos(2+0i)} = -1.317i.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view asin.mata, adopath asis:asin.mata},
{view acos.mata, adopath asis:acos.mata},
{view atan.mata, adopath asis:atan.mata},
{view tanh.mata, adopath asis:tanh.mata},
{view asinh.mata, adopath asis:asinh.mata},
{view acosh.mata, adopath asis:acosh.mata},
{view atanh.mata, adopath asis:atanh.mata},
{view pi.mata, adopath asis:pi.mata};
other functions are built in.
{p_end}
