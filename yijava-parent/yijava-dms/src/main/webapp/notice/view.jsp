<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
									<td>标题:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="title" id="title" data-options="required:false"></input>
									</td>
									<td></td>
									<td>发布人:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="realname" id="realname" data-options="required:false"></input>
									</td>
									<td></td>
									<td>重要性:</td>
									<td><input name="level_id" class="easyui-combobox" id="level_id" style="width:80px;"
										data-options="
							             			url:'${basePath}/api/noticeLevel/list',
								                    method:'get',
								                    valueField:'id',
								                    textField:'level_name',
								                    panelHeight:'auto'
						            			" />
									</td>
									<td></td>
									<td>状态:</td>
									<td><input name="status_id" class="easyui-combobox" id="status_id" style="width:80px;"
										data-options="
							             			url:'${basePath}/api/noticeStatus/list',
								                    method:'get',
								                    valueField:'id',
								                    textField:'status_name',
								                    panelHeight:'auto'
						            			" />
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="121">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>	
						</restrict:function>	   
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" class="easyui-datagrid" title="查询结果" style="height: 330px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="publish_date" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="title" width="200" align="left" sortable="true">标题</th>
							<th field="realname" width="100" align="left" sortable="true">发布人</th>
							<th field="status_name" width="100" align="left"  sortable="true">发布状态</th>
							<th field="publish_date" width="150" align="left" sortable="true">发布时间</th>
							<th field="validity_date" width="150" align="left" sortable="true">有效期</th>
							<th field="level_name" width="100" align="left"  sortable="true">紧急程度</th>
							<th field="dealer_id" width="100" align="left"  sortable="true" formatter="formatterInfo">详细</th>
							
						</tr>
					</thead>
				</table>
				<div id="tb">    
				<restrict:function funId="122">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a>    
				 </restrict:function>
				 <restrict:function funId="130">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit"  plain="true" onclick="updateEntity();">编辑</a>   
				 </restrict:function>  
