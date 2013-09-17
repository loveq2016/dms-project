<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
					<div style="padding: 10px 0 10px 60px">
						<form id="ff" method="post">
							<table>
								<tr>
									<td>订单号:</td>
									<td><input class="easyui-validatebox" type="text" name="order_code"></input></td>
									<td width="100">经销商:</td>
									<td>
										<input class="easyui-combobox" name="dealer_id" id="dealer_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}/api/dealer/list',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto'
						            			"/>
									</td>
									<td width="50">状态:</td>
									<td width="270">										
										<input name="order_status" class="easyui-combobox" data-options="
											valueField: 'id',
											textField: 'value',
											data: [{
												id: '0',
												value: '未提交'
											},{
												id: '1',
												value: '已提交'
											},{
												id: '2',
												value: '驳回'
											},{
												id: '3',
												value: '已审核'
											},{
												id: '4',
												value: '已发货'
											},{
												id: '5',
												value: '部分发货'
											},{
												id: '6',
												value: '已完成'
											}]" />
									</td>
								</tr>
								<tr>
									<td width="100">开始时间:</td>
									<td width="270">
										<input name="start_date" id="start_date" class="easyui-datebox"></input>
									</td>
									<td width="100">结束时间:</td>
									<td width="270">
										 <input name="end_date" id="end_date" class="easyui-datebox"></input>
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
				<table id="dg" title="查询结果" style="height:330px" url="${basePath}api/order/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'id',width:240,align:'center'" hidden="true">id</th>
							<th data-options="field:'dealer_name',width:240,align:'center'" sortable="true">经销商</th>
							<th data-options="field:'order_code',width:200,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'order_number_sum',width:80,align:'center'" sortable="true">总数量</th>
							<th data-options="field:'order_money_sum',width:80,align:'center'" sortable="true">总金额</th>
							<th data-options="field:'order_status',width:80,align:'center'" formatter="formatterStatus" sortable="true">状态</th>
							<th data-options="field:'custom',width:80,align:'center'" formatter="formatterProduct">产品</th>
							<th data-options="field:'order_date',width:150,align:'center'" sortable="true">下单时间</th>
							<th data-options="field:'dealer_address_id',width:60" hidden="true"></th>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tb">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:500px;height:336px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>收货地址:</td>
						<td>
							<input class="easyui-combobox" name="dealer_address_id" style="width:150px" maxLength="100" class="easyui-validatebox" required="true"
						             			data-options="
							             			url:'${basePath}api/dealerAddress/list',
								                    method:'get',
								                    valueField:'id',
								                    textField:'address',
								                    panelHeight:'auto'
						            			">
						</td>
					</tr>
				</table>
			</form>
			<div style="margin: 10px 0;"></div>
			<div style="margin: 10px 0;"></div>
			<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#w').window('close')">取消</a>					   
			</div>
		</div>
	<script type="text/javascript">
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination();
		})
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_order_code: $('input[name=order_code]').val(),
		    	filter_ANDS_dealer_id: $('input[name=dealer_id]').val(),
		    	filter_ANDS_order_status: $('input[name=order_status]').val(),
		    	filter_ANDS_start_date: $('input[name=start_date]').val(),
		    	filter_ANDS_end_date: $('input[name=end_date]').val(),
		    });
		}
		function formatterProduct(value, row, index){
			//row.order_code
			return '<span>包含产品</span>';
		}
		function formatterStatus(value, row, index){
			if(value=='0')
				return '<span>未提交</span>'; 
			else if(value=='1')
				return '<span>已提交</span>'; 
			else if(value=='2')
				return '<span>驳回</span>'; 
			else if(value=='3')
				return '<span>已审核</span>'; 
			else if(value=='4')
				return '<span>已发货</span>'; 
			else if(value=='5')
				return '<span>部分发货</span>'; 
			else if(value=='6')
				return '<span>已完成</span>'; 
		}
		
		function newEntity()
		{
			clearForm();
			$('#w').dialog('open').dialog('setTitle','添加订单信息');
			url =basePath+'api/sysuser/save';
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
				$('#w').dialog('open').dialog('setTitle','更新订单信息');
			    $('#ffadd').form('load', row);
				url = basePath+'api/sysuser/update';
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
					url :basePath+'api/sysuser/remove?id='+row.id,
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