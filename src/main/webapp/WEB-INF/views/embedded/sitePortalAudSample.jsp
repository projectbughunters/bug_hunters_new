<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, user-scalable=no">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	
	<style>
		*{
			margin: 0;
		}
		.top_panel{
			position: absolute;
			width: 0%;
			height: 0%;
			background-color: white;
		}
		.left_panel{
			position: absolute;
			width: 250px;
			color:white;
			background-color: black;
			list-style: none;
		}
		.HideFrame {
			left: -50000px;
			top: -50000px;
			position: absolute;
		}
		.VisibleFrame {
			float: left;
			position: relative;
			overflow: hidden;
			left: 0px;
			top: 0px;
			width: 100%;
			height: 100%;
		}
	</style>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);

	request.setAttribute("aud7_server_url" , "http://192.168.1.1:8087");
    request.setAttribute("is_ssl" , false);
    request.setAttribute("user_id" , "bughunters");

%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
</head>
<body>
<script>
	
	window.onload = function() {
		console.log("onload");
		winResizer();
	}
	
	window.addEventListener('resize', function(event){
		winResizer();
	});

	var winResizer = function(){
		console.log('winResizer===');
		var win_w = $(window).eq(0).outerWidth();
		var win_h = $(window).eq(0).outerHeight();

		var top_panel_height = $('.top_panel').outerHeight();
		var left_panel_width = $('.left_panel').outerWidth();

		$('.left_panel').css('height', win_h - top_panel_height);
		$('.left_panel').css('top', top_panel_height);

		$('.main_group').css('height', win_h - top_panel_height);
		$('.main_group').css('top', top_panel_height);
		$('.main_group').css('left', left_panel_width);
		$('.main_group').css('width', win_w - left_panel_width);
		

	}

	var openReport = function(code , isTileShow , iframeId){
		$("#" + iframeId)[0].contentWindow.openReport(code , isTileShow);	
	
		$('.main_group').removeClass('SiteHideFrame').addClass('SiteVisibleFrame');
	}

	function openPopReport(reportCode){
		var winWidth = $( window ).width() - 100;
        var winHeight = $( window ).height() - 100;
		
        //window.open("http://192.168.11.45:9090/examples/embedded/iaudEmbedded.jsp?rCode="+reportCode+"&sTitle=true&audServerUrl=http://192.168.0.83:8083", "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes");
		//window.open("http://192.168.0.83:8083/portal/Content.jsp" , "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes")
		window.open("http://192.168.1.1:8087/extention/portal/SimpleSSO.jsp?reportCode="+reportCode, "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes");
   }

</script>

<div class="top_panel"></a>
</div>

<div class="left_panel">
<a href="${root}"><image src="${root}image/TMI_Y.png"
				style="width: 70px; height : 50px; margin-left: 70px; margin-top: 30px;" /></a>
	<ul>
		<li>
			<div class='rep_div' style="padding:10px 10px; padding-top: 100px; cursor:pointer;" onclick='openReport("REP4463E55E07C047729CAD7F4143840DC6", true , "REPORT_VIEW")'>방어주 주식 대시보드</div>
		</li>
		<li>
			<div class='rep_div' style="padding:10px 10px; cursor:pointer;" onclick='openReport("REP06B85EE4878A4EBE9FB400699514CD82", true,  "REPORT_VIEW")'>ESG 주식 대시보드</div>
		</li>
		<li>
			<div class='rep_div' style="padding:10px 10px; cursor:pointer;" onclick='openReport("REP59FFFDE5AD5248B393D6ACDF003E2FC2", true ,  "REPORT_VIEW")'>기술주 주식 대시보드</div>
		</li>
		<li>
			<div class='rep_div' style="padding:10px 10px; cursor:pointer;" onclick='openReport("REPFA2C0018A56749459181AB18721A07DE", true ,  "REPORT_VIEW")'>가치주 주식 대시보드</div>
		</li>
		<li>
			<div class='rep_div' style="padding:10px 10px; cursor:pointer;" onclick='openReport("REPEC3F075C8A54433994771C223E5C0544", true ,  "REPORT_VIEW")'>성장주 주식 대시보드</div>
		</li>
		<li>
			<div class='rep_div' style="padding:10px 10px; cursor:pointer;" onclick='openReport("REP826F800DC4EC435C9093CB7B8187B2D9" , true ,  "REPORT_VIEW")'>배당주 주식 대시보드</div>
		</li>		
	</ul>
</div>

<div class="main_group VisibleFrame">
	<iframe id="REPORT_VIEW" name="REPORT_VIEW"  width="100%" height="100%" frameborder="0"  src="http://localhost:9088/bugHunters_TMI/embedded/iaudEmbedded?audServerUrl=http://192.168.1.1:8087"></iframe>
</div>

</body>
</html>