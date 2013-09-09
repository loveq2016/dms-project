<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/common/head.jsp"%>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<div class="easyui-panel" title="查询条件">
					<div style="padding: 10px 0 0 60px">
						<form id="ffquery" method="post">
							<table>
								<tr>
									<td width="100">开始时间:</td>
									<td width="270">
										<input id="start_date" class="easyui-datebox" required></input>
									</td>
									<td width="100">结束时间:</td>
									<td width="270">
										 <input id="end_date" class="easyui-datebox" required></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:330px" url="${basePath}api/syslog/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="timestmp" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'formatted_message',width:180,align:'center'" sortable="true">操作名</th>
							<th data-options="field:'account',width:150,align:'center'" sortable="true">账户</th>
							<th data-options="field:'level_string',width:100,align:'center'" sortable="true">日志级别</th>
							<th data-options="field:'hostname',width:150,align:'center'" sortable="true">主机名</th>
							<th data-options="field:'operatorip',width:150,align:'center'" sortable="true">操作IP</th>
							<th data-options="field:'timestmp',width:180,align:'center'" sortable="true">时间</th>
						</tr>
					</thead>
				</table>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
	<script type="text/javascript">
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination();
		});
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_start_date: $('#start_date').val(),
		    	filter_ANDS_end_date: $('#end_date').val()
		    });
		}
	</script>
</body>
</html>
