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
									<td>医院名称:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="hospital_name" id="hospital_name" data-options="required:false"></input>
									</td>
									<td>医院等级:</td>
									<td>
										<input class="easyui-combobox" name="level_id"  id="level_id"  style="width:150px" maxLength="100" class="easyui-validatebox" required="true"
							             			data-options="
								             			url:'${basePath}/api/hospitalLevel/list',
									                    method:'get',
									                    valueField:'id',
									                    textField:'level_name',
									                    panelHeight:'auto',
									                    required:false
							            			">
							            			
									</td>
								</tr>
								<tr>
									<td>省份:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="provinces" id="hospital_name" data-options="required:false"></input>
									</td>
									<td>地区:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="area" id="area" data-options="required:false"></input>
									</td>
									<td>县市(区):</td>
									<td>
										<input class="easyui-validatebox" type="text" name="city" id="city" data-options="required:false"></input>
									</td>
								</tr>								
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="16">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height: 330px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="hospital_name" width="150" align="center" sortable="true">医院名称</th>
							<th field="hostpital_category" width="200" align="center" sortable="true">客户分类</th>
							<th field="level_name" width="200" align="center" sortable="true">等级</th>
							<th field="provinces" width="200" align="center" sortable="true">省份</th>
							<th field="area" width="200" align="center" sortable="true">地区</th>
							<th field="city" width="200" align="center" sortable="true">县市(区)</th>
							<th field="address" width="200" align="center" sortable="true">地址</th>
							<th field="postcode" width="200" align="center" sortable="true">邮编</th>
							<th field="phone" width="200" align="center" sortable="true">电话</th>
							<th field="beds" width="200" align="center" sortable="true">床位数</th>
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="17">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a>   
					</restrict:function> 
					<restrict:function funId="18">
				    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>  
				    </restrict:function>   
				    <restrict:function funId="19">
				    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a>    
				    </restrict:function>
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
	   <div id="dlg" class="easyui-dialog" style="width:460px;height:460px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlg-buttons">
		        <form id="fm" method="post" novalidate enctype="multipart/form-data">
		        	<input type="hidden" name="id">
					         	  <table>
					             	<tr>
					             		<td>医院名称:</td>
										<td><input name="hospital_name" style="width:150px" maxLength="50" class="easyui-validatebox"  required="true"></td>
					             	</tr>       
					             	<tr>
					             		<td>客户分类:</td>
										<td><input name="hostpital_category" style="width:150px" maxLength="20" class="easyui-validatebox" ></td>
					             	</tr>      	
					             	<tr>
					             		<td>等级:</td>
					             		<td>
					             		      <input class="easyui-combobox" name="level_id"  style="width:150px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}/api/hospitalLevel/list',
									                    method:'get',
									                    valueField:'id',
									                    textField:'level_name',
									                    panelHeight:'auto',
							            			">			             		
					             		</td>
					             	</tr>
					             	<tr>
					             		<td>省份:</td>
										<td><input name="provinces" style="width:150px" maxLength="50" class="easyui-validatebox" ></td>
					             	</tr>   
					             	<tr>
					             		<td>地区:</td>
										<td><input name="area" style="width:150px" maxLength="20" class="easyui-validatebox" ></td>
					             	</tr>   
					             	<tr>
					             		<td>县市（区）:</td>
										<td><input name="city" style="width:150px" maxLength="20" class="easyui-validatebox" ></td>
					             	</tr>   
					             	<tr>
					             		<td>地址:</td>
										<td><input name="address" style="width:200px" maxLength="100" class="easyui-validatebox" ></td>
					             	</tr>   
					             	<tr>
					             		<td>邮编:</td>
										<td><input name="postcode" style="width:150px" maxLength="10" class="easyui-validatebox" ></td>
					             	</tr>   					             	
					             	<tr>
					             		<td>电话:</td>
										<td><input name="phone" style="width:150px" maxLength="20" class="easyui-validatebox" ></td>
					             	</tr>   					             	
					             	<tr>
					             		<td>床位数:</td>
										<td><input name="beds" style="width:150px" maxLength="10" class="easyui-numberbox"  data-options="min:0"></td>
					             	</tr>   					             	
					             	
					             	
					             	
					             	</table>        	
		        </form>
	    </div>
	    <div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
	    </div>


    
	<script type="text/javascript">
	
	 	var url;

		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
		});

		$('#dg').datagrid({
			 url : basePath + "api/hospital/paging",
		});

		 function newEntity(){
			 $('#dlg').dialog('open').dialog('setTitle','医院信息添加');
			 url = basePath + 'api/hospital/save';
			 $('#fm').form('clear');
			 saveEntity();
		  } 


	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	        	$('#fm').form('clear');
	            $('#dlg').dialog('open').dialog('setTitle','医院信息更新');
	            $('#fm').form('load',row);
	            url = basePath + 'api/hospital/update';
	          }else{
					$.messager.alert('提示','请选中数据!','warning');				
			 }	
	     }
	     
			
		
		function saveEntity() {
			$('#fm').form('submit', {
			    url:url,
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');;
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
						 $('#dlg').dialog('close');     
	                     $('#dg').datagrid('reload');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});	
		}
		
		 function deleteEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/hospital/delete',
	            				data : {id:row.id},
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
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
	        }
		  
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_hospital_name: $('#hospital_name').val(),
		    	filter_ANDS_level_id: $('#level_id').combobox('getValue'),
		    	filter_ANDS_provinces: $('#provinces').val(),
		    	filter_ANDS_area: $('#area').val(),
		    	filter_ANDS_city: $('#city').val()
		    });
		}
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>