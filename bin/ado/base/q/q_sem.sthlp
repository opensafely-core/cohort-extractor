{smcl}
{* *! version 1.4.1  22may2019}{...}
{bf:Datasets for Stata Structural Equation Modeling Reference Manual, Release 16}
{hline}
{p}
Datasets used in the Stata Documentation were selected to demonstrate
 how to use Stata.  Some datasets have been altered to explain a particular
 feature.  Do not use these datasets for
 analysis.
{p_end}
{hline}

{p 4 4 2}
Also see {help sempath_examples:SEM path diagram examples} to obtain the path
diagrams shown in the {it:Stata Structural Equation Modeling Reference Manual}.
{p_end}

    {title:Example 1 - Single-factor measurement model}
	sem_1fmm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_1fmm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_1fmm.dta":describe}

    {title:Example 3 - Two-factor measurement model}
	sem_2fmm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmm.dta":describe}

    {title:Example 4 - Goodness-of-fit statistics}
	sem_2fmm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmm.dta":describe}

    {title:Example 5 - Modification indices}
	sem_2fmm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmm.dta":describe}

    {title:Example 6 - Linear regression}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}

    {title:Example 7 - Nonrecursive structural model}
	sem_sm1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_sm1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_sm1.dta":describe}

    {title:Example 8 - Testing that coefficients are equal, and constraining them}
	sem_sm1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_sm1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_sm1.dta":describe}

    {title:Example 9 - Structural model with measurement component}
	sem_sm2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_sm2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_sm2.dta":describe}

    {title:Example 10 - MIMIC model}
	sem_mimic1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_mimic1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_mimic1.dta":describe}

    {title:Example 11 - estat framework}
	sem_mimic1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_mimic1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_mimic1.dta":describe}

    {title:Example 12 - Seemingly unrelated regression}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}

    {title:Example 13 - Equation-level Wald test}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}

    {title:Example 14 - Predicted values}
	sem_1fmm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_1fmm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_1fmm.dta":describe}

    {title:Example 16 - Higher-order CFA}
	sem_hcfa1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_hcfa1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_hcfa1.dta":describe}

    {title:Example 16 - Correlation}
	census13.dta{col 32}{stata "use http://www.stata-press.com/data/r16/census13.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/census13.dta":describe}

    {title:Example 17 - Correlated uniqueness model}
	sem_cu1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_cu1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_cu1.dta":describe}

    {title:Example 18 - Latent growth model}
	sem_lcm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_lcm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_lcm.dta":describe}

    {title:Example 20 - Two-factor measurement model by group}
	sem_2fmmby.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmmby.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmmby.dta":describe}

    {title:Example 21 - Group-level goodness of fit}
	sem_2fmmby.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmmby.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmmby.dta":describe}

    {title:Example 22 - Testing parameter equality across groups}
	sem_2fmmby.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmmby.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmmby.dta":describe}

    {title:Example 23 - Specifying parameter constraints across groups}
	sem_2fmmby.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_2fmmby.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_2fmmby.dta":describe}

    {title:Example 24 - Reliability}
	sem_rel.dta{col 32}{stata "use http://www.stata-press.com/data/r16/sem_rel.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/sem_rel.dta":describe}

    {title:Example 25 - Creating summary statistics data from raw data}
	auto2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto2.dta":describe}

    {title:Example 26 - Fitting a model using data missing at random}
	cfa_missing.dta{col 32}{stata "use http://www.stata-press.com/data/r16/cfa_missing.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/cfa_missing.dta":describe}

    {title:Example 27g - Single-factor measurement model (generalized response)}
	gsem_1fmm.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_1fmm.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_1fmm.dta":describe}

    {title:Example 28g - One-parameter logistic IRT (Rasch) model}
	gsem_cfa.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_cfa.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_cfa.dta":describe}

    {title:Example 29g - Two-parameter logistic IRT model}
	gsem_cfa.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_cfa.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_cfa.dta":describe}

    {title:Example 30g - Two-level measurement model (multilevel, generalized response)}
	gsem_cfa.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_cfa.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_cfa.dta":describe}

    {title:Example 31g - Two-factor measurement model (generalized response)}
	gsem_cfa.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_cfa.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_cfa.dta":describe}

    {title:Example 32g - Full structural equation model (generalized response)}
	gsem_cfa.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_cfa.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_cfa.dta":describe}

    {title:Example 33g - Logistic regression}
	gsem_lbw.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_lbw.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_lbw.dta":describe}

    {title:Example 34g - Combined models (generalized responses)}
	gsem_lbw.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_lbw.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_lbw.dta":describe}

    {title:Example 35g - Ordered probit and ordered logit}
	gsem_issp93.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_issp93.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_issp93.dta":describe}

    {title:Example 36g - MIMIC model (generalized response)}
	gsem_issp93.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_issp93.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_issp93.dta":describe}

    {title:Example 37g - Multinomial logistic regression}
	gsem_sysdsn1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_sysdsn1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_sysdsn1.dta":describe}

    {title:Example 38g - Random-intercept and random-slope models (multilevel)}
	gsem_nlsy.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_nlsy.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_nlsy.dta":describe}

    {title:Example 39g - Three-level model (multilevel, generalized response)}
	gsem_melanoma.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_melanoma.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_melanoma.dta":describe}

    {title:Example 40g - Crossed models (multilevel)}
	gsem_fifeschool.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_fifeschool.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_fifeschool.dta":describe}

    {title:Example 41g - Two-level multinomial logistic regression (multilevel)}
	gsem_lineup.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_lineup.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_lineup.dta":describe}

    {title:Example 42g - One- and two-level mediation models (multilevel)}
	gsem_multmed.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_multmed.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_multmed.dta":describe}

    {title:Example 43g - Tobit regression}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}

    {title:Example 44g - Interval regression}
	intregxmpl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/intregxmpl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/intregxmpl.dta":describe}

    {title:Example 45g - Heckman selection model}
	gsem_womenwk.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_womenwk.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_womenwk.dta":describe}

    {title:Example 46g - Endogenous treatment-effects model}
	gsem_union3.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_union3.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_union3.dta":describe}

    {title:Example 47g - Exponential survival model}
	gsem_kva.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_kva.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_kva.dta":describe}

    {title:Example 48g - Loglogistic survival model with censored and truncated data}
	gsem_diet.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_diet.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_diet.dta":describe}

    {title:Example 49g - Multiple-group Weibull survival model}
	gsem_cancer.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_cancer.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_cancer.dta":describe}

    {title:Example 50g - Latent class model}
	gsem_lca1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_lca1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_lca1.dta":describe}

    {title:Example 51g - Latent class goodness-of-fit statistics}
	gsem_lca1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_lca1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_lca1.dta":describe}

    {title:Example 52g - Latent profile model}
	gsem_lca2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_lca2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_lca2.dta":describe}

    {title:Example 53g - Finite mixture Poisson regression}
	gsem_mixture.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_mixture.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_mixture.dta":describe}

    {title:Example 54g - Finite mixture Poisson regression, multiple responses}
	gsem_mixture.dta{col 32}{stata "use http://www.stata-press.com/data/r16/gsem_mixture.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/gsem_mixture.dta":describe}
{hline}

{p}
StataCorp gratefully acknowledges that some datasets in the Reference
 Manuals are proprietary and have been used in our printed documentation
  with the express permission of the copyright holders. If any copyright
 holder believes that by making these datasets available to the public,
 StataCorp is in violation of the letter or spirit of any such agreement,
 please contact {browse "mailto:tech-support@stata.com":tech-support@stata.com}
 and any such materials will be removed from this webpage.
{p_end}
