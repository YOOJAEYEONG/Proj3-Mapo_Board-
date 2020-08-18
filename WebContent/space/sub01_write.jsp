<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- 글작성 완료전 로그인 체크하기 -->
<%@ include file="../common/isLogin.jsp" %>

<%
//글쓰기 진입시 수정모드로 들어온경우 해당 게시물 내용을 채워넣는다
BbsDTO dto = null;
String editMode = request.getParameter("editMode");
System.out.println("Write페이지>editMode: "+editMode);
String num = request.getParameter("num");
if(editMode != null){
	if(editMode.equals("authorized")){
		
		BbsDAO dao = new BbsDAO(application);
		
		System.out.println(num);
		dto = dao.selectView(num);
		dao.close();
		pageContext.setAttribute("title", dto.getTitle());
		pageContext.setAttribute("content", dto.getContent());
	}
}

//파일의 db접근
FileDAO fDAO = new FileDAO(application);
FileDTO fDTO = new FileDTO();
fDTO = fDAO.getFile(num);
String fileName = fDTO.getOriginfile()==null? "" : fDTO.getOriginfile();
%>

<style>
th{ font-size: 1.2em; color: white; background: #353535;  }
#deleteFile:hover{ cursor: pointer; }
</style>

<script>
	
	function chkDelFile(){
		$('[name="delFileFlag"]').val('deleteFile');
		//console.log($('[name="delFileFlag"]').val());//출력확인
		$('#deleteBtn').attr('hidden','hidden');
		$('#deleteFile').attr('hidden','hidden');
		$('#fileName').attr('hidden','hidden');
	}
	
	
</script>
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
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;공지사항
					<%}else if(board.equals("plan")){		%>
						<img src="../images/space/sub02_title.gif" alt="프로그램일정" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;프로그램일정<p>
					<%}else if(board.equals("freeboard")){	%>
						<img src="../images/space/sub03_title.gif" alt="자유게시판" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;자유게시판<p>
					<%}else if(board.equals("gallery")){	%>
						<img src="../images/space/sub04_title.gif" alt="사진게시판" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;사진게시판<p>
					<%}else if(board.equals("dataroom")){	%>
						<img src="../images/space/sub05_title.gif" alt="정보자료실" class="con_title" />
						<p class="location">
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;정보자료실<p>
					<%} %>
					<p>
				</div>

				<!-- 테이블 -->
				<form action="../BoardModel1/WriteProc.jsp" name="writeFrm" method="post"
					enctype="multipart/form-data" >
					
					<input type="text" name="num" value="<%=num%>"/>
					<input type="text" name="editMode" value="<%=editMode%>"/>
					<input type="text"  hidden="" name="boardname" value="${param.boardname }"/>
					<div class="row ml-1 mr-1">

						<table class="table table-bordered ">
							<colgroup>
								<col width="15%"  />
								<col width="*" />
							</colgroup>
							<tbody>

								<tr >
									<th class="text-center" style=" vertical-align: middle;">제목</th>
									<td><input type="text" name="title" value="${title }" class="form-control" required/></td>
								</tr>
								<tr>
									<th class="text-center" style=" vertical-align: middle;">내용</th>
									<td><textarea rows="10" name="content"
											class="form-control" required>${content }</textarea></td>
								</tr>
								
								<c:if test="${param.boardname eq 'dataroom'|| 
									param.boardname eq 'gallery'||
									param.boardname eq 'community'||
									param.boardname eq 'volunteer'}">
									<!--첨부파일  -->
									<tr>
										<th class="text-center"	style=" vertical-align: middle;">첨부파일</th>
											<!--type=file 인경우class="form-control"는 필요하지 않다  -->
										<td >
											<span id="fileName"><%=fileName %></span>
											<%if( fDTO.getServerfile() != null ) { %>
												<span style="vertical-align: middle;" id="deleteBtn" onclick="chkDelFile();">
													<!-- 첨부파일 삭제버튼 -->
													<i class="material-icons" id="deleteFile"  style="font-size:20px">&#xe92b;</i>
												</span>
														
												<input type="hidden" name="delFileFlag" value=" "/>
											<%} %>
											<input type="file" name="attachFile" class="btn btn-sm btn-light"/>
										</td>
									</tr> 
								</c:if>
							
							</tbody>
						</table>
					</div>
					<div class="row ml-1" align="right">
						<button type="submit" class="btn btn-success btn-sm m-1">완료</button>
						<button type="reset" class="btn btn-outline-dark btn-sm m-1">Reset</button>
						<button type="button" class="btn btn-outline-dark btn-sm m-1"  
							onclick="location.href='sub01_list.jsp?nowPage=${
								param.nowPage}&searchColumn=${
								param.searchColumn}&searchWord=${
								param.searchWord}&boardname=${
								param.boardname }';">리스트보기</button>
					</div>
				</form>

			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>


	<%@ include file="../include/footer.jsp"%>
</body>
</html>

<!-- 각종 버튼 부분 -->
		<!-- <button type="button" class="btn">Basic</button> -->
		<!-- <button type="button" class="btn btn-primary" 
	onclick="location.href='BoardWrite.jsp';">글쓰기</button> -->
		<!-- <button type="button" class="btn btn-secondary">수정하기</button>
<button type="button" class="btn btn-success">삭제하기</button>
<button type="button" class="btn btn-info">답글쓰기</button>
<button type="button" class="btn btn-light">Light</button>
<button type="button" class="btn btn-link">Link</button> -->


















