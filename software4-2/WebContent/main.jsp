<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.BoardDAO" %>
<%@ page import = "bbs.Board" %>
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
		if (session.getAttribute("userID")  != null){
			userID = (String) session.getAttribute("userID");
		}
	%>
	<nav class="navbar navbar-default">
		<div class="naver-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JS커뮤니티</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class = "active"><a href="main.jsp">메인</a>
				<li><a href="board.jsp?pageNumber=<%=1%>">게시판</a>
			</ul>
			<%
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
				else{
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			<!-- <ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">검색 카테고리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="selectAction.jsp">제목</a></li>
						<li><a href="selectAction.jsp">내용</a></li>
						<li><a href="selectAction.jsp">제목 + 내용</a></li>
						<li><a href="selectAction.jsp">작성자</a></li>
					</ul>
				</li>
			</ul>
			<form class="navbar-form pull-right" role="search">
            <div class="input-group">
               <input type="text" class="form-control" placeholder="Search">
               <div class="input-group-btn">
                  <button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-search"></span></button>
               </div>
            </div>
        	</form> -->
		</div>
	</nav>
	<div class="container">
		<div class="row">
	<form methed = "post" action = "board.jsp">
		<input type = "submit" class = "btn btn-primary pull-right" value = "찾기">
		<input type = "text" class = "btn pull-right" placeholder = "검색" name = "boardSearch" maxlength = "50">
		<select class = "btn pull-right" name = "opt">
			<option value = "1">제목</option>
			<option value = "2">내용</option>
			<option value = "3">제목 + 내용</option>
			<option value = "4">작성자</option>
		</select>
	</form>
		</div>
		
	</div>
	<div style = "text-align : center;">
	<img src = "PieChart19.jsp">
	</div>
	<div class="container">
	<div class = "row">
	<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="text-align: center; class = "form-control">인기글</th>
					</tr>
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
						ArrayList<Board> list = boardDAO.getHitList();
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
	</div>
	</div>
	<script
		src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>