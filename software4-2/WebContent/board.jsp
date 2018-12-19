<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BoardDAO"%>
<%@ page import="bbs.Board"%>
<%@ page import="bbs.Page"%>
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
<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
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
			<form methed="post" action="board.jsp">
				<input type="submit" class="btn btn-primary pull-right" value="찾기">
				<input type="text" class="btn pull-right" placeholder="검색"
					name="boardSearch" maxlength="50"> <select
					class="btn pull-right" name="opt">
					<option value="1">제목</option>
					<option value="2">내용</option>
					<option value="3">제목 + 내용</option>
					<option value="4">작성자</option>
				</select>
			</form>
			<br><br>
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
						<th style="background-color: #eeeeee; text-align: center;">조회수</th>
						<th style="background-color: #eeeeee; text-align: center;">추천수</th>
					</tr>
				</thead>
				<tbody>
					<%
						BoardDAO boardDAO = new BoardDAO();
						ArrayList<Board> list = boardDAO.getSelectList(pageNumber, request.getParameter("opt"),
								request.getParameter("boardSearch"));
						String opt = request.getParameter("opt");
						String select = request.getParameter("boardSearch");
						for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td><%=list.get(i).getBoardIdx()%></td>
						<td><a
							href="view.jsp?BoardIdx=<%=list.get(i).getBoardIdx()%>"><%=list.get(i).getBoardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("/n", "<br>")%></a></td>
						<td><%=list.get(i).getUserID()%></td>
						<td><%=list.get(i).getWdate()%></td>
						<td><%=list.get(i).getHits()%></td>
						<td><%=list.get(i).getGet()%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				Page pg = boardDAO.page(pageNumber, opt, select);
				if (pg.getStartPage() != 1) {
			%>
			<a href="board.jsp?pageNumber=<%=pg.getStartPage()-1%>"
				class="btn btn-success btn-arraw-left">이전</a>
			<%
				}
				for(int i = pg.getStartPage(); i <= pg.getEndPage(); i++){
					if(i == pg.getSpage()){
			%>
					[<%=i%>]&nbsp;
			<%
					}
					else if(i != pg.getSpage()){
						if(opt == null){
			%>		
							<a href = "board.jsp?pageNumber=<%=i%>">[<%=i%>]&nbsp;</a>
			<%
						}else{
			%>		
					<a href = "board.jsp?pageNumber=<%=i%>&boardSearch=<%=select%>&opt=<%=opt%>">[<%=i%>]&nbsp;</a>
			<%
						}
					}
				}
				if (pg.getEndPage()!=pg.getMaxPage()){
			%>
			<a href="board.jsp?pageNumber=<%=pg.getEndPage()+1%>"
				class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
			
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>