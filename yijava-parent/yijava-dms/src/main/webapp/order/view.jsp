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
				<table id="dg" title="查询结果" style="height:300px" url="${basePath}api/order/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" 
					iconCls="icon-search" sortOrder="asc" toolbar="#tbOrder" data-options="onClickRow:onClickOrderRow">
					<thead>
						<tr>
							<th data-options="field:'id',width:240,align:'center'" hidden="true">id</th>
							<th data-options="field:'dealer_name',width:240,align:'center'" sortable="true">经销商</th>
							<th data-options="field:'order_code',width:200,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'order_number_sum',width:80,align:'center'" sortable="true">总数量</th>
							<th data-options="field:'order_money_sum',width:80,align:'center'" sortable="true">总金额</th>
							<th data-options="field:'order_status',width:80,align:'center'" formatter="formatterStatus" sortable="true">状态</th>
							<th data-options="field:'order_date',width:150,align:'center'" sortable="true">下单时间</th>
							<th data-options="field:'dealer_address_id',width:60" hidden="true"></th>
							<th data-options="field:'receive_linkman',width:60" hidden="true"></th>
							<th data-options="field:'receive_linkphone',width:60" hidden="true"></th>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tbOrder">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dgDetail" class="easyui-datagrid" title="包含产品" style="height: 300px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbOrderDetail">
					<thead>
						<tr>
							<th data-options="field:'product_item_number',width:100,align:'center'" sortable="true">产品编码</th>
							<th data-options="field:'product_name',width:200,align:'center'" sortable="true">产品名称</th>
							<th data-options="field:'models',width:60,align:'center'" sortable="true">产品规格</th>
							<th data-options="field:'order_number_sum',width:80,align:'center'" sortable="true">数量</th>
							<th data-options="field:'order_price',width:80,align:'center'" sortable="true">订购价格</th>
							<th data-options="field:'order_money_sum',width:80,align:'center'" sortable="true">小计</th>
							<th data-options="field:'discount',width:80,align:'center'" sortable="true">折扣</th>
							<th data-options="field:'delivery_sum',width:80,align:'center'" sortable="true">发货数量</th>
							<th data-options="field:'plan_send_date',width:150,align:'center'" sortable="true">预计发货日期</th>
						</tr>
					</thead>
				</table>
				<div id="tbOrderDetail">    
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="saveOrderDetail" onclick="newOrderDetailEntity();">添加产品</a>    
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delOrderDetail" onclick="removeOrderDetailEntity();">删除产品</a>    
				</div> 	
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="w" class="easyui-window" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:300px;height:200px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>收货地址:</td>
						<td>
							<input hidden="true" name="order_code"></input>
							<input class="easyui-combobox" name="dealer_address_id" style="width:150px" maxLength="100" class="easyui-validatebox" required="true"
						             			data-options="
							             			url:'${basePath}api/dealerAddress/list?id=${user.fk_dealer_id}',
								                    method:'get',
								                    valueField:'id',
								                    textField:'address',
								                    panelHeight:'auto',
								                    onSelect:function functionS(s){
														$('#receive_linkman').val(s.linkman);
														$('#receive_linkphone').val(s.linkphone);
													}
						            			">
						</td>
					</tr>
					<tr>
						<td>收货人:</td>
						<td>
							<input class="easyui-validatebox" disabled="disabled" name="receive_linkman" id="receive_linkman" value="aa" style="width:150px" maxLength="100">
						</td>
					</tr>
					<tr>
						<td>收货电话:</td>
						<td>
							<input class="easyui-validatebox" disabled="disabled" name="receive_linkphone" id="receive_linkphone" style="width:150px" maxLength="100">
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
		<div id="dlgOrderDetail" class="easyui-dialog" style="width:800px;height:495px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgOrderDetail-buttons">
				<div class="easyui-panel" title="查询条件" style="width:775px;">
						<div style="padding: 10px 0 0 60px">
							<form id="ffdetail" method="post">
								<table>
									<tr>
										<td>产品编号:</td>	
										<td width="100px"><input class="easyui-validatebox" type="text" name="item_number"></input></td>
										<td>选择分类:</td>
										<td>
						                <input id="cc" name="category_id" class="easyui-combotree"  value=""  required="true" editable="false" style="width:200px;"
						                	data-options="
						                			url: '${basePath}api/dealerAuthProduct/list?dealer_id=${user.fk_dealer_id}',
													method: 'get',
													lines: true,
													onClick : function(node){
													    var tree = $(this).tree;  
														isLeaf = tree('isLeaf', node.target);
														if(!isLeaf){
															$('#cc').combotree('clear');
														}else{
															$('#cc').combotree('setValue', node.id);  
														}	
							            			}">  
					                	</td>
									</tr>
								</table>
							</form>
						</div>
						<div style="text-align: right; padding:5px">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchProduct()">查询</a>   
						</div>
					</div>
				<div style="margin: 10px 0;"></div>
					<table id="dgProduct" class="easyui-datagrid" title="查询结果" style="height:300px" url="${basePath}/api/product/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbProduct">
						<thead>
							<tr>
								<th data-options="field:'item_number',width:100,align:'center'" sortable="true">产品编号</th>
								<th data-options="field:'cname',width:150,align:'center'" sortable="true">中文名称</th>
								<th data-options="field:'ename',width:150,align:'center'" sortable="true">英文说明</th>
								<th data-options="field:'price',width:80,align:'center'" sortable="true">价格</th>
								<th data-options="field:'discount',width:80,align:'center'" sortable="true">折扣</th>
								<th data-options="field:'order_company',width:80,align:'center'">订购单位</th>
								<th data-options="field:'is_order',width:80" formatter="formatterIs_order">是否可订货</th>
							</tr>
						</thead>
					</table>
				</div>
		<div style="margin: 10px 0;"></div>
	    <div id="dlgOrderDetail-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="newProductNumEntity()">添加产品</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgOrderDetail').dialog('close')">取消</a>
	    </div>
		<div id="dlgProductSum" class="easyui-dialog" style="width:300px;height:500px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductSum-buttons">
		        <form id="fm3" action="" method="post" enctype="multipart/form-data">
		        	<input type="hidden" name="id">
		        	<input type="hidden" name="dealer_id" id="discount_dealer_id">
					      <table> 
					    		<tr>
					             	<td>order_code</td>
					             	<td><input name="order_code" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>product_item_number</td>
					             	<td><input name="product_item_number" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>product_name</td>
					             	<td><input name="product_name" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>order_price</td>
					             	<td><input name="order_price" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>discount</td>
					             	<td><input name="discount" class="easyui-validatebox" value="10" style="width:150px"></td>
					            </tr>
						        <tr>
					             	<td>数量:</td>
					             	<td><input name="order_number_sum" id="order_number_sum" class="easyui-numberbox" style="width:150px" value="1" required="true"></td>
					             </tr>
					      </table>        	
		        </form>
	    </div>
	    <div id="dlgProductSum-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveOrderDetailEntity();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductSum').dialog('close')">取消</a>
	    </div>
	<script type="text/javascript">
		var order_status;
		var order_code;
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination();
			var pager = $('#dgs').datagrid().datagrid('getPager'); // get the pager of datagrid
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
			url =basePath+'api/order/save';
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
				url = basePath+'api/order/updateAddress';
				$('#w').window('open');
			}else
			{
				$.messager.alert('提示','请选中某个订单!','warning');
			}
		}
		function destroyEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
				if(order_status=='0'){
				    $.ajax({
						type : "POST",
						url :basePath+'api/order/remove?id='+row.order_code,
						error : function(request) {
							$.messager.alert('提示','抱歉,删除错误!','error');	
						},
						success:function(msg){
						    var jsonobj = $.parseJSON(msg);
        					if (jsonobj.state == 1) {
        	                     $('#dg').datagrid('reload');
        					}else{
        						$.messager.alert('提示','抱歉,删除错误!','error');	
        					}
						}	
					});
				}else{
					$.messager.alert('提示','无法删除已提交的订单!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个订单!','warning');
			}
		}
		function clearForm(){
			$('#ffadd').form('clear');
		}
		function onClickOrderRow(rowIndex, rowData){
            $('#dgDetail').datagrid('loadData', {total: 0, rows: [] });
			order_code = rowData.order_code;
			order_status=rowData.order_status;
			$('#dgDetail').datagrid({
				url : basePath + "api/orderdetail/paging",
					queryParams: {
						filter_ANDS_order_code : rowData.order_code
					}
			});
			if(order_status!='0'){
				$('#saveOrderDetail').linkbutton('disable');
				$('#delOrderDetail').linkbutton('disable');
			}else{
				$('#saveOrderDetail').linkbutton('enable');
				$('#delOrderDetail').linkbutton('enable');
			}
		}
		//订单项
		function removeOrderDetailEntity()
		{
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				if(order_status=='0'){
				    $.ajax({
						type : "POST",
						url :basePath+'api/orderdetail/remove?id='+row.id,
						error : function(request) {
							$.messager.alert('提示','抱歉,删除错误!','error');	
						},
						success:function(msg){
						    var jsonobj = $.parseJSON(msg);
        					if (jsonobj.state == 1) {
        	                     $('#dgDetail').datagrid('reload');
        	                     $('#dg').datagrid('reload');
        					}else{
        						$.messager.alert('提示','抱歉,删除错误!','error');	
        					}
						}
					});
				}else{
					$.messager.alert('提示','无法删除已提交的订单!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function newOrderDetailEntity()
		{
			if(typeof(order_code) != "undefined"){
				$('#dlgOrderDetail').dialog('open').dialog('setTitle','选择产品列表');
				url =basePath+'api/orderdetail/save';
				$('#dlgOrderDetail').window('open');
			}else
			{
				$.messager.alert('提示','请选中某个订单!','warning');
			}
		}		
		function newProductNumEntity() {
			$('#order_number_sum').val('1');
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$("#fm3 input[name=order_code]").val(order_code);
				$("#fm3 input[name=product_item_number]").val(row.item_number);
				$("#fm3 input[name=product_name]").val(row.cname);
				$("#fm3 input[name=order_price]").val(row.price);
				$("#fm3 input[name=discount]").val(row.discount);
				
				$('#dlgProductSum').dialog('open').dialog('setTitle','添加产品数量');
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function saveOrderDetailEntity(){
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#fm3').form('submit', {
					url :basePath+'api/orderdetail/save',
				    method:"post",
				    onSubmit: function(){
				        return $(this).form('validate');;
				    },
				    success:function(msg){
				    	var jsonobj = $.parseJSON(msg);
				    	if(jsonobj.state==1){
							 $('#dlgProductSum').dialog('close');     
		                     $('#dgDetail').datagrid('reload');
		                     $('#dg').datagrid('reload');
				    	}else{
				    		$.messager.alert('提示','Error!','error');	
				    	}
				    }		
				});					
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function doSearchProduct(){
		    $('#dgProduct').datagrid('load',{
		    	filter_ANDS_product_name: $('input[name=product_name]').val(),
		    	filter_ANDS_dealer_id: $('input[name=dealer_id]').val(),
		    	filter_ANDS_category_id: $('input[name=category_id]').val()
		    });
		}
		function formatterIs_order (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		} 
	</script>
</body>
</html>