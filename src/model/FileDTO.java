package model;

public class FileDTO {

	
	private String num;			//일련번호=>multi_board와 조인
	private String originfile;	//원본파일명
	private String serverfile;	//서버에 저장된파일명
	private String boardname;	//게시판별 섹션분류
	
	
	

	
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getOriginfile() {
		return originfile;
	}
	public void setOriginfile(String originfile) {
		this.originfile = originfile;
	}
	public String getServerfile() {
		return serverfile;
	}
	public void setServerfile(String serverfile) {
		this.serverfile = serverfile;
	}
	public String getBoardname() {
		return boardname;
	}
	public void setBoardname(String boardname) {
		this.boardname = boardname;
	}
	
	
	
	
	
}



























