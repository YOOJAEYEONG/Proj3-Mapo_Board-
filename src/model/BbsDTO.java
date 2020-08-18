package model;

import java.sql.Date;
import java.util.Map;

public class BbsDTO {
	/*
	DTO객체를 만들때 테이블 컬럼의 타입과는 상관없이 대부분의 멤버변수는 
	String형으로 정의하면된다.
	JSP에서 산술연산이 꼭 필요한 경우에만 int, double과 같이 숫자형으로 정의한다.
	*/
	

	
	
	private String 
		num,
		title,
		content,
		postdate,
		id,
		visitcount,
		boardname,
		pass,
		//▼join 용 변수
		name;
	

	
	
	
	public BbsDTO() {}
	
	
	
	public BbsDTO(String num, String title, String content, String postdate,
			String id, String visitcount, String boardname, String name, String pass) {
		super();
		this.num = num;
		this.title = title;
		this.content = content;
		this.postdate = postdate;
		this.id = id;
		this.visitcount = visitcount;
		this.boardname = boardname;
		this.name = name;
		this.pass = pass;
		
	}

	
	
	
	
	
	




	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getPostdate() {
		return postdate;
	}

	public void setPostdate(String postdate) {
		this.postdate = postdate;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getVisitcount() {
		return visitcount;
	}

	public void setVisitcount(String visitcount) {
		this.visitcount = visitcount;
	}

	public String getBoardname() {
		return boardname;
	}

	public void setBoardname(String boardname) {
		this.boardname = boardname;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	
	
	

	
}
