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
<link rel="stylesheet" href="${root }css/boardWrite.css">
</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />

	<div class="write-container">
    <div class="write-header">
        <h2>글쓰기</h2>
        <div>
            <form:form class="write-form" modelAttribute="boardWriteBean" method="post" action="${root}board/boardWriteSuccess" enctype="multipart/form-data">

                <div class="form-group">
                    <label for="type">카테고리</label> 
                    <select id="type" name="type" required onchange="toggleComplainCategory(); updateType();">
                        <option value="" disabled selected>카테고리 선택</option>
                        <option value="공지게시판" hidden>공지게시판</option>
                        <option value="자유게시판">자유게시판</option>
                        <option value="고객센터">고객센터 접수</option>
                    </select>
                </div>
                
                <div id="complainCategoryContainer" style="display: none;">
                    <label for="complain_category">불편사항 선택</label> 
                    <select id="complain_category" name="complain_category">
                        <option value="" disabled selected>불편사항 선택</option>
                        <option value="정보오류 신고 및 정정">정보오류 신고 및 정정</option>
                        <option value="로그인 관련 사항">로그인 관련 사항</option>
                        <option value="기타 문의">기타 문의</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="title">제목</label>
                    <form:input path="title" id="title" required="true" placeholder="제목을 입력하세요" />
                </div>

                <div class="form-group">
                    <label for="content">내용</label>
                    <form:textarea path="content" id="content" required="true" placeholder="내용을 입력하세요"></form:textarea>
                </div>

                <div class="form-group">
                    <label for="file">파일 첨부</label>
                    <form:input type="file" path="upload_file" id="file" accept="image/*"/>
                </div>

                <div class="button-group">
                    <form:button class="submit-btn">등록</form:button>
                    <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
                </div>
            </form:form>
        </div>
    </div>
</div>




	<c:import url="/WEB-INF/views/include/bottom.jsp" />

	<script>
		function toggleComplainCategory() {
			var categorySelect = document.getElementById('type');
			var complainCategoryContainer = document
					.getElementById('complainCategoryContainer');

			if (categorySelect.value === '고객센터') {
				complainCategoryContainer.style.display = 'block';
			} else {
				complainCategoryContainer.style.display = 'none';
			}
		}

		function updateType() {
			var categorySelect = document.getElementById("type");
			var typeInput = document.getElementById("type"); // type 값을 저장할 input 필드
			var selectedCategoryDisplay = document
					.getElementById("selectedCategory"); // 선택한 카테고리를 표시할 부분

			// 선택한 카테고리 표시
			if (categorySelect.value) {
				selectedCategoryDisplay.textContent = "선택한 카테고리: "
						+ categorySelect.value;
			} else {
				selectedCategoryDisplay.textContent = ""; // 선택이 없을 경우 비움
			}

			// type 값을 설정
			if (categorySelect.value === "고객센터") {
				typeInput.value = "serviceCenter"; // 고객센터 선택 시
			} else {
				typeInput.value = "board"; // 선택하지 않았을 때
			}
		}
	</script>

</body>
</html>
