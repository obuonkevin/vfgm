@extends('admin.master')
@section('content')
@section('title','Edit Employee')
<style>
	.appendBtnColor{
		color: #fff;
		font-weight: 700;
	}
</style>

	<div class="container-fluid">
		<div class="row bg-title">
			<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
				<ol class="breadcrumb">
					<li class="active breadcrumbColor"><a href="{{ url('dashboard') }}"><i class="fa fa-home"></i> Dashboard</a></li>
					<li>@yield('title')</li>
				  
				</ol>
			</div>
			<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12">
				<a href="{{route('employee.index')}}"  class="btn btn-success pull-right m-l-20 hidden-xs hidden-sm waves-effect waves-light"><i class="fa fa-list-ul" aria-hidden="true"></i>  View Employee</a>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-info">
					<div class="panel-heading"><i class="mdi mdi-clipboard-text fa-fw"></i> @yield('title')</div>
					<div class="panel-wrapper collapse in" aria-expanded="true">
						<div class="panel-body">
							@if($errors->any())
								<div class="alert alert-danger alert-dismissible" role="alert">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
									@foreach($errors->all() as $error)
										<strong>{!! $error !!}</strong><br>
									@endforeach
								</div>
							@endif
							@if(session()->has('success'))
								<div class="alert alert-success alert-dismissable">
									<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
									<i class="cr-icon glyphicon glyphicon-ok"></i>&nbsp;<strong>{{ session()->get('success') }}</strong>
								</div>
							@endif
							@if(session()->has('error'))
								<div class="alert alert-danger alert-dismissable">
									<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
									<i class="glyphicon glyphicon-remove"></i>&nbsp;<strong>{{ session()->get('error') }}</strong>
								</div>
							@endif
							{{ Form::model($editModeData, array('route' => array('employee.update', $editModeData->employee_id), 'method' => 'PUT','files' => 'true','id' => 'employeeForm')) }}
							<input class="form-control  delete_education_qualifications_cid" id="delete_education_qualifications_cid" name="delete_education_qualifications_cid" type="hidden" value="">
							<input class="form-control  delete_experiences_cid" id="delete_experiences_cid" name="delete_experiences_cid" type="hidden" value="">
								<div class="form-body">
									<h3 class="box-title">Employee Account</h3>
									<hr>
									<div class="row">
										<div class="col-md-3">
											<div class="form-group">
												<label for="exampleInput">Role<span class="validateRq">*</span></label>
												<select name="role_id" class="form-control user_id required select2" required>
													<option value="">--- Please select ---</option>
													@foreach($roleList as $value)
														<option value="{{$value->role_id}}" @if($value->role_id == $employeeAccountEditModeData->role_id) {{"selected"}} @endif>{{$value->role_name}}</option>
													@endforeach
												</select>
											</div>
										</div>
										<div class="col-md-3">
											<label for="exampleInput">User Name<span class="validateRq">*</span></label>
											<div class="input-group">
												<div class="input-group-addon"><i class="ti-user"></i></div>
												<input class="form-control required user_name" required id="user_name" placeholder="Enter your user name" name="user_name" type="text" value="{{ $employeeAccountEditModeData->user_name }}">
											</div>
										</div>
									</div>
									<h3 class="box-title">Personal Information</h3>
									<hr>
									<div class="row">
										<div class="col-md-3">
											<div class="form-group">
												<label for="exampleInput">First Name<span class="validateRq">*</span></label>
												<input class="form-control required first_name" id="first_name" placeholder="Enter first name" name="first_name" type="text" value="{{ $editModeData->first_name }}">
											</div>
										</div>
										<div class="col-md-3">
											<div class="form-group">
												<label for="exampleInput">Last Name</label>
												<input class="form-control last_name" id="last_name" placeholder="Enter last name" name="last_name" type="text" value="{{ $editModeData->last_name }}">
											</div>
										</div>
										<div class="col-md-3">
											<div class="form-group">
												<label for="exampleInput">Fingerprint No.<span class="validateRq">*</span></label>
												<input class="form-control number finger_id"  id="finger_id" placeholder="Enter Finger Pin No" name="finger_id" type="text" value="{{ $editModeData->finger_id }}">
											</div>
										</div>
										<div class="col-md-3">
											<div class="form-group">
												<label for="exampleInput">Supervisor</label>
												<select name="supervisor_id" class="form-control supervisor_id required select2" >
													<option value="">--- Please select ---</option>
													@foreach($supervisorList as $value)
														<option value="{{$value->employee_id}}" @if($value->employee_id == $editModeData->supervisor_id) {{"selected"}} @endif>{{$value->first_name}} {{$value->last_name}}</option>
													@endforeach
												</select>
											</div>
										</div>
									</div>

								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Department Name<span class="validateRq">*</span></label>
											<select name="department_id" class="form-control department_id  select2">
												<option value="">--- Please select ---</option>
												@foreach($departmentList as $value)
													<option value="{{$value->department_id}}" @if($value->department_id == $editModeData->department_id) {{"selected"}} @endif>{{$value->department_name}}</option>
												@endforeach
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Designation Name<span class="validateRq">*</span></label>
											<select name="designation_id" class="form-control department_id select2">
												<option value="">--- Please select ---</option>
												@foreach($designationList as $value)
													<option value="{{$value->designation_id}}" @if($value->designation_id == $editModeData->designation_id) {{"selected"}} @endif>{{$value->designation_name}}</option>
												@endforeach
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Branch Name</label>
											<select name="branch_id" class="form-control branch_id select2" >
												<option value="">--- Please select ---</option>
												@foreach($branchList as $value)
													<option value="{{$value->branch_id}}" @if($value->branch_id == $editModeData->branch_id) {{"selected"}} @endif>{{$value->branch_name}}</option>
												@endforeach
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Work Shift<span class="validateRq">*</span></label>
											<select name="work_shift_id" class="form-control work_shift_id select2">
												<option value="">--- Please select ---</option>
												@foreach($workShiftList as $value)
													<option value="{{$value->work_shift_id}}" @if($value->work_shift_id == $editModeData->work_shift_id) {{"selected"}} @endif>{{$value->shift_name}}</option>
												@endforeach
											</select>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Monthly Pay Grade<span class="validateRq">*</span></label>
											<select name="pay_grade_id" class="form-control pay_grade_id required" >
												<option value="">--- Please select ---</option>
												@foreach($payGradeList as $value)
													<option value="{{$value->pay_grade_id}}" @if($value->pay_grade_id == $editModeData->pay_grade_id) {{"selected"}} @endif>{{$value->pay_grade_name}}</option>
												@endforeach
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Hourly Pay Grade<span class="validateRq">*</span></label>
											<select name="hourly_salaries_id" class="form-control hourly_pay_grade_id required" >
												<option value="">--- Please select ---</option>
												@foreach($hourlyPayGradeList as $value)
													<option value="{{$value->hourly_salaries_id}}" @if($value->hourly_salaries_id == $editModeData->hourly_salaries_id) {{"selected"}} @endif>{{$value->hourly_grade}}</option>
												@endforeach
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<label for="exampleInput">Email</label>
										<div class="input-group">
											<span class="input-group-addon"><i class="fa fa-envelope"></i></span>
											<input class="form-control email" id="email" placeholder="Enter email" name="email" type="email" value="{{ $editModeData->email }}">
										</div>
									</div>
									<div class="col-md-3">
										<label for="exampleInput">Phone<span class="validateRq">*</span></label>
										<div class="input-group">
											<span class="input-group-addon">+880</span>
											<input class="form-control number phone" id="phone" placeholder="Enter phone"  name="phone" type="number" value="{{ $editModeData->phone }}">
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Gender<span class="validateRq">*</span></label>
											<select name="gender" class="form-control gender select2">
												<option value="">--- Please select ---</option>
												<option value="Male" @if('Male' == $editModeData->gender) {{"selected"}} @endif>Male</option>
												<option value="Female" @if('Female' == $editModeData->gender) {{"selected"}} @endif>Female</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Religion</label>
											<input class="form-control religion" id="religion" placeholder="Enter religion" name="religion" type="text" value="{{ $editModeData->religion }}">
										</div>
									</div>
									<div class="col-md-3">
										<label for="exampleInput">Date Of Birth<span class="validateRq">*</span></label>
										<div class="input-group">
											<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
											<input class="form-control date_of_birth dateField"  id="date_of_birth" readonly placeholder="Enter date of birth" name="date_of_birth" type="text" value="{{ dateConvertDBtoForm($editModeData->date_of_birth) }}">
										</div>
									</div>
									<div class="col-md-3">
										<label for="exampleInput">Date Of Joining<span class="validateRq">*</span></label>
										<div class="input-group">
											<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
											<input class="form-control date_of_joining dateField" id="date_of_joining" readonly placeholder="Enter date of joining" name="date_of_joining" type="text" value="{{ dateConvertDBtoForm($editModeData->date_of_joining)  }}">
										</div>
									</div>
								</div>


								<div class="row">
									<div class="col-md-3">
										<label for="exampleInput">Date Of Leaving</label>
										<div class="input-group">
											<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
											<input class="form-control  date_of_leaving dateField" id="date_of_leaving" readonly placeholder="Enter date of leaving" name="date_of_leaving" type="text" value="{{ dateConvertDBtoForm($editModeData->date_of_leaving)  }}">
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Marital Status</label>
											<select name="marital_status" class="form-control status required select2" >
												<option value="">--- Please select ---</option>
												<option value="Unmarried" @if('Unmarried' == $editModeData->marital_status) {{"selected"}} @endif>Unmarried</option>
												<option value="Married" @if('Married' == $editModeData->marital_status) {{"selected"}} @endif>Married</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Status<span class="validateRq">*</span></label>
											<select name="status" class="form-control status select2">
												<option value="1" @if('1' == $editModeData->status) {{"selected"}} @endif>Active</option>
												<option value="2" @if('2' == $editModeData->status) {{"selected"}} @endif>Inactive</option>
												<option value="3" @if('3' == $editModeData->status) {{"selected"}} @endif>Terminate</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<label for="exampleInput">Photo</label>
										<div class="input-group">
											<span class="input-group-addon"><i class="	fa fa-picture-o"></i></span>
											<input class="form-control photo" id="photo" accept="image/png, image/jpeg, image/gif,image/jpg"  name="photo" type="file">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Address</label>
											<textarea class="form-control address" id="address" placeholder="Enter address" cols="30" rows="2" name="address">{{ $editModeData->address }}</textarea>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="exampleInput">Emergency Contact</label>
											<textarea class="form-control emergency_contacts" id="emergency_contacts" placeholder="Enter emergency contact" cols="30" rows="2" name="emergency_contacts">{{ $editModeData->emergency_contacts }}</textarea>
										</div>
									</div>
								</div>
							<br>
							<h3 class="box-title">Education Qualification</h3>
								<hr>
								<div class="education_qualification_append_div">
									@if(isset($editModeData) && count($educationQualificationEditModeData) > 0)
										@foreach($educationQualificationEditModeData as $educationQualificationValue)
											<div class="education_qualification_row_element">
												<input class="educationQualification_cid" id="educationQualification_cid" name="educationQualification_cid[]" type="hidden" value="{{$educationQualificationValue->employee_education_qualification_id}}">
												<div class="row">
													<div class="col-md-3">
														<div class="form-group">
															<label for="exampleInput">Institute<span class="validateRq">*</span></label>
															<select name="institute[]" class="form-control institute">
																<option value="">--- Please select ---</option>
																<option value="Board" @if($educationQualificationValue->institute == "Board") {{  "selected" }} @endif>Board</option>
																<option value="University" @if($educationQualificationValue->institute == "University") {{  "selected" }} @endif>University</option>
															</select>
														</div>
													</div>
													<div class="col-md-3">
														<div class="form-group">
															<label for="exampleInput">Board / University Name<span class="validateRq">*</span></label>
															<input type="text" name="board_university[]" class="form-control board_university" id="board_university" placeholder="Enter board/university name" value="{{ $educationQualificationValue->board_university }}">
														</div>
													</div>
													<div class="col-md-3">
														<div class="form-group">
															<label for="exampleInput">Degree<span class="validateRq">*</span></label>
															<input type="text" name="degree[]" class="form-control degree required" id="degree" placeholder="Example: B.Sc. Engr.(Bachelor of Science in Engineering)" value="{{ $educationQualificationValue->degree }}">
														</div>
													</div>
													<div class="col-md-3">
														<label for="exampleInput">Passing year<span class="validateRq">*</span></label>
														<div class="input-group">
															<span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
															<input type="text" name="passing_year[]" class="form-control yearPicker required" id="passing_year" placeholder="Enter year" value="{{ $educationQualificationValue->passing_year }}">
														</div>
													</div>
												</div>
												<div class="row">
													<div class="col-md-3">
														<div class="form-group">
															<label for="exampleInput">Result</label>
															<select name="result[]" class="form-control result">
																<option value="">--- Please select ---</option>
																<option value="First class" @if($educationQualificationValue->result == "First class") {{  "selected" }} @endif>First class</option>
																<option value="Second class" @if($educationQualificationValue->result == "Second class") {{  "selected" }} @endif>Second class</option>
																<option value="Third class" @if($educationQualificationValue->result == "Third class") {{  "selected" }} @endif>Third class</option>
															</select>
														</div>
													</div>
													<div class="col-md-3">
														<div class="form-group">
															<label for="exampleInput">GPA / CGPA</label>
															<input type="text" name="cgpa[]" class="form-control cgpa" id="cgpa" placeholder="Example: 5.00,4.63" value="{{ $educationQualificationValue->cgpa }}">
														</div>
													</div>
													<div class="col-md-3"></div>
													<div class="col-md-3">
														<div class="form-group">
															<input  type="button" class="form-control btn btn-danger deleteEducationQualification appendBtnColor" style="margin-top: 17px" value="Remove">
														</div>
													</div>
												</div>
												<hr>
											</div>
										@endforeach
									@endif	
								</div>
								<div class="row">
									<div class="col-md-9"></div>
									<div class="col-md-3"><div class="form-group"><input id="addEducationQualification" type="button" class="form-control btn btn-success appendBtnColor" value="Add Education Qualification"></div></div>
								</div>
								</div>
							
								<h3 class="box-title">Professional Experience</h3>
									<hr>
									<div class="experience_append_div">
										@if(isset($editModeData) && count($experienceEditModeData) > 0)
											@foreach($experienceEditModeData as $experienceValue)
												<div class="experience_row_element">
													<input class="employee_experience_id" id="employee_experience_id" name="employeeExperience_cid[]" type="hidden" value="{{$experienceValue->employee_experience_id}}">
													<div class="row">
														<div class="col-md-3">
															<div class="form-group">
																<label for="exampleInput">Organization Name<span class="validateRq">*</span></label>
																<input type="text" name="organization_name[]" class="form-control organization_name" id="organization_name" placeholder="Enter organization name" value="{{$experienceValue->organization_name}}">
															</div>
														</div>
														<div class="col-md-3">
															<div class="form-group">
																<label for="exampleInput">Designation<span class="validateRq">*</span></label>
																<input type="text" name="designation[]" class="form-control designation" id="designation" placeholder="Enter designation" value="{{dateConvertDBtoForm($experienceValue->designation)}}">
															</div>
														</div>
														<div class="col-md-3">
															<label for="exampleInput">From Date<span class="validateRq">*</span></label>
															<div class="input-group">
																<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
																<input type="text" name="from_date[]" class="form-control dateField" id="from_date" placeholder="Enter from date" value="{{dateConvertDBtoForm($experienceValue->from_date)}}">
															</div>
														</div>
														<div class="col-md-3">
															<label for="exampleInput">To Date<span class="validateRq">*</span></label>
															<div class="input-group">
																<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
																<input type="text" name="to_date[]" class="form-control dateField" id="to_date" placeholder="Enter to date" value="{{dateConvertDBtoForm($experienceValue->to_date)}}">
															</div>
														</div>
													</div>

													<div class="row">
														<div class="col-md-3">
															<div class="form-group">
																<label for="exampleInput">Responsibility<span class="validateRq">*</span></label>
																<textarea name="responsibility[]" class="form-control responsibility" placeholder="Enter responsibility" cols="30" rows="2" required>{{$experienceValue->responsibility}}</textarea>
															</div>
														</div>
														<div class="col-md-3">
															<div class="form-group">
																<label for="exampleInput">Skill<span class="validateRq">*</span></label>
																<textarea name="skill[]" class="form-control skill" placeholder="Enter skill" cols="30" rows="2">{{$experienceValue->skill}}</textarea>
															</div>
														</div>
														<div class="col-md-3"></div>
														<div class="col-md-3">
															<div class="form-group">
																<input  type="button" class="form-control btn btn-danger deleteExperience appendBtnColor" style="margin-top: 17px" value="Remove">
															</div>
														</div>
													</div>
													<hr>
												</div>
											@endforeach
										@endif
									</div>
									<div class="row">
										<div class="col-md-9"></div>
										<div class="col-md-3"><div class="form-group"><input id="addExperience" type="button" class="form-control btn btn-success appendBtnColor"  value="Add Professional Experience"></div></div>
									</div>
									<div class="form-actions">
									<div class="row">
										<div class="col-md-12 ">
											<button type="submit" class="btn btn-info btn_style"><i class="fa fa-pencil"></i> Update</button>
										</div>
									</div>
								</div>
								</div>
								
							{{ Form::close() }}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="row_element1" style="display: none;">
	<input name="educationQualification_cid[]" type="hidden">
	<div class="row">
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Institute<span class="validateRq">*</span></label>
				<select name="institute[]" class="form-control institute">
					<option value="">--- Please select ---</option>
					<option value="Board">Board</option>
					<option value="University">University</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Board / University Name<span class="validateRq">*</span></label>
				<input type="text" name="board_university[]" class="form-control board_university" id="board_university" placeholder="Enter board/university name">
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Degree<span class="validateRq">*</span></label>
				<input type="text" name="degree[]" class="form-control degree required" id="degree" placeholder="Example: B.Sc. Engr.(Bachelor of Science in Engineering)">
			</div>
		</div>
		<div class="col-md-3">
			<label for="exampleInput">Passing year<span class="validateRq">*</span></label>
			<div class="input-group">
				<span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
				<input type="text" name="passing_year[]" class="form-control yearPicker required" id="passing_year" placeholder="Enter year">
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Result</label>
				<select name="result[]" class="form-control result">
					<option value="">--- Please select ---</option>
					<option value="First class">First class</option>
					<option value="Second class">Second class</option>
					<option value="Third class">Third class</option>
				</select>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">GPA / CGPA</label>
				<input type="text" name="cgpa[]" class="form-control cgpa" id="cgpa" placeholder="Example: 5.00,4.63">
			</div>
		</div>
		<div class="col-md-3"></div>
		<div class="col-md-3">
			<div class="form-group">
				<input  type="button" class="form-control btn btn-danger deleteEducationQualification appendBtnColor" style="margin-top: 17px" value="Remove">
			</div>
		</div>
	</div>
	<hr>
