{smcl}
{* *! version 1.1.3  29jan2019}{...}
{findalias asgsufonts}{...}
{viewerjumpto "Changing and saving fonts and positions of your windows" "unixfonts##remarks1"}{...}
{viewerjumpto "Changing color schemes" "unixfonts##remarks2"}{...}
{viewerjumpto "Managing your preferences" "unixfonts##remarks3"}{...}
{viewerjumpto "Closing and opening windows" "unixfonts##remarks4"}{...}
{title:Title}

    {findalias gsufonts} 


{marker remarks1}{...}
{title:Changing and saving fonts and positions of your windows}

{p 4 4 2}
You can change fonts in the following windows:

{p 8 25 2}{hi:Results}{space 10}(fixed-width fonts only){p_end}
{p 8 25 2}{hi:command line}{space 5}(any font){p_end}
{p 8 25 2}{hi:History}{space 11}(any font){p_end}
{p 8 25 2}{hi:Variables}{space 8}(any font){p_end}
{p 8 25 2}{hi:Do-file Editor}{space 3}(fixed-width fonts only){p_end}
{p 8 25 2}{hi:Data Editor}{space 6}(fixed-width fonts only){p_end}
{p 8 25 2}{hi:Viewer}{space 11}(fixed-width fonts only){p_end}
{p 8 25 2}{hi:Graph}{space 12}(any font)

{p 4 4 2}
(Fixed-width fonts are "typewriter" fonts like Courier.)


{p 4 4 2}
To change the font for a window:

{p 8 12 2}1.  Right-click on the window and select {cmd:Preferences...}{p_end}
{p 8 12 2}2.  Click the {cmd:Browse} button next to the font field.{p_end}
{p 8 12 2}3.  Select the font and size.{p_end}
{p 8 12 2}4.  Click {cmd:OK}.{p_end}
{p 8 12 2}5.  Click {cmd:OK} again.


{marker remarks2}{...}
{title:Changing color schemes}

{p 4 4 2}
To change the color scheme of the {hi:Results} window:

{p 8 12 2}1.  Right-click on the Results window and select {cmd:Preferences...}{p_end}
{p 8 12 2}2.  Select the desired scheme from the {cmd:Color scheme} list.

    or

{p 8 12 2}1.  Create your own by selecting Custom 1 from the {cmd:Color scheme}
		list.{p_end}
{p 8 12 2}2.  Click the various output level buttons and select the desired
		color.{p_end}
{p 8 12 2}3.  Check the {cmd:bold} and {cmd:underline} boxes if desired.


{p 4 4 2}
To change the color scheme of the {hi:Viewer}:

{p 8 12 2}1.  Right-click on the Viewer window and select {cmd:Preferences...}{p_end}
{p 8 12 2}3.  Select the desired scheme from the {cmd:Color scheme} list.

    or

{p 8 12 2}1.  Create your own by selecting Custom 1 from the {cmd:Color scheme}
		list.{p_end}
{p 8 12 2}2.  Click the various output level buttons and select the desired
		color.{p_end}
{p 8 12 2}3.  Check the {cmd:bold} and {cmd:underline} boxes if desired.


{p 4 4 2}
Stata(console) users should see help {help conren} for information on
console settings that take advantage of Stata's color, bold, and underlined
output.


{marker remarks3}{...}
{title:Managing your preferences}

{p 4 4 2}
Your font sizes, graph settings, and window layout will be automatically saved
at the end of your Stata session.  The next time Stata comes up, it will come
up exactly as you left it.  You can also have multiple sets of preferences.


{p 4 4 2}
To save your font, graph, and window preferences:

{p 8 12 2}1.  Select {cmd:Edit > Preferences > Manage Preferences > Save Preferences...}.{p_end}
{p 8 12 2}2.  Enter a {it:preference_name}.


{p 4 4 2}
To load a saved preference:

{p 8 8 2}Select {cmd:Edit > Preferences > Manage Preferences > Open Preferences ... > }{it:preference_name}.


{p 4 4 2}
To restore the factory settings for the font, graph settings, and
window layout:

{p 8 8 2}
Select {cmd:Edit > Preferences > Manage Preferences > Factory Settings}.


{marker remarks4}{...}
{title:Closing and opening windows}

{p 4 4 2}
You can close the {hi:Viewer}, {hi:Graph}, {hi:Do-file Editor}, and
{hi:Data Editor} windows.


{p 4 4 2}
If you want to open a closed window or bring a hidden one to the top:

{p 8 8 2}
Select the desired window from the {cmd:Window} menu.


{p 4 4 2}
There are also buttons to bring the {hi:Main}, {hi:Graph}, {hi:Data Editor},
{hi:Do-file Editor}, and {hi:Viewer} windows to the top.
{p_end}
