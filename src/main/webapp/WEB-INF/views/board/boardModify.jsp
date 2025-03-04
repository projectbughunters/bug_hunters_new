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
<title>Notice | TMI</title>
<link rel="stylesheet" href="${root }css/boardModify.css">
</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />
<div class="primary-container">
	<div class="modify-container">
		<div class="modify-header">
			<h2>게시글 수정</h2>
			<div>
				<form:form class="modify-form" modelAttribute="boardBean" method="post" action="${root}board/boardModifyPro" enctype="multipart/form-data">
					<input type="hidden" name="board_idx" value="${boardBean.board_idx}" />

					<div class="form-group">
						<label for="type">카테고리</label>
						<form:select path="type" id="type" required="true">
							<option value="공지게시판" <c:if test="${boardBean.type == '공지게시판'}">selected</c:if>>공지게시판</option>
							<option value="자유게시판" <c:if test="${boardBean.type == '자유게시판'}">selected</c:if>>자유게시판</option>
							<option value="고객센터" <c:if test="${boardBean.type == '고객센터'}">selected</c:if>>고객센터 접수</option>
						</form:select>
					</div>

					<div class="form-group">
						<label for="title">제목</label>
						<form:input path="title" id="title" required="true" />
					</div>

					<div class="form-group">
						<label for="content">내용</label>
						<form:textarea path="content" id="content" required="true"></form:textarea>
					</div>
					<div class="form-group">
						<form:hidden path="content_file"/>
	                    <label for="file">파일 첨부</label>
	                    <form:input type="file" path="upload_file" id="file" />
	                    <c:if test="${not empty filePath}">
					        <div class="current-image">
					            <h3>현재 첨부된 이미지:</h3>
					            <img src="${root }${filePath}" alt="첨부 이미지" style="max-width:300px; height:auto;" />
					            <br/>
					               <p><input type="checkbox" name="deleteFile" value="true" />
					                이미지 삭제</p> 
					        </div>
					    </c:if>
                	</div>

					<div class="button-group">
						<form:button class="submit-btn">수정 완료</form:button>
						<button type="button" class="cancel-btn" onclick="history.back()">취소</button>
					</div>
				</form:form>
			</div>
		</div>
	</div>
</div>
	<c:import url="/WEB-INF/views/include/bottom.jsp" />
</body>
</html>
