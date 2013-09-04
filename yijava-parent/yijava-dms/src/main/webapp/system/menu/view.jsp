<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"	href="../../resource/themes/gray/easyui.css">
<link rel="stylesheet" type="text/css"	href="../../resource/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../../resource/css/main.css">
<script type="text/javascript" src="../../resource/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="../../resource/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../../resource/js/common.js"></script>
<script type="text/javascript" src="../../resource/locale/easyui-lang-zh_CN.js"></script>
</head>
<body LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
			    <table id="treegrid"></table>
			</div>
			<div id="mm" class="easyui-menu" style="width:120px;">  
		        <div onclick="append()">Append</div>  
		        <div onclick="remove()">Remove</div>  
		    </div>  
			<div style="margin: 10px 0;"></div>
		</div>
	<script type="text/javascript">
		$(function() {
			$('#treegrid').treegrid({
                title:'菜单名称',  
                iconCls:'icon-save', 
                height:350,  
                nowrap: false,  
                rownumbers: true,  
                animate:true,  
                collapsible:true,  
                url:'/yijava-dms/api/sysmenu/list',  
                idField:'id',
                treeField:'menu_name',	
                frozenColumns:[[
                    {title:'菜单名称',field:'menu_name',width:200} 
                ]],  
                columns:[[
                    {field:'url',title:'链接',width:150},  
                    {field:'isdeleted',title:'状态',width:220,rowspan:2,
                    	formatter:function(value){
                			return value==1?"<span style='color:green'>正常</span>":"<span style='color:red'>移除</span>";
                        }
                    },  
                    {field:'remark',title:'备注',width:150,rowspan:2}  
                ]],
                onContextMenu: function(e,row){
                    e.preventDefault();  
                    $(this).treegrid('unselectAll');  
                    $(this).treegrid('select', row.code);  
                    $('#mm').menu('show', {
                        left: e.pageX,  
                        top: e.pageY  
                    });  
                }  
            });
		});
	</script>
</body>
</html>