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
									<td>经销商:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input>
									</td>
									<td></td>
									<td>仓库名称:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="storage_name" id="storage_name" data-options="required:false"></input>
									</td>
									<td></td>
									<td>地址:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="address" id="address" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="98">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>
						</restrict:function>			   
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" class="easyui-datagrid" title="查询结果" style="height: 500px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="200" align="left" sortable="true">经销商</th>
							<th field="storage_name" width="200" align="left" sortable="true">仓库名称</th>
							<th field="province" width="100" align="left" sortable="true">省份</th>
							<th field="city" width="100" align="left" sortable="true">城市</th>
							<th field="category_name" width="100" align="left" sortable="true">仓库类型</th>
							<th field="postcode" width="100" align="left" sortable="true">邮编</th>
							<th field="address" width="200" align="left" sortable="true">地址</th>
							<th field="area" width="200" align="left" sortable="true">区或乡</th>
							<th field="phone" width="100" align="left" sortable="true">电话</th>
							<th field="tex" width="100" align="left" sortable="true">邮编</th>
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="99">
				    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a></restrict:function>    
				   <restrict:function funId="100">
				    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a></restrict:function> 
				    <restrict:function funId="101">
				    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a></restrict:function>    
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:360px;height:260px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons" enctype="multipart/form-data">
	        <form id="fm" method="post" novalidate enctype="multipart/form-data">
	        	<input type="hidden" name="id">
				         	  <table>
				             	<tr>
				             		<td>经销商:</td>
				             		<td>
				             		      <input class="easyui-combobox" name="dealer_id"  style="width:150px" maxLength="100" class="easyui-validatebox" required="true"
						             			data-options="
							             			url:'${basePath}/api/dealer/list',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto'
						            			">
				             		</td>
				             	</tr>          	
				             	<tr>
				             		<td>仓库名称:</td>
				             		<td>
				             		      <input class="easyui-combobox" name="storage_id"  style="width:150px" maxLength="100" class="easyui-validatebox" required="true"
						             			data-options="
							             			url:'${basePath}/api/storage/list',
								                    method:'get',
								                    valueField:'id',
								                    textField:'storage_name',
								                    panelHeight:'auto'
						            			">			             		
				             		</td>
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

		$('#dg').datagrid({
			  url : basePath +"api/dealerStorage/paging" 
		});
		
	
		 function newEntity(){
		        $('#dlg').dialog('open').dialog('setTitle','经销商仓库添加');
		        $('#fm').form('clear');
		        url = basePath +  'api/dealerStorage/save';
			 } 
		 
		 

	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','经销商仓库更新');
	            $('#fm').form('load',row);
	            url = basePath + 'api/dealerStorage/update';
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
			    	}else if(jsonobj.state==2){
			    		$.messager.alert('提示','经销商仓库重复!','warning');		
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
	            				url : basePath + 'api/dealerStorage/delete',
	            				data : {id:row.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dg').datagrid('reload');
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
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_storage_name: $('#storage_name').val(),
		    	filter_ANDS_address: $('#address').val()
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>