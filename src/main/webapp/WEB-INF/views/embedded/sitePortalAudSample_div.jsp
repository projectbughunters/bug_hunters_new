<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.matrix.service.TokenService" %>
<%@ page import="com.matrix.service.AudSessionService" %>
<%@ page import="java.util.*" %>
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
			width: 100%;
			height: 50px;
			background-color: black;
		}
		.left_panel{
			position: absolute;
			width: 250px;
			background-color: darkgrey;
		}
		.HideFrame {
			left: -50000px;
			top: -50000px;
			position: absolute;
		}
		.VisibleFrame1 {
			float: left;
			position: relative;
			overflow: hidden;
			left: 0px;
			top: 0px;
			width: 100%;
			height: 100%;
		}
		#AUDview{
			position: absolute;
			width: 100%;
			height: 100%;
			overflow: auto;
		}
		.rep_div{
			cursor: pointer;
			font-size: 14px;
			font-weight: bold;
		}	
		#header {
  position: fixed;
  top: 0;
  right: 0;
  left: 0;
  width: 100%;
  min-width: 360px;
  background-color: #fff;
  z-index: 9;
}
	</style>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);

	/*********************************************
	 * 사용자 설정 영역
	 * serverUrl: AUD7 플랫폼 matrix 서버 주소 (사이트별로 상이하다)
	 * user_id : 임베디드 시 연동할 유저코드
	 * is_ssl : serverUrl이 https 인 경우에 true로 설정
	 **********************************************/
	String serverUrl = "http://192.168.1.1:8087"; // server url
	if (serverUrl == null || serverUrl == ""){
		out.print("audServerUrl check .. ");
		return;
	}
	/*********************************************
	 * 사용자 코드에 대한 커스텀 방법
	 * userCode : 사이트에서 userCode를 확인할 수 있는 정보 (ex:암호화된 key 등)
	 * 자체적은 sso 모듈을 통해 전달한 userCode를 복호화 처리 하여 AUD7플랫폼에 등록된 평문 userCode를 설정한다.
	 **********************************************/
	String userCode = request.getParameter("userCode") != null ? request.getParameter("userCode") : "matrix";

	String rCode = request.getParameter("rCode");
	String showTitle = request.getParameter("sTitle");
    request.setAttribute("aud7_server_url" , serverUrl);
    request.setAttribute("is_ssl" , false);
    request.setAttribute("user_id" , userCode);
	//0. 쿠키에 AUD7 인증 token이 존재하는지 확인한다.

	//1. AUD7 플랫폼용 token을 발생한다.
    String aud7Token = new TokenService().execute(request , response);
	//2. 인증정보에 저장된 path 일부 항목을 조회하여 script를 import 한다.
	request.setAttribute("token" , aud7Token);
    Map<String , String> audSessionInfo = new AudSessionService().execute(request , response);
    String AUD7_FULL_PATH = audSessionInfo.get("AUD7_FULL_PATH") ; 
    String AUD7_SKIN_CSS_PATH = audSessionInfo.get("AUD7_SKIN_CSS_PATH");
    String CUSTOM_PARAM = audSessionInfo.get("CUSTOM_PARAM");
	String PORTAL_THEME_CSS_PATH = audSessionInfo.get("PORTAL_THEME_CSS_PATH");

%>
<!-- i-AUD 보고서를 임베디드 할 때 적용시킬 AUD7 플랫폼용 소스 import -->

<script type="text/javascript" src="<%=AUD7_FULL_PATH%>/js/lib/audframework/release/bimatrix.lib.audframework.js"></script>
<script type="text/javascript" src="<%=AUD7_FULL_PATH%>/js/lib/audframework/release/bimatrix.module.audframework.js"></script>
<link rel="stylesheet" type="text/css" href="<%=AUD7_SKIN_CSS_PATH%>/bimatrix.module.audframework.css">

<!-- i-AUD 보고서 버튼 영역을 표현할 때 적용시킬 AUD7 플랫폼용 소스 import -->
<link rel="stylesheet" type="text/css" href="<%=serverUrl%>/portal/css/theme1/theme.css" />
<script type="text/javascript" src="<%=serverUrl%>/portal/js/jquery-3.6.0.min.js" flush="false"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/Base64.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/jquery.portal.common.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/authorityCheck_em.jsp"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.message.jsp"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.option.data.jsp"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.content.top.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/matrix.script.comm.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/matrix.script.content.em.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.content.bookmark.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.content.condition.js"></script>


<script type="text/javascript">
	var AUD7_PATH = "<%=AUD7_FULL_PATH%>";
	var AUD7_SETTING_PATH = "<%=AUD7_FULL_PATH%>";
	var globalParam = <%=CUSTOM_PARAM%> ;
	var gvWebRootName = "<%=serverUrl%>";
	var currUserId = "<%=userCode%>";
	var ispopupView = true;
	
	//GFN_AUTHORITY.USER_AUTH_INFO();

	var reportCode = "<%=rCode%>"; // 오픈할 보고서 코드
	var showTitle = false; // title , 버튼 영역 표시 여부
	if ("<%=showTitle%>" == "true")
		showTitle = true;
</script>
	
