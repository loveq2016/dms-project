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
										<c:choose>
										       <c:when test="${user.fk_dealer_id!='0'}">
													<input class="easyui-validatebox" disabled="disabled" id="dealer_name" value="${user.dealer_name}" style="width:200px" maxLength="100">
													<input class="easyui-validatebox" type="hidden" name="dealer_id" id="dealer_id" value="${user.fk_dealer_id}" style="width:200px" maxLength="100">					       	
										       </c:when>
										       <c:otherwise>
										       		<input class="easyui-combobox" name="dealer_id" id="dealer_id" style="width:200px" maxLength="100" class="easyui-validatebox"
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
									<td>退换货单号:</td>
									<td><input class="easyui-validatebox" type="text" name="exchanged_code" data-options="required:false"></input></td>
								</tr>
								<tr>
									<td>类型:</td>
									<td><input name="type" class="easyui-combobox" 
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '1',value: '退货'},
														{id: '2',value: '换货'}
														]" />
									</td>
									<td>状态:</td>
									<td><input name="status" class="easyui-combobox" 
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '0',value: '未提交'},
														{id: '1',value: '提交'},
														{id: '2',value: '驳回'},
														{id: '3',value: '已经审核'},
														{id: '4',value: '完成'}
														]" />
									</td>
								</tr>
								<tr>
									<td width="100">调整开始时间:</td>
									<td width="270">
										<input name="start_date" id="start_date" class="easyui-datebox"></input>
									</td>
									<td width="100">调整结束时间:</td>
									<td width="270">
										 <input name="end_date" id="end_date" class="easyui-datebox"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="179">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>	
						</restrict:function>		   
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
							<th field="exchanged_code" width="120" align="center" sortable="true">退换单号</th>
							<th field="type" width="120" align="center" sortable="true" formatter="formatterType">类型</th>
							<th field="total_number" width="120" align="center" sortable="true">总数量</th>
							<th field="exchanged_date" width="100" align="center" sortable="true">调整日期</th>
<!-- 							<th field="dealer_name" width="100" align="center" sortable="true">退换人</th> -->
							<th field="status" width="100" align="center" sortable="true" formatter="formatterStatus">单据状态</th>
							<th field="info" width="100" align="center" sortable="false" formatter="formatterInfo">明细</th>
							<restrict:function funId="183">
								<th data-options="field:'custom2',width:80,align:'center'" formatter="formatterCheck">审核</th>
							</restrict:function>
						</tr>
					</thead>
				</table>
				<div id="tb">     
					<restrict:function funId="180">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
					</restrict:function>
					<restrict:function funId="181">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
					</restrict:function>
					<restrict:function funId="182">
	        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity()">删除</a>
	        		</restrict:function>
