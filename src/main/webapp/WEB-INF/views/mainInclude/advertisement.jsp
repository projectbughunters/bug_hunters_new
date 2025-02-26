<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value="${pageContext.request.contextPath}/" />

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>광고 슬라이더</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap" rel="stylesheet">

  <div class="advertisement-slider">
    <div class="advertisement-slides">
      <!-- 슬라이드 1 -->
      <div class="advertisement-slide">
          <div class="advertisement">
            <img class="adver-img" alt="" src="${root }image/advertisement1.png"/>
          </div>
      </div>
      <!-- 슬라이드 2 -->
      <div class="advertisement-slide">
          <div class="advertisement">
            <img class="adver-img" alt="" src="${root }image/advertisement2.png"/>
          </div>
      </div>
      <!-- 슬라이드 3 -->
      <div class="advertisement-slide">
          <div class="advertisement">

          </div>
      </div>
    </div>
    <!-- 좌우 화살표 버튼 -->
    <button class="advertisement-arrow advertisement-arrow-left">&#10094;</button>
    <button class="advertisement-arrow advertisement-arrow-right">&#10095;</button>
    <!-- 인디케이터 -->
    <div class="advertisement-indicators">
      <div class="advertisement-indicator active" data-index="0"></div>
      <div class="advertisement-indicator" data-index="1"></div>
      <div class="advertisement-indicator" data-index="2"></div>
    </div>
  </div>