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
										<c:choose>
										       <c:when test="${user.fk_dealer_id!='0'}">
													<input class="easyui-validatebox" disabled="disabled" id="dealer_name" value="${user.dealer_name}" style="width:200px" maxLength="100">
													<input class="easyui-validatebox" type="hidden" name="dealer_id" id="dealer_id" value="${user.fk_dealer_id}" style="width:200px" maxLength="100">					       	
										       </c:when>
										       <c:otherwise>
										       		<input class="easyui-combobox" name="dealer_id" id="dealer_id" style="width:200px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}api/userDealerFun/list?t_id=${user.teams}&u_id=${user.id}',
									                    method:'get',
									                    valueField:'dealer_id',
									                    textField:'dealer_name',
									                    panelHeight:'auto'
							            			"/>
										       </c:otherwise>
										</c:choose>
									</td>
									<td></td>
									<td>经销商代码:</td>
									<td>
										<input class="easyui-validatebox" type="text" style="width:300px" name="dealer_code" id="dealer_code" data-options="required:false"></input>
									</td>
								</tr>
								<tr>
									<td>发货开始时间:</td>
									<td><input name="start_date" id="start_date" class="easyui-datebox"></input></td>
									<td></td>
									<td>发货结束时间:</td>
									<td> <input name="end_date" id="end_date" class="easyui-datebox"></input></td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="228">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>		
						</restrict:function>	   
					</div>
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">

				<table id="dg" title="查询结果" style="height: 370px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="deliver_code" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="type" width="80" align="left" sortable="true">订单类型</th>
							<th field="express_date" width="100" align="left" sortable="true">发货日期</th>
							<th field="deliver_sum" width="100" align="left" sortable="true">发货数量</th>
							<th field="deliver_code" width="150" align="left" sortable="true">代码</th>
							<th field="deliver_remark" width="80" align="left" sortable="true">备注</th>
							<th field="dealer_name" width="150" align="left" sortable="true">代理商名称</th>
							<th field="dealer_code" width="80" align="left" sortable="true">代理商代码</th>
							<th field="attribute" width="80" align="left" sortable="true">区域</th>
							<th field="models" width="80" align="left" sortable="true">型号</th>
							<th field="express_sn" width="80" align="left" sortable="true">批号</th>
							<th field="validity_date" width="80" align="left" sortable="true">效期</th>
							<th field="product_sn" width="80" align="left" sortable="true">序列号</th>
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="235">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="repostExcel();">导出</a> 
					</restrict:function>   
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
	<script type="text/javascript">

	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/repostExpress/paging"
		});

		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_id: $('input[name=dealer_id]').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val(),
		    	filter_ANDS_start_date: $('input[name=start_date]').val(),
		    	filter_ANDS_end_date: $('input[name=end_date]').val()
		    });
		}
		
		 function repostExcel(){
	    		var tabTitle = "发货信息报表导出";
	    		addTabByChild(tabTitle,"report/ok.jsp");
				var url = "api/repostExpress/down";			
				var form=$("<form>");//定义一个form表单
				form.attr("style","display:none");
				form.attr("target","");
				form.attr("method","post");
				form.attr("action",basePath+url);
				form.attr("enctype","multipart/form-data");
				var input1=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_id\" value="+$('input[name=dealer_id]').val()+">");
				var input2=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_code\" value="+$('#dealer_code').val()+">");
				var input3=$("<input type=\"hidden\" name=\"filter_ANDS_start_date\" value="+$('input[name=start_date]').val()+">");
				var input4=$("<input type=\"hidden\" name=\"filter_ANDS_end_date\" value="+$('input[name=end_date]').val()+">");
				$("body").append(form);//将表单放置在web中
				form.append(input1);
				form.append(input2);
				form.append(input3);
				form.append(input4);
				form.submit();//表单提交
			 }
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>