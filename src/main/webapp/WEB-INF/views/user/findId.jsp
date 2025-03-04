<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>   
<c:set var="root" value='${pageContext.request.contextPath }/' />   

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
    <title>Take Money Information | TMI</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${root}css/findId.css"> 

</head>
<body>
    <div class="findId-container">
        <div class="findId-header">
            <a href="${root}"><image src="${root}image/TMI_YB.png" style="width: 70px; height : 50px"/></a>
            <p>아이디 찾기</p>
            <p>회원가입 시 입력한 이름과 이메일을 입력해주세요.</p>
            <br/>
            <c:if test="${submitted }">
	            <c:if test="${fail}">
	            	<div>
	            		<h3>ERROR</h3>
	            		<p>이름과 이메일을 확인해주세요.</p>
	            	</div>
	            </c:if>		
	            <c:if test="${!fail}">
	            	<div>
	            		<h3>
	            		<c:out value="${member_name}님의 아이디는"/>
	            		<br/>
	            		<c:out value="${member_id}입니다."/>
	            		</h3>
	            	</div>
	            </c:if>		
   			</c:if>
        </div>
      	
		<div>
		    <form:form action="${root}user/findId_pro" method="post" modelAttribute="tempLoginUserBean">
		        <div class="input-group">
		            <label for="member_name">이름</label>
		            <form:input path="member_name" id="member_name" required="required" />
		        </div>
		        <div class="input-group">
		            <label for="email">이메일</label>
		            <form:input path="email" id="email" required="required" />
		        </div>
		        <button type="submit" class="find-btn">아이디 찾기</button>
		    </form:form>
		</div>

        <div class="links">
            <a href="${root }user/login">로그인</a>
            <span class="divider">|</span>
            <a href="${root }user/findPassword">비밀번호 찾기</a>
            <span class="divider">|</span>
            <a href="${root }user/createMember">회원가입</a>
        </div>
    </div>
</body>
</html>
