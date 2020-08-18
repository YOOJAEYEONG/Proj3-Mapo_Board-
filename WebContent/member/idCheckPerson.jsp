<%@page import="java.util.Map"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>   

<%
System.out.println("idCheckPerson.jsp진입");

String id = request.getParameter("user_id");   


//회원가입>중복확인버튼을 눌렀을때

System.out.println("id="+ id);

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

MemberDAO dao = new MemberDAO(drv, url);

//저장된아이디가 있으면 아이디중복된것임
boolean hasMember = dao.isMember(id);
	
String html = "";

if(hasMember ){
	//중복된 아이디가 있는경우
	html = "<b style='color:red;'>사용중인 아이디입니다</b>";
}
else {
	//중복되는 아이디가 없는경우 
	html = "<b>사용가능합니다</b>";
}
out.print(html);
%>