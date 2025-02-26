<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var='root' value='${pageContext.request.contextPath}/'/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Take Money Information | TMI</title>
    <script type="text/javascript">
        alert('${message}');
        location.href="${root}user/myPage";
    </script>
</head>
<body>
</body>
</html>