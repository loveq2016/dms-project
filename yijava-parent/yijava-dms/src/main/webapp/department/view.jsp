<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/common/head.jsp"%>
</head>
		<a href="#" onclick="collapseAll()">收起</a>  
        <a href="#" onclick="expandAll()">展开</a>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
			    <table id="treegrid"></table>
			    <div id="mm" class="easyui-menu" style="width:120px;">  
			        <div onclick="append()">添加</div>  
			        <div onclick="updateEntity()">修改</div>  
			        <div onclick="deleteEntity()">删除</div>  
			    </div>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" title="部门信息" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:300px;height:250px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<input type="hidden" name="id"></input>
                    <input type="hidden" name="fk_parent_id"></input>
					<tr>
						<td>部门名:</td>
                    	<td>
                    		<input class="easyui-validatebox" type="text" name="department_name" data-options="required:true"></input>
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
		$(function() {
			$('#treegrid').treegrid({
                title:'部门信息',  
                iconCls:'icon-save',
                height:500,  
                nowrap: false,  
                rownumbers: true,  
                animate:true,  
                collapsible:true,
                url:basePath+'api/department/listByParentId',  
                idField:'id',
                treeField:'department_name',	
                frozenColumns:[[
                    {title:'部门名称',field:'department_name',width:200} 
                ]],
                columns:[[
                    {field:'fk_parent_name',title:'父类',width:150}, 
                    {field:'remark',title:'备注',width:270,rowspan:2}
                ]],
                onContextMenu: function(e,row){  
                    e.preventDefault();  
                    $(this).treegrid('unselectAll');  
                    $(this).treegrid('select', row.id);  
                    $('#mm').menu('show', {
                        left: e.pageX,  
                        top: e.pageY  
                    });
                }
            });
		});
		function collapseAll(){
           var node = $('#treegrid').treegrid('getSelected');  
           if (node){
               $('#treegrid').treegrid('collapseAll', node.id);  
           } else {
               $('#treegrid').treegrid('collapseAll');  
           }
       }  
       function expandAll(){
           var node = $('#treegrid').treegrid('getSelected');  
           if (node){  
               $('#treegrid').treegrid('expandAll', node.id);  
           } else {
               $('#treegrid').treegrid('expandAll');  
           }  
       }
       var p_target=null;
		function append() {
			clearForm();
			var t = $('#treegrid');
			var node = t.treegrid('getSelected');
			if (node) {
				p_target = node.id;
				$('#ffadd').form('load', {
					fk_parent_id : '' + node.id + ''
				});
				url = basePath+'api/department/save';
				$('#w').window('open');
			}
		}
		var url;
		function updateEntity() {
			clearForm();
			var t = $('#treegrid');
			var node = t.treegrid('getSelected');
			if (node) {
				p_target = node.fk_parent_id;
				$('#ffadd').form('load', node);
				url = basePath+'api/department/update';
				$('#w').window('open');
			}
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
					if (jsonobj.state == 1) {
						if(p_target>-1)
		               		$('#treegrid').treegrid('reload', p_target);
						else
			                $('#treegrid').treegrid('reload');
						p_target = null;
						$('#w').window('close');
					}
			    }
			});
		}
		function deleteEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/department/delete',
	            				data : {id:row.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {
	            	                     $('#dg').datagrid('reload');
	            					}
	            				}
	            			});                    	
	                    }
	                });
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
	        }
		function clearForm() {
			$('#ffadd').form('clear');
		}
	</script>
</html>