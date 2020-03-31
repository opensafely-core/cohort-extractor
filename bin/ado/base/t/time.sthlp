{smcl}
{* *! version 1.1.24  20sep2018}{...}
{vieweralsosee "[TS] Time series" "mansection TS Timeseries"}{...}
{viewerjumpto "Description" "time##description"}{...}
{viewerjumpto "Links to PDF documentation" "time##linkspdf"}{...}
{viewerjumpto "Data management tools and TS operators" "time##data"}{...}
{viewerjumpto "Univariate time series" "time##univariate"}{...}
{viewerjumpto "Multivariate time series" "time##multivariate"}{...}
{viewerjumpto "Forecasting models" "time##forecasting"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TS] Time series} {hline 2}}Introduction to time-series commands{p_end}
{p2col:}({mansection TS Timeseries:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{pstd}
(Note:  If you are looking for information on time and date variables, 
see {manhelp Datetime D}.)
{p_end}


{marker description}{...}
{title:Description}

{pstd}
Some Stata commands are written directly for performing time-series
analyses.  This entry provides an index to these commands.

{pstd}
Many other Stata commands allow time-series operators in expressions and
varlists (for example, {helpb regress}, {helpb summarize}, {helpb graph},
{helpb list}, ...).

{pstd}
For help with time-series operators and varlists, see {help tsvarlist}.

{pstd}
Before using time-series analysis commands or time-series operators, you
must declare your data to be time series and indicate the time variable.  This
is done using the {cmd:tsset} command; see {manhelp tsset TS}.

{pstd}
If your interest is in analyzing cross-sectional time-series (panel)
datasets, see {manhelp xt XT}.


{marker data}{...}
    {title:Data-management tools and time-series operators}

{p2colset 9 37 39 2}{...}
{p2col :{helpb tsset}}Declare data to be time-series data{p_end}
{p2col :{helpb tsfill}}Fill in gaps in time variable{p_end}
{p2col :{helpb tsappend}}Add observations to a time-series dataset{p_end}
{p2col :{helpb tsreport}}Report time-series aspects of a dataset or estimation sample{p_end}
{p2col :{helpb tsrevar}}Time-series operator programming command{p_end}
{p2col :{helpb rolling}}Rolling-window and recursive estimation{p_end}
{p2col :{helpb datetime business calendars}}User-definable business calendars{p_end}
{p2col :{helpb import fred}}Import data from Federal Reserve Economic Data{p_end}


{marker univariate}{...}
    {title:Univariate time series}

      {bf:Estimators}

{p2col :{helpb arfima}}Autoregressive fractionally integrated moving-average models{p_end}
{p2col :{helpb arfima postestimation}}Postestimation tools for arfima{p_end}
{p2col :{helpb arima}}ARIMA, ARMAX, and other dynamic regression models{p_end}
{p2col :{helpb arima postestimation}}Postestimation tools for arima{p_end}
{p2col :{helpb arch}}Autoregressive conditional heteroskedasticity (ARCH) family of estimators{p_end}
{p2col :{helpb arch postestimation}}Postestimation tools for arch{p_end}
{p2col :{helpb mswitch}}Markov-switching regression models{p_end}
{p2col :{helpb mswitch postestimation}}Postestimation tools for mswitch{p_end}
{p2col :{helpb newey}}Regression with Newey-West standard errors{p_end}
{p2col :{helpb newey postestimation}}Postestimation tools for newey{p_end}
{p2col :{helpb prais}}Prais-Winsten and Cochrane-Orcutt regression{p_end}
{p2col :{helpb prais postestimation}}Postestimation tools for prais{p_end}
{p2col :{helpb ucm}}Unobserved-components model{p_end}
{p2col :{helpb ucm postestimation}}Postestimation tools for ucm{p_end}
{p2col :{helpb threshold}}Threshold regression{p_end}
{p2col :{helpb threshold postestimation}}Postestimation tools for threshold{p_end}


      {bf:Time-series smoothers and filters}

{p2col :{helpb tsfilter bk}}Baxter-King time-series filter{p_end}
{p2col :{helpb tsfilter bw}}Butterworth time-series filter{p_end}
{p2col :{helpb tsfilter cf}}Christiano-Fitzgerald time-series filter{p_end}
{p2col :{helpb tsfilter hp}}Hodrick-Prescott time-series filter{p_end}
{p2col :{helpb tssmooth ma}}Moving-average filter{p_end}
{p2col :{helpb tssmooth dexponential}}Double-exponential smoothing{p_end}
{p2col :{helpb tssmooth exponential}}Single-exponential smoothing{p_end}
{p2col :{helpb tssmooth hwinters}}Holt-Winters nonseasonal smoothing{p_end}
{p2col :{helpb tssmooth shwinters}}Holt-Winters seasonal smoothing{p_end}
{p2col :{helpb tssmooth nl}}Nonlinear filter{p_end}


      {bf:Diagnostic tools}

{p2col :{helpb corrgram}}Tabulate and graph autocorrelations{p_end}
{p2col :{helpb xcorr}}Cross-correlogram for bivariate time series{p_end}
{p2col :{helpb cumsp}}Graph cumulative spectral distribution{p_end}
{p2col :{helpb pergram}}Periodogram{p_end}
{p2col :{helpb psdensity}}Parametric spectral density estimation{p_end}
{p2col :{helpb estat acplot}}Plot parametric autocorrelation and autocovariance
functions{p_end}
{p2col :{helpb estat aroots}}Check the stability condition of ARIMA
estimates{p_end}
{p2col :{helpb estat duration}}Display expected duration of states in a table
{p_end}
{p2col :{helpb estat transition}}Display transition probabilities in a table
{p_end}
{p2col :{helpb dfgls}}DF-GLS unit-root test{p_end}
{p2col :{helpb dfuller}}Augmented Dickey-Fuller unit-root test{p_end}
{p2col :{helpb pperron}}Phillips-Perron unit-roots test{p_end}
{p2col :{helpb estat sbknown}}Test for a structural break with a known break date{p_end}
{p2col :{helpb estat sbsingle}}Test for a structural break with an unknown break date{p_end}
{p2col :{helpb estat sbcusum}}Cumulative sum test for parameter stability{p_end}
{p2col :{helpb regress postestimationts##dwatson:estat dwatson}}Durbin-Watson d statistic{p_end}
{p2col :{helpb regress postestimationts##durbinalt:estat durbinalt}}Durbin's alternative test for serial correlation{p_end}
{p2col :{helpb regress_postestimationts##bgodfrey:estat bgodfrey}}Breusch-Godfrey test for higher-order serial correlation{p_end}
{p2col :{helpb regress_postestimationts##archlm:estat archlm}}Engle's LM test for the presence of autoregressive conditional heteroskedasticity{p_end}
{p2col :{helpb mswitch postestimation}}Postestimation tools for mswitch{p_end}
{p2col :{helpb wntestb}}Bartlett's periodogram-based test for white noise{p_end}
{p2col :{helpb wntestq}}Portmanteau (Q) test for white noise{p_end}


{marker multivariate}{...}
    {title:Multivariate time series}

      {bf:Estimators}

{p2col :{helpb dfactor}}Dynamic-factor models{p_end}
{p2col :{helpb dfactor postestimation}}Postestimation tools for dfactor{p_end}
{p2col :{helpb mgarch ccc}}Constant conditional correlation multivariate GARCH models{p_end}
{p2col :{helpb mgarch ccc postestimation}}Postestimation tools for mgarch ccc{p_end}
{p2col :{helpb mgarch dcc}}Dynamic conditional correlation multivariate GARCH models{p_end}
{p2col :{helpb mgarch dcc postestimation}}Postestimation tools for mgarch dcc{p_end}
{p2col :{helpb mgarch dvech}}Diagonal vech multivariate GARCH models{p_end}
{p2col :{helpb mgarch dvech postestimation}}Postestimation tools for mgarch dvech{p_end}
{p2col :{helpb mgarch vcc}}Varying conditional correlation multivariate GARCH models{p_end}
{p2col :{helpb mgarch vcc postestimation}}Postestimation tools for mgarch vcc{p_end}
{p2col :{helpb sspace}}State-space models{p_end}
{p2col :{helpb sspace postestimation}}Postestimation tools for sspace{p_end}
{p2col :{helpb var}}Vector autoregressive models{p_end}
{p2col :{helpb var postestimation}}Postestimation tools for var{p_end}
{p2col :{helpb svar}}Structural vector autoregressive models{p_end}
{p2col :{helpb svar postestimation}}Postestimation tools for svar{p_end}
{p2col :{helpb varbasic}}Fit a simple VAR and graph IRFs or FEVDs{p_end}
{p2col :{helpb varbasic postestimation}}Postestimation tools for varbasic{p_end}
{p2col :{helpb vec}}Vector error-correction models{p_end}
{p2col :{helpb vec postestimation}}Postestimation tools for vec{p_end}

{p 8 10 2}
Also see {mansection DSGE dsgeDSGE:{it:Stata Dynamic Stochastic General Equilibrium Models Reference Manual}}.


      {bf:Diagnostic tools}

{p2col :{helpb varlmar}}Perform LM test for residual autocorrelation{p_end}
{p2col :{helpb varnorm}}Test for normally distributed disturbances{p_end}
{p2col :{helpb varsoc}}Obtain lag-order selection statistics for VARs and VECMs{p_end}
{p2col :{helpb varstable}}Check the stability condition of VAR or SVAR estimates{p_end}
{p2col :{helpb varwle}}Obtain Wald lag-exclusion statistics{p_end}
{p2col :{helpb veclmar}}Perform LM test for residual autocorrelation{p_end}
{p2col :{helpb vecnorm}}Test for normally distributed disturbances{p_end}
{p2col :{helpb vecrank}}Estimate the cointegrating rank of a VECM{p_end}
{p2col :{helpb vecstable}}Check the stability condition of VECM estimates{p_end}


      {bf:Forecasting, inference, and interpretation}

{p2col :{helpb irf create}}Obtain IRFs, dynamic-multiplier functions, and FEVDs{p_end}
{p2col :{helpb fcast compute}}Compute dynamic forecasts after var, svar, or vec{p_end}
{p2col :{helpb vargranger}}Perform pairwise Granger causality tests{p_end}


      {bf:Graphs and tables}

{p2col :{helpb corrgram}}Tabulate and graph autocorrelations{p_end}
{p2col :{helpb xcorr}}Cross-correlogram for bivariate time series{p_end}
{p2col :{helpb pergram}}Periodogram{p_end}
{p2col :{helpb irf graph}}Graphs of IRFs, dynamic-multiplier functions, and
FEVDs{p_end}
{p2col :{helpb irf cgraph}}Combined graphs of IRFs, dynamic-multiplier functions,
and FEVDs{p_end}
{p2col :{helpb irf ograph}}Overlaid graphs of IRFs, dynamic-multiplier functions,
and FEVDs{p_end}
{p2col :{helpb irf table}}Tables of IRFs, dynamic-multiplier functions,
and FEVDs{p_end}
{p2col :{helpb irf ctable}}Combined tables of IRFs, dynamic-multiplier functions, and FEVDs{p_end}
{p2col :{helpb fcast graph}}Graph forecasts after fcast compute{p_end}
{p2col :{helpb tsline}}Plot time-series data{p_end}
{p2col :{helpb tsrline}}Plot time-series range plot data{p_end}
{p2col :{helpb varstable}}Check the stability condition of VAR or SVAR estimates{p_end}
{p2col :{helpb vecstable}}Check the stability condition of VECM estimates{p_end}
{p2col :{helpb wntestb}}Bartlett's periodogram-based test for white noise{p_end}


      {bf:Results management tools}

{p2col :{helpb irf add}}Add results from an IRF file to the active IRF file{p_end}
{p2col :{helpb irf describe}}Describe an IRF file{p_end}
{p2col :{helpb irf drop}}Drop IRF results from the active IRF file{p_end}
{p2col :{helpb irf rename}}Rename an IRF result in an IRF file{p_end}
{p2col :{helpb irf set}}Set the active IRF file{p_end}


{marker forecasting}{...}
    {title:Forecasting models}

{p2colset 9 37 39 2}{...}
{p2col :{helpb forecast}}Econometric model forecasting{p_end}
{p2col :{helpb forecast adjust}}Adjust a variable by add factoring, replacing, etc.{p_end}
{p2col :{helpb forecast clear}}Clear current model from memory{p_end}
{p2col :{helpb forecast coefvector}}Specify an equation via a coefficient vector{p_end}
{p2col :{helpb forecast create}}Create a new forecast model{p_end}
{p2col :{helpb forecast describe}}Describe features of the forecast model{p_end}
{p2col :{helpb forecast drop}}Drop forecast variables{p_end}
{p2col :{helpb forecast estimates}}Add estimation results to a forecast model{p_end}
{p2col :{helpb forecast exogenous}}Declare exogenous variables{p_end}
{p2col :{helpb forecast identity}}Add an identity to a forecast model{p_end}
{p2col :{helpb forecast list}}List forecast commands composing current model{p_end}
{p2col :{helpb forecast query}}Check whether a forecast model has been started{p_end}
{p2col :{helpb forecast solve}}Obtain static and dynamic forecasts{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS TimeseriesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
