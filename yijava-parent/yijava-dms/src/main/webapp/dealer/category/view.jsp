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

				<table id="dg" title="查询结果" style="height: 430px" url="/yijava-dms/api/dealer/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="center" sortable="true">中文名称</th>
							<th field="dealer_code" width="200" align="center" sortable="true">经销商代码</th>
							<th field="business_contacts" width="200" align="center" sortable="true">商务联系人</th>
							<th field="business_phone" width="200" align="center" sortable="true">商务联系人电话</th>
							<th field="invoice_address" width="400" align="center">发票邮寄地址</th>
							<th field="invoicea_postcode" width="150" align="center">发票邮寄地址邮编</th>
							<th field="status" width="150" align="center" formatter="formatterStatus">经销商状态</th>
							<th field="attribute" width="100" align="center">经销商属性</th>
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:703px;height:450px;padding: 5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate>
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
	             		<td><input name="business_phone" style="width:250px" maxLength="10"  class="easyui-numberbox" required="true"></td>
	             	</tr>
	             	<tr>
	             		<td>财务联系人:</td>
	             		<td><input name="financial_contacts" style="width:250px" maxLength="30" class="easyui-validatebox"></td>
	             	</tr>             	
	              	<tr>
	             		<td>财务联系人电话:</td>
						<td><input name="financial_phone" style="width:250px" maxLength="10"  class="easyui-numberbox"></td>
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
	             		<td>经销商属性:</td>
	             		<td><input name="attribute" style="width:150px" maxLength="30" class="easyui-validatebox"></td>
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
						<td><input name="bm_telephone" style="width:150px" maxLength="20" class="easyui-numberbox"></td>
	             		<td>业务经理传真:</td>
						<td><input name="bm_fax" style="width:150px" maxLength="20" class="easyui-numberbox"></td>
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


		function formatterStatus (value, row, index) { 
			return value==1?"<span style='color:green'>有效</span>":"<span style='color:red'>无效</span>";
		} 
		
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
		});
		
		 
		 function newEntity(){
	        $('#dlg').dialog('open').dialog('setTitle','经销商基础信息添加');
	        $('#fm').form('clear');
	        $("input[name='status']:eq(0)").attr("checked", "checked"); 
	        url = '/yijava-dms/api/dealer/save';
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
	            
	            url = '/yijava-dms/api/dealer/update';
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
	            				url : '/yijava-dms/api/dealer/delete',
	            				data : {id:row.dealer_id},
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