<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/common/base.jsp"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>海利欧斯经销商管理系统</title>
<link rel="stylesheet" type="text/css" href="${resPath}css/css.css">
<link rel="stylesheet" type="text/css"	href="${resPath}resource/themes/gray/easyui.css">

<script type="text/javascript" src="${resPath}resource/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="${resPath}resource/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${resPath}resource/js/common.js"></script>
<script type="text/javascript" src="${resPath}resource/locale/easyui-lang-zh_CN.js"></script>
<script src="${resPath}js/jquery.cycle.all.min.js"></script>
<script src="${resPath}js/index.js"></script>
<script type="text/javascript" src="${resPath}resource/js/common.js"></script>
</head>

<body  onkeydown="on_return();">
<div class="top"><a href="#"><img src="images/logo.jpg"></a></div>
<div class="page">
  <div class="main">
    <h1 class="title">海利欧斯经销商管理系统</h1>
    <div class="left">
      <form id="ffadd" action="" method="post" enctype="multipart/form-data">
        <div class="formline">
          <label>User ID/系统登陆账号：</label>
          <input type="text" class="ipt" value="" name="account" value="admin">
        </div>
        <div class="formline">
          <label>Password/密码：</label>
          <input type="password" class="ipt" value="" name="password" value="111111">
        </div>
        <div class="formline">
          <label>Validation Code/验证码：</label>
          <input type="text" class="ipt code" value="" name="captcha" onkeydown="on_return();">&nbsp;&nbsp;
          <img id="captchaImg" src="getCaptcha" width="84" height="32"  align="absmiddle" style="cursor:hand" onclick="javascript:reloadValidateCode();" title="看不请?点击刷新"/>
          <!-- <img src="images/code.gif" width="84" height="32"> <a href="javascript:reloadValidateCode();">看不请?</a>--><div id="loading_img" width="16" height="11" ></div>
        </div>
        
        <div class="formline">
        	
          <input type="button" name="loginbtn" id="loginbtn" value="Login/登录" class="btn" onclick="login()">
        </div>
      </form>
      <p>支持热线：+86-10-59000321</p>
      <p>支持邮箱：</p>
      <p>版权所有：深圳市金瑞凯利生物科技有限公司</p>
    </div>
    <div id="focus">
    	<ul class="focus">
        	<li><a href="#"><img src="images/img.jpg" width="509" height="388"></a></li>
        	<li><a href="#"><img src="images/img.jpg" width="509" height="388"></a></li>
        	<li><a href="#"><img src="images/img.jpg" width="509" height="388"></a></li>
        	<li><a href="#"><img src="images/img.jpg" width="509" height="388"></a></li>
        </ul>
    </div>
  </div>
</div>
<div class="footer">主办单位：深圳市金瑞凯利生物科技有限公司 粤ICP备09108850号-1</div>
<script type="text/javascript">
		function login() {
			$("#loginbtn").attr('disabled',true);
			$.ajax({
				type : "POST",
				url : basePath+"api/sys/login",
				data : $('#ffadd').serialize(),
				error : function(request) {
					$.messager.alert('提示',error,'error');
				},
				beforeSend:StartRequest,
				success:function(msg){
					var jsonobj= eval('('+msg+')'); 
					if(jsonobj.state=='0'){
						
						$('#loginbtn').removeAttr("disabled"); 
				   		$.messager.alert('提示',jsonobj.error.msg,'warning');	
				   		EndResponse();
				   		
				   	}else{
				   		location.href ="main.jsp";
				   	}			
					
				}	
			});
		}
		
		function StartRequest(){
				$('#loginbtn').attr('disabled',"true");
				
			   $('#loading_img').html('<img src="images/ajloading.gif"  width="16" height="11" />');
		}
		function EndResponse(data){
			$('#loginbtn').removeAttr("disabled"); 
			   $('#loading_img').html("");
			}
		function reloadValidateCode() {
			$("#captchaImg").attr("src","getCaptcha?date = " + new Date() + Math.floor(Math.random()*24));
		}
		
		function on_return(){
			  if(window.event.keyCode == 13){
			   if (document.all('loginbtn')!=null){
			      document.all('loginbtn').click();
			      }
			  }
		}
	</script>
</body>
</html>
