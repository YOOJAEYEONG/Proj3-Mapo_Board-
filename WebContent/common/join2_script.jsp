<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<script>

var chkFormFlag = false;

function confirmSignForm(frm) {
	concole.log('confirmSignForm진입');
	alert($('#idInputComent').text());
	if(chkFormFlag == false && $('#idInputComent').text() !="사용가능합니다" ){
		alert('아이디중복확인 및 입력양식을 확인해주세요.');
		return false;
	}else{
		concole.log('confirmSignForm:else진입');
	return false;
	
		return true;
	}
}





$(function() {
	
	//회원가입첫 진입시 가입완료버튼을 비활성화	
	$('#signupBtn')
		.css('opacity', '0.2');
		
	
	
	//회원기입 확인버튼 마우스 오버시 툴팁
	$('[data-toggle="tooltip"]').tooltip(); 
	
	
	//선택한 이메일로 적용하고 도메인 항목을 편집 불가하도록 만든다.
	$('#last_email_check2').change(function() {
			//console.log('jQuery진입');
			console.log($('#last_email_check2 option:selected').val());
			if($('select[name="last_email_check2"] option:selected').val() == "self"){
				//console.log('self진입');
				$("input[name='email_2']")
					.removeAttr("disabled")
					.val('');
			}else{
				$("input[name='email_2']")
				.attr("disabled", "disabled")
				.val($('#last_email_check2 option:selected').val());
			}
	});

	//아이디비번체크식
	var RegExp1 = /^[a-z0-9]{4,12}$/; 
	var RegExp2 = /[a-z]/g;
	var RegExp3 = /[0-9]/g;
	//아이디입력시 조건에 맞는값인지 체크한다.
	$('input[name="id"]').keyup(function() {
		if (
			RegExp1.test($(this).val()) &&
			RegExp2.test($(this).val()) &&
			RegExp3.test($(this).val()) 
			) {
			$('#span_id').removeAttr("style");
			chkFormFlag = true;
		} else {
			$('#span_id').attr("style", 'color:red');
			chkFormFlag = false;
		}
	});
	
	//비번입력시 조건에 맞는값인지 체크한다.
	$('input[name="pass"]').keyup(function() {
		console.log($(this).val());
		if (	
				RegExp1.test($(this).val()) &&
				RegExp2.test($(this).val()) &&
				RegExp3.test($(this).val()) 
			) {
			$('#span_pass').removeAttr("style");
			chkFormFlag = true;
		} else {
			$('#span_pass').attr("style", 'color:red');
			chkFormFlag = false;
		}
	});
	//비번 일치 검사
	$('input[name="pass2"]').keyup(
		function(){
			var pass = $('input[name="pass"]').val();
			var pass2 = $('input[name="pass2"]').val();
			console.log( pass2);
			if( pass != pass2 ){
				$('#passchk').removeAttr("hidden");
				$('input[name="pass2"]').css('border-bottom-color','red');
				chkFormFlag = false;
			}else{
				$('#passchk').attr("hidden","hidden");
				$('input[name="pass2"]').css('border-bottom-color','');
				chkFormFlag = true;
			}
		}		
	);
	
});
	
	//아이디 중복검사버튼
	$("#idCheck").click( function() {
		
		if( $('input[name="id"]').val() == "" ){
			alert('아이디를 입력하세요');
			return;
		}
		else if( ( $('input[name="id"]').val() ).indexOf(" ") != -1 ){
			alert('공백이 포함되어있습니다.');
			return;
		}
		else if( chkFormFlag == false){
			alert('양식에 맞지 않습니다.');
			return;
		} else {
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
		}
		
		
	});

//다음주소검색api
function DaumPostcode(){
	new daum.Postcode({
	    oncomplete: function(data) {
	    	// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if(data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("addr2").value = extraAddr;
            
            } else {
                document.getElementById("addr2").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('zip1').value = data.zonecode;
            document.getElementById("addr1").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("addr2").focus();
	    }
	}).open();			
}

	
	
</script>