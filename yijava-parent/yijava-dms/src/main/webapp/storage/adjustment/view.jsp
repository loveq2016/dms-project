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
									<td><input class="easyui-validatebox" type="text" name="dealer_name" data-options="required:false"></input></td>
									<td></td>
									<td>调整单号:</td>
									<td><input class="easyui-validatebox" type="text" name="dealer_name" data-options="required:false"></input></td>
								</tr>
								<tr>
									<td>类型:</td>
									<td><input name="consignee_status" class="easyui-combobox" 
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '1',value: '其他出库'},
														{id: '2',value: '异常入库'},
														{id: '3',value: '报废'}
														]" />
									</td>
									<td></td>
									<td>状态:</td>
									<td><input name="consignee_status" class="easyui-combobox" 
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '1',value: '同意'},
														{id: '2',value: '撤销'},
														{id: '3',value: '拒绝'},
														{id: '4',value: '提交'},
														{id: '5',value: '待批'}
														]" />
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
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="100" align="center" sortable="true">经销商</th>
							<th field="adjust_storage_code" width="120" align="center" sortable="true">调整单号</th>
							<th field="type" width="120" align="center" sortable="true" formatter="formatterType">类型</th>
							<th field="total_number" width="120" align="center" sortable="true">总数量</th>
							<th field="adjust_storage_date" width="100" align="center" sortable="true">调整日期</th>
							<th field="dealer_name" width="100" align="center" sortable="true">调整人</th>
							<th field="status" width="100" align="center" sortable="true" formatter="formatterStatus">状态</th>
							<th field="info" width="100" align="center" sortable="false" formatter="formatterInfo">明细</th>
						</tr>
					</thead>
				</table>
				<div id="tb">     
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity()">删除</a>
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
		<div id="dlgAdjustDetail" class="easyui-dialog" title="库存调整明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="fm" method="post" enctype="multipart/form-data">
							<table>
								<tr>
									<td>经销商:</td>
									<td>
						            	<input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="dealer_name" id="dealer_name"/>
									</td>
								</tr>
								<tr>
									<td>库存调整单号:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="adjust_storage_code" id="adjust_storage_code"/></td>
									<td></td>
									<td>调整日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:100px;" name="adjust_storage_date" id="adjust_storage_date"/></td>
									<td></td>
									<td>调整类型:</td>	
									<td><input class="easyui-combobox" name="type" id="type" 
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '1',value: '其他出库'},
														{id: '2',value: '异常入库'},
														{id: '3',value: '报废'}
														]" />
									  </td>
									 <td></td> 
									<td>调整状态:</td>
									<td><input name="status" class="easyui-combobox" readonly="readonly" id="status"
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '0',value: '未提交'},
														{id: '1',value: '同意'},
														{id: '2',value: '撤销'},
														{id: '3',value: '拒绝'},
														{id: '4',value: '提交'},
														{id: '5',value: '待批'}
														]" />
									</td>
								</tr>
								<tr>
									<td>调整原因:</td>	
									<td colspan="4"><textarea name="remark" cols="65" style="height:30px;"></textarea></td>
								</tr>
								
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div class="easyui-tabs" style="width:925px;height:auto;">
				<div title="明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgDetail" class="easyui-datagrid" title="订单明细信息" style="height:300px" method="get"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb1">
						<thead>
							<tr>
							<th data-options="field:'storage_name',width:100,align:'center'" sortable="true">仓库</th>
							<th data-options="field:'product_item_number',width:65,align:'center'" sortable="true">产品编码</th>
							<th data-options="field:'batch_no',width:80,align:'center'" sortable="true">批次</th>
							<th data-options="field:'valid_date',width:80,align:'center',editor:'numberbox'">有效期</th>
							<th data-options="field:'inventory_number',width:100,align:'center',editor:'datebox'">库存量</th>
							<th data-options="field:'adjust_number',width:100,align:'center',editor:'datebox'">调整量</th>
							<th data-options="field:'product_sn',width:100,align:'center',editor:'datebox'" formatter="formatterProductSn">序列号</th>
							</tr>
						</thead>
					</table>
					<div id="tb1">     
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true"  id="newAdjustBtn" onclick="newDetailEntity()">添加产品</a>
        				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true"  id="deleteAdjustBtn" onclick="deleteDetailEntity()">删除产品</a>
					</div> 
				</div>
				<div title="修改记录" style="padding: 5px 5px 5px 5px;" >
					<table id="dgUpdateLog" class="easyui-datagrid" title="修改记录" style="height:370px" method="get"
						rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc">
						<thead>
							<tr>
								
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
		<div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" id="submitAdjustBtn" onclick="submitAdjustStorage();">提交</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgAdjustDetail').dialog('close')">取消</a>
	    </div>
		
	
	<div id="dlgProduct" class="easyui-dialog" title="库存列表" style="width:800px;height:495px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProduct-buttons">
				<div class="easyui-panel" title="查询条件" style="width:775px;">
						<div style="padding: 10px 0 0 30px">
							<form id="ffdetail" method="post">
								<table>
									<tr>
										<input type="hidden" name="fk_dealer_id" id="fk_dealer_id" value="${user.fk_dealer_id}"></input>
										<td>仓库:</td>
										<td width="100px">
											<input class="easyui-combobox" name="fk_storage_id" id="fk_storage_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}api/storage/list?dealer_id=${user.fk_dealer_id}',
								                    method:'get',
								                    valueField:'id',
													textField:'storage_name',
								                    panelHeight:'auto'
						            			"/>
										</td>
										<td>产品编号:</td>	
										<td width="100px"><input class="easyui-validatebox" type="text" name="product_item_number" id="product_item_number" ></input></td>
										<td>产品批次:</td>	
										<td width="100px"><input class="easyui-validatebox" type="text" name="batch_no" id="batch_no" ></input></td>
									</tr>
								</table>
							</form>
						</div>
						<div style="text-align: right; padding:5px">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchProduct()">查询</a>   
						</div>
					</div>
				<div style="margin: 10px 0;"></div>
					<table id="dgProduct" class="easyui-datagrid" title="查询结果" style="height:300px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbProduct">
						<thead>
							<tr>
								<th field="dealer_name" width="100" align="center" hidden="true">经销商</th>
								<th field="fk_storage_id" width="120" align="center" hidden="true"></th>
								<th field="storage_name" width="120" align="center" sortable="true">仓库</th>
								<th field="product_item_number" width="120" align="center" sortable="true">产品编号</th>
								<th field="product_cname" width="120" align="center" sortable="true">产品中文名称</th>
								<th field="batch_no" width="100" align="center" sortable="true">批号/序列号</th>
								<th field="valid_date" width="100" align="center" sortable="true">有效期</th>
								<th field="inventory_number" width="100" align="center" sortable="true">产品数量（EA）</th>
							</tr>
						</thead>
					</table>
		</div>
		<div style="margin: 10px 0;"></div>
	    <div id="dlgProduct-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="newProductSnEntity()">添加</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProduct').dialog('close')">取消</a>
	    </div>
	    
		<div id="dlgProductSn" class="easyui-dialog" style="width:400px;height:460px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductSn-buttons">
		        <form id="fm3" action="" method="post" enctype="multipart/form-data">
		        
		       			 <input name="adjust_storage_code" hidden="true" class="easyui-validatebox" style="width:150px;">
					      <table>
					      	     <tr>
					             	<td>仓库:</td>
					             	<input name="fk_storage_id" hidden="true" class="easyui-validatebox" style="width:150px;">
					             	<td><input name="storage_name" readonly="true" class="easyui-validatebox" style="width:150px;"></td>
					            </tr>
					            <tr>
					             	<td>产品编码:</td>
					             	<td><input name="product_item_number" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>产品名称</td>
					             	<td><input name="product_cname" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>批次</td>
					             	<td><input name="batch_no" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>有效期</td>
					             	<td><input name="valid_date" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>库存量:</td>
					             	<td><input name="inventory_number" readonly="true" class="easyui-numberbox" style="width:150px"></td>
					             </tr>
						        <tr>
					             	<td>调整数量:</td>
					             	<td><input name="adjust_number" class="easyui-numberbox" style="width:150px" data-options="required:true"></td>
					             </tr>
					             <tr>
						             <td colspan="2">
						             	<font color="red">注：
						             		<p>减少填写负数：如：-3、 </p>
						             		<p>增加填写正数：如：3</p>
						             	</font>
						             </td>
					             </tr>
					      </table>    	
		        </form>
	    </div>
	    <div id="dlgProductSn-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveAdjustStorageDetailEntity();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductSn').dialog('close')">取消</a>
	    </div>	    
	

	<script type="text/javascript">
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/adjuststorage/paging",
			onLoadSuccess:function(data){ 
				 $(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			}
		});

		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val()
		    });
		}
		
		function formatterType(value, row, index){
			if(value=='0')
				return '<span>未选择</span>'; 
			else if(value=='1')
				return '<span>其他出库</span>'; 
			else if(value=='2')
				return '<span>退货</span>'; 
			else if(value=='3')
				return '<span>异常入库</span>'; 
			else if(value=='4')
				return '<span>报废</span>'; 
		}
		
		function formatterStatus(value, row, index){
			if(value=='0')
				return '<span>未提交</span>'; 
			else if(value=='1')
				return '<span>同意</span>'; 
			else if(value=='2')
				return '<span>撤销</span>'; 
			else if(value=='3')
				return '<span>拒绝</span>'; 
			else if(value=='4')
				return '<span>提交</span>'; 
			else if(value=='5')
				return '<span>待批</span>'; 
		}

		function formatterInfo(value, row, index){
			return '<a class="infoBtn" href="javascript:void(0)"  onclick="openAdjustDetail(' + index + ');" ></a>';
		}
		
		 function formatterProductSn (value, row, index) { 
			 	return '<a class="productSnBtn" href="javascript:void(0)"  onclick="openProductSn('+index+')" ></a>';
		} 
		
		function newEntity(){
			$.getJSON(basePath + "api/adjuststorage/save",function(result){
				if(result.id==""){
					alert("Not Login");
				}else{
					$("#dealer_name").val(result.dealer_name);
					$("#adjust_storage_code").val(result.adjust_storage_code);
					$("#adjust_storage_date").val(result.adjust_storage_date);
					$('#dg').datagrid('reload');
					$('#dlgAdjustDetail').dialog('open');
					url =basePath+'api/adjuststorage/update';
				}
			});	
		}		
		
		function editEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	            	if(row.status=='0'){
	            		 idx = $('#dg').datagrid('getRowIndex',row);
	            		openAdjustDetail(idx);
						url =basePath+'api/adjuststorage/update';
	            	}else{
	            		$.messager.alert('提示','无法编辑已提交的调整单!','error');
	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }		
			
			
		}
		
		
		function deleteEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	            	if(row.status=='0'){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/adjuststorage/delete',
		            				data : {id:row.id,adjust_storage_code:row.adjust_storage_code},
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
	            		$.messager.alert('提示','无法删除已提交的调整单!','error');
	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }				
		}
		
		function newDetailEntity(){	
			
			if($('#status').combobox('getValue')==0){
				$('#dlgProduct').dialog('open');
				$('#dgProduct').datagrid({
					 url:basePath+'api/storageDetail/paging',
					 queryParams: {
						filter_ANDS_fk_dealer_id : $('#fk_dealer_id').val()
					 }
				});
			}else{
				$.messager.alert('提示','无法编辑已提交的调整单!','error');
			}

		}
		
		function deleteDetailEntity(){
	           var row = $('#dgDetail').datagrid('getSelected');
	            if (row){
	            	if($('#status').combobox('getValue')==0){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/adjuststoragedetail/delete',
		            				data : {id:row.id,adjust_storage_code:row.adjust_storage_code},
		            				error : function(request) {
		            					$.messager.alert('提示','Error!','error');	
		            				},
		            				success : function(data) {
		            					var jsonobj = $.parseJSON(data);
		            					if (jsonobj.state == 1) {  
		            	                     $('#dgDetail').datagrid('reload');
		            	                     $('#dg').datagrid('reload');
		            					}else{
		            						$.messager.alert('提示','Error!','error');	
		            					}
		            				}
		            			});                    	
		                    }
		                });	            		
	            	}else{
	            		$.messager.alert('提示','无法编辑已提交的调整单!','error');
	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }			
		}
		
		
		function newProductSnEntity() {
			$('#fm3').form('clear');
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#dlgProductSn').dialog('open').dialog('setTitle','添加产品');
				$('#fm3').form('load',row);
				
				
				
				$("#fm3 input[name=adjust_storage_code]").val(adjust_storage_code);
			}else{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		
		
		function saveAdjustStorageDetailEntity(){
		//	if($('#status').combobox('getValue')==0){
				$('#fm3').form('submit', {
					url :basePath+'api/adjuststoragedetail/save',
				    method:"post",
				    onSubmit: function(){
				        return $(this).form('validate');
				    },
				    success:function(msg){
				    	var jsonobj = $.parseJSON(msg);
				    	if(jsonobj.state==1){
							 $('#dlgProductSn').dialog('close');     
		                     $('#dgDetail').datagrid('reload');
		                     $('#dg').datagrid('reload');
				    	}else if(jsonobj.state==2){
				    		$.messager.alert('提示','不可重复添加一个批次!','error');	
				    	}else{
				    		$.messager.alert('提示','Error!','error');	
				    	}
				    }
				});				
		//	}else{
		//		$.messager.alert('提示','无法编辑已提交的调整单!','error');
		//	}
				
		}
		
		var adjust_storage_code ;
		function openAdjustDetail(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
			$('#fm').form('load',row);
			if(row.status==0){
				$('#type').combobox('setValue','1');
				$("#newAdjustBtn").linkbutton('enable');
				$("#deleteAdjustBtn").linkbutton('enable');
				$("#submitAdjustBtn").linkbutton('enable');
			}else{
				$("#newAdjustBtn").linkbutton('disable');
				$("#deleteAdjustBtn").linkbutton('disable');
				$("#submitAdjustBtn").linkbutton('disable');
			}
				
			$('#dlgAdjustDetail').dialog('open');
			adjust_storage_code = row.adjust_storage_code;
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
			$('#dgDetail').datagrid({
				url : basePath + "api/adjuststoragedetail/paging",
				queryParams: {
					filter_ANDS_adjust_storage_code : adjust_storage_code
				},
				onLoadSuccess:function(data){ 
					  $(".productSnBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				 }
			});
		}

		function doSearchProduct(){
		    $('#dgProduct').datagrid('load',{
		    	filter_ANDS_fk_storage_id: $("#ffdetail input[name=fk_storage_id]").val(),
				filter_ANDS_fk_dealer_id : $('#ffdetail input[name=fk_dealer_id]').val(),
		    	filter_ANDS_product_item_number:$("#ffdetail input[name=product_item_number]").val(),
		    	filter_ANDS_batch_no: $("#ffdetail input[name=batch_no]").val()
		    });
		}
		
		var adjust_detail_id;
		var sn_num;
		function openProductSn(index){
			$('#dgDetail').datagrid('selectRow',index);
			var row = $('#dgDetail').datagrid('getSelected');
// 			$('#dlgProductSn').dialog('open').dialog('setTitle', '['+row.express_sn+']产品序列号维护');
			adjust_detail_id = row.id;
			sn_num = Math.abs(row.adjust_number);
			alert(sn_num)
// 			$('#dgProductSn').datagrid('loadData', {total: 0, rows: []});
// 			$('#dgProductSn').datagrid({
// 				url : basePath + "api/deliverExpressSn/paging",
// 				queryParams: {
// 					filter_ANDS_deliver_express_detail_id : deliver_express_detail_id
// 				}
// 			});
		}
		
		
		function submitAdjustStorage(){
            $.messager.confirm('Confirm','提交后不能修改,是否确定提交?',function(r){
                if (r){
        			$('#fm').form('submit', {
        				url :basePath+'api/adjuststorage/submit',
        			    method:"post",
        			    onSubmit: function(){
        			        return $(this).form('validate');
        			    },
        			    success:function(msg){
        			    	var jsonobj = $.parseJSON(msg);
        			    	if(jsonobj.state==1){
        						 $('#dlgAdjustDetail').dialog('close');     
        	                     $('#dg').datagrid('reload');
        			    	}else{
        			    		$.messager.alert('提示','Error!','error');	
        			    	}
        			    }
        			});
                }
            });
			
		}
		
	</script>


</body>
</html>