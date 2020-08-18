<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<%System.out.println("sub01.jsp페이지 진입"); %>

 <body>
 	
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/community/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/community_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				
				<c:if test="${boardname eq 'community' }">
					<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
				</c:if>
				<c:if test="${boardname eq 'volunteer' }">
					<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
				</c:if>
				
		
						
			 	
				<!-- 게시판 -->
				<div>
					<c:if test="${boardname eq 'community' }">
						<c:if test="${USER_GRADE ne '관리자' }">
							<div class="blockBox" >	직원전용 공간입니다.	</div>
						</c:if>
						<c:if test="${USER_GRADE eq '관리자' }">
							<c:import url="../BoardModel2/BoardList"></c:import>
						</c:if>
					</c:if>
					
					<c:if test="${boardname eq 'volunteer' }">
						<c:if test="${USER_GRADE ne '관리자'&& USER_GRADE ne '일반'}">
							<div class="blockBox">회원전용 공간입니다.</div>		
						</c:if>	
						<c:if test="${USER_GRADE eq '관리자' || USER_GRADE eq '일반' }">
							<c:import url="../BoardModel2/BoardList"></c:import>
						</c:if>
					</c:if>
				</div>
					
							<%-- <%@ include file ='../BoardModel1/BoardList.jsp' %>		 --%>
					
					
			
					
					
					
					
					
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
 </body>
</html>
