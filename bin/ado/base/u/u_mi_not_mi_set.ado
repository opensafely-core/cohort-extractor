*! version 1.1.2  26oct2015
/*
	u_mi_not_mi_set <name> [other]

	For use by set commands outside the -mi- system.
	Verifies data are not -mi set- and, if they are, issues the 
	error message "you must use -mi <name>- to set or query these data.

	See detailed explanation below.
*/

program u_mi_not_mi_set 
	version 11
	args name other

	if ("`_dta[_mi_marker]'"=="") {
		exit
	}
	if ("$MI_IMPUTE_user"!="") { // do not perform this check 
				     // if commands are called from
				     // user-defined imputation methods
		if ($MI_IMPUTE_user==1) {
			exit
		}
	}

	di as err "no; data are {bf:mi set}"

	di as err "{p 4 4 2}"

	if ("`other'" != "") {
		di as err ///
		"Use {bf:mi `name'} to perform {bf:`name'} on these data."
		di as err ///
		"{bf:mi `name'} has the same syntax as {bf:`name'}."
		di as err
		di as err "{p 4 4 2}"
		di as err "Perhaps you did not type {bf:`name'}."
		di as err ///
		"In that case, the command you typed calls {bf:`name'}"
		di as err "and it is not appropriate for use with {bf:mi} data."
	}
	else {
		di as err ///
		"Use {bf:mi `name'} to set or query these data;"
		di as err ///
		"{bf:mi `name'} has the same syntax as {bf:`name'}."
		di as err
		di as err "{p 4 4 2}"
		di as err "Perhaps you did not type {bf:`name'}."
		di as err "Some commands call {bf:`name'} to obtain information"
		di as err "about the settings.  In that case, that command is"
		di as err ///
		"not appropriate for running directly on {bf:mi} data."
	}
	di as err "Use {bf:mi extract}"
	if ("`other'"!="") {
		di as err "or {bf:mi xeq}"
	}
	di as err ///
	"to select the data on which you want to run the command, which"
	di as err "is probably {it:m}=0."
	di as err "{p_end}"
	exit 119
end
exit

/*
    This description explains use of -u_mi_not_mi_set <name>- when the 
    second argument is left blank.  See comment below when specified 
    with a second argument.

    Problem:
	To ensure that set commands such as stset, svyset, ..., 
	do not set imputed or passive variables if the data are 
	-mi set-

    Solution:
        Let's refer to this set command as xyzset.
        xyzset should be written as follows, 
	    
		program <xyzsetcmd_or_utility_thereof>
			...
			... parsing to include option -mi-
			...
			if ("`mi'"=="") {
				u_mi_not_mi_set "xyzset"
				local checkvars "*"
			}
			else {
				local checkvars "u_mi_check_setvars settime"
			}
			...

			`checkvars' ...
			...
			`checkvars' ...
			...
		end

    That is, 

        0.  Argument "xyzset" on u_mi_not_mi_set should be such that 
	    "xyzset" would execute the xyz set command.  If it is two
            words, that's fine; specify u_mi_not_mi_set "xyz set".

        1.  The xyz set command should allow option -mi-, which is not
            advertised.  The -mi- system will call the xyz set command
            using option -mi-.

	2.  If option -mi- is not specified, then a user is calling the 
            xyz set command and xyz set is to run only if the data are not 
            -mi set-.  This is verified by utility -u_mi_not_mi_set-.

        3.  If option -mi- is specified, then the xyz set command is being
            run by -mi-.  Use -u_mi_check_setvars settime- to verify that 
            the xyz set variables are not imputed or passive.

    Syntax of u_mi_check_setvars is

	    u_mi_check_setvars {settime|runtime} "<setcmdname>" [varlist]

                <setcmdname> is the set command name, such as "xyzset" or
		"xyz set".  May omit quotes if one word.

	    	varlist is optional; if not specified, no error is issued.
	

    In addition, the xyz set command is to provide another call with a name of
    its choosing which will be called only under the condition that the data
    are -mi set-; the data might not be xyz set.  This routine is to verify 
    that if the data are xyz set, the xyz variables are still not 
    imputed or passive.  It is to do this using the same 
    u_mi_check_setvars routine, but specifying -runtime- instead of -settime-.

    -mi- system note:  The second utility is run by u_mi_setcheck_runtime
    only.

/*
    This command explains use of -u_mi_not_mi_set <name> other-.
    See command above when other is not specified.

    -u_mi_not_mi_set <name> other- was created for use by commands
    for which -mi <command>- exits and we want to ensure that 
    <command> without the prefix is not run with mi data.  -stsplit- 
    is an example.  We include near the top of the code for -stsplit-:

		u_mi_not_mi_set stsplit other

    The other option changes the text of the error message to be 
    more appropriate for non-set commands.
*/
