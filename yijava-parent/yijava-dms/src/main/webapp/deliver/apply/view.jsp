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
									<td width="50">类型:</td>
									<td width="270">										
										<input name="deliver_status" class="easyui-combobox" id="deliver_status_s"
											data-options="
												valueField: 'id',
												textField: 'value',
												panelHeight:'auto',
												data: [{
													id: '4',
													value: '全部发货'
												},{
													id: '5',
													value: '部分发货'
												}]" />
									</td>
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
						<restrict:function funId="140">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>  
						</restrict:function>
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:330px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="create_date" pagination="true" iconCls="icon-search" 
					sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'deliver_code',width:150,align:'center'" sortable="true">出货单号</th>
							<th data-options="field:'dealer_name',width:150,align:'center'" sortable="true">经销商</th>
							<th data-options="field:'order_code',width:150,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'order_date',width:150,align:'center'" sortable="true" formatter="formatterdate">下单时间</th>
							<th data-options="field:'create_date',width:150,align:'center'" sortable="true" formatter="formatterdate">编制时间</th>
<!-- 							<th data-options="field:'express_number',width:150,align:'center'" sortable="true">快递号</th> -->
							<th data-options="field:'deliver_status',width:80,align:'center'" formatter="formatterDeliverStatus" sortable="true">发货类型</th>
							<th data-options="field:'check_status',width:80,align:'center'"  formatter="formatterCheckStatus">审核状态</th>
							<restrict:function funId="145">
								<th data-options="field:'custom',width:80,align:'center'" formatter="formatterDetail">明细</th>
							</restrict:function>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tb">
				<restrict:function funId="141">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				</restrict:function>
				<restrict:function funId="142">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
				</restrict:function>
				<restrict:function funId="143">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity()">删除</a>
        		</restrict:function>
        		<restrict:function funId="161">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" onclick="ToCheckEntity()">提交审核</a>
        		</restrict:function>
        		<restrict:function funId="160">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="CheckEntity()">审核</a>
        		</restrict:function>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
		
   	<div id="dlgOrder" class="easyui-dialog" style="width:710px;height:450px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttonsOrder">
				<table id="dgOrder" title="订单查询结果" style="height:365px;width:680px;" method="get" toolbar="#dgOrder-tb"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" iconCls="icon-search" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'dealer_name',width:200,align:'center'" sortable="true">经销商</th>
							<th data-options="field:'order_code',width:200,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'order_status',width:80,align:'center'"  formatter="formatterStatus" sortable="true">状态</th>
							<th data-options="field:'order_date',width:150,align:'center'" sortable="true" formatter="formatterdate">下单时间</th>
						</tr>
					</thead>
				</table>
				<div id="dgOrder-tb" style="padding:5px;height:auto">
						经销商名称:&nbsp;&nbsp;<input class="easyui-validatebox" type="text" style="width:200px; " name="dg_dealer_name"></input>
						订单号:&nbsp;&nbsp;<input class="easyui-validatebox" type="text" style="width:200px; " name="dg_order_code"></input>
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchOrder()">查询</a>
				</div>
    </div>
    <div id="dlg-buttonsOrder">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-redo" onclick="nextSetp();">下一步</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgOrder').dialog('close')">取消</a>
    </div>
    
    <div id="dlgOneSetp" class="easyui-dialog" style="width:803px;height:550px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttonsOneSetp">
	        <form id="fm" method="post" novalidate enctype="multipart/form-data">
	        	<input type="hidden" name="deliver_id" id="deliver_id">
	        	<input type="hidden" name="order_id" id="order_id">
	        	<input type="hidden" name="order_date" id="order_date">
	        	<input type="hidden" name="dealer_id" id="dealer_id">
	        	<input type="hidden" name="dealer_address_id" id="dealer_address_id">
			<table>
				<tr>
					<td>经销商名称:</td>
					<td><input class="easyui-validatebox" type="text" style="width:200px;"
						name="dealer_name" id="dealer_name" data-options="required:false" readonly="readonly"></input>
					</td>
				</tr>
				<tr>
					<td>订单号:</td>
					<td><input class="easyui-validatebox" type="text" style="width:200px;"
						name="order_code" id="order_code" data-options="required:false" readonly="readonly"></input>
					</td>
					<td></td>
					<td>发货类型:</td>
					<td>
						<input name="deliver_status" width="200px" class="easyui-combobox" id="deliver_status"
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
						<td>特殊说明:</td>
			             <td colspan="4"><textarea name="remark" cols="65" style="height:30px;"></textarea></td>
				</tr>
			</table>
				 <input type="hidden" name="ids" id="ids">
	        	<input type="hidden"  name="deliver_number_sums" id="deliver_number_sums">
	        	<input type="hidden"  name="deliver_dates" id="deliver_dates">
	        	<input type="hidden"  name="arrival_dates" id="arrival_dates">
	        	<input type="hidden"  name="deliver_remarks" id="deliver_remarks">
			<div style="width:755px; padding: 5px 5px 5px 5px;">
				<table id="dgOrderOneSetp" title="详情查询结果" style="height:330px" method="get" toolbar='#tbOneSetp'
						rownumbers="true" singleSelect="false" pagination="false" iconCls="icon-search" sortName="id" sortOrder="asc">
						<thead>
							<tr>