<%-- 	        		<restrict:function funId="183"> --%>
<!-- 	        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="CheckEntity()">审核</a> -->
<%-- 	        		</restrict:function> --%>
	        		<restrict:function funId="184">
        				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" onclick="ToCheckEntity()">提交审核</a>
        			</restrict:function>
        			<restrict:function funId="210">
        				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="VidwDocument()">查看单据</a>
        			</restrict:function>
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="dlgW" class="easyui-dialog" style="width:400px;height:160px;padding:5px 5px 5px 5px;"
		            modal="true" closed="true" buttons="#dlgW-buttons">
			        <form id="fm2" action="" method="post" enctype="multipart/form-data">
						      <table>
							        <tr>
						             	<td>操作类型:</td>
						             	<td><input class="easyui-combobox" name="type" id="type" style="width:150px"
												data-options="
													required:true,
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '1',value: '退货'},
														{id: '2',value: '换货'}
														]" />
										</td>
						             </tr>
						      </table>    	
			        </form>
		    </div>
		    <div id="dlgW-buttons">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="createExchangedEntity();">保存</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgW').dialog('close')">取消</a>
		    </div>	
		</div>
		
		<div id="dlgExchangedDetail" class="easyui-dialog" title="退换明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
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
									<td>退换单号:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:200px;" name="exchanged_code" id="exchanged_code"/></td>
									<td></td>
									<td>退换日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" style="width:100px;" name="exchanged_date" id="exchanged_date"/></td>
									<td></td>
									<td>退换类型:</td>	
									<td><input class="easyui-combobox" name="type" id="type"  readonly="readonly"
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '1',value: '退货'},
														{id: '2',value: '换货'}
														]" />
									  </td>
									 <td></td> 
									<td>退换状态:</td>
									<td><input name="status" class="easyui-combobox" readonly="readonly" id="status"
												data-options="
													valueField: 'id',
													textField: 'value',
													panelHeight:'auto',
													data: [
														{id: '0',value: '未提交'},
														{id: '1',value: '提交'},
														{id: '2',value: '驳回'},
														{id: '3',value: '已经审核'},
														{id: '4',value: '完成'}
														]" />
									</td>
								</tr>
								<tr>
									<td>退换原因:</td>	
									<td colspan="4"><textarea name="remark" cols="65" style="height:30px;"></textarea></td>
								</tr>
								
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="tabs" class="easyui-tabs" style="width:925px;height:auto;">
				<div title="明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgDetail" class="easyui-datagrid" title="订单明细信息" style="height:300px" method="get"
						 rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb1">
						<thead>
							<tr>
							<th data-options="field:'storage_name',width:100,align:'center'" sortable="true">仓库</th>
							<th data-options="field:'product_item_number',width:65,align:'center'" sortable="true">产品编码</th>
							<th data-options="field:'models',width:65,align:'center'" sortable="true">规格</th>
							<th data-options="field:'batch_no',width:80,align:'center'" sortable="true">批次</th>
							<th data-options="field:'valid_date',width:80,align:'center',editor:'numberbox'">有效期</th>
							<th data-options="field:'inventory_number',width:100,align:'center',editor:'datebox'">库存量</th>
							<th data-options="field:'exchanged_number',width:100,align:'center',editor:'datebox'">退换量</th>
							<th data-options="field:'product_sn',width:100,align:'center',editor:'datebox'" formatter="formatterProductSn">序列号</th>
							</tr>
						</thead>
					</table>
					<div id="tb1">     
						<restrict:function funId="186">
							<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true"  id="newExchangedBtn" onclick="newDetailEntity()">添加产品</a>
	        			</restrict:function>
	        			<restrict:function funId="187">	
	        				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true"  id="deleteExchangedBtn" onclick="deleteDetailEntity()">删除产品</a>
						</restrict:function>
					</div> 
				</div>
				<div title="流程记录" style="padding: 5px 5px 5px 5px;" >
					<table id="dgflow_record" class="easyui-datagrid" title="查询结果" style="height: 330px">
						<thead>
							<tr>
								<th data-options="field:'user_id',width:80"  sortable="true" hidden="true">修改人id</th>	
								<th data-options="field:'user_name',width:80"  sortable="true">修改人</th>							
								<th data-options="field:'create_date',width:120" sortable="true">日期</th>
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
										<option value="3">结束</option>
									</select>
									</td>								
								</tr>
								<tr height="60">
									<td height="50">请选择用户:</td>
												<td>
												<input class="easyui-combobox" name="base_check_id" id="base_check_id" 
												style="width:250px" maxLength="100" class="easyui-validatebox"
								             			/>
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
								<input type="hidden" name="check_name" id="check_name">
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
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" id="submitExchangedBtn" onclick="submitExchanged();">提交</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgExchangedDetail').dialog('close')">取消</a>
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
								<th field="product_item_number" width="80" align="center" sortable="true">产品编号</th>
								<th field="models" width="120" align="center" sortable="true">规格</th>
								<th field="product_cname" width="120" align="center" sortable="true">产品中文名称</th>
								<th field="batch_no" width="100" align="center" sortable="true">产品批次</th>
								<th field="valid_date" width="100" align="center" sortable="true">有效期</th>
								<th field="inventory_number" width="100" align="center" sortable="true">产品数量（EA）</th>
							</tr>
						</thead>
					</table>
		</div>
		<div style="margin: 10px 0;"></div>
	    <div id="dlgProduct-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="newProductEntity()">添加</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProduct').dialog('close')">取消</a>
	    </div>
	    
		<div id="dlgProductAdd" class="easyui-dialog" style="width:400px;height:460px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductAdd-buttons">
		        <form id="fm3" action="" method="post" enctype="multipart/form-data">
		        
		       			 <input name="exchanged_code" hidden="true" class="easyui-validatebox" style="width:150px;">
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
					             	<td>规格</td>
					             	<td><input name="models" readonly="true" class="easyui-validatebox" style="width:150px"></td>
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
<!-- 						             
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
-->
					      </table>    	
		        </form>
	    </div>
	    <div id="dlgProductAdd-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveExchangedDetailEntity();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductAdd').dialog('close')">取消</a>
	    </div>	    
	    
	    
	    <div id="dlgExchangedProductSn" class="easyui-dialog" style="width:653px;height:413px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true">
				<table id="dgExchangedProductSn"  class="easyui-datagrid" title="查询结果" style="height:365px;width:630px;" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id"  toolbar="#tb3"
						pagination="true" iconCls="icon-search" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'order_code',width:240,align:'center'" sortable="true">订单号</th>
							<th data-options="field:'product_sn',width:180,align:'center'" sortable="true">序列号</th>
							<th data-options="field:'newModels',width:100,align:'center'" sortable="true">换货规格</th>
						</tr>
					</thead>
				</table>
				<div id="tb3">
					<restrict:function funId="201">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="selectProductSn" onclick="selectProductSn()">添加</a>
					</restrict:function>
					<restrict:function funId="202">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="deleteExchangedSn" onclick="deleteExchangedSn()">删除</a>
					</restrict:function>
					<restrict:function funId="209">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="selectProduct" onclick="newOrderDetailEntity()">选择换货产品</a>
					</restrict:function>
				</div>
    	</div>
	    
		<div id="dlgProductSn" class="easyui-dialog" title="序列号列表" style="width:800px;height:495px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProductSn-buttons">
				<div class="easyui-panel" title="查询条件" style="width:775px;">
						<div style="padding: 10px 0 0 30px">
							<form id="fffdetail" method="post">
								<input type="hidden" name="batch_no" id="batch_no" value=""></input>
								<input type="hidden" name="fk_storage_id" id="fk_storage_id" value=""></input>
								<input type="hidden" name="models" id="models" value=""></input>
								<table>
									<tr>
