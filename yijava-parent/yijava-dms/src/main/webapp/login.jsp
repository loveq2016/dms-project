<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/common/head.jsp"%>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<div class="easyui-panel" title="查询条件">
					<div style="padding: 10px 0 0 60px">
						<form id="ffadd" action="" method="post" enctype="multipart/form-data">
							<table>
								<tr>
									<td width="50">账户:</td>
									<td>
										<input hidden="true" name="id"></input>
										<input class="easyui-validatebox" type="text" name="account" data-options="required:true"></input>
									</td>
								</tr>
								<tr>
									<td>密码:</td>
									<td>
										<input class="easyui-validatebox" type="password" name="password" data-options="required:true"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="login()">登录</a>   
					</div>
				</div>
			</div>
			
		</div>
	<script type="text/javascript">
		function login() {
			$.ajax({
				type : "POST",
				url : basePath+"api/sys/login",
				data : $('#ffadd').serialize(),
				error : function(request) {
					alert("登录失败，请稍后再试！");
				},
				success:function(msg){
					var jsonobj= eval('('+msg+')'); 
				   	if(jsonobj.data=='succeess')
				   		location.href ="main.jsp";
				   	else
				   		alert("登录失败，请稍后再试！");
				}	
			});
		}
	</script>
</body>
</html>
