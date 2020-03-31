{smcl}
{* *! version 1.0.2  29may2013}{...}
{bf:Example path diagrams from}
{bf:[SEM] Stata Structural Equation Modeling Reference Manual}
{hline}
{p 0 0}Click on {bf:{stata " ":SEM}} at the right below to open a path diagram
or on {bf:{stata " ":SEM/dta}} to open a diagram and the associated dataset.
Clicking on the example number on the left below opens the PDF documentation
for the associated examples.  Requires web access.{p_end}
{hline}

{p 0 4}
{space 73}Diagram{p_end}
{p 0 4}
{space 62}Diagram{space 3}and Data{p_end}
{hline}
{p 0 4}
{findalias semsfmm}{space 4}Single-factor measurement model
	  {space 16}{bf:{stata "webgetsem sem_1fmm":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_1fmm sem_1fmm":SEM/dta}}{p_end}
{p 0 4}
{findalias semssd}{space 4}Creating a dataset from published covariances
	  {space  2}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semtfmm}{space 4}Two-factor measurement model
	  {space 19}{bf:{stata "webgetsem sem_2fmm":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_2fmm sem_2fmm":SEM/dta}}{p_end}
{p 0 4}
{findalias semgof}{space 4}Goodness-of-fit statistics
	  {space 21}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semmindices}{space 4}Modification indices
	  {space 27}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semreg}{space 4}Linear regression
	  {space 30}{bf:{stata "webgetsem sem_regress":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_regress autowt2":SEM/dta}}{p_end}
{p 0 4}
{findalias semnrsm}{space 4}Nonrecursive structural model
	  {space 18}{bf:{stata "webgetsem sem_sm1":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_sm1 sem_sm1":SEM/dta}}{p_end}
{p 0 4}
{findalias sembequal}{space 4}Testing that and constraining coefficients
	  {space  5}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semmc}{space 4}Structural model with measurement component
	  {space  4}{bf:{stata "webgetsem sem_sm2":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_sm2 sem_sm2":SEM/dta}}{p_end}
{p 0 4}
{findalias semmimic}{space 3}MIMIC model
	 {space 36}{bf:{stata "webgetsem sem_mimic1":SEM}}
	 {space  3}{bf:{stata "webgetsem sem_mimic1 sem_mimic1":SEM/dta}}{p_end}
{p 0 4}
{findalias semframework}{space 3}estat framework
	  {space 32}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semsureg}{space 3}Seemingly unrelated regression
	  {space 17}{bf:{stata "webgetsem sem_sureg":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_sureg auto":SEM/dta}}{p_end}
{p 0 4}
{findalias semeqtest}{space 3}Equation-level Wald test
	  {space 23}{it:no new diagrams}{p_end}
{p 0 4}
{findalias sempredict}{space 3}Predicted values
	  {space 31}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semhcfa}{space 3}Higher-order CFA
	  {space 31}{bf:{stata "webgetsem sem_hcfa1":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_hcfa1 sem_hcfa1":SEM/dta}}{p_end}
{p 0 4}
{findalias semcorr}{space 3}Correlation
	  {space 36}{bf:{stata "webgetsem sem_corr":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_corr census13":SEM/dta}}{p_end}
{p 0 4}
{findalias semcu}{space 3}Correlated uniqueness model
	  {space 20}{bf:{stata "webgetsem sem_cu1":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_cu1 sem_cu1":SEM/dta}}{p_end}
{p 0 4}
{findalias semlgm}{space 3}Latent growth model
	  {space 28}{bf:{stata "webgetsem sem_lcm":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_lcm sem_lcm":SEM/dta}}{p_end}
{p 0 4}
{findalias semssdg}{space 3}Creating multiple-group summary statistics data
	  {space  0}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semtfmmg}{space 3}Two-factor measurement model by group
	  {space 10}{bf:{stata "webgetsem sem_2fmmby":SEM}}
	  {space  3}{bf:{stata "webgetsem sem_2fmmby sem_2fmmby":SEM/dta}}{p_end}
{p 0 4}
{findalias semggof}{space 3}Group-level goodness of fit
	  {space 20}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semginv}{space 3}Testing parameter equality across groups
	  {space  7}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semcnsg}{space 3}Specifying parameter constraints across groups
	  {space  1}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semrel}{space 3}Reliability
	  {space 36}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semssdbuild}{space 3}Creating summary statistics data from raw data
	  {space  1}{it:no new diagrams}{p_end}
{p 0 4}
{findalias semmlmv}{space 3}Fitting a model using data missing at random
	  {space  3}{bf:{stata "webgetsem cfa_missing":SEM}}
	  {space  3}{bf:{stata "webgetsem cfa_missing cfa_missing":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemsfmm}{space 2}Single-factor measurement model (generalized)
          {space  2}{bf:{stata "webgetsem gsem_1fmm":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_1fmm gsem_1fmm":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemoirt}{space 2}One-parameter logistic IRT (Rasch) model
          {space  7}{bf:{stata "webgetsem gsem_irt1":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_irt1 gsem_cfa":SEM/dta}}{p_end}
{p 0 4}
{space 19}1PL IRT model, variance constrained to {cmd:1}
          {space  7}{bf:{stata "webgetsem gsem_irt2":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_irt2 gsem_cfa":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemtirt}{space 2}Two-parameter logistic IRT model
          {space  15}{bf:{stata "webgetsem gsem_irt3":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_irt3 gsem_cfa":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemcfam}{space 2}Two-level measurement model (generalized)
          {space  6}{bf:{stata "webgetsem gsem_mlcfa2":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_mlcfa2 gsem_cfa":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemtfmm}{space 2}Two-factor measurement model (generalized)
          {space  5}{bf:{stata "webgetsem gsem_2fmm":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_2fmm gsem_cfa":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemsem}{space 2}Full structural equation model (generalized)
          {space  3}{bf:{stata "webgetsem gsem_sem":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_sem gsem_cfa":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemlogit}{space 2}Logistic regression
          {space  28}{bf:{stata "webgetsem gsem_logit":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_logit gsem_lbw":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemcombined}{space 2}Combined models (generalized responses)
          {space  8}{bf:{stata "webgetsem gsem_comb":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_comb gsem_lbw":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemoprobit}{space 2}Ordered probit
          {space  33}{bf:{stata "webgetsem gsem_oprobit":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_oprobit gsem_issp93":SEM/dta}}{p_end}
{p 0 4}
{space 19}Ordered logistic
          {space  31}{bf:{stata "webgetsem gsem_ologit":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_ologit gsem_issp93":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemmimic}{space 2}MIMIC model (generalized response)
          {space  13}{bf:{stata "webgetsem gsem_mimic":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_mimic gsem_issp93":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemmlogit}{space 2}Multinomial logistic regression
          {space  16}{bf:{stata "webgetsem gsem_mlogit1":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_mlogit1 gsem_sysdsn1":SEM/dta}}{p_end}
{p 0 4}
{space 19}Multinomial logistic model with constraints
          {space  4}{bf:{stata "webgetsem sem_mlogit2":SEM}}
          {space  3}{bf:{stata "webgetsem sem_mlogit2 gsem_sysdsn1":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemmris}{space 2}Random-intercept model
          {space  25}{bf:{stata "webgetsem gsem_rint":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_rint gsem_nlsy":SEM/dta}}{p_end}
{p 0 4}
{space 19}Random-slope model
          {space  29}{bf:{stata "webgetsem gsem_rslope":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_rslope gsem_nlsy":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemtlevel}{space 2}Three-level model (generalized response)
          {space  7}{bf:{stata "webgetsem gsem_3lev":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_3lev gsem_melanoma":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemcross}{space 2}Crossed-effects model
          {space  26}{bf:{stata "webgetsem gsem_cross":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_cross gsem_fifeschool":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemtmlogit}{space 2}Multinomial logistic, shared random effects
          {space  4}{bf:{stata "webgetsem gsem_mlmlogit1":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_mlmlogit1 gsem_lineup":SEM/dta}}{p_end}
{p 0 4}
{space 19}Multinomial logistic, separate random effects
          {space  2}{bf:{stata "webgetsem gsem_mlmlogit2":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_mlmlogit2 gsem_lineup":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemmediation}{space 2}One-level mediation model
          {space  22}{bf:{stata "webgetsem sem_med":SEM}}
          {space  3}{bf:{stata "webgetsem sem_med gsem_multmed":SEM/dta}}{p_end}
{p 0 4}
{space 19}Two-level mediation model
          {space  22}{bf:{stata "webgetsem gsem_mlmed":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_mlmed gsem_multmed":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemsel}{space 2}Heckman selection model
          {space  24}{bf:{stata "webgetsem gsem_select":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_select gsem_multmed":SEM/dta}}{p_end}
{p 0 4}
{findalias gsemtreat}{space 2}Endogenous treatment-effects model
          {space  13}{bf:{stata "webgetsem gsem_treat":SEM}}
          {space  3}{bf:{stata "webgetsem gsem_treat gsem_union3":SEM/dta}}{p_end}{hline}