</head>
<body>
<script>
	
	window.addEventListener('resize', function(event){
		winResizer();
	});

	$(document).ready(function(){

	});
	
	window.onload = function() {
		console.log("onload");
		$("#titlebg_main").css('display','none');
		var biAccessToken = "<%=aud7Token%>";
		GFN_AUTHORITY.setCookie("bimatrix_accessToken" , biAccessToken)
		// 인증 자동 연장
		GFN_AUTHORITY.UpdateSession();
		console.log("===bi:"+gfnGetCookie("bimatrix_accessToken"));
		// 리사이징
		winResizer();
		if (reportCode != "null")
			openReport(reportCode , showTitle);
	}

	var winResizer = function(){
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

		var title_panel_height = $("#titlebg_main").outerHeight();
		var isHidden = $("#titlebg_main").css("display") === "none";
		if (isHidden)
			title_panel_height = 0;

		//$('.view_panel').css('height', win_h);
		//$('.view_panel').css('width', win_w );
		$('.view_panel').css({'width':win_w, 'position':'relative'});	//.offset({left: viewPanel_Left})

		$('#AUDview').css('height', win_h - title_panel_height);
	}
	

	/**
	 * resize 함수 호출 시 i-AUD 보고서를 리사이징 시킬 때 추가해줘야 할 함수
	 **/
	window.addEventListener('resize', function(event){
		winResizer();
		AUD.GetMainViewer().ViewerSizeChanged();
	});
	
	/**
	 * i-AUD 보고서 오픈
	 **/
	var openReport = function(_reportCode , isShow){
		reportCode = _reportCode;
		if (!GFN_AUTHORITY.CheckSession()){
			//alert("AUD7 Platform auth invalid. page refresh....");
			location.reload();
			return ;
		}

		GFN_AUTHORITY.USER_AUTH_INFO();

		if (globalParam.length > 0)
    		AUD.SetCustomParams(<%=CUSTOM_PARAM%>);
		
		if (isShow){
			var btn_type = "";
			if (GFN_OPTION.OP04_VIEW_BTN=='TEXT') btn_type = "text_type";
			else if(GFN_OPTION.OP04_VIEW_BTN=='IMAGE') btn_type = "img_type";
			$("#titlebg_main").css('display','');
			$('.topbtn_group').option_top('view_btn', {'btn_type': btn_type, 'callbackFn': settingTitle, 'embedded':true});
		}else{
			$("#titlebg_main").css('display','none');
		}
					
		AUD.Init(AudOpenReport);
	}

	/**
	 * i-AUD 보고서 오픈에 필요한 Init용 함수.
	 * AUD.LoadDocument ('div id명' , 보고서코드 , 2) ;
	 **/
	var AudOpenReport = function() {
		AUD.SetFileDialogCallback();
		AUD.LoadDocument('AUDview', reportCode, 2);
		if (globalParam.length > 0)
    		AUD.SetCustomParams(<%=CUSTOM_PARAM%>);
	}

	var settingTitle = function() {
		$("#titlebg_main").css('display','');
		$('.topbtn_group').option_top('setting_title', {'report_code': reportCode});
	}


	function openPopReport(reportCode){
		var winWidth = $( window ).width() - 100;
        var winHeight = $( window ).height() - 100 ;
			
        //window.open("http://192.168.11.45:9090/examples/embedded/iaudEmbedded.jsp?rCode="+reportCode+"&sTitle=true&audServerUrl=http://192.168.0.83:8083", "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes");
		//window.open("http://192.168.0.83:8083/portal/Content.jsp" , "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes")
		window.open("http://192.168.1.1:8087/extention/portal/SimpleSSO.jsp?reportCode="+reportCode, "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes");
   }

</script>

<div class="top_panel">
</div>

<div class="left_panel">
	<ul>
		<li>
			<div class='rep_div' onclick='openReport("REP64C80DCFDEEA430487163202CFBCB61A", true)'>[AUD7] Event Test4_Chart</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REPA0ACE7186FB7448C9254C99C488F905D", true)'>[AUD7] Event Test5_List-Grid</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REPD986E645FAEA491C8F723A9C3A14E941", false)'>[AUD7] Event Test8_MX-Grid</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REPE8A1A0CC379A4467A62E58BE74CEEF90", true)'>[AUD7] Event Test6_OlapGrid</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP6CDB152C8EDB425BA448524855F3DE23", true)'>커피_매출정보</div>
		</li>
		<li>
			<div class='rep_div' onclick='openPopReport("REP8B7C7FC3C04A47DD9F19D2B4F93EE0A9" , true)'>[MX-GRID] 달력 . 팝업으로 열기</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP89CAE7FA188744C685AF8C589138E031" , true)'>(i-Meta Viewer)커피 매출 정보2</div>
		</li>
	</ul>
</div>

<div class="main_group VisibleFrame1">
	<div class="view_panel">
		<div class="titlebg" id="titlebg_main">
			<div class="title_area">
				<ul><li><span id="dvReportName"></span></li></ul>
			</div><!-- title_area -->
			<div class="bookmark" id="bookmarkIcon" style="display:none;"></div>
			<!-- 현재 경로표시 영역 -->
			<div class="location" style="display:none;"></div>
			<div class="topbtn_group"></div>
		</div><!--// titlebg -->
		<div id="AUDview" name="AUDview" class="istudio-common-viewer"></div>
	</div>
</div>

</body>
</html>