<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
						<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>			   
					</div>
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">

				<table id="dg" title="查询结果" style="height: 330px" url="/yijava-dms/api/product/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="desc">
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

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
            closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate>
        	<input type="hidden" name="item_number">
            <div class="fitem">
                <label>中文名称:</label>
                <input name="cname" class="easyui-validatebox" required="true">
            </div>
            <div class="fitem">
                <label>英文说明:</label>
                <input name="ename" class="easyui-validatebox" required="true">
            </div>
            <div class="fitem">
                <label>描述:</label>
                <input name="remark">
            </div>
            <div class="fitem">
                <label>价格:</label>
                <input name="price" class="easyui-numberbox" min="0" max="99999999" precision="2" required="true">
            </div>
            <div class="fitem">
                <label>订购单位:</label>
                <input name="order_company" class="easyui-validatebox">
            </div>
            <div class="fitem">
                <label>是否可订货:</label>
                	<input type="radio" name="is_order" class="easyui-validatebox" value="1"> 是
                	<input type="radio" name="is_order" class="easyui-validatebox" value="0"> 否
            </div>
            <div class="fitem">
                <label>产品分类:</label>
                <input id="cc" name="category_id" class="easyui-combotree"  value=""  url="/yijava-dms/api/productCategory/list"  required="true" editable="false" style="width:200px;"
                	data-options="
                			url: '/yijava-dms/api/productCategory/list',
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
            </div>
            							
            
        </form>
    </div>
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>
	
	

	<script type="text/javascript">
	 	var url;
		$('#dg').datagrid({
		    toolbar : [{
		        text:'添加',
		        iconCls:'icon-add',
		        handler:function(){newEntity();}
		    },{
		        text:'编辑',
		        iconCls:'icon-edit',
		        handler:function(){updateEntity();}
		    },'-',{
		        text:'删除',
		        iconCls:'icon-remove',
		        handler:function(){deleteEntity();}
		    }]
		});


		function formatterIs_order (value, row, index) { 
			return value==1?"<span style='color:green'>是</span>":"<span style='color:red'>否</span>";
		} 
		
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
		});
		
		 
		 function newEntity(){
	        $('#dlg').dialog('open').dialog('setTitle','产品基础信息添加');
	        $('#fm').form('clear');
	        
	        
		     $('#cc').combotree('setValue',"11");
	         $('#cc').combotree('setText',"sss");
	        
	        //$('#cc').combotree('reload');
	        
// 	        $('#cc').combotree({
//                 onLoadSuccess: function (node, data) {
//                 	 for(var i=0;i<data.length;i++){  
//                 		 if(data[i].id == 18){
//                 			 $('#cc').combotree('setValue',data[i].id);
//                 			 break;
//                 		 }else{
//                 			 $('#cc').combotree({url : "/yijava-dms/api/productCategory/list?id="+data[i].id});
//                 		 }
//                 	 }
//                 }
//         	});
	        
	        
	        
//             var node = $('#cc').combotree('tree').tree("find",1);
//             if (node){  
//                 var children = $('#cc').combotree('tree').tree('getChildren', node.target);  
//                 var s = '';  
//                 for(var i=0; i<children.length; i++){  
//                     s += children[i].text + ',';  
//                 }  
//                 alert(s);  
//             }  
            
            
            
           // alert(node)
            
            
	        url = '/yijava-dms/api/product/save';
	     }
		   

	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','产品基础信息更新');
	            $('#fm').form('load',row);
	            

	            
		       // $('#cc').combotree('setValue',"11");
		        //$('#cc').combotree('setText',"sss");
		        
		        
	            url = '/yijava-dms/api/product/update';
	          }
	     }
	     
			
		
		function saveEntity() {
			$.ajax({
				type : "POST",
				url : url,
				data : $('#fm').serialize(),
				error : function(request) {
					alert("Error");
				},
				success : function(data) {
					var jsonobj = $.parseJSON(data);
					if (jsonobj.state == 1) {
						 $('#dlg').dialog('close');     
	                     $('#dg').datagrid('reload');
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
	            				url : '/yijava-dms/api/product/delete',
	            				data : {id:row.item_number},
	            				error : function(request) {
	            					alert("Error");
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dg').datagrid('reload');
	            					}
	            				}
	            			});                    	
	                    }
	                });
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