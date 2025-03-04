<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${root}css/tendencyResult.css">
<link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
<title>TendencyResult | TMI</title>
    
</head>

<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp" />
    <div class="result-container">
        <h1 id="result-title">투자 성향 분석 결과</h1>
        <p>당신의 점수는 <strong>${total}</strong>점이며,</p>
        <p><strong>${type}</strong> 투자자입니다.</p>
        <p>${description}</p>
    <button onclick="location.href='${root }portfolio/portfolioMain'" type="button">내 포트폴리오 생성하기</button>
    </div>

</body>
</html>
