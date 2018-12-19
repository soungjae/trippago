package com;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import MyDb.DBconn;
import bbs.Board;

public class CommentDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public CommentDAO() {
		try {
			
			conn = DBconn.getsqlconnection();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int getNext() {
		String SQL = "SELECT CommentIdx FROM Comments ORDER BY CommentIdx DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;// 첫 번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int write(int BoardIdx, String userID, String CComment) {
		String SQL = "INSERT INTO Comments(CommentIdx, BoardIdx, userID, CComment) VALUES(?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setInt(2, BoardIdx);
			pstmt.setString(3, userID);
			pstmt.setString(4, CComment);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public ArrayList<Comment> getComment(int BoardIdx) {
		String SQL = "SELECT * FROM Comments WHERE BoardIdx = ?";
		ArrayList<Comment> list = new ArrayList<Comment>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Comment comment = new Comment();
				comment.setCommentIdx(rs.getInt(1));
				comment.setBoardIdx(rs.getInt(2));
				comment.setUserID(rs.getString(3));
				comment.setCComment(rs.getString(4));
				comment.setCdate(rs.getDate(5));
				list.add(comment);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int CommentCheck(int BoardIdx) {
		String SQL = "SELECT COUNT(*) FROM Comments WHERE BoardIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				int count = rs.getInt("COUNT(*)");
				System.out.print(count);
				if(count > 1)
					return 1;
				else
					return 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public Comment getCComment(int CommentIdx) {
		String SQL = "SELECT * FROM Comments WHERE CommentIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, CommentIdx);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Comment com = new Comment();
				com.setCommentIdx(rs.getInt(1));
				com.setBoardIdx(rs.getInt(2));
				com.setUserID(rs.getString(3));
				com.setCComment(rs.getString(4));
				com.setCdate(rs.getDate(5));
				return com;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int Cupdate(String CComment, int CommentIdx) {
		String SQL = "UPDATE Comments SET CComment = ? WHERE CommentIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, CComment);
			pstmt.setInt(2, CommentIdx);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int Cdelete(int CommentIdx) {
		String SQL = "DELETE FROM Comments WHERE CommentIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, CommentIdx);
			int flag = pstmt.executeUpdate();
			if(flag > 0) {
				return 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
