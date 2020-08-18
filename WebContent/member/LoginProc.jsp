<%@page import="model.MemberDAO"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
System.out.println("LoginProc.jsp진입");




String id = request.getParameter("user_id");    
String pw = request.getParameter("user_pw");   

//로그인할때 아이디저장하기 체크박스
String saveID = request.getParameter("saveId");   
System.out.println("saveID"+saveID);


    
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

MemberDAO dao = new MemberDAO(drv, url);



//방법3 : Map 컬렉션에 회원정보 저장 후 반환 받기
Map<String, String> memberInfo = dao.getMemberMap(id, pw);

//맵의 id 키값에 저장된 값이 있는지 확인 
if(memberInfo.get("id") != null){
	//저장된 값이 있다면.. 세션영역에 아이디, 패스워드, 이름을 속성으로 저장한다.
	session.setAttribute("USER_ID", memberInfo.get("id"));
	session.setAttribute("USER_PW", memberInfo.get("pass"));
	session.setAttribute("USER_NAME", memberInfo.get("name"));
	session.setAttribute("USER_GRADE", memberInfo.get("grade"));
	
	System.out.println("saveID: "+ saveID);
	if(saveID != null){
		System.out.println("쿠키저장진입");
		Cookie ck = new Cookie("USER_ID", id);
		ck.setPath(request.getContextPath());
		ck.setMaxAge(3600*100);//100일동안 쿠키를 유지한다.
		response.addCookie(ck);
	}else {
		System.out.println("쿠키삭제진입");
		Cookie ck = new Cookie("USER_ID", "");
		ck.setPath(request.getContextPath());
		ck.setMaxAge(0);//유효시간이 0이므로 사용할 수 없는 쿠키가 된다.
		response.addCookie(ck);
	}
	
	response.sendRedirect("../main/main.jsp");
}
else {
	out.print("<script>alert('로그인실패하였습니다');</script>");
	response.sendRedirect("login.jsp");

	//request.getRequestDispatcher("Login.jsp").forward(request, response);
}

%>

























