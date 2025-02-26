<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value='${pageContext.request.contextPath}/'/>
<script type="text/javascript">
	alert("게시물이 성공적으로 저장되었습니다.")
	location.href="${root}board/boardMain"
</script>