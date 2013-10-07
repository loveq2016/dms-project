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
									<td>产品编号:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="item_number" id="item_number" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="108">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>	
						</restrict:function>		   
					</div>
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">

				<table id="dg" title="查询结果" style="height: 330px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="item_number" width="150" align="center" sortable="true">产品编号</th>
							<th field="cname" width="200" align="center" sortable="true">中文名称</th>
							<th field="ename" width="200" align="center" sortable="true">英文说明</th>
							<th field="remark" width="400" align="center">描述</th>
							<th field="price" width="150" align="center">价格</th>
							<th field="order_company" width="150" align="center">订购单位</th>
							<th field="is_order" width="100" align="center" formatter="formatterIs_order">是否可订货</th>
						</tr>
					</thead>
				</table>
				<div id="tb"> 
				<restrict:function funId="109">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a></restrict:function>    
				 <restrict:function funId="110">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a></restrict:function>    
				<restrict:function funId="111">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a></restrict:function>   
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:500px;height:380px;padding:10px 20px"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate enctype="multipart/form-data">
        	<input type="hidden" name="item_number">
             <table>
             	<tr>
             		<td>中文名称:</td>
             		<td><input name="cname" class="easyui-validatebox" required="true"></td>
             	</tr>
              	<tr>
             		<td>英文说明:</td>
             		<td><input name="ename" class="easyui-validatebox" required="true"></td>
             	</tr>            	
             	<tr>
             		<td>描述:</td>
             		<td><input name="remark"></td>
             	</tr>             	
              	<tr>
             		<td>价格:</td>
             		<td><input name="price" class="easyui-numberbox" min="0" max="99999999" precision="2" required="true"></td>
             	</tr>
             	<tr>
             		<td>订购单位:</td>
             		<td><input name="order_company" class="easyui-validatebox"></td>
             	</tr>             	
              	<tr>
             		<td>是否可订货:</td>
             		<td>
             			<input type="radio" name="is_order"  value="1"> 是
                		<input type="radio" name="is_order"  value="0"> 否
                	</td>
             	</tr>                	
              	<tr>
             		<td>产品分类:</td>
             		<td>
	                <input id="cc" name="category_id" class="easyui-combotree"  value=""  required="true" editable="false" style="width:200px;"
	                	data-options="
	                			url: '${basePath}/api/productCategory/list',
								method: 'get',
								lines: true,
								onClick : function(node){
								    var tree = $(this).tree;  
									isLeaf = tree('isLeaf', node.target);
									if(!isLeaf){
										$('#cc').combotree('clear');
									}else{
										$('#cc').combotree('setValue', node.id);  
									}	
		            			}" >  
                	</td>
             	</tr>  
            </table>
        </form>
    </div>
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>
    
    
	
	

	<script type="text/javascript">
	 	var url;
	 	
		$('#dg').datagrid({
			url : basePath + "api/product/paging"
		});


		function formatterIs_order (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		} 
		
		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
		});
		
		 
		 function newEntity(){
	        $('#dlg').dialog('open').dialog('setTitle','产品基础信息添加');
	        $('#fm').form('clear');
	        $("input[name='is_order']:eq(0)").attr("checked", "checked"); 
	        url = basePath + '/api/product/save';
		  } 

	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','产品基础信息更新');
	            $('#fm').form('load',row);
			    $('#cc').combotree('setValue',row.category_id);
		        $('#cc').combotree('setText',row.category_name);
	            url = basePath + 'api/product/update';
	          }else{
					$.messager.alert('提示','请选中数据!','warning');				
			 }	
	     }
	     
			
		
		function saveEntity() {
			$('#fm').form('submit', {
			    url:url,
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');;
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
						 $('#dlg').dialog('close');     
	                     $('#dg').datagrid('reload');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});	
		}
		  
		  
		 function deleteEntity(){
	           var row = $('#dg').datagrid('getSelected');
	            if (row){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/product/delete',
	            				data : {id:row.item_number},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dg').datagrid('reload');
	            					}else{
	            						$.messager.alert('提示','Error!','error');	
	            					}
	            				}
	            			});                    	
	                    }
	                });
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
	        }
	

		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_item_number: $('#item_number').val()
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>