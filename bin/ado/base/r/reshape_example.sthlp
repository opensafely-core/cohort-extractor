{smcl}
{* *! version 1.0.3  11feb2011}{...}
{* this hlp file called by reshape.dlg}{...}
{vieweralsosee "[D] reshape" "help reshape"}{...}
{title:Long format}	id   year   sex    inc   ue
		{hline 27}
		 1     80     0   5000    0
		 1     81     0   5500    1
		 1     82     0   6000    0
		 2     80     1   2000    1
		 2     81     1   2200    0
		 2     82     1   3300    0
		 3     80     0   3000    0
		 3     81     0   2000    0
		 3     82     0   1000    1


{title:Wide format}	id  sex   inc80  inc81  inc82  ue80  ue81  ue82
		{hline 47}
		 1    0    5000   5500   6000     0     1     0
		 2    1    2000   2200   3300     1     0     0
		 3    0    3000   2000   1000     0     0     1


{c TLC}{hline 53}{c TT}{hline 8}{c TRC}
{c |} Variable edit field                                 {c |} Value  {c |}
{c LT}{hline 53}{c +}{hline 8}{c RT}
{c |} ID variable(s) - the i() option                     {c |} {bf:id}     {c |}
{c |} Subobservation identifier variable - the j() option {c |} {bf:year}   {c |}
{c |} Variables that differ on subobservations            {c |} {bf:inc ue} {c |}
{c BLC}{hline 53}{c BT}{hline 8}{c BRC}
