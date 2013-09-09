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
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_name" data-options="required:false"></input>
									</td>
									<td></td>
									<td>经销商代码:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="dealer_name" id="dealer_code" data-options="required:false"></input>
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
				<table id="dg" class="easyui-datagrid" title="查询结果" style="height: 430px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="center" sortable="true">经销商名称</th>
							<th field="dealer_code" width="200" align="center" sortable="true">经销商代码</th>
							<th field="address" width="200" align="center" sortable="true" formatter="formatterInfo">维护地址明细</th>
						</tr>
					</thead>
				</table>
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


     
        <div id="dlgAddress" class="easyui-dialog" style="width:800px;height:450px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true">
            <div id="p1" class="easyui-panel" title="基础信息"  height="200px">
 				<table>
						<tr>
							<td>经销商:</td>
							<td><input class="easyui-validatebox" type="text"   style="width:200px" id="show_dealer_name" data-options="required:false"></input></td>
							<td></td>
							<td>经销商代码:</td>
							<td><input class="easyui-validatebox" type="text"  style="width:200px"  id="show_dealer_code" data-options="required:false"></input></td>
						</tr>
				</table>           
            </div>
            <div style="margin: 5px 0;"></div>
             <div id="p2" class="easyui-panel" title="编辑信息"  height="200px">
		        <form id="fm" method="post" novalidate>
		        <input type="hidden" name="id">
		        <input type="hidden" name="dealer_id">
		         	  <table>
			             	<tr>
			             		<td>收货地址:</td>
			             		<td><input name="address" class="easyui-validatebox" style="width:150px" maxLength="100" data-options="required:true"></td>
			             		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			             		<td>收货地址邮编:</td>
			             		<td><input name="postcode" class="easyui-numberbox" style="width:150px" maxLength="10" data-options="required:false"></td>
			             	</tr>             	
			              	<tr>
			             		<td>收货人中文姓名:</td>
			             		<td><input name="linkman" class="easyui-validatebox" style="width:150px" maxLength="50"  data-options="required:true"></td>
			             		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			             		<td>收货人电话:</td>
								<td><input name="linkphone" class="easyui-validatebox" style="width:150px" maxLength="20" data-options="required:true"></td>
			             	</tr>    
			            </table>
		        </form>       
		           <div style="padding:5px;padding-right:20px;width:150px;float:right;">  
			        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="newEntity();">新增</a>  
			        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" onclick="updateEntity();">修改</a>  
			    </div>  
            </div>          
            <div style="margin: 5px 0;"></div>
				<table id="dgAddress" class="easyui-datagrid" title="查询结果" style="height: 330px" url="${basePath}api/dealerAddress/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc">
					<thead>
						<tr>
							<th field="address" width="150" align="center" sortable="true">收货地址</th>
							<th field="postcode" width="150" align="center" sortable="true">收货地址邮编</th>
							<th field="linkman" width="150" align="center" sortable="true">收货中文名称</th>
							<th field="linkphone" width="150" align="center" sortable="true">收货人电话</th>
							<th field="del" width="100" align="center" sortable="true" formatter="formatterDel">删除</th>
						</tr>
					</thead>
				</table>
    </div>
    
	<script type="text/javascript">
	
	 	var url;

		$(function() {
			//var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			//pager.pagination(); 
		});
		
		function openDialog(dealer_id,dealer_name,dealer_code){
			 $('#dlgAddress').dialog('open').dialog('setTitle','经销商地址查询');
			 $("#show_dealer_name").val(dealer_name);
			 $("#show_dealer_code").val(dealer_code);
			 $('#fm').form('load',{dealer_id:dealer_id});
			 $('#dgAddress').datagrid({
				queryParams: {
					filter_ANDS_dealer_id : dealer_id
				}
			 });
		}
		

		
		
		 function formatterInfo (value, row, index) { 
			 	v = "'"+row.dealer_id +"','" + row.dealer_name +"','"+ row.dealer_code+"'";
			 	return '<a class="addressEditBtn" href="javascript:void(0)"  onclick="openDialog(' + v + ');" ></a>';
		} 
		 
		 function formatterDel (value, row, index) { 
			 	return '<a class="addressDelBtn" href="javascript:void(0)"  onclick="deleteEntity('+row.id+')" ></a>';
		}

		
		
		$('#dg').datagrid({
			 url : basePath + "api/dealer/paging", 
			  onLoadSuccess:function(data){ 
				  $(".addressEditBtn").linkbutton({ plain:true, iconCls:'icon-edit' });
			  }
		});

		$('#dgAddress').datagrid({
			  onLoadSuccess:function(data){ 
				  $(".addressDelBtn").linkbutton({ plain:true, iconCls:'icon-no' });
			  },onClickRow: function(rowIndex, row){
					$('#fm').form('clear');
					$('#fm').form('load',row);
				}
		});

	
		 
		 function newEntity(){
			 url = basePath + 'api/dealerAddress/save';
			 saveEntity();
		  } 

	     function updateEntity(){
	          var row = $('#dgAddress').datagrid('getSelected');
	          if (row){
	            url = basePath + 'api/dealerAddress/update';
	            saveEntity();
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
			    		 $('#fm').form('clear');
	                     $('#dgAddress').datagrid('reload');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});	
		}
		  
		  
		 function deleteEntity(id){
	            if (id){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/dealerAddress/delete',
	            				data : {id:id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dgAddress').datagrid('reload');
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
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val(),
		    	
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>