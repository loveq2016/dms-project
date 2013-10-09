<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>	

<%@include file="/common/base.jsp"%>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">

				<div class="easyui-panel" title="查询条件">
					<div style="padding: 10px 0 10px 60px">
						<form id="ffquery" method="post" border="1">
							<table>
								<tr>
									<td>流程名称:</td>
									<td>
										${flow.flow_name }
									</td>
									
								</tr>
								<tr>
									<td>流程描述:</td>
									<td>
										${flow.flow_name }
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
								   
					</div>
				</div>
				
				<div style="margin: 10px 0;"></div>

				<div style="padding-left: 10px; padding-right: 10px">
	
					<table id="dg1" title="选择步骤" style="height: 330px" url="${basePath}api/step/view?flow_id=${flow.flow_id}" method="get"
						 singleSelect="true" pagination="false" sortName="item_number" sortOrder="asc">					
						<thead>
							<tr>
								<th data-options="field:'step_id',width:300"  sortable="true" hidden="true">step_id</th>
								<th data-options="field:'action_id',width:300"  sortable="true" hidden="true">action_id</th>
								
								<th data-options="field:'step_order_no',width:80,editor:'numberbox'">步骤序号</th>
								<th data-options="field:'action_name',width:200,editor:'text'"  >步骤名称</th>
								<th data-options="field:'action_desc',width:200,editor:'text'">步骤描述</th>	
								<th data-options="field:'step_type',width:100,formatter:formattersteptype,
									editor:{  
	                            	type:'combobox',  
		                           options:{  
		                                valueField:'typeid',  
		                                textField:'name',  
		                                data:step_type,  
		                               required:true  
		                            } }">处理类型</th>	
		                        
		                         <th data-options="field:'dd',width:100,formatter:formatterUserInfo">查看处理部门</th>				
							</tr>
						</thead>
					</table>
	
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>
			<div id="step_dep" title="流程设计-节点处理人" style="top:10px;padding:1px;width:780px;height:590px;" title="Modal Window">
				<!-- <div id="test" class="easyui-window" data-options="closed:true,modal:true,title:'Test Window'" style="width:300px;height:100px;"> -->
			    </div>
			<script language="javascript">
			var step_type = [  
	           {typeid:'1',name:'顺序处理'},  
	           {typeid:'0',name:'并行处理'}
	       ]; 

			var lastIndex;  
			
			$(function() {
				var pager = $('#dg1').datagrid(); // get the pager of datagrid				
			}); 
			
			 function formattersteptype (value, row) { 
				 
				 if(value==1)
					 return "并行处理";
				 else
					 return "顺序处理";
				
			}
			 
			 $(function(){  				 
					$('#dg1').datagrid({						
					    toolbar : [{
					        text:'刷新',
					        iconCls:'icon-reload',
					        handler:function(){			        	
					        	var pager = $('#dg1').datagrid(); // get the pager of datagrid
							}
					    },{
					    	id:'addStepMenu',
					        text:'添加',
					        iconCls:'icon-add',
					        handler:function(){
					        	
					        	$('#addStepMenu').linkbutton('disable');
					        	$('#dg1').datagrid('endEdit', lastIndex); 
					        	$('#dg1').datagrid('appendRow',{  
					        		step_order_no:'',  
					        		action_name:'',  
					        		action_desc:'',  
					        		step_type:'' 
		                        
		                       }); 
					        	lastIndex = $('#dg1').datagrid('getRows').length-1;  
			                    $('#dg1').datagrid('selectRow', lastIndex);  
			                    $('#dg1').datagrid('beginEdit', lastIndex);  
			                    
			                    $('#saveStepMenu').linkbutton('enable');
							}
					    },'-',{
					        text:'删除',
					        iconCls:'icon-remove',
					        handler:function(){
					        	deleteStepEntity();
					        }
					    },'-',{  
					    	id:'saveStepMenu',
					    	text:'保存',  
					    	iconCls:'icon-save',  
					    	
					    	handler:function(){  
					    		//$('#dg1').datagrid('acceptChanges');
					    		//alert(lastIndex);
					    		if (lastIndex != undefined) {
									$('#dg1').datagrid('endEdit', lastIndex);
									
									saveChange();
									
								}
					    		
					    	}  
					    }
					    ]
					});
					
					
					$('#saveStepMenu').linkbutton('disable');
			 });  
			 
			 function saveChange()
			 {
				 var insertRows = $('#dg1').datagrid('getChanges','inserted');
				 var step_order_no=insertRows[0].step_order_no;
				 var action_name=insertRows[0].action_name;
				 var action_desc=insertRows[0].action_desc;
				 var step_type=insertRows[0].step_type;
				 
				 var data="step_order_no="+step_order_no+"&action_name="+action_name+"&action_desc="+action_desc+"&step_type="+step_type;
				     data+="&flow_id="+${flow.flow_id }
				 $.ajax({
				     type: 'POST',
				     url: '${basePath}api/step/save',
				    data: data ,
				    async : false, //默认为true 异步  
				    success:function(data){ 
				    	$('#addStepMenu').linkbutton('enable');
				    	$('#saveStepMenu').linkbutton('disable');
				        //alert(data);   
				    	$('#dg1').datagrid('reload');
				    },
				    error:function(){     
				        alert('error');     
				     }
				    
				});
 				
				//alert(JSON.stringify(changesRows));
			 }
			 
			 
			 function deleteStepEntity()
				{
					var row = $('#dg1').datagrid('getSelected');
					if (row){
						 $.messager.confirm('确定','确定要删除吗 ?',function(r){
							 if (r){
			                        $.post(basePath+'api/step/remove',{step_id:row.step_id,action_id:row.action_id},function(result){
			                        	//var jsonobj= eval('('+result+')');  
			                        	//alert(result);
			        			    	if(result.state==1){
			                                //$('#dg1').datagrid('reload');    // reload the user data
			                                $('#dg1').datagrid('reload');
			                            } else {
			                                $.messager.show({    // show error message
			                                    title: 'Error',
			                                    msg: result.error.msg
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
			 
			 
			 function formatterUserInfo (value, row, index) { 
				 return '<span style="color:red" onclick="viewcheckdep(' + row.step_id + ');">查看处理部门 </span>'; 
			} 
			 
			 function viewcheckdep(t)
			 {
				 $("#step_dep").window({
		               width: 480,
		               modal: true,
		               height: 490,
		               closable:true,
		               minimizable:false,
		               maximizable:false,
		               zIndex:9999,
		               collapsible:false
		              });
		    	 $('#step_dep').load(basePath+'/web/flow/step_dep/view?step_id='+t); 
			 }
			</script>