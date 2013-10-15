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
				<table id="dgProduct" class="easyui-datagrid" title="查询结果" style="height:230px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc"  toolbar="#tbProduct"
						data-options="onClickRow:onClickProductRow">
					<thead>
						<tr>
							<th field="product_category_id" width="150" align="center" sortable="true" data-options="
									formatter:function(value,row){
                            			return row.category_name;
                            		}
                            	">产品分类</th>
							<th field="product_remark" width="150" align="center" editor="text" sortable="true">产品描述</th>
							<th field="area_remark" width="150" align="center" editor="text" sortable="true">授权区域描述</th>
							<th field="status" width="150" align="center" sortable="true" 
									data-options="
									editor:{type:'checkbox',options:{on:'1',off:'0'}},
									formatter: function(value,row,index){
										return value==1? '<span style=\'color:green\'>有效</span>':'<span style=\'color:red\'>无效</span>';
									}">是否有效</th>
							<restrict:function funId="40">
								<th field="discountList" width="200" align="center" sortable="true" formatter="formatterDiscount">产品价格折扣授权列表</th>
							</restrict:function>
						</tr>
					</thead>
				</table>
				<div id="tbProduct">    
					<restrict:function funId="34">
				   	 	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newProductEntity();">新增授权</a> 
				   	</restrict:function>  
				   <restrict:function funId="35">
				   	 	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  plain="true" onclick="updateProductEntity();">编辑</a>     
				   </restrict:function>
				   <restrict:function funId="36">
				    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeProductEntity();">删除</a>   
				    </restrict:function>
				</div> 	
			</div>
			<div style="margin: 10px 0;"></div>
			<div style="padding-left: 10px; padding-right: 10px">
				<table id="dgHospital" class="easyui-datagrid" title="包含医院" style="height: 350px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbHospital">
					<thead>
						<tr>
							<th field="hospital_name" width="250" align="left" sortable="true">医院名称</th>
							<th field="hostpital_category" width="100" align="left" sortable="true">医院分类</th>
							<th field="level_name" width="100" align="left" sortable="true">等级</th>
							<th field="provinces" width="200" align="left" sortable="true">省份</th>
							<th field="area" width="100" align="left" sortable="true">地区</th>
							<th field="city" width="100" align="left" sortable="true">县市(区)</th>
							<th field="address" width="300" align="left" sortable="true">地址</th>
						</tr>
					</thead>
				</table>
				<div id="tbHospital">    
					<restrict:function funId="34">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newHospitalEntity();">选择医院</a>   
					</restrict:function> 
					<restrict:function funId="34">
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeHospitalEntity();">删除医院</a>  
					</restrict:function>
					<restrict:function funId="34">  
					    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeAllHospitalEntity();">全部删除</a>  
					 </restrict:function> 
				</div> 	
			</div>			
		</div>

       <div id="dlgProducr" class="easyui-dialog" style="width:360px;height:260px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProducr-buttons">
	        <form id="fm" method="post" novalidate enctype="multipart/form-data">
	        	<input type="hidden" name="id">
	        	<input type="hidden" name="dealer_id" id="product_dealer_id">
				       <table>
				              	<tr>
				             		<td>产品分类:</td>
				             		<td>
					                <input id="cc" name="product_category_id" class="easyui-combotree"  value=""  required="true" editable="false" style="width:200px;"
					                	data-options="
					                			url: '${basePath}/api/productCategory/list',
												method: 'get',
												lines: true,
												onClick : function(node){
												    var tree = $(this).tree;  
													isLeaf = tree('isLeaf', node.target);
													if(!isLeaf){
														$('#cc').combotree('clear');
													}else{
														$('#cc').combotree('setValue', node.id);  
													}	
						            			}" >  
				                	</td>
				             	</tr>           	
				             	<tr>
				             		<td>产品描述:</td>
				             		<td><input name="product_remark" class="easyui-validatebox" style="width:150px" maxLength="100" ></td>
				             	</tr>
				        		<tr>
				             		<td>区域描述:</td>
				             		<td><input name="area_remark" class="easyui-validatebox" style="width:150px" maxLength="100" ></td>
				             	</tr>    
				              	<tr>
				             		<td>是否有效:</td>
				             		<td>
				             			<input type="radio" name="status"  value="1"> 是
				                		<input type="radio" name="status"  value="0"> 否
				                	</td>
				             	</tr> 					             	
				        </table>        	
	        </form>
    </div>
    <div id="dlgProducr-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveProductEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgProducr').dialog('close')">取消</a>
    </div>
    
    
     <div id="dlgHospital" class="easyui-dialog" style="width:850px;height:580px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgProducr-buttons">
	       					<div class="easyui-panel" title="查询条件" style="width:800px;">
								<div style="padding: 10px 0 0 10px">
									<form id="ffdetail" method="post">
										<table>
											<tr>
												<td>医院名称:</td>
												<td>
													<input class="easyui-validatebox" type="text" name="hospital_name" id="hospital_name" data-options="required:false"></input>
												</td>
												<td>医院等级:</td>
												<td>
													<input class="easyui-combobox" name="level_id"  id="level_id"  style="width:150px" maxLength="100" 
													class="easyui-validatebox" required="true"
										             			data-options="
											             			url:'${basePath}/api/hospitalLevel/list',
												                    method:'get',
												                    valueField:'id',
												                    textField:'level_name',
												                    panelHeight:'auto',
												                    required:false
										            			">
										            			
												</td>
											
												<td>省份:</td>
												<td>
													<input class="easyui-combobox" type="text" name="provinces" id="provinces" data-options="
											             			url:'${basePath}/api/hospital/getprovince_api',
												                    method:'get',
												                    valueField:'province',
												                    textField:'province',
												                    panelHeight:'auto',
												                    required:false
										            			"></input>
												</td>
												</tr>	
												<tr>	
												<td>地区:</td>
												<td>
													<input class="easyui-validatebox" type="text" name="area" id="area" data-options="required:false"></input>
												</td>
												<td>县市(区):</td>
												<td>
													<input class="easyui-validatebox" type="text" name="city" id="city" data-options="required:false"></input>
												</td>
												
												<td>地址:</td>
												<td>
													<input class="easyui-validatebox" type="text" name="address" id="address" style="width:300px" data-options="required:false"></input>
												</td>
											</tr>								
									</table>
									</form>
								</div>
								<div style="text-align: right; padding:5px">
									<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="doSearchHospital()">查询</a>   
								</div>
							</div>	
	        	
						       <table id="tablehospital" title="查询结果" style="height:350px;width:800px" method="get"
										rownumbers="true" singleSelect="false" pagination="true" sortName="id" sortOrder="desc" toolbar="">
											<thead>
												<tr>
												<th field="id" width="280" align="left" sortable="true" hidden="true">id</th>	
												<th field="hospital_name" width="280" align="left" sortable="true">医院名称</th>										
												<th field="level_name" width="50" align="left" sortable="true">等级</th>
												<th field="provinces" width="120" align="left" sortable="true">省份</th>										
												<th field="address" width="300" align="left" sortable="true">地址</th>										
												</tr>
											</thead>
							 </table>	
	        </form>
    </div>
    <div id="dlgProducr-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveHospitalEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgHospital').dialog('close')">取消</a>
    </div>
    
    
    
     <div id="dlgDiscount" class="easyui-dialog" style="width:660px;height:460px;padding:5px 5px 5px 5px;"
            modal="true" closed="true">
				<table id="dgDiscount" class="easyui-datagrid" title="" style="height: 400px" method="get"
					rownumbers="true" singleSelect="true" pagination="true" sortName="id" sortOrder="desc" toolbar="#tbDiscount">
					<thead>
						<tr>
							<th field="cname" width="250" align="center" sortable="true">产品名称</th>
							<th field="models" width="250" align="center" sortable="true">规格型号</th>
							<th field="discount" width="100" align="center" sortable="true">折扣</th>
						</tr>
					</thead>
				</table>
				<div id="tbDiscount">    
				<restrict:function funId="41">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newDiscountEntity();">新增产品</a>    
				 </restrict:function>  
				 <restrict:function funId="42">
				    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeDiscountEntity();">删除</a> 
				 </restrict:function>   
				</div> 
    </div>
     <div id="dlgDiscountForm" class="easyui-dialog" style="width:360px;height:260px;padding:5px 5px 5px 5px;"
            modal="true" closed="true" buttons="#dlgDiscount-buttons">
	        <form id="fm3" method="post" novalidate enctype="multipart/form-data">
	        	<input type="hidden" name="id">
	        	<input type="hidden" name="dealer_id" id="discount_dealer_id">
				       <table>
				              	<tr>
				             		<td>产品:</td>
				             		<td><input class="easyui-combobox" id="ccd" name="item_number"  style="width:150px" maxLength="100" required="true"></td>
				             	</tr>  
					             <tr>
				             		<td>折扣:</td>
				             		<td><input name="discount" class="easyui-numberbox" style="width:150px" min="1" max="99999999" precision="2" required="true"></td>
				             	</tr>  			             					             	
				        </table>        	
	        </form>
    </div>
    <div id="dlgDiscount-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveDiscountEntity();">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgHospital').dialog('close')">取消</a>
    </div>
    

    
    

	<script type="text/javascript">
	
	 	var url;
	 	var dealer_id = ${dealer};
		var category_id;
		$('#dgProduct').datagrid({
			  url : basePath +"api/dealerAuthProduct/paging" ,
			  queryParams: {
					filter_ANDS_dealer_id : dealer_id
			 },
			  onLoadSuccess:function(data){ 
				  $(".discountListBtn").linkbutton({ plain:true, iconCls:'icon-manage' });
			  }
		});
		
		
		function formatterDiscount (value, row, index) { 
			 	v = "'"+row.product_category_id +"','" + row.category_name +"'";
			 	//return '<a class="authListBtn" href="javascript:void(0)"  onclick="openDialog(' + v + ');" ></a>';
			 	return '<a class="discountListBtn" href="javascript:void(0)"  onclick="showDiscount('+v+')" ></a>';
			 	
		} 
		
		function showDiscount(category_id,category_name){
			 $('#dlgDiscount').dialog('open').dialog('setTitle',"["+category_name+']授权产品折扣');
			 $('#dgDiscount').datagrid({
				    url : basePath + "api/dealerAuthDiscount/paging",
					queryParams: {
						filter_ANDS_dealer_id : dealer_id,
						filter_ANDS_category_id : category_id
					}
			});		
		}
		
		
		function newDiscountEntity(){
	        $('#dlgDiscountForm').dialog('open').dialog('setTitle','授权产品折扣添加');
	        $('#fm3').form('clear');
	        $("#discount_dealer_id").val(dealer_id);
	        $('#ccd').combobox({
	            url:basePath + '/api/product/list?category_id='+category_id,
	            valueField:'item_number',
	            textField:'cname',
	            panelHeight:'auto'
	        });
	        
	        url = basePath +  'api/dealerAuthDiscount/save';      			
		}
		
		
		function saveDiscountEntity(){
			$('#fm3').form('submit', {
			    url:url,
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');;
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
						$('#dlgDiscountForm').dialog('close');     
	                    $('#dgDiscount').datagrid('reload');
			    	}else if(jsonobj.state==2){
			    		$.messager.alert('提示','产品重复!','warning');				
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});				
		}
		
		
		function removeDiscountEntity(){
	           var row = $('#dgDiscount').datagrid('getSelected');
	            if (row){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/dealerAuthDiscount/delete',
	            				data : {id:row.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dgDiscount').datagrid('reload');
	            					}else{
	            						$.messager.alert('提示','Error!','error');	
	            					}
	            				}
	            			});                    	
	                    }
	                });
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }			
			
		}
		
		
		 

	    function onClickProductRow(rowIndex, rowData){
	    	category_id = rowData.product_category_id;
			 $('#dgHospital').datagrid({
				    url : basePath + "api/dealerAuthHospital/paging",
					queryParams: {
						filter_ANDS_dealer_id : rowData.dealer_id,
						filter_ANDS_category_id : rowData.product_category_id
					}
			});
	    }
	    
	    
        function newProductEntity(){
	        $('#dlgProducr').dialog('open').dialog('setTitle','授权属性添加');
	        $('#fm').form('clear');
	        $("input[name='status']:eq(0)").attr("checked", "checked"); 
	        $("#product_dealer_id").val(dealer_id);
	        url = basePath +  'api/dealerAuthProduct/save';       	
        }
        
	     function updateProductEntity(){
	          var row = $('#dgProduct').datagrid('getSelected');
	          if (row){
	            $('#dlgProducr').dialog('open').dialog('setTitle','授权属性更新');
	            $('#fm').form('load',row);
			    $('#cc').combotree('setValue',row.product_category_id);
		        $('#cc').combotree('setText',row.category_name);
	            url = basePath + 'api/dealerAuthProduct/update';
	          }else{
					$.messager.alert('提示','请选中数据!','warning');				
			 }	
	     }
	     
		function saveProductEntity() {
				$('#fm').form('submit', {
				    url:url,
				    method:"post",
				    onSubmit: function(){
				        return $(this).form('validate');
				    },
				    success:function(msg){
				    	var jsonobj = $.parseJSON(msg);
				    	if(jsonobj.state==1){
							$('#dlgProducr').dialog('close');     
		                    $('#dgProduct').datagrid('reload');
		                    $('#dgHospital').datagrid('loadData', { total: 0, rows: [] });
				    	}else{
				    		$.messager.alert('提示','Error!','error');	
				    	}
				    }		
				});	
		}
	     
		 function removeProductEntity(){
	           var row = $('#dgProduct').datagrid('getSelected');
	            if (row){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/dealerAuthProduct/delete',
	            				data : {id:row.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dgProduct').datagrid('reload');
	            					}else{
	            						$.messager.alert('提示','Error!','error');	
	            					}
	            				}
	            			});                    	
	                    }
	                });
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
	        }
		 
		 

        function newHospitalEntity(){
        	if(category_id){
    	        $('#dlgHospital').dialog('open').dialog('setTitle','授权医院添加');
    	        
    	        //加载医院
    	        $('#tablehospital').datagrid({
					 url:basePath+'api/hospital/paging',
					 pageSize:10,					 
					 pageList: [10, 20, 30], 
				});
    	        
    	        
    	        $('#fm2').form('clear');
    	        $("#hospital_dealer_id").val(dealer_id);
    	        $("#hospital_category_id").val(category_id);
    	        url = basePath +  'api/dealerAuthHospital/save';           		
        	}else{
				$.messager.alert('提示','请选中数据!','warning');				
			 }	
        }
        
        function saveHospitalEntity(){
        	
        	var ids = [];
        	var rows = $('#tablehospital').datagrid('getSelections');
        	for(var i=0; i<rows.length; i++){
        		    ids.push(rows[i].id);
        	}
        	var idstr=ids.join(',');
        	if(idstr!=",")
        		{
	        		$.ajax({
	    				type : "POST",
	    				url : basePath + 'api/dealerAuthHospital/save',
	    				data : {ids:idstr,dealer_id:dealer_id,category_id:category_id},
	    				
	    				success : function(data) {
	    					var jsonobj = $.parseJSON(data);
	    					if (jsonobj.state == 1) {  
	    						$('#dlgHospital').dialog('close');     
	   						 	$('#dgHospital').datagrid('reload');
	    					}else{
	    						$.messager.alert('提示',jsonobj.error.msg,'Error!');	
	    					}
	    				}
	    			});                
        		}
			/* $('#fm2').form('submit', {
			    url:url,
			    method:"post",
			    onSubmit: function(){
			        return $(this).form('validate');;
			    },
			    success:function(msg){
			    	var jsonobj = $.parseJSON(msg);
			    	if(jsonobj.state==1){
						$('#dlgHospital').dialog('close');     
						 $('#dgHospital').datagrid('reload');
			    	}else{
			    		$.messager.alert('提示','Error!','error');	
			    	}
			    }		
			});	     */   	
        }
        
        
        function removeHospitalEntity(){
	           var row = $('#dgHospital').datagrid('getSelected');
	            if (row){
	                $.messager.confirm('Confirm','是否确定删除?',function(r){
	                    if (r){
	            			$.ajax({
	            				type : "POST",
	            				url : basePath + 'api/dealerAuthHospital/delete',
	            				data : {id:row.id},
	            				error : function(request) {
	            					$.messager.alert('提示','Error!','error');	
	            				},
	            				success : function(data) {
	            					var jsonobj = $.parseJSON(data);
	            					if (jsonobj.state == 1) {  
	            	                     $('#dgHospital').datagrid('reload');
	            					}else{
	            						$.messager.alert('提示','Error!','error');	
	            					}
	            				}
	            			});                    	
	                    }
	                });
	            }else{
					$.messager.alert('提示','请选中数据!','warning');				
				 }	
        }
        
        function removeAllHospitalEntity(){
        	if(category_id){
                $.messager.confirm('Confirm','是否确定删除?',function(r){
                    if (r){
            			$.ajax({
            				type : "POST",
            				url : basePath + 'api/dealerAuthHospital/deleteAll',
            				data : {dealer_id : dealer_id, category_id : category_id},
            				error : function(request) {
            					$.messager.alert('提示','Error!','error');	
            				},
            				success : function(data) {
            					var jsonobj = $.parseJSON(data);
            					if (jsonobj.state == 1) {  
            	                     $('#dgHospital').datagrid('reload');
            					}else{
            						$.messager.alert('提示','Error!','error');	
            					}
            				}
            			});                    	
                    }
                });        		
        	}else{
        		$.messager.alert('提示','请选中数据!','warning');				
        	}

        }

		


        function doSearchHospital(){
		    $('#tablehospital').datagrid('load',{
		    	filter_ANDS_hospital_name: $('#hospital_name').val(),
		    	filter_ANDS_level_id: $('#level_id').combobox('getValue'),
		    	filter_ANDS_provinces: $('#provinces').combobox('getValue'),
		    	filter_ANDS_area: $('#area').val(),
		    	filter_ANDS_city: $('#city').val(),
		    	filter_ANDS_address: $('#address').val()
		    });
		}
		
		
		


		
		
	</script>

	<script type="text/javascript"> 
		
</script>
</body>
</html>