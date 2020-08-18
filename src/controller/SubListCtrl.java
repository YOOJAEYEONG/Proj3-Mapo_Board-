package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.FileRenamePolicy;

import model.BbsDAO;
import model.BbsDTO;
import model.FileDAO;
import model.FileDTO;
import util.JavascriptUtil;

@WebServlet("/community/SubList.do")
public class SubListCtrl extends HttpServlet {

	HttpServletRequest req;
	HttpServletResponse resp;
	PrintWriter out;
	ServletContext application;
	HttpSession session;
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}

	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		System.out.println("서블릿 진입");
		String ctrl = req.getParameter("command");
		System.out.println("command=>"+ctrl);
		
		
		try {
			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html;charset=utf-8");
			PrintWriter out = resp.getWriter();
			ServletContext application = req.getServletContext();
			HttpSession session =req.getSession();
			
			this.req = req;
			this.resp = resp;
			this.out = out;
			this.application = application;
			this.session = session;
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		switch (ctrl) {
			case "write" :	doWrite();	break;
			case "insert" : doInsert();	break;
			case "delete" :	doDelete();	break;
			case "view" :	doView();	break;
			case "list" : 	dolist();	break;
			default :					break;
		}
		
	}



	public void isLogin() {
		if(session.getAttribute("USER_ID") == null){
			
			System.out.println("isLogIn>"+session.getAttribute("USER_ID") );
			JavascriptUtil.jsAlertLocation(
					"로그인 후 이용해주십시요.", "../member/login.jsp");
		}//////////////////////////////////////////////////////
	}
	
	private void doDelete() {

		System.out.println("SubListCtrl>doDelete:진입");
		
		
		isLogin();
		
		
		
		String num = req.getParameter("num");
		String boardname = req.getParameter("boardname");
		String nowPage = req.getParameter("nowPage");


		BbsDTO dto = new BbsDTO();
		BbsDAO dao = new BbsDAO(application);

		//작성자본인 확인을 위해 기존 게시물의 내용을 가져온다.
		dto = dao.selectView(num);

		//세션영역에 저장된 로그인아이디를 Object=>String으로 가져온다.
		String sesstion_id = 
			session.getAttribute("USER_ID").toString();
		System.out.print("session.getAttribute(\"USER_ID\"): "+session.getAttribute("USER_ID"));

		int affected = 0;

		//세션영역과 DB상의 작성자가 동일한지 확인하여 true일때는 삭제 처리
		if(sesstion_id.equals(dto.getId())){
			dto.setNum(num);
			affected = dao.delete(dto);
		}
		else {
			//경고창으로 알림후 뒤로가기 처리
			JavascriptUtil.jsAlertBack("본인만 사용가능합니다.");
			return;
		}
		if(affected ==1){
			JavascriptUtil.jsAlertLocation("삭제되었습니다.",
					"../community/SubList.do?command=list&boardname="+boardname+"&nowPage="+nowPage, out);
		}
		else{
			out.println("삭제실패하였습니다.");
		}

	}//doDelete


	private void doInsert() {

		System.out.println("SubListCtrl>doInsert():진입");
		
		isLogin();
		
		
		try {
			req.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}//////////////////////////////////////////////////////////////



		/***********파일 업로드를 위한처리*/
		String saveDirectory = application.getRealPath("/Data");
		System.out.println("saveDirectory>"+saveDirectory);//정상
		int maxPostSize = 1024*10*1000;
		String encodeType = "UTF-8";

		FileRenamePolicy policy = new DefaultFileRenamePolicy();
		MultipartRequest mr = null;



		//BbsDAO에 저장할 객체
		String title = null; 
		String content = null; 
		/*사용자의 입력값을 DTO객체에 저장후 파라미터로 전달
		DB에 삽입 후 해당 게시물의 DB num값을 반환한다.*/
		String num = "0"; 

		//BbsDAO와 file_tb에 저장할 객체
		String boardname = "";

		//FileDAO에 저장할 객체
		File oldFile = null;
		File newFile = null;
		String realFileName = null;
		String delFileFlag = "";//파일수정시 첨부했던 파일을 삭제할때

		boolean resultSaveFile = false;
		String fileName = "";
		String editMode = "";

		FileDTO fDTO = new FileDTO();
		FileDAO fDAO = new FileDAO(application);
		BbsDTO dto = new BbsDTO();
		BbsDAO dao = new BbsDAO(application);

		try{
			
			mr = new MultipartRequest(req, saveDirectory,
					maxPostSize, encodeType, policy);
			if(mr!=null){
				System.out.println("MultipartRequest :생성됨");
			}
		}catch(Exception e){
			System.out.println("WriteProc>MultipartRequest:생성예외");
			e.printStackTrace();
		}////////////////////////////////////////////////////////
		try{
			/**파일 이름 변경 로직*******/
			fileName = mr.getFilesystemName("attachFile");
			if(fileName != null){
				System.out.println("파일이름 변경: 진입");
				System.out.println("fileName :  "+fileName);//첨부를 안할경우 null		
				int idx = -1;
				idx = fileName.lastIndexOf(".");
				
				String nowTime = 
						new SimpleDateFormat("yyyy_MM_dd_H_m_s_S").format(new Date());
				realFileName = nowTime+fileName.substring(idx, fileName.length());
				
				oldFile = new File(saveDirectory+File.separator+fileName);
				newFile = new File(saveDirectory+File.separator+realFileName);
				oldFile.renameTo(newFile);//이름변경
				
				System.out.println("파일이름 변경됨:"+newFile);
			}
		}catch(Exception e){
			System.out.print("파일이름 변경:예외");
			e.printStackTrace();
		}/////////////////////////////////////////////////////////	
			
			
		try{
			System.out.println("WriteProc>폼값받기 :시작");
			title = mr.getParameter("title");
			content = mr.getParameter("content");
			boardname = mr.getParameter("boardname");
			//출력된는 null값이 String타입의 null 문자열이다.
			editMode = mr.getParameter("editMode");
			
			//폼값을 DTO객체에 저장한다.
			dto.setTitle(title);
			dto.setContent(content);
			dto.setBoardname(boardname);
			dto.setId(session.getAttribute("USER_ID").toString());
		}catch(Exception e){
			System.out.println("WriteProc>폼값받기 :예외");
			e.printStackTrace();
		}////////////////////////////////////////////////////


		try{
			
			/*
			해당 진행이 수정모드가 이니면 DB의 num 값은 
			없는 것이므로 insert 후 DB에서 자동 부여된 num 값을 리턴 받는다.
			기존글 수정모드인경우 num 값이 있으므로 파라미터로 받는다.
			*/
			if(editMode.equals("authorized"))	{
				System.out.println("WriteProc>authorized: 진입");
				
				num = mr.getParameter("num");
				System.out.println("num:  "+num);
				dto.setNum(num);
				
				//수정하기 + 첨부파일삭제 클릭여부
				delFileFlag = mr.getParameter("delFileFlag");
				System.out.println("delFileFlag: "+delFileFlag);
				
				//게시판테이블 수정, 수정하기는 이미 부여된num 값이 있으므로
				//글 수정후 반환 받을 필요가 없다.
				dao.updateWrite(dto);
				System.out.println("WriteProc:num:"+num);
				
				if(delFileFlag!=null)
					if(delFileFlag.equals("deleteFile")){
						System.out.println("WriteProc>deleteFile: 진입");
						//파일테이블에서 파일 삭제
						fDTO.setNum( num );
						fDAO.fileDelete(fDTO);
					}
				
				System.out.println("fileName: "+fileName);
				try{
					if(fileName != null){
						System.out.println("첨부파일이 있는경우 실행");
						fDTO.setNum(num);
						fDTO.setBoardname(boardname);
						fDTO.setOriginfile(fileName);
						fDTO.setServerfile(realFileName);
						System.out.println("num"+num+"boardname"+boardname+"filename"+
							fileName+"realFileName"+realFileName);
						
						resultSaveFile = fDAO.fileInsert(fDTO);	
						System.out.println("파일 DB insert 결과: "+ resultSaveFile);
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else {
				try{
					System.out.println("WriteProc>새글쓰기 진입");
					//새글 쓰기 일 경우
					num = Integer.toString( dao.insertWrite(dto) );
					//수정글&새글에 첨부파일이 있는경우
					if(fileName != null){	
						System.out.println("첨부파일이 있는경우 DB처리");
						fDTO.setNum(num);
						fDTO.setBoardname(boardname);
						fDTO.setOriginfile(fileName);
						fDTO.setServerfile(realFileName);
						
						resultSaveFile = fDAO.fileInsert(fDTO);	
						System.out.println("파일 DB insert 결과: "+ resultSaveFile);
					}
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}catch(Exception e){
			System.out.println("WriteProc>수정하기:DB처리 예외");
			e.printStackTrace();
		}///////////////////////////////////////////////////////
			
			
		try{
			System.out.println("WriteProc>editMode: "+editMode);
			System.out.println("게시글등록 후 num출력:"+num);
			System.out.println("WriteProc>폼값출력테스트");
			System.out.println("title> "+title);
			System.out.println("content> "+content);
			System.out.println("boardname> "+boardname);
			System.out.println("num> "+num);
			System.out.println("유저아이디> "+session.getAttribute("USER_ID"));
			System.out.println("=======================================");
		}catch (Exception e){
			System.out.println("WriteProc>폼값출력: 예외");
			e.printStackTrace();	
		}
			
		try{
			dao.close();
			fDAO.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
			
	
		if( num.equals("0") ){
			System.out.println("SubListCtrl>doInsert():결과실패");
			JavascriptUtil.jsAlertBack("글쓰기에 실패하였습니다.");
		}else{
			System.out.println("SubListCtrl>doInsert():결과성공");
			JavascriptUtil.jsAlertLocation(
					"등록되었습니다.", 
					"../community/SubList.do?boardname="+boardname+"&command=list&",
					out);
		}
				
			



		
	}


	private void doView() {
		
		System.out.println("SubListCtrl:doView:진입===============");
		String num = req.getParameter("num");
		BbsDAO dao = new BbsDAO(application);

		//게시물의 조회수를 증가시킨다
		dao.updateVisitCount(num);
		//게시물을 가져와서 DTO객체로 변환
		BbsDTO dto = dao.selectView(num);
		String content = dto.getContent().replace("\r\n", "<br>");
		dto.setContent(content);
		req.setAttribute("dto", dto);
		dao.close();

	}

	private void doWrite() {

		System.out.println("SubListCtrl:doWrite:진입");
		try {
		
			//글쓰기 진입시 수정모드로 들어온경우 해당 게시물 내용을 채워넣는다
			BbsDTO dto = null;
			String editMode = req.getParameter("editMode");
			req.setAttribute("editMode", editMode);
			System.out.println("Write페이지>editMode: "+editMode);
			String num = req.getParameter("num");
			if(editMode != null){
				if(editMode.equals("authorized")){
					
					BbsDAO dao = new BbsDAO(application);
					
					System.out.println(num);
					dto = dao.selectView(num);
					dao.close();
					req.setAttribute("title", dto.getTitle());
					req.setAttribute("content", dto.getContent());
				}
			}
	
			//파일의 db접근
			FileDAO fDAO = new FileDAO(application);
			FileDTO fDTO = new FileDTO();
			fDTO = fDAO.getFile(num);
			req.setAttribute("fDTO", fDTO);
			String fileName = fDTO.getOriginfile()==null? "" : fDTO.getOriginfile();
			req.setAttribute("fileName", fileName);
			
			String path = "../community/sub01_write2.jsp";
			req.getRequestDispatcher(path).forward(req, resp);
		} catch (ServletException | IOException e) {
			
			e.printStackTrace();
		}
		
		
	}

	

	public void dolist() {
		
		System.out.println("SubListCtrl:doList():진입");
		try {
		
		
			//멀티게시판 구현을 위한 파라미터 처리
			String boardname=null;
			if(req.getParameter("boardname")!=null){
				boardname = req.getParameter("boardname");
				System.out.println("BoardListProc>boardname>"+boardname);
				req.setAttribute("boardname", boardname);
			}
			
			else if( boardname==null || boardname.equals("") ){
				//만약 bname의 값이 없다면 로그인 화면으로 강제이동시킨다.
				System.out.println("isFlag>메인확면으로 강제이동");
				JavascriptUtil.jsAlertLocation("허용하지 않은 접근입니다", "../member/login.jsp", out);
				return;
			}
			
			
		
			String drv = application.getInitParameter("MariaJDBCDriver");
			String url = application.getInitParameter("MariaConnectURL");
			
			System.out.println(drv);
			System.out.println(url);
			
			BbsDAO dao = new BbsDAO(drv, url);
			
	
			Map<String, Object> param = new HashMap<String, Object>();
			
			param.put("boardname", boardname);
			
	
			//검색후 2페이지로 넘어가면 검색이 풀리는 문제를 해결하기위해
			//폼값을 받아서 파라미터를 저장할 변수 생성
			String queryStr = "";//검색시 페이지번호로 쿼리스트링을 넘겨주기위한 용도
	
	
			//필수파라미터에 대한 쿼리스트링 처리
			queryStr = "boardname="+boardname+"&";
			
			
			//검색어 입력시 전송된 폼값을 받아 Map에 저장
			String searchColumn = req.getParameter("searchColumn");
			String searchWord = req.getParameter("searchWord");
	
			
			if (searchWord != null) {
				if(searchWord.length()>0){
					
					//검색어를 입력한경우 Map에 값을 입력함
					//아무것도 입력안하고 그냥 검색버튼을 누를경우를 위한 로직임
					param.put("Column", searchColumn);
					param.put("Word", searchWord);
					
					//검색어가 있을때 쿼리스트링을 만들어준다.
					queryStr +="&searchColumn="+searchColumn
								+"&searchWord="+searchWord+"&";
				}
			}
			//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음 
			int totalRecordCount = dao.getTotalRecordCount(param);
	
	
			/*****************************페이지처리 start ***/
			//web.xml 의 초기화 파라미터를 가져와서 정수로 변경후 저장
			int pageSize = 
				Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
			if(boardname.equals("gallery")) pageSize = 6;
			int blockPage = 
				Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));
	
			//전체페이지수 계산 => 약105개 / 10 => 10.5 => ceil(10.5) =>11
			int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);
			
			/*현재페이지번호 : 파라미터가 없을때는 무조건 1페이지로 지정하고, 있을때는 해당값을 
				얻어와서 지정한다. 즉 리스트에 처음 진입했을때는 1페이지가 된다.*/
			
			int nowPage = 
				req.getParameter("nowPage")==null ||
				req.getParameter("nowPage").equals("")? 1 :
				Integer.parseInt(req.getParameter("nowPage"));
	
	
	
			//MariaDB를통해 한페이지에 출력할 게시물의 범위를 결정한다. 
			//limit의 첫번째인자 : 시작인덱스
			int start = (nowPage-1)*pageSize;
			//limit의 두번째인자 : 가져올레코드의 갯수
			int end = pageSize;
	
			//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
			param.put("start", start);
			param.put("end", end);
			//***************************페이지처리 end**/
	
			//조건에 맞는 레코드를 select하여 결과 셋을 List컬랙션으로 반환받음
			List<BbsDTO> bbs = dao.selectListPage(param);
			req.setAttribute("bbs", bbs);
			dao.close();
	
			/*게시판별 권한설정**************/
			String grade="";
			if(session.getAttribute("USER_GRADE")!=null){
				grade = session.getAttribute("USER_GRADE").toString();
				System.out.println("BoardCtrl>USER_GRADE:"+grade);
			}
			req.setAttribute("USER_GRADE", grade);
			
			
			
			
			//DB의 긴 Date 타입을 짧게 변환
			SimpleDateFormat before = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
			SimpleDateFormat isnew = new SimpleDateFormat("yy.MM.dd");
			req.setAttribute("before", before);
			req.setAttribute("isnew", isnew);
			
			FileDAO fdao = new FileDAO(application);
			FileDTO fdto = new FileDTO();
			req.setAttribute("fdao", fdao);
			req.setAttribute("fdto", fdto);
			
			System.out.println("BoardCtrl:dolist():끝");
			req.getRequestDispatcher("../community/sub01_list2.jsp?boardname="+boardname).forward(req, resp);
		} catch (ServletException | IOException e) {
			e.printStackTrace();
		}
	}
}
