<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"	href="../../resource/themes/gray/easyui.css">
<link rel="stylesheet" type="text/css"	href="../../resource/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../../resource/css/main.css">
<script type="text/javascript" src="../../resource/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="../../resource/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../../resource/js/common.js"></script>
<script type="text/javascript" src="../../resource/locale/easyui-lang-zh_CN.js"></script>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<div class="easyui-panel" title="查询条件">
					<div style="padding: 10px 0 0 60px">
						<form id="ffquery" method="post">
							<table>
								<tr>
									<td width="50">账户:</td>
										<td width="270"><input class="easyui-validatebox" type="text" name="account" id="account"></input>
									</td>
									<td width="100">姓名:</td>
										<td width="270"><input class="easyui-validatebox" type="text" name="realname" id="realname"></input>
									</td>
								</tr>
								<tr>
									<td width="50">部门:</td>
									<td width="270"><select name="fk_department_id">
										  <option value ="1001">销售部</option>
										</select>
									</td>
									<td width="100">经销商:</td>
									<td>
										<select name="fk_dealer_id">
										  <option value ="2033">北京杜蕾斯医疗器械有限公司</option>
										</select>								
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:330px" url="/yijava-dms/api/sysuser/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'account',width:55,align:'center'" sortable="true">账户</th>
							<th data-options="field:'realname',width:60,align:'center'" sortable="true">姓名</th>
							<th data-options="field:'email',width:80">邮箱</th>
							<th data-options="field:'type',width:80,align:'center'" sortable="true">用户类型</th>
							<th data-options="field:'birthday',width:70,align:'center'" sortable="true">生日</th>
							<th data-options="field:'sex',width:55,align:'center'" sortable="true">性别</th>
							<th data-options="field:'phone',width:60,align:'center'">手机号</th>
							<th data-options="field:'province',width:55,align:'center'">省份</th>
							<th data-options="field:'address',width:80">地址</th>
							<th data-options="field:'postcode',width:55,align:'center'">邮编</th>
							<th data-options="field:'fk_department_id',width:60,align:'center'">部门</th>
							<th data-options="field:'fk_dealer_id',width:100,align:'center'">经销商</th>
							<th data-options="field:'last_time',width:120,align:'center'">更新时间</th>
						</tr>
					</thead>
				</table>
				<div id="tb">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" title="用户详细信息" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:550px;height:380px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>角色:</td>
						<td>
							<select name="fk_role_id"  data-options="required:true">
								<option value ="" selected="selected">请选择</option>
								<option value ="1001">销售角色</option>
								<option value ="1002">经理角色</option>
							</select>
						</td>
						<td>部门:</td>
						<td>
							<select name="fk_department_id" data-options="required:true">
								<option value ="" selected="selected">请选择</option>
								<option value ="1001">市场部</option>
								<option value ="1003">综合部</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="50">账户:</td>
						<td>
							<input hidden="true" name="id"></input>
							<input class="easyui-validatebox" type="text" name="account" data-options="required:true"></input>
						</td>
						<td>姓名:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="realname" data-options="required:true"></input>
						</td>
					</tr>
					<tr>
						<td>密码:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="password" data-options="required:true"></input>
						</td>
						<td>邮箱:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="email" data-options="required:true,validType:'email'" invalidMessage="请填写正确的邮件格式"></input>
						</td>
					</tr>
					<tr>
						<td>生日:</td>
						<td>
							<input class="easyui-datebox" type="text" name="birthday"></input>
						</td>
						<td>性别:</td>
						<td>
							<input type="radio" value="male" checked="checked" name="sex"/>男
							<input type="radio" value="female" name="sex"/>女
						</td>
					</tr>
					<tr>
						<td>手机号:</td>
						<td>
							<input class="easyui-numberbox" type="text" name="phone"></input>
						</td>
						<td>省份:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="province"></input>
						</td>
					</tr>
					<tr>
						<td>地址:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="address""></input>
						</td>
						<td>邮编:</td>
						<td>
							<input class="easyui-numberbox" type="text" name="postcode"></input>
						</td>
					</tr>
					<tr>
						<td>经销商:</td>
						<td>
							<select name="fk_dealer_id"  data-options="required:true">
								<option value ="">请选择</option>
								<option value ="2033">北京算算医疗器械有限公司</option>
							</select>	
						</td>
						<td>用户状态:</td>
						<td>
							<select name="isdeleted" class="easyui-validatebox" >
								<option value ="0">正常</option>
								<option value ="1">移除</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Customfield1:</td>
                    	<td><input class="easyui-numberbox" type="text" name="customfield1"></input></td>
                    	<td>Customfield2:</td>
                    	<td><input class="easyui-numberbox" type="text" name="customfield2"></input></td>
					</tr>
				</table>
			</form>
			<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">清空</a>					   
			</div>
		</div>
	<script type="text/javascript">
 		var url;
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination();
		});
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_account: $('#account').val(),
		    	filter_ANDS_realname: $('#realname').val()
		    });
		}
		function newEntity()
		{
			$('#dlg').dialog('open').dialog('setTitle','用户信息添加');
			url = '/yijava-dms/api/sysuser/save';
			$('#w').window('open');
		}		
		function saveEntity() {
			$.ajax({
				type : "POST",
				url : url,
				data : $('#ffadd').serialize(),
				error : function(request) {
					alert("更新失败，请稍后再试！");
				},
				success:function(msg){
				    var jsonobj= eval('('+msg+')');  
				    if(jsonobj.state==1)
				    {
				    	clearForm();
				    	$('#w').window('close');
				    	var pager = $('#dg').datagrid().datagrid('getPager');
				    	pager.pagination('select');	
				    }
				}	
			});
		}		
		function editEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
				 $('#dlg').dialog('open').dialog('setTitle','用户信息更新');
			    $('#ffadd').form('load', row);
				url = '/yijava-dms/api/sysuser/update';
				$('#w').window('open');
			}else
			{
				alert("请选中数据 ");	
			}
		}
		function destroyEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
			    $.ajax({
					type : "POST",
					url : '/yijava-dms/api/sysuser/remove?id='+row.id,
					error : function(request) {
						alert("Connection error");
					},
					success:function(msg){
					    var jsonobj= eval('('+msg+')');  
					    if(jsonobj.state==1)
					    {
					    	clearForm();
					    	$('#w').window('close');
					    	var pager = $('#dg').datagrid().datagrid('getPager');
					    	pager.pagination('select');	
					    }
					}	
				});
			}else
			{
				alert("请选中数据 ");	
			}			
		}
		function clearForm(){
			$('#ffadd').form('clear');
		}
	</script>
</body>
</html>
