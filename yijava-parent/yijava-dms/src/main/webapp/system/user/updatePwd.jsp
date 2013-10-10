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
		
	<div style="padding-left: 10px; padding-right: 10px;">
		<div class="easyui-panel" title="修改密码">
			<div style="padding: 10px 0 0 60px">
				<form id="ffupdatepwd" method="post">
					<table>
						<tr>
							<td width="50">现在的密码:</td>
							<td width="270"><input class="easyui-validatebox" type="password" name="currentpwd" id="currentpwd"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">新的密码:</td>
							<td width="270"><input class="easyui-validatebox" type="password" name="newpwd" id="newpwd"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">重复新的密码:</td>
							<td width="270"><input class="easyui-validatebox" type="password" name="confirmpwd" id="confirmpwd"></input>
							</td>									
						</tr>
					</table>
				</form>
			</div>
			<div style="text-align: center; padding: 5px">
				<restrict:function funId="131">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="updatepwd()">保存</a>
				</restrict:function>   
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function updatepwd() {
			$.ajax({
				type : "POST",
				url : basePath+"api/sysuser/updatepwd",
				data : $('#ffupdatepwd').serialize(),
				/* error : function(request) {
					
					$.messager.alert('提示',error,'error');
				}, */
				success:function(msg){
					var jsonobj= eval('('+msg+')'); 
				   	if(jsonobj.state=='0'){
				   		$.messager.alert('提示',jsonobj.error.msg,'warning');
				   		
				   		
				   	}else{
				   		$.messager.alert('提示',"密码已经修改",'info');
				   		$('#ffupdatepwd').form('clear');
				   	}
				   		
				}	
			});
		}
	</script>		
</body>
</html>
