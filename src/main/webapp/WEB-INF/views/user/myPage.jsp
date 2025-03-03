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

<link rel="stylesheet" href="${root}css/myPage.css">
<title>Take Money Information | TMI</title>

</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />

	<div class="mypage-container">
		<div class="profile-section">
			<h2>회원 정보</h2>
			<div class="info-group">
				<span class="info-label">아이디</span><span class="info-value">${loginUserBean.member_id }</span>
			</div>
			<div class="info-group">
				<span class="info-label">이름</span> <span class="info-value">${loginUserBean.member_name }</span>
			</div>
			<div class="info-group">
				<span class="info-label">생년월일</span> <span class="info-value">${loginUserBean.birth }</span>
			</div>
			<div class="info-group">
				<span class="info-label">이메일</span> <span class="info-value">${loginUserBean.email }</span>
			</div>
			<div class="info-group">
				<span class="info-label">투자성향</span> <span class="info-value">${profileBean.personal_tendency_code }</span>
			</div>
			<div class="info-group">
				<span class="info-label">생성날짜</span> <span class="info-value">${profileBean.created_at }</span>
			</div>
			<button class="submit-btn" onclick="location.href='${root}user/deleteMember'">회원탈퇴</button>
		</div>

		<div class="password-section">
			<h2>비밀번호 변경</h2>
			<form:form class="password-form" action="${root}user/changePassword" method="post" modelAttribute="tempLoginUserBean">
				<div class="form-group">
					<form:label path="password">현재 비밀번호</form:label> 
					<form:password path="password" id="password" required="true"/>
				</div>
				<div class="form-group">
					<form:label path="password2">새 비밀번호</form:label> 
					<form:password path="password2" id="password2" required="true"/>
				</div>
				<div class="form-group">
					<label for="confirmPassword">비밀번호 확인</label> 
					<input type="password" id="confirmPassword" name="confirmPassword" required/>
				</div>
				<form:button type="submit" class="submit-btn">비밀번호 변경</form:button>
			</form:form>
		</div>
	</div>

	<c:import url="/WEB-INF/views/include/bottom.jsp" />


	<script type="text/javascript">
	
		function validatePasswords() {
			const newPassword = document.querySelector('input[id="password2"]').value;
			const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
			
			if (newPassword !== confirmPassword){
				alert("변경하려는 비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
				return false;
			}
			return true;
		}
	
	</script>

</body>
</html>