<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BoardDAO"%>
<%@ page import="bbs.Board"%>
<%@ page import="java.io.PrintWriter"%>
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
		}
		int BoardIdx = 0 ;
		if(request.getParameter("BoardIdx")!=null){
			BoardIdx = Integer.parseInt(request.getParameter("BoardIdx").trim()/*뭔진 모르겠는데 이게 있어여 실행됌;;;; 알아보자*/);
		}
		if(BoardIdx == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다..')");
			script.println("location.href = board.jsp'");
			script.println("</script>");
		}
			Board bbs = new BoardDAO().getBoard(BoardIdx);
			BoardDAO boardDAO = new BoardDAO();
			//System.out.print(boardDAO.GetsCheck(BoardIdx, userID));
			if(boardDAO.GetsCheck(BoardIdx, userID) == 1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 추천 하였습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				int result = boardDAO.UpdateGet(BoardIdx, userID); 
				if (result == 1 ){
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("history.back()");
						script.println("</script>");
			}
		}
	%>
</body>
</html>
