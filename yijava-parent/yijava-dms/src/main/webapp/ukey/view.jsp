<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/common/head.jsp"%>
<script type="text/javascript" src="${resPath}resource/js/auth.js"></script>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<embed id="s_simnew31"  type="application/npsyunew3-plugin" hidden="true"> </embed>
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
										<%-- <input class="easyui-combobox" name="qqdealer_id" id="qqdealer_id" style="width:260px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}/api/dealer/list',
									                    method:'get',
									                    valueField:'dealer_id',
									                    textField:'dealer_name',
									                    panelHeight:'auto'
							            			"/> --%>
							            <input class="easyui-combobox" name="qqdealer_id" id="qqdealer_id" style="width:260px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}api/sysuser/list',
									                    method:'get',
									                    valueField:'id',
									                    textField:'account',
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

				<table id="dg" title="查询结果" style="height: 330px" url="${basePath}api/ukey/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'key_id',width:100"  sortable="true" >U盾编号</th>
							<th data-options="field:'factory_code',width:300"  sortable="true">出厂 编码</th>
							<th data-options="field:'version',width:50" sortable="true">版本号</th>
							<th data-options="field:'exversion',width:80" sortable="true" >扩展版本号</th>
							<th data-options="field:'userId',width:80" sortable="userId" >用户编号</th>
							<th data-options="field:'account',width:150" sortable="account" >用户名</th>
							<th data-options="field:'realname',width:200" sortable="realname" >真实名称</th>
							<th data-options="field:'create_date',width:200" formatter="formatterdate">创建日期</th>							
							<!-- <th data-options="field:'dd',width:100" align="center" formatter="formatterInfo">配置经销商</th> -->
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		

		
	<div id="w" class="easyui-window" title="增加U盾,清保证插入U盾" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:650px;height:400px;padding:10px;">
		<form id="ffadd" action="" method="post" enctype="multipart/form-data">
							<table>
								<tr height="30">
									<td>状态信息:</td>
									<td><div id="keymsginfo"></div></td>								
								</tr>
								
								
								<tr height="30">
									<td>出厂 编码:</td>
									<td><input class="easyui-validatebox" readonly="true" style="width:260px;" type="text" id="factory_code" name="factory_code" data-options="required:true"></input></td>								
								</tr>
								<tr height="30">
									<td>版本号:</td>
									<td>
									<input class="easyui-validatebox" readonly="true" style="width:260px;" type="text" id="version" name="version" data-options="required:true"></input>
									</td>								
								</tr>
								<tr height="30">
									<td>扩展版本号:</td>
									<td><input class="easyui-validatebox" readonly="true" style="width:260px;" type="text" id="exversion" name="exversion" data-options="required:true"></input></td>								
								</tr>
								<tr height="30">
									<td>用户:</td>
								<td><input class="easyui-combobox" name="userId" id="userId" style="width:260px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}api/sysuser/list',
									                    method:'get',
									                    valueField:'id',
									                    textField:'account',
									                    panelHeight:'auto'
							            			"/>
							            			</td>	
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
			 return '<span style="color:red" onclick="openview(' + row.flow_id + ');">配置经销商 </span>'; 
		} 
		
		 function formatterSystem (value, row, index) { 
			 if(value==1)
				 return "是";
			 else
				 return "否";
			
		}
		
	   
	


    
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
			
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_id:$('#ffquery input[name=qqdealer_id]').val(),		    	
		    });
		}
		
		function newEntity()
		{
			 $('#ffadd').form('clear');
	         url = basePath+'api/ukey/save';
			$('#w').window('open');
			LoadKey();
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
			    			//写入u盾
			    			var ret=WriteKey(jsonobj.data);
			    			if(ret)
			    				{
				    				$.messager.show({
		                                 title: '提示',
		                                 msg: "添加成功!"
		                             });
			    				}
			    			clearForm();
			    			$('#w').window('close');
			    			var pager = $('#dg').datagrid().datagrid('getPager');
			    			pager.pagination('select');	
				   			
			    		}else {
                            $.messager.show({    // show error message
                                title: 'Error',
                                msg: jsonobj.error.msg
                            });
                        } 
			    }		
			});			
		}		
		
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
				 $.messager.confirm('确定','确定要删除吗 ?',function(r){
					 if (r){
	                        $.post(basePath+'api/ukey/remove',{key_id:row.key_id},function(result){
	                        
	        			    	if(result.state==1){
	                                $('#dg').datagrid('reload');    // reload the user data
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
		

		function clearForm(){
			$('#ffadd').form('clear');
		}
		
		function checkKey(){
			
		}
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>