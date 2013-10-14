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
									<td>流程名称:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="flow_name" id="flow_name" data-options="required:false"></input>
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

				<table id="dg" title="查询结果" style="height: 330px" url="${basePath}api/flow/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'flow_id',width:100"  sortable="true" >流程编号</th>
							<th data-options="field:'flow_name',width:300"  sortable="true">流程名称</th>
							<th data-options="field:'flow_desc',width:300" sortable="true">流程描述</th>
							<th data-options="field:'is_system',width:100" sortable="true" formatter="formatterSystem">是否系统流程</th>
							<th data-options="field:'add_date',width:200" formatter="formatterdate">创建日期</th>							
							<th data-options="field:'dd',width:100" align="center" formatter="formatterInfo">查看详细流程</th>
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		

		
	<div id="w" class="easyui-window" title="增加流程" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:650px;height:400px;padding:10px;">
		<form id="ffadd" action="" method="post" enctype="multipart/form-data">
							<table>
								<tr>
									<td>流程名称:</td>
									<td><input class="easyui-validatebox" style="width:260px;" type="text" name="flow_name" data-options="required:true"></input></td>								
								</tr>
								<tr>
									<td>流程描述:</td>
									<td>
									<textarea name="flow_desc" style="height:60px;width:260px;"></textarea>
									</td>								
								</tr>
								<tr>
									<td>是否系统流程:</td>
									<td><input class="easyui-validatebox" type="checkbox" name="is_system" value="1" data-options="required:true"></input></td>								
								</tr>
								<tr>
									<td>排序:</td>
									<td><input class="easyui-validatebox" type="text" name="order_no" data-options="required:true"></input></td>								
								</tr>
							</table>
		</form>
		
		<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
		</div>
	</div>
	
	<div id="test" title="流程设计" style="top:10px;padding:1px;width:780px;height:590px;" title="Modal Window">
	<!-- <div id="test" class="easyui-window" data-options="closed:true,modal:true,title:'Test Window'" style="width:300px;height:100px;"> -->
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
		    },'-',{
		        text:'删除',
		        iconCls:'icon-remove',
		        handler:function(){
		        	deleteEntity();
		        }
		    }]
		});
		

		
		 function formatterInfo (value, row, index) { 
			 return '<span style="color:red" onclick="openview(' + row.flow_id + ');">查看详细流程 </span>'; 
		} 
		
		 function formatterSystem (value, row, index) { 
			 if(value==1)
				 return "是";
			 else
				 return "否";
			
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
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_flow_name: $('#flow_name').val()
		    });
		}
		
		function newEntity()
		{
			 $('#ffadd').form('clear');
	         url = basePath+'api/flow/save';
			$('#w').window('open');
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
			    			$('#w').window('close');
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
			    url = basePath+'api/flow/update?flow_id='+row.flow_id;
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
	                        $.post(basePath+'api/flow/remove',{flow_id:row.flow_id},function(result){
	                        	var jsonobj= eval('('+msg+')');  
	        			    	if(jsonobj.state==1){
	                                $('#dg').datagrid('reload');    // reload the user data
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
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>