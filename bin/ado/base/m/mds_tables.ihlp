{* *! version 1.0.9  09dec2014}{...}
{marker method}{...}
{synoptset 15}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt c:lassical}}classical MDS; default if neither {cmd:loss()}
nor {cmd:transform()} is specified{p_end}
{synopt:{opt m:odern}}modern MDS; default if {cmd:loss()} or {cmd:transform()}
is specified; except when {cmd:loss(stress)} and {cmd:transform(monotonic)}
are specified{p_end}
{synopt:{opt n:onmetric}}nonmetric (modern) MDS; default when {cmd:loss(stress)}
and {cmd:transform(monotonic)} are specified{p_end}
{synoptline}


{marker loss}{...}
{synoptset 15}{...}
{p2coldent:{it:loss}}Description{p_end}
{synoptline}
{synopt:{opt stre:ss}}stress criterion, normalized by distances; the default{p_end}
{synopt:{opt nstr:ess}}stress criterion, normalized by disparities{p_end}
{synopt:{opt sstr:ess}}squared stress criterion, normalized by
	distances{p_end}
{synopt:{opt nsst:ress}}squared stress criterion, normalized by
	disparities{p_end}
{synopt:{opt stra:in}}strain criterion (with {cmd:transform(identity)}
is equivalent to classical MDS){p_end}
{synopt:{opt sam:mon }}Sammon mapping{p_end}
{synoptline}


{marker tfunction}{...}
{synoptset 15}{...}
{p2coldent:{it:tfunction}}Description{p_end}
{synoptline}
{synopt:{opt i:dentity}}no transformation; disparity = dissimilarity; the
default{p_end}
{synopt:{opt p:ower}}power alpha: disparity = dissimilarity^alpha{p_end}
{synopt:{opt m:onotonic}}weakly monotonic increasing functions
	(nonmetric scaling); only with {cmd:loss(stress)}{p_end}
{synoptline}


{marker norm}{...}
{synoptset 26}{...}
{p2coldent:{it:norm}}Description{p_end}
{synoptline}
{synopt:{opt p:rincipal}}principal orientation; location=0; the default{p_end}
{synopt:{opt c:lassical}}Procrustes rotation toward classical solution{p_end}
{synopt:{opt t:arget(matname)}[{cmd:, }{opt copy}]}Procrustes rotation toward {it:matname}; ignore naming conflicts if {cmd:copy} is specified{p_end}
{synoptline}


{marker initopt}{...}
{synoptset 26}{...}
{p2coldent:{it:initopt}}Description{p_end}
{synoptline}
{synopt:{opt c:lassical}}start with classical solution; the default{p_end}
{synopt:{opt r:andom}[{cmd:(}{it:#}{cmd:)}]}start at random configuration,
setting seed to {it:#}{p_end}
{synopt:{opt f:rom(matname)}[{cmd:, }{opt copy}]}start from
{it:matname}; ignore naming conflicts if {cmd:copy} is specified{p_end}
{synoptline}
