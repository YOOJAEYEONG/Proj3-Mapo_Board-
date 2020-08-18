<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.PagingUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

    
<%--JSTL 추가(lib포함)  --%>   
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



<!--게시판 리스팅 로직  -->    
<%@include file="../BoardModel1/BoardListProc.jsp" %>

<!-- 첨부파일 아이콘 CDN -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">


<div class="container" >
	<div class="row" >
		<!-- 검색부분 -->
		<form class="form-inline ml-auto" name="searchFrm" method="get">
			<input type="hidden" name="boardname" value="${param.boardname}"/>
			<div class="form-group">
				<select name="searchColumn" class="form-control">
					<option value="title">제목</option>
					<option value="content">내용</option>
				</select>
			</div>
			<div class="input-group">
				<input type="text" name="searchWord" class="form-control" />
				<div class="input-group-btn">
					<button type="submit" class="btn btn-light">
						<i class='fa fa-search' style='font-size: 20px'></i>
					</button>
				</div>
			</div>
		</form>
	</div>
	<div class="row mt-3" >
		<!-- 게시판리스트부분 -->
		<table class="table table-bordered table-hover table-striped" id="list" >
			<colgroup>
				<col width="10%" />
				<col width="50%" /> <!-- 제목 -->
				<col width="15%" /> <!-- 작정자 -->
				<col width="15%" /><!-- 작성일 -->
				<col width="10%" />
			</colgroup>
			<thead>
				<tr style="background-color: #353535; "
					class="text-center text-white">
					<th >번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>뷰</th>
					
				</tr>
			</thead>
			<tbody>

				<%
					//List컬렉션에 입력된 데이터가 없을때 true를 반환.
					if (bbs.isEmpty()) {
				%>
				<tr>
					<td colspan="5" align="center" height="50">등록된 게시물이 없습니다.</td>
				</tr>
				<%
					} else {
						//게시물의 가상번호로 사용할 변수
						int vNum = 0;
						int countNum = 0;
						for (BbsDTO dto : bbs) {
							System.out.printf("%d-(((%d-1)*%d)+%d)=",totalRecordCount,nowPage,pageSize,countNum);
							System.out.println(totalRecordCount - (((nowPage-1) * pageSize) + countNum));
							
							vNum = totalRecordCount - (((nowPage-1) * pageSize) + countNum++);
							fdto = fdao.getFile(dto.getNum());
							System.out.println("fdto.getNum:"+fdto.getNum());
							System.out.println("fdto.getOri:"+fdto.getOriginfile());
							System.out.println("fdto.getSer:"+fdto.getServerfile());
							
							Date original_date = before.parse(dto.getPostdate());
							String newdate = isnew.format(original_date);
				%>
				<%-- 리스트반복 시작 --%>
				<tr style="font-size: 1.2em; ">
					<td class="text-center" ><%=vNum%></td>
					<td class="text-left"  >
						<div style="width:450px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
							<!--첨부파일 아이콘  -->
							<%if(fdto.getServerfile()!=null){ %>
							
								<i class="material-icons" style="vertical-align:text-top; font-size: 16px; color: fuchsia;">&#xe226;</i>
								
							
							<%} %>
							<!--게시글 제목 -->
							<a href="../BoardModel2/sub01_view2?num=<%=dto.getNum()%>&nowPage=<%=
								nowPage%>&<%=queryStr%>" ><%=dto.getTitle() %></a>
						</div>
					</td>
					<td class="text-center"><%=dto.getId()%></td>
					<td class="text-center"><%=newdate%></td>
					<td class="text-center"><%=dto.getVisitcount()%></td>
				</tr>
				<%-- 리스트반복 끝--%>
				<%
						} //for-each
					} //if
				%>
			</tbody>
		</table>
	</div>
	<div class="row">
		<div class="col text-right">
			<!--글쓰기 권한 설정  -->
			<%
				if(boardname.equals("freeboard") ||	boardname.equals("gallery") ||
					boardname.equals("dataroom") ||	grade.equals("관리자") ||
					grade.equals("일반")){ 
					if( !boardname.equals("admin")){
			%>
		
			<button type="button" class="btn btn-outline-secondary" 
				onclick="location.href='../community/SubList.do?boardname=${
				boardname}&command=write'">글쓰기</button>
			<% 		}
				}%>
		</div>
	</div>
	<div class="row mt-3">
		<div class="col">
			<!-- 페이지번호 부분 -->
			<ul class="pagination justify-content-center pagination-sm">	
					<%=PagingUtil.pagingBS4(totalRecordCount,pageSize, 
							blockPage, nowPage,"../community/SubList.do?command=list&"+queryStr)%>
			</ul>
		</div>
	</div>
</div>
