var digitArray = new Array('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
var keyid,pdata;
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

function LoadKey()
{
	if(navigator.userAgent.indexOf("MSIE")>0 && !navigator.userAgent.indexOf("opera") > -1){
	    s_simnew1=new ActiveXObject("Syunew3A.s_simnew3");
    }else {
		s_simnew1= document.getElementById("s_simnew31");
    }
	DevicePath = s_simnew1.FindPort(0);//'查找加密锁
	//DevicePath = s_simnew1.FindPort_2(0,1,  70967193);//'查找指定的加密锁（使用普通算法）
	if( s_simnew1.LastError!= 0 )
	{
		$('#keymsginfo').text("未发现加密锁，请插入加密锁");
		//window.alert ( "未发现加密锁，请插入加密锁");
	}else{
		//window.alert ( "发现加密锁");
		$('#keymsginfo').text("发现加密锁,正在读取数据");
		pdata=s_simnew1.GetProduceDate(DevicePath);
		if(s_simnew1.LastError !=0){ 
			$('#keymsginfo').text("发现加密锁,读取出厂编码错误");
			return ;
		}
		$("#factory_code").val(pdata);
		//alert(pdata);
		{
			//用于返回加密狗的版本号
			version = s_simnew1.GetVersion(DevicePath);
			if(s_simnew1.LastError !=0){
				
				$('#keymsginfo').text("发现加密锁,返回版本号错误");
				return ;
			}
			//window.alert("已成功返回锁的版本号:"+version);
			$("#version").val(version);
		}
			
		{
			//用于返回加密狗的扩展版本号
			versionex = s_simnew1.GetVersionEx(DevicePath);
			if(s_simnew1.LastError !=0){
				
				$('#keymsginfo').text("发现加密锁,返回扩展版本号错误");
				return ;
			}
			$("#exversion").val(versionex);
			//window.alert("已成功返回锁的扩展版本号:"+versionex);
		}
		$('#keymsginfo').text("发现加密锁,读取数据完毕，请点击保存");
	}
}

function WriteKey(value)
{
	if(navigator.userAgent.indexOf("MSIE")>0 && !navigator.userAgent.indexOf("opera") > -1){
	    s_simnew1=new ActiveXObject("Syunew3A.s_simnew3");
    }else {
		s_simnew1= document.getElementById("s_simnew31");
    }
	DevicePath = s_simnew1.FindPort(0);//'查找加密锁
	//DevicePath = s_simnew1.FindPort_2(0,1,  70967193);//'查找指定的加密锁（使用普通算法）
	if( s_simnew1.LastError!= 0 )
	{
		$('#keymsginfo').text("未发现加密锁，请插入加密锁");
		//window.alert ( "未发现加密锁，请插入加密锁");
	}else{
		//写入字符串带长度
		{
			//写入字符串带长度，,使用默认的读密码
		    InString = value;
		   
		
		    //写入字符串到地址1
		    nlen = s_simnew1.YWriteString( InString,1, "ffffffff", "ffffffff", DevicePath);
		    if( s_simnew1.LastError !=0 )
		    {
		        window.alert("写入字符串(带长度)错误。") ;return  ;
		    }
		   //写入字符串的长度到地址0
		    s_simnew1.SetBuf(nlen,0);
		    ret = s_simnew1.YWriteEx( 0, 1, "ffffffff", "ffffffff", DevicePath);
		    if( ret != 0 )
		    	{
		    		return false; //window.alert("写入字符串长度错误。错误码：" );
		    	}
		       
		    else
		    	{
		    		return true;
		    	}
		        //window.alert("写入字符串(带长度)成功");
		}
	}
}


