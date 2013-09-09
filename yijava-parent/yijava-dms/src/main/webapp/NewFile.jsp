<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@include file="/jsp/common/base.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>视频管理</title>
<link rel="stylesheet" type="text/css" href="${resPath}skin/css/base.css">
</head>
<body leftmargin="8" topmargin="8" >
	<!--  快速转换位置按钮  -->
	<table width="98%" border="0" cellpadding="0" cellspacing="1" bgcolor="#D1DDAA" align="center">
		<tr>
			 <td height="26">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					  <td align="center">
				 </tr>
			</table>
			</td>
		</tr>
	</table>
	<form name="form2" action="${basePath}backend/video/addVideoAction.jhtml" method="post" encType="multipart/form-data">
		<table width="98%" border="0" cellpadding="2" cellspacing="1" bgcolor="#D1DDAA" align="center" style="margin-top:8px">
			<tr bgcolor="#E7E7E7">
				<td height="24" colspan="2" >&nbsp;添加视频&nbsp;</td>
			</tr>
			<tr style="height: 30px" align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">标题</td>
			  <td align="left"><input name="title" type="text" id="title" size="70" value="" class="np">&nbsp;&nbsp;&nbsp;&nbsp;时长：
			    <input name="videoTime" type="text" id="videoTime" size="10" value="" class="np"></td>
			</tr>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%" >简介</td>
			  <td align="left">
					<textarea rows="5" cols="80" name="summary"></textarea>
					&nbsp;&nbsp;如需段落换行，请在行间输入换行字符：&lt;br&gt;&lt;br&gt;</td>
			</tr>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">大缩略图</td>
				<td align="left">
					<input name="thumbImg2" type="hidden" id="thumbImg2">
					<%--
					<input name="resFile2"  type="file" id="resFile2" size="30" class="np">
					 --%>
					<div id="thumbImgEle2"></div>
					<img id="thumbImgD2" width="60" height="35" align="absmiddle" style="display:none"/>
					&nbsp;&nbsp;&nbsp;NEWS类视频的“NEWS大图”使用，图片280X430</td>
			</tr>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">小缩略图</td>
				<td align="left">
					<input name="thumbImg" type="hidden" id="thumbImg">
					<%--
					<input name="resFile"  type="file" id="resFile" size="30" class="np">
					--%>
					<div id="thumbImgEle"></div>
					<img id="thumbImgD" width="60" height="35" align="absmiddle" style="display:none"/>
					&nbsp;&nbsp;&nbsp;图片140X80</td>
			</tr>
			<%---
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">FLV路径</td>
				<td align="left">
					目录：
					<select	name="videoDict">
						<option value="China_report/" selected="selected">1----China_report</option>
						<option value="China_view/">2----China_view</option>
						<option value="Click_on_today/">3----Click_on_today</option>
						<option value="Economy_report/">4----Economy_report</option>
						<option value="Global_visitor/">5----Global_visitor</option>
						<option value="Green_voices/">6----Green_voices</option>
						<option value="Lifestyles/">7----Lifestyles</option>
						<option value="Quarterly_review/">8----Quarterly_review</option>
						<option value="Spotlight/">9----Spotlight</option>
						<option value="World_news/">10----World_news</option>
						<option value="World_Perspective/">11----World_Perspective</option>
						<option value="Latest_news/">12----Latest_News</option>
					</select>				
				</td>
			</tr>
			---%>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">视频来源</td>
				<td align="left">
					<input name="source" type="text" id="source" size="30" value="" class="np">&nbsp;
					<input type="button" onClick="setSource();" class="button" value="CNC">
					
					&nbsp;&nbsp;排序(越大越靠前):<input name="seq" type="text" id="seq" size="30" value="0" class="np">
				</td>
			</tr>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
			  <td>更新时间</td>
		      <td align="left"><input name="updateDate" type="text" id="updateDate"  value="${nowDate}" class="Wdate" onFocus="WdatePicker({readOnly:true,minDate:'${today}'})"></td>
		  </tr>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">视频分类</td>
				<td align="left">
					<select id="categoryId" name="categoryId" onChange="changeCategory()">
						<option value="12"> 请选择</option>
						<c:forEach var="category" items="${categorys}">
							<option value="${category.id}"> ${category.title}</option>
						</c:forEach>
					</select>
					视频文件名称（*.flv）：<input name="flvFile"  type="text" id="flvFile" size="50" class="np"></td>
			</tr>
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">相关视频</td>
				<td align="left">
					<input name="tag" type="text" id="tag" size="50" value="" class="np">&nbsp;&nbsp;&nbsp;多个相关视频使用“|”分开</td>
			</tr>
			<tr id="newsEle" style="height: 100px;display: none" align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">News:</td>
				<td align="left" >
					<font color="red">（如果类型为News，下列选择项可以使用）</font><br>
						关键词：
						<!-->select name="keyword">
							<option value="1">Politics</option>
							<option value="2">Business</option>
							<option value="3">Entertainment</option>
							<option value="4">Sci/Environment</option>
						</select><br-->
						发布NEWS大图:
						<input name="sendNewsIndex" type="hidden" id="isNewsIndex" value="1"/>
						<input id="isNewsIndexCheck" type="checkbox"  onclick="checkVideoIsNewsIndex()" class="np" />
						<br>
						发布DON’T MISS:
						<input name="recommend" type="hidden" id="isRecommend" value="1"/>
						<input id="isRecommendCheck" type="checkbox"  onclick="checkIsRecommend()" class="np" /></td>
			</tr>			
			<tr id="lastestNewsEle" align='center' style="height: 50px;display: none" bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">Lastest News:</td>
				<td align="left">
					<font color="red">（如果类型为Lastest News，下列选择项可以使用）</font><br>
					发布首页Lastest News:
					<select name="sendIndex">
						<option value="1">不发布</option>
						<option value="2">首页左文</option>
						<option value="3">首页右图</option>
					</select>
					<br></td>
			</tr>
			
			<tr id="specialNewsEle" style="height:50px;display: none" align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">SpecialNews:</td>
				<td align="left" >
					<font color="red">（如果类型为SpecialNews，下列选择项可以使用）</font><br>
						分类标签：
						<select name="keyword">
							<option value="5">Opinion</option>
							<option value="6">Focus</option>
							<option value="7">Toppic</option>
						</select></td>
			</tr>
			
			
			<tr id="InChinaNewsEle" style="height:50px;display: none" align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">in china:</td>
				<td align="left" >
					<font color="red">（如果类型为in china，下列选择项可以使用）</font><br>
						分类标签：
						<select name="keyword">
							<option value="8">Travel</option>
							<option value="9">Delicacy</option>
							<option value="10">Style</option>
						</select></td>
			</tr>		
			
			
					
			<tr  align='center'  bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%">位置标签:</td>
				<td align="left">					
						
						<input name="postion1" type="checkbox" id="postion1" value="1"/>
						首页显示A:						
						<input name="postion2" type="checkbox" id="postion2" value="1"/>
						首页显示B:						
						<input name="postion3" type="checkbox" id="postion3" value="1"/>
						二级页推荐:
					<br></td>
			</tr>
					
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td width="10%" >内容</td>
				<td align="left">
					<textarea rows="20" cols="100" name="content"></textarea></td>
			</tr>			
			<tr align='center' bgcolor="#FFFFFF" onMouseMove="javascript:this.bgColor='#FCFDEE';" onMouseOut="javascript:this.bgColor='#FFFFFF';" height="22" >
				<td align="center" colspan="2">
					<input  type="submit" id="title" size="10" value="保存" style="cursor: pointer;" ></td>
			</tr>	
		</table>
	</form>
</body>
<script type="text/javascript" src="${resPath}js/backend.js?v=20120304"></script>
<script type="text/javascript" src="${resPath}js/swfobject.js"></script>
<script type="text/javascript" src="${resPath}FCKeditor/fckeditor.js"></script>
<script language="javascript" type="text/javascript" src="${basePath}js/time_plugin/WdatePicker.js"></script>
<script type="text/javascript">
	
	window.onload=function(){
		var oFCKeditor = new FCKeditor('content') ;
		oFCKeditor.BasePath = '${basePath}'+"FCKeditor/";
		oFCKeditor.Height = 200;
		//oFCKeditor.BasePath   = "/FCKEditTest/fckeditor/";
		oFCKeditor.ToolbarSet = 'Basic' ;
		oFCKeditor.ReplaceTextarea();	
	}
	
	var webPath = '${basePath}';
	initUploader('thumbImgEle','thumbImg',350,30,1,3);
	initUploader('thumbImgEle2','thumbImg2',350,30,1,3);
	
	function setSource()
	{
		document.getElementById('source').value="CNC";
		
	}
</script>
</html>