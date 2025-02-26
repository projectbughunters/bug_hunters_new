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
<title>Take Money Information | TMI</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="${root}css/findPassword.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>
    <div class="findPw-container">
        <div class="findPw-header">
            <h1><a href="${root }">TMI</a></h1>
            <p>비밀번호 찾기</p>
            <p>가입한 아이디와 이메일을 입력해주세요.</p>
        </div>
        <form action="${root}user/findPasswordResult" method="get">
            <div class="input-group">
                <label for="member_id">아이디</label>
                <input type="text" id="member_id" name="member_id" required>
            </div>
            <div class="input-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" required>
            </div>
            <button type="submit" class="find-btn">비밀번호 찾기</button>
        </form>
        <p class="notice">* 입력하신 이메일로 임시 비밀번호가 발송됩니다.</p>
        
        
        <div class="links">
            <a href="${root }user/login">로그인</a>
            <span class="divider">|</span>
            <a href="${root }user/findId">아이디 찾기</a>
            <span class="divider">|</span>
            <a href="${root }user/createMember">회원가입</a>
        </div>
    </div>
</body>


</html>