<!-- 				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a>     -->
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		
		
   <div id="dlg" class="easyui-dialog" style="width:703px;height:450px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate enctype="multipart/form-data">
        <input type="hidden" name="notice_id" id="notice_id">
        <input type="hidden" name="category_ids" id="category_ids">
         <div class="easyui-tabs" style="width:680px;height: auto;">
         	 <div title="基本信息" style="padding: 5px 5px 5px 5px;" >
	            <div class="easyui-layout" style="width:670px;height:320px;">  
		        <div data-options="region:'east',split:true" title="发布对象" style="width:160px;">
		        	<table id="dgDealerCategory" class="easyui-datagrid" title="经销商分类" style="height:300px"  method="get"
						 singleSelect="1"  sortName="id" sortOrder="desc">
						<thead>
							<tr>
								<th field="id" checkbox="true"></th>
								<th field="category_name" width="150" align="left">中文名称</th>
							</tr>
						</thead>
					</table>  
		        </div>  
		        <div data-options="region:'center'" style="background:#fafafa;overflow:hidden">  
		         	  <table border="0">
								<tr>
									<td>重要性:</td>
									<td><input name="level_id" class="easyui-combobox" required="true" style="width:80px;"
										data-options="
							             			url:'${basePath}/api/noticeLevel/list',
								                    method:'get',
								                    valueField:'id',
								                    textField:'level_name',
								                    panelHeight:'auto'
						            			" />
									</td>
			             			<td>有效期:</td>
			             			<td><input name="validity_date" class="easyui-datebox" style="width:100px;"></td>
									<td>状态:</td>
									<td><input name="status_id" class="easyui-combobox" required="true" style="width:80px;"
										data-options="
							             			url:'${basePath}/api/noticeStatus/list',
								                    method:'get',
								                    valueField:'id',
								                    textField:'status_name',
								                    panelHeight:'auto'
						            			" />
									</td>
			             	</tr>            	
			             	<tr >
			             		<td>标题:</td>
			             		<td colspan="5"><input name="title" style="width:250px" maxLength="30" class="easyui-validatebox" required="true"></td>
			             	</tr>             	
			              	<tr>
			             		<td>公告内容:</td>
			             		<td colspan="5"><textarea name="content" cols="65" style="height:220px;"></textarea></td>
			             	</tr>
			            </table>					
		        </div>  
		    </div> 
         	 </div>
         	 <div title="经销商阅读信息" style="padding:10px">
	     			<table id="dgDealer" class="easyui-datagrid" title="查询结果" style="height:300px"  method="get"
						rownumbers="true" singleSelect="true" pagination="true" sortName="read_date" sortOrder="desc" >
						<thead>
							<tr>
								<th field="dealer_name" width="200" align="center" sortable="true">中文名称</th>
								<th field="dealer_code" width="100" align="center" sortable="true">经销商代码</th>
								<th field="is_read" width="150" align="center" sortable="true" formatter="formatterIs_read">是否已阅读</th>
								<th field="read_date" width="150" align="center" sortable="true">阅读时间</th>
							</tr>
						</thead>
					</table>    	 
         	 </div>
 		</div>
        </form>
    </div>
    <div id="dlg-buttons">
        <a id="saveEntityBtn" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>


   <div id="dlgInfo" class="easyui-dialog" style="width:703px;height:450px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true">
         <form id="fmInfo" method="post" novalidate enctype="multipart/form-data">
         <div class="easyui-tabs" style="width:680px;height: auto;">
         	 <div title="基本信息" style="padding: 5px 5px 5px 5px;" >
		        <div data-options="region:'center'" style="background:#fafafa;overflow:hidden">  
		         	  <table border="0">
								<tr>
									<td>重要性:</td>
									<td><input name="level_name"  type="text" required="true" style="width:80px;"/></td>
			             			<td>有效期:</td>
			             			<td><input name="validity_date" class="easyui-datebox" type="text" style="width:100px;"></td>
									<td>状态:</td>
									<td><input name="status_name" type="text" required="true" style="width:80px;"/></td>
			             	</tr>            	
			             	<tr >
			             		<td>标题:</td>
			             		<td colspan="5"><input name="title" style="width:250px" maxLength="30" class="easyui-validatebox" required="true"></td>
			             	</tr>             	
			              	<tr>
			             		<td>公告内容:</td>
			             		<td colspan="5"><textarea name="content" cols="65" style="height:220px;"></textarea></td>
			             	</tr>
			            </table>					
		        </div>  
		    </div> 
 		</div>
 		</form>
    </div>
    
    
    
	<script type="text/javascript">
	 	var url;
		$(function() {
			$('#dg').datagrid({
				  url : basePath +"api/notice/paging" ,
				  onLoadSuccess:function(data){ 
					  var rowData = data.rows;  
					  if(!rowData[0].dealer_id){
						  $('#dg').datagrid('hideColumn',"dealer_id");  
					  }else{
						  $(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
					  }
				  }
			});
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_title: $('#title').val(),
		    	filter_ANDS_realname: $('#realname').val(),
		    	filter_ANDS_level_id: $('#level_id').combobox('getValue'),
		    	filter_ANDS_status_id: $('#status_id').combobox('getValue'),
		    });
		}
		
		function formatterInfo(value, row, index){
			v = "'"+ row.notice_id + "','" + index+"'";
			return '<a class="infoBtn" href="javascript:void(0)"  onclick="showEntity(' + v + ')" ></a>';
		}
		
		function showEntity(notice_id,index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
			if (row) {
				$('#dlgInfo').dialog('open').dialog('setTitle', '公告详细');
				$('#fmInfo').form('load', row);
				$.getJSON(basePath + "api/noticeDealer/update?id="+row.notice_id,function(result){});				
			}
		}
		
		function formatterIs_read(value, row, index){
			//v = "'"+ row.id + "','" + index+"'";
			//return '<a class="infoBtn" href="javascript:void(0)"  onclick="updateEntity(' + row.id + ')" ></a>';
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		}
		function newEntity() {
			$('#dlg').dialog('open').dialog('setTitle', '公告添加');
			$('#fm').form('clear');
			url = basePath + 'api/notice/save';
			$('#dgDealerCategory').datagrid({
				url : basePath + "api/dealerCategory/paging",
				 onLoadSuccess:function(data){ 
					 $('#dgDealerCategory').datagrid('clearSelections');  
				 }
			});
			$('#dgDealer').datagrid('loadData', { total: 0, rows: [] });
			$("#saveEntityBtn").linkbutton("enable");
		}

		function updateEntity() {
			var row = $('#dg').datagrid('getSelected');
			if (row) {
				url = basePath + 'api/notice/update';
				$('#fm').form('clear');
				$('#dlg').dialog('open').dialog('setTitle', '公告修改');
				$('#fm').form('load', row);
				
				if(row.status_id==1||row.status_id==3){
					$("#saveEntityBtn").linkbutton("disable");
				}else{
					$("#saveEntityBtn").linkbutton("enable");
				}
				
				$('#dgDealerCategory').datagrid({
					url : basePath + "api/dealerCategory/paging",
					 onLoadSuccess:function(data){ 
						 $.getJSON(basePath + "api/notice/categoryList?id="+row.notice_id,function(result){
							 $.each(result, function(i, field){
								 var rowData = data.rows;  
								 $.each(rowData,function(idx,val){
									if(val.id==field.dealer_category_id){
										 $('#dgDealerCategory').datagrid('selectRow',idx);  
									}
								 });
							   });
						 });
					 }
				});
				$('#dgDealer').datagrid({
					url : basePath + "api/noticeDealer/paging",
					queryParams: {
						filter_ANDS_notice_id : row.notice_id
					}
				});
			}else{
				$.messager.alert('提示','请选中数据!','warning');		
			}
		}

		function saveEntity() {
			var ids = [];
			var rows = $('#dgDealerCategory').datagrid('getSelections');
			for ( var i = 0; i < rows.length; i++) {
				ids.push(rows[i].id);
			}
			if (ids.length > 0) {
				$("#category_ids").val(ids.join(','));
				$('#fm').form('submit', {
					url : url,
					method : "post",
					onSubmit : function() {
						return $(this).form('validate');
					},
					success : function(msg) {
						var jsonobj = $.parseJSON(msg);
						if (jsonobj.state == 1) {
							$('#dlg').dialog('close');
							$('#dg').datagrid('reload');
						} else {
							$.messager.alert('提示', 'Error!', 'error');
						}
					}
				});
			} else {
				$.messager.alert('提示', '请选择发布对象!', 'error');
			}
		}

	</script>
</body>
</html>