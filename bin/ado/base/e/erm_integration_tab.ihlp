{* *! version 1.0.1  15mar2019}{...}
{synopt :{opt intp:oints(#)}}set the number of integration (quadrature) 
    points for integration over four or more dimensions; default
    is {cmd:intpoints(128)}{p_end}
{synopt :{opt triint:points(#)}}set the number of integration (quadrature) 
    points for integration over three dimensions; default is
    {cmd:triintpoints(10)}{p_end}
{synopt :{opt reintp:oints(#)}}set the number of integration (quadrature)
    points for random-effects integration; default is {cmd:reintpoints(7)}
    {p_end}
{synopt :{opt reintm:ethod(intmethod)}}integration method for random effects;
   {it:intmethod} may be {cmdab:mv:aghermite} (the default) or
   {cmdab:gh:ermite}{p_end}