</div>

<div class="row_element2" style="display: none;">
	<input name="employeeExperience_cid[]" type="hidden">
	<div class="row">
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Organization Name<span class="validateRq">*</span></label>
				<input type="text" name="organization_name[]" class="form-control organization_name" id="organization_name" placeholder="Enter organization name">
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Designation<span class="validateRq">*</span></label>
				<input type="text" name="designation[]" class="form-control designation" id="designation" placeholder="Enter designation">
			</div>
		</div>
		<div class="col-md-3">
			<label for="exampleInput">From Date<span class="validateRq">*</span></label>
			<div class="input-group">
				<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
				<input type="text" name="from_date[]" class="form-control dateField" id="from_date" placeholder="Enter from date">
			</div>
		</div>
		<div class="col-md-3">
			<label for="exampleInput">To Date<span class="validateRq">*</span></label>
			<div class="input-group">
				<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
				<input type="text" name="to_date[]" class="form-control dateField" id="to_date" placeholder="Enter to date">
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Responsibility<span class="validateRq">*</span></label>
				<textarea name="responsibility[]" class="form-control responsibility" placeholder="Enter responsibility" cols="30" rows="2"></textarea>
			</div>
		</div>
		<div class="col-md-3">
			<div class="form-group">
				<label for="exampleInput">Skill<span class="validateRq">*</span></label>
				<textarea name="skill[]" class="form-control skill" placeholder="Enter skill" cols="30" rows="2"></textarea>
			</div>
		</div>
		<div class="col-md-3"></div>
		<div class="col-md-3">
			<div class="form-group">
				<input  type="button" class="form-control btn btn-danger deleteExperience appendBtnColor" style="margin-top: 17px" value="Remove">
			</div>
		</div>
	</div>
	<hr>
