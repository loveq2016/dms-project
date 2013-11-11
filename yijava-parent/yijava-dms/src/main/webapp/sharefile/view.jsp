<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/common/head.jsp"%>
<script type="text/javascript" src="${resPath}resource/js/auth.js"></script>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<embed id="s_simnew31"  type="application/npsyunew3-plugin" hidden="true"> </embed>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">

				<div class="easyui-panel" title="查询条件">
					<div style="padding: 10px 0 10px 60px">
						<form id="ffquery" method="post">
							<table>
								<tr>
									<td>文件名称:</td>
									<td>
										<input class="easyui-validatebox" type="text" style="width:260px;" name="filename" id="filename" data-options="required:false"></input>
									</td>
									
									<td>文件描述:</td>
									<td>
										<input class="easyui-validatebox" type="text" style="width:260px;" name="filedesc" id="filedesc" data-options="required:false"></input>
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

				<table id="dg" title="查询结果" style="height: 330px" url="${basePath}api/sharefile/paging" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="asc">
					<thead>
						<tr>
							<th data-options="field:'id',width:100"  sortable="true" hidden="true">id</th>
							<th data-options="field:'filename',width:300"  sortable="true" >文件名称</th>
							<th data-options="field:'filedesc',width:300"  sortable="true">文件描述</th>							
							<th data-options="field:'filesize',width:80" sortable="true" >文件大小(M)</th>							
							<th data-options="field:'last_date',width:200" formatter="formatterdate">最后修改日期</th>	
							
							<th data-options="field:'dd',width:100" sortable="true" formatter="formatterdownload">点击下载</th>			
						</tr>
					</thead>
				</table>

			</div>
			<div style="margin: 10px 0;"></div>
		</div>
		

		
	<div id="w" class="easyui-window" title="添加文件" data-options="modal:true,closed:true,iconCls:'icon-manage'" 
	style="width:650px;height:400px;padding:10px;">
		<form id="ffadd" action="" method="post" enctype="multipart/form-data">
							<table>													
								
								<tr height="30">
									<td>文件名称:</td>
									<td><input class="easyui-validatebox" style="width:260px;" type="text" id="filename" name="filename" data-options="required:true"></input></td>								
								</tr>
								<tr height="30">
									<td>文件描述:</td>
									<td>
									<input class="easyui-validatebox"  style="width:260px;" type="text" id="filedesc" name="filedesc" data-options="required:true"></input>
									</td>								
								</tr>
								<tr height="30">
									<td>选择文件:</td>
									<td><input  style="width:260px;" type="file" id="file" name="file"></input></td>								
								</tr>
								<input type="hidden" name="id" id="id" value="">
							</table>
		</form>
		
		<div style="text-align: right; padding: 5px">
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveEntity()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="clearForm()">取消</a>					   
		</div>
	</div>
	
	<div id="test" title="流程设计" style="top:10px;padding:1px;width:780px;height:590px;" title="Modal Window">
	<!-- <div id="test" class="easyui-window" data-options="closed:true,modal:true,title:'Test Window'" style="width:300px;height:100px;"> -->
    </div>


	<script type="text/javascript">
	
	 	var url;	 
		$('#dg').datagrid({
		    toolbar : [{
		        text:'添加',
		        iconCls:'icon-add',
		        handler:function(){
		        	newEntity();
		        	//$('#w').window('open');
				}
		    },{
		        text:'编辑',
		        iconCls:'icon-edit',
		        handler:function(){
		        	viewEntity();
				}
		    },'-',{
		        text:'删除',
		        iconCls:'icon-remove',
		        handler:function(){
		        	deleteEntity();
		        }
		    }]
		});
		

		
		 function formatterdownload(value, row, index)
		 {
			 if(row!="")
				 return '<a class="infoBtn" href="javascript:void(0)" onclick="downloadfile(\''+row.filepath+'\')">下载</a>'; 
		 }
	   
	
		function downloadfile(file)
		{
			
			var tabTitle = "文件下载 ";
			var url = basePath+"upsharefile/"+file;						
			addTabByChild(tabTitle,url);
		}

    
		$(function() {
			var pager = $('#dg').datagrid().datagrid('getPager'); // get the pager of datagrid
			pager.pagination(); 
			
		});
		
		function doSearch(){
		    $('#dg').datagrid('load',{
		    	filter_ANDS_filename:$('#ffquery input[name=filename]').val(),
		    	filter_ANDS_filedesc:$('#ffquery input[name=filedesc]').val()
		    });
		}
		
		function newEntity()
		{
			 $('#ffadd').form('clear');
	         url = basePath+'api/sharefile/save';
			$('#w').window('open');
			
		}
		
		function saveEntity()
		{
			$('#ffadd').form('submit', {
			    url:url,
			    method:"post",
			   
			    onSubmit: function(){
			        // do some check
			        // return false to prevent submit;
			        return $(this).form('validate');;
			    },
			    success:function(msg){
			    	var jsonobj= eval('('+msg+')');  
			    	if(jsonobj.state==1)
			    		{
			    			clearForm();
			    			$('#w').window('close');
			    			var pager = $('#dg').datagrid().datagrid('getPager');
			    			pager.pagination('select');	
				   			
			    		}else {
                            $.messager.show({    // show error message
                                title: 'Error',
                                msg: jsonobj.error.msg
                            });
                        } 
			    }		
			});			
		}		
		
		
		function deleteEntity()
		{
			var row = $('#dg').datagrid('getSelected');
			if (row){
				 $.messager.confirm('确定','确定要删除吗 ?',function(r){
					 if (r){
	                        $.post(basePath+'api/sharefile/remove',{entity_id:row.id},function(result){
	                        
	        			    	if(result.state==1){
	                                $('#dg').datagrid('reload');    // reload the user data
	                            } else {
	                                $.messager.show({    // show error message
	                                    title: 'Error',
	                                    msg: result.error.msg
	                                });
	                            } 
	                        },'json');
	                    }
				 });
			    
			    
			}else
			{
				$.messager.alert('提示','请选中数据!','warning');
			}
			
		}
		

		function clearForm(){
			$('#ffadd').form('clear');
		}
		
		function viewEntity()
		{
			var row = $('#dg').datagrid('getSelected');			
			if (row ){		  
			    $('#ffadd').form('load', row);	 			
			    url = basePath+'api/sharefile/update';
			    $('#w').window('open');
			}else
			{
				$.messager.alert('提示---数据已经提交不能修改','请选中数据!','warning');				
			}			
		}
		
	</script>

	
</body>
</html>