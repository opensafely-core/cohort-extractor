*! version 1.0.2  16apr2019
version 10


mata:

string scalar ferrortext(real scalar userec)
{
	real scalar	ec

	ec = abs(userec)

	if (ec==1 | ec==612) return("unexpected end of file")
	if (ec==601) return("file not found")
	if (ec==602) return("file already exists")
	if (ec==603) return("file could not be opened")
	if (ec==608) return("file is read-only")
	if (ec==610) return("file not Stata format")
	if (ec==630) return("web files not supported by this version of Stata")
	if (ec==631) return("host not found")
	if (ec==632) return("web file not allowed in this context")
	if (ec==633) return("may not write to web file")
	if (ec==639) return("file transmission error -- checksums do not match")
	if (ec==660) return("proxy host not found")
	if (ec==661) return("host or file not found")
	if (ec==662) return("proxy server refused request to send")
	if (ec==663) return("remote connection to proxy failed")
	if (ec==665) return("could not set socket nonblocking")
	if (ec==667) return("wrong version of winsock.dll")
	if (ec==668) return("could not find valid winsock.dll or astsys0.lib")
	if (ec==669) return("invalid URL")
	if (ec==670) return("invalid network port number")
	if (ec==671) return("unknown network protocol")
	if (ec==672) return("server refused to send file")
	if (ec==673) return("authorization required by server")
	if (ec==674) return("unexpected response from server")
	if (ec==675) return("server reported server error")
	if (ec==676) return("server refused request to send")
	if (ec==677) return("remote connection failed -- see help {help r(677)} for troubleshooting")
	if (ec==678) return("could not open local network socket")
	if (ec==679) return("unexpected web error")
	if (ec==680) return("could not find valid odbc32.dll")
	if (ec==682) return("could not connect to ODBC data source name")
	if (ec==683) return("could not fetch variable in ODBC table")
	if (ec==684) return("could not find valid dlxapi32.dll")
	if (ec==691) return("I/O error")
	if (ec==699) return("insufficient disk space")

	if (ec==3601) return("invalid file handle")
	if (ec==3602) return("invalid filename")
	if (ec==3603) return("invalid file mode")
	if (ec==3611 | ec==681) return("too many open files")
	if (ec==3621) return("attempt to write read-only file")
	if (ec==3622) return("attempt to read write-only file")
	if (ec==3623) return("attempt to seek append-only file")
	if (ec==3698) return("file seek error")

	if (ec) return("I/O request refused by operating system")
	return("")
}

real scalar freturncode(real scalar userec)
{
	real scalar	ec

	ec = abs(userec)

	return(ec==1 ? 612 : ec)
}

end
