package bbs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import MyDb.DBconn;

public class BoardDAO {

	private Connection conn;
	private ResultSet rs;

	public BoardDAO() {
		try {

			conn = DBconn.getsqlconnection();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int getNext() {
		String SQL = "SELECT BoardIdx FROM Board ORDER BY BoardIdx DESC";
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

	public int write(String userID, String BoardTitle, String BoardContent, String BoardCName, String BoardImg) {
		String SQL = "INSERT INTO Board(BoardIdx, userID, BoardTitle, BoardContent, BoardCName, BoardAvailable, BoardImg) VALUES(?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, userID);
			pstmt.setString(3, BoardTitle);
			pstmt.setString(4, BoardContent);
			pstmt.setString(5, BoardCName);
			pstmt.setInt(6, 1);
			pstmt.setString(7, BoardImg);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public ArrayList<Board> getHitList() {
		String SQL = "SELECT * FROM Board WHERE BoardAvailable = 1 ORDER BY Gets DESC LIMIT 10";
		ArrayList<Board> list = new ArrayList<Board>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Board bbs = new Board();
				bbs.setBoardIdx(rs.getInt(1));
				bbs.setUserID(rs.getString(2));
				bbs.setBoardTitle(rs.getString(3));
				bbs.setBoardContent(rs.getString(4));
				bbs.setBoardCName(rs.getString(5));
				bbs.setWdate(rs.getDate(6));
				bbs.setBoardAvailable(rs.getInt(7));
				bbs.setBoardImg(rs.getString(8));
				bbs.setHits(rs.getInt(9));
				bbs.setGet(rs.getInt(10));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Page page(int pageNumber,String opt, String boardSelect) {
		
		int  spage = pageNumber;
		int maxPage = (int)(getListCount(opt, boardSelect)/10.0 + 0.9);
		int startPage = (int)(spage/5.0 + 0.8) * 5 - 4;
		int endPage = startPage + 4;
		
		if(endPage > maxPage) endPage = maxPage;
		
		try {
			Page pg = new Page();
			pg.setSpage(spage);
			pg.setMaxPage(maxPage);
			pg.setStartPage(startPage);
			pg.setEndPage(endPage);
			return pg;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public Board getBoard(int BoardIdx) {
		String SQL = "SELECT * FROM Board WHERE BoardIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Board bbs = new Board();
				bbs.setBoardIdx(rs.getInt(1));
				bbs.setUserID(rs.getString(2));
				bbs.setBoardTitle(rs.getString(3));
				bbs.setBoardContent(rs.getString(4));
				bbs.setBoardCName(rs.getString(5));
				bbs.setWdate(rs.getDate(6));
				bbs.setBoardAvailable(rs.getInt(7));
				bbs.setBoardImg(rs.getString(8));
				bbs.setHits(rs.getInt(9));
				bbs.setGet(rs.getInt(10));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public void UpdateHit(int BoardIdx) {
		String SQL = "UPDATE Board SET Hits = Hits + 1 WHERE BoardIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			int flag = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int GetsCheck(int BoardIdx, String userID) {
		String SQL = "SELECT COUNT(*) From Gets WHERE BoardIdx = ? AND userID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			pstmt.setString(2, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				int count = rs.getInt("COUNT(*)");
				System.out.print(count);
				if(count == 1)
					return 1;
				else
					return 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int UpdateGet(int BoardIdx, String userID) {
		String SQL = "UPDATE Board SET Gets = Gets + 1 WHERE BoardIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			int flag = pstmt.executeUpdate();
			if (flag > 0) {
				SQL = "INSERT INTO Gets VALUES(?,?)";
				PreparedStatement stmt = conn.prepareStatement(SQL);
				stmt.setInt(1, BoardIdx);
				stmt.setString(2, userID);
				stmt.executeUpdate();
				return 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int update(int BoardIdx, String BoardTitle, String BoardContent, String BoardCName) {
		String SQL = "UPDATE Board SET BoardTitle =?, BoardContent = ?, BoardCName = ? WHERE BoardIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, BoardTitle);
			pstmt.setString(2, BoardContent);
			pstmt.setString(3, BoardCName);
			pstmt.setInt(4, BoardIdx);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public int delete(int BoardIdx) {
		String SQL = "UPDATE Board SET BoardAvailable = 0 WHERE BoardIdx = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, BoardIdx);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public ArrayList<Board> getSelectList(int pageNumber, String opt, String boardSelect) {
		String SQL = "SELECT * FROM Board WHERE BoardAvailable = 1 ORDER BY BoardIdx DESC LIMIT ?,?";
		String TSQL = "SELECT * FROM Board WHERE BoardTitle LIKE ? AND BoardAvailable = 1 ORDER BY BoardIdx DESC LIMIT ?,?";
		String CSQL = "SELECT * FROM Board WHERE BoardContent LIKE ? AND BoardAvailable = 1 ORDER BY BoardIdx DESC LIMIT ?,?";
		String TCSQL = "SELECT * FROM Board WHERE BoardContent LIKE ? OR BoardTitle LIKE ? AND BoardAvailable = 1 ORDER BY BoardIdx DESC LIMIT ?,?";
		String USQL = "SELECT * FROM Board WHERE userID LIKE ? AND BoardAvailable = 1 ORDER BY BoardIdx DESC LIMIT ?,?";
		ArrayList<Board> list = new ArrayList<Board>();
		try {
			if (opt == null) {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, pageNumber*10 -10);
				pstmt.setInt(2, pageNumber*10);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Board bbs = new Board();
					bbs.setBoardIdx(rs.getInt(1));
					bbs.setUserID(rs.getString(2));
					bbs.setBoardTitle(rs.getString(3));
					bbs.setBoardContent(rs.getString(4));
					bbs.setBoardCName(rs.getString(5));
					bbs.setWdate(rs.getDate(6));
					bbs.setBoardAvailable(rs.getInt(7));
					bbs.setBoardImg(rs.getString(8));
					bbs.setHits(rs.getInt(9));
					bbs.setGet(rs.getInt(10));
					list.add(bbs);
				}
			} else if (opt.equals("1")) {
				PreparedStatement pstmt = conn.prepareStatement(TSQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				pstmt.setInt(2, pageNumber*10 -10);
				pstmt.setInt(3, pageNumber*10);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Board bbs = new Board();
					bbs.setBoardIdx(rs.getInt(1));
					bbs.setUserID(rs.getString(2));
					bbs.setBoardTitle(rs.getString(3));
					bbs.setBoardContent(rs.getString(4));
					bbs.setBoardCName(rs.getString(5));
					bbs.setWdate(rs.getDate(6));
					bbs.setBoardAvailable(rs.getInt(7));
					bbs.setBoardImg(rs.getString(8));
					bbs.setHits(rs.getInt(9));
					bbs.setGet(rs.getInt(10));
					list.add(bbs);
				}
			} else if (opt.equals("2")) {
				PreparedStatement pstmt = conn.prepareStatement(CSQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				pstmt.setInt(2, pageNumber*10 -10);
				pstmt.setInt(3, pageNumber*10);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Board bbs = new Board();
					bbs.setBoardIdx(rs.getInt(1));
					bbs.setUserID(rs.getString(2));
					bbs.setBoardTitle(rs.getString(3));
					bbs.setBoardContent(rs.getString(4));
					bbs.setBoardCName(rs.getString(5));
					bbs.setWdate(rs.getDate(6));
					bbs.setBoardAvailable(rs.getInt(7));
					bbs.setBoardImg(rs.getString(8));
					bbs.setHits(rs.getInt(9));
					bbs.setGet(rs.getInt(10));
					list.add(bbs);
				}
			} else if (opt.equals("3")) {
				PreparedStatement pstmt = conn.prepareStatement(TCSQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				pstmt.setString(2, '%' + boardSelect + '%');
				pstmt.setInt(3, pageNumber*10 -10);
				pstmt.setInt(4, pageNumber*10);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Board bbs = new Board();
					bbs.setBoardIdx(rs.getInt(1));
					bbs.setUserID(rs.getString(2));
					bbs.setBoardTitle(rs.getString(3));
					bbs.setBoardContent(rs.getString(4));
					bbs.setBoardCName(rs.getString(5));
					bbs.setWdate(rs.getDate(6));
					bbs.setBoardAvailable(rs.getInt(7));
					bbs.setBoardImg(rs.getString(8));
					bbs.setHits(rs.getInt(9));
					bbs.setGet(rs.getInt(10));
					list.add(bbs);
				}
			} else if (opt.equals("4")) {
				PreparedStatement pstmt = conn.prepareStatement(USQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				pstmt.setInt(2, pageNumber*10 -10);
				pstmt.setInt(3, pageNumber*10);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Board bbs = new Board();
					bbs.setBoardIdx(rs.getInt(1));
					bbs.setUserID(rs.getString(2));
					bbs.setBoardTitle(rs.getString(3));
					bbs.setBoardContent(rs.getString(4));
					bbs.setBoardCName(rs.getString(5));
					bbs.setWdate(rs.getDate(6));
					bbs.setBoardAvailable(rs.getInt(7));
					bbs.setBoardImg(rs.getString(8));
					bbs.setHits(rs.getInt(9));
					bbs.setGet(rs.getInt(10));
					list.add(bbs);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int getListCount(String opt, String boardSelect) {
		String SQL = "SELECT COUNT(*) FROM Board";
		String TSQL = "SELECT COUNT(*) FROM Board WHERE BoardTitle LIKE ?";
		String CSQL = "SELECT COUNT(*) FROM Board WHERE BoardContent LIKE ?";
		String TCSQL = "SELECT COUNT(*) FROM Board WHERE BoardContent LIKE ? OR BoardTitle LIKE ?";
		String USQL = "SELECT COUNT(*) FROM Board WHERE userID LIKE ?";
		int result = 0;
		try {
			if(opt == null) {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				rs = pstmt.executeQuery();
			}
			else if (opt.equals("1")) {
				PreparedStatement pstmt = conn.prepareStatement(TSQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				rs = pstmt.executeQuery();
			}
			else if (opt.equals("2")) {
				PreparedStatement pstmt = conn.prepareStatement(CSQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				rs = pstmt.executeQuery();
			}
			else if (opt.equals("3")) {
				PreparedStatement pstmt = conn.prepareStatement(TCSQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				pstmt.setString(2, '%' + boardSelect + '%');
				rs = pstmt.executeQuery();
			}
			else if (opt.equals("4")) {
				PreparedStatement pstmt = conn.prepareStatement(USQL);
				pstmt.setString(1, '%' + boardSelect + '%');
				rs = pstmt.executeQuery();
			}
			if (rs.next()) {
				result = rs.getInt(1) + 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
