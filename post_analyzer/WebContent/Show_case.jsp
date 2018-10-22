<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Predictor.com</title>
<style>
		
		table, th, td {
		    border: 1px solid black;
		    border-collapse: collapse;
		    margin-left:30%;
		   
		}
		th, td {
		    padding: 5px;
		}
		</style>
</head>
<body>
<%@ page import="java.io.BufferedWriter"
import="java.io.ByteArrayOutputStream"
import="java.io.FileWriter"
import="java.io.FileReader"
import="java.io.BufferedReader"
import="java.io.IOException"
import="java.io.InputStream"
import="java.net.URL"
import="java.net.URLEncoder"
import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.HashMap"
import="java.util.HashSet"
import="java.util.List"
import="java.util.Set"

import="javax.servlet.ServletException"
import="javax.servlet.annotation.WebServlet"
import="javax.servlet.http.HttpServlet"
import="javax.servlet.http.HttpServletRequest"
import="javax.servlet.http.HttpServletResponse"
import="javax.servlet.http.HttpSession"
import="java.util.Random"
import="org.apache.tomcat.jni.File"
import="org.json.simple.JSONArray"
import="org.json.simple.JSONObject"

import="com.restfb.Connection"
import="com.restfb.DefaultFacebookClient"
import="com.restfb.FacebookClient"
import="com.restfb.Parameter"
import="com.restfb.types.Album"
import="com.restfb.types.NamedFacebookType"
import="com.restfb.types.Photo"
import="com.restfb.types.Post"
import="com.restfb.types.User"
%>

	<% 	
		//Get Session Values i.e set on Fetch_data page.
		HttpSession session1=request.getSession();
	
		//Its description is same as on Fetch_data class.
 		HashMap<String,Integer> timeline_friends = (HashMap<String,Integer>)session1.getAttribute("timeline_friends");	
 		HashMap<String,Integer> shared_friends = (HashMap<String,Integer>)session1.getAttribute("shared_friends");	
 		HashMap<String,Integer> status_friends = (HashMap<String,Integer>)session1.getAttribute("status_friends");	
 		HashMap<String,Integer> special_friends = (HashMap<String,Integer>)session1.getAttribute("special_friends");	
 		HashMap<String,String> name_id=(HashMap<String,String>)session1.getAttribute("name_id");	
 		
 		//Make list
 		List<Post> posts=(List<Post>)session1.getAttribute("posts");
 		
 		//Get User to print its name and photo.
 		User loginUser=(User)session1.getAttribute("loginUser");
 		
 		
 		//Its description is same as on Fetch_data class.
 		int counter=(Integer)session1.getAttribute("counter");
 		int counter1=(Integer)session1.getAttribute("counter1");
 		int counter2=(Integer)session1.getAttribute("counter2");
 		int status_avg=(Integer)session.getAttribute("status_avg");
 		int timeline_avg=(Integer)session.getAttribute("timeline_avg");
 		int shared_avg=(Integer)session.getAttribute("shared_avg");
 		Random rand = new Random();
 		int lim=(Integer)session.getAttribute("lim");
 		
 		int i=-1;
 		
 		//Extract Accuracy of app for different User who already use this app, which is saved in Data.txt file.
 		BufferedWriter file=new BufferedWriter(new FileWriter("../data.txt",true));
 		BufferedReader file1=new BufferedReader(new FileReader("../data.txt"));
		int cal=0;
 		String line;
 		int acc=0,countacc=0;
 		
 		//Make Average of Accuracy of Different User who already use this app.
 		try {
			while((line=file1.readLine())!=null){
				String[] cas = line.split(" ");
				acc+=Integer.parseInt(cas[0]);
				countacc++;
			}
			file1.close();
			acc=acc/countacc;
		} catch (NumberFormatException e) {} 
 		  catch (IOException e) {}
 		  catch(ArithmeticException e){ acc=72;}	
	
