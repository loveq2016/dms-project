<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"	href="../resource/themes/gray/easyui.css">
<link rel="stylesheet" type="text/css"	href="../resource/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../resource/css/main.css">
<script type="text/javascript" src="../resource/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="../resource/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../resource/js/common.js"></script>
<script type="text/javascript" src="../resource/locale/easyui-lang-zh_CN.js"></script>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<div id="p" class="easyui-panel" title="">
<div style="margin: 10px 0;"></div>
<div style="padding-left: 10px; padding-right: 10px">

<!-- <div class="easyui-panel" title=" " style="width:1050px;height:350px;padding:1px;" -->
<!-- 		data-options=" -->
<!-- 			        	tools:[{  -->
<!-- 				        	iconCls:'icon-reload',  -->
<!--  				        	handler:function(){  -->
<!--  				            	$('#tree').tree('reload');  -->
<!--  				        	}  -->
<!--  				        }] "> -->
	<div class="easyui-layout" style="width:1050px;height:450px;" data-options="fit:true">
        <div  title="产品分类" style="width:300px;" data-options="region:'west',split:true">
  	        	 <ul id="tree" class="easyui-tree" 
	        	 		data-options="
							url: '/yijava-dms/api/productCategory/list',
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
	            				if(typeof(node.state) == 'undefined'){
	            					loadProduct(node.id)
	            				}
	            			}
			  			">
	    		</ul>  
        </div>
        <div title="包含产品" data-options="region:'center'">
        
        	
        </div>
   </div>    

    
</div>
<div style="margin: 10px 0;"></div>
</div> 
		<div id="tt">
	        <a href="javascript:void(0)" class="icon-add" onclick="javascript:alert('add')"></a>
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
			<form id="productCagegoryFrom" method="post">
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
				p_target = $('#tree').tree('getParent',node.target).target;
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
				p_target = $('#tree').tree('getParent',node.target).target;
				$('#productCagegoryFrom').form('load', node);
				$('#treeEdit').window('open');
			}

		}
		function saveEntity() {
			$.ajax({
				type : "POST",
				url : '/yijava-dms/api/productCategory/save',
				data : $('#productCagegoryFrom').serialize(),
				error : function(request) {
					alert("Connection error");
				},
				success : function(data) {
					var jsonobj = $.parseJSON(data);
					if (jsonobj.state == 1) {
						$('#tree').tree('reload',p_target);
						p_target = null;
						$('#treeEdit').window('close');
					}
				}
			});
		}
		
		function removeIt(){
			var t = $('#tree');
			var node = t.tree('getSelected');
			if (node) {
				p_target = $('#tree').tree('getParent',node.target).target;
				$.ajax({
					type : "POST",
					url : '/yijava-dms/api/productCategory/remove',
					data :  {id:node.id},
					error : function(request) {
						alert("Connection error");
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
			alert(category_id)
		}
		
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>