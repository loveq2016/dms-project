<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/common/head.jsp"%>
</head>
<body class="easyui-layout">	
	<div data-options="iconCls:'icon-info',region:'west',split:true,title:'公司信息'"
		style="width: 200px; padding: 10px;background: #ddd;">

								<div id="Panel1_Body" class=" ">
                            <h1>公司信息</h1>
                            <br>
                            <h1>深圳市金瑞凯利生物科技有限公司</h1>
                            
                           深圳公司地址：深圳市福田区皇岗北路彩电工业区402栋6楼<br>
                            邮编：518035<br>
                            电话：0755-83073249<br>
                            传真：0755-83073251、83197052<br>
                            &nbsp;<br>
                           
                             <h1>北京办事处地址：北京市朝阳区东三环中路39号建外SOHO西区18号楼18层1801室</h1>
                            邮编：100022 <br>
                            电话：010-59000321<br>
                            传真：010-59009006<br>
                            &nbsp;<br>
                            
                            <h1>上海办事处地址：上海市闵行区古方路18号南方商务大厦1007室</h1>
                            邮编：201102		<br>
		   电话：021-64136730<br>		
		  传真：021-64136370<br>
                            <br>
                            <h1>客服人员</h1>
                            <br>
                           北区负责人<br>
		  杨绛红：010-59000321 <br>
		  jianghong.yang@kinhely.com<br>
<br><br><br>
                          南区负责人<br>
                          潘丽美: 021-64136730 <br>
                          limei.pan@kinhely.com<br>
                            <br>
                        </div>

			
	</div>
	<div
		data-options="iconCls:'icon-remind',region:'east',split:true,collapsed:false,title:'待处理事项',tools:'#treetool'"
		style="width: 200px; padding: 10px;background: #ddd;">
			<ul id="tochecktree" class="easyui-tree" data-options="url:'${basePath}api/flowrecord/tocheck',method:'get',animate:true"></ul>
	</div>	
	<div id="mainPanle11" class="easyui-panel" data-options="iconCls:'icon-info',region:'center',title:'公告及通知',tools:'#tt'" style="background: #ddd;">		
		<div title="公告及通知" data-options="iconCls:'icon-info',closable:false" style="padding:1px;background: #ddd;overflow:hidden;" id="home">
			<div >
				<table id="dg"  title="" style="height: 610px"  method="get"
					rownumbers="false" scrollbarSize="2" singleSelect="true" pagination="true" sortName="notice_id" sortOrder="desc" toolbar="#tb">
					<thead>
						<tr>
							<th field="title" width="130" align="left" sortable="true">标题</th>
							<th field="realname" width="130" align="left" sortable="true">发布人</th>
							<th field="status_name" width="100" align="left"  sortable="true">发布状态</th>
							<th field="publish_date" width="130" align="left" formatter="formatterdate" sortable="true">发布时间</th>
							<th field="validity_date" width="120" align="left" formatter="formatterdate" sortable="true">有效期</th>
							<th field="level_name" width="100" align="left"  sortable="true">紧急程度</th>
							<th field="dealer_id" width="80" align="left"  sortable="true" formatter="formatterInfo">详细</th>							
						</tr>
					</thead>
				</table>
			</div>
		   <div id="dlgInfo" class="easyui-dialog" style="width:703px;height:450px;padding: 5px 5px 5px 5px;"
		            modal="true" closed="true">
		         <form id="fmInfo" method="post" novalidate enctype="multipart/form-data">
		         <div class="easyui-tabs" style="width:680px;height: auto;">
		         	 <div title="基本信息" style="padding: 5px 5px 5px 5px;" >
				        <div data-options="region:'center'" style="background:#fafafa;overflow:hidden">  
				         	  <table border="0">
										<tr>
											<td>重要性:</td>
											<td><input name="level_name"  type="text" required="true" style="width:80px;"/></td>
					             			<td>有效期:</td>
					             			<td><input name="validity_date" class="easyui-datebox" type="text" style="width:100px;"></td>
											<td>状态:</td>
											<td><input name="status_name" type="text" required="true" style="width:80px;"/></td>
					             	</tr>            	
					             	<tr >
					             		<td>标题:</td>
					             		<td colspan="5"><input name="title" style="width:250px" maxLength="30" class="easyui-validatebox" required="true"></td>
					             	</tr>             	
					              	<tr>
					             		<td>公告内容:</td>
					             		<td colspan="5"><textarea name="content" cols="65" style="height:220px;"></textarea></td>
					             	</tr>
					            </table>					
				        </div>  
				    </div> 
		 		</div>
		 		</form>
		   </div>
		</div>
	</div>	
	<div id="treetool">
		<a href="javascript:void(0)" class="icon-reload" onclick="javascript:checkReload();"></a>		
	</div>
	
	<div id="tt">
		<a href="javascript:void(0)" class="icon-reload" onclick="javascript:noticeReload();"></a>		
	</div>
	
<script type="text/javascript">
$(document).ready(function(){
	$('#mm1').menu();  
});
$('#tochecktree').tree({
	onClick: function(node){
		if(node.id==trialflow_identifier_num)
		{
			var tabTitle = "试用管理";
			var url = "trial/view.jsp";
			addTabByChild(tabTitle,url);
		}else if(node.id==orderflow_identifier_num)
		{
			var tabTitle = "订单管理";
			var url = "order/view.jsp";
			addTabByChild(tabTitle,url);
		}else if(node.id==pullStorageflow_identifier_num)
		{
			var tabTitle = "经销商借贷出库";
			var url = "pullstorage/loans/pullview.jsp";
			addTabByChild(tabTitle,url);
		}else if(node.id==salesStorageflow_identifier_num)
		{
			var tabTitle = "经销商医院销售出库";
			var url = "pullstorage/sales/salesview.jsp";
			addTabByChild(tabTitle,url);
		}else if(node.id==deliverflow_identifier_num)
		{
			var tabTitle = "发货管理";
			var url = "deliver/apply/view.jsp";
			addTabByChild(tabTitle,url);
		}else if(node.id==adjustStorageflow_identifier_num)
		{
			var tabTitle = "调整管理";
			var url = "storage/adjustment/view.jsp";
			addTabByChild(tabTitle,url);
		}else if(node.id==exchangedflow_identifier_num)
		{
			var tabTitle = "退换管理";
			var url = "exchanged/view.jsp";
			addTabByChild(tabTitle,url);
		}
	}
});
function checkReload()
{  
	$('#tochecktree').tree('reload');
	
}

function noticeReload()
{  
	$('#dg').datagrid('reload');
	
}


var dealer_id = ${user.fk_dealer_id};

	$('#dg').datagrid({
		  url : basePath +"api/notice/paging" ,
		  queryParams: {
				filter_ANDS_status_id : 3,
				filter_ANDS_dealer_id : dealer_id
		  },
		  onLoadSuccess:function(data){ 
			  $(".infoBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
		  }
	});
function formatterInfo(value, row, index){
	v = "'"+ row.notice_id + "','" + index+"'";
	return '<a class="infoBtn" href="javascript:void(0)"  onclick="showEntity(' + v + ')" ></a>';
}
function showEntity(notice_id,index){
	$('#dg').datagrid('selectRow',index);
	var row = $('#dg').datagrid('getSelected');
	if (row) {
		$('#dlgInfo').dialog('open').dialog('setTitle', '公告详细');
		$('#fmInfo').form('load', row);
		$.getJSON(basePath + "api/noticeDealer/update?id="+row.notice_id,function(result){});				
	}
}
</script>
</body>
</html>
