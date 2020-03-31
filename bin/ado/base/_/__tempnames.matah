*! version 1.0.1  05mar2018

local TEMPNAMES_VARIABLE	1
local TEMPNAMES_MATRIX		2
local TEMPNAMES_SCALAR		3
local TEMPNAMES_GENERIC		4

local TEMPNAMES_POST ("VAR","MAT","SC","TMP")
local TEMPNAMES_TYPES ("variable","matrix","scalar","tempname")

local TEMPNAMES_MAX_INDEX 65536

if "$TEMPNAMES_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

class __tempnames
{
    private:
	static real scalar m_index
	static string vector m_postfix

    protected:
	string scalar m_prefix
	string vector m_names
	real vector m_types

    public:
	static real scalar VARIABLE
	static real scalar MATRIX
	static real scalar SCALAR
	static real scalar GENERIC

    public:
	void new()
	void destroy()

	void set_prefix()
	string scalar new_name()
	void clear()
	real scalar index()
	string matrix names()
}

end

global TEMPNAMES_MATAH_INCLUDED 1

exit
