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
					<restrict:function funId="146">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a> 
					</restrict:function>  
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:330px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="express_code" pagination="true" iconCls="icon-search" 
					sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'deliver_code',width:150,align:'center'" sortable="true">出货单号</th>
							<th data-options="field:'dealer_name',width:150,align:'center'" sortable="true">经销商</th>
							<th data-options="field:'order_code',width:150,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'order_date',width:150,align:'center'" sortable="true">下单时间</th>
							<th data-options="field:'create_date',width:150,align:'center'" sortable="true">编制时间</th>
<!-- 							<th data-options="field:'express_number',width:150,align:'center'" sortable="true">快递号</th> -->
							<th data-options="field:'deliver_status',width:80,align:'center'" formatter="formatterDeliverStatus" sortable="true">发货类型</th>
							<th data-options="field:'check_status',width:80,align:'center'"  formatter="formatterCheckStatus">审核状态</th>
<!-- 							<th data-options="field:'express_code',width:180,align:'center'"  formatter="formatterExpressStatus" sortable="true">物流状态</th> -->
							<th data-options="field:'express_code',width:180,align:'center'">快递号</th>
<!-- 							<th data-options="field:'custom',width:80,align:'center'" formatter="formatterDetail">明细</th> -->
						</tr>
					</thead>
				</table>
			</div>
			<div id="tb">
				<restrict:function funId="147">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">发货</a>
				</restrict:function>
				<restrict:function funId="148">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="newEntity()">编辑</a>
				</restrict:function>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>

		
		
	<div id="dlgDeliverDetail" class="easyui-dialog" title="出货物流明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="ffDeliverDetail" method="post" enctype="multipart/form-data">
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
									<td><input name="deliver_status" class="easyui-combobox" id="deliver_statusCombobox" readonly="readonly"
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
									<td>送货地址:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:250px;" id="address"></input></td>
									<td></td>
									<td>联系人:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:100px;" id="linkman"></input></td>
									<td></td>
									<td>联系电话:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:100px;" id="linkphone"></input></td>
								</tr>
								<tr>
									<td>快递单号:</td>	
			             			<td><input class="easyui-validatebox" type="text" style="width:250px;" name="express_code" data-options="required:true"/></td>
			             			<td></td>
			             			<td>发货日期:</td>	
									<td><input class="easyui-datebox" type="text" style="width:150px;" name="express_date" data-options="required:true"/></td>
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
							</tr>
						</thead>
					</table>
					<div id="tb1">
						<restrict:function funId="149">
							<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newExpress()">物流添加</a>
						</restrict:function>
					</div>
				</div>
				<div title="物流明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgExpress" class="easyui-datagrid" title="物流明细信息" style="height:270px" method="get" toolbar="#tb2"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc">
						<thead>
							<tr>
							<th data-options="field:'product_name',width:100,align:'center'" sortable="true">产品名称</th>
							<th data-options="field:'models',width:65,align:'center'" sortable="true">产品规格</th>
							<th data-options="field:'express_num',width:80,align:'center'">出货数量</th>
							<th data-options="field:'express_sn',width:100,align:'center'">规格、批号</th>
							<th data-options="field:'validity_date',width:100,align:'center'">有效期</th>
							<th data-options="field:'remark',width:100,align:'center'">备注</th>
							<restrict:function funId="151">
								<th data-options="field:'product_sn',width:100,align:'center'" formatter="formatterProductSn">序列号</th>
							</restrict:function>
							</tr>
						</thead>
					</table>
					<div id="tb2">
						<restrict:function funId="150">
							<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteExpress()">删除</a>
						</restrict:function>
					</div>
				</div>
			</div>
		</div>
		<div id="dlg-buttons">
			<restrict:function funId="155">
	        	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="submitExpress();">提交</a>
	        </restrict:function>
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
					             	<td>出货数量:</td>
					             	<td><input name="deliver_number_sum" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>数量:</td>
					             	<td><input name="express_num" class="easyui-numberbox" style="width:150px" data-options="min:1,required:true"></td>
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
		
		
	<div id="dlgProductSn" class="easyui-dialog" style="width:403px;height:413px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true">
				<table id="dgProductSn"  class="easyui-datagrid" title="查询结果" style="height:365px;width:380px;" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="deliver_express_detail_id"  toolbar="#tb3"
						pagination="true" iconCls="icon-search" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'product_sn',width:240,align:'center'" sortable="true">序列号</th>
						</tr>
					</thead>
				</table>
				<div id="tb3">
					<restrict:function funId="152">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addExpressSn()">添加</a>
					</restrict:function>
					<restrict:function funId="153">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editExpressSn()">编辑</a>
					</restrict:function>
					<restrict:function funId="154">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteExpressSn()">删除</a>
					</restrict:function>
				</div>
    </div>
   	<div id="dlgProductSn2" class="easyui-dialog" style="width:300px;height:300px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductSn-buttons">
		        <form id="fm2" action="" method="post" enctype="multipart/form-data">
		        		  <input name="id" type="hidden">
		         		  <input name="deliver_express_detail_id" id="deliver_express_detail_id" type="hidden">
		         		  <input name="deliver_code" id="deliver_code" type="hidden">
					      <table> 
					    		<tr>
					             	<td>序列号:</td>
					             	<td><input name="product_sn"  type="text" class="easyui-validatebox" style="width:150px;" data-options="required:true" ></td>
					            </tr>
					      </table>        	
		        </form>
	    </div>
	    <div id="dlgProductSn-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveExpressSn();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductSn2').dialog('close')">取消</a>
	    </div>
		
	<script type="text/javascript">
		$(function() {
			$('#dg').datagrid({
				  url : basePath +"api/deliverApply/pagingtodelver" ,
					queryParams: {
						filter_ANDS_check_status : 3
					}
			});
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_order_code: $('input[name=order_code]').val(),
		    	filter_ANDS_deliver_code: $('input[name=deliver_code]').val(),
		    	filter_ANDS_check_status : 3
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
		
		function formatterExpressStatus(value, row, index){
			if(value)
				return '<span>'+value+'</span>'; 
			else
				return '<span>尚未发货</span>'; 
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
		
		
		 function formatterProductSn (value, row, index) { 
			 	return '<a class="productSnBtn" href="javascript:void(0)"  onclick="openProductSn('+index+')" ></a>';
		} 
		 
		 
		var deliver_code ;
		var isExpress ; 
		function newEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				isExpress = row.express_code;
				$('#ffDeliverDetail').form('clear');
				$('#ffDeliverDetail').form('load',row);
				$('#dlgDeliverDetail').dialog('open');
				deliver_code = row.deliver_code;
				$.getJSON(basePath + "api/dealerAddress/entity?id="+ row.dealer_address_id,function(result){
					$("#address").val(result.address);
					$("#linkman").val(result.linkman);
					$("#linkphone").val(result.linkphone);
				});		
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
					},
					onLoadSuccess:function(data){ 
						  $(".productSnBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
					 }
				});
			}else{
				$.messager.alert('提示','请选中数据!','warning');
			}		
		}		
		
		function newExpress(){
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				if(!isExpress){
					$('#dlgExpress').dialog('open').dialog('setTitle', '物流产品信息添加');
					$('#fm').form('clear');
					$('#fm').form('load',row);
				}else{
					$.messager.alert('提示','已发货，不能修改!','warning');
				}
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
					if(!isExpress){
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
					}else{
						$.messager.alert('提示','已发货，不能修改!','warning');
					}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
		}
		
		
		function isEmpty(s1){
		    var sValue = s1 + "";
		    var test = / /g;
		    sValue = sValue.replace(test, "");
		    return sValue==null || sValue.length<=0;
		}
		
		
		function submitExpress(){
			if(isExpress){
				submitExpressR()
			}else{
				   $.messager.confirm('Confirm','填写快递单号后无法修改出货明细,可以修改快递单号?',function(r){
	                    if (r){
	                    	submitExpressR();
	                    }
				   });
			}
		}
		
		function submitExpressR(){
				$('#ffDeliverDetail').form('submit', {
					url : basePath + 'api/deliverExpress/submitExpress',
					method : "post",
					onSubmit : function() {
						return $(this).form('validate');
					},
					success : function(msg) {
						var jsonobj = $.parseJSON(msg);
						if (jsonobj.state == 1) {
							$('#dlgDeliverDetail').dialog('close');
							$('#dg').datagrid('reload');
						}else if (jsonobj.state == 2) {
							$("#tab").tabs("select","物流明细行");
							$.messager.alert('提示', '物流明细行中序列号不能为空!', 'warning');
						}else {
							$.messager.alert('提示', 'Error!', 'error');
						}
					}
				});
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
		
		var deliver_express_detail_id;
		var sn_num;
		function openProductSn(index){
			$('#dgExpress').datagrid('selectRow',index);
			var row = $('#dgExpress').datagrid('getSelected');
			$('#dlgProductSn').dialog('open').dialog('setTitle', '['+row.express_sn+']产品序列号维护');
			deliver_express_detail_id = row.id;
			sn_num = row.express_num;
			$('#dgProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgProductSn').datagrid({
				url : basePath + "api/deliverExpressSn/paging",
				queryParams: {
					filter_ANDS_deliver_express_detail_id : deliver_express_detail_id
				}
			});
		}
		
		var url;
		function addExpressSn(){
			if(!isExpress){
				data = $('#dgProductSn').datagrid('getData');
				if(parseInt(data.total) ==0 || parseInt(data.total) < parseInt(sn_num) ){
					$('#dlgProductSn2').dialog('open').dialog('setTitle', '序列号添加');
					$('#fm2').form('clear');
					$('#fm2').form('load',{
						"deliver_express_detail_id":deliver_express_detail_id,
						"deliver_code" : deliver_code});
					url = basePath + 'api/deliverExpressSn/save';
				} else {
					$.messager.alert('提示', '序列号数量已满!', 'warning');
				}
			} else {
				$.messager.alert('提示', '已发货，不能修改!', 'warning');
			}

		}

		function editExpressSn() {
			var row = $('#dgProductSn').datagrid('getSelected');
			if (row) {
				if (!isExpress) {
					$('#dlgProductSn2').dialog('open').dialog('setTitle',
							'序列号更新');
					$('#fm2').form('clear');
					$('#fm2').form('load', row);
					url = basePath + 'api/deliverExpressSn/update';
				} else {
					$.messager.alert('提示', '已发货，不能修改!', 'warning');
				}

			} else {
				$.messager.alert('提示', '请选中数据!', 'warning');
			}
		}
		function saveExpressSn() {
			$('#fm2').form('submit', {
				url : url,
				method : "post",
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(msg) {
					var jsonobj = $.parseJSON(msg);
					if (jsonobj.state == 1) {
						$('#dlgProductSn2').dialog('close');
						$('#dgProductSn').datagrid('reload');
					} else if (jsonobj.state == 2) {
						$.messager.alert('提示', '序列号重复', 'warning');
					} else {
						$.messager.alert('提示', 'Error!', 'error');
					}
				}
			});
		}

		function deleteExpressSn() {
			var row = $('#dgProductSn').datagrid('getSelected');
			if (row) {
				if (!isExpress) {
					$.messager.confirm('Confirm', '是否确定删除?', function(r) {
						if (r) {
							$.ajax({
								type : "POST",
								url : basePath + 'api/deliverExpressSn/delete',
								data : {
									id : row.id
								},
								error : function(request) {
									$.messager.alert('提示', 'Error!', 'error');
								},
								success : function(data) {
									var jsonobj = $.parseJSON(data);
									if (jsonobj.state == 1) {
										$('#dgProductSn').datagrid('reload');
									} else {
										$.messager.alert('提示', 'Error!',
												'error');
									}
								}
							});
						}
					});
				} else {
					$.messager.alert('提示', '已发货，不能修改!', 'warning');
				}
			} else {
				$.messager.alert('提示', '请选中数据!', 'warning');
			}
		}
	</script>
</body>
</html>