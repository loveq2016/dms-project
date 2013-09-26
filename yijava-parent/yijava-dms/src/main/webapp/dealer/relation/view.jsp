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
				<table id="dg"  title="查询结果" style="height: 430px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="dealer_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="dealer_name" width="150" align="center" sortable="true">经销商</th>
							<th field="dealer_code" width="200" align="center" sortable="true">经销商代码</th>
							<th field="category_name" width="200" align="center" sortable="true">经销商类型</th>
							<th field="authList" width="200" align="center" sortable="true" formatter="formatterAuth">授权关系</th>
						</tr>
					</thead>
				</table>
				<div id="tb">     
<!-- 				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateEntity();">编辑</a>        -->
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:500px;height:380px;padding:10px 20px"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate>
        	<input type="hidden" name="id">
        	<input type="hidden" name="dealer_id">
             <table>           	
             	<tr>
             		<td>物流经销商:</td>
             		<td>
             		<input class="easyui-combobox" name="parent_dealer_id" 
             			data-options="
	             			url:'${basePath}/api/dealerRelationFun/list',
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
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>
    
    
	
	

	<script type="text/javascript">
	 	var url;
		$('#dg').datagrid({
			url : basePath + "api/dealerRelationFun/paging",
			onLoadSuccess:function(data){ 
				 $(".authListBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			}
		});

		
		 function formatterAuth (value, row, index) { 
			 	//v = "'"+row.dealer_id +"','" + row.dealer_name +"'";
			 	return '<a class="authListBtn" href="javascript:void(0)"  onclick="updateEntity(' + index + ');" ></a>';
			 	//return '<a class="authListBtn" href="javascript:void(0)"  onclick="parent.addTab(\'['+row.dealer_name+']授权信息维护\',\''+basePath+'web/dealer/authView?dealer='+row.dealer_id+'\');" ></a>';
			 	
		} 
		 


	     function updateEntity(index){
			$('#dg').datagrid('selectRow',index);
			var row = $('#dg').datagrid('getSelected');
	          if (row){
	            $('#dlg').dialog('open').dialog('setTitle','经销商授权关系');
	            $('#fm').form('load',row);
	            url = basePath + 'api/dealerRelationFun/save';
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
			    	if(jsonobj.state==1)
			    		{
						 $('#dlg').dialog('close');     
	                     $('#dg').datagrid('reload');
			    		}
			    }		
			});	
		}
		  
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_dealer_name: $('#dealer_name').val(),
		    	filter_ANDS_dealer_code: $('#dealer_code').val()
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>