<!-- 							formatter="formatterCheck" -->
							<th field="id" checkBox="true"></th>
<!-- 							<th data-options="field:'product_item_number',width:100,align:'center'" sortable="true">产品编码</th> -->
							<th data-options="field:'product_name',width:100,align:'center'" sortable="true">产品名称</th>
							<th data-options="field:'models',width:65,align:'center'" sortable="true">产品规格</th>
							<th data-options="field:'order_number_sum',width:80,align:'center'" sortable="true">数量</th>
							<th data-options="field:'deliver_number_sum',width:80,align:'center',editor:'numberbox'">发货数量</th>
							<th data-options="field:'deliver_date',width:100,align:'center',editor:'datebox'" formatter="formatterdate">预计发货日期</th>
							<th data-options="field:'arrival_date',width:100,align:'center',editor:'datebox'" formatter="formatterdate">预计到货日期</th>
							<th data-options="field:'deliver_remark',width:150,align:'center',editor:'text'">备注</th>
							</tr>
						</thead>
					</table>
			</div>
	        </form>
	         <div id="tbOneSetp" style="height:auto">
	         	<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" 
	         		onclick="$('#dgOrderOneSetp').datagrid('reload');">刷新</a>
<!-- 		        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="accept()">保存</a> -->
		    </div>
    </div>
    <div id="dlg-buttonsOneSetp">
     	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" id="preSetp" onclick="newEntity();">上一步</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" id="btnSetp1" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" id="btnSetp2" onclick="updateEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgOneSetp').dialog('close')">取消</a>
    </div>
		
		
	<div id="dlgDeliverDetail" class="easyui-dialog" title="申请出货明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
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
									<td>发货类型:</td>	
									<td><input name="deliver_status" class="easyui-combobox" id="deliver_status_ss"
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
										<td>特殊说明:</td>
							             <td colspan="4"><textarea name="remark" cols="65" style="height:30px;"></textarea></td>
								</tr>
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="tabs" class="easyui-tabs" style="width:925px;height:auto;">
				<div title="明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgDetail" class="easyui-datagrid" title="订单明细信息" style="height:330px" method="get"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="delivery_detail_id" sortOrder="desc">
						<thead>
							<tr>
							<th data-options="field:'product_name',width:100,align:'center'" sortable="true">产品名称</th>
							<th data-options="field:'models',width:65,align:'center'" sortable="true">产品规格</th>
							<th data-options="field:'order_number_sum',width:80,align:'center'" sortable="true">数量</th>
							<th data-options="field:'deliver_number_sum',width:80,align:'center',editor:'numberbox'">发货数量</th>
							<th data-options="field:'deliver_date',width:100,align:'center',editor:'datebox'" formatter="formatterdate">预计发货日期</th>
							<th data-options="field:'arrival_date',width:100,align:'center',editor:'datebox'" formatter="formatterdate">预计到货日期</th>
							<th data-options="field:'deliver_remark',width:150,align:'center',editor:'text'">备注</th>
							</tr>
						</thead>
					</table>
				</div>
				<div title="流程记录" style="padding: 5px 5px 5px 5px;" >
					<table id="dgflow_record" class="easyui-datagrid" title="查询结果" style="height: 330px">
						<thead>
							<tr>
								<th data-options="field:'user_id',width:80"  sortable="true" hidden="true">修改人id</th>	
								<th data-options="field:'user_name',width:80"  sortable="true">修改人</th>							
								<th data-options="field:'create_date',width:120" sortable="true" formatter="formatterdate">日期</th>
								<th data-options="field:'action_name',width:120"  sortable="true">动作</th>
								<th data-options="field:'content',width:220"  sortable="true" formatter="FormatFlowlog" >内容</th>
								<th data-options="field:'check_user_id',width:10"  sortable="true" hidden="true">修改人id</th>	
								<th data-options="field:'check_user_name',width:10"  sortable="true" hidden="true">修改人</th>						
								<th data-options="field:'check_reason',width:150">处理意见</th>	
								<th data-options="field:'sign',width:100" formatter="formattersign">签名</th>														
							</tr>
						</thead>
					</table> 
				</div>
				<div title="审核" style="padding: 5px 5px 5px 5px;">
					<form id="base_form_check" action="" method="post" enctype="multipart/form-data">
							<table style="height: 330px">
								<tr height="20" >
									<td>处理选项:</td>
									<td>
									<select class="easyui-combobox" name="status" style="width:200px;">
										<option value="1">同意</option>
										<option value="2">驳回</option>
									</select>
									</td>								
								</tr>
								<tr>
									<td>处理意见:</td>
									<td>
									<textarea name="check_reason" style="height:60px;width:260px;"></textarea>
									</td>								
								</tr>
								<tr height="100"><td colspan="2">
								<input type="hidden" name="bussiness_id" id="bussiness_id">
								<input type="hidden" name="flow_id" id="flow_id" value="">
								<div style="text-align: right; padding: 5px">
										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveFlowCheck()">提交</a>
