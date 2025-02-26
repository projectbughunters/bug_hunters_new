<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
<div class="youtube">
    <iframe src="https://www.youtube.com/embed?listType=playlist&list=PLT6yxVwBEbi0AKJXT8tseRoYHctKpD1Fj&autoplay=1&mute=1&controls=0&loop=1"
            title="YouTube video player" frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
            style="width: 100%; height: 100%;">
    </iframe>
</div>
	