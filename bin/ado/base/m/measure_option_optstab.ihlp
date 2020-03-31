{* *! version 1.0.6  29jul2015}{...}
{p2colset 5 23 27 2}{...}
{p2col:{it:measure}}Description{p_end}
{p2line}
{p2col:{it:{help measure_option##cont_measure:cont_measure}}}similarity or
	dissimilarity measure for continuous data{p_end}
{p2col:{it:{help measure_option##binary_measure:binary_measure}}}similarity
	measure for binary data{p_end}
{p2col:{it:{help measure_option##mixed_measure:mixed_measure}}}dissimilarity
	measure for a mix of binary and continuous data{p_end}
{p2line}

{p2col:{marker cont_measure}{it:cont_measure}}Description{p_end}
{p2line}
{p2col:{opt L2}}Euclidean distance (Minkowski with argument 2){p_end}
{p2col 7 25 29 2:{opt Euc:lidean}}alias for {opt L2}{p_end}
{p2col 7 25 29 2:{cmd:L(2)}}alias for {opt L2}{p_end}
{p2col:{opt L2squared}}squared Euclidean distance{p_end}
{p2col 7 25 29 2:{cmd:Lpower(2)}}alias for {opt L2squared}{p_end}
{p2col:{opt L1}}absolute-value distance (Minkowski with argument 1){p_end}
{p2col 7 25 29 2:{opt abs:olute}}alias for {opt L1}{p_end}
{p2col 7 25 29 2:{opt cityb:lock}}alias for {opt L1}{p_end}
{p2col 7 25 29 2:{opt manhat:tan}}alias for {opt L1}{p_end}
{p2col 7 25 29 2:{cmd:L(1)}}alias for {opt L1}{p_end}
{p2col 7 25 29 2:{cmd:Lpower(1)}}alias for {opt L1}{p_end}
{p2col:{opt Linf:inity}}maximum-value distance (Minkowski with infinite
				argument){p_end}
{p2col 7 25 29 2:{opt max:imum}}alias for {opt Linfinity}{p_end}
{p2col:{opt L(#)}}Minkowski distance with {it:#} argument{p_end}
{p2col:{opt Lpow:er(#)}}Minkowski distance with {it:#} argument raised to {it:#}
				power{p_end}
{p2col:{opt Canb:erra}}Canberra distance{p_end}
{p2col:{opt corr:elation}}correlation coefficient similarity measure{p_end}
{p2col:{opt ang:ular}}angular separation similarity measure{p_end}
{p2col 7 25 29 2:{opt ang:le}}alias for {opt angular}{p_end}
{p2line}

{p2col:{marker binary_measure}{it:binary_measure}}Description{p_end}
{p2line}
{p2col:{opt match:ing}}simple matching similarity coefficient{p_end}
{p2col:{opt Jac:card}}Jaccard binary similarity coefficient{p_end}
{p2col:{opt Russ:ell}}Russell and Rao similarity coefficient{p_end}
{p2col:{opt Hamann}}Hamann similarity coefficient{p_end}
{p2col:{opt Dice}}Dice similarity coefficient{p_end}
{p2col:{opt antiDice}}anti-Dice similarity coefficient{p_end}
{p2col:{opt Sneath}}Sneath and Sokal similarity coefficient{p_end}
{p2col:{opt Rogers}}Rogers and Tanimoto similarity coefficient{p_end}
{p2col:{opt Ochiai}}Ochiai similarity coefficient{p_end}
{p2col:{opt Yule}}Yule similarity coefficient{p_end}
{p2col:{opt Ander:berg}}Anderberg similarity coefficient{p_end}
{p2col:{opt Kulc:zynski}}Kulczyński similarity coefficient{p_end}
{p2col:{opt Pearson}}Pearson's phi similarity coefficient{p_end}
{p2col:{opt Gower2}}similarity coefficient with same denominator as
	{opt Pearson}{p_end}
{p2line}

{p2col:{marker mixed_measure}{it:mixed_measure}}Description{p_end}
{p2line}
{p2col:{opt Gower}}Gower's dissimilarity coefficient{p_end}
{p2line}
{p2colreset}{...}
