{smcl}
{* *! version 1.10.9  22aug2019}{...}
{vieweralsosee "prdocumented" "help prdocumented"}{...}
{vieweralsosee "updates" "help updates"}{...}
{vieweralsosee "whatsnew" "help whatsnew"}{...}
{viewerjumpto "Description" "undocumented##description"}{...}
{viewerjumpto "Links to undocumented commands" "undocumented##undocumented"}{...}
{title:Title}

{pstd}
{hi:Undocumented commands}


{marker description}{...}
{title:Description}

{pstd}
An {it:undocumented command} is a command of very limited interest, usually
interesting only to Stata programmers, and is used by StataCorp in developing
Stata.

{pstd}
Undocumented commands are documented in the system help, but their
documentation does not appear in the PDF manuals.  That undocumented
commands are documented at all shows the "openness" of the Stata software.

{pstd}
Undocumented commands may change their syntax or behavior in subsequent
releases of Stata, though this is rare, so use them with caution.

{pstd}
See {help whatsnew} for a list of additions and fixes that have been made
to Stata.  See {helpb updates}, or
{update "from http://www.stata.com":click here}, to obtain the latest additions
to Stata.  See {help prdocumented:previously documented commands} for
information about commands that are no longer an official part of Stata.


{marker undocumented}{...}
{title:Links to undocumented commands}

{pstd}
The following tables provide links to undocumented commands.  The links have
been grouped by the manual they would have been in if they were documented.


{p2colset 5 36 38 2}{...}
{p2col:Base ([R])}Description{p_end}
{p2line}
{p2col:{manhelp dtaverify R}}verify .dta file construction{p_end}
{p2col:{manhelp dtaversion R}}report format and version of .dta file{p_end}
{p2col:{manhelp margins_generate R:margins, generate()}}create margin response variables in the current dataset{p_end}
{p2col:{manhelp margins_plot R:margins, plot()}}margins and marginsplot in one step{p_end}
{p2col:{manhelp margins_saving R:margins, saving()}}save margins results to a dataset{p_end}
{p2col:{manhelp marginsplot_using R:marginsplot using}}plot margins results from a dataset{p_end}
{p2col:{manhelp mat_capp R}}operate on matrices by names rather than
	positions{p_end}
{p2col:{manhelp minbound R}}minimize a scalar function on a range{p_end}
{p2col:{manhelp qby R}}combination of {helpb quietly} and {helpb by}{p_end}
{p2col:{manhelp set_ctrlh R:set ctrlh}}set behavior of Ctrl+H for command-line editing in Unix (console){p_end}
{p2col:{manhelp set_insertmode R:set insertmode}}set behavior of command-line editing in Unix (console){p_end}
{p2line}

{p2col:Choice Models ([CM])}Description{p_end}
{p2line}
{p2col:{manhelp _cm CM}}verify data are {helpb cmset}{p_end}
{p2line}

{p2col:Data Management ([D])}Description{p_end}
{p2line}
{p2col:{manhelp bitowt D}}convert binary freq. records to freq.-weighted
	data{p_end}
{p2col:{manhelp _frames D}}utilities for manipulation of data frames{p_end}
{p2col:{manhelp import_shp D:import shp}}import and export a shapefile{p_end}
{p2col:{manhelp obs_advice D:obs advice}}advice on 2+ billion observations{p_end}
{p2col:{manhelp _mkcross D}}cross variables with automatic short value labels{p_end}
{p2col:{manhelp _rename D}}rename variable{p_end}
{p2col:{manhelp sysdescribe D}}describe shipped dataset{p_end}
{p2col:{manhelp unicode_advice D:unicode advice}}advice on using Unicode{p_end}
{p2col:{manhelp webdescribe D}}describe data over the web{p_end}
{p2line}

{p2col:Functions ([FN])}Description{p_end}
{p2line}
{p2col:{manhelp lndirichletden() FN}}natural logarithm of Dirichlet density{p_end}
{p2col:{manhelp lngeometricp() FN}}natural logarithm of geometric density{p_end}
{p2col:{manhelp lnparetoden() FN}}natural logarithm of Pareto density{p_end}
{p2col:{manhelp rgeometric() FN}}geometric random variates{p_end}
{p2col:{manhelp rpareto() FN}}Pareto random variates{p_end}
{p2line}

