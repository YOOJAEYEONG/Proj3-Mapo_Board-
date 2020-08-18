<%@page import="java.util.Enumeration"%>
<%@page import="model.MemberDAO"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
System.out.println("adminLoginProc.jsp진입");



String id = request.getParameter("id");    
String pw = request.getParameter("password");    

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

MemberDAO dao = new MemberDAO(drv, url);



//방법3 : Map 컬렉션에 회원정보 저장 후 반환 받기
Map<String, String> memberInfo = dao.getMemberMap(id, pw);

//맵의 id 키값에 저장된 값이 있는지 확인 
if(memberInfo.get("id") != null){
	if(memberInfo.get("grade").equals("관리자")==false){
		request.setAttribute("ERROR_MSG", "관리자만 접근가능합니다.");
		request.getRequestDispatcher("./login.jsp").forward(request, response);
	}
	//저장된 값이 있다면.. 세션영역에 아이디, 패스워드, 이름을 속성으로 저장한다.
	session.setAttribute("USER_ID", memberInfo.get("id"));
	session.setAttribute("USER_PW", memberInfo.get("pass"));
	session.setAttribute("USER_NAME", memberInfo.get("name"));
	session.setAttribute("USER_GRADE", memberInfo.get("grade"));
	
	response.sendRedirect("index.jsp");

}
else {
	request.setAttribute("ERROR_MSG", "로그인에 실패하였습니다.");
	//response.sendRedirect("login.html");
	
	request.getRequestDispatcher("./login.jsp").forward(request, response);
}

%>

























