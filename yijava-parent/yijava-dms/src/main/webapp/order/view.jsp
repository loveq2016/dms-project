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
										<c:choose>
										       <c:when test="${user.fk_dealer_id!='0'}">
													<input class="easyui-validatebox" disabled="disabled" id="dealer_name" value="${user.dealer_name}" style="width:150px" maxLength="100">
													<input class="easyui-validatebox" type="hidden" name="dealer_id" id="dealer_id" value="${user.fk_dealer_id}" style="width:150px" maxLength="100">					       	
										       </c:when>
										       <c:otherwise>
										       		<input class="easyui-combobox" name="dealer_id" id="dealer_id" style="width:150px" maxLength="100" class="easyui-validatebox"
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
					 <restrict:function funId="20">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
					</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:370px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id"
					iconCls="icon-search" sortOrder="desc" toolbar="#tbOrder">
					<thead>
						<tr>
							<th data-options="field:'id',width:240,align:'left'" hidden="true">id</th>
							<th data-options="field:'order_code',width:200,align:'left'" sortable="true">订单号</th>
							<th data-options="field:'dealer_name',width:240,align:'left'" sortable="true">经销商</th>
							<th data-options="field:'order_number_sum',width:80,align:'left'" sortable="true">总数量</th>
							<th data-options="field:'order_money_sum',width:80,align:'left'" sortable="true">总金额</th>
							<th data-options="field:'order_status',width:80,align:'left'" formatter="formatterStatus" sortable="true">状态</th>
							<th data-options="field:'order_date',width:150,align:'left'" sortable="true">订单时间</th>
							<th data-options="field:'custom',width:100,align:'center'" sortable="false" formatter="formatterDetail">明细</th>
							<th data-options="field:'dealer_address_id',width:60" hidden="true"></th>
							<th data-options="field:'receive_linkman',width:60" hidden="true"></th>
							<th data-options="field:'receive_linkphone',width:60" hidden="true"></th>
							<th data-options="field:'business_contacts',width:60" hidden="true"></th>
							<th data-options="field:'addess',width:60" hidden="true"></th>
							<th data-options="field:'business_phone',width:60" hidden="true"></th>
							<th data-options="field:'receive_postcode',width:60" hidden="true"></th>
						</tr>
					</thead>
				</table>
			</div>
			<div id="tbOrder">
				<restrict:function funId="21">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				</restrict:function>
				<restrict:function funId="26">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editEntity()">编辑</a>
				</restrict:function>
				<restrict:function funId="27">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyEntity()">删除</a>
        		</restrict:function>
        		<restrict:function funId="157">
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="CheckEntity()">审核</a>
        		</restrict:function>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="w" class="easyui-window" data-options="minimizable:false,maximizable:false,modal:true,closed:true,iconCls:'icon-manage'" style="width:300px;height:200px;padding:10px;">
			<form id="ffadd" action="" method="post" enctype="multipart/form-data">
				<table>
					<tr>
						<td>收货地址:</td>
						<td>
							<input type="hidden" name="id"></input>
							<input type="hidden" name="order_code"></input>
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
			<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#w').window('close')">取消</a>					   
			</div>
		</div>
		</div>
		<div id="dlgOrderDetail" class="easyui-dialog" title="订单明细" style="width:950px;height:auto;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
            <div class="easyui-panel" style="width:925px;" style="margin: 10px 0;">
					<form id="ffOrderDetail" method="post">
							<table>
								<tr>
									<td>订单号:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="order_code"></input></td>
									<td width="100">经销商:</td>
									<td>
						            	<input class="easyui-validatebox" readonly="readonly" type="text" name="dealer_name"></input>
									</td>
									<td width="50">状态:</td>
									<td width="270">				
										<input name="order_status" readonly="readonly" class="easyui-combobox" data-options="
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
									<td>订单日期:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="order_date"></input></td>
								</tr>
							</table>
					</form>
			</div>
			<div style="margin: 10px 0;"></div>
			<div id="dlgOrderDetailtabs" class="easyui-tabs" style="width:925px;height:auto;">
         		<div title="表头信息" style="padding: 5px 5px 5px 5px;">
         			<div class="easyui-layout" style="height:370px;">  
	         			<form id="ffOrderInfo" method="post">
		         			<table style="border-collapse:collapse;border:none;">
		         				<tr style="border-bottom:3px double #D3D3D3;">
									<td width="80" height="30">订单信息</td>	
									<td width="200"></td>
									<td width="80" height="30">经销商信息</td>	
									<td width="200"></td>	
									<td width="100" height="30">经销商收货地址</td>	
									<td width="200"></td>
								</tr>
								<tr height="">
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
			         			<tr>
									<td>金额汇总:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="order_money_sum"></input></td>
									<td>联系人:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="business_contacts"></input></td>
									<td>收货地址:</td>	
									<td>
										<input class="easyui-combobox" readonly="readonly" name="dealer_address_id" style="width:150px" maxLength="100" class="easyui-validatebox"
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
									<td>数量汇总:</td>
									<td>
									    <input class="easyui-validatebox" readonly="readonly" type="text" name="order_number_sum"></input>
									</td>
									<td width="20">联系电话:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="business_phone"></input></td>
									<td width="20">邮编:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="receive_postcode"></input></td>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<td>联系地址:</td>	
									<td><input class="easyui-validatebox" readonly="readonly" type="text" name="addess"></input></td>
									<td width="20">收货人:</td>
									<td>
										<input class="easyui-validatebox" readonly="readonly" name="receive_linkman" id="receive_linkman" value="aa" style="width:150px" maxLength="100">
									</td>
								</tr>
								<tr>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td>收货电话:</td>
									<td>
										<input class="easyui-validatebox" readonly="readonly" name="receive_linkphone" id="receive_linkphone" style="width:150px" maxLength="100">
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>
				<div title="明细行" style="padding: 5px 5px 5px 5px;" >
					<table id="dgDetail" class="easyui-datagrid" title="订单明细信息" style="height:370px" method="get"
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
								<th data-options="field:'plan_send_date',width:100,align:'center'" sortable="true">预计发货日期</th>
							</tr>
						</thead>
					</table>
					<div id="tbOrderDetail">    
						<restrict:function funId="28">
					    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="saveOrderDetail" onclick="newOrderDetailEntity();">添加产品</a>
					    </restrict:function>    
					    <restrict:function funId="29">
					   		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delOrderDetail" onclick="removeOrderDetailEntity();">删除产品</a>
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
											<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveFlowCheck()">提交</a>
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
		</div>
		<div id="dlg-buttons">
		    <restrict:function funId="158">
	        	<a id="saveEntityBtn" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="ToCheckEntity()">提交订单</a>
	        </restrict:function>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgOrderDetail').dialog('close')">取消</a>
	    </div>
		<div id="dlgProduct" class="easyui-dialog" style="width:800px;height:495px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProduct-buttons">
				<div class="easyui-panel" title="查询条件" style="width:775px;">
						<div style="padding: 10px 0 0 30px">
							<form id="ffdetail" method="post">
								<table>
									<tr>
										<td>产品编号:</td>	
										<td width="100px"><input class="easyui-validatebox" type="text" name="item_number" id="item_number" ></input></td>
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
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchProduct()">查询</a>   
						</div>
					</div>
				<div style="margin: 10px 0;"></div>
					<table id="dgProduct" class="easyui-datagrid" title="查询结果" style="height:300px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="desc" toolbar="#tbProduct">
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
	    <div id="dlgProduct-buttons">
	    	<restrict:function funId="28">
	       		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="newProductNumEntity()">添加</a>
	        </restrict:function>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProduct').dialog('close')">取消</a>
	    </div>
		<div id="dlgProductSum" class="easyui-dialog" style="width:300px;height:300px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductSum-buttons">
		        <form id="fm3" action="" method="post" enctype="multipart/form-data">
					      <table> 
					    		<tr>
					             	<td>订单号:</td>
					             	<td><input name="order_code" readonly="true" class="easyui-validatebox" style="width:150px;"></td>
					            </tr>
					            <tr>
					             	<td>产品编码:</td>
					             	<td><input name="product_item_number" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>产品名称</td>
					             	<td><input name="product_name" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>订购价格</td>
					             	<td><input name="order_price" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>折扣</td>
					             	<td><input name="discount" readonly="true" class="easyui-validatebox" value="10" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>小计</td>
					             	<td><input name="order_money_sum" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
						        <tr>
					             	<td>数量:</td>
					             	<td><input name="order_number_sum" id="order_number_sum" class="easyui-numberbox" style="width:150px" 
									data-options="required:true"></td>
					             </tr>
					      </table>        	
		        </form>
	    </div>
	    <div id="dlgProductSum-buttons">
		    <restrict:function funId="28">
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveOrderDetailEntity();">保存</a>
		    </restrict:function>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductSum').dialog('close')">取消</a>
	    </div>
	<script type="text/javascript">
		var order_status;
		var order_code;
		var order_id;
		var dealer_id=${user.fk_dealer_id};
		$(function() {  
			$('#dg').datagrid({
				url : basePath +"api/order/paging",
				onLoadSuccess:function(data){ 
					$(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			    }
			});
			//计算订单项小计
			$("#order_number_sum").keyup(function(){
		    	var order_price= $('input[name=order_price]').val();
				var discount= $('input[name=discount]').val();
				if (typeof(discount) == "undefined"||discount=='')
					discount=10;
				var order_number_sum= $('#order_number_sum').val();
				var m=order_price*order_number_sum*(discount*0.1);
				$('input[name=order_money_sum]').val(m.toFixed(2));
		    });
		})
		function formatterDetail(value, row, index){
			return '<a class="infoBtn" href="javascript:void(0)" onclick="onClickOrderDetail('+index+')"></a>'; 
		}
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_order_code:$('#ff input[name=order_code]').val(),
		    	filter_ANDS_dealer_id: $('#ff input[name=dealer_id]').val(),
		    	filter_ANDS_order_status: $('#ff input[name=order_status]').val(),
		    	filter_ANDS_start_date: $('#ff input[name=start_date]').val(),
		    	filter_ANDS_end_date: $('#ff input[name=end_date]').val(),
		    });
		}
		function formatterStatus(value, row, index){
			if(value=='0')
				return '<span style="color:red">未提交</span>'; 
			else if(value=='1')
				return '<span style="color:red">已提交</span>'; 
			else if(value=='2')
				return '<span style="color:red">驳回</span>'; 
			else if(value=='3')
				return '<span style="color:red">已审核</span>'; 
			else if(value=='4')
				return '<span style="color:red">已发货</span>'; 
			else if(value=='5')
				return '<span style="color:red">部分发货</span>'; 
			else if(value=='6')
				return '<span style="color:red">已完成</span>'; 
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
				    	$('#dg').datagrid('reload');
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
				if(row.order_status=='0'||row.order_status=='2'){
					$('#w').dialog('open').dialog('setTitle','更新订单信息');
				    $('#ffadd').form('load', row);
					url = basePath+'api/order/updateAddress';
					$('#w').window('open');
				}else{
					$.messager.alert('提示','无法编辑已处理的订单!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个订单!','warning');
			}
		}
		function destroyEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
				if(row.order_status=='0'){
					$.messager.confirm('Confirm','是否确定删除?',function(r){
					    $.ajax({
							type : "POST",
							url :basePath+'api/order/remove?id='+row.order_code,
							error : function(request) {
								$.messager.alert('提示','抱歉,删除错误!','error');	
							},
							success:function(msg){
							    var jsonobj = $.parseJSON(msg);
	        					if (jsonobj.state == 1) {
	        						 order_code=undefined;
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
					});
				}else{
					$.messager.alert('提示','无法删除已处理的订单!','error');
				}
			}else
			{
				$.messager.alert('提示','请选中某个订单!','warning');
			}
		}
		function clearForm(){
			$('#ffadd').form('clear');
		}
		function clearOrderDetailForm(){
			$('#fm3').form('clear');
		}
		function onClickOrderDetail(index){
			$('#dg').datagrid('selectRow',index);
			openOrderDetail($('#dg').datagrid('getSelected'));
		}
		//open订单项
		function openOrderDetail(row,type){
			var row = $('#dg').datagrid('getSelected');
			$('#ffOrderDetail').form('load',row);
			$('#ffOrderInfo').form('load',row);
			$('#dlgOrderDetail').dialog('open');
            $('#dgDetail').datagrid('loadData', {total: 0, rows: []});
			order_code = row.order_code;
			order_status=row.order_status;
			order_id=row.id;
			$('#dgDetail').datagrid({
				url : basePath + "api/orderdetail/paging",
				queryParams: {
					filter_ANDS_order_code : order_code
				}
			});
			$('#dgUpdateLog').datagrid({
			    url:basePath+'api/flowlog/list?bussiness_id='+row.id+"&flow_id="+orderflow_identifier_num
			}); 
			if(order_status=='0'|| order_status=='2'){
				$('#saveOrderDetail').linkbutton('enable');
				$('#delOrderDetail').linkbutton('enable');
				$('#saveEntityBtn').linkbutton('enable');
			}else{
				$('#saveOrderDetail').linkbutton('disable');
				$('#delOrderDetail').linkbutton('disable');
				$('#saveEntityBtn').linkbutton('disable');
			}
			if(typeof(type) != "undefined"){
				$('#dlgOrderDetailtabs').tabs('enableTab', '审核'); 
				$('#dlgOrderDetailtabs').tabs('select', '审核');
			}else{
				$('#dlgOrderDetailtabs').tabs('select', '表头信息');
				$('#dlgOrderDetailtabs').tabs('disableTab', '审核');
			}
		}
		//订单项
		function removeOrderDetailEntity()
		{
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				if(order_status=='0'){
					$.messager.confirm('Confirm','是否确定删除?',function(r){
					    $.ajax({
							type : "POST",
							url :basePath+'api/orderdetail/remove?oc='+row.order_code+'&id='+row.id,
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
				$('#dlgProduct').dialog('open').dialog('setTitle','['+order_code+']产品列表');
				$('#dgProduct').datagrid({
					 url:basePath+'api/product/api_paging',
					 queryParams: {
							filter_ANDS_dealer_id : dealer_id
					 }
				});
			}else
			{
				$.messager.alert('提示','请选中某个订单!','warning');
			}
		}		
		function newProductNumEntity() {
			clearOrderDetailForm();
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$("#fm3 input[name=order_code]").val(order_code);
				$("#fm3 input[name=product_item_number]").val(row.item_number);
				$("#fm3 input[name=product_name]").val(row.cname);
				$("#fm3 input[name=order_price]").val(row.price);
				$("#fm3 input[name=discount]").val(row.discount);
				
				$('#dlgProductSum').dialog('open').dialog('setTitle','添加产品');
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
				        return $(this).form('validate');
				    },
				    success:function(msg){
				    	var jsonobj = $.parseJSON(msg);
				    	if(jsonobj.state==1){
							 $('#dlgProductSum').dialog('close');     
		                     $('#dgDetail').datagrid('reload');
		                     $('#dg').datagrid('reload');
		                     $.messager.show({
                                 title: '提示',
                                 msg: "添加成功!"
                             });
				    	}else if(jsonobj.state==2){
				    		$.messager.alert('提示','不可重复添加一个产品!','error');	
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
		    	filter_ANDS_item_number: $("#ffdetail input[name=item_number]").val(),
		    	filter_ANDS_dealer_id: dealer_id,
		    	filter_ANDS_category_id: $("#ffdetail input[name=category_id]").val()
		    });
		}
		function formatterIs_order (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		}
		
		/**
		提交订单
		*/
		function ToCheckEntity(){
			if (order_status ==0 || order_status ==2){			
				 $.messager.confirm('提示','提交后将不能修改 ,确定要要提交审核吗  ?',function(r){
					 if (r){
	                        $.post(basePath+'api/order/updatetocheck',{order_id:order_id},function(result){
	        			    	if(result.state==1){
	        			    		$('#dg').datagrid('reload');
	        			    		$('#dlgOrderDetail').dialog('close');
	                            } else {
	                                $.messager.show({
	                                    title: 'Error',
	                                    msg: "订单提交失败!"
	                                });
	                            }
	                        },'json');
	                    }
				 });
			}else
			{
	    		$.messager.alert('提示','无法提交已处理订单!','error');
			}
		}
		/**
		审核
		*/
		function CheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row && row.order_status==1){
				 $.messager.confirm('提示','确定要要审核吗  ?',function(r){
					 $('#bussiness_id').val(row.id);
					 $("#flow_id").val(orderflow_identifier_num);
					 openOrderDetail(row,1);
				 });
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');
			}
		}
		/*保存审核*/
		function saveFlowCheck()
		{
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
					    $('#dlgOrderDetail').dialog('close');
					    $('#dg').datagrid('reload');			
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