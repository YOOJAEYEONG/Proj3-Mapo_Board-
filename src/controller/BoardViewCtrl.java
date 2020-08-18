package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BbsDAO;
import model.BbsDTO;
import model.FileDAO;
import model.FileDTO;

@WebServlet("/BoardModel2/sub01_view2")
public class BoardViewCtrl extends HttpServlet{

	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
		
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

	
		
		
		System.out.println("sub01_view:진입=========================================");
		//폼값받기  - 파라미터로 전달된 게시물의 일련번호
		String num = req.getParameter("num");
		String boardname = req.getParameter("boardname");
		
		
		
		ServletContext application = req.getServletContext();
		BbsDAO dao = new BbsDAO(application);

		//게시물의 조회수를 증가시킨다
		dao.updateVisitCount(num);
		//게시물을 가져와서 DTO객체로 변환
		BbsDTO dto = dao.selectView(num);
		String content = dto.getContent().replace("\r\n", "<br>");
		dto.setContent(content);
		req.setAttribute("dto", dto);
		dao.close();

		//sql형 시간형변환. 각페이지별 다르게 출력하였음
		SimpleDateFormat before = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
		SimpleDateFormat isnew = new SimpleDateFormat("yy.MM.dd hh:mm:ss");
		Date original_date = null;
		try {
			original_date = before.parse(dto.getPostdate());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String newdate = isnew.format(original_date);
		req.setAttribute("newdate", newdate);
		
		

		
		//파일의 db접근
		FileDAO fDAO = new FileDAO(application);
		FileDTO fDTO = new FileDTO();
		System.out.println("View>num>"+num);
		fDTO = fDAO.getFile(num);
		req.setAttribute("fDTO", fDTO);
		
		
		System.out.println("View>fDTO.getBoardname(): "+fDTO.getBoardname());
		System.out.println("View>fDTO.getOriginfile(): "+fDTO.getOriginfile());
		System.out.println("View>fDTO.getServerfile(): "+fDTO.getServerfile());
		boolean hasFile = fDTO.getOriginfile()==null? false : true ;
		req.setAttribute("hasFile", hasFile);
		String fileName = fDTO.getOriginfile()==null? "" : fDTO.getOriginfile();
		req.setAttribute("fileName", fileName);
		
		
		
		String originFile=null;
		String serverFile=null;
		if(fDTO.getOriginfile()!=null)
			originFile = URLEncoder.encode(fDTO.getOriginfile(), "UTF-8");
		if(fDTO.getServerfile()!=null)
			serverFile = URLEncoder.encode(fDTO.getServerfile(), "UTF-8");
		
		
		
		req.setAttribute("originFile", originFile);
		req.setAttribute("serverFile", serverFile);
		
		String path = "../community/sub01_view2.jsp";
		req.getRequestDispatcher(path).forward(req, resp);
	}
}
