<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.sql.*"%>
<%@ page import="bbs.Board"%>
<%@ page import="bbs.BoardDAO"%>
<%@ page import="com.Comment"%>
<%@ page import="com.CommentDAO"%>
<%@ page import="MyDb.DBconn"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<title>JS커뮤니티</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int BoardIdx = 0;
		if (request.getParameter("BoardIdx") != null) {
			BoardIdx = Integer.parseInt(request.getParameter("BoardIdx"));
		}
		if (BoardIdx == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'Board.jsp'");
			script.println("</script>");
		}
		Board bbs = new BoardDAO().getBoard(BoardIdx);
		BoardDAO dao = new BoardDAO();
		dao.UpdateHit(BoardIdx);
	%>
	<nav class="navbar navbar-default">
		<div class="naver-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JS커뮤니티</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a>
				<li class="active"><a href="board.jsp">게시판</a>
			</ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center;">리뷰 글</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%=bbs.getBoardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("/n", "<br>")%></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<td>조회수</td>
						<td colspan="2"><%=bbs.getHits() + 1%></td>
					</tr>
					<tr>
						<td>추천수</td>
						<td colspan="2"><%=bbs.getGet()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%=bbs.getWdate()%></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-algin: left;"><%=bbs.getBoardContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("/n", "<br>")%> <br> <img
							src="<%="img\\" + bbs.getBoardImg()%>"></td>
					</tr>
				</tbody>
			</table>
			<a href="board.jsp" class="btn btn-primary">목록</a> <a
				onclick="return confirm('추천 하시겠습니까?')"
				href="recommend.jsp?BoardIdx= <%=BoardIdx%>" class="btn btn-primary">추천</a>

			<%
				if (userID != null && userID.equals(bbs.getUserID())) {
			%>
			<a href="update.jsp?BoardIdx= <%=BoardIdx%>" class="btn btn-primary">수정</a>
			<a onclick="return confirm('정말로 삭제하시겠습니까?')"
				href="deleteAction.jsp?BoardIdx= <%=BoardIdx%>"
				class="btn btn-primary">삭제</a>

			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>

		</div>
		<br> <br> <br>
		<div class="row">
			<form method="post" action="CWriteAction.jsp?BoardIdx=<%=BoardIdx%>">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeee; text-align: center;">댓글
								작성</th>
						</tr>
					</thead>
					<tr>
						<td><textarea class="form-control" placeholder="글 내용"
								name="CComment" maxlength="200" style="height: 150px"></textarea></td>
					</tr>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="댓글쓰기">
			</form>
		</div>
		<br> <br>
		<%
			CommentDAO Cdao = new CommentDAO();
			if (Cdao.CommentCheck(BoardIdx) <= 1) {
		%>
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="8"
							style="background-color: #eeeeee; text-align: center;">댓글</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="1">작성자</td>
						<td colspan="3">내용</td>
						<td colspan="1">작성일자</td>
						<td colspan="1"></td>
					</tr>
					<%
						ArrayList<Comment> list = Cdao.getComment(BoardIdx);
							for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td colspan="1"><%=list.get(i).getUserID()%></td>
						<td colspan="3"><%=list.get(i).getCComment()%></td>
						<td colspan="1"><%=list.get(i).getCdate()%></td>
						<%
							if (userID != null && userID.equals(list.get(i).getUserID())) {
						%>
						<td colspan="1"><a href="Cupdate.jsp?BoardIdx= <%=BoardIdx%>&CommentIdx=<%=list.get(i).getCommentIdx()%>">수정</a>/
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="CdeleteAction.jsp?CommentIdx=<%=list.get(i).getCommentIdx()%>">삭제</a></td>
						<%
						}
							else{
								
						%>
							<td></td>
						<%
						}
						%>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
		<%
			}
		%>
	</div>
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>