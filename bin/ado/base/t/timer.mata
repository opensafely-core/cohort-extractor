*! version 1.0.0  24may2006
version 9.2

/*
	void timer([real t], [string scalar txt])
		arguments may be specified in either order
*/

local MAXTIMERS	100
mata:

void timer(|first, second)
{
	if (args()==0) 			   timer_report_u("", .)
	else if (args()==1) {
		if (eltype(first)=="real") timer_report_u("", first)
		else			   timer_report_u(first, .)
	}
	else {
		if (eltype(first)=="real") timer_report_u(second, first)
		else			   timer_report_u(first, second)
	}
}

/*static*/ void timer_report_u(string scalar comment, real vector timer)
{
	real scalar	i, i0, i1

	printf("\n")
	printf("{txt}{hline}\n")
	printf("{res}timer report")
	if (comment!="") printf(" -- %s\n", comment)
	else printf("\n") 

	if (rows(timer)==1 & cols(timer)==1 & timer[1]>=.) {
		for (i=1; i<=`MAXTIMERS'; i++) {
			if (timer_value(i)[2]) timer_report_u2(i)
		}
	}
	else if (rows(timer)==1) {
		for (i=1; i<=cols(timer); i++) timer_report_u2(i)
	}
	else {
		i0 = timer[1]
		if (i0<1) i0 = 1
		else if (i0>`MAXTIMERS') i0=`MAXTIMERS'

		i1 = timer[2]
		if (i1<1) i1 = 1
		else if (i1>`MAXTIMERS') i1=`MAXTIMERS'

		if (i1<i0) swap(i0, i1)

		for (i=i0; i<=i1; i++) {
			if (timer_value(i)[2]) timer_report_u2(i)
		}
	}
	printf("{txt}{hline}\n")
}

/*static*/ void timer_report_u2(real scalar i)
{
	real rowvector	t

	t = timer_value(i)
	printf("{txt}%3.0f.  %9.3g /%9.0g = {res:%9.0g}\n",
						i, t[1], t[2], t[1]/t[2])
}

end
