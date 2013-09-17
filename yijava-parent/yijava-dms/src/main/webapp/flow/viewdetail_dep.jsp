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
									<td>步骤名称:</td>
									<td>
										${step.action_name }
									</td>
									
								</tr>
								<tr>
									<td>步骤描述:</td>
									<td>
										${step.action_desc },${step.step_id },${step.action_id },${step.flow_id }
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
	
					<table id="dgdep" title="选择步骤处理部门" style="height: 300px" url="${basePath}api/step_dep/view?step_id=${step.step_id}" method="get"
						 singleSelect="true" pagination="false" sortName="item_number" sortOrder="asc">					
						<thead>
							<tr>
								<th data-options="field:'entity_id',width:300"  sortable="true" hidden="true">entity_id</th>
								
								<th data-options="field:'department_name',width:200" editor="{type:'combotree',options:{url:'${basePath}api/department/listByParentId'}}">部门</th>
							
		                        <th data-options="field:'ext_logic',width:200,formatter:formatterstepdeptype,
									editor:{  
	                            	type:'combobox',  
		                           options:{  
		                                valueField:'typeid',  
		                                textField:'name',  
		                                data:ext_logic,  
		                               required:true  
		                            } }">处理类型</th>	
		                         
							</tr>
						</thead>
					</table>
	
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<script language="javascript">
			var ext_logic = [  
			  	           {typeid:'1',name:'需要销售关系处理'},  
			  	           {typeid:'0',name:'不需要销售关系处理'}
			  	       ]; 

			var lastIndex;  
			
			$(function() {
				var pager = $('#dgdep').datagrid(); // get the pager of datagrid				
			}); 
			
			function formatterstepdeptype (value, row) { 
				 
				 if(value==1)
					 return "需要销售关系处理";
				 else
					 return "不需要销售关系处理";
				
			}
			 
			 $(function(){  				 
					$('#dgdep').datagrid({						
					    toolbar : [{
					        text:'刷新',
					        iconCls:'icon-reload',
					        handler:function(){			        	
					        	var pager = $('#dgdep').datagrid(); // get the pager of datagrid
							}
					    },{
					    	id:'addStepDepMenu',
					        text:'添加',
					        iconCls:'icon-add',
					        handler:function(){
					        	
					        	$('#addStepDepMenu').linkbutton('disable');
					        	$('#dgdep').datagrid('endEdit', lastIndex); 
					        	$('#dgdep').datagrid('appendRow',{  
					        		department_name:'',
					        		ext_logic:'',
		                       }); 
					        	lastIndex = $('#dgdep').datagrid('getRows').length-1;  
			                    $('#dgdep').datagrid('selectRow', lastIndex);  
			                    $('#dgdep').datagrid('beginEdit', lastIndex);  
			                    
			                    $('#saveStepDepMenu').linkbutton('enable');
							}
					    },'-',{
					        text:'删除',
					        iconCls:'icon-remove',
					        handler:function(){
					        	deleteStepDepEntity();
					        }
					    },'-',{  
					    	id:'saveStepDepMenu',
					    	text:'保存',  
					    	iconCls:'icon-save',  
					    	
					    	handler:function(){  
					    		//$('#dg1').datagrid('acceptChanges');
					    		//alert(lastIndex);
					    		if (lastIndex != undefined) {
									$('#dgdep').datagrid('endEdit', lastIndex);
									
									saveStepDepChange();
									
								}
					    		
					    	}  
					    }
					    ]
					});
					
					
					$('#saveStepDepMenu').linkbutton('disable');
			 });  
			 
			 function saveStepDepChange()
			 {
				 var insertRows = $('#dgdep').datagrid('getChanges','inserted');
				 var department_name=insertRows[0].department_name;
				 var ext_logic=insertRows[0].ext_logic;
				 
				 var data="department_name="+department_name+"&action_id="+${step.action_id}+"&step_id="+${step.step_id};
				     data+="&flow_id="+${step.flow_id }+"&ext_logic="+ext_logic;
				 $.ajax({
				     type: 'POST',
				     url: '${basePath}api/step_dep/save',
				    data: data ,
				    async : false, //默认为true 异步  
				    success:function(data){ 
				    	$('#addStepMenu').linkbutton('enable');
				    	$('#saveStepMenu').linkbutton('disable');
				        //alert(data);   
				    	$('#dgdep').datagrid('reload');
				    },
				    error:function(){     
				        alert('error');     
				     }
				    
				});
 				
				//alert(JSON.stringify(changesRows));
			 }
			 
			 
			 function deleteStepDepEntity()
				{
					var row = $('#dgdep').datagrid('getSelected');
					if (row){
						 $.messager.confirm('确定','确定要删除吗 ?',function(r){
							 if (r){
			                        $.post(basePath+'api/step_dep/remove',{entity_id:row.entity_id},function(result){
			                        	//var jsonobj= eval('('+result+')');  
			                        	//alert(result);
			        			    	if(result.state==1){
			                                //$('#dg1').datagrid('reload');    // reload the user data
			                                $('#dgdep').datagrid('reload');
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
			 
			 
			
			</script>