<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 파일명 : adminIsLogin.jsp --%>
<%
System.out.println("adminIsLogin.jsp:[진입]");
if(session.getAttribute("USER_ID") == null){
%>
		<script>
		alert("로그인 후 이용해주십시요.");
		location.href = "login.jsp";
		</script>
<%		
}
%>  
