{smcl}
{* *! version 1.5.2  30may2019}{...}
{bf:Datasets for Stata Multiple-Imputation Reference Manual, Release 16}
{hline}
{p}
Datasets used in the Stata Documentation were selected to demonstrate
 how to use Stata.  Some datasets have been altered to explain a particular
 feature.  Do not use these datasets for
 analysis.
{p_end}
{hline}

    {title:{help mi_intro_substantive:Intro substantive}}
	mheart0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart0.dta":describe}

    {title:{help mi_intro:Intro}}
	mheart5.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart5.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart5.dta":describe}

    {title:{help mi estimate}}
	mheart1s20.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart1s20.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart1s20.dta":describe}
	mhouses1993s30.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mhouses1993s30.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mhouses1993s30.dta":describe}
	mdrugtrs25.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mdrugtrs25.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mdrugtrs25.dta":describe}
	mjsps5.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mjsps5.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mjsps5.dta":describe}

    {title:{help mi estimate using}}
	mhouses1993s30.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mhouses1993s30.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mhouses1993s30.dta":describe}

    {title:{help mi export ice}}
	miproto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/miproto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/miproto.dta":describe}

    {title:{help mi export nhanes1}}
	miproto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/miproto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/miproto.dta":describe}

    {title:{help mi import flong}}
	ourunsetdata.dta{col 32}{stata "use http://www.stata-press.com/data/r16/ourunsetdata.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/ourunsetdata.dta":describe}

    {title:{help mi import flongsep}}
	imorig.dta{col 32}{stata "use http://www.stata-press.com/data/r16/imorig.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/imorig.dta":describe}
	im1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/im1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/im1.dta":describe}
	im2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/im2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/im2.dta":describe}

    {title:{help mi import ice}}
	icedata.dta{col 32}{stata "use http://www.stata-press.com/data/r16/icedata.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/icedata.dta":describe}

    {title:{help mi import nhanes1}}
	nhorig.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nhorig.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nhorig.dta":describe}
	nh1.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nh1.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nh1.dta":describe}
	nh2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/nh2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/nh2.dta":describe}

    {title:{help mi import wide}}
	wi.dta{col 32}{stata "use http://www.stata-press.com/data/r16/wi.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/wi.dta":describe}

    {title:{help mi impute}}
	mheart1s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart1s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart1s0.dta":describe}
	mheart5s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart5s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart5s0.dta":describe}
	mheart7s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart7s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart7s0.dta":describe}

    {title:{help mi impute chained}}
	mheart8s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart8s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart8s0.dta":describe}
	mheart9s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart9s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart9s0.dta":describe}
	mheart10s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart10s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart10s0.dta":describe}

    {title:{help mi impute intreg}}
	mheartintreg.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheartintreg.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheartintreg.dta":describe}

    {title:{help mi impute logit}}
	mheart2.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart2.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart2.dta":describe}

    {title:{help mi impute mlogit}}
	mheart3.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart3.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart3.dta":describe}

    {title:{help mi impute monotone}}
	mheart5s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart5s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart5s0.dta":describe}
	mheart6s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart6s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart6s0.dta":describe}

    {title:{help mi impute mvn}}
	mheart5s0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart5s0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart5s0.dta":describe}
	mhouses1993.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mhouses1993.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mhouses1993.dta":describe}
	mvnexample0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mvnexample0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mvnexample0.dta":describe}

    {title:{help mi impute nbreg}}
	mheartpois.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheartpois.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheartpois.dta":describe}

    {title:{help mi impute ologit}}
	mheart4.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart4.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart4.dta":describe}

    {title:{help mi impute pmm}}
	mheart0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart0.dta":describe}

    {title:{help mi impute poisson}}
	mheartpois.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheartpois.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheartpois.dta":describe}

    {title:{help mi impute regress}}
	mheart0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart0.dta":describe}

    {title:{help mi impute truncreg}}
	mheart0.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart0.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart0.dta":describe}

    {title:{help mi impute usermethod}}
	auto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/auto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/auto.dta":describe}

    {title:{help mi predict}}
	mhouses1993s30.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mhouses1993s30.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mhouses1993s30.dta":describe}
	mheart1s20.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart1s20.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart1s20.dta":describe}
	mdrugtrs25.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mdrugtrs25.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mdrugtrs25.dta":describe}

    {title:{help mi test}}
	mhouses1993s30.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mhouses1993s30.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mhouses1993s30.dta":describe}

    {title:{help mi_styles:Styles}}
	miproto.dta{col 32}{stata "use http://www.stata-press.com/data/r16/miproto.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/miproto.dta":describe}

    {title:{help mi_workflow:Workflow}}
	mheart5.dta{col 32}{stata "use http://www.stata-press.com/data/r16/mheart5.dta":use} | {stata "describe using  http://www.stata-press.com/data/r16/mheart5.dta":describe}
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
