<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script language="javascript" src="js/dsoframer.js"></script>  
</head>
 <body onload="load();" >    
<script type="text/javascript">


function load(){  
	document.getElementById('oframe').Open("http://localhost:8080/yijava-dms/generate/trial/trial-31.doc",false);
	 //word.openDoc("trial-31.doc","http://localhost:8080/yijava-dms/generate/trial/trial-31.doc");  
}
</script>

<object classid="clsid:00460182-9E5E-11d5-B7C8-B8269041DD57" codebase="dsoframer.ocx" id="oframe" width="100%" height="100%">  
         <param name="BorderStyle" value="1">  
         <param name="TitlebarColor" value="52479">  
         <param name="TitlebarTextColor" value="0">    
       </object>  
</body>
</html>