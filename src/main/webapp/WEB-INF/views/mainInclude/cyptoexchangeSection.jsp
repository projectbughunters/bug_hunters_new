<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <div class="cyptoexchange-section">
    <h2 id="crypto-title">암호화폐 거래소</h2>
    <ul id="cyptoexchangeList">
      <c:forEach var="cyptoexchange" items="${cyptoexchangeList}">
        <li class="cyptoexchange-item">
          <a href="${cyptoexchange.url}" target="_blank">
            <img src="${root}image/${cyptoexchange.image}" alt="${cyptoexchange.name}" />
          </a>
        </li>
      </c:forEach>
    </ul>
  </div>

