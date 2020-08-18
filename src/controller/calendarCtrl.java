package controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.time.temporal.ChronoField;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class calendarCtrl{
	
	public static void main(String[] args) {
/*
1. isEqual() 메소드 : equals() 메소드와는 달리 오직 날짜만을 비교함. (LocalDate 클래스에서만 제공)
2. isBefore() 메소드 : 두 개의 날짜와 시간 객체를 비교하여 현재 객체가 명시된 객체보다 앞선 시간인지를 비교함.
3. isAfter() 메소드 : 두 개의 날짜와 시간 객체를 비교하여 현재 객체가 명시된 객체보다 늦은 시간인지를 비교함.

LocalDate today = LocalDate.now();
LocalDate otherDay = LocalDate.of(1982, 02, 19);

System.out.println(today.compareTo(otherDay));	//35
System.out.println(today.isBefore(otherDay));	//false
System.out.println(today.isEqual(otherDay));	//false
*/
		
		//LocalDate localDate = new LocalDate(lastWeek, lastWeek, lastWeek);
		System.out.println("현재 날짜 : "+ LocalDate.now());// 2020-06-06
		System.out.println("현재 시간 : "+ LocalTime.now());//18:58:17.026
		
		LocalDate setDay = LocalDate.of(1982, 02, 19);
		
		// static LocalTime of(int hour, int minute, int second, int nanoOfSecond)
		LocalTime birthTime = LocalTime.of(02, 02, 00, 100000000);
		LocalDate today = LocalDate.now();
		LocalDate otherDay = LocalDate.now().minusDays(6);//otherDay: 2020-05-31
		LocalDate bfoMonth = LocalDate.now().minusMonths(1);
		
		System.out.println("today: "+today);		// 2020-06-06
		System.out.println("otherDay: "+otherDay);	// 2020-05-31
		
		//today의 지난달로 날짜를 샛팅
		LocalDate calDate = LocalDate.of(today.getYear() , today.getMonth(), today.getDayOfMonth());
		//LocalDate calDate = LocalDate.of(today.getYear() , today.getMonth().minus(1), today.getDayOfMonth());//MAY
		System.out.println("calDate:  "+calDate);	//2020-05-06
		System.out.println("비교:  "+calDate.getMonth().compareTo(today.getMonth()) );	//-1
		
		System.out.println("for문실행");
		List<Integer> calendar = new ArrayList<Integer>();
		
		int d=1;
		//날짜를 하나씩 감소시키면서 이달의 전달과 같아질때까지 반복
		for( ; calDate.getMonth().compareTo(today.getMonth().minus(1)) != 0 ; d++) {
			//일-- 
			calDate = LocalDate.of(
					today.getYear() ,
					today.getMonth(),
					today.minusDays(d).getDayOfMonth() );
			System.out.println(calDate+" d: "+d);
			calendar.add(d);
			System.out.println("calDate: "+calDate);
			//변경되는 날짜가 이달의 첫날과 같으면 
			if(calDate.isEqual(today.withDayOfMonth(1)) ) {
				System.out.println("calDate.isEqual(today.withDayOfMonth(1): "+calDate.isEqual(today.withDayOfMonth(1)) );
				//이달의 시작일이 목요일일경우 월요일(1)이 될때까지 0으로 채운다
				for(int i=today.minusDays(d).getDayOfWeek().getValue(); i>1; i-- ) {
					System.out.println("i: "+i);
					calendar.add(0);						
				}
				//만약 월요일이면 일요일을 위해 한번더 0으로 채우고 반복문 탈출
				if(today.minusDays(d).getDayOfWeek().getValue()==1) {
					calendar.add(0);	
					break;
				}
			}
		}
		System.out.println("for문 종료");
		//0을 채운것을 앞으로 보내기위해 정렬
		Collections.sort(calendar);
		System.out.println(LocalDate.now().lengthOfMonth());//30
		System.out.println(today.getDayOfMonth());//오늘의 날짜:6
		
		//오늘부터 이번달의 마지막날까지 날짜를 계속 추가한다.
		for(int day=today.getDayOfMonth(); day <= today.lengthOfMonth(); day++ ) {
			calendar.add(day);
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
		
	}
}
