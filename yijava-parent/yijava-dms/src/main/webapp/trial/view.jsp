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
							<th data-options="field:'id',width:90" sortable="true" formatter="formatterdesc">明细</th>							
						</tr>
					</thead>
				</table>

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
										<td>试用医院:</td>
										<td>
										
										
										<input  style="width:260px;" class="easyui-validatebox" type="hidden" 
										name="trial_id" data-options="required:true" ></input>
										
										
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
			</div>
			
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
				<table id="dgdesc" title="查询结果" style="width:650px;height: 340px" url="${basePath}api/flow/paging" method="get"
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
				<table id="dgflow" title="查询结果" style="width:650px;height: 340px" url="${basePath}api/flow/paging" method="get"
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
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
							</div>				
							</td>
							</tr>					
						</table>
				</form>					
			</div>
			
		</div>
	</div>
	<!--flow end -->	
	


	<script type="text/javascript">
	
	 	var url;	 
		$('#dg').datagrid(
				{
					onLoadSuccess:function(data){ 
					  $(".questionBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
				 },
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
		 function formattersign(value, row, index)
		 {
			 if(row.sign && row.sign==1)
			 	return '<span><img src="'+basePath+'resource/signimg/10049_qz.jpg" width="50" height="50"></span>'; 
		 }
		 
		 function formatterdesc (value, row, index) { 
			// v = "'"+ row.id + "','" + index+"'";
			 	return '<a class="questionBtn" href="javascript:void(0)"  onclick="View_Entity('+index+')" ></a>';
			 //return '<span><img src="'+basePath+'resource/themes/icons/detail.png" style="cursor:pointer" onclick="View_Entity(' + index + ');"></span>'; 
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
			if (row && row.status ==0){		  
			    $('#ffadd').form('load', row);
			    
			    /**
		 		添加数据加载
		 		*/
		 		
	 			var pager1 = $('#dgadd').datagrid().datagrid('getPager'); // get the pager of datagrid
	 			pager1.pagination();
	 			
	 			
			    url = basePath+'api/protrial/update?flow_id='+row.flow_id;
			    $('#dlgadd').dialog('open').dialog('setTitle', '修改申请试用');
			}else
			{
				$.messager.alert('提示---数据已经提交不能修改','请选中数据!','warning');				
			}			
		}
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row && row.status ==0){		
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
			if (row && row.status ==0){			
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
					 var dgflow = $('#dgflow').datagrid().datagrid('getPager'); 
					 dgflow.pagination(); 
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
			 //加载流程记录
			 LoadFlowRecord(row.trial_id);
			
			
			
			
			var pagerdesc = $('#dgdesc').datagrid().datagrid('getPager'); 
			pagerdesc.pagination(); 
			
			
			
				
				
			 $('#dlgdetail').dialog('open').dialog('setTitle', '审核');
			//var row = $('#dg').datagrid('getSelected');
			//if (row && row.status ==1){				
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
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>