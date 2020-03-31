{smcl}
{* *! version 1.6.3  01apr2019}{...}
{findalias asfrflavors}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Stata/IC" "help stataic"}{...}
{vieweralsosee "Stata/SE" "help statase"}{...}
{vieweralsosee "Stata/MP" "help statamp"}{...}
{title:Title}

{pstd}
{findalias frflavors}


{title:Contents}

        {help flavors##platforms:5.1 Platforms}

        {help flavors##flavors:5.2 Stata/MP, Stata/SE, and Stata/IC}
            {help flavors##version_own:5.2.1 Determining which version you own}
            {help flavors##version_installed:5.2.2 Determining which version is installed}

        {help flavors##limits:5.3 Size limits of Stata/MP, SE, and IC}

        {help flavors##speed:5.4 Speed comparison of Stata/MP, SE, and IC}

        {help flavors##comparison:5.5 Feature comparison of Stata/MP, SE, and IC}


{marker platforms}{...}
{title:5.1 Platforms}

{pstd}
Stata is available for a variety of systems, including

        Stata for Windows, 64-bit x86-64

        Stata for Mac, 64-bit x86-64

        Stata for Linux, 64-bit x86-64

{pstd}
Which version of Stata you run does not matter -- Stata is Stata.  You
instruct Stata in the same way and Stata produces the same results, right down
to the random-number generator.  Even files can be shared.  A dataset created
on one computer can be used on any other computer, and the same goes for
graphs, programs, or any file Stata uses or produces.  Moving files
across platforms is simply a matter of copying them; no translation is
required.

{pstd}
Some computers, however, are faster than others.  Some computers have more
memory than others.  Computers with more memory, and faster computers, are
better.

{pstd}
When you purchase Stata, you may install it on any of the above platforms.
Stata licenses are not locked to a single operating system.


{marker flavors}{...}
{title:5.2 Stata/MP, Stata/SE, and Stata/IC}

{pstd}
Stata is available in three flavors, although perhaps sizes would be a better
word.  The flavors are, from largest to smallest, Stata/MP, Stata/SE,
and Stata/IC.

{pstd}
Stata/MP is the multiprocessor version of Stata.  It runs on multiple 
CPUs or on multiple cores, from 2 to 64.  Stata/MP uses however many
cores you tell it to use (even one), up to the number of cores for which you
are licensed.  Stata/MP is the fastest version of Stata.  Even so, all the
details of parallelization are handled internally and you use Stata/MP just
like you use any other flavor of Stata.  You can read about how
Stata/MP works and see how its speed increases with more cores in the Stata/MP
performance report at
{browse "https://www.stata.com/statamp/report.pdf":https://www.stata.com/statamp/report.pdf}.

{pstd}
Stata/SE is like Stata/MP, but for single CPUs.  Stata/SE will run on
multiple CPUs or multiple core computers, but it will use only one of
the CPUs or cores.  SE stands for special edition.

{pstd}
In addition to being the fastest version of Stata, Stata/MP is also the
largest.  Stata/MP allows up to 1,099,511,627,775 observations in theory,
but you can undoubtedly run out of memory first.  You may have up to
120,000 variables with Stata/MP.  Statistical models may have up to 11,000
variables.

{pstd}
Stata/SE allow up to 2,147,583,647 observations, assuming you have enough
memory.  You may have up to 32,767 variables, and, like Stata/MP, statistical
models may have up to 11,000 variables.

{pstd}
Stata/IC is standard Stata.  Up to 2,147,583,647 observations and 2,048
variables are allowed, depending on memory.  Statistical models may have
up to 800 variables.


{marker version_own}{...}
    {title:5.2.1 Determining which version you own}

{pstd}
Check your License and Activation Key.  Included with every copy of Stata is
a License and Activation Key that contains codes that you will input
during installation.  This determines which flavor of Stata you have and for
which platform.

{pstd}
Contact us or your distributor if you want to upgrade from one flavor to
another.  Usually, all you need is an upgraded License and Activation
Key with the appropriate codes.  All flavors of Stata are on the same DVD.  

{pstd}
If you purchased one flavor of Stata and want to use a lessor version, you
may.  You might want to do this if you had a large computer at work and a
smaller one at home.  Please remember, however, that you have only one
license (or however many licenses you purchased).  You may, both legally and
ethically, install Stata on both computers and then use one or the other, but
you should not use them both simultaneously.


{marker version_installed}{...}
    {title:5.2.2 Determining which version is installed}

{pstd}
If Stata is already installed, you can find out which Stata
you are using by entering Stata as you normally do and typing {cmd:about}:

        . about

        Stata/IC {ccl stata_version} for Windows (64-bit x86-64)
        Born {it:date}
        Copyright (C) 1985-2019 StataCorp LLC

        Total physical memory:     8388608 KB
        Available physical memory:  937932 KB

        10-user 32-core Stata network perpetual license:
               Serial number:  5015041234
                 Licensed to:  Alan R. Riley
                               StataCorp


{marker limits}{...}
{title:5.3 Size limits of Stata/MP, SE, and IC}

{pstd}
Stata/MP allows more variables and observations, longer macros, and a longer
command line than Stata/SE.  Stata/SE allows more variables, larger
models, longer macros, and a longer command line than Stata/IC.  The
longer command line and macro length are required because of the greater
number of variables allowed.  The larger model means that Stata/MP and
Stata/SE can fit statistical models with more independent variables.
See {help limits} for the maximum size limits for Stata/MP, Stata/SE, and
Stata/IC.


{marker speed}{...}
{title:5.4 Speed comparison of Stata/MP, SE, and IC}

{pstd}
We have written a white paper comparing the performance of Stata/MP with
Stata/SE; see 
{browse "https://www.stata.com/statamp/report.pdf"}.  The white paper includes
command-by-command performance measurements.

{pstd}
In summary, on a dual-core computer, Stata/MP will run
commands in 71% of the time required by Stata/SE.  There is variation; some
commands run in half the time and others are not sped up at all.  Statistical
estimation commands run in 59% of the time.  Numbers quoted are medians.
Average performance gains are higher because commands that take longer to
execute are generally sped up more.

{pstd}
Stata/MP running on four cores runs in 50% (all commands) and 35%
(estimation commands) of the time required by Stata/SE.  Both numbers are
median measures.

{pstd}
Stata/MP supports up to 64 cores.

{pstd}
Stata/IC is a slower than Stata/SE, but those differences emerge only
when processing datasets that are pushing the limits of Stata/IC.
Stata/SE has a larger memory footprint and uses that
extra memory for larger look-aside tables to more efficiently process large
datasets.  The real benefits of the larger tables become apparent  
only after exceeding
the limits of Stata/IC.  Stata/SE was designed for processing large datasets.

{pstd}
In all cases, the differences are all technical and internal.  From the user's
point of view, Stata/MP, Stata/SE, and Stata/IC work the same way.


{marker comparison}{...}
{title:5.5 Feature comparison of Stata/MP, SE, and IC}

{pstd}
The features of all flavors of Stata on all platforms are the same.
The differences are in speed and in limits.  The differences in 
limits are

                                  Stata/IC               Stata/SE and /MP
          Parameter  {c |}  Default    min    max  {c |}  Default    min     max
          {hline 11}{c +}{hline 25}{c +}{hline 28}
          {helpb maxvar}     {c |}    2,048  2,048  2,048  {c |}    5,000  2,048 120,000 (MP)
                     {c |}                         {c |}                  32,767 (SE)
                     {c |}                         {c |}
          {helpb processors} {c |}        1      1      1  {c |}        2      1      64 (MP)
                     {c |}                         {c |}        1      1       1 (SE)
          {hline 11}{c BT}{hline 25}{c BT}{hline 28}
          Note:  The default number of processors for Stata/MP is the minimum
                 of processors licensed and processors available.

{pstd}
The limits on Stata/MP and /SE are settable.  You reset the limits 
temporarily by typing 

        {cmd:. set maxvar} {it:#}
        {cmd:. set processors} {it:#}

{pstd}
Concerning the last, Stata/MP users sometimes want to use fewer processors to
leave some free for other applications.

{pstd}
You reset the limits permanently by typing

        {cmd:. set maxvar} {it:#}{cmd:, permanently}

{pstd}
If you use Stata/SE or Stata/MP, see
{bf:{help statase:help stata/se}}
or
{bf:{help statamp:help stata/mp}}
to learn more.
