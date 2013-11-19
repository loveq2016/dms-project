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
									<td>型号:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="models" id="models" data-options="required:false"></input>
									</td>
							</tr>
							<tr>
									<td>批号:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="batch_no" id="batch_no" data-options="required:false"></input>
									</td>
									
									<td>序列号:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="product_sn" id="product_sn" data-options="required:false"></input>
									</td>
									
									<td>入库时间:</td>
									<td>
										<input name="last_time" id="last_time" class="easyui-datebox"></input>
									</td>
								</tr>						
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="226">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height: 480px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="fk_dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="180" align="left" sortable="true">经销商名称</th>
							<th field="dealer_code" width="150" align="left" sortable="true">经销商代码</th>
							<th field="attribute" width="50" align="left" sortable="true">区域</th>	
							<th data-options="field:'last_time',width:150,align:'center'"  sortable="true">入库时间</th>
							<th field="product_item_number" width="80" align="left" sortable="true">产品编号</th>
							<th field="models" width="80" align="left" sortable="true">型号</th>
							<th field="batch_no" width="80" align="left" sortable="true">批号</th>
							<th field="product_sn" width="80" align="left" sortable="true">序列号</th>
							<th field="valid_date" width="200" align="left" sortable="true">有效期</th>
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="229">
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
			 url : basePath + "api/storagereport/paging",
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
    		var tabTitle = "库存报表导出";
    		addTabByChild(tabTitle,"report/ok.jsp");
			var url = "api/storagereport/down";			
			var form=$("<form>");//定义一个form表单
			form.attr("style","display:none");
			form.attr("target","");
			form.attr("method","post");
			form.attr("action",basePath+url);
			form.attr("enctype","multipart/form-data");
			var input0=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_id\" value="+$('#dealer_id').val()+">");
			var input1=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_code\" value="+$('#dealer_code').val()+">");
			var input2=$("<input type=\"hidden\" name=\"filter_ANDS_attribute\" value="+$('#attribute').val()+">");
			var input3=$("<input type=\"hidden\" name=\"filter_ANDS_last_time\" value="+$('#last_time').val()+">");
			var input4=$("<input type=\"hidden\" name=\"filter_ANDS_product_item_number\" value="+$('#product_item_number').val()+">");
			var input5=$("<input type=\"hidden\" name=\"filter_ANDS_models\" value="+$('#models').val()+">");
			var input6=$("<input type=\"hidden\" name=\"filter_ANDS_batch_no\" value="+$('#batch_no').val()+">");
			var input7=$("<input type=\"hidden\" name=\"filter_ANDS_product_sn\" value="+$('#product_sn').val()+">");
			var input8=$("<input type=\"hidden\" name=\"filter_ANDS_valid_date\" value="+$('#valid_date').val()+">");
			$("body").append(form);//将表单放置在web中
			form.append(input0);
			form.append(input1);
			form.append(input2);
			form.append(input3);
			form.append(input4);
			form.append(input5);
			form.append(input6);
			form.append(input7);
			form.append(input8);
			form.submit();//表单提交
		 }
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_id: $('#dealer_id').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val(),
		    	filter_ANDS_attribute: $('#attribute').val(),
		    	filter_ANDS_last_time: $('#last_time').val(),
		    	filter_ANDS_models: $('#models').val(),
		    	filter_ANDS_batch_no: $('#batch_no').val(),
		    	filter_ANDS_product_sn: $('#product_sn').val()
		    });
		}
	</script>
</body>
</html>