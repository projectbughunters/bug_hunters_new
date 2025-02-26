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
<title>Portfolio | TMI</title>
<link rel="stylesheet" href="${root}css/portfolio.css">

<style type="text/css">
body {
	height: 100vh;
}
#portfolio-list, #portfolio-summary, #portfolio-chart, #portfolio-holdings{
	margin: 60px auto;
}

.portfolio-list, .portfolio-summary, .portfolio-chart,
	.portfolio-holdings {
	background-color: f8f8f8;
}

.footer {
	margin-top: 70px;
}
</style>
</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />
	<div class="primary-container">
	
	<form:form action="${root }portfolio/newPortfolio_pro" method="post" modelAttribute="newPortfolioBean">
						<div class="input-group">
							<form:label path="title">제목</form:label>
							<form:input path="title" class="form-control"  />
							<form:errors path="title" style="color:red" />
						</div>
						<div class="input-group">
							<form:label path="personal_tendency_code">투자 성향</form:label>
							<form:input path="personal_tendency_code" class="form-control" value="${profileBean.personal_tendency_code}" readonly="true"/>
							<form:errors path="personal_tendency_code" style="color:red" />
						</div>
						<div class="input-group">
						<form:hidden path="member_idx" value="${loginUserBean.member_idx}"/>
							<form:label path="member_name">생성자</form:label>
							<form:input path="member_name" class="form-control" value="${loginUserBean.member_name}" readonly="true"/>
							<form:errors path="member_name" style="color:red" />
						</div>
						<form:button type="submit" class="register-btn">포트폴리오 생성</form:button>
					</form:form>
					</div>

</body>
</html>