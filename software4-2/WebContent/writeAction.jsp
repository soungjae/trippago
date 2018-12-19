<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BoardDAO"%>
<%@ page import="bbs.Board"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JS커뮤니티</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}else {
			String path = request.getRealPath("/img");
			
			MultipartRequest multi = new MultipartRequest(request,path,5*1024*1024,"UTF-8",new DefaultFileRenamePolicy());;
			Board board = new Board();
			board.setBoardTitle(multi.getParameter("boardTitle"));
			board.setBoardContent(multi.getParameter("boardContent"));
			board.setBoardCName(multi.getParameter("boardCName"));
			board.setBoardImg(multi.getFilesystemName("boardImg"));
			
			if (board.getBoardTitle() == null || board.getBoardCName() == null || board.getBoardContent() == null || board.getBoardImg() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				BoardDAO boardDAO = new BoardDAO();
				int result = boardDAO.write(userID, board.getBoardTitle(), board.getBoardContent(), board.getBoardCName(), board.getBoardImg());
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='board.jsp'");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>
