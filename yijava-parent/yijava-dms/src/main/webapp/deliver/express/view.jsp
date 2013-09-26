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
									<td>出货单号:</td>	
									<td><input class="easyui-validatebox" type="text" name="deliver_code"></input></td>
								</tr>
<!-- 								<tr> -->
<!-- 									<td width="100">开始时间:</td> -->
<!-- 									<td width="270"> -->
<!-- 										<input name="start_date" id="start_date" class="easyui-datebox"></input> -->
<!-- 									</td> -->
<!-- 									<td width="100">结束时间:</td> -->
<!-- 									<td width="270"> -->
<!-- 										 <input name="end_date" id="end_date" class="easyui-datebox"></input> -->
<!-- 									</td> -->
<!-- 								</tr> -->
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
				<table id="dg" title="查询结果" style="height:330px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="deliver_id" pagination="true" iconCls="icon-search" 
					sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'deliver_code',width:150,align:'center'" sortable="true">出货单号</th>
							<th data-options="field:'dealer_name',width:150,align:'center'" sortable="true">经销商</th>
							<th data-options="field:'order_code',width:150,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'order_date',width:150,align:'center'" sortable="true">下单时间</th>
							<th data-options="field:'create_date',width:150,align:'center'" sortable="true">编制时间</th>
<!-- 							<th data-options="field:'express_number',width:150,align:'center'" sortable="true">快递号</th> -->
							<th data-options="field:'deliver_status',width:80,align:'center'" formatter="formatterDeliverStatus" sortable="true">发货状态</th>
							<th data-options="field:'check_status',width:80,align:'center'"  formatter="formatterCheckStatus">审核状态</th>
							<th data-options="field:'custom',width:80,align:'center'" formatter="formatterDetail">明细</th>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tb">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">发货</a>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>

		
		
	<div id="dlgDeliverDetail" class="easyui-dialog" title="发货物流明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="ffDeliverDetail" method="post">
							<table>
								<tr>
									<td>经销商:</td>
									<td>
						            	<input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="dealer_name"></input>
									</td>
								</tr>
								<tr>
									<td>订单号:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="order_code"></input></td>
									<td></td>
									<td>订单日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="order_date"></input></td>
								</tr>
								<tr>
									<td>出货单号:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="deliver_code"></input></td>
									<td></td>
									<td>出货单日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="create_date"></input></td>
									<td></td>
									<td>发货状态:</td>	
									<td><input name="deliver_status" class="easyui-combobox" id="deliver_status"
												data-options="
													required:true,
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '4',value: '全部发货'},
														{id: '5',value: '部分发货'}
														]" />
									  </td>
								</tr>
								<tr>
									<td>快递单号:</td>	
			             			<td colspan="4"><textarea name="remark" cols="65" style="height:30px;"></textarea></td>
								</tr>
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="tab" class="easyui-tabs" style="width:925px;height:auto;">
				<div title="明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgDetail" class="easyui-datagrid" title="出货单明细信息" style="height:270px" method="get" toolbar="#tb1"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="delivery_detail_id" sortOrder="desc" >
						<thead>
							<tr>
							<th data-options="field:'product_name',width:100,align:'center'" sortable="true">产品名称</th>
							<th data-options="field:'models',width:65,align:'center'" sortable="true">产品规格</th>
							<th data-options="field:'order_number_sum',width:80,align:'center'" sortable="true">订单数量</th>
							<th data-options="field:'deliver_number_sum',width:80,align:'center',editor:'numberbox'">发货数量</th>
							<th data-options="field:'deliver_date',width:100,align:'center',editor:'datebox'">预计发货日期</th>
							<th data-options="field:'arrival_date',width:100,align:'center',editor:'datebox'">预计到货日期</th>
							<th data-options="field:'deliver_remark',width:150,align:'center',editor:'text'">备注</th>
							<th data-options="field:'deliver_remark',width:150,align:'center',editor:'text'">发货明细</th>
							</tr>
						</thead>
					</table>
					<div id="tb1">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newExpress()">物流添加</a>
					</div>
				</div>
				<div title="物流明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgExpress" class="easyui-datagrid" title="物流明细信息" style="height:270px" method="get" toolbar="#tb2"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc">
						<thead>
							<tr>
							<th data-options="field:'product_name',width:100,align:'center'" sortable="true">产品名称</th>
							<th data-options="field:'models',width:65,align:'center'" sortable="true">产品规格</th>
							<th data-options="field:'exprees_num',width:80,align:'center'">发货数量</th>
							<th data-options="field:'express_sn',width:100,align:'center'">规格、批号</th>
							<th data-options="field:'validity_date',width:100,align:'center'">有效期</th>
							<th data-options="field:'remark',width:100,align:'center'">备注</th>
							</tr>
						</thead>
					</table>
					<div id="tb2">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="deleteExpress()">删除</a>
					</div>
				</div>
			</div>
		</div>
		<div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="alert('提交后将不能在修改，确定提交吗？')">提交</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgDeliverDetail').dialog('close')">取消</a>
	    </div>
	    
		<div id="dlgExpress" class="easyui-dialog" style="width:300px;height:300px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductSum-buttons">
		        <form id="fm" action="" method="post" enctype="multipart/form-data">
		         		  <input name="delivery_detail_id" type="hidden">
		         		  <input name="deliver_id" type="hidden">
		         		  <input name="deliver_code" type="hidden">
		         		  <input name="order_detail_id" type="hidden">
		         		  <input name="order_code" type="hidden">
		         		  <input name="product_item_number" type="hidden">
					      <table> 
					    		<tr>
					             	<td>产品名称:</td>
					             	<td><input name="product_name" readonly="true" class="easyui-validatebox" style="width:150px;"></td>
					            </tr>
					            <tr>
					             	<td>产品规格:</td>
					             	<td><input name="models" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>发货数量:</td>
					             	<td><input name="deliver_number_sum" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>数量:</td>
					             	<td><input name="exprees_num" class="easyui-numberbox" style="width:150px" data-options="min:1,required:true"></td>
					             </tr>
					            <tr>
					             	<td>规格、批号</td>
					             	<td><input name="express_sn"  class="easyui-validatebox" style="width:150px" data-options="required:true"></td>
					            </tr>
					            <tr>
					             	<td>有效期</td>
					             	<td><input name="validity_date" class="easyui-datebox" style="width:150px" data-options="required:true"></td>
					            </tr>
					            <tr>
					             	<td>备注</td>
					             	<td><input name="remark"  class="easyui-validatebox"  style="width:150px"></td>
					            </tr>
					      </table>        	
		        </form>
	    </div>
	    <div id="dlgProductSum-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveExpress();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgExpress').dialog('close')">取消</a>
	    </div>
		
		
	<script type="text/javascript">
		$(function() {
			$('#dg').datagrid({
				  url : basePath +"api/deliverApply/paging" ,
					queryParams: {
						filter_ANDS_check_status : 3
					}
			});
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_order_code: $('input[name=order_code]').val(),
		    	filter_ANDS_deliver_code: $('input[name=deliver_code]').val()
		    });
		}
		
		function formatterDeliverStatus(value, row, index){
			if(value=='4')
				return '<span>全部出货</span>'; 
			else if(value=='5')
				return '<span>部分出货</span>'; 
		}
		
		function formatterCheckStatus(value, row, index){
			return formatterStatus(value, row, index);
		}
		
		function formatterDetail(value, row, index){
			return '<span style="color:red;cursor:pointer" onclick="openDeliverDetail(\''+index+'\')">明细</span>'; 
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
		
		var deliver_code ;
		function newEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				$('#ffDeliverDetail').form('load',row);
				$('#deliver_status').combobox('disable');
				$('#dlgDeliverDetail').dialog('open');
				deliver_code = row.deliver_code;
	            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
				$('#dgDetail').datagrid({
					url : basePath + "api/deliverApply/detailPaging",
					queryParams: {
						filter_ANDS_deliver_code : deliver_code
					}
				});
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
		
		function newExpress(){
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				$('#dlgExpress').dialog('open').dialog('setTitle', '物流产品信息添加');
				$('#fm').form('load',row);
			}else{
				$.messager.alert('提示','请选中数据!','warning');
			}		
		}
		
		
		function saveExpress(){
			$('#fm').form('submit', {
				url : basePath + 'api/deliverExpress/save',
				method : "post",
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(msg) {
					var jsonobj = $.parseJSON(msg);
					if (jsonobj.state == 1) {
						$('#dlgExpress').dialog('close');
						$("#tab").tabs("select","物流明细行");
						$('#dgExpress').datagrid('reload');
					} else if (jsonobj.state == 2) {
						$.messager.alert('提示', '数量不能大于累计发货数量!', 'warning');
					}else {
						$.messager.alert('提示', 'Error!', 'error');
					}
				}
			});
		}
		
		
		function deleteExpress(){
	           var row = $('#dgExpress').datagrid('getSelected');
	            if (row){
	            //	if(row.check_status=='0'){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/deliverExpress/delete',
		            				data : {id:row.id},
		            				error : function(request) {
		            					$.messager.alert('提示','Error!','error');	
		            				},
		            				success : function(data) {
		            					var jsonobj = $.parseJSON(data);
		            					if (jsonobj.state == 1) {  
		            	                     $('#dgExpress').datagrid('reload');
		            					}else{
		            						$.messager.alert('提示','Error!','error');	
		            					}
		            				}
		            			});                    	
		                    }
		                });	            		
	            //	}else{
	            	//	$.messager.alert('提示','无法删除已提交的出货单!','error');
	            	//}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
		}
		
		function openDeliverDetail(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
			$('#ffDeliverDetail').form('load',row);
			$('#deliver_status_ss').combobox('disable');
			$('#dlgDeliverDetail').dialog('open');
			deliver_code = row.deliver_code;
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
			$('#dgDetail').datagrid({
				url : basePath + "api/deliverApply/detailPaging",
				queryParams: {
					filter_ANDS_deliver_code : deliver_code
				}
			});

		}
		
	</script>
</body>
</html>