<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
					<restrict:function funId="1">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
					</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:500px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'role_name',width:100,align:'left'" sortable="true">角色名称</th>
							<th data-options="field:'remark',width:160,align:'left'" sortable="true">备注</th>
							<th data-options="field:'last_time',width:180,align:'left'" formatter="formatterdate" sortable="true">更新时间</th>
							<th data-options="field:'custom',width:80,align:'left'" formatter="formatterAuthoriz">授权</th>
						</tr>
					</thead>
				</table>
				<div id="tb">
				<restrict:function funId="2">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				</restrict:function>
				<restrict:function funId="4">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
        		</restrict:function>
        		<restrict:function funId="3">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
        		</restrict:function>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" title="角色详细信息" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:298px;height:230px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>角色名称:</td>
                    	<td>
                    		<input class="easyui-validatebox" type="text" name="role_name" data-options="required:true"></input>
                    		<input class="easyui-validatebox" type="text" hidden="true" name="id"></input>
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
		<div id="authorizW" class="easyui-window" data-options="title:'授权列表',minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:705px;height:500px;padding:5px;"></div>  
		<script type="text/javascript">
 		var url;
 		var pagesize='12';
		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid pageSize:pagesize,pageList: [12, 20, 30], 
			//pager.pagination();
			
			var pager = $('#dg').datagrid(
					{
						 pageSize:pagesize,						 
						 pageList: [12, 20, 30]						
					
					}).datagrid('getPager');
			pager.pagination();
		})
		function doSearch(){
			$('#dg').datagrid({url : basePath +"api/sysrole/paging"});
		    $('#dg').datagrid('load',{
		    	filter_ANDS_role_name: $('#role_name').val(),
		    });
		}
		function newEntity()
		{
			$('#dlg').dialog('open').dialog('setTitle','角色信息添加');
			url = basePath+'/api/sysrole/save';
			$('#w').window('open');
		}
		function saveEntity() {
			$('#ffadd').form('submit', {
			    url:url,
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
			    		clearForm();
				    	$('#w').window('close');
				    	var pager = $('#dg').datagrid().datagrid('getPager');
				    	pager.pagination('select');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
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
				url = basePath+'/api/sysrole/update';
				$('#w').window('open');
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');
			}
		}
		function destroyEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if(row.id==1){
				$.messager.alert('提示','禁止删除管理员角色!','warning');return;
			}
			if (row){
			    $.ajax({
					type : "POST",
					url : basePath+'api/sysrole/remove?id='+row.id,
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
				$.messager.alert('提示','请选中数据!','warning');
			}			
		}
		function formatterAuthoriz(value, row, index){
			return '<span style="color:red;cursor:pointer;background:#FFF" onclick="authoriz(' + row.id + ');">授权</span>'; 
		}
		function authoriz(id){
	    	$('#authorizW').load(basePath+'api/sysmenu/goauthorze?roleid='+id); 
	    	$('#authorizW').window('open');
		}
		function clearForm(){
			$('#ffadd').form('clear');
		}
	</script>
</body>
</html>