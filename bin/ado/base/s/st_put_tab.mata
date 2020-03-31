*! version 1.0.2  11sep2017
version 15

* Stata friendly companion functions for Mata class -_put_tab-.
* See _put_tab.mata.

mata:

void st_put_tab_new(string scalar name, |real scalar remove)
{
	pointer(class _put_tab) scalar pT

	if (name != "") {
		pT = findexternal(name)
		if (pT != NULL) {
			if (remove == 1) {
				rmexternal(name)
			}
			else {
				errprintf("Mata object %s already exists", name)
				exit(110)
			}
		}
		pT = crexternal(name)
		(*pT) = _put_tab()
	}
}

void st_put_tab_remove(string scalar name)
{
	if (name != "") {
		rmexternal(name)
	}
}

void st_put_tab_init(string scalar name, scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->init(arg)
}

void st_put_tab_reset(string scalar name, scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->reset(arg)
}

void st_put_tab_status(string scalar name, string scalar note)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->status(note)
}

void st_put_tab_add_ctitles(
	string	scalar	name,
	string	scalar	corner,
	string	scalar	titles,
	|string	scalar	span)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	if (args() == 3) {
		pT->add_ctitles(corner, tokens(titles))
	}
	else {
		pT->add_ctitles(corner, tokens(titles), strtoreal(tokens(span)))
	}
}

void st_put_tab_reset_cspans(
	string	scalar	name,
	string	scalar	span)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->reset_cspans(strtoreal(tokens(span)))
}

void st_put_tab_set_cformats(string scalar name, string scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->set_cformats(tokens(arg))
}

void st_put_tab_add_row(string scalar name)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->add_row()
}

void st_put_tab_set_rformat(string scalar name, string scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->set_rformat(tokens(arg))
}

void st_put_tab_add_rtitle(string scalar name, scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->add_rtitle(arg)
}

void st_put_tab_add_ralign(string scalar name, scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->add_ralign(arg)
}

void st_put_tab_add_note(string scalar name, scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->add_note(arg)
}

void st_put_tab_add_cnotes(string scalar name, string scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->add_cnotes(tokens(arg))
}

void st_put_tab_set_sep(string scalar name)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->set_sep()
}

void st_put_tab_add_values(string scalar name, string scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}
	string	vector	v

	v = tokens(arg)
	if (c("dp") == "period") {
		v = subinstr(v, ",", "")
	}
	else {
		v = subinstr(v, ".", "")
		v = subinstr(v, ",", ".")
	}

	pT->add_values(strtoreal(v))
}

void st_put_tab_after_ms_eq_display(string scalar name, string scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->after_ms_eq_display(arg)
}

void st_put_tab_after_ms_display(string scalar name, string scalar arg)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->after_ms_display(arg)
}

void st_put_tab_post_results(
	string	scalar	name,
	string	scalar	prefix,
	string	scalar	suffix)
{
	pointer(class _put_tab) scalar pT

	pT = st_put_tab__find(name)
	if (pT == NULL) {
		return
	}

	pT->post_results(prefix, suffix)
}

// subroutines --------------------------------------------------------------

pointer(class _put_tab) scalar st_put_tab__find(string scalar name)
{
	if (name == "") {
		return(NULL)
	}
	return(findexternal(name))
}

end

exit
