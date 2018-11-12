<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>ScheduleMe (Single User)</title>
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<link rel="stylesheet" href="single_schedule.css">
	</head>
	<body>
		<script>
		
			(function(d, s, id){
				var js, fjs = d.getElementsByTagName(s)[0];
			    if (d.getElementById(id)) {return;}
			    js = d.createElement(s); js.id = id;
			    js.src = "https://connect.facebook.net/en_US/sdk.js";
			    fjs.parentNode.insertBefore(js, fjs);
			}(document, 'script', 'facebook-jssdk'));

		  
			window.fbAsyncInit = function() {
			    FB.init({
			      appId: '562234917553248',
			      cookie: true,
			      xfbml: true,
			      version: 'v3.2'
			    });
			    FB.AppEvents.logPageView(); 
		    	FB.getLoginStatus(function(response) {
		    		  if (response.status === 'connected') {
		    		    successfulLogin();
		    		  }
		    	});
			};
		  
			function fbLogin() {
		      FB.login(function (response) {
		          if (response.authResponse) {
		              successfulLogin();
		          } else {
		              //User cancelled login or did not fully authorize
		          }
		      }, {scope: 'email, user_friends'});
		  	}
		  
			// Fetch the user profile data from facebook
		  	function successfulLogin(){
		    	FB.api('/me', {locale: 'en_US', fields: 'id,first_name,last_name,email,link,gender,locale,picture'}, function (response) {
		        	document.getElementById('fbButton').setAttribute("onclick","fbLogout()");
		        	document.getElementById('fbButton').innerHTML = '<img src="fblogout.png" class="fb-button" />';
		        	var userID = response.id;
	    	    	sessionStorage.setItem("userID", userID);
	    	    	//check if sessionUserID == null -> if so -> send to DB
					//TODO: uncomment line below to add user to database 
					//addUniqueUser(userID);
		   		});
		   	}
		  
		  	function fbLogout() {
		    	FB.logout(function() {
		          	document.getElementById('fbButton').setAttribute("onclick","fbLogin()");
		          	document.getElementById('fbButton').innerHTML = '<img src="fblogin.png" class="fb-button" />';
		          	//document.getElementById('userData').innerHTML = '';
		      	});
		   	}
		  	
		    function addUniqueUser(userID) { 
				var xhttp = new XMLHttpRequest();
			   	xhttp.open("POST", "AddUniqueUserServlet?userID="+userID, true);
			   	xhttp.onreadystatechange = function() { 
			   		//console.log(this.responseText);
			   	}
			   	xhttp.send();
		     }
		    
			function addGroup(){
				var xhttp = new XMLHttpRequest();
				xhttp.open("GET", "AddInfo?action=group", true);
				xhttp.onreadystatechange = function() {
					document.getElementById("classes_table").innerHTML = this.responseText;
				}
				xhttp.send();
			}
			
			function removeGroup(group_num){
				var xhttp = new XMLHttpRequest();
				xhttp.open("GET", "RemoveInfo?action=group&group_num=" + group_num, true);
				xhttp.onreadystatechange = function() {
					document.getElementById("classes_table").innerHTML = this.responseText;
				}
				xhttp.send();
			}
			
			function addClass(group_num){
				var xhttp = new XMLHttpRequest();
				xhttp.open("GET", "AddInfo?action=class&department=" + document.getElementById("department_input" + group_num).value + "&number=" + document.getElementById("number_input" + group_num).value + "&group_num=" + group_num, true);
				xhttp.onreadystatechange = function() {
					document.getElementById("classes_table").innerHTML = this.responseText;
				}
				xhttp.send();
			}
			
			function removeClass(group_num, class_num){
				var xhttp = new XMLHttpRequest();
				xhttp.open("GET", "RemoveInfo?action=class&group_num=" + group_num + "&class_num=" + class_num, true);
				xhttp.onreadystatechange = function() {
					document.getElementById("classes_table").innerHTML = this.responseText;
				}
				xhttp.send();
			}
			
			function addConstraint(){
				var xhttp = new XMLHttpRequest();
				var monday = document.getElementById("monday");
				var tuesday = document.getElementById("tuesday");
				var wednesday = document.getElementById("wednesday");
				var thursday = document.getElementById("thursday");
				var friday = document.getElementById("friday");
				var monday_bit = "0";
				var tuesday_bit = "0";
				var wednesday_bit = "0";
				var thursday_bit = "0";
				var friday_bit = "0";
				if(monday.checked == true) monday_bit = "1";
				if(tuesday.checked == true) tuesday_bit = "1";
				if(wednesday.checked == true) wednesday_bit = "1";
				if(thursday.checked == true) thursday_bit = "1";
				if(friday.checked == true) friday_bit = "1";
				xhttp.open("GET", "AddInfo?action=constraint&monday=" + monday_bit + "&tuesday=" + tuesday_bit + "&wednesday=" + wednesday_bit + "&thursday=" + thursday_bit + "&friday=" + friday_bit + "&start_time=" + document.getElementById("start_time").value + "&end_time=" + document.getElementById("end_time").value, true);
				xhttp.onreadystatechange = function() {
					document.getElementById("constraints_table").innerHTML = this.responseText;
				}
				xhttp.send();
			}
			
			function removeConstraint(constraint_num){
				var xhttp = new XMLHttpRequest();
				xhttp.open("GET", "RemoveInfo?action=constraint&constraint_num=" + constraint_num, true);
				xhttp.onreadystatechange = function() {
					document.getElementById("constraints_table").innerHTML = this.responseText;
				}
				xhttp.send();
			}
		</script>
		

		<div style="height: 100vh">
			<div class="container-fluid h-100">
				<div class="row h-100">
					<div class="col-12">
						<div class="h-100 d-flex flex-column">
							<div class="row button-bar">
								<div class="col-3">
									<button type="button" class="btn btn-info btn-block schedule-button">
										Generate Schedules <i class="fas fa-cogs"></i>
									</button>
								</div>
								<div class="col-3">
									<button type="button" class="btn btn-primary btn-block schedule-button">
										Schedule with Friends <i class="fas fa-arrow-right"></i>
									</button>
								</div>
								<div class="col-3">
								</div>
								<div class="col-2">
									<!-- facebook button -->
									<a href="javascript:void(0);" onclick="fbLogin()" id="fbButton"><img src="fblogin.png" class="fb-button" /></a>
								</div>
								<div class="col-1">
								</div>
							</div>
							<div class="row flex-grow-1 h-100">
								<div class="col-6 h-100">
									<div class="row h-50">
										<div class="col-12 h-100 panel-classes">
											<div class="d-flex flex-column h-100">
												<div class="row justify-content-center panel-header">My Classes</div>
												<div class="row flex-grow-1">
													<div class="col-12 panel-content" id="classes_table">
														<div class="row h-100 header-row">
															<div class="col-4 h-100 group-header">
																Group 1
															</div>
															<div class="col-4 no-padding">
																<button type="button" class="btn btn-danger button-remove" onclick="removeGroup(0)">Remove Group</button>
															</div>
														</div>
														<div class="row h-100 class-row">
															<div class="col-4 no-padding">
																<input type="text" class="class-input" id="department_input0" placeholder="Department Code">
															</div>
															<div class="col-4 no-padding">
																<input type="text" class="class-input" id="number_input0" placeholder="Course Number">
															</div>
															<div class="col-4 no-padding">
																<button type="button" class="btn btn-success button-add" onclick="addClass(0)">Add Class</button>
															</div>
														</div>
														<div class="row group-add-row">
															<div class="col-4 no-padding">
																<button type="button" class="btn btn-success button-add" onclick="addGroup()">Add Group</button>
															</div>
															<div class="col-8 no-padding">
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="row h-50">
										<div class="col-12 h-100 panel-constraints">
											<div class="d-flex flex-column h-100">
												<div class="row justify-content-center panel-header">Other Time Constraints</div>
												<div class="row flex-grow-1">
													<div class="col-12 panel-content" id="constraints_table">
														<div class="row first-constraint-row">
															<div class="col-1 no-padding">
																<label class="checkbox-label"><input class="day-checkbox" type="checkbox" id="monday"> Mon.</label>
														    	<label class="checkbox-label"><input class="day-checkbox" type="checkbox" id="tuesday"> Tues.</label><br>
															</div>
															<div class="col-1 no-padding">
																<label class="checkbox-label"><input class="day-checkbox" type="checkbox" id="wednesday"> Wed.</label><br>
														    	<label class="checkbox-label"><input class="day-checkbox" type="checkbox" id="thursday"> Thurs.</label><br>
															</div>
															<div class="col-1 no-padding">
														    	<label class="checkbox-label"><input class="day-checkbox" type="checkbox" id="friday"> Fri.</label><br>
															</div>
															<div class="col-3 no-padding">
																<input type="text" onfocus="(this.type='time')" placeholder=" Start Time" class="class-entry" id="start_time">
															</div>
															<div class="col-3 no-padding">
																<input type="text" onfocus="(this.type='time')" placeholder=" End Time" class="class-entry" id="end_time">
															</div>
															<div class="col-3 no-padding">
																<button type="button" class="btn btn-success constraint-button" onclick="addConstraint()">Add Constraint</button>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-6 panel-schedules h-100">
									<div class="d-flex flex-column h-100">
										<div class="row justify-content-center panel-header">Generated Schedules</div>
										<div class="row flex-grow-1">
											<div class="col-12 panel-content">
												next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
														next row <br />
														next row
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>