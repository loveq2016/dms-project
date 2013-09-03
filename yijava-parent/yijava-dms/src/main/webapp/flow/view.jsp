<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"	href="../resource/themes/gray/easyui.css">
<link rel="stylesheet" type="text/css"	href="../resource/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../resource/css/main.css">
<script type="text/javascript" src="../resource/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="../resource/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../resource/js/common.js"></script>
<script type="text/javascript" src="../resource/locale/easyui-lang-zh_CN.js"></script>
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

				<table id="dg" title="查询结果" style="height: 330px" url="/yijava-dms/api/flow/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th field="flow_id" width="150" sortable="true" hidden="true">id</th>
							<th field="flow_name" width="150" sortable="true">流程名称</th>
							<th data-options="field:'flow_desc',width:300" sortable="true">流程描述</th>
							<th data-options="field:'is_system',width:100" sortable="true" formatter="formatterSystem">是否系统流程</th>
							<th data-options="field:'add_date',width:200">创建日期</th>							
							<th field="info" width="100" align="center" formatter="formatterInfo">查看详细流程</th>
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		

		
	<div id="w" class="easyui-window" title="流程详细信息" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
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
	
	<div id="test" title="ddd" style="top:10px;padding:1px;width:780px;height:590px;display:none;" title="Modal Window">
    </div>

	<script type="text/javascript">
	
	 	var url;	 
		$('#dg').datagrid({
		    toolbar : [{
		        text:'添加',
		        iconCls:'icon-add',
		        handler:function(){
		        	$('#w').window('open');
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
	               collapsed:false,
	               closable:false,
	               minimizable:false,
	               maximizable:false,
	               zIndex:9999,
	               collapsible:false
	              });
	    	 $('#test').load('/yijava-dms/flow/viewdetail.jsp'); 
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
	         url = '/yijava-dms/api/flow/save';
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
			    url = '/yijava-dms/api/flow/update?flow_id='+row.flow_id;
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
	                        $.post('/yijava-dms/api/flow/remove',{flow_id:row.flow_id},function(result){
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