<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath }/" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
    <title>경제 뉴스 포털</title>
    <link rel="stylesheet" href="${root }css/stock.css" />
</head>
<body>

<c:import url="/WEB-INF/views/include/topMenu.jsp"/>

<form action="${root}stock/search">
    <input type="text" name="keyword" placeholder="Enter keyword" />
    <button type="submit">검색</button>
</form>

<div>
    <ul>
        <c:forEach var="stock" items="${stocks}">
            <li>
                Symbol: ${stock.symbol}, Name: ${stock.name}, Type: ${stock.type},
                Region: ${stock.region}, Currency: ${stock.currency}
            </li>
        </c:forEach>
    </ul>
</div>

<c:if test="${not empty error}">
    <div style="color: red;">${error}</div>
</c:if>

<c:import url="/WEB-INF/views/include/bottom.jsp"/>
</body>
</html>