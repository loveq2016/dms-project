<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/common/head.jsp"%>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
		<div id="p" class="easyui-panel" title="" width="1598">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">

				<div class="easyui-panel" title="查询条件">
					<div style="padding: 10px 0 10px 60px">
						<form id="ffquery" method="post">
							<table>
								<tr>
									<td>试用时间  从:</td>
									<td>
									<input name="q_start_time" id="q_start_time" class="easyui-datebox"></input>									
									</td>
									
									<td>  至:</td>
									<td>
									<input name="q_end_time" id="q_end_time" class="easyui-datebox"></input>									
									</td>	
									
									<td width="100">试用医院:</td>
									<td>
									<input class="easyui-combobox" name="queryhospital_id" id="queryhospital_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}api/dealerAuthHospital/api_list',
								                    method:'get',
								                    valueField:'hospital_id',
								                    textField:'hospital_name',
								                    panelHeight:'auto'
						            			"/>								
									</td>
									
									<td width="100">经销商:</td>
									<td>
										<input class="easyui-combobox" name="querydealer_id" id="querydealer_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}api/userDealerFun/list?t_id=${user.teams}&u_id=${user.id}',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto'
						            			"/>
									</td>						
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="123">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>
						</restrict:function>			   
					</div>
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">

				<table id="dg" title="查询结果" style="height: 440px" url="${basePath}api/protrial/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc" toolbar="#tbOrder">
					<thead>
						<tr>
							<th data-options="field:'trial_id',width:100"  sortable="true" hidden="true">trial_id</th>
							<th data-options="field:'dealer_user_id',width:100"  sortable="true" hidden="true">dealer_user_id</th>
							<th data-options="field:'trial_code',width:200"  sortable="true">试用申请单号</th>
							<th data-options="field:'dealer_name',width:200"  sortable="true">经销商名称</th>
							<th data-options="field:'hospital_name',width:200"  sortable="true">医院名称</th>									
							<th data-options="field:'reason',width:300" sortable="true">试用理由</th>							
							<th data-options="field:'create_time',width:200">申请日期</th>	
							<th data-options="field:'status',width:90" sortable="true" formatter="formatterstatus">单据状态</th>
							<th data-options="field:'id',width:90" sortable="true" formatter="formatterdesc">明细</th>							
						</tr>
					</thead>
				</table>

			</div>
			<div id="tbOrder">
				<restrict:function funId="124">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity()">添加</a>
				</restrict:function>
				<restrict:function funId="125">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="viewEntity()">编辑</a>
				</restrict:function>
				<restrict:function funId="126">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity()">删除</a>
        		</restrict:function>
        		<restrict:function funId="127">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" plain="true" onclick="ToCheckEntity()">提交审核</a>
        		</restrict:function>
        		<restrict:function funId="128">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="CheckEntity()">审核</a>
        		</restrict:function>
        		<restrict:function funId="156">
        			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="VidwDocument()">查看单据</a>
        		</restrict:function>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


	<!--add start -->	
	<div id="dlgadd" class="easyui-dialog" title="申请试用" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:720px;height:500px;padding:10px;">
	
	
	<div class="easyui-tabs" style="width:680px;height:380px">	
		<div title="基本信息" >
				<form id="ffadd" action="" method="post" enctype="multipart/form-data">
								<table>
									<tr>
										<td>经销商:</td>
										<td>
										
										 <input class="easyui-combobox" name="dealer_user_id" id="dealer_user_id" style="width:260px" 
										 maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}api/userDealerFun/list?t_id=${user.teams}&u_id=${user.id}',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto',
								                    onSelect: function(rec){
								                    	$('#dealer_name').val(rec.dealer_name);								                    	
											            var url = '${basePath}api/dealerAuthHospital/api_list?filter_ANDS_dealer_id='+rec.dealer_id;
											            $('#addhospital_id').combobox('reload', url);
											        }
						            			"/>	
						            	</td>							
									</tr>
									<tr>
										<td>试用医院:</td>
										<td>										
											<input class="easyui-combobox" name="addhospital_id" id="addhospital_id" 
											style="width:260px" maxLength="100" value="" class="easyui-validatebox"" data-options="
											valueField:'hospital_id',
											textField:'hospital_name',
											 onSelect: function(rec){
											 	$('#hospital_name').val(rec.hospital_name);		
											  }
											"/>	
												
										</td>		
										
										
														
									</tr>
									
									<tr>
										<td>试用时间:</td>
										<td>
										<input name="create_time"  class="easyui-datebox" style="width:260px"></input>
										
										</td>								
									</tr>
									<tr>
										<td>试用理由:</td>
										<td>
										<textarea name="reason" style="height:120px;width:360px;"></textarea>
										</td>								
									</tr>
								</table>
								<input type="text" name="trial_id" id="trial_id" value="">
								<input type="text" name="dealer_name" id="dealer_name" value="">
								<input type="text" name="hospital_name" id="hospital_name" value="">
				</form>			
				<div style="text-align: right; padding: 5px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#dlgadd').dialog('close')">取消</a>					   
				</div>
			</div>
			
			<%-- <div title="产品明细行" >
					<div id="tbOrderDetail">    
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="saveOrderDetail" onclick="newOrderDetailEntity();">添加产品</a>
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delOrderDetail" onclick="removeOrderDetailEntity();">删除产品</a>
					</div>
				<table id="dgadd" title="查询结果" style="width:650px;height: 340px" url="${basePath}api/flow/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'flow_id',width:10"  sortable="true" hidden="true">id</th>
							<th data-options="field:'flow_name',width:100"  sortable="true">产品名称</th>
							<th data-options="field:'flow_desc',width:100" sortable="true">规格型号</th>
							<th data-options="field:'is_system',width:50" sortable="true">数量</th>
							
							<th data-options="field:'add_date',width:50">备注</th>										
						</tr>
					</thead>
				</table>				
			</div>		 --%>	
		</div>
	</div>
	<!--add end -->	
	
	
	<!--dlgdetail start -->	
	<div id="dlgdetail" class="easyui-dialog" title="申请试用" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:850px;height:500px;padding:10px;">
	
	
	<div class="easyui-tabs" style="width:820px;height:380px">	
		<div title="基本信息" >
				<form id="base_form_detail" action="" method="post" enctype="multipart/form-data">
								<table>
									<tr>
										<td>试用医院:</td>
										<td>
										<input  style="width:260px;" class="easyui-validatebox" type="text" 
										name="hospital_id" data-options="required:true"></input></td>								
									</tr>
									<tr>
										<td>经销商:</td>
										<td>
										<input  style="width:260px;" class="easyui-validatebox" type="text"
										 name="dealer_user_id" data-options="required:true"></input></td>								
									</tr>
									<tr>
										<td>试用时间:</td>
										<td>
										<input name="create_time"  class="easyui-datebox"></input>
										
										</td>								
									</tr>
									<tr>
										<td>试用理由:</td>
										<td>
										<textarea name="reason" style="height:120px;width:360px;"></textarea>
										</td>								
									</tr>
								</table>
				</form>			
				
			</div>
			
			<div title="产品明细行" >
			
					<div id="tbOrderDetail">    
						<restrict:function funId="171">
							<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" id="saveOrderDetail" onclick="newOrderDetailEntity();">添加产品</a>
						</restrict:function>
						<restrict:function funId="172">
					   		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" id="delOrderDetail" onclick="removeOrderDetailEntity();">删除产品</a>
					    </restrict:function>
					</div>
				<table id="dgDetail" title="查询结果" style="width:650px;height: 320px">
					<thead>
						<tr>
							<th data-options="field:'trial_detail_id',width:10"  sortable="true" hidden="true">trial_detail_id</th>
							<th data-options="field:'product_name',width:150"  sortable="true">产品名称</th>
							<th data-options="field:'product_name',width:150" sortable="true">规格型号</th>
							<th data-options="field:'trial_num',width:50" sortable="true">数量</th>							
							<th data-options="field:'remark',width:290">备注</th>										
						</tr>
					</thead>
				</table>
			</div>
			
			<div title="流程记录" >
				<table id="dgdescflow_record" title="查询结果" style="width:810px;height: 340px">
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
		</div>
	</div>
	<!--dlgdetail end -->	
	
	<!--flow check start -->	
	<div id="dlgflowcheck" class="easyui-dialog" title="申请试用-审核" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:850px;height:500px;padding:10px;">
	
	
	<div class="easyui-tabs" style="width:820px;height:380px">	
		<div title="基本信息" >
				<form id="base_form_flowcheck" action="" method="post" enctype="multipart/form-data">
								<table>
									<tr>
										<td>试用医院:</td>
										<td>
										<input  style="width:260px;" class="easyui-validatebox" type="text" 
										name="hospital_id" data-options="required:true"></input></td>								
									</tr>
									<tr>
										<td>经销商:</td>
										<td>
										<input  style="width:260px;" class="easyui-validatebox" type="text"
										 name="dealer_user_id" data-options="required:true"></input></td>								
									</tr>
									<tr>
										<td>试用时间:</td>
										<td>
										<input name="create_time"  class="easyui-datebox"></input>
										
										</td>								
									</tr>
									<tr>
										<td>试用理由:</td>
										<td>
										<textarea name="reason" style="height:120px;width:360px;"></textarea>
										</td>								
									</tr>
								</table>
				</form>			
				
			</div>
			
			<div title="产品明细行" >
				
					
					<table id="dgflow" title="查询结果" style="width:650px;height: 320px">
					<thead>
						<tr>
							<th data-options="field:'trial_detail_id',width:10"  sortable="true" hidden="true">trial_detail_id</th>
							<th data-options="field:'product_name',width:150"  sortable="true">产品名称</th>
							<th data-options="field:'product_name',width:150" sortable="true">规格型号</th>
							<th data-options="field:'trial_num',width:50" sortable="true">数量</th>							
							<th data-options="field:'remark',width:290">备注</th>										
						</tr>
					</thead>
				</table>
			</div>
			
			<div title="流程记录" >
				<table id="dgflow_record" title="查询结果" style="width:810px;height: 340px">
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
			<div title="审核" >
				<form id="base_form_check" action="" method="post" enctype="multipart/form-data">
						<table>
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
							
							<tr height="60">
								<td>处理意见:</td>
								<td>
								<textarea name="check_reason" style="height:60px;width:260px;"></textarea>
								</td>								
							</tr>
							
							<tr height="60"><td colspan="2">
							<input type="hidden" name="bussiness_id" id="bussiness_id">
							<input type="hidden" name="flow_id" id="flow_id" value="">
							<div style="text-align: right; padding: 5px">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveFlowCheck()">提交</a>
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="javascript:$('#dlgflowcheck').dialog('close')">取消</a>					   
							</div>				
							</td>
							</tr>					
						</table>
				</form>					
			</div>
			
		</div>
	</div>
	<!--flow end -->	
	
		<div id="dlgProduct" class="easyui-dialog" title="申请试用-审核" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
			style="width:850px;height:500px;padding:10px;" buttons="#dlgProduct-buttons">
						<div class="easyui-panel" title="查询条件" style="width:775px;">
								<div style="padding: 10px 0 0 30px">
									<form id="ffdetail" method="post">
										<table>
											<tr>
												<td>产品编号:</td>	
												<td width="100px"><input class="easyui-validatebox" type="text" name="item_number" id="item_number" ></input></td>
												<td>选择分类:</td>
												<td>
									            	<input class="easyui-combobox" name="category_id" id="category_id" style="width:150px" maxLength="100" value="" class="easyui-validatebox""/>
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
								<table id="dgProduct" title="查询结果" style="height:300px" method="get"
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
			    		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="newProductNumEntity()">添加</a>
			        	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProduct').dialog('close')">取消</a>
			    </div>	
			    
			    
			    <div id="dlgProductSum" class="easyui-dialog" style="width:300px;height:300px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlgProductSum-buttons">
		        <form id="fm3" action="" method="post" enctype="multipart/form-data">
					      <table> 
					    		<tr>
					             	<td>试用单号:</td><input name="trial_id" readonly="true" type="input">
					             	<td><input name="trial_code" readonly="true" class="easyui-validatebox" style="width:150px;"></td>
					            </tr>
					            <tr>
					             	<td>产品编码:</td>
					             	<td><input name="product_id" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>
					            <tr>
					             	<td>产品名称</td>
					             	<td><input name="product_name" readonly="true" class="easyui-validatebox" style="width:150px"></td>
					            </tr>					           
						        <tr>
					             	<td>数量:</td>
					             	<td><input name="trial_num" id="trial_num" class="easyui-numberbox" style="width:150px" 
									data-options="required:true"></td>
					             </tr>
					             <tr>
					             	<td>备注:</td>
					             	<td><input name="remark" id="remark" class="easyui-numberbox" style="width:150px" 
									data-options="required:true"></td>
					             </tr>
					      </table>        	
		        </form>
	    </div>
	    <div id="dlgProductSum-buttons">
		   
		        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveOrderDetailEntity();">保存</a>
		    
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProductSum').dialog('close')">取消</a>
	    </div>
		
	<script type="text/javascript">
	
	 	var url;
	 	var trial_id;
	 	var trial_code;
	 	var trial_status;
	 	var dealer_id;
		$('#dg').datagrid(
				{
					onLoadSuccess:function(data){ 
					  $(".questionBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				 }
		});
		

		
		 function formatterInfo (value, row, index) { 
			 return '<span style="color:red" onclick="openview(' + row.flow_id + ');">查看详细流程 </span>'; 
		} 
		 function formattersign(value, row, index)
		 {
			 if(row.sign && row.sign!="")
			 	return '<span><img src="'+basePath+'resource/signimg/'+value+'" width="50" height="50"></span>'; 
		 }
		 
		 function formatterdesc (value, row, index) { 
			// v = "'"+ row.id + "','" + index+"'";
			 	return '<a class="questionBtn" href="javascript:void(0)"  onclick="View_Entity('+index+')" ></a>';
			 //return '<span><img src="'+basePath+'resource/themes/icons/detail.png" style="cursor:pointer" onclick="View_Entity(' + index + ');"></span>'; 
		} 
		 function formatterIs_order (value, row, index) { 
				return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
			}
		
		 function formatterstatus (value, row, index) { 
			 if(value=='0')
				 return '<span style="color:green" >未提交</span>'; 
				else if(value=='1')
					return '<span style="color:red">已提交</span>'; 
				else if(value=='2')
					return '<span style="color:red">驳回</span>'; 
				else if(value=='3')
					return '<span style="color:#0044BB">已审核</span>'; 				
				else if(value=='4')
					return '<span style="color:red">已完成</span>'; 
			
		}
		
	    function openview(t){	    	
	    	  $("#test").window({
	               width: 780,
	               modal: true,
	               height: 590,
	               closable:true,
	               minimizable:false,
	               maximizable:false,
	               zIndex:9999,
	               collapsible:false
	              });
	    	 $('#test').load(basePath+'web/flow/view?fow_id='+t); 
	    	 //href: '/yijava-dms/flow/viewdetail.jsp'
	    }
	


    	/**
    	主数据加载
    	*/
		$(function() {
			
			
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
			
		});
		
		
		
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_flow_name: $('#flow_name').val()
		    });
		}
		
		function newEntity()
		{
			 $('#ffadd').form('clear');
			 url = basePath+'api/protrial/save';
	         $('#dlgadd').dialog('open').dialog('setTitle', '填写申请试用');
	         
	         
	         /**
	 		添加数据加载
	 		*/
	 		
 			var pager1 = $('#dgadd').datagrid().datagrid('getPager'); // get the pager of datagrid
 			pager1.pagination(); 
	 			
	 		
		}
		
		function saveEntity()
		{
			$('#ffadd').form('submit', {
			    url:url,
			    method:"post",
			   
			    onSubmit: function(){
			        // do some check
			        // return false to prevent submit;
			    	//return $(this).form('validate');;
			    },
			    success:function(msg){
			    	
			    	var jsonobj= eval('('+msg+')');  
			    	if(jsonobj.state==1)
			    		{
			    			clearForm();			    			
			    			$('#dlgadd').dialog('close');
			    			var pager = $('#dg').datagrid().datagrid('getPager');
			    			pager.pagination('select');	
				   			
			    		}
			    }		
			});			
		}		
		function viewEntity()
		{
			var row = $('#dg').datagrid('getSelected');			
			if (row && (row.status ==0 || row.status==2)){		  
			    $('#ffadd').form('load', row);
			    
			    /**
		 		添加数据加载
		 		*/
		 		
	 			/* var pager1 = $('#dgadd').datagrid().datagrid('getPager'); // get the pager of datagrid
	 			pager1.pagination(); */
	 			
	 			
			    url = basePath+'api/protrial/update';
			    $('#dlgadd').dialog('open').dialog('setTitle', '修改申请试用');
			}else
			{
				$.messager.alert('提示---数据已经提交不能修改','请选中数据!','warning');				
			}			
		}
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row && (row.status ==0 || row.status==2)){		
				 $.messager.confirm('确定','确定要删除吗 ?',function(r){
					 if (r){
	                        $.post(basePath+'api/protrial/remove',{trial_id:row.trial_id},function(result){
	                        	
	        			    	if(result.state==1){
	        			    		var pager = $('#dg').datagrid().datagrid('getPager');
	    			    			pager.pagination('select');	
	                            } else {
	                                $.messager.show({    // show error message
	                                    title: 'Error',
	                                    msg: result.errorMsg
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
		

		function clearForm(){
			$('#ffadd').form('clear');
		}
		
		/**
		提交审核
		*/
		function ToCheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row && (row.status ==0 || row.status ==2) ){			
				 $.messager.confirm('提示','提交后将不能修改 ,确定要要提交审核吗  ?',function(r){
					 if (r){
	                        $.post(basePath+'api/protrial/updatetocheck',{trial_id:row.trial_id},function(result){
	                        	
	        			    	if(result.state==1){
	        			    		var pager = $('#dg').datagrid().datagrid('getPager');
	    			    			pager.pagination('select');	
	                            } else {
	                                $.messager.show({    // show error message
	                                    title: 'Error',
	                                    msg: result.errorMsg
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
		
		/**
		审核
		*/
		function CheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row && row.status ==1){				
				 $.messager.confirm('提示','确定要要审核吗  ?',function(r){
					
					 $('#bussiness_id').val(row.trial_id);
					 $("#flow_id").val(trialflow_identifier_num);
					 //填充基本信息
					  $('#base_form_flowcheck').form('load', row);
					  LoadProductDetailForFlow(row.trial_id);
					 //加载流程记录
					 LoadCheckFlowRecord(row.trial_id);
					 
					 $('#dlgflowcheck').dialog('open').dialog('setTitle', '审核');
				 });
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');
			}
			 
		}
		
		//dlgdetail
		function View_Entity(index){			
			 //填充基本信息			 
			 //selectRow
			 $('#dg').datagrid('selectRow', index);
			 var row = $('#dg').datagrid('getSelected');
			  $('#base_form_detail').form('load', row);
			 trial_id=row.trial_id;
			 trial_code=row.trial_code;
			 trial_status=row.status;
			 dealer_id=row.dealer_user_id;
			 //加载流程记录
			 LoadFlowRecord(row.trial_id);
			 LoadProductDetail(row.trial_id);				
			 $('#dlgdetail').dialog('open').dialog('setTitle', '明细');
			//var row = $('#dg').datagrid('getSelected');
			//if (row && row.status ==1){		
				
			if(trial_status=='0'|| trial_status=='2'){
				$('#saveOrderDetail').linkbutton('enable');
				$('#delOrderDetail').linkbutton('enable');
			}else{
				$('#saveOrderDetail').linkbutton('disable');
				$('#delOrderDetail').linkbutton('disable');
			}
		}
			
		function LoadProductDetail(trial_id)
		{
			 $('#dgDetail').datagrid({
				 url:basePath+'api/trialdetail/view?trial_id='+trial_id
				}); 
				
		
			
		}
		
		function LoadProductDetailForFlow(trial_id)
		{
			 $('#dgflow').datagrid({
				 url:basePath+'api/trialdetail/view?trial_id='+trial_id
				}); 
				
		
			
		}
			
		function  LoadFlowRecord(bussinessId)
		{
			 $('#dgdescflow_record').datagrid({
			    url:basePath+'api/flowlog/list?bussiness_id='+bussinessId+"&flow_id="+trialflow_identifier_num
			}); 
			
		}
		
		function  LoadCheckFlowRecord(bussinessId)
		{
			 $('#dgflow_record').datagrid({
			    url:basePath+'api/flowlog/list?bussiness_id='+bussinessId+"&flow_id="+trialflow_identifier_num
			}); 
			
		}
		
		/*审核结果*/
		function saveFlowCheck()
		{
		
			
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
			    	if(jsonobj.state==1)
			    		{
			    			clearForm();			    			
			    			$('#dlgflowcheck').dialog('close');
			    			var pager = $('#dg').datagrid().datagrid('getPager');
			    			pager.pagination('select');	
				   			
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
		
		
		
		/**
		查看单据
		*/
		function VidwDocument (value, row, index) 
		{
			var row = $('#dg').datagrid('getSelected');
			if (row && row.status ==3){				
				$.post(basePath+'api/protrial/viewdocument',{trial_id:row.trial_id},function(result){
                	
			    	if(result.state==1){
			    		
			    		var tabTitle = "试用管理单据 "+result.data;
						var url = "generate/"+result.data;						
						addTabByChild(tabTitle,url);
			    		//var pager = $('#dg').datagrid().datagrid('getPager');
		    			//pager.pagination('select');	
                    } else {
                        $.messager.show({    // show error message
                            title: 'Error',
                            msg: result.error
                        });
                    } 
                },'json');
			}else
			{
				$.messager.alert('提示-审核结束才能查看单据 ','请选中数据!','warning');
			}
			
		}
		function newOrderDetailEntity()
		{
			if(trial_status=="0" || trial_status=="2")
			{
				/**
				产品分类下拉框
				*/
				$('#category_id').combobox({
				    url:basePath+'api/dealerAuthProduct/list?dealer_id='+dealer_id,
				    valueField:'product_category_id',
					textField:'category_name'
				});
			
				$('#dlgProduct').dialog('open').dialog('setTitle','['+trial_code+']产品列表');
				$('#dgProduct').datagrid({
						 url:basePath+'api/product/api_paging',
						 queryParams: {
							 filter_ANDS_dealer_id : dealer_id
						 }
	
				});	
			}else
			{
				$.messager.alert('提示','申请已经提交不能修改','warning');
			}
		}
		/**
		选择产品明细 
		*/
		function newProductNumEntity() {
			$('#fm3').form('clear');
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				
				$("#fm3 input[name=trial_id]").val(trial_id);
				$("#fm3 input[name=trial_code]").val(trial_code);
				$("#fm3 input[name=product_id]").val(row.item_number);
				$("#fm3 input[name=product_name]").val(row.cname);
				//$("#fm3 input[name=order_price]").val(row.price);
				//$("#fm3 input[name=discount]").val(row.discount);
				
				$('#dlgProductSum').dialog('open').dialog('setTitle','添加产品');
			}else
			{
				$.messager.alert('提示','请选中某个产品!','warning');
			}
		}
		
		/**
		保存产品明细 
		*/
		function saveOrderDetailEntity(){
			var row = $('#dgProduct').datagrid('getSelected');
			if(row){
				$('#fm3').form('submit', {
					url :basePath+'api/trialdetail/save',
				    method:"post",
				    onSubmit: function(){
				        return $(this).form('validate');
				    },
				    success:function(msg){
				    	var jsonobj = $.parseJSON(msg);
				    	if(jsonobj.state==1){
							 $('#dlgProductSum').dialog('close');     
		                     $('#dgDetail').datagrid('reload');
		                     //$('#dg').datagrid('reload');
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
		
		//订单项
		function removeOrderDetailEntity()
		{
			var row = $('#dgDetail').datagrid('getSelected');
			if (row){
				if(trial_status=='0'){
				    $.ajax({
						type : "POST",
						url :basePath+'api/trialdetail/delete?trial_detail_id='+row.trial_detail_id,
						error : function(request) {
							$.messager.alert('提示','抱歉,删除错误!','error');	
						},
						success:function(msg){
						    var jsonobj = $.parseJSON(msg);
        					if (jsonobj.state == 1) {
        	                     $('#dgDetail').datagrid('reload');
        	                     
        					}else{
        						$.messager.alert('提示',jsonobj.error.msg,'error');	
        					}
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
		
		function doSearchProduct(){
		    $('#dgProduct').datagrid('load',{
		    	filter_ANDS_item_number: $("#ffdetail input[name=item_number]").val(),
		    	filter_ANDS_dealer_id: dealer_id,
		    	filter_ANDS_category_id: $("#ffdetail input[name=category_id]").val()
		    });
		}
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>