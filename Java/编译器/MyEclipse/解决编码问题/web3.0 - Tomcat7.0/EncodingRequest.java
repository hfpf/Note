package cn.itcast.web.filter;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

/**
 * 装饰request
 * 
 * @author li119
 *
 */
public class EncodingRequest extends HttpServletRequestWrapper {

	private HttpServletRequest request;

	public EncodingRequest(HttpServletRequest request) {
		super(request);
		this.request = request;
	}

	@Override
	public String getParameter(String name) {
		String str = request.getParameter(name);
		try {
			str = new String(str.getBytes("ISO-8859-1"), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}
		return str;
	}
}
