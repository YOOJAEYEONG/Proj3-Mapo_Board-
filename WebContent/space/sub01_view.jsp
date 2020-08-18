<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%
System.out.println("sub01_view:진입=========================================");
//폼값받기  - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
String boardname = request.getParameter("boardname");
BbsDAO dao = new BbsDAO(application);

//게시물의 조회수를 증가시킨다
dao.updateVisitCount(num);
//게시물을 가져와서 DTO객체로 변환
BbsDTO dto = dao.selectView(num);

//dao.close();

//sql형 시간형변환. 각페이지별 다르게 출력하였음
SimpleDateFormat before = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
SimpleDateFormat isnew = new SimpleDateFormat("yy.MM.dd hh:mm:ss");
Date original_date = before.parse(dto.getPostdate());
String newdate = isnew.format(original_date);
%>

<%
//파일의 db접근
FileDAO fDAO = new FileDAO(application);
FileDTO fDTO = new FileDTO();
System.out.println("View>num>"+num);
fDTO = fDAO.getFile(num);
System.out.println("View>fDTO.getBoardname(): "+fDTO.getBoardname());
System.out.println("View>fDTO.getOriginfile(): "+fDTO.getOriginfile());
System.out.println("View>fDTO.getServerfile(): "+fDTO.getServerfile());
boolean hasFile = fDTO.getOriginfile()==null? false : true ;
String fileName = fDTO.getOriginfile()==null? "" : fDTO.getOriginfile() ;
%>
 
 <body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/space/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/space_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					
					<%if(boardname.equals("admin")){			%>
						<img src="../images/space/sub01_title.gif" alt="공지사항" class="con_title" />
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;공지사항
					<%}else if(boardname.equals("plan")){		%>
						<img src="../images/space/sub02_title.gif" alt="프로그램일정" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;프로그램일정<p>
					<%}else if(boardname.equals("freeboard")){	%>
						<img src="../images/space/sub03_title.gif" alt="자유게시판" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;자유게시판<p>
					<%}else if(boardname.equals("gallery")){	%>
						<img src="../images/space/sub04_title.gif" alt="사진게시판" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;사진게시판<p>
					<%}else if(boardname.equals("dataroom")){	%>
						<img src="../images/space/sub05_title.gif" alt="정보자료실" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;정보자료실<p>
					<%} %>
					<p>
				</div>
				<div>


<table class="table table-bordered "  >
<style>th{color: white;}</style>
<colgroup>
	<col width="10%" style=" background: #353535; " />
	<col width="60%"/>
	<col width="10%" style=" background: #353535; "/>
	<col width="*"/>
</colgroup>
<tbody>
	<tr>
		<th class="text-center" style="vertical-align:middle;">작성자</th>
		<td><%=dto.getName()%></td>
		<th class="text-center" style="vertical-align:middle;">작성일</th>
		<td><%=newdate %></td>
	</tr>
	<tr >
		<th class="text-center" 
			style="vertical-align:middle;">제목</th>
		<td colspan="1 id="view-title"><%=dto.getTitle() %></td>
		
		<th class="text-center" style="vertical-align:middle;">조회수</th>
		<td><%=dto.getVisitcount() %></td>
	</tr>
	<tr >
		<th class="text-center" 
			style="vertical-align:middle;">내용</th>
		<td colspan="3" style="height:200px;" id="view-content" >
			<%if(fDTO.getServerfile() !=null) {%>
			<img class="rounded" style="align-items:center;  align-content: center;" src="../Data/<%=fDTO.getServerfile() %>"></img>
			<%} %>
			<p><%=dto.getContent().replace("\r\n", "<br>") %></p>
		</td>
	</tr>
	<%if( boardname.equals("dataroom") || boardname.equals("gallery") ) {%>
	<tr>
		<th class="text-center" 
			style="vertical-align:middle;">첨부파일</th>
		<td colspan="3">
			<c:if test="<%=hasFile %>">
				<%=fileName%>
				<%
				String s = URLEncoder.encode(fDTO.getOriginfile(), "UTF-8");
				System.out.println(s); 
				String r = URLEncoder.encode(fDTO.getServerfile(), "UTF-8");
				System.out.println(r); 
				%>
				<button class="btn btn-sm btn-dark" onclick="javascript:location.href='../BoardModel1/DownloadProc.jsp?originFile=<%=
					URLEncoder.encode(fDTO.getOriginfile(), "UTF-8") %>&serverFile=<%=
						URLEncoder.encode(fDTO.getServerfile(), "UTF-8") %>'"
				>다운로드</button>
			</c:if>
		</td>
	</tr>
	<%} %>
</tbody>
</table>
<!-- text-center -->
<div class="row ml-1" align="right">
	<!-- 각종 버튼 부분 -->
	<%		
	if(session.getAttribute("USER_ID") !=null &&
		session.getAttribute("USER_ID").toString().equals(dto.getId())) {
	%>
		<button type="button" class="btn btn-outline-warning btn-sm m-1" onclick="isDelete();"
			>삭제하기</button>
		<button type="button" class="btn btn-outline-dark btn-sm m-1" onclick="isEdit();"
			>수정하기</button>
		<button type="button" class="btn btn-dark btn-sm m-1" id="saveBtn" hidden=""
			>저장하기</button>
			<!--  onclick="location.href='BoardEdit.jsp?num=<%=dto.getNum()%>'" -->
	<%
	}
	%>	
	<button type="button" class="btn btn-outline-dark btn-sm m-1"  
		onclick="location.href='sub01_list.jsp?nowPage=${
			param.nowPage}&searchColumn=${
			param.searchColumn}&searchWord=${
			param.searchWord}&boardname=${
			param.boardname }';">리스트보기</button>
</div>


<!--게시글 수정 / 삭제  -->
	<form name="funcFrm">
		<input type="hidden" name="num" value="<%=dto.getNum()%>" />
	</form>

<script>
	function isDelete() {
		var c = confirm('삭제할까요?');
		if(c){
			var f = document.funcFrm;
			f.method = "post";
			f.action = "../BoardModel1/DeleteProc.jsp?boardname=${
				param.boardname}&nowPage=${param.nowPage}&searchColumn=${
				param.searchColumn}&searchWord=${
				param.searchWord}";
			f.submit();
			//history.go(0);//페이지 새로고침
		}
	}
	function isEdit() {
		var contentId = "<%=dto.getId()%>";
		var sessionId = '${USER_ID}';
		
		if(contentId == sessionId){
			console.log('${param.boardname}');
			var edit = document.funcFrm;
			edit.method = "post";
			/* edit.action = "./sub01_write.jsp?boardname=freeboard"; */
			edit.action = "./sub01_write.jsp?boardname=${
				param.boardname}&nowPage=${
				param.nowPage}&searchColumn=${
				param.searchColumn}&searchWord=${
				param.searchWord}&editMode=authorized&num=${
				param.num}"; 
			edit.submit();
			//history.go(0);//페이지 새로고침
		}
		
	}
</script>

				
				
				
				
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>


	<%@ include file="../include/footer.jsp" %>
 </body>
</html>