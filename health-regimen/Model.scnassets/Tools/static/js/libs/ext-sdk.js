window.onResume=document.createEvent("Event");window.onResume.initEvent("onResume",true,true);var HiydSdk={fnId:0,cbList:[]};HiydSdk.checkInject=function(name){if(typeof window.Hiyd!="undefined"){if(typeof Hiyd[name]=="undefined"){console.log("没有"+name+"这个方法");return false}else{return true}}else{console.log("js方法未注入！name:"+name);return false}};HiydSdk.callfn=function(){var _fnId=this.fnId++;var name=arguments[0];var param=[];for(var i=1;i<arguments.length;i++){if(typeof arguments[i]=="function"){this.cbList[_fnId]=arguments[i];arguments[i]="HiydSdk.cbList["+_fnId+"]"}param.push(arguments[i])}if(this.checkInject(name)){Hiyd[name].apply(Hiyd,param);return true}else{return false}};HiydSdk.appBridge=function(uri){var iframe=document.createElement("IFRAME");iframe.setAttribute("src",uri);document.documentElement.appendChild(iframe);iframe.parentNode.removeChild(iframe);iframe=null};HiydSdk.openLogin=function(){return this.callfn("openLogin")};HiydSdk.getUserInfo=function(callback){return this.callfn("getUserInfo",callback)};HiydSdk.getDeviceInfo=function(callback){return this.callfn("getDeviceInfo",callback)};HiydSdk.openUrl=function(url,title,needTopBar){title=title||"";needTopBar=needTopBar!==null?needTopBar:true;return this.callfn("openUrl",url,title,needTopBar)};HiydSdk.copy=function(txt){return this.callfn("copy",txt)};HiydSdk.historyBack=function(){return this.callfn("historyBack")};HiydSdk.closeWebview=function(){return this.callfn("closeWebview")};HiydSdk.setTitle=function(title){return this.callfn("setTitle",title)};HiydSdk.getNetworkType=function(callback){return this.callfn("getNetworkType",callback)};HiydSdk.shareMessage=function(title,link,desc,imgUrl){return this.callfn("shareMessage",title,link,desc,imgUrl)};HiydSdk.showLoading=function(txt){txt=txt||"正在加载中...";return this.callfn("showLoading",txt)};HiydSdk.hideLoading=function(){return this.callfn("hideLoading")};HiydSdk.showTip=function(txt,timeout){return this.callfn("showTip",txt,timeout)};HiydSdk.showErrorTip=function(txt,timeout){if(window.Ouj&&Ouj.showErrortip){OujSdk.showTip(txt,timeout)}else{return this.callfn("showErrortip",txt,timeout)}};HiydSdk.showDialog=function(txt){return this.callfn("showDialog",txt)};HiydSdk.confirm=function(txt,callback,title,buttonLables){title=title||"提醒";buttonLables=buttonLables||"确定,取消";return this.callfn("confirm",title,txt,callback,buttonLables)};HiydSdk.hideMenuButton=function(){return this.callfn("hideMenuButton")};HiydSdk.hideShare=function(){return this.callfn("hideShare")};HiydSdk.aliPay=function(platformData,callback){return this.callfn("aliPay",platformData,callback)};HiydSdk.wxPay=function(platformData,callback){if(typeof platformData=="object"){platformData=JSON.stringify(platformData)}return this.callfn("wxPay",platformData,callback)};HiydSdk.setShareInfo=function(title,link,desc,imgUrl){return this.callfn("setShareInfo",title,link,desc,imgUrl)};HiydSdk.toTaskList=function(){return this.appBridge("hiyd://toTaskList")};HiydSdk.toFeedback=function(){return this.appBridge("hiyd://toFeedback")};