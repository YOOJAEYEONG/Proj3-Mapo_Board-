<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.BbsDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="model.BbsDTO"%>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> -->
<!DOCTYPE html>
 
<%
//리퀘스트 내장객체를 이용하여 쿠키를 읽어온다.
Cookie[] cookies = request.getCookies();
//쿠기에 저장된 아이디값을 저장할 변수
String user = "";
if(cookies!=null){
	System.out.println("쿠키가져오기");
	for(Cookie ck : cookies){
		if(ck.getName().equals("USER_ID")){
			//찾았다면 쿠키에 저장된 쿠키값을 변수에 저장한다.
			user = ck.getValue();
			System.out.println(user);
		}
	}
}
/***메인화면에 게시판 제목을 띄우는 로직******************/
request.setCharacterEncoding("UTF-8");
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

BbsDAO dao = new BbsDAO(drv, url);
Map<String, Object> param = new HashMap<String, Object>();
param.put("boardname", "admin");
param.put("start", 1);
param.put("end", 5);
List<BbsDTO> bbsAdmin = dao.selectListPage(param);


param.replace("boardname", "freeboard");
List<BbsDTO> bbsFree = dao.selectListPage(param);

//사진게시판
param.replace("boardname", "gallery");
param.put("end", 6);//사진을 6띄우기위해 변경함
List<BbsDTO> bbsGallery = dao.selectListPage(param);

//DB의 긴 Date 타입을 짧게 변환
SimpleDateFormat before = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
SimpleDateFormat isnew = new SimpleDateFormat("yy.MM.dd");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>마포구립장애인 직업재활센터</title>
<style type="text/css" media="screen">
	@import url("../css/common.css");
	@import url("../css/main.css");
	@import url("../css/sub.css");
</style>
</head>

<script>
	//에러가 나지만 정상작동함
	//회원기입 완료하면 메세지 출력
	window.onload = function(){
		if(${param.intro eq 'welcome'}){
			alert("환영합니다");
		}
	}
	
