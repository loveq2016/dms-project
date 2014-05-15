<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>海利欧斯经销商管理系统</title>
<%@include file="/common/head.jsp"%>
</head>
<body class="easyui-layout">
	
	<div data-options="region:'north',border:false"
		style=" background: #ddd; ">
		<div id="settingsWrapper">
			   <table width="100%" >
			        <tbody>
			            <tr>
			                <td>
			                    <div id="logon">
			                        <ul>
			                            
			                        </ul>
			                    </div>
			                </td>
			                <td align="right">
			                    <div id="settings">
			                        <ul>
			                            <li>欢迎您,${user.realname}</li>
			                            <li id="itemAddContent"><a href='javascript:void(0)' onclick="javascript:toHome();">首页</a></li>
			                           	<li id="itemLogout"><a href='${basePath}api/sys/logout'>退出</a> </li>
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
	
	<div data-options="region:'south',border:false"
		style="height: 20px; background: #ddd; padding: 10px;"></div>
	<div id="mainPanle" data-options="region:'center',title:''">
		<div id="tabs" class="easyui-tabs"  fit="true" border="false" >
			<div title="首页" data-options="iconCls:'icon-home',closable:false" style="padding:1px;overflow:hidden;" id="home">				
				<iframe name="mainFrame" scrolling="no" frameborder="0"  src="home.jsp" style="width:100%;height:100%;"></iframe>			
			</div>
		</div>
	</div>
	
	
	<div id="tab-tools">
	
		<a href="javascript:void(0)" class="easyui-linkbutton" plain="true"  iconCls="icon-reload" onclick="javascript:ReloadTab();"></a>		
	</div>
	
	
	 <!--  >div id="dd" class="easyui-dialog" title="My Dialog" style="width:700px;height:500px;"
        data-options="iconCls:'icon-close',resizable:true,modal:true">
    		
    		<img alt="" src="resource/holiday/yuandan.jpg" width="486" height="364">
	</div--> 
<script type="text/javascript">
$(document).ready(function(){
	$('#mm1').menu(); 	
	//showImg();
	
	
});

/* $('#dd').dialog({
    title: '节日快乐',
    width: 500,
    height: 400,
    closed: false,
    cache: false,
    //href: 'resource/holiday/Christmas.gif',
    modal: false
}); */

function toHome()
{
	$('#tabs').tabs('select',"首页");
}

function illegal(XMLHttpRequest, textStatus, errorThrown)  
{  
    if(XMLHttpRequest.status==403){  
    	window.location = "common/nopermit.html";  
    }else if(XMLHttpRequest.status==500){  
    	window.location = "common/error.html";  
    }else if(XMLHttpRequest.status==408){  
    	window.location = "login.html";  
    }  
}  

$.ajaxSetup({"error":illegal});

$('#tabs').tabs({
	tools:'#tab-tools'
});


function ReloadTab()
{   
	
	var currTab =$('#tabs').tabs('getSelected');	
    var iframe = $(currTab.panel('options').content);
    var src = iframe.attr('src');
    if(src)
    	$('#tabs').tabs('update', { tab: currTab, options: { content: createFrame(src)} });
    else
    	$('#tabs').tabs('update', { tab: currTab, options: { content: createFrame("home.jsp")} });
	
}

function showImg()
{
	openUrl("resource/holiday/Christmas.gif");
	//window.open ('resource/holiday/Christmas.jpg','newwindow','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
}


function openUrl( url ){
    var f=document.createElement("form");
    f.setAttribute("action" , url );
    f.setAttribute("method" , 'get' );
    f.setAttribute("target" , '_black' );
    document.body.appendChild(f)
    f.submit();
 }
</script>
</body>
</html>