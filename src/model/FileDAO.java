package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Vector;

import javax.servlet.ServletContext;

public class FileDAO {

	Connection con;
	PreparedStatement psmt;
	ResultSet rs;

	public FileDAO(ServletContext ctx) {

		try {
			Class.forName(ctx.getInitParameter("MariaJDBCDriverLocal"));
			String id = "suamil_user";
			String pw = "1234";
			

			con = DriverManager.getConnection(
					ctx.getInitParameter("MariaConnectURLLocal"), id, pw);

			if(con==null) {
				
				Class.forName(ctx.getInitParameter("MariaJDBCDriverWeb"));
				id = "dbwodud89";
				pw = "T3sshutd0n!!";
				
				con = DriverManager.getConnection(
						ctx.getInitParameter("MariaConnectURLWeb"), id, pw);

			}
			System.out.println("mariaDB연결 성공");
		} catch (Exception e) {
			System.out.println("FileDAO>mariaDB연결 예외");
			e.printStackTrace();
		}
	}

	public boolean fileInsert(FileDTO dto) {

		boolean affected = false;
		try {
			//DB에 저장한적이 있는지 검사
			boolean existRec = checkFile(dto);
			
			//파일이 저장된적이 있으면 UPDATE 아니면 INSERT 진행
			if(existRec)	return fileUpdate(dto);	
			
			//첨부파일이 없는 새글도 파일테이블은 null로 추가된다 
			//파일이 저장된적이 없는 완전 신규게시물이면 아래 진행
			String query = " INSERT INTO file_tb "
					+ " (num, originfile, serverfile, boardname) "
					+ " VALUES (?, ?, ?, ?)";

			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getNum());
			psmt.setString(2, dto.getOriginfile());
			psmt.setString(3, dto.getServerfile());
			psmt.setString(4, dto.getBoardname());

			affected = psmt.executeUpdate()==1 ? true : false ;
		} catch (Exception e) {
			System.out.println("FileDAO>insert : 예외");
			e.printStackTrace();
		}
		return affected;
	}
	
	public boolean checkFile(FileDTO dto) {

		boolean hasRec = false;
		try {
			String query = " SELECT num FROM file_tb "
					+ " WHERE num = ? ";

			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getNum());

			rs = psmt.executeQuery();
			
			//num 값으로 저장된적이 있으면 true
			if(rs.next()) hasRec = true;
		} catch (Exception e) {
			System.out.println("FileDAO>checkFile : 예외");
			e.printStackTrace();
		}
		return hasRec;
	}
	
	
	
	public boolean fileUpdate(FileDTO fDTO) {

		boolean affected = false;
		try {
			String query = " UPDATE file_tb "
					+ " SET originfile = ?, serverfile = ? "
					+ " WHERE num = ? ";
			
			

			psmt = con.prepareStatement(query);
			psmt.setString(1, fDTO.getOriginfile());
			psmt.setString(2, fDTO.getServerfile());
			psmt.setString(3, fDTO.getNum());

			affected = (psmt.executeUpdate()==1 ? true : false );
		} catch (Exception e) {
			System.out.println("FileDAO>Update : 예외");
			e.printStackTrace();
		}
		return affected;
	}
	
	
	
	public FileDTO getFile(String num) {
		
		FileDTO fDTO = new FileDTO();
		
		try {
			String query = "SELECT * FROM file_tb  "
					+ " WHERE num = ? ";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			
			rs = psmt.executeQuery();
			if(rs.next()) {
				fDTO.setNum( Integer.toString(	rs.getInt("num")) );
				fDTO.setOriginfile(				rs.getString("originfile"));
				fDTO.setServerfile(				rs.getString("serverfile"));
				fDTO.setBoardname(				rs.getString("boardname"));
			}
			
		} catch (Exception e) {
			System.out.println("FileDAO>getFile : 예외");
			e.printStackTrace();
		}
		return fDTO;
	}
	
	
	public List<FileDTO> fileList() {
		List<FileDTO> fileList = new Vector<FileDTO>();
		
		String query = "SELECT * FROM file_tb "
				+ " WHERE 1=1 "
				+ "	ORDER BY num DESC ";
		System.out.println("fileList:QUERY>"+query);
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			while (rs.next()) {
				FileDTO dto = new FileDTO();
				dto.setNum(Integer.toString( rs.getInt(1) ));
				fileList.add(dto);
			}
			
			
		} catch (Exception e) {
			System.out.println("FileDAO>fileList:예외");
			e.printStackTrace();
		}
		return fileList;
	}


	public void fileDelete(FileDTO fDTO) {
		try {
			String query = " DELETE FROM file_tb WHERE num = ? ";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, fDTO.getNum());

			if(1 == psmt.executeUpdate()) {
				System.out.println("수정글>첨부파일삭제하기 적용됨");
			}
		} catch (Exception e) {
			System.out.println("FileDAO>Update : 예외");
			e.printStackTrace();
		}
	}


	public void close() {
		try {
			if(con!=null) 	con.close();
			if(psmt!=null)	psmt.close();
			if(rs!=null)	rs.close();
		
		} catch (Exception e) {
			e.printStackTrace();
		}
	}




}























