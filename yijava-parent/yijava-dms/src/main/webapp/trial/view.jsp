<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
									<input class="easyui-combobox" name="dealer_id" id="dealer_id" style="width:150px" maxLength="100" class="easyui-validatebox"
						             			data-options="
							             			url:'${basePath}/api/dealer/list',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto'
						            			"/>								
									</td>
									
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

				<table id="dg" title="查询结果" style="height: 330px" url="${basePath}api/protrial/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'trial_id',width:100"  sortable="true" hidden="true">trial_id</th>
							<th data-options="field:'dealer_name',width:200"  sortable="true">经销商名称</th>
							<th data-options="field:'hospital_name',width:200"  sortable="true">医院名称</th>									
							<th data-options="field:'reason',width:300" sortable="true">试用理由</th>							
							<th data-options="field:'create_time',width:200">申请日期</th>	
							<th data-options="field:'status',width:90" sortable="true" formatter="formatterstatus">单据状态</th>							
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		

	<!--add start -->	
	<div id="dlg" class="easyui-dialog" title="申请试用" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:720px;height:500px;padding:10px;">
	
	
	<div class="easyui-tabs" style="width:680px;height:380px">	
		<div title="基本信息" >
				<form id="ffadd" action="" method="post" enctype="multipart/form-data">
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
				<div style="text-align: right; padding: 5px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
				</div>
			</div>
			
			<div title="产品明细行" >
				<table id="dg1" title="查询结果" style="width:650px;height: 340px" url="${basePath}api/protrial/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'flow_id',width:10"  sortable="true" hidden="true">id</th>
							<th data-options="field:'flow_name',width:100"  sortable="true">产品名称</th>
							<th data-options="field:'flow_desc',width:100" sortable="true">规格型号</th>
							<th data-options="field:'is_system',width:50" sortable="true" formatter="formatterSystem">数量</th>
							
							<th data-options="field:'add_date',width:50">备注</th>										
						</tr>
					</thead>
				</table>
			</div>
			
		</div>
	</div>
	<!--add end -->	
	
	<!--flow start -->	
	<div id="dlgflow" class="easyui-dialog" title="申请试用" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:720px;height:500px;padding:10px;">
	
	
	<div class="easyui-tabs" style="width:680px;height:380px">	
		<div title="基本信息" >
				<form id="ffadd" action="" method="post" enctype="multipart/form-data">
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
				<div style="text-align: center; padding: 50px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
				</div>
			</div>
			
			<div title="产品明细行" >
				<table id="dg1" title="查询结果" style="width:650px;height: 340px" url="${basePath}api/protrial/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'flow_id',width:10"  sortable="true" hidden="true">id</th>
							<th data-options="field:'flow_name',width:100"  sortable="true">产品名称</th>
							<th data-options="field:'flow_desc',width:100" sortable="true">规格型号</th>
							<th data-options="field:'is_system',width:50" sortable="true" formatter="formatterSystem">数量</th>
							
							<th data-options="field:'add_date',width:50">备注</th>										
						</tr>
					</thead>
				</table>
			</div>
			<div title="流程记录" >
				<table id="dg1" title="查询结果" style="width:650px;height: 340px" url="${basePath}api/protrial/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'flow_id',width:10"  sortable="true" hidden="true">id</th>
							<th data-options="field:'flow_name',width:100"  sortable="true">产品名称</th>
							<th data-options="field:'flow_desc',width:100" sortable="true">规格型号</th>
							<th data-options="field:'is_system',width:50" sortable="true" formatter="formatterSystem">数量</th>
							
							<th data-options="field:'add_date',width:50">备注</th>										
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
	<!--flow end -->	
	
	
	<div id="test" title="流程设计" style="top:10px;padding:1px;width:780px;height:590px;" title="Modal Window">
	
    </div>


	<script type="text/javascript">
	
	 	var url;	 
		$('#dg').datagrid({
		    toolbar : [{
		        text:'添加',
		        iconCls:'icon-add',
		        handler:function(){
		        	newEntity();
		        	//$('#w').window('open');
				}
		    },{
		        text:'编辑',
		        iconCls:'icon-edit',
		        handler:function(){
		        	viewEntity();
				}
		    }
		    ,'-',{
		        text:'删除',
		        iconCls:'icon-remove',
		        handler:function(){
		        	deleteEntity();
		        }
		    },{
		        text:'提交审核',
		        iconCls:'icon-ok',
		        handler:function(){
		        	ToCheckEntity();
				}
		    },{
		        text:'审核',
		        iconCls:'icon-check',
		        handler:function(){
		        	CheckEntity();
				}
		    }
		    ]
		});
		

		
		 function formatterInfo (value, row, index) { 
			 return '<span style="color:red" onclick="openview(' + row.flow_id + ');">查看详细流程 </span>'; 
		} 
		
		 function formatterstatus (value, row, index) { 
			 if(value=='0')
					return '<span>未提交</span>'; 
				else if(value=='1')
					return '<span>已提交</span>'; 
				else if(value=='2')
					return '<span>驳回</span>'; 
				else if(value=='3')
					return '<span>已审核</span>'; 				
				else if(value=='4')
					return '<span>已完成</span>'; 
			
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
	


    
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
			
		});
		$(function() {
			var pager = $('#dg1').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
			
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
	         $('#dlg').dialog('open').dialog('setTitle', '申请试用');
		}
		
		function saveEntity()
		{
			$('#ffadd').form('submit', {
			    url:url,
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
			    			$('#dlg').dialog('close');
			    			var pager = $('#dg').datagrid().datagrid('getPager');
			    			pager.pagination('select');	
				   			
			    		}
			    }		
			});			
		}		
		function viewEntity()
		{
			var row = $('#dg').datagrid('getSelected');			
			if (row){			   
			    $('#ffadd').form('load', row);
			    url = basePath+'api/protrial/update?flow_id='+row.flow_id;
			    $('#w').window('open');
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');				
			}			
		}
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
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
				$.messager.alert('提示','请选中数据!','warning');
			}
			
		}
		

		function clearForm(){
			$('#ffadd').form('clear');
		}
		
		function ToCheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
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
				$.messager.alert('提示','请选中数据!','warning');
			}
		}
		
		function CheckEntity(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				 $.messager.confirm('提示','提交后将不能修改 ,确定要要提交审核吗  ?',function(r){
					 
					 $('#dlgflow').dialog('open').dialog('setTitle', '审核');
				 });
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');
			}
			 
		}
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>