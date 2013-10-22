<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>无标题文档</title>
</head>
<%



if (request.getParameter("UserName") != null )
{
out.println("<p>");
out.println("用户名是：");
out.println(request.getParameter("UserName"));
out.println("</p>");

out.println("<p>");
out.println("密码是：");
out.println(request.getParameter("Password"));
out.println("</p>");

out.println("<p>");
out.println("锁ID是：");
out.println(request.getParameter("KeyID"));
out.println("</p>");

out.println("<p>");

}
else
{

%>
<body bgcolor="#ffffff" >
<embed id="s_simnew31"  type="application/npsyunew3-plugin" hidden="true"> </embed><!--创建firefox,chrome等插件-->

<SCRIPT LANGUAGE=javascript>

var digitArray = new Array('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');

function toHex( n ) {

        var result = ''
        var start = true;

        for ( var i=32; i>0; ) {
                i -= 4;
                var digit = ( n >> i ) & 0xf;

                if (!start || digit != 0) {
                        start = false;
                        result += digitArray[digit];
                }
        }

        return ( result == '' ? '0' : result );
}

function login_onclick() 
{
	 try
	 {
		var DevicePath,mylen,ret;
		var s_simnew31;
		//创建插件或控件
		if(navigator.userAgent.indexOf("MSIE")>0 && !navigator.userAgent.indexOf("opera") > -1)
		{
			s_simnew31=new ActiveXObject("Syunew3A.s_simnew3");
		}
		else
		{
			s_simnew31= document.getElementById('s_simnew31');
		}
		DevicePath = s_simnew31.FindPort(0);//'来查找加密锁，0是指查找默认端口的锁
		if( s_simnew31.LastError!= 0 )
		{
			window.alert ( "未发现加密锁，请插入加密锁");
		}
		else
		{
			 //'读取锁的ID
            frmlogin.KeyID.value=toHex(s_simnew31.GetID_1(DevicePath))+toHex(s_simnew31.GetID_2(DevicePath));
            if( s_simnew31.LastError!= 0 )
			{
	            window.alert( "获取用户名错误,错误码是"+s_simnew31.LastError.toString());
		        return ;
			}
			
			//获取设置在锁中的用户名
			//先从地址0读取字符串的长度,使用默认的读密码"FFFFFFFF","FFFFFFFF"
			ret=s_simnew31.YReadEx(0,1,"ffffffff","ffffffff",DevicePath);
			mylen =s_simnew31.GetBuf(0);
			//再从地址1读取相应的长度的字符串，,使用默认的读密码"FFFFFFFF","FFFFFFFF"
			frmlogin.UserName.value=s_simnew31.YReadString(1,mylen, "ffffffff", "ffffffff", DevicePath);
			if( s_simnew31.LastError!= 0 )
			{
				window.alert(  "Err to GetUserName,ErrCode is:"+s_simnew31.LastError.toString());
				return ;
			}

			//获到设置在锁中的用户密码,
			//先从地址20读取字符串的长度,使用默认的读密码"FFFFFFFF","FFFFFFFF"
			ret=s_simnew31.YReadEx(20,1,"ffffffff","ffffffff",DevicePath);
			mylen =s_simnew31.GetBuf(0);
			//再从地址21读取相应的长度的字符串，,使用默认的读密码"FFFFFFFF","FFFFFFFF"
			frmlogin.Password.value=s_simnew31.YReadString(21,mylen,"ffffffff", "ffffffff", DevicePath);
			if( s_simnew31.LastError!= 0 )
			{
				window.alert( "获取用户密码错误,错误码是:"+s_simnew31.LastError.toString());
				return ;
			}
			
			frmlogin.submit ();
		}
	  }

	 catch(e)  
	  {  
				alert(e.name + ": " + e.message+"。可能是没有安装相应的控件或插件");
				return false;
	  }  

}
</SCRIPT>


<form name="frmlogin" method="post" action="test1.jsp">
<table width="354" height="92" border="0">
  <tr>
	<b>用户登录<b>
  </tr>
   <tr>
    <td colspan="2"><input name="chkonly" type="checkbox" id="chkonly" checked>
      请插入加密锁后，再进行登录</td>
  </tr>
  <tr>
    <td width="92"></td>
    <td width="246"><input name="UserName" type="text" id="UserName" style="VISIBILITY: hidden"></td>
  </tr>
  <tr>
    
    <td><input name="Password" type="Password" id="Password" style="VISIBILITY: hidden" ></td>
  </tr>
  <tr>
  
    <td><input name="KeyID" type="text" id="KeyID" style="VISIBILITY: hidden"></td>
  </tr>

  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="Submit" value="提交" onclick="login_onclick()">
  </tr>
</table>

</form>
</body>
</html>
<%
}
%>