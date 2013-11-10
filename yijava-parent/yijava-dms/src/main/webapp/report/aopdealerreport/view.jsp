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
									<td></td>
									<td>年度:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="year" id="year" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="52">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>	
						</restrict:function>		   
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" class="easyui-datagrid" title="查询结果" style="height: 510px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="100" align="center" sortable="true">经销商</th>
							<th field="dealer_code" width="100" align="center" sortable="true">经销商代码</th>
							<th field="year" width="100" align="center" sortable="true">年度</th>
							<th field="january" width="100" align="center" sortable="true">一月份</th>
							<th field="february" width="100" align="center" sortable="true">二月份</th>
							<th field="march" width="100" align="center" sortable="true">三月份</th>
							<th field="april" width="100" align="center" sortable="true">四月份</th>
							<th field="may" width="100" align="center" sortable="true">五月份</th>
							<th field="june" width="100" align="center" sortable="true">六月份</th>
							<th field="july" width="100" align="center" sortable="true">七月份</th>
							<th field="august" width="100" align="center" sortable="true">八月份</th>
							<th field="september" width="100" align="center" sortable="true">九月份</th>
							<th field="october" width="100" align="center" sortable="true">十月份</th>
							<th field="november" width="100" align="center" sortable="true">十一月份</th>
							<th field="december" width="100" align="center" sortable="true">十二月份</th>
						</tr>
					</thead>
				</table>
				<div id="tb">  
				<restrict:function funId="224">  
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="repostExcel();">导出</a>
				</restrict:function>
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
	<script type="text/javascript">
	 	var url;

		$('#dg').datagrid({
			  url : basePath +"api/dealerPlan/paging" 
		});

		  
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val(),
		    	filter_ANDS_year: $('#year').val()
		    });
		}
		
		 function repostExcel(){
	    		var tabTitle = "经销商指标设定报表导出";
	    		addTabByChild(tabTitle,"report/ok.jsp");
				var url = "api/aopdealerreport/down";			
				var form=$("<form>");//定义一个form表单
				form.attr("style","display:none");
				form.attr("target","");
				form.attr("method","post");
				form.attr("action",basePath+url);
				form.attr("enctype","multipart/form-data");		    	
				var input0=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_name\" value="+$('#dealer_name').val()+">");
				var input1=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_code\" value="+$('#dealer_code').val()+">");
				var input2=$("<input type=\"hidden\" name=\"filter_ANDS_year\" value="+$('#year').val()+">");
				$("body").append(form);//将表单放置在web中
				form.append(input0);
				form.append(input1);
				form.append(input2);
				form.submit();//表单提交
			 }
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>