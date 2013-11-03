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
						<restrict:function funId="214">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			
						</restrict:function>   
					</div>
				</div>
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" title="查询结果" style="height: 480px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="hospital_name" width="280" align="left" sortable="true">医院名称</th>
							<th field="hostpital_category" width="50" align="left" sortable="true">客户分类</th>
							<th field="level_name" width="50" align="left" sortable="true">等级</th>
							<th field="provinces_name" width="120" align="left" sortable="true">省份</th>
							<th field="area_name" width="80" align="left" sortable="true">城市</th>
							<th field="city_name" width="80" align="left" sortable="true">区或乡</th>
							<th field="address" width="300" align="left" sortable="true">地址</th>
							<th field="postcode" width="100" align="left" sortable="true">邮编</th>
							<th field="last_update" width="150" align="left" sortable="true" formatter="formatterdate">最后修改时间</th>
							<th field="phone" width="200" align="left" sortable="true" hidden="true">电话</th>
							<th field="beds" width="200" align="left" sortable="true" hidden="true">床位数</th>
							<th data-options="field:'ids',width:50" sortable="true" formatter="formatterdesc">明细</th>	
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="220">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="repostExcel();">导出</a>   
					</restrict:function> 
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>

	   <div id="dlg" class="easyui-dialog" style="width:560px;height:460px;padding:5px 5px 5px 5px;"
	            modal="true" closed="true" buttons="#dlg-buttons">
		        <form id="fm" method="post" novalidate enctype="multipart/form-data">
		        	<input type="hidden" name="id">
					         	  <table>
					             	<tr>
					             		<td>医院名称:</td>
										<td><input name="hospital_name" style="width:300px" maxLength="50" class="easyui-validatebox"  required="true"></td>
					             	</tr>       
					             	<tr>
					             		<td>客户分类:</td>
										<td><input name="hostpital_category" style="width:300px" maxLength="20" class="easyui-validatebox" ></td>
					             	</tr>      	
					             	<tr>
					             		<td>等级:</td>
					             		<td>
					             		      <input class="easyui-combobox" name="level_id"  style="width:300px" maxLength="100" class="easyui-validatebox"
							             			data-options="
								             			url:'${basePath}/api/hospitalLevel/list',
									                    method:'get',
									                    valueField:'id',
									                    textField:'level_name',
 														editable:false,
							            			">			             		
					             		</td>
					             	</tr>
					             	<tr>
				             		<td>省份:</td>
				             		<td>
				             		    <input class="easyui-combobox" type="text" style="width:300px" name="provinces" id="provinces" data-options="required:false"></input>
				             		</td>
				             	</tr>
				             	<tr>
				             		<td>城市:</td>
				             		<td>
				             		    <input class="easyui-combobox" type="text" style="width:300px" name="city" id="city" data-options="required:false"></input>
				             		</td>
				             	</tr>
				             	<tr>
				             		<td>区或乡:</td>
				             		<td>
				             		    <input class="easyui-combobox" type="text" style="width:300px" name="area" id="area" data-options="required:false"></input>
				             		</td>
				             	</tr>
					             	<tr>
					             		<td>地址:</td>
										<td><input name="address" style="width:300px" maxLength="100" class="easyui-validatebox" ></td>
					             	</tr>   
					             	<tr>
					             		<td>邮编:</td>
										<td><input name="postcode" style="width:150px" maxLength="10" class="easyui-validatebox" ></td>
					             	</tr>   					             	
					             	<tr>
					             		<td>电话:</td>
										<td><input name="phone" style="width:150px" maxLength="20" class="easyui-validatebox" ></td>
					             	</tr>   					             	
					             	<tr>
					             		<td>床位数:</td>
										<td><input name="beds" style="width:150px" maxLength="10" class="easyui-numberbox"  data-options="min:0"></td>
					             	</tr>   					             	
					             	
					             	
					             	
					             	</table>        	
		        </form>
	    </div>
	    <div id="dlg-buttons">
	        <a href="javascript:void(0)" class="easyui-linkbutton" id="saveobject" iconCls="icon-ok" onclick="saveEntity();">保存</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
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
		
		var  city = $('#city').combobox({
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
	 	 function formatterdesc (value, row, index) { 
				// v = "'"+ row.id + "','" + index+"'";
				 	return '<a class="questionBtn" href="javascript:void(0)"  onclick="View_Entity('+index+')" ></a>';
				 //return '<span><img src="'+basePath+'resource/themes/icons/detail.png" style="cursor:pointer" onclick="View_Entity(' + index + ');"></span>'; 
			} 
	 	 
		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
		});

		$('#dg').datagrid({
			 url : basePath + "api/repostHospital/paging",
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
    		var tabTitle = "医院报表导出";
    		addTabByChild(tabTitle,"report/ok.jsp");
			var url = "api/repostHospital/down";			
			var form=$("<form>");//定义一个form表单
			form.attr("style","display:none");
			form.attr("target","");
			form.attr("method","post");
			form.attr("action",basePath+url);
			form.attr("enctype","multipart/form-data");
			var input1=$("<input type=\"hidden\" name=\"filter_ANDS_hospital_name\" value="+$('#hospital_name').val()+">");
			var input2=$("<input type=\"hidden\" name=\"filter_ANDS_level_id\" value="+$('#level_id').combobox('getValue')+">");
			var input3=$("<input type=\"hidden\" name=\"filter_ANDS_provinces\" value="+$('#quprovince').combobox('getValue')+">");
			var input4=$("<input type=\"hidden\" name=\"filter_ANDS_area\" value="+$('#quarea').combobox('getValue')+">");
			var input5=$("<input type=\"hidden\" name=\"filter_ANDS_city\" value="+$('#qucity').combobox('getValue')+">");
			var input6=$("<input type=\"hidden\" name=\"filter_ANDS_address\" value="+$('#address').val()+">");
			$("body").append(form);//将表单放置在web中
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
		    	filter_ANDS_hospital_name: $('#hospital_name').val(),
		    	filter_ANDS_level_id: $('#level_id').combobox('getValue'),
		    	filter_ANDS_provinces: $('#quprovince').combobox('getValue'),
		    	filter_ANDS_area: $('#quarea').combobox('getValue'),
		    	filter_ANDS_city: $('#qucity').combobox('getValue'),
		    	filter_ANDS_address: $('#address').val()
		    });
		}


		function View_Entity(index){
			 $('#dg').datagrid('selectRow', index);
			 var row = $('#dg').datagrid('getSelected');
			 $('#fm').form('load',row);
			 $('#dlg').dialog('open').dialog('setTitle','医院信息明细');
			 $('#saveobject').linkbutton('disable');
			  loadProvince();
	            $('#provinces').combobox({
	            	onLoadSuccess: function(){
	    	            $('#provinces').combobox("setValue",row.provinces);
	    	            $('#provinces').combobox("setText",row.provinces_name);
	            	}
	            });
	            $('#area').combobox({
	            	onLoadSuccess: function(){
	    	            $('#area').combobox("setValue",row.area);
	    	            $('#area').combobox("setText",row.area_name);
	            	}
	            });
	            $('#city').combobox({
	            	onLoadSuccess: function(){
	    	            $('#city').combobox("setValue",row.city);
	    	            $('#city').combobox("setText",row.city_name);
	            	}
	            });
		}
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>