<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value='${pageContext.request.contextPath}/'/>
<script type="text/javascript">
	alert("수정이 완료되었습니다.")
	location.href='${root}board/boardRead?board_idx=${board_idx}'
</script>