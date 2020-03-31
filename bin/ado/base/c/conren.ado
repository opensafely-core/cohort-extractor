*! version 1.1.2  20jan2015
program define conren
	version 7
	* To add a black background style scheme increase maxbc and then
	* write subroutine ColorB#  <-- where # is this new maxbc number.
	*
	* To add a white background style scheme increase maxwc and then
	* write subroutine ColorW#  <-- where # is this new maxwc number.
	*
	* black background schemes are numbered 1, 2, ... , `maxbc'
	* white background schemes are numbered 101, 102, ... , 100+`maxwc'
	*
	* To add an underline scheme increase maxuls and then write
	* subroutine Ul#  <-- where # is this new maxuls number.

	if "$S_CONSOLE" != "console" {
		/* Only -conren test- makes any sense for non console users */
		RenTest
		exit
	}

	local maxbc	5
	local maxwc	8
	local maxuls	2
	local maxcolors = `maxbc' + `maxwc'

	args subcmd cmdarg

	if "`subcmd'"=="" {
		di
		di "{p 4 4}{txt}{cmd:conren} currently has " `maxcolors'+1
		di " style schemes and " `maxuls'+1 " underlining schemes,"
		di "for a total of " (`maxcolors'+1)*(`maxuls'+1)
		di " possibilities.  Scheme 0 for {cmd:style} (or {cmd:ul})"
		di "removes the style (or underline) settings.  `maxbc' dark"
		di "and `maxwc' light background schemes are available."
		di "You are free to choose from all schemes."
		di "You can try style schemes by typing"
		di
		di "{col 34}0 == {it:#}{col 51}reset style scheme"
		di "{col 12}{txt}. {cmd:conren style} {it:#}{col 34}" /*
			*/ "1 <= {it:#} <= `maxbc'{col 51}dark backgrounds"
		di "{col 32}101 <= {it:#} <= " `maxwc'+100 /*
			*/ "{col 51}light backgrounds" _n
		di "{p 4 4}and underlining schemes by typing"
		di
		di "{col 12}{txt}. {cmd:conren ul} {it:#}{col 34}" /*
			*/ "0 <= {it:#} <= `maxuls'" _n
		di "{p 4 4}You can view how a scheme looks by typing"
		di
		di "{col 12}{txt}. {cmd:conren test}" _n
		di "{p 4 4}You can clear all styles and underlining by typing"
		di
		di "{col 12}{txt}. {cmd:conren clear}"
		exit
	}

	local len = length("`subcmd'")

	if "`subcmd'"==bsubstr("test",1,`len') {
		RenTest
		exit
	}

	if "`subcmd'"=="reset" || "`subcmd'"=="clear" {
		set conren clear
		di as txt "(all rendition codes cleared)"
		exit
	}

	if "`subcmd'" == bsubstr("style",1,max(`len',1)) {
		confirm integer number `cmdarg'
		if (`cmdarg'<0) | (`cmdarg' > `maxwc'+100) | /*
				*/ ((`cmdarg'<101) & (`cmdarg'>`maxbc')) {
			di as err "{p}# must be between 0 and `maxbc' or"
			di "between 101 and " `maxwc'+100 "{break}"
			exit 198
		}
		if `cmdarg'==0 {
			Color0
		}
		else if `cmdarg' <= `maxbc' {
			ColorB`cmdarg' `cmdarg'
		}
		else {
			local wnum = `cmdarg' - 100
			ColorW`wnum' `cmdarg'
		}

		exit
	}

	if "`subcmd'" == "ul" {
		confirm integer number `cmdarg'
		if `cmdarg'<0 | `cmdarg'>`maxuls' {
			di as err "# must be between 0 and `maxuls'"
			exit 198
		}
		Ul`cmdarg'
		exit
	}
	error 198
end

program define Color0
	/* remove any current bf, sf, and it definitions */
	set conren res
	set conren txt
	set conren blue
	set conren inp
	set conren err
	set conren link
	set conren hi
	/* remove the reset code */
	set conren reset

	di
	di "{txt}{p 4 4 4}{cmd:style 0} removes the current style definitions."
end

program define ColorB1  /* for black backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 3 m
	set conren txt  <27> [ 3 2 m
	set conren blue <27> [ 3 6 m
	set conren inp  <27> [ 3 7 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 6 m
	set conren hi   <27> [ 3 7 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'}, designed for black backgrounds,"
	di "provides all the colors, but does not attempt to distinguish"
	di "between bold and normal type."

	RenTest
end

program define ColorB2  /* for black backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 3 m
	set conren txt  <27> [ 3 2 m
	set conren blue <27> [ 3 6 m
	set conren inp  <27> [ 3 7 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 6 m
	set conren hi   <27> [ 3 7 m
	/* now reset bf */
	set conren bf res  <27> [ 1 ; 3 3 m
	set conren bf txt  <27> [ 1 ; 3 2 m
	set conren bf blue <27> [ 1 ; 3 6 m
	set conren bf inp  <27> [ 1 ; 3 7 m
	set conren bf err  <27> [ 1 ; 3 1 m
	set conren bf link <27> [ 1 ; 3 6 m
	set conren bf hi   <27> [ 1 ; 3 7 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'}, designed for black backgrounds,"
	di "provides all the colors and attempts to distinguish between"
	di "bold and normal type."

	RenTest
end

program define ColorB3  /* for black backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 1 ; 3 3 m
	set conren txt  <27> [ 1 ; 3 2 m
	set conren blue <27> [ 1 ; 3 6 m
	set conren inp  <27> [ 1 ; 3 7 m
	set conren err  <27> [ 1 ; 3 1 m
	set conren link <27> [ 1 ; 3 6 m
	set conren hi   <27> [ 1 ; 3 7 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di "{txt}{p 4 4 4}{cmd:style `1'}, designed for black backgrounds,"
	di "provides all the colors, but does not attempt to distinguish"
	di "between bold and normal type."
	RenTest
end

program define ColorB4  /* for black backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 3 m
	set conren txt  <27> [ 3 2 m
	set conren blue <27> [ 3 6 m
	set conren inp  <27> [ 3 7 m
	set conren err  <27> [ 1 ; 3 1 m
	set conren link <27> [ 3 6 m
	set conren hi   <27> [ 3 7 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'}, designed for black backgrounds,"
	di "provides all the colors, but does not attempt to distinguish"
	di "between bold and normal type.  However all choices for error"
	di "are made bold red for more dramatic effect."

	RenTest
end

program define ColorB5  /* for black backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 3 m
	set conren txt  <27> [ 3 2 m
	set conren blue <27> [ 3 6 m
	set conren inp  <27> [ 3 7 m
	set conren err  <27> [ 1 ; 3 1 m
	set conren link <27> [ 3 6 m
	set conren hi   <27> [ 3 7 m
	/* now reset bf */
	set conren bf res  <27> [ 1 ; 3 3 m
	set conren bf txt  <27> [ 1 ; 3 2 m
	set conren bf blue <27> [ 1 ; 3 6 m
	set conren bf inp  <27> [ 1 ; 3 7 m
	set conren bf link <27> [ 1 ; 3 6 m
	set conren bf hi   <27> [ 1 ; 3 7 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'}, designed for black backgrounds,"
	di "provides all the colors and attempts to distinguish between"
	di "bold and normal type.  However all choices for error"
	di "are made bold red for more dramatic effect."

	RenTest
end

program define ColorW1   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 1 ; 3 0 m
	set conren txt  <27> [ 3 0 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 1 ; 3 0 m
	/* reset bold ct and bold st */
	set conren bf inp <27> [ 1 ; 3 0 m
	set conren bf txt <27> [ 1 ; 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} is designed for white backgrounds."
	di "It sets text and input to black; hilite, result, bold text, and"
	di "bold input to bold black; and uses red for error and blue for"
	di "link without distinguishing between bold and normal type."

	RenTest
end

program define ColorW2   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 1 ; 3 0 m
	set conren txt  <27> [ 3 0 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 1 ; 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 1 ; 3 0 m
	/* reset bold txt */
	set conren bf txt <27> [ 1 ; 3 0 m
	/* reset italic inp */
	set conren it inp <27> [ 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} is designed for white backgrounds."
	di "It sets text to black; hilite, input, result, and bold text to"
	di "bold black; and uses red for error and blue for link without"
	di "distinguishing between bold and normal type."

	RenTest
end

program define ColorW3   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 1 ; 3 0 m
	set conren txt  <27> [ 3 0 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 1 ; 3 0 m
	/* reset some bolds */
	set conren bf inp  <27> [ 1 ; 3 0 m
	set conren bf txt  <27> [ 1 ; 3 0 m
	set conren bf blue <27> [ 1 ; 3 4 m
	set conren bf err  <27> [ 1 ; 3 1 m
	set conren bf link <27> [ 1 ; 3 4 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} is designed for white backgrounds."
	di "It sets text and input to black; hilite, result, bold text, and"
	di "bold input to bold black; and uses red for error and blue for"
	di "link using both bold and normal type."

	RenTest
end

program define ColorW4   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 1 ; 3 0 m
	set conren txt  <27> [ 3 0 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 1 ; 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 1 ; 3 0 m
	/* reset bolds as needed */
	set conren bf txt  <27> [ 1 ; 3 0 m
	set conren bf blue <27> [ 1 ; 3 4 m
	set conren bf err  <27> [ 1 ; 3 1 m
	set conren bf link <27> [ 1 ; 3 4 m
	/* reset italic inp from bold back to plain */
	set conren it inp <27> [ 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} is designed for white backgrounds."
	di "It sets text to black; hilite, input, result, and bold text to"
	di "bold black; and uses red for error and blue for link"
        di "using both bold and normal type."

	RenTest
end

program define ColorW5   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 0 m
	set conren txt  <27> [ 3 0 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} sets input, result, and text to"
	di "black (for use with white backgrounds), uses red for error and"
	di "blue for link, but does not attempt to distinguish between bold"
	di "and normal type."

	RenTest
end

program define ColorW6   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 0 m
	set conren txt  <27> [ 3 0 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 3 0 m
	/* now reset bf */
	set conren bf res  <27> [ 1 ; 3 0 m
	set conren bf txt  <27> [ 1 ; 3 0 m
	set conren bf blue <27> [ 1 ; 3 4 m
	set conren bf inp  <27> [ 1 ; 3 0 m
	set conren bf err  <27> [ 1 ; 3 1 m
	set conren bf link <27> [ 1 ; 3 4 m
	set conren bf hi   <27> [ 1 ; 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} sets input, result, and text to"
	di "black (for use with white backgrounds), uses red for error and"
	di "blue for link, and attempts to distinguish between bold and"
	di "normal type in all cases."

	RenTest
end

program define ColorW7   /* for white backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 3 m
	set conren txt  <27> [ 3 2 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} sets input to black (for use with"
	di "white backgrounds) and provides all the other colors, but does"
	di "not attempt to distinguish between bold and normal type."
	di "Yellow and green are often hard to see on a white background, and"
	di "if this is true for you, consider trying another scheme."

	RenTest
end

program define ColorW8   /* for ct backgrounds */
	/* set bf, sf, and it */
	set conren res  <27> [ 3 3 m
	set conren txt  <27> [ 3 2 m
	set conren blue <27> [ 3 4 m
	set conren inp  <27> [ 3 0 m
	set conren err  <27> [ 3 1 m
	set conren link <27> [ 3 4 m
	set conren hi   <27> [ 3 0 m
	/* now reset bf */
	set conren bf res  <27> [ 1 ; 3 3 m
	set conren bf txt  <27> [ 1 ; 3 2 m
	set conren bf blue <27> [ 1 ; 3 4 m
	set conren bf inp  <27> [ 1 ; 3 0 m
	set conren bf err  <27> [ 1 ; 3 1 m
	set conren bf link <27> [ 1 ; 3 4 m
	set conren bf hi   <27> [ 1 ; 3 0 m
	/* set the reset code */
	set conren reset <27> [ 0 m

	di
	di "{txt}{p 4 4 4}{cmd:style `1'} sets input to black (for use with"
	di "white backgrounds), provides all the other colors, and attempts"
	di "to distinguish between bold and normal type."
	di "Yellow and green are often hard to see on a white background, and"
	di "if this is true for you, consider trying another scheme."

	RenTest
end

program define Ul0
	/* clear both codes */
	set conren ulon
	set conren uloff

	di
	di "{txt}{p 4 4 4}{cmd:ul 0} removes the current"
	di "{cmd:ulon} and {cmd:uloff} definitions."
end

program define Ul1
	/* set both codes */
	set conren ulon   <27> [ 4 m
	set conren uloff  <27> [ 2 4 m

	di
	di "{txt}{p 4 4 4}{cmd:ul 1} sets both {cmd:ulon} and {cmd:uloff}."

	RenTest
end

program define Ul2
	/* set ulon, but clear uloff */
	set conren ulon   <27> [ 4 m
	set conren uloff

	di
	di "{txt}{p 4 4 4}{cmd:ul 2} sets {cmd:ulon}, but clears the"
	di "{cmd:uloff} definition.  If all goes well, the underlining will"
	di "be turned off automatically with the {cmd:reset} font code."

	RenTest
end

program define RenTest
	di
	di "{txt}{col 10}{sf:sf font}{col 36}{bf:bf font}{col 62}{it:it font}"
	di "{txt}{col 5}{hline 18}{col 31}{hline 18}{col 57}{hline 18}"

	di "{col  5}{sf:{res:result}}{col 13}{sf:{ul:{res:underlined}}}" _c
	di "{col 31}{bf:{res:result}}{col 39}{bf:{ul:{res:underlined}}}" _c
	di "{col 57}{it:{res:result}}{col 65}{it:{ul:{res:underlined}}}"

	di "{col  5}{sf:{txt:text}}{col 13}{sf:{ul:{txt:underlined}}}" _c
	di "{col 31}{bf:{txt:text}}{col 39}{bf:{ul:{txt:underlined}}}" _c
	di "{col 57}{it:{txt:text}}{col 65}{it:{ul:{txt:underlined}}}"

	di "{col  5}{sf:{inp:input}}{col 13}{sf:{ul:{inp:underlined}}}" _c
	di "{col 31}{bf:{inp:input}}{col 39}{bf:{ul:{inp:underlined}}}" _c
	di "{col 57}{it:{inp:input}}{col 65}{it:{ul:{inp:underlined}}}"

	di "{col  5}{sf:{err:error}}{col 13}{sf:{ul:{err:underlined}}}" _c
	di "{col 31}{bf:{err:error}}{col 39}{bf:{ul:{err:underlined}}}" _c
	di "{col 57}{it:{err:error}}{col 65}{it:{ul:{err:underlined}}}"

	di "{col  5}{sf:{help conren:link}}" _c
	di "{col 13}{sf:{ul:{help conren:underlined}}}" _c
	di "{col 31}{bf:{help conren:link}}" _c
	di "{col 39}{bf:{ul:{help conren:underlined}}}" _c
	di "{col 57}{it:{help conren:link}}" _c
	di "{col 65}{it:{ul:{help conren:underlined}}}"

	di "{col  5}{sf:{hi:hilite}}{col 13}{sf:{ul:{hi:underlined}}}" _c
	di "{col 31}{bf:{hi:hilite}}{col 39}{bf:{ul:{hi:underlined}}}" _c
	di "{col 57}{it:{hi:hilite}}{col 65}{it:{ul:{hi:underlined}}}"
end

exit
