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
									<input class="easyui-validatebox" type="hidden" name="type" id="type" value="3"/>
									<td width="100">销售单号:</td>	
									<td width="270"><input class="easyui-validatebox" style="width:150px" type="text" name="pull_storage_code"></input></td>
									<td width="100">经销商:</td>
									<td width="270">
										<c:choose>
											<c:when test="${user.fk_dealer_id!='0'}">
												<input class="easyui-validatebox" readonly="readonly" style="width:150px" id="pull_storage_party_name" value="${user.dealer_name}" style="width:150px" maxLength="100">
												<input class="easyui-validatebox" type="hidden" name="fk_pull_storage_party_id" id="fk_pull_storage_party_id" value="${user.fk_dealer_id}" style="width:150px" maxLength="100">					       	
											</c:when>
											<c:otherwise>
											    <input class="easyui-combobox" name="fk_pull_storage_party_id" id="fk_pull_storage_party_id" style="width:150px" maxLength="100" class="easyui-validatebox"
									             	data-options="
										               url:'${basePath}api/userDealerFun/list?t_id=${user.teams}&u_id=${user.id}',
											           method:'get',
											           valueField:'dealer_id',
											           textField:'dealer_name',
											           panelHeight:'auto'
									            	"/>
											</c:otherwise>
										</c:choose>
									</td>
									<td width="100">销售医院:</td>
									<td width="270"><input class="easyui-validatebox" style="width:150px" type="text" name="put_storage_party_name"></input></td>
								</tr>
								<tr>
									<td width="50">状态:</td>
									<td width="270">										
										<input name="status" class="easyui-combobox" data-options="
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
												value: '成功'
											}]" />
									</td>
									<td width="100">销售时间开始日期:</td>
									<td width="270">
										<input name="sales_start_date" id="sales_start_date" class="easyui-datebox"></input>
									</td>
									<td width="100">销售时间结束日期:</td>
									<td width="270">
										 <input name="sales_end_date" id="sales_end_date" class="easyui-datebox"></input>
									</td>
								</tr>
								<tr height="30">
									<td width="100">提交时间开始日期:</td>
									<td width="270">
										<input name="pull_start_date" id="pull_start_date" class="easyui-datebox"></input>
									</td>
									<td width="100">提交时间结束日期:</td>
									<td width="270">
										 <input name="pull_end_date" id="pull_end_date" class="easyui-datebox"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
					<restrict:function funId="73">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
					</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:370px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" pagination="true" 
					iconCls="icon-search" sortOrder="desc" toolbar="#tbPullStorage">
					<thead>
						<tr>
							<th data-options="field:'id',width:10,align:'center'" hidden="true">id</th>
							<th data-options="field:'pull_storage_party_name',width:150,align:'left'" sortable="true">经销商</th>
							<th data-options="field:'pull_storage_code',width:160,align:'left'" sortable="true">销售单号</th>
							<th data-options="field:'put_storage_party_name',width:150,align:'left'" sortable="true">销售医院</th>
							<th data-options="field:'total_number',width:80,align:'center'" sortable="true">总数量</th>
							<th data-options="field:'sales_date',width:150,align:'center'" formatter="formatterdate" sortable="true">销售时间</th>
							<th data-options="field:'pull_storage_date',width:150,align:'center'" formatter="formatterdate" sortable="true">提交时间</th>
							<th data-options="field:'status',width:80,align:'center'" formatter="formatterStatus" sortable="true">单据状态</th>
							<th data-options="field:'custom',width:80,align:'center'" formatter="formatterDetail">明细</th>
							<th data-options="field:'record_id',width:80,align:'center'" hidden="true"></th>
							<th data-options="field:'record_status',width:80,align:'center'" hidden="true"></th>
							<th data-options="field:'check_id',width:80,align:'center'" hidden="true"></th>
							<restrict:function funId="169">
								<th data-options="field:'custom2',width:80,align:'center'" formatter="formatterCheck">审核</th>
							</restrict:function>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tbPullStorage">
			<restrict:function funId="74">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
			</restrict:function>
			<restrict:function funId="75">
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
        	</restrict:function>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="w" class="easyui-window" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:500px;height:250px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
					    <td>销售时间:</td>
					    <td><input name="sales_date" class="easyui-datebox" data-options="required:true" style="width:150px"></input></td>
					</tr>
					<tr>
						<td>销售医院:</td>
						<td>
							<input type="hidden" id="type" name="type" value="3"/>
						    <input class="easyui-combobox" style="width:300px" name="fk_put_storage_party_id" id="fk_put_storage_party_id" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}api/dealerAuthHospital/api_list',
								                    method:'get',
								                    valueField:'hospital_id',
								                    textField:'hospital_name',
								                    panelHeight:'auto',
								                    onSelect:function functionS(s){
														$('#provinces').val(s.provinces);
														$('#area').val(s.area);
														$('#city').val(s.city);
													}
						            			"/>
						</td>
					</tr>
					<tr>
						<td>省份:</td>
						<td>
							<input class="easyui-validatebox" readonly="true" name="provinces" id="provinces" style="width:150px" maxLength="100">
						</td>
					</tr>
					<tr>
						<td>地区:</td>
						<td>
							<input class="easyui-validatebox" readonly="true" name="area" id="area" style="width:150px" maxLength="100">
						</td>
					</tr>
					<tr>
						<td>县市（区）:</td>
						<td>
							<input class="easyui-validatebox" readonly="true" name="city" id="city" style="width:150px" maxLength="100">
						</td>
					</tr>
				</table>
			</form>
			<div style="margin: 10px 0;"></div>
			<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#w').window('close')">取消</a>					   
			</div>
		</div>
		</div>
		<div id="dlgPullStorageDetail" class="easyui-dialog" title="明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="ffPullStorageDetail" method="post">
							<table>
								<tr>
									<td width="80">经销商:</td>
									<td width="200">
						            	<input class="easyui-validatebox" style="width:150px;" readonly="readonly" type="text" name="pull_storage_party_name"></input>
									</td>
									<td width="80">出售单号:</td>	
									<td width="200"><input class="easyui-validatebox" style="width:150px;" readonly="readonly" type="text" name="pull_storage_code"></input></td>
									<td width="80">提交时间:</td>	
									<td width="200"><input class="easyui-validatebox" readonly="readonly" type="text" name="pull_storage_date"></input></td>
								</tr>
								<tr>
									<td width="80">销售医院:</td>
									<td>
						            	<input class="easyui-validatebox" style="width:150px;" readonly="readonly" type="text" name="put_storage_party_name"></input>
									</td>
									<td width="50">状态:</td>
									<td width="200">				
										<input name="status" readonly="readonly" class="easyui-combobox" data-options="
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
												value: '成功'
											}]" />
									</td>
									<td>销售时间:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="sales_date"></input></td>
								</tr>
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="dlgPullStorageDetailtabs" class="easyui-tabs" style="width:925px;height:auto;">
				 <div title="明细行" style="padding: 5px 5px 5px 5px;">
					<table id="dgDetail" class="easyui-datagrid" title="查询结果" style="height:370px" method="get"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbPullStorageDetail">
						<thead>
							<tr>
								<th data-options="field:'id',width:100,align:'center'" hidden="true"></th>
								<th data-options="field:'fk_storage_id',width:100,align:'center'" hidden="true"></th>
								<th data-options="field:'storage_name',width:120,align:'left'" sortable="true">仓库</th>
								<th data-options="field:'product_item_number',width:80,align:'center'" sortable="true">产品编码</th>
								<th data-options="field:'models',width:100,align:'center'" sortable="true">规格型号</th>
								<th data-options="field:'batch_no',width:80,align:'center'" sortable="true">产品批次</th>
								<th data-options="field:'valid_date',width:120,align:'center'" sortable="true">有效日期</th>
								<th data-options="field:'inventory_number',width:80,align:'center'" sortable="true">库存量</th>
								<th data-options="field:'sales_number',width:100,align:'center'" sortable="true">销售数量(EA)</th>
								<th data-options="field:'money',width:80,align:'center'" sortable="true">医院销售价格</th>
								<th data-options="field:'product_sn',width:100,align:'center',editor:'datebox'" formatter="formatterProductSn">序列号</th>
							</tr>
						</thead>
					</table>
					<div id="tbPullStorageDetail">  
						<restrict:function funId="77">  
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="savePullStorageDetail" onclick="newPullStorageDetailEntity();">添加产品</a>
					   	</restrict:function>
					   	<restrict:function funId="78">    
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delPullStorageDetail" onclick="removePullStorageDetailEntity();">删除产品</a>
					    </restrict:function>    
					</div>
				</div>
				<div title="修改记录" style="padding: 5px 5px 5px 5px;" >
					<table id="dgUpdateLog" class="easyui-datagrid" title="修改记录" style="height:370px" method="get"
						rownumbers="true" singleSelect="true" pagination="true" sortName="user_id" sortOrder="desc">
						<thead>
							<tr>
								<th data-options="field:'user_id',width:80"  sortable="true" hidden="true">修改人id</th>	
								<th data-options="field:'user_name',width:80"  sortable="true">修改人</th>							
								<th data-options="field:'create_date',width:120" formatter="formatterdate" sortable="true">日期</th>
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
				<div id="checktab" title="审核" style="padding: 5px 5px 5px 5px;" >
					<form id="base_form_check" action="" method="post" enctype="multipart/form-data">
							<table height="370px">
								<tr height="20"><td colspan="2"></td></tr>
								<tr height="40">
									<td>处理选项:</td>
									<td>
									<select class="easyui-combobox" name="status" style="width:200px;">
										<option value="1">同意</option>
										<option value="2">驳回</option>
									</select>
									</td>
								</tr>
								<tr height="80">
									<td>处理意见:</td>
									<td>
									<textarea name="check_reason" style="height:60px;width:260px;"></textarea>
									</td>								
								</tr>
								<tr height="60">
								<td colspan="2">
									<input type="hidden" name="bussiness_id" id="bussiness_id">
									<input type="hidden" name="flow_id" id="flow_id" value="">
									<div style="text-align: right; padding: 5px">
											<a href="javascript:void(0)" class="easyui-linkbutton" id="saveCheckbtn" data-options="iconCls:'icon-save'" onclick="saveFlowCheck()">提交</a>
									</div>
								</td>
								</tr>	
								<tr height="60">
								<td colspan="2">
									
								</td>
								</tr>
								<tr height="60">
								<td colspan="2">
									
								</td>
								</tr>			
							</table>
					</form>	
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		<div id="dlg-buttons">
	        <restrict:function funId="79">
	        <a href="javascript:void(0)" class="easyui-linkbutton" id="submitPullStorage" iconCls="icon-ok" onclick="ToCheckEntity()">提交</a>
	        </restrict:function>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgPullStorageDetail').dialog('close')">取消</a>
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
								<th field="models" width="100" align="center" sortable="true">规格型号</th>
								<th field="product_cname" width="140" align="center" sortable="true">产品中文名称</th>
								<th field="batch_no" width="100" align="center" sortable="true">批号/序列号</th>
								<th field="valid_date" width="100" align="center" sortable="true">有效期</th>
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
					             	<td>仓库:</td>
					             	<input name="fk_storage_id" type="hidden" class="easyui-validatebox" style="width:150px;">
					             	<td><input name="storage_name" readonly="true" class="easyui-validatebox" style="width:150px;"></td>
					            </tr>
					    		<tr>
					             	<td>出售单号:</td>
					             	<td>
					             		<input name="pull_storage_code" readonly="true" class="easyui-validatebox" style="width:150px;">
					             	</td>
					            </tr>
					            <tr>
					             	<td>产品编码:</td>
					             	<td><input name="product_item_number" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>规格型号:</td>
					             	<td><input name="models" readonly="true" class="easyui-validatebox" style="width:150px"></td>
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
					             	<td>销售价格:</td>
					             	<td><input name="money" id="money" class="easyui-numberbox" style="width:150px" 
									data-options="required:true"></td>
					            </tr>
					      </table>    	
		        </form>
	    </div>
	    <div id="dlgProductAdd-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="savePullStorageDetailEntity();">保存</a>
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
					<restrict:function funId="194">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" id="saveProductSn" plain="true" onclick="selectProductSn()">添加</a>
					</restrict:function>
					<restrict:function funId="195">
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
		var pull_storage_id;
		var pull_storage_code;
		var fk_pull_storage_detail_id;
		var batch_no;
		var fk_storage_id;
		var dealer_id=${user.fk_dealer_id};
		var models;
		var valid_date;
		$(function() {
			$('#dg').datagrid({
				  url : basePath +"api/salesstorage/paging" ,
					queryParams: {
						filter_ANDS_type : $('#ff input[name=type]').val()
					},
					 onLoadSuccess:function(data){
							$(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
							$(".checkBtn").linkbutton({ plain:true, iconCls:'icon-check' });
					}
			});
		})
		function formatterDetail(value, row, index){
			return '<a class="infoBtn" href="javascript:void(0)" onclick="onClickPullStorageDetail(\''+index+'\')"></span>'; 
		}
		function doSearch(){
			$('#dg').datagrid('load',{
				filter_ANDS_pull_storage_code:$('#ff input[name=pull_storage_code]').val(),
				filter_ANDS_fk_pull_storage_party_id: $('#ff input[name=fk_pull_storage_party_id]').val(),
				filter_ANDS_put_storage_party_name: $('#ff input[name=put_storage_party_name]').val(),
				filter_ANDS_status: $('#ff input[name=status]').val(),
				filter_ANDS_type: $('#ff input[name=type]').val(),
				filter_ANDS_pull_start_date: $('#ff input[name=pull_start_date]').val(),
				filter_ANDS_pull_end_date: $('#ff input[name=pull_end_date]').val(),
				filter_ANDS_sales_start_date: $('#ff input[name=sales_start_date]').val(),
				filter_ANDS_sales_end_date: $('#ff input[name=sales_end_date]').val()
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
				return '<span>成功</span>';
		}
		function newEntity()
		{
			clearForm();
			$('#ffadd input[name=type]').val(3);
			$('#w').dialog('open').dialog('setTitle','添加信息');
			url =basePath+'api/salesstorage/save';
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
								url :basePath+'api/salesstorage/remove',
								data:{pull_storage_code:row.pull_storage_code,filter_ANDS_pull_storage_code:row.pull_storage_code},
								error : function(request) {
									$.messager.alert('提示','抱歉,删除错误!','error');	
								},
								success:function(msg){
								    var jsonobj = $.parseJSON(msg);
		        					if (jsonobj.state == 1) {
		        						 pull_storage_code=undefined;
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
					$.messager.alert('提示','无法删除已提交的单据!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个单据!','warning');
			}
		}
		function clearForm(){
			$('#ffadd').form('clear');
		}
		function clearPullStorageDetailForm(){
			$('#fm3').form('clear');
		}
		function onClickPullStorageDetail(index){
			$('#dg').datagrid('selectRow',index);
			openPullStorageDetail($('#dg').datagrid('getSelected'));
		}
		//open订单项
		function openPullStorageDetail(row,type){
			$('#ffPullStorageDetail').form('load',row);
			$('#dlgPullStorageDetail').dialog('open');
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
            pull_storage_code = row.pull_storage_code;
            pull_storage_id = row.id; 
			status=row.status;
			$('#dgDetail').datagrid({
				url : basePath + "api/pullstoragedetail/detailpaging",
				queryParams: {
					filter_ANDS_pull_storage_code : pull_storage_code
				},
				onLoadSuccess:function(data){ 
					  $(".productSnBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				}
			});
			$('#dgUpdateLog').datagrid({
			    url:basePath+'api/flowlog/list?bussiness_id='+row.id+"&flow_id="+salesStorageflow_identifier_num
			}); 
			if(status=='0'|| status=='2'){
				$('#savePullStorageDetail').linkbutton('enable');
				$('#delPullStorageDetail').linkbutton('enable');
				$('#saveDraft').linkbutton('enable');
				$('#submitPullStorage').linkbutton('enable');
				$('#saveProductSn').linkbutton('enable');
				$('#deleteProductSn').linkbutton('enable');
			}else{
				$('#savePullStorageDetail').linkbutton('disable');
				$('#delPullStorageDetail').linkbutton('disable');
				$('#saveDraft').linkbutton('disable');
				$('#submitPullStorage').linkbutton('disable');
				$('#saveProductSn').linkbutton('disable');
				$('#deleteProductSn').linkbutton('disable');
			}
			if(typeof(type) != "undefined"){
				$('#dlgPullStorageDetailtabs').tabs('enableTab', '审核'); 
				$('#dlgPullStorageDetailtabs').tabs('select', '审核');
			}else{
				$('#dlgPullStorageDetailtabs').tabs('select', '明细行');
				$('#dlgPullStorageDetailtabs').tabs('disableTab', '审核');
			}
		}
		//明细
		function removePullStorageDetailEntity()
		{
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				if(status=='0'|| status=='2'){
					$.messager.confirm('Confirm','是否确定删除?',function(r){
						if (r){
						    $.ajax({
								type : "POST",
								url :basePath+'api/pullstoragedetail/remove',
								data:{id:row.id,pull_storage_code:pull_storage_code},
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
					$.messager.alert('提示','无法删除已提交的单据!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function newPullStorageDetailEntity()
		{
			if(typeof(pull_storage_code) != "undefined"){
				$('#dlgProduct').dialog('open');
				$('#dgProduct').datagrid({
					url:basePath+'api/storageDetail/api_paging',
					queryParams: {
						filter_ANDS_dealer_id : dealer_id
					}
				});
			}else
			{
				$.messager.alert('提示','请选中某个单据!','warning');
			}
		}
		function newProductAddEntity() {
			clearPullStorageDetailForm();
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#fm3').form('load',row);
				$("#fm3 input[name=pull_storage_code]").val(pull_storage_code);
				$('#dlgProductAdd').dialog('open').dialog('setTitle','添加产品');
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		function savePullStorageDetailEntity(){
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#fm3').form('submit', {
					url :basePath+'api/pullstoragedetail/savedetail',
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
				    		$.messager.alert('提示','不可重复添加一个批次!','error');	
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
		    	filter_ANDS_fk_storage_id: $("#ffdetail input[name=fk_storage_id]").val(),
				filter_ANDS_fk_dealer_id : $('#ffdetail input[name=fk_dealer_id]').val(),
		    	filter_ANDS_product_item_number:$("#ffdetail input[name=product_item_number]").val(),
		    	filter_ANDS_batch_no: $("#ffdetail input[name=batch_no]").val()
		    });
		}
		function formatterIs_pullstorage (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		}
		function formatterProductSn (value, row, index) { 
			return '<a class="productSnBtn" href="javascript:void(0)"  onclick="openProductSn('+index+')" ></a>';
		}
		function formatterCheck (value, row, index) {
			var d=(typeof(row.check_id) != "undefined" && row.record_status=='0') ?'':'disabled';
			return '<a class="checkBtn" '+d+' href="javascript:void(0)" onclick="CheckEntity('+index+')">审核</a>'; 
		}
		function doSearchProductSn(){
		    $('#dgStorageProductSn').datagrid('load',{
		    	filter_ANDS_fk_storage_id: $("#fffdetail input[name=fk_storage_id]").val(),
		    	filter_ANDS_batch_no: $("#fffdetail input[name=batch_no]").val(),
		    	filter_ANDS_product_sn: $("#fffdetail input[name=product_sn]").val(),
		    	filter_ANDS_pull_storage_code: $("#fffdetail input[name=pull_storage_code]").val(),
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
			fk_pull_storage_detail_id = row.id;
			batch_no = row.batch_no;
			fk_storage_id = row.fk_storage_id;
			models = row.models;
			valid_date = row.valid_date;
			$('#dgProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgProductSn').datagrid({
				url : basePath + "api/pullstorageprodetail/paging",
				queryParams: {
					filter_ANDS_pull_storage_code: pull_storage_code,
					filter_ANDS_fk_storage_id : fk_storage_id	,
					filter_ANDS_batch_no : batch_no,
					filter_ANDS_fk_pull_storage_detail_id : fk_pull_storage_detail_id
				}
			});
		}
		function selectProductSn(){
			$('#dlgStorageProductSn').dialog('open');
			$("#fffdetail input[name=batch_no]").val(batch_no);
			$("#fffdetail input[name=fk_storage_id]").val(fk_storage_id);
			$("#fffdetail input[name=models]").val(models);
			$("#fffdetail input[name=valid_date]").val(valid_date);
			$('#dgStorageProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgStorageProductSn').datagrid({
				url : basePath + "api/storageProDetail/api_paging",
				queryParams: {
					filter_ANDS_fk_storage_id: fk_storage_id,
					filter_ANDS_batch_no : batch_no,
					filter_ANDS_models : models,
					filter_ANDS_valid_date : valid_date,
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
		            	url : basePath + 'api/pullstorageprodetail/save',
		            		data : {
		            				fk_pull_storage_detail_id : fk_pull_storage_detail_id,
		            				fk_storage_id:fk_storage_id,
		            				batch_nos : batch_nos.join(','),
		            				product_sns : product_sns.join(','),
		            				pull_storage_code:pull_storage_code
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
				            url : basePath + 'api/pullstorageprodetail/remove',
				            data : {
				            	id:row.id, 
				            	pull_storage_code:pull_storage_code,
				            	fk_pull_storage_detail_id : row.fk_pull_storage_detail_id},
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
		/**
		提交订单
		*/
		function ToCheckEntity(){
			if(typeof(pull_storage_code) != "undefined")
			if(status=='0'|| status=='2'){
				///var item = $('#dgProduct').datagrid('getRows');
				//if(item.length>0){
					 $.messager.confirm('提示','提交后将不能修改 ,确定要提交审核吗  ?',function(r){
						 if (r){
							 $('#submitPullStorage').linkbutton('disable');
		                     $.post(basePath+'api/salesstorage/updatetocheck',{id:pull_storage_id,
			                    pull_storage_code:pull_storage_code},function(result){
			        			if(result.state==1){
			        			    $('#dg').datagrid('reload');
			     			 	    $('#dlgPullStorageDetail').dialog('close')
			        			}else if (result.state == 2) {
			        				$.messager.alert('提示','抱歉,请添加产品序列号!','error');
						 		}else if(result.state == 3) {
					 				$.messager.alert('提示','抱歉,请添加产品!','error');
					 			}else if(result.state == 4) {
					 				$.messager.alert('提示','抱歉,库存不足!','error');
					 			}else{
		                            $.messager.show({
		                                title: 'Error',
		                                msg: "提交失败!"
		                        	});
		                        }
			        			$('#submitPullStorage').linkbutton('enable');
		                     },'json');
		                 }
					 });
			    //}else
				//{
		    		//$.messager.alert('提示','请添加产品!','error');
				//}
			}else
			{
	    		$.messager.alert('提示','无法提交已处理订单!','error');
			}
		}
		/**
		审核
		*/
		function CheckEntity(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
			if (row && row.status==1){
				 $.messager.confirm('提示','确定要要审核吗  ?',function(r){
					 $('#bussiness_id').val(row.id);
					 $("#flow_id").val(salesStorageflow_identifier_num);
					 openPullStorageDetail(row,1);
				 });
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');
			}
		}
		/*保存审核*/
		function saveFlowCheck()
		{
			$('#saveCheckbtn').linkbutton('disable');
			$('#base_form_check').form('submit', {
				url:basePath+'/api/flowrecord/do_flow',
				method:"post",	
				onSubmit: function(){
				   return $(this).form('validate');
				},
				success:function(msg){
				   var jsonobj= eval('('+msg+')');  
				   if(jsonobj.state==1)
				   {
					    clearForm();
					    $('#dlgPullStorageDetail').dialog('close');
					    var pager = $('#dg').datagrid().datagrid('getPager');
					    pager.pagination('select');		
					    $('#saveCheckbtn').linkbutton('enable');
				   }else{
					   $.messager.show({
                           title: 'Error',
                           msg: jsonobj.error.msg
                       });
	    			   $('#saveCheckbtn').linkbutton('enable');
				   }
				}
			});
		}
		function FormatFlowlog (value, row, index) 
		{
			if(row.user_name  && row.action_name)
			{
				return row.user_name +" 进行"+row.action_name ;
			}else
			{
				return row.user_name ;
			}
		}
		function formattersign(value, row, index)
		 {
			 if(row.sign && row.sign!="")
			 	return '<span><img src="'+basePath+'resource/signimg/'+value+'" width="50" height="50"></span>'; 
		 }
	</script>
</body>
</html>