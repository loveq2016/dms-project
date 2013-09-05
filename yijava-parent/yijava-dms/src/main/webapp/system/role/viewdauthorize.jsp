<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
		<input type="hidden" value="${roleid}" id="roleid" />
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
		var i = $("#roleid").val(); 
		$('#treegrid').treegrid({
            title:'菜单信息',  
            iconCls:'icon-save', 
            height:500,  
            nowrap: false,  
            rownumbers: true,  
            animate:true,  
            collapsible:true,  
            url:'/yijava-dms/api/fun/list?roleid='+i,  
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
                {field:'isdeleted',title:'状态',width:50,rowspan:2,
                	formatter:function(value){
            			return value==1?"<span style='color:green'>移除</span>":"<span style='color:red'>正常</span>";
                    }
                },  
                {field:'remark',title:'备注',width:270,rowspan:2}
            ]]
        });
		function collapseAll(){  
            var node = $('#treegrid').treegrid('getSelected');  
            if (node){  
                $('#treegrid').treegrid('collapseAll', node.code);  
            } else {  
                $('#treegrid').treegrid('collapseAll');  
            }  
        }  
        function expandAll(){  
            var node = $('#test').treegrid('getSelected');  
            if (node){  
                $('#treegrid').treegrid('expandAll', node.code);  
            } else {  
                $('#treegrid').treegrid('expandAll');  
            }  
        }  
	});
	</script>