{p2col:Graphics ([G])}Description{p_end}
{p2line}
{p2col:{manhelp _check4gropts G-2}}check for illegal {helpb graph} options{p_end}
{p2col:{manhelp di_g G-2}}display debug messages in {helpb graph} commands{p_end}
{p2col:{manhelp _get_gropts G-2}}parse graph options{p_end}
{p2col:{manhelp gs_fileinfo G-2}}obtain information about {cmd:.gph} file{p_end}
{p2col:{manhelp gs_filetype G-2}}determine type of {cmd:.gph} file{p_end}
{p2col:{manhelp gs_graphinfo G-2}}obtain information about memory graph{p_end}
{p2col:{manhelp gs_stat G-2}}verify (non)existence of graph{p_end}
{p2col:{manhelp _matplot G-2}}scatterplot of a matrix{p_end}
{p2col:{manhelp _natscale G-2}}obtain nice label or tick values{p_end}
{p2col:{manhelp _tsnatscale G-2}}obtain nice label or tick values for time
	series{p_end}
{p2col:{manhelp twoway__function_gen G-2}}parse and generate variables for
	{helpb twoway function}{p_end}
{p2col:{manhelp twoway__histogram_gen G-2}}generate variables for
	{helpb twoway histogram}{p_end}
{p2col:{manhelp twoway__kdensity_gen G-2}}parse and generate variables for
	{helpb twoway kdensity}{p_end}
{p2col:{manhelp twoway_mata G-2:twoway mata}}{cmd:twoway} graphs from {helpb mata}
	matrices{p_end}
{p2col:{manhelp twoway_sunflower G-2:twoway sunflower}}graph
           density-distribution sunflower plots{p_end}
{p2col:{manhelpi labelstyle G-4}}formal definition of
	{it:{help markerlabelstyle}}{p_end}
{p2col:{manhelpi sunflowerstyle G-4}}expanded {help pstyle} used for
	{helpb twoway sunflower}{p_end}
{p2line}

{p2col:Longitudinal-Data/}{p_end}
{p2col 7 34 36 2:Panel-Data ([XT])}Description{p_end}
{p2line}
{p2col:{manhelp _xt XT}}verify data are {helpb xtset}{p_end}
{p2col:{manhelp _xtstrbal XT}}verify data are strongly balanced{p_end}
{p2line}

{p2col:Mata ([M])}Description{p_end}
{p2line}
{p2col:{manhelp m2_doppelganger M-2:doppelganger}}library double of built-in 
function{p_end}
{p2col:{manhelp matalabel M-3}}create column vectors in {help Mata} containing
        value labels{p_end}
{p2col:{manhelp mf_arfimaacf M-5:arfimaacf()}}autocovariance functions{p_end}
{p2col:{manhelp mf_arfimapsdensity M-5:arfimapsdensity()}}parametric spectral 
	density functions{p_end}
{p2col:{manhelp mf__factorsym M-5:_factorsym()}}factor a symmetric nonnegative-definite matrix{p_end}
{p2col:{manhelp mf__gauss_hermite_nodes M-5:_gauss_hermite_nodes()}}Gauss-Hermite quadrature{p_end}
{p2col:{manhelp mf___lnmvnormalden M-5:__lnmvnormalden()}}log-multivariate-normal density for multivariate samples{p_end}
{p2col:{manhelp mf__lsfitqr M-5:_lsfitqr()}}least-squares regression using QR 
	decomposition{p_end}
{p2col:{manhelp mf_moptimize_init_mlopts M-5:moptimize_init_mlopts()}}{cmd:ml}
	options parser for {cmd:moptimize()}{p_end}
{p2col:{manhelp mf_panelsum M-5:panelsum()}}panel sums{p_end}
{p2col:{manhelp mf__parse_colon M-5:_parse_colon()}}parse prefix command{p_end}
{p2col:{manhelp mf_rdirichlet M-5:rdirichlet()}}Dirichlet random variates{p_end}
{p2col:{manhelp mf_regex M-5:regexm()}}regular expression match{p_end}
{p2col:{manhelp mf_ustrregex M-5:ustrregexm()}}Unicode regular expression match{p_end}
{p2col:{manhelp mf_robust M-5:robust()}}robust variance estimates{p_end}
{p2col:{manhelp mf_spmatbanded M-5:SPMATbanded()}}banded matrix operators{p_end}
{p2col:{manhelp mf_st_fopen M-5:st_fopen()}}open file the Stata way{p_end}
{p2col:{manhelp mf_st_freadsignature M-5:st_freadsignature()}}read/write
        standard Stata file signature{p_end}
{p2col:{manhelp mf_st_lchar M-5:st_lchar()}}obtain/set "long" characteristics
        {p_end}
{p2col:{manhelp mf_st_matrix__joinbyname M-5:st_matrix__joinbyname()}}join
	rows of Stata matrices while matching column names{p_end}
{p2col:{manhelp mf_st_matrix_list M-5:st_matrix_list()}}list a Stata
	matrix{p_end}
{p2col:{manhelp mf_st_ms_display M-5:st_ms_display()}}coefficient table output
to strings{p_end}
{p2col:{manhelp mf_st_ms_unab M-5:st_ms_unab()}}unabbreviate matrix stripe elements{p_end}
{p2col:{manhelp mf_st_ms_utils M-5:st_ms_utils()}}matrix stripe utilities{p_end}
{p2col:{manhelp mf_subdiagget M-5:subdiagget()}}extract matrix subdiagonals{p_end}
{p2col:{manhelp mf_timer M-5:timer()}}profile code{p_end}
{p2col:{manhelp mf_toeplitzsolve M-5:toeplitzsolve()}}solve linear systems using Toeplitz matrix{p_end}
{p2col:{manhelp mf_trace_ABBAV M-5:trace_ABBAV()}}obtain trace of a special
	matrix{p_end}
{p2col:{manhelp mf_trace_AVBV M-5:trace_AVBV()}}obtain trace of a special 
	matrix{p_end}
{p2col:{manhelp mf_ucmpsdensity M-5:ucmpsdensity}}parametric spectral density 
	of a time-series stochastic cycle{p_end}
{p2col:{manhelp mf_vech_lower M-5:vech_lower()}}same as {helpb mf_vec:vech()} but omits the main diagonal{p_end}
{p2line}

