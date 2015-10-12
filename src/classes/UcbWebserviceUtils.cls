global with sharing class UcbWebserviceUtils {

    global final static Integer STATUS_OK = 200;
    global final static Integer STATUS_CREATED = 201;
    global final static Integer STATUS_ACCEPTED = 202;
    global final static Integer STATUS_BAD = 400;
    global final static Integer STATUS_FORBIDDEN = 403;
    global final static Integer STATUS_NOTFOUND = 404;
    global final static Integer STATUS_NOTALLOWED = 405;
    global final static Integer STATUS_ISE = 500;

    public virtual class UnknownException extends UcbExceptions.UnknownException {}
    public virtual class BadException extends UcbExceptions.BadException {}


	public UcbWebserviceUtils() {
		/** Return codes to for returnCdoe */
	}


}