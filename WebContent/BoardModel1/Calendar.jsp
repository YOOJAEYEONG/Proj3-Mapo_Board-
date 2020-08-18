<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="util.PagingUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>



<!--게시판 리스팅 로직  -->    
<%@include file="BoardListProc.jsp" %>

<!--JSTL  -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<style>.days-row{background-color: #eff8f9;}</style>

	<%-- 
<div class="container" >
	<div class="row" >
		<!-- 검색부분 -->
		
		<form class="form-inline ml-auto" name="searchFrm" method="get">
			<input type="hidden" name="boardname" value="<%=boardname%>"/>
			<div class="form-group">
				<select name="searchColumn" class="form-control">
					<option value="title">제목</option>
					<option value="content">내용</option>
				</select>
			</div>
			<div class="input-group">
				<input type="text" name="searchWord" class="form-control" />
				<div class="input-group-btn">
					<button type="submit" class="btn btn-warning">
						<i class='fa fa-search' style='font-size: 20px'></i>
					</button>
				</div>
			</div>
		</form>
	</div>
	 --%>
	
	
<!-- 		<button class="btn btn-sm mx-auto" name="thisMonth" onclick="change('today');">오늘</button> -->
	<div class="row mt-3 mx-auto" >
		
			
		<input type="number" hidden="" value="0" id="change"/>
		<div class="row mx-auto">
			<button class="btn btn-sm mr-auto" name="beforeMonth" onclick="change('before');">이전</button>
			<div class="mx-auto" style="font-size: 2em;"><input readonly="readonly" value="" id="dateDisplay" style="width: 150px; text-align: center;"></input></div>
			<button class="btn btn-sm ml-auto" name="nextMonth" onclick="change('next');">다음</button>
			<input type="text" hidden="" id="datehidden" value=""/>
		</div>
		<table cellpadding="0" cellspacing="0" border="0" class="calendar table" >
			<colgroup>
				<col width="100/7%" />
				<col width="100/7%" />
				<col width="100/7%" />
				<col width="100/7%" />
				<col width="100/7%" />
				<col width="100/7%" />
				<col width="100/7%" />
			</colgroup>
			<tr class="days-row">
				<th><img src="../images/day01.gif" alt="S" /></th>
				<th><img src="../images/day02.gif" alt="M" /></th>
				<th><img src="../images/day03.gif" alt="T" /></th>
				<th><img src="../images/day04.gif" alt="W" /></th>
				<th><img src="../images/day05.gif" alt="T" /></th>
				<th><img src="../images/day06.gif" alt="F" /></th>
				<th><img src="../images/day07.gif" alt="S" /></th>
			</tr  >
			<tbody id="day-calendar"></tbody>
			
		</table>

	</div>

	<!-- The Modal /////////////////////////////////-->
	<div class="modal fade" id="myModal">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title" >Modal Heading</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					
				</div>

				<!-- Modal body -->
				<div class="modal-body" style="font-size:large; height: 200px;">Modal body..</div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button  type="button" class="btn btn-secondary"
						data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>









<script>
	var month = 0;
	var year = 0;
	var selectDate = "";
	
	
		
	
		function change(frm) {
			console.log(frm);
			var val = parseInt($('#change').val());
			if (frm === 'next') {
				$('#change').val(val + 1);
			}
			if (frm === 'before') {
				$('#change').val(val - 1);
			}
			if (frm === 'today') {
				$('#change').val(0);

			}
			val = parseInt($('#change').val());
			calendar(val);
		}

		$(document).keydown(function(event){
			var val = parseInt($('#change').val());
			var key = event.keyCode;
			//왼쪽
			if(key==37){
				$('#change').val(val - 1);
			}
			//오른쪽
			if(key==39){
				$('#change').val(val + 1);
			}
			val = parseInt($('#change').val());
			calendar(val);
			
		});
		
		$(function() {
			//처음진입시 캘린더를 자동 호출한다.
			calendar(0);
			
			
			//날짜를 클릭할경우 
			$(document).on("click",".pickDay",function(){
				var m = month >=10 ? month : '0'+month;
				var d = $(this).val();
				d = d >= 10? d : "0"+d; 


				selectDate = year+"-"+m+"-"+d;
				$('#datehidden').val(selectDate);
				

			$.get("../common/calendar_view.jsp", 
				{"postdate" : selectDate},
				function(d) {
					console.log('성공');
					var rd = JSON.parse(d);
										
					console.log(rd);
					console.log(rd.name);
					console.log(rd.title);
					console.log(rd.content);
					
					$('.modal-title').text(rd.title);
					$('.modal-body').html(rd.content);
					
			});

		});
	});

	//yyyy-MM-dd 포맷으로 변환
	function getFormatDate(date) {

		year = date.getFullYear();
		month = (1 + date.getMonth());
		month = month >= 10 ? month : '0' + month;
		var day = day.getDate();
		day = day >= 10 ? day : '0' + day;
		return year + '-' + month + '-' + day;
	}

	function calendar(num) {
		console.log("함수진입 " + num);
		//console.log("함수진입 "+frm.value); 

		$.get(
			'../common/calendarProc.jsp',
			{"change" : num	},
			function(jdata) {
				console.log('캘린더DB정보 읽어오기 =============================');
				console.log("jdata: " + jdata);

				var data = JSON.parse(jdata);		
				console.log("date: " + data);

				var today = data.today;				console.log("monthLength : " + data.monthLength);
				var total = data.calendar.length;	console.log("total:" + total);
				month = data.month;					console.log("month: " + month);
				year = data.year;					console.log("year: " + year);
				var thisDate = data.thisDate;		console.log("thisDate : " + thisDate);
				
				$.each(data.plans, function (index, value) {
					 
					 console.log("value.name: ");
					 console.log("value.name: "+value.name);
				});
							

				
				
				console.log('캘린더DB 출력===================');

				var weeks = Math.ceil(total / 7);	
				console.log("weeks : " + weeks);
				
				var week = 1;
				var htmlStr = "";
				for (var day = 0; day < total; day++) {
					if (week == 1) {
						htmlStr += "<tr>";
					}

					htmlStr += "<td>";
					if (data.calendar[day] != 0) {
						//console.log("day:"+day);
						htmlStr += "<button data-toggle='modal' data-target='#myModal' class='btn btn-sm pickDay' "+
					"name='pick"+day+"' value='"+data.calendarDate[day]+"' >"
								+ day + "</button>";
					}
					htmlStr += "</td>";

					//날짜와 버튼을 만든후 해당일에 일정이 있으면 속성을 추가한다.
					console.log("plans : "+data.plans);
					
					if (week++ == 7) {
						htmlStr += "</tr>";
						week = 1;
					}

					//캘린더 상단에 년 월을 표시
					$('#dateDisplay').val(year + "년" + month + "월");

				}
				
				//날짜를 담고있는 map객체 파싱
				for ( var key in data.calendarDate) {
					//console.log("key:"+key);//키값 파싱됨
					//console.log("value: "+data.calendarDate[key]);//value값 파싱됨
				}
				
				
				//행을 추가한다
				for (var add = weeks * 7 - total; add > 0; add--) {
					htmlStr += "<td> </td>"
				}

				console.log("추가일:" + (weeks * 7 - total));
				$('#day-calendar').html(htmlStr);
				//console.log(htmlStr);
				htmlStr = "";

				
			}

		);
	}//Calendar////////////////////////////////////////////////
</script>




