{p2col:Multivariate}{p_end}
{p2col 7 34 36 2:Statistics ([MV])}Description{p_end}
{p2line}
{p2col:{manhelp parse_dissim MV}}parse similarity and dissimilarity measures{p_end}
{p2line}

{p2col:Programming ([P])}Description{p_end}
{p2line}
{p2col:{manhelp anova_terms P}}obtain {helpb anova} or {helpb manova} terms{p_end}
{p2col:{manhelp anovadef P}}obtain {helpb anova} or {helpb manova} term
	definitions{p_end}
{p2col:{manhelp _assert_mreldif P}}assert two matrices are the same{p_end}
{p2col:{manhelp _cassert P:_cassert}}verify two strings are equal{p_end}
{p2col:{manhelp _b_pclass P}}utility for constructing {cmd:e(b_pclass)}{p_end}
{p2col:{manhelp _check_lrmodel P}}utility for checking option 
{cmd:lrmodel}{p_end}
{p2col:{manhelp _check_omit P}}utility for checking collinearity behavior{p_end}
{p2col:{manhelp checkdlgfiles P}}check dialog files for linkage errors{p_end}
{p2col:{manhelp checkhlpfiles P}}check help files for linkage errors{p_end}
{p2col:{manhelp _cmdxel P}}parse commands with expression lists{p_end}
{p2col:{manhelp _coef_table P}}display estimation results{p_end}
{p2col:{manhelp _coef_table_header P}}automatic headers for coefficient
	tables{p_end}
{p2col:{manhelp _confirm_date P}}confirm a date string is given in a valid
	format{p_end}
{p2col:{manhelp copysource P}}copy source code to current directory{p_end}
{p2col:{manhelp _crcar1 P}}compute AR(1) rho from residuals{p_end}
{p2col:{manhelp cscript P}}begin a certification script{p_end}
{p2col:{manhelp cscript_log P}}begin or end a certification script log{p_end}
{p2col:{manhelp dialog_undocumented P}}undocumented dialog features{p_end}
{p2col:{manhelp _diparm P}}display ancillary parameters{p_end}
{p2col:{manhelp dirstats P}}report number of files in lettered
	subdirectories{p_end}
{p2col:{manhelp set_dockingguides P:set dockingguides}}enable docking guides
        for dockable windows (Windows only){p_end}
{p2col:{manhelp dta_equal P}}assert datasets equal{p_end}
{p2col:{manhelp _eqlist P}}general-purpose class for managing equation
	specifications{p_end}
{p2col:{manhelp expr_query P}}obtain variables used by expression{p_end}
{p2col:{manhelp find_hlp_file P}}find help files{p_end}
{p2col:{manhelp _fv_check_depvar P}}check
	for factor variables in list of dependent variables{p_end}
{p2col:{manhelp _getcovcorr P}}parse corr. and covariance matrix options{p_end}
{p2col:{manhelp _getfilename P}}handle path-filename specifications{p_end}
{p2col:{manhelp _get_diopts P}}parse
	standard display options for estimation commands{p_end}
{p2col:{manhelp _get_diparmopts P}}handle multiple transform. of ancillary
	param.{p_end}
{p2col:{manhelp _get_eformopts P}}parse the multiple forms of {cmd:eform()}{p_end}
{p2col:{manhelp _get_eqspec P}}identify equation elements from coefficient
	vector{p_end}
{p2col:{manhelp _get_offopt P}}obtain offset information{p_end}
{p2col:{manhelp inten P}}numeric base conversion{p_end}
{p2col:{manhelp keyfiles P}}explanation of {cmd:.key} files used by
	{helpb search}{p_end}
{p2col:{manhelp _labels2names P}}make Stata names for each level of a
	variable{p_end}
{p2col:{manhelp lrecomp P}}display log relative errors{p_end}
{p2col:{manhelp _make_constraints P}}make a constraint matrix from a {cmd:constraints()} specification{p_end}
{p2col:{manhelp _massert P:_massert}}verify two matrices are equal{p_end}
{p2col:{manhelp _matrix_table P}}display matrix as a table{p_end}
{p2col:{manhelp _mgarch_p_names P}}parse new variable lists for {cmd:mgarch}
        postestimation{p_end}
{p2col:{manhelp mkassert P}}generate {helpb assert}s for Stata objects{p_end}
{p2col:{manhelp _mkvec P}}process {cmd:from()} option prior to
	{helpb ml:ml model}{p_end}
{p2col:{manhelp ml_hold P:ml hold}}call {helpb ml} recursively{p_end}
{p2col:{manhelp mlopts P}}parse {helpb ml} options{p_end}
{p2col:{manhelp moptobj P}}recallable ML evaluator{p_end}
{p2col:{manhelp _ms_at_parse P}}parse {opt at()} specifications for
	postestimation commands{p_end}
{p2col:{manhelp _ms_balance P}}adjust {cmd:e(b)} by balancing factor-variable
	covariates{p_end}
{p2col:{manhelp _ms_build_info P}}build extra factor-variables information
	into column stripes{p_end}
{p2col:{manhelp _ms_display P}}display matrix stripe element{p_end}
{p2col:{manhelp _ms_dydx_parse P}}parse {opt dydx()} specifications for
	postestimation commands{p_end}
{p2col:{manhelp _ms_element_info P}}matrix stripe element information{p_end}
{p2col:{manhelp _ms_empty_info P}}matrix stripe information on elements
	flagged as empty cells{p_end}
{p2col:{manhelp _ms_eq_display P}}display matrix stripe equation{p_end}
{p2col:{manhelp _ms_eq_info P}}matrix stripe equation information{p_end}
{p2col:{manhelp _ms_lf_info P}}matrix stripe linear form information{p_end}
{p2col:{manhelp _ms_extract_varlist P}}match variables from {cmd:e(b)}{p_end}
{p2col:{manhelp _ms_findomitted P}}find and flag omitted matrix elements{p_end}
{p2col:{manhelp _ms_modify P}}modify column stripes{p_end}
{p2col:{manhelp _ms_omit_info P}}matrix stripe collinearity information{p_end}
{p2col:{manhelp _ms_op_info P}}matrix stripe operator information{p_end}
{p2col:{manhelp _ms_parse_parts P}}parse
	a single matrix stripe element{p_end}
{p2col:{manhelp _ms_put_omit P}}add {cmd:o.} operators to a matrix stripe element{p_end}
{p2col:{manhelp _ms_split P}}matrix stripe splitting tools{p_end}
{p2col:{manhelp _ms_unab P}}unabbreviate matrix stripe elements{p_end}
{p2col:{manhelp _mtest P}}perform multiple (simultaneous) testing adjustment{p_end}
{p2col:{manhelp _nobs P}}count the number of observations{p_end}
{p2col:{manhelp notes_ P}}commands for use with {helpb notes}{p_end}
{p2col:{manhelp _on_colon_parse P}}parse based on colon{p_end}
{p2col:{manhelp opts_exclusive P}}error message for mutually exclusive
	options{p_end}
{p2col:{manhelp _parse P}}parse complicated syntax (for instance,
	{helpb graph}){p_end}
{p2col:{manhelp _pb_exp_list P}}general-purpose class for managing
	parentheses-bound expression lists{p_end}
{p2col:{manhelp postrtoe P}}move results from {cmd:r()} into {cmd:e()}{p_end}
{p2col:{manhelp _pred_se P}}add single-equation extensions to
	{helpb predict}{p_end}
{p2col:{manhelp _prefix P}}overview of tools for {it:prefix} commands{p_end}
{p2col:{manhelp profiler P}}profile Stata programs{p_end}
{p2col:{manhelp projmanager P}}open Stata Project Manager{p_end}
{p2col:{manhelp _qsort_index P}}sort a list of words{p_end}
{p2col:{manhelp rcof P}}verify return code{p_end}
{p2col:{manhelp _recast P}}change storage type of variable{p_end}
{p2col:{manhelp _restore_labels P}}restore value labels to variables{p_end}
{p2col:{manhelp _rmcoll2list P}}check for collinearity in the union of two
lists of variables{p_end}
{p2col:{manhelp _rmcollright P}}remove collinear variables from the right{p_end}
{p2col:{manhelp _sassert P:_sassert}}verify two scalars are equal{p_end}
{p2col:{manhelp _score_spec P}}parse syntax for generating score variables{p_end}
{p2col:{manhelp set_buildfvinfo P:set buildfvinfo}}build
	extra factor-variables information into parameter estimates{p_end}
{p2col:{manhelp sortseed P:set sortseed}}set the seed used to break ties in 
	sorts{p_end}
{p2col:{manhelp storedresults P}}manipulate and verify {cmd:r()} and {cmd:e()}
	results{p_end}
{p2col:{manhelp _strip_labels P}}remove value labels from variables{p_end}
{p2col:{manhelp _stubstar2names P}}parse new variable lists{p_end}
{p2col:{manhelp _tab P}}generate simple tables{p_end}
{p2col:{manhelp _unab P}}unabbreviate variable list from matrix stripe
	element{p_end}
{p2col:{manhelp varclassify P}}classify a single variable as categorical or not{p_end}
{p2col:{manhelp _vassert P:_vassert}}verify two variables are equal{p_end}
{p2col:{manhelp _vce_parse P}}parse the {cmd:vce()} option{p_end}
{p2col:{manhelp _vce_parserun P}}parse options {cmd:vce(bootstrap)} and
                     {cmd:vce(jackknife)}{p_end}
{p2col:{manhelp version_missing P:version, missing}}set version to use modern
treatment of missing values{p_end}
{p2line}

