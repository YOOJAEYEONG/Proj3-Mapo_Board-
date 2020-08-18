<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../include/global_head.jsp" %>




<!--다음  우편번호검색-->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp"%>

		<img src="../images/member/sub_image.jpg" id="main_visual" />


		<div class="contents_box">
			<div class="left_contents">
				<%@ include file="../include/member_leftmenu.jsp"%>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/join_tit.gif" alt="회원가입" class="con_title" />
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;회원가입
					<p>
				</div>
				<p class="join_title">
					<img src="../images/join_tit03.gif" alt="회원정보입력" />
				</p>
				<form name="logFrm" method="post" action="SignUp.do" onsubmit="return confirmSignForm();">
					<table cellpadding="0" cellspacing="0" border="0" class="join_box">
						<colgroup>
							<col width="80px;" />
							<col width="*" />
						</colgroup>

						<!-- 회원정보입력 폼 시작-->
						<tr>
							<th><img src="../images/join_tit001.gif" /></th>
							<td><input type="text" name="name" value=""
								class="join_input" required /></td>
						</tr>
						<tr>
							<th><img src="../images/join_tit002.gif" /></th>
							<!--중복확인버튼-->
							<td><input type="text" name="id" value=""
								class="join_input" required maxlength="12" />&nbsp;
								<button id="idCheck" type="button" style="border: 0">
									<img src="../images/btn_idcheck.gif" alt="중복확인" />
								</button>&nbsp;&nbsp;<span id="span_id">* 4자 이상 12자 이내의 영문/숫자 조합하여
									공백 없이 기입</span>
								<br />
								<span id="idInputComent"></span> 
							</td>
						</tr>
						<tr>
							<th><img src="../images/join_tit003.gif" /></th>
							<td><input type="password" name="pass" maxlength="12" 
								class="join_input" required />&nbsp;&nbsp;<span id="span_pass">*
									4자 이상 12자 이내의 영문/숫자 조합</span></td>
						</tr>
						<tr>
							<th><img src="../images/join_tit04.gif" /></th>
							<td><input type="password" name="pass2"  maxlength="12" 
								class="join_input" required />
								<span id="passchk" style="color: red;" hidden="hidden">
									 &emsp;비밀번호가 일치하지 않습니다</span>
							</td>
						</tr>


						<tr>
							<th><img src="../images/join_tit06.gif" /></th>
							<td><input type="text" name="tel1" value="" maxlength="3"
								class="join_input" style="width: 50px;" />&nbsp;-&nbsp; <input
								type="text" name="tel2" value="" maxlength="4"
								class="join_input" style="width: 50px;" />&nbsp;-&nbsp; <input
								type="text" name="tel3" value="" maxlength="4"
								class="join_input" style="width: 50px;" /></td>
						</tr>
						<tr>
							<th><img src="../images/join_tit07.gif" /></th>
							<td><input type="text" name="mobile1" value="" maxlength="3"
								class="join_input" style="width: 50px;" required />&nbsp;-&nbsp;
								<input type="text" name="mobile2" value="" maxlength="4"
								class="join_input" style="width: 50px;" required />&nbsp;-&nbsp;
								<input type="text" name="mobile3" value="" maxlength="4"
								class="join_input" style="width: 50px;" required /></td>
						</tr>
						<tr>
							<th><img src="../images/join_tit08.gif" /></th>
							<td><input type="text" name="email_1"
								style="width: 100px; height: 20px; border: solid 1px #dadada;"
								value="" required /> @ <input type="text" name="email_2"
								style="width: 150px; height: 20px; border: solid 1px #dadada;"
								value="" /> 
								<select name="last_email_check2" class="pass" id="last_email_check2">
									<!--onChange="email_input(this);"  -->
									<option selected value=" ">선택해주세요</option>
									<option value="self">직접입력</option>
									<option value="gmail.com">gmail.com</option>
									<option value="hotmail.com">hotmail.com</option>
									<option value="nate.com">nate.com</option>
									<option value="naver.com">naver.com</option>
								</select> <input type="checkbox" name="subscribe" value="1"> <span>이메일
									수신동의</span>
							</td>
						</tr>
						<tr>
							<th><img src="../images/join_tit09.gif" /></th>
							<td>
								<!--우편번호--> 
								<input type="text" id="zip1" name="zipcode" value=""
								class="join_input" style="width: 100px;" /> <a
								href="javascript:;" title="새 창으로 열림"
								onclick="DaumPostcode();"
								onkeypress="">[우편번호검색]</a> <br /> 
								<!--주소--> 
								<input type="text" name="addr1"
								id="addr1" value="" class="join_input"
								style="width: 550px; margin-top: 5px;" /><br> 
								<input type="text" name="addr2"
								id="addr2" value="" class="join_input"
								style="width: 550px; margin-top: 5px;" />
							</td>
						</tr>
					</table>
					<p style="text-align: center; margin-bottom: 20px">
						<!--회원가입확인버튼-->
					<!-- 	<button type="submit" data-toggle="tooltip" title="Hooray!" id="signupBtn" style=" border: 0;" >
							<img src="../images/btn01.gif" />
						</button> -->
						<!-- <button id="signupBtn" data-toggle="tooltip" data-placement="top" title="아이디중복확인이 필요합니다!" >
						<img src="../images/btn01.gif"   /></button>  -->
						<input type="image" src="../images/btn01.gif" id="signupBtn" data-toggle="tooltip" data-placement="top" title="아이디중복확인이 필요합니다!"/>
						&nbsp;&nbsp;<a href="login.jsp"><img src="../images/btn02.gif" /></a>
					</p>
					
				</form>

			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>
	<%@ include file="../include/footer.jsp"%>
	
	<%-- <c:include url="../common/join2_script.jsp"></c:include> --%>
	<jsp:include page="../common/join2_script.jsp"></jsp:include>
	
	
</body>
</html>
