<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/common/head.jsp"%>
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
									<td>经销商:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input>
									</td>
									<td></td>
									<td>单据状态:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input>
									</td>
								</tr>
								<tr>
									<td>客户订单号:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			   
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg"  title="查询结果" style="height: 330px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="consignee_status" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="100" align="center" sortable="true">经销商</th>
							<th field="order_code" width="120" align="center" sortable="true">客户订单号</th>
							<th field="express_code" width="120" align="center" sortable="true">快递号</th>
							<th field="deliver_code" width="120" align="center" sortable="true">收货单号</th>
							<th field="cm" width="50" align="center" formatter="formatterCM">发货方</th>
							<th field="express_date" width="100" align="center" sortable="true">发货日期</th>
							<th field="consignee_date" width="100" align="center" sortable="true">收货日期</th>
							<th field="totalMoney" width="100" align="center" sortable="true" >金额</th>
							<th field="consignee_status" width="100" align="center" sortable="true" formatter="formatterConsigneeStatus">单据状态</th>
							<th field="info" width="100" align="center" sortable="true" formatter="formatterInfo">明细</th>
						</tr>
					</thead>
				</table>
				<div id="tb">     
<!-- 				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>        -->
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
		
		<div id="dlgDeliverDetail" class="easyui-dialog" title="收货单明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="ffDeliverDetail" method="post" enctype="multipart/form-data">
							<table>
								<tr>
									<td>经销商:</td>
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="dealer_name"></input></td>
									<td></td>
									<td>客户订单号</td>
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="order_code"></input></td>
								</tr>
								<tr>
									<td>发货方:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="cm"></input></td>
									<td></td>
									<td>出货单号:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="deliver_code"></input></td>
									<td></td>
									<td>快递号:</td>
									<td><input class="easyui-validatebox" readonly="readonly"  type="text" style="width:200px;" name="express_code"/></td>
								</tr>
								<tr>
									<td>发货日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="express_date"></input></td>
									<td></td>
									<td>收货日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="consignee_date"></input></td>
									<td></td>
									<td>单据状态:</td>	
									<td><input name="consignee_status" class="easyui-combobox" readonly="readonly" 
												data-options="
													required:true,
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '0',value: '待接收'},
														{id: '1',value: '完成'}
														]" />
									  </td>
								</tr>
								<tr>
									<td>金额:</td>	
									<td colspan="4"><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="totalMoney"></input></td>
								</tr>

							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="width:925px;height:auto;">
					<table id="dgExpress" class="easyui-datagrid" title="查询结果" style="height:270px" method="get" toolbar="#tb2"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc">
						<thead>
							<tr>
							<th data-options="field:'express_sn',width:100,align:'center'" sortable="true">产品批号</th>
							<th data-options="field:'validity_date',width:100,align:'center'" sortable="true">有效期</th>
							<th data-options="field:'abc',width:100,align:'center'">销售单位</th>
							<th data-options="field:'express_num',width:100,align:'center'">销售数量</th>
							<th data-options="field:'totalMoney',width:100,align:'center'">含税销售价格</th>
							</tr>
						</thead>
					</table>
			</div>
		</div>
		<div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" id="submitConsignee" onclick="submitConsignee();">确认收货</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgDeliverDetail').dialog('close')">取消</a>
	    </div>
	

    
    
	
	

	<script type="text/javascript">
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/orderDeliver/paging",
			onLoadSuccess:function(data){ 
				 $(".info").linkbutton({ plain:true, iconCls:'icon-manage' });
			}
		});
		function formatterCM(value, row, index){
			return '<span>Bard</span>'; 
		}
		function formatterConsigneeStatus(value, row, index){
			if(value=='0')
				return '<span>待接收</span>'; 
			else if(value=='1')
				return '<span>完成</span>'; 
		}
		
		 function formatterInfo (value, row, index) { 
			 	//v = "'"+row.dealer_id +"','" + row.dealer_name +"'";
			 	return '<a class="info" href="javascript:void(0)"  onclick="openInfo(' + index + ');" ></a>';
			 	//return '<a class="authListBtn" href="javascript:void(0)"  onclick="parent.addTab(\'['+row.dealer_name+']授权信息维护\',\''+basePath+'web/dealer/authView?dealer='+row.dealer_id+'\');" ></a>';
			 	
		} 
		 
		 var dealer_id;
		 var deliver_code;
		 function openInfo(index){
				$('#dg').datagrid('selectRow',index);
				var row = $('#dg').datagrid('getSelected');
		          if (row){
		            $('#dlgDeliverDetail').dialog('open').dialog('setTitle','收货单明细');
					$('#ffDeliverDetail').form('clear');
					$('#ffDeliverDetail').form('load', row);
					$('#ffDeliverDetail').form('load', {"cm":"Bard"});
					if(row.consignee_status== 1){
						$("#submitConsignee").linkbutton('disable');
					}else{
						$("#submitConsignee").linkbutton('enable');
					}
					deliver_code = row.deliver_code;
					dealer_id = row.dealer_id;
					$('#dgExpress').datagrid('loadData', {total: 0, rows: []});
					$('#dgExpress').datagrid({
						url : basePath + "api/deliverExpress/paging",
						queryParams: {
							filter_ANDS_deliver_code : deliver_code
						}
					});
		          }else{
						$.messager.alert('提示','请选中数据!','warning');				
				 }				 
		 }
		 
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val()
		    });
		}
		
		function submitConsignee(){
			$("#submitConsignee").linkbutton('disable');
			$.ajax({
				type : "POST",
				url : basePath + 'api/orderDeliver/consignee',
				data : {deliver_code:deliver_code,dealer_id:dealer_id},
				error : function(request) {
					$("#submitConsignee").linkbutton('enable');
					$.messager.alert('提示','Error!','error');	
				},
				success : function(data) {
					var jsonobj = $.parseJSON(data);
					if (jsonobj.state == 1) {  
						 $('#dg').datagrid('reload');
						 $('#dlgDeliverDetail').dialog('close');
					}else{
						$("#submitConsignee").linkbutton('enable');
						$.messager.alert('提示','Error!','error');	
					}
				}
			}); 
		}
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>