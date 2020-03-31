{smcl}
{* *! version 1.0.4  25sep2018}{...}
{vieweralsosee "[M-5] mvnormal()" "mansection M-5 mvnormal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] normal()" "help mf_normal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ghk()" "help mf_ghk"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_mvnormal##syntax"}{...}
{viewerjumpto "Description" "mf_mvnormal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_mvnormal##linkspdf"}{...}
{viewerjumpto "Conformability" "mf_mvnormal##conformability"}{...}
{viewerjumpto "Source code" "mf_mvnormal##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] mvnormal()} {hline 2}}Compute multivariate normal distributions and derivatives
{p_end}
{p2col:}({mansection M-5 mvnormal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 15}{...}
{synopt:{it:real colvector}}{opt mvnormal(U, R)}{p_end}

{synopt:{it:real colvector}}{opt mvnormal(L, U, R)}{p_end}

{synopt:{it:real colvector}}{opt mvnormalcv(L, U, M, V)}{p_end}


{synopt:{it:real colvector}}{opt mvnormalqp(U, R, q)}{p_end}

{synopt:{it:real colvector}}{opt mvnormalqp(L, U, R, q)}{p_end}

{synopt:{it:real colvector}}{opt mvnormalcvqp(L, U, M, V, q)}{p_end}


{synopt:{it:void}}{opt mvnormalderiv(U, R, dU, dR)}{p_end}

{synopt:{it:void}}{opt mvnormalderiv(L, U, R, dL, dU, dR)}{p_end}

{synopt:{it:void}}{opt mvnormalcvderiv(L, U, M, V, dL, dU, dM, dV)}{p_end}


{synopt:{it:void}}{opt mvnormalderivqp(U, R, dU, dR, q)}{p_end}

{synopt:{it:void}}{opt mvnormalderivqp(L, U, R, dL, dU, dR, q)}{p_end}

{synopt:{it:void}}{opt mvnormalcvderivqp(L, U, M, V, dL, dU, dM, dV, q)}{p_end}
{p2colreset}{...}


{pstd}
where{p_end}
	         {it:L}:  {it:real matrix L}
	         {it:U}:  {it:real matrix U}
	         {it:M}:  {it:real matrix M}
	         {it:R}:  {it:real matrix R}
	         {it:V}:  {it:real matrix V}
	         {it:q}:  {it:real scalar q}

{pmore2}
The types of {it:dL}, {it:dU}, {it:dM}, {it:dR}, 
and {it:dV} are irrelevant; results are returned there as real matrices.


{marker description}{...}
{title:Description}

{pstd}
{opt mvnormal(U, R)} returns the cumulative multivariate 
normal distributions with lower limits -infinity, upper limits {it:U},
and vectorized correlation matrices {it:R} (only the lower halves are 
recorded).

{pstd}
{opt mvnormal(L, U, R)} returns the 
multivariate normal distributions with lower limits {it:L}, 
upper limits {it:U}, and vectorized correlation matrices {it:R} 
(only the lower halves are recorded).

{pstd}
{opt mvnormalcv(L, U, M, V)} returns the 
multivariate normal distributions with lower limits {it:L}, 
upper limits {it:U}, means {it:M}, and vectorized covariance matrices 
{it:V} (only the lower halves are recorded).

{pstd}
{opt mvnormalderiv(U, R, dU, dR)} computes 
the derivatives {it:dU} and {it:dR} of cumulative multivariate 
normal distributions {opt mvnormal(U, R)} with upper limits 
{it:U} (lower limits -infinity) and vectorized correlation matrices {it:R}
(only the lower halves are recorded), respectively, with no return values.

{pstd}
{opt mvnormalderiv(L, U, R, dL, dU, dR)} computes the derivatives {it:dL},
{it:dU}, and {it:dR} of multivariate normal distributions 
{opt mvnormal(L, U, R)} with lower limits {it:L}, 
upper limits {it:U}, and vectorized correlation matrices {it:R}
(only the lower halves are recorded), respectively, with no return values.

{pstd}
{opt  mvnormalcvderiv(L, U, M, V, dL, dU, dM, dV)} 
computes the derivatives {it:dL}, {it:dU}, {it:dM}, and {it:dV} 
of multivariate normal distributions 
{opt mvnormalcv(L, U, M, V)}
with lower limits {it:L}, upper limits {it:U}, means {it:M},
and vectorized covariance matrices {it:V} 
(only the lower halves are recorded), respectively, with no return values.

{pstd}
{opt mvnormal()}, {opt mvnormalcv()}, {opt mvnormalderiv()}, and 
{opt mvnormalcvderiv()} use 128 quadrature points by default for dimensions
greater than 3 and use 10 quadrature points by default for dimensions
less than or equal to 3.

{pstd}
{opt mvnormalqp(U, R, q)},
{opt mvnormalqp(L, U, R, q)},
{opt mvnormalcvqp(L, U, M, V, q)},
{opt mvnormalderivqp(U, R, dU, dR, q)},
{opt mvnormalderivqp(L, U, R, dL, dU, dR, q)} and
{opt mvnormalcvderivqp(L, U, M, V, dL, dU, dM, dV, q)}
do the same things except that, rather than using the default number of 
quadrature points in the calculations, they allow you to specify 
the number of quadrature points in {it:q}.  {it:q} must be between
3 and 5,000.  If {it:q} is not an integer, the integer part of {it:q}
is taken as the number of quadrature points.

{pstd}
Note that {opt mvnormal()}, {opt mvnormalcv()}, {opt mvnormalqp()},
and {opt mvnormalcvqp()} use {opt normal()} when the dimension equals 1 and
{opt binormal()} when the dimension equals 2, in which cases the number of
quadrature points is irrelevant. The computation of the cumulative
multivariate normal distributions and their derivatives can be slow when the
dimension is large.

{pstd}
The matrices {it:L}, {it:U}, {it:M}, {it:R}, and {it:V} parameterize the
integrals that are approximated and returned in a column vector.  See
{help mf_mvnormal##conformability:{it:Conformability}}
for the general rules of conformability and see
{mansection M-5 mvnormal()Remarksandexamples:{it:Remarks and examples}}
for examples in {bf:[M-5] mvnormal()}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 mvnormal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker conformability}{...}
{title:Conformability}

{pstd}
Let {it:d} be the dimension between 1 and 50. Let 
{it:t} = ({it:d} + 1) * {it:d} / 2, 
and let {it:q} be the number of quadrature points between 3 and 5,000.
By default, {it:q} = 128 for {it:d} > 3 and 
{it:q} = 10 for {it:d} {ul:<} 3. Let 
{it:r} = {cmd:max(}{opt rows(L)}{cmd:,} {opt rows(U)}{cmd:,}
{opt rows(M)}{cmd:,} {opt rows(R)}{cmd:,} {opt rows(V)}{cmd:)}.

    {opt mvnormal(U, R)}:
        {it:input}:
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
       {it:output}:
             {it:result}: 1 {it:x} 1  or  {it:r} {it:x} 1, {it:r} > 1

    {opt mvnormal(L, U, R)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1 
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
       {it:output}:
             {it:result}: 1 {it:x} 1  or  {it:r} {it:x} 1, {it:r} > 1

    {opt mvnormalcv(L, U, M, V)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:M}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:V}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
       {it:output}:
             {it:result}: 1 {it:x} 1  or  {it:r} {it:x} 1, {it:r} > 1

    {opt mvnormalqp(U, R, q)}:
        {it:input}:
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
                  {it:q}: 1 {it:x} 1
       {it:output}:
             {it:result}: 1 {it:x} 1  or  {it:r} {it:x} 1, {it:r} > 1

    {opt mvnormalqp(L, U, R, q)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
                  {it:q}: 1 {it:x} 1 
       {it:output}:
             {it:result}: 1 {it:x} 1  or  {it:r} {it:x} 1, {it:r} > 1

    {opt mvnormalcvqp(L, U, M, V, q)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 
                  {it:M}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:V}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
                  {it:q}: 1 {it:x} 1
       {it:output}:
             {it:result}: 1 {it:x} 1  or  {it:r} {it:x} 1, {it:r} > 1

    {opt mvnormalderiv(U, R, dU, dR)}:
        {it:input}:
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
       {it:output}:
                 {it:dU}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dR}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
             {it:result}: {it:void}

    {opt mvnormalderiv(L, U, R, dL, dU, dR)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
       {it:output}:
                 {it:dL}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dU}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dR}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
             {it:result}: {it:void}

    {opt mvnormalcvderiv(L, U, M, V, dL, dU, dM, dV)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:M}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:V}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
       {it:output}:
                 {it:dL}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dU}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dM}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dV}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
             {it:result}: {it:void}

    {opt mvnormalderivqp(U, R, dU, dR, q)}:
        {it:input}:
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
                  {it:q}: 1 {it:x} 1 
       {it:output}:
                 {it:dU}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dR}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
             {it:result}: {it:void}

    {opt mvnormalderivqp(L, U, R, dL, dU, dR, q)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:R}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
                  {it:q}: 1 {it:x} 1
       {it:output}:
                 {it:dL}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dU}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dR}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
             {it:result}: {it:void}

    {opt mvnormalcvderivqp(L, U, M, V, dL, dU, dM, dV, q)}:
        {it:input}:
                  {it:L}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:U}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:M}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                  {it:V}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
                  {it:q}: 1 {it:x} 1
       {it:output}:
                 {it:dL}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dU}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dM}: 1 {it:x} {it:d}  or  {it:r} {it:x} {it:d}, {it:r} > 1
                 {it:dV}: 1 {it:x} {it:t}  or  {it:r} {it:x} {it:t}, {it:r} > 1
             {it:result}: {it:void}


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
