
<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>PaySlip</title>
		<meta charset="utf-8">
	</head>
	<style>

		table {
			margin: 0 0 40px 0;
			width: 100%;
			box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
			display: table;
			border-collapse: collapse;
		}
		table, td, th {border: 1px solid black;}
		td{padding: 5px;}
		th{padding: 5px;}
		/*.companyAddress{*/
			/*width: 75%;*/
			/*float: left;*/
		/*}*/
		/*.employeeInfo{*/
			/*width: 35%;*/
			/*float: right;*/
		/*}*/
		.month{
			text-align: center;
		}
		.col-md-4 {
			width: 33.33333333%;
			float: left;

		}
		.col-md-6 {
			width: 50%;
			float: left;
		}
		.col-md-12 {
			width: 100%;
		}
		.col-md-2 {
			width: 16.66666667%;
			float: left;
		}
	</style>
	<body>
	<div class="container">
	<div class="row">
		<div class="col-md-12">
			<div class="panel panel-info">

				<div class="companyAddress">
					<div style="    width: 300px;
    margin: 0 auto;" >
						@if($printHeadSetting){!! $printHeadSetting->description !!}@endif
					</div>
				</div>

				<div class="panel-wrapper collapse in" aria-expanded="true">
					<div class="panel-body">
						<div class="col-md-12 month">
							<h3><strong>SALARY SHEET/ FINAL BALANCE</strong></h3>
						</div>
						<div class="form-body">
							<div class="table-responsive">
								<table class="table table-bordered table-hover table-striped">
									<tbody>
									<tr>
										<td>Month :   </td>
										<td> <b>{{convartMonthAndYearToWord($salaryDetails->month_of_salary)}}</b></td>
									</tr>
									<tr>
										<td>Pay Grade :   </td>
										<td> <b>@if(isset($salaryDetails->employee->hourlySalaries->hourly_grade))
													{{$salaryDetails->employee->hourlySalaries->hourly_grade}} (Hourly)
												@endif</b></td>
									</tr>
									<tr>
										<td>Name:</td>
										<td>
											<b>

													@if(isset($salaryDetails->employee->first_name))
														{{$salaryDetails->employee->first_name}} {{$salaryDetails->employee->last_name}}
													@endif
											</b>
										</td>
									</tr>
									<tr>
										<td>Department :</td>
										<td><b>@if(isset($salaryDetails->employee->department->department_name))
													{{$salaryDetails->employee->department->department_name}}
												@endif</b></td>
									</tr>
									<tr>
										<td>Designation :</td>
										<td><b>@if(isset($salaryDetails->employee->designation->designation_name))
													{{$salaryDetails->employee->designation->designation_name}}
												@endif</b></td>
									</tr>
									<tr>
										<td>Joining Date : </td>
										<td><b>@if(isset($salaryDetails->employee->date_of_joining))
													{{date(" d-M-Y", strtotime($salaryDetails->employee->date_of_joining))}}
												@endif
											</b></td>
									</tr>

									<tr>
										<td>Working Hour</td>
										<td class="text-center">
											{{$salaryDetails->working_hour}}
										</td>
									</tr>
									<tr>
										<td>Hourly Rate</td>
										<td class="text-center">
											{{number_format($salaryDetails->hourly_rate)}}
											<input type="hidden" readonly  class="form-control" value="{{$salaryDetails->hourly_rate}}" name="hourly_rate">
										</td>
									</tr>
									<tr>
										<td >Total Salary</td>
										<td class="text-center">
											{{number_format($salaryDetails->gross_salary)}}
										</td>
									</tr>

									<tr>
										<td colspan="1" ><b>Gross Salary</b></td>
										<td class="text-center">
											<b>{{number_format($salaryDetails->gross_salary)}}</b>
										</td>
									</tr>

									</tbody>
								</table>

								<div class="col-sm-12 col-xs-12 col-md-4" style="text-align: center">
									<strong>Administrator signature ..</strong>
								</div>
								<div class="col-sm-12 col-xs-12 col-md-4" style="text-align: center">
									<strong>Date ..</strong>

								</div>
								<div class="col-sm-12 col-xs-12 col-md-4" style="text-align: center">
									<strong>Employee signature ..</strong>
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


