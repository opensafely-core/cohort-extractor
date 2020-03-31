{* *! version 1.0.5  07apr2011}{...}
{marker rotation_methods}{...}
{p2coldent:{it:rotation_methods}}Description{p_end}
{synoptline}
{p2coldent:* {opt v:arimax}}varimax ({cmd:orthogonal} only); the default{p_end}
{synopt:{opt vgpf}}varimax via the GPF algorithm ({cmd:orthogonal} only){p_end}
{synopt:{opt quartima:x}}quartimax ({cmd:orthogonal} only){p_end}
{synopt:{opt equa:max}}equamax ({cmd:orthogonal} only){p_end}
{synopt:{opt parsi:max}}parsimax ({cmd:orthogonal} only){p_end}
{synopt:{opt entr:opy}}minimum entropy ({cmd:orthogonal} only){p_end}
{synopt:{opt tandem1}}Comrey's tandem 1 principle ({cmd:orthogonal} only){p_end}
{synopt:{opt tandem2}}Comrey's tandem 2 principle ({cmd:orthogonal} only){p_end}

{p2coldent:* {cmdab:p:romax}[{cmd:(}{it:#}{cmd:)}]}promax power {it:#} (implies
	{cmd:oblique}); default is {cmd:promax(3)}{p_end}

{synopt:{cmdab:oblimi:n}[{cmd:(}{it:#}{cmd:)}]}oblimin with gamma={it:#};
	default is {cmd:oblimin(0)}{p_end}
{synopt:{opt cf(#)}}Crawford-Ferguson family with kappa={it:#},
	0<={it:#}<=1{p_end}
{synopt:{opt ben:tler}}Bentler's invariant pattern simplicity{p_end}
{synopt:{opt oblima:x}}oblimax{p_end}
{synopt:{opt quartimi:n}}quartimin{p_end}
{synopt:{opt tar:get(Tg)}}rotate toward matrix {it:Tg}{p_end}
{synopt:{opt partial(Tg W)}}rotate toward matrix {it:Tg}, weighted by
	matrix {it:W}{p_end}
{synoptline}
{p 4 6 2}
* {opt varimax} and {opt promax} ignore all {it:optimize_options}.
{p_end}
