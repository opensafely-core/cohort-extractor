{smcl}
{* *! version 1.0.0  23jun2019}{...}
{bf:Datasets for Stata Lasso Reference Manual, Release 16}
{hline}
{p}
Datasets used in the Stata Documentation were selected to demonstrate
 how to use Stata.  Some datasets have been altered to explain a particular
 feature.  Do not use these datasets for
 analysis.
{p_end}
{hline}

    {title:{help coefpath}}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}
	breathe.dta{col 32}{stata "use http://www.stata-press.com/data/r16/breathe.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/breathe.dta":describe}

    {title:{help elasticnet}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}
	fakesurvey2_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey2_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey2_vl.dta":describe}

    {title:Inference examples}
	breathe.dta{col 32}{stata "use http://www.stata-press.com/data/r16/breathe.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/breathe.dta":describe}
	lassoex.dta{col 32}{stata "use http://www.stata-press.com/data/r16/lassoex.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/lassoex.dta":describe}
	mroz.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mroz.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mroz.dta":describe}

    {title:{help lasso}}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}

    {title:{help lassocoef}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}
	mroz2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mroz2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mroz2.dta":describe}
	breathe.dta{col 32}{stata "use http://www.stata-press.com/data/r16/breathe.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/breathe.dta":describe}

    {title:lasso examples}
	fakesurvey.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey.dta":describe}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}

    {title:{help lassogof}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}

    {title:{help lassoinfo}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}
	mroz2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mroz2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mroz2.dta":describe}
	breathe.dta{col 32}{stata "use http://www.stata-press.com/data/r16/breathe.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/breathe.dta":describe}

    {title:{help lassoknots}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}

    {title:{help lassoselect}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}

    {title:{help sqrtlasso}}
	fakesurvey_vl.dta{col 32}{stata "use http://www.stata-press.com/data/r16/fakesurvey_vl.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/fakesurvey_vl.dta":describe}
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
