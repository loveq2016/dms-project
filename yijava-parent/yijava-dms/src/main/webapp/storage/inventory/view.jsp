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
									<td><input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input></td>
									<td></td>
									<td>仓库:</td>
									<td><input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input></td>
								</tr>
								<tr>
									<td>Item Number:</td>
									<td><input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input></td>
									<td></td>
									<td>批号/序列号:</td>
									<td><input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input></td>
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
				<table id="dg"  title="查询结果" style="height: 330px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="100" align="center" sortable="true">经销商</th>
							<th field="storage_name" width="120" align="center" sortable="true">仓库</th>
							<th field="product_item_number" width="120" align="center" sortable="true">Item Number</th>
							<th field="product_cname" width="120" align="center" sortable="true">产品中文名称</th>
							<th field="batch_no" width="100" align="center" sortable="true">批号/序列号</th>
							<th field="valid_date" width="100" align="center" sortable="true">有效期</th>
							<th field="inventory_number" width="100" align="center" sortable="true">产品数量（EA）</th>
						</tr>
					</thead>
				</table>
				<div id="tb">     
<!-- 				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>        -->
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
		
		
	
	

	<script type="text/javascript">
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/storageDetail/paging"
		});
	
		  
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