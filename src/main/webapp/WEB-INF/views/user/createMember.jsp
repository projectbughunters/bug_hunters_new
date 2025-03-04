<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>   
<c:set var="root" value='${pageContext.request.contextPath }/' />   
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${root}css/createMember.css"> 
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
    <title>Take Money Information | TMI</title>
<script>
   function checkUserIdExist(){
      //변수선언 : 사용자가 입력한 id값 가져오기
      var member_id = $("#member_id").val()
      //아이디를 입력하지 않았을 경우
      if(member_id.length == 0){
         alert('아이디를 입력해주세요')
         return
      }
      
      $.ajax({
         //요청할 주소
         url : '${root}user/checkUserIdExist/' + member_id,
         //요청타입
         type : 'get',
         //응답결과
         dataType : 'text',
         //성공시 호출할 함수
         success : function(result){
            if(result.trim() == 'true'){
               alert('사용할 수 있는 아이디입니다')
               $("#userIdExist").val('true')
            } else if(result.trim() == 'false'){
               alert('사용할 수 없는 아이디 입니다')
               $("#userIdExist").val('false')
            }
         }
      })
   }
   //사용자 아이디란에 입력하면 무조건 false
   function resetUserIdExist(){
      $("#userIdExist").val('false')
   }
</script>
    
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <a href="${root}"><image src="${root}image/TMI_YB.png" style="width: 70px; height : 50px"/></a>
            <p>회원가입</p>
        </div>
        <form:form action="${root }user/createMember_pro" method="post" modelAttribute="joinUserBean">
						<form:hidden path="userIdExist"/>
						<div class="input-group">
							<form:label path="member_name">이름</form:label>
							<form:input path="member_name" class="form-control"/>
							<form:errors path="member_name" style="color:red" />
						</div>
						<div class="input-group">
							<form:label path="member_id">아이디</form:label>
							<div class="id-group">
	                        <form:input path="member_id" class='form-control' onkeypress="resetUserIdExist()"/>
	                           <div class="id-group">
	                              <button type="button" class="check-id-btn" onclick="checkUserIdExist()">중복확인</button>
	                           </div>
	                     	</div>
							<form:errors path="member_id" style="color:red"/>
						</div>
						<div class="input-group">
							<form:label path="password">비밀번호</form:label>
							<form:password path="password" class="form-control"/>
							<form:errors path="password" style="color:red" />
						</div>
						<div class="input-group">
							<form:label path="password2">비밀번호 확인</form:label>
							<form:password path="password2" class="form-control"/>
							<form:errors path="password2" style="color:red" />
						</div>
						<div class="input-group">
							<form:label path="birth">생년월일</form:label>
							<form:input path="birth" class="form-control" placeholder="20010101" />
							<form:errors path="birth" style="color:red" />
						</div>
						<div class="input-group">
							<form:label path="email">이메일</form:label>
							<form:input type="email" path="email" class="form-control"/>
							<form:errors path="email" style="color:red" />
						</div>
						<form:button type="submit" class="register-btn">회원가입</form:button>
					</form:form>
					
        <div class="login-link">
            이미 계정이 있으신가요? <a href="${root }user/login">로그인하기</a>
        </div>
    </div>

    <script>
        function checkId() {
            alert("아이디 중복 확인은 서버에서 처리됩니다.");
        }
    </script>
</body>
</html>
