<%@page import="java.util.Map"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page trimDirectiveWhitespaces="true" %>   

<%-- 아이디찾기 --%>
<%
System.out.println("FindIdProc.jsp진입");
request.setCharacterEncoding("UTF-8");

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

MemberDAO dao = new MemberDAO(drv, url);

String toFind = request.getParameter("find");    

if(toFind.equals("id")){
	String name = request.getParameter("name1");    
	String email = request.getParameter("email1");  

	String memberId = dao.getMemberId(name, email);
%>
{"title":"아이디찾기 결과", "content":"회원님의 아이디는 <%=memberId %> 입니다."}
<%
}
else if(toFind.equals("pass")){

	String id = request.getParameter("id2");    
	String email = request.getParameter("email2");  
	String name = request.getParameter("name2");   
	
	System.out.println("id:  "+id);
	System.out.println("name:  "+name);
	System.out.println("email:  "+email);
	
	Boolean Proc = dao.getMemberPass(id, name, email, request );
	
	if(Proc == true){
%>
	{"title":"비밀번호찾기 결과", "content":"회원님의 비밀번호는 이메일로 발송되었습니다."}
<%	}else{%>
	{"title":"비밀번호찾기 결과", "content":"일치하는 결과가 없습니다."}
<% 
	}
}
dao.close();
%>














