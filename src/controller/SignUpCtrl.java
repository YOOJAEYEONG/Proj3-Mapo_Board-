package controller;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.MemberDAO;

@WebServlet("/member/SignUp.do")
public class SignUpCtrl extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("SignUpCtrl>doPost진입");
		req.setCharacterEncoding("UTF-8");
		try {
			ServletContext application = req.getServletContext();
			String drv = application.getInitParameter("MariaJDBCDriver");
			String url = application.getInitParameter("MariaConnectURL");
			
			MemberDAO dao = new MemberDAO(drv, url);
			Map<String,String> signUpFrm = new HashMap<String,String>();
			
			/*
			//폼에 입력했던 폼값넘어옴.
			Enumeration<String> params =  req.getParameterNames();
			while (params.hasMoreElements()) {
				String param = params.nextElement();
				System.out.println(param);
			}
			*/
			System.out.println(req.getParameter("name"));
			System.out.println(req.getParameter("id"));
			System.out.println(req.getParameter("pass"));
			
			signUpFrm.put("name", req.getParameter("name"));
			signUpFrm.put("id", req.getParameter("id"));				
			signUpFrm.put("pass", req.getParameter("pass"));
			signUpFrm.put("tel", req.getParameter("tel1")+req.getParameter("tel2")+req.getParameter("tel3"));
			signUpFrm.put("phone", req.getParameter("mobile1")+req.getParameter("mobile2")+req.getParameter("mobile3"));
			signUpFrm.put("email", req.getParameter("email_1")+"@"+req.getParameter("email_2") );
			signUpFrm.put("subscribe", (req.getParameter("subscribe") )==null ? "N":"Y" );
			signUpFrm.put("address", req.getParameter("addr1")+" ("+req.getParameter("addr2")+")" );
			signUpFrm.put("zipcode", req.getParameter("zipcode"));
			
			dao.addMember(signUpFrm);
			
			req.getRequestDispatcher("/main/main.jsp?intro=welcome").forward(req, resp);
		} catch (Exception e) {
			System.out.println("controller.SignUpCtrl예외>>");
			e.printStackTrace();
		}
		
		
		

		
		
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
}
