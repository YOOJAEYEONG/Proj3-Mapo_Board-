<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.PagingUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>



<!--게시판 리스팅 로직  -->    
<%@include file="BoardListProc.jsp" %>


	






<div class="container" >
	<div class="row" >
		<!-- 검색부분 -->
		<form class="form-inline ml-auto" name="searchFrm" method="get">
			<input type="hidden" name="boardname" value="<%=boardname%>"/>
			<div class="form-group">
				<select name="searchColumn" class="form-control">
					<option value="title">제목</option>
					<option value="content">내용</option>
				</select>
			</div>
			<div class="input-group">
				<input type="text" name="searchWord" class="form-control" />
				<div class="input-group-btn">
					<button type="submit" class="btn btn-warning">
						<i class='fa fa-search' style='font-size: 20px'></i>
					</button>
				</div>
			</div>
		</form>
	</div>
	<div class="row mt-3" >
		<!-- 게시판리스트부분 -->
		<table class="table" style="border-spacing: 5px;"  id="list">
				<%	
					//게시물의 가상번호로 사용할 변수
					//int vNum = 0;
					//int countNum = 0;
					
					/* for (BbsDTO dto : bbs) {//pageSize = 6으로 변경함 */
					fdao = new FileDAO(application);
					fdto = new FileDTO();
					int idx = 0;
					System.out.println("bbs.size():"+bbs.size());
					//vNum = totalRecordCount - (((nowPage-1) * pageSize) + countNum++);
					for(int tr=0; tr<=1; tr++){ 
					
					
				%>
						<tr>
				<%		
						for(int td=0; td<=2 ; td++){
						String num = (bbs.get(idx).getNum());
						
						Date original_date = before.parse(bbs.get(idx).getPostdate());
						String newdate = isnew.format(original_date);
						
						fdto = fdao.getFile(num);
						
				%>
							<td >
								<div style="height: 130px; max-height: 250px; max-width: 260px; overflow: hidden; " >
									<%if(fdto.getServerfile()!=null) {%>
									<input type="image" class="img-thumbnail rounded"  
										 src="../Data/<%=fdto.getServerfile()  %>"
										 onclick="location.href='../space/sub01_view.jsp?num=<%=bbs.get(idx).getNum()%>&nowPage=<%=
												nowPage%>&<%=queryStr%>'" />
									<%}else {%>
										<input type="image" class="img-thumbnail rounded"  
										 src="../images/noimage.gif" 
										 onclick="location.href='../space/sub01_view.jsp?num=<%=bbs.get(idx).getNum()%>&nowPage=<%=
												nowPage%>&<%=queryStr%>'" />
									<%} %>
								</div>
								<div class="row">
									<div class="col-6" style="empty-cells: hide; font-weight: bold;"><%=bbs.get(idx).getTitle() %></div>
									<div class="col-6 text-right" style="font-size: 0.9em;color: gray;"><%=bbs.get(idx).getId() %></div>
								</div>
								<div class="row" style="font-size: 0.9em;color: gray;">
									<div class="col-6"><i class='far fa-eye'></i>&emsp;<%=bbs.get(idx).getVisitcount() %></div>
									<div class="col-6 text-right"><%=newdate %></div>
								</div>
								
							</td>
				<%
						idx = (idx+1)%6; // 0 1 2 3 4 0 1 2 ...
						}
				%>
						</tr>
				<% 	}%>
		</table>
	</div>
	<div class="row">
		<div class="col text-right">
			<!--글쓰기 권한 설정  -->
			<%if(boardname.equals("freeboard") ||
					boardname.equals("gallery") ||
					boardname.equals("dataroom") ||
					grade.equals("관리자")){ 
			%>
			<button type="button" class="btn btn-outline-secondary"
				onclick="location.href='../space/sub01_write.jsp?boardname=<%=boardname%>'">글쓰기</button>
			<%} %>
		</div>
	</div>	
	<div class="row mt-3">
		<div class="col">
			<!-- 페이지번호 부분 -->
			<ul class="pagination justify-content-center pagination-sm">	
					<%=PagingUtil.pagingBS4(totalRecordCount,pageSize, 
							blockPage, nowPage,"sub01_list.jsp?"+queryStr)%>
			</ul>
		</div>
	</div>
</div>



