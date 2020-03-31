*! version 1.0.1  05mar2018

findfile __tempnames.matah
quietly include `"`r(fn)'"'


mata:

void __tempnames::new()
{
	if (missing(m_index)) {
		m_index = 0
		VARIABLE = `TEMPNAMES_VARIABLE'
		MATRIX = `TEMPNAMES_MATRIX'
		SCALAR = `TEMPNAMES_SCALAR'
		GENERIC = `TEMPNAMES_GENERIC'
		m_postfix = `TEMPNAMES_POST'
	}
	m_names = J(1,0,"")
	m_types = J(1,0,0)
}

void __tempnames::destroy()
{
	clear()
}

void __tempnames::clear()
{
	real scalar i, k, ivar

	k = length(m_names)
	for (i=1; i<=k; i++) {
		if (m_types[i] == VARIABLE) {
			if (!missing(ivar=_st_varindex(m_names[i]))) {
				st_dropvar(ivar)
			}
		}
		else if (m_types[i] == MATRIX) {
			st_matrix(m_names[i],J(0,0,.))
		}
		else if (m_types[i] == SCALAR) {
			st_numscalar(m_names[i],J(0,0,.))
		}
	}
	m_names = J(1,0,"")
	m_types = J(1,0,0)
}

real scalar __tempnames::index()
{
	return(m_index)
}

string matrix __tempnames::names()
{
	real scalar k
	string vector types
	string matrix names

	k = length(m_names)
	if (!k) {
		return(J(0,2,""))
	}
	types = `TEMPNAMES_TYPES'
	names = (m_names',types[m_types]')

	return(names)
}

void __tempnames::set_prefix(string scalar prefix)
{
	m_prefix = prefix
}

string scalar __tempnames::new_name(real scalar type)
{
	string scalar name

	if (type!=VARIABLE & type!=MATRIX & type!=SCALAR) {
		return("")
	}
	/* prevent overflow on counter
	 * assumption: older variables have been released		
	 * 		small chance of collision			*/
	m_index = mod(m_index,`TEMPNAMES_MAX_INDEX') + 1
	name = sprintf("__%s_%s_%g",m_prefix,m_postfix[type],m_index)
	m_names = (m_names,name)
	m_types = (m_types,type)

	return(name)
}

end

exit
