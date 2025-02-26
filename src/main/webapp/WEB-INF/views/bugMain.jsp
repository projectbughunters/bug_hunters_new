<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<c:set var="root" value='${pageContext.request.contextPath }/' />   
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${root}css/bugMain.css"> 
	<link rel="stylesheet" href="${root}css/newsSection.css"> 
	<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="java.util.List"%>
    <title>Take Money Information | TMI</title>
</head>

<body>
    <!-- 상단 메뉴 은정 -->
    <c:import url="/WEB-INF/views/include/topMenu.jsp"/>
    
    <div class="primary-container">
        <!-- 광고 영역 ddddddd-->
        <c:import url="/WEB-INF/views/mainInclude/advertisement.jsp" />
        
        <!-- 뉴스 및 유튜브 영역 -->
        <div class="content-container">
            <c:import url="/WEB-INF/views/mainInclude/newsSection.jsp" />
            <c:import url="/WEB-INF/views/mainInclude/youtubeSection.jsp" />
        </div>
        
        <!-- 주식 및 코인 시장 영역 -->
        <div class="market-container">
		    <c:import url="/WEB-INF/views/mainInclude/stockSection.jsp" />
		    <c:import url="/WEB-INF/views/mainInclude/coinSection.jsp" />
		</div>
        
        <!-- 캘린더와 차트 영역 -->
        <div class="content-container">
            <c:import url="/WEB-INF/views/mainInclude/widgetSection.jsp" />
            <c:import url="/WEB-INF/views/mainInclude/productSection.jsp" />
        </div>
        
        
                  
        <!-- 즐겨찾기 영역 -->
        <c:import url="/WEB-INF/views/mainInclude/favoriteSection.jsp" />
        
        <!-- 거래소 영역 -->
        <c:import url="/WEB-INF/views/mainInclude/cyptoexchangeSection.jsp" />

    </div>
    
    <!-- 관련 스크립트 영역 -->
    <c:import url="/WEB-INF/views/mainInclude/scripts.jsp" />
    
    <!-- 하단 공통 영역 -->
    <c:import url="/WEB-INF/views/include/bottom.jsp" />

    

</body>

</html>
