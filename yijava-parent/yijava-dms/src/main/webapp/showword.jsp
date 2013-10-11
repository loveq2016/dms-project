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
	//document.getElementById('oframe').Open("http://localhost:8080/yijava-dms/generate/trial/trial-31.doc",false);
	 //word.openDoc("trial-31.doc","http://localhost:8080/yijava-dms/generate/trial/trial-31.doc");  
}
</script>

<object   id=FileDialog   style="left:   0px;   TOP:   0px"   
classid="clsid:f9043c85-f6f2-101a-a3c9-08002b2f49fb"   codebase="http://activex.microsoft.com/controls/vb5/comdlg32.cab">   
  </object>   
  <input   type=button   value="打开Word文档"   onclick='OpenFile()'>   
  <input   type=button   value="HTML格式"   onclick='window.confirm(App.innerHTML)'>   
  <div   align=left   id=App   style="border:1   solid   #000000;background-color:#FFFFFF;height:400px;overflow:auto;width:100%;z-index:2"   contentEditable></div>   
  <script>   
  function   OpenFile()   
  {   
  try   
  {   
  FileDialog.CancelError=true;   
  FileDialog.Filter="Word模板|*.doc|Word模板|*.dot";   
  FileDialog.ShowOpen();   
  var   WordApp=new   ActiveXObject("Word.Application");   
  WordApp.Application.Visible=false;   
  var   Doc=WordApp.Documents.Open(FileDialog.filename);   
  Doc.Activate();   
  Doc.Parent.Options.InsertedTextColor=4;   
  Doc.Parent.Options.InsertedTextMark=2;   
  Doc.Parent.Options.DeletedTextColor=4;   
  Doc.Parent.Options.DeletedTextMark=1;   
  Doc.TrackRevisions=true;   
  Doc.PrintRevisions=true;   
  Doc.ShowRevisions=true;   
  Doc.Application.UserName="";   
  var   Range=Doc.Range();   
  Range.Select();   
  var   Selection=WordApp.Selection;   
  Selection.Copy();   
  App.focus();   
  document.execCommand("Paste");   
  App.focus();   
  WordApp.DisplayAlerts=false;   
  Doc.Close();   
  WordApp.DisplayAlerts=true;   
  WordApp.Quit();   
  }   
  catch(e){}   
  return   false;   
  }   
  </script>
</body>
</html>