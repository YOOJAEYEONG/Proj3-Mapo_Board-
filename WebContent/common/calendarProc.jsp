<%@page import="org.json.simple.JSONArray"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Collections"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>


<%
System.out.println("calendar.jsp:진입=====================================");
List<Integer> calendar = new ArrayList<Integer>();

Map<Integer,String> calendarDate = new HashMap<Integer,String>();
//List<LocalDate> calendarDate = new ArrayList<LocalDate>();

int change = Integer.parseInt(request.getParameter("change"));

//문서를 처음 로딩할경우 현재 달력출력
LocalDate today = LocalDate.now();
System.out.println("today : "+today);


//다음 버튼을 눌렀을경우 다음월로 셋팅
if(change > 0)
	today = LocalDate.now().plusMonths(change);

//이전 버튼을 눌렀을경우 이전월로 셋팅
if(change < 0){
	today = LocalDate.now().minusMonths(change);
}

System.out.println("thisMonth: "+ today.getMonthValue());



LocalDate localDate = LocalDate.of(today.getYear() , today.getMonth(), today.getDayOfMonth());
LocalDate calDate = LocalDate.of(today.getYear() , today.getMonth(), today.getDayOfMonth());
System.out.println("calDate : "+calDate);


int d=1;
int calendarDate_idx = 1;
//날짜를 하나씩 감소시키면서 이달의 전달과 같아질때까지 반복
for( ; calDate.getMonth().compareTo(today.getMonth().minus(1)) != 0 ; d++) {
	//일-- 
	calDate = LocalDate.of(
			today.getYear() ,
			today.getMonth(),
			today.minusDays(d).getDayOfMonth() );
	
	//1일부터 오늘까지 순차 저장을 위함
	localDate = LocalDate.of(
			today.getYear() ,
			today.getMonth(),
			d );
	System.out.println(calDate+" d: "+d);
	calendar.add(d); 
	
	calendarDate.put(d, localDate.toString());
	//calendarDate.add(localDate);
	
	System.out.println("calDate: "+calDate);
	System.out.println("calendarDate: "+calendarDate.get(d));
//	System.out.println("calendarDate: "+calendarDate.get(d-1));
	
	//변경되는 날짜가 이달의 첫날과 같으면 
	if(calDate.isEqual(today.withDayOfMonth(1)) ) {
		System.out.println("calDate.isEqual(today.withDayOfMonth(1): "
			+calDate.isEqual(today.withDayOfMonth(1)) );
		System.out.println("today2 : "+today);
		//이달의 시작일이 목요일일경우 월요일(1)이 될때까지 0으로 채운다
		if(today.minusDays(d).getDayOfWeek().getValue()!=7){
			for(int i=today.minusDays(d).getDayOfWeek().getValue(); i>=1; i-- ) {
				System.out.println("i: "+i);
				calendar.add(0);						
			}
		}
			
		break;
	}
}
System.out.println("for문 종료");
System.out.println("d  : "+d);//
for(int i=1; i<=6;i++){
	
}




//0을 채운것을 앞으로 보내기위해 정렬
Collections.sort(calendar);
System.out.println("lengthOfMonth: "+today.lengthOfMonth());//30
System.out.println("DayOfMonth:  "+today.getDayOfMonth());//오늘의 날짜:6
System.out.println("today : "+today);//오늘의 날짜:6



System.out.println("마지막날까지 날짜를 추가");
//오늘부터 이번달의 마지막날까지 날짜를 계속 추가한다.
for(int day=today.getDayOfMonth(); day <= today.lengthOfMonth(); day++ ) {
	calendar.add(day);
	
	calDate = LocalDate.of(
			today.getYear() ,
			today.getMonth(),
			day);
	
	
	calendarDate.put(day, calDate.toString());
//	calendarDate.add(localDate);
	
	
	System.out.println("day: "+day);
	System.out.println("calDate: "+calDate);
	System.out.println("calendarDate: "+calendarDate.get(day));
//	System.out.println("calendarDate: "+calendarDate.get(day-1));
}

//System.out.println(today.minusDays(d).getDayOfWeek());	//MONDAY
//System.out.println(today.minusDays(d).getDayOfWeek().getValue());	//1

System.out.println("달력 최종 출력");
int week=1;
for(Integer i : calendar) {
	System.out.print(i+" ");
	if(week++ ==7) {
		System.out.println();
		week = 1;
	}
}
System.out.println();
for( Integer i: calendar)
	System.out.print(i+" ");

//System.out.println("map출력======");
//System.out.println(calendarDate.keySet());

System.out.println(calendarDate.get(1));	//2020-06-01
System.out.println(calendarDate.get(20));	//2020-06-20


JSONObject jsonObject = new JSONObject(calendarDate);
for( Map.Entry<Integer, String> entry : calendarDate.entrySet() ) {
    int key = entry.getKey();
    String value = entry.getValue();
    jsonObject.put(key, value);
}



//////리스팅할때 달력에 일정이 있는경우 표시를 해줌
System.out.println("calendarDate:"+calendarDate);
BbsDAO dao = new BbsDAO(application);
BbsDTO dto = new BbsDTO();




//List<BbsDTO> 로 넘길경우
List<BbsDTO> plans = new ArrayList<BbsDTO>();
String month = today.getMonthValue() >=10 ? 
		Integer.toString( today.getMonthValue()) : 
			"0"+today.getMonthValue();//6
System.out.println(today.getMonthValue());//6
System.out.println(today.getYear());

plans = dao.planList(today.getYear()+"-"+month);

JSONArray jsonArr = new JSONArray();
for(BbsDTO p : plans){
	jsonArr.add(p);
}
System.out.println("jsonArr: "+jsonArr);
System.out.println("jsonArr.toJSONString(): "+jsonArr.toJSONString());
System.out.println("jsonArr.toString(): "+jsonArr.toString());
System.out.println("jsonArr.toArray(): "+jsonArr.toArray());



////////////////////////////////////////리스팅 : 끝
%>
{
	"calendar"		:<%=calendar %>,
	"monthLength"	:<%=today.lengthOfMonth() %>,
	"today"			:<%=LocalDate.now().getDayOfMonth() %>,
	"month"			:<%=today.getMonth().getValue() %>,
	"year"			:<%=today.getYear() %>,
	"thisDate"		:"<%=today.toString() %>",
	"calendarDate"	:<%=jsonObject.toString() %>,
	"plans"			:<%=plans %>
	
}
























