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
									loadUserDealer(node.attributes.user_id,node.attributes.parent_id)
									//$('#cc').combotree('setValue', node.id);  
								}	
	            			}
			  			">
	    		</ul>  
        </div>
        <div title="负责经销商" data-options="region:'center'">

		  <table id="dg" class="easyui-datagrid" title="查询结果" style="height:420px"
		           rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
		        <thead>
		            <tr>
							<th field="dealer_name" width="150" align="left" sortable="true">中文名称</th>
							<th field="dealer_code" width="200" align="left" sortable="true">经销商代码</th>
							<th field="business_contacts" width="200" align="left" sortable="true">商务联系人</th>
							<th field="business_phone" width="200" align="left" sortable="true">商务联系人电话</th>
		            </tr>
		        </thead>
		    </table>
		    <div id="tb">   
		    	<restrict:function funId="117">
				   <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a>
				</restrict:function>
				<restrict:function funId="118">       
				   <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a>  
				</restrict:function> 
			</div> 
        </div>
   </div>    

    
</div>
<div style="margin: 10px 0;"></div>
</div> 

       <div id="dlg" class="easyui-dialog" style="width:360px;height:260px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProducr-buttons">
	        <form id="fm" method="post" novalidate enctype="multipart/form-data">
	        	<input type="hidden" name="user_id" id="dealer_user_id">
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
		
		
		function loadUserDealer(user_id,parent_id){
			//alert(user_id.split("|")[1])
			//alert(parent_id)
			//uid = user_id.split("|")[1];
			uid = user_id ; 
			$('#dg').datagrid({
				  url : basePath +"api/userDealerFun/paging" ,
				  queryParams: {
					  filter_ANDS_user_id : user_id,
					  filter_ANDS_parent_id : parent_id
				 }
			});
		}
		
        function newEntity(){
        	if(uid){
    	        $('#dlg').dialog('open').dialog('setTitle','负责经销商添加');
    	        $('#fm').form('clear');
    	        $("#dealer_user_id").val(uid);
    	        url = basePath +  'api/userDealerFun/save';           		
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
			    	}else if(jsonobj.state==2){
			    		$.messager.alert('提示','经销商重复!','warning');		
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
	            				url : basePath + 'api/userDealerFun/delete',
	            				data : {id:row.id},
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
		

		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>