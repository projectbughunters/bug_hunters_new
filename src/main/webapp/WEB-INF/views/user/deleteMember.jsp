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
<link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
<title>Take Money Information | TMI</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="${root}css/deleteMember.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>
<div class="deleteMember-container">
        <div class="deleteMember-header">
            <a href="${root}"><image src="${root}image/TMI_YB.png" style="width: 70px; height : 50px"/></a>
            <p>회원탈퇴</p>
            <p>비밀번호를 입력해주세요.</p>
        </div>
        <form action="${root}user/deleteMember_pro" method="post">
        	<input type="hidden" id="member_idx" name="member_idx" value="${loginUserBean.member_idx }" />
        	<input type="hidden" id="member_id" name="member_id" value="${loginUserBean.member_id }" />
            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="find-btn">회원탈퇴</button>
        </form>
        
      </div>
</body>
</html>