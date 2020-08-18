<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

//멀티게시판 구현을 위한 파라미터 처리
String boardname = request.getParameter("boardname");
if( boardname==null || boardname.equals("") ){
	//만약 bname의 값이 없다면 로그인 화면으로 강제이동시킨다.
	System.out.println("isFlag>메인확면으로 강제이동");
	JavascriptUtil.jsAlertLocation("허용하지 않은 접근입니다", "../member/login.jsp", out);
	return;
}
%>   




