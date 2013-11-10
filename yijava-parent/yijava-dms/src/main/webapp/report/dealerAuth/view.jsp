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
										<input class="easyui-validatebox" type="text" style="width:300px" name="dealer_name" id="dealer_name" data-options="required:false"></input>
									</td>
									<td></td>
									<td>经销商代码:</td>
									<td>
										<input class="easyui-validatebox" type="text" style="width:300px" name="dealer_code" id="dealer_code" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="217">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>		
						</restrict:function>	   
					</div>
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">

				<table id="dg" title="查询结果" style="height: 500px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="left" sortable="true">经销商名称</th>
							<th field="category_name" width="200" align="left" sortable="true">经销商类型</th>
							<th field="attribute" width="200" align="left" sortable="true">经销商属性</th>
							<th field="product_remark" width="200" align="left" sortable="true">授权分类</th>
							<th field="hospital_name" width="180" align="left" sortable="true">医院名称</th>
							<th field="level_name" width="50" align="left" sortable="true">医院等级</th>
							<th field="provinces_name" width="80" align="left" sortable="true">医院省份</th>
							<th field="area_name" width="80" align="left" sortable="true">医院地区</th>
							<th field="city_name" width="80" align="left" sortable="true">医院县市(区)</th>
							<th field="address" width="200" align="left" sortable="true">地址</th>
							<th field="postcode" width="80" align="left" sortable="true">邮编</th>
							<th field="phone" width="80" align="left" sortable="true" >医院电话</th>
							<th field="beds" width="80" align="left" sortable="true">床位数</th>	
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="221">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="repostExcel();">导出</a> 
					</restrict:function>   
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
	<script type="text/javascript">
		function formatterdesc (value, row, index) { 
			// v = "'"+ row.id + "','" + index+"'";
			 	return '<a class="questionBtn" href="javascript:void(0)"  onclick="View_Entity('+index+')" ></a>';
			 //return '<span><img src="'+basePath+'resource/themes/icons/detail.png" style="cursor:pointer" onclick="View_Entity(' + index + ');"></span>'; 
		} 
		
	
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/repostDealerAuth/paging",
			 onLoadSuccess:function(data){ 
				  $(".questionBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			 }
		});


		function formatterStatus (value, row, index) { 
			return value==1?"<span style='color:green'>有效</span>":"<span style='color:red'>无效</span>";
		} 
		
		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
		});
		
		function loadProvince(){
			
			var provinces =  $('#attribute').combobox({
					valueField:'name',
					textField:'name',
					editable:false,
					url:basePath +'api/area/getarea_api?pid=0',
					
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

		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val(),
		    	
		    });
		}
		
		function View_Entity(index){
			 $('#dg').datagrid('selectRow', index);
			
			 var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','经销商基础信息查看');
	            $('#fm').form('load',row);
	            
	            if(row.status==1){
	            	$("input[name='status']:eq(0)").attr("checked", "checked"); 
	            }else{
	            	$("input[name='status']:eq(1)").attr("checked", "checked"); 
	            }
	          }
		}

		 function repostExcel(){
	    		var tabTitle = "经销商授权信息报表导出";
	    		addTabByChild(tabTitle,"report/ok.jsp");
				var url = "api/repostDealerAuth/down";			
				var form=$("<form>");//定义一个form表单
				form.attr("style","display:none");
				form.attr("target","");
				form.attr("method","post");
				form.attr("action",basePath+url);
				form.attr("enctype","multipart/form-data");
				var input1=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_name\" value="+$('#dealer_name').val()+">");
				var input2=$("<input type=\"hidden\" name=\"filter_ANDS_dealer_code\" value="+$('#dealer_code').val()+">");
				$("body").append(form);//将表单放置在web中
				form.append(input1);
				form.append(input2);
				form.submit();//表单提交
			 }
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>