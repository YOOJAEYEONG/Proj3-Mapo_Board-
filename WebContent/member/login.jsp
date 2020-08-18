<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>



 <body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/member/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/member_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/login_title.gif" alt="인사말" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;로그인<p>
				</div>
				<div class="login_box01" style="height: 220px;" >
					<img src="../images/login_tit.gif" style="margin-bottom:30px; " />
					<!-- 로그인부분 -->
					<form action="LoginProc.jsp" method="post" >
						<ul >
							<li><img src="../images/login_tit001.gif" alt="아이디" style="margin-right:15px;" /><input type="text" name="user_id" value="" class="login_input01" required/></li>
							<li><img src="../images/login_tit002.gif" alt="비밀번호" style="margin-right:15px;" /><input type="text" name="user_pw" value="" class="login_input01" required/></li>
						</ul>
						<input type="image" src="../images/login_btn.gif" class="login_btn01" />
					</form>
				<p style=" margin-bottom:50px;"><a href="id_pw.jsp"><img src="../images/login_btn02.gif" alt="아이디/패스워드찾기" /></a>&nbsp;<a href="join01.jsp"><img src="../images/login_btn03.gif" alt="회원가입" /></a></p>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
		 
		
		
 </body>
</html>
