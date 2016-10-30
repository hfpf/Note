package demo.oracle.testdemo;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;

import org.junit.Test;

import demo.oracle.utils.JDBCUtils;

public class TestOracle {
/*
 * create or replace procedure queryempinfo(eno in number,
                                             pename out varchar2,
                                             psal       out number,
                                          pjob      out varchar2)
 */
	@Test
	public void testProcedure(){
		//{call <procedure-name>[(<arg1>,<arg2>, ...)]}
		String sql = "{call queryempinfo(?,?,?,?)}";
		Connection conn = null;
		CallableStatement call = null;
		try {
			conn = JDBCUtils.getConnection();
			call = conn.prepareCall(sql);
			 
			//对于in参数，赋值
			call.setInt(1, 7839);
			
			//对于out参数，申明
			call.registerOutParameter(2, OracleTypes.VARCHAR);
			call.registerOutParameter(3, OracleTypes.NUMBER);
			call.registerOutParameter(4, OracleTypes.VARCHAR);
			
			//调用
			call.execute();
			
			//取出结果
			String name = call.getString(2);
			double sal = call.getDouble(3);
			String job = call.getString(4);
			System.out.println(name+"\t"+sal+"\t"+job);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			JDBCUtils.release(conn, call, null);
		}
	}
	
/*
 * create or replace function queryempincome(eno in number)
return number	
 */
	@Test
	public void testFunction(){
		//{?= call <procedure-name>[(<arg1>,<arg2>, ...)]}
		String sql = "{?=call queryempincome(?)}";
		Connection conn = null;
		CallableStatement call = null;
		try {
			conn = JDBCUtils.getConnection();
			call = conn.prepareCall(sql);
			 
			//对于out参数，申明
			call.registerOutParameter(1, OracleTypes.NUMBER);
			
			//对于in参数，赋值
			call.setInt(2, 7839);			
			//调用
			call.execute();
			
			//取出结果
			double income = call.getDouble(1);
			System.out.println(income);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			JDBCUtils.release(conn, call, null);
		}		
		
	}
	
	@Test
	public void testCursor(){
		String sql = "{call MYPACKAGE.queryEmpList(?,?)}";
		Connection conn = null;
		CallableStatement call = null;
		ResultSet rs = null;
		try {
			conn = JDBCUtils.getConnection();
			call = conn.prepareCall(sql);
			
			//设置部门号
			call.setInt(1, 20);
			
			//申明out
			call.registerOutParameter(2, OracleTypes.CURSOR);
			
			//执行
			call.execute();
			
			//取出结果
			rs = ((OracleCallableStatement)call).getCursor(2);
			while(rs.next()){
				String name = rs.getString("ename");
				double sal = rs.getDouble("sal");
				System.out.println(name+"\t"+sal);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			JDBCUtils.release(conn, call, rs);
		}	
	}
}