</script>
<body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp"%>
		
		<div id="main_visual">
		<a href="../product/sub01.jsp"><img src="../images/main_image_01.jpg" /></a><a href="../product/sub01_02.jsp"><img src="../images/main_image_02.jpg" /></a><a href="../product/sub01_03.jsp"><img src="../images/main_image_03.jpg" /></a><a href="../product/sub02.jsp"><img src="../images/main_image_04.jpg" /></a>
		</div>

		<div class="main_contents">
			<div class="main_con_left">
				<p class="main_title" style="border:0px; margin-bottom:0px;"><img src="../images/main_title01.gif" alt="로그인 LOGIN" /></p>
				<div class="login_box">
					<form method="post" action="../member/LoginProc.jsp">
					<table cellpadding="0" cellspacing="0" border="0">
					
					<%if(session.getAttribute("USER_ID")==null) {%>
					<!-- 로그인전 -->
						<colgroup>
							<col width="45px" />
							<col width="125px" />
							<col width="55px" />
						</colgroup>
							<tr>
								<th><img src="../images/login_tit01.gif" alt="아이디" /></th>
								<td><input type="text" name="user_id" value="<%=user==null?"":user %>" class="login_input" /></td>
								<td rowspan="2"><input type="image" src="../images/login_btn01.gif" alt="로그인" /></td>
							</tr>
							<tr>
								<th><img src="../images/login_tit02.gif" alt="패스워드" /></th>
								<td><input type="text" name="user_pw" value="" class="login_input" /></td>
							</tr>
						<tr>
							<td colspan="4">
								<p>
								<input type="checkbox" name="saveId" value="Y" 
									<%if(user.length()!=0) { %> 
										checked="checked"
									<% } %>
								/><img src="../images/login_tit03.gif" alt="저장" />
								<a href="../member/id_pw.jsp"><img src="../images/login_btn02.gif" alt="아이디/패스워드찾기" /></a>
								<a href="../member/join01.jsp"><img src="../images/login_btn03.gif" alt="회원가입" /></a>
								</p>
							</td>
						</tr>
					<%}else{ %>
					<!-- 로그인 후 -->
					<tr>
						<td>
							<p style="padding:5px 10px 10px 10px"><span style="font-weight:bold; color:#333;"><%=session.getAttribute("USER_NAME") %>님,</span> 반갑습니다.<br />로그인 하셨습니다.</p>
							<p style="text-align:right; padding-right:10px;">
							<a href=""><img src="../images/login_btn04.gif" /></a><!--회원정보수정-->
							<a href="Logout.do"><img src="../images/login_btn05.gif" /></a><!--로그아웃-->
							</p> 
						</td>
					</tr>
					<%} %>
					</table>
					</form>
				</div>
			</div>
			<div class="main_con_center">
				<p class="main_title"><img src="../images/main_title02.gif" alt="공지사항 NOTICE" /><a href="../space/sub01.jsp?boardname=admin"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_board_list">
					<%
						if ( !bbsAdmin.isEmpty()) {
							//2020-06-01 11:17:45.0
							for (BbsDTO dto : bbsAdmin) {
								Date original_date = before.parse(dto.getPostdate());
								String newdate = isnew.format(original_date);
					%>
						<li>
							<p style="width:220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
								<a href="../space/sub01_view.jsp?boardname=admin&num=<%=dto.getNum()%>">
								<%=dto.getTitle() %></a>
							<span><%=newdate %></span>
							</p>
						</li>
					<% 	
							}
						}
					%>
				</ul>
			</div>
			<div class="main_con_right">
				<p class="main_title"><img src="../images/main_title03.gif" alt="자유게시판 FREE BOARD" /><a href="../space/sub03.jsp?boardname=freeboard"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_board_list">
					<%
						if ( !bbsFree.isEmpty()) {
						//2020-06-01 11:17:45.0
							for (BbsDTO dto : bbsFree) {
								Date original_date = before.parse(dto.getPostdate());
								String newdate = isnew.format(original_date);
					%> 
						<li>
							<p style="width:220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
								<a href="../space/sub01_view.jsp?boardname=admin&num=<%=dto.getNum()%>">
								<%=dto.getTitle() %></a>
							<span><%=newdate %></span>
							</p>
						</li>
					<% 	
							}
						}
					%>
				</ul>
			</div>
		</div>

		<!-- 프로그램일정 -->
		<div class="main_contents">
			<div class="main_con_left">
				<p class="main_title"><img src="../images/main_title04.gif" alt="월간일정 CALENDAR" /></p>
				<img src="../images/main_tel.gif" />
			</div>
			<div class="main_con_center">
				<p class="main_title" style="border:0px; margin-bottom:0px;"><img src="../images/main_title05.gif" alt="월간일정 CALENDAR" /></p>
				
					
					
					
				<div class="cal_top">
					<table cellpadding="0" cellspacing="0" border="0">
						<colgroup>
							<col width="13px;" />
							<col width="*" />
							<col width="13px;" />
						</colgroup>
						<tr>
							<td><a href=""><img src="../images/cal_a01.gif" style="margin-top:3px;" /></a></td>
							<td><img src="../images/calender_2012.gif" />&nbsp;&nbsp;<img src="../images/calender_m1.gif" /></td>
							<td><a href=""><img src="../images/cal_a02.gif" style="margin-top:3px;" /></a></td>
						</tr>
					</table>
				</div>
				<div class="cal_bottom">
					<table cellpadding="0" cellspacing="0" border="0" class="calendar">
						<colgroup>
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th><img src="../images/day01.gif" alt="S" /></th>
							<th><img src="../images/day02.gif" alt="M" /></th>
							<th><img src="../images/day03.gif" alt="T" /></th>
							<th><img src="../images/day04.gif" alt="W" /></th>
							<th><img src="../images/day05.gif" alt="T" /></th>
							<th><img src="../images/day06.gif" alt="F" /></th>
							<th><img src="../images/day07.gif" alt="S" /></th>
						</tr>
						<tr>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">1</a></td>
							<td><a href="">2</a></td>
							<td><a href="">3</a></td>
						</tr>
						<tr>
							<td><a href="">4</a></td>
							<td><a href="">5</a></td>
							<td><a href="">6</a></td>
							<td><a href="">7</a></td>
							<td><a href="">8</a></td>
							<td><a href="">9</a></td>
							<td><a href="">10</a></td>
						</tr>
						<tr>
							<td><a href="">11</a></td>
							<td><a href="">12</a></td>
							<td><a href="">13</a></td>
							<td><a href="">14</a></td>
							<td><a href="">15</a></td>
							<td><a href="">16</a></td>
							<td><a href="">17</a></td>
						</tr>
						<tr>
							<td><a href="">18</a></td>
							<td><a href="">19</a></td>
							<td><a href="">20</a></td>
							<td><a href="">21</a></td>
							<td><a href="">22</a></td>
							<td><a href="">23</a></td>
							<td><a href="">24</a></td>
						</tr>
						<tr>
							<td><a href="">25</a></td>
							<td><a href="">26</a></td>
							<td><a href="">27</a></td>
							<td><a href="">28</a></td>
							<td><a href="">29</a></td>
							<td><a href="">30</a></td>
							<td><a href="">31</a></td>
						</tr>
						<tr>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
						</tr>
					</table>
				</div>
			</div>
			<!-- 사진게시판 -->
			<div class="main_con_right">
				<p class="main_title"><img src="../images/main_title06.gif" alt="사진게시판 PHOTO BOARD" /><a href="../space/sub01_list.jsp?boardname=gallery"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_photo_list" style="border-radius: 8px; overflow: hidden; "> 
				<%
					if( !bbsGallery.isEmpty()){
						/* for (BbsDTO dto : bbs) {//pageSize = 6으로 변경함 */
						FileDAO fdao = new FileDAO(application);
						FileDTO fdto = new FileDTO();
						int idx = 0;
						for(int tr=0; tr<=2; tr++){ 
				%>	
					<li >
				<%		
						for(int td=0; td<=1 ; td++){
							String num = (bbsGallery.get(idx).getNum());
							fdto = fdao.getFile(num);
							String src = "../space/sub01_view.jsp?boardname=gallery&num="+bbsGallery.get(idx).getNum();
				%>
						<dl style="cursor: pointer;max-width: 90px; max-height: 80px;" >
							<dt onclick="location.href='<%=src%>'" style="
							  		background-image: url('../Data/<%=fdto.getServerfile()  %>'); 
							  		background-repeat:no-repeat; 
							  		background-position: center center;" >
							  		<div style="width: 90px; height: 60px;  "></div>
							</dt>
							<dd style="text-align: center;"><a href="../space/sub01_view.jsp?num=<%=bbsGallery.get(idx).getNum()%>" ><%=bbsGallery.get(idx).getTitle() %></a></dd>
						</dl>
				<%
							idx = (idx+1)%6; // 0 1 2 3 4 0 1 2 ...
							}
				%>
					</li>
				<% 		}%>
				<% 	}%>
					
				</ul>
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>

	<%@ include file="../include/footer.jsp"%>
	

</body>
</html>
















