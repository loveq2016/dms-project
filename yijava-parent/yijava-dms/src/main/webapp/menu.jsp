<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<%-- <div style="padding: 5px;">
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
</c:forEach> --%>
<div style="padding: 5px; width: 600px;">
	<a href="javascript:void(0)" id="mb1" class="easyui-menubutton"
		data-options="menu:'#mm1',iconCls:'icon-filep'">系统管理</a>
	<a href="javascript:void(0)" id="mb2" class="easyui-menubutton"
		data-options="menu:'#mm2',iconCls:'icon-filep'">基础信息维护</a>
	<a href="javascript:void(0)" id="mb1" class="easyui-menubutton"
		data-options="menu:'#mm3',iconCls:'icon-filep'">流程管理</a> 
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
</div>
<div id="mm2" style="width: 100px;">
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="产品信息维护" url="product/view.jsp">产品信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="产品分类维护" url="productCategory/view.jsp">产品分类维护</a>
	</div>
	
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="医院信息维护"
			url="base/hospital/view.jsp">医院信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商基础信息维护" url="dealer/view.jsp">经销商基础信息维护</a>
	</div>
	<div data-options="iconCls:'icon-file'">
		<a href="javascript:void(0)" title="经销商地址信息维护" url="dealer/dealerAddress/view.jsp">经销商地址信息维护</a>
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
