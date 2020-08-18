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
					<img src="../images/member/id_pw_title.gif" alt="" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;아이디/비밀번호찾기<p>
				</div>
				<div class="idpw_box">
					<div class="id_box">
						<!--아이디찾기-->
							<ul>
								<li><input type="text" name="nameToId" value="" required class="login_input01" /></li>
								<li><input type="text" name="emailToId" value="" required class="login_input01" /></li>
							</ul>
							<!--확인버튼-->
							<input type="image" src="../images/member/id_btn01.gif" class="id_btn" id="findId" data-toggle="modal" data-target="#myModal"/>
						<!--회원가입버튼-->
						<a href="join01.jsp"><img src="../images/login_btn03.gif" class="id_btn02" /></a>
					</div>
					
					<div class="pw_box">
						<!--비번찾기-->
							<ul>
								<li><input type="text" name="idToPass" value="" class="login_input01" required/></li>
								<li><input type="text" name="nameToPass"  value="" class="login_input01" required/></li>
								<li><input type="text" name="emailToPass"  value="" class="login_input01" required	/></li>
							</ul>
							<input type="image" src="../images/member/id_btn01.gif" class="pw_btn" id="findPass" data-toggle="modal" data-target="#myModal"/>
						
					</div>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	<%@ include file="../include/footer.jsp" %>
	
	<!-- 확인버튼 클릭시 모달창 팝업됨 -->
	<!-- The Modal -->
	<div class="modal fade" id="myModal">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				
				<!-- Modal Header -->
				<div class="modal-header">
					<h6 class="modal-title" id="modal-title">아이디 찾기</h6>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
	
				<!-- Modal body -->
				<div class="modal-body" id="modal-content">내용</div>
				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				</div>

			</div>
		</div>
	</div>

	
	
	<jsp:include page="../common/id_pw_script.jsp"></jsp:include>
 </body>
</html>


