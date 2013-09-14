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
        <div  title="组织分类" style="width:300px;" data-options="region:'west',split:true">
  	        	 <ul id="tree" class="easyui-tree" 
	        	 		data-options="
							url: '${basePath}api/userOrganization/list',
							method: 'get',
							lines: true,
	            			onClick: function(node){
								var tree = $(this).tree;  
								isLeaf = tree('isLeaf', node.target);
								if(!isLeaf){
									//$('#cc').combotree('clear');
								}else{
									loadUserHospital(node.id,node.attributes.parent_id)
									//$('#cc').combotree('setValue', node.id);  
								}	
	            			}
			  			">
	    		</ul>  
        </div>
        <div title="负责医院" data-options="region:'center'">

		  <table id="dg" class="easyui-datagrid" title="查询结果" style="height:420px"
		           rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" >
		        <thead>
		            <tr>
		            		<th field="dealer_name" width="150" align="center" sortable="true">经销商名称</th>
		            		<th field="category_name" width="150" align="center" sortable="true">分类名称</th>
							<th field="hospital_name" width="150" align="center" sortable="true">医院名称</th>
							<th field="hostpital_category" width="200" align="center" sortable="true">客户分类</th>
							<th field="level_name" width="200" align="center" sortable="true">医院等级</th>
							<th field="provinces" width="200" align="center" sortable="true">所属省份</th>
							<th field="area" width="200" align="center" sortable="true">所属地区</th>
							<th field="city" width="200" align="center" sortable="true">所属县市(区)</th>
		            </tr>
		        </thead>
		    </table>
		    <div id="tb">    
				   <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a>         
				   <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a>    
			</div> 
        </div>
   </div>    

    
</div>
<div style="margin: 10px 0;"></div>
</div> 

       <div id="dlg" class="easyui-dialog" style="width:360px;height:260px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProducr-buttons">
	        <form id="fm" method="post" novalidate>
	        	<input type="hidden" name="user_id" id="hospital_user_id">
				       <table>
				             	<tr>
				             		<td>经销商:</td>
				             		<td>
				             		      <input class="easyui-combobox" name="dealer_id"  style="width:150px" maxLength="100" class="easyui-validatebox" required="true"
						             			data-options="
							             			url:'${basePath}/api/dealer/list',
								                    method:'get',
								                    valueField:'dealer_id',
								                    textField:'dealer_name',
								                    panelHeight:'auto'
						            			">
				             		</td>
				             	</tr>        					             	
				        </table>        	
	        </form>
    </div>
    <div id="dlgProducr-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>
    
		

	<script type="text/javascript">
	


		var uid = null;
		
		
		function loadUserHospital(user_id,parent_id){
			uid = user_id;
			$('#dg').datagrid({
				  url : basePath +"api/userHospitalFun/paging" ,
				  queryParams: {
					  filter_ANDS_user_id : user_id,
					  filter_ANDS_parent_id : parent_id
				 }
			});
		}
		
        function newEntity(){
        	if(uid){
    	        $('#dlg').dialog('open').dialog('setTitle','负责医院添加');
    	        $('#fm').form('clear');
    	        $("#hospital_user_id").val(uid);
    	        url = basePath +  'api/userHospitalFun/save';           		
        	}else{
				$.messager.alert('提示','请选中数据!','warning');				
			 }	
        }
        
		function saveEntity() {
			alert(111)
// 			$('#fm').form('submit', {
// 			    url:url,
// 			    method:"post",
// 			    onSubmit: function(){
// 			        return $(this).form('validate');;
// 			    },
// 			    success:function(msg){
// 			    	var jsonobj = $.parseJSON(msg);
// 			    	if(jsonobj.state==1){
// 						$('#dlg').dialog('close');     
// 	                    $('#dg').datagrid('reload');
// 			    	}else if(jsonobj.state==2){
// 			    		$.messager.alert('提示','医院重复!','warning');		
// 			    	}else{
// 			    		$.messager.alert('提示','Error!','error');	
// 			    	}
// 			    }		
// 			});	
		}
		
		function deleteEntity(){
			alert(222)
// 	           var row = $('#dg').datagrid('getSelected');
// 	            if (row){
// 	                $.messager.confirm('Confirm','是否确定删除?',function(r){
// 	                    if (r){
// 	            			$.ajax({
// 	            				type : "POST",
// 	            				url : basePath + 'api/userHospitalFun/delete',
// 	            				data : {id:row.id},
// 	            				error : function(request) {
// 	            					$.messager.alert('提示','Error!','error');	
// 	            				},
// 	            				success : function(data) {
// 	            					var jsonobj = $.parseJSON(data);
// 	            					if (jsonobj.state == 1) {  
// 	            	                     $('#dg').datagrid('reload');
// 	            					}else{
// 	            						$.messager.alert('提示','Error!','error');	
// 	            					}
// 	            				}
// 	            			});                    	
// 	                    }
// 	                });
// 	            }else{
// 					$.messager.alert('提示','请选中数据!','warning');				
// 				 }	
	        }
		

		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>