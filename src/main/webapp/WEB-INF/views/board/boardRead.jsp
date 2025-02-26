<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notice | TMI</title>
<link rel="stylesheet" href="${root}css/boardRead.css">
<script>
function confirmDelete(boardIdx) {
    if (confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
        window.location.href = "${root}board/boardDelete?board_idx=" + boardIdx;
    }
}
</script>
</head>
<body>

<c:import url="/WEB-INF/views/include/topMenu.jsp" />
<div class="primary-container">
<div class="read-container">
    <div class="read-header">
        <h2>게시글 읽기</h2>
        <div class="info-row">
            <div class="form-group">
                <label for="type">카테고리</label>
                <p class="small">${boardBean.type}</p>
            </div>
            <c:if test="${boardBean.type eq '고객센터'}">
			    <div class="form-group">
			        <label for="type">불편사항</label>
			        <p class="small">${boardBean.complain_category}</p>
			    </div>
			</c:if>
            <div class="form-group">
                <label for="writeDate">작성일</label>
                <p class="small">${boardBean.write_date}</p>
            </div>
            <div class="form-group">
                <label for="memberId">작성자</label>
                <p class="small">${boardBean.member_id}</p>
            </div>
        </div>
        

        <div class="form-group">
            <label for="title">제목</label>
            <p class="content title">${boardBean.title}</p> 
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <p class="content">${boardBean.content}</p>
        </div>
        
       <div class="form-group">
		    <label for="file">파일 첨부</label>
		    <c:if test="${not empty filePath}">
		        <img src="${root}${filePath}" alt="첨부된 이미지" class="file-attachment" />
		    </c:if>
		    <c:if test="${empty filePath}">
		        <p>첨부된 이미지가 없습니다.</p>
		    </c:if>
		</div>

        
        <div class="stats-row">
            <div class="form-group">
                <label for="viewCount">조회수</label>
                <p class="small">${boardBean.view_count}</p>
            </div>
            <div class="form-group">
			    <label for="likeCount">추천수</label>
			    <p class="small" id="likeCount">${boardBean.like_count}</p>
			 </div>
			 <div class="form-group">
			   	<button id="recommend" type="button" onclick="incrementLikeCount(${boardBean.board_idx});">👍🏻</button>
			 </div> 
		</div>
		<div class="comment-section">
		    <form:form action="${root}board/commentAdd" method="post" modelAttribute="commentBean">
		        <form:hidden path="board_idx" value="${commentBean.board_idx}" />
		        <form:hidden path="comment_idx" value="${commentBean.comment_idx}"/>
		        <form:hidden path="member_idx" value="${loginUserBean.member_idx}"/>
		        <div class="comment-input">
		            <label for="content">댓글</label>
		            <form:textarea id="comment_content" path="comment_content" rows="4" required="required" 
		                           disabled="${loginUserBean.userLogin==false}"></form:textarea>
		        </div>
		        <button type="submit" ${loginUserBean.userLogin==false ? 'disabled' : ''}>댓글 작성</button>
		    </form:form>
		</div>
	<div class="comment-section">
		<c:if test="${loginUserBean.userLogin==false}">
		    <p>로그인 후 댓글을 작성할 수 있습니다.</p>
		</c:if>
	</div>	
		<!-- 댓글 목록 -->
		<div class="comment-section">
		    <h3>댓글 목록</h3>
		    <c:choose>
		        <c:when test="${not empty commentList}">
		            <c:forEach var="comment" items="${commentList}">
		                <div class="comment">
		                    <p>
				                <strong>
				                    ${userIdMap[comment.member_idx]} <!-- member_idx에 해당하는 user_id를 가져옵니다. -->
				                </strong> (${comment.comment_time})
				            </p> 
		                    <!-- 기존 댓글 내용 -->
		                    <p id="comment-text-${comment.comment_idx}">${comment.comment_content}</p>
		
		                    <!-- 수정 폼 (초기에는 숨김) -->
		                    <form:form action="${root}board/commentUpdate" method="post" modelAttribute="commentBean"
		                               id="edit-form-${comment.comment_idx}" style="display:none;">
		                        <form:hidden path="comment_idx" value="${comment.comment_idx}" />
		                        <form:hidden path="board_idx" value="${comment.board_idx}" />
		                        <form:input path="comment_content" value="${comment.comment_content}" />
		                        <button type="submit">저장</button>
		                    </form:form>
		
		                    <!-- 버튼 영역 -->
		                    <c:if test="${comment.member_idx == loginUserBean.member_idx && loginUserBean.userLogin==true}">
		                        <button onclick="editComment(${comment.comment_idx})">수정</button>
		                        <form:form action="${root}board/commentDelete" method="post" modelAttribute="commentBean" style="display:inline;">
		                            <form:hidden path="comment_idx" value="${comment.comment_idx}" />
		                            <form:hidden path="board_idx" value="${comment.board_idx}" />
		                            <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
		                        </form:form>
		                    </c:if>
		                </div>
		                <hr>
		            </c:forEach>
		        </c:when>
		        <c:otherwise>
		            <p>등록된 댓글이 없습니다.</p>
		        </c:otherwise>
		    </c:choose>
		</div>
		</div>
		
        <!-- 수정 및 삭제 버튼 -->
        <c:if test="${boardBean.member_idx == loginUserBean.member_idx}">
            <div class="button-group">
                <button type="button" onclick="window.location.href='${root}board/boardModify?board_idx=${boardBean.board_idx}'">수정</button>
                <button type="button" onclick="confirmDelete(${boardBean.board_idx})">삭제</button>
            </div>
        </c:if>

        <div class="button-group">
            <button type="button" class="back-btn" onclick="window.location.href='${root}board/boardMain'">게시글 목록</button>
        </div>
    </div>

</div>
<c:import url="/WEB-INF/views/include/bottom.jsp" />

<script>
function editComment(commentIdx) {
    let commentContent = document.getElementById("comment-text-" + commentIdx);
    let editForm = document.getElementById("edit-form-" + commentIdx);
    
    // 기존 텍스트 숨기고 폼 표시
    commentContent.style.display = "none";
    editForm.style.display = "block";
}


function incrementLikeCount(boardIdx) {
    $.ajax({
        url: '${root}board/incrementLikeCount', // 추천수를 증가시키는 API URL
        type: 'POST',
        data: { board_idx: boardIdx }, // board_idx를 데이터로 보냄
        success: function(response) {
            // 성공적으로 응답을 받으면 추천수 업데이트
            $('#likeCount').text(response.newLikeCount); // 서버에서 새로운 추천수를 받는다고 가정
        },
        error: function(xhr, status, error) {
            console.error("추천수 증가 실패:", error);
            alert("추천수 증가에 실패했습니다.");
        }
    });
}
</script>


</body>
</html>