</div>
@endsection
@section('page_scripts')
	<script>
        $(document).ready(function (){

            $('#addEducationQualification').click(function(){
                $('.education_qualification_append_div').append('<div class="education_qualification_row_element">' + $('.row_element1').html() + '</div>');
            });

            $('#addExperience').click(function(){
                $('.experience_append_div').append('<div class="experience_row_element">' + $('.row_element2').html() + '</div>');
            });

            $(document).on("click",".deleteEducationQualification",function(){
                $(this).parents('.education_qualification_row_element').remove();
                var deletedID = $(this).parents('.education_qualification_row_element').find('.educationQualification_cid').val();
                if (deletedID) {
                    var prevDelId = $('#delete_education_qualifications_cid').val();
                    if (prevDelId) {
                        $('#delete_education_qualifications_cid').val(prevDelId + ',' + deletedID);
                    } else {
                        $('#delete_education_qualifications_cid').val(deletedID);
                    }
                }
            });

            $(document).on("click",".deleteExperience",function(){
                $(this).parents('.experience_row_element').remove();
                var deletedID = $(this).parents('.experience_row_element').find('.employee_experience_id').val();
                if (deletedID) {
                    var prevDelId = $('#delete_experiences_cid').val();
                    if (prevDelId) {
                        $('#delete_experiences_cid').val(prevDelId + ',' + deletedID);
                    } else {
                        $('#delete_experiences_cid').val(deletedID);
                    }
                }
            });

            $(document).on('change','.pay_grade_id',function(){
                var data = $('.pay_grade_id').val();
                if(data){
                    $('.hourly_pay_grade_id').val('');
                    $('.pay_grade_id').attr('required',false);
                    $('.hourly_pay_grade_id').attr('required',false);
                }else{
                    $('.pay_grade_id').attr('required',true);
                    $('.hourly_pay_grade_id').attr('required',true);
                }
            });

            $(document).on('change','.hourly_pay_grade_id',function(){
                var data = $('.hourly_pay_grade_id').val();
                if(data){
                    $('.pay_grade_id').val('');
                    $('.pay_grade_id').attr('required',false);
                    $('.hourly_pay_grade_id').attr('required',false);
                }else{
                    $('.pay_grade_id').attr('required',true);
                    $('.hourly_pay_grade_id').attr('required',true);
                }
            });

        });

	</script>
@endsection
