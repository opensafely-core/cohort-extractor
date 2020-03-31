{smcl}
{* *! version 1.1.4  04oct2018}{...}
{findalias asfrkeyboard}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Description" "keyboard##description"}{...}
{viewerjumpto "F-keys" "keyboard##fkeys"}{...}
{title:Title}

{pstd}
{findalias frkeyboard}


{marker description}{...}
{title:Description}

{pstd}
Certain keys allow you to edit the line that you are typing.  Because Stata
supports a variety of computers and keyboards, the location and the names of
the editing keys are not the same for all Stata users.

{pstd}
Every keyboard has the standard alphabet keys (QWERTY and so on), and every
keyboard has a {hi:Ctrl} key.  Some keyboards have extra keys located to the
right, above, or left, with names like {hi:PgUp} and {hi:PgDn}.

{pstd}
Some key combinations have a special meaning to Stata.  {hi:Break}, for
instance, tells Stata to stop what it is doing and return control to the
keyboard.  On most Unix computers, holding down {hi:Ctrl} and pressing {hi:C}
produces {hi:Break}.

{pstd}Other key combinations provide a shorthand for certain commands and
editing previous lines. On keyboards with a key labeled {hi:PgUp}, {hi:PgUp}
is the PrevLine key, but on everybody's keyboard, no matter which version of
Unix, brand of keyboard, or anything else, {hi:Ctrl+R} also means PrevLine.

{pstd}When we say to press PrevLine, now you know what we mean: press {hi:PgUp}
or {hi:Ctrl+R}.  The editing keys are the following:

      Name for
    editing key{space 2}Editing key{space 18}Function
    {hline}
    Kill{space 6}{hi:Esc} on PCs or {hi:Ctrl+U}{space 12}Deletes the line and lets you
                                                start over.

    Dbs{space 7}{hi:Backspace} on PCs, {hi:Delete},{space 7}Backs up and deletes one
                or {hi:Ctrl+H}                       character.

    Lft{space 7}{hi:<-} (left arrow), {hi:4} on the       Moves the cursor left one
                numeric keypad for PCs, or      character without deleting
		{hi:Ctrl+H}                          any characters.

    Rgt{space 7}{hi:->} (right arrow), {hi:6} on the      Moves the cursor forward one
                numeric keypad for PCs, or      character.
		{hi:Ctrl+L}

    Up{space 8}Up arrow, {hi:8} on the numeric      Moves the cursor up one physical
                keypad for PCs, or {hi:Ctrl+O}       line on a line that takes
		                                more than one physical line.
						Also see PrevLine.

    Dn{space 8}Down arrow, {hi:2} on the numeric    Moves the cursor down one 
                keypad for PCs, or {hi:Ctrl+N}       physical line on a line that
		                                takes more than one physical
						line.  Also see NextLine.

    PrevLine{space 2}{hi:PgUp} or {hi:Ctrl+R}                  Retrieves a previously typed
                                                line.  You may press PrevLine
						multiple times to step back
						through previous commands.

    NextLine{space 2}{hi:PgDn} or {hi:Ctrl+B}                  The inverse of PrevLine.

    Seek{space 6}{hi:Ctrl+Home} on PCs or {hi:Ctrl+W}      Goes to the line number
                                                specified.  Before pressing
						Seek, type the line number.
						For instance, typing {hi:3} and
						then pressing Seek is the
						same as pressing PrevLine
						three times.

    Ins{space 7}{hi:Ins} or {hi:Ctrl+E}                   Toggles insert mode. In insert
                                                mode, characters typed are
						inserted at the position of
						the cursor.

    Del{space 7}{hi:Del} or {hi:Ctrl+D}                   Deletes the character at the
                                                position of the cursor.

    Home{space 6}{hi:Home} or {hi:Ctrl+K}                  Moves the cursor to the start of
                                                the line.

    End{space 7}{hi:End} or {hi:Ctrl+P}                   Moves the cursor to the end of 
                                                the line.

    Hack{space 6}{hi:Ctrl+End} on PCs or {hi:Ctrl+X}       Hacks off the line at the cursor.

    Tab{space 7}{hi:->|} on PCs, {hi:Tab}, or {hi:Ctrl+I}      Expands the variable name.

    Btab{space 6}{hi:|<-} on PCs or {hi:Ctrl+G}            The inverse of Tab.
    {hline}


{marker fkeys}{...}
{title:F-keys}

{pstd}
By default, Stata defines the F-keys to mean

      F-key{col 16}Equivalent to typing...{col 60}See
      {hline 67}
      F1{col 16}{cmd:help advice;}{col 30}and pressing the spacebar{col 60}{helpb help advice}
      F2{col 16}{cmd:describe;}{col 30}and pressing Enter{col 60}{helpb describe}
      F7{col 16}{cmd:save}{col 30}and pressing the spacebar{col 60}{helpb save}
      F8{col 16}{cmd:use}{col 30}and pressing the spacebar{col 60}{helpb use}
      {hline 67}

{pstd}
The semicolons at the end of some entries indicate an implied {hi:Return}.

{pstd}
Unix(console) users:  Sometimes Unix assigns a special meaning to the
F-keys, and if it does, those meanings supersede our meanings.  Stata provides
a second way to get to the F-keys.  Hold down {hi:Ctrl}, press {hi:F}, release
the keys, and then press a number {hi:0} through {hi:9}.  Stata interprets
{hi:Ctrl+F} plus {hi:1} as equivalent to the {hi:F1} key, {hi:Ctrl+F} plus
{hi:2} as {hi:F2}, and so on.  {hi:Ctrl+F} plus {hi:0} means {hi:F10}.  These
keys will work only if they are properly mapped in your {cmd:termcap} or
{cmd:terminfo} entry.

{pstd}
Unix(console) users:  {cmd:Ctrl+H} can be used for either a backspace or
a left arrow.  The default is backspace, and this can be changed with the
undocumented command {helpb set ctrlh}.

{pstd}
Windows users: {hi:F10} is reserved internally by Windows; you cannot
program this key.
{p_end}
