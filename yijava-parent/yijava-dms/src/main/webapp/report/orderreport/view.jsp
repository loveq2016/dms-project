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
									<td>订单号:</td>	
									<td><input class="easyui-validatebox" style="width:160px" type="text" name="order_code"></input></td>
									<td>经销商名称:</td>
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
									<td>经销商代码:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_code" id="dealer_code" data-options="required:false"></input>
									</td>
									<td>区域:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="attribute" id="attribute" data-options="required:false"></input>
									</td>
							</tr>
							<tr>
									<td>型号:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="models" id="models" data-options="required:false"></input>
									</td>
									<td width="100">开始订单时间:</td>
									<td width="270">
										<input name="start_order_date" id="start_order_date" class="easyui-datebox"></input>
									</td>
									<td width="100">结束订单时间:</td>
									<td width="270">
										 <input name="end_order_date" id="end_order_date" class="easyui-datebox"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="237">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height: 370px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="180" align="left" sortable="true">代理商名称</th>
							<th field="dealer_code" width="80" align="left" sortable="true">代理商代码</th>
							<th field="attribute" width="50" align="left" sortable="true">区域</th>	
							<th field="order_code" width="80" align="left" sortable="true">订单号</th>
							<th field="type" width="180" align="left" sortable="true">订单类型</th>
							<th field="order_date" width="100" align="left" sortable="true">订单日期</th>
							<th field="models" width="80" align="left" sortable="true">型号</th>
							<th field="order_number_sum" width="50" align="left" sortable="true">订单数量</th>
							<th field="order_money_sum" width="50" align="left" sortable="true">金额</th>
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="238">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="repostExcel();">导出</a>   
					</restrict:function> 
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
	<script type="text/javascript">
	 	var url;
	 	var pagesize='13';
	 	loadProvinceforqu();
		function loadProvinceforqu(){
			var quprovince =  $('#quprovince').combobox({
					valueField:'areaid',
					textField:'name',
					editable:false,
					url:basePath +'api/area/getarea_api?pid=0',
					onChange:function(newValue, oldValue){
						$.get(basePath +'api/area/getarea_api',{pid:newValue},function(data){
							quarea.combobox("clear").combobox('loadData',data);
							qucity.combobox("clear");
						},'json');
					},
					onLoadSuccess:onLoadSuccess
				});
			
			var quarea  = $('#quarea').combobox({
				valueField:'areaid',
				textField:'name',
				editable:false,
				onChange:function(newValue, oldValue){
					if(newValue!=0){
						$.get(basePath +'api/area/getarea_api',{pid:newValue},function(data){
							qucity.combobox("clear");
							qucity.combobox("clear").combobox('loadData',data);
						},'json');
					}
				},
				onLoadSuccess:onLoadSuccess
			});
			
			var qucity = $('#qucity').combobox({
				valueField:'areaid',
				textField:'name',
				editable:false,
				onLoadSuccess:onLoadSuccess
			});				
		}

		function loadProvince(){
			var provinces =  $('#provinces').combobox({
				valueField:'areaid',
				textField:'name',
				editable:false,
				url:basePath +'api/area/getarea_api?pid=0',
				onChange:function(newValue, oldValue){
					$.get(basePath +'api/area/getarea_api',{pid:newValue},function(data){
						$('#city').combobox("clear").combobox('loadData',data);
						$('#area').combobox("clear");
					},'json');
				},
				onLoadSuccess:onLoadSuccess
			});
		
		var city = $('#city').combobox({
			valueField:'areaid',
			textField:'name',
			editable:false,
			onChange:function(newValue, oldValue){
				if(newValue!=0){
					$.get(basePath +'api/area/getarea_api',{pid:newValue},function(data){
						$('#area').combobox("clear");
						$('#area').combobox("clear").combobox('loadData',data);
					},'json');
				}
			},
			onLoadSuccess:onLoadSuccess
		});
		var area = $('#area').combobox({
			valueField:'areaid',
			textField:'name',
			editable:false,
			onLoadSuccess:onLoadSuccess
		});	
		}
		function onLoadSuccess(){
			var target = $(this);
			var data = target.combobox("getData");
			var options = target.combobox("options");
			if(data && data.length>0){
				var fs = data[0];
				target.combobox("setValue",fs[options.valueField]);
			}
		}
		$('#dg').datagrid({
			 url : basePath + "api/orderreport/paging",
			 queryParams: {
					name: 'pageSize',
					subject: pagesize
			 },
			 pageSize:pagesize,
			 pageList: [13, 20, 30], 
			 onLoadSuccess:function(data){ 
				  $(".questionBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			 }
		});
		 function repostExcel(){
    		var tabTitle = "订单报表导出";
    		addTabByChild(tabTitle,"report/ok.jsp");
			var url = "api/orderreport/down";			
			var form=$("<form>");//定义一个form表单
			form.attr("style","display:none");
			form.attr("target","");
			form.attr("method","post");
			form.attr("action",basePath+url);
			form.attr("enctype","multipart/form-data");
			var input0=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_id\" value="+$('#ffquery input[name=dealer_id]').val()+">");
			var input1=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_code\" value="+$('#ffquery input[name=dealer_code]').val()+">");
			var input2=$("<input type=\"hidden\" name=\"filter_ANDS_attribute\" value="+$('#ffquery input[name=attribute]').val()+">");
			var input3=$("<input type=\"hidden\" name=\"filter_ANDS_start_order_date\" value="+$('#ffquery input[name=start_order_date]').val()+">");
			var input4=$("<input type=\"hidden\" name=\"filter_ANDS_end_order_date\" value="+$('#ffquery input[name=end_order_date]').val()+">");
			var input5=$("<input type=\"hidden\" name=\"filter_ANDS_models\" value="+$('#ffquery input[name=models]').val()+">");
			var input6=$("<input type=\"hidden\" name=\"filter_ANDS_order_code\" value="+$('#ffquery input[name=order_code]').val()+">");
			$("body").append(form);//将表单放置在web中
			form.append(input0);
			form.append(input1);
			form.append(input2);
			form.append(input3);
			form.append(input4);
			form.append(input5);
			form.append(input6);
			form.submit();//表单提交
		 }
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_order_code:  $('#ffquery input[name=order_code]').val(),
		    	filter_ANDS_dealer_id: $('#ffquery input[name=dealer_id]').val(),
		    	filter_ANDS_dealer_code:  $('#ffquery input[name=dealer_code]').val(),
		    	filter_ANDS_attribute:  $('#ffquery input[name=attribute]').val(),
		    	filter_ANDS_start_order_date: $('#ffquery input[name=start_order_date]').val(),
		    	filter_ANDS_end_order_date: $('#ffquery input[name=end_order_date]').val(),
		    	filter_ANDS_models:  $('#ffquery input[name=models]').val()
		    });
		}
	</script>
</body>
</html>