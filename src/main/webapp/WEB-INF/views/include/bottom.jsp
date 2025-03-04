<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />

<link rel="stylesheet" href="${root}css/bottom.css">


<footer>
	<div class="footer">
		<p>&copy; 2024 BugHunters. All rights reserved.  </p>
	<div id="admin">
		<c:if test="${loginUserBean.member_idx == 10000}">
        <a href="http://localhost:5173">관리자 페이지</a>
    	</c:if>
	</div>
	</div>
</footer>