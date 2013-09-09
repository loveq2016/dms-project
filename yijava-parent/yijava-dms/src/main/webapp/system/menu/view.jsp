<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/common/head.jsp"%>
</head>
		<a href="#" onclick="collapseAll()">收起</a>  
        <a href="#" onclick="expandAll()">展开</a>
		<div id="p" class="easyui-panel" title="">
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
			    <table id="treegrid"></table>
			    <div id="mm" class="easyui-menu" style="width:120px;">  
			        <div onclick="append()">添加</div>  
			        <div onclick="remove()">修改</div>  
			    </div> 
			</div>
			<div style="margin: 10px 0;"></div>
		</div>
	<script type="text/javascript">
		$(function() {
			$('#treegrid').treegrid({
                title:'菜单信息',  
                iconCls:'icon-save', 
                height:500,  
                nowrap: false,  
                rownumbers: true,  
                animate:true,  
                collapsible:true,
                url:basePath+'api/sysmenu/list',  
                idField:'id',
                treeField:'menu_name',	
                frozenColumns:[[
                    {title:'名称',field:'menu_name',width:200} 
                ]],  
                columns:[[
                    {field:'url',title:'链接',width:150},  
                    {field:'list',title:'功能',width:250,rowspan:2,
                    	formatter:function(value){
                    		var str="";
                    		if (typeof(value) != "undefined")
		                    for(var i=0;i<value.length;i++){
		                    	str+=value[i].fun_name+" ";
		                    }
                			return str;
                        }
                    },
                    {field:'remark',title:'备注',width:270,rowspan:2}
                ]],
                onContextMenu: function(e,row){  
                    e.preventDefault();  
                    $(this).treegrid('unselectAll');  
                    $(this).treegrid('select', row.id);  
                    $('#mm').menu('show', {
                        left: e.pageX,  
                        top: e.pageY  
                    });
                } 
            });
		});
		function collapseAll(){  
           var node = $('#treegrid').treegrid('getSelected');  
           if (node){
               $('#treegrid').treegrid('collapseAll', node.id);  
           } else {
               $('#treegrid').treegrid('collapseAll');  
           }  
       }  
       function expandAll(){
           var node = $('#treegrid').treegrid('getSelected');  
           if (node){  
               $('#treegrid').treegrid('expandAll', node.id);  
           } else {
               $('#treegrid').treegrid('expandAll');  
           }  
       }  
	</script>
</html>