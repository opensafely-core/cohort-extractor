{smcl}
{* *! version 1.5.2  30may2019}{...}
{bf:Datasets for Stata Survey Data Reference Manual, Release 16}
{hline}
{p}
Datasets used in the Stata Documentation were selected to demonstrate
 how to use Stata.  Some datasets have been altered to explain a particular
 feature.  Do not use these datasets for
 analysis.
{p_end}
{hline}

    {title:Calibration}
	smho.dta{col 32}{stata "use http://www.stata-press.com/data/r16/stdize.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/stdize.dta":describe}

{hline}

    {title:Direct standardization}
	stdize.dta{col 32}{stata "use http://www.stata-press.com/data/r16/stdize.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/stdize.dta":describe}

{hline}

    {title:{help svy_estat:estat}}
	nhanes2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2.dta":describe}
	nhanes2b.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2b.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2b.dta":describe}
	nmihs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nmihs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nmihs.dta":describe}
	strata5.dta{col 32}{stata "use http://www.stata-press.com/data/r16/strata5.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/strata5.dta":describe}
	nhanes2d.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2d.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2d.dta":describe}

{hline}

    {title:ml for svy}
	multistage.dta{col 32}{stata "use http://www.stata-press.com/data/r16/multistage.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/multistage.dta":describe}

{hline}

    {title:Poststratification}
	poststrata.dta{col 32}{stata "use http://www.stata-press.com/data/r16/poststrata.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/poststrata.dta":describe}

{hline}

    {title:Subpopulation estimation}
	nhanes2d.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2d.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2d.dta":describe}
	nmihs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nmihs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nmihs.dta":describe}

    {title:{help Survey}}
	stage5a.dta{col 32}{stata "use http://www.stata-press.com/data/r16/stage5a.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/stage5a.dta":describe}
	multistage.dta{col 32}{stata "use http://www.stata-press.com/data/r16/multistage.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/multistage.dta":describe}
	nhefs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhefs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhefs.dta":describe}
	nhanes2b.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2b.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2b.dta":describe}
	highschool.dta{col 32}{stata "use http://www.stata-press.com/data/r16/highschool.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/highschool.dta":describe}
	nhanes2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2.dta":describe}
	nhanes2brr.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2brr.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2brr.dta":describe}
	stdize.dta{col 32}{stata "use http://www.stata-press.com/data/r16/stdize.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/stdize.dta":describe}
	poststrata.dta{col 32}{stata "use http://www.stata-press.com/data/r16/poststrata.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/poststrata.dta":describe}

    {title:{help svy}}
	nhanes2f.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2f.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2f.dta":describe}

    {title:{help svy bootstrap}}
	nmihs_bs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nmihs_bs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nmihs_bs.dta":describe}
	nmihs_mbs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nmihs_mbs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nmihs_mbs.dta":describe}

    {title:{help svy brr}}
	nhanes2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2.dta":describe}
	nhanes2brr.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2brr.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2brr.dta":describe}

    {title:{help svy estimation}}
	nhanes2f.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2f.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2f.dta":describe}
	nmihs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nmihs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nmihs.dta":describe}
	nhanes2d.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2d.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2d.dta":describe}
	nhefs.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhefs.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhefs.dta":describe}

    {title:{help svy jackknife}}
	nhanes2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2.dta":describe}
	nhanes2jknife.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2jknife.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2jknife.dta":describe}

    {title:{help svy postestimation}}
	nhanes2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2.dta":describe}
	nhanes2d.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2d.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2d.dta":describe}
	nhanes2f.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2f.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2f.dta":describe}

    {title:{help svy sdr}}
	ss07ptx.dta{col 32}{stata "use http://www.stata-press.com/data/r16/ss07ptx.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/ss07ptx.dta":describe}

    {title:{help "svy: tabulate oneway"}}
	nhanes2b.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2b.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2b.dta":describe}

    {title:{help "svy: tabulate twoway"}}
	nhanes2b.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2b.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2b.dta":describe}
	svy_tabopt.dta{col 32}{stata "use http://www.stata-press.com/data/r16/svy_tabopt.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/svy_tabopt.dta":describe}

    {title:{help svydescribe}}
	nhanes2b.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhanes2b.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhanes2b.dta":describe}

    {title:{help svyset}}
	stage5a.dta{col 32}{stata "use http://www.stata-press.com/data/r16/stage5a.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/stage5a.dta":describe}
	fpc.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fpc.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fpc.dta":describe}
	svyset_wr.dta{col 32}{stata "use http://www.stata-press.com/data/r16/svyset_wr.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/svyset_wr.dta":describe}
	stage5a_jkw.dta{col 32}{stata "use http://www.stata-press.com/data/r16/stage5a_jkw.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/stage5a_jkw.dta":describe}
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
