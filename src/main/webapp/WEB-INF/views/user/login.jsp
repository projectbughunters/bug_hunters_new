<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value='${pageContext.request.contextPath }/' />      
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${root}css/login.css"> 
    
    <title>Take Money Information | TMI</title>
    <style type="text/css">
    	.alert-danger {
    background-color: #ffe6e6; /* 밝은 빨간색 배경 */
    color: #d9534f; /* 경고용 빨간 텍스트 */
    border: 1px solid #f5c6cb; /* 부드러운 경계선 */
    border-radius: 5px; /* 둥근 모서리 */
    padding: 15px; /* 여백 */
    margin-bottom: 20px; /* 아래 여백 */
    text-align: center; /* 텍스트 가운데 정렬 */
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* 약간의 그림자 효과 */
    font-size: 14px; /* 텍스트 크기 */
}

.alert-danger h3 {
    font-size: 18px; /* 제목 크기 */
    margin-bottom: 10px; /* 아래 여백 */
    color: #d9534f; /* 제목 색상 */
    font-weight: 700; /* 굵은 글씨 */
}

.alert-danger p {
    margin: 0; /* 기본 여백 제거 */
    color: #d9534f; /* 문단 텍스트 색상 */
}
    	
    </style>
    
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1><a href="${root }">TMI</a></h1>
            <p>로그인하여 서비스를 이용하세요</p>
            <c:if test="${fail == true }">
                     <div class="alert-danger">
                     <!-- xss방지 입력값이 출력되기전에 HTML 이스케이프 처리를 적용 -->
                          <h3>로그인 실패</h3>
                          <c:if test="${not empty errorMessage}">
                              <p>${errorMessage}</p>
                          </c:if>
                          <c:if test="${empty errorMessage}">
                              <p>아이디와 비밀번호를 확인해주세요.</p>
    						  <p>로그인 실패 횟수: <c:out value="${failCount}" /></p>
                          </c:if>
                      </div>
                  </c:if>
        </div>
        <form:form action="${root }user/login_pro" method="post" modelAttribute="tempLoginUserBean">
					<!-- csrf 토큰값 전송-> 서버로 전송된 토큰값은 클라이언트 요청을 매칭하여 검증한다 -->
					 <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<div class="input-group">
					         <form:label path="member_id">아이디</form:label>
					         <form:input path="member_id" class='form-control'/>
					         <form:errors path='member_id' style='color:red'/>
				      	</div>
					    <div class="input-group">
					         <form:label path="password">비밀번호</form:label>
					         <form:password path="password" class='form-control'/>
					         <form:errors path='password' style='color:red'/>
					    </div>
					    <button type="submit" class="login-btn">로그인</button>
					</form:form>
					<button type="button" class="googleLogin-btn" onclick="location.href='${root}google/login'">구글 로그인</button>
        <div class="links">
            <a href="${root }user/createMember">회원가입</a>
            <span class="divider">|</span>
            <a href="${root }user/findId">아이디 찾기</a>
            <span class="divider">|</span>
            <a href="${root }user/findPassword">비밀번호 찾기</a>
        </div>
    </div>
</body>
</html>
