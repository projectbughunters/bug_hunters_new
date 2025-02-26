<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap"
	rel="stylesheet">
	
<div class="favorite-container">
    <h1>즐겨찾기</h1>
    <table>
        <thead>
            <tr>
                <th>종목</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="favorite" items="${favorites}">
                <c:choose>
                    <c:when test="${favorite.type == 'stock'}">
                        <tr>
                            <td>
                                <a href="${root}stock/info/${favorite.symbol}">
                                    ${favorite.symbol}
                                </a>
                            </td>
                            <td>
                                <button class="delete-fav-btn" data-symbol="${favorite.symbol}" data-type="stock">삭제</button>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td>
                                <a href="${root}coin/info/${favorite.symbol}/${favorite.type}">
                                    ${favorite.symbol}
                                </a>
                            </td>
                            <td>
                                <button class="delete-fav-btn" data-symbol="${favorite.symbol}" data-type="${favorite.type}">삭제</button>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </tbody>
    </table>
</div>
	