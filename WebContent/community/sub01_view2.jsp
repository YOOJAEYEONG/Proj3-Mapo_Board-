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



<%--JSTL 추가(lib포함)  --%>   
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

 
 
 
 
 
 <!-- @WebServlet("/BoardModel2/sub01_view2") -->
 <body>
	<div id="wrap" align="center">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/community/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<c:import url="../include/community_leftmenu.jsp"/>
			</div>
			
			
			
			
			
			
			
			<div class="right_contents">
				<div class="top_title">	
					<c:if test="${param.boardname eq 'community' }">
						<img src="../images/community/sub01_title.gif" alt="직원자료실" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
					</c:if>
					<c:if test="${param.boardname eq 'volunteer' }">
						<img src="../images/community/sub02_title.gif" alt="보호자 게시판" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
					</c:if>
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
		<td>${dto.name }</td>
		<th class="text-center" style="vertical-align:middle;">작성일</th>
		<td>${newdate }</td>
	</tr>
	<tr >
		<th class="text-center" 
			style="vertical-align:middle;">제목</th>
		<td colspan="1 id="view-title">${ dto.title}</td>
		
		<th class="text-center" style="vertical-align:middle;">조회수</th>
		<td>${dto.visitcount }</td>
	</tr>
	<tr >
		<th class="text-center" 
			style="vertical-align:middle;">내용</th>
		<td colspan="3" style="height:200px;" id="view-content" >
			<c:if test="${fDTO.serverfile }">
				<img class="rounded" style="align-items:center;  align-content: center;" 
					src="../Data/${fDTO.serverfile}"></img>
			</c:if>
			<p>${dto.content}</p>
		</td>
	</tr>
	
	
	
	
	<tr>
		<th class="text-center" style="vertical-align:middle;">첨부파일</th>
		<td colspan="3">
			<c:if test="#{hasFile }">
				${fileName }
				<button class="btn btn-sm btn-dark" 
					onclick="javascript:location.href='../BoardModel1/DownloadProc.jsp?originFile=${
				originFile }%>&serverFile=${serverFile } %>'"
				>다운로드</button>
			</c:if>
		</td>
	</tr>
	
	
	
	
</tbody>
</table>
<!-- text-center -->
<div class="row ml-1" align="right">
	<!-- 각종 버튼 부분 -->
	
		<c:if test="${not empty USER_ID and USER_ID eq dto.id }">
		<button type="button" class="btn btn-outline-warning btn-sm m-1" onclick="isDelete();"
			>삭제하기</button>
		<button type="button" class="btn btn-outline-dark btn-sm m-1" onclick="isEdit();"
			>수정하기</button>
		<button type="button" class="btn btn-dark btn-sm m-1" id="saveBtn" hidden=""
			>저장하기</button>
	</c:if>
	
	<button type="button" class="btn btn-outline-dark btn-sm m-1"  
		onclick="location.href='../community/SubList.do?nowPage=${
			param.nowPage}&searchColumn=${
			param.searchColumn}&searchWord=${
			param.searchWord}&boardname=${
			param.boardname }&command=list';">리스트보기</button>
</div>


<!--게시글 수정 / 삭제  -->
	<form name="funcFrm">
		<input type="hidden" name="num" value="${dto.num }" />
	</form>

<script>
	function isDelete() {
		var c = confirm('삭제할까요?');
		if(c){
			var f = document.funcFrm;
			f.method = "post";
			f.action = "../community/SubList.do?command=delete&boardname=${
				param.boardname}&nowPage=${param.nowPage}&searchColumn=${
				param.searchColumn}&searchWord=${
				param.searchWord}";
			f.submit();
			//history.go(0);//페이지 새로고침
		}
	}
	function isEdit() {
		var contentId = "${dto.id}";
		var sessionId = '${USER_ID}';
		
		if(contentId == sessionId){
			console.log('${param.boardname}');
			var edit = document.funcFrm;
			edit.method = "post";
			edit.action = "../community/SubList.do?command=write&boardname=${
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