<%-- 										<input type="hidden" name="fk_dealer_id" id="fk_dealer_id" value="${user.fk_dealer_id}"></input>
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
--%>
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
					<table id="dgProductSn" class="easyui-datagrid" title="查询结果" style="height:300px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbProduct">
						<thead>
							<tr>
<!-- 								<th field="dealer_name" width="100" align="center" hidden="true">经销商</th> -->
								<th field="fk_order_code" width="120" align="center" sortable="true">订单号</th>
								<th field="storage_name" width="120" align="center" sortable="true">仓库</th>
<!-- 								<th field="product_item_number" width="120" align="center" sortable="true">产品编号</th> -->
<!-- 								<th field="product_cname" width="120" align="center" sortable="true">产品中文名称</th> -->
								<th field="batch_no" width="100" align="center" sortable="true">产品批次</th>
								<th field="product_sn" width="100" align="center" sortable="true">序列号</th>
<!-- 								<th field="inventory_number" width="100" align="center" sortable="true">产品数量（EA）</th> -->
							</tr>
						</thead>
					</table>
		</div>
		<div style="margin: 10px 0;"></div>
	    <div id="dlgProductSn-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="addProductSn()">添加</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductSn').dialog('close')">取消</a>
	    </div>
	    
	    <div id="dlgOrderProduct" class="easyui-dialog" style="width:850px;height:495px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgOrderProduct-buttons">
				<div class="easyui-panel" title="查询条件" style="width:825px;">
						<div style="padding: 10px 0 0 30px">
							<form id="fffdetail" method="post">
								<table>
									<tr>
										<td>产品编号:</td>	
										<td width="150px"><input class="easyui-validatebox" type="text" name="item_number" id="item_number" ></input></td>
										<td>选择分类:</td>
										<td>
							            	<input class="easyui-combobox" name="category_id" id="category_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url: '${basePath}api/dealerAuthProduct/list?dealer_id=${user.fk_dealer_id}',
								                    method:'get',
								                    valueField:'product_category_id',
													textField:'category_name',
								                    panelHeight:'auto'
						            			"/>
					                	</td>
									</tr>
								</table>
							</form>
						</div>
						<div style="text-align: right; padding:5px">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchOrderProduct()">查询</a>   
						</div>
					</div>
				<div style="margin: 10px 0;"></div>
					<table id="dgOrderProduct" class="easyui-datagrid" title="查询结果" style="height:300px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="desc" toolbar="#tbProduct">
						<thead>
							<tr>
								<th data-options="field:'item_number',width:80,align:'center'" sortable="true">产品编号</th>
								<th data-options="field:'cname',width:150,align:'center'" sortable="true">中文名称</th>
								<th data-options="field:'ename',width:120,align:'center'" sortable="true">英文名称</th>
								<th data-options="field:'models',width:100,align:'center'" sortable="true">规格型号</th>
								<th data-options="field:'price',width:80,align:'center'" sortable="true">价格</th>
								<th data-options="field:'discount',width:80,align:'center'" sortable="true">成交价格</th>
								<th data-options="field:'order_company',width:80,align:'center'">订购单位</th>
								<th data-options="field:'is_order',width:80" formatter="formatterIs_order">是否可订货</th>
								<th data-options="field:'remark',width:80" hidden="true">备注</th>
							</tr>
						</thead>
					</table>
		</div>
		<div style="margin: 10px 0;"></div>
	    <div id="dlgOrderProduct-buttons">
	       	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="updateExchangedModels()">选择</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgOrderProduct').dialog('close')">取消</a>
	    </div>

	<script type="text/javascript">
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/exchanged/paging",
			onLoadSuccess:function(data){ 
				 $(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				 $(".checkBtn").linkbutton({ plain:true, iconCls:'icon-check' });
			}
		});

		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_exchanged_code:$('#ffquery input[name=exchanged_code]').val(),
		    	filter_ANDS_dealer_id: $('#ffquery input[name=dealer_id]').val(),
		    	filter_ANDS_type: $('#ffquery input[name=type]').val(),
		    	filter_ANDS_status: $('#ffquery input[name=status]').val(),
		    	filter_ANDS_start_date: $('#ffquery input[name=start_date]').val(),
		    	filter_ANDS_end_date: $('#ffquery input[name=end_date]').val(),
		    });
		}
		
		function formatterCheck (value, row, index) {
			var d=(typeof(row.check_id) != "undefined" && row.record_status=='0') ?'':'disabled';
			return '<a class="checkBtn" '+d+' href="javascript:void(0)" onclick="CheckEntity('+index+')">审核</a>'; 
		}
		
		function formatterType(value, row, index){
			 if(value=='1')
				return '<span>退货</span>'; 
			else if(value=='2')
				return '<span>换货</span>'; 
		}
		
		function formatterStatus(value, row, index){
			if(value=='0')
				return '<span>未提交</span>'; 
			else if(value=='1')
				return '<span>提交</span>'; 
			else if(value=='2')
				return '<span>驳回</span>'; 
			else if(value=='3')
				return '<span>已经审核</span>'; 
			else if(value=='4')
				return '<span>已完成</span>'; 
		}

		function formatterInfo(value, row, index){
			return '<a class="infoBtn" href="javascript:void(0)"  onclick="openExchangedDetail(' + index + ');" ></a>';
		}
		
		 function formatterProductSn (value, row, index) { 
			 	return '<a class="productSnBtn" href="javascript:void(0)"  onclick="openProductSn('+index+')" ></a>';
		} 
		
		function newEntity(){
			$('#fm2').form('clear');
			$('#dlgW').dialog('open').dialog('setTitle','添加退换货信息');
		}		
		
		function createExchangedEntity(){
			$('#fm2').form('submit', {
				url :basePath+'api/exchanged/save',
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
						 $('#dlgW').dialog('close');     
	                     $('#dg').datagrid('reload');
			    	}else if(jsonobj.state==2){
			    		$.messager.alert('提示','不是经销商用户不能添加!','error');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }
			});
		}
		
		function editEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	            	if(row.status=='0' || row.status=='2'){
	            		 idx = $('#dg').datagrid('getRowIndex',row);
	            		 openExchangedDetail(idx);
						 //url =basePath+'api/exchanged/update';
	            	}else{
	            		$.messager.alert('提示','无法编辑已提交的!','error');
	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }		
		}
		
		
		function deleteEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	            	if(row.status=='0' || row.status=='2'){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/exchanged/delete',
		            				data : {id:row.id,exchanged_code:row.exchanged_code},
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
	            		$.messager.alert('提示','无法删除已提交的!','error');
	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }				
		}
		
		
		var dealer_id ; 
		var exchanged_code ;
		var type;
		function openExchangedDetail(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
			$('#fm').form('load',row);
			exchanged_code = row.exchanged_code;
			dealer_id = row.dealer_id;
			type = row.type;
			if(row.status==0 || row.status==2){
				$("#newExchangedBtn").linkbutton('enable');
				$("#deleteExchangedBtn").linkbutton('enable');
				$("#submitExchangedBtn").linkbutton('enable');
			}else{
				$("#newExchangedBtn").linkbutton('disable');
				$("#deleteExchangedBtn").linkbutton('disable');
				$("#submitExchangedBtn").linkbutton('disable');
			}
			$('#dlgExchangedDetail').dialog('open');
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
			$('#dgDetail').datagrid({
				url : basePath + "api/exchangeddetail/paging",
				queryParams: {
					filter_ANDS_exchanged_code : exchanged_code
				},
				onLoadSuccess:function(data){ 
					  $(".productSnBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				 }
			});
			
			 LoadCheckFlowRecord(row.id);
			 $('#tabs').tabs('disableTab', '审核'); 
		}
		
		
		
		
		function newDetailEntity(){	
			if($('#status').combobox('getValue')==0 || $('#status').combobox('getValue')==2){
				$('#dlgProduct').dialog('open');
				$('#dgProduct').datagrid({
					 url:basePath+'api/storageDetail/api_paging',
					queryParams: {
						filter_ANDS_dealer_id : dealer_id
					}
				});
			}else{
				$.messager.alert('提示','无法编辑已提交的!','error');
			}

		}
		
		function deleteDetailEntity(){
	           var row = $('#dgDetail').datagrid('getSelected');
	            if (row){
	            	if($('#status').combobox('getValue')==0 || $('#status').combobox('getValue')==2){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/exchangeddetail/delete',
		            				data : {id:row.id,exchanged_code:row.exchanged_code},
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
		
		
		function newProductEntity() {
			$('#fm3').form('clear');
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#dlgProductAdd').dialog('open').dialog('setTitle','添加产品');
				$('#fm3').form('load',row);
				$("#fm3 input[name=exchanged_code]").val(exchanged_code);
			}else{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		
		
		function saveExchangedDetailEntity(){
		//	if($('#status').combobox('getValue')==0){
				$('#fm3').form('submit', {
					url :basePath+'api/exchangeddetail/save',
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
		                     $.messager.alert('提示','产品添加成功!','info');		
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
		


		function doSearchProduct(){
		    $('#dgProduct').datagrid('load',{
		    	filter_ANDS_fk_storage_id: $("#ffdetail input[name=fk_storage_id]").val(),
				filter_ANDS_fk_dealer_id : $('#ffdetail input[name=fk_dealer_id]').val(),
		    	filter_ANDS_product_item_number:$("#ffdetail input[name=product_item_number]").val(),
		    	filter_ANDS_batch_no: $("#ffdetail input[name=batch_no]").val()
		    });
		}
		
		function doSearchProductSn(){
		    $('#dgProductSn').datagrid('load',{
		    	filter_ANDS_fk_storage_id: $("#fffdetail input[name=fk_storage_id]").val(),
		    	filter_ANDS_batch_no: $("#fffdetail input[name=batch_no]").val(),
		    	filter_ANDS_product_sn: $("#fffdetail input[name=product_sn]").val(),
		    	filter_ANDS_models: $("#fffdetail input[name=models]").val(),
		    	filter_ANDS_dealer_id : dealer_id,
				filter_ANDS_status : 1
		    });
		}
		

		var exchanged_detail_id;
		var sn_num;
		var batch_no;
		var fk_storage_id;
		var models;
		function openProductSn(index){
			$('#dgDetail').datagrid('selectRow',index);
			var row = $('#dgDetail').datagrid('getSelected');
			$('#dlgExchangedProductSn').dialog('open').dialog('setTitle','产品下序列号');
			exchanged_code = row.exchanged_code;
			exchanged_detail_id = row.id;
			sn_num = Math.abs(row.exchanged_number);
			batch_no = row.batch_no;
			fk_storage_id = row.fk_storage_id;
			models = row.models;
			if($('#status').combobox('getValue')==0 || $('#status').combobox('getValue')==2){
				$("#selectProductSn").linkbutton('enable');
				$("#deleteExchangedSn").linkbutton('enable');
				if(type==2 ){
					$("#selectProduct").linkbutton('enable');
				}else{
					$("#selectProduct").linkbutton('disable');
				}
			}else{
				$("#selectProductSn").linkbutton('disable');
				$("#deleteExchangedSn").linkbutton('disable');
				$("#selectProduct").linkbutton('disable');
			}

			$('#dgExchangedProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgExchangedProductSn').datagrid({
				url : basePath + "api/exchangeddetailpro/paging",
				queryParams: {
					filter_ANDS_exchanged_code: exchanged_code,
					filter_ANDS_fk_storage_id : fk_storage_id	,
					filter_ANDS_batch_no : batch_no,
					filter_ANDS_exchanged_detail_id : exchanged_detail_id
				},
				onLoadSuccess:function(data){ 
					if(type==2){
						$('#dgExchangedProductSn').datagrid('showColumn',"newModels");  
					}else{
						$('#dgExchangedProductSn').datagrid('hideColumn',"newModels");  
					}
					 
				}
				
			});
		}
		
		function selectProductSn(){
			$('#dlgProductSn').dialog('open');
			$("#fffdetail input[name=batch_no]").val(batch_no);
			$("#fffdetail input[name=fk_storage_id]").val(fk_storage_id);
			$("#fffdetail input[name=models]").val(models);
			$('#dgProductSn').datagrid('loadData', {total: 0, rows: []});
			$('#dgProductSn').datagrid({
				url : basePath + "api/storageProDetail/api_paging",
				queryParams: {
					filter_ANDS_fk_storage_id : fk_storage_id	,
					filter_ANDS_batch_no : batch_no,
					filter_ANDS_models : models,
					filter_ANDS_dealer_id : dealer_id,
					filter_ANDS_status : 1
				}
			});
		}
		
		function addProductSn(){
	           var row = $('#dgProductSn').datagrid('getSelected');
	            if (row){
// 	            	if(row.status=='0'){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/exchangeddetailpro/save',
		            				data : {
		            						exchanged_detail_id : exchanged_detail_id,
		            						fk_storage_id:row.fk_storage_id,
		            						batch_no : row.batch_no,
		            						product_sn : row.product_sn,
		            						exchanged_code:exchanged_code,
		            						order_code:row.fk_order_code
		            				},
		            				error : function(request) {
		            					$.messager.alert('提示','Error!','error');	
		            				},
		            				success : function(data) {
		            					var jsonobj = $.parseJSON(data);
		            					if (jsonobj.state == 1) {  
		            	                     $('#dgExchangedProductSn').datagrid('reload');
		            	                     $('#dgDetail').datagrid('reload');
		            	                     $('#dg').datagrid('reload');
		            	                     
		            	                     $.messager.alert('提示','序列号添加成功!','info');			
		            					}else if(jsonobj.state == 2){
		            						$.messager.alert('提示','序列号已经存在!','warning');			
		            					}else{
		            						$.messager.alert('提示','Error!','error');	
		            					}
		            				}
		            			});                    	            		
// 	            	}else{
// 	            		$.messager.alert('提示','无法删除已提交的调整单!','error');
// 	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
			
		}
		
		function deleteExchangedSn(){
	           var row = $('#dgExchangedProductSn').datagrid('getSelected');
	            if (row){
// 	            	if($('#status').combobox('getValue')==0){
		                $.messager.confirm('Confirm','是否确定删除?',function(r){
		                    if (r){
		            			$.ajax({
		            				type : "POST",
		            				url : basePath + 'api/exchangeddetailpro/delete',
		            				data : {
		            					id:row.id , 
		            					exchanged_code:exchanged_code,
		            					exchanged_detail_id : exchanged_detail_id},
		            				error : function(request) {
		            					$.messager.alert('提示','Error!','error');	
		            				},
		            				success : function(data) {
		            					var jsonobj = $.parseJSON(data);
		            					if (jsonobj.state == 1) {  
		            	                     $('#dgExchangedProductSn').datagrid('reload');
		            	                     $('#dgDetail').datagrid('reload');
		            	                     $('#dg').datagrid('reload');
		            					}else{
		            						$.messager.alert('提示','Error!','error');	
		            					}
		            				}
		            			});                    	
		                    }
		                });	            		
// 	            	}else{
// 	            		$.messager.alert('提示','无法编辑已提交的调整单!','error');
// 	            	}
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
		}
		
		
		
		
		function submitExchanged(){
            //$.messager.confirm('Confirm','提交后不能修改,是否确定提交?',function(r){
            //    if (r){
        			$('#fm').form('submit', {
        				url :basePath+'api/exchanged/submit',
        			    method:"post",
        			    onSubmit: function(){
        			        return $(this).form('validate');
        			    },
        			    success:function(msg){
        			    	var jsonobj = $.parseJSON(msg);
        			    	if(jsonobj.state==1){
        						 $('#dlgExchangedDetail').dialog('close');     
        	                     $('#dg').datagrid('reload');
        			    	}else{
        			    		$.messager.alert('提示','Error!','error');	
        			    	}
        			    }
        			});
               // }
            //});
		}
		
		/**
		审核
		*/
		function CheckEntity(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
 			$('#base_check_id').combobox({
				 
				 url:'${basePath}api/sysuser/companylist',
                 method:'get',
                 valueField:'id',
                 textField:'realname',
                 panelHeight:'auto',
                 onSelect: function (rec) {
                	 $("#base_form_check input[name=check_name]").val(rec.realname);
                 }
			 });
			if (row && row.status ==1){				
				 $.messager.confirm('提示','确定要要审核吗  ?',function(r){
					 $('#bussiness_id').val(row.id);
					 $("#flow_id").val(exchangedflow_identifier_num);
					 //填充基本信息
					  $('#base_form_flowcheck').form('load', row);
					 //var dgflow = $('#dgflow').datagrid().datagrid('getPager'); 
					 //dgflow.pagination(); 
					 //加载流程记录
					 //LoadCheckFlowRecord(row.deliver_id);
					 openExchangedDetail(index);
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
			if (row && (row.status ==0 || row.status ==2) ){			
				 $.messager.confirm('提示','提交后将不能修改 ,确定要要提交审核吗  ?',function(r){
					 if (r){
	                        $.post(basePath+'api/exchanged/updatetocheck',{exchanged_id:row.id},function(result){
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
			    url:basePath+'api/flowlog/list?bussiness_id='+bussinessId+"&flow_id="+exchangedflow_identifier_num
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
					 url:basePath+'api/flowrecord/do_allocate_flow',
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
				    		$('#dlgExchangedDetail').dialog('close');
				    		//var pager = $('#dg').datagrid().datagrid('getPager');
				    		//pager.pagination('select');	
				    		$('#dg').datagrid('reload');
				    	}
				    }		
				});		
			}
		
		function formatterIs_order (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		}
		var exchanged_pro_detail_id;
		function newOrderDetailEntity(){
			var row = $('#dgExchangedProductSn').datagrid('getSelected');
			if (row){	
				exchanged_pro_detail_id = row.id;
				$('#dlgOrderProduct').dialog('open').dialog('setTitle','['+row.batch_no+']换货产品列表');
				$('#dgOrderProduct').datagrid({
					 url:basePath+'api/product/api_paging',
					 queryParams: {
							filter_ANDS_dealer_id : dealer_id
					 }
				});
			}else{
				$.messager.alert('提示','请选中数据!','warning');
			}
		}	
		
		function doSearchOrderProduct(){
		    $('#dgOrderProduct').datagrid('load',{
		    	filter_ANDS_item_number: $("#fffdetail input[name=item_number]").val(),
		    	filter_ANDS_dealer_id: dealer_id,
		    	filter_ANDS_category_id: $("#fffdetail input[name=category_id]").val()
		    });
		}
		
		function updateExchangedModels(){
			
			if(typeof(exchanged_pro_detail_id) != "undefined"){
				var row = $('#dgOrderProduct').datagrid('getSelected');
				if (row){	
        			$.ajax({
        				type : "POST",
        				url : basePath + 'api/exchangeddetailpro/setModelsBySn',
        				data : {
        					id:exchanged_pro_detail_id , 
        					models:row.models},
        				error : function(request) {
        					$.messager.alert('提示','Error!','error');	
        				},
        				success : function(data) {
        					var jsonobj = $.parseJSON(data);
        					if (jsonobj.state == 1) {  
        						$('#dgExchangedProductSn').datagrid('reload');
        						$.messager.alert('提示','规格设置成功!','info');	
        						$('#dlgOrderProduct').dialog('close');
        	                     
        					}else{
        						$.messager.alert('提示','Error!','error');	
        					}
        				}
        			});  
				}else{
					$.messager.alert('提示','请选中数据!','warning');
				}
			}else{
				$.messager.alert('提示','请选中换货产品序列号!','warning');
			}
		}
		
		/**
		查看单据
		*/
		function VidwDocument () 
		{
			var row = $('#dg').datagrid('getSelected');
			if (row && row.status ==3){				
				$.post(basePath+'api/exchanged/viewdocument',{exchanged_id:row.id},function(result){
                	
			    	if(result.state==1){
			    		var tabTitle = "退换货管理单据"+result.data;
						var url = "generate/"+result.data;			
						addTabByChild(tabTitle,url);
			    		//var pager = $('#dg').datagrid().datagrid('getPager');
		    			//pager.pagination('select');	
                    } else {
                        $.messager.show({    // show error message
                            title: 'Error',
                            msg: result.error.msg
                        });
                    } 
                },'json');
			}else
			{
				$.messager.alert('提示-审核结束才能查看单据 ','请选中数据!','warning');
			}
			
		}
		
		
		
		
	</script>


</body>
</html>