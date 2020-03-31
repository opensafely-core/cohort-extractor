{smcl}
{* *! version 1.0.0  16mar2017}{...}
{pstd}
The interval time variables should have the following
form:

         Type of data{space 24}lower{space 5}upper
	 {space 35}endpoint{space 2}endpoint
         {hline 53}
         uncensored data{space 9}{it:a} = [{it:a},{it:a}]{space 5}{it:a}{space 9}{it:a}
         interval-censored data{space 6}({it:a},{it:b}]{space 5}{it:a}{space 9}{it:b}
         left-censored data{space 10}(0,{it:b}]{space 5}{cmd:.}{space 9}{it:b}
         left-censored data{space 10}(0,{it:b}]{space 5}0{space 9}{it:b}
         right-censored data{space 6}[{it:a},+inf){space 5}{it:a}{space 9}{cmd:.}
         missing{space 31}{cmd:.}{space 9}{cmd:.}
         missing{space 31}0{space 9}{cmd:.}
         {hline 53}

