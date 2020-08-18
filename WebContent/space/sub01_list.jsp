<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>

<%
//파일의 db접근
FileDAO fDAO = new FileDAO(application);
FileDTO fDTO = new FileDTO();
List<FileDTO> fileList = fDAO.fileList();

%>

<body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp"%>

		<!-- 메인이미지 -->
		<c:if test="${param.boardname eq 'admin'||
			param.boardname eq 'freeboard'||
			param.boardname eq 'plan'||
			param.boardname eq 'gallery'||
			param.boardname eq 'dataroom'}">
			<img src="../images/space/sub_image.jpg" id="main_visual" />
		</c:if>
		<c:if test="${param.boardname eq 'community'||
					 param.boardname eq 'volunteer'}">
			<img src="../images/community/sub_image.jpg" id="main_visual" />			 	
		</c:if>
		

		<!-- left 메뉴바 -->
		<div class="contents_box">
			<div class="left_contents">
				<c:if test="${param.boardname eq 'admin'||
					param.boardname eq 'freeboard'||
					param.boardname eq 'plan'||
					param.boardname eq 'gallery'||
					param.boardname eq 'dataroom' }">
					<%@ include file="../include/space_leftmenu.jsp"%>
				</c:if>
				<c:if test="${param.boardname eq 'community'||
					 param.boardname eq 'volunteer'}">
					<%@ include file = "../include/community_leftmenu.jsp" %>
				</c:if>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<%String board = request.getParameter("boardname"); %>
					<%if(board.equals("admin")){			%>
						<img src="../images/space/sub01_title.gif" alt="공지사항" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;공지사항<p>
					<%}else if(board.equals("plan")){		%>
						<img src="../images/space/sub02_title.gif" alt="프로그램일정" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;프로그램일정<p>
					<%}else if(board.equals("freeboard")){	%>
						<img src="../images/space/sub03_title.gif" alt="자유게시판" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;자유게시판<p>
					<%}else if(board.equals("gallery")){	%>
						<img src="../images/space/sub04_title.gif" alt="사진게시판" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;사진게시판<p>
					<%}else if(board.equals("dataroom")){	%>
						<img src="../images/space/sub05_title.gif" alt="정보자료실" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;정보자료실<p>
					<%}else if(board.equals("community")){	%>
						<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
					<%}else if(board.equals("volunteer")){	%>
						<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
					<%} %>
					
				</div>
				
				
				
				
				
				
				
				<div>
				<!-- 게시판 -->
				<%if( board.equals("community")) {%>
					<c:if test="${USER_GRADE ne '관리자' }">
						 <div style="width: 100%; height: 110px;background-color: #D5CEC4; 
						 	border-radius: 5px; text-align: center; align-items: baseline; 
						 	font-weight: bold; font-size: 1.5em; padding-top: 2em; ">
						 	직원전용 공간입니다.
						 </div>
					</c:if>
					<c:if test="${USER_GRADE eq '관리자' }">
						<%@ include file ='../BoardModel1/BoardList.jsp' %>		
					</c:if>
				<%}else if( board.equals("volunteer")) {%>
						<c:if test="${USER_GRADE eq '관리자'&& USER_GRADE eq '일반'}">
							 <div style="width: 100%; height: 110px;background-color: #D5CEC4; 
							 	border-radius: 5px; text-align: center; align-items: baseline; 
							 	font-weight: bold; font-size: 1.5em; padding-top: 2em; ">
							 	회원전용 공간입니다.
							</div>		
						</c:if>	
						<%@ include file ='../BoardModel1/BoardList.jsp' %>		
				<%} %>
				<c:choose>
					<c:when test="${param.boardname eq 'admin' || 
						param.boardname eq 'freeboard'|| 
						param.boardname eq 'dataroom'}">
						<%@ include file ='../BoardModel1/BoardList.jsp' %>		
					</c:when>
					<c:when test="${param.boardname eq 'plan' }">
						<%@ include file ='../BoardModel1/Calendar.jsp' %>		
					</c:when>
					<c:when test="${param.boardname eq 'gallery' }">
						<%@ include file ='../BoardModel1/Gallery.jsp' %>	
					</c:when>
				</c:choose>
				
				</div>
				
				
				
				
				
				
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>


	<%@ include file="../include/footer.jsp"%>
</body>
</html>