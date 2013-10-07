<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/common/head.jsp"%>
</head>
<body class="easyui-layout">
	
	<div data-options="region:'north',border:false"
		style=" background: #ddd; ">
		<div id="settingsWrapper">
			    <table width="100%">
			        <tbody>
			            <tr>
			                <td>
			                    <div id="logon">
			                        <ul>
			                            <!--<li>巴德销售追踪系统</li>-->
			                        </ul>
			                    </div>
			                </td>
			                <td align="right">
			                    <div id="settings">
			                        <ul>
			                            <li>ddd</li>
			                            <li id="itemAddContent"><a href='/'>主页</a></li>
			                           	<li id="itemLogout">
			                                <div id="TopControl1_ctl00_Container" style="display:inline;">
			
											</div>
			                            </li>
			                        </ul>
			                    </div>
			                </td>
			            </tr>
			        </tbody>
			    </table>
			</div>

		<div id="menu">
			<jsp:include page="menu.jsp"></jsp:include>
		</div>
	</div>
	<div data-options="region:'west',split:true,title:'公司信息'"
		style="width: 150px; padding: 10px;">west content
	</div>
	<div
		data-options="region:'east',split:true,collapsed:false,title:'待处理事项',tools:'#treetool'"
		style="width: 200px; padding: 10px;">
			<ul id="tochecktree" class="easyui-tree" data-options="url:'${basePath}api/flowrecord/tocheck',method:'get',animate:true"></ul>
		</div>
	<div data-options="region:'south',border:false"
		style="height: 20px; background: #ddd; padding: 10px;"></div>
	<div id="mainPanle" data-options="region:'center',title:''">
		<div id="tabs" class="easyui-tabs"  fit="true" border="false" >
		<div title="首页" data-options="iconCls:'icon-help',closable:false" style="padding:20px;overflow:hidden;" id="home">
			<h1>Welcome to jQuery UI!</h1>
			</div>
		</div>
	</div>
	<div id="treetool">
		<a href="javascript:void(0)" class="icon-reload" onclick="javascript:checkReload();"></a>
		
	</div>
<script type="text/javascript">
$(document).ready(function(){
	$('#mm1').menu();  
});
$('#tochecktree').tree({
	onClick: function(node){
		if(node.id==trialflow_identifier_num)
		{
			alert("跳转到试用处理1");
		}
			
	}
});
function checkReload()
{  
	$('#tochecktree').tree('reload');
	
}
</script>
</body>
</html>