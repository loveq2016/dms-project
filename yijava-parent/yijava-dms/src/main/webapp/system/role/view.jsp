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
									<td>角色名称:</td>
										<td><input class="easyui-validatebox" type="text" name="role_name" id="role_name"></input>
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
				<table id="dg" title="查询结果" style="height:330px" url="/yijava-dms/api/sysrole/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'role_name',width:100,align:'center'" sortable="true">角色名称</th>
							<th data-options="field:'remark',width:160,align:'center'" sortable="true">备注</th>
							<th data-options="field:'last_time',width:180,align:'center'" sortable="true">更新时间</th>
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
		<div id="w" class="easyui-window" title="角色详细信息" data-options="modal:true,closed:true,iconCls:'icon-manage'" style="width:298px;height:230px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>角色名称:</td>
                    	<td>
                    		<input class="easyui-validatebox" type="text" name="role_name"></input>
                    		<input class="easyui-validatebox" type="text" hidden="true" name="id"></input>
                    	</td>
					</tr>
					<tr>
						<td>状态:</td>
						<td>
							<select name="isdeleted" class="easyui-validatebox" >
								<option value ="0">正常</option>
								<option value ="1">移除</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>备注:</td>
                    	<td><textarea name="remark" style="height:60px;"></textarea></td>
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
		    	filter_ANDS_role_name: $('#role_name').val(),
		    });
		}
		function newEntity()
		{
			$('#dlg').dialog('open').dialog('setTitle','角色信息添加');
			url = '/yijava-dms/api/sysrole/save';
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
				 $('#dlg').dialog('open').dialog('setTitle','角色信息更新');
			    $('#ffadd').form('load', row);
				url = '/yijava-dms/api/sysrole/update';
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
					url : '/yijava-dms/api/sysrole/remove?id='+row.id,
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