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
					<div style="padding: 10px 0 10px 60px">
						<form id="ffquery" method="post">
							<table>
								<tr>
									<td>账户:</td>
									<td><input class="easyui-validatebox" type="text" name="account"></input>
									</td>
									<td>姓名:</td>
									<td><input class="easyui-validatebox" type="text" name="realname"></input>
									</td>
									<td>部门:</td>
									<td><select name="fk_department_id">
										  <option value ="1001">销售部</option>
										</select>
									</td>
									<td>经销商:</td>
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
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="newEntity();">新建</a>						
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="updateEntity()">修改</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="deleteEntity()">删除</a>					   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:330px" url="/yijava-dms/api/sysuser/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'account',width:55,align:'center'">账户</th>
							<th data-options="field:'realname',width:60,align:'center'">姓名</th>
							<th data-options="field:'email',width:80">邮箱</th>
							<th data-options="field:'type',width:60,align:'center'">用户类型</th>
							<th data-options="field:'birthday',width:70,align:'center'">生日</th>
							<th data-options="field:'sex',width:55,align:'center'">性别</th>
							<th data-options="field:'phone',width:60,align:'center'">手机号</th>
							<th data-options="field:'province',width:55,align:'center'">省份</th>
							<th data-options="field:'address',width:80">地址</th>
							<th data-options="field:'postcode',width:55,align:'center'">邮编</th>
							<th data-options="field:'fk_department_id',width:60,align:'center'">部门</th>
							<th data-options="field:'fk_dealer_id',width:100,align:'center'">经销商</th>
							<th data-options="field:'create_time',width:60,align:'center'">创建时间</th>
							<th data-options="field:'last_time',width:60,align:'center'">更新时间</th>
						</tr>
					</thead>
				</table>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" title="医院详细信息" data-options="modal:true,closed:true,iconCls:'icon-manage'" style="width:650px;height:400px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>账户:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="account" data-options="required:true"></input>
						</td>
						<td>姓名:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="realname" data-options="required:true"></input>
						</td>
						<td>邮箱:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="email" data-options="required:true"></input>
						</td>
						<td>用户类型:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="type" data-options="required:true"></input>
						</td>
						<td>生日:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="birthday" data-options="required:true"></input>
						</td>
						<td>性别:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="sex" data-options="required:true"></input>
						</td>
						<td>手机号:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="phone" data-options="required:true"></input>
						</td>
						<td>省份:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="province" data-options="required:true"></input>
						</td>
						<td>地址:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="address" data-options="required:true"></input>
						</td>
						<td>邮编:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="postcode" data-options="required:true"></input>
						</td>
						<td>部门:</td>
						<td>
							<select name="fk_department_id">
								<option value ="1001">销售部</option>
							</select>
						</td>
						<td>经销商:</td>
						<td>
							<select name="fk_dealer_id">
								<option value ="2033">北京算算医疗器械有限公司</option>
							</select>	
						</td>
						<td>备注:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="remark" data-options="required:true"></input>
						</td>
					</tr>
				</table>
			</form>
			<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
			</div>
		</div>
	<script type="text/javascript">
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination();
		});
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_account: $('#account').val(),
		    	filter_ANDS_realname: $('#realname').val(),
		    	filter_ANDS_fk_department_id: $('#fk_department_id').val(),
		    	filter_ANDS_fk_dealer_id: $('#fk_dealer_id').val()
		    });
		}
		function newEntity()
		{
			$('#w').window('open');
		}		
		function saveEntity() {
			$.ajax({
				type : "POST",
				url : '/yijava-dms/api/sysuser/save',
				data : $('#ffadd').serialize(),
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
		}		
		function updateEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
			    alert('id:'+row.id+"\nPrice:"+row.account);
			   // $('#ffadd').form('load', row);
			}else
			{
				alert("请选中数据 ");	
			}
			$('#w').window('open');
		}
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
			    alert('id:'+row.id+"\nPrice:"+row.account);
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