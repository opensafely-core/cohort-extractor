{smcl}
{* *! version 1.0.11  19oct2017}{...}
{viewerdialog psdensity "dialog psdensity"}{...}
{vieweralsosee "[TS] psdensity" "mansection TS psdensity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arfima" "help arfima"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] ucm" "help ucm"}{...}
{viewerjumpto "Syntax" "psdensity##syntax"}{...}
{viewerjumpto "Menu" "psdensity##menu"}{...}
{viewerjumpto "Description" "psdensity##description"}{...}
{viewerjumpto "Links to PDF documentation" "psdensity##linkspdf"}{...}
{viewerjumpto "Options" "psdensity##options"}{...}
{viewerjumpto "Examples" "psdensity##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] psdensity} {hline 2}}Parametric spectral density 
	estimation after arima, arfima, and ucm{p_end}
{p2col:}({mansection TS psdensity:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{opt psdensity} {dtype} {it:{help newvar:newvar_sd}}
{it:{help newvar:newvar_f}}
{ifin}
[{cmd:,} {it:options}]

{pstd}
where {it:newvar_sd} is the name of the variable that will contain 
the estimated spectral density and {it:newvar_f} is the name of the 
new variable that will contain the frequencies at which the 
spectral density estimate is computed. 

{synoptset 15}{...}
{synopthdr :options}
{synoptline}
{synopt :{opt pspect:rum}}estimate the power spectrum rather than the spectral density{p_end}
{synopt :{opt range(a b)}}limit the frequency range to [a,b){p_end}
{synopt :{opt cyc:le(#)}}estimate the spectral density from the specified
stochastic cycle; only allowed after {cmd:ucm}{p_end}
{synopt :{opt smem:ory}}estimate the spectral density of the short-memory
    component of the ARFIMA process; only allowed after {cmd:arfima}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Postestimation > Parametric spectral density}


{marker description}{...}
{title:Description}

{pstd}
{cmd:psdensity} estimates the spectral density of a stationary process using
the parameters of a previously estimated parametric model.

{pstd}
{cmd:psdensity} works after {helpb arfima}, {helpb arima}, and {helpb ucm}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS psdensityQuickstart:Quick start}

        {mansection TS psdensityRemarksandexamples:Remarks and examples}

        {mansection TS psdensityMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt pspectrum} causes {cmd:psdensity} to estimate the power spectrum rather
than the spectral density.  The power spectrum is equal to the spectral density
times the variance of the process.

{phang}
{opt range(a b)} limits the frequency range.  By default, the spectral density
is computed over [0, pi).  Specifying {opt range(a b)} causes
the spectral density to be computed over [a,b).  We require that 
0 {ul:<} a < b < pi.

{phang}
{opt cycle(#)} causes {cmd:psdensity} to estimate the spectral density from
the specified stochastic cycle after {cmd:ucm}.  By default, the spectral
density from the first stochastic cycle is estimated.  {opt cycle(#)} must
specify an integer that corresponds to a cycle in the model fit by {cmd:ucm}.

{phang}
{opt smemory} causes {cmd:psdensity} to ignore the ARFIMA fractional
integration parameter.  The spectral density computed is for the short-memory
ARMA component of the model.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse manemp2}{p_end}

{pstd}Plot the number of manufacturing employees in the United States{p_end}
{phang2}{cmd:. tsline D.manemp, yline(-0.206)}

{pstd}Simple ARIMA model with differencing and an autoregressive 
	component{p_end}
{phang2}{cmd:. arima D.manemp, ar(1) technique(nr) noconstant}{p_end}

{pstd}Spectral density for a positive autoregressive parameter{p_end}
{phang2}{cmd:. psdensity psden omega}{p_end}

{pstd}Graph the results{p_end}
{phang2}{cmd:. twoway line psden omega}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse icsa1, clear}{p_end}

{pstd}Plot the changes in the new claims for unemployment insurance in the 
	United States{p_end}
{phang2}{cmd:. tsline D.icsa, yline(0.08)}

{pstd}Simple ARIMA model with differencing and an autoregressive 
	component{p_end}
{phang2}{cmd:. arima D.icsa, ar(1) technique(nr) noconstant}{p_end}

{pstd}Spectral density for a negative autoregressive parameter{p_end}
{phang2}{cmd:. psdensity psden omega}{p_end}

{pstd}Graph the results{p_end}
{phang2}{cmd:. twoway line psden omega}{p_end}

    {hline}
