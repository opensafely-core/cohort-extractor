{smcl}
{* *! version 1.5.0  06dec2019}{...}
{vieweralsosee "[M-5] normal()" "mansection M-5 normal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] mvnormal()" "help mf_mvnormal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_normal##syntax"}{...}
{viewerjumpto "Description" "mf_normal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_normal##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_normal##remarks"}{...}
{viewerjumpto "Conformability" "mf_normal##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_normal##diagnostics"}{...}
{viewerjumpto "Source code" "mf_normal##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] normal()} {hline 2}}Cumulatives, reverse cumulatives, and densities
{p_end}
{p2col:}({mansection M-5 normal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	Gaussian normal:

		{it:d} =   {cmd:normalden(}{it:z}{cmd:)}
		{it:d} =   {cmd:normalden(}{it:x}{cmd:,} {it:sd}{cmd:)}
		{it:d} =   {cmd:normalden(}{it:x}{cmd:,} {it:mean}, {it:sd}{cmd:)}
		{it:p} =      {cmd:normal(}{it:z}{cmd:)}
		{it:z} =   {cmd:invnormal(}{it:p}{cmd:)}
	    {it:ln(d)} = {cmd:lnnormalden(}{it:z}{cmd:)}
	    {it:ln(d)} = {cmd:lnnormalden(}{it:x}{cmd:,} {it:sd}{cmd:)}
	    {it:ln(d)} = {cmd:lnnormalden(}{it:x}{cmd:,} {it:mean}, {it:sd}{cmd:)}
	    {it:ln(p)} =    {cmd:lnnormal(}{it:z}{cmd:)}

	Binormal:

		{it:p} = {cmd:binormal(}{it:z1}{cmd:,} {it:z2}{cmd:,} {it:rho}{cmd:)}

	Multivariate normal:
		
	    {it:ln(d)} = {cmd:lnmvnormalden(}{it:M}{cmd:,} {it:V}{cmd:,} {it:X}{cmd:)}

	Beta:

		{it:d} =      {cmd:betaden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:ibeta(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:ibetatail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invibeta(}{it:a}{cmd:,} {it:b}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invibetatail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:q}{cmd:)}

	Binomial:

	       {it:pk} =       {cmd:binomialp(}{it:n}{cmd:,} {it:k}{cmd:,} {it:pi}{cmd:)}
	        {it:p} =        {cmd:binomial(}{it:n}{cmd:,} {it:k}{cmd:,} {it:pi}{cmd:)}
	        {it:q} =    {cmd:binomialtail(}{it:n}{cmd:,} {it:k}{cmd:,} {it:pi}{cmd:)}
	       {it:pi} =     {cmd:invbinomial(}{it:n}{cmd:,} {it:k}{cmd:,} {it:p}{cmd:)}
	       {it:pi} = {cmd:invbinomialtail(}{it:n}{cmd:,} {it:k}{cmd:,} {it:q}{cmd:)}
	
	Cauchy:

		{it:d} =     {cmd:cauchyden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:cauchy(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:cauchytail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invcauchy(}{it:a}{cmd:,} {it:b}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invcauchytail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:q}{cmd:)}
	    {it:ln(d)} =   {cmd:lncauchyden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}

	Chi-squared:

		{it:d} =     {cmd:chi2den(}{it:df}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:chi2(}{it:df}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:chi2tail(}{it:df}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invchi2(}{it:df}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invchi2tail(}{it:df}{cmd:,} {it:q}{cmd:)}

	Dunnett's multiple range:
	
		{it:p} =    {cmd:dunnettprob(}{it:k}{cmd:,} {it:df}{cmd:,} {it:x}{cmd:)}
		{it:x} = {cmd:invdunnettprob(}{it:k}{cmd:,} {it:df}{cmd:,} {it:p}{cmd:)}

        Exponential:

		{it:d} =     {cmd:exponentialden(}{it:b}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:exponential(}{it:b}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:exponentialtail(}{it:b}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invexponential(}{it:b}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invexponentialtail(}{it:b}{cmd:,} {it:q}{cmd:)}

	F:

		{it:d} =     {cmd:Fden(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:f}{cmd:)}
		{it:p} =        {cmd:F(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:f}{cmd:)}
		{it:q} =    {cmd:Ftail(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:f}{cmd:)}
	        {it:f} =     {cmd:invF(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:p}{cmd:)}
	        {it:f} = {cmd:invFtail(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:q}{cmd:)}

	Gamma and inverse gamma:

		{it:d} =      {cmd:gammaden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:gammap(}{it:a}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:gammaptail(}{it:a}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invgammap(}{it:a}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invgammaptail(}{it:a}{cmd:,} {it:q}{cmd:)}
	    {it:dg/da} =     {cmd:dgammapda(}{it:a}{cmd:,} {it:x}{cmd:)}
	    {it:dg/dx} =     {cmd:dgammapdx(}{it:a}{cmd:,} {it:x}{cmd:)}
	  {it:d2g/da2} =   {cmd:dgammapdada(}{it:a}{cmd:,} {it:x}{cmd:)}
	 {it:d2g/dadx} =   {cmd:dgammapdadx(}{it:a}{cmd:,} {it:x}{cmd:)}
	  {it:d2g/dx2} =   {cmd:dgammapdxdx(}{it:a}{cmd:,} {it:x}{cmd:)}
            {it:ln(d)} =   {cmd:lnigammaden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}

	Hypergeometric:

	       {it:pk} = {cmd:hypergeometricp(}{it:N}{cmd:,} {it:K}{cmd:,} {it:n}{cmd:,} {it:k}{cmd:)}
	        {it:p} =  {cmd:hypergeometric(}{it:N}{cmd:,} {it:K}{cmd:,} {it:n}{cmd:,} {it:k}{cmd:)}

	Inverse Gaussian:

		{it:d} =     {cmd:igaussianden(}{it:m}{cmd:,} {it:a}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:igaussian(}{it:m}{cmd:,} {it:a}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:igaussiantail(}{it:m}{cmd:,} {it:a}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invigaussian(}{it:m}{cmd:,} {it:a}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invigaussiantail(}{it:m}{cmd:,} {it:a}{cmd:,} {it:q}{cmd:)}
	    {it:ln(d)} =   {cmd:lnigaussianden(}{it:m}{cmd:,} {it:a}{cmd:,} {it:x}{cmd:)}
	
	Laplace:

                {it:d} =     {cmd:laplaceden(}{it:m}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
                {it:p} =        {cmd:laplace(}{it:m}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
                {it:q} =    {cmd:laplacetail(}{it:m}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
                {it:x} =     {cmd:invlaplace(}{it:m}{cmd:,} {it:b}{cmd:,} {it:p}{cmd:)}
                {it:x} = {cmd:invlaplacetail(}{it:m}{cmd:,} {it:b}{cmd:,} {it:q}{cmd:)}
	    {it:ln(d)} =   {cmd:lnlaplaceden(}{it:m}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}

        Logistic:

	        {it:d} =     {cmd:logisticden(}{it:x}{cmd:)}
	        {it:d} =     {cmd:logisticden(}{it:s}{cmd:,} {it:x}{cmd:)}
	        {it:d} =     {cmd:logisticden(}{it:m}{cmd:,} {it:s}{cmd:,} {it:x}{cmd:)}
	        {it:p} =        {cmd:logistic(}{it:x}{cmd:)}
	        {it:p} =        {cmd:logistic(}{it:s}{cmd:,} {it:x}{cmd:)}
	        {it:p} =        {cmd:logistic(}{it:m}{cmd:,} {it:s}{cmd:,} {it:x}{cmd:)}
	        {it:q} =    {cmd:logistictail(}{it:x}{cmd:)}
	        {it:q} =    {cmd:logistictail(}{it:s}{cmd:,} {it:x}{cmd:)}
	        {it:q} =    {cmd:logistictail(}{it:m}{cmd:,} {it:s}{cmd:,} {it:x}{cmd:)}
	        {it:x} =     {cmd:invlogistic(}{it:p}{cmd:)}
	        {it:x} =     {cmd:invlogistic(}{it:s}{cmd:,} {it:p}{cmd:)}
	        {it:x} =     {cmd:invlogistic(}{it:m}{cmd:,} {it:s}{cmd:,} {it:p}{cmd:)}
	        {it:x} = {cmd:invlogistictail(}{it:q}{cmd:)}
	        {it:x} = {cmd:invlogistictail(}{it:s}{cmd:,} {it:q}{cmd:)}
	        {it:x} = {cmd:invlogistictail(}{it:m}{cmd:,} {it:s}{cmd:,} {it:q}{cmd:)}

	Negative binomial:

	       {it:pk} =       {cmd:nbinomialp(}{it:n}{cmd:,} {it:k}{cmd:,} {it:pi}{cmd:)}
	        {it:p} =        {cmd:nbinomial(}{it:n}{cmd:,} {it:k}{cmd:,} {it:pi}{cmd:)}
	        {it:q} =    {cmd:nbinomialtail(}{it:n}{cmd:,} {it:k}{cmd:,} {it:pi}{cmd:)}
	       {it:pi} =     {cmd:invnbinomial(}{it:n}{cmd:,} {it:k}{cmd:,} {it:p}{cmd:)}
	       {it:pi} = {cmd:invnbinomialtail(}{it:n}{cmd:,} {it:k}{cmd:,} {it:q}{cmd:)}

	Noncentral beta:

		{it:d} =  {cmd:nbetaden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:np}{cmd:,} {it:x}{cmd:)}
		{it:p} =    {cmd:nibeta(}{it:a}{cmd:,} {it:b}{cmd:,} {it:np}{cmd:,} {it:x}{cmd:)}
		{it:x} = {cmd:invnibeta(}{it:a}{cmd:,} {it:b}{cmd:,} {it:np}{cmd:,} {it:p}{cmd:)}

	Noncentral chi-squared:

		{it:d} =     {cmd:nchi2den(}{it:df}{cmd:,} {it:np}{cmd:,} {it:x}{cmd:)}
		{it:p} =        {cmd:nchi2(}{it:df}{cmd:,} {it:np}{cmd:,} {it:x}{cmd:)}
		{it:q} =    {cmd:nchi2tail(}{it:df}{cmd:,} {it:np}{cmd:,} {it:x}{cmd:)}
		{it:x} =     {cmd:invnchi2(}{it:df}{cmd:,} {it:np}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invnchi2tail(}{it:df}{cmd:,} {it:np}{cmd:,} {it:q}{cmd:)}
	       {it:np} =      {cmd:npnchi2(}{it:df}{cmd:,} {it:x}{cmd:,} {it:p}{cmd:)}

	Noncentral F:

		{it:d} =     {cmd:nFden(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:np}{cmd:,} {it:f}{cmd:)}
		{it:p} =        {cmd:nF(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:np}{cmd:,} {it:f}{cmd:)}
		{it:q} =    {cmd:nFtail(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:np}{cmd:,} {it:f}{cmd:)}
                {it:f} =     {cmd:invnF(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:np}{cmd:,} {it:p}{cmd:)}
		{it:f} = {cmd:invnFtail(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:np}{cmd:,} {it:q}{cmd:)}
	       {it:np} =      {cmd:npnF(}{it:df1}{cmd:,} {it:df2}{cmd:,} {it:f}{cmd:,} {it:p}{cmd:)}

	Noncentral Student's t:

                {it:d} =     {cmd:ntden(}{it:df}{cmd:,} {it:np}{cmd:,} {it:t}{cmd:)}
                {it:p} =        {cmd:nt(}{it:df}{cmd:,} {it:np}{cmd:,} {it:t}{cmd:)}
                {it:q} =    {cmd:nttail(}{it:df}{cmd:,} {it:np}{cmd:,} {it:t}{cmd:)}
                {it:t} =     {cmd:invnt(}{it:df}{cmd:,} {it:np}{cmd:,} {it:p}{cmd:)}
                {it:t} = {cmd:invnttail(}{it:df}{cmd:,} {it:np}{cmd:,} {it:q}{cmd:)}
               {it:np} =      {cmd:npnt(}{it:df}{cmd:,} {it:t}{cmd:,} {it:p}{cmd:)}

	Poisson:

	       {it:pk} =       {cmd:poissonp(}{it:mean}{cmd:,} {it:k}{cmd:)}
		{it:p} =        {cmd:poisson(}{it:mean}{cmd:,} {it:k}{cmd:)}
		{it:q} =    {cmd:poissontail(}{it:mean}{cmd:,} {it:k}{cmd:)}
		{it:m} =     {cmd:invpoisson(}{it:k}{cmd:,} {it:p}{cmd:)}
		{it:m} = {cmd:invpoissontail(}{it:k}{cmd:,} {it:q}{cmd:)}

	Student's t:

		{it:d} =     {cmd:tden(}{it:df}{cmd:,} {it:t}{cmd:)}
		{it:p} =        {cmd:t(}{it:df}{cmd:,} {it:t}{cmd:)}
		{it:q} =    {cmd:ttail(}{it:df}{cmd:,} {it:t}{cmd:)}
		{it:t} =     {cmd:invt(}{it:df}{cmd:,} {it:p}{cmd:)}
		{it:t} = {cmd:invttail(}{it:df}{cmd:,} {it:q}{cmd:)}

	Tukey's Studentized range:
	
		{it:p} =    {cmd:tukeyprob(}{it:k}{cmd:,} {it:df}{cmd:,} {it:x}{cmd:)}
		{it:x} = {cmd:invtukeyprob(}{it:k}{cmd:,} {it:df}{cmd:,} {it:p}{cmd:)}

        Weibull:

		{it:d} = {cmd:weibullden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:d} = {cmd:weibullden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:p} = {cmd:weibull(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:p} = {cmd:weibull(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:q} = {cmd:weibulltail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:q} = {cmd:weibulltail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:x} = {cmd:invweibull(}{it:a}{cmd:,} {it:b}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invweibull(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invweibulltail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:q}{cmd:)}
		{it:x} = {cmd:invweibulltail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:q}{cmd:)}

        Weibull (proportional hazards):

		{it:d} = {cmd:weibullphden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:d} = {cmd:weibullphden(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:p} = {cmd:weibullph(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:p} = {cmd:weibullph(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:q} = {cmd:weibullphtail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
		{it:q} = {cmd:weibullphtail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:x}{cmd:)}
		{it:x} = {cmd:invweibullph(}{it:a}{cmd:,} {it:b}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invweibullph(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:p}{cmd:)}
		{it:x} = {cmd:invweibullphtail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:q}{cmd:)}
		{it:x} = {cmd:invweibullphtail(}{it:a}{cmd:,} {it:b}{cmd:,} {it:g}{cmd:,} {it:q}{cmd:)}

	Wishart and inverse Wishart:

	    {it:ln(d)} =  {cmd:lnwishartden(}{it:df}{cmd:,} {it:V}{cmd:,} {it:X}{cmd:)}
	    {it:ln(d)} = {cmd:lniwishartden(}{it:df}{cmd:,} {it:V}{cmd:,} {it:X}{cmd:)}

{p 4 8 2}
where

{p 8 12 2}
    1.  All functions return real and all arguments are real or real matrices.

{p 8 12 2}
    2.  The left-hand-side notation is used to assist in interpreting the
        meaning of the returned value:

		{it:d} = density value
	       {it:pk} = probability of discrete outcome K = Pr(K = k) 
		{it:p} = left cumulative 
		  = Pr(-infinity < {it:statistic} {ul:<} {it:x}) (continuous)
		  = Pr(0 {ul:<} K {ul:<} k) (discrete)
		{it:q} = right cumulative 
		  = 1 - {it:p}  (continuous)
		  = Pr(K {ul:>} k) = 1 - p + pk (discrete) 
	       {it:np} = noncentrality parameter
	    {it:ln(p)} = log cumulative
	    {it:ln(d)} = log density

{p 8 12 2}
    3. Hypergeometric distribution:

		{it:N} = number of objects in the population
		{it:K} = number of objects in the population with the
			 characteristic of interest, {it:K} < {it:N}
		{it:n} = sample size, {it:n} < {it:N}
		{it:k} = number of objects in the sample with the 
			 characteristic of interest, 
			 max(0,{it:n}-{it:N}+{it:K}) {ul:<} {it:k} {ul:<} min({it:K},{it:n})

{p 8 12 2}
    4. Negative binomial distribution: {it:n} > 0 and may be nonintegral.	

{p 8 12 2}
    5. Multivariate normal, Wishart, and inverse Wishart distributions: 

		{it:M} = mean vector
		{it:V} = covariance or scale matrix
		{it:X} = random vector for multivariate normal or 
                         random matrix for Wishart and inverse Wishart


{marker description}{...}
{title:Description}

{p 4 4 2}
    The above functions return density values, cumulatives, reverse 
    cumulatives, inverse cumulatives, and in one case, derivatives of the
    indicated probability density function.  These functions mirror the Stata
    functions of the same name and in fact are the Stata functions.  

{p 4 4 2}
    See {helpb probfun:[FN] Statistical functions} for details.
    In the syntax diagram above, some arguments have been renamed in 
    hope of aiding understanding, but the function arguments match 
    one to one with the underlying Stata functions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 normal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_normal##remarks1:R-conformability}
	{help mf_normal##remarks2:A note concerning invbinomial() and invbinomialtail()}
	{help mf_normal##remarks3:A note concerning ibeta()}
	{help mf_normal##remarks4:A note concerning gammap()}


{marker remarks1}{...}
{title:R-conformability}

{p 4 4 2}
The above functions are usually used with scalar arguments and then 
return a scalar result:

	: {cmd:x = chi2(10, 12)}
	: {cmd:x}
	  {res:.7149434997}

{p 4 4 2}
The arguments may, however, be vectors or matrices.  For instance, 

	: {cmd:x = chi2((10,11,12), 12)}
	: {cmd:x}
        {res}       {txt}          1             2             3
            {c TLC}{hline 43}{c TRC}
          1 {c |}  {res}.7149434997   .6363567795   .5543203586{txt}  {c |}
            {c BLC}{hline 43}{c BRC}{txt}

	: {cmd:x = chi2(10, (12,12.5,13))}
	: {cmd:x}
        {res}       {txt}          1             2             3
            {c TLC}{hline 43}{c TRC}
          1 {c |}  {res}.7149434997   .7470146767   .7763281832{txt}  {c |}
            {c BLC}{hline 43}{c BRC}{txt}

	: {cmd:x = chi2((10,11,12), (12,12.5,13))}
	: {cmd:x}
        {res}       {txt}          1             2             3
            {c TLC}{hline 43}{c TRC}
          1 {c |}  {res}.7149434997   .6727441644   .6309593164{txt}  {c |}
            {c BLC}{hline 43}{c BRC}{txt}

{p 4 4 2}
In the last example, the numbers correspond to {cmd:chi2(10,12)},
{cmd:chi2(11,12.5)}, and {cmd:chi2(12,13)}.

{p 4 4 2}
Arguments are required to be
{help m6_glossary##r-conformability:r-conformable} (see
{bf:{help m6_glossary:[M-6] Glossary}}), 
and thus, 

	: {cmd:x = chi2((10\11\12), (12,12.5,13))}
	: {cmd:x}
        {res}       {txt}          1             2             3
            {c TLC}{hline 43}{c TRC}
          1 {c |}  {res}.7149434997   .7470146767   .7763281832{txt}  {c |}
          2 {c |}  {res}.6363567795   .6727441644   .7066745906{txt}  {c |}
          3 {c |}  {res}.5543203586    .593595966   .6309593164{txt}  {c |}
            {c BLC}{hline 43}{c BRC}{txt}

{p 4 4 2}
which corresponds to

        {res}       {txt}          1             2             3
            {c TLC}{hline 43}{c TRC}
          1 {c |}  {cmd}chi2(10,12)   chi2(10,12.5)  chi2(10,13){txt} {c |}
          2 {c |}  {cmd}chi2(11,12)   chi2(11,12.5)  chi2(11,13){txt} {c |}
          3 {c |}  {cmd}chi2(12,12)   chi2(12,12.5)  chi2(12,13){txt} {c |}
            {c BLC}{hline 43}{c BRC}{txt}


{marker remarks2}{...}
{title:A note concerning invbinomial() and invbinomialtail()}

{p 4 4 2}
{cmd:invbinomial(}{it:n}{cmd:,} {it:k}{cmd:,} {it:p}{cmd:)} and
{cmd:invbinomialtail(}{it:n}{cmd:,} {it:k}{cmd:,} {it:q}{cmd:)} are useful for
calculating confidence intervals for {it:pi}, the probability of a success.
{cmd:invbinomial()} returns the probability {it:pi} such that the probability
of observing {it:k} or fewer successes in {it:n} trials is {it:p}.
{cmd:invbinomialtail()} returns the probability {it:pi} such that the
probability of observing {it:k} or more successes in {it:n} trials is {it:q}.


{marker remarks3}{...}
{title:A note concerning ibeta()}

{p 4 4 2}
{cmd:ibeta(}{it:a}{cmd:,} {it:b}{cmd:,} {it:x}{cmd:)}
is known as the cumulative beta distribution, and it is known as the 
incomplete beta function {it:I_x}({it:a}, {it:b}).


{marker remarks4}{...}
{title:A note concerning gammap()}

{p 4 4 2}
{cmd:gammap(}{it:a}{cmd:,} {it:x}{cmd:)}
is known as the cumulative gamma distribution, and it is known 
as the incomplete gamma function {it:P}({it:a}, {it:x}).


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
All functions require that arguments be r-conformable; see 
{it:{help mf_normal##remarks1:R-conformability}}
above.  Returned is matrix of {cmd:max(}argument rows{cmd:)} rows and
{cmd:max(}argument columns{cmd:)} columns containing element-by-element
calculated results.


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    All functions return missing when arguments are out of range.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
