<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	
<div class="widget">
    <h2>캘린더</h2>
    <iframe src="https://sslecal2.investing.com?columns=exc_flags,exc_currency,exc_importance,exc_actual,exc_forecast,exc_previous&amp;category=_employment,_economicActivity,_inflation,_credit,_centralBanks,_confidenceIndex,_balance,_Bonds&amp;importance=1,2,3&amp;features=datepicker,timezone,timeselector,filters&amp;countries=110,43,17,42,5,178,32,12,26,36,4,72,10,14,48,35,37,6,122,41,22,11,25,39&amp;calType=week&amp;timeZone=88&amp;lang=18"
            width="95%" height="100%" frameborder="0" allowtransparency="true"
            marginwidth="0" marginheight="0"></iframe>
</div>
	