<!-- 										<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#dlgflowcheck').dialog('close')">取消</a>					    -->
								</div>				
								</td>
								</tr>					
							</table>
					</form>					
			</div>
			</div>
		</div>
		<div id="dlg-buttons">
			<restrict:function funId="144">
<!-- 	        	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" id="submitDeliver" onclick="submitDeliver();">提交</a> -->
	        </restrict:function>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgDeliverDetail').dialog('close')">取消</a>
	    </div>
		
		
	<script type="text/javascript">
		$(function() {
			$('#dg').datagrid({
				  url : basePath +"api/deliverApply/paging" ,
					queryParams: {
						filter_ANDS_order_status : $('#deliver_status_s').combobox('getValue')
					},
					onLoadSuccess:function(data){ 
						  $(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
					 }
			});
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_order_code: $('input[name=order_code]').val(),
		    	filter_ANDS_deliver_code: $('input[name=deliver_code]').val(),
		    	filter_ANDS_deliver_status: $('input[name=deliver_status]').val(),
		    	filter_ANDS_start_date: $('input[name=start_date]').val(),
		    	filter_ANDS_end_date: $('input[name=end_date]').val(),
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
			return '<a class="infoBtn" href="javascript:void(0)"  onclick="openDeliverDetail('+index+')" ></a>';
			//return '<span style="color:red;cursor:pointer" onclick="openDeliverDetail(\''+index+'\')">明细</span>'; 
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
		
		function newEntity(){
			$('#dlgOneSetp').dialog('close');
			$('#dlgOrder').dialog('open').dialog('setTitle', '发货申请第一部');
			$('#dgOrder').datagrid({
				  url : basePath +"api/order/api_paging" 
			});		
		}		
		
		function doSearchOrder(){
		    $('#dgOrder').datagrid('load',{
		    	filter_ANDS_order_code: $('input[name=dg_order_code]').val(),
		    	filter_ANDS_dealer_name: $('input[name=dg_dealer_name]').val()
		    });
		}
		
		function nextSetp(){
			var row = $('#dgOrder').datagrid('getSelected');
			if (row){
				$('#dlgOrder').dialog('close');
				$('#dlgOneSetp').dialog('open').dialog('setTitle', '发货申请第二部');
				$('#fm').form('clear');
				$('#preSetp').show();
				$("#order_id").val(row.id);
				$("#order_code").val(row.order_code);
				$("#order_date").val(row.order_date);
				$("#dealer_id").val(row.dealer_id);
				$("#dealer_name").val(row.dealer_name);
				$("#dealer_address_id").val(row.dealer_address_id);
				$('#deliver_status').combobox('enable');
				$("#btnSetp1").show();
				$("#btnSetp2").hide();
				$('#dgOrderOneSetp').datagrid({
					url : basePath + "api/orderdetail/list",
					onClickRow: onClickRow,
					queryParams: {
						filter_ANDS_order_code : row.order_code
					},
					onLoadSuccess:function(data){ 
						 $('#dgOrderOneSetp').datagrid('showColumn',"id");  
					}
				});
				//$("#btnSetp").unbind("click");
				//$("#btnSetp").bind("click",function (){saveEntity();});
			}else{
				$.messager.alert('提示','请选中数据!','warning');
			}
		}
		
		var editIndex = undefined;
	    function endEditing(){
	          if (editIndex == undefined){return true ;}
	            if ($('#dgOrderOneSetp').datagrid('validateRow', editIndex)){
	                $('#dgOrderOneSetp').datagrid('endEdit', editIndex);
	                editIndex = undefined;
	                return true;
	            } else {
	                return false;
	            }
	      }
	     function onClickRow(index){
	            if (editIndex != index){
	                if (endEditing()){
	                    $('#dgOrderOneSetp').datagrid('selectRow', index).datagrid('beginEdit', index);
	                    editIndex = index;
	                    $('#dgOrderOneSetp').datagrid('beginEdit', index);
	                } else {
	                    $('#dgOrderOneSetp').datagrid('selectRow', editIndex);
	                }
	            }
	     }
	     function endEdit(){
 			var rows = $('#dgOrderOneSetp').datagrid('getRows');
           	for ( var i = 0; i < rows.length; i++) {
           		$('#dgOrderOneSetp').datagrid('endEdit', i);
	        }
           	editIndex = undefined;
	     }
		
		function saveEntity(){
			endEdit();
			var isSubmit = true ; 
			var isNumError = false;
			var checkedItems = $('#dgOrderOneSetp').datagrid('getChecked');
			var ids = [];
			var deliver_number_sums = [];
			var deliver_dates = [];
			var arrival_dates = [];
			var deliver_remarks = [];
			$.each(checkedItems, function(index, item){
				ids.push(item.id);
			});
			if(ids.length > 0){
				var updated = $('#dgOrderOneSetp').datagrid('getChanges',"updated");
				if (updated == 0) {
					$.messager.alert('提示', '数据不能为空!', 'warning');
					isSubmit = false;
					return;
				}
				for ( var i = 0; i < updated.length; i++) {
					if ($.inArray(updated[i].id, ids) != -1) {
						if (updated[i].deliver_number_sum != "") deliver_number_sums.push(updated[i].deliver_number_sum);
						if (parseInt(updated[i].deliver_number_sum) > parseInt(updated[i].order_number_sum)) isNumError = true;
						if (updated[i].deliver_date != "") deliver_dates.push(updated[i].deliver_date);
						if (updated[i].arrival_date != "") arrival_dates.push(updated[i].arrival_date);
						deliver_remarks.push(updated[i].deliver_remark);
					}
				}
				
				if(deliver_number_sums.length != ids.length){
					isSubmit = false;
					$.messager.alert('提示', '发货数量不能为空!', 'warning');
					return;
				}
				if(isNumError){
					isSubmit = false;
					$.messager.alert('提示', '发货数量不能大约订单数量!', 'warning');
					return;
				}
				if(deliver_dates.length != ids.length){
					isSubmit = false;
					$.messager.alert('提示', '预计发货日期不能为空!', 'warning');
					return;
				}
				if(arrival_dates.length != ids.length){
					isSubmit = false;
					$.messager.alert('提示', '预计到货日期不能为空!', 'warning');
					return;
				}
				
				if (isSubmit) {
					$("#ids").val(ids.join(","));
					$("#deliver_number_sums").val(deliver_number_sums.join(","));
					$("#deliver_dates").val(deliver_dates.join(","));
					$("#arrival_dates").val(arrival_dates.join(","));
					$("#deliver_remarks").val(deliver_remarks.join(","));
					$('#fm').form('submit', {
						url : basePath + 'api/deliverApply/save',
						method : "post",
						onSubmit : function() {
							return $(this).form('validate');
						},
						success : function(msg) {
							var jsonobj = $.parseJSON(msg);
							if (jsonobj.state == 1) {
								$('#dlgOneSetp').dialog('close');
								$('#dg').datagrid('reload');
							} else {
								$.messager.alert('提示', 'Error!', 'error');
							}
						}
					});
				}
			} else {
				$.messager.alert('提示', '请选中数据!', 'warning');
				isSubmit = false;
			}
		}
		
		
		function editEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				if(row.check_status=='0' || row.check_status=='2'){
					$('#dlgOneSetp').dialog('open').dialog('setTitle', '发货申请更新');
					$('#fm').form('clear');
					$('#fm').form('load', row);
					$("#preSetp").hide();
					$("#btnSetp2").show();
					$("#btnSetp1").hide();
					$('#deliver_status').combobox('disable');
					$('#dgOrderOneSetp').datagrid({
						url : basePath + "api/deliverApply/detailList",
						onClickRow: onClickRow,
						queryParams: {
							filter_ANDS_deliver_code : row.deliver_code
						},
						onLoadSuccess:function(data){ 
							 $('#dgOrderOneSetp').datagrid('hideColumn',"id");  
						}
					});					
				}else{
					$.messager.alert('提示','无法更新已提交的出货单!','error');
				}

			}else{
				$.messager.alert('提示','请选中数据!','warning');
			}
		}
		
		function updateEntity(){
			endEdit();
			var isNumError = false;
			var isSubmit = true ; 
			//var checkedItems = $('#dgOrderOneSetp').datagrid('getRows');
			var ids = [];
			var deliver_number_sums = [];
			var deliver_dates = [];
			var arrival_dates = [];
			var deliver_remarks = [];
			//$.each(checkedItems, function(index, item){
			//	ids.push(item.delivery_detail_id);
			//});
			//if(ids.length > 0){
				var updated = $('#dgOrderOneSetp').datagrid('getChanges',"updated");
		//		if (updated == 0) {
			//		$.messager.alert('提示', '数据不能为空!', 'warning');
				//	isSubmit = false;
				//	return;
			//	}
				for ( var i = 0; i < updated.length; i++) {
						ids.push(updated[i].delivery_detail_id);
				//	if ($.inArray(updated[i].delivery_detail_id, ids) != -1) {
						if (updated[i].deliver_number_sum != "") deliver_number_sums.push(updated[i].deliver_number_sum);
						if (parseInt(updated[i].deliver_number_sum) > parseInt(updated[i].order_number_sum)) isNumError = true;
						if (updated[i].deliver_date != "") deliver_dates.push(updated[i].deliver_date);
						if (updated[i].arrival_date != "") arrival_dates.push(updated[i].arrival_date);
						deliver_remarks.push(updated[i].deliver_remark);
					//}
				}
				
				if(deliver_number_sums.length != ids.length){
					isSubmit = false;
					$.messager.alert('提示', '发货数量不能为空!', 'warning');
					return;
				}
				if(isNumError){
					isSubmit = false;
					$.messager.alert('提示', '发货数量不能大约订单数量!', 'warning');
					return;
				}
				if(deliver_dates.length != ids.length){
					isSubmit = false;
					$.messager.alert('提示', '预计发货日期不能为空!', 'warning');
					return;
				}
				if(arrival_dates.length != ids.length){
					isSubmit = false;
					$.messager.alert('提示', '预计到货日期不能为空!', 'warning');
					return;
				}
				
				if (isSubmit) {
					$("#ids").val(ids.join(","));
					$("#deliver_number_sums").val(deliver_number_sums.join(","));
					$("#deliver_dates").val(deliver_dates.join(","));
					$("#arrival_dates").val(arrival_dates.join(","));
					$("#deliver_remarks").val(deliver_remarks.join(","));
					$('#fm').form('submit', {
						url : basePath + 'api/deliverApply/update',
						method : "post",
						onSubmit : function() {
							return $(this).form('validate');
						},
						success : function(msg) {
							var jsonobj = $.parseJSON(msg);
							if (jsonobj.state == 1) {
								$('#dlgOneSetp').dialog('close');
								$('#dg').datagrid('reload');
							} else {
								$.messager.alert('提示', 'Error!', 'error');
							}
						}
					});
				}
			//} else {
			//	$.messager.alert('提示', '请选中数据!', 'warning');
			//	isSubmit = false;
			//}
		}
		
		
		function deleteEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	            	if(row.check_status=='0' || row.check_status=='2'){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/deliverApply/delete',
		            				data : {id:row.deliver_id},
		            				error : function(request) {
		            					$.messager.alert('提示','Error!','error');	
		            				},
		            				success : function(data) {
		            					var jsonobj = $.parseJSON(data);
		            					if (jsonobj.state == 1) {  
		            	                     $('#dg').datagrid('reload');
		            					}else{
		            						$.messager.alert('提示','Error!','error');	
		            					}
		            				}
		            			});                    	
		                    }
		                });	            		
	            	}else{
	            		$.messager.alert('提示','无法删除已提交的出货单!','error');
	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
		}
		
		
		var deliver_code ;
		var deliver_id;
		function openDeliverDetail(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
			$('#ffDeliverDetail').form('load',row);
			$('#deliver_status_ss').combobox('disable');
			$('#dlgDeliverDetail').dialog('open');
			deliver_code = row.deliver_code;
			deliver_id = row.deliver_id;
			if(row.check_status == 0 || row.check_status == 2){
				$("#submitDeliver").linkbutton("enable");
			}else{
				$("#submitDeliver").linkbutton("disable");
			}
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
			$('#dgDetail').datagrid({
				url : basePath + "api/deliverApply/detailPaging",
				queryParams: {
					filter_ANDS_deliver_code : deliver_code
				}
			});
			
			 LoadCheckFlowRecord(row.deliver_id);
			 $('#tabs').tabs('disableTab', '审核'); 
		}
		
		
		function submitDeliver(){
            $.messager.confirm('Confirm','提交后将不能在修改，确定提交吗?',function(r){
                if (r){
        			$.ajax({
        				type : "POST",
        				url : basePath + 'api/deliverApply/submit',
        				data : {deliver_code : deliver_code , deliver_id :deliver_id},
        				error : function(request) {
        					$.messager.alert('提示','Error!','error');	
        				},
        				success : function(data) {
        					var jsonobj = $.parseJSON(data);
        					if (jsonobj.state == 1) {  
        	                     $('#dg').datagrid('reload');
        	                     $('#dgflow_record').datagrid('reload');
        					}else{
        						$.messager.alert('提示','Error!','error');	
        					}
        				}
        			});                    	
                }
            });	
		}
		
		
		

		/**
		审核
		*/
		function CheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row && row.check_status ==1){				
				 $.messager.confirm('提示','确定要要审核吗  ?',function(r){
					 $('#bussiness_id').val(row.deliver_id);
					 $("#flow_id").val(deliverflow_identifier_num);
					 //填充基本信息
					  $('#base_form_flowcheck').form('load', row);
					 //var dgflow = $('#dgflow').datagrid().datagrid('getPager'); 
					 //dgflow.pagination(); 
					 //加载流程记录
					 //LoadCheckFlowRecord(row.deliver_id);
					 openDeliverDetail($('#dg').datagrid('getRowIndex'));
					 $('#tabs').tabs('enableTab', '审核'); 
					 $('#tabs').tabs('select', '审核');
					 //$('#dlgDeliverDetail').dialog('open').dialog('setTitle', '审核');
				 });
			}else{
				$.messager.alert('提示','请选中数据!','warning');
			}
			 
		}
		
		
		/**
		提交审核
		*/
		function ToCheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row && (row.check_status ==0 || row.check_status ==2) ){			
				 $.messager.confirm('提示','提交后将不能修改 ,确定要要提交审核吗  ?',function(r){
					 if (r){
	                        $.post(basePath+'api/deliverApply/updatetocheck',{deliver_id:row.deliver_id},function(result){
	        			    	if(result.state==1){
	        			    		$('#dg').datagrid('reload');
	                            } else {
	                                $.messager.show({    // show error message
	                                    title: 'Error',
	                                    msg: '提交审核失败,请检查单据'
	                                });
	                            } 
	                        },'json');
	                    }
				 });
			}else
			{
				$.messager.alert('提示---数据已经提交不能修改','请选中数据!','warning');
			}
		}
		
		function  LoadCheckFlowRecord(bussinessId){
			 $('#dgflow_record').datagrid({
			    url:basePath+'api/flowlog/list?bussiness_id='+bussinessId+"&flow_id="+deliverflow_identifier_num
			}); 
		}
		function FormatFlowlog (value, row, index) {
			if(row.user_name  && row.action_name){
				return row.user_name +" 进行"+row.action_name ;
			}else{
				return row.user_name ;
			}
		}
		 function formattersign(value, row, index){
			 if(row.sign && row.sign!="")
			 	return '<span><img src="'+basePath+'resource/signimg/'+value+'" width="50" height="50"></span>'; 
		 }
		 
		function saveFlowCheck(){

				$('#base_form_check').form('submit', {
				    url:basePath+'/api/flowrecord/do_flow',
				    method:"post",
				    onSubmit: function(){
				        // do some check
				        // return false to prevent submit;
				    	return $(this).form('validate');;
				    },
				    success:function(msg){
				    	var jsonobj= eval('('+msg+')');  
				    	if(jsonobj.state==1){
				    			//clearForm();			    			
				    			$('#dlgDeliverDetail').dialog('close');
				    			//var pager = $('#dg').datagrid().datagrid('getPager');
				    			//pager.pagination('select');	
				    		$('#dg').datagrid('reload');
					   			
				    		}
				    }		
				});		
			}
		
	</script>
</body>
</html>