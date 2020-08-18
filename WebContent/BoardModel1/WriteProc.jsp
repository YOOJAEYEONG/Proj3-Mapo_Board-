<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.multipart.FileRenamePolicy"%>
<%@page import="com.sun.scenario.effect.impl.sw.sse.SSEBlend_ADDPeer"%>
<%@page import="java.util.Enumeration"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 글작성 완료전 로그인 체크하기 -->
<%@ include file="../common/isLogin.jsp" %>


<%
System.out.println("WriteProc진입=========================");
request.setCharacterEncoding("UTF-8");



/***********파일 업로드를 위한처리*/
String saveDirectory = application.getRealPath("/Data");
System.out.println("saveDirectory>"+saveDirectory);//정상
int maxPostSize = 1024*10*1000;
String encodeType = "UTF-8";

FileRenamePolicy policy = new DefaultFileRenamePolicy();
MultipartRequest mr = null;



//BbsDAO에 저장할 객체
String title = null; 
String content = null; 
/*사용자의 입력값을 DTO객체에 저장후 파라미터로 전달
DB에 삽입 후 해당 게시물의 DB num값을 반환한다.*/
String num = "0"; 

//BbsDAO와 file_tb에 저장할 객체
String boardname = "";

//FileDAO에 저장할 객체
File oldFile = null;
File newFile = null;
String realFileName = null;
String delFileFlag = "";//파일수정시 첨부했던 파일을 삭제할때

boolean resultSaveFile = false;
String fileName = "";
String editMode = "";

FileDTO fDTO = new FileDTO();
FileDAO fDAO = new FileDAO(application);
BbsDTO dto = new BbsDTO();
BbsDAO dao = new BbsDAO(application);

try{
	
	mr = new MultipartRequest(request, saveDirectory,
			maxPostSize, encodeType, policy);
	if(mr!=null){
		System.out.println("MultipartRequest :생성됨");
	}
}catch(Exception e){
	System.out.println("WriteProc>MultipartRequest:생성예외");
	e.printStackTrace();
}////////////////////////////////////////////////////////
try{
	/**파일 이름 변경 로직*******/
	fileName = mr.getFilesystemName("attachFile");
	if(fileName != null){
		System.out.println("파일이름 변경: 진입");
		System.out.println("fileName :  "+fileName);//첨부를 안할경우 null		
		int idx = -1;
		idx = fileName.lastIndexOf(".");
		
		String nowTime = 
				new SimpleDateFormat("yyyy_MM_dd_H_m_s_S").format(new Date());
		realFileName = nowTime+fileName.substring(idx, fileName.length());
		
		oldFile = new File(saveDirectory+File.separator+fileName);
		newFile = new File(saveDirectory+File.separator+realFileName);
		oldFile.renameTo(newFile);//이름변경
		
		System.out.println("파일이름 변경됨:"+newFile);
	}
}catch(Exception e){
	System.out.print("파일이름 변경:예외");
	e.printStackTrace();
}/////////////////////////////////////////////////////////	
	
	
try{
	System.out.println("WriteProc>폼값받기 :시작");
	title = mr.getParameter("title");
	content = mr.getParameter("content");
	boardname = mr.getParameter("boardname");
	//출력된는 null값이 String타입의 null 문자열이다.
	editMode = mr.getParameter("editMode");
	
	//폼값을 DTO객체에 저장한다.
	dto.setTitle(title);
	dto.setContent(content);
	dto.setBoardname(boardname);
	dto.setId(session.getAttribute("USER_ID").toString());
}catch(Exception e){
	System.out.println("WriteProc>폼값받기 :예외");
	e.printStackTrace();
}////////////////////////////////////////////////////


