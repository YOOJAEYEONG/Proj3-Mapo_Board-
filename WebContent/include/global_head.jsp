<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %> 
    
    
<%--JSTL 추가(lib포함)  --%>   
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--
HTML4,5 표준에서는 form.(양식이름) 이런식으로 elements 속성 안쓰고도 바로 접근할 수 있습니다. 하지만 XHTML시절 브라우저에서는 그런 표준이 없기 때문에 크로스 브라우저에서는 elements 속성으로 접근하는게 유효합니다.
특히 DOCTYPE를 XHTML 로 지정했다면, IE를 제외한 모든 브라우저에서 elements 속성을 안쓰고 바로 접근하려 한다면 속성이 null이거나 개체가 아니라고 오류가 뜰겁니다.
 --%>
<!-- <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="Ko" lang="Ko"> -->

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" ></meta>
<meta http-equiv="Content-Script-Type" content="text/javascript" ></meta>
<title>마포구립장애인 직업재활센터</title>
<style type="text/css" media="screen">
	@import url("../css/common.css");
	@import url("../css/main.css");
	@import url("../css/sub.css");
</style>




<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script> -->
<!-- <script src="../jquery/jquery-3.5.1.js"></script> -->
<!-- 
<link href="../bootstrap4.4.1/css/bootstrap.css" rel="stylesheet" ></link>
<script src="../bootstrap4.4.1/js/bootstrap.min.js" ></script> -->

<!--게시판 페이지번호 및 검색 아이콘 CDN  -->
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
 




<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
</head>
</html>