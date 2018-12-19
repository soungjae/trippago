package user;

import java.sql.*;
import MyDb.DBconn;

public class MemberDAO {

		private Connection conn;
		private PreparedStatement pstmt;
		private ResultSet rs;
		
		public MemberDAO() {
			try {
				
				conn = DBconn.getsqlconnection();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		public int login(String userID, String userPassword) {
			String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString(1).equals(userPassword)) {
						return 1; //�α��� ����
					}
					else
						return 0; // �α��� ����
				}
				return -1; // ���̵� ����
			}catch(Exception e){
				e.printStackTrace();
			}
			return -2; // �����ͺ��̽� ����
		}
		
		public int join(User user) {
			String SQL = "INSERT INTO USER(userID, userPassword, userName, userGender, userEmail) VALUES (?,?,?,?,?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, user.getUserID());
				pstmt.setString(2, user.getUserPassword());
				pstmt.setString(3, user.getUserName());
				pstmt.setString(4, user.getUserGender());
				pstmt.setString(5, user.getUserEmail());
				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; // �����ͺ��̽� ����
		}
}