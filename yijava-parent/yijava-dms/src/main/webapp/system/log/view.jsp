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
										<input name="start_date" id="start_date" class="easyui-datebox"></input>
									</td>
									<td width="100">结束时间:</td>
									<td width="270">
										 <input name="end_date" id="end_date" class="easyui-datebox"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="15">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearch()">查询</a>
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height:330px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="timestmp" pagination="true" iconCls="icon-search" sortOrder="asc" toolbar="#tb">
					<thead>
						<tr>
							<th data-options="field:'formatted_message',width:180,align:'center'" sortable="true">操作名</th>
							<th data-options="field:'account',width:150,align:'center'" sortable="true">账户</th>
							<th data-options="field:'level_string',width:100,align:'center'" sortable="true">日志级别</th>
							<th data-options="field:'hostname',width:150,align:'center'" sortable="true">主机名</th>
							<th data-options="field:'operatorip',width:150,align:'center'" sortable="true">操作IP</th>
							<th data-options="field:'timestmp',width:180,align:'center'" formatter="formatterDate" sortable="true">时间</th>
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
			$('#dg').datagrid({url : basePath +"api/syslog/paging"});
		    $('#dg').datagrid('load',{
		    	filter_ANDS_start_date: $('input[name=start_date]').val(),
		    	filter_ANDS_end_date: $('input[name=end_date]').val()
		    });
		}
		function formatterDate(value){
			var date=new Date();
			date.setTime(value);
			return '<span style="cursor:pointer;">'+date.format('yyyy-MM-dd HH:mm:ss')+'</span>'; 
		}
	</script>
</body>
</html>
