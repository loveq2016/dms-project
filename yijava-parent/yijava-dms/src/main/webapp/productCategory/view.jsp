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

	<div class="easyui-layout" style="width:1050px;height:450px;" data-options="fit:true">
        <div  title="产品分类" style="width:300px;" data-options="region:'west',split:true">
  	        	 <ul id="tree" class="easyui-tree" 
	        	 		data-options="
							url: '${basePath}api/productCategory/list',
							method: 'get',
							lines: true,
							onContextMenu: function(e,node){
				                e.preventDefault();
				                $(this).tree('select',node.target);
				                $('#treeRightMenu').menu('show',{
				                    left: e.pageX,
				                    top: e.pageY
				                });
	            			},
	            			onClick: function(node){
								var tree = $(this).tree;  
								isLeaf = tree('isLeaf', node.target);
								if(!isLeaf){
									//$('#cc').combotree('clear');
								}else{
									loadProduct(node.id)
									//$('#cc').combotree('setValue', node.id);  
								}	
	            			}
			  			">
	    		</ul>  
        </div>
        <div title="包含产品" data-options="region:'center'">

		  <table id="dg" class="easyui-datagrid" title="查询结果" style="height:420px"
		           rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="desc">
		        <thead>
		            <tr>
							<th field="item_number" width="150" align="center">产品编号</th>
							<th field="cname" width="200" align="center">中文名称</th>
							<th field="ename" width="200" align="center">英文说明</th>
							<th field="remark" width="400" align="center">描述</th>
							<th field="price" width="150" align="center">价格</th>
							<th field="order_company" width="150" align="center">订购单位</th>
		               		<th field="is_order" width="100" align="center" formatter="formatterIs_order">是否可订货</th>
		            </tr>
		        </thead>
		    </table>
        </div>
   </div>    

    
</div>
<div style="margin: 10px 0;"></div>
</div> 
		<%-- 右键菜单--%>
		 <div id="treeRightMenu" class="easyui-menu" style="width:120px;">
			<div onclick="append()"   data-options="iconCls:'icon-add'">添加</div>
			<div onclick="edit()"   data-options="iconCls:'icon-edit'">编辑</div>
			<div onclick="removeIt()" data-options="iconCls:'icon-remove'">删除</div>
		</div>
		<%-- 右键菜单--%>
		<div id="treeEdit" class="easyui-window" title="产品分类详细信息" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
		style="width:650px;height:200px;padding:10px;">
			<form id="productCagegoryFrom" method="post" enctype="multipart/form-data">
					<input type="hidden" name="id"/>
					<input type="hidden" name="parent_id"/>
					<table>
						<tr>
							<td>产品分类名称:</td>
							<td><input class="easyui-validatebox" type="text" name="text" data-options="required:true,validType:'length[1,30]'" maxlength="30"></input></td>
						</tr>
					</table>
			</form>
			<div style="text-align: right; padding: 5px">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="closeForm()">取消</a>					   
			</div>
		</div>		
		

	<script type="text/javascript">
	


		var p_target = null;
		function append() {
			clearForm();
			var t = $('#tree');
			var node = t.tree('getSelected');
			if (node) {
				//p_target = $('#tree').tree('getParent',node.target).target;
				$('#productCagegoryFrom').form('load', {
					parent_id : '' + node.id + ''
				});
				$('#treeEdit').window('open');
			}

		}
		function edit() {
			clearForm();
			var t = $('#tree');
			var node = t.tree('getSelected');
			if (node) {
				//p_target = $('#tree').tree('getParent',node.target).target;
				$('#productCagegoryFrom').form('load', node);
				$('#treeEdit').window('open');
			}

		}
		function saveEntity() {
			
			$('#productCagegoryFrom').form('submit', {
				url : basePath + 'api/productCategory/save',
				method : "post",
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(msg) {
					var jsonobj = $.parseJSON(msg);
					if (jsonobj.state == 1) {
						$('#tree').tree('reload');
						$('#treeEdit').window('close');
					}else {
						$.messager.alert('提示', 'Error!', 'error');
					}
				}
			});
		}
		
		function removeIt(){
			var t = $('#tree');
			var node = t.tree('getSelected');
			if (node) {
				//p_target = $('#tree').tree('getParent',node.target).target;
				$.ajax({
					type : "POST",
					url : basePath + 'api/productCategory/remove',
					data :  {id:node.id},
					error : function(request) {
						$.messager.alert('提示','Error!','error');	
					},
					success : function(data) {
						var jsonobj = $.parseJSON(data);
						if (jsonobj.state == 1) {
							$('#tree').tree('reload',p_target);
						}
					}
				});
			}			
		}
		function clearForm() {
			$('#productCagegoryFrom').form('clear');
		}

		function closeForm() {;
			$('#treeEdit').window('close');
		}
		
		function loadProduct(category_id){
			$('#dg').datagrid({
				  url : basePath +"api/product/paging" ,
				  queryParams: {
					  filter_ANDS_category_id : category_id
				 }
			});
		}
		
		function formatterIs_order (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		} 
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>