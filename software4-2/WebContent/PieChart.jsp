<%@ page  contentType="image/jpeg" %>
<%@ page import = "org.jfree.chart.*"%>
<%@ page import = "chart.*"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.awt.Color"%>
<%@ page import = "org.jfree.data.general.DefaultPieDataset"%>
<%
	ServletOutputStream m = response.getOutputStream();
	ChartDAO chartDAO = new ChartDAO();
	
	JFreeChart chart = chartDAO.getPieChart();
	ChartUtilities.writeChartAsPNG(m, chart, 640, 400);
%>
