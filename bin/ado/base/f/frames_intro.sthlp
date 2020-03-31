{smcl}
{* *! version 1.0.0  14jun2019}{...}
{vieweralsosee "[D] frames intro" "mansection D framesintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames" "help frames"}{...}
{vieweralsosee "[D] frlink" "help frlink"}{...}
{vieweralsosee "[D] frget"  "help frget"}{...}
{vieweralsosee "[FN] Programming functions" "help f_frval"}{...}
{vieweralsosee "[M-5] st_frame*()" "help mf_st_frame"}{...}
{viewerjumpto "Description" "frames_intro##description"}{...}
{viewerjumpto "Remarks" "frames_intro##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] frames intro} {hline 2}}Introduction to frames{p_end}
{p2col:}({mansection D framesintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Frames, also known as data frames, allow you to simultaneously store
multiple datasets in memory.  The datasets in memory are stored in
frames, and Stata allows multiple frames.  You can switch
between them and even link data in them to data in other frames.  How
this works is presented below.


{marker remarks}{...}
{title:Remarks}

{pstd}
    Remarks are presented under the headings 

        {help frames_intro##why:What frames can do for you}
	    {help frames_intro##multitask:Use frames to multitask}
	    {help frames_intro##integral:Use frames to perform tasks integral to your work}
	    {help frames_intro##link:Use frames to work with separate datasets simultaneously}
	    {help frames_intro##post:Use frames to record statistics gathered from simulations}
	    {help frames_intro##preserve:Frames make Stata (preserve/restore) faster}
	    {help frames_intro##other:Other uses will occur to you that we should have listed}

        {help frames_intro##learning:Learning frames}
            {help frames_intro##currentframe:The current frame}
            {help frames_intro##creation:Creating new frames}
	    {help frames_intro##plural:Type frame or frames, it does not matter}
            {help frames_intro##switching:Switching frames}
	    {help frames_intro##copying:Copying frames}
	    {help frames_intro##dropping:Dropping frames}
	    {help frames_intro##reset:Resetting frames}
            {help frames_intro##frameprefix:Frame prefix command} 
	    {help frames_intro##linking:Linking frames}
	    {help frames_intro##_frval:Ignore the _frval() function}
	    {help frames_intro##posting:Posting new observation to frame}

        {help frames_intro##programming:Programming with frames}
	    {help frames_intro##ado:Ado programming with frames}
	    {help frames_intro##mata:Mata programming with frames}


{marker why}{...}
{title:What frames can do for you}

{pstd}
    Frames let you have multiple datasets in memory simultaneously.
    Here are a few ways you can use them.


{marker multitask}{...}
{ul:Use frames to multitask}

{pstd}
    You can create a new frame, load another dataset into it, perform
    some task, switch back, and discard the frame.

{pstd}
    You are working.  The phone rings.  Something has to be handled
    right now.

{col 9}{cmd:. frame create interruption}         // you create new frame ...
{col 9}{cmd:. frame change interruption}         // and switch to it

{col 9}{cmd:. use} {it:another_dataset}               // you load a dataset
{col 9}{cmd:.}                                   // you do what needs doing
{col 9}{cmd:.}
{col 9}{cmd:. frame change default}              // you switch back
{col 9}{cmd:. frame drop interruption}           // you delete the new frame

{pstd}
You are back to work just as if you had never been interrupted. 


{marker integral}{...}
{ul:Use frames to perform tasks integral to your work}

{pstd}
    You need to calculate a value from the data and add it to the
    data.  This is troublesome because making the
    calculation requires modifying the data, the same data that needs 
    to be unmodified and have the result added to it. 

{pstd}
    You have loaded {cmd:yourdata.dta} into memory and have already 
    made some updates to it.  You have not yet saved those changes. 
    You set about calculating the troublesome value.

{col 9}{cmd:. frame copy default subtask}        // create & copy current data to
                                            //    new frame
{col 9}{cmd:. frame change subtask}              // switch to the new frame

{col 9}{cmd:. sort weight foreign}               // begin result calculation
{col 9}{cmd:.} {it:omitted steps}
{col 9}{cmd:. keep if mark1 | mark2}             {red:// drop observations!}
{col 9}{cmd:.} {it:omitted steps}
{col 9}{cmd:. regress dmpg dw if mod(_n,2)}      // calculate troublesome value

{col 9}{cmd:. frame change default}              // switch back to previous frame
{col 9}{cmd:. gen dwc = cond(foreign,_b[dw],0)}  // save result in yourdata.dta
{col 9}{cmd:. frame drop subtask}                // drop new frame

{pstd}
    You could have used {cmd:preserve} and {cmd:restore} to perform this task.
    Using frames, however, is usually more convenient, if for no other
    reason than you can switch back and forth between them.  You cannot
    do that with a preserved dataset and the modified copy in memory.

{pstd}
    If you look carefully at the code above, you will notice that 
    the troublesome value we needed to calculate and store was {cmd:_b[dw]}. 
    {cmd:_b[dw]} was calculated from data in frame {cmd:subtask} and stored in
    Stata for subsequent use no matter which frame is current.

{pstd}
    It is dataset values that are stored in frames.
    Programmatic values such as {cmd:_b[]}, {cmd:r()}, {cmd:e()}, and 
    {cmd:s()} are stored in Stata and available across frames. 
    
   
{marker link}{...}
{ul:Use frames to work with separate datasets simultaneously}

{pstd}
    When we say working with datasets simultaneously, we mean datasets
    that are linked.  Linked datasets are an alternative to merged
    datasets.

{pstd}
    You have two datasets.  {cmd:persons.dta} contains data on people.
    {cmd:uscounties.dta} contains data on counties.
    You want to analyze the people in {cmd:persons.dta} and the
    counties in which they live.  There are issues in combining the two
    datasets:  

{p 8 12 2}
    1.  Some of the people in {cmd:persons.dta} live in the same
        county.  

{p 8 12 2}
    2.  There are counties in {cmd:uscounties.dta} that are irrelevant
        to your analysis because nobody in {cmd:persons.dta} lives in them.

{p 8 12 2}
    3.  You are not certain that {cmd:uscounties.dta} is complete.  There
        might be some people in {cmd:persons.dta} that live in counties
        not recorded in {cmd:uscounties.dta}.

{p 8 12 2}
    4.  And beyond that, only some of the variables in {cmd:uscounties.dta}
        are needed for your analysis.

{pstd}
    The frames solution to all of these problems is to link the
    two datasets.  You start by loading {cmd:persons.dta} into one
    frame and {cmd:uscounties.dta} into another:

{col 9}{cmd:. use persons}
{col 9}{cmd:. frame create counties}
{col 9}{cmd:. frame counties: use counties}

{pstd}
    To link the datasets in the two frames, you type 

{col 9}{cmd:. frlink m:1 countyid, frame(uscounties)}

{pstd}
    This matches the observations in {cmd:persons.dta} to those in
    {cmd:uscounties.dta} based on equal values of variable
    {cmd:countyid}.  The data are not merged, they are linked.  No
    variables from {cmd:uscounties.dta} are copied to
    {cmd:persons.dta}, but how the variables would be copied has been
    worked out.

{pstd} 
    You copy variables to the person data as you need them, one at a
    time, or in groups, using the {cmd:frget} command: 

{col 9}{cmd:. frget med_income nschools, from(uscounties)}

{pstd}
    You can perform the desired analysis using {cmd:persons.dta}, 
    the dataset in the current frame:

{col 9}{cmd:. regress income med_income n_schools educ age}


{marker post}{...}
{ul:Use frames to record statistics gathered from simulations}

{pstd}
    Simulations involve repeating a task -- performing a simulation
    -- each step of which produces statistics that are somehow recorded.
    After that, you analyze the recorded statistics.  

{pstd}
    The frames solution to the simulation problem is to collect the
    statistics in another frame.  We will name that frame
    {cmd:results}.  You start by creating a new frame and 
    the variables in it to record the statistics, such as
    {cmd:b1coverage} and {cmd:b2coverage}:

                      {it:new frame's}
                      {it:name}
                        \
         {cmd:. frame create results b1coverage b2coverage}
                                {hline 21} 
                                     /
                          {it:new variables in it}

{pstd}
    The new frame contains zero observations at this point. 

{pstd}
    You will next write a do-file to create the values to be stored
    after each iteration.  At the end of each iteration, the do-file 
    will contain the line 

                   {it:frame's name}
                      \
         {cmd:. frame post results (}{it:exp}₁{cmd:) (}{it:exp}₂{cmd:)}
                              {hline 13}
                                  /
                              {it:values for}
                         {cmd:b1coverage} and {cmd:b2coverage}

{pstd}
    {cmd:frame} {cmd:post} adds an observation to the data in {cmd:results}.
    {it:exp}₁ and {it:exp}₂ are expressions.

{pstd}
    When the do-file finishes, the completed set of results will be found 
    in frame {cmd:results}.  You will want to save them: 

{col 9}{cmd:. frame results: save} {it:filename}

{pstd}
    You will then switch to the frame and begin your analysis of the 
    statistics:

{col 9}{cmd:. frame change results}
{col 9}{cmd:. summarize}


{marker preserve}{...}
{ul:Frames make Stata (preserve/restore) faster}

{pstd}
    Many programs written in Stata use the commands 
    {helpb preserve} and {helpb preserve:restore}
    to temporarily save and later restore the contents of the data in
    memory.  Programs that use {cmd:preserve} and {cmd:restore} now run
    faster if you are using Stata/SE or Stata/MP.  They run faster because
    Stata preserves data by copying them to hidden frames.  Those hidden
    frames are stored in memory.  Copying data to frames stored in memory
    takes a lot less time than copying data to disk.

{pstd}
    More correctly, {cmd:preserve} copies data to hidden frames unless
    memory is in short supply.  If it is, {cmd:preserve} resorts to
    storing them on disk.  That is temporary because later, as
    datasets are restored, memory will again become available and
    {cmd:preserve} will return to preserving them in hidden frames.

{pstd}
    This is all automatic, but you may want to reset the value of
    {cmd:max_preservemem}, which controls this behavior.  When the amount
    stored in hidden frames would exceed {cmd:max_preservemem}, Stata
    preserves subsequent datasets on disk.
    Out of the box, {cmd:max_preservemem} is set to 1 gigabyte. 
    Perhaps you or someone else has already changed 
    that.  To find out the current value of {cmd:max_preservemem}, type 

{col 9}{cmd:. query memory}

{pstd}
    If you want to change {cmd:max_preservemem} to 2 gigabytes
    for the duration of the session, type 

{col 9}{cmd:. set max_preservemem 2g}

{pstd}
    You can set the value up or down.  You could set it to {cmd:4g} or
    {cmd:50m}.  You could even set it to {cmd:0}, and then all datasets
    would be preserved to disk.

{pstd}
    If you want to set {cmd:max_preservemem} to 2 gigabytes permanently, 
    for this session and future Stata sessions, type

{col 9}{cmd:. set max_preservemem 2g, permanently}

     
{marker other}{...}
{ul:Other uses will occur to you that we should have listed}

{pstd}
    Frames make doing lots of tasks more convenient, and you will find 
    your own uses for them.  Frames make code faster too.  
    Manipulating objects stored in memory takes less computer time 
    than manipulating disk files. 


{marker learning}{...}
{title:Learning frames}

{pstd}
    Here is a tutorial on using frames.  In the tutorial, we will sometimes
    show you a syntax diagram.  For example, we might show you

{p 8 12 16}
{bf:{help frame_copy:frame copy}} {it:framename} {it:newframename}

{pstd}
    When we show syntax diagrams in the tutorial, they are not always
    the full syntax diagrams.  {cmd:frame} {cmd:copy}, for instance,
    also allows a {cmd:replace} option, and we might not only not show
    it in the syntax diagram but also not even mention it.  You can
    click on the command to see the full syntax.


{marker currentframe}{...}
{ul:The current frame}

{pstd}
    Everything hinges on the {it:current frame}.  
    Stata commands use the data in the current frame.  When you load 
    a dataset,

{col 9}{cmd:. sysuse auto}

{pstd}
    you are loading it into the current frame.  Which frame is that?  Type
    {cmd:frame} to discover its identity:

{col 9}{cmd:. frame}

{pstd}
    You can type {helpb frame} or type {cmd:pwf}, which is a synonym
    for {cmd:frame}.  The letters stand for "print working frame".
    We will type {cmd:frame} in this tutorial, but you may prefer to
    type {cmd:pwf} because it is shorter.  Other {cmd:frame} commands
    also have shorter synonyms.  We will mention them as we go along.

{pstd}
    We just discovered that the current frame is named {cmd:default}. 
    When Stata is launched, that is what it names the frame it creates
    for you.  You cannot change that, but {cmd:default} is just a name,
    and you can rename frames if you wish.  You can create other frames
    too.  You can create up to 100 of them.

{pstd}
    To rename a frame, use the {cmd:frame} {cmd:rename} command: 

{p 12 12 2}
{bf:{help frame_rename:frame rename}} {it:oldname} {it:newname}

{pstd}
To rename the frame {cmd:default} to {cmd:genesis}, type

{col 9}{cmd:. frame rename default genesis}
{col 9}{cmd:. frame}

{pstd}
    Frames can be renamed whether Stata created them or you did.  They
    can be renamed whether they have data in them or they are empty.
    Renaming {cmd:default} will not break anything subsequently.  Stata
    commands operate on the current frame, whatever its name.


{marker creation}{...}
{ul:Creating new frames}

{pstd}
    Create new frames using the {cmd:frame} {cmd:create} command:

{p 12 12 2} 
{bf:{help frame_post:frame create}} {it:newframename}

{pstd}
    We will show you an example in a minute.  First, however, if you
    are going to create a frame with a new name, you need to know how
    to find out the names of the frames that currently exist.  You do
    that using the {cmd:frames} {cmd:dir} command:

{p 12 12 2} 
{bf:{help frames_dir:frames dir}}

{pstd}
    We recall that we renamed our default frame, but we cannot recall
    the name that we used.  So what frames are in memory?

{col 9}{cmd:. frames dir}

{pstd}
    There is one frame in memory, named {cmd:genesis}.  It
    contains a dataset that is 74 x 12, meaning 74
    observations and 12 variables.  The dataset has a 
    {help label:dataset label} "1978 Automobile Data", but if it
    did not, the dataset's name, {cmd:auto.dta}, would have appeared in its
    place in {cmd:frames} {cmd:dir}'s output, unless the data had never been
    saved to disk.  In that case, nothing would have appeared where ``1978
    Automobile Data'' appeared.

{pstd}
    Now let's create a new frame named {cmd:second}:

{col 9}{cmd:. frame create second}
{col 9}{cmd:. frame dir}

{pstd}
    There are now two frames in memory.  The new frame is 0 x 0.
    It is empty.

{pstd}
    By the way, {cmd:frame} {cmd:create} has a shorter synonym, {cmd:mkf}.
    The letters stand for "make frame".  We could have typed 
    {cmd:mkf} {cmd:second} to make the new frame. 
   

{marker plural}{...}
{ul:Type frame or frames, it does not matter}

{pstd}
    You probably did not notice, but we have used {cmd:frames} {cmd:dir} 
    twice so far, but we typed it differently the second time.  We typed 

{p 12 12 2}
{cmd:. frames dir}{break}
{cmd:. frame dir}

{pstd}
    Stata does not care whether you type {cmd:frame} or {cmd:frames}.
    This indifference applies to all the {cmd:frames}/{cmd:frame}
    commands.


{marker switching}{...}
{ul:Switching frames}

{pstd}
    {cmd:frame} {cmd:change} (synonym: {cmd:cwf} for "change working frame")
    switches the identity of the current frame:

{p 12 12 2}
{bf:{help frame_change:frame change}} {it:framename}

{pstd}
    We could make {cmd:second} the current frame and switch back to 
    {cmd:genesis} again: 

{col 9}{cmd:. frames change second}
{col 9}{cmd:. count}
{col 9}{cmd:. cwf genesis}
{col 9}{cmd:. count}

{pstd}
    We used Stata's {cmd:count} command to demonstrate that the
    current frame really switched.  {cmd:count} without arguments
    displays the number of observations.  


{marker copying}{...}
{ul:Copying frames}

{pstd}
    There are two commands for copying frames:

{p 8 12 16}
{bf:{help frame_copy:frame copy}} {it:framename} {it:newframename}

{col 9}{bf:{help frame_put:frame put}} {it:varlist}{cmd:, into(}{it:newframename}{cmd:)}
{col 9}{bf:{help frame_put:frame put}} {cmd:if} {it:exp}{cmd:,  into(}{it:newframename}{cmd:)}

{pstd}
    {cmd:frame copy} copies the entire dataset.

{pstd}
    {cmd:frame} {cmd:put} copies subsets of the dataset. 

{pstd}
    In either case, the commands create the frame being copied to. 


{marker dropping}{...}
{ul:Dropping frames}

{pstd}
To drop an existing frame, type 

{p 8 12 16}
{bf:{help frame_drop:frame drop}} {it:framename}


{marker reset}{...}
{ul:Resetting frames}

{pstd}
     Resetting frames means the following:

{p 8 12 2}
    1.  Drop all the data in all the frames, even if the data have 
        not been saved since they were last saved.

{p 8 12 2}
    2.  Drop (delete) all the frames.

{p 8 12 2}
    3.  Create a new frame named {cmd:default}, and make it the 
        current frame.

{pstd}
    Each of the following commands resets frames:
    
{col 9}{bf:{help frames_reset:frames reset}}
{col 9}{bf:{help frames_reset:clear frames}}

{col 9}{bf:{help clear:clear all}}

{pstd}
{cmd:frames reset} and {cmd:clear frames} are synonyms. 

{pstd}
{cmd:clear all} resets the frames and does more.  It returns Stata
to as close to just-after-launch status as possible.


{marker frameprefix}{...}
{ul:Frame prefix command}

{pstd}
The {cmd:frame} prefix command is perhaps the most convenient of the
{cmd:frame} commands.  Its syntax command is

{p 8 12 2}
{bf:{help frame_prefix:frame}}
{it:framename}{bf:{help frame_prefix::}} {it:stata_command}

{pstd}
The {cmd:frame} prefix command 1) changes the current frame to the 
frame specified, 2) executes {it:stata_command}, and 3) changes the current 
frame back to what it was.

{pstd}
For instance, say the current frame is {cmd:default} and we have 
a second frame named {cmd:second}.  We type 

{p 8 12 2}
{cmd:. frame second: sysuse census, clear}

{pstd}
The result would be that frame {cmd:second} would contain
{cmd:census.dta} and the current frame would still be 
{cmd:default}, just as if we had typed

{col 9}{cmd:. frame change second}
{col 9}{cmd:. sysuse census, clear}
{col 9}{cmd:. frame change default}

{pstd}
Frame prefix has a second feature too.  Imagine that in doing the
above, we omitted the {cmd:clear} option when we use the data.
Consider what would have happened if we set about typing the three
commands but the data in {cmd:second} had changed since they were last
saved:

{col 9}{cmd:. frame second}
{col 9}{cmd:. sysuse census}

{pstd}
What is the current frame?  It is {cmd:second}, of course, because we
changed to it.  Now consider making the same mistake using the
{cmd:frame} prefix approach:

{col 9}{cmd:. frame second: sysuse census}

{pstd}
Even though an error occurred, the current frame is still {cmd:default}!
To recover from the error, we do not have to change back to the original 
frame.  The {cmd:frame} prefix command did that for us. 

{pstd}
{cmd:frame} prefix has another syntax when you have more than one
command to be executed:

         {cmd:frame} {it:framename} {cmd:{c -(}}
                {it:stata_command}
                {it:stata_command}
                .
                .
         {cmd:{c )-}}

{pstd}
This syntax is especially useful in programs.


{marker linking}{...}
{ul:Linking frames}

{pstd}
    When we say linking, we mean linking as shown in the earlier 
    {help frames_intro##link:example} when we had separate datasets on
    people and counties and combined them in a merged-data kind of
    way.  Linking can do a lot more than we showed you. 

{pstd}
    In {manhelp frlink D}, we show you how to create a nested linkage to link
    students (one dataset) to the schools they attend (a second dataset) and
    to the counties (a third dataset) in which their schools are located.  We
    show you an example of linking a generational dataset with itself, so that
    adult children are linked to their parents and grandparents, a total of
    six simultaneous linkages!

{pstd}
    Linkages are created by using the {cmd:frlink} command.  Its simplest 
    syntaxes are

{p 8 8 2}
{helpb frlink} {cmd:m:1} {varlist}{cmd:,}
   {opt frame(framename)}

{p 8 8 2}
{helpb frlink} {cmd:1:1} {varlist}{cmd:,}
  {opt frame(framename)}

{pstd}
    These syntaxes create an {cmd:m:1} or {cmd:1:1} link between the current
    frame and {it:framename} based on observations having equal values of
    {it:varlist}.

{pstd}
    Once a link is created, you can use the {cmd:frget} command to copy
    the appropriate values of variables from {it:framename} to the
    current frame.  Its syntaxes are

{p 8 8 2}
{helpb frget} {varlist}{cmd:,}
    {opt from(linkagename)}

{p 8 8 2}
{helpb frget} {newvar} {cmd:=} {varname}{cmd:,}
    {opt from(linkagename)}

{pstd}
    You can use the {cmd:frval()} function in expressions to
    access appropriate observations of variables in the linked data.
    Its syntax is

{col 9}... {help frval():{bf:frval(}{it:linkagename}{bf:,}{it:varname}{bf:)}} ...


{marker _frval}{...}
{ul:Ignore the _frval() function}

{pstd}
    While we are on the subject of the {cmd:frval()} function, we
    should warn you.  Also available is {helpb f_frval##_frval():_frval()}.
    Ignore it.  {cmd:frval()}
    is better.  {cmd:_frval()} is for use by programmers.

    
{marker posting}{...}
{ul:Posting new observations to frames}

{pstd}
    We used posting to perform simulations in an 
    {help frames_intro##post:example} earlier.  That is one use of it.
    More generally, posting solves problems that require transferring
    data or values from one frame to a new observation in another.

{pstd}
    First, you prepare the other frame to receive the data. 
    {cmd:frame} {cmd:create}, which we
    {help frames_intro##creation:already discussed},
    has a syntax for doing this. 
    We showed you its first syntax, which is

{p 12 12 2}
{helpb frame create} {it:newframename}

{pstd}
   The second syntax is

{p 12 12 2} 
{bf:{help frame_post:frame create}} {it:newframename} {it:newvarlist}

{pstd}
    This syntax creates the new frame and creates in it a zero-observation
    dataset of the new variables specified.  {it:newvarlist} really is
    a new varlist, and that means that you can specify variables types
    and variable names.  You could type

{col 9}{cmd:. frame create results strL(rngstate) double(b1coverage b2coverage)}

{pstd}
    Alternatively, you can use {cmd:frame} {cmd:create}'s first syntax 
    to create the frame, use {cmd:frame} {cmd:change} to switch to it, 
    and create the zero-observation dataset yourself.  Then, you can switch
    back to what was the current frame. 

{pstd}
    {cmd:frame} {cmd:post} adds observations to the second frame.  Its 
    syntax is 

{p 12 12 2} 
{bf:{help frame_post:frame post}} 
{it:framename}
{cmd:(}{it:exp}{cmd:)}
{cmd:(}{it:exp}{cmd:)} ... {cmd:(}{it:exp}{cmd:)}

{pstd}
    The expressions are in the same order as the variables in the 
    second frame.



{marker programming}{...}
{title:Programming with frames}

{pstd}
    Below we discuss writing Stata programs that deal with multiple
    frames.

{pstd}
    If you are not interested in writing such programs, stop reading. 

{pstd}
    What follows is not a tutorial.  What follows are numbered lists
    detailing everything you need to know to write programs that use
    more than the current frame.  That program could implement a
    command that does something with frames specified by users.  Or
    it could do something that, as far as users are concerned, uses
    only the current frame and hidden from them is that your program
    uses frames to accomplish certain internal tasks.

{pstd}
    We also want to emphasize there still exists a place for 
    programs written in Stata that do not use frames at all. 
    Perhaps most programs are like that. 
    

{marker ado}{...}
{ul:Ado programming with frames}

{p 8 12 2}
     1.  {helpb macro:tempname}s.

{p 12 12 2}
         Frames with names created by {cmd:tempname} are 
         automatically dropped (deleted) when the program 
         generating the temporary name ends. 

{p 12 12 2}
	If the program you write is to create a new frame for the 
        user, give the frame a {cmd:tempname} in your program, and, 
        at the end, use {cmd:frame} {cmd:rename} to change its name.
        This way, if an error occurs, the frame the program may have
        been in the midst of creating will be dropped automatically.

{p 8 12 2}
     2.  Current frame.

{p 12 12 2}
         Stata provides the name of the current frame in 
         {helpb creturn:creturn}
         result {cmd:c(frame)}.  You can obtain the name of the current
         frame by coding 

{col 16}{cmd:local curframe = c(frame)}

{p 12 12 2}
         Programs that use frames invariably change frames during their
         execution.  Programs need to ensure the appropriate frame is
         the current one at the time the program exits.  This
         includes when the program is successful and when it exits with
         error.

{p 12 12 2}
         The successful case is easy enough to handle. 
         At the point your program exits, set the current frame
         appropriately.  In general, the current frame should be the
         same as the current frame was when the program started.

{p 12 12 2}
         Error cases can be more difficult.  Who knows when the 
         user will press break or when the bug buried in your code will
         bite?  The code could be doing literally anything.  
         Even so, your program needs to ensure that the current frame 
         is set appropriately.  There is a style of programming that
         does this.  

{p 12 12 2}
         Case 1:
         You are writing new command {cmd:foo}.  {cmd:foo} uses 
         frames but in all cases is to leave the current 
         frame the same as it was initially.  The code reads as follows:

                 {cmd:program foo}
                         {cmd:version} ...

                             {cmd:local curframe = c(frame)}
                             {cmd:frame `curframe' {c -(}}
                                  {cmd:foo_cmd `0'}
                             {cmd:{c )-}}
                 {cmd:end}

{p 12 12 2}
        Write {cmd:foo_cmd} as you usually would.  As you write 
        {cmd:foo_cmd}, you can ignore the current-frame problem. 
        You can use {cmd:frame} {cmd:change} freely in {cmd:foo_cmd}
        and its subroutines. 
        No matter what happens, 
        error or success, the program will end with the current frame 
        unchanged.

{p 12 12 2}
        Case 2:
        You are writing new command {cmd:foo}.  If {cmd:foo} is successful, 
        the new frame will change.  The code reads as follows:

                 {cmd:program foo}
                         {cmd:version} ...

                             {cmd:local curframe = c(frame)}
                             {cmd:frame `curframe' {c -(}}
                                  {cmd:foo_cmd `0'}
                             {cmd:{c )-}}
                       {cmd:frame change `s(frame)'}
                 {cmd:end}

{p 12 12 2}
        Write {cmd:foo_cmd} as you usually would.  If execution is successful, 
        however, {cmd:foo_cmd} 
	must {helpb return:sreturn} in {cmd:s(frame)} the name
	of the frame that is to be the current frame.  As with case~1, you can
	use {cmd:frame} {cmd:change} freely in {cmd:foo_cmd} and all of its
	subroutines. 

{p 8 12 2}
    3.  {helpb preserve} and {helpb restore}.

{p 12 12 2}
        For end users, using frames is sometimes a better alternative 
        to using {cmd:preserve} and {cmd:restore}.   Programmers should 
        not, however, interpret that as {cmd:preserve} and {cmd:restore}
        are out of date and not to be used in frame programming. 
        {cmd:preserve} and {cmd:restore} in programming have the same 
        valid use they have always had.  

{p 12 12 2}
        Before frames existed in Stata, a single program could have at
        most one active {cmd:preserve} in it.  Active means not
        canceled by {cmd:restore} or {cmd:restore,} {cmd:not}.
        A program could {cmd:preserve}, later {cmd:restore} or 
        {cmd:restore,} {cmd:not}, and then {cmd:preserve} again. 
        It would be odd but allowed.

{p 12 12 2}
        Nowadays, a single program can have up to one active
        {cmd:preserve} for each frame.  If a program
        deals with frames {cmd:`one'} and {cmd:`two'} and it is
        necessary, it can {cmd:preserve} both of them.  {cmd:preserve}
        preserves the current frame.  To preserve frames {cmd:`one'}
        and {cmd:`two'}, code,

{col 17}{cmd:frame `one': preserve}
{col 17}{cmd:frame `two': preserve}
             
{p 12 12 2}
       When frames are automatically restored at the end of the program, 
       both frames will be restored. 

{p 12 12 2}
       If you wish to restore frame {cmd:`one'} early and cancel its 
       automatic restoration when the program ends, code 

{col 17}{cmd:frame `one': restore}

{p 12 12 2}
       If you instead wish to restore frame {cmd:`one'} now and still have 
       it restored when the program ends, code

{col 17}{cmd:frame `one': restore, preserve}

{p 12 12 2}
       If you instead wish simply to cancel the restoration of 
       frame {cmd:`one'} when the program ends, code
 
{col 17}{cmd:frame `one': restore, not}

{p 12 12 2}
       In all three cases, frame {cmd:`two'} will still be restored 
       when the program ends. 

{p 12 12 2}
       Any uncanceled automatic restorations when the program ends
       will re-create any frames that have been dropped (deleted).  Automatic
       restoration does not change the identity of the current frame. 
     

{marker mata}{...}
{ul:Mata programming with frames}

{p 8 12 2}
   1.  {bf:{help mf_st_frame:st_frame*()}} functions.

{p 12 12 2}
       Mata provides a suite of frame-related functions. 
       They can change frames, create frames, drop frames, etc. 

{p 8 12 2}
    2.  {bf:{help mf_st_data:st_data()}},
        {bf:{help mf_st_data:st_sdata()}},
        {bf:{help mf_st_data:_st_data()}}, and
        {bf:{help mf_st_data:_st_sdata()}}
        functions.

{p 12 12 2}
        Calls to {cmd:st_data()} and its associated functions 
        return the data from the current frame.   If you want 
        data from other frames, change to the other frame first 
        using {bf:{help mf_st_frame:st_framecurrent()}}.

{p 8 12 2}
   3.  {bf:{help mf_st_view:st_view()}} and 
       {bf:{help mf_st_sview:st_sview()}} functions.

{p 12 12 2}
       Views are views onto the frame that was current at the time the
       view was created by {cmd:st_view()} or {cmd:st_sview()}, and 
       they remain that after creation even when the identity of the 
       current frame changes.  If {cmd:X} is a view onto frame
       {cmd:default}, it remains a view onto frame {cmd:default} 
       even if the current frame changes.

{p 12 12 2}
       Views are how data can be copied between frames.  Create a 
       view onto the data in one frame.  Create another view onto the 
       data in the other.  Use one view to update the other.
{p_end}