try{
	
	/*
	해당 진행이 수정모드가 이니면 DB의 num 값은 
	없는 것이므로 insert 후 DB에서 자동 부여된 num 값을 리턴 받는다.
	기존글 수정모드인경우 num 값이 있으므로 파라미터로 받는다.
	*/
	if(editMode.equals("authorized"))	{
		System.out.println("WriteProc>authorized: 진입");
		
		num = mr.getParameter("num");
		System.out.println("num:  "+num);
		dto.setNum(num);
		
		//수정하기 + 첨부파일삭제 클릭여부
		delFileFlag = mr.getParameter("delFileFlag");
		System.out.println("delFileFlag: "+delFileFlag);
		
		//게시판테이블 수정, 수정하기는 이미 부여된num 값이 있으므로
		//글 수정후 반환 받을 필요가 없다.
		dao.updateWrite(dto);
		System.out.println("WriteProc:num:"+num);
		
		if(delFileFlag!=null)
			if(delFileFlag.equals("deleteFile")){
				System.out.println("WriteProc>deleteFile: 진입");
				//파일테이블에서 파일 삭제
				fDTO.setNum( num );
				fDAO.fileDelete(fDTO);
			}
		
		System.out.println("fileName: "+fileName);
		try{
			if(fileName != null){
				System.out.println("첨부파일이 있는경우 실행");
				fDTO.setNum(num);
				fDTO.setBoardname(boardname);
				fDTO.setOriginfile(fileName);
				fDTO.setServerfile(realFileName);
				System.out.println("num"+num+"boardname"+boardname+"filename"+
					fileName+"realFileName"+realFileName);
				
				resultSaveFile = fDAO.fileInsert(fDTO);	
				System.out.println("파일 DB insert 결과: "+ resultSaveFile);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	else {
		try{
			System.out.println("WriteProc>새글쓰기 진입");
			//새글 쓰기 일 경우
			num = Integer.toString( dao.insertWrite(dto) );
			//수정글&새글에 첨부파일이 있는경우
			if(fileName != null){	
				System.out.println("첨부파일이 있는경우 DB처리");
				fDTO.setNum(num);
				fDTO.setBoardname(boardname);
				fDTO.setOriginfile(fileName);
				fDTO.setServerfile(realFileName);
				
				resultSaveFile = fDAO.fileInsert(fDTO);	
				System.out.println("파일 DB insert 결과: "+ resultSaveFile);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}catch(Exception e){
	System.out.println("WriteProc>수정하기:DB처리 예외");
	e.printStackTrace();
}///////////////////////////////////////////////////////
	
	
try{
	System.out.println("WriteProc>editMode: "+editMode);
	System.out.println("게시글등록 후 num출력:"+num);
	System.out.println("WriteProc>폼값출력테스트");
	System.out.println("title> "+title);
	System.out.println("content> "+content);
	System.out.println("boardname> "+boardname);
	System.out.println("num> "+num);
	System.out.println("유저아이디> "+session.getAttribute("USER_ID"));
	System.out.println("=======================================");
}catch (Exception e){
	System.out.println("WriteProc>폼값출력: 예외");
	e.printStackTrace();	
}
	
try{
	dao.close();
	fDAO.close();
}catch(Exception e){
	e.printStackTrace();
}
	

/* 
if( !num.equals("0")  ){
	//글쓰기 성공했을때
	out.println("<script>alert('등록되었습니다.');</script>");
	response.sendRedirect("../space/sub01_list.jsp?boardname="+boardname);
}
else{ */
%>
	<!-- 글쓰기 실패했을때 -->
	<script>
		if(<%=num%> === "0"){
			alert('글쓰기에 실패하였습니다.');
			history.go(-1);			
		}else{
			alert('등록되었습니다.');
			location.href = "../space/sub01_list.jsp?boardname=<%=boardname%>";
		}
		
	</script>

















<!-- 
	//50개씩입력할때 사용하는 로직
	for(int i=1 ; i<=100;  i++){
		title = i+" 번째 자유글입니다. 제목이 긴 게시물입니다. 제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목제목";
		content = i+"번째 게시글 내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용";
		dto.setTitle(title);
		dto.setContent(content);
		BbsDAO dao = new BbsDAO(application);

		int affected = dao.insertWrite(dto);
	}
 -->
	
	

















