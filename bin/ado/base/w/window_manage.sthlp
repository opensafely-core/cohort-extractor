{smcl}
{* *! version 1.0.22  05feb2019}{...}
{vieweralsosee "[P] window manage" "mansection P windowmanage"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] window programming" "help window_programming"}{...}
{viewerjumpto "Syntax" "window_manage##syntax"}{...}
{viewerjumpto "Description" "window_manage##description"}{...}
{viewerjumpto "Links to PDF documentation" "window_manage##linkspdf"}{...}
{viewerjumpto "Remarks" "window_manage##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[P] window manage} {hline 2}}Manage window characteristics{p_end}
{p2col:}({mansection P windowmanage:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Minimize or restore the main Stata window

{p 8 18 2}
{opt win:dow} {opt man:age} {cmd:minimize}

{p 8 18 2}
{opt win:dow} {opt man:age} {cmd:restore}


{phang}Manage window preferences

{p 8 18 2}
{opt win:dow} {opt man:age} {opt prefs}
 {c -(}{opt load} "{it:prefname}"|{opt save} "{it:prefname}"|{opt default}{c )-}


{phang}Restore file associations (Windows only)

{p 8 18 2}
{opt win:dow} {opt man:age} {opt associate}


{phang}Reset main window title (Unix and Windows only)

{p 8 18 2}
{opt win:dow} {opt man:age} {opt maintitle} {c -(}{opt reset} | "{it:title}"{c )-}


{phang}Set Dock icon's label (Mac only)

{p 8 18 2}
{opt win:dow} {opt man:age} {opt docklabel} ["{it:label}"]


{phang}Bring windows forward

{p 8 18 2}
{opt win:dow} {opt man:age} {opt forward} {it:window-name}

{phang2}
where {it:window-name} can be {opt command}, {opt doeditor}, {opt graph}, 
{opt help}, {opt history}, {opt results}, {opt review}, {opt variables}, or
{opt viewer}.


{phang}Commands to manage Graph windows

{p 8 18 2}
{opt win:dow} {opt man:age} {opt print} {opt graph}

{p 8 18 2}
{opt win:dow} {opt man:age} {opt forward} {opt graph}
 ["{it:graphname}"]

{p 8 18 2}
{opt win:dow} {opt man:age} {opt close} {opt graph}
 [{c -(}"{it:graphname}"|{cmd:_all}{c )-}]

{p 8 18 2}
{opt win:dow} {opt man:age} {opt rename} {opt graph}
 {it:oldgraphname} {it:newgraphname}


{phang}Commands to manage Viewer windows

{p 8 18 2}
{opt win:dow} {opt man:age} {opt print} {opt viewer}
 ["{it:viewername}"]

{p 8 18 2}
{opt win:dow} {opt man:age} {opt forward} {opt viewer}
 ["{it:viewername}"]

{p 8 18 2}
{opt win:dow} {opt man:age} {opt close} {opt viewer}
 [{c -(}"{it:viewername}"|{cmd:_all}{c )-}]


{marker description}{...}
{title:Description} 

{pstd}
{cmd:window manage} allows Stata programs to invoke features from
Stata's main menu.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P windowmanageRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:window} {cmd:manage} accesses various parts of Stata's windowed interface
that would otherwise be available only interactively.  For instance, say that a
programmer wanted to ensure that the Graph window was brought to the front.
An interactive user would do that by selecting {hi:Graph} from the 
{hi:Window} menu.  A Stata program could be made to do the same thing by
coding {cmd:window} {cmd:manage} {cmd:forward} {cmd:graph}.

{pstd}
Remarks are presented under the following headings:

       {hi:{help window manage##minimizing:Minimizing or restoring the main window}}
       {hi:{help window manage##preferences:Windowing preferences}}
       {hi:{help window manage##restoringfile:Restoring file associations (Windows only)}}
       {hi:{help window manage##maintitle:Resetting the main window title}}
       {hi:{help window manage##docklabel:Setting Dock icon's label (Mac only)}}
       {hi:{help window manage##windowsforward:Bringing windows forward}}
       {hi:{help window manage##graphs:Commands to manage Graph windows}}
       {hi:{help window manage##viewer:Commands to manage Viewer windows}}


{marker minimizing}{...}
{title:Minimizing or restoring the main window}

{pstd}
{cmd:window} {cmd:manage} {cmd:minimize} minimizes (hides) the Stata window.
With Stata for Windows and Stata for Unix, this has the same effect as
clicking on the minimize button on Stata's title bar.  With Stata for Mac,
this has the same effect as selecting {hi:Hide Stata} from the {hi:Stata}
menu.

{pstd}
For example,

       {cmd:window manage minimize}

{pstd}
minimizes the overall Stata window if you are using Stata for Windows or
Stata for Unix and hides Stata's windows if you are using Stata for Mac.

{pstd}
{cmd:window} {cmd:manage} {cmd:restore} restores the Stata window if
necessary.

{pstd}
With Stata for Windows, this command has the same effect as
clicking the Stata button on the taskbar.  With Stata for Mac, this 
command has the same effect as clicking on the Stata icon on the Dock.
With Stata for Unix, this command has the same effect as clicking on
the Stata icon in the Window Manager.

{pstd}
For example,

       {cmd:window manage restore}

{pstd}
restores Stata's overall window to its normal, nonminimized state.


{marker preferences}{...}
{title:Windowing preferences}

{pstd}
{cmd:window} {cmd:manage} {cmd:prefs}
{c -(}{opt load} "{it:prefname}"|{opt save} "{it:prefname}"|{opt default}{c )-}
loads, saves, and restores windowing preferences.

{pstd}
{cmd:window manage prefs load} "{it:prefname}" is
equivalent to selecting
{bf:Edit > Preferences > Load Preference set} and loading a
named preference set.  
{cmd:window manage prefs save} "{it:prefname}" is equivalent to selecting
{bf:Edit > Preferences > Save preference set} and naming
a new preference set.  
{cmd:window manage prefs default} is equivalent to selecting
{bf:Edit > Preferences > Load preference set > Widescreen layout (default)}.
In Stata for Mac, the {bf:Preferences} menu is located in the {bf:Stata}
menu.

{pstd}
For example,

       {cmd:window manage prefs default}

{pstd}
restores Stata's windows to their "factory" appearance.


{marker restoringfile}{...}
{title:Restoring file associations (Windows only)}

{pstd}
In Stata for Windows, {cmd:window} {cmd:manage} {cmd:associate} restores the
default actions for Stata file types.  For example, another application could
take over the {cmd:.dta} extension so that double-clicking on a Stata dataset
would no longer launch Stata.  {cmd:window} {cmd:manage} {cmd:associate}
restores the association between all Stata file extensions (such as
{cmd:.dta}) and Stata.  This is equivalent to selecting 
{bf:Edit > Preferences > Reset file associations}.


{marker maintitle}{...}
{title:Resetting the main window title}

{pstd}
In Stata for Unix and Stata for Windows, {cmd:window} {cmd:manage}
{cmd:maintitle} "{it:title}" changes the title of the main Stata Window.
The title may be reset to the default with {cmd:window} {cmd:manage}
{cmd:maintitle} {cmd:reset}.


{marker docklabel}{...}
{title:Setting Dock icon's label (Mac only)}

{pstd}
In Stata for Mac, {cmd:window} {cmd:manage} {cmd:docklabel} "{it:label}"
sets the label to be displayed in the badge area of Stata's application icon
in the Dock.  To clear the badge label, enter the command with no label.  You
should limit the label to 6 characters or fewer; otherwise, the label will be
truncated.

{pstd}
{cmd:window} {cmd:manage} {cmd:docklabel} can be useful for displaying the
progress of a do-file.

{pstd}
For example,

       {hline 45} begin test.do {hline 4}
	do test1.do
	window manage docklabel "25%"
	do test2.do
	window manage docklabel "50%"
	do test3.do
	window manage docklabel "75%"
	do test4.do
	window manage docklabel
       {hline 45} end test.do {hline 6}


{marker windowsforward}{...}
{title:Bringing windows forward}

{pstd}
{cmd:window} {cmd:manage} {cmd:forward} {it:window-name} brings the specified
window to the top of all other Stata windows.  This command is equivalent to
selecting one of the available windows from the {hi:Window} menu.  The
following table lists the {it:window-name}s that {cmd:window manage forward}
understands:

          {it:window-name}{col 30}Stata window
          {hline 40}
          {cmd:command}{col 30}Command window
          {cmd:doeditor}{col 30}Do-file editor window
          {cmd:graph}{col 30}Graph window
          {cmd:help}{col 30}Help/search window
          {cmd:history}{col 30}History window
          {cmd:results}{col 30}Results window
          {cmd:review}{col 30}synonym for {cmd:history}
          {cmd:variables}{col 30}Variables window
          {cmd:viewer}{col 30}Viewer window
          {hline 40}

{pstd}
If a window had not been available on Stata's {hi:Window} menu (if it had
been grayed out), specifying {it:window-name} after 
{cmd:window manage forward} would do nothing.  For example, if there is no
current graph, {cmd:window manage forward graph} will do nothing; it is not an
error.

{pstd}
For example,

       {cmd:window manage forward results}

{pstd}
brings the Results window to the top of the other Stata windows.

{pstd}
Under Stata for Mac and Stata for Unix, specifying the Command, History,
Results, or Variables windows will bring the main Stata window forward because
these windows are all contained within one window.
{p_end}


{marker graphs}{...}
{title:Commands to manage Graph windows}

{pstd}{bf:Printing}

{pstd}
{cmd:window} {cmd:manage} {cmd:print} {opt graph} invokes the action of the
{hi:File} > {hi:Print} > {hi:Graph (Graph)} menu item.  If there is no current
graph, {cmd:window} {cmd:manage} {cmd:print} does nothing; it does not return
an error.

{pstd}
For example,

       {cmd:window manage print graph}

{pstd}
displays the print dialog box just as if you pulled down
{hi:File} > {hi:Print} > {hi:Graph (Graph)}.

{pstd}{bf:Bringing forward}

{pstd}
{cmd:window} {cmd:manage} {cmd:forward} {opt graph} [{it:graphname}] brings
the Graph window named {it:graphname}, if it exists, to the top of other
windows.  If {it:graphname} is not specified and there are multiple graph 
windows open, {cmd:window} {cmd:manage} {cmd:forward} {cmd:graph} brings
the topmost Graph window to the top of other windows.

{pstd}{bf:Closing}

{pstd}
{cmd:window} {cmd:manage} {cmd:close} {opt graph} [{it:graphname}|{cmd:_all}]
closes the Graph windows named {it:graphname}, if it exists.  If {cmd:_all}
is specified, all Graph windows are closed.  If {it:graphname} is not 
specified and an unnamed Graph window exists, the unnamed Graph window will
be closed.  Note that this command is not intended for end users; it is a
utility to be used by {cmd:graph close}.  End users should use
{helpb graph close}.

{pstd}{bf:Renaming}

{pstd}
{cmd:window} {cmd:manage} {cmd:rename} {cmd:graph} {it:oldgraphname}
{it:newgraphname} renames the Graph window named {it:oldgraphname}, if it
exists, to {it:newgraphname}.  Note that this command is not intended for end
users; it is a utility to be used by {cmd:graph rename}.  End users
should use {helpb graph rename}.


{marker viewer}{...}
{title:Commands to manage Viewer windows}

{pstd}{bf:Printing}

{pstd}
{cmd:window} {cmd:manage} {cmd:print} {opt viewer} [{it:viewername}] prints 
the Viewer window named {it:viewername}, if it exists.  If {it:viewername} is
not specified and there are multiple Viewer windows open, {cmd:window}
{cmd:manage} prints the topmost Viewer window.  If there is no current Viewer
window, {cmd:window} {cmd:manage} {cmd:print} does nothing; it does not return
an error.

{pstd}{bf:Bringing forward}

{pstd}
{cmd:window} {cmd:manage} {cmd:forward} {opt viewer} [{it:viewername}] brings
the Viewer window named {it:viewername}, if it exists, to the top of other
windows.  If {it:viewername} is not specified and there are multiple Viewer 
windows open, {cmd:window} {cmd:manage} brings the topmost Viewer window
to the top of other windows.

{pstd}{bf:Closing}

{pstd}
{cmd:window} {cmd:manage} {cmd:close} {opt viewer} [{it:viewername}|{cmd:_all}]
closes the Viewer window named {it:viewername}, if it exists.  If {cmd:_all}
is specified, all Viewer windows are closed.  If {it:viewername} is not 
specified and an unnamed Viewer window exists, the unnamed Viewer window will
be closed.
{p_end}
