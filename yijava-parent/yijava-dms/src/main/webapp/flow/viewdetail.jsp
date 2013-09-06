<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>	
	<link rel="stylesheet" type="text/css"	href="${resPath}resource/themes/gray/easyui.css">
<link rel="stylesheet" type="text/css"	href="${resPath}resource/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${resPath}resource/css/main.css">
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
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			   
					</div>
				</div>
				
				<div style="margin: 10px 0;"></div>

				<div style="padding-left: 10px; padding-right: 10px">
	
					<table id="dg1" title="查询结果" style="height: 330px" url="${basePath}api/flow/paging" method="get"
						rownumbers="true" singleSelect="true" pagination="false" sortName="item_number" sortOrder="asc">
						
						
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
				
			</div>


			<div style="margin: 10px 0;"></div>

			<script language="javascript">
			$(function() {
				var pager = $('#dg1').datagrid(); // get the pager of datagrid
				
				alert("eee");
				
			}); 
			</script>