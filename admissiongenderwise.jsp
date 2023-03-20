<%
    StackTraceElement ste = new Throwable().getStackTrace()[0];
    String pagename = ste.getFileName();
   // if (DBC.DBConnection.PageAuthentication("" + session.getAttribute("role_id"), pagename, request)) {
%>
<%@page import="java.util.Calendar"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@include file="beanimport.jsp" %>
<html:html>
    <head><%@include file='grid.jsp' %>
        <%@include file='header.jsp' %>
        <!--<script type="text/javascript" src="js/ajax4.js"></script>-->
        <script type="text/javascript">
            function openPage(pageURL)
            {
                window.location = pageURL;
            }
        </script>

        <script>

            function numberWithCommas(x) {
                var parts = x.toString().split(".");
                var parts1;
                var parts2;
                var ll = parts[0].length;
                //alert(ll+"**"+parts[0]);
                if (ll > 3)
                {
                    parts1 = parts[0].substring(0, ll - 3);
                    parts2 = "," + parts[0].substring(ll - 3, ll);
                }
                else
                    return x;
                parts1 = parts1.replace(/\B(?=(\d{2})+(?!\d))/g, ",");
                if (parts[1] != null)
                {
                    return parts1 + parts2 + "." + parts[1];
                }
                else
                    return parts1 + parts2;
                //    return parts.join(".");
            }


            function calcTotal(mytable, rowno, colno)
            {
                var totVal = 0;
                var refTab = document.getElementById(mytable);
                //alert(refTab); //alert(refTab.rows.length);
                var i = 0;
                var row;
                var col;
                var col1;
                var j = colno - 1;
                for (i = rowno - 1; i < refTab.rows.length - 1; i++) {
                    row = refTab.rows.item(i);
                    col = row.cells.item(j);
                    console.log(col.firstChild.nodeValue);
                    totVal += parseInt(col.firstChild.nodeValue);
                }
                //alert(totVal);
                // now print total in ith row
                row = refTab.rows.item(i);
                col = row.cells.item(j);
                col.firstChild.nodeValue = numberWithCommas(totVal);
                //  col.firstChild.nodeValue =totVal;


            }



            function getTotals() {
                //calcTotal('tabcolor', '4', '4');

                for (i = 5; i <= 9; i++) {
                    calcTotal('tot', 2, i);
                }
            }
        </script>
        <script type="text/javascript">
            function openPage(pageURL)
            {
                window.location = pageURL;
            }
        </script>

        <script type="text/javascript">
            var encodedUri = encodeURI(csvContent);
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", "my_data.csv");

        </script>
        <script type="text/javascript">
            function fnExcelReport()
            {
                var tab_text = "<table border='1px'><tr bgcolor='#87AFC6'>";
                var textRange;
                var j = 0;
                tab = document.getElementById('tot'); // id of table

                for (j = 0; j < tab.rows.length; j++)
                {
                    tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
                    //tab_text=tab_text+"</tr>";
                }

                tab_text = tab_text + "</table>";
                tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
                tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
                tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

                var ua = window.navigator.userAgent;
                var msie = ua.indexOf("MSIE ");

                if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
                {
                    txtArea1.document.open("txt/html", "replace");
                    txtArea1.document.write(tab_text);
                    txtArea1.document.close();
                    txtArea1.focus();
                    sa = txtArea1.document.execCommand("SaveAs", true, "Say Thanks to shobha.xls");
                }
                else                 //other browser not tested on IE 11
                    sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

                return (sa);
            }
        </script>



    </head>


    <body onLoad="getTotals()">
        <%@include file="banner.jsp"%>
        <%@include file='nav-login2.jsp' %>

        <%            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = DBC.DBConnection.getConnection(request);

                String trade_name;
                String strength = null;
                String malecount=null;
                String femalecount=null;
                String strength_fill = null;
                String strength_vacant = null;
                String iti_name = null;
                String total=null;
                int st_tot = 0;
                int st_f = 0;
                int st_v = 0;

        %>

        <form method="post" action="admissiongenderwise.jsp">
            <p align="center"  class="style4"> 
                <font color="blue" size="4">

                    Admission Report
                </font>
            </p>




            <table align="center" border="1" bgcolor="#e4eeb9" >
                <tr>
                    <td>
                        <%                        int current_year = Integer.parseInt(beans.MyUtil.getOptionValue("iti_params", "code", "value", "1", con));
                            // String sub_year = current_year.substring(2, 4);
                            
                        %>

                        

                        <label for="category">Select Year :</label>

                        <select name="year" id="year"  >
                             <option value="">Select Year</option>
                             <%= beans.MyUtil.putOptionsWhereCondition("admissions.iti_admissions","year_of_admission", "year_of_admission","where year_of_admission >='2019'")%>
                        </select>&nbsp;&nbsp;&nbsp;
