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
		<img src="../images/community/sub_image.jpg" id="main_visual" />			 	
		
		
		
		<!-- left 메뉴바 -->
		<div class="contents_box">
			<div class="left_contents">
				<c:import url="../include/community_leftmenu.jsp"></c:import>
			</div>
			
			
			
			
			<div class="right_contents">
					${param.boardname }
				<div class="top_title">
					<c:if test="${param.boardname eq 'community'}">
						<img src="../images/community/sub01_title.gif" 
							alt="직원자료실" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;직원자료실<p>
					</c:if>
					<c:if test="${param.boardname eq 'volunteer'}">
						<img src="../images/community/sub02_title.gif" 
							alt="보호자 게시판" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;보호자 게시판<p>
					</c:if>
				</div>
				
				
				
				
				
				<div>
<!-- 테이블 -->
<form action="../community/SubList.do?command=insert&" name="writeFrm" method="post"
	enctype="multipart/form-data" >
	
	<input type="text" name="num" value="${param.num }"/>
	<input type="text" name="editMode" value="${editMode}"/>
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
							<span id="fileName">${fileName }</span>
							<c:if test="${not empty fDTO.serverfile }">
								<span style="vertical-align: middle;" id="deleteBtn" onclick="chkDelFile();">
									<!-- 첨부파일 삭제버튼 -->
									<i class="material-icons" id="deleteFile"  
										style="font-size:20px">&#xe92b;</i>
								</span>
								<input type="hidden" name="delFileFlag" value=" "/>
							</c:if>
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
			onclick="location.href='../community/SubList.do?nowPage=${
				param.nowPage}&searchColumn=${
				param.searchColumn}&searchWord=${
				param.searchWord}&boardname=${
				param.boardname }&command=list';">리스트보기</button>
	</div>
</form>

				
				
				
				
				
				</div>
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


















