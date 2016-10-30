package cn.itcast.web.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class EncodingFilter implements Filter {

	public void init(FilterConfig fConfig) throws ServletException {
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		// 处理post编码
		request.setCharacterEncoding("UTF-8");
		
		/*
		 * 处理get请求
		 */
		/*
		 * 调包request
		 * 1. 写一个request的装饰类
		 * 2. 在放行时，使用我们自己的request
		 */
		HttpServletRequest req = (HttpServletRequest) request;
		if (req.getMethod().equals("GET")) {
			EncodingRequest er = new EncodingRequest(req);
			chain.doFilter(er, response);
		} else if (req.getMethod().equals("POST")) {
			chain.doFilter(request, response);
		}
	}

	public void destroy() {
	}

}
