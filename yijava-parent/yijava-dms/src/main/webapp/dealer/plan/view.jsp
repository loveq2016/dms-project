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
									<td></td>
									<td>年度:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="year" id="year" data-options="required:false"></input>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div style="text-align: right; padding: 5px">
						<restrict:function funId="52">
							<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="doSearch()">查询</a>	
						</restrict:function>		   
					</div>
				</div>
			</div>

			<div style="margin: 10px 0;"></div>

			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dg" class="easyui-datagrid" title="查询结果" style="height: 510px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="100" align="center" sortable="true">经销商</th>
							<th field="dealer_code" width="100" align="center" sortable="true">经销商代码</th>
							<th field="year" width="100" align="center" sortable="true">年度</th>
							<th field="january" width="100" align="center" sortable="true">一月份</th>
							<th field="february" width="100" align="center" sortable="true">二月份</th>
							<th field="march" width="100" align="center" sortable="true">三月份</th>
							<th field="april" width="100" align="center" sortable="true">四月份</th>
							<th field="may" width="100" align="center" sortable="true">五月份</th>
							<th field="june" width="100" align="center" sortable="true">六月份</th>
							<th field="july" width="100" align="center" sortable="true">七月份</th>
							<th field="august" width="100" align="center" sortable="true">八月份</th>
							<th field="september" width="100" align="center" sortable="true">九月份</th>
							<th field="october" width="100" align="center" sortable="true">十月份</th>
							<th field="november" width="100" align="center" sortable="true">十一月份</th>
							<th field="december" width="100" align="center" sortable="true">十二月份</th>
						</tr>
					</thead>
				</table>
				<div id="tb">  
				<restrict:function funId="56">  
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a>
				</restrict:function>
				<restrict:function funId="57">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>
				</restrict:function>     
				<restrict:function funId="58">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteEntity();">删除</a>
				</restrict:function>
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:660px;height:560px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlg-buttons" enctype="multipart/form-data">
        <form id="fm" method="post" novalidate enctype="multipart/form-data">
        	<input  type="hidden" name="id">
		    <div class="easyui-panel" title="Nested Panel" style="width:635px;height:470px;padding:10px;">
		        <div class="easyui-layout" data-options="fit:true">
		            <div data-options="region:'west',split:true" style="width:300px;padding:10px">
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
			             	<tr>
			             		<td>年度:</td>
			             		<td><input name="year" style="width:150px" maxLength="10" class="easyui-numberbox" required="true"></td>
			             	</tr>
			             	</table>
		            </div>
		            <div data-options="region:'center'" style="padding:10px">
			         	  <table>
			             	<tr>
			             		<td>月份:</td>
			             		<td>金额</td>
			             	</tr>          	
			             	<tr>
			             		<td>一月份:</td>
			             		<td><input name="january" style="width:150px" maxLength="10" class="easyui-numberbox"  data-options="min:0,precision:2" required="true"></td>
			             	</tr>
			             	<tr>
			             		<td>二月份:</td>
			             		<td><input name="february" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>三月份:</td>
			             		<td><input name="march" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>
			             	<tr>
			             		<td>四月份:</td>
			             		<td><input name="april" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>五月份:</td>
			             		<td><input name="may" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>六月份:</td>
			             		<td><input name="june" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>七月份:</td>
			             		<td><input name="july" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>八月份:</td>
			             		<td><input name="august" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>九月份:</td>
			             		<td><input name="september" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>十月份:</td>
			             		<td><input name="october" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>十一月份:</td>
			             		<td><input name="november" style="width:150px" maxLength="10" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>			             	
			             	<tr>
			             		<td>十二月份:</td>
			             		<td><input name="december" style="width:150px" maxLength="30" class="easyui-numberbox" data-options="min:0,precision:2" required="true"></td>
			             	</tr>	             	
			             	</table>
		            </div>
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
			  url : basePath +"api/dealerPlan/paging" 
		});

		 function newEntity(){
		        $('#dlg').dialog('open').dialog('setTitle','经销商指标添加');
		        $('#fm').form('clear');
		        url = basePath +  'api/dealerPlan/save';
			  } 
		 
		 

	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','经销商指标更新');
	            $('#fm').form('load',row);
	            url = basePath + 'api/dealerPlan/update';
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
			    		$.messager.alert('提示','经销商指标年份重复!','warning');		
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
	            				url : basePath + 'api/dealerPlan/delete',
	            				data : {id:row.id},
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
		    	filter_ANDS_year: $('#year').val()
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>