package cn.itcast.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/BServlet")
public class BServlet extends BaseServlet {
	private static final long serialVersionUID = 1L;
	
	public String fun1(HttpServletRequest req, HttpServletResponse resp) {
		System.out.println("fun1()....");
		return "/index.jsp";
	}
	
	public String fun2(HttpServletRequest req, HttpServletResponse resp) {
		System.out.println("fun2()....");
		return "r:/index.jsp";
	}
	
	public String fun3(HttpServletRequest req, HttpServletResponse resp) {
		System.out.println("fun3()....");
		return "f:/index.jsp";
	}
	
	public String fun4(HttpServletRequest req, HttpServletResponse resp) {
		System.out.println("fun4()....");
		return null;
	}
	
	public String fun5(HttpServletRequest req, HttpServletResponse resp) {
		System.out.println("fun5()....");
		return "d:/WEB-INF/files/a.jpg";
	}
	
}