<label for="category">Select Cast Type :</label>

                        <select name="cast_type" id="cast_type"  >
                            <option value="">Select Cast</option>
                          <option value="OC">OC</option>
                             <option value="BC">BC</option>
                             <option value="SC">SC</option>
                             <option value="ST">ST</option>
<!--                             <option value="U">PWD</option>
                             <option value="R">Rural</option>
                             <option value="U">Urban</option>-->
                        </select>
<!--<label for="category">Select Iti Type :</label>

                        <select name="iti_type" id="iti_type"  >                          
                             <option value="">Select Iti</option>
                             <option value="R">Rural</option>
                             <option value="U">Urban</option>
                        </select>-->


                    </td>
                        <tr>
                        <td>
                           <label for="category">Select PWD :</label>
<input type="radio" name="pwd" value="t"/>Yes
<input type="radio" name="pwd" value="f"/>No
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <input type="submit" name="submit" value="submit"/>
                        </td>
                    </tr>
                </tr>
            </table>

        </form>
        <%if (request.getParameter("submit") != null) {
                System.out.println("asdfasdfasdfasfasfsadfasfdasfdsa");
                int trade_code = 0;
                int dist_code = 0;
                String sql = null;
                String strsql="";
                String strsubsql="";

                String year = request.getParameter("year");
                String cast_type=request.getParameter("cast_type");
//                 String iti_type=request.getParameter("iti_type");
                 String pwd=request.getParameter("pwd");
System.out.println("year"+year);
System.out.println("cast_type"+cast_type);  
//System.out.println("iti_type"+iti_type);
System.out.println("pwd"+pwd);

                   
                try{
//                    if (iti_type.length()> 0 && !iti_type.equals("0")) {
//                strsql = strsql + "res_category='" +cast_type + "' AND ";                   
//                    }
if(pwd!=null){
                if (pwd.length()> 0 && !pwd.equals("0") && !pwd.equals("null")) {
                    if(pwd=="t"){
                         strsql = strsql + "pwd='" +pwd + "' AND ";  
                    }
                    if(pwd=="f"){
                         strsql = strsql + "pwd='" +pwd + "' AND ";  
                    }                                
                    }
}
//                if (iti_type.length()> 0 && !iti_type.equals("0")) {
//                strsql = strsql + "res_category='" +cast_type + "' AND ";                   
//                    }
                    if (cast_type.length()> 0 && !cast_type.equals("0")) {
                strsql = strsql + "res_category ilike'%" +cast_type + "%' AND ";                   
                    }
                    if(year.length()>0 && !year.equals("0")){
                    strsql=strsql+"year_of_admission='"+year+"' and ";
                    }
                    if (!strsql.equals(null)) {
	            	strsubsql = strsql.substring(0, strsql.length() - 4);
	            }
                    
                     sql = "SELECT  b.trade_name,(select count(*) as male from admissions.iti_admissions where "+strsubsql+" and gender='male'  and trade_code=a.trade_code) male,(select count(*) as female from admissions.iti_admissions where  "+strsubsql+" and gender='female' and trade_code=a.trade_code) female,(select count(*) from admissions.iti_admissions  where "+strsubsql+" and trade_code=a.trade_code) total FROM    admissions.iti_admissions  a INNER JOIN ititrade_master b ON a.trade_code = b.trade_code where "+strsubsql+"  GROUP   BY  a.trade_code,b.trade_name order by b.trade_name";
                ps = con.prepareStatement(sql);
                
                rs = ps.executeQuery();
              System.out.print("genderquery"+sql);
                }catch(Exception e){
                    e.printStackTrace();
                    System.out.println("Exception is"+e);
                }
                   

                


        %>


        <%@include file='grid.jsp' %>
        <div id="wrapper">

            <div class="content">
                <div align="center">
                    &nbsp;&nbsp;
                    <td> <center> <input type="button" name="back" value="Back" align="centre" onclick="openPage('loginsuccess.jsp')"/><input type="button" value="Excel" onclick="fnExcelReport();"/> 
                            <input type="button" value="Print" id="printpagebutton" onClick="printpage();" /></td>

                    <table align="center"   border="2" width="70%" id="tot" bgcolor="#e4eeb9">

                        <thead>

                            <p align="center"  class="style4"> 
                                <font color="blue" size="4">

                                    For Year: <%=year%>
                                </font>
                            </p> 
                            <tr>
                                <td><b>#</b></td>                               
                                <td><b>Trade Name</b></td> 
                                <td><b>Boys</b></td> 
                                <td><b>Girls</b></td> 
                                <td><b>Total</b></td> 

                            </tr></thead>
                        <tbody>

                            <% int i = 0;
                                while (rs.next()) {

                                    i++;
                                    trade_name = rs.getString("trade_name");

                                    malecount = rs.getString("male");
                                    femalecount = rs.getString("female");
                                    total = rs.getString("total");
                                    st_tot = st_tot + Integer.parseInt(malecount);
                                    st_f = st_f + Integer.parseInt(femalecount);
                                    st_v = st_v + Integer.parseInt(total);


                            %>
                            <tr>
                                <td><%= i%></td>
                                <td><%= trade_name%></td>
                                <td><%= malecount%></td>
                                <td><%= femalecount%></td>                               
                                <td><%= total%></td> 
                            </tr>
                            <% }%>
                            <tr><td colspan="2" > <font colour="white">Total</font></td>
                                <td><%=st_tot%></td>
                                <td><%=st_f%></td>
                                <td><%=st_v%></td>
                            </tr>
                        </tbody></table>

                </div></div></div>

        <td> <center> <input type="button" name="back" value="Back" align="centre" onclick="openPage('loginsuccess.jsp')"/><input type="button" value="Excel" onclick="fnExcelReport();"/> 

                <input type="button" value="Print" id="printpagebutton" onClick="printpage();" /></center></td>
        <script>

            function printpage() {
                //                                      Get the print button and put it into a variable
                var printButton = document.getElementById("printpagebutton");
                // var closebutton = document.getElementById("closebutton");
                var navmenu = document.getElementById("banner-id");
                var banner = document.getElementById("menu-bar");
                var foot = document.getElementById("footer");
                document.getElementById("tot").style.width = "100%";


                //                                     Set the print button visibility to 'hidden'; 
                printButton.style.visibility = 'hidden';
                navmenu.style.display = 'none';
                banner.style.display = 'none';
                foot.style.display = 'none';
                //Print the page content
                window.print();
                // Set the print button to 'visible' again 
                //                                      //[Delete this line if you want it to stay hidden after printing]
                printButton.style.visibility = 'visible';

                navmenu.style.display = 'block';
                banner.style.display = 'block';
                foot.style.display = 'block';
                document.getElementById("tot").style.width = "60%";

                // window.location ="ShopDetailsbyMlspoint.jsp";
            }


        </script>
        <%

                    con.close();
                }
            } catch (Exception e) {
                System.out.println("Exception is  " + e);
            } finally {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();

                }
                if (con != null) {
                    con.close();

                }
            }%>

        <%@include file="footer.jsp"%>
    </body>
</html:html>

<% //} else {%>
<%//@include file='authentication.jsp' %>
<% //}%>