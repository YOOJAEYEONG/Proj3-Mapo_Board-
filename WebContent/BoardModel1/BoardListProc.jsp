<%@page import="model.FileDTO"%>
<%@page import="model.FileDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="model.BbsDAO"%>


<%
	request.setCharacterEncoding("UTF-8");

	

	//멀티게시판 구현을 위한 파라미터 처리
	String boardname=null;
	if(request.getParameter("boardname")!=null){
		boardname = request.getParameter("boardname");
		System.out.println("BoardListProc>boardname>"+boardname);
	}
	
	
	else if( boardname==null || boardname.equals("") ){
		//만약 bname의 값이 없다면 로그인 화면으로 강제이동시킨다.
		System.out.println("isFlag>메인확면으로 강제이동");
		JavascriptUtil.jsAlertLocation("허용하지 않은 접근입니다", "../member/login.jsp", out);
		return;
	}

	String drv = application.getInitParameter("MariaJDBCDriver");
	String url = application.getInitParameter("MariaConnectURL");

	BbsDAO dao = new BbsDAO(drv, url);

	Map<String, Object> param = new HashMap<String, Object>();

	param.put("boardname", boardname);
	

	//검색후 2페이지로 넘어가면 검색이 풀리는 문제를 해결하기위해
	//폼값을 받아서 파라미터를 저장할 변수 생성
	String queryStr = "";//검색시 페이지번호로 쿼리스트링을 넘겨주기위한 용도


	//필수파라미터에 대한 쿼리스트링 처리
	queryStr = "boardname="+boardname+"&";
	
	
	//검색어 입력시 전송된 폼값을 받아 Map에 저장
	String searchColumn = request.getParameter("searchColumn");
	String searchWord = request.getParameter("searchWord");

	
	if (searchWord != null) {
		if(searchWord.length()>0){
			
			//검색어를 입력한경우 Map에 값을 입력함
			//아무것도 입력안하고 그냥 검색버튼을 누를경우를 위한 로직임
			param.put("Column", searchColumn);
			param.put("Word", searchWord);
			
			//검색어가 있을때 쿼리스트링을 만들어준다.
			queryStr +="&searchColumn="+searchColumn
						+"&searchWord="+searchWord+"&";
		}
	}
//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음 
int totalRecordCount = dao.getTotalRecordCount(param);


/*****************************페이지처리 start ***/
//web.xml 의 초기화 파라미터를 가져와서 정수로 변경후 저장
int pageSize = 
	Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
if(boardname.equals("gallery")) pageSize = 6;
int blockPage = 
	Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));

//전체페이지수 계산 => 약105개 / 10 => 10.5 => ceil(10.5) =>11
int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);
/*
현재페이지번호 : 파라미터가 없을때는 무조건 1페이지로 지정하고, 있을때는 해당값을 
	얻어와서 지정한다. 즉 리스트에 처음 진입했을때는 1페이지가 된다.
*/
int nowPage = 
	request.getParameter("nowPage")==null ||
	request.getParameter("nowPage").equals("")? 1 :
	Integer.parseInt(request.getParameter("nowPage"));



//MariaDB를통해 한페이지에 출력할 게시물의 범위를 결정한다. 
//limit의 첫번째인자 : 시작인덱스
int start = (nowPage-1)*pageSize;
//limit의 두번째인자 : 가져올레코드의 갯수
int end = pageSize;

//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
param.put("start", start);
param.put("end", end);
/***************************페이지처리 end**/

//조건에 맞는 레코드를 select하여 결과 셋을 List컬랙션으로 반환받음
List<BbsDTO> bbs = dao.selectListPage(param);
dao.close();

/*게시판별 권한설정**************/
String grade = "";
if(session.getAttribute("USER_GRADE")!=null){
 	grade = session.getAttribute("USER_GRADE").toString();
}
//DB의 긴 Date 타입을 짧게 변환
SimpleDateFormat before = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
SimpleDateFormat isnew = new SimpleDateFormat("yy.MM.dd");

FileDAO fdao = new FileDAO(application);
FileDTO fdto = new FileDTO();

%>