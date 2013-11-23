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
								<tr height="30">
									<td width="60">移库单号:</td>	
									<td width="270"><input class="easyui-validatebox" style="width:150px" type="text" name="move_storage_code"></input></td>
									<td width="60">经销商:</td>
									<td width="270">
									<c:if test="${user.fk_dealer_id!='0'}">
										<input class="easyui-validatebox" readonly="readonly" style="width:150px" id="move_storage_party_name" value="${user.dealer_name}" style="width:150px" maxLength="100">
										<input class="easyui-validatebox" type="hidden" name="fk_move_storage_party_id" id="fk_move_storage_party_id" value="${user.fk_dealer_id}" style="width:150px" maxLength="100">
									</c:if>
									<c:if test="${user.fk_department_id!='0'}">
										<input class="easyui-combobox" name="fk_move_storage_party_id" id="fk_move_storage_party_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}api/userDealerFun/list?t_id=${user.teams}&u_id=${user.id}',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto'
						            			"/>
						            </c:if>
									</td>
									<td width="60">状态:</td>
									<td width="270">										
										<input name="status" class="easyui-combobox" data-options="
											valueField: 'id',
											textField: 'value',
											data: [{
												id: '0',
												value: '未提交'
											},{
												id: '1',
												value: '成功'
											},]" />
									</td>
								</tr>
								<tr>
									<td>开始时间:</td>
									<td>
										<input name="move_start_date" id="move_start_date" class="easyui-datebox"></input>
									</td>
									<td>结束时间:</td>
									<td>
										 <input name="move_end_date" id="move_end_date" class="easyui-datebox"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="80">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:370px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" 
					iconCls="icon-search" sortOrder="desc" toolbar="#tbMoveStorage">
					<thead>
						<tr>
							<th data-options="field:'id',width:10,align:'center'" hidden="true">id</th>
							<th data-options="field:'move_storage_party_name',width:200,align:'left'" sortable="true">经销商</th>
							<th data-options="field:'move_storage_code',width:160,align:'center'" sortable="true">移库单号</th>
							<th data-options="field:'move_storage_date',width:150,align:'center'" formatter="formatterdate" sortable="true">移库时间</th>
							<th data-options="field:'total_number',width:100,align:'center'" sortable="true">总数量</th>
							<th data-options="field:'status',width:80,align:'center'" formatter="formatterStatus" sortable="true">单据状态</th>
							<th data-options="field:'last_time',width:150,align:'center'" formatter="formatterdate" sortable="true">创建时间</th>
							<th data-options="field:'custom',width:80,align:'center'" formatter="formatterDetail">明细</th>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tbMoveStorage">
				<restrict:function funId="81">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				</restrict:function>
				<restrict:function funId="82">
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
        		</restrict:function>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="w" class="easyui-window" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:300px;height:150px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>移库类型:</td>
						<td>
							<input name="type" id="type" class="easyui-combobox"  readonly="readonly" data-options="
											valueField: 'id',
											textField: 'value',
											data: [{
												id: '1',
												value: '内部移库'
											},{
												id: '2',
												value: '外部移库'
											},]" />
						</td>
					</tr>
				</table>
			</form>
			<div style="margin: 10px 0;"></div>
			<div style="text-align: right; padding: 5px">
			<restrict:function funId="84">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
			</restrict:function>
			<restrict:function funId="85">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#w').window('close')">取消</a>
			</restrict:function>					   
			</div>
		</div>
		</div>
		<div id="dlgMoveStorageDetail" class="easyui-dialog" title="明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="ffMoveStorageDetail" method="post">
							<table>
								<tr>
									<td width="50">经销商:</td>
									<td width="200">
						            	<input class="easyui-validatebox" style="width:150px" readonly="readonly" type="text" name="move_storage_party_name"></input>
									</td>
									<td width="60">移库单号:</td>	
									<td width="200"><input class="easyui-validatebox" style="width:160px" readonly="readonly" type="text" name="move_storage_code"></input></td>
									<td width="60">移库时间:</td>	
									<td width="200"><input class="easyui-validatebox" style="width:150px" readonly="readonly" type="text" name="move_storage_date"></input></td>
								</tr>
								<tr>
									<td>状态:</td>
									<td>				
										<input name="status" readonly="readonly" class="easyui-combobox" data-options="
											valueField: 'id',
											textField: 'value',
											data: [{
												id: '0',
												value: '未提交'
											},{
												id: '1',
												value: '成功'
											}]" />
									</td>
								</tr>
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div>
				<table id="dgDetail" class="easyui-datagrid" title="查询结果" style="height:370px" method="get"
					 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbMoveStorageDetail">
					<thead>
						<tr>
							<th data-options="field:'id',width:100,align:'center'" hidden="true"></th>
							<th data-options="field:'fk_move_storage_id',width:100,align:'center'" hidden="true"></th>
							<th data-options="field:'fk_move_to_storage_id',width:100,align:'center'" hidden="true"></th>
							<th data-options="field:'move_storage_name',width:100,align:'center'" sortable="true">移出仓库</th>
							<th data-options="field:'product_item_number',width:100,align:'center'" sortable="true">产品编码</th>
							<th data-options="field:'models',width:100,align:'center'" sortable="true">规格型号</th>
							<th data-options="field:'batch_no',width:100,align:'center'" sortable="true">产品批次</th>
							<th data-options="field:'valid_date',width:100,align:'center'" sortable="true">有效日期</th>
							<th data-options="field:'inventory_number',width:80,align:'center'" sortable="true">库存量</th>
							<th data-options="field:'move_number',width:80,align:'center'" sortable="true">移动数量(EA)</th>
							<th data-options="field:'move_to_storage_name',width:100,align:'center'" sortable="true">移入仓库</th>
							<th data-options="field:'custom',width:80,align:'center'" formatter="formatterProductSn">明细</th>
						</tr>
					</thead>
				</table>
				<div id="tbMoveStorageDetail">    
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="saveMoveStorageDetail" onclick="newMoveStorageDetailEntity();">添加产品</a>    
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delMoveStorageDetail" onclick="removeMoveStorageDetailEntity();">删除产品</a>    
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="dlg-buttons">
			<restrict:function funId="86">
	        <a href="javascript:void(0)" class="easyui-linkbutton" id="submitMoveStorage" iconCls="icon-ok" onclick="submitMoveStorage()">提交</a>
	        </restrict:function>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgMoveStorageDetail').dialog('close')">取消</a>
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
										<td width="160px">
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
										<td width="150px"><input class="easyui-validatebox" type="text" name="product_item_number" id="product_item_number" ></input></td>
										<td>产品批次:</td>	
										<td width="150px"><input class="easyui-validatebox" type="text" name="batch_no" id="batch_no" ></input></td>
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
								<th field="product_item_number" width="80" align="center" sortable="true">产品编号</th>
								<th field="models" width="120" align="center" sortable="true">规格型号</th>
								<th field="product_cname" width="120" align="center" sortable="true">产品中文名称</th>
								<th field="batch_no" width="100" align="center" sortable="true">批号/序列号</th>
								<th field="valid_date" width="100" align="center"  sortable="true">有效期</th>
								<th field="inventory_number" width="100" align="center" sortable="true">产品数量（EA）</th>
							</tr>
						</thead>
					</table>
		</div>
		<div style="margin: 10px 0;"></div>
	    <div id="dlgProduct-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="newProductAddEntity()">添加</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProduct').dialog('close')">取消</a>
	    </div>
		<div id="dlgProductAdd" class="easyui-dialog" style="width:300px;height:350px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductAdd-buttons">
		        <form id="fm3" action="" method="post" enctype="multipart/form-data">
					      <table>
					      	    <tr>
					             	<td>移出仓库:</td>
					             	<input name="fk_move_storage_id" id="fk_move_storage_id" hidden="true" class="easyui-validatebox" style="width:150px;">
					             	<td><input name="move_storage_name" readonly="true" class="easyui-validatebox" style="width:150px;"></td>
					            </tr>
					             <tr>
					             	<td>移入仓库:</td>
					             	<td>
					             		<input class="easyui-combobox" name="fk_move_to_storage_id" id="fk_move_to_storage_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
						             				required:true,
							             			url:'${basePath}api/storage/list?dealer_id=${user.fk_dealer_id}',
								                    method:'get',
								                    valueField:'id',
													textField:'storage_name',
								                    panelHeight:'auto',
								                    onSelect:function(record){
								                    	if(record.id==$('#fk_move_storage_id').val()){
								                    		$('#fk_move_to_storage_id').combobox('unselect',record.id);
								                 		}
								                    }
						            			"/>
									</td>
					            </tr>
					    		<tr>
					             	<td>移库单号:</td>
					             	<td>
					             		<input name="move_storage_code" readonly="true" class="easyui-validatebox" style="width:150px;">
					             	</td>
					            </tr>
					            <tr>
					             	<td>规格型号:</td>
					             	<td><input name="models" readonly="true" class="easyui-validatebox" style="width:150px"></td>
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
					      </table>
		        </form>
	    </div>
	    <div id="dlgProductAdd-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveMoveStorageDetailEntity();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductAdd').dialog('close')">取消</a>
	    </div>
	    <div id="dlgProductSn" class="easyui-dialog" style="width:475px;height:415px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true">
				<table id="dgProductSn"  class="easyui-datagrid" title="查询结果" style="height:365px;width:450px;" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id"  toolbar="#tb3"
						pagination="true" iconCls="icon-search" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'product_sn',width:200,align:'center'" sortable="true">序列号</th>
							<th data-options="field:'last_time',width:200,align:'center'" formatter="formatterdate" sortable="true">更新时间</th>
						</tr>
					</thead>
				</table>
				<div id="tb3">
					<restrict:function funId="200">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="saveProductSn" onclick="selectProductSn()">添加</a>
					</restrict:function>
					<restrict:function funId="199">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="deleteProductSn" onclick="deleteProductSn()">删除</a>
					</restrict:function>
				</div>
    	</div>
    	<div id="dlgStorageProductSn" class="easyui-dialog" title="序列号列表" style="width:800px;height:495px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgStorageProductSn-buttons">
				<div class="easyui-panel" title="查询条件" style="width:775px;">
						<div style="padding: 10px 0 0 30px">
							<form id="fffdetail" method="post">
								<input type="hidden" name="batch_no" id="batch_no" value=""></input>
								<input type="hidden" name="fk_storage_id" id="fk_storage_id" value=""></input>
								<input type="hidden" name="status" id="status" value="1"></input>
								<input type="hidden" name="models" id="models" value=""></input>
								<input type="hidden" name="valid_date" id="valid_date" value=""></input>
								<table>
									<tr>
										<td>序列号:</td>	
										<td width="100px"><input class="easyui-validatebox" type="text" name="product_sn" id="product_sn" ></input></td>
									</tr>
								</table>
							</form>
						</div>
						<div style="text-align: right; padding:5px">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchProductSn()">查询</a>   
						</div>
					</div>
				<div style="margin: 10px 0;"></div>
					<table id="dgStorageProductSn" class="easyui-datagrid" title="查询结果" style="height:300px" method="get"
					rownumbers="true" singleSelect="false" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbProduct">
						<thead>
							<tr>
								<th field="storage_name" width="120" align="center" sortable="true">仓库</th>
								<th field="batch_no" width="100" align="center" sortable="true">产品批次</th>
								<th field="product_sn" width="100" align="center" sortable="true">序列号</th>
							</tr>
						</thead>
					</table>
			</div>
		<div style="margin: 10px 0;"></div>
		<div id="dlgStorageProductSn-buttons">
		      <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="addProductSn()">添加</a>
		      <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgStorageProductSn').dialog('close')">取消</a>
		</div>
	<script type="text/javascript">
		var status;
		var move_storage_id;
		var move_storage_code;
		var fk_move_storage_detail_id;
		var batch_no;
		var fk_move_storage_id;
		var fk_move_to_storage_id;
		var dealer_id=${user.fk_dealer_id};
		var models;
		var valid_date;
		$(function() {
			$('#dg').datagrid({
				url : basePath +"api/movestorage/paging",
				onLoadSuccess:function(data){ 
					$(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage'});
				}
			});
			$('#type').combobox('setValue','1');
		})
		function formatterDetail(value, row, index){
			return '<a class="infoBtn" href="javascript:void(0)" onclick="onClickMoveStorageDetail(\''+index+'\')"></span>'; 
		}
		function doSearch(){
			 $('#dg').datagrid('load',{
				  filter_ANDS_move_storage_code:$('#ff input[name=move_storage_code]').val(),
				  filter_ANDS_fk_move_storage_party_id: $('#ff input[name=fk_move_storage_party_id]').val(),
				  filter_ANDS_status: $('#ff input[name=status]').val(),
				  filter_ANDS_move_start_date: $('#ff input[name=move_start_date]').val(),
				  filter_ANDS_move_end_date: $('#ff input[name=move_end_date]').val()
			});
		}
		function formatterStatus(value, row, index){
			if(value=='0')
				return '<span>未提交</span>'; 
			else if(value=='1')
				return '<span>成功</span>';
		}
		function newEntity()
		{
			clearForm();
			$('#w').dialog('open').dialog('setTitle','添加信息');
			url =basePath+'api/movestorage/save';
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
		function destroyEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
				if(row.status=='0'){
					 $.messager.confirm('Confirm','是否确定删除?',function(r){
						 if (r){
						    $.ajax({
								type : "POST",
								url :basePath+'api/movestorage/remove',
								data:{move_storage_code:row.move_storage_code,filter_ANDS_move_storage_code:row.move_storage_code},
								error : function(request) {
									$.messager.alert('提示','抱歉,删除错误!','error');	
								},
								success:function(msg){
								    var jsonobj = $.parseJSON(msg);
		        					if (jsonobj.state == 1) {
		        						 move_storage_code=undefined;
		        	                     $('#dg').datagrid('reload');
		        	                     $('#dgDetail').datagrid('loadData', {total: 0, rows: [] });
		        	                     $('#dgDetail').datagrid({
		        	         				title:'包含产品'
		        	         			 });
		        					}else{
		        						$.messager.alert('提示','抱歉,删除错误!','error');	
		        					}
								}
							});
						 }
					});
				}else{
					$.messager.alert('提示','无法删除已成功的单据!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个单据!','warning');
			}
		}
		function clearForm(){
			//$('#ffadd').form('clear');
		}
		function clearMoveStorageDetailForm(){
			$('#fm3').form('clear');
		}
		function onClickMoveStorageDetail(index){
			$('#dg').datagrid('selectRow',index);
			openMoveStorageDetail($('#dg').datagrid('getSelected'));
		}
		//open订单项
		function openMoveStorageDetail(row,type){
			$('#ffMoveStorageDetail').form('load',row);
			$('#dlgMoveStorageDetail').dialog('open');
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
            move_storage_code = row.move_storage_code;
            move_storage_id=row.id;
			status=row.status;
			$('#dgDetail').datagrid({
				url : basePath + "api/movestoragedetail/detailpaging",
				queryParams: {
					filter_ANDS_move_storage_code : move_storage_code
				},
				onLoadSuccess:function(data){ 
					  $(".productSnBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				}
			});
			if(status!='0'){
				$('#saveMoveStorageDetail').linkbutton('disable');
				$('#delMoveStorageDetail').linkbutton('disable');
				$('#saveDraft').linkbutton('disable');
				$('#submitMoveStorage').linkbutton('disable');
				
				$('#saveProductSn').linkbutton('disable');
				$('#deleteProductSn').linkbutton('disable');
			}else{
				$('#saveMoveStorageDetail').linkbutton('enable');
				$('#delMoveStorageDetail').linkbutton('enable');
				$('#saveDraft').linkbutton('enable');
				$('#submitMoveStorage').linkbutton('enable');
				
				$('#saveProductSn').linkbutton('enable');
				$('#deleteProductSn').linkbutton('enable');
			}
		}
		//明细
		function removeMoveStorageDetailEntity()
		{
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				if(status=='0'){
					$.messager.confirm('Confirm','是否确定删除?',function(r){
						if (r){
						    $.ajax({
								type : "POST",
								url :basePath+'api/movestoragedetail/remove',
								data:{id:row.id,move_storage_code:move_storage_code},
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
						}
					});
				}else{
					$.messager.alert('提示','无法删除已成功的单据!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function newMoveStorageDetailEntity()
		{
			if(typeof(move_storage_code) != "undefined"){
				$('#dlgProduct').dialog('open');
				$('#dgProduct').datagrid({
					 url:basePath+'api/storageDetail/api_paging',
					 queryParams: {
						filter_ANDS_fk_dealer_id :dealer_id
					 }
				});
			}else
			{
				$.messager.alert('提示','请选中某个单据!','warning');
			}
		}
		function newProductAddEntity() {
			clearMoveStorageDetailForm();
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#fm3').form('load',row);
				$("#fm3 input[name=move_storage_code]").val(move_storage_code);
				$("#fm3 input[name=fk_move_storage_id]").val(row.fk_storage_id);	
				$("#fm3 input[name=move_storage_name]").val(row.storage_name);
				$('#dlgProductAdd').dialog('open').dialog('setTitle','添加产品');
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function saveMoveStorageDetailEntity(){
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#fm3').form('submit', {
					url :basePath+'api/movestoragedetail/savedetail',
				    method:"post",
				    onSubmit: function(){
				        return $(this).form('validate');
				    },
				    success:function(msg){
				    	var jsonobj = $.parseJSON(msg);
				    	if(jsonobj.state==1){
							 $('#dlgProductAdd').dialog('close');     
		                     $('#dgDetail').datagrid('reload');
		                     $('#dg').datagrid('reload');
		                     $.messager.show({
                                 title: '提示',
                                 msg: "产品添加成功!"
                             });
				    	}else if(jsonobj.state==2){
				    		$.messager.alert('提示','同一仓库相同产品相批次不可用重复移出!','error');	
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
		function submitMoveStorage(){
			if(typeof(move_storage_code) != "undefined")
			if (status=="0"){
				///var item = $('#dgProduct').datagrid('getRows');
				//if(item.length>0){
			    	$.messager.confirm('提示','提交后将不能修改 ,确定要提交吗  ?',function(r){
			    		if (r){
			    			$('#submitMoveStorage').linkbutton('disable');
					 		$.ajax({
								type : "POST",
								url :basePath+'api/movestorage/submitMoveStorage',
								data:{id:move_storage_id,move_storage_code:move_storage_code},
								error : function(request) {
									$.messager.alert('提示','抱歉,提交错误!','error');
								},
								success:function(msg){
									var jsonobj = $.parseJSON(msg);
						 			if (jsonobj.state == 1) {
						 	            $('#dg').datagrid('reload');
						 	            $('#dlgMoveStorageDetail').dialog('close')
						 			}else if (jsonobj.state == 2) {
						 				$.messager.alert('提示','抱歉,请添加产品序列号!','error');
						 			}else if(jsonobj.state == 3) {
						 				$.messager.alert('提示','抱歉,请添加产品!','error');
						 			}else if(jsonobj.state == 4) {
						 				$.messager.alert('提示','抱歉,库存不足!','error');
						 			}else{
						 				$.messager.show({
		                                    title: 'Error',
		                                    msg: "提交失败!"
		                                });
					 				}
								},
								complete:function(request){
									$('#submitMoveStorage').linkbutton('enable');
								}
							});
			    		}
			    	});
			    //}else
				//{
		    		//$.messager.alert('提示','请添加产品!','error');
				//}
			}else{
				$.messager.alert('提示','抱歉,无法提交已处理数据!','error');	
			}
		}
		function doSearchProduct(){
		    $('#dgProduct').datagrid('load',{
		    	filter_ANDS_fk_storage_id: $("#ffdetail input[name=fk_storage_id]").val(),
				filter_ANDS_fk_dealer_id : $('#ffdetail input[name=fk_dealer_id]').val(),
		    	filter_ANDS_product_item_number:$("#ffdetail input[name=product_item_number]").val(),
		    	filter_ANDS_batch_no: $("#ffdetail input[name=batch_no]").val()
		    });
		}
		function formatterIs_movestorage (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		} 
		function formatterProductSn (value, row, index) { 
			return '<a class="productSnBtn" href="javascript:void(0)"  onclick="openProductSn('+index+')" ></a>';
		}
		function doSearchProductSn(){
		    $('#dgStorageProductSn').datagrid('load',{
		    	filter_ANDS_fk_storage_id: $("#fffdetail input[name=fk_storage_id]").val(),
		    	filter_ANDS_batch_no: $("#fffdetail input[name=batch_no]").val(),
		    	filter_ANDS_product_sn: $("#fffdetail input[name=product_sn]").val(),
		    	filter_ANDS_move_storage_code: $("#fffdetail input[name=move_storage_code]").val(),
		    	filter_ANDS_models: $("#fffdetail input[name=models]").val(),
		    	filter_ANDS_valid_date: $("#fffdetail input[name=valid_date]").val(),
		    	filter_ANDS_status: 1
		    });
		}
		//SN明细
		function openProductSn(index){
			$('#dgDetail').datagrid('selectRow',index);
			var row = $('#dgDetail').datagrid('getSelected');
			$('#dlgProductSn').dialog('open').dialog('setTitle','产品下序列号');
			fk_move_storage_detail_id = row.id;
			batch_no = row.batch_no;
			fk_move_storage_id = row.fk_move_storage_id;
			fk_move_to_storage_id = row.fk_move_to_storage_id;
			models = row.models;
			valid_date = row.valid_date;
			$('#dgProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgProductSn').datagrid({
				url : basePath + "api/movestorageprodetail/paging",
				queryParams: {
					filter_ANDS_move_storage_code: move_storage_code,
					filter_ANDS_fk_storage_id : fk_move_storage_id,
					filter_ANDS_batch_no : batch_no
				}
			});
		}
		function selectProductSn(){
			$('#dlgStorageProductSn').dialog('open');
			$("#fffdetail input[name=batch_no]").val(batch_no);
			$("#fffdetail input[name=fk_storage_id]").val(fk_move_storage_id);
			$("#fffdetail input[name=models]").val(models);
			$("#fffdetail input[name=valid_date]").val(valid_date);
			$('#dgStorageProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgStorageProductSn').datagrid({
				url : basePath + "api/storageProDetail/api_paging",
				queryParams: {
					filter_ANDS_fk_storage_id: fk_move_storage_id,
					filter_ANDS_batch_no : batch_no,
					filter_ANDS_models: models,
					filter_ANDS_valid_date: valid_date,
					filter_ANDS_status : 1
				}
			});
		}
		function addProductSn(){
				var product_sns = [];
				var batch_nos = [];
	        	var rows = $('#dgStorageProductSn').datagrid('getSelections');
	        	for(var i=0; i<rows.length; i++){
	        		product_sns.push(rows[i].product_sn);
	        		batch_nos.push(rows[i].batch_no);
	        	}
	            if (rows.length>0){
		            	$.ajax({
		            	type : "POST",
		            	url : basePath + 'api/movestorageprodetail/save',
		            		data : {
		            				fk_move_storage_detail_id : fk_move_storage_detail_id,
		            				batch_nos : batch_nos.join(','),
		            				product_sns : product_sns.join(','),
		            				move_storage_code:move_storage_code,
		            				fk_move_storage_id:fk_move_storage_id,
		            				fk_move_to_storage_id:fk_move_to_storage_id
		            		},
		            		error : function(request) {
		            			$.messager.alert('提示','Error!','error');	
		            		},
		            		success : function(data) {
		            			var jsonobj = $.parseJSON(data);
		            			if (jsonobj.state == 1) {
		            	            $('#dgProductSn').datagrid('reload');
		            	            $('#dgDetail').datagrid('reload');
		            	            $('#dg').datagrid('reload');
		            	            $.messager.show({
	                                    title: '提示',
	                                    msg: "序列号添加成功!"
	                                });
		            			}else if(jsonobj.state == 2){
		            				$.messager.alert('提示','序列号已经存在!','warning');			
		            			}else{
		            				$.messager.alert('提示','Error!','error');	
		            		}
		            	}
		            }); 
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				}	
		}
		function deleteProductSn(){
	    	var row = $('#dgProductSn').datagrid('getSelected');
	    	if (row){
		    	$.messager.confirm('Confirm','是否确定删除?',function(r){
			       	 if (r){
				         $.ajax({
				            type : "POST",
				            url : basePath + 'api/movestorageprodetail/remove',
				            data : {
				            	id:row.id, 
				            	move_storage_code:move_storage_code,
				            	fk_move_storage_detail_id : row.fk_move_storage_detail_id},
				            	error : function(request) {
				            		$.messager.alert('提示','Error!','error');	
				            	},
				            	success : function(data) {
					            	var jsonobj = $.parseJSON(data);
					            	if (jsonobj.state == 1) {
					            	    $('#dgProductSn').datagrid('reload');
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
				$.messager.alert('提示','请选中数据!','warning');				
		  }	
	  }
	</script>
</body>
</html>