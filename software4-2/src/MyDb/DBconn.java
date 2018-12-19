package MyDb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBconn {
	public static Connection getsqlconnection() {
		Connection conn  = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			
			String url = "jdbc:mysql://localhost:3306/web?characterEncoding=UTF-8&serverTimezone=UTC";
			String user = "root";
			String passward = "9469dkssud";
			
			conn = DriverManager.getConnection(url, user, passward);
		
		}catch(ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		
		return conn;
		
	}
	
	public static void close(Connection conn) {
		try {
			if(conn != null)
				conn.close();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
}