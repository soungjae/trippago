package com;

import java.sql.Date;

public class Comment {
		int CommentIdx;
		int BoardIdx;
		String userID;
		String CComment;
		Date Cdate;
		public int getCommentIdx() {
			return CommentIdx;
		}
		public void setCommentIdx(int commentIdx) {
			CommentIdx = commentIdx;
		}
		public int getBoardIdx() {
			return BoardIdx;
		}
		public void setBoardIdx(int boardIdx) {
			BoardIdx = boardIdx;
		}
		public String getUserID() {
			return userID;
		}
		public void setUserID(String userID) {
			this.userID = userID;
		}
		public String getCComment() {
			return CComment;
		}
		public void setCComment(String cComment) {
			CComment = cComment;
		}
		public Date getCdate() {
			return Cdate;
		}
		public void setCdate(Date cdate) {
			Cdate = cdate;
		}
}
