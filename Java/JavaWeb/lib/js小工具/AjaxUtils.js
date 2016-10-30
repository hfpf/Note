// 创建ajax对象
function createXMLHttpRequest() {
	try {
		return new XMLHttpRequest();
	} catch (e) {
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				throw e;
			}
		}
	}
}
/**
 * 参数：请求方式, 请求url, 是否异步, 请求体, 回调方法, 服务器响应参数的类型
 * method, url, asyn, params, callback, type
 */
function ajax(option) {
	/*
	 * 1. 得到xmlHttp
	 */
	var xmlHttp = createXMLHttpRequest();
	/*
	 * 2. 打开连接
	 */
	if (!option.method) { //默认为GET请求
		option.method = "GET";
	}
	if (option.asyn == undefined) { //默认为GET请求
		option.asyn = true;
	}
	xmlHttp.open(option.method, option.url, option.asyn);
	/*
	 * 3. 判断是否为POST
	 */
	if ("POST" == option.method) {
		xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	}
	/*
	 * 4. 发送请求
	 */
	xmlHttp.send(option.params);
	/*
	 * 5. 注册监听
	 */
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {	//双重判断
			// 获取服务器的响应数据，进行转换！
			if (!option.type) { // type默认为文本
				data = xmlHttp.responseText;
			} else if (option.type == "xml") {
				data = xmlHttp.responseXML;
			} else if (option.type == "text") {
				data = xmlHttp.responseText;
			} else if (option.type == "json") {
				var text = xmlHttp.responseText;
				data = eval("(" + text + ")");
			}
			
			// 调用回调方法
			option.callback(data);
		}	
	};
}
