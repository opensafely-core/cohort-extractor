{smcl}
{* *! version 1.1.11  15may2018}{...}
{vieweralsosee "[M-4] Standard" "mansection M-4 Standard"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_standard##contents"}{...}
{viewerjumpto "Description" "m4_standard##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_standard##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_standard##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-4] Standard} {hline 2}}Functions to create standard matrices
{p_end}
{p2col:}({mansection M-4 Standard:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 20}Function{col 39}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 26}{c TRC}
{col 5}{hline 3}{c RT}{it: Unit & constant matrices }{c LT}{hline}
{col 5}   {c BLC}{hline 26}{c BRC}

{col 5}{bf:{help mf_i:I()}}{...}
{col 20}{cmd:I()}{...}
{col 39}identity matrix

{...}
{col 5}{bf:{help mf_e:e()}}{...}
{col 20}{cmd:e()}{...}
{col 39}unit vectors
{...}

{col 5}{bf:{help mf_j:J()}}{...}
{col 20}{cmd:J()}{...}
{col 39}matrix of constants
{...}

{col 5}{bf:{help mf_designmatrix:designmatrix()}}{...}
{col 20}{cmd:designmatrix()}{...}
{col 39}design matrices
{...}

{col 5}   {c TLC}{hline 25}{c TRC}
{col 5}{hline 3}{c RT}{it: Block-diagonal matrices }{c LT}{hline}
{col 5}   {c BLC}{hline 25}{c BRC}

{col 5}{bf:{help mf_blockdiag:blockdiag()}}{...}
{col 20}{cmd:blockdiag()}{...}
{col 39}block-diagonal matrix
{...}

{col 5}   {c TLC}{hline 8}{c TRC}
{col 5}{hline 3}{c RT}{it: Ranges }{c LT}{hline}
{col 5}   {c BLC}{hline 8}{c BRC}

{col 5}{bf:{help mf_range:range()}}{...}
{col 20}{cmd:range()}{...}
{col 39}vector over specified range
{col 20}{cmd:rangen()}{...}
{col 39}vector of n over specified range
{...}

{col 5}{bf:{help mf_unitcircle:unitcircle()}}{...}
{col 20}{cmd:unitcircle()}{...}
{col 39}unit circle on complex plane
{...}

{col 5}   {c TLC}{hline 8}{c TRC}
{col 5}{hline 3}{c RT}{it: Random }{c LT}{hline}
{col 5}   {c BLC}{hline 8}{c BRC}

{col 5}{bf:{help mf_runiform:runiform()}}{...}
{col 20}{cmd:runiform()}{...}
{col 39}uniform random variates
{col 20}{cmd:rnormal()}{...}
{col 39}normal (Gaussian) random variates
{col 20}{hline 10}
{col 20}{cmd:rbeta()}{...}
{col 39}beta random variates
{col 20}{cmd:rbinomial()}{...}
{col 39}binomial random variates
{col 20}{cmd:rchi2()}{...}
{col 39}chi-squared random variates
{col 20}{cmd:rdiscrete()}{...}
{col 39}discrete random variates
{col 20}{cmd:rexponential()}{...}
{col 39}exponential random variates
{col 20}{cmd:rgamma()}{...}
{col 39}gamma random variates
{col 20}{cmd:rhypergeometric()}{...}
{col 39}hypergeometric random variates
{col 20}{cmd:rlogistic()}{...}
{col 39}logistic random variates
{col 20}{cmd:rnbinomial()}{...}
{col 39}negative binomial random variates
{col 20}{cmd:rpoisson()}{...}
{col 39}Poisson random variates
{col 20}{cmd:rt()}{...}
{col 39}Student's t random variates
{col 20}{cmd:runiformint()}{...}
{col 39}uniform random integer variates
{col 20}{cmd:rweibull()}{...}
{col 39}Weibull random variates
{col 20}{cmd:rweibullph()}{...}
{col 39}Weibull (proportional hazards)
{col 41}random variates

{col 5}   {c TLC}{hline 16}{c TRC}
{col 5}{hline 3}{c RT}{it: Named matrices }{c LT}{hline}
{col 5}   {c BLC}{hline 16}{c BRC}

{col 5}{bf:{help mf_hilbert:Hilbert()}}{...}
{col 20}{cmd:Hilbert()}{...}
{col 39}Hilbert matrices
{col 20}{cmd:invHilbert()}{...}
{col 39}inverse Hilbert matrices

{col 5}{bf:{help mf_toeplitz:Toeplitz()}}{...}
{col 20}{cmd:Toeplitz()}{...}
{col 39}Toeplitz matrices

{col 5}{bf:{help mf_vandermonde:Vandermonde()}}{...}
{col 20}{cmd:Vandermonde()}{...}
{col 39}Vandermonde matrices
{col 5}{hline}

{col 5}   {c TLC}{hline 27}{c TRC}
{col 5}{hline 3}{c RT}{it: vec() & vech() transforms }{c LT}{hline}
{col 5}   {c BLC}{hline 27}{c BRC}

{col 5}{bf:{help mf_dmatrix:Dmatrix()}}{...}
{col 20}{cmd:Dmatrix()}{...}
{col 39}duplication matrices

{col 5}{bf:{help mf_kmatrix:Kmatrix()}}{...}
{col 20}{cmd:Kmatrix()}{...}
{col 39}commutation matrices

{col 5}{bf:{help mf_lmatrix:Lmatrix()}}{...}
{col 20}{cmd:Lmatrix()}{...}
{col 39}elimination matrices
{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The functions above create standard matrices such as the identity matrix, 
etc.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 StandardRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
For other mathematical functions, see

	{bf:{help m4_matrix:[M-4] Matrix}}          Matrix mathematical functions

	{bf:{help m4_scalar:[M-4] Scalar}}          Scalar mathematical functions

	{bf:{help m4_mathematical:[M-4] Mathematical}}    Important mathematical functions
