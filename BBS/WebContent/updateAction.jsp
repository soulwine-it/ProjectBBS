<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
</head>
<body>
	<%
		// 세션
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		// userID가 없다면 로그인을 하세요.
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href='login.jsp'");
			script.println("</script>");
		} 
		
		//글번호를 받아와 int 타입으로 바꿔줍니다.
		int bbsID = 0;
		if (request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		//글 번호를 받아오지 못했습니다.
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
		// userID와 글에 대한 userID가 같지 않다면 수정을 못합니다.
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if (!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
			//만약 user가 같다면
		}else {
			// 파라미터로 받아온 제목과 내용에 공백이 없도록 합니다.
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent")== null
					|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 모두 되지 않았습니다.')");
				script.println("history.back()");
				script.println("<script>");
				//공백이 없다면
			}else{
				
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
				//오류가 발생했다면.
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("<alert('글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
					//수정이 완료 되었다면
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='bbs.jsp'");
					script.println("</script>");
				}
			}

		}
	%>
</body>
</html>