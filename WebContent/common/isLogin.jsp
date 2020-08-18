<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 파일명 : isLogin.jsp --%>
<%
System.out.println("isLogin.jsp:[진입]");
if(session.getAttribute("USER_ID") == null){
	
	System.out.println("isLogIn>"+session.getAttribute("USER_ID") );
	
	//response.sendRedirect("../member/login.jsp");		
%>

	<script>
		alert("로그인 후 이용해주십시요.");
		location.href = "../member/login.jsp";
	</script>
<%
}
%>  