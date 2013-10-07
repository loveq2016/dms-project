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
		<div class="easyui-panel" title="个人信息">
			<div style="padding: 10px 0 0 60px">
				<form id="ffupdateinfo" method="post" enctype="multipart/form-data">
					<table>
						<tr>
							<td width="50">用户名:</td>
							<td width="270"><input class="easyui-validatebox" type="text" name="account" readonly="readonly" 
							id="account" value="${sysUser.account}"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">姓名:</td>
							<td width="270"><input class="easyui-validatebox" type="text" name="realname" id="realname" value="${sysUser.realname}"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">邮箱:</td>
							<td width="270"><input class="easyui-validatebox" type="text" name="email" id="email" value="${sysUser.email}"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">电话:</td>
							<td width="270"><input class="easyui-validatebox" type="text" name="phone" id="phone" value="${sysUser.phone}"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">地址:</td>
							<td width="270"><input class="easyui-validatebox" type="text" name="address" id="address" value="${sysUser.address}"></input>
							</td>									
						</tr>
						<tr>								
							<td width="100">签名:</td>
							<td width="270">
							<c:if test="${sysUser.sign_img!=null}">
								<img src="${basePath}resource/signimg/${sysUser.sign_img}" width="50" height="50">
							</c:if>
							<input type="file" name="file"/>  </input>
							</td>									
						</tr>
						
					</table>
				</form>
			</div>
			<div style="text-align: center; padding: 5px">
				<restrict:function funId="133">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="updateuser()">保存</a>
				</restrict:function>   
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function updateuser() {
			$('#ffupdateinfo').form('submit', {
			    url:basePath+"/api/sysuser/updateinfo",
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
			    		$.messager.alert('提示','保存成功，重新登录后生效','info');	
			    		
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});
		}
	</script>		
</body>
</html>
