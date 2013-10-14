<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
									<td>关键字:</td>
									<td>
										<input class="easyui-validatebox" type="text" name="q_text" id="q_text" data-options="required:false"></input>
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
				<table id="dg" title="查询结果" style="height: 430px"  method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="id" width="150" align="left" sortable="true">序号</th>
							<th field="q_text" width="400" align="left" sortable="true">问题</th>
							<th field="a_text" width="400" align="left" sortable="true">回答</th>
							<th field="info" width="100" align="left" formatter="formatterInfo">明细</th>
						</tr>
					</thead>
				</table>
				<div id="tb">    
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newEntity();">添加</a>    
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit"  plain="true" onclick="updateEntity();">编辑</a>  
				</div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		


   <div id="dlg" class="easyui-dialog" style="width:500px;height:380px;padding:10px 20px"
            modal="true" closed="true" buttons="#dlg-buttons">
        <form id="fm" method="post" novalidate enctype="multipart/form-data">
        	<input type="hidden" name="id">
             <table>
				<tr>
					<td>问题:</td>
                    <td><textarea name="q_text"  rows="10" cols="60" style="height:100px;"></textarea></td>
				</tr>
				<tr id="digcolumn">
					<td>回答:</td>
                    <td><textarea name="a_text" rows="10" cols="60" style="height:100px;"></textarea></td>
				</tr>          	
            </table>
        </form>
    </div>
    <div id="dlg-buttons">
        <a id="saveEntityBtn" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
    </div>
    
    
	
	

	<script type="text/javascript">
	 	var url;
	 	
		$('#dg').datagrid({
			url : basePath + "api/question/paging",
			onLoadSuccess:function(data){ 
				  $(".questionBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			 }
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_q_text: $('#q_text').val()
		    });
		}


		 function formatterInfo (value, row, index) { 
			 	v = "'"+ row.id + "','" + index+"'";
			 	return '<a class="questionBtn" href="javascript:void(0)"  onclick="openQuestion('+v+')" ></a>';
		} 
		 
		 
		 function openQuestion(id,index){
				$('#dg').datagrid('selectRow',index);
				var row = $('#dg').datagrid('getSelected');
				if (row) {
					$("#saveEntityBtn").linkbutton("disable");
					$('#fm').form('clear');
					$('#dlg').dialog('open').dialog('setTitle', '问题查看');
					$('#fm').form('load', row);			
				}
		 }
		 
		 
		 function newEntity(){
	        $('#dlg').dialog('open').dialog('setTitle','问题添加');
	        $('#fm').form('clear');
	        url = basePath + '/api/question/save';
	        $("#digcolumn").hide();
	        $("#saveEntityBtn").linkbutton("enable");
		  } 

		 
	     function updateEntity(){
	          var row = $('#dg').datagrid('getSelected');
	          if (row){
	        	  if(row.a_text==null || row.a_text==''){
	        		    $("#saveEntityBtn").linkbutton("enable");
		  	            $('#dlg').dialog('open').dialog('setTitle','问题更新');
			            $('#fm').form('load',row);
			            $("#digcolumn").hide();
			            url = basePath + 'api/question/update';
	        	  }else{
	        		  $.messager.alert('提示','问题已经被回答不能修改!','warning');		
	        	  }
	          }else{
					$.messager.alert('提示','请选中数据!','warning');				
			 }	
	     }
	     
		function saveEntity() {
			$('#fm').form('submit', {
			    url:url,
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
						 $('#dlg').dialog('close');     
	                     $('#dg').datagrid('reload');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});	
		}
		  
	

	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>