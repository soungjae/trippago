package chart;

import java.awt.Color;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;

import MyDb.DBconn;

public class ChartDAO {
		
		private Connection conn;
		private ResultSet rs;

		
		public ChartDAO() {
			
			try	{
				
			conn = DBconn.getsqlconnection();
			
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		public ArrayList<Country> getCountry() {
			String SQL = "SELECT * FROM Country ORDER BY CountryGet DESC LIMIT 5";
			ArrayList<Country> list = new ArrayList<Country>();
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Country con = new Country();
					con.setCName(rs.getString(1));
					con.setGets(rs.getInt(2));
					list.add(con);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return list;
		}
		
		public JFreeChart getPieChart() {
			
			ChartDAO chartDAO = new ChartDAO();
			DefaultPieDataset dataset = new DefaultPieDataset();
			ArrayList<Country> list = chartDAO.getCountry();
			for(int i = 0; i < list.size(); i++) {
			dataset.setValue(list.get(i).getCName(), list.get(i).getGets());
			}
			JFreeChart chart = ChartFactory.createPieChart("Country Gets", dataset, true, true, false);
			chart.setBackgroundPaint(Color.WHITE);
			
			return chart;
			
		}
}
