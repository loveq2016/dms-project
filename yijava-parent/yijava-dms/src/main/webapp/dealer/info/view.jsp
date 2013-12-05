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
										<input class="easyui-validatebox" type="text" style="width:300px" name="dealer_name" id="dealer_code" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="22">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>		
						</restrict:function>	   
					</div>
				</div>
				
			</div>


			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">

				<table id="dg" title="查询结果" style="height: 500px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="left" sortable="true">中文名称</th>
							<th field="dealer_code" width="200" align="left" sortable="true">经销商代码</th>
							<th field="business_contacts" width="80" align="left" sortable="true">商务联系人</th>
							<th field="business_phone" width="200" align="left" sortable="true">商务联系人电话</th>
							<th field="invoice_address" width="300" align="left">发票邮寄地址</th>
							<th field="invoicea_postcode" width="150" align="left">发票邮寄地址邮编</th>
							<th field="status" width="70" align="left" formatter="formatterStatus">经销商状态</th>
							<th field="attribute" width="130" align="left" >经销商属性-供货区域</th>
							<th data-options="field:'ids',width:50" sortable="true" formatter="formatterdesc">明细</th>	
						</tr>
					</thead>
				</table>
				<div id="tb">    
					<restrict:function funId="23">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a> 
					</restrict:function>   
					<restrict:function funId="24">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>  
					</restrict:function>
					<restrict:function funId="25">   
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a>   
					 </restrict:function> 
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:703px;height:450px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate enctype="multipart/form-data">
        <input type="hidden" name="dealer_id">
         <div class="easyui-tabs" style="width:680px;height: auto;">
         	 <div title="基本信息" >
	         	  <table>
	             	<tr>
	             		<td>经销商中文名称:</td>
	             		<td><input name="dealer_name" style="width:150px" maxLength="100" class="easyui-validatebox" required="true"></td>
	             	</tr>
	              	<tr>
	             		<td>经销商代码:</td>
	             		<td><input name="dealer_code" style="width:150px" maxLength="100" class="easyui-validatebox" required="true"></td>
	             	</tr>            	
	             	<tr>
	             		<td>商务联系人:</td>
	             		<td><input name="business_contacts" style="width:250px" maxLength="30" class="easyui-validatebox" required="true"></td>
	             	</tr>             	
	              	<tr>
	             		<td>商务联系人电话:</td>
	             		<td><input name="business_phone" style="width:250px" maxLength="20"  class="" required="true"></td>
	             	</tr>
	             	<tr>
	             		<td>财务联系人:</td>
	             		<td><input name="financial_contacts" style="width:250px" maxLength="30" class="easyui-validatebox"></td>
	             	</tr>             	
	              	<tr>
	             		<td>财务联系人电话:</td>
						<td><input name="financial_phone" style="width:250px" maxLength="20"  class=""></td>
	             	</tr>    
	              	<tr>
	             		<td>发票邮寄地址:</td>
	             		<td><input name="invoice_address" style="width:150px" maxLength="100" class="easyui-validatebox"></td>
	             	</tr>  	             	
	              	<tr>
	             		<td>发票邮寄地址邮编:</td>
	             		<td><input name="invoicea_postcode" style="width:150px" maxLength="10" class="easyui-validatebox"></td>
	             	</tr> 	 
	              	<tr>
	             		<td>系统开帐日:</td>
	             		<td><input name="settlement_time" style="width:150px" class="easyui-datebox" required="true"></td>
	             	</tr> 	             	
	              	<tr>
	             		<td>经销商属性-供货区域:</td>
	             		<td><!-- <input name="attribute" style="width:150px" maxLength="30" class="easyui-validatebox"> -->
	             			 <input class="easyui-combobox" type="text" style="width:300px" name="attribute" id="attribute" data-options="required:false"></input>
	             		</td>
	             	</tr> 
	              	<tr>
	             		<td>经销商状态:</td>
	             		<td>
	             			<input type="radio" name="status"  value="1"> 是
	                		<input type="radio" name="status"  value="0"> 否
	                	</td>
	             	</tr> 	             	        	
	            </table>
         	 </div>
         	 <div title="其他信息" style="padding:10px">
         	  <table>
	             	<tr>
	             		<td>注册地址:</td>
	             		<td><input name="register_address" style="width:250px" maxLength="100" class="easyui-validatebox"></td>
	             	</tr>
	              	<tr>
	             		<td>公司类型:</td>
	             		<td><input name="company_type" style="width:150px" maxLength="50" class="easyui-validatebox"></td>
	             		<td>成立时间:</td>
	             		<td><input name="found_time" style="width:150px" class="easyui-datebox"></td>
	             	</tr>             	
	              	<tr>
	             		<td>公司法人:</td>
	             		<td><input name="corporate" style="width:150px" maxLength="50" class="easyui-validatebox"></td>
	             		<td>法人手机:</td>
	             		<td><input name="corporate_phone" style="width:150px" maxLength="20" class="easyui-numberbox"></td>
	             	</tr>             	
	              	<tr>
	             		<td>注册资金:</td>
						<td><input name="register_fund" style="width:150px" maxLength="10" class="easyui-validatebox"></td>
	             	</tr>    
	              	<tr>
	             		<td>医疗器械经营范围:</td>
	             		<td><input name="operated_scope" style="width:150px" maxLength="100" class="easyui-validatebox"></td>
	             	</tr>  	             	
	              	<tr>
	             		<td>营业地址（联系地址）:</td>
	             		<td><input name="addess" style="width:150px" maxLength="100" class="easyui-validatebox"></td>
	             	</tr> 	 
	              	<tr>
	             		<td>公司总经理姓名:</td>
	             		<td><input name="gm_name" style="width:150px" maxLength="20" class="easyui-validatebox" ></td>
	             		<td>公司总经理手机:</td>
	             		<td><input name="gm_phone" style="width:150px" maxLength="20" class="easyui-numberbox"></td>
	             	</tr> 	 
	             	<tr>
	             		<td>业务经理姓名:</td>
						<td><input name="bm_name" style="width:150px" maxLength="20" class="easyui-validatebox"></td>
	             		<td>业务经理手机:</td>
						<td><input name="bm_phone" style="width:150px" maxLength="20" class="easyui-numberbox"></td>
	             	</tr>  
	             	<tr>
	             		<td>业务经理座机:</td>
						<td><input name="bm_telephone" style="width:150px" maxLength="20" class=""></td>
	             		<td>业务经理传真:</td>
						<td><input name="bm_fax" style="width:150px" maxLength="20" class=""></td>
	             	</tr>   
	             	<tr>
	             		<td>备案往来邮箱:</td>
						<td><input name="email" style="width:150px" class="easyui-validatebox"></td>
	             	</tr>              	      	
	            </table>
         	 </div>
 		</div>
        </form>
    </div>
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>
    
    
	
	

	<script type="text/javascript">
		function formatterdesc (value, row, index) { 
			// v = "'"+ row.id + "','" + index+"'";
			 	return '<a class="questionBtn" href="javascript:void(0)"  onclick="View_Entity('+index+')" ></a>';
			 //return '<span><img src="'+basePath+'resource/themes/icons/detail.png" style="cursor:pointer" onclick="View_Entity(' + index + ');"></span>'; 
		} 
		
	
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/dealer/paging",
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
		 
		 function newEntity(){
	        $('#dlg').dialog('open').dialog('setTitle','经销商基础信息添加');
	        $('#fm').form('clear');
	        $("input[name='status']:eq(0)").attr("checked", "checked"); 
	        url = basePath +  'api/dealer/save';
	        
	        loadProvince();
		  } 

	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','经销商基础信息更新');
	            $('#fm').form('load',row);
	            
	            if(row.status==1){
	            	$("input[name='status']:eq(0)").attr("checked", "checked"); 
	            }else{
	            	$("input[name='status']:eq(1)").attr("checked", "checked"); 
	            }
	            loadProvince();
	            url = basePath + 'api/dealer/update';
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
			    		$.messager.alert('提示','经销商代码重复!','warning');		
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
	            				url : basePath + 'api/dealer/delete',
	            				data : {id:row.dealer_id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
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


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>