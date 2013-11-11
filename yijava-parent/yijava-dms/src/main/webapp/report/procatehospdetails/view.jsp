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
									<td>产品分类:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="product_remark" id="product_remark" data-options="required:false"></input>
									</td>
									<td>医院名称:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="hospital_name" id="hospital_name" data-options="required:false"></input>
									</td>
									<td>医院等级:</td>
									<td>
										<input class="easyui-combobox" name="level_id"  id="level_id"  style="width:150px" maxLength="100" 
										class="easyui-validatebox" required="true"
							             			data-options="
								             			url:'${basePath}/api/hospitalLevel/list',
									                    method:'get',
									                    valueField:'id',
									                    textField:'level_name',
									                    required:false,
									                    editable:false
							            			">
									</td>
									<td>省份:</td>
									<td>
										<input class="easyui-combobox" type="text" name="quprovince" id="quprovince" data-options="required:false"></input>
									</td>
							</tr>
							<tr>
									<td>城市:</td>
									<td>
										<input class="easyui-combobox" type="text"  name="quarea" id="quarea" data-options="required:false"></input>
									</td>
									
									<td>区或乡:</td>
									<td>
										<input class="easyui-combobox" type="text"  name="qucity" id="qucity"  data-options="required:false"></input>
									</td>
									
									<td>地址:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="address" id="address" style="width:300px" data-options="required:false"></input>
									</td>
								</tr>						
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="215">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height: 480px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="proid" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="product_remark" width="160" align="left" sortable="true">产品分类</th>
							<th field="hospital_name" width="180" align="left" sortable="true">医院名称</th>
							<th field="realname" width="80" align="left" sortable="true">销售人员</th>
							<th field="dealer_name" width="180" align="left" sortable="true">授权经销商</th>		
							<th field="level_name" width="50" align="left" sortable="true">医院等级</th>
							<th field="provinces_name" width="80" align="left" sortable="true">医院省份</th>
							<th field="area_name" width="80" align="left" sortable="true">医院地区</th>
							<th field="city_name" width="80" align="left" sortable="true">医院县市(区)</th>
							<th field="address" width="200" align="left" sortable="true">地址</th>
							<th field="postcode" width="80" align="left" sortable="true">邮编</th>
							<th field="phone" width="80" align="left" sortable="true" hidden="true">医院电话</th>
							<th field="beds" width="80" align="left" sortable="true" hidden="true">床位数</th>	
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="222">
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
			 url : basePath + "api/procatehospdetails/paging",
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
    		var tabTitle = "产品分类激活医院明细报表导出";
    		addTabByChild(tabTitle,"report/ok.jsp");
			var url = "api/procatehospdetails/down";			
			var form=$("<form>");//定义一个form表单
			form.attr("style","display:none");
			form.attr("target","");
			form.attr("method","post");
			form.attr("action",basePath+url);
			form.attr("enctype","multipart/form-data");
			var input0=$("<input type=\"hidden\" name=\"filter_ANDS_product_remark\" value="+$('#product_remark').val()+">");
			var input1=$("<input type=\"hidden\" name=\"filter_ANDS_hospital_name\" value="+$('#hospital_name').val()+">");
			var input2=$("<input type=\"hidden\" name=\"filter_ANDS_level_id\" value="+$('#level_id').combobox('getValue')+">");
			var input3=$("<input type=\"hidden\" name=\"filter_ANDS_provinces\" value="+$('#quprovince').combobox('getValue')+">");
			var input4=$("<input type=\"hidden\" name=\"filter_ANDS_area\" value="+$('#quarea').combobox('getValue')+">");
			var input5=$("<input type=\"hidden\" name=\"filter_ANDS_city\" value="+$('#qucity').combobox('getValue')+">");
			var input6=$("<input type=\"hidden\" name=\"filter_ANDS_address\" value="+$('#address').val()+">");
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
		    	filter_ANDS_product_remark: $('#product_remark').val(),
		    	filter_ANDS_hospital_name: $('#hospital_name').val(),
		    	filter_ANDS_level_id: $('#level_id').combobox('getValue'),
		    	filter_ANDS_provinces: $('#quprovince').combobox('getValue'),
		    	filter_ANDS_area: $('#quarea').combobox('getValue'),
		    	filter_ANDS_city: $('#qucity').combobox('getValue'),
		    	filter_ANDS_address: $('#address').val()
		    });
		}
	</script>
</body>
</html>