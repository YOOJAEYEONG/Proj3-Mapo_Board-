package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.swing.text.html.HTMLDocument.Iterator;

import smtp.SMTPAuth;

public class MemberDAO {
	
	//멤버변수(클래스전체 멤버메소드에 접근가능)
	Connection con;	// 데이터 베이스와 연결을 위한 객체
	PreparedStatement psmt; 
	ResultSet rs;	// SQL & DB 질의에 의해 생성된 테이블을 저장하는 객체입니다.
	//Statement stmt;	// SQL 문을 데이터베이스에 보내기위한 객체
	
	//기본생성자
	public MemberDAO() {
		System.out.println("MemberDAO생성자호출");
	}
	public MemberDAO(String driver, String url) {
		try {
			//드라이버로드
			Class.forName(driver);
			String id = "suamil_user";
			String pw = "1234";
			
			
			con = DriverManager.getConnection(url, id, pw);
			
			if(con==null) {
				id = "dbwodud89";
				pw = "T3sshutd0n!!";
				con = DriverManager.getConnection(url, id, pw);
			}
			
			System.out.println("DB연결 성공");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//방법1 : 회원의 존재 유무만 판단한다.
	public boolean isMember(String id) {
		
		//COUNT()의 실행결과 결과가 없으면 0을 반환한다. 
		//COUNT() => 0, 1, ~~~~99의 다중값 반환할 것임
		String sql = "SELECT COUNT(*) FROM membership " +
				" WHERE id=? ";
		int isMember = 0;
		boolean isFlag = false;
		
		try {
			//prepare 객체로 쿼리문 전송
			psmt = con.prepareStatement(sql);
			//인파라미터 설정
			psmt.setString(1,id);
			
			//쿼리 실행
			rs = psmt.executeQuery();
			//실행된 결과를 가져오기위해 next()호출
			rs.next();/*여기서는 결과유무에 따라 true,false를 반환하고
				여기서는 count()함수를 썼기 때문에 무조건 0 또는 0이상의 값을 반환하게 된다.
			*/
			isMember = rs.getInt(1);
			System.out.println("afftected:"+ isMember);
			
			if(isMember==0)	isFlag = false;
			else			isFlag = true;
			
		} catch (Exception e) {
			isFlag = false;
			e.printStackTrace();
		}
		return isFlag;
	}
	
	
	
	
	//방법2 : 회원 인증후 MemberDTO객체로 회원정보를 반환한다.
	public MemberDTO getMemberDTO(String uid, String upass) {
		//DTO객체를 생성한다.
		MemberDTO memberDTO = new MemberDTO();
		
		String query = "SELECT id, pass, name, grade FROM membership " +
				" WHERE id=? AND pass=? ";
		
		try {
			//prepared 객체 생성
			psmt = con.prepareStatement(query);
			//쿼리문에 인파라미터 설정
			psmt.setString(1, uid);
			psmt.setString(2, upass);
			
			//오라클로 쿼리문 전송 및 실행결과를 ResultSet으로 반환받음;
			//지금상태에서는 결과유무를 모른다.
			rs = psmt.executeQuery();//SQL 질의 결과를 ResultSet에 저장합니다.
			
			/*
			실행된 결과를 가져오기위해 next()호출
			-결과가 1 개인 경우
				if(rs.next()) { }
			-결과가 2개 이상인 경우
				while(rs.next()) { }
				
				rs.next() : 반환된 레코드 한줄으 읽어온다 . 결과값이 여러개일경우 
				while()을통해 여러줄을 읽어온다.
			 */
			
			//오라클이 반환해준 ResultSet이 있는지 확인
			if(rs.next()) {
				// 이 함수에서 객체를 반환하는 이유?
				//  함수는 하나의 값많을 반황할 수 있기 때문에 회원 레코드의 여러 값을 
				//  객체로 만들어 반환하는 것이다.
				
				memberDTO.setId(rs.getString("id"));
				memberDTO.setPass(rs.getString("pass"));
				memberDTO.setName(rs.getString(3));//3번컬럼(오라클인덱스는1부터)
				//getter사용에서 컬럽 순서지정과 컬럽네임으로 얻어오는 방법에 주시
				memberDTO.setName(rs.getString("grade"));
			}
			else {
				System.out.println("결과 셋이 없습니다.");
			}
		} catch (Exception e) {
			System.out.println("getMenberDTO오류:");
			e.printStackTrace();
		}
		return memberDTO;
	}
	
	
	//방법3 : 회원 인증후 MemberDTO객체로 회원정보를 반환한다.
	public Map<String, String> getMemberMap(String id, String pwd) {
		
		Map<String, String> maps = new HashMap<String, String>();
		
		String query = "SELECT id, pass, name, grade FROM membership " +
				" WHERE id=? AND pass=? ";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			psmt.setString(2, pwd);
	
			rs = psmt.executeQuery();
			
			if(rs.next()) {
				maps.put("id", rs.getString("id"));
				maps.put("pass", rs.getString("pass"));
				maps.put("name", rs.getString("name"));
				maps.put("grade", rs.getString("grade"));
			}
			else {
				System.out.println("결과 맵이 없습니다.");
			}
		} catch (Exception e) {
			System.out.println("getMenberDTO오류:");
			e.printStackTrace();
		}
		return maps;
	}


	//회원가입;회원가입폼을 DB에 저장
	public void addMember(Map<String,String> signUpFrm){
		
		
		String query = "INSERT INTO membership ( "
				+ " name, id, pass, tel, phone, email, subscribe, address, zipcode)"
				+ " VALUES (?,?,?,?,?,?,?,?,?) ";
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, signUpFrm.get("name"));
			psmt.setString(2, signUpFrm.get("id"));
			psmt.setString(3, signUpFrm.get("pass"));
			psmt.setString(4, signUpFrm.get("tel"));
			psmt.setString(5, signUpFrm.get("phone"));
			psmt.setString(6, signUpFrm.get("email"));
			psmt.setString(7, signUpFrm.get("subscribe"));
			psmt.setString(8, signUpFrm.get("address"));
			psmt.setString(9, signUpFrm.get("zipcode"));
			
			psmt.executeUpdate(); 
			
		} catch (Exception e) {
			System.out.println("MemberDAO예외>>");
			e.printStackTrace();
		}
	}

	//아이디찾기
	public String getMemberId(String name, String email) {
		
		
		String query = "SELECT id FROM membership " +
				" WHERE name = ? AND email = ? ";
		String resultId =null;
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, name);
			psmt.setString(2, email);
	
			rs = psmt.executeQuery();
			if(rs.next())	{
				System.out.println("if문진입");
				resultId = rs.getString(1);
				System.out.println("sql실행결과:"+resultId);
			}
		} catch (Exception e) {
			System.out.println("MemberDAO;getMemberId:예외>>");
			e.printStackTrace();
			e.getStackTrace();
			e.getMessage();
		}
		close();
		return resultId;
	}
	
	//비번찾기
	public boolean getMemberPass(String id, String name, String email, HttpServletRequest req) {
		
		
		String query = "SELECT pass FROM membership " +
				" WHERE id=? AND name = ? AND email = ? ";
		boolean resultPass = false;
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			psmt.setString(2, name);
			psmt.setString(3, email);
			
			rs = psmt.executeQuery();
			if(rs.next())	{
				String getPass = rs.getString(1);
				System.out.println("sql실행결과: "+getPass);
				resultPass = sendMailPass(getPass , req, email);
			}
		} catch (Exception e) {
			System.out.println("MemberDAO;getMemberId:예외>>");
			e.printStackTrace();
			e.getStackTrace();
			e.getMessage();
		}
		close();
		return resultPass;
		
	}

	public boolean sendMailPass(String pass, HttpServletRequest req, String email) {
		
		SMTPAuth smtp = new SMTPAuth();
		Map<String, String> emailContent = new HashMap<String, String>();
		
		String adminMail = null;
		String query = "SELECT DISTINCT email FROM membership " +
				" WHERE grade = '관리자' ";
		String subject = "복지관:회원비밀번호를 보내드립니다.";
		String content = "귀하의 비밀번호를 확인하세요<br>&emsp;"+pass;
		
		try {
			req.setCharacterEncoding("UTF-8");
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			
			if(rs.next())	adminMail = rs.getString("email");
			
			
		} catch (Exception e) {
			System.out.println("sendMailPass예외>>");
			e.printStackTrace();
		}
		
		emailContent.put("from",	adminMail);
		emailContent.put("to", 		email);
		emailContent.put("subject", subject);
		emailContent.put("content", content);

		close();
		
		boolean emailResult = false;
		if(adminMail != null) {
			emailResult = smtp.emailSending(emailContent);
			
			if(emailResult==true)	{
				System.out.println(email+"에게 메일발송됨");
				return emailResult;
			}
			else {
				System.out.println(email+"에게 메일발송 실패함.");
			}
		}
		return emailResult;
	}
	
	
	public void close() {
			try {
				if(con!=null)	con.close();
				if(psmt!=null)	psmt.close();
				if(rs!=null)	rs.close();
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
	}
}

























