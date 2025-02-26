<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${root}css/tendencyTest.css">
<title>TendencyTest | TMI</title>
</head>


<body>

    <c:import url="/WEB-INF/views/include/topMenu.jsp" />


	<c:if test="${not empty errorMessage}">
	    <div class="error">${errorMessage}</div>
	</c:if>


    <div class="container">
        <h2 style="text-align: center; margin-bottom: 30px;">투자성향 검사</h2>
        <form id="investmentForm" method="post" action="${root }portfolio/tendencyResult">
            <c:forEach var="question" items="${questions}">
                <div class="question-container">
                    <div class="question">${question.question}</div>
                    <div class="options">
                        <c:forEach var="option" items="${question.options}">
                            <label class="option">
                                <input type="radio" name="${question.id}" value="${option.value}" required> ${option.text}
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>

            <button type="submit" class="submit-btn">결과 확인하기</button>
        </form>
    </div>

    <c:import url="/WEB-INF/views/include/bottom.jsp" />
</body>
</html>