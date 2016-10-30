package cn.itcast.servlet;

import java.io.IOException;
import java.lang.reflect.Method;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class BaseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest req,
			HttpServletResponse resp) throws ServletException, IOException {
		/*
		 * 1. 获取参数，用来识别用户想请求的方法
		 * 2. 判断是哪一个方法，是哪一个调用哪一个
		 */
		String methodName = req.getParameter("method");
		if (methodName == null || methodName.trim().isEmpty()) {
			throw new RuntimeException("没有传递Method参数！");
		}
		/* 
		 * 得到方法名称，是否可通过反射来调用方法？
		 * 1. 得到方法名，通过方法名再得到Method类的对象！
		 *   * 需要得到Class，然后调用它的方法进行查询！得到Method
		 *   * 我们要查询的是当前类的方法，所以我们需要得到当前类的Class
		 */
		Class<?> c = this.getClass();
		Method method = null;
		try {
			method = c.getMethod(methodName, HttpServletRequest.class,
					HttpServletResponse.class);
		} catch (Exception e) {
			throw new RuntimeException("调用的方法" + methodName + "不存在！");
		}
		/*
		 * 调用method方法 
		 */
		try {
			String result = (String)method.invoke(this, req, resp);
			/*
			 * 获取请求处理方法执行后返回的字符串，它表示转发或重定向的路径！
			 * 帮它完成转发或重定向！
			 */
			/*
			 * 如果用户返回的是字符串为null，或为""，那么我们什么也不做！
			 */
			if (result == null || result.trim().isEmpty()){
				return ;
			}
			/*
			 * 查看返回的字符串中是否包含冒号，如果没有，表示转发
			 * 如果有，使用冒号分割字符串，得到前缀和后缀！
			 * 其中前缀如果是f，表示转发，如果是r表示重定向，后缀就是要转发或重定向的路径了！
			 */
			if (result.contains(":")) {
				// 使用冒号分割字符串，得到前缀和后缀
				int index = result.indexOf(":");
				String s = result.substring(0, index);
				String path = result.substring(index+1);
				if (s.equalsIgnoreCase("r")){
					resp.sendRedirect(req.getContextPath() + path);
				} else if (s.equalsIgnoreCase("f")) {
					req.getRequestDispatcher(path).forward(req, resp);
				} else {
					throw new RuntimeException("指定的操作" + s + "现在还不支持！");
				}
			} else {
				req.getRequestDispatcher(result).forward(req, resp);
			}
		} catch (Exception e) {
			System.out.println("调用的方法" + methodName + "内部出现异常");
			throw new RuntimeException(e);
		}
	}
	
}
