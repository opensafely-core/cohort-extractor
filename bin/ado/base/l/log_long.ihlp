{* *! version 1.0.0  22jun2019}{...}
{phang}
[{cmd:no}]{cmd:log} displays or suppresses a log showing the progress of the
estimation.  By default, one-line messages indicating when each lasso
estimation begins are shown. Specify {cmd:verbose} to see a more detailed log.

{phang}
{cmd:verbose} displays a verbose log showing the iterations of each lasso
estimation.  This option is useful when doing {cmd:selection(cv)} or
{cmd:selection(adaptive)}.  It allows you to monitor the progress of the lasso
estimations for these selection methods, which can be time consuming when
there are many {it:othervars} specified in {cmd:controls()}.
