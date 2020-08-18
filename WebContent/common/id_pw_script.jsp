<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<script>


var findMemberInfo = function(toFind){
	$.post(
		'FindProc.jsp',
		{
			'find'	: toFind,
			'name1'	: $('input[name="nameToId"]').val(),
			'email1': $('input[name="emailToId"]').val(),
			'id2'	: $('input[name="idToPass"]').val(),
			'name2'	: $('input[name="nameToPass"]').val(),
			'email2': $('input[name="emailToPass"]').val()
		},
		function (data){
			console.log(data);//json객체 출력됨
			var data = JSON.parse(data);
		
			$('#modal-title').text(data.title);
			$('#modal-content').text(data.content);
		}
	);
}
$(function() {
	$('#findId').click( function() {
		findMemberInfo("id");
	});
	$('#findPass').click( function(){
		findMemberInfo("pass"); 
	});
	
	//아이디 중복검사버튼
	$("#idCheck").click( function() {
		
		$.get(
			'idCheckPerson.jsp',
			{'user_id'	: logFrm.id.value },
			function(data){
				$('#idInputComent').html(data);
				if($('#idInputComent').text() =="사용가능합니다" ){
					$('#id').attr('disabled','disabled');
					$('#signupBtn')
						.removeAttr('disabled')
						.css('opacity', '1.0');
				}
			}
		);
	});
	
	
});

</script>