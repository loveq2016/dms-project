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
						<restrict:function funId="31">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>
						</restrict:function>			   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg"  title="查询结果" style="height: 330px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="center" sortable="true">经销商名称</th>
							<th field="dealer_code" width="200" align="center" sortable="true">经销商代码</th>
							<th field="create_date" width="150" align="center" sortable="true">创建时间</th>
							<restrict:function funId="32">
								<th field="authList" width="200" align="center" sortable="true" formatter="formatterAuth">授权列表</th>
							</restrict:function>
						</tr>
					</thead>
				</table>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>

    

	<script type="text/javascript">
	
	 	var url;

		$(function() {
			
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//alert(11)
			//pager.pagination(); 
		});
		
		

		 function formatterAuth (value, row, index) { 
			 	//v = "'"+row.dealer_id +"','" + row.dealer_name +"'";
			 	//return '<a class="authListBtn" href="javascript:void(0)"  onclick="openDialog(' + v + ');" ></a>';
			 	return '<a class="authListBtn" href="javascript:void(0)"  onclick="parent.addTab(\'['+row.dealer_name+']授权信息维护\',\''+basePath+'web/dealer/authView?dealer='+row.dealer_id+'\');" ></a>';
			 	
		} 
		 
		$('#dg').datagrid({
			  url : basePath +"api/dealer/paging" ,
			  onLoadSuccess:function(data){ 
				  $(".authListBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			  }
		});
		


		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val(),
		    	
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>