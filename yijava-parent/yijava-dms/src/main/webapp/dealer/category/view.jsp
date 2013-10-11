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
									<td>经销商代码:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_code" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="46">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>	
						</restrict:function>		   
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg"  title="查询结果" style="height: 510px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="center" sortable="true">经销商</th>
							<th field="dealer_code" width="200" align="center" sortable="true">经销商代码</th>
							<th field="category_name" width="200" align="center" sortable="true">经销商类型</th>
						</tr>
					</thead>
				</table>
				<div id="tb">     
					<restrict:function funId="47">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>   
					</restrict:function>    
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:500px;height:380px;padding:10px 20px"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate enctype="multipart/form-data">
        	<input type="hidden" name="dealer_id">
             <table>
             	<tr>
             		<td>经销商:</td>
             		<td><input name="dealer_name" style="width:200px" class="easyui-validatebox" required="true" disabled="disabled"></td>
             	</tr>
              	<tr>
             		<td>经销商代码:</td>
             		<td><input name="dealer_code" style="width:200px" class="easyui-validatebox" required="true" disabled="disabled"></td>
             	</tr>            	
             	<tr>
             		<td>经销商类型:</td>
             		<td>
             		<input class="easyui-combobox" name="category_id" 
             			data-options="
	             			url:'${basePath}/api/dealerCategory/list',
		                    method:'get',
		                    valueField:'id',
		                    textField:'category_name',
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
			url : basePath + "api/dealerCategoryFun/paging"
		});



	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','经销商分类信息更新');
	            $('#fm').form('load',row);
	            url = basePath + 'api/dealerCategoryFun/update';
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
			    	if(jsonobj.state==1)
			    		{
						 $('#dlg').dialog('close');     
	                     $('#dg').datagrid('reload');
			    		}
			    }		
			});	
		}
		  
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val()
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>