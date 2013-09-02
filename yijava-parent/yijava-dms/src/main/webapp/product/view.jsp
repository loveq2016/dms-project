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
					rownumbers="true" singleSelect="true" pagination="true" sortName="item_number" sortOrder="asc">
					<thead>
						<tr>
							<th field="item_number" width="100" sortable="true">产品编号</th>
							<th data-options="field:'cname',width:100" sortable="true">中文名称</th>
							<th data-options="field:'ename',width:100" sortable="true">英文说明</th>
							<th data-options="field:'remark',width:100">描述</th>
							<th data-options="field:'order_company',width:100">订购单位</th>
							<th data-options="field:'is_order',width:100">是否可订货</th>
							<th field="info" width="100" align="center" formatter="formatterInfo">明细</th>
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		

		
	<div id="w" class="easyui-window" title="医院详细信息" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:650px;height:400px;padding:10px;">
		<form id="ffadd" action="" method="post" enctype="multipart/form-data">
							<table>
								<tr>
									<td>医院名称:</td>
									<td><input class="easyui-validatebox" type="text" name="name" data-options="required:true"></input></td>
								
									
								</tr>
								
							</table>
		</form>
		
		<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
		</div>
	</div>
	
	

	<script type="text/javascript">
	
		$('#dg').datagrid({
		    toolbar : [{
		        text:'添加',
		        iconCls:'icon-add',
		        handler:function(){alert('add')}
		    },{
		        text:'编辑',
		        iconCls:'icon-edit',
		        handler:function(){alert('cut')}
		    },'-',{
		        text:'删除',
		        iconCls:'icon-remove',
		        handler:function(){alert('save')}
		    }]
		});
		

		
		 function formatterInfo (value, row, index) { 
			 return '<span style="color:red" onclick="aa(' + row.item_number + ');">编辑 </span>'; 
		} 

		
	    function aa(t){
	    	alert(t)
	    }
	


    
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
			
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_item_number: $('#item_number').val()
		    });
		}
		
		function newEntity()
		{
			$('#w').window('open');
		}
		
		function saveEntity()
		{
			$('#ffadd').form('submit', {
			    url:'/yijava-dms/api/hospital/save',
			    method:"post",
			   
			    onSubmit: function(){
			        // do some check
			        // return false to prevent submit;
			        return true;
			    },
			    success:function(msg){
			    	var jsonobj= eval('('+msg+')');  
			    	if(jsonobj.state==1)
			    		{
			    			clearForm();
			    			$('#w').window('close');
			    			var pager = $('#dg').datagrid().datagrid('getPager');
			    			pager.pagination('select');	
				   			
			    		}
			    }		
			});			
		}		
		function updateEntity()
		{
			

			
			
			var row = $('#dg').datagrid('getSelected');
			if (row){
			    //alert('id:'+row.id+"\nPrice:"+row.name);
			    $('#ffadd').form('load', row);
			}
			$('#w').window('open');
		}
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
			    alert('id:'+row.id+"\nPrice:"+row.name);
			}else
			{
				alert("请选中数据 ");	
			}
			
		}
		

		function clearForm(){
			$('#ffadd').form('clear');
		}
		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>