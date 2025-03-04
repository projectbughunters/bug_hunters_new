<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value='${pageContext.request.contextPath }/' />      
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${root}css/login.css"> 
    <link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
    <title>Take Money Information | TMI</title>
    
    
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <a href="${root}"><image src="${root}image/TMI_YB.png" style="width: 70px; height : 50px"/></a>
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