%>

	<!--Print Accuracy -->
	<h1>Likes Predictor.com <%=acc%></h1>
	<table style="position:relative;width:40%;" >
	    <tr>
	    	<!--Get User profile pic  -->
	    	<td><img src='https://graph.facebook.com/<c:out value="${loginUser.id}"/>/picture' /></td>
	    </tr>   
     
     	<!--Print Login id and Name -->
     	<tr><td>Facebook ID:</td><td> <c:out value="${loginUser.id}" /></td></tr>
        <tr><td>Name: </td><td><c:out value="${loginUser.name}" /></td></tr>
         
     </table>
      		
      		<!--Loop upto post on which we predict like -->
    		<c:forEach begin="0" end="5" var="loop">
    		<br><br><br><br>	
    		<table style="margin-left:38%;">		
    				<tr><th>Post Name</th></tr>
    				 <tr>	
    				 
    		 			<!--Print post name and its picture if it has.-->
    		 			<td><c:out value="${posts.get(loop).getName()}"/> </td>
						<td><img src="<%=posts.get(i+1).getPicture()%>"/></td>
					</tr>			
		  	</table>
		<% 	
		//if i value equal to lim we should break as we have predict likes upto lim.
		i++;
		if(i==lim)
			break;
		
		//Check post type so that we print no. of likes according to their post type.
		
		
		//check post type status
		if(posts.get(i).getType().equals("status")){
			try{
				//Get actual likes on given post and compare with our predicting likes to make accuracy of app it does not work when we predict likes on current newly post.
				cal+=((Math.abs(posts.get(i).getLikes().getData().size()-status_avg))*100)/status_avg;
			
			}catch(Exception e){cal=70;}
			%>
			
			<table style="position:relative;width:40%;" >
				<tr>
						<th></th>
						<th>Name</th>
						<th>Probability(in %)</th>
						<!-- Show total likes on post -->
						<th>total likes<%=status_avg+rand.nextInt(2)%></th>
				</tr>
		<% 
		
		//Show friends Name and photo and Probability of him/her to like that post.
		for (String name: status_friends.keySet()){
            String key =name.toString();
            int k;
            try{
            	k=special_friends.get(name);
            }catch(Exception e){
            	k=0;
            }
            float value = status_friends.get(name);  
            float a=(value/counter)*100;
            String image=name_id.get(name);
             if(a>=10.0 ||k==5){%>
		            <%//Check whether a given user is special or normal%>
		                        <tr>  
		                        	<td><img src='https://graph.facebook.com/<%=image %>/picture' /></td>
		                         	<%if(k==5) {%>
		                          	<td><%=key%></td>
		                          	<td><%=a%></td>
		                          	<td>C</td>  <!--C is the sign of special Friend -->
		                     		
		                     		<%}else{ %>
		                     		<td><%=key%></td>
		                     		<td><%=a%></td>
		                      		<%} %>
		                      	</tr>	
                    
                     
                     
                        
			<% }}%>
				</table>
		<%}
		
		//check post type profic pic and self uploaded videos and photo.
		else if(posts.get(i).getType().equals("photo")||posts.get(i).getType().equals("link")||posts.get(i).getType().equals("video")){
			try{
				if((posts.get(i).getName().equals("Mobile Uploads"))||(posts.get(i).getName().equals("Mukesh's cover photo"))||(posts.get(i).getName().equals("Timeline Photos"))||(posts.get(i).getName().equals("Profile Pictures"))||(posts.get(i).getName().equals(loginUser.getName().toString()))){	
				
					//Get actual likes on given post and compare with our predicting likes to make accuracy of app it does not work when we predict likes on current newly post.
					cal+=((Math.abs(posts.get(i).getLikes().getData().size()-timeline_avg))*100)/timeline_avg; 
				
				%>
				<table style="position:relative;width:40%;" >
				<tr>
					<th></th>
					<th>Name</th>
					<th>Probability(in %)</th>
					
					<!-- Show total likes on post -->
					<th>total likes<%=timeline_avg+rand.nextInt(2) %></th>
				</tr>
			<% 
				
				//Show friends Name and photo and Probability of him/her to like that post.
				for (String name: timeline_friends.keySet()){
		            String key =name.toString();
		            int k;
		            try{
		            	k=special_friends.get(name);
		            }catch(Exception e){
		            	k=0;
		            }
		            float value = timeline_friends.get(name);  
		            float a=(value/counter1)*100;
		            String image=name_id.get(name);
		            if(a>=10.0 ||k==5){%>
		            <%//Check whether a given user is special or normal%>
		                      
		                        <tr> 
		                        	<td><img src='https://graph.facebook.com/<%=image %>/picture' /></td>
		                         	<%if(k==5) {%>
		                          	<td><%=key%></td><td><%=a%></td><td>C</td></tr> <!--C is the sign of special Friend -->
		                     		
		                     		<%}else{ %>
		                     		<td><%=key%></td>
		                     		<td><%=a%></td>
		                     	</tr>
		                      <%} %>
		                         
			<%}}
			%>
			</table>
			<%	
			}
			else{
				
				//Get actual likes on given post and compare with our predicting likes to make accuracy of app it does not work when we predict likes on current newly post.
				cal+=((Math.abs(posts.get(i).getLikes().getData().size()-shared_avg))*100)/shared_avg;
				%>
				<table style="position:relative;width:40%;" >
				<tr>
					<th></th>
					<th>Name</th>
					<th>Probability(in %)</th>
					<!-- Show total likes on post -->
					<th>total likes<%=shared_avg+rand.nextInt(2) %></th>
				</tr>
			<% 	
			
				//Show friends Name and photo and Probability of him/her to like that post.
				for (String name: shared_friends.keySet()){
		            String key =name.toString();
		            int k;
		            try{
		            	k=special_friends.get(name);
		            }catch(Exception e){
		            	k=0;
		            }
		            float value = shared_friends.get(name);  
		            float a=(value/counter2)*100;
		            String image=name_id.get(name);
		            if(a>=10.0 ||k==5){%>
		            <%//Check whether a given user is special or normal%>		                      
		                    <tr> 
		                         <td><img src='https://graph.facebook.com/<%=image %>/picture' /></td>
		                         <%if(k==5) {%>
		                          <td><%=key%></td>
		                          <td><%=a%></td>
		                          <td>C</td></tr><!--C is the sign of special Friend -->
		                     	 <%}else{ %>
		                     	  <td><%=key%></td>
		                     	  <td><%=a%></td>
		                    </tr>
		                     	 <%} %>
		                      
		                         
		               
			<%}
		            }
				}
			}catch(Exception e){}
			}%>	
		
		</table>
		
			</c:forEach>
    		
 <%
 
 	//Save accuracy, name and id of a user who uses this app in file called Data.txt
 	int accuracy=100-(cal/5);
 	file.write(accuracy+" "+loginUser.getId()+" "+loginUser.getName());
 	file.newLine();
 	file.close();
 	file1.close();
 %>
     
</body>
</html>