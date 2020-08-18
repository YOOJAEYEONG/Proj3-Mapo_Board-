<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>


<%
request.setCharacterEncoding("UTF-8");

	
BbsDAO dao = new BbsDAO(application);
BbsDTO dto = new BbsDTO();

String postdate = request.getParameter("postdate");

dto = dao.selectPlanView(postdate);
dao.close();

System.out.println(dto.getTitle());
System.out.println(dto.getContent());
System.out.println(dto.getName());

String title = dto.getTitle()==null?"일정이 없습니다." : dto.getTitle();
String content = dto.getContent()==null? " " : dto.getContent();
String name = dto.getName()==null? "" : dto.getName();
%>
{
	"title" : "<%=title %>",
	"content" : "<%=content%>",
	"name" : "<%=name %>"
}