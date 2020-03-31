{* *! version 1.0.1  14jun2019}{...}
{marker frval()}{...}
    {cmd:frval(}{it:lvar}{cmd:,}{it:var}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}returns values of variables stored in other frames

{p2col:}The frame functions {cmd:frval()} and
		{helpb f_frval##_frval():_frval()} 
                  access values of variables in frames outside the current
                  frame. If you do not know what a frame is, see
                  {helpb frames intro:[D] frames intro}.

{p2col:}The two functions do the same thing, but {cmd:frval()}
                  is easier to use, and it is safer. {cmd:_frval()} is a
                  programmer's function.

{p2col:}{it:lvar} is the name of a variable created by {helpb frlink} that
		links the current frame to another frame.

{p2col:}{it:var} is the name of a variable in the other frame.

{p2col:}Returned is the value of {it:var} from the observation in
		  the other frame that matches the observation in the
		  current frame.

{p2col:Example 1:}The current frame contains data on persons.
		  Among the variables in the current frame is {cmd:countyid}
		  containing the county in which each person lives.

{p2col:}Frame {cmd:frcounty} contains data on counties.  In these
		  data, variable {cmd:countyid} also records the county's
		  ID, and the other variables record county
		  characteristics.

{p2col:}In the current frame, you have previously created variable
		  {cmd:linkcnty} that links the current frame to
	          {cmd:frcounty}.  You did this by typing

{p2col:}{cmd:. frlink m:1 countyid, frame(frcounty) generate(linkcnty)}

{p2col:}Thus, you can now type

{p2col:}{cmd:. generate rel_income = income / frval(linkcnty, median_income)}

{p2col:}{cmd:income} is an existing variable in the current frame.
		{cmd:median_income} is an existing variable in {cmd:frcounty}.
		{cmd:rel_income} will be a new variable in the current frame,
		containing the income of each person divided by the median
		income of the county in which they live.

{p2col:Example 2:}It is usual to name frames after dataset names and to name
		  link variables after frame names.  Here is an example of
		  this, following the names used above:

{p2col:}{cmd:. use persons, clear}{break}
	{cmd:. frame create county}{break}
	{cmd:. frame county: use county}{break}
	{cmd:. frlink m:1 countyid, frame(county)}{break}
	{cmd:. generate rel_income = income / frval(county, median_income)}

{p2col: Domain {it:lvar}:}the name of a variable created by
        {helpb frlink} that links the current frame to another frame

{p2col: Domain {it:var}:}any variable (string or numeric) in the frame to
	       which {it:lvar} links; varname abbreviation is
	       allowed{p_end}

{p2col: Range:}range of {it:var}, plus missing value
               (missing value is defined as {cmd:.} when {it:var} 
               contains numeric data and {cmd:""} when {it:var} 
               contains string data; 
               missing value is returned for observations in the
               current frame that are unmatched in the other frame){p_end}
{p2colreset}{...}

    {cmd:frval(}{it:lvar}{cmd:,}{it:var}{cmd:,}{it:unm}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {helpb f_frval##frval():frval()} function described
	above but with a third argument {it:umn}

{p2col:}{cmd:frval()} returns the value of {it:var} from the 
		  observation in the frame linked using {it:lvar} that 
		  matches the observation in the current frame and the value 
		  in {it:unm} if there is no matching observation.

{p2col:}For example, type 

{p2col:} {cmd:. generate median_inc = frval(county, median_income, .a)}

{p2col:}to create new variable {cmd:median_inc} in the current 
        frame, containing {cmd:median_income} from the other frame, 
        or {cmd:.a} when there is no matched observation in the 
        other frame.

{p2col: Domain {it:lvar}:}the name of a variable created by
        {helpb frlink} that links the current frame to another frame

{p2col: Domain {it:var}:}any variable (string or numeric) in the frame to
	       which {it:lvar} links; varname abbreviation is
	       allowed{p_end}

{p2col:Domain {it:unm}:}any numeric value if {it:var} is numeric;
        any string value when {it:var} is string

{p2col: Range:}range of {it:var}, plus {it:unm}{p_end}
{p2colreset}{...}

{marker _frval()}{...}
    {cmd:_frval(}{it:frm}{cmd:,}{it:var}{cmd:,}{it:i}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}programmer's version of
	{helpb f_frval##frval():frval()}

{p2col:}It is useful for those wishing to write their own {helpb frlink} and
		create special (or at least different) effects.

{p2col:}{cmd:_frval()} returns values of variables stored in other
		  frames.  It returns {it:var}'s 
		  {it:i}th observation
		  ({it:var}[{it:i}]) from the frame {it:frm}; 
                  see {helpb frames intro:[D] frames intro}.

{p2col:}If {it:i} is outside the valid range of observations for the
        frame, {cmd:_frval()} returns missing. 

{p2col:}For example, you have two datasets in memory. 
        The current frame is named {cmd:default}
        and contains 57 observations.  The other dataset, we will assume, 
        is stored in frame {cmd:xdata}. 
        It contains different variables but on the same 57
        observations.  The two datasets are in the same order so that
        observation 1 in {cmd:default} corresponds to observation 1
        in {cmd:xdata}, observation 2 to observation 2, and so on.
        You can type
        {p_end}

{p2col:}{cmd:. generate hrlywage = income / _frval(xdata, hrswrked, _n)}
       {p_end}

{p2col:}This will divide values of {cmd:income} stored in {cmd:default} by
        values of {cmd:hrswrked} stored in {cmd:xdata}.

{p2col:}The first thing to notice is that {cmd:_frval()}'s first two arguments 
        are not expressions.  You just type the name of the frame and 
        the name of the variable
        without embedding them in quotes.  We specified {cmd:xdata} 
        for the frame name and
        and {cmd:hrswrked} for the variable name.  
        {p_end}

{p2col:}The second thing to notice is that the 
        third argument is an expression.  To
        emphasize that, let's change the example.  Assume that
        {cmd:xdata} contains 58 instead of 57 observations.  Assume
        that observation 1 in {cmd:default} corresponds to observation
        2 in {cmd:xdata}, observation 2 corresponds to observation 3,
        and so on.  There is no observation in {cmd:default} that 
        corresponds to observation 1 in {cmd:xdata}.  
        In this case, you type
        {p_end}

{p2col:}{cmd:. generate hrlywage = income / _frval(xdata, hrswrked, _n+1)}
        {p_end}

{p2col:}These examples are artificial.  You will normally use 
        {cmd:_frval()} by creating a variable 
        in {cmd:default} that contains the corresponding 
        observation
        numbers in {cmd:xdata}.  If the variable were called {cmd:xobsno}, 
        then in the first example, {cmd:xobsno}
        would contain 1, 2, ..., 57.
        {p_end}

{p2col:}In the second example, {cmd:xobsno} would contain 2, 3, ..., 58.
        {p_end}

{p2col:}In another example, {cmd:xobsno} might contain 9, 6, ...,
        32, which is to say, the numbers 2, 3, ..., 58, but permuted to
        reflect the datasets' jumbled order.
{p_end}

{p2col:}In yet another example, {cmd:xobsno} might contain 9, 6, 9, ...,
        32, which is to say, observation 1 and 3 in {cmd:default} 
        both correspond to observation 9 in {cmd:xdata}.  {cmd:xdata}
        in this example might record geographic location and 
        in {cmd:default}, persons in observations 1 and 3 live in the 
        same locale. 

{p2col:}And in a final example, {cmd:xobsno} 
        might contain all the above and missing values ({cmd:.}).
        The missing values would indicate observations in {cmd:default}
        that have no corresponding observation in {cmd:xdata}.  If
        observations 7 and 11 contained missing, that means there
        would be no observations in {cmd:xdata} corresponding to
        observations 7 and 11 in {cmd:default}.
        ({cmd:_frval()} has a second syntax that allows you to specify
        the value returned when there are no corresponding observations;
        see below.)
        {p_end}

{p2col:}Regardless of the complexity of the example, 
        the value of {cmd:xobsno} in observation {it:j} is the
        corresponding observation number {it:i} in {cmd:xdata}.
        Regardless of complexity, to create new 
        variable {cmd:hrlywage} in {cmd:default},
        you would type{p_end}

{p2col:}{cmd:. generate hrlywage = income / _frval(xdata, hrswrked, xobsno)}
        {p_end}

{p2col:}That leaves only the question of how to generate {cmd:xobsno} in all 
        the above situations, and it is easy to do. 
        See {helpb frlink:[D] frlink}.
        {p_end}

{p2col:}There are two more things to know.
        {p_end}

{p2col:}First, variables across frames are distinct.  If the variable we
        have been calling {cmd:income} in {cmd:default} were named
        {cmd:x}, and the variable {cmd:hrswrked} in {cmd:xdata} were
        also named {cmd:x}, you would type {p_end}

{p2col:}{cmd:. generate hrlywage = x / _frval(xdata, x, xobsno)} {p_end}

{p2col:}Second, although we have demonstrated the use of {cmd:_frval()}
        with numeric variables, it works with string variables too. 
        If {it:var} is a string variable name, {cmd:_frval()} 
        returns a string result. 

{p2col: Domain {it:frm}:}any existing framename

{p2col: Domain {it:var}:}any existing variable name in {it:frm};
	       varname abbreviation is allowed{p_end}

{p2col: Domain {it:i}:}any numeric values including missing values even 
                       though the 
                       nonmissing values should be integers in the range 1 to 
                       {it:frm}'s {cmd:_N};
                       nonintegers will be interpreted as the corresponding 
                       integer obtained by truncation, and values outside
                       the range will be treated as if they were missing
                       value

{p2col: Range:}range of {it:var} in {it:frm} plus missing value;
               numeric missing value ({cmd:.}) when {it:var} is numeric,
	       and string missing value ({cmd:""}) when {it:var} is string
	       {p_end}

{p2colreset}{...}
    {cmd:_frval(}{it:frm}{cmd:,}{it:var}{cmd:,}{it:i}{cmd:,}{it:v}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {helpb f_frval##_frval():_frval()} function described
	above but with a fourth argument {it:v}

{p2col:}{cmd:_frval()} returns values of variables stored in other frames.  It
		returns {it:var}'s {it:i}th observation ({it:var}[{it:i}])
		from the frame {it:frm}.

{p2col:}When {it:v} is specified, {cmd:_frval()} returns {it:v} if
		{it:var}[{it:i}] is missing or if  {it:i} is outside the valid
		range of observations.

{p2col:}{cmd:. generate hwage = income / _frval(xdata, hrswrked, xobsno, .z)}
        {p_end}

{p2col:}{cmd:. generate hwage = income / _frval(xdata, hrswrked, xobsno, avg)}
        {p_end}

{p2col:}In the first case, {cmd:.z} is returned for observations 
in which {cmd:xobsno} contains values that are out of range.
In the second case, the value recorded in variable {cmd:avg} is returned. 
{p_end}

{p2col: Domain {it:frm}:}any existing framename
{p_end}

{p2col: Domain {it:var}:}any existing variable name in {it:frm};
	       varname abbreviation is allowed{p_end}

{p2col: Domain {it:i}:}any numeric values including missing values even 
                       though the 
                       nonmissing values should be integers in the range 1 to 
                       {it:frm}'s {cmd:_N};
                       nonintegers will be interpreted as the corresponding 
                       integer obtained by truncation, and values outside
                       the range will be treated as if they were missing
                       value

{p2col: Domain {it:v}:}any numeric value when {it:var} is numeric;
                       any string value when {it:var} is string 
                       (can be a constant or vary observation by observation)

{p2col: Range:}range of {it:var} in {it:frm} plus {it:v}{p_end}
{p2colreset}{...}