{p2col:Structural Equation}{p_end}
{p2col 7 34 36 2:Modeling ([SEM])}Description{p_end}
{p2line}
{p2col:{manhelp gsem_fvstandard SEM:gsem fvstandard}}keep track of levels for factor variables{p_end}
{p2col:{manhelp webgetsem SEM}}open SEM example path diagram{p_end}
{p2line}

{p2col:Survival ([ST])}Description{p_end}
{p2line}
{p2col:{manhelp st_forceshared ST:stcox, forceshared}}force estimation of a shared-frailty survival model{p_end}
{p2col:{manhelp st_forceshared ST:streg, forceshared}}force estimation of a shared-frailty survival model{p_end}
{p2line}

{p2col:Survey ([SVY])}Description{p_end}
{p2line}
{p2col:{manhelp brrstat SVY}}report results from balanced repeated replication{p_end}
{p2col:{manhelp is_svy SVY}}determine if last estimation was {helpb svy} class{p_end}
{p2col:{manhelp jkstat SVY}}report jackknife results{p_end}
{p2col:{manhelp _svy_mkdeff SVY}}calculate survey design effects{p_end}
{p2col:{manhelp _svy_mkmeff SVY}}calculate survey misspecification effects{p_end}
{p2col:{manhelp svy_parsing SVY}}checking options for community-contributed
	commands used with the {cmd:svy} prefix{p_end}
{p2col:{manhelp _svy_setup SVY}}retrieve {helpb svy} settings and adjust
	weights{p_end}
{p2col:{manhelp svycal SVY}}calibration adjusted sampling weights{p_end}
{p2col:{manhelp svygen SVY}}generate adjusted sampling weights{p_end}
{p2line}

{p2col:Time-Series ([TS])}Description{p_end}
{p2line}
{p2col:{manhelp _sep_varsylags TS}}return the lag structure of varlist{p_end}
{p2col:{manhelp _ts TS}}verify data are {helpb tsset}{p_end}
{p2line}
{p2colreset}{...}
