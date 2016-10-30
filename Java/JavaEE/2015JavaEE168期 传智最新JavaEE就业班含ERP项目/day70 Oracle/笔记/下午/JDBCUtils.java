package demo.oracle.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class JDBCUtils {
		private static String driver = "oracle.jdbc.OracleDriver";
		private static String url = "jdbc:oracle:thin:@192.168.56.101:1521:orcl";
		private static String user = "scott";
		private static String password = "tiger";
		
		static{
			try {
				Class.forName(driver);   
				//DriverManager.registerDriver(driver)
			} catch (ClassNotFoundException e) {
				throw new ExceptionInInitializerError(e);
			}
		}

		public static Connection getConnection(){
			try {
				return DriverManager.getConnection(url,user,password);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return null;
		}

		/*
		 * 运行Java程序:
		 * java -Xms100M -Xmx200M HelloWorld
		 * 
		 * 技术方向：
		 * 1. 性能调优  --> tomcat
		 * 2. 故障诊断 --> 死锁(JDK ThreadDump)
		 *              win: ctrl+break
		 *              linux: kill -3 pid
		 */
		public static void release(Connection conn,Statement st,ResultSet rs){
			if(rs!=null){
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					rs = null; //   ----> java GC
				}
			}
			if(st!=null){
				try {
					st.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					st = null;
				}
			}
			if(conn!=null){
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					conn = null;
				}
			}
		}
}












