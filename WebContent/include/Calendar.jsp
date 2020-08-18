<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
	
	
<%@page trimDirectiveWhitespaces="true" %>



<%--메인 페이지에서 캘린더 를 위한 파일 --%>
<%
	
/*
Calendar클래스는 추상클래스로 생성자를 제공하지 않는다.
따라서 객체생성을 위해 new를 사용할 수 없고 유틸리티 메소드를 통해 객체를 생성한다.


	
*/
	Calendar tDay = Calendar.getInstance();

	
/*
파라미터가 있는경우 : 파라미터에 해당하는 년/월을 표현
없는경우 : 무조건 현재 년/월을 표현
*/
	int y = (request.getParameter("y") == null)
			? tDay.get(Calendar.YEAR)
			: Integer.parseInt(request.getParameter("y"));
	int m = (request.getParameter("m") == null)
			? tDay.get(Calendar.MONTH)
			: Integer.parseInt(request.getParameter("m"));
	int d = tDay.get(Calendar.DATE);
/*
년/월 그리고 1일을 설정한다. 즉 파라미터로 전달된 현재월의 1일로 설정함.	
*/
	Calendar dSet = Calendar.getInstance();
	dSet.set(y, m, 1);

	//오늘이 어떤요일인지 구해온다.
	int yo = dSet.get(Calendar.DAY_OF_WEEK);
	//현재월의 마지막 날짜를 구해온다.(7월=>31일 / 9월=>30일)
	int last_day = dSet.getActualMaximum(Calendar.DATE);
%>
<table cellpadding="0" cellspacing="0" border="0" class="calendar">
	<colgroup>
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="14%" />
		<col width="*" />
	</colgroup>
	<tr>
	<%
	String[] a = {"sun", "mon", "tue", "wed", "thu", "fri", "sat" };
	for(int i=0; i<7; i++){
	%>
		<th style="padding: 5px 0;"><img src="../images/day0<%=i+1 %>.gif" alt="<%=a[i] %>" /></th>
	<%
	}
	%>
	</tr>
	<tr>
	<%
	for(int k=1; k<yo;k++){
	%>
		<td></td>
	<%
	}
	%>
	<%
	for(int j=1; j<last_day;j++){
	%>
		<td><%=j %>
		<%if((yo+j-1) % 7 == 0){ %></td>
	</tr>
	<tr>		
	<%
		}
	}
	for(int e=1; e<(7-yo);e++){
	%>
		<td></td>
	<%
	}
	%>
	</tr>
	
</table>





























