<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>



<body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp"%>

		<!-- 메인이미지 -->
		
		<c:if test="${param.boardname eq 'community'||
					 param.boardname eq 'volunteer'}">
			<img src="../images/community/sub_image.jpg" id="main_visual" />			 	
		</c:if>
		

		<div class="contents_box">
			
			
			<!-- left 메뉴바 -->
			<div class="left_contents">
				<c:import url="../include/community_leftmenu.jsp"/>
			</div>
			
			
			
			<div class="right_contents">
				${param.boardname }
				<div class="top_title">
					<c:if test="${param.boardname eq 'community'}">
						<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
					</c:if>
					<c:if test="${param.boardname eq 'volunteer'}">
						<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
					</c:if>
				</div>
				
				
				
				
				
				
				
				<div>
					<!-- 게시판 -->
					<c:if test="${param.boardname eq 'community' }">
						<c:if test="${USER_GRADE ne '관리자' }">
							 <div style="width: 100%; height: 110px;background-color: #D5CEC4; 
							 	border-radius: 5px; text-align: center; align-items: baseline; 
							 	font-weight: bold; font-size: 1.5em; padding-top: 2em; ">
							 	직원전용 공간입니다.
							 </div>
						</c:if>
						<c:if test="${USER_GRADE eq '관리자' }">
							<%-- <%@ include file ='../BoardModel1/BoardList.jsp' %>	 --%>	
							<c:import url="../BoardModel2/BoardList2.jsp"/>
						</c:if>
					</c:if>
					<c:if test="${param.boardname eq 'volunteer' }">
							<c:if test="${USER_GRADE ne '관리자'&& USER_GRADE ne '일반'}">
								 <div style="width: 100%; height: 110px;background-color: #D5CEC4; 
								 	border-radius: 5px; text-align: center; align-items: baseline; 
								 	font-weight: bold; font-size: 1.5em; padding-top: 2em; ">
								 	회원전용 공간입니다.
								</div>		
							</c:if>	
							<c:if test="${USER_GRADE eq '관리자' or USER_GRADE eq '일반' }">
								<c:import url="../BoardModel2/BoardList2.jsp"/>
								<%-- <%@ include file ='../BoardModel1/BoardList.jsp' %>		 --%>
							</c:if>
					</c:if>
				</div>
				
				
				
				
				
				
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>


	<%@ include file="../include/footer.jsp"%>
</body>
</html>