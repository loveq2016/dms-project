<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!-- <div style="padding: 5px;">
	<c:forEach items="${roleFunctionList}" var="fun">
		<c:if test="${fun.menu_parent_id != parent_id}">
			<a href="javascript:void(0)" id="mb1" class="easyui-menubutton" 
				data-options="menu:'#mm${fun.menu_parent_id}',iconCls:'icon-filep'" 
				title="${fun.menu_parent_name}">${fun.menu_parent_name}</a>
		</c:if>
		<c:set value="${fun.menu_parent_id}" var="parent_id"/>
	</c:forEach>
</div>
<c:set value="-1" var="parent_id"/>
<c:set value="-1" var="menu_id"/>
<c:forEach items="${roleFunctionList}" var="fun" varStatus="status">
	<c:if test="${fun.menu_parent_id != parent_id}">
		<div id="mm${fun.menu_parent_id}" style="width: 150px;">
	</c:if>
		<c:if test="${fun.menu_id != menu_id}">
			<div data-options="iconCls:'icon-file'">
				<a href="javascript:void(0)" title="${fun.menu_name}" url="${fun.menu_url}">${fun.menu_name}</a>
			</div>
		</c:if>
	<c:set value="${fun.menu_parent_id}" var="parent_id"/>
	<c:set value="${fun.menu_id}" var="menu_id"/>
	<c:if test="${roleFunctionList[status.index+1].menu_parent_id!=fun.menu_parent_id}">
		</div>
	</c:if>
</c:forEach>
<a href="${basePath}api/sys/logout">退出</a>
-->
<div style="padding: 5px; width: 1000px;">
	<a href="javascript:void(0)" id="mb1" class="easyui-menubutton"
		data-options="menu:'#mm1',iconCls:'icon-filep'">系统管理</a>
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm2',iconCls:'icon-filep'">基础信息维护</a>
	<a href="javascript:void(0)" id="mb1" class="easyui-menubutton"
		data-options="menu:'#mm3',iconCls:'icon-filep'">流程管理</a> 
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm4',iconCls:'icon-filep'">库存管理</a>
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm5',iconCls:'icon-filep'">信息查询</a>	
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm6',iconCls:'icon-filep'">订单管理</a>
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm7',iconCls:'icon-filep'">试用管理</a>
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm8',iconCls:'icon-filep'">出货管理</a>	
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm9',iconCls:'icon-filep'">采购管理</a>
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm10',iconCls:'icon-filep'">销售管理</a>
</div>
<div id="mm1" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="用户管理" url="system/user/view.jsp">用户管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="角色管理" url="system/role/view.jsp">角色管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="菜单管理" url="system/menu/view.jsp">菜单管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="菜单管理" url="system/log/view.jsp">日志管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="部门管理" url="department/view.jsp">部门管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="组织管理" url="teamlayou/view.jsp">组织管理</a>
	</div>
</div>
<div id="mm2" style="width: 100px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="医院信息维护" url="hospital/view.jsp">医院信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商基础信息维护" url="dealer/info/view.jsp">经销商基础信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商授权维护" url="dealer/auth/view.jsp">经销商授权维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商类型维护" url="dealer/category/view.jsp">经销商类型维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商指标维护" url="dealer/plan/view.jsp">经销商指标维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商基础信息维护" url="dealer/info/view.jsp">经销商基础信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商地址信息维护" url="dealer/address/view.jsp">经销商地址信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商仓库信息维护" url="dealer/storage/view.jsp">经销商仓库信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商关系管理" url="dealer/relation/view.jsp">经销商关系管理</a>
	</div>	
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="产品信息维护" url="product/view.jsp">产品信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="产品分类维护" url="productCategory/view.jsp">产品分类维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="销售人员与经销商关系维护" url="userSales/user/view.jsp">销售人员与经销商关系维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="销售人员与医院关系维护" url="userSales/hospital/view.jsp">销售人员与医院关系维护</a>
	</div>
</div>
<div id="mm3" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="用户管理" url="flow/view.jsp">流程管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="订单管理"
			url="foundation/data-dictionary/view.jsp">数据字典管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="订单管理"
			url="foundation/dictionary-category/view.jsp">字典类别管理</a>
	</div>
</div>
<div id="mm4" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="仓库维护" url="storage/view.jsp">仓库维护</a>
	</div>
</div>
<div id="mm5" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商问题列表" url="question/dealer_view.jsp">经销商问题列表</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="问题列表" url="question/view.jsp">管理员问题列表</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="公告维护" url="notice/view.jsp">公告维护</a>
	</div>
</div>
<div id="mm6" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="订单管理" url="order/view.jsp">订单管理</a>
	</div>
</div>
<div id="mm7" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="订单管理" url="trial/view.jsp">试用管理</a>
	</div>
</div>
<div id="mm8" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="发货单管理" url="deliver/apply/view.jsp">发货单管理</a>
	</div>	
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="出货管理" url="deliver/express/view.jsp">出货管理</a>
	</div>
</div>
<div id="mm9" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商采购入库" url="orderPurchase/view.jsp">经销商采购入库</a>
	</div>
</div>
<div id="mm10" style="width: 150px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="发货单管理" url="pullstorage/salesview.jsp">分销出库管理</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="发货管理" url="pullstorage/loansview.jsp">借贷出库管理</a>
</div>
