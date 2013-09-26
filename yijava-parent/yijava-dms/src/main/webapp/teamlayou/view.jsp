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
			        <div onclick="appendTeam()">添加组织</div>  
			        <div onclick="appendUserDetail()">添加用户</div>  
			        <div onclick="updateTeam()">修改组织</div>
			        <div onclick="deleteTeam()" id="deleteTeam">删除组织</div>  
			    </div>
			     <div id="mmDelUser" class="easyui-menu" style="width:120px;">
			        <div onclick="deleteUser()" id="deleteUser">删除用户</div>  
			    </div>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" title="组织分类" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:300px;height:200px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<input type="hidden" name="id"></input>
                    <input type="hidden" name="parent_id"></input>
					<tr>
						<td>组织名:</td>
                    	<td>
                    		<input class="easyui-validatebox" type="text" name="team_name" data-options="required:true"></input>
                    	</td>
					</tr>
					<tr>
						<td>备注:</td>
                    	<td><textarea name="remark" style="height:60px;"></textarea></td>
					</tr>
				</table>
			</form>
			<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveTeam()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">清空</a>					   
			</div>
		</div>
		<div id="dlgUserDetail" class="easyui-dialog" title="用户列表" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
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
										<td width="100">角色:</td>
										<td width="270">
											<input class="easyui-combobox" name="fk_role_id" id="fk_role_id" style="width:150px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}api/sysrole/list',
									                    method:'get',
									                    valueField:'id',
														textField:'role_name',
									                    panelHeight:'auto'
							            			"/>
										</td>
									</tr>
									<tr>
										<td width="50">状态:</td>
										<td width="270">										
											<input name="isdeleted" class="easyui-combobox" data-options="
												valueField: 'id',
												textField: 'value',
												data: [{
													id: '0',
													value: '启用'
												},{
													id: '1',
													value: '禁用'
												},{
													id: '2',
													value: '离职'
												}]" />
										</td>
										<td width="50">部门:</td>
										<td width="270">
											<input class="easyui-combotree" name="fk_department_id" id="fk_department_id" style="width:150px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}api/department/listByParentId',
									                    method:'get',
									                    valueField:'id',
														textField:'department_name',
									                    panelHeight:'auto'
							            			"/>
										</td>
										<td width="100">经销商:</td>
										<td>
											<input class="easyui-combobox" name="fk_dealer_id" id="fk_dealer_id" style="width:150px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}/api/dealer/list',
									                    method:'get',
									                    valueField:'dealer_id',
									                    textField:'dealer_name',
									                    panelHeight:'auto'
							            			"/>						
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
					<table id="dg" title="查询结果" style="height:330px" url="${basePath}api/sysuser/paging" method="get"
						rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
						<thead>
							<tr>
								<th data-options="field:'account',width:100,align:'center'" sortable="true">账户</th>
								<th data-options="field:'realname',width:100,align:'center'" sortable="true">姓名</th>
								<th data-options="field:'email',width:150">邮箱</th>
								<th data-options="field:'birthday',width:70,align:'center'" hidden="true">生日</th>
								<th data-options="field:'sex',width:55,align:'center'" formatter="formatter" sortable="true">性别</th>
								<th data-options="field:'phone',width:100,align:'center'">手机号</th>
								<th data-options="field:'province',width:55,align:'center'" hidden="true">省份</th>
								<th data-options="field:'address',width:80" hidden="true">地址</th>
								<th data-options="field:'postcode',width:55,align:'center'" hidden="true">邮编</th>
								<th data-options="field:'fk_role_id',width:80,align:'center'" hidden="true"></th>
								<th data-options="field:'isdeleted',width:55,align:'center'" formatter="formatterStatus" sortable="true">状态</th>
								<th data-options="field:'role_name',width:80,align:'center'" sortable="true">角色</th>
								<th data-options="field:'department_name',width:100,align:'center'">部门</th>
								<th data-options="field:'fk_department_id',width:60,align:'center'" hidden="true"></th>
								<th data-options="field:'dealer_name',width:100,align:'center'">经销商</th>
								<th data-options="field:'fk_dealer_id',width:60,align:'center'" hidden="true"></th>
								<th data-options="field:'last_time',width:150,align:'center'">更新时间</th>
							</tr>
						</thead>
					</table>
				</div>
				<div style="margin: 10px 0;"></div>
			</div>
        </div>
        <div id="dlg-buttons">
	        <a id="saveEntityBtn" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveUser()">添加用户</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgUserDetail').dialog('close')">取消</a>
	    </div>
	<script tye="text/javascript">
		var type;
		var id;
		var text;
		var parent_id;
		$(function() {
			$('#treegrid').treegrid({
                title:'组织分类',  
                iconCls:'icon-save',
                height:500,  
                nowrap: true,  
                rownumbers: true,  
                animate:true,  
                collapsible:true,
                url:basePath+'api/teamlayou/listByParentId',  
                idField:'id',
                treeField:'text',
                frozenColumns:[[
                    {title:'组织名称',field:'text',width:500} 
                ]],
                onContextMenu: function(e,row){
                    e.preventDefault();  
                    $(this).treegrid('unselectAll');  
                    $(this).treegrid('select', row.id);
                    type=row.type;
                    id=row.id;
                    parent_id=row.parent_id;
                    text=row.text;
                    if(row.id==1)
                    	$('#deleteTeam').hide();
                    else
                    	$('#deleteTeam').show();
                    if(type==2)
                    {
                    	$('#mmDelUser').menu('show', {
                            left: e.pageX,  
                            top: e.pageY  
                        });
                    }else{
                    	$('#mm').menu('show', {
                            left: e.pageX,  
                            top: e.pageY  
                        });
                    }
                }
            });
			$.ajax({
				type : "POST",
				url :basePath+'api/sysrole/list',
				success:function(msg){
				    var jsonobj= eval('('+msg+')'); 
				    var options;  
					for (var i = 0; i < jsonobj.length; i++) {
						options += "<option value='" + jsonobj[i].id + "'>" + jsonobj[i].role_name + "</option>";  
					}
					$("#fk_role_id").append(options);
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
		function appendTeam() {
			clearForm();
			var t = $('#treegrid');
			var node = t.treegrid('getSelected');
			if (node) {
				p_target = node.fk_parent_id;
				$('#ffadd').form('load', {
					parent_id : '' + node.id + ''
				});
				url = basePath+'api/teamlayou/save';
				$('#w').window('open');
			}
		}
		var url;
		function updateTeam() {
			clearForm();
			var t = $('#treegrid');
			var node = t.treegrid('getSelected');
			if (node) {
				p_target = node.parent_id;
				$('input=[name=team_name]').val(node.text);
				$('#ffadd').form('load', node);
				url = basePath+'api/teamlayou/update';
				$('#w').window('open');
			}
		}
		function saveTeam() {
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
			                $('#treegrid').treegrid('reload',id);
						p_target = null;
						$('#w').window('close');
					}
			    }
			});
		}
		function deleteTeam(){
	           var node = $('#treegrid').treegrid('getSelected');
	            if (node){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/teamlayou/delete',
	            				data : {id:node.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {
	            						$('#treegrid').treegrid('reload',node.parent_id);
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
		//添加用户
	    function saveUser()
			{
				var row = $('#dg').datagrid('getSelected');
				if (row){
					if(row.fk_dealer_id==0){
					    $.ajax({
							type : "POST",
							url :basePath+'api/teamlayou/saveuser',
							data:{fk_team_id:id,fk_team_name:text,fk_user_id:row.id,fk_user_name:row.account,fk_role_id:row.fk_role_id},
							error : function(request) {
								$.messager.alert('提示','Error!','error');
							},
							success:function(msg){
							    var jsonobj= eval('('+msg+')');  
							    if(jsonobj.state==1)
							    {
							    	$('#treegrid').treegrid('reload',id);
							    }
							}
						});
					}else{
						$.messager.alert('提示','禁止添加经销商用户!','error');	
					}
				}else
				{
					$.messager.alert('提示','请选中某个用户!','error');
				}			
		 }
	    function deleteUser(){
	           var node = $('#treegrid').treegrid('getSelected');
	            if (node){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/teamlayou/deluser',
	            				data : {id:node.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {
	            						$('#treegrid').treegrid('reload',node.parent_id);
	            					}
	            				}
	            			});                    	
	                    }
	                });
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
	    }
		function appendUserDetail()
		{
			$('#dlgUserDetail').dialog('open');
			var pager = $('#dg').datagrid().datagrid('getPager'); 
			pager.pagination();
		}
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_account: $('#account').val(),
		    	filter_ANDS_realname: $('#realname').val(),
		    	filter_ANDS_fk_role_id: $("input[name=fk_role_id]").val(),
		    	filter_ANDS_fk_department_id: $('input[name=fk_department_id]').val(),
		    	filter_ANDS_fk_dealer_id: $('input[name=fk_dealer_id]').val(),
		    	filter_ANDS_isdeleted: $('input[name=isdeleted]').val()
		    });
		}
		function formatter(value, row, index){
			if(value=='male')
				return '<span>男</span>'; 
			else
				return '<span>女</span>'; 
		}
		function formatterStatus(value, row, index){
			if(value=='0')
				return '<span>启用</span>'; 
			else if(value=='1')
				return '<span>禁用</span>'; 
			else
				return '<span>离职</span>'; 
		}
	</script>